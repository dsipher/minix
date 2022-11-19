/*****************************************************************************

   fs.c                                                       ux/64 kernel

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from UNIX (Seventh Edition), which is in the public domain.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#include <sys/fs.h>
#include <sys/buf.h>
#include <sys/log.h>
#include <sys/io.h>
#include <sys/spin.h>
#include <sys/user.h>
#include <sys/proc.h>
#include <sys/inode.h>
#include <sys/systm.h>
#include <sys/mutex.h>
#include <sys/io.h>
#include <sys/dev.h>
#include <sys/stat.h>
#include <errno.h>

/* scan a filesystem bitmap on `dev' which starts at `map' and spans
   `size' bits for a free bit (==1). the bit is reset and its index
   is returned. `hint' indicates where to start the scan: if non-zero,
   the scan will wrap if/when it reaches the end of the map. returns
   0 if there are no free bits (ENOSPC) or some other error occurs. */

static unsigned
alloc(dev_t dev, daddr_t map, unsigned size, unsigned hint)
{
    /* we use the hint to compute our starting position, `blkno'
       is the block in the map, `index' the word in that block. */

    daddr_t         blkno   = hint / FS_BITS_PER_BLOCK;
    unsigned        index   = (hint % FS_BITS_PER_BLOCK) / BITS_PER_QWORD;
    daddr_t         blocks  = WHOLE(size, FS_BITS_PER_BLOCK);
    daddr_t         count;
    struct buf      *bp;
    unsigned long   word;
    unsigned        bit;

    /* we iterate over at most blocks+1 blocks. the +1
       covers the case where `hint' is non-zero, since
       we may have to examine the starting block twice
       (the first pass might only examine part of it) */

    count = 0;

    while (count <= blocks)
    {
        /* if we've reached the end of the map, wrap around. `blkno' may be
           be beyond `blocks' if `hint' is bogus, hence the >= vs just == */

        if (blkno >= blocks) blkno = 0;

        /* read in the block and scan for the
           first set bit, one word at a time */

        bp = bread(dev, map + blkno);
        if (bp == 0) return 0;

        for (; index < FS_QWORDS_PER_BLOCK; ++index)
        {
            word = bp->b_qwords[index];
            if (word == 0) continue;

            /* welp, we have at least one free bit. BSFQ() will give us
               the least significant one in the word. convert to offset
               from the beginning of the map, AFTER resetting the bit */

            bit = BSFQ(word);
            word &= ~(1UL << bit);
            bit += index * BITS_PER_QWORD;
            bit += blkno * FS_BITS_PER_BLOCK;

            /* false positive: we saw a `free' bit beyond the end of the
               bitmap (i.e., in the trailing junk bits in the block after
               the end of the bitmap). break out -> wrap to first block */

            if (bit >= size) break;

            /* success. update the bitmap. */

            bp->b_qwords[index] = word;
            bwrite(bp, B_ASYNC);

            return bit;
        }

        brelse(bp, 0);
        index = 0;
        ++blkno;
        ++count;
    }

    /* no free bits */

    u.u_errno = ENOSPC;
    return 0;
}

/* free `bit' in the map starting at `map' on `dev'.
   this is obviously faster and simpler than alloc() */

static void
free(dev_t dev, daddr_t map, unsigned bit)
{
    daddr_t         blkno   = bit / FS_BITS_PER_BLOCK;
    unsigned        index   = (bit % FS_BITS_PER_BLOCK) / BITS_PER_QWORD;
    struct buf      *bp;

    bit %= BITS_PER_QWORD;
    bp = bread(dev, map + blkno);
    if (bp == 0) return;

    bp->b_qwords[index] |= (1UL << bit);
    bwrite(bp, B_ASYNC);
}

/* in balloc() and bfree() we update mnt->m_balloc with no
   locking protocol. the hint is just a hint, and if it's
   out of date (or even invalid, which won't happen because
   the updates happen to be atomic) no real harm is done. */

struct buf *
balloc(struct mount *mnt)
{
    struct buf *bp = 0;
    daddr_t blkno;

    down(&mnt->m_balloc);

    blkno = alloc(mnt->m_dev, FS_BMAP_START(mnt->m_filsys),
                  mnt->m_filsys.s_blocks, mnt->m_bhint);

    up(&mnt->m_balloc);

    if (blkno) {
        mnt->m_bhint = blkno;
        bp = getblk(mnt->m_dev, blkno);
        STOSQ(bp->b_data, 0, FS_QWORDS_PER_BLOCK);
    }

    bdevsw[MAJOR(mnt->m_dev)].d_alloc(mnt->m_dev, blkno);

    return bp;
}

void
bfree(struct mount *mnt, daddr_t blkno)
{
    bdevsw[MAJOR(mnt->m_dev)].d_free(mnt->m_dev, blkno);
    free(mnt->m_dev, FS_BMAP_START(mnt->m_filsys), blkno);
    mnt->m_bhint = blkno;
}

/* ialloc() and ifree() are almost exact analogs of balloc()
   and bfree(), except there are no driver hooks for inodes. */

