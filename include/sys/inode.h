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

/* mount structure. one allocated on every mount.
   free entries are indicated by m_dev == NODEV */

struct mount
{
    dev_t               m_dev;          /* device mounted */
    struct filsys       m_super;        /* in-core superblock */
    struct inode        *m_inode;       /* where mounted */
};

/* in-core inode: the image of an on-disk inode
   (i_dinode) augmented with runtime-only data.
   as the v7 sources say, the inode is the focus
   of all file activity in the system. like bufs,
   inodes are cached, and using similar methods */

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

#define I_DIRTY         0x00000001      /* inode has been updated */
#define I_TEXT          0x00000002      /* set up for demand-paging */
#define I_SPLIT         0x00000004      /* text image is multi-level */
#define I_MOUNT         0x00000008      /* fs mounted on this inode */

/* when text exceeds this size, i_text must be
   split (512 pointers per page * 4k = 2MB) */

#define MAX_UNSPLIT_TEXT    (1 << 21)   /* 2MB */

#ifdef _KERNEL

/* exposed to page.c */

extern struct inode *inode;
extern struct inodeq *inodeq;

/* initialize inode cache */

extern void inoinit(void);

#endif /* _KERNEL */

#endif /* _SYS_INODE_H */

/* vi: set ts=4 expandtab: */
