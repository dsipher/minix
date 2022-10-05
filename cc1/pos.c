/*****************************************************************************

   pos.c                                               jewel/os c compiler

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
#include "insn.h"
#include "block.h"
#include "pos.h"

/* returns true if the operand is known to be
   non-negative in current state of block `b' */

static int is_pos(struct block *b, struct operand *o)
{
    if (OPERAND_PURE_IMM(o))
    {
        long mask = 0;

        switch (T_BASE(o->t))
        {
        case T_UCHAR:
        case T_SCHAR:
        case T_CHAR:        mask = 0x7F;
                            break;

        case T_USHORT:
        case T_SHORT:       mask = 0x7FFF;
                            break;

        case T_UINT:
        case T_INT:         mask = 0x7FFFFFFF;
                            break;
        }

        return (o->con.i & mask) == o->con.i;
    } else
        return OPERAND_REG(o)
               && BITVEC_IS_SET(b->pos.now.pos, REG_INDEX(o->reg));
}

/* returns true if the operand is undef */

static int is_undef(struct block *b, struct operand *o)
{
    return OPERAND_REG(o)
           && BITVEC_IS_CLR(b->pos.now.pos, REG_INDEX(o->reg))
           && BITVEC_IS_CLR(b->pos.now.neg, REG_INDEX(o->reg));
}

/* `reg' is known to be non-negative now in block `b' */

static void set_pos(struct block *b, int reg)
{
    BITVEC_SET(b->pos.now.pos, REG_INDEX(reg));
    BITVEC_CLR(b->pos.now.neg, REG_INDEX(reg));
}

/* now `reg' is undefined in block `b' */

static void set_undef(struct block *b, int reg)
{
    BITVEC_CLR(b->pos.now.pos, REG_INDEX(reg));
    BITVEC_CLR(b->pos.now.neg, REG_INDEX(reg));
}

/* now `reg' is not known to be non-negative in block `b' */

static void set_neg(struct block *b, int reg)
{
    BITVEC_CLR(b->pos.now.pos, REG_INDEX(reg));
    BITVEC_SET(b->pos.now.neg, REG_INDEX(reg));
}

/* allocate must-be-nonnegative
   per-block data for block `b' */

static void alloc0(struct block *b)
{
    INIT_BITVEC(b->pos.now.pos, &local_arena);
    INIT_BITVEC(b->pos.now.neg, &local_arena);
    INIT_BITVEC(b->pos.out.pos, &local_arena);
    INIT_BITVEC(b->pos.out.neg, &local_arena);

    RESIZE_BITVEC(b->pos.now.pos, nr_assigned_regs);
    RESIZE_BITVEC(b->pos.now.neg, nr_assigned_regs);
    RESIZE_BITVEC(b->pos.out.pos, nr_assigned_regs);
    RESIZE_BITVEC(b->pos.out.neg, nr_assigned_regs);

    CLR_BITVEC(b->pos.out.pos);
    CLR_BITVEC(b->pos.out.neg);
}

/* compute the meet for block `b' into `now':
   pos = (V(preds) pos) - neg, neg = V(preds) neg */

static void meet0(struct block *b)
{
    struct block *pred;
    int n;

    CLR_BITVEC(b->pos.now.pos);
    CLR_BITVEC(b->pos.now.neg);

    for (n = 0; n < NR_PREDS(b); ++n) {
        pred = PRED(b, n);

        if (n == 0) {
            DUP_VECTOR(b->pos.now.pos, pred->pos.out.pos);
            DUP_VECTOR(b->pos.now.neg, pred->pos.out.neg);
        } else {
            BITVEC_OR(b->pos.now.pos, pred->pos.out.pos);
            BITVEC_OR(b->pos.now.neg, pred->pos.out.neg);
        }
    }

    BITVEC_BIC(b->pos.now.pos, b->pos.now.neg);
}

/* perform a stepwise update of `now' in
   `b' based on the effects of `insn'. */

static VECTOR(reg) tmp_regs;

