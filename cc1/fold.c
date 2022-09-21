/*****************************************************************************

   fold.c                                              jewel/os c compiler

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

#include <limits.h>
#include "cc1.h"
#include "block.h"
#include "heap.h"
#include "type.h"
#include "opt.h"
#include "fold.h"


void normalize_con(long t, union con *conp)
{
    switch (T_BASE(t))
    {
        case T_CHAR:
        case T_SCHAR:   conp->i = (char) conp->i; break;
        case T_UCHAR:   conp->i = (unsigned char) conp->i; break;
        case T_SHORT:   conp->i = (short) conp->i; break;
        case T_USHORT:  conp->i = (unsigned short) conp->i; break;
        case T_INT:     conp->i = (int) conp->i; break;
        case T_UINT:    conp->i = (unsigned) conp->i; break;
    }
}

int con_in_range(long t, union con *conp)
{
    switch (T_BASE(t))
    {
    case T_CHAR:
    case T_SCHAR:   return (conp->i >= SCHAR_MIN) && (conp->i <= SCHAR_MAX);
    case T_SHORT:   return (conp->i >= SHRT_MIN) && (conp->i <= SHRT_MAX);
    case T_INT:     return (conp->i >= INT_MIN) && (conp->i <= INT_MAX);

    case T_UCHAR:   return (conp->i >= 0) && (conp->i <= UCHAR_MAX);
    case T_USHORT:  return (conp->i >= 0) && (conp->i <= USHRT_MAX);
    case T_UINT:    return (conp->i >= 0) && (conp->i <= UINT_MAX);

    default:        return 1;   /* longs are always 'in range' */
    }
}

int cast_con(long to_t, long from_t, union con *conp, int pure)
{
    if (T_CAST_CLASS(to_t) == T_CAST_CLASS(from_t))
        /* no conversion required, normalization will suffice */ ;
    else if (to_t & T_FLOATING) {
        /* discrete -> float. we can't fold this if the discrete
           value references an assembler symbol (nonsense anyway) */

        if (!pure) return 0;

        if (from_t & T_SIGNED)
            conp->f = conp->i;
        else
            conp->f = conp->u;
    } else {
        /* float -> discrete. as we always refuse to create
           an impure float, no need to account for that */

        if (to_t & T_SIGNED)
            conp->i = conp->f;
        else
            conp->u = conp->f;
    }

    return 1;
}

/* compare two constants and return the ccset of the condition codes.
   there are two sets of codes (signed vs. unsigned/floating-point) */

#define CMP_CONS0_S(MEMB)                                                   \
    do {                                                                    \
        if (left->con.MEMB == right->con.MEMB) {                            \
            CCSET_SET(ccs, CC_GE);                                          \
            CCSET_SET(ccs, CC_LE);                                          \
            CCSET_SET(ccs, CC_Z);                                           \
        }                                                                   \
                                                                            \
        if (left->con.MEMB > right->con.MEMB) {                             \
            CCSET_SET(ccs, CC_G);                                           \
            CCSET_SET(ccs, CC_GE);                                          \
            CCSET_SET(ccs, CC_NZ);                                          \
        }                                                                   \
                                                                            \
        if (left->con.MEMB < right->con.MEMB) {                             \
            CCSET_SET(ccs, CC_L);                                           \
            CCSET_SET(ccs, CC_LE);                                          \
            CCSET_SET(ccs, CC_NZ);                                          \
        }                                                                   \
    } while (0)

#define CMP_CONS0_U(MEMB)                                                   \
    do {                                                                    \
        if (left->con.MEMB == right->con.MEMB) {                            \
            CCSET_SET(ccs, CC_AE);                                          \
            CCSET_SET(ccs, CC_BE);                                          \
            CCSET_SET(ccs, CC_Z);                                           \
        }                                                                   \
                                                                            \
        if (left->con.MEMB > right->con.MEMB) {                             \
            CCSET_SET(ccs, CC_A);                                           \
            CCSET_SET(ccs, CC_AE);                                          \
            CCSET_SET(ccs, CC_NZ);                                          \
        }                                                                   \
                                                                            \
        if (left->con.MEMB < right->con.MEMB) {                             \
            CCSET_SET(ccs, CC_B);                                           \
            CCSET_SET(ccs, CC_BE);                                          \
            CCSET_SET(ccs, CC_NZ);                                          \
        }                                                                   \
    } while (0)

