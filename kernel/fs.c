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
#include <unistd.h>
#include <fcntl.h>
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
        bp->b_flags |= B_DIRTY;
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
        ip->i_flags |= I_ATIME | I_CTIME | I_MTIME;
    }

    return ip;
}

void
ifree(struct mount *mnt, ino_t ino)
{
    free(mnt->m_dev, FS_IMAP_START(mnt->m_filsys), ino);
    mnt->m_ihint = ino;
}

/* scan directory `dp' (locked by caller) for the next component of
   `*path', which is advanced to the point beyond that next component.

   if the entry is FOUND in `dp', then the return value is non-null. in this
   case u.u_scanbp holds the buf which contains the desired directory entry,
   which is returned to the caller. u.u_vacancy is invalid. the caller must
   dispose of u.u_scanbp properly when ready.

   if the entry is NOT FOUND in `dp', then the return value is null. u.u_errno
   is zero, u.u_scanbp is invalid, and u.u_vacancy indicates the offset of the
   first unoccupied entry in the directory (which may be dp->i_size if no free
   entries were spotted).

   if an error occurs, null is returned. only u.u_errno is valid.
   caller must ensure `dp' is a directory and the user has credentials. */

static struct direct *
scan(struct inode *dp, char **path)
{
    struct direct   name;           /* the component we're looking for */
    struct direct   *entry;         /* actual entry under consideration */
    off_t           vacancy = -1;   /* offset of first vacant slot */
    off_t           offset = 0;     /* current position in `dp' */
    struct buf      *bp = 0;        /* block containing offset */

    FS_FILL_DNAME(name, *path);
    dp->i_flags |= I_ATIME;

    for (; offset < dp->i_dinode.di_size; offset += sizeof(struct direct))
    {
        if (FS_BLOCK_OFS(offset) == 0)          /* next directory block */
        {
            if (bp) brelse(bp, 0);
            bp = bmap(dp, offset);
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
   they are tightly coupled this way to avoid duplicating work. */

static void
creat(struct inode *dp, char *name, struct inode *ip)
{
    struct direct   *entry;     /* empty entry in directory */
    struct buf      *bp;        /* buf containing entry */
    off_t           offset;     /* offset of `entry' in `dp' */

    offset = u.u_vacancy;
    bp = bmap(dp, offset);
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
        dp->i_dinode.di_size += sizeof(struct direct);

    entry->d_ino = ip->i_ino;
    ++(ip->i_dinode.di_nlink);
    ip->i_flags |= I_CTIME;
    dp->i_flags |= I_CTIME | I_MTIME;
    bwrite(bp, B_ASYNC);
}

/* look up `path' in the filesystem and return its inode. if an
   error occurs, null is returned and u_errno is set. otherwise:

        if the path does not exist, null is returned.
        if the path does exist, its inode is returned.

        in either case, u.u_nameidp MAY be non-zero; it
        holds the inode of the directory in which the
        sought path was (or should have been) found.

        the returned inode, if not null, is locked. likewise,
        u.u_nameidp, if not null, is locked. it is the caller's
        responsibility to dispose of these inodes as appropriate.

        if u.u_nameidp is not null, it is guaranteed that creat()
        may be called on it. it was the most recently scan()ed.

   `*path' is moved forward as namei() progresses. in particular, if
   the final component does not exist, `*path' names this component.

   this code is gnarly. this is an unfortunate consequence of subtle corner
   cases which seem to be inherent in the design of the unix filesystem. */

#define NAMEI_IPUT(ip)  do { if (ip) { iput((ip), 0); (ip) = 0; } } while (0)

static struct inode *
namei(char **path)
{
    struct inode    *dp;            /* most recently-matched component */
    struct inode    *pdp;           /* directory in which `dp' was found */
    struct direct   *entry;         /* entry found by scan() */
    struct mount    *mnt;           /* for alternative locking w/ `..' */
    char            *this;          /* component we're trying to match */

    this = *path;

    switch (*this)
    {
    case 0:     u.u_errno = ENOENT;     return 0;
    case '/':   dp = idup(rootdir);     break;
    default:    dp = idup(u.u_cdir);    break;
    }

    pdp = 0;

next:

    /* a / here is either a component separator
       or a trailing slash on the last component.
       either way, `dp' must be a directory, in
       the latter case because posix says so */

    if (*this == '/') {
        if (!S_ISDIR(dp->i_dinode.di_mode)) {
            u.u_errno = ENOTDIR;
            goto error;
        }

        while (*this == '/') ++this;
    }

    /* keep the caller informed
       of how far we got. */

    *path = this;

    /* end of the path. Qapla' */

    if (*this == 0) {
        u.u_nameidp = pdp;
        return dp;
    }

search:

    access(dp, X_OK, 0);
    if (u.u_errno) goto error;
    entry = scan(dp, &this);
    if (u.u_errno) goto error;

    /* if we get no match, fast-forward `this' to see if it's the last
       component. if so, tell the caller where we should have found the
       component and let it decide what to do. otherwise, it's an error. */

    if (entry == 0)
    {
        while (*this == '/')
            ++this;

        if (*this == 0) {
            NAMEI_IPUT(pdp);
            u.u_nameidp = dp;
            return 0;
        } else {
            u.u_errno = ENOENT;
            goto error;
        }
    }

    /* no longer needed. `dp' will either be promoted to the
      parent position (normal descent only), or discarded. */

    NAMEI_IPUT(pdp);

    /* a self-referential `..' entry is only found at the root of
       a filesystem. if it's not THE root of the filesystem, then
       we must ascend through a mount point. `..' here then means
       the parent of the covered inode, so we switch out `dp' and
       repeat the search for `..'. */

    if (    dp != rootdir                   /* not at THE root */
         && dp->i_ino == entry->d_ino       /* self-referential */
         && FS_DNAME_DOTDOT(*entry) )       /* `..' */
    {
        mnt = getfs(dp->i_dev);
        brelse(u.u_scanbp, 0);
        iput(dp, 0);
        dp = idup(mnt->m_inode);
        putfs(mnt);

        this -= 2;
        goto search;
    }

    /* a self-referential entry is usually `.', but this could also be
       `..' at the root of THE filesystem. either way, it's a no-op. */

    if (dp->i_ino == entry->d_ino) { brelse(u.u_scanbp, 0); goto next; }

    /* a non-self-referential `..' requires special handling. we can't
       hold the `parent' (which is really the child) locked because we
       run the risk of deadlock (it violates the normal locking order).

       so we grab the mount `dp' is on to keep its filesystem from being
       unmounted from under us, and then release `dp'. we still hold the
       buf containing `entry' so, crucially, the iget() is still atomic */

    if (FS_DNAME_DOTDOT(*entry))
    {
        mnt = getfs(dp->i_dev);
        iput(dp, 0);
        dp = iget(mnt->m_dev, entry->d_ino);
        brelse(u.u_scanbp, 0);
        putfs(mnt);

        if (u.u_errno)  goto error;
                else    goto next;
    }

    /* the usual case: a normal descent to an entry. we promote `dp'
       to parent directory [still locked] and acquire the child. */

    pdp = dp;
    dp = iget(pdp->i_dev, entry->d_ino);
    brelse(u.u_scanbp, 0);

    if (u.u_errno == 0)     goto next;
                else        /* fallthru */ ;

error:
    NAMEI_IPUT(dp);
    NAMEI_IPUT(pdp);
    return 0;
}

struct inode *
open(char *path, int oflags, mode_t mode)
{
    struct mount    *mnt = 0;      /* for inode allocation */
    struct inode    *ip = 0;       /* the inode of interest */
    struct inode    *dp = 0;       /* parent directory */
    int             amode;         /* R_OK, W_OK for access() */

    /* make note of whether we're reading, writing or both.

       ordinarily we don't bother to check for invalid arguments,
       leaving it to the system call handlers to do that, but since
       we must to inspect this argument anyway, we validate it too. */

    switch (oflags & O_ACCMODE)
    {
    case O_RDWR:        amode = W_OK | R_OK;    break;
    case O_WRONLY:      amode = W_OK;           break;

    case O_RDONLY:      amode = R_OK;

                        if ((oflags & O_TRUNC) == 0)
                            break;
                        else
                            /* fallthru to error. posix leaves this up
                               to us, but we say O_TRUNC plus O_RDONLY
                               is an invalid combination. */ ;

    default:            u.u_errno = EINVAL;
                        return 0;
    }

    /* find the file */

    ip = namei(&path);
    dp = u.u_nameidp;
    if (u.u_errno) return 0;

    if (ip) {
        /* the file exists. we fail if:

            (a) O_EXCL is specified (since this is what O_EXCL is for)
            (b) the file is a directory and write access is requested;
            (c) the user lacks permissions required for access requested. */

        if (O_EXCL) { u.u_errno = EEXIST; goto error; }

        if (S_ISDIR(ip->i_dinode.di_mode) && (amode & W_OK))
        {
            u.u_errno = EISDIR;
            goto error;
        }

        access(ip, amode, 0);
        if (u.u_errno) goto error;

        /* itrunc() only works on regular files and directories. it ignores
           other file types. users can't truncate directories, but the logic
           above ensures that (O_TRUNC && S_ISDIR(ip)) is impossible here. */

        if (oflags & O_TRUNC)
        {
            itrunc(ip);
            if (u.u_errno) goto error;
        }
    } else {
        /* file does NOT exist. we'll create the file unless:

            (a) the user didn't specify O_CREAT (that's what O_CREAT is for);
            (b) the user lacks write permissions in the parent directory. */

        if ((oflags & O_CREAT) == 0) { u.u_errno = ENOENT; goto error; }

        access(dp, W_OK, 0);
        if (u.u_errno) goto error;

        mnt = getfs(dp->i_dev);
        ip = ialloc(mnt);
        if (ip == 0) goto error;

        ip->i_dinode.di_uid = CURPROC->p_uid;
        ip->i_dinode.di_gid = CURPROC->p_gid;
        ip->i_dinode.di_mode = S_IFREG | (mode & ~(u.u_mask));
        ip->i_flags |= I_ATIME | I_MTIME;

        creat(dp, path, ip);
        if (u.u_errno) goto error;
    }

out:

    if (ip && (amode & W_OK))
        ++(ip->i_wrefs);

    if (mnt) putfs(mnt);
    if (dp) iput(dp, 0);
    return ip;

error:
    if (ip)
    {
        iput(ip, 0);
        ip = 0;
    }

    goto out;
}

/* vi: set ts=4 expandtab: */
