/*****************************************************************************

   hoist.c                                             tahoe/64 c compiler

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
#include "heap.h"
#include "reg.h"
#include "func.h"
#include "opt.h"
#include "hoist.h"

#define HOIST(b, n)     VECTOR_ELEM((b)->hoist.eval, (n))
#define NR_HOIST(b)     VECTOR_SIZE((b)->hoist.eval)

#define ADD_HOIST(b, i)                                                     \
    do {                                                                    \
        GROW_VECTOR((b)->hoist.eval, 1);                                    \
        VECTOR_LAST((b)->hoist.eval) = (i);                                 \
    } while (0)

static VECTOR(reg) defd_regs;       /* clobbered in current block */

static VECTOR(reg) tmp_regs;
static VECTOR(reg) tmp2_regs;

/* compute EVAL() for block b (in the terminology of muchnick
   13.5: the set of insns whose operands are not DEFd earlier
   in this block). we exclude volatile insns since they can
   never be moved, and consider only a limited number of ops. */

static void eval(struct block *b)
{
    struct insn *insn;
    int i;

    TRUNC_VECTOR(defd_regs);

    FOR_EACH_INSN(b, i, insn) {
        if (insn->is_volatile) goto ineligible;
        if (insn->was_hoisted) goto ineligible;

        switch (insn->op)
        {
        case I_LIR_FRAME:   /* all these insns have I_FLAG_HAS_DST, */
        case I_LIR_CAST:    /* so operand[0] is always a destination */
        case I_LIR_COM:     /* reg, and none of them USEs REG_CC. */
        case I_LIR_MOVE:
        case I_LIR_NEG:
        case I_LIR_ADD:
        case I_LIR_SUB:
        case I_LIR_MUL:
        case I_LIR_DIV:
        case I_LIR_MOD:
        case I_LIR_SHR:
        case I_LIR_SHL:
        case I_LIR_AND:
        case I_LIR_OR:
        case I_LIR_XOR:
        case I_LIR_BSF:
        case I_LIR_BSR:
        case I_LIR_LOAD:    break;

        default:            goto ineligible;
        }

        /* looks eligible; let's make sure its operands (or other
           dependencies) haven't been touched earlier in the block. */

        TRUNC_VECTOR(tmp_regs);
        TRUNC_VECTOR(tmp2_regs);

        insn_uses(insn, &tmp2_regs, I_FLAG_USES_MEM);
        intersect_regs(&tmp_regs, &tmp2_regs, &defd_regs);
        if (!EMPTY_VECTOR(tmp_regs)) goto ineligible;

        ADD_HOIST(b, &INSN(b, i));  /* eligible */

ineligible:
        insn_defs(insn, &defd_regs, I_FLAG_DEFS_MEM);
    }
}

/* scan the EVAL() set of block b to find an insn that matches insn.
   in this context, it means computes the same value into a register
   with the same or sympatico type. if found, b->hoist.match is set
   accordingly and returns true, otherwise returns false. */

static int match(struct block *b, struct insn *insn)
{
    struct insn *match;
    int insn_reg, match_reg;
    int i, same;

    for (i = 0; i < NR_HOIST(b); ++i) {
        match = *HOIST(b, i);

        /* the full comparison is pretty expensive,
           so eliminate common obvious cases first. */

        if (match->op != insn->op)
            continue;

        /* match_insn() requires total congruity, but we only
           need the same operands and destination type, so we
           force the destination to be the same (fake) O_REG
           in both insns. (we can assume the form of the isns
           because we're selective; see the switch in eval()).

           even this is overly conservative: we could settle
           for merely simpatico destination types, or even in
           many cases simpatico operand types, but since we
           are primarily cleaning up redundancy produced by
           the compiler itself, we'll usually match exactly */

        insn_reg = insn->operand[0].reg;
        match_reg = match->operand[0].reg;

        insn->operand[0].reg = REG_NONE;    /* illegal, of course, but */
        match->operand[0].reg = REG_NONE;   /* match_insn() won't care */
        same = same_insn(insn, match);

        insn->operand[0].reg = insn_reg;
        match->operand[0].reg = match_reg;

        if (same) {
            b->hoist.match = HOIST(b, i);
            return 1;
        }
    }

    return 0;
}

/* process a block. try to hoist from successors
   if appropriate, then compute the EVAL() set. */

