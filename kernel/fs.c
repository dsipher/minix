/*****************************************************************************

   fs.c                                                       ux/64 kernel

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

#include <sys/fs.h>
#include <sys/buf.h>
#include <sys/log.h>
#include <sys/io.h>
#include <sys/spin.h>
#include <sys/user.h>
#include <sys/proc.h>
#include <sys/inode.h>
#include <sys/systm.h>
#include <errno.h>

/* scan a filesystem bitmap on `dev' which starts at `map' and spans
   `size' bits for a free bit (==1). the bit is reset and its index
   is returned. `hint' indicates where to start the scan: if non-zero,
   the scan will wrap if/when it reaches the end of the map. returns
   0 if there are no free bits (ENOSPC) or some other error occurs.

   (we can use this for both block maps and inode maps because daddr_t
   and ino_t have the same type (`unsigned') and use 0 as sentinel.) */

static unsigned
alloc(dev_t dev, daddr_t map, unsigned size, unsigned hint)
{
    /* we use the hint to compute our starting position, `blkno'
       is the block in the map, `index' the word in that block. */

    daddr_t         blkno   = hint / FS_BITS_PER_BLOCK;
    unsigned        index   = (hint % FS_BITS_PER_BLOCK) / BITS_PER_QWORD;
    daddr_t         blocks  = WHOLE(size, FS_BITS_PER_BLOCK);
    daddr_t         count;
    struct buf      *buf;
    unsigned long   word;
    unsigned        bit;

    /* we iterate over at most blocks+1 blocks. the +1
       covers the case where `hint' is non-zero, since
       we may have to examine the starting block twice
       (the first pass might only examine part of it) */

    count = 0;

    while (count <= blocks)
    {
        /* if we've reached the end of the map, wrap around. `blkno' may be
           be beyond `blocks' if `hint' is bogus, hence the >= vs just == */

        if (blkno >= blocks) blkno = 0;

        /* read in the block and scan for the
           first set bit, one word at a time */

        buf = bread(dev, map + blkno);
        if (buf == 0) return 0;

        for (; index < FS_QWORDS_PER_BLOCK; ++index)
        {
            word = buf->b_qwords[index];
            if (word == 0) continue;

            /* welp, we have at least one free bit. BSFQ() will give us
               the least significant one in the word. convert to offset
               from the beginning of the map, AFTER resetting the bit */

            bit = BSFQ(word);
            word &= ~(1L << bit);
            bit += index * BITS_PER_QWORD;
            bit += blkno * FS_BITS_PER_BLOCK;

            /* bit 0 should never be free in bmap or imap */

            if (bit == 0) panic("alloc");

            /* false positive: we saw a `free' bit beyond the end of the
               bitmap (i.e., in the trailing junk bits in the block after
               the end of the bitmap). break out -> wrap to first block */

            if (bit >= size) break;

            /* success. update the bitmap. */

            buf->b_qwords[index] = word;
            bwrite(buf, B_SYNC);
            if (u.u_errno) return 0;

            return bit;
        }

        brelse(buf, 0);
        index = 0;
        ++blkno;
        ++count;
    }

    /* no free bits */

    u.u_errno = ENOSPC;
    return 0;
}

/* the logic for balloc() and ialloc() is nearly identical.
   we don't attempt simultaneous scans of the bitmaps, not
   because it's racy, but because it's counterproductive */

#define ALLOC(FLAG, MAP, SIZE, HINT, FREE)                      \
    {                                                           \
        unsigned n;                                             \
                                                                \
        acquire(&mnt->m_lock);                                  \
                                                                \
        while (mnt->m_flags & FLAG) {                           \
            mnt->m_flags |= M_WANTED;                           \
            sleep(mnt, P_STATE_COMA, &mnt->m_lock);             \
        }                                                       \
                                                                \
        mnt->m_flags |= FLAG;                                   \
        release(&mnt->m_lock);                                  \
                                                                \
        n = alloc(  mnt->m_dev,                                 \
                    MAP(mnt->m_filsys),                         \
                    mnt->m_filsys.SIZE,                         \
                    mnt->HINT               );                  \
                                                                \
        acquire(&mnt->m_lock);                                  \
                                                                \
        if (n) {  /* success */                                 \
            mnt->HINT = n;                                      \
            --mnt->m_filsys.FREE;                               \
            mnt->m_flags |= M_DIRTY;                            \
        }                                                       \
                                                                \
        if (mnt->m_flags & M_WANTED) wakeup(mnt);               \
        mnt->m_flags &= ~(M_WANTED | FLAG);                     \
                                                                \
        release(&mnt->m_lock);                                  \
                                                                \
        return n;                                               \
    }

daddr_t balloc(struct mount *mnt)   ALLOC(  M_BALLOC,           \
                                            FS_BMAP_START,      \
                                            s_blocks,           \
                                            m_bhint,            \
                                            s_free_blocks       )

ino_t   ialloc(struct mount *mnt)   ALLOC(  M_IALLOC,           \
                                            FS_IMAP_START,      \
                                            s_inodes,           \
                                            m_ihint,            \
                                            s_free_inodes       )

/* vi: set ts=4 expandtab: */
