/*****************************************************************************

   reach.c                                             tahoe/64 c compiler

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
#include "reach.h"

void new_reach(struct block *b)
{
    INIT_VECTOR(b->reach.in, &func_arena);
    INIT_VECTOR(b->reach.out, &func_arena);
    INIT_VECTOR(b->reach.gen, &func_arena);
}

static VECTOR(reg) tmp_regs;

/* decorate each register DEFd in each insn with a unique sub,
   starting with sub 1. the subs vector, indexed by reg index,
   holds the index of the last assigned sub. we do not touch
   machine registers; they always have a sub of 0. (we do not
   compute reaching definitions on any IR which references the
   machine regs, except when constructing webs for allocation.
   in that situation all references to a machine reg must be
   in the same web, anyway.) sub 0 on a pseudo-reg indicates
   a USE which has no associated DEFs (an uninitialized reg). */

static VECTOR(int) subs;                /* local_arena */
static VECTOR(reg) decorate_regs;       /* local_arena */

static void decorate0(struct block *b)
{
    struct insn *insn;
    int i, j, reg, new, *sub;

    FOR_EACH_INSN(b, i, insn) {
        TRUNC_VECTOR(decorate_regs);
        insn_defs(insn, &decorate_regs, 0);

        FOR_EACH_REG(decorate_regs, j, reg) {
            if (MACHINE_REG(reg)) continue;

            sub = &VECTOR_ELEM(subs, REG_INDEX(reg));
            ++*sub;
            new = reg;
            REG_SET_SUB(new, *sub);

            insn_substitute_reg(insn, reg, new, INSN_SUBSTITUTE_DEFS);
        }
    }
}

/* update reaching definitions. the state given is that
   before the execution of insn; the state is updated to
   reflect the effects of that insn. this is fast and
   easy due to the magic of replace_indexed_regs(). */

static VECTOR(reg) update_regs;

static void update(struct insn *insn, VECTOR(reg) *state)
{
    int i;

    TRUNC_VECTOR(update_regs);
    insn_defs(insn, &update_regs, 0);

    /* don't accumulate machine registers in reaching definitions: it is
       useless clutter. it would be better if insn_defs() did not insert
       them in the first place, but we have no means of requesting that */

    for (i = 0; i < VECTOR_SIZE(update_regs); ++i)
        if (MACHINE_REG(VECTOR_ELEM(update_regs, i))) {
            VECTOR_DELETE(update_regs, i, 1);
            --i; /* revisit index */
        }

    replace_indexed_regs(state, &update_regs);
}

/* start with the input state, fast forward to the
   insn in question, then select the relevant defs. */

static VECTOR(reg) reach_regs;

void reach(struct block *b, int i, int reg, VECTOR(reg) *defs)
{
    struct insn *insn;
    int j;

    DUP_VECTOR(reach_regs, b->reach.in);

    FOR_EACH_INSN(b, j, insn) {
        if (j == i) break;
        update(insn, &reach_regs);
    }

    select_indexed_regs(defs, &reach_regs, reg);
}

/* compute the GEN() set for the block into b->reach.gen.
   the vector is initially empty; we simply step through
   to the end of the block to compute the exit state. */

static void gen0(struct block *b)
{
    struct insn *insn;
    int i;

    FOR_EACH_INSN(b, i, insn) update(insn, &b->reach.gen);
}

/* iterative analysis:

   IN = V all preds(out)
   OUT = (IN - GEN) V GEN

   the computation of OUT is done by replace_indexed_regs(),
   so the expression above isn't entirely accurate; the set
   difference is computed without respect to reg subscripts,
   whereas the union is.

   terminate when OUT is unchanged from the previous iteration */

static VECTOR(reg) compute_regs;

static int compute0(struct block *b)
{
    int n;

    for (n = 0; n < NR_PREDS(b); ++n) {
        union_regs(&compute_regs, &b->reach.in, &PRED(b, n)->reach.out);
        SWAP(VECTOR(reg), compute_regs, b->reach.in);
    }

    DUP_VECTOR(compute_regs, b->reach.in);
    replace_indexed_regs(&compute_regs, &b->reach.gen);

    if (same_regs(&compute_regs, &b->reach.out))
        return ITERATE_OK;
    else {
        SWAP(VECTOR(reg), compute_regs, b->reach.out);
        return ITERATE_AGAIN;
    }
}

/* storage of webs. as mentioned above, these are usually called live
   ranges, but muchnick calls them webs, and we follow suit to avoid
   confusion with struct range (live.c). these are effectively three-
   dimensional arrays, though the dimensions vary a la java throughout.

          webs[r][n][i]

               |  |  |
               |  |  \.. the ith register in the nth web of register r
               |  \..... the nth web associated with basis register r
               \........ the basis register of interest, by REG_INDEX */

