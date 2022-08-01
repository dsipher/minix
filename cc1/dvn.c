/*****************************************************************************

   dvn.c                                               tahoe/64 c compiler

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
#include "opt.h"
#include "insn.h"
#include "block.h"
#include "func.h"
#include "dvn.h"

/* value numbers are allocated globally and kept here.
   the index into the values vector is the value number. */

static VECTOR(value) values;

#define VALUE(n)    VECTOR_ELEM(values, (n))
#define NR_VALUES   VECTOR_SIZE(values)

/* a value is available in a block if it is
   (a) a constant or (b) held in a register */

#define AVAIL(b, n)     ((VALUE(n).v == V_IMM) ||                           \
                         (number_to_reg((b), (n)) != REG_NONE))

/* every time a V_IMM is created, we keep a reference to it here. this
   just reduces the space that imm() needs to search for constants. */

static VECTOR(value_ref) imms;

#define IMM(n)      VECTOR_ELEM(imms, (n))
#define NR_IMMS     VECTOR_SIZE(imms)

/* allocate a new value number of the specified class in block
   b and minimally initialize it. return the new value number.

   when appropriate, secondary references are maintained: V_IMMs go into the
   global imms vector, and V_EXPRs into the block's exprs vector. since this
   is the only place where new elements are added to these vectors, they are
   guaranteed to be ordered by value number. for V_IMMs this is unimportant,
   but meet0() relies on the consistent ordering of block exprs. */

static int new_number(struct block *b, int v, long t)
{
    int number = VECTOR_SIZE(values);

    GROW_VECTOR(values, 1);
    VALUE(number).v = v;
    VALUE(number).number = number;
    VALUE(number).t = t;

    switch (v)
    {
    case V_IMM:     GROW_VECTOR(imms, 1);
                    VECTOR_LAST(imms) = &VALUE(number);
                    break;

    case V_EXPR:    GROW_VECTOR(b->dvn.exprs, 1);
                    VECTOR_LAST(b->dvn.exprs) = &VALUE(number);
                    break;
    }

    return number;
}

/* V_IMMs are more work than one might think. we not only must scan
   all existing values, but we want simpatico constants to share an
   entry, so we must normalize them to compare them.

   type punning abounds: comparing con.i elements for equality
   works whether the elements are integers or floating point */

static int imm(struct block *b, long t, union con con, struct symbol *sym)
{
    int number;
    int n;

    for (n = 0; n < NR_IMMS; ++n) {
        struct value *v = IMM(n);

        if (v->sym != sym) continue;
        if (!T_SIMPATICO(v->t, t)) continue;
        normalize_con(v->t, &con);

        if (v->con.i == con.i)
            return v->number;
    }

    normalize_con(t, &con);
    number = new_number(b, V_IMM, t);
    VALUE(number).con = con;
    VALUE(number).sym = sym;

    return number;
}

/* associate reg with value in block b.
   any existing association is broken. */

static void assoc(struct block *b, int reg, int number)
{
    int n;

    for (n = 0; n < NR_REGVALS(b); ++n) {
        if (REGVAL(b, n).reg == reg) {
            REGVAL(b, n).number = number;
            return;
        }

        if (REG_PRECEDES(reg, REGVAL(b, n).reg))
            break;  /* insertion point */
    }

    VECTOR_INSERT(b->dvn.regvals, n, 1);
    REGVAL(b, n).reg = reg;
    REGVAL(b, n).number = number;
}

/* return the value number associated with reg in block b. if none
   exists, a new opaque value is created and associated with the reg. */

static int reg_to_number(struct block *b, int reg, long t)
{
    int n;

    for (n = 0; n < NR_REGVALS(b); ++n) {
        if (REGVAL(b, n).reg == reg)
            return REGVAL(b, n).number;

        if (REG_PRECEDES(reg, REGVAL(b, n).reg))
            break; /* insert here */
    }

    VECTOR_INSERT(b->dvn.regvals, n, 1);
    REGVAL(b, n).reg = reg;
    REGVAL(b, n).number = new_number(b, V_NONE, t);

    return REGVAL(b, n).number;
}

/* return any reg in block b which holds a value. if
   no such reg is is available, returns REG_NONE. */

