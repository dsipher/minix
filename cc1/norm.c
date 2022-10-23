/*****************************************************************************

   norm.c                                                 ux/64 c compiler

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
#include "live.h"
#include "opt.h"
#include "heap.h"
#include "norm.h"

/* replace insn with a left shift by 1. this is only used to replace integer
   addition when adding a reg to itself. this isn't a better choice; the sole
   value of this replacement is normalization, and even that is dubious, but
   we do this so (a + a, a * 2, a << 1) are easily identified as equivalent */

static struct insn *shl1(struct insn *insn, int dummy)
{
    insn->op = I_LIR_SHL;
    I_OPERAND(&insn->operand[2], 0, T_CHAR, 1);
    return insn;
}

/* unsigned mod by a power of 2 is replaced
   with the equivalent mask operation */

static struct insn *mod2(struct insn *insn, int dummy)
{
    insn->op = I_LIR_AND;
    --(insn->operand[2].con.u);
    return insn;
}

/* division or multiplication by a power of 2 is
   replaced by a left or right shift (given by op) */

struct insn *pow2(struct insn *insn, int op)
{
    insn->op = op;
    I_OPERAND(&insn->operand[2], 0, T_CHAR,
              CTZ(insn->operand[2].con.u));

    return insn;
}

/* operand templates for the right operand in norms[] table.
   some double as the replace arguments to a handler function. */

#define NORM_REG            0       /* reg (if right, must be same as left) */
#define NORM_ZERO           1       /* 0 or 0.0 */
#define NORM_ONE            2       /* 1 or 1.0 */
#define NORM_POW2           3       /* constant power of 2 */
#define NORM_ALL1           4       /* all 1 bits */
#define NORM_ANY            5       /* any operand */

/* render the insn dst a copy of the left operand or a constant, depending on
   the value of replace. whenever this happens, there's a chance the previous
   operand(s) are now dead, so we signal that; we also signal copy or constant
   propagation (depending on what we assign, of course) */

static struct insn *move0(struct insn *insn, int replace)
{
    struct insn *new;

    opt_request |= OPT_DEAD;

    new = new_insn(I_LIR_MOVE, 0);
    new->operand[0] = insn->operand[0];
    new->operand[1] = insn->operand[1];

    switch (replace)
    {
    case NORM_REG:      opt_request |= OPT_LIR_PROP;
                        return new;

    case NORM_ZERO:     I_OPERAND(&new->operand[1], 0, 0, 0); break;
    case NORM_ONE:      I_OPERAND(&new->operand[1], 0, 0, 1); break;
    }

    if (new->operand[0].t & T_FLOATING)
        new->operand[1].con.f = new->operand[1].con.i;

    opt_request |= OPT_LIR_FOLD | OPT_LIR_REASSOC;
    return new;
}

/* order of the template entries is important in three respects. first,
   all entries for a given op must be contiguous, because the matching
   logic in norm() expects this. second, the first matched template is
   used, so, for example, right == NORM_REG entries should appear after
   after any NORM_ZERO or NORM_ONE entries for any op, otherwise a reg
   which is known constant will be missed. finally, more frequent ops
   should appear earlier in the table. (this is a really minor point.)

   it is a rule of LIR that the antecedent of any USE of REG_CC is
   an I_LIR_CMP; other DEFs of REG_CC are treated as clobbers, not
   providing useful information. as such we can replace insns which
   DEF REG_CC with any other insns without regard to how they affect
   the flags, but the converse is not true: if REG_CC is live across
   an insn we can't clobber REG_CC. we do not check for this currently
   since we have no need to (no transformations would do this) but it
   is important to remember for future additions to the table.

   as usual, we play fast-and-loose with floating-point here in ways that
   might offend purists. we can fix by being more conservative if needed. */

