/*****************************************************************************

   lower.c                                                minix c compiler

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
#include "reg.h"
#include "block.h"
#include "insn.h"
#include "opt.h"
#include "func.h"
#include "live.h"
#include "lower.h"

static VECTOR(reg) tmp_regs;

/* attempt to combine two operands into one operand (as though
   by addition). if successful, the merged operand will be in
   *dst and true returned; otherwise *dst is left unchanged. */

#define COMBINE0(o)                                                         \
    do {                                                                    \
        if ((o)->reg != REG_NONE) ++regs;                                   \
        if ((o)->index != REG_NONE) ++regs;                                 \
        if ((o)->scale != 0) ++scales;                                      \
    } while (0)

static int combine(struct operand *dst, struct operand *src)
{
    int regs = 0;
    int scales = 0;
    long i;

    /* eliminate obvious show-stoppers early. */

    if ((dst->t & T_FLOATING) || (src->t & T_FLOATING)) return 0;
    if (OPERAND_MEM(dst) || OPERAND_MEM(src)) return 0;
    if (OPERAND_HUGE(dst) || OPERAND_HUGE(src)) return 0;

    /* clean up the operands and determine if they can be combined.
       count terms to ensure they will all fit into one operand. */

    normalize_operand(dst); COMBINE0(dst);
    normalize_operand(src); COMBINE0(src);

    if (regs > 2) return 0;
    if (scales > 1) return 0;
    if (dst->sym && src->sym) return 0;

    if ((i = dst->con.i + src->con.i)   /* if the operand is 64-bit, */
      && (dst->t & (T_LONGS | T_PTR))   /* we don't want to introduce */
      && HUGE(i))                       /* a huge constant. if smaller, */
        return 0;                       /* overflow is ok, we'll normalize */

    /* since the operands are normalized, and scales < 2, it is
       impossible for both dst and src to have index regs here. */

    if (dst->sym == 0) dst->sym = src->sym;

    if ((dst->reg != REG_NONE) && (src->reg != REG_NONE))
        dst->index = src->reg;
    else {
        if (dst->reg == REG_NONE) dst->reg = src->reg;
        if (dst->index == REG_NONE) dst->index = src->index;
        if (dst->scale == 0) dst->scale = src->scale;
    }

    dst->class = O_EA;
    dst->con.i = i;
    normalize_con(dst->t, &dst->con);
    normalize_operand(dst);
    return 1;
}

/* attempt to expand an operand from the cache: if o is
   O_REG with a cache entry, it is is overwritten from
   the cache entry, except for its t which is preserved.

   n.b.: since we only pull entries from the cache using this
   function, and since it preserves the original operand's t,
   there is no need to set/maintain t for cache entries. */

static void cache_expand(struct block *b, struct operand *o)
{
    int n;

    if (OPERAND_REG(o)) {
        int dst = o->reg;

        for (n = 0; n < NR_CACHE(b); ++n) {
            if (CACHE(b, n).reg == dst) {
                MCH_OPERAND(o, &CACHE(b, n).operand);
                break;
            }

            if (REG_PRECEDES(dst, CACHE(b,n).reg))
                break; /* not here, early exit */
        }
    }
}

/* expand two operands from the cache and attempt to combine them.
   if that fails, attempt to combine the operands unexpanded. if
   that fails, give up. returns true with the combination in lhs
   on success, otherwise returns false with lhs/rhs unchanged. */

static int cache_add(struct block *b, struct operand *lhs,
                                      struct operand *rhs)
{
    struct operand new_lhs;
    struct operand new_rhs;

    new_lhs = *lhs; cache_expand(b, &new_lhs);
    new_rhs = *rhs; cache_expand(b, &new_rhs);

    if (!combine(&new_lhs, &new_rhs)) {
        new_lhs = *lhs;
        new_rhs = *rhs;

        if (!combine(&new_lhs, &new_rhs))
            return 0;
    }

    *lhs = new_lhs;
    return 1;
}

/* remove cache entry associated with reg and any entries
   dependent on reg, recursively, declaring them all NAA.

   no entries in the cache can relate to regs which are NAA, so it
   doubles as a flag to mark entries to be removed as we identify
   them. we remove them all at once as we exit the outermost call-
   we'd just trip over ourselves if we tried to do it as we go. */

static void cache_invalidate(struct block *b, int reg, int recurse)
{
    int n;

    CACHE_SET_NAA(b, reg);

    for (n = 0; n < NR_CACHE(b); ++n) {
        struct cache *c = &CACHE(b, n);

        if ((c->operand.reg == reg) || (c->operand.index == reg))
            if (!CACHE_IS_NAA(b, c->reg))
                cache_invalidate(b, c->reg, 1);
    }

    if (!recurse) {
        for (n = 0; n < NR_CACHE(b); ++n) {
            if (CACHE_IS_NAA(b, CACHE(b, n).reg)) {
                VECTOR_DELETE(b->lower.state.cache, n, 1);
                --n;    /* revisit index */
            }
        }
    }
}

/* we've got an operand for reg in block b. invalidate any existing
   entry (and dependent entries), then insert it into the cache. in
   two cases, we don't insert the operand, but leave the reg NAA:

            1. the operand is self-referential,
               (since the value of a reg can't be a function of itself)

            2. the operand is a huge constant
               (since huge constants can't be combined with anything) */

static void cache_set(struct block *b, int reg, struct operand *o)
{
    int n;

    cache_invalidate(b, reg, 0);
    normalize_operand(o);

    if (!OPERAND_HUGE(o) && (o->reg != reg) && (o->index != reg)) {
        for (n = 0; n < NR_CACHE(b); ++n)
            if (REG_PRECEDES(reg, CACHE(b, n).reg))
                break; /* insertion point */

        VECTOR_INSERT(b->lower.state.cache, n, 1);
        VECTOR_ELEM(b->lower.state.cache, n).reg = reg;
        VECTOR_ELEM(b->lower.state.cache, n).operand = *o;
        CACHE_CLR_NAA(b, reg);
    }
}

/* mark reg undef in block b. */

static void cache_undef(struct block *b, int reg)
{
    cache_invalidate(b, reg, 0);
    CACHE_CLR_NAA(b, reg);
}

/* determine if reg is undef in block b.

   remember, a reg is undef iff it is not NAA
   and there is no entry for it in the cache. */

static int cache_is_undef(struct block *b, int reg)
{
    int n;

    if (CACHE_IS_NAA(b, reg)) return 0;

    for (n = 0; n < NR_CACHE(b); ++n) {
        if (CACHE(b, n).reg == reg)
            return 0;

        if (REG_PRECEDES(reg, CACHE(b, n).reg))
            break;  /* not where it should be */
    }

    return 1;
}

/* update the current state of the cache in block b
   based on the action of the insn at index i. */

static void cache_update(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct operand l, r;
    int n, reg;

    switch (insn->op)
    {
    case I_LIR_FRAME:
    case I_LIR_MOVE:
    case I_LIR_SHL:
    case I_LIR_SUB:
    case I_LIR_ADD:
        /* interesting ops. universally, any undef
           source operands yield an undef result. */

        for (n = 0; n < NR_OPERANDS(insn); ++n) {
            reg = insn->operand[n].reg;

            if (OPERAND_REG(&insn->operand[n])
              && OPERAND_USES_REGS(insn, n)
              && cache_is_undef(b, reg))
            {
                cache_undef(b, reg);
                return;
            }
        }

        break;

    default:
        /* uninteresting op. just invalidate
           as necessary and we're done. */

        TRUNC_VECTOR(tmp_regs);
        insn_defs(insn, &tmp_regs, 0);

        FOR_EACH_REG(tmp_regs, n, reg)
            cache_invalidate(b, reg, 0);

        return;
    }

    reg = insn->operand[0].reg;

    switch (insn->op)       /* n.b.: break goes to invalidate. */
    {                       /* return from switch case on success */
    case I_LIR_FRAME:
        /* no-brainer I_LIR_FRAME always has a constant operand,
           and (by definition) it means (%rbp + that constant). */

        BASED_OPERAND(&l, 0, T_LONG, O_EA, REG_RBP, insn->operand[1].con.i);
        cache_set(b, reg, &l);
        return;

    case I_LIR_MOVE:
        /* simply make the destination a synonym for the
           (potentially expanded) source, whatever that be. */

        l = insn->operand[1];
        cache_expand(b, &l);
        cache_set(b, reg, &l);
        return;

    case I_LIR_SHL:
        /* if we're shifting a reg left by 1, 2, or 3,
           then we can express this as a scaled index */

        if (!OPERAND_REG(&insn->operand[1])
          || !OPERAND_PURE_IMM(&insn->operand[2])
          || (insn->operand[2].con.i < 1)
          || (insn->operand[2].con.i > 3))
            break;

        INDEX_OPERAND(&l, 0, insn->operand[1].t, O_EA,
                      insn->operand[1].reg, insn->operand[2].con.i);

        cache_set(b, reg, &l);
        return;

    case I_LIR_ADD:
    case I_LIR_SUB:
        l = insn->operand[1];
        r = insn->operand[2];

        if (insn->op == I_LIR_SUB) {
            /* we can handle subtraction in limited cases,
               when we we treat it as an additive inverse */

            if (!OPERAND_PURE_IMM(&r)) break;
            r.con.i = -r.con.i;
            normalize_con(r.t, &r.con);
        }

        if (cache_add(b, &l, &r) == 0)
            break;

        cache_set(b, reg, &l);
        return;
    }

    cache_invalidate(b, reg, 0);
}

