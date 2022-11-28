/*****************************************************************************

   sys/buf.h                                           minix system header

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).
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

#ifndef _SYS_BUF_H
#define _SYS_BUF_H

#include <sys/dev.h>
#include <sys/types.h>
#include <sys/tailq.h>
#include <sys/fs.h>

/* a buffer header contains all the information required to perform i/o.
   each buffer in the pool is usually linked into two queues: the bhashq
   which permits fast lookups by dev/blkno (always) and the bavailq which
   holds blocks available for other use (sometimes). a buffer is on the
   bavailq if and only if it is not marked b_busy; when it is b_busy, the
   b_avail_links can be used (by, e.g., the driver) for another bufq. */

TAILQ_HEAD(bufq, buf);  /* struct bufq */

struct buf
{
    dev_t               b_dev;          /* associated device */
    daddr_t             b_blkno;        /* and its block number */
    char                b_flags;        /* see B_* below */

    char                b_done,         /* flag: driver completed i/o */
                        b_busy,         /* flag: someone is using buf */
                        b_wanted;       /* flag: someone else wants it */

    char                b_errno;        /* result of last i/o operation */
    char                b_errcnt;       /* retry count (for driver use) */

    /* the actual block data is pointed to here; it is always
       located in the first 4G to make direct PCI DMA possible.
       we present several different views for convenience. */

    union
    {
        char            *b_data;        /* general use */
        daddr_t         *b_daddr;       /* indirect block */
        unsigned long   *b_qwords;      /* as quadwords */
    };

    TAILQ_ENTRY(buf)    b_hash_links;       /* bhashq[dev/blkno] */
    TAILQ_ENTRY(buf)    b_avail_links;      /* bavailq (or other) */
};

/* this bit is set when the buffer is handed to the device
   strategy routine to indicate a read operation. B_WRITE
   isn't real; it is provided as a mnemonic convenience to
   the callers of routines which have a read/write argument */

#define B_WRITE         0x00
#define B_READ          0x01

/* this bit is set when the data in b_data mirrors
   what is (or what should be) in the disk block. */

#define B_VALID         0x02

/* set on a buffer to indicate it should be placed at the head
   of the free list when it released, rather than the tail. it
   it is a performance heuristic used when the owner judges the
   block is unlikely to be used again soon. */

#define B_AGE           0x04

/* indicates that the owner does not want the block after
   i/o is done, so after completion it should be released.
   this is currently only supported for write operations */

#define B_ASYNC         0x08

/* set on a buffer on the bavailq when its contents are dirty,
   that is, must be written out before reusing the buffer. */

#define B_DIRTY         0x10


#ifdef _KERNEL

/* these are basically private to buf.c, but they
   must be exported so page.c can allocate them. */

extern struct buf  *buf;        /* buf[NBUF] */
extern struct bufq *bhashq;     /* bhashq[NBUFQ] */

/* initialialize buffer cache */

extern void bufinit(void);

/* get a buffer for the specified block. it may
   or may not already have valid data in it. */

extern struct buf *getblk(dev_t dev, daddr_t blkno);

/* write `buf' to disk and release ownership of it. if B_ASYNC is
   set, returns immediately, otherwise waits for completion. as a
   convenience `flags' are applied to bp->b_flags before processing.  */

extern void bwrite(struct buf *bp, int flags);

/* read in (if necessary) the block and return its buf. if
   an error occurs, returns 0 (with u.u_errno set of course). */

extern struct buf *bread(dev_t dev, daddr_t blkno);

/* relinquish ownership a buffer. no immediate i/o is implied, but if
   marked B_DIRTY, the buf will be written out before it is reassigned.
   `flags' are applied to bp->b_flags before processing (a convenience) */

extern void brelse(struct buf *bp, int flags);

/* called by a device driver after completing i/o on a buf.
   `errno' is zero in the usual case when no error occurs */

extern void iodone(struct buf *bp, int errno);

#endif /* _KERNEL */

#endif /* _SYS_BUF_H */

/* vi: set ts=4 expandtab: */
