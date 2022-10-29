/*****************************************************************************

   buf.c                                                      ux/64 kernel

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

#include <sys/buf.h>
#include <sys/page.h>
#include <sys/log.h>
#include "config.h"

struct bufq bavailq = TAILQ_HEAD_INITIALIZER(bavailq);

struct bufq *bhashq;         /* bhashq[NBUFH] */
struct buf  *buf;            /* buf[NBUF] */

/* compute the hash bucket for buf `b'. (this is
   why we recommend that NBUFH be a power of 2.) */

#define BUFHASH(b)      ((b)->b_blkno % NBUFH)

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

    (4) allocate pages for data storage for each buf */

void bufinit(void)
{
    int i, b;
    caddr_t data;

    for (i = 0; i < NBUFH; ++i)
        TAILQ_INIT(&bhashq[i]);

    for (i = 0; i < NBUF; ++i) {
        buf[i].b_dev = NODEV;
        buf[i].b_blkno = i;
        b = BUFHASH(&buf[i]);
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

/* vi: set ts=4 expandtab: */
