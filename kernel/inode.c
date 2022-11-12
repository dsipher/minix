/*****************************************************************************

   ino.c                                                      ux/64 kernel

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
#include <errno.h>
#include "config.h"

/* allocated and zeroed at boot by pginit() in page.c */

struct inode *inode;            /* inode[NINODE] */
struct inodeq *inodeq;          /* inodeq[NINODEQ] */

/* inodes with no active references (i_refs == 0) go
   here, and can be assigned to a different dev/ino */

static struct inodeq iavailq = TAILQ_HEAD_INITIALIZER(iavailq);

/* mounted filesystems. as mentioned below, this is protected by
   inode_lock when adding and removing entries. because existing
   entries are guaranteed to remain undisturbed as long as any
   inode on the filesystem is referenced (i.e., the filesystem
   busy) it's safe to hand out pointers into mounts[] via getfs() */

static struct mount mounts[NMOUNT];

/* protects inode queues, the shared fields
   of struct inode and changes to mounts[] */

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
    MOVSQ(&new->m_filsys, filsys, FS_FILSYS_QWORDS);

    if (ip) {
        ++(ip->i_refs);             /* we keep a reference */
        ip->i_flags |= I_MOUNT;     /* because it's mounted on */
    }

    release(&inode_lock);
    bwrite(super, B_ASYNC);
}

/* we assume the entry exists, since no one should ever be
   holding an inode that is not on a mounted filesystem. */

struct mount *
getfs(struct inode *ip)
{
    struct mount *mnt;
    int i;

    acquire(&inode_lock);

    for (mnt = mounts, i = 0; i < NMOUNT; ++i, ++mnt)
        if (mnt->m_dev == ip->i_dev) {
            release(&inode_lock);
            return mnt;
        }
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

    mnt = getfs(ip);

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
}

/* free the cached text pages associated with the inode, if
   any. resets I_TEXT and I_SPLIT flags. caller owns `ip'. */

static void
xfree0(caddr_t *pages)
{
    int i;

    for (i = 0; i < PTES_PER_PAGE; ++i)
        if (pages[i])
            pgfree(pages[i]);
}

static void
xfree(struct inode *ip)
{
    int i;

    if (ip->i_flags & I_TEXT) {
        if (ip->i_flags & I_SPLIT)
            for (i = 0; i < PTES_PER_PAGE; ++i)
                if (ip->i_text[i])
                    xfree0((caddr_t *) (ip->i_text[i]));

        xfree0(ip->i_text);
        pgfree((caddr_t) ip->i_text);
    }

    ip->i_flags &= ~(I_TEXT | I_SPLIT);
}

struct inode *
iget(dev_t dev, ino_t ino, int ref)
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

            release(&inode_lock);
            ilock(ip);
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
    ip->i_refs = 1;                         /* (i_wanted/i_xrefs/i_wrefs */
    ip->i_busy = 1;                         /* must all already be zero) */

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

        if ((ip->i_flags & I_VALID) == 0)
            /* looks like rwinode() failed. it
               has already set u_errno for us */

            goto error;
    }

    /* 4. finally, increment the other reference counts and enforce
          the mutual exclusion of write access and demand paging. */

    switch (ref)
    {
    case INODE_REF_X:   if (ip->i_wrefs) goto etxtbsy;
                        ++(ip->i_xrefs);
                        break;

    case INODE_REF_W:   if (ip->i_xrefs) goto etxtbsy;
                        ++(ip->i_wrefs);

                        /* if this was previously (but not currently)
                           used for demand paging, invalidate cache */

                        xfree(ip);
    }

    return ip;

etxtbsy:
    u.u_errno = ETXTBSY;
error:
    iput(ip, 0, 0);
    return 0;
}

void
itrunc(struct inode *ip)
{
    panic("itrunc"); /* XXX */
}

void
iput(struct inode *ip, int ref, int flags)
{
    struct mount *mnt;
    struct inode *root;
    ino_t free_ino;

recurse: /* see #5 */

    free_ino = 0;
    ip->i_flags |= flags;

    /* 1. if this is the last reference, free the inode's storage.

       tricky. ordinarily, refs can't be relied on without inode_lock,
       but when nlink == 0 and refs == 1, we know that this is the last
       reference to `ip', and crucially, we also know that no one else
       can bind a new reference to `ip': the inode is not referenced in
       memory (save by us, refs == 1); the only disk references will be
       in directory entries (but there are none, nlink == 0) or in the
       free inode bitmap (but obviously we're not free... yet). there
       is no other way to find one's way to this inode, so we're safe.

       why not just acquire inode_lock? because we need to itrunc(). */

    if (ip->i_dinode.di_nlink == 0 && ip->i_refs == 1)
    {
        itrunc(ip);                 /* zap associated storage */

        /* races, races. we can't free the inode in its filesystem
           bitmap yet, or we'll invalidate what we just said above.
           we have to remember to do it right before we return. BUT
           by that time we'll no longer own `ip', so in [very rare]
           circumstances the filesystem it is on might be unmounted.
           solely to avoid this, grab a ref to the root of the fs. */

        mnt = getfs(ip);
        root = iget(mnt->m_dev, FS_ROOT_INO, 0);
        irelse(root);
        free_ino = ip->i_ino;  /* sentinel */
    }

    /* 2. if the inode has been updated, sync its on-disk counterpart */

    if (ip->i_flags & I_DIRTY)
    {
        time_t t = time; /* it's too volatile */

        if (ip->i_flags & I_ATIME) ip->i_dinode.di_atime = t;
        if (ip->i_flags & I_MTIME) ip->i_dinode.di_mtime = t;
        if (ip->i_flags & I_CTIME) ip->i_dinode.di_ctime = t;

        rwinode(ip, 1);
    }

    /* 3. decrement ancillary reference counts. the caller must call
          iput() with the same `ref' argument it passed to iget(). */

    switch (ref)
    {
    case INODE_REF_W:   --(ip->i_wrefs); break;
    case INODE_REF_X:   --(ip->i_xrefs); break;
    }

    /* 4. decrement main reference count, put back on the iavailq
          if no more in-memory references. relinquish ownership. */

    acquire(&inode_lock);

    if (--(ip->i_refs) == 0)
        TAILQ_INSERT_TAIL(&iavailq, ip, i_avail_links);

    ip->i_busy = 0;

    if (ip->i_wanted) {
        ip->i_wanted = 0;
        wakeup(ip);
    }

    release(&inode_lock);

    /* 5. finally, if we zapped the inode, free it in its bitmap. see
          the body of #1 above for the reasoning behind the gymnastics. */

    if (free_ino) {
        ifree(mnt, free_ino);
        ilock(root);

        /* unnecessary cleverness, or perhaps
           a missing compiler optimization.  */

        ip = root;      /* iput(root, 0, 0); */
        flags = 0;
        ref = 0;
        goto recurse;
    }
}

void
ilock(struct inode *ip)
{
    acquire(&inode_lock);

    while (ip->i_busy) {
        ip->i_wanted = 1;
        sleep(ip, P_STATE_COMA, &inode_lock);
    }

    release(&inode_lock);
}

void
irelse(struct inode *ip)
{
    acquire(&inode_lock);

    if (ip->i_wanted) {
        ip->i_wanted = 0;
        wakeup(ip);
    }

    ip->i_busy = 0;
    release(&inode_lock);
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
