/*****************************************************************************

   inode.c                                                    ux/64 kernel

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

#include <sys/inode.h>
#include <sys/dev.h>
#include <sys/spin.h>
#include <sys/clock.h>
#include <sys/log.h>
#include <sys/user.h>
#include <sys/buf.h>
#include <sys/io.h>
#include <sys/proc.h>
#include <sys/stat.h>
#include <errno.h>
#include <unistd.h>
#include "config.h"

/* allocated and zeroed at boot by pginit() in page.c */

struct inode *inode;            /* inode[NINODE] */
struct inodeq *inodeq;          /* inodeq[NINODEQ] */

/* inodes with no active references (i_refs == 0) go
   here, and can be assigned to a different dev/ino */

static struct inodeq iavailq = TAILQ_HEAD_INITIALIZER(iavailq);

/* mounted filesystems. */

static struct mount mounts[NMOUNT];

/* protects inode queues, selected fields
   of struct inode and mounts[] entries */

static spinlock_t inode_lock;

/* map an inode number to its bucket. most
   efficient if NINODEQ is a power of 2 */

#define INOHASH(ino)    ((ino) % NINODEQ)

/* the caller must ensure that `ip' (if provided) is a directory,
   and that the process has permission to mount (i.e., is root). */

void
mount(dev_t dev, struct inode *ip)
{
    struct mount *mnt;
    struct mount *new;
    struct buf *super;
    struct filsys *filsys;
    int i;

    /* bread() will have a Bad Time(tm) if the
       device major runs off the end of bdevsw[] */

    if (MAJOR(dev) >= NBLKDEV) {
        u.u_errno = ENXIO;
        return;
    }

    /* read the super block and make sure it smells right */

    super = bread(dev, FS_SUPER_BLOCK);
    if (u.u_errno) return;

    filsys = (struct filsys *) (super->b_data + FS_SUPER_OFFSET);

    if (    filsys->s_magic      != FS_SUPER_MAGIC
        ||  filsys->s_magic2     != FS_SUPER_MAGIC2
        ||  filsys->s_boot_magic != FS_BOOT_MAGIC )
    {
        brelse(super, 0);
        u.u_errno = EINVAL;
        return;
    }

    /* looks like a valid filesystem; find a vacant entry in mounts[]. while
       we're at it, make sure we're not colliding with an existing entry. */

    new = 0;
    acquire(&inode_lock);

    for (mnt = mounts, i = 0; i < NMOUNT; ++i, ++mnt)
        if (mnt->m_dev == NODEV) {
            if (new == 0)
                new = mnt;
        } else {
            if (mnt->m_dev == dev || mnt->m_inode == ip)
            {
busy:
                release(&inode_lock);
                brelse(super, 0);
                u.u_errno = EBUSY;
                return;
            }
        }

    if (new == 0) goto busy;    /* no empty slots */

    /* looks good. update the superblock to reflect the
       mount action and populate the mounts[] entry. */

    filsys->s_mtime = time;

    new->m_dev = dev;
    new->m_inode = ip;
    new->m_bhint = 0;
    new->m_ihint = 0;
    new->m_refs = 1;
    MOVSQ(&new->m_filsys, filsys, FS_FILSYS_QWORDS);

    if (ip) {
        ++(ip->i_refs);             /* we keep a reference */
        ip->i_flags |= I_MOUNT;     /* because it's mounted on */
    }

    release(&inode_lock);
    bwrite(super, B_ASYNC);
}

struct mount *
getfs(dev_t dev)
{
    struct mount *mnt;
    int i;

    acquire(&inode_lock);

    for (mnt = mounts, i = 0; i < NMOUNT; ++i, ++mnt)
        if (mnt->m_dev == dev) {
            ++(mnt->m_refs);
            goto out;
        }

    mnt = 0; /* no match */

out:
    release(&inode_lock);
    return mnt;
}

void
putfs(struct mount *mnt)
{
    acquire(&inode_lock);
    --(mnt->m_refs);
    release(&inode_lock);
}

/* read/write ip->i_dinode from/to the underlying device. the
   caller must own the inode. `w' controls the direction of i/o. */

