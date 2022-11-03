/*****************************************************************************

   buf.c                                                      ux/64 kernel

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

#include <sys/buf.h>
#include <sys/page.h>
#include <sys/log.h>
#include <sys/spin.h>
#include <sys/proc.h>
#include "config.h"

/* we maintain a fixed number of buffers
   allocated at initialization by page.c */

struct buf *buf; /* buf[NBUF] */

/* all bufs are always in the bhashq (hash by b_blkno),
   and buffers not b_busy are also in the bavailq. */

struct bufq bavailq = TAILQ_HEAD_INITIALIZER(bavailq);
struct bufq *bhashq; /* bhashq[NBUFH] */

/* protects the global buffer data, and the b_wanted, b_busy, and b_done
   fields of buf. (the remaining fields are exclusively for the owner.) */

static spinlock_t buf_lock;

/* compute the hash bucket for `blkno'. we
   recommend that NBUFH be a power of 2. */

#define BUFHASH(blkno)  ((blkno) % NBUFH)

/* bhashq[] and buf[] have been allocated and
   zeroed by pginit(). we have four tasks:

    (1) initialize all the bhashq[] heads.
        (all-zero is not a valid tailq head)

    (2) put all bufs on the bavailq.

    (3) put all bufs in the bhashq[]. we must spread
        the blocks out by manipulating their b_blknos,
        otherwise they'll all [pathologically] end up
        in the same bucket. (this matters because it
        penalizes `real' buffers in that bucket until
        they finally spread themselves out over time)

    (4) allocate pages for data storage for each buf

   we skip locking, since this is called very early */

void bufinit(void)
{
    int i, b;
    caddr_t data;

    for (i = 0; i < NBUFH; ++i)
        TAILQ_INIT(&bhashq[i]);

    for (i = 0; i < NBUF; ++i) {
        buf[i].b_dev = NODEV;
        buf[i].b_blkno = i;
        b = BUFHASH(buf[i].b_blkno);
        TAILQ_INSERT_TAIL(&bhashq[b], &buf[i], b_hash_links);
        TAILQ_INSERT_TAIL(&bavailq, &buf[i], b_avail_links);

        /* (a) there must BE a free page for the data and
           (b) its physical address must be < 4GB for DMA */

        data = pgall(0);
        buf[i].b_data = (char *) data;

        if (data == 0 || VTOP(data) >= 0x100000000 /* 4GB */)
            panic("bufinit");
    }
}

void brelse(struct buf *bp, int flags)
{
    acquire(&buf_lock);

    bp->b_flags |= flags;
    bp->b_busy = 0;

    if (bp->b_wanted) {
        bp->b_wanted = 0;
        wakeup(bp);
    }

    /* wake up anyone waiting for ANY free block
       (which can only be true if bavailq is empty) */

    if (TAILQ_FIRST(&bavailq) == 0) wakeup(&bavailq);

    if (bp->b_flags & B_AGE) {
        bp->b_flags &= ~B_AGE;
        TAILQ_INSERT_HEAD(&bavailq, bp, b_avail_links);
    } else
        TAILQ_INSERT_TAIL(&bavailq, bp, b_avail_links);

    release(&buf_lock);
}

/* wait for i/o on `bp' to complete; we do this by looking for
   bp->b_done to go true when it's set by iodone(). notice that
   b_done is only partly protected by buf_lock: it can be reset
   with impunity by the buf owner, but it can't be set without
   holding the lock, since we synch on the positive transition */

static void
iowait(struct buf *bp)
{
    acquire(&buf_lock);

    while (bp->b_done == 0) /* maybe if? */
        sleep(bp, P_STATE_COMA, &buf_lock);

    release(&buf_lock);
}

/* iodone() is usually (but not always) called from in interrupt
   context, from the bottom half of a device's strategy routine. */