static int number_to_reg(struct block *b, int number)
{
    int n;

    for (n = 0; n < NR_REGVALS(b); ++n)
        if (REGVAL(b, n).number == number)
            return REGVAL(b, n).reg;

    return REG_NONE;
}

/* dissociate a reg from its value (if any) in block b */

static void dissoc(struct block *b, int reg)
{
    int n;

    for (n = 0; n < NR_REGVALS(b); ++n) {
        if (REGVAL(b, n).reg == reg) {
            VECTOR_DELETE(b->dvn.regvals, n, 1);
            break;
        }

        if (REG_PRECEDES(reg, REGVAL(b, n).reg))
            break;  /* not here, exit early */
    }
}

/* retrieve the fundamental type of the value associated with the reload */

#define RELOAD_T(r)     (VALUE((r)->number).t)

/* we keep the reload vector ordered (by no particular criteria,
   really) to make merging fast. this is gnarly enough and called
   infrequently enough to avoid trying to inline it.

   remember, this is a total ordering, so iff

            !reload_precedes(a, b) && !reload_precedes(b, a)

   then a == b (at least in the base, offset, sym and t fields) */

static int reload_precedes(struct reload *r1, struct reload *r2)
{
    if (r1->base < r2->base) return 1;
    if (r1->base > r2->base) return 0;

    if (r1->offset < r2->offset) return 1;
    if (r1->offset > r2->offset) return 0;

    if (r1->sym < r2->sym) return 1;
    if (r1->sym > r2->sym) return 0;

    return (RELOAD_T(r1) < RELOAD_T(r2));
}

/* insert a new reload into the block's reloads vector in its proper
   place. duplicates are not permitted. returns the entry's address. */

static struct reload *new_reload(struct block *b, struct reload *new)
{
    int n;

    for (n = 0; n < NR_RELOADS(b); ++n)
        if (reload_precedes(new, &RELOAD(b, n)))
            break;  /* insertion point found */

    VECTOR_INSERT(b->dvn.reloads, n, 1);
    RELOAD(b, n) = *new;

    return &RELOAD(b, n);
}

/* label operand n of insn i in block b with a value number. */

static void label(struct block *b, int i, int n)
{
    struct operand *o = &INSN(b, i)->operand[n];
    union con con;

    if (OPERAND_REG(o))
        o->number = reg_to_number(b, o->reg, o->t);
    else /* O_IMM */
        o->number = imm(b, o->t, o->con, o->sym);
}

/* look in block b for an available value that computes the same thing
   insn does and return its value number, or NO_NUMBER if no match. */

static int match(struct block *b, struct insn *insn)
{
    struct value *v;
    int strict = 0;
    int i, n;

    switch (insn->op)
    {
        case I_LIR_DIV:         /* these operations require */
        case I_LIR_MOD:         /* operand types to match */
        case I_LIR_SHR:
        case I_LIR_CAST:        strict = 1; break;
    }

    for (i = 0; i < NR_EXPRS(b); ++i) {
        v = EXPR(b, i);

        if (v->insn->op != insn->op) continue;

        for (n = (insn->op & I_FLAG_HAS_DST) ? 1 : 0;
             n < I_OPERANDS(insn->op); ++n)
        {
            if (v->insn->operand[n].number != insn->operand[n].number)
                goto mismatch;

            if (strict && (v->insn->operand[n].t != insn->operand[n].t))
                goto mismatch;
        }

        /* I_LIR_CAST is unique in that its destination operand's type is
           not dependent on its source operand's type. we require that the
           value and the desired result type be at least simpatico for a
           match; this is implied by other ops, so we usually don't check. */

        if ((insn->op == I_LIR_CAST)
          && !T_SIMPATICO(v->t, insn->operand[0].t))
            goto mismatch;

        /* looks good; let's make sure we still have access to the value.
           if not, discard the value (since it's useless) and keep looking */

        if (!AVAIL(b, v->number)) {
            VECTOR_DELETE(b->dvn.exprs, i, 1);
            --i; /* retry this index */
            goto mismatch;
        }

        return v->number;       /* matched */

mismatch:   ;
    }

    return NO_NUMBER;
}