static void
rwinode(struct inode *ip, int w)
{
    struct mount *mnt;          /* filesystem containing inode */
    daddr_t blkno;              /* ... which block it's in */
    int offset;                 /* ... offset in that block */
    struct buf *buf;            /* our handle to that block */

    mnt = getfs(ip->i_dev);

    blkno = FS_ITOD(mnt->m_filsys, ip->i_ino);
    offset = FS_ITOO(mnt->m_filsys, ip->i_ino);
    buf = bread(ip->i_dev, blkno);

    if (buf)
        if (w) {
            MOVSQ(buf->b_data + offset, &ip->i_dinode, FS_INODE_QWORDS);
            bwrite(buf, B_ASYNC);
            ip->i_flags &= ~I_DIRTY;
        } else {
            MOVSQ(&ip->i_dinode, buf->b_data + offset, FS_INODE_QWORDS);
            brelse(buf, 0);
            ip->i_flags |= I_VALID;
        }

    putfs(mnt);
}

/* free the text pages associated with the inode, if any.
   resets I_TEXT and I_SPLIT flags. caller must own `ip'. */

static void
xfree0(xte_t *table)
{
    int i;

    for (i = 0; i < XTES_PER_PAGE; ++i)
        if (table[i])
            pgfree((caddr_t) table[i]);
}

static void
xfree(struct inode *ip)
{
    int i;

    if (ip->i_flags & I_TEXT) {
        if (ip->i_flags & I_SPLIT)
            for (i = 0; i < XTES_PER_PAGE; ++i)
                if (ip->i_text[i])
                    xfree0((xte_t *) (ip->i_text[i]));

        xfree0(ip->i_text);
        pgfree((caddr_t) ip->i_text);
    }

    ip->i_flags &= ~(I_TEXT | I_SPLIT);
}

/* `primitive' forms of ilock() and irelse(). */

#define ILOCK(ip)                       /* held: inode_lock */              \
    do {                                                                    \
        while ((ip)->i_busy) {                                              \
            (ip)->i_wanted = 1;                                             \
            sleep((ip), P_STATE_COMA, &inode_lock);                         \
        }                                                                   \
                                                                            \
        (ip)->i_busy = 1;                                                   \
    } while (0)

#define IRELSE(ip)                      /* held: inode_lock */              \
    do {                                                                    \
        if ((ip)->i_wanted)                                                 \
            wakeup(ip);                                                     \
                                                                            \
        (ip)->i_wanted = 0;                                                 \
        (ip)->i_busy = 0;                                                   \
    } while (0)

/* wrapped versions of ILOCK() and IRELSE().
   these are primarily for external use. */

void
ilock(struct inode *ip)
{
    acquire(&inode_lock);
    ILOCK(ip);
    release(&inode_lock);
}

void
irelse(struct inode *ip)
{
    acquire(&inode_lock);
    IRELSE(ip);
    release(&inode_lock);
}

struct inode *
idup(struct inode *ip)
{
    acquire(&inode_lock);
    ILOCK(ip);
    ++ip->i_refs;
    release(&inode_lock);

    return ip;
}

void
iref(struct inode *ip, int ref)
{
    switch (ref)
    {
    case INODE_REF_X:   if (ip->i_wrefs)
                            u.u_errno = ETXTBSY;
                        else
                            ++(ip->i_xrefs);

                        break;

    case INODE_REF_W:   if (ip->i_xrefs)
                            u.u_errno = ETXTBSY;
                        else {
                            ++(ip->i_wrefs);
                            xfree(ip);
                        }
    }
}

