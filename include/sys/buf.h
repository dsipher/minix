/*****************************************************************************

   sys/buf.h                                           ux/64 system header

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

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

/* we adopt the research unix buffer cache with only minimal
   modification. as such, dmr's classic paper on the unix i/o
   system is still mostly relevant, and many of the comments
   here are basically lifted from there and the v7 sources. */

TAILQ_HEAD(bufq, buf);  /* struct bufq */

/* a buffer header contains all the information required to perform i/o.
   each buffer in the pool is usually linked into two queues: the bhashq
   which permits fast lookups by dev/blkno (always) and the bavailq which
   holds blocks available for other use (sometimes). a buffer is on the
   bavailq if and only if it is not marked B_BUSY; when it is B_BUSY, the
   b_avail_links can be used (by, e.g., the driver) for another bufq.

   note that `b_flags' is volatile. this field is not protected by any
   locks and must be accessed atomically regardless of who owns the buf. */

struct buf
{
    dev_t               b_dev;          /* associated device */
    daddr_t             b_blkno;        /* and its block number */
    volatile int        b_flags;        /* see B_* flags below */

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

/* this bit is cleared when the buffer is handed to the device
   strategy routine and is set when the operation completes,
   whether normally or as the result of an error. if this bit
   is set on a block in bavailq or returned from getblk(), it
   signals the block is in agreement with the data on disk. */

#define B_DONE      0x00000002

/* this bit is set when B_DONE is set to indicate an i/o error */

#define B_ERROR     0x00000004

/* when set, this bit indicates the block is not on bavailq,
   i.e., it is dedicated to someone's exclusive use. the buf
   remains in the appropriate bhashq bucket, however. */

#define B_BUSY      0x00000008

/* used in conjuction with the B_BUSY bit. this indicates
   that the block is wanted by someone else, so a wakeup()
   on the block address should be issued when it is released */

#define B_WANTED    0x00000010

/* set on a buffer just before it is released to indicate it
   should be placed at the head of the free list, rather than
   the tail. it is a performance heuristic used when the owner
   judges that the block is unlikely to be used again soon. */

#define B_AGE       0x00000020

/* set by bawrite() to indicate to the driver that the buffer should be
   released when the write is done, usually at interrupt time with iodone */

#define B_ASYNC     0x00000040

/* set by bdwrite() before releasing the buffer. when getblk(), while
   searching for a free block, discovers the bit is set in a buffer it
   would otherwise grab, it causes the block to be written out before
   reusing it. */

#define B_DELWRI    0x00000080

#ifdef _KERNEL

/* we must export these so
   page.c can allocate them */

extern struct buf  *buf;
extern struct bufq *bhashq;

/* initialialize buffer cache */

extern void bufinit(void);

/* get a buffer for the specified block. it may
   or may not already have valid data in it. */

extern struct buf *getblk(dev_t dev, daddr_t blkno);

#endif /* _KERNEL */

#endif /* _SYS_BUF_H */

/* vi: set ts=4 expandtab: */
