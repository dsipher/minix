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

/* we've encountered a zero-extension instruction, but the source
   operand is known to be zero-extended into bits [63:32] already.
   if the source and destination regs are the, this is easy: just
   nuke the MOVZLQ. if they are different, we attempt a localized
   copy propagation to eliminate all uses of the dst and so render
   the MOVZLQ useless. returns non-zero if any insns were altered. */

static int replace0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    int src = insn->operand[1].reg;
    int dst = insn->operand[0].reg;

    if (src != dst) {
        int src_r = range_by_use(b, src, i);
        int dst_r = range_by_def(b, dst, i);
        int src_span = range_span(b, src_r);
        int dst_span = range_span(b, dst_r);
        struct insn *use;
        int count;

        /* if the destination is live out of
           the block, then don't even try. */

        if (dst_span > INSN_INDEX_LAST)
            return 0;

        /* if the destination is DEFd in the last insn (the only
           possible insn, given the definition of a live range),
           then we won't be able to substitute it in general, as
           it may be an update operand (i.e., we can't replace it
           without overwriting the source), so we don't even try.
           this is conservative, since not every DEF involves an
           update operand, so we can loosen this test up in the
           future, if we think it would yield significant gains */

        TRUNC_VECTOR(regs);
        insn_defs(INSN(b, dst_span), &regs, 0);
        if (contains_reg(&regs, dst)) return 0;

        /* if the destination outlives the source, we can't safely
           substitute since its value may change before we're done.
           this, again, is conservative; if the source isn't DEFd
           again we *could* use it, but we'd extend its lifetime. */

        if (dst_span > src_span)
            return 0;

        /* okay, attempt to replace. we may still fail; it might be that
           a USE is inherent to the insn (e.g. REG_RAX in I_MCH_IDIVQ).
           if we only replace partway, we can't kill the MOVZLQ, but no
           harm done. we do need to track if we made any changes, though,
           because we will invalidate the live data in doing so, and the
           outer loop must be informed of this. */

        count = 0;

        while (NEXT_IN_RANGE(b, dst_r)) {
            ++dst_r;    /* skip the DEF itself */

            use = INSN(b, RANGE(b, dst_r).use);

            if (insn_substitute_reg(use, dst, src, INSN_SUBSTITUTE_USES, 0))
                ++count;

            /* if the insn claims to still use dst, then it
               is an inherent operand, and we've failed. */

            TRUNC_VECTOR(regs);
            insn_uses(use, &regs, 0);
            if (contains_reg(&regs, dst)) return count;
        }
    }

    /* if we get here, it means the dst register's live range has
       completely disappeared, and we can safely discard the MOVZLQ. */

    INSN(b, i) = &nop_insn;
    return 1;
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
          && MBZ(b->mbz, insn->operand[1].reg))
        {
            if (replace0(b, i))
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