void
iodone(struct buf *bp, int flags)
{
    bp->b_flags |= flags;

    /* the filesystem code sets B_CRITICAL on all i/o involving
       filesystem metadata. a panic is the only safe response. */

    if (bp->b_flags & B_ERROR) {
        printf("i/o error: device %d/%d block %u\n", MAJOR(bp->b_dev),
                                                     MINOR(bp->b_dev),
                                                     bp->b_blkno);

        if (bp->b_flags & B_CRITICAL) panic("B_CRITICAL");
    }

    if (bp->b_flags & B_READ)           /* a completed read means */
        bp->b_flags |= B_VALID;         /* the data is now B_VALID. */
    else                                /* a completed write means */
        bp->b_flags &= ~B_DIRTY;        /* the buf is no longer B_DIRTY. */

    /* hygiene. don't keep stray flags around. */

    bp->b_flags &= ~(B_READ | B_CRITICAL | B_SYNC);

    if (bp->b_flags & B_ASYNC) {
        /* async i/o means the owner doesn't want the buf anymore,
           so we release it on his behalf. we must clear the error
           flag, since there's no process to report the error to. */

        bp->b_flags &= ~(B_ASYNC | B_ERROR);
        brelse(bp, 0);
     } else {
        /* otherwise, we know the owner is waiting for it in iowait().
           the owner must do something appropriate with any B_ERROR. */

        acquire(&buf_lock);
        bp->b_done = 1;
        bp->b_wanted = 0;
        wakeup(bp);
        release(&buf_lock);
    }
}

/* we must observe the state of B_ASYNC before calling the strategy
   routine, because ownership of the buf passes to the driver then.
   reading them directly would result in a race with the driver. */

void
bwrite(struct buf *bp, int flags)
{
    int sync;

    bp->b_done = 0;
    bp->b_flags |= B_WRITE | flags;
    sync = !(bp->b_flags & B_ASYNC);
    /* XXX: strategy */

    if (sync) {
        iowait(bp);
        brelse(bp, 0);
    }
}

struct buf *
bread(dev_t dev, daddr_t blkno, int flags)
{
    struct buf *bp;

    bp = getblk(dev, blkno);

    if (bp->b_flags & B_VALID)
        return bp;

    bp->b_done = 0;
    bp->b_flags |= B_READ | flags;
    /* XXX: strategy */
    iowait(bp);
    return bp;
}

/* mark `bp' busy and remove it from the bavailq */

static
notavail(struct buf *bp)    /* held: buf_lock */
{
    bp->b_busy = 1;
    TAILQ_REMOVE(&bavailq, bp, b_avail_links);
}

/* assign a buffer for the given block. if the appropriate
   block is already associated, return it; otherwise search
   for the oldest non-busy buffer and reassign it. */

struct buf *
getblk(dev_t dev, daddr_t blkno)
{
    struct buf *bp;
    int b; /* bucket */

relock:
    acquire(&buf_lock);

retry:

    /* first, see if the block is already associated in the cache. if yes,
       but it's busy, we'll have to sleep on the block and retry on wakeup */

    b = BUFHASH(blkno);

    for (bp = TAILQ_FIRST(&bhashq[b]); bp; bp = TAILQ_NEXT(bp, b_hash_links))
    {
        if (bp->b_dev != dev || bp->b_blkno != blkno)
            continue;

        if (bp->b_busy) {
            bp->b_wanted = 1;
            sleep(bp, P_STATE_COMA, &buf_lock);
            goto retry;
        }

        notavail(bp);
        release(&buf_lock);
        return bp;
    }

    /* not in the cache, so we need to grab an available block and
       reassign it. in the highly unlikely event that there are no
       available blocks, sleep on the bavailq and retry on wakeup */

    bp = TAILQ_FIRST(&bavailq);

    if (bp == 0) {
        sleep(&bavailq, P_STATE_COMA, &buf_lock);
        goto retry;
    }

    /* claim ownership of the block for ourselves. if it's got data
       that must to be written to disk, our success is short-lived:
       we must schedule the write and start the search over again. */

    notavail(bp);

    if (bp->b_flags & B_DIRTY) {
        release(&buf_lock);
        bwrite(bp, B_ASYNC | B_AGE);
        goto relock;
    }

    /* this is the ONLY place where a buf can be reassigned, and
       thus the only place where it will change bhashq buckets */

    b = BUFHASH(bp->b_blkno); TAILQ_REMOVE(&bhashq[b], bp, b_hash_links);

    bp->b_flags = 0;            /* zap all the flags */
    bp->b_dev = dev;            /* reassign the block */
    bp->b_blkno = blkno;

    b = BUFHASH(blkno); TAILQ_INSERT_HEAD(&bhashq[b], bp, b_hash_links);

    release(&buf_lock);
    return bp;
}

/* vi: set ts=4 expandtab: */