struct inode *
iget(dev_t dev, ino_t ino)
{
    struct inode *ip;
    struct mount *mnt;
    int b, ob; /* buckets */

    acquire(&inode_lock);

retry:

    /* 1. first try to find the inode in the cache */

    b = INOHASH(ino);

    for (ip = TAILQ_FIRST(&inodeq[b]); ip; ip = TAILQ_NEXT(ip, i_hash_links))
    {
        if (ip->i_ino == ino && ip->i_dev == dev)
        {
            /* great, it's already here. if it's mounted on what we
               REALLY want is the root inode of the mounted device.
               (it's safe to check I_MOUNT here though we don't own
               the node yet; mounts and unmounts sync on inode_lock.) */

            if (ip->i_flags & I_MOUNT) {
                mnt = mounts;
                while (mnt->m_dev == NODEV || mnt->m_inode != ip) ++mnt;
                dev = mnt->m_dev;   /* the mount entry MUST be */
                ino = FS_ROOT_INO;  /* present, or we're hosed */
                goto retry;
            }

            /* no need to cross a mount point. grab a ref.
               if this is the first reference to the node,
               then it's on the iavailq; not for long ... */

            if (++(ip->i_refs) == 1) /* was available */
                TAILQ_REMOVE(&iavailq, ip, i_avail_links);

            /* shuffle this inode to the head of its hash
               queue to keep the queue in MRU order */

            TAILQ_REMOVE(&inodeq[b], ip, i_hash_links);
            TAILQ_INSERT_HEAD(&inodeq[b], ip, i_hash_links);

            ILOCK(ip);
            release(&inode_lock);

            goto found;
        }
    }

    /* 2. fall through: the inode isn't in the cache, so we
          need to grab one from the iavailq and reassign it.
          this involves changing which hash bucket it's in. */

    ip = TAILQ_FIRST(&iavailq);

    if (ip == 0) {              /* unlike the buffer cache, we don't block */
        u.u_errno = ENFILE;     /* and wait for a free inode: bufs churn, */
        release(&inode_lock);   /* but we could wait indefinitely for an */
        return 0;               /* inode. no problem if NINODE is right! */
    }

    ob = INOHASH(ip->i_ino);
    TAILQ_REMOVE(&inodeq[ob], ip, i_hash_links);
    TAILQ_REMOVE(&iavailq, ip, i_avail_links);

    ip->i_dev = dev;
    ip->i_ino = ino;
    ip->i_flags &= (I_TEXT | I_SPLIT);      /* see xfree() just below */
    ip->i_refs = 1;  /* ref and */          /* (i_wanted/i_xrefs/i_wrefs */
    ip->i_busy = 1;  /* lock it */          /* must all already be zero) */

    TAILQ_INSERT_HEAD(&inodeq[b], ip, i_hash_links);
    release(&inode_lock);

    /* toss any stale cached text pages.
       zaps I_TEXT, I_SPLIT if kept above. */

    xfree(ip);

found:

    /* 3. we've got the inode, and are currently its owner.
          read it in from disk if necessary; this will only
          occur if we just got the inode off the iavailq or
          if previous attempts have resulted in errors. */

    if ((ip->i_flags & I_VALID) == 0) {
        rwinode(ip, 0);

        if ((ip->i_flags & I_VALID) == 0) {
            /* looks like rwinode() failed. it
               has already set u_errno for us */

            iput(ip, 0);
            return 0;
        }
    }

    return ip;
}

/* the algorithm for itrunc() is lifted with little change from v7.
   for this reason, the blocks of the file are removed in reverse
   order, which had benefits on the original filesystem. for ux/64,
   with bitmaps and typically SSD storage, order is unimportant. */

static void itrunc0(struct mount *mnt, daddr_t bn, int f1, int f2)
{
    struct buf *bp;
    daddr_t *bap;
    daddr_t nb;
    int i;

    for (i = (FS_BLOCKS_PER_BLOCK - 1); i >= 0; --i)
    {
        if (bp == 0) {
            bp = bread(mnt->m_dev, bn);
            if (bp == 0) return; /* uhoh */
            bap = bp->b_daddr;
        }

        nb = bap[i];
        if (nb == 0) continue;

        if (f1) {
            brelse(bp, 0);
            bp = 0;
            itrunc0(mnt, nb, f2, 0);
        } else
            bfree(mnt, nb);
    }

    if (bp) brelse(bp, 0);
    bfree(mnt, bn);
}