static int cmp_cons(long t, struct constant *left, struct constant *right)
{
    int ccs = 0;

    if (t & T_FLOATING)
        CMP_CONS0_U(f);
    else if (t & T_SIGNED)
        CMP_CONS0_S(i);
    else
        CMP_CONS0_U(u);

    return ccs;
}

/* initialize (or clear/reinitialize) state: size nac
   vector correctly, and reset every reg to undef. */

static void init_state(struct fold_state *state)
{
    RESIZE_BITVEC(state->nac, nr_assigned_regs);
    CLR_BITVEC(state->nac);
    TRUNC_VECTOR(state->constants);
}

/* find the constant associated with reg in the block's state.
   creates a new entry if necessary and create is true, and
   returns the index of the entry, or -1 if not present. */

static int lookup_constant(struct block *b, int reg, int create)
{
    int i;

    for (i = 0; i < NR_FOLD_CONSTANTS(b); ++i) {
        if (FOLD_CONSTANT(b, i).reg == reg)
            return i;

        if (REG_PRECEDES(reg, FOLD_CONSTANT(b, i).reg))
            break;
    }

    if (create) {
        VECTOR_INSERT(b->fold.state.constants, i, 1);
        FOLD_CONSTANT(b, i).reg = reg;
        return i;
    } else
        return -1;
}

static void remove_constant(struct block *b, int reg)
{
    int i;

    i = lookup_constant(b, reg, 0);
    if (i != -1) VECTOR_DELETE(b->fold.state.constants, i, 1);
}

/* set or clear the nac bit for reg r in block b */

#define SET_NAC_BIT(b, r)   BITVEC_SET((b)->fold.state.nac, REG_INDEX(r))
#define CLR_NAC_BIT(b, r)   BITVEC_CLR((b)->fold.state.nac, REG_INDEX(r))

static void set_ccs(struct block *b, int ccs)
{
    int k;

    k = lookup_constant(b, REG_CC, 1);
    FOLD_CONSTANT(b, k).con.u = ccs;
    FOLD_CONSTANT(b, k).sym = 0;

    CLR_NAC_BIT(b, REG_CC);
}

static int get_ccs(struct block *b)
{
    int k;

    k = lookup_constant(b, REG_CC, 0);

    if (k == -1)
        return 0;
    else
        return FOLD_CONSTANT(b, k).con.u;
}

/* set a reg r nac or undef (respectively) in block b's state */

#define SET_NAC(b, r)                                                       \
    do {                                                                    \
        remove_constant((b), (r));                                          \
        SET_NAC_BIT((b), (r));                                              \
    } while (0)

#define SET_UNDEF(b, r)                                                     \
    do {                                                                    \
        remove_constant((b), (r));                                          \
        CLR_NAC_BIT((b), (r));                                              \
    } while (0)

/* eval() performs symbolic execution of insn i in block b, and updates b's
   fold.state accordingly. it's long, but proceeds more or less linearly. */

static VECTOR(reg) tmp_regs;        /* allocation managed by opt_lir_fold() */

/* helper for eval(), to set all affected regs to
   nac (if F==SET_NAC) or undef (if F==SET_UNDEF) */

#define EVAL0(F)                                                            \
    do {                                                                    \
        int _i;                                                             \
        int _reg;                                                           \
        TRUNC_VECTOR(tmp_regs);                                             \
        insn_defs(insn, &tmp_regs, I_FLAG_DEFS_CC);                         \
        FOR_EACH_REG(tmp_regs, _i, _reg) F(b, _reg);                        \
    } while (0)

