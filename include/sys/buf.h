/*****************************************************************************

   sys/buf.h                                           ux/64 system header

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

#ifndef _SYS_BUF_H
#define _SYS_BUF_H

#include <sys/param.h>
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
    short               b_flags;        /* see B_* below */

    char                b_busy,         /* flag: someone is using buf */
                        b_wanted;       /* flag: someone else wants it */

    /* the actual block data is pointed to here; it is always
       located in the first 4G to make direct PCI DMA possible.
       we present several different views for convenience. */

    union
    {
        char            *b_data;        /* general use */
        daddr_t         *b_daddr;       /* indirect block */
        struct filsys   *b_filsys;      /* superblock */
        struct dinode   *b_dino;        /* inode block */
    };

    TAILQ_ENTRY(buf)    b_hash_links;       /* bhashq[dev/blkno] */
    TAILQ_ENTRY(buf)    b_avail_links;      /* bavailq (or other) */
};

/* this bit is set when the buffer is handed to the device
   strategy routine to indicate a read operation. B_WRITE
   isn't real; it is provided as a mnemonic convenience to
   the callers of routines which have a read/write argument */

#define B_WRITE     0x00000000
#define B_READ      0x00000001

/* this bit is set when the data in b_data mirrors
   what is (or what should be) in the disk block. */

#define B_VALID     0x00000002

/* this bit is set by the driver when an i/o error occurs */

#define B_ERROR     0x00000004

/* set on a buffer just before it is released to indicate it
   should be placed at the head of the free list, rather than
   the tail. it is a performance heuristic used when the owner
   judges that the block is unlikely to be used again soon. */

#define B_AGE       0x00000008

/* set by bawrite() to indicate to the driver that the buffer should be
   released when the write is done, usually at interrupt time with iodone */

#define B_ASYNC     0x00000010

/* set by bdwrite() before releasing the buffer. when getblk(), while
   searching for a free block, discovers the bit is set in a buffer it
   would otherwise grab, it writes the block out before reusing it */

#define B_DELWRI    0x00000020

#ifdef _KERNEL

/* these are basically private to buf.c, but they
   must be exported so page.c can allocate them. */

extern struct buf  *buf;        /* buf[NBUF] */
extern struct bufq *bhashq;     /* bhashq[NBUFH] */

/* initialialize buffer cache */

extern void bufinit(void);

/* get a buffer for the specified block. it may
   or may not already have valid data in it. */

extern struct buf *getblk(dev_t dev, daddr_t blkno);

#endif /* _KERNEL */

#endif /* _SYS_BUF_H */

/* vi: set ts=4 expandtab: */