/* returns true if two cache states represent the same cache state.
   unfortunately, same_operand() is relatively slow, so this can be
   too. but usually the vectors aren't very large, and we take some
   shortcuts to ease the pain. as usual, the total ordering of the
   cache vector helps immensely. */

static int same_cache(struct cache_state *cs1, struct cache_state *cs2)
{
    int n;

    if (!SAME_BITVEC(cs1->naa, cs2->naa)) return 0;
    if (VECTOR_SIZE(cs1->cache) != VECTOR_SIZE(cs2->cache)) return 0;

    for (n = 0; n < VECTOR_SIZE(cs1->cache); ++n) {
        if (VECTOR_ELEM(cs1->cache, n).reg
          != VECTOR_ELEM(cs2->cache, n).reg)
            return 0;

        if (!same_operand(&VECTOR_ELEM(cs1->cache, n).operand,
                          &VECTOR_ELEM(cs2->cache, n).operand))
            return 0;
    }

    return 1;
}

/* construct the entry state for a block from its predecessors' exit
   states. this looks strikingly similar to meet0() in fold.c, which
   is not an accident; it was stolen because the lattice is the same.
   as a result: ANY BUGS FIXED in this logic should be cross-checked
   and exported to meet0() in fold.c, and vice-versa! (yes, yes, DRY.) */

static void meet0(struct block *b)
{
    int n;

    CLR_BITVEC(b->lower.state.naa);
    TRUNC_VECTOR(b->lower.state.cache);

    for (n = 0; n < NR_PREDS(b); ++n) {
        struct block *pred_b = PRED(b, n);
        int pred_i = 0, pred_reg;
        int i = 0, reg;

        BITVEC_OR(b->lower.state.naa, pred_b->lower.exit.naa);

        while ((i < NR_CACHE(b)) && (pred_i < NR_EXIT(pred_b))) {
            reg = CACHE(b, i).reg;
            pred_reg = EXIT(pred_b, pred_i).reg;

            if (CACHE_IS_NAA(b, reg)) {
                /* we have a constant that the says is NAA; kill it */
                VECTOR_DELETE(b->lower.state.cache, i, 1);
            } else if (CACHE_IS_NAA(b, pred_reg)) {
                /* ignore a predecessor's entry if we say it's NAA */
                ++pred_i;
            } else if (REG_PRECEDES(reg, pred_reg)) {
                /* keep an entry that is undef in predecessor */
                ++i;
            } else if (REG_PRECEDES(pred_reg, reg)) {
                /* pred has an entry that we say is undef, so inherit it */
                VECTOR_INSERT(b->lower.state.cache, i, 1);
                CACHE(b, i) = EXIT(pred_b, pred_i);
                ++i;
                ++pred_i;
            } else {
                /* both claim the entry is known. convert to NAA if
                   they disagree on the value, otherwise keep it */

                if (!same_operand(&CACHE(b, i).operand,
                                  &EXIT(pred_b, pred_i).operand))
                {
                    VECTOR_DELETE(b->lower.state.cache, i, 1);
                    CACHE_SET_NAA(b, reg);
                    ++pred_i;
                } else {
                    ++i;
                    ++pred_i;
                }
            }
        }

        /* no more entries from the predecessor, but we need to strike
           any entries we still have that the predecessor says are NAA */

        while (i < NR_CACHE(b)) {
            reg = CACHE(b, i).reg;

            if (CACHE_IS_NAA(b, reg))
                VECTOR_DELETE(b->lower.state.cache, i, 1);
            else
                ++i;
        }

        /* the predecessor still has more entries for us. we can
           inherit them if we've not decided that they're NAA */

        while (pred_i < NR_EXIT(pred_b)) {
            pred_reg = EXIT(pred_b, pred_i).reg;

            if (!CACHE_IS_NAA(b, pred_reg)) {
                GROW_VECTOR(b->lower.state.cache, 1);
                VECTOR_LAST(b->lower.state.cache) = EXIT(pred_b, pred_i);
            }

            ++pred_i;
        }
    }
}

/* iterative step for operand-building data-flow analysis.
   like conditional constant propagation (OPT_FOLD), we must
   perform a kind of symbolic execution of the block on each
   pass to compute the exit state from the merged input state.
   as usual, we repeat until the exit state for all blocks is
   unchanged from the previous pass. */

static int cache0(struct block *b)
{
    int i;

    meet0(b);

    for (i = 0; i < NR_INSNS(b); ++i) cache_update(b, i);
    SWAP(struct cache_state, b->lower.state, b->lower.exit);

    if (same_cache(&b->lower.state, &b->lower.exit))
        return ITERATE_OK;
    else
        return ITERATE_AGAIN;
}

/* allocate storage resources for
   the specified cache_state */

static void alloc0(struct cache_state *cs)
{
    INIT_BITVEC(cs->naa, &local_arena);
    RESIZE_BITVEC(cs->naa, nr_assigned_regs);
    INIT_VECTOR(cs->cache, &local_arena);
}

struct insn *move(long t, struct operand *dst, struct operand *src)
{
    struct insn *new;
    int op;

    switch (T_BASE(t))
    {
    case T_CHAR:
    case T_UCHAR:
    case T_SCHAR:       op = I_MCH_MOVB; break;

    case T_SHORT:
    case T_USHORT:      op = I_MCH_MOVW; break;

    case T_INT:
    case T_UINT:        op = I_MCH_MOVL; break;

    case T_LONG:
    case T_ULONG:
    case T_PTR:         op = I_MCH_MOVQ; break;

    case T_FLOAT:       op = I_MCH_MOVSS; break;

    case T_DOUBLE:
    case T_LDOUBLE:     op = I_MCH_MOVSD; break;
    }

    new = new_insn(op, 0);
    MCH_OPERAND(&new->operand[0], dst);
    MCH_OPERAND(&new->operand[1], src);
    return new;
}

/* generate an insn to move src into dst, attempting first to expand
   src from the cache. the goal is simple local rematerialization; we
   avoid using expanded operands that are merely O_REG or O_IMM, since
   that would constitute [inappropriate?] constant or copy propagation. */

static struct insn *remat(struct block *b, long t, struct operand *dst,
                                                   struct operand *src)
{
    struct operand expand = *src;
    struct insn *new;
    int op;

    cache_expand(b, &expand);

    if (OPERAND_EA(&expand)) {
        switch (T_BASE(t)) {
        case T_CHAR:
        case T_UCHAR:
        case T_SCHAR:       op = I_MCH_LEAB; break;

        case T_SHORT:
        case T_USHORT:      op = I_MCH_LEAW; break;

        case T_INT:
        case T_UINT:        op = I_MCH_LEAL; break;

        case T_LONG:
        case T_ULONG:
        case T_PTR:         op = I_MCH_LEAQ; break;
        }

        new = new_insn(op, 0);
        MCH_OPERAND(&new->operand[0], dst);
        MCH_OPERAND(&new->operand[1], &expand);
    } else
        new = move(t, dst, src);

    return new;
}

/* second-level instruction selection tables.

   the table is terminated with a null sentry entry.
   order is important: the first matching entry wins. */

struct choice
{
    long ts[3];         /* type mask for operand[n] */
    int op;             /* associated MCH insn op */
    int flags;          /* C_* below */

    int (*handler)(struct block *b,     /* the block and index of */
                   int i,               /* ... insn being lowered */
                   int orig_i,          /* original index of insn */
                   struct choice *c);   /* the winning choice */
};

#define C_SHIFT     0x00000001      /* rhs is a bitcount for shift op */
#define C_NOIMM     0x00000002      /* no immediate src operands allowed */

/* second-level instruction dispatch. match the operand(s)
   against the entries in choices[] and call the handler. */

static int choose(struct block *b, int i, int orig_i, struct choice *cs)
{
    struct insn *insn = INSN(b, i);
    int n = NR_OPERANDS(insn);
    int m;

    while (cs->handler) {
        for (m = 0; m < n; ++m)
            if ((insn->operand[m].t & cs->ts[m]) == 0)
                break; /* type mismatch */

        if (m == n) /* match */
            return cs->handler(b, i, orig_i, cs);

        ++cs;
    }

    error(INTERNAL, 0, "choose() %d %d", b->asmlab, orig_i);
}