void
itrunc(struct inode *ip)
{
    struct mount *mnt;
    daddr_t bn;
    int i;

    /* truncating anything other than a directory
       or a regular file is a no-op (not an error) */

    if ( !S_ISDIR(ip->i_dinode.di_mode)
      && !S_ISREG(ip->i_dinode.di_mode)) return;

    mnt = getfs(ip->i_dev);

    for (i = (FS_INODE_BLOCKS - 1); i >= 0; --i)
    {
        bn = ip->i_dinode.di_addr[i];
        if (bn == 0) continue;

        switch (i)
        {
        default:                    bfree(mnt, bn);             break;
        case FS_INDIRECT_BLOCK:     itrunc0(mnt, bn, 0, 0);     break;
        case FS_DOUBLE_BLOCK:       itrunc0(mnt, bn, 1, 0);     break;
        case FS_TRIPLE_BLOCK:       itrunc0(mnt, bn, 1, 1);     break;
        }

        ip->i_dinode.di_addr[i] = 0;
    }

    ip->i_dinode.di_size = 0;
    ip->i_flags |= I_MTIME | I_CTIME;

    putfs(mnt);
}

void
iupdat(struct inode *ip)
{
    time_t t;

    if (ip->i_flags & I_DIRTY)
    {
        t = time;   /* it's not THAT volatile */

        if (ip->i_flags & I_ATIME) ip->i_dinode.di_atime = t;
        if (ip->i_flags & I_MTIME) ip->i_dinode.di_mtime = t;
        if (ip->i_flags & I_CTIME) ip->i_dinode.di_ctime = t;

        rwinode(ip, 1);     /* resets I_DIRTY for us */
    }
}

void
iput(struct inode *ip, int flags)
{
    struct mount *mnt;          /* used in step #5 ... */
    ino_t ino;                  /* ... if we free inode */
    int last_ref;               /* we hold the last ref */

    ip->i_flags |= flags;

    /* 1. first, determine if we hold the last reference to this inode,
          either in-memory or on-disk. it can be shown that, if this is
          true now, it will remain so even after inode_lock is released. */

    acquire(&inode_lock);
    last_ref = (ip->i_dinode.di_nlink == 0) && (ip->i_refs == 1);
    release(&inode_lock);

    /* 2. if we have the last reference, nuke any allocated storage */

    if (last_ref)
    {
        itrunc(ip);                 /* zap associated storage. */
        mnt = getfs(ip->i_dev);     /* stash important details ... */
        ino = ip->i_ino;            /* ... for freeing in step #5 */
        ip->i_flags & ~I_DIRTY;     /* don't bother updating it (next) */
    }

    /* 3. last chance to commit any changes to disk */

    iupdat(ip);

    /* 4. decrement main reference count, put back on
          the iavailq if no more in-memory references. */

    acquire(&inode_lock);

    if (--(ip->i_refs) == 0)
        TAILQ_INSERT_TAIL(&iavailq, ip, i_avail_links);

    IRELSE(ip);
    release(&inode_lock);

    /* 5. finally, if we had the last ref, free inode in its bitmap.
          (must be done last, or the assertion in #1 would be false.) */

    if (last_ref) {
        ifree(mnt, ino);
        putfs(mnt);
    }
}

#define BMAP0(SIZE)     do {                                        \
                            if (uoffset >= SIZE) {                  \
                                ++depth;                            \
                                uoffset -= SIZE;                    \
                            }                                       \
                        } while (0)

struct buf *bmap(struct inode *ip, off_t offset)
{
    /* the offset arithmetic here is much
       more efficient if it is is unsigned */

    unsigned long   uoffset = offset;

    struct mount    *mnt;
    daddr_t         *blknop;
    int             index;
    int             depth;
    struct buf      *bp, *nextbp;

    /* since uoffset is unsigned, this catches not only
       offsets that are too large, but negative ones */

    if (uoffset >= FS_MAX_FILE_SIZE)
    {
        u.u_errno = EFBIG;
        return 0;
    }

    /* treating each element of di_addr[] as the root of separate
       trees (of varying heights), decide which tree `uoffset' is
       in and modify it to be an offset into that tree. */