static void eval(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    int op = insn->op;

    struct constant src[2];             /* source operand(s) if any. the */
    struct constant *left = &src[0];    /* pointers are swapped if commuted */
    struct constant *right = &src[1];   /* but result always goes in *left */
    long t;                             /* type of operand(s) */

    /* first, an oddball: comparing anything with itself always yields a
       constant set of condition codes (regardless of type, see notes on
       CMP_CONS0 above). note that this is different from knowing the state
       of _some_ of the condition codes, which we must handle elsewhere. */

    if ((op == I_LIR_CMP)
      && OPERAND_REG(&insn->operand[0])
      && OPERAND_REG(&insn->operand[1])
      && (insn->operand[0].reg == insn->operand[1].reg))
    {
        int ccs = 0;

        if (insn->operand[0].t & T_SIGNED) {
            CCSET_SET(ccs, CC_Z);
            CCSET_SET(ccs, CC_LE);
            CCSET_SET(ccs, CC_GE);
        } else {
            CCSET_SET(ccs, CC_Z);
            CCSET_SET(ccs, CC_AE);
            CCSET_SET(ccs, CC_BE);
        }

        set_ccs(b, ccs);
        return;
    }

    /* these insns affect no condition codes or registers. */

    switch (op)
    {
    case I_NOP:
    case I_LIR_BLKCPY:
    case I_LIR_BLKSET:
    case I_LIR_STORE:
    case I_LIR_RETURN:          return;
    }

    /* we have no chance of evaluating these at compile time, regardless of
       the operands. in fact, all nacs ultimately arise from one of these */

    switch (op)
    {
    case I_ASM:
    case I_LIR_FRAME:
    case I_LIR_ARG:
    case I_LIR_CALL:
    case I_LIR_LOAD:            goto nac;
    }

    /* the I_LIR_SETcc operations are special in that they have
       no explicit source operands, depending only on REG_CC. */

    if (I_LIR_IS_SETCC(op)) {
        int cc;

        if (FOLD_IS_NAC(b, REG_CC)) goto nac;
        if (get_ccs(b) == 0) goto undef;

        cc = I_LIR_SETCC_TO_CC(op);
        left->sym = 0;
        left->con.i = CCSET_IS_SET(get_ccs(b), cc) != 0;
        goto constant;
    }

    /* the remaining instructions use one or two source operands. try to
       get all constant operands, mapping regs if they are known constants.
       if an operand is nac, we can short-circuit out as the result is nac.
       if we see an undef, we keep going in case the other operand is nac. */

    right->sym = 0;             /* so it's PURE_CONSTANT() for unaries */

    {
        int s = 0;              /* src[] index */
        int o = 0;              /* operand[] index */
        int k;                  /* FOLD_CONSTANT() index */
        int is_undef = 0;
        int reg;

        if (op & I_FLAG_HAS_DST) ++o;       /* LIR --> dst is never a src */

        /* we use the type of the left (or only) operand to disambiguate
           operations, since this is either the same as the right's type
           or this operation doesn't care which operand's type we use */

        t = insn->operand[o].t;             /* use type of first operand */

        while (o < I_OPERANDS(op)) {
            if (OPERAND_REG(&insn->operand[o])) {
                reg = insn->operand[o].reg;
                if (FOLD_IS_NAC(b, reg)) goto nac;

                if ((k = lookup_constant(b, reg, 0)) != -1) {
                    /* the operand type may differ from the reg type (though
                        they are simpatico); we must normalize the constant */

                    src[s].con = FOLD_CONSTANT(b, k).con;
                    src[s].sym = FOLD_CONSTANT(b, k).sym;
                    normalize_con(insn->operand[o].t, &src[s].con);
                } else
                    is_undef = 1;
            } else {    /* O_IMM */
                src[s].con = insn->operand[o].con;
                src[s].sym = insn->operand[o].sym;
            }

            ++o;
            ++s;
        }

        if (is_undef) goto undef;
    }

    /* all operands are constants, but either or both might be impure.
       try to purify the right side. if we can't, we can't proceed. */

    switch (op)
    {
    case I_LIR_CMP:     /* ... is really just subtraction */
    case I_LIR_SUB:     FOLD_PRESUBTRACT(left, right); break;
    case I_LIR_ADD:     FOLD_COMMUTE(struct constant *, left, right); break;
    }

    if (!PURE_CONSTANT(*right)) goto nac;   /* pure for unary (see above) */

    /* the first set of operations can (usually) handle an impure left */

    switch (op)
    {
    case I_LIR_ADD:     FOLD_BINARY(t, left, right, +); goto constant;
    case I_LIR_SUB:     FOLD_BINARY(t, left, right, -); goto constant;

    case I_LIR_CAST:    if (!cast_con(insn->operand[0].t, t,
                                      &left->con, PURE_CONSTANT(*left)))
                            goto nac;

                        /* FALLTHRU */

    case I_LIR_MOVE:    goto constant;
    }

    /* the remaining operations require all pure operands */

    if (!PURE_CONSTANT(*left)) goto nac;

    switch (op)
    {
        case I_LIR_CMP:     set_ccs(b, cmp_cons(t, left, right)); return;
        case I_LIR_NEG:     FOLD_UNARY(t, left, -); goto constant;
        case I_LIR_COM:     FOLD_UNARY_I(t, left, ~); goto constant;
        case I_LIR_MUL:     FOLD_BINARY(t, left, right, *); goto constant;
        case I_LIR_SHR:     FOLD_SHIFT(t, left, right, >>); goto constant;
        case I_LIR_SHL:     FOLD_SHIFT(t, left, right, <<); goto constant;
        case I_LIR_AND:     FOLD_BINARY_I(t, left, right, &); goto constant;
        case I_LIR_OR:      FOLD_BINARY_I(t, left, right, |); goto constant;
        case I_LIR_XOR:     FOLD_BINARY_I(t, left, right, ^); goto constant;

        case I_LIR_MOD:     if (right->con.i == 0) goto nac;
                            FOLD_BINARY_I(t, left, right, %); goto constant;

        case I_LIR_DIV:     /* floating-point division by zero isn't fatal */

                            if ((t & T_INTEGRAL) && (right->con.i == 0))
                                goto nac;

                            FOLD_BINARY(t, left, right, /); goto constant;

                            /* bit scanning is undefined for a zero operand,
                               but again, it's not fatal, so we don't check */

        case I_LIR_BSF:     FOLD_UNARY_B(t, left, BSF, BSFL); goto constant;
        case I_LIR_BSR:     FOLD_UNARY_B(t, left, BSR, BSRL); goto constant;
    }

    /* fall thru to nac as a safe default if we fail to process an
       operation above, though in practice this should never happen ... */

nac:    EVAL0(SET_NAC);     return;
undef:  EVAL0(SET_UNDEF);   return;

    /* all insns that get here have exactly one dst reg, operand[0].
       it has been determined to be constant; its value is in left. */

constant:
    {
        int dst = insn->operand[0].reg;             /* always O_REG */
        struct symbol *sym = REG_TO_SYMBOL(dst);
        int k;

        /* normalize the constant to the register's 'native' type (from
           its symbol) and then insert/update the constants vector. */

        normalize_con(TYPE_BASE(sym->type), &left->con);
        k = lookup_constant(b, dst, 1);
        FOLD_CONSTANT(b, k).con = left->con;
        FOLD_CONSTANT(b, k).sym = left->sym;

        /* we don't speculate on the contents of REG_CC in LIR except
           as the result of I_LIR_CMP, which was dealt with above. if
           REG_CC was DEFd, we must assume it was clobbered. */

        if (INSN_DEFS_CC(insn)) SET_NAC(b, REG_CC);
    }
}

