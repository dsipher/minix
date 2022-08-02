/*****************************************************************************

   opt.h                                               tahoe/64 c compiler

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

#ifndef OPT_H
#define OPT_H

/* opt() loops, invoking the optimization passes requested until no requests
   remain. passes may request other passes (or themselves) by setting flags
   in opt_request. the passes are prioritized in the order they appear in the
   passes[] table in opt.c, whose order is mirrored below.

   most passes operate either on LIR or on MCH insns, but not both. the
   names reflect which. notably OPT_DEAD and OPT_PRUNE do work on both. */

extern int opt_request;             /* passes requested this round */
extern int opt_prohibit;            /* passes prohibited globally */

#define OPT_LIR_FIXCC       0x00000001
#define OPT_LIR_NORM        0x00000002
#define OPT_LIR_DELAY       0x00000004
#define OPT_LIR_PROP        0x00000008
#define OPT_DEAD            0x00000010
#define OPT_LIR_REASSOC     0x00000020
#define OPT_PRUNE           0x00000040
#define OPT_LIR_FOLD        0x00000080
#define OPT_LIR_HOIST       0x00000100
#define OPT_LIR_DVN         0x00000200
#define OPT_LIR_CMP         0x00000400
#define OPT_MERGE           0x00000800
#define OPT_MCH_EARLY       0x00001000
#define OPT_MCH_CMP         0x00002000
#define OPT_MCH_FUSE        0x00004000
#define OPT_MCH_CMOV        0x00008000
#define OPT_MCH_LATE        0x00010000
#define OPT_MCH_ZLQ         0x00020000

#define OPT_ANY_PASSES      (   OPT_DEAD            \
                            |   OPT_PRUNE           \
                            |   OPT_MERGE           )

#define OPT_LIR_PASSES      (   OPT_LIR_FIXCC       \
                            |   OPT_LIR_NORM        \
                            |   OPT_LIR_DELAY       \
                            |   OPT_LIR_PROP        \
                            |   OPT_LIR_REASSOC     \
                            |   OPT_LIR_FOLD        \
                            |   OPT_LIR_HOIST       \
                            |   OPT_LIR_DVN         \
                            |   OPT_LIR_CMP         )

/* passes that can be run on the MCH code
   only before register allocation is done
   (because they must allocate temporaries) */

#define OPT_MCH_PRECOLOR    (   OPT_MCH_CMOV        )

/* passes that can be run on the MCH code
   before, during, or after allocation */

#define OPT_MCH_PASSES      (   OPT_MCH_EARLY       \
                            |   OPT_MCH_CMP         \
                            |   OPT_MCH_FUSE        )

/* MCH final passes must be treated with care, because they
   modify the IR `destructively', in the sense that other
   passes may not be able to handle them after they run. */

#define OPT_MCH_FINAL       (   OPT_MCH_LATE        \
                            |   OPT_MCH_ZLQ         )

void opt_prune(void);               /* CFG pruning */
void opt_dead(void);                /* dead store removal */

/* seed opt_request with request and run the optimizer loop.
   passes in either prohibit or opt_prohibit are blocked. */

void opt(int request, int prohibit);

#endif /* OPT_H */

/* vi: set ts=4 expandtab: */