struct {
    long ts;                                    /* T_*; type of operand[1] */
    int op;                                     /* I_LIR_* */
    char left;                                  /* NORM_*: operand[1] */
    char right;                                 /* NORM_*: operand[2] */
    int arg;                                    /* arg for handler */
    struct insn *(*f)(struct insn *, int);      /* replacement handler */
} norms[] = {
    T_ANY,      I_LIR_ADD,  NORM_REG,   NORM_ZERO,  NORM_REG,   move0,
    T_INTEGRAL, I_LIR_ADD,  NORM_REG,   NORM_REG,   0,          shl1,
    T_ANY,      I_LIR_SUB,  NORM_REG,   NORM_ZERO,  NORM_REG,   move0,
    T_ANY,      I_LIR_SUB,  NORM_REG,   NORM_REG,   NORM_ZERO,  move0,
    T_ANY,      I_LIR_MUL,  NORM_REG,   NORM_ZERO,  NORM_ZERO,  move0,
    T_ANY,      I_LIR_MUL,  NORM_REG,   NORM_ONE,   NORM_REG,   move0,
    T_INTEGRAL, I_LIR_MUL,  NORM_REG,   NORM_POW2,  I_LIR_SHL,  pow2,
    T_INTEGRAL, I_LIR_MOD,  NORM_REG,   NORM_ONE,   NORM_ZERO,  move0,
    T_INTEGRAL, I_LIR_MOD,  NORM_REG,   NORM_REG,   NORM_ZERO,  move0,
    T_UNSIGNED, I_LIR_MOD,  NORM_REG,   NORM_POW2,  0,          mod2,
    T_ANY,      I_LIR_DIV,  NORM_REG,   NORM_ONE,   NORM_REG,   move0,
    T_ANY,      I_LIR_DIV,  NORM_REG,   NORM_REG,   NORM_ONE,   move0,
    T_UNSIGNED, I_LIR_DIV,  NORM_REG,   NORM_POW2,  I_LIR_SHR,  pow2,
    T_INTEGRAL, I_LIR_AND,  NORM_REG,   NORM_ZERO,  NORM_ZERO,  move0,
    T_INTEGRAL, I_LIR_AND,  NORM_REG,   NORM_REG,   NORM_REG,   move0,
    T_INTEGRAL, I_LIR_AND,  NORM_REG,   NORM_ALL1,  NORM_REG,   move0,
    T_INTEGRAL, I_LIR_OR,   NORM_REG,   NORM_ZERO,  NORM_REG,   move0,
    T_INTEGRAL, I_LIR_OR,   NORM_REG,   NORM_REG,   NORM_REG,   move0,
    T_INTEGRAL, I_LIR_XOR,  NORM_REG,   NORM_ZERO,  NORM_REG,   move0,
    T_INTEGRAL, I_LIR_XOR,  NORM_REG,   NORM_REG,   NORM_ZERO,  move0,
    T_INTEGRAL, I_LIR_SHL,  NORM_ZERO,  NORM_ANY,   NORM_ZERO,  move0,
    T_INTEGRAL, I_LIR_SHL,  NORM_REG,   NORM_ZERO,  NORM_REG,   move0,
    T_INTEGRAL, I_LIR_SHR,  NORM_ZERO,  NORM_ANY,   NORM_ZERO,  move0,
    T_INTEGRAL, I_LIR_SHR,  NORM_REG,   NORM_ZERO,  NORM_REG,   move0
};

static VECTOR(bitvec) norm_0s;      /* registers known to be constant 0 */
static VECTOR(bitvec) norm_1s;      /* registers known to be constant 1 */

#define IS0(reg)    BITVEC_IS_SET(norm_0s, REG_INDEX(reg))
#define IS1(reg)    BITVEC_IS_SET(norm_1s, REG_INDEX(reg))
#define CLR0(reg)   BITVEC_CLR(norm_0s, REG_INDEX(reg))
#define CLR1(reg)   BITVEC_CLR(norm_1s, REG_INDEX(reg))
#define SET0(reg)   BITVEC_SET(norm_0s, REG_INDEX(reg))
#define SET1(reg)   BITVEC_SET(norm_1s, REG_INDEX(reg))

static VECTOR(reg) norm_regs;

/* algebraic simplification and normalization. we replace algebraic
   identities (a + 0 = a) to eliminate operations where possible,
   perform the usual strength reductions where integer mul/div/mod
   with powers of 2 are concerned, and otherwise normalize insns so
   later passes need to concern themselves detecting equivalents.

   we do a limited form of local constant propagation (for constants
   zero and one), to avoid bouncing back and forth with the fold pass
   when the effects ripple through an expression, e.g.,:

                    0 * a_1 * a_2 * a_3 * .... * a_n

   would require (a_n - 1) passes to resolve without local propagation. */