/* mark block executable (B_MARKED) along with
   all of its unconditional successors, recursively.
   returns the number of new blocks marked (if any). */

static int mark(struct block *b)
{
    int marked = 0;

    do {
        if (b->flags & B_MARKED)
            break;

        b->flags |= B_MARKED;
        ++marked;
    } while (b = unconditional_succ(b));

    return marked;
}

/* mark all successors of block b executable.
   returns the total number of new blocks marked. */

static int mark_all(struct block *b)
{
    int marked = 0;
    int n;

    for (n = 0; n < NR_SUCCS(b); ++n)
        marked += mark(SUCC(b, n).b);

    return marked;
}

/* construct a fresh (input) state by meeting the (output) state of all
   predecessors. we discard any constant that any predecessor claims is
   nac, discard and mark as nac any constant that predecessors disagree
   on, and inherit/keep any constants still standing. our logic requires
   that the constants vectors be ordered. this is pretty efficient, all
   things considered, being roughly O(n^2) in the number of constants
   circulating, which is typically small.

   this code has been lifted nearly verbatim for meet0() in lower.c. ANY
   BUGS FIXED should be cross-checked and exported there and vice-versa */

static void meet0(struct block *b)
{
    int n;

    init_state(&b->fold.state);

    for (n = 0; n < NR_PREDS(b); ++n) {
        struct block *pred_b = PRED(b, n);
        int pred_k = 0, pred_reg;
        int k = 0, reg;

        BITVEC_OR(b->fold.state.nac, pred_b->fold.prop.nac);

        while ((k < NR_FOLD_CONSTANTS(b))
          && (pred_k < NR_PROP_CONSTANTS(pred_b)))
        {
            reg = FOLD_CONSTANT(b, k).reg;
            pred_reg = PROP_CONSTANT(pred_b, pred_k).reg;

            if (FOLD_IS_NAC(b, reg)) {
                /* kill a constant if the predecessor says it's nac */
                VECTOR_DELETE(b->fold.state.constants, k, 1);
            } else if (FOLD_IS_NAC(b, pred_reg)) {
                /* ignore a predecessor's constant that we say is nac */
                ++pred_k;
            } else if (REG_PRECEDES(reg, pred_reg)) {
                /* keep a constant we have that is undef in predecessor */
                ++k;
            } else if (REG_PRECEDES(pred_reg, reg)) {
                /* pred has a constant we say is undef, so we inherit it */
                VECTOR_INSERT(b->fold.state.constants, k, 1);
                FOLD_CONSTANT(b, k) = PROP_CONSTANT(pred_b, pred_k);
                ++k;
                ++pred_k;
            } else {
                /* reg == pred_reg: we both claim the reg is constant.
                   we convert it to nac if we disagree on that value.
                   n.b. the comparison works for floating-point too! */

                if (!SAME_CONSTANT(FOLD_CONSTANT(b, k),
                                   PROP_CONSTANT(pred_b, pred_k)))
                {
                    VECTOR_DELETE(b->fold.state.constants, k, 1);
                    SET_NAC_BIT(b, reg);
                    ++pred_k;
                } else {
                    ++k;
                    ++pred_k;
                }
            }
        }

        /* kill any remaining constants the pred says are nac */

        while (k < NR_FOLD_CONSTANTS(b)) {
            reg = FOLD_CONSTANT(b, k).reg;

            if (FOLD_IS_NAC(b, reg))
                VECTOR_DELETE(b->fold.state.constants, k, 1);
            else
                ++k;
        }

        /* inherit any non-nac constants from the pred */

        while (pred_k < NR_PROP_CONSTANTS(pred_b)) {
            pred_reg = PROP_CONSTANT(pred_b, pred_k).reg;

            if (!FOLD_IS_NAC(b, pred_reg)) {
                GROW_VECTOR(b->fold.state.constants, 1);

                VECTOR_LAST(b->fold.state.constants)
                    = PROP_CONSTANT(pred_b, pred_k);
            }

            ++pred_k;
        }
    }
}