/* if the operand is an O_IMM, load it into a temporary
   and rewrite *src to refer to the temp reg. returns 1
   if the substitution occurred, or 0 otherwise. */

static int deimm(struct block *b, int i, struct operand *src)
{
    struct operand dst;
    int reg;

    if (OPERAND_IMM(src)) {
        reg = temp_reg(src->t);
        REG_OPERAND(&dst, 0, src->t, reg);
        insert_insn(move(src->t, &dst, src), b, i);
        *src = dst;
        return 1;
    } else
        return 0;
}

/* I_LIR_CMP. we can't have an immediate on the lhs (which
   almost never happens, thanks to OPT_FOLD and OPT_NORM). */

static int lower_cmp(struct block *b, int i,
                     int unused0, struct choice *c)
{
    struct insn *insn = INSN(b, i);
    struct operand lhs = insn->operand[0];
    struct operand *rhs = &insn->operand[1];
    struct insn *new;
    int count;

    count = deimm(b, i, &lhs);
    i += count;

    new = new_insn(c->op, 0);
    MCH_OPERAND(&new->operand[0], &lhs);
    MCH_OPERAND(&new->operand[1], rhs);
    insert_insn(new, b, i);

    return ++count;
}

static struct choice cmp_choices[] =
{
    T_CHARS,                T_CHARS,                0,
    I_MCH_CMPB,             0,                      lower_cmp,

    T_SHORTS,               T_SHORTS,               0,
    I_MCH_CMPW,             0,                      lower_cmp,

    T_INTS,                 T_INTS,                 0,
    I_MCH_CMPL,             0,                      lower_cmp,

    T_LONGS | T_PTR,        T_LONGS | T_PTR,        0,
    I_MCH_CMPQ,             0,                      lower_cmp,

    T_INTS,                 T_INTS,                 0,
    I_MCH_CMPL,             0,                      lower_cmp,

    T_FLOAT,                T_FLOAT,                0,
    I_MCH_UCOMISS,          0,                      lower_cmp,

    T_DOUBLE | T_LDOUBLE,   T_DOUBLE | T_LDOUBLE,   0,
    I_MCH_UCOMISD,          0,                      lower_cmp,

    { 0 }
};

/* two-address unary operations. mostly casts. tough
   casts (between certain ints and floating-point types)
   have already been dealt with in gen.c.

   the only gotcha is that some of these on ATOM do not permit
   immediate source operands, so we need to move them to temps.
   this should only occur if OPT_FOLD is off, or the user tries
   something silly like converting a global address to a float. */

static int lower_unary2(struct block *b, int i,
                      int unused0, struct choice *c)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    struct operand src = insn->operand[1];
    struct insn *new;
    int count = 0;

    if (c->flags & C_NOIMM) {
        count = deimm(b, i, &src);
        i += count;
    }

    new = new_insn(c->op, 0);
    MCH_OPERAND(&new->operand[0], dst);
    MCH_OPERAND(&new->operand[1], &src);
    insert_insn(new, b, i);

    return ++count;
}

static struct choice cast_choices[] =
{
    T_CHARS,                T_DISCRETE,             0,
    I_MCH_MOVB,             0,                      lower_unary2,

    T_SHORTS,               T_UCHAR,                0,
    I_MCH_MOVZBW,           C_NOIMM,                lower_unary2,

    T_SHORTS,               T_CHAR | T_SCHAR,       0,
    I_MCH_MOVSBW,           C_NOIMM,                lower_unary2,

    T_SHORTS,               T_DISCRETE,             0,
    I_MCH_MOVW,             0,                      lower_unary2,

    T_INTS,                 T_UCHAR,                0,
    I_MCH_MOVZBL,           C_NOIMM,                lower_unary2,

    T_INTS,                 T_CHAR | T_SCHAR,       0,
    I_MCH_MOVSBL,           C_NOIMM,                lower_unary2,

    T_INTS,                 T_USHORT,               0,
    I_MCH_MOVZWL,           C_NOIMM,                lower_unary2,

    T_INTS,                 T_SHORT,                0,
    I_MCH_MOVSWL,           C_NOIMM,                lower_unary2,

    T_INTS,                 T_DISCRETE,             0,
    I_MCH_MOVL,             0,                      lower_unary2,

    T_LONGS | T_PTR,        T_UCHAR,                0,
    I_MCH_MOVZBQ,           C_NOIMM,                lower_unary2,

    T_LONGS | T_PTR,        T_CHAR | T_SCHAR,       0,
    I_MCH_MOVSBQ,           C_NOIMM,                lower_unary2,

    T_LONGS | T_PTR,        T_USHORT,               0,
    I_MCH_MOVZWQ,           C_NOIMM,                lower_unary2,

    T_LONGS | T_PTR,        T_SHORT,                0,
    I_MCH_MOVSWQ,           C_NOIMM,                lower_unary2,

        /* I_MCH_MOVZLQ is synthetic; it's emitted as movl */

    T_LONGS | T_PTR,        T_UINT,                 0,
    I_MCH_MOVZLQ,           C_NOIMM,                lower_unary2,

    T_LONGS | T_PTR,        T_INT,                  0,
    I_MCH_MOVSLQ,           C_NOIMM,                lower_unary2,

    T_LONGS | T_PTR,        T_DISCRETE,             0,
    I_MCH_MOVQ,             0,                      lower_unary2,

        /* conversions between floating-points and ints are
           only partially covered here. conversions involving
           unsigned long are _completely_ rewritten in gen.c,
           and never appear in LIR. similarly, conversions
           from sub- and unsigned ints are recast in tree.c
           via a temporary, so they do not appear either. */

    T_CHARS
    | T_SHORTS
    | T_INT,                T_FLOAT,                0,
    I_MCH_CVTSS2SIL,        C_NOIMM,                lower_unary2,

    T_LONG | T_UINT,        T_FLOAT,                0,
    I_MCH_CVTSS2SIQ,        C_NOIMM,                lower_unary2,

    T_FLOAT,                T_INT,                  0,
    I_MCH_CVTSI2SSL,        C_NOIMM,                lower_unary2,

    T_FLOAT,                T_LONG,                 0,
    I_MCH_CVTSI2SSQ,        C_NOIMM,                lower_unary2,

    T_FLOAT,                T_DOUBLE | T_LDOUBLE,   0,
    I_MCH_CVTSD2SS,         0,                      lower_unary2,

    T_FLOAT,                T_FLOAT,                0,
    I_MCH_MOVSS,            0,                      lower_unary2,

    T_CHARS
    | T_SHORTS
    | T_INT,                T_DOUBLE | T_LDOUBLE,   0,
    I_MCH_CVTSD2SIL,        C_NOIMM,                lower_unary2,

    T_LONG | T_UINT,        T_DOUBLE | T_LDOUBLE,   0,
    I_MCH_CVTSD2SIQ,        C_NOIMM,                lower_unary2,

    T_DOUBLE | T_LDOUBLE,   T_INT,                  0,
    I_MCH_CVTSI2SDL,        C_NOIMM,                lower_unary2,

    T_DOUBLE | T_LDOUBLE,   T_LONG,                 0,
    I_MCH_CVTSI2SDQ,        C_NOIMM,                lower_unary2,

    T_DOUBLE | T_LDOUBLE,   T_FLOAT,                0,
    I_MCH_CVTSS2SD,         0,                      lower_unary2,

    T_DOUBLE | T_LDOUBLE,   T_DOUBLE | T_LDOUBLE,   0,
    I_MCH_MOVSD,            0,                      lower_unary2,

    { 0 }
};

/* single-address unary operations have a straightforward translation:

    I_LIR_OP    src, dst        ->          mov     src, dst    (1)
                                            OP      dst         (2)

   if src and dst are the same, then (1) is unnecessary. */

static int lower_unary(struct block *b, int i,
                       int unused0, struct choice *c)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    struct operand *src = &insn->operand[1];
    struct insn *new;
    int count = 0;

    if (!OPERAND_SAME_REG(dst, src)) {
        insert_insn(move(dst->t, dst, src), b, i++);
        ++count;
    }

    new = new_insn(c->op, 0);
    MCH_OPERAND(&new->operand[0], dst);
    insert_insn(new, b, i);
    ++count;

    return count;
}

static struct choice neg_choices[] =
{
    T_ANY,                  T_CHARS,                0,
    I_MCH_NEGB,             0,                      lower_unary,

    T_ANY,                  T_SHORTS,               0,
    I_MCH_NEGW,             0,                      lower_unary,

    T_ANY,                  T_INTS,                 0,
    I_MCH_NEGL,             0,                      lower_unary,

    T_ANY,                  T_LONGS | T_PTR,        0,
    I_MCH_NEGQ,             0,                      lower_unary,

    /* note: deconst() has rewritten all I_LIR_NEG with
       floating-point operands as multiplication by -1. */

    { 0 }
};

static struct choice com_choices[] =
{
    T_ANY,                  T_CHARS,                0,
    I_MCH_NOTB,             0,                      lower_unary,