/* replace with insn at index i in block b with a sequence to compute
   the value given (which must be available) into the destination reg
   of that insn. in the usual case, the value and the destination reg
   have simpatico types, and the entire sequence is an I_LIR_MOVE. if
   the destination reg is smaller than the value type, then a temp is
   allocated and the sequence becomes an I_LIR_MOVE to the temp, then
   a right shift by bits, and finally a cast to the destination reg.
   (this latter action is required when we're extracting a partial
   value from an overlapping reload.)

   we will always replace the insn with a sequence that begins with
   I_LIR_MOVE, even if it isn't really required (in the latter case,
   we could shift directly into the temp). we also make the assoc()
   between the destination reg of this first move and its source value
   on behalf of the caller. these two actions serve two purposes:

        1. simplifies the logic in the callers, who can safely assume
           that all state modified by INSN(b,i) has been accounted for

        2. subjects the complete extraction sequence, if present, to
           further value numbering. (if there were no move insn, and
           we proceeded directly to the shift, we'd have to fix up or
           backtrack to feed the shift into the numbering process.)

   the extraneous move (in the extended sequence) will typically be
   absorbed by the usual means, i.e., copy propagation or coalescing. */

static void replace(struct block *b, int i, int number, int bits)
{
    struct value *v = &VALUE(number);
    struct insn *insn = INSN(b, i);
    int final_reg = insn->operand[0].reg;
    long final_t = insn->operand[0].t;
    int move_reg;

    if (t_size(final_t) != t_size(v->t))
        move_reg = temp_reg(v->t);
    else
        move_reg = final_reg;

    /* first, let's retrieve the value into move_reg.
       this move_reg is always simpatico with the value. */

    if (v->v == V_IMM) {
        insn = new_insn(I_LIR_MOVE, 0);
        REG_OPERAND(&insn->operand[0], 0, v->t, move_reg);
        IMM_OPERAND(&insn->operand[1], 0, 0, v->con, v->sym);
        insn->operand[1].t = insn->operand[0].t;
        opt_request |= OPT_LIR_FOLD;    /* new constant */
    } else {
        int value_reg = number_to_reg(b, number);
        insn = new_insn(I_LIR_MOVE, 0);
        REG_OPERAND(&insn->operand[0], 0, v->t, move_reg);
        REG_OPERAND(&insn->operand[1], 0, v->t, value_reg);
        opt_request |= OPT_PRUNE | OPT_LIR_PROP;    /* we made a copy */
    }

    INSN(b, i) = insn;
    assoc(b, move_reg, number);

    /* now, if move_reg is a temporary, it's because the final_reg has a
       smaller size than the value itself, so we must shift and downcast. */

    if (move_reg != final_reg) {
        insn = new_insn(I_LIR_SHR, 0);
        REG_OPERAND(&insn->operand[0], 0, v->t, move_reg);
        insn->operand[1] = insn->operand[0];
        I_OPERAND(&insn->operand[2], 0, T_CHAR, bits);
        insert_insn(insn, b, i + 1);

        insn = new_insn(I_LIR_CAST, 0);
        REG_OPERAND(&insn->operand[0], 0, final_t, final_reg);
        REG_OPERAND(&insn->operand[1], 0, v->t, move_reg);
        insert_insn(insn, b, i + 2);

        opt_request |= OPT_LIR_PROP | OPT_LIR_REASSOC | OPT_LIR_FOLD;
    }

    opt_request |= OPT_LIR_DVN | OPT_DEAD;
}

static VECTOR(reg) tmp_regs;

/* invalidate any state affected by insn in block b:

   1. if the insn DEFs regs, dissociate them from their values (if any).

   2. if the insn defs memory, we invalidate all reloads, since
   we no longer have any idea what the actual state of memory is.

   3. if the insn uses memory, we remove all references to the store
   insns in reloads. this 'commits' those stores, preventing store()
   from removing them if/when it encounters ank overwriting insns.

   as a special case, if insn == 0, we act as if we've encountered an
   insn that uses memory (and nothing else). as described above, this
   commits all stores. dvn0() does this when inheriting state from a
   predecessor, since we do not, in general, post-dominate the stores. */