/* this is the iteration function for the inner loop of the first phase. we
   meet with all our predecessors to create an initial state, then evaluate
   each insn in turn to arrive at a final state. we determine if that final
   state differs from the last iteration (read: if we've converged) and then
   stash the state in prop for the next iteration or for the second phase. */

static int prop0(struct block *b)
{
    int ret = ITERATE_AGAIN;
    int i, k;

    if ((b->flags & B_MARKED) == 0)         /* ignore blocks not */
        return ITERATE_OK;                  /* yet marked reachable */

    meet0(b);
    for (i = 0; i < NR_INSNS(b); ++i) eval(b, i);

    if (!SAME_BITVEC(b->fold.state.nac, b->fold.prop.nac))
        goto out;

    if (NR_FOLD_CONSTANTS(b) != NR_PROP_CONSTANTS(b))
        goto out;

    for (k = 0; k < NR_FOLD_CONSTANTS(b); ++k)
        if (!SAME_CONSTANT(FOLD_CONSTANT(b, k), PROP_CONSTANT(b, k)))
            goto out;

    ret = ITERATE_OK;

out:
    SWAP(struct fold_state, b->fold.state, b->fold.prop);
    return ret;
}

/* in the second phase, we take the final meet and actually perform
   replacements: we replace all register source operands with known
   constant values with those constants, and replace entire insns
   with I_LIR_MOVEs of the results, when the results can be folded.

   finally, we rewrite the branches at the end of the block with
   unconditional jumps if the target block can be computed. this
   only affects the data-flow analysis conservatively and is safe:
   we are removing predecessors from other blocks, so at worst the
   data-flow solution will be suboptimal, but not incorrect. */

