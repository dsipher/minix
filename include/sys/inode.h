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
#include <sys/mutex.h>

/* structure for mounts[] table. one entry per filesystem.

   free entries are indicated by m_dev == NODEV (and m_inode == 0).

   among used entries, no two entries can have the same m_dev, since we
   don't permit a device to be mounted multiple times. similarly m_inode
   is always unique: two filesystems can't be mounted on the same inode.

   mounts[0] is the root filesystem. it's special. its m_inode == 0. */

struct mount
{
    dev_t               m_dev;          /* device mounted */
    unsigned            m_refs;         /* getfs() reference count */
    struct inode        *m_inode;       /* where mounted */
    struct filsys       m_filsys;       /* in-core superblock */

    /* these mutexes are used to prevent us from attempting alloc()
       on the same bitmap on the same device at the same time. not
       because it would result in races- it's just counterproductive. */

    struct mutex        m_balloc;       /* block allocation mutex */
    struct mutex        m_ialloc;       /* inode ................ */
    daddr_t             m_bhint;        /* hint for block allocation */
    ino_t               m_ihint;        /* ........ inode .......... */
};

/* in-core inode: the image of an on-disk inode
   (i_dinode) augmented with runtime-only data.
   to paraphrase v7, the inode is the focus of
   filesystem activity in the kernel. like bufs,
   inodes are cached in a [broadly] similar way */

TAILQ_HEAD(inodeq, inode);      /* struct inodeq */

struct inode
{
    /* fields marked (L) can only be changed while holding inode_lock.
       ............. (O) ................... by the current owner. */

    dev_t               i_dev;          /* (L) dev/ino pair uniquely */
    ino_t               i_ino;          /* (L) identifies this inode */
    int                 i_flags;        /* (O) I_* below */
    struct dinode       i_dinode;       /* (O) copy of on-disk data */

    /* the usual busy/wanted synchronization protocol. these fields
       are unique in that they may be manipulated when merely holding
       the ino_lock rather than having full ownership of the inode */

    char                i_busy;         /* (L) inode is in use */
    char                i_wanted;       /* (L) someone else wants it */

    /* i_refs is a count of in-memory references to this inode.

       i_wrefs counts how many references are mutable, i.e., how
       many are open files with write access this inode. i_xrefs
       is a count of processes which are using this inode as text.

       we only track i_wrefs/i_xrefs carefully for regular files,
       since only such files can serve as demand-paging storage. */

    short               i_refs;         /* (L) total ref count */
    short               i_wrefs;        /* (O) write references */
    short               i_xrefs;        /* (O) text references */

    /* these fields are only valid when the inode is set up as
       the backing store for a process image (I_TEXT). i_text
       is a map, like a page table, of pages which hold loaded,
       shareable text pages. when a_text is <= MAX_UNSPLIT_TEXT,
       i_text is a linear array. otherwise it's two-tiered.

       the pages referred to by i_text are owned by this inode
       (not any struct buf or any process using the text.) */

    struct exec         *i_exec;            /* (O) points to i_text */
    caddr_t             *i_text;            /* (O) index of text pages */

    /* we protect directory content operations (name lookup, unlink, etc.)
       with a mutex, to keep such operations atomic and avoid nasty races.
       ownership protects acquisition, but it can be released without. */

    struct mutex        i_lookup;           /* (O) down() (-) up() */

    /* inodes are always in a hash bucket, hashed by i_number.
       when i_refs == 0, the inode is also in the iavailq, as
       it is available to be reassigned if needed. (contrast
       with struct bufs, which are on bavailq when not BUSY) */

    TAILQ_ENTRY(inode)  i_hash_links;       /* (L) ihashq */
    TAILQ_ENTRY(inode)  i_avail_links;      /* (L) iavailq */
};

#define I_VALID         0x00000001      /* i_dinode is valid */

#define I_ATIME         0x00000002      /* inode has been `accessed' */
#define I_CTIME         0x00000004      /* inode has been `changed' */
#define I_MTIME         0x00000008      /* inode has been `modified' */