struct inode *
ialloc(struct mount *mnt)
{
    struct inode *ip = 0;
    ino_t ino;

    down(&mnt->m_ialloc);

    ino = alloc(mnt->m_dev, FS_IMAP_START(mnt->m_filsys),
                mnt->m_filsys.s_inodes, mnt->m_ihint);

    up(&mnt->m_ialloc);

    if (ino) {
        mnt->m_ihint = ino;
        ip = iget(mnt->m_dev, ino);
        STOSQ(&ip->i_dinode, 0, FS_INODE_QWORDS);
    }

    return ip;
}

void
ifree(struct mount *mnt, ino_t ino)
{
    free(mnt->m_dev, FS_IMAP_START(mnt->m_filsys), ino);
    mnt->m_ihint = ino;
}

/* scan directory `dp' (locked by caller) for the next component of `path'.

   if the entry is FOUND in `dp', then the return value is non-null. in this
   case u.u_scanbp holds the buf which contains the desired directory entry,
   which is returned to the caller. `*path' is updated to point just past the
   component just processed. u.u_vacancy is invalid. the caller must dispose
   of u.u_scanbp properly when ready.

   if the entry is NOT FOUND in `dp', then the return value is null. u.u_errno
   is zero, u.u_scanbp is invalid, and u.u_vacancy indicates the offset of the
   first unoccupied entry in the directory (which may be dp->i_size if no free
   entries were spotted). `*path' is NOT advanced past the component.

   if an error occurred, null is returned. only u.u_errno is valid.

   the caller must ensure `dp' is a directory and the user has credentials. */

static struct direct *
scan(struct inode *dp, char **path)
{
    struct direct   name;           /* the component we're looking for */
    struct direct   *entry;         /* actual entry under consideration */
    char            *next = *path;  /* beginning of next path component */
    off_t           vacancy = -1;   /* offset of first vacant slot */
    off_t           offset = 0;     /* current position in `dp' */
    struct buf      *bp = 0;        /* block containing offset */

    FS_FILL_DNAME(name, next);
    dp->i_flags |= I_ATIME;

    for (; offset < dp->i_dinode.di_size; offset += sizeof(struct direct))
    {
        if (FS_BLOCK_OFS(offset) == 0)          /* next directory block */
        {
            if (bp) brelse(bp, 0);
            bp = bmap(dp, offset, 0);
            if (bp == 0) break;
        }

        entry = FS_DIRECT(bp, offset);

        if (entry->d_ino == 0)                  /* vacant slot */
        {
            if (vacancy == -1)
                vacancy = offset;

            continue;
        }

        if (FS_CMP_DNAME(*entry, name))         /* success */
        {
            u.u_scanbp = bp;
            *path = next;
            return entry;
        }
    }

    /* we either ran off the end or we encountered an error. in the latter
       case, u.u_vacancy will be invalid, but the caller should know that. */

    if (bp) brelse(bp, 0);

    u.u_vacancy = (vacancy == -1) ? dp->i_dinode.di_size
                                  : vacancy;

    return 0;
}

/* create new directory entry in `dp' for `name' which references `ip'.
   the caller must own `dp' and `ip'. if successful, ip->di_nlink will
   be incremented; otherwise u.u_errno will be set.

   creat() depends heavily on scan(). before calling creat():

            1. scan() for `name' must have been called on `dp',
            2. that scan must have yielded a NOT FOUND result,
            3. that call must have been the last call to scan()
               in this process context,
            4. the ownership of `dp' can not have been yielded
               between the call to scan() and the call to creat(),
            5. no other changes to `dp' can have been made that
               would invalidate the scan() results.

   in other words, one calls scan() then creat() almost immediately
   after. in practice this fits naturally into the filesystem logic.
   it is designed this way to avoid duplicating work. */

static void
creat(struct inode *dp, char *name, struct inode *ip)
{
    struct direct   *entry;     /* empty entry in directory */
    struct buf      *bp;        /* buf containing entry */
    off_t           offset;     /* offset of `entry' in `dp' */

    offset = u.u_vacancy;
    bp = bmap(dp, offset, 1);
    if (bp == 0) return;
    entry = FS_DIRECT(bp, offset);
    FS_FILL_DNAME(*entry, name);

    /* trailing slashes are fine on the last component
       of a path only if it is a directory. per posix */

    if ((*name == '/') && !S_ISDIR(ip->i_dinode.di_mode))
    {
        u.u_errno = ENOTDIR;
        return;
    }

    /* if the vacancy was at the end of the
       directory, then we just extended it */

    if (offset == dp->i_dinode.di_size)
    {
        dp->i_dinode.di_size += sizeof(struct direct);
        dp->i_flags |= I_CTIME;
    }

    entry->d_ino = ip->i_ino;
    ++(ip->i_dinode.di_nlink);
    ip->i_flags |= I_CTIME;
    dp->i_flags |= I_MTIME;
    bwrite(bp, B_ASYNC);
}

/* vi: set ts=4 expandtab: */
