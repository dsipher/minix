/*****************************************************************************

   delay.c                                                minix c compiler

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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

#include "cc1.h"
#include "block.h"
#include "delay.h"

/* in a basic block, we attempt to shuffle LOAD/STORE instructions
   to their earliest possible points. for LOADs in particular, the
   intent is to allow the CPU as much time as possible to fetch the
   value before we attempt to use it. STOREs can benefit, too; there
   is no reason not to tell the memory subsystem as soon as possible
   that we have something for it to do. (at least, in theory.)

   there's another benefit to this shuffling, which explains why we
   call this OPT_LIR_DELAY: it has the effect of pushing post-inc or
   post-dec ops past a memory op which uses the affected variable in
   its address calculations. by delaying the increment/decrement this
   way, it eases register pressure and avoids unnecessary copies by
   leaving the prior value available before it's modified.

   the delay optimization is nearly as old as c is, appearing in s.c.
   johnson's pcc (and perhaps in dmr's compiler; i should look...) */

static void delay0(struct block *b)
{
    struct insn *insn;
    int invalidated;
    int i, j;

again:
    dep_analyze(b);

    FOR_EACH_INSN(b, i, insn) {
        switch (insn->op)
        {
        case I_LIR_LOAD:
        case I_LIR_STORE:   goto eligible;

        case I_LIR_CAST:
            /* if we're casting the result of a LOAD, we want to move
               it along with that LOAD. among other things, it prevents
               OPT_MCH_FUSE from undoing our work by moving the memory
               operation forward again (by fusing it to the cast...). */

            for (j = (i - 1); j >= 0; --j) {
                /* we can avoid doing full live analysis:
                   the only possible dependency an I_LIR_CAST
                   has is on the insn which DEFs its source. */

                if (deps(b, i, j) && (INSN(b, j)->op == I_LIR_LOAD))
                    goto eligible;
            }

        default:            continue;
        }

        /* if the insn we're moving does not depend on the previous
           insn, swap them to put it first. then continue to the next
           previous. at each point, j+1 is the insn in motion, j is
           its predecessor. i remains the unchanged, ORIGINAL index
           of the insn in motion, used for deps interrogation. */

eligible:
        invalidated = 0;

        for (j = (i - 1); j >= 0; --j) {
            switch (INSN(b, j)->op)
            {
            default:            if (!deps(b, i, j))
                                    break;

            /* we don't cross insns, partly to avoid
               unnecessary reordering, but mostly to
               ensure this function terminates... */

            case I_LIR_CAST:
            case I_LIR_LOAD:
            case I_LIR_STORE:   goto next_i;
            }

            SWAP(struct insn *, INSN(b, j), INSN(b, j + 1));
            invalidated = 1;
        }

next_i:
        if (invalidated)        /* if we made any changes, */
            goto again;         /* we need to recheck deps */
    }
}

void opt_lir_delay(void)
{
    struct block *b;
    FOR_ALL_BLOCKS(b) delay0(b);
}

/* vi: set ts=4 expandtab: */
