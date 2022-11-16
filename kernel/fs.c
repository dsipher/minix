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

/* ialloc() and ifree() are almost exact analogs of
   balloc() and bfree(), except there are no driver
   hooks for inodes and inodes need a `ref' arg. */

struct inode *
ialloc(struct mount *mnt, int ref)
{
    struct inode *ip = 0;
    ino_t ino;

    down(&mnt->m_ialloc);

    ino = alloc(mnt->m_dev, FS_IMAP_START(mnt->m_filsys),
                mnt->m_filsys.s_inodes, mnt->m_ihint);

    up(&mnt->m_ialloc);

    if (ino) {
        mnt->m_ihint = ino;
        ip = iget(mnt->m_dev, ino, ref);
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

/* optimized comparison for struct direct names */

#define NAMECMP(a, b)   ({  long    *_a     = (long *)  ((a).d_name);   \
                            int     *_a2    = (int *)   ((a).d_name);   \
                            long    *_b     = (long *)  ((b).d_name);   \
                            int     *_b2    = (int *)   ((b).d_name);   \
                                                                        \
                            (       _a[0]   ==  _b[0]                   \
                                &&  _a[1]   ==  _b[1]                   \
                                &&  _a[2]   ==  _b[2]                   \
                                &&  _a2[6]  ==  _b2[6]  );              })

/* ... and an optimized copy */

#define NAMECPY(a, b)   do {                                            \
                            long    *_a     = (long *)  ((a).d_name);   \
                            int     *_a2    = (int *)   ((a).d_name);   \
                            long    *_b     = (long *)  ((b).d_name);   \
                            int     *_b2    = (int *)   ((b).d_name);   \
                                                                        \
                            _a[0]   =  _b[0];                           \
                            _a[1]   =  _b[1];                           \
                            _a[2]   =  _b[2];                           \
                            _a2[6]  =  _b2[6];                          \
                        } while (0)

/* ... and an optimized zero */

#define NAMEZERO(a)     do {                                            \
                            long    *_a     = (long *)  ((a).d_name);   \
                            int     *_a2    = (int *)   ((a).d_name);   \
                                                                        \
                            _a[0] = _a[1] = _a[2] = _a2[6] = 0;         \
                        } while (0)

int
scandir(struct inode *dp, char **path, int creat)
{
    /* for NAMECMP() to be most efficient, the struct directs must be
       quadword aligned. future versions of the compiler will likely
       quadword align non-scalar locals by default, so we can skip
       the trickery. (very near future versions of cc1 will also do
       better zeroing of locals, and NAMEZERO() will go away, too.) */

    union
    {
        struct direct name;
        long x; /* align */
    } d;

    off_t offset;               /* into the directory file */
    off_t empty;                /* offset of last empty entry */
    struct buf *bp;             /* current directory block */
    struct direct *direct;      /* working entry */

    /* pull the next component from `path' into d.name.d_name.
       ignore characters beyond NAME_MAX; zero pad if short.
       if it's empty, nice try luser. gobble up trailing /s. */

    {
        char *cp;
        int idx;

        cp = *path;

        if (*cp == 0) {
            u.u_errno = ENOENT;
            return 0;
        }

        NAMEZERO(d.name);

        for (idx = 0; *cp && *cp != '/'; ++idx, ++cp)
            if (idx < NAME_MAX)
                d.name.d_name[idx] = *cp;

        while (*cp == '/') ++cp;

        *path = cp;
    }

    /* loop through the directory looking for the component
       name. record any empty slots we come across in case
       we need to create the entry later. */

    dp->i_flags |= I_ATIME;         /* we're reading it, right? */

    offset = 0;                     /* start ... at the beginning */
    empty = -1;                     /* haven't seen a vacancy yet */
    bp = 0;

    for (offset = 0;
         offset < dp->i_dinode.di_size;
         offset += sizeof(struct direct))
    {
        if (FS_BLOCK_OFS(offset) == 0)      /* at block boundaries */
        {                                   /* read in next block */
            if (bp) brelse(bp, 0);
            bp = bmap(dp, offset, 0);
            if (bp == 0) return 0;
        }

        direct = FS_DIRECT(bp, offset);

        if (direct->d_ino == 0)     /* if the slot is vacant, record */
        {                           /* its location for later reference */
            if (empty == -1)
                empty = offset;

            continue;
        }

        if (NAMECMP(*direct, d.name))
        {
            u.u_scanbp = bp;
            u.u_scanofs = offset;

            return 1;   /* jackpot */
        }
    }

    /* fall through: no match. if creat, then either use a previously
       discovered vacant slot or extend the directory as needed to make
       a new entry, then copy the name into it. leave d->d_ino zeroed;
       the caller will know it's a new entry and it must be filled in */

    if (bp) brelse(bp, 0);

    if (creat)
    {
        /* if we didn't encounter an empty slot,
           extend the directory to make one. */

        if (empty == -1) {
            empty = offset;
            dp->i_dinode.di_size += sizeof(struct direct);
            dp->i_flags |= I_CTIME;
        }

        bp = bmap(dp, empty, 1);
        if (bp == 0) return 0;

        u.u_scanbp = bp;
        u.u_scanofs = empty;
        direct = FS_DIRECT(bp, empty);
        NAMECPY(*direct, d.name);

        dp->i_flags |= I_MTIME;
        bp->b_flags |= B_DIRTY;

        return 1;
    } else {
        u.u_errno = ENOENT;
        return 0;
    }
}

/* vi: set ts=4 expandtab: */