    mnt = getfs(ip->i_dev);
    depth = 0;

    if (uoffset < FS_DIRECT_BYTES)
        index = uoffset >> FS_BLOCK_SHIFT;
    else {
        BMAP0(FS_DIRECT_BYTES);
        BMAP0(FS_INDIRECT_BYTES);
        BMAP0(FS_DOUBLE_BYTES);
        index = FS_INDIRECT_BLOCK + (depth - 1);
    }

    /* now, descend the tree to the leaf we want,
       allocating blocks as necessary to get there. */

    blknop = &(ip->i_dinode.di_addr[index]);
    bp = 0;

    for (;;)
    {
        if (*blknop == 0) {
            nextbp = balloc(mnt);

            if (nextbp) {
                *blknop = nextbp->b_blkno;
                if (bp) bwrite(bp, B_ASYNC);
                ip->i_flags |= I_CTIME;
            }
        } else {
            nextbp = bread(ip->i_dev, *blknop);
            if (bp) brelse(bp, 0);
        }

        if ((bp = nextbp) == 0)
            /* error */
            goto out;

        switch (depth)
        {
        case 0:     goto out;

        case 1:     index = uoffset / FS_BLOCK_SIZE;
                    break;
        case 2:     index = uoffset / FS_INDIRECT_BYTES;
                    uoffset -= index * FS_INDIRECT_BYTES;
                    break;
        case 3:     index = uoffset / FS_DOUBLE_BYTES;
                    uoffset -= index * FS_DOUBLE_BYTES;
                    break;
        }

        blknop = &(bp->b_daddr[index]);
        --depth;
    }

out:
    putfs(mnt);
    return bp;
}

/* not coincidentally, the *_OK macros from unistd.h line up exactly
   with the mode bits in the least-significant 3 bits, and groups of
   mode bits can be easily shifted into that position. this alignment
   is of course inherited from v7, and is true on every half-witted
   posix system, though posix itself refused to define their values. */

void access(struct inode *ip, int amode, int real)
{
    uid_t uid = real ? CURPROC->p_uid : CURPROC->p_euid;
    gid_t gid = real ? CURPROC->p_gid : CURPROC->p_egid;
    mode_t m = ip->i_dinode.di_mode;

    /* we can't have a file open for writing and
       demand-paging at the same time, root or no */

    if (    ((amode & W_OK) && ip->i_xrefs)
         || ((amode & X_OK) && ip->i_wrefs) )
    {
        u.u_errno = ETXTBSY;
        return;
    }

    /* root can execute anything with any x bit set,
       and can read or write regardless of mode. */

    if (uid == 0)
    {
        if ((amode & X_OK) && ((m & (S_IXUSR | S_IXGRP | S_IXOTH)) == 0))
            u.u_errno = EACCES;

        return;
    }

    /* for other users, figure out which
       set of bits applies, and mask. */

    if (uid == ip->i_dinode.di_uid)
        amode <<= 6;    /* consult owner bits */
    else if (gid == ip->i_dinode.di_gid)
        amode <<= 3;    /* ....... group bits */
    else
        /* default to `other' bits */ ;

    if ((amode & m) != amode)
        u.u_errno = EACCES;
}

/* clear out mounts[] table. initialize inoq buckets, initialize all inodes
   to belong to an impossible device, scatter them across the buckets, and
   put them on iavailq (as usual for initialization, we forego any locking) */

void
inoinit(void)
{
    int i, b;

    for (i = 0; i < NMOUNT; ++i)
        mounts[i].m_dev = NODEV;

    for (i = 0; i < NINODEQ; ++i)
        TAILQ_INIT(&inodeq[i]);

    for (i = 0; i < NINODE; ++i)
    {
        inode[i].i_dev = NODEV;
        inode[i].i_ino = i;
        b = INOHASH(inode[i].i_ino);
        TAILQ_INSERT_TAIL(&inodeq[b], &inode[i], i_hash_links);
        TAILQ_INSERT_TAIL(&iavailq, &inode[i], i_avail_links);
    }
}

/* vi: set ts=4 expandtab: */