static void fold0(struct block *b)
{
    struct insn *insn;
    int i, k, r;
    int dst;

    meet0(b);

    FOR_EACH_INSN(b, i, insn) {
        /* first, replace known-constant operands in the insn. */

        for (k = 0; k < NR_FOLD_CONSTANTS(b); ++k)
            if (insn_substitute_con(insn, FOLD_CONSTANT(b, k).reg,
                                          FOLD_CONSTANT(b, k).con,
                                          FOLD_CONSTANT(b, k).sym))
                opt_request |= OPT_DEAD | OPT_LIR_NORM | OPT_LIR_REASSOC;

        eval(b, i);

        /* then, if the insn DEFs exactly one register, doesn't DEF memory,
           and doesn't have other side effects, and we know the result, we
           can replace the insn with an I_LIR_MOVE. */

        TRUNC_VECTOR(tmp_regs);
        insn_defs(insn, &tmp_regs, 0);
        if (VECTOR_SIZE(tmp_regs) != 1) continue;
        dst = VECTOR_ELEM(tmp_regs, 0);
        k = lookup_constant(b, dst, 0);
        if (k == -1) continue;                  /* value unknown */

        if (INSN_DEFS_MEM(insn)) continue;      /* this is perhaps */
        if (INSN_SIDEFFS(insn)) continue;       /* overly cautious */

        /* looks good; let's replace with I_LIR_MOVE. here, we split insn
           and INSN(b, i), use a trick to get insn_substitute_con() to do
           our dirty work, then replace the insn in the block. */

        insn = new_insn(I_LIR_MOVE, 0);
        insn->operand[0] = INSN(b, i)->operand[0];
        insn->operand[1] = INSN(b, i)->operand[0];

        insn_substitute_con(insn, dst, FOLD_CONSTANT(b, k).con,
                                       FOLD_CONSTANT(b, k).sym);

        INSN(b, i) = insn;
        opt_request |= OPT_DEAD | OPT_LIR_NORM | OPT_LIR_REASSOC;
    }

    /* now, rewrite block branches. just as the above inserts constants
       where propagation determined them to be, here we make permanent
       the constant branch decisions calculated by propagation */

    if (conditional_block(b) && !FOLD_IS_NAC(b, REG_CC) && get_ccs(b)) {
        predict_succ(b, get_ccs(b), 1);
        opt_request |= OPT_PRUNE;
    }

    if (SWITCH_BLOCK(b)
      && OPERAND_REG(&b->control)
      && ((k = lookup_constant(b, b->control.reg, 0)) != -1)
      && PURE_CONSTANT(FOLD_CONSTANT(b, k)))
    {
        predict_switch_succ(b, FOLD_CONSTANT(b, k).con, 1);
        opt_request |= OPT_PRUNE;
    }
}

