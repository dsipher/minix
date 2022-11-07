/*****************************************************************************

   sys/inode.h                                         ux/64 system header

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

#ifndef _SYS_INODE_H
#define _SYS_INODE_H

#include <a.out.h>
#include <sys/fs.h>
#include <sys/types.h>
#include <sys/tailq.h>
#include <sys/spin.h>

/* structure for mounts[] table. one entry per filesystem.

   free entries are indicated by m_dev == NODEV (and m_inode == 0).

   among used entries, no two entries can have the same m_dev, since we
   don't permit a device to be mounted multiple times. similarly m_inode
   is always unique: even if a mount point is completely covered, the
   covering mount will be associated with the root inode of the covered.

   mounts[0] is the root filesystem. it's special. its m_inode == 0. */

struct mount
{
    dev_t               m_dev;          /* device mounted */
    spinlock_t          m_lock;         /* protects m_filsys */
    struct filsys       m_filsys;       /* in-core superblock */
    struct inode        *m_inode;       /* where mounted */
};

/* in-core inode: the image of an on-disk inode
   (i_dinode) augmented with runtime-only data.
   to paraphrase v7, the inode is the focus of
   [most] i/o activity in the system. like bufs,
   inodes are cached, and using similar methods. */

TAILQ_HEAD(inodeq, inode);      /* struct inodeq */

struct inode
{
    dev_t               i_dev;          /* dev/ino pair uniquely */
    ino_t               i_ino;          /* identifies this inode */
    int                 i_flags;        /* I_* below */
    struct dinode       i_dinode;       /* copy of on-disk data */

    /* the usual busy/wanted synchronization protocol. these fields
       are unique in that they may be manipulated when merely holding
       the ino_lock rather than having full ownership of the inode */

    char                i_busy;         /* inode is in use */
    char                i_wanted;       /* someone else wants it */

    /* i_refs is a count of in-memory references to this inode.
       i_wrefs counts how many of those are mutable, i.e., how
       many open files with write access this inode. i_xrefs is
       a count of processes which are using this inode as text.
       note that i_wrefs != 0 --> i_xrefs == 0, and vice versa */

    short               i_refs;         /* total ref count */
    short               i_wrefs;        /* write references */
    short               i_xrefs;        /* text references */

    /* these fields are only valid when the inode is set up as
       the backing store for a process image (I_TEXT). i_text
       is a map, like a page table, of pages which hold loaded,
       shareable text pages. when a_text is <= MAX_UNSPLIT_TEXT,
       i_text is a linear array. otherwise it's two-tiered.

       the pages referred to by i_text are owned by this inode
       (not any struct buf or any process using the text.) */

    struct exec         *i_exec;
    caddr_t             *i_text;

    /* inodes are always in a hash bucket, hashed by i_number.
       when i_refs == 0, the inode is also in the iavailq, as
       it is available to be reassigned if needed. (contrast
       with struct bufs, which are on bavailq when not BUSY) */

    TAILQ_ENTRY(inode)  i_hash_links;       /* ihashq */
    TAILQ_ENTRY(inode)  i_avail_links;      /* iavailq */
};

#define I_DIRTY         0x00000001      /* i_dinode has been changed */
#define I_TEXT          0x00000002      /* set up for demand-paging */
#define I_SPLIT         0x00000004      /* text image is multi-level */
#define I_MOUNT         0x00000008      /* fs mounted on this inode */

/* when text exceeds this size, i_text must be
   split (512 pointers per page * 4k = 2MB) */

#define MAX_UNSPLIT_TEXT    (1 << 21)   /* 2MB */

#ifdef _KERNEL

/* exposed for page.c */

extern struct inode *inode;
extern struct inodeq *inodeq;

/* initialize inode cache */

extern void inoinit(void);

/* return the struct mount associated with ip->i_dev
   (i.e., the filesystem which containing the inode).
   the client is free to use the mount, indefinitely,
   provided that it:

        (a) protects m_filsys with m_lock, and
        (b) maintains its reference to `ip' */

extern struct mount *getfs(struct inode *ip);

/* each inode has multiple reference counts; the caller must announce his
   intentions with a flag to iget() and pass the same flag back to iput()
   to maintain the reference counts properly. */

#define INODE_REF_R     0       /* we'll be reading only */
#define INODE_REF_W     1       /* inode must be writable */
#define INODE_REF_X     2       /* inode is for demand paging */

/* return the in-core inode corresponding to the disk inode `ino' on `dev'.
   `ref' is one of INODE_REF_* above. if the inode is not in memory, it is
   read in from the device. if it is mounted on, indirection is performed.
   the reference count(s) are incremented and the inode is returned locked. */

extern struct inode *iget(dev_t dev, ino_t ino, int ref);

#endif /* _KERNEL */

#endif /* _SYS_INODE_H */

/* vi: set ts=4 expandtab: */