static void hoist0(struct block *b)
{
    struct insn *insn;
    struct block *prime_b;
    struct block *succ_b;
    int index;
    int m, n;
    int tmp;

    /* first, determine if block b is properly qualified
       to host hoisted insns from its successors:

        1. b must have more than one successor (it follows that
           b must either be a switch block or conditional block)
        2. each successor must have exactly one predecessor (b). */

    if (NR_SUCCS(b) <= 1) goto out;

    for (n = 0; n < NR_SUCCS(b); ++n) {
        succ_b = SUCC(b, n).b;
        if (NR_PREDS(succ_b) != 1) goto out;
    }

    /* next, determine if we have a safe place to insert hoisted insns. by
       `safe', we mean where REG_CC isn't live, since most insns considered
       clobber it. if b is a switch block, we can simply insert at the end.
       if b is conditional, we require the I_LIR_CMP governing the branch be
       in b. as we backtrack to the I_LIR_CMP, we record any DEFs so we can
       be sure not to hoist any insn above the DEF(s) of its operands. */

    index = NEXT_INSN_INDEX(b);
    TRUNC_VECTOR(defd_regs);

    if (conditional_block(b)) {
        for (;;)
        {
            if (index == 0) goto out; /* I_LIR_CMP not present */

            --index;
            insn = INSN(b, index);
            insn_defs(insn, &defd_regs, I_FLAG_DEFS_MEM);
            if (insn->op == I_LIR_CMP) break; /* found it */
        }
    }

    /* okay, let's try to hoist. we pick one successor (prime_b)
       to be the baseline; it doesn't matter which we choose. */

    prime_b = SUCC(b, 0).b;

    for (m = 0; m < NR_HOIST(prime_b); ++m) {
        /* if this insn relies on registers (or memory) that are
           DEFd after the insertion point in b, it's a no-go. */

        prime_b->hoist.match = HOIST(prime_b, m);
        insn = *prime_b->hoist.match;

        TRUNC_VECTOR(tmp_regs);
        TRUNC_VECTOR(tmp2_regs);
        insn_uses(insn, &tmp2_regs, I_FLAG_USES_MEM);
        intersect_regs(&tmp_regs, &tmp2_regs, &defd_regs);
        if (!EMPTY_VECTOR(tmp_regs)) goto next;

        /* so far so good; now make sure that every successor
           has the same insn, modulo the destination reg. */

        for (n = 1; n < NR_SUCCS(b); ++n)
            if (!match(SUCC(b, n).b, insn))
                goto next;

        /* eligible for hoisting. at this point, every successor's
           hoist.match points to its insn which matches insn. */

        insn = dup_insn(insn);                  /* duplicate insn */
        tmp = temp_reg(insn->operand[0].t);     /* but compute into */
        insn->operand[0].reg = tmp;             /* a new temporary */
        insert_insn(insn, b, index);            /* and hoist into b */
        ++index;                                /* preserve insn order */

        /* now, replace the hoisted insn in every block with a copy
           operation from the new temporary. we mark the I_LIR_MOVE
           hoisted so we don't try to hoist it on a future pass. if
           it doesn't disappear in copy propagation, it is not only
           of no use to us in exposing new opportunities, but if we
           attempt to hoist it again, we'll loop forever w/OPT_LIR_PROP. */

        for (n = 0; n < NR_SUCCS(b); ++n) {
            succ_b = SUCC(b, n).b;

            insn = new_insn(I_LIR_MOVE, 0);
            insn->operand[0] = (*succ_b->hoist.match)->operand[0];
            insn->operand[1] = insn->operand[0];
            insn->operand[1].reg = tmp;
            insn->was_hoisted = 1;
            *succ_b->hoist.match = insn;
        }

        /* copy propagation now will likely expose more
           opportunities for another round of hoisting */

        opt_request |= OPT_LIR_PROP | OPT_LIR_HOIST;
next:   ;
    }

out:
    eval(b);
}

/* hoisting. if all the paths leaving a block b are going to evaluate an
   expression, it's better if we evaluate the expression once at the end
   of b and reference that result instead of recomputing it on each path.
   this reduces code size, but perhaps more importantly, it also exposes
   additional opportunities for dvn, further reducing the need for gcse.

   general implementations of hoisting are global optimizations (see e.g.
   muchnick 13.5) but we purposely restrict ours to extended basic blocks
   so we don't needlessly increase register pressure across loop bodies.

   we perform a forward post-order walk of the CFG. the criteria for
   qualified blocks in hoist0(), the nature of a post order, and our
   effective meet function (intersection), ensure that we process EBBs
   and EBBs only, bottom-up. hoisted insns bubble up to their earliest
   possible positions in a single pass but, like gcse, hoisting must be
   interleaved with OPT_LIR_PROP to handle chains of dependent insns. */

void opt_lir_hoist(void)
{
    struct block *b;

    INIT_VECTOR(defd_regs, &local_arena);
    INIT_VECTOR(tmp_regs, &local_arena);
    INIT_VECTOR(tmp2_regs, &local_arena);

    FOR_ALL_BLOCKS(b) INIT_VECTOR(b->hoist.eval, &local_arena);
    walk_blocks(0, 0, hoist0);

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