#define I_TEXT          0x00000010      /* set up for demand-paging */
#define I_SPLIT         0x00000020      /* text image is multi-level */
#define I_MOUNT         0x00000040      /* fs mounted on this inode */

#define I_DIRTY         (I_ATIME | I_CTIME | I_MTIME)

/* when text exceeds this size, i_text must be
   split (512 pointers per page * 4k = 2MB) */

#define I_MAX_FLAT_TEXT     (1 << 21)   /* 2MB */

/* maximum size of split (two-level) text.
   512 pointers to pages of 512 pointers per
   page --> 512 * 512 * 4k = 1GB. we simply
   refuse to run binaries larger than this */

#define I_MAX_SPLIT_TEXT    (1 << 30)   /* 1GB */


#ifdef _KERNEL

/* system root directory */

extern struct inode *rootdir;

/* exposed for page.c */

extern struct inode *inode;
extern struct inodeq *inodeq;

/* initialize inode cache */

extern void inoinit(void);

/* return the struct mount associated with ip->i_dev (i.e., the
   filesystem which contains the inode). the filesystem can not
   be unmounted before the caller issues a matching putfs(). */

extern struct mount *getfs(struct inode *ip);

/* release a reference to a filesystem returned by getfs() */

extern void putfs(struct mount *mnt);

/* mount the filesystem on block device `dev' onto directory `ip'. the caller
   must own `ip'. [as special case, `ip' may be null, when mounting root.] */

extern void mount(dev_t dev, struct inode *ip);

/* each inode has multiple reference counts; the caller must announce his
   intentions with a flag to iget() and pass the same flag back to iput()
   to maintain the reference counts properly. */

#define INODE_REF_R     0       /* we'll be reading only */
#define INODE_REF_W     1       /* inode must be writable */
#define INODE_REF_X     2       /* inode is for demand paging */

/* return the in-core inode corresponding to the disk inode `ino' on `dev'.
   `ref' is one of INODE_REF_* above. if the inode is not in memory, it is
   read in from the device. if it is mounted on, indirection is performed.
   the reference count(s) are incremented and the inode is returned locked.
   on error, returns null with u.u_errno set accordingly. */

extern struct inode *iget(dev_t dev, ino_t ino, int ref);

/* acquire or relinquish ownership of inode `ip'. */

extern void ilock(struct inode *ip);
extern void irelse(struct inode *ip);

/* free any disk storage associated with an inode,
   and set its size to 0. caller must own `ip'. */

extern void itrunc(struct inode *ip);

/* if the inode is dirty, update its on-disk image
   and mark it clean. the caller must own `ip'. */

extern void iupdat(struct inode *ip);

/* caller owns `ip'. decrement reference count(s) of `ip' (per `ref') and
   relinquish ownership. if the inode is marked dirty, it is written out.
   if this was the last reference to the inode exist (in-core or on-disk)
   then the on-disk inode and any associated on-disk storage is freed. as
   a convenience, `flags' are applied to ip->i_flags before processing. */

extern void iput(struct inode *ip, int ref, int flags);

/* map an offset `fileofs' into a file `ip' to its block number on the
   device. if `w' is specified, then new blocks are allocated as needed
   (data blocks and indirect blocks). returns the buf, or null if an
   error occurs or (if `w' is not specified) `fileofs' is not mapped. */

extern struct buf *bmap(struct inode *ip, off_t fileofs, int w);

/* check permissions on an inode `ip' (owned by caller).
   `amode' is a bitwise-OR of R_OK, W_OK, or X_OK. if
   access is denied, returns false, u.u_errno == EACCES.
   otherwise true is returned. the effective uid/gid are
   used to determine access unless `real' is non-zero. */

extern int access(struct inode *ip, int amode, int real);

#endif /* _KERNEL */


#endif /* _SYS_INODE_H */

/* vi: set ts=4 expandtab: */
