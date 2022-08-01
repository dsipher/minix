/*****************************************************************************

   reassoc.c                                           tahoe/64 c compiler

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
#include "opt.h"
#include "reassoc.h"

/* probably nowhere else in a compiler is it more obvious that there are
   endless possibilities for improvement than in algebraic transformations.
   of course, endless possibilities translate into endless work; return on
   investment is a serious consideration here. as usual, we are primarily
   interested in improving sequences which arise with some frequency from
   'well-written' source code, not compensating for sloppy programming. */

/* returns true if op is one of the ops[] */

#define OP_ONE_OF(op, ops)                                                  \
    ({                                                                      \
        int _i;                                                             \
        int _ret = 0;                                                       \
                                                                            \
        for (_i = 0; (ops)[_i]; ++_i)                                       \
            if ((ops)[_i] == (op)) {                                        \
                _ret = 1;                                                   \
                break;                                                      \
            }                                                               \
                                                                            \
        (_ret);                                                             \
    })

/* returns insn index of the insn defining operand n if
   the operand (of insn i in block b) is an interior node
   of a tree. by this, we mean the operand:

        1. is a reg
        2. defined in this block
        3. by an operation in ops[]
        4. whose result (reg) has exactly one use

   when insn->op is I_LIR_SHR, we also require

        5. the type of reg must be the same as
           its defining operation's left operand

   to ensure we don't intermix logical and arithmetic shifts.
   returns INSN_INDEX_NONE if the operand does not qualify. */

static int interior(struct block *b, int i, int n, int *ops)
{
    struct insn *insn = INSN(b, i);
    long ts;
    int def;
    int reg;
    int r;

    if (!OPERAND_REG(&insn->operand[n]))
        return INSN_INDEX_NONE; /* #1 */

    if (insn->op == I_LIR_SHR)
        ts = T_BASE(insn->operand[n].t);
    else
        ts = T_ANY;

    reg = insn->operand[n].reg;
    r = range_by_use(b, reg, i);
    def = RANGE(b, r).def;

    if (def < INSN_INDEX_FIRST)
        return INSN_INDEX_NONE; /* #2 */

    insn = INSN(b, def);

    if (!OP_ONE_OF(insn->op, ops))
        return INSN_INDEX_NONE; /* #3 */

    if (range_use_count(b, r) != 1)
        return INSN_INDEX_NONE; /* #4 */

    if ((insn->operand[1].t & ts) == 0)
        return INSN_INDEX_NONE; /* #5 */

    return def;
}

/* once an insn has been included in a tree, it becomes ineligible
   for future inspection, since it would yield no further results */

static VECTOR(bitvec) ineligible;

/* constant operands are collected into the terms vector
   (obviously not the correct... term... for all operators) */

static VECTOR(operand) terms;

/* for additive operations, constant terms are adjusted for addition, i.e.,
   we rewrite the terms as if the ops were I_LIR_ADD. after rollup() sums
   them, the result might end up on the right side of the - operator (the
   minuend), in which case we need to negate it. this flags remind us. */

static int minuend;

/* once all constants are collected, they are 'rolled up', replacing all
   but one constant (the first) with the identity element appropriate to
   the operator. if any replacement is made, we request opt_norm(), which
   which will eliminate the leftover identity operations for us. */

static void rollup(int op)
{
    int i, j;

    for (j = (VECTOR_SIZE(terms) - 1); j >= 1; --j) {
        struct operand *left = VECTOR_ELEM(terms, j - 1);
        struct operand *right = VECTOR_ELEM(terms, j);

        switch (op)
        {
        case I_LIR_ADD: FOLD_BINARY(left->t, left, right, +); i = 0; break;
        case I_LIR_MUL: FOLD_BINARY(left->t, left, right, *); i = 1; break;
        case I_LIR_OR:  FOLD_BINARY_I(left->t, left, right, |); i = 0; break;
        case I_LIR_XOR: FOLD_BINARY_I(left->t, left, right, ^); i = 0; break;
        case I_LIR_AND: FOLD_BINARY_I(left->t, left, right, &); i = -1; break;
        }

        right->con.i = i;

        if (right->t & T_FLOATING)
            right->con.f = right->con.i;
        else
            normalize_con(right->t, &right->con);  /* important if i == -1 */

        normalize_con(left->t, &left->con);
        opt_request |= OPT_LIR_NORM;
    }

    if (VECTOR_SIZE(terms)) {
        struct operand *result = VECTOR_ELEM(terms, 0);

        /* normalization is unnecessary; the result is already
           normalized, and negating it will not denormalize it */

        if (minuend) FOLD_UNARY(result->t, result, -);
    }
}