static void update0(struct block *b, struct insn *insn)
{
    void (*set)(struct block *b, int reg) = set_neg;
    int reg, j;

    /* decide if the result of this insn must be non-negative. */

    switch (insn->op)
    {
    case I_LIR_CAST:    /* casting an unsigned integer to a larger
                           integer always yields non-negative value */

                        if ((insn->operand[1].t & T_UNSIGNED)
                          && (insn->operand[0].t & T_INTEGRAL)
                          && (t_size(insn->operand[1].t) <
                              t_size(insn->operand[0].t)))
                        {
                            set = set_pos;
                        }

                        /* casting a non-negative integer to a larger
                           integer always yields non-negative value */

                        if (is_pos(b, &insn->operand[1])
                          && (insn->operand[0].t & T_INTEGRAL)
                          && (t_size(insn->operand[1].t) <
                              t_size(insn->operand[0].t)))
                        {
                            set = set_pos;
                        }

                        break;

    case I_LIR_SHR:     /* a right shift of an unsigned type
                           always shifts a zero into the sign... */

                        if (insn->operand[1].t & T_UNSIGNED)
                            set = set_pos;

                        /* FALLTHRU: a right shift of a
                           non-negative value is non-negative */

    case I_LIR_MOVE:    if (is_pos(b, &insn->operand[1]))
                            set = set_pos;

                        break;

        /* per the Standard, we can assume the result of
           adding, multiplying, or left-shifting signed
           non-negative integers is non-negative. this is
           very useful to the compiler, but is an abuse of
           undefined behavior, so they require the -O flag */

    case I_LIR_SHL:     if (is_pos(b, &insn->operand[1])
                          && (insn->operand[1].t & T_SIGNED)
                          && O_flag)
                        {
                            set = set_pos;
                        }

                        break;

    case I_LIR_ADD:
    case I_LIR_MUL:     if (!(insn->operand[1].t & T_SIGNED)
                          || !(insn->operand[2].t & T_SIGNED)
                          || !O_flag)
                        {
                            break;
                        }

                        /* FALLTHRU */

    case I_LIR_MOD:
    case I_LIR_DIV:
    case I_LIR_XOR:
    case I_LIR_OR:      /* if both operands are non-negative
                           then the result will be too. */

                        if ( is_pos(b, &insn->operand[1])
                          && is_pos(b, &insn->operand[2]))
                            set = set_pos;

                        break;

    case I_LIR_AND:     /* if either operand of I_LIR_AND is known
                           to be non-negative then the sign bit of
                           the result will always be masked off. */

                        if ( is_pos(b, &insn->operand[1])
                          || is_pos(b, &insn->operand[2]))
                            set = set_pos;

                        break;

    }

    /* decide if the result of this insn is undef.

       it is not immediately obvious, but these conditions
       are mutually exclusive of the conditions in the above
       switch, so we don't overwrite the former's results */

    switch (insn->op)
    {
    case I_LIR_SHL:
    case I_LIR_SHR:
    case I_LIR_CAST:
    case I_LIR_MOVE:    if (is_undef(b, &insn->operand[1]))
                            set = set_undef;

                        break;

    case I_LIR_ADD:
    case I_LIR_MUL:
    case I_LIR_MOD:
    case I_LIR_DIV:
    case I_LIR_XOR:
    case I_LIR_OR:
    case I_LIR_AND:     if (is_undef(b, &insn->operand[1])
                          || is_undef(b, &insn->operand[2]))
                            set = set_undef;

                        break;
    }

    /* update the state of the registers defined by this
       insn; `set' will be one of `set_undef', `set_pos'
       or `set_neg' due to the filtering switches above */

    TRUNC_VECTOR(tmp_regs);
    insn_defs(insn, &tmp_regs, 0);

    FOR_EACH_REG(tmp_regs, j, reg)
        set(b, reg);
}

/* iterative analysis, meet, analyze block. as
    usual, convergence when out state unchanged */

static int analyze0(struct block *b)
{
    struct insn *insn;
    int i;

    meet0(b);
    FOR_EACH_INSN(b, i, insn) update0(b, insn);

    if (SAME_BITVEC(b->pos.now.pos, b->pos.out.pos)
      && SAME_BITVEC(b->pos.now.neg, b->pos.out.neg))
        return ITERATE_OK;
    else {
        SWAP(struct pos_state, b->pos.now, b->pos.out);
        return ITERATE_AGAIN;
    }
}

/* look for I_LIR_CASTs of signed integers that are
   known to be non-negative, and rewrite the signed
   type as its unsigned counterpart. */

static void recast0(struct block *b)
{
    struct insn *insn;
    int i;

    meet0(b);

    FOR_EACH_INSN(b, i, insn)
    {
        if ( (insn->op == I_LIR_CAST)
          && (insn->operand[1].t & T_SIGNED)
          && is_pos(b, &insn->operand[1]))
            insn->operand[1].t = t_unsigned(insn->operand[1].t);

        update0(b, insn);
    }
}

/* we want to convert sign extensions to zero extensions where
   possible, because the ATOM is biased towards zero extensions:
   in particular, zero extensions of an int to a long can often
   be skipped altogether. this pass is really part of a two-pass
   sequence. we convert sign extensions to zero extensions here,
   and then OPT_MCH_ZLQs eliminates unnecessary zero extensions. */

void opt_lir_pos(void)
{
    struct block *b;

    INIT_VECTOR(tmp_regs, &local_arena);
    FOR_ALL_BLOCKS(b) alloc0(b);
    iterate_blocks(analyze0);
    FOR_ALL_BLOCKS(b) recast0(b);
}

/* vi: set ts=4 expandtab: */
