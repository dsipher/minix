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

    release(&inode_lock);

    if (ip) ++(ip->i_refs);     /* we've kept a reference, */
    bwrite(super, B_ASYNC);     /* and updated the superblock */
}

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
            bwrite(buf, B_ASYNC);
        } else {
            MOVSQ(&ip->i_dinode, buf->b_data + offset, FS_INODE_QWORDS);
            brelse(buf, 0);
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
    /* XXX */
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
