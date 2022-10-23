/*****************************************************************************

   cmov.c                                                 ux/64 c compiler

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
#include "func.h"
#include "lower.h"
#include "opt.h"
#include "cmov.h"

/* if op is a MOVx, return the corresponding CMOVccx
   for that op and the given condition. otherwise 0. */

static int map0(int op, int cc)
{
    switch (op)
    {
    case I_MCH_MOVB:
    case I_MCH_MOVW:
    case I_MCH_MOVL:    return I_CC_TO_MCH_CMOVCCL(cc);
    case I_MCH_MOVQ:    return I_CC_TO_MCH_CMOVCCQ(cc);

    default:            return 0;
    }
}

/* return a reg holding the value of the operand. if the
   operand is already in a reg, use that. otherwise, it
   must be a constant, so create a temp reg and load it
   by issuing an insn in block b. for the time being we
   place the load at the end of block b, though it might
   be better placed a bit earlier. rainy day. */

static int regify0(struct block *b, struct operand *o)
{
    int reg;

    if (OPERAND_REG(o))
        reg = o->reg;
    else {
        struct operand tmp;

        reg = temp_reg(o->t);
        REG_TO_SYMBOL(reg)->s |= S_NOSPILL;
        REG_OPERAND(&tmp, 0, 0, reg);
        append_insn(move(o->t, &tmp, o), b);
    }

    return reg;
}

/* simple helper to append

        op %src, %dst

   to the end of block b. */

static void docmov0(struct block *b, int op, int dst, int src)
{
    struct insn *new;

    new = new_insn(op, 0);
    REG_OPERAND(&new->operand[0], 0, 0, dst);
    REG_OPERAND(&new->operand[1], 0, 0, src);
    append_insn(new, b);
}

/* look for a one-legged conditional move and rewrite
   as a CMOV. returns true on success, false otherwise.

            CMP ......      ->          CMP ......
            ....                        ....
            Jcc join                    [ MOV ...., %tmp ]
   leg:     MOV ...., %dst              CMOVcc %tmp, %dst
   join:    .....                 join: .....

   the CMP is really any prior insn that sets the flags inspected.

   if the value conditionally moved into %dst is an immediate,
   it must be loaded into a temp reg first. this is simply a
   limitation of the ATOM CMOVcc insns. such a temp is marked
   not spillable [see regify0()] since spilling it is unwise,
   not to mention pointless.

   even with the possible increased (though temporary) register
   pressure, this is almost always a win, because the replaced
   branch is usually not well-predicted. even when it would be,
   the CMOV isn't ridiculously expensive in its stead. */

static int oneleg0(struct block *b, int n)
{
    struct block *leg;
    struct block *join;
    struct insn *leg_insn;

    int m = n ^ 1;      /* the other successor */

    if (conditional_block(b)
      && (NR_SUCCS(b) == 2)
      && (join = unconditional_succ(leg = SUCC(b, n).b))
      && (join == SUCC(b, m).b)
      && (NR_PREDS(leg) == 1)
      && (NR_INSNS(leg) == 1)
      && map0((leg_insn = INSN(leg, 0))->op, 0)
      && OPERAND_REG(&leg_insn->operand[0])
      && !OPERAND_MEM(&leg_insn->operand[1]))
    {
        int op = map0(leg_insn->op, SUCC(b, n).cc);
        int dst = leg_insn->operand[0].reg;
        int src = regify0(b, &leg_insn->operand[1]);

        docmov0(b, op, dst, src);

        remove_succs(b);
        add_succ(b, CC_ALWAYS, join);

        return 1;
    }

    return 0;
}

/* a simple extension of the one-legged move. here we look
   for a two-legged or diamond pattern:

            CMP ......          ->      CMP ......
            Jcc true                    [ MOV TTTT, %tmp ]
   false:   MOV FFFF, %dst              MOV FFFF, %dst
            jmp join                    CMOVcc TTTT, %dst
   true:    MOV TTTT, %dst
   join:    .......                     ........

   again, the bracketed move is not required unless TTTT
   is not immediate, and again, we usually win even with
   the added register pressure. */