/* if we have an unconditional successor whose sole purpose is to test a
   register against a constant and branch on the result, and we know the
   register is a constant on exit from this block, we hoist the comparison
   and branches to the end of this block and tell propagation to run again.
   the comparison and conditional branches will be folded on the next run.

   this simple, and conservative, transformation helps with two common cases:

        1. a for loop with constant bounds (or similar construction):
           this effectively removes the entry test and inverts the loop.

        2. logical operators: gen_log() in gen.c always creates a temp
           for the result and branches on it. if the result is otherwise
           unused, this transformation cuts all that silliness out. */

static void project0(struct block *b)
{
    struct block *succ_b;
    struct insn *insn;
    int reg;
    int k;

    if ((succ_b = unconditional_succ(b))
      && (NR_INSNS(succ_b) == 1)
      && insn_is_cmp_con(INSN(succ_b, 0), &reg)
      && ((k = lookup_constant(b, reg, 0)) != -1)
      && PURE_CONSTANT(FOLD_CONSTANT(b, k)))
    {
        insn = dup_insn(INSN(succ_b, 0));
        append_insn(insn, b);
        dup_succs(b, succ_b);
        opt_request |= OPT_LIR_FOLD;
    }
}

/* because of they overlap, we combine constant folding with propagation. the
   propagation is essentially that discussed by wegman & zadeck in their 1991
   paper, "constant propagation with conditional branches", though they focus
   on sparse conditional constant propagation using ssa form, whereas here we
   do it non-sparsely. they allude to this version almost in passing and only
   sketch it (see 3.3) for comparison; the effects are the same as with ssa.

   we proceed in three phases:

            1. discover and propagate constants (prop0)
            2. inject the constants and simplify (fold0)
            3. project constant values forward (project0) */

void opt_lir_fold(void)
{
    struct block *b;
    int marked;

    FOR_ALL_BLOCKS(b) {
        b->flags &= ~B_MARKED;

        INIT_BITVEC(b->fold.state.nac, &local_arena);
        INIT_VECTOR(b->fold.state.constants, &local_arena);
        init_state(&b->fold.state);

        INIT_BITVEC(b->fold.prop.nac, &local_arena);
        INIT_VECTOR(b->fold.prop.constants, &local_arena);
        init_state(&b->fold.prop);
    }

    /* phase 1. this consists of an inner loop and an outer loop. the inner
       loop discovers and (optimistically) propagates constants around the
       blocks which have been marked executable, exiting once they converge.
       the outer loop uses this information to (pessimistically) mark blocks
       executable, terminating when no new blocks have been marked. */

    sequence_blocks(0);     /* forward data-flow problem */
    mark(entry_block);

    INIT_VECTOR(tmp_regs, &local_arena);

    do {
        iterate_blocks(prop0);
        marked = 0;

        FOR_ALL_BLOCKS(b) {
            if ((b->flags & B_MARKED) == 0)
                continue;

            /* we are pessimistic here: if any branches are dependent upon an
               undef, we assume all paths are taken. this is arbitrary, since
               there's certainly an error in the user's code. we won't be able
               to eliminate the paths, so we might as well optimize them. */

            if (conditional_block(b)) {
                if (FOLD_IS_NAC(b, REG_CC) || !get_ccs(b))
                    marked += mark_all(b);
                else
                    marked += mark(predict_succ(b, get_ccs(b), 0));
            } else if (SWITCH_BLOCK(b) && OPERAND_REG(&b->control)) {
                int reg = b->control.reg;
                int k;

                if (FOLD_IS_NAC(b, reg)
                  || ((k = lookup_constant(b, reg, 0)) == -1)
                  || !PURE_CONSTANT(FOLD_CONSTANT(b, k)))
                    marked += mark_all(b);
                else
                    marked += mark(predict_switch_succ(b,
                                    FOLD_CONSTANT(b, k).con, 0));
            }
        }
    } while (marked);

    /* phase 2. here we actually perform the substitutions. */

    FOR_ALL_BLOCKS(b)
        if (b->flags & B_MARKED)
            fold0(b);

    /* phase 3. this is done separately from folding because it affects
       the CFG in ways not accounted for by the propagation algorithm. */

    FOR_ALL_BLOCKS(b)
        if (b->flags & B_MARKED)
            project0(b);

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