    T_ANY,                  T_SHORTS,               0,
    I_MCH_NOTW,             0,                      lower_unary,

    T_ANY,                  T_INTS,                 0,
    I_MCH_NOTL,             0,                      lower_unary,

    T_ANY,                  T_LONGS | T_PTR,        0,
    I_MCH_NOTQ,             0,                      lower_unary,

    { 0 }
};

/* the most general translation of a binary operation is of the form:

    I_LIR_OP    rhs, lhs, dst   ->      mov     rhs, tmp    (1)
                                        mov     lhs, dst    (2)
                                        OP      tmp, dst    (3)

   ideally, lhs and dst refer to the same register, since this maps
   directly to the two-address form of ATOM insns. for this reason
   we attempt to rearrange commutative operations, and omit (2) since
   it would be a useless copy operation.

   if neither the lhs nor the rhs is dst, then we attempt to commute
   the operation to put a dead register on the lhs. this increases the
   likelihood that lhs and dst will coalesce during register allocation.

   (1) serves two purposes:

        (a) shifts (C_SHIFT) have restrictions; the rhs must either be an
            immediate or %cl, so non-immediates go into a tmp (RCX here).

        (b) rhs and dst might be the same reg, in which case (2) would
            destroy its value before we've read it.

   if none of these situations apply, (1) can be elided. */

static int lower_binary(struct block *b, int i,
                        int orig_i, struct choice *c)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst, *lhs;
    struct operand rhs;
    struct insn *new;
    int count = 0;
    int tmp;
    int r;

    /* try to rearrange commutative operations as discussed
       above, but don't do anything if lhs == dst already. */

    if (!OPERAND_SAME_REG(&insn->operand[0], &insn->operand[1])) {
        if (OPERAND_SAME_REG(&insn->operand[0], &insn->operand[2]))
            commute_insn(insn); /* rhs == dst, try to put on lhs */
        else if (OPERAND_REG(&insn->operand[2])) {
            r = range_by_use(b, insn->operand[2].reg, orig_i);

            if (range_span(b, r) == orig_i)
                /* rhs is dead after this insn,
                   try to put it on the lhs */
                commute_insn(insn);
        }
    }

    dst = &insn->operand[0];
    lhs = &insn->operand[1];
    rhs = insn->operand[2];
    tmp = REG_NONE;

    if (c->flags & C_SHIFT)
        if (!OPERAND_PURE_IMM(&rhs))
            tmp = REG_RCX;
        else {
            /* we must limit the shift constant to 8
               bits. might as well `say what we mean'. */

            if (lhs->t & T_LONGS)
                rhs.con.i &= 63;
            else
                rhs.con.i &= 31;
        }

    if (OPERAND_SAME_REG(&insn->operand[0], &rhs))
        tmp = temp_reg(rhs.t);

    if (tmp != REG_NONE) {                                          /* (1) */
        REG_OPERAND(&rhs, 0, rhs.t, tmp);
        insert_insn(move(rhs.t, &rhs, &insn->operand[2]), b, i++);
        ++count;
    }

    if (!OPERAND_SAME_REG(dst, lhs)) {                              /* (2) */
        insert_insn(move(dst->t, dst, lhs), b, i++);
        ++count;
    }

    new = new_insn(c->op, 0);                                       /* (3) */
    MCH_OPERAND(&new->operand[0], dst);
    MCH_OPERAND(&new->operand[1], &rhs);
    insert_insn(new, b, i++);
    ++count;

    return count;
}

static struct choice add_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHARS,
    I_MCH_ADDB,             0,                      lower_binary,

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_ADDW,             0,                      lower_binary,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_ADDL,             0,                      lower_binary,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_ADDQ,             0,                      lower_binary,

    /* floating-point addition is dispatched from lea_choices[] */

    { 0 }
};

static struct choice sub_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHARS,
    I_MCH_SUBB,             0,                      lower_binary,

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_SUBW,             0,                      lower_binary,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_SUBL,             0,                      lower_binary,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_SUBQ,             0,                      lower_binary,

    T_ANY,                  T_FLOAT,                T_FLOAT,
    I_MCH_SUBSS,            0,                      lower_binary,

    T_ANY,                  T_DOUBLE | T_LDOUBLE,   T_DOUBLE | T_LDOUBLE,
    I_MCH_SUBSD,            0,                      lower_binary,

    { 0 }
};

static struct choice mul2_choices[] =
{
    /* 8x8 multiplication is dispatched in mul_choices[] */

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_IMULW,            0,                      lower_binary,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_IMULL,            0,                      lower_binary,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_IMULQ,            0,                      lower_binary,

    /* floating-point multiplication is dispatched in mul_choices[] */

    { 0 }
};

static struct choice and_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHARS,
    I_MCH_ANDB,             0,                      lower_binary,

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_ANDW,             0,                      lower_binary,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_ANDL,             0,                      lower_binary,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_ANDQ,             0,                      lower_binary,

    { 0 }
};

static struct choice or_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHARS,
    I_MCH_ORB,              0,                      lower_binary,

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_ORW,              0,                      lower_binary,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_ORL,              0,                      lower_binary,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_ORQ,              0,                      lower_binary,

    { 0 }
};

static struct choice xor_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHARS,
    I_MCH_XORB,             0,                      lower_binary,

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_XORW,             0,                      lower_binary,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_XORL,             0,                      lower_binary,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_XORQ,             0,                      lower_binary,

    { 0 }
};

static struct choice shl_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHAR,
    I_MCH_SHLB,             C_SHIFT,                lower_binary,

    T_ANY,                  T_SHORTS,               T_CHAR,
    I_MCH_SHLW,             C_SHIFT,                lower_binary,

    T_ANY,                  T_INTS,                 T_CHAR,
    I_MCH_SHLL,             C_SHIFT,                lower_binary,

    T_ANY,                  T_LONGS | T_PTR,        T_CHAR,
    I_MCH_SHLQ,             C_SHIFT,                lower_binary,

    { 0 }
};

static struct choice shr_choices[] =
{
    T_ANY,                  T_UCHAR,                T_CHAR,
    I_MCH_SHRB,             C_SHIFT,                lower_binary,

    T_ANY,                  T_CHAR | T_SCHAR,       T_CHAR,
    I_MCH_SARB,             C_SHIFT,                lower_binary,

    T_ANY,                  T_USHORT,               T_CHAR,
    I_MCH_SHRW,             C_SHIFT,                lower_binary,

    T_ANY,                  T_SHORT,                T_CHAR,
    I_MCH_SARW,             C_SHIFT,                lower_binary,

    T_ANY,                  T_UINT,                 T_CHAR,
    I_MCH_SHRL,             C_SHIFT,                lower_binary,

    T_ANY,                  T_INT,                  T_CHAR,
    I_MCH_SARL,             C_SHIFT,                lower_binary,

    T_ANY,                  T_ULONG | T_PTR,        T_CHAR,
    I_MCH_SHRQ,             C_SHIFT,                lower_binary,

    T_ANY,                  T_LONG,                 T_CHAR,
    I_MCH_SARQ,             C_SHIFT,                lower_binary,

    { 0 }
};

/* 8-bit I_LIR_MUL. we need to use the single
   operand version of IMUL: AL * operand -> AX. */

static int lower_mul8(struct block *b, int i,
                      int unused0, struct choice *unused1)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    struct operand *lhs;
    struct operand rhs;
    struct operand rax;
    struct insn *new;
    int count;

    REG_OPERAND(&rax, 0, T_CHAR, REG_RAX);

    /* for the single-operand IMUL, a constant is best put on the
       left, since that will be loaded into the accumulator anyway. */

    if (OPERAND_IMM(&insn->operand[2])) commute_insn(insn);

    lhs = &insn->operand[1];
    rhs = insn->operand[2];

    count = deimm(b, i, &rhs);      /* IMUL operand can't be immediate */
    i += count;

    insert_insn(remat(b, T_CHAR, &rax, lhs), b, i++);   /* movb <lhs>, %al */

    new = new_insn(I_MCH_IMULB, 0);                     /* imulb <rhs> */
    MCH_OPERAND(&new->operand[0], &rhs);
    insert_insn(new, b, i++);

    insert_insn(move(T_CHAR, dst, &rax), b, i++);       /* mov %al, <dst> */

    return count + 3;
}

/* 3-operand multiplication. if one of the operands is a
   constant, we can use a 3-address IMUL; otherwise punt. */