static int twoleg0(struct block *b)
{
    struct block *true_b;
    struct block *true_succ_b;
    struct insn *true_insn;

    struct block *false_b;
    struct block *false_succ_b;
    struct insn *false_insn;

    if (conditional_block(b)
      && (NR_SUCCS(b) == 2)
      && (true_succ_b = unconditional_succ(true_b = SUCC(b, 0).b))
      && (false_succ_b = unconditional_succ(false_b = SUCC(b, 1).b))
      && (true_succ_b == false_succ_b)
      && (NR_PREDS(true_b) == 1) && (NR_PREDS(false_b) == 1)
      && (NR_INSNS(true_b) == 1) && (NR_INSNS(false_b) == 1)
      && map0((true_insn = INSN(true_b, 0))->op, 0)
      && ((false_insn = INSN(false_b, 0))->op == true_insn->op)
      && OPERAND_REG(&true_insn->operand[0])
      && OPERAND_REG(&false_insn->operand[0])
      && !OPERAND_MEM(&true_insn->operand[1])
      && !OPERAND_MEM(&false_insn->operand[1])
      && (true_insn->operand[0].reg == false_insn->operand[0].reg))
    {
        struct operand true = true_insn->operand[1];
        struct operand false = false_insn->operand[1];
        struct operand dst = true_insn->operand[0];
        int dst_reg = true_insn->operand[0].reg;
        int cc = SUCC(b, 0).cc;
        int true_reg;
        int op;

        if (OPERAND_REG(&false) && !OPERAND_REG(&true)) {
            /* false is already in a reg; we can avoid the
               following load by simply inverting the sense. */

            cc = INVERT_CC(cc);
            SWAP(struct operand, true, false);
        }

        op = map0(true_insn->op, cc);

        /* pathological case. if the true value is the destination's
           original value, our sequence will clobber it when loading
           the false value. (it's really one-legged in that case.)
           OPT_PRUNE normally eliminates these before we get here. */

        if (OPERAND_REG(&true) && (true.reg == dst_reg)) return 0;

        /* here we go: load the true value into a temp reg, if needed,
           then preload the false value, and finally overwrite with the
           true value if the condition is indeed true.

           long-winded, but typically better than a misprediction penalty. */

        true_reg = regify0(b, &true);           /* [MOVx <true>, %true_reg] */
        append_insn(move(dst.t, &dst, &false), b);    /* MOVx <false>, %dst */
        docmov0(b, op, dst_reg, true_reg);        /* CMOVccx %true_reg,%dst */

        remove_succs(b);
        add_succ(b, CC_ALWAYS, true_succ_b);
        return 1;
    }

    return 0;
}

/* in this pass, we try to replace simple triangle (one-legged) or diamond
   (two-legged) CFG figures with conditional moves. see oneleg0()/twoleg0()
   above for specifics.

   this pass typically runs exactly once, in the first optimization run after
   lowering. we don't want to run iteratively during register allocation, for
   two reasons:

        1. we allocate temporaries, which would be spitting in
           the face of an allocator which is trying to spill, and
        2. we probably wouldn't have new opportunities anyway.

   we run this pass on MCH code. this is a deliberate decision as it is a
   kind of architectural optimization rather than a general one. putting
   conditional moves in LIR adds baggage to the front end with little (if
   any) benefit.

   there are size violations here. ATOM doesn't have CMOVcc in all sizes
   (byte is missing). this is of little consequence, since we deliberately
   avoid fusing, our temporaries are marked not spillable, and we always
   oversize (rather than under, which is where we get into serious trouble
   with the spill code). we use 32-bit CMOVcc for all sub-int types, and
   64-bit for the others; 16-bit CMOVcc exists but has no value w/o fusing.

   we do not permit fusing of CMOVcc operations, because ATOM may read
   the source operand whether the condition is true or not; we obviously
   should not make a conditional memory read suddenly unconditional. */

void opt_mch_cmov(void)
{
    struct block *b;

restart:
    FOR_ALL_BLOCKS(b)
        if (oneleg0(b, 0) || oneleg0(b, 1) || twoleg0(b)) {
            opt_request |= OPT_PRUNE;
            goto restart;
        }
}

/* vi: set ts=4 expandtab: */