static void invalidate(struct block *b, struct insn *insn)
{
    int defs_mem = insn ? INSN_DEFS_MEM(insn) : 0;
    int uses_mem = insn ? INSN_USES_MEM(insn) : 1;
    int n, reg;

    if (insn) {
        TRUNC_VECTOR(tmp_regs);                                 /* #1 */
        insn_defs(insn, &tmp_regs, 0);
        FOR_EACH_REG(tmp_regs, n, reg) dissoc(b, reg);
    }

    if (defs_mem) TRUNC_VECTOR(b->dvn.reloads);                 /* #2 */

    if (uses_mem)                                               /* #3 */
        for (n = 0; n < NR_RELOADS(b); ++n)
            RELOAD(b, n).store = 0;
}

/* value is the value number of a pointer in block b. attempt to re-express
   that value as a more 'fundamental' version - a previous value, offset by
   a constant. we do this by tracing the value through address calculations
   in the value tree. populates reload base, offset, and sym accordingly. as
   a convenience, the remaining fields of reload are initialized to zero. */

static void address(struct block *b, int number, struct reload *reload)
{
    __builtin_memset(reload, 0, sizeof(struct reload));
    reload->base = number;

    while (REAL_NUMBER(reload->base))
    {
        struct value *v = &VALUE(reload->base);

        if (v->v == V_EXPR)
        {
            int sign = -1;
            struct operand *left = &v->insn->operand[1];
            struct operand *right = &v->insn->operand[2];

            switch (v->insn->op)
            {
            case I_LIR_ADD:
                sign = 1;

                if (OPERAND_PURE_IMM(left))
                    SWAP(struct operand *, left, right);

                /* FALLTHRU */

            case I_LIR_SUB:
                if (!OPERAND_PURE_IMM(right)) return;
                reload->offset += right->con.i * sign;
                reload->base = left->number;
                break;

            case I_LIR_FRAME:
                reload->offset += left->con.i;
                reload->base = FRAME_NUMBER;
                /* FALLTHRU */

            default:
                return;
            }
        } else if (v->v == V_IMM) {
            reload->offset += v->con.i;
            reload->sym = v->sym;
            reload->base = GLOBAL_NUMBER;
            return;
        } else /* V_NONE */
            return;
    }
}

/* determine the aliasing relationship between two reload entries. returns:

        EXACT       r1 and r2 overlap exactly, i.e., they
                    refer to the same memory address and size.

        CONTAIN     r1 and r2 overlap. r1 is smaller than
                    r2 and is completely covered by r2.

        OVERLAP     r1 and r2 overlap in some other way not described
                    above, or the relationship between them is unknown.

        0           r1 and r2 are known to be completely disjoint.

   we must make a few assumptions, or else most memory-access optimizations
   are impossible:

        1. no two virtual addresses map to the same storage.
        2. no two global symbols overlap.

    obviously there are legitimate, though not especially common,
    circumstances where these assumptions are not entirely correct.
    when an aliasing hazard might be present, use `volatile'. */

#define OVERLAP     1
#define EXACT       2
#define CONTAIN     3

