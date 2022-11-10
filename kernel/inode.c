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

/* mounted filesystems. as mentioned below, this is protected
   by inode_lock, but the locking protocol is quite loose. in
   particular, entries associated with any referenced inodes
   are guaranteed to be undisturbed (they can't be unmounted).
   this is why, e.g., we can hand out entry pointers to clients
   via getfs() even though they have no access to inode_lock. */

static struct mount mounts[NMOUNT];

/* protects inode queues, the shared fields
   of struct inode and (partially) mounts[] */

static spinlock_t inode_lock;

/* map an inode number to its bucket. most
   efficient if NINODEQ is a power of 2 */

#define INOHASH(ino)    ((ino) % NINODEQ)

/* the caller holds a reference to `ip'. as such, it
   is safe for us to scan mounts[] without locking. */

struct mount *
getfs(struct inode *ip)
{
    struct mount *mnt;
    int i;

    for (mnt = mounts, i = 0; i < NMOUNT; ++i, ++mnt)
        if (mnt->m_dev == ip->i_dev)
            return mnt;

    /* no one should ever be holding an inode
       that is not on a mounted filesystem... */

    panic("getfs");
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

    /* notice that it's not an error to try to read/write inode 0. the
       system in its current form will never try this, but it's a valid
       inode on the medium, and it may someday have a special use. */

    if (ip->i_ino >= mnt->m_filsys.s_inodes) panic("rwinode");

    blkno = FS_ITOD(mnt->m_filsys, ip->i_ino);
    offset = FS_ITOO(mnt->m_filsys, ip->i_ino);
    buf = bread(ip->i_dev, blkno);

    if (buf)
        if (w) {
            MOVSQ(buf->b_data + offset, &ip->i_dinode, FS_INODE_QWORDS);
            bwrite(buf, B_SYNC);
            ip->i_flags &= ~I_DIRTY;
        } else {
            MOVSQ(&ip->i_dinode, buf->b_data + offset, FS_INODE_QWORDS);
            brelse(buf, 0);
        }
}

struct inode *
iget(dev_t dev, ino_t ino, int ref)
{
    struct inode *ip;
    struct mount *mnt;
    int ob, b;  /* buckets */

    acquire(&inode_lock);

loop:
    b = INOHASH(ino);

    for (ip = TAILQ_FIRST(&inodeq[b]); ip; ip = TAILQ_NEXT(ip, i_hash_links))
    {
        if (ip->i_dev == dev && ip->i_ino == ino)
        {
            /* if the inode is in the cache, but it
               is busy, we have to wait our turn */

            if (ip->i_busy) {
                ip->i_wanted = 1;
                sleep(ip, P_STATE_COMA, &inode_lock);
                goto loop;
            }

            /* if it's in the cache, but a mount point, then we really
               mean we want the root inode of the mounted filesystem */

            if (ip->i_flags & I_MOUNT) {
                for (mnt = mounts; mnt; ++mnt)
                    if (mnt->m_inode == ip)
                    {
                        dev = mnt->m_dev;
                        ino = FS_ROOT_INO;
                        goto loop;
                    }

                panic("iget");
            }

            /* an inode can't be used for writing
               and demand paging at the same time */

            if ((ref == INODE_REF_X && ip->i_wrefs)
             || (ref == INODE_REF_W && ip->i_xrefs))
            {
                u.u_errno = ETXTBSY;
                release(&inode_lock);
                return 0;
            }

            /* looks like it's ours for the taking.
               if it's on the iavailq, get it off */

            if (ip->i_refs == 0)
                TAILQ_REMOVE(&iavailq, ip, i_avail_links);

            ip->i_busy = 1;
            ++(ip->i_refs);
            release(&inode_lock);
            goto success;
        }
    }

    /* fall through; the inode isn't in the cache, so we need to grab
       one from the iavailq, reassign it, and load it in from disk. */

    ip = TAILQ_FIRST(&iavailq);

    if (ip == 0) {              /* unlike the buffer cache, we don't block */
        u.u_errno = ENFILE;     /* and wait for a free inode: bufs churn, */
        release(&inode_lock);   /* but we could wait indefinitely for an */
        return 0;               /* inode. no problem if NINODE is right! */
    }

    TAILQ_REMOVE(&iavailq, ip, i_avail_links);

    /* XXX if I_TEXT, zap the i_text */

    /* since we're re-assigning the inode, we
       must shift it into its new hash bucket */

    ob = INOHASH(ip->i_ino);
    TAILQ_REMOVE(&inodeq[ob], ip, i_hash_links);
    TAILQ_INSERT_HEAD(&inodeq[b], ip, i_hash_links);

    /* now initialize the inode and take ownership. */

    ip->i_dev = dev;
    ip->i_ino = ino;
    ip->i_flags = 0;
    ip->i_busy = 1;         /* i_wanted is already 0, and so are */
    ip->i_refs = 1;         /* i_wrefs/i_xrefs, unless we goofed */

    release(&inode_lock);
    rwinode(ip, 0);

    /* if there was an error reading the inode from disk, we disassociate
       `ip' from it (so no one will grab it and mistakenly think it holds
       valid data) then put it back on the free list and error out. */

    if (u.u_errno) {
        acquire(&inode_lock);
        ip->i_dev = ENODEV;
        ip->i_busy = 0;
        ip->i_refs = 0;

        if (ip->i_wanted) {
            ip->i_wanted = 0;
            wakeup(ip);
        }

        TAILQ_INSERT_HEAD(&iavailq, ip, i_avail_links);
        release(&inode_lock);
        return 0;
    }

success:
    switch (ref)
    {
    case INODE_REF_W:   ++(ip->i_wrefs); break;
    case INODE_REF_X:   ++(ip->i_xrefs); break;
    }

    return ip;
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