static void norm(struct block *b)
{
    struct insn *insn;
    int src, dst;
    int i, j;

    CLR_BITVEC(norm_0s);
    CLR_BITVEC(norm_1s);

    FOR_EACH_INSN(b, i, insn) {
        if (I_LIR_BINARY(insn->op)) {
            for (j = 0; j < ARRAY_SIZE(norms); ++j)
                if (norms[j].op == insn->op) break;

            if (OPERAND_REG(&insn->operand[2]))  /* puts reg on left and */
                commute_insn(insn);              /* any constant on right */

            for (; (j < ARRAY_SIZE(norms)) && (norms[j].op == insn->op); ++j)
            {
                if ((insn->operand[1].t & norms[j].ts) == 0) continue;

                if ((norms[j].left == NORM_REG) &&      /* match left */
                  !OPERAND_REG(&insn->operand[1]))
                    continue;

                if ((norms[j].left == NORM_ZERO) &&
                  !OPERAND_ZERO(&insn->operand[1])
                  && !(OPERAND_REG(&insn->operand[1])
                  && IS0(insn->operand[1].reg)))
                    continue;

                switch (norms[j].right)                 /* match right */
                {
                case NORM_REG:
                    if (OPERAND_REG(&insn->operand[2])
                      && (insn->operand[1].reg == insn->operand[2].reg))
                        break; else continue;

                case NORM_ZERO:
                    if (OPERAND_ZERO(&insn->operand[2])
                      || (OPERAND_REG(&insn->operand[2])
                      && IS0(insn->operand[2].reg)))
                        break; else continue;

                case NORM_ONE:
                    if (OPERAND_ONE(&insn->operand[2])
                      || (OPERAND_REG(&insn->operand[2])
                      && IS1(insn->operand[2].reg)))
                        break; else continue;

                case NORM_POW2:
                    if (OPERAND_PURE_IMM(&insn->operand[2])
                      && POW2(insn->operand[2].con.u))
                        break; else continue;

                case NORM_ALL1:
                    if (OPERAND_PURE_IMM(&insn->operand[2])) {
                        union con con;
                        con.i = -1;
                        normalize_con(insn->operand[2].t, &con);
                        if (insn->operand[2].con.i == con.i) break;
                    }

                    continue;

                case NORM_ANY: /* matches everything */ break;
                }

                insn = (norms[j].f)(insn, norms[j].arg);
                INSN(b, i) = insn;
                goto next_insn;
            }
        }

next_insn:
        if (insn_is_copy(insn, &dst, &src)) {
            if (IS0(src)) SET0(dst); else CLR0(dst);
            if (IS1(src)) SET1(dst); else CLR1(dst);
        } else if (insn->op == I_LIR_MOVE) {
            dst = insn->operand[0].reg;
            if (OPERAND_ZERO(&insn->operand[1])) SET0(dst); else CLR0(dst);
            if (OPERAND_ONE(&insn->operand[1])) SET1(dst); else CLR1(dst);
        } else {
            TRUNC_VECTOR(norm_regs);
            insn_defs(insn, &norm_regs, 0);
            FOR_EACH_REG(norm_regs, j, dst) { CLR0(dst); CLR1(dst); }
        }
    }
}

/* normalize I_LIR_CMP operations. comparisons are _almost_ commutative:
   we can swap the operands if we invert some of the dependent conditions.
   normalizing by swapping exposes some opportunities:

                        for example,    (a > b) || (b > a)
                    can be rewritten    (a > b) || (a < b)

   resulting in a duplicate I_LIR_CMP <b>, <a> which OPT_LIR_CMP can elide,
   and, after pruning and such, optimize down to its equivalent (a != b).

   this is a local `optimization' only. if the result of a comparison is
   live out, it would take a LOT of work to find the corresponding USEs.
   luckily, REG_CC isn't live across blocks until OPT_LIR_CMP has made it
   so, and by then we will have exploited most (if not all) opportunities. */

static void cmp(struct block *b)
{
    struct insn *insn;
    int i, r, cc;

    FOR_EACH_INSN(b, i, insn) {
        if (insn->op != I_LIR_CMP) continue;
        r = range_by_def(b, REG_CC, i);

        if (range_span(b, r) > INSN_INDEX_BRANCH)
            continue;   /* it's live out, skip it */

        if (OPERAND_IMM(&insn->operand[0]) && OPERAND_IMM(&insn->operand[1]))
            continue;   /* leave this for opt_fold() */

        if (OPERAND_REG(&insn->operand[0]) && OPERAND_REG(&insn->operand[1])
          && REG_PRECEDES(insn->operand[0].reg, insn->operand[1].reg))
            continue;   /* reg operands in order, already normalized */

        if (OPERAND_IMM(&insn->operand[1]))
            continue;   /* constant on the right, already normalized */

        SWAP(struct operand, insn->operand[0], insn->operand[1]);

        while (NEXT_IN_RANGE(b, r)) {
            ++r;    /* pre-increment skips the range head */

            if (RANGE(b, r).use == INSN_INDEX_BRANCH)
                commute_succs(b);
            else {
                /* the only insns possibly dependent
                   on REG_CC in LIR are I_LIR_SETcc */

                insn = INSN(b, RANGE(b, r).use);
                cc = I_LIR_SETCC_TO_CC(insn->op);
                cc = commuted_cc[cc];
                insn->op = I_CC_TO_LIR_SETCC(cc);
            }
        }
    }
}

void opt_lir_norm(void)
{
    struct block *b;

    live_analyze(LIVE_ANALYZE_CC);

    INIT_VECTOR(norm_regs, &local_arena);
    INIT_BITVEC(norm_0s, &local_arena);
    INIT_BITVEC(norm_1s, &local_arena);
    RESIZE_BITVEC(norm_0s, nr_assigned_regs);
    RESIZE_BITVEC(norm_1s, nr_assigned_regs);

    FOR_ALL_BLOCKS(b) cmp(b);
    FOR_ALL_BLOCKS(b) norm(b);

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