static int lower_mul3(struct block *b, int i,
                      int orig_i, struct choice *c)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst;
    struct operand lhs;
    struct operand *rhs;
    struct insn *new;
    int count;

    if (OPERAND_IMM(&insn->operand[1]))     /* put the constant on */
        commute_insn(insn);                 /* the right if possible */

    if (!OPERAND_IMM(&insn->operand[2]))
        return choose(b, i, orig_i, mul2_choices);      /* punt */

    dst = &insn->operand[0];
    lhs = insn->operand[1];
    rhs = &insn->operand[2];

    count = deimm(b, i, &lhs);      /* one constant is enough, thanks */
    i += count;                     /* (only happens with OPT_FOLD off) */

    new = new_insn(c->op, 0);
    MCH_OPERAND(&new->operand[0], dst);
    MCH_OPERAND(&new->operand[1], &lhs);
    MCH_OPERAND(&new->operand[2], rhs);
    insert_insn(new, b, i);

    return ++count;
}

static struct choice mul_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHARS,
    I_MCH_IMULB,            0,                      lower_mul8,

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_IMUL3W,           0,                      lower_mul3,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_IMUL3L,           0,                      lower_mul3,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_IMUL3Q,           0,                      lower_mul3,

    T_ANY,                  T_FLOAT,                T_FLOAT,
    I_MCH_MULSS,            0,                      lower_binary,

    T_ANY,                  T_DOUBLE | T_LDOUBLE,   T_DOUBLE | T_LDOUBLE,
    I_MCH_MULSD,            0,                      lower_binary,

    { 0 }
};

/* I_LIR_DIV and I_LIR_MOD are both handled by division insns on ATOM,
   which are single-operand only. this is not difficult, just tedious.

   n.b.: since we have no use for the flags argument in choices, it is
   repurposed to hold the op for sign extension, or 0 when unsigned. */

static int lower_divmod(struct block *b, int i,
                        struct choice *c, int mod)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    struct operand *lhs = &insn->operand[1];
    struct operand rhs = insn->operand[2];
    struct operand rax;
    struct operand rdx;
    struct insn *new;
    int byte;
    int count;

    REG_OPERAND(&rax, 0, dst->t, REG_RAX);
    REG_OPERAND(&rdx, 0, dst->t, REG_RDX);

    /* byte operations need special handling. */

    byte = (dst->t & T_CHARS) != 0;

    /* the divisor can't be an immediate */

    count = deimm(b, i, &rhs);
    i += count;

    if (byte) {
        /* for byte division, the divisor goes into AX.
           we sign- or zero-extend while loading. note
           that we use c->flags to differentiate, even
           though we don't actually use I_MCH_CBTW! */

        new = new_insn(c->flags ? I_MCH_MOVSBL : I_MCH_MOVZBL, 0);
        REG_OPERAND(&new->operand[0], 0, T_INT, REG_RAX);
        MCH_OPERAND(&new->operand[1], lhs);
        insert_insn(new, b, i++);
        ++count;
    } else {
        /* in non-byte division, the divisor goes into xDX:xAX.
           xDX is filled either by manually clobbering it for
           zero extension, or by using one of the special ops
           (conveniently supplied by the choices flags field). */

        insert_insn(remat(b, dst->t, &rax, lhs), b, i++);

        if (c->flags)       /* signed, use CWTD .. CQTO */
            insert_insn(new_insn(c->flags, 0), b, i++);
        else {              /* unsigned, just zero RDX */
            new = new_insn(I_MCH_MOVL, 0);
            REG_OPERAND(&new->operand[0], 0, T_INT, REG_RDX);
            I_OPERAND(&new->operand[1], 0, T_INT, 0);
            insert_insn(new, b, i++);
        }

        count += 2;
    }

    new = new_insn(c->op, 0);               /* divide */
    MCH_OPERAND(&new->operand[0], &rhs);
    insert_insn(new, b, i++);
    ++count;

    /* byte operations leave the remainder in AH. if that's what we
       want, shift it down to where the quotient goes, and pretend
       we want the quotient. (AH can't be used directly because it
       is not allowed to appear with arbitrary operands in an insn.
       we have no way of representing AH in an insn anyway.) */

    if (mod && byte) {
        new = new_insn(I_MCH_SHRL, 0);
        REG_OPERAND(&new->operand[0], 0, T_INT, REG_RAX);
        I_OPERAND(&new->operand[1], 0, T_CHAR, 8);
        insert_insn(new, b, i++);
        ++count;
        mod = 0;    /* will return RAX below */
    }

    if (mod)
        insert_insn(move(dst->t, dst, &rdx), b, i);     /* remainder */
    else
        insert_insn(move(dst->t, dst, &rax), b, i);     /* quotient */

    return ++count;
}

static int lower_div(struct block *b, int i,
                     int unused0, struct choice *c)
{
    return lower_divmod(b, i, c, 0);
}

static int lower_mod(struct block *b, int i,
                     int unused0, struct choice *c)
{
    return lower_divmod(b, i, c, 1);
}

static struct choice mod_choices[] =
{
    T_ANY,                  T_UCHAR,                T_UCHAR,
    I_MCH_DIVB,             0,                      lower_mod,

    T_ANY,                  T_CHAR | T_SCHAR,       T_CHAR | T_SCHAR,
    I_MCH_IDIVB,            I_MCH_CBTW,             lower_mod,

    T_ANY,                  T_USHORT,               T_USHORT,
    I_MCH_DIVW,             0,                      lower_mod,

    T_ANY,                  T_SHORT,                T_SHORT,
    I_MCH_IDIVW,            I_MCH_CWTD,             lower_mod,

    T_ANY,                  T_UINT,                 T_UINT,
    I_MCH_DIVL,             0,                      lower_mod,

    T_ANY,                  T_INT,                  T_INT,
    I_MCH_IDIVL,            I_MCH_CLTD,             lower_mod,

    T_ANY,                  T_ULONG | T_PTR,        T_ULONG | T_PTR,
    I_MCH_DIVQ,             0,                      lower_mod,

    T_ANY,                  T_LONG,                 T_LONG,
    I_MCH_IDIVQ,            I_MCH_CQTO,             lower_mod,

    { 0 }
};

static struct choice div_choices[] =
{
    T_ANY,                  T_UCHAR,                T_UCHAR,
    I_MCH_DIVB,             0,                      lower_div,

    T_ANY,                  T_CHAR | T_SCHAR,       T_CHAR | T_SCHAR,
    I_MCH_IDIVB,            I_MCH_CBTW,             lower_div,

    T_ANY,                  T_USHORT,               T_USHORT,
    I_MCH_DIVW,             0,                      lower_div,

    T_ANY,                  T_SHORT,                T_SHORT,
    I_MCH_IDIVW,            I_MCH_CWTD,             lower_div,

    T_ANY,                  T_UINT,                 T_UINT,
    I_MCH_DIVL,             0,                      lower_div,

    T_ANY,                  T_INT,                  T_INT,
    I_MCH_IDIVL,            I_MCH_CLTD,             lower_div,

    T_ANY,                  T_ULONG | T_PTR,        T_ULONG | T_PTR,
    I_MCH_DIVQ,             0,                      lower_div,

    T_ANY,                  T_LONG,                 T_LONG,
    I_MCH_IDIVQ,            I_MCH_CQTO,             lower_div,

    T_ANY,                  T_FLOAT,                T_FLOAT,
    I_MCH_DIVSS,            0,                      lower_binary,

    T_ANY,                  T_DOUBLE | T_LDOUBLE,   T_DOUBLE | T_LDOUBLE,
    I_MCH_DIVSD,            0,                      lower_binary,

    { 0 }
};

/* I_LIR_ADDs with integer operands are filtered through this function.
   we check the operand cache to see if we can issue an LEA to combine
   multiple operations into one. if not, fall back to lower_binary().

   using LEA is not always the best choice, but it's not entirely clear
   until after register allocation what the best choice is. e.g.,

                        leal (%i30q,%i31q), %i32l

   is a good choice for a three-address add, but if %i30 and %i32 coalesce,

   leal (%i30q,%i31q), %i30l    is better rendered      addl %i31l, %i30l.

   the latter is obviously smaller and faster, and also amenable to fusing.

   we take the optimistic approach of using LEAs where possible, and leave
   it to later passes to rewrite them as simple adds or shifts when needed. */

static int lower_lea(struct block *b, int i,
                     int orig_i, struct choice *c)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    struct operand lhs = insn->operand[1];
    struct operand rhs = insn->operand[2];
    struct insn *new;

    if (cache_add(b, &lhs, &rhs)) {
        if (OPERAND_EA(&lhs)) {
            new = new_insn(c->op, 0);
            MCH_OPERAND(&new->operand[0], dst);
            MCH_OPERAND(&new->operand[1], &lhs);
        } else
            new = move(dst->t, dst, &lhs);

        insert_insn(new, b, i);
        return 1;
    } else
        return choose(b, i, orig_i, add_choices);
}

static struct choice lea_choices[] =
{
    T_ANY,                  T_CHARS,                T_CHARS,
    I_MCH_LEAB,             0,                      lower_lea,

    T_ANY,                  T_SHORTS,               T_SHORTS,
    I_MCH_LEAW,             0,                      lower_lea,

    T_ANY,                  T_INTS,                 T_INTS,
    I_MCH_LEAL,             0,                      lower_lea,

