/*****************************************************************************

  mbz.c                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "block.h"
#include "mbz.h"

/* SET/CLR set or clear the MBZ state of reg
   respectively; MBZ inquires if the reg is MBZ.

   these (obviously?) rely on the fact that all
   the GP regs of interest have indices <= 31. */

#define SET(mbz, reg)       ((mbz) |= (1 << REG_INDEX(reg)))
#define CLR(mbz, reg)       ((mbz) &= ~(1 << REG_INDEX(reg)))
#define MBZ(mbz, reg)       ((mbz) & (1 << REG_INDEX(reg)))

static VECTOR(reg) regs;

/* update the state of b->mbz according
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
        SET(b->mbz, dst);
    }

    TRUNC_VECTOR(regs);
    insn_defs(insn, &regs, 0);

    FOR_EACH_REG(regs, j, reg)
        if (reg != dst)
            CLR(b->mbz, reg);
}

/* compute meet: the intersection
   of all predecessors' states */

static void meet0(struct block *b)
{
    int n;

    b->mbz = 0;

    for (n = 0; n < NR_PREDS(b); ++n)
        if (n == 0)
            b->mbz = PRED(b, n)->mbz;
        else
            b->mbz &= PRED(b, n)->mbz;
}

/* iterative analysis. compute output state from input
   state transformed by insns in block. repeat if the
   output state is not the same as the last iteration */

static int mbz0(struct block *b)
{
    int old_mbz, i;

    old_mbz = b->mbz;
    meet0(b);

    for (i = 0; i < NR_INSNS(b); ++i)
        update0(b, i);

    if (b->mbz == old_mbz)
        return ITERATE_OK;
    else
        return ITERATE_AGAIN;
}

/* perform a final meet, and nuke unnecessary zero extensions. */

static int mbz1(struct block *b)
{
    struct insn *insn;
    int i;

    meet0(b);

    FOR_EACH_INSN(b, i, insn) {
        if ((insn->op == I_MCH_MOVL)
          && OPERAND_REG(&insn->operand[0])
          && OPERAND_REG(&insn->operand[1])
          && insn->operand[0].reg == insn->operand[1].reg
          && MBZ(b->mbz, insn->operand[1].reg))
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
   analysis to determine at which points the last write to a register
   must have cleared the upper 32 bits, and eliminate unnecessary zero
   extensions that follow.

   this pass runs on the MCH insns in a `destructive' final phase, and,
   in fact, is best run after OPT_MCH_LATE, as that pass shrinks ops to
   32-bit when possible, which opens up more opportunities here. */

void opt_mch_mbz(void)
{
    struct block *b;

    sequence_blocks(0);

restart:
    FOR_ALL_BLOCKS(b) b->mbz = 0;

    INIT_VECTOR(regs, &local_arena);
    iterate_blocks(mbz0);
    ARENA_FREE(&local_arena);

    live_analyze(LIVE_ANALYZE_REGS);
    INIT_VECTOR(regs, &local_arena);

    /* it is extremely conservative to restart the entire analysis
       on any change; probably overly conservative. rainy day. */

    FOR_ALL_BLOCKS(b)
        if (mbz1(b)) {
            ARENA_FREE(&local_arena);
            goto restart;
        }

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