DEFINE_VECTOR(web, VECTOR(reg));
DEFINE_VECTOR(webs, VECTOR(web));

static VECTOR(webs) webs;

#define WEBS(r)     VECTOR_ELEM(webs, REG_INDEX(r))      /*    webs[r] */
#define NR_WEBS(r)  VECTOR_SIZE(WEBS(r))                 /*  # webs[r] */
#define WEB(r, n)   VECTOR_ELEM(WEBS(r), (n))            /* webs[r][n] */

/* each web is named (arbitrarily) its first member */

#define NAME(r, n)  VECTOR_ELEM(WEB((r), (n)), 0)

/* returns the name of the web containing reg.
   if no web is found, returns the reg unchanged. */

static int name(int reg)
{
    int n;

    for (n = 0; n < NR_WEBS(reg); ++n)
        if (contains_reg(&WEB(reg, n), reg))
            return NAME(reg, n);

    return reg;
}

/* regs have been determined to belong to the same web.
   merge0() updates the web information to reflect this.
   returns the NAME of the web regs were merged into. */

static VECTOR(reg) merge_regs;      /* local_arena */

static int merge0(VECTOR(reg) *regs)
{
    int r;      /* primary index */
    int m;      /* web we're merging into */
    int n;      /* web we're merging from */

    r = VECTOR_ELEM(*regs, 0);  /* never empty; build0 guarantees this */

    /* first, we look for any web which intersects regs. it doesn't
       matter which. this web will subsume all the overlapping webs. */

    for (m = 0; m < NR_WEBS(r); ++m) {
        intersect_regs(&merge_regs, regs, &WEB(r, m));
        if (!EMPTY_VECTOR(merge_regs)) break;
    }

    /* if we couldn't find any intersecting
       web, our job is easy: make a new one. */

    if (m == NR_WEBS(r)) {
        /* if we couldn't find any intersecting
           web, our job is easy: make a new one. */

        GROW_VECTOR(WEBS(r), 1);
        INIT_VECTOR(WEB(r, m), &local_arena);
        DUP_VECTOR(WEB(r, m), *regs);
    } else {
        /* m is the target web. first, fold the
           regs just discovered by build0(). */

        union_regs(&merge_regs, regs, &WEB(r, m));
        DUP_VECTOR(WEB(r, m), merge_regs);

        /* now fold each existing overlapping web into m.
           we don't need to examine webs n < m, because:

           1. m before the above step (folding in regs)
              couldn't have overlapped with n; else they
              would be merged already. so they can only
              overlap in the new regs,
           2. but m is the first web that overlaps with
              any regs; our initial search started at 0. */

        for (n = (m + 1); n < NR_WEBS(r); ++n) {
            intersect_regs(&merge_regs, regs, &WEB(r, n));

            if (!EMPTY_VECTOR(merge_regs)) {
                /* merge the contents of the webs into target
                   web and remove the web under consideration */

                union_regs(&merge_regs, &WEB(r, m), &WEB(r, n));
                DUP_VECTOR(WEB(r, m), merge_regs);

                VECTOR_DELETE(WEBS(r), n, 1);
                --n; /* revisit this index */
            }
        }
    }

    return NAME(r, m);
}

/* scan block b and build webs. for each reg USEd in an insn, we
   determine its reaching DEFs, and then tell merge0() that these
   DEFs must be part of the same web. we then subscript the USE
   with the [transient] NAME of the web for redecorate0().

   uses: tmp_regs
         reach_regs (borrowed from reach() which is not called) */

static VECTOR(reg) build_regs;      /* local_arena */

static int build1(int reg, VECTOR(reg) *state)
{
    TRUNC_VECTOR(build_regs);
    select_indexed_regs(&build_regs, state, reg);

    /* build_regs holds all the DEFs that reach this USE of reg.
       if reg is already subscripted, it means decorate0() added
       it, which in turns means the reg is USEd and DEFd in the
       same operand, i.e., it's an update operand in a two-address
       MCH insn. in that case we need to add reg's subscript to the
       web as well, since the reg obviously can't be separated. */

    if (REG_SUB(reg)) add_reg(&build_regs, reg);

    /* if build_regs is empty here, it means no DEFs reached this
       USE, so the reg holds junk. we leave the subscript 0. this
       USE will appear to be LIVE IN, and further, all such USEs
       of the same reg will appear to belong to the same web. both
       dependencies are bogus and overly constrain the allocator. */

    if (EMPTY_VECTOR(build_regs))
        return reg;
    else
        return merge0(&build_regs);
}