    T_ANY,                  T_LONGS | T_PTR,        T_LONGS | T_PTR,
    I_MCH_LEAQ,             0,                      lower_lea,

    T_ANY,                  T_FLOAT,                T_FLOAT,
    I_MCH_ADDSS,            0,                      lower_binary,

    T_ANY,                  T_DOUBLE | T_LDOUBLE,   T_DOUBLE | T_LDOUBLE,
    I_MCH_ADDSD,            0,                      lower_binary,

    { 0 }
};

/* I_LIR_RETURN: if the function returns a value, move that value to
   the correct physical register, then morph I_LIR_RETURN to I_MCH_RET. */

static int lower_return(struct block *b, int i,
                        int unused0, struct choice *unused1)
{
    struct operand dst;
    struct operand src;
    int op = I_MCH_RET;
    int count = 1;

    if (!VOID_TYPE(func_ret_type)) {
        /* convenient defaults, overridden below */

        op = I_MCH_RETI;
        count = 2;
        REG_OPERAND(&dst, func_ret_type, 0, REG_RAX);
        REG_OPERAND(&src, func_ret_type, 0, symbol_to_reg(func_ret_sym));

        if (FLOATING_TYPE(func_ret_type)) {
            op = I_MCH_RETF;
            dst.reg = REG_XMM0;
        }

        if (STRUN_TYPE(func_ret_type)) {
            /* func_ret_type is a lie. we reflect
               the hidden argument pointer back to
               the caller as a convenience (per the ABI) */

            src.t = T_PTR;
            dst.t = T_PTR;
            src.reg = symbol_to_reg(func_hidden_arg);
        }

        insert_insn(move(dst.t, &dst, &src), b, i++);
    }

    insert_insn(new_insn(op, 0), b, i);
    return count;
}

/* I_LIR_ARG: rewrite as a move from the appropriate physical register. */

static int nr_iargs;    /* reset at beginning of lower() */
static int nr_fargs;

static int lower_arg(struct block *b, int i,
                     int unused0, struct choice *unused1)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    struct operand src;
    int reg;

    if (dst->t & T_FLOATING)
        reg = fargs[nr_fargs++];
    else
        reg = iargs[nr_iargs++];

    REG_OPERAND(&src, 0, 0, reg);
    insert_insn(move(dst->t, dst, &src), b, i);

    return 1;
}

/* I_LIR_LOAD and I_LIR_STORE. the important step here
   is to rewrite the address operand from the cache, if
   possible: this is the primary reason we have the cache! */

static int lower_mem(struct block *b, int i,
                     int unused0, struct choice *unused)
{
    struct insn *insn = INSN(b, i);
    int n = (insn->op == I_LIR_LOAD);   /* operand[n] is address */
    struct insn *new;
    struct operand addr;
    long t;

    addr = insn->operand[n];
    cache_expand(b, &addr);
    normalize_operand(&addr);       /* ... so converting O_REG/O_IMM do */
    addr.class = O_MEM;             /* inherit any garbage values here */

    t = insn->operand[n ^ 1].t;     /* non-address operand dictates type */

    if (insn->op == I_LIR_LOAD)
        new = move(t, &insn->operand[n ^ 1], &addr);
    else
        new = move(t, &addr, &insn->operand[n ^ 1]);

    insert_insn(new, b, i);
    new->is_volatile = insn->is_volatile;

    return 1;
}

/* I_LIR_FRAME is trivial; FRAME $x, %y ---> LEAQ x(RBP), %y.
   this sequence typically evaporates in dead-store elimination */

static int lower_frame(struct block *b, int i,
                       int unused0, struct choice *unused1)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;

    new = new_insn(I_MCH_LEAQ, 0);
    MCH_OPERAND(&new->operand[0], &insn->operand[0]);
    BASED_OPERAND(&new->operand[1], 0, 0, O_EA,
                  REG_RBP, insn->operand[1].con.i);

    insert_insn(new, b, i);
    return 1;
}

/* I_ASM is valid both as LIR and MCH, but the semantics are slightly
   different. first, we must invert the regmaps (see insn.h for why).
   second, we must make explicit the machinery to move data to/from
   regs as dictated by those regmaps. (asm0 is the helper for this.) */

static int asm0(struct block *b, int i, VECTOR(regmap) *rm)
{
    struct symbol *sym;
    struct operand dst, src;
    int from, to;
    int count = 0;
    int n;

    for (n = 0; n < VECTOR_SIZE(*rm); ++n) {
        from = VECTOR_ELEM(*rm, n).from;
        to = VECTOR_ELEM(*rm, n).to;

        /* the defs map may include a `to' REG_NONE which means that
           `from' is a reg which was DEFd but whose value is tossed.
           [the REG_NONE is placed in `from' by asm_stmt(), but by
           the time we get here it's been inverted by lower_asm().] */

        if (to == REG_NONE) continue;

        /* one of the pair is a pseudo register. we use its
           type to determine what flavor of move to issue */

        if (PSEUDO_REG(to))
            sym = REG_TO_SYMBOL(to);
        else
            sym = REG_TO_SYMBOL(from);

        REG_OPERAND(&dst, sym->type, 0, to);
        REG_OPERAND(&src, sym->type, 0, from);
        insert_insn(move(dst.t, &dst, &src), b, i++);
        ++count;
    }

    return count;
}

static int lower_asm(struct block *b, int i,
                     int unused0, struct choice *unused)
{
    struct asm_insn *insn = (struct asm_insn *) INSN(b, i);
    struct asm_insn *new = (struct asm_insn *) dup_insn(INSN(b, i));
    int count;

    /* the regmaps are pseudo -> physical,
       process the uses (input) regmap */

    count = asm0(b, i, &new->uses);
    i += count;

    invert_regmap(&new->uses);
    invert_regmap(&new->defs);
    insert_insn((struct insn *) new, b, i++);
    ++count;

    /* now regmaps are physical -> pseudo,
       process the defs (output) regmap */

    count += asm0(b, i, &new->defs);
    return count;
}

/* I_MCH_SETxx insns are almost exactly like I_LIR_SETxx, except the
   MCH insns only set the lower byte. we must manually clear the upper
   bits via zero extension. this is suboptimal, since the CPU falsely
   assumes the SETxx is dependent on the previous value of its target
   register, so we might suffer an unnecessary partial register stall.

   clearing the register first, then SETxx would be better, but the
   optimizer thinks the clear is dead. minor issue. revisit someday. */

static int lower_setcc(struct block *b, int i,
                       int unused0, struct choice *unused)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    int cc;

    cc = I_LIR_SETCC_TO_CC(insn->op);
    new = new_insn(I_CC_TO_MCH_SETCC(cc), 0);
    MCH_OPERAND(&new->operand[0], &insn->operand[0]);
    insert_insn(new, b, i++);

    new = new_insn(I_MCH_MOVZBL, 0);
    MCH_OPERAND(&new->operand[0], &insn->operand[0]);
    MCH_OPERAND(&new->operand[1], &insn->operand[0]);
    insert_insn(new, b, i);

    return 2;
}

/* I_LIR_MOVE: thanks to deconst() and move() there's nothing to do here.
   we don't remat() here, since that would constitute a form of copy or
   constant propagation. remat() is for moves we generate to machine regs. */

static int lower_move(struct block *b, int i,
                      int unused0, struct choice *unused1)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];

    insert_insn(move(dst->t, dst, &insn->operand[1]), b, i);

    return 1;
}

/* return the number of word operations required to cover a region
   of length bytes, or MAX_INT if the length not constant. assumes
   bytes is `reasonable', so the count will not overflow an int. */

static int words(struct operand *bytes)
{
    int words = bytes->con.i >> 3;      /* full 8-byte words */
    int bits = bytes->con.i & 7;

    if (!OPERAND_PURE_IMM(bytes)) return INT_MAX;

    if (bits & 4) ++words;              /* ... population count */
    if (bits & 2) ++words;
    if (bits & 1) ++words;

    return words;
}

/* convert a pointer operand (O_REG, O_EA, O_IMM) to an O_MEM operand,
   in preparation for using it to manually copy or zero a block of size
   bytes. in such manual moves, the memory operand will be incremented
   by bumping its con.i field as the copy progresses. the simplest way
   to perform the operand conversion is to normalize it and force its
   class to O_MEM, but sometimes we can use an expanded operand from
   the cache without increasing code size much and saving a temporary.
   on the other hand, when the expanded operand has a long or complex
   encoding, we're better off putting it in a temporary first. */