#define OVERLAP0(_r1,_r2)   ((_r1->offset >= _r2->offset)                   \
                            && (_r1->offset < ((_r2->offset) + _r2##_size)))

static int overlaps(struct reload *r1, struct reload *r2)
{
    int r1_size;
    int r2_size;

    if ((r1->base == GLOBAL_NUMBER)         /* see assumption #2 */
      && (r2->base == GLOBAL_NUMBER)
      && (r1->sym != r2->sym))
        return 0;

    /* globals and frame-allocated addresses can't ever overlap. */

    if ( ((r1->base == GLOBAL_NUMBER) && (r2->base == FRAME_NUMBER))
      || ((r2->base == GLOBAL_NUMBER) && (r1->base == FRAME_NUMBER)))
        return 0;

    /* otherwise, we can only make a determination if the
       accesses use the same base value and same asm symbol. */

    if (r1->base != r2->base) return OVERLAP;
    if (r1->sym != r2->sym) return OVERLAP;

    /* and we do that by checking the constant offsets from that
       base/sym pair against each other and the sizes of access. */

    r1_size = t_size(RELOAD_T(r1));
    r2_size = t_size(RELOAD_T(r2));

    /* an exact match is easy to spot */

    if ((r1->offset == r2->offset) && (r1_size == r2_size))
        return EXACT;

    /* partial overlaps are not `commutative' (we have no
       special return value to indicate that r2 is completely
       covered by r1), hence the asymmetry below. */

    if (OVERLAP0(r1, r2))
        if ((r1->offset + r1_size) <= (r2->offset + r2_size))
            return CONTAIN;
        else
            return OVERLAP;

    if (OVERLAP0(r2, r1)) return OVERLAP;

    return 0;       /* not aliases! */
}

/* I_LIR_LOAD: we can avoid the load if we know the value stored at a
   location (because we've previously either read or stored it) and the
   value is still available. if we must issue a load, then we assign it
   a value and remember it with a reload entry; like any other memory
   read, this will result in invalidate() committing any prior stores. */

static void load(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct reload *match;
    struct reload new;
    int n;
    int bits;

    if (insn->is_volatile) {
        /* aside from the invalidation to commit any pending stores,
           volatile loads pass through unnoticed. we don't satisfy them
           from the reload cache for obvious reasons, but we don't cache
           their results to satisfy future non-volatile loads, either, or
           invalidate overlapping reloads already cached. this means that
           mixing volatile and non-volatile loads in the presence of an
           actually-volatile memory location can result in odd behavior,
           but in that circumstance, frankly, the programmer deserves it. */

        invalidate(b, 0);
        return;
    }

    label(b, i, 1);
    address(b, insn->operand[1].number, &new);
    new.number = new_number(b, V_NONE, insn->operand[0].t);

    match = 0;

    for (n = 0; n < NR_RELOADS(b); ++n) {
        struct reload *reload = &RELOAD(b, n);

        /* this is as good a place as any to purge
           entries that are no longer available. */

        if (!AVAIL(b, reload->number)) {
            VECTOR_DELETE(b->dvn.reloads, n, 1);
            --n; /* revisit */
            continue;
        }

        if (T_CAST_CLASS(RELOAD_T(reload)) != T_CAST_CLASS(RELOAD_T(&new)))
            continue;   /* we don't mix floats and non-floats */

        switch (overlaps(&new, reload))
        {
        case EXACT:     /* an exact match (modulo simpatico)
                           trumps all others, exit early */

                        match = reload;
                        bits = 0;
                        goto matched;

        case CONTAIN:   /* if the value covers this load, we can use it if
                           a discrete type; remember it but keep looking. */

                        if ((RELOAD_T(&new) & T_FLOATING) == 0) {
                            match = reload;
                            bits = (new.offset - reload->offset)
                                    * BITS_PER_BYTE;
                        }

                        break;
        }
    }

matched:
    if (match)
        replace(b, i, match->number, bits);
    else {
        match = new_reload(b, &new);
        invalidate(b, 0);
        assoc(b, insn->operand[0].reg, match->number);
    }
}

/* new, a value we're about to write, is CONTAINed by reload,
   which is already stored in memory. if they're both discrete
   constants, then we create a new value reload2 and return its
   value number. if not possible, returns NO_NUMBER. */

#define OVERWRITE0(_v)      (((_v)->t & T_DISCRETE)                     \
                              && ((_v)->v == V_IMM)                     \
                              && ((_v)->sym == 0))

static int overwrite(struct block *b, struct reload *new,
                                      struct reload *reload)
{
    struct value *new_v = &VALUE(new->number);
    struct value *reload_v = &VALUE(reload->number);

    union con con;
    int shift;
    int width;

    /* they must both be discrete, pure constants */

    if (!OVERWRITE0(new_v) || !OVERWRITE0(reload_v))
        return NO_NUMBER;

    /* looks good. effect a bitfield insertion */

    width = t_size(new_v->t) * BITS_PER_BYTE;
    shift = (new->offset - reload->offset) * BITS_PER_BYTE;

    con.i = reload_v->con.i;
    con.i &= ~(BIT_MASK(width) << shift);
    con.i |= (new_v->con.i & BIT_MASK(width)) << shift;

    return imm(b, reload_v->t, con, 0);
}

/* I_LIR_STORE: we remember the value we store at a location in case someone
   tries to load it again. if the current store overwrites a previous store
   that has not been committed to memory, we can modify or nuke the earlier
   store. a store also invalidates any cached reloads entries that we can't
   guarantee are not aliased by that store. */

static void store(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct reload *reload;
    struct reload new;
    int n;

    label(b, i, 0);     /* address */
    label(b, i, 1);     /* data stored */

    address(b, insn->operand[0].number, &new);
    new.number = insn->operand[1].number;
    new.store = insn->is_volatile ? 0 : &INSN(b, i);

    for (n = 0; n < NR_RELOADS(b); ++n) {
        reload = &RELOAD(b, n);

        /* if the new store completely writes over a previous
           store, then, we can nuke that earlier store entirely,
           then forget we ever knew about it. we request another
           dvn pass, since we may have eliminated a dependency. */

        switch (overlaps(reload, &new))
        {
        case EXACT:
        case CONTAIN:
            if (reload->store) {
                *reload->store = &nop_insn;
                opt_request |= OPT_DEAD | OPT_LIR_DVN;
            }

            goto zap;
        }

        switch (overlaps(&new, reload))
        {
        case CONTAIN:
            /* if the new store partially overwrites a previous
               store, then we may be able to update that earlier
               store with data from the current store, and then
               ditch the current store as redundant. */

            reload->number = overwrite(b, &new, reload);

            if (reload->number == NO_NUMBER)
                goto zap;
            else {
                if (reload->store && !insn->is_volatile) {
                    struct insn *patch_insn;

                    /* the previous store is uncommitted, so we can
                       backpatch it with data from the current store */

                    patch_insn = new_insn(I_LIR_STORE, 0);
                    patch_insn->operand[0] = (*reload->store)->operand[0];

                    IMM_OPERAND(&patch_insn->operand[1], 0, 0,
                                VALUE(reload->number).con, 0);

                    patch_insn->operand[1].t = VALUE(reload->number).t;
                    *reload->store = patch_insn;

                    /* that renders the present store redundant, so we
                       kill it. this also signals the last line of this
                       function to forget the new reload (see below) */

                    new.store = 0;
                    INSN(b, i) = &nop_insn;
                    opt_request |= OPT_DEAD;
                }

                continue;
            }

            /* FALLTHRU */

        case OVERLAP:
            goto zap;

        /* the only case remaining is 0 == no overlap,
           since EXACT is 'commutative' and will have
           been dealt with in the previous switch. */

        default:
            continue;
        }

zap:    VECTOR_DELETE(b->dvn.reloads, n, 1);
        --n;
    }

    /* the check for NOP prevents the insertion of an entry
       into the reload table when it's redundant, see above */

    if (INSN(b, i) != &nop_insn) new_reload(b, &new);
}

/* compute the intersection of exprs, regvals, reloads
   of blocks b and pred_b with the result in block b. */

static void meet0(struct block *b, struct block *pred_b)
{
    int i, pred_i;

    /* the exprs vectors are ordered by value number (see
       new_number), so we can perform an efficient merge */

    i = 0;
    pred_i = 0;

    while ((i < NR_EXPRS(b)) && (pred_i < NR_EXPRS(pred_b)))
    {
        struct value *v = EXPR(b, i);
        struct value *pred_v = EXPR(pred_b, pred_i);

        if (pred_v->number < v->number)
            ++pred_i;
        else if (v->number < pred_v->number)
            VECTOR_DELETE(b->dvn.exprs, i, 1);
        else
            ++i;
    }

    RESIZE_VECTOR(b->dvn.exprs, i);     /* discard any remaining */

    /* merge regvals using almost exactly the same logic: we
       need an additional check to ensure regs agree on values. */

    i = 0;
    pred_i = 0;

    while ((i < NR_REGVALS(b)) && (pred_i < NR_REGVALS(pred_b)))
    {
        struct regval *rv = &REGVAL(b, i);
        struct regval *pred_rv = &REGVAL(pred_b, pred_i);

        if (REG_PRECEDES(pred_rv->reg, rv->reg))
            ++pred_i;   /* ignore */
        else if (REG_PRECEDES(rv->reg, pred_rv->reg)
                || (rv->number != pred_rv->number))
            VECTOR_DELETE(b->dvn.regvals, i, 1);
        else
            ++i;
    }

    RESIZE_VECTOR(b->dvn.regvals, i);

    /* again, very similar logic to meet on the reloads. notice
       we ignore the store field since its value doesn't affect
       our choice to keep it- it will be invalidated in dvn0() */

    i = 0;
    pred_i = 0;

    while ((i < NR_RELOADS(b)) && (pred_i < NR_RELOADS(pred_b)))
    {
        struct reload *rel = &RELOAD(b, i);
        struct reload *pred_rel = &RELOAD(pred_b, pred_i);

        if (reload_precedes(pred_rel, rel))
            ++pred_i;
        else if (reload_precedes(rel, pred_rel)
                || (rel->number != pred_rel->number))
            VECTOR_DELETE(b->dvn.reloads, i, 1);
        else
            ++i;
    }

    RESIZE_VECTOR(b->dvn.reloads, i);
}

/* merge the state (exprs, regvals, and reloads) from all the preds of b.

   the RPO sequence in which we process blocks guarantees that all preds of
   the current block will have already been processed, unless those preds
   reach it via a back edge. the latter preds will have empty state which
   means the result will be empty, which is the desired behavior, since we
   can't carry data around loops. due to the mechanism we use to merge the
   states (by updating the current block's state as we go) we must keep a
   special eye out for blocks which are their own preds, and avoid merging. */

static void inherit0(struct block *b)
{
    int n;

    if (!is_pred(b, b)) {
        for (n = 0; n < NR_PREDS(b); ++n) {
            struct block *pred_b = PRED(b, n);

            if (n == 0) {
                DUP_VECTOR(b->dvn.exprs, pred_b->dvn.exprs);
                DUP_VECTOR(b->dvn.regvals, pred_b->dvn.regvals);
                DUP_VECTOR(b->dvn.reloads, pred_b->dvn.reloads);
            } else
                meet0(b, pred_b);
        }
    }
}

static void dvn0(struct block *b)
{
    struct insn *insn;
    int i, n;
    int number;

    inherit0(b);
    invalidate(b, 0);

    FOR_EACH_INSN(b, i, insn) {
        switch (insn->op)
        {
                /* operations are handled by common code */

        case I_LIR_FRAME:   case I_LIR_CAST:    case I_LIR_NEG:
        case I_LIR_COM:     case I_LIR_ADD:     case I_LIR_SUB:
        case I_LIR_MUL:     case I_LIR_DIV:     case I_LIR_MOD:
        case I_LIR_SHR:     case I_LIR_SHL:     case I_LIR_AND:
        case I_LIR_OR:      case I_LIR_XOR:     case I_LIR_BSF:
        case I_LIR_BSR:

                            break;

                /* a few require special handling */

        case I_LIR_MOVE:    label(b, i, 1);
                            assoc(b, insn->operand[0].reg,
                                insn->operand[1].number);
                            continue;

        case I_LIR_LOAD:    load(b, i); continue;
        case I_LIR_STORE:   store(b, i); continue;

                /* the remaining instructions are not subject to dvn */

        default:            invalidate(b, insn); continue;
        }

        /* all instructions dealt with here have a destination O_REG in
           operand[0], and 0..2 O_REG or O_IMM sources in operand[1..3].
           none of them use or def memory or have any other side effects. */

        for (n = 1; n < I_OPERANDS(insn->op); ++n) label(b, i, n);

        if ((I_OPERANDS(insn->op) == 3)
          && (insn->operand[1].number < insn->operand[2].number))
            commute_insn(insn); /* normalize binary operations */

        number = match(b, insn);

        if (number == NO_NUMBER) {
            number = new_number(b, V_EXPR, insn->operand[0].t);
            VALUE(number).insn = insn;
            assoc(b, insn->operand[0].reg, number);
        } else
            replace(b, i, number, 0);
    }
}

void opt_lir_dvn(void)
{
    struct block *b;

    INIT_VECTOR(tmp_regs, &local_arena);
    INIT_VECTOR(values, &local_arena);
    INIT_VECTOR(imms, &local_arena);

    FOR_ALL_BLOCKS(b) {
        INIT_VECTOR(b->dvn.exprs, &local_arena);
        INIT_VECTOR(b->dvn.regvals, &local_arena);
        INIT_VECTOR(b->dvn.reloads, &local_arena);
    }

    sequence_blocks(0);         /* RPO walk */
    FOR_ALL_BLOCKS(b) dvn0(b);

    ARENA_FREE(&local_arena);

    /* we normalize binary operators based on value numbers, which
       is not normalized as far as other passes are concerned... */

    opt_request |= OPT_LIR_NORM;
}

/* vi: set ts=4 expandtab: */
