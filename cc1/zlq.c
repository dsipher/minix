/*****************************************************************************

   zlq.c                                               tahoe/64 c compiler

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

#include "cc1.h"
#include "block.h"
#include "zlq.h"

/* SET/CLR set or clear the ZLQ state of reg
   respectively; ZLQ inquires if the reg is ZLQ.

   these (obviously?) rely on the fact that all
   the GP regs of interest have indices <= 31. */

#define SET(zlq, reg)       ((zlq) |= (1 << REG_INDEX(reg)))
#define CLR(zlq, reg)       ((zlq) &= ~(1 << REG_INDEX(reg)))
#define ZLQ(zlq, reg)       ((zlq) & (1 << REG_INDEX(reg)))

static VECTOR(reg) regs;

/* update the state of b->zlq according
   to the actions of insn at index i */

static void update0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    int dst, j, reg;

    /* if the explicit destination reg of this insn
       is 32-bit, then we know its high bits have been
       reset. all other DEFs force us to invalidate. */

    dst = REG_NONE;

    if ((insn->op & I_FLAG_HAS_DST)
      && OPERAND_REG(&insn->operand[0])
      && (insn->operand[0].t & T_INTS))
    {
        dst = insn->operand[0].reg;
        SET(b->zlq, dst);
    }

    TRUNC_VECTOR(regs);
    insn_defs(insn, &regs, 0);

    FOR_EACH_REG(regs, j, reg)
        if (reg != dst)
            CLR(b->zlq, reg);
}

/* compute meet: the intersection
   of all predecessors' states */

static void meet0(struct block *b)
{
    int n;

    b->zlq = 0;

    for (n = 0; n < NR_PREDS(b); ++n)
        if (n == 0)
            b->zlq = PRED(b, n)->zlq;
        else
            b->zlq &= PRED(b, n)->zlq;
}

/* iterative analysis. compute output state from input
   state transformed by insns in block. repeat if the
   output state is not the same as the last iteration */

static int zlq0(struct block *b)
{
    int old_zlq, i;

    old_zlq = b->zlq;
    meet0(b);

    for (i = 0; i < NR_INSNS(b); ++i)
        update0(b, i);

    if (b->zlq == old_zlq)
        return ITERATE_OK;
    else
        return ITERATE_AGAIN;
}

/* perform a final meet, and nuke unnecessary zero extensions. */

static int zlq1(struct block *b)
{
    struct insn *insn;
    int i;

    meet0(b);

    FOR_EACH_INSN(b, i, insn) {
        if ((insn->op == I_MCH_MOVZLQ)
          && OPERAND_REG(&insn->operand[0])
          && OPERAND_REG(&insn->operand[1])
          && insn->operand[0].reg == insn->operand[1].reg
          && ZLQ(b->zlq, insn->operand[1].reg))
        {
            INSN(b, i) = &nop_insn;
            return 1;
        }

        update0(b, i);
    }

    return 0;
}

/* the AMD64 architecture automatically zeros bits[63:32] of a register
   when it is written to as a 32-bit operand. here we perform data-flow
   analysis to determine at which points the last write(s) to a register
   zeroed the upper bits, and use this to eliminate unnecessary MOVZLQs.

   by itself, this optimization yields only a modest benefit (we eliminate
   117 insns, ~0.2%, in the regression suite). ultimately, synergy between
   this pass and not-yet-written other transformations is the goal, e.g.:

        (1) we need to rewrite MOVSLQs as MOVZLQs when the value is
            known to be non-negative. the former are far more common,
            often arising from indexing arrays with ints.

        (2) the register allocator needs to recognize when a value and
            its sign-extended value can inhabit the same register and
            coalsece them accordingly.

   these two alone should yield many more removable MOVZLQ-self insns.

   this pass must run last, as we have no means of indicating a dependency
   on the _size_ of a previous write. if we try to interleave other passes
   they might pull the rug out from underneath us. on the bright side, this
   allows us to optimize for working on the small set of machine regs. */

void opt_mch_zlq(void)
{
    struct block *b;

    sequence_blocks(0);

restart:
    FOR_ALL_BLOCKS(b) b->zlq = 0;

    INIT_VECTOR(regs, &local_arena);
    iterate_blocks(zlq0);
    ARENA_FREE(&local_arena);

    live_analyze(LIVE_ANALYZE_REGS);
    INIT_VECTOR(regs, &local_arena);

    /* it is extremely conservative to restart the entire analysis
       on any change; probably completely unnecessary. rainy day. */

    FOR_ALL_BLOCKS(b)
        if (zlq1(b)) {
            ARENA_FREE(&local_arena);
            goto restart;
        }

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