static void blkaddr(struct block *b, struct operand *o, int size)
{
    struct operand exp;

    exp = *o;
    cache_expand(b, &exp);

    switch (size)
    {
    default:    /* an O_REG will become an O_MEM with just
                   a base register, so if the entire range
                   can be covered with an 8-bit offset .. */

                if (OPERAND_REG(&exp)
                  && (size <= SCHAR_MAX))
                    goto expanded;

                /* again, if the entire range can be covered
                   with an 8-bit displacement, it's a win. we
                   need a base register since (,index,scale)
                   always requires a 32-bit offset. */

                if (OPERAND_EA(&exp)
                  && (exp.reg != REG_NONE)
                  && (exp.sym == 0)
                  && (exp.con.i >= SCHAR_MIN)
                  && ((exp.con.i + size) <= SCHAR_MAX))
                    goto expanded;

                goto original;

    case 8:     /* the operation will only cover one word, so */
    case 4:     /* it's always best to use the expanded address */
    case 2:
    case 1:     goto expanded;
    }

expanded:
    *o = exp;
original:
    normalize_operand(o);
    o->class = O_MEM;
}

/* emit a sequence to effect a copy a block of
   size bytes from src to dst (non-overlapping).

   the best way to do has varied from generation to
   generation, but in recent years REP MOVSB has
   re-emerged as the winner in most implementations,
   so we go with that unless the block is very small
   (read: such that copying it manually takes roughly
   the same or less code space as a REP MOVSB sequence).

   we do not try to effect copies with xmm registers,
   since we have a policy of not touching the FPU unless
   we're actually doing floating point. maybe revisit. */

static int copy(struct block *b, int i, struct operand *dst,
                                        struct operand *src,
                                        struct operand *bytes)
{
    int count = 0;
    int n;

    if (words(bytes) <= 3) {
        struct operand from = *src;
        struct operand to = *dst;
        int rem = bytes->con.i;
        struct operand tmp;
        struct insn *new;
        long t;

        REG_OPERAND(&tmp, 0, T_LONG, temp_reg(T_LONG));

        blkaddr(b, &to, rem);
        blkaddr(b, &from, rem);

        while (rem)
        {
            if (rem >= 8)       { t = T_LONG;   n = 8; }
            else if (rem >= 4)  { t = T_INT;    n = 4; }
            else if (rem >= 2)  { t = T_SHORT;  n = 2; }
            else                { t = T_CHAR;   n = 1; }

            insert_insn(move(t, &tmp, &from), b, i++);
            insert_insn(move(t, &to, &tmp), b, i++);

            to.con.i += n;
            from.con.i += n;
            rem -= n;
            count += 2;
        }
    } else {
        struct operand rcx, rsi, rdi;

        REG_OPERAND(&rcx, 0, 0, REG_RCX);
        REG_OPERAND(&rsi, 0, 0, REG_RSI);
        REG_OPERAND(&rdi, 0, 0, REG_RDI);

        insert_insn(remat(b, T_LONG, &rcx, bytes), b, i++);
        insert_insn(remat(b, T_LONG, &rsi, src), b, i++);
        insert_insn(remat(b, T_LONG, &rdi, dst), b, i++);
        insert_insn(new_insn(I_MCH_REP, 0), b, i++);
        insert_insn(new_insn(I_MCH_MOVSB, 0), b, i++);

        count = 5;
    }

    return count;
}

/* I_LIR_BLKCPY arises from struct assignments. */

static int lower_blkcpy(struct block *b, int i,
                        int unused0, struct choice *unused1)
{
    struct insn *insn = INSN(b, i);

    return copy(b, i, &insn->operand[0],
                      &insn->operand[1],
                      &insn->operand[2]);
}

/* I_LIR_BLKSET. as above, the compiler generates these
   when dealing with structs (auto initializers). we try
   to generate a short sequence when zeroing constant-sized
   blocks, otherwise fall back to REP STOSB. */

static int lower_blkset(struct block *b, int i,
                        int unused0, struct choice *unused1)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    struct operand *val = &insn->operand[1];
    struct operand *bytes = &insn->operand[2];
    struct insn *new;
    int count = 0;
    int n;

    if (((n = words(bytes)) <= 7) && OPERAND_ZERO(val)) {
        int rem = bytes->con.i;
        struct operand zero;
        struct operand to;
        long t;
        int tmp;

        to = *dst;
        blkaddr(b, &to, rem);
        I_OPERAND(&zero, 0, 0, 0);

        if (n > 1) {
            /* if we're zeroing more than one word,
               then let's load zero into a temporary. */

            tmp = temp_reg(T_LONG);

            new = new_insn(I_MCH_MOVQ, 0);
            REG_OPERAND(&new->operand[0], 0, 0, tmp);
            MCH_OPERAND(&new->operand[1], &zero);
            insert_insn(new, b, i++);
            ++count;

            REG_OPERAND(&zero, 0, 0, tmp);
        }

        while (rem)
        {
            if (rem >= 8)       { t = T_LONG;   n = 8; }
            else if (rem >= 4)  { t = T_INT;    n = 4; }
            else if (rem >= 2)  { t = T_SHORT;  n = 2; }
            else                { t = T_CHAR;   n = 1; }

            insert_insn(move(t, &to, &zero), b, i++);

            to.con.i += n;
            rem -= n;
            ++count;
        }
    } else {
        struct operand rax, rcx, rdi;

        REG_OPERAND(&rcx, 0, 0, REG_RCX);
        REG_OPERAND(&rdi, 0, 0, REG_RDI);
        REG_OPERAND(&rax, 0, 0, REG_RAX);

        insert_insn(remat(b, T_LONG, &rcx, bytes), b, i++);
        insert_insn(remat(b, T_LONG, &rdi, dst), b, i++);
        insert_insn(remat(b, T_CHAR, &rax, val), b, i++);
        insert_insn(new_insn(I_MCH_REP, 0), b, i++);
        insert_insn(new_insn(I_MCH_STOSB, 0), b, i++);

        count = 5;
    }

    return count;
}

/* I_LIR_CALL. this is interesting if only because we emit the sequence
   mostly out-of-order: first the I_MCH_CALL, retrieving the return value,
   and the post-call stack fixup; then the register arguments, and third
   the stacked arguments, if any. then we backpatch the post-call stack
   fixup with the right value, or nuke it if we didn't use the stack.

   we try to make stacking arguments efficient, using PUSHQ if they're all
   discrete. otherwise we'll populate the stack manually, decrementing RSP
   as necessary, then moving all the arguments into place. stacked arguments
   are pretty rare so a great deal of fine-tuning probably isn't warranted.

   we modify the I_LIR_CALL as we lower, specifically by changing processed
   arguments to O_NONE to mark them done. this is ordinarily not done, since
   the main loop uses the LIR insn for its cache_update(). but because we are
   merely modifying an I_LIR_CALL which is `uninteresting' to the cache code,
   and only modifying the arguments which are USEd, and never DEFd, we can
   get away with it, at least for now ... */