/* addition and subtraction are handled together. as we descend the tree, we
   keep track of the sign needed and negate the constants as necessary. we
   put constant subtrahends at the head of the terms list because replacing
   them with zero does not eliminate them (0 - x = -x, i.e., it is negation).
   by placing them at the top, rollup() will target at least one of them for
   the final result; if there is only one such constant subtrahend, we win. */

#define ADDITIVE0(n, neg)                                                   \
    do {                                                                    \
        struct operand *_term = &insn->operand[n];                          \
        int _first;                                                         \
                                                                            \
        if (OPERAND_PURE_IMM(_term)) {                                      \
            if (neg) FOLD_UNARY(_term->t, _term, -);                        \
                                                                            \
            if ((n == 1) && (insn->op == I_LIR_SUB)) {                      \
                _first = 1;                                                 \
                VECTOR_INSERT(terms, 0, 1);                                 \
                VECTOR_ELEM(terms, 0) = _term;                              \
            } else {                                                        \
                _first = (VECTOR_SIZE(terms) == 0);                         \
                GROW_VECTOR(terms, 1);                                      \
                VECTOR_LAST(terms) = _term;                                 \
            }                                                               \
                                                                            \
            if (_first) minuend = neg;                                      \
        } else {                                                            \
            int _def = interior(b, i, n, ops);                              \
            if (_def != INSN_INDEX_NONE) additive0(b, _def, neg);           \
        }                                                                   \
    } while (0)

static void additive0(struct block *b, int i, int neg)
{
    static int ops[] = { I_LIR_ADD, I_LIR_SUB, 0 };
    struct insn *insn = INSN(b, i);
    int right_neg = insn->op == I_LIR_SUB ? (neg ^ 1) : neg;

    BITVEC_SET(ineligible, i);
    ADDITIVE0(1, neg);
    ADDITIVE0(2, right_neg);
}

/* typical associative/commutative binary operators are very simple. */

#define COMMUTATIVE0(n, op)                                                 \
    do {                                                                    \
        struct operand *_term = &insn->operand[n];                          \
                                                                            \
        if (OPERAND_PURE_IMM(_term)) {                                      \
            GROW_VECTOR(terms, 1);                                          \
            VECTOR_LAST(terms) = _term;                                     \
        } else {                                                            \
            int _def = interior(b, i, n, ops);                              \
            if (_def != INSN_INDEX_NONE) commutative0(b, _def, op);         \
        }                                                                   \
    } while (0)

static void commutative0(struct block *b, int i, int op)
{
    static int ops[] = { 0, 0 };
    struct insn *insn = INSN(b, i);

    ops[0] = op;
    BITVEC_SET(ineligible, i);
    COMMUTATIVE0(1, op);
    COMMUTATIVE0(2, op);
}

/* we can group the constants on the right side of shift
   operators. these 'trees' are really more like chains. */

static void shift0(struct block *b, int i, int op)
{
    static int ops[] = { 0, 0 };
    struct insn *insn = INSN(b, i);
    int def;

    ops[0] = op;
    BITVEC_SET(ineligible, i);
    def = interior(b, i, 1, ops);

    if (OPERAND_PURE_IMM(&insn->operand[2])) {
        GROW_VECTOR(terms, 1);
        VECTOR_LAST(terms) = &insn->operand[2];
    }

    if (def != INSN_INDEX_NONE) shift0(b, def, op);
}

/* reassociate to group constants, e.g.,

                        3 + a + 5 ---> a + 8

                        int b = 10;
                        3 + a + b ---> a + 13

   the front end will not fold the first because the constants
   are separated (and it does only the bare minimum to compute
   expressions needed for array bounds, initializers, etc.) it
   can't fold the second because it has no access to constants
   exposed by the optimizer (here, via constant propagation). */

static void constant0(struct block *b)
{
    int op;
    int i;

    RESIZE_BITVEC(ineligible, NR_INSNS(b));
    CLR_BITVEC(ineligible);

    for (i = NR_INSNS(b); i--; ) {
        if (BITVEC_IS_SET(ineligible, i))
            continue;

        minuend = 0;
        TRUNC_VECTOR(terms);

        switch (op = INSN(b, i)->op)
        {
        case I_LIR_ADD:
        case I_LIR_SUB:     additive0(b, i, 0);
                            rollup(I_LIR_ADD);
                            break;

        case I_LIR_MUL:
        case I_LIR_OR:
        case I_LIR_XOR:
        case I_LIR_AND:     commutative0(b, i, op);
                            rollup(op);
                            break;

        case I_LIR_SHR:
        case I_LIR_SHL:     shift0(b, i, op);
                            rollup(I_LIR_ADD);
                            break;
        }
    }
}

void opt_lir_reassoc(void)
{
    struct block *b;

    live_analyze(LIVE_ANALYZE_REGS);

    INIT_BITVEC(ineligible, &local_arena);
    INIT_VECTOR(terms, &local_arena);

    FOR_ALL_BLOCKS(b) constant0(b);

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