static void build0(struct block *b)
{
    struct insn *insn;
    int i, j, reg;

    /* we reuse reach()'s regs to hold the current
       state, since reach() will not be called */

    DUP_VECTOR(reach_regs, b->reach.in);

    FOR_EACH_INSN(b, i, insn) {
        TRUNC_VECTOR(tmp_regs);
        insn_uses(insn, &tmp_regs, 0);

        FOR_EACH_REG(tmp_regs, j, reg) {
            if (MACHINE_REG(reg)) continue;
            insn_substitute_reg(insn, reg, build1(reg, &reach_regs),
                                INSN_SUBSTITUTE_USES);
        }

        update(insn, &reach_regs);
    }

    if (SWITCH_BLOCK(b) && OPERAND_REG(&b->control))
        b->control.reg = build1(b->control.reg, &reach_regs);
}

/* once all the webs have been built, we go back and relabel all the regs
   so that the subscript of each USE matches the NAME of its associated web.
   build0() assigned subs to USEs already, but the NAMEs can change as webs
   are merged, so we need a final pass. no webs are made for machine regs
   or pseudo-regs USEd with no reaching DEFs, so this code will leave them
   undisturbed, as they should be. uses: tmp_regs */

#define REDECORATE0(uses, USES)                                             \
    do {                                                                    \
        int j, reg;                                                         \
                                                                            \
        TRUNC_VECTOR(tmp_regs);                                             \
        insn_##uses(insn, &tmp_regs, 0);                                    \
                                                                            \
        FOR_EACH_REG(tmp_regs, j, reg)                                      \
            insn_substitute_reg(insn, reg, name(reg),                       \
                                INSN_SUBSTITUTE_##USES);                    \
    } while (0)

static void redecorate0(struct block *b)
{
    struct insn *insn;
    int i;

    FOR_EACH_INSN(b, i, insn) {
        REDECORATE0(uses, USES);
        REDECORATE0(defs, DEFS);
    }

    if (SWITCH_BLOCK(b) && OPERAND_REG(&b->control))
        b->control.reg = name(b->control.reg);
}

void reach_analyze(int flags)
{
    struct block *b;
    int i;

    INIT_VECTOR(decorate_regs, &local_arena);   /* for decorate0() */
    INIT_VECTOR(merge_regs, &local_arena);      /* for merge0() */
    INIT_VECTOR(build_regs, &local_arena);      /* for build0()/build1() */
    INIT_VECTOR(tmp_regs, &local_arena);

    INIT_VECTOR(subs, &local_arena);
    RESIZE_VECTOR(subs, nr_assigned_regs);
    MEMSET_VECTOR(subs, 0);

    FOR_ALL_BLOCKS(b) {
        TRUNC_VECTOR(b->reach.in);
        TRUNC_VECTOR(b->reach.out);
        TRUNC_VECTOR(b->reach.gen);
    }

    FOR_ALL_BLOCKS(b) decorate0(b);
    FOR_ALL_BLOCKS(b) gen0(b);

    sequence_blocks(0);
    iterate_blocks(compute0);

    if (flags & REACH_ANALYZE_WEBS) {
        INIT_VECTOR(webs, &local_arena);
        RESIZE_VECTOR(webs, nr_assigned_regs);

        for (i = 0; i < nr_assigned_regs; ++i)
            /* can't use WEBS() since i is not a reg... */
            INIT_VECTOR(VECTOR_ELEM(webs, i), &local_arena);

        FOR_ALL_BLOCKS(b) build0(b);
        FOR_ALL_BLOCKS(b) redecorate0(b);
    }

    ARENA_FREE(&local_arena);
}

/* reach() is called after analysis is complete; its temporary must come
   from the func_arena. reach() invokes update(), so the same applies to
   its temporary. compute_regs is SWAPped with block vectors, so it must
   come from the same arena they do which, again, is func_arena. */

void reset_reach(void)
{
    INIT_VECTOR(reach_regs, &func_arena);
    INIT_VECTOR(update_regs, &func_arena);
    INIT_VECTOR(compute_regs, &func_arena);
}

#ifdef DEBUG

void out_reach(struct block *b)
{
    OUTC('\n');
    OUTS("; REACH  IN: "); out_regs(&b->reach.in);  OUTC('\n');
    OUTS("; REACH GEN: "); out_regs(&b->reach.gen); OUTC('\n');
    OUTS("; REACH OUT: "); out_regs(&b->reach.out); OUTC('\n');
}

#endif /* DEBUG */

/* vi: set ts=4 expandtab: */