static int lower_call(struct block *b, int i,
                      int unused0, struct choice *unused1)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    struct insn *call;      /* the I_MCH_CALL insn */
    struct insn *adj;       /* post-call RSP adjustment */
    int arg_i;              /* where to insert arguments */
    int use_pushq;          /* if all stacked arguments will be discrete */
    int offset;             /* from RSP for stacked argument */
    int count = 0;
    int n;

    arg_i = i;      /* arguments will be inserted before the call */

    call = new_insn(I_MCH_CALL, 0);
    MCH_OPERAND(&call->operand[0], &insn->operand[1]);
    insert_insn(call, b, i++);
    ++count;

    /* if the function is not void, insn->operand[0] will be O_REG.
       copy the result from the machine reg to its pseudo reg. */

    if (OPERAND_REG(&insn->operand[0])) {
        struct operand src;
        long t = insn->operand[0].t;

        if (t & T_DISCRETE)
            REG_OPERAND(&src, 0, 0, REG_RAX);
        else
            REG_OPERAND(&src, 0, 0, REG_XMM0);

        insert_insn(move(t, &insn->operand[0], &src), b, i++);
        ++count;
    }

    /* if we stack any arguments, we'll need to
       fix up the stack pointer afterwards. put
       a partial insn here; operand[1] will be
       filled end once we're done. */

    adj = new_insn(I_MCH_ADDQ, 0);
    REG_OPERAND(&adj->operand[0], 0, 0, REG_RSP);
    /* operand[1] is filled in at end of func */
    insert_insn(adj, b, i++);
    ++count;

    /* now, prepare the arguments. notice that because we never
       change arg_i, these end up in the output in the opposite
       order to that in which we process them. first, deal with
       register arguments (so these will be loaded last). */

    if (!insn->is_variadic) {
        for (n = 2; n < (insn->nr_args + 2); ++n) {
            struct operand src;
            struct operand dst;
            long t = insn->operand[n].t;

            if (t & T_STRUN) continue;

            if (t & T_DISCRETE) {
                if (call->nr_iargs == MAX_IARGS) continue;
                REG_OPERAND(&dst, 0, 0, iargs[call->nr_iargs]);
                ++call->nr_iargs;
            } else { /* T_FLOATING */
                if (call->nr_fargs == MAX_FARGS) continue;
                REG_OPERAND(&dst, 0, 0, fargs[call->nr_fargs]);
                ++call->nr_fargs;
            }

            MCH_OPERAND(&src, &insn->operand[n]);
            insert_insn(remat(b, t, &dst, &src), b, arg_i);
            ++count;

            insn->operand[n].class = O_NONE;    /* mark processed */
        }
    }

    /* scan the arguments we have to stack to see if they're all
       discrete. if so, we'll use PUSHQ to stack them all. n.b.:
       if we're pushing a double constant, we could use PUSHQ
       then too, but that possibility is hidden by deconst(). */

    use_pushq = 1;

    for (n = 2; n < (insn->nr_args + 2); ++n) {
        if (OPERAND_NONE(&insn->operand[n]))
            continue;

        if (!(insn->operand[n].t & T_DISCRETE)) {
            use_pushq = 0;
            break;
        }
    }

    /* now, move any arguments to the stack. for scalars, we
       use a simple mov insn. for structs, we invoke copy().
       again, because we don't bump arg_i, this will result in
       the arguments being stacked right-to-left, as required. */

    offset = 0;

    for (n = 2; n < (insn->nr_args + 2); ++n) {
        struct operand *src = &insn->operand[n];
        struct operand dst;
        struct operand bytes;
        int size = (src->t & T_STRUN) ? src->size : t_size(src->t);

        if (OPERAND_NONE(src))
            continue;   /* already in reg */

        if (use_pushq) {
            new = new_insn(I_MCH_PUSHQ, 0);
            MCH_OPERAND(&new->operand[0], src);
            insert_insn(new, b, arg_i);
            ++count;
        } else {
            if (src->t & T_STRUN) {
                /* n.b. the src is actually a PTR to the struct */
                BASED_OPERAND(&dst, 0, 0, O_EA, REG_RSP, offset);
                I_OPERAND(&bytes, 0, T_LONG, size);
                count += copy(b, arg_i, &dst, src, &bytes);
            } else {
                BASED_OPERAND(&dst, 0, 0, O_MEM, REG_RSP, offset);
                insert_insn(move(src->t, &dst, src), b, arg_i);
                ++count;
            }
        }

        offset += size;
        offset = ROUND_UP(offset, STACK_ALIGN);
    }

    /* finalize the stack adjustments. we need a sub before
       the arguments if we stacked the arguments manually
       (read: not if we used PUSHQ), and we need to fill
       in the post-call adjustment value (or kill it). */

    if (offset && !use_pushq) {
        new = new_insn(I_MCH_SUBQ, 0);
        REG_OPERAND(&new->operand[0], 0, 0, REG_RSP);
        I_OPERAND(&new->operand[1], 0, T_LONG, offset);
        insert_insn(new, b, arg_i); /* before arguments */
        ++count;
    }

    if (offset)
        I_OPERAND(&adj->operand[1], 0, T_LONG, offset);
    else
        adj->op = I_NOP;    /* didn't use the stack */

    return count;
}

/* the first-level instruction selection table is indexed by I_INDEX. if the
   handler is 0, the instruction is passed through unchanged. otherwise, the
   the handler is resposible for inserting the equivalent lowered insn(s)
   before the insn under consideration, and returning the number inserted. */

struct sel
{
    struct choice *choices;         /* choices[] table if applicable */

    int (*handler)(struct block *b,             /* the block and index of */
                   int i,                       /* ... insn being lowered */
                   int orig_i,                  /* original index of insn */
                   struct choice *choices);     /* second-level table, or 0 */
};

static struct sel sel[] =
{
    {   0               /* N/A */           },          /* I_NOP */
    {   0,              lower_asm           },          /* I_ASM */
    {   0                                   },          /* (unused) */
    {   0,              lower_frame         },          /* I_LIR_FRAME */
    {   0,              lower_mem           },          /* I_LIR_LOAD */
    {   0,              lower_mem           },          /* I_LIR_STORE */
    {   0,              lower_call          },          /* I_LIR_CALL */
    {   0,              lower_arg           },          /* I_LIR_ARG */
    {   0,              lower_return        },          /* I_LIR_RETURN */
    {   0,              lower_move          },          /* I_LIR_MOVE */
    {   cast_choices,   choose              },          /* I_LIR_CAST */
    {   cmp_choices,    choose              },          /* I_LIR_CMP */
    {   neg_choices,    choose              },          /* I_LIR_NEG */
    {   com_choices,    choose              },          /* I_LIR_COM */
    {   lea_choices,    choose              },          /* I_LIR_ADD */
    {   sub_choices,    choose              },          /* I_LIR_SUB */
    {   mul_choices,    choose              },          /* I_LIR_MUL */
    {   div_choices,    choose              },          /* I_LIR_DIV */
    {   mod_choices,    choose              },          /* I_LIR_MOD */
    {   shr_choices,    choose              },          /* I_LIR_SHR */
    {   shl_choices,    choose              },          /* I_LIR_SHL */
    {   and_choices,    choose              },          /* I_LIR_AND */
    {   or_choices,     choose              },          /* I_LIR_OR */
    {   xor_choices,    choose              },          /* I_LIR_XOR */
    {   0,              lower_setcc         },          /* I_LIR_SETZ */
    {   0,              lower_setcc         },          /* I_LIR_SETNZ */
    {   0,              lower_setcc         },          /* I_LIR_SETS */
    {   0,              lower_setcc         },          /* I_LIR_SETNS */
    {   0,              lower_setcc         },          /* I_LIR_SETG */
    {   0,              lower_setcc         },          /* I_LIR_SETLE */
    {   0,              lower_setcc         },          /* I_LIR_SETGE */
    {   0,              lower_setcc         },          /* I_LIR_SETL */
    {   0,              lower_setcc         },          /* I_LIR_SETA */
    {   0,              lower_setcc         },          /* I_LIR_SETBE */
    {   0,              lower_setcc         },          /* I_LIR_SETAE */
    {   0,              lower_setcc         },          /* I_LIR_SETB */
    {   0                                   },          /* (unused) */
    {   0                                   },          /* (unused) */
    {   0,              lower_blkcpy        },          /* I_LIR_BLKCPY */
    {   0,              lower_blkset        }           /* I_LIR_BLKSET */
};

/* convert the CFG from LIR insns to MCH insns.

   we are called after deconst(), so we are guaranteed that all LIR
   operands are valid ATOM operands, either O_REGs, or O_IMMs with
   discrete, non-huge values.

   we proceed in two phases. first, we perform iterative analysis to
   build the operand caches (used to form complex address operands).
   then we process each block, one insn at a time, dispatching via
   a two-level table first with sel[], based on op, then possibly on
   operand types in various choices[] tables. the lowering handler
   is responsible for inserting the equivalent MCH sequence *before*
   the LIR insn and reporting back how many insns it emitted (so the
   outer loop can keep track). the outer loop updates the operand
   cache for the block, removes the LIR insn, rinses and repeats.

   we compute live information before beginning the lowering proper.
   because the lowering changes instruction indexes, the outer loop
   tracks the original index of the current LIR insn in orig_i so that
   lowering handlers can consult the live data (with some limitations). */

void lower(void)
{
    struct block *b;
    struct insn *insn;
    struct sel *selp;
    int i, orig_i;

    INIT_VECTOR(tmp_regs, &local_arena);

    FOR_ALL_BLOCKS(b) {
        alloc0(&b->lower.state);
        alloc0(&b->lower.exit);
        CLR_BITVEC(b->lower.exit.naa);
    }

    sequence_blocks(0);
    iterate_blocks(cache0);

    live_analyze(LIVE_ANALYZE_REGS);

    nr_iargs = 0;   /* for lower_arg() */
    nr_fargs = 0;

    FOR_ALL_BLOCKS(b) {
        meet0(b);
        orig_i = 0;

        FOR_EACH_INSN(b, i, insn) {
            selp = sel + I_INDEX(insn->op);

            if (selp->handler == 0)
                cache_update(b, i);
            else {
                i += selp->handler(b, i, orig_i, selp->choices);
                cache_update(b, i);
                VECTOR_DELETE(b->insns, i, 1);
                --i; /* removed this insn */
            }

            ++orig_i;
        }
    }

    ARENA_FREE(&local_arena);
}

/* replace synthetic MCH instructions with their real counterparts. called
   right before the function is output so the we render legal assembly. */

void desynth(void)
{
    struct block *b;
    struct insn *insn;
    struct insn *new;
    int i, op;

    FOR_ALL_BLOCKS(b)
        FOR_EACH_INSN(b, i, insn) {
            switch (insn->op)
            {
            case I_MCH_LEAB:    op = I_MCH_LEAL; break;
            case I_MCH_MOVZLQ:  op = I_MCH_MOVL; break;

            default:            continue;
            }

            new = new_insn(op, 0);
            MCH_OPERAND(&new->operand[0], &insn->operand[0]);
            MCH_OPERAND(&new->operand[1], &insn->operand[1]);
            INSN(b, i) = new;
        }
}

/* vi: set ts=4 expandtab: */
