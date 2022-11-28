/*****************************************************************************

   live.c                                                 minix c compiler

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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
#include "heap.h"
#include "reg.h"
#include "block.h"
#include "live.h"

/* conventional live-variable analysis. the result of the
   analysis is a populated struct live in every block.

   analysis proceeds in three phases. first, local0() resets the block's
   state, and then iterates over each insn in the block in order and calls
   use0() and def0() to build the range entries and USE and DEF sets. then
   iterative analysis with global0() computes the IN and OUT sets. finally,
   we fix up the ranges by extending the last USE of LIVE OUT ranges.

   the sequencing of the analysis is important. in particular, use0()/def0()
   rely on the fact that block insns will be processed in order and that the
   USEs for an insn will be recorded first, then its DEFs. by making these
   assumptions, they can build the ranges vector very efficiently. */

#define NR_LIVE_REGS    8       /* default for DEF(), USE(), etc. sets */
#define NR_LIVE_RANGES  32      /* default for live ranges */

static VECTOR(reg) tmp_regs;        /* working storage, allocated in */
static VECTOR(reg) tmp_in;          /* the local_arena by live_analyze() */
static VECTOR(reg) tmp_out;

static void def0(struct block *b, int reg, int def, int add)
{
    int r;

    for (r = NR_RANGES(b); r--; ) {
        if (RANGE(b, r).def > def) continue;
        if (RANGE(b, r).def < def) break;
        if (REG_PRECEDES(RANGE(b, r).reg, reg)) break;
    }

    r += 1;

    VECTOR_INSERT(b->live.ranges, r, 1);
    RANGE(b, r).def = def;
    RANGE(b, r).reg = reg;
    RANGE(b, r).use = def;

    if (!contains_reg(&b->live.use, reg) && add)
        add_reg(&b->live.def, reg);
}

static void use0(struct block *b, int reg, int use, int add)
{
    int def;
    int r;

retry:
    for (r = NR_RANGES(b); r--; ) {
        if (RANGE(b, r).def >= use) continue;

        if (RANGE(b, r).reg == reg) {   /* one reason why the sequence of */
            def = RANGE(b, r).def;      /* analysis is important: we assume */
            break;                      /* that this is the most recent DEF */
        }                               /* relative to the USE in question */
    }

    if (r < 0) {
        /* there is no DEF for this reg in this block. add to the
           USE set, create its placeholder DEF, then try again. */

        def0(b, reg, INSN_INDEX_BEFORE, 0);
        if (add) add_reg(&b->live.use, reg);
        goto retry;
    } else {
        r += 1;

        VECTOR_INSERT(b->live.ranges, r, 1);
        RANGE(b, r).def = def;
        RANGE(b, r).reg = reg;
        RANGE(b, r).use = use;
    }
}

#define LOCAL0(SPECIAL)                                                     \
    do {                                                                    \
        if (flags & LIVE_ANALYZE_##SPECIAL) {                               \
            if (INSN_USES_##SPECIAL(insn)) use0(b, REG_##SPECIAL, i, 1);    \
            if (INSN_DEFS_##SPECIAL(insn)) def0(b, REG_##SPECIAL, i, 1);    \
        }                                                                   \
    } while (0)

#define LOCAL1(usedef)                                                      \
    do {                                                                    \
        TRUNC_VECTOR(tmp_regs);                                             \
        insn_##usedef##s(insn, &tmp_regs, 0);                               \
        FOR_EACH_REG(tmp_regs, j, reg) usedef##0(b, reg, i, 1);             \
    } while (0)

static void local0(struct block *b, int flags)
{
    struct insn *insn;
    int i, j;
    int reg;

    TRUNC_VECTOR(b->live.use);
    TRUNC_VECTOR(b->live.def);
    TRUNC_VECTOR(b->live.in);
    TRUNC_VECTOR(b->live.out);
    TRUNC_VECTOR(b->live.ranges);

    FOR_EACH_INSN(b, i, insn) {
        LOCAL0(CC);
        LOCAL0(MEM);

        if (flags & LIVE_ANALYZE_REGS) {
            LOCAL1(use);
            LOCAL1(def);
        }
    }

    if ((flags & LIVE_ANALYZE_REGS)
      && SWITCH_BLOCK(b) && OPERAND_REG(&b->control))
        use0(b, b->control.reg, INSN_INDEX_BRANCH, 1);

    if ((flags & LIVE_ANALYZE_CC) && conditional_block(b))
        use0(b, REG_CC, INSN_INDEX_BRANCH, 1);
}

static int global0(struct block *b)
{
    int ret = ITERATE_OK;
    struct block *succ_b;
    int i;

    /* OUT(b) = V IN(succs) */

    TRUNC_VECTOR(tmp_out);

    for (i = 0; i < NR_SUCCS(b); ++i) {
        succ_b = SUCC(b, i).b;
        DUP_VECTOR(tmp_regs, tmp_out);
        union_regs(&tmp_out, &tmp_regs, &succ_b->live.in);
    }

    if (!same_regs(&tmp_out, &b->live.out)) {
        DUP_VECTOR(b->live.out, tmp_out);
        ret = ITERATE_AGAIN;
    }

    /* IN(b) = USE(b) V (OUT(b) - DEF(b)) */

    diff_regs(&tmp_regs, &b->live.out, &b->live.def);
    union_regs(&tmp_in, &b->live.use, &tmp_regs);

    if (!same_regs(&tmp_in, &b->live.in)) {
        DUP_VECTOR(b->live.in, tmp_in);
        ret = ITERATE_AGAIN;
    }

    return ret;
}

void live_analyze(int flags)
{
    struct block *b;
    int i;
    int reg;

    INIT_VECTOR(tmp_regs, &local_arena);
    INIT_VECTOR(tmp_in, &local_arena);
    INIT_VECTOR(tmp_out, &local_arena);

    FOR_ALL_BLOCKS(b) local0(b, flags);

    sequence_blocks(1);
    iterate_blocks(global0);

    FOR_ALL_BLOCKS(b)
        FOR_EACH_REG(b->live.out, i, reg)
            use0(b, reg, INSN_INDEX_AFTER, 0);

    ARENA_FREE(&local_arena);
}

/* we find ranges by naive forward scans. the ranges vectors are rarely
   (never) large enough to warrant a more complex algorithm, especially
   as the comparisons are ordered to cooperate with branch prediction. */

int range_by_reg(struct block *b, int reg)
{
    int r;

    for (r = 0; r < NR_RANGES(b); ++r)
        if (RANGE(b, r).reg == reg)
            return r;
}

int range_by_use(struct block *b, int reg, int use)
{
    int r;

    for (r = 0; r < NR_RANGES(b); ++r)
        if ((RANGE(b, r).use == use) && (RANGE(b, r).reg == reg))
            return r;
}

int range_by_def(struct block *b, int reg, int def)
{
    int r;

    for (r = 0; r < NR_RANGES(b); ++r)
        if ((RANGE(b, r).def == def) && (RANGE(b, r).reg == reg))
            return r;
}

/* given our ordering, the last use is the last entry
   at or after r which bears the same def, reg values */

int range_span(struct block *b, int r)
{
    while (NEXT_IN_RANGE(b, r)) ++r;
    return RANGE(b, r).use;
}

int range_doa(struct block *b, int reg, int def)
{
    int r = range_by_def(b, reg, def);
    return !NEXT_IN_RANGE(b, r);            /* true if def is only entry */
}

int range_spans_death(struct block *b, int r)
{
    int reg;        /* reg of the range */
    int first;      /* the DEF of reg */
    int last;       /* its span (last USE) */
    int r2;         /* the other range in question */

    while (PREV_IN_RANGE(b, r)) --r;
    reg = RANGE(b, r).reg;
    first = RANGE(b, r).def;
    last = range_span(b, r);

    for (r2 = 0; r2 < NR_RANGES(b); ++r2) {
        /* we've spanned a death when a range's last
           USE is between our DEF and our last USE. */

        if ((REG_TYPE(reg) == REG_TYPE(RANGE(b, r2).reg))
          && (RANGE(b, r2).use > first)
          && (RANGE(b, r2).use < last)
          && !NEXT_IN_RANGE(b, r2))
            return 1;
    }

    return 0;
}

int range_use_count(struct block *b, int r)
{
    int count = 0;

    while (PREV_IN_RANGE(b, r)) --r;

    for (;;)
    {
        if (RANGE(b, r).def != RANGE(b, r).use)
            ++count;

        if (!NEXT_IN_RANGE(b, r))
            return count;

        ++r;
    }
}

int live_across(struct block *b, int reg, int i)
{
    int r;

    for (r = 0; r < NR_RANGES(b) && RANGE(b, r).def < i; ++r) {
        if (RANGE(b, r).reg != reg) continue;

        /* we're positioned over the placeholder/head for a
           DEF of reg. fast forward to end of this chain */

        while (NEXT_IN_RANGE(b, r)) ++r;

        /* and now use tells us the span of this DEF. */

        if (RANGE(b, r).use > i) return 1;
    }

    return 0;
}

/* register Y interferes a range r of register X iff r is live
   when Y is DEFd, except when that DEF is a copy [or extension]
   of X to Y. this relation can be computed fairly efficiently
   since the ranges are ordered by DEFs: we simply scan forward
   from the range to find all the DEFs in its span. technically
   this is O(n) in the number of range entries, but in practice
   most ranges are short so we only scan a subset of entries.

   GP and XMM registers never interfere, as they are disjoint.

   note that our definition of interference is asymmetric, and
   thus can be used to build either a conventional interference
   graph or a `containment' graph (a la cooper & simpson, 1998). */

void range_interf(struct block *b, int r, VECTOR(reg) *regs)
{
    int span;
    int x, y;
    int src, dst;
    int def;
    int x_def;

    x = RANGE(b, r).reg;
    x_def = RANGE(b, r).def;

    while (NEXT_IN_RANGE(b, r)) ++r;
    span = RANGE(b, r).use;
    ++r;

    while ((r < NR_RANGES(b)) && (RANGE(b, r).def < span)) {
        if (RANGE_HEAD(b, r)) {
            def = RANGE(b, r).def;
            y = RANGE(b, r).reg;

            if ( (def >= INSN_INDEX_FIRST)
              && (def <= INSN_INDEX_LAST)
              &&    (insn_is_copy(INSN(b, def), &dst, &src)
                  ||  insn_is_ext(INSN(b, def), &dst, &src) )
              && (dst == y) && (src == x))
                /* copies from x -> y don't count */ ;
            else
                if ((def != x_def)        /* simultaneous DEFs don't count */
                 && (REG_TYPE(x) == REG_TYPE(y))) /* must be in same class */
                    add_reg(regs, y);
        }

        ++r;
    }
}

int live_ccs(struct block *b, int i)
{
    struct insn *insn;
    int ccs = 0;
    int cc;
    int r, n;

    insn = INSN(b, i);

    if (INSN_DEFS_CC(insn)) {
        r = range_by_def(b, REG_CC, i);

        while (NEXT_IN_RANGE(b, r))     /* DEF skipped in first iteration */
        {
            ++r;

            if (RANGE(b, r).use == INSN_INDEX_AFTER) {
                ccs = CCSET_ALL;
                break;
            } else if (RANGE(b, r).use == INSN_INDEX_BRANCH) {
                for (n = 0; n < NR_SUCCS(b); ++n) {
                    cc = SUCC(b, n).cc;
                    CCSET_SET(ccs, cc);
                }
            } else {
                insn = INSN(b, RANGE(b, r).use);

                if (I_LIR_IS_SETCC(insn->op))
                    cc = I_LIR_SETCC_TO_CC(insn->op);
                else if (I_MCH_IS_SETCC(insn->op))
                    cc = I_MCH_SETCC_TO_CC(insn->op);
                else if (I_MCH_IS_CMOVCCL(insn->op))
                    cc = I_MCH_CMOVCCL_TO_CC(insn->op);
                else
                    cc = I_MCH_CMOVCCQ_TO_CC(insn->op);

                CCSET_SET(ccs, cc);
            }
        }
    }

    return ccs;
}

int live_kill_dead(struct block *b, int i)
{
    int ret = 0;
    int r;

    for (r = 0; r < NR_RANGES(b); ++r) {
        /* if a USE is live-in, by removing this USE it may
           no longer be live-in, which has cascading effects. */

        if (RANGE(b, r).use == i) {
            if (RANGE(b, r).def == INSN_INDEX_BEFORE)
                ret = 1;

            VECTOR_DELETE(b->live.ranges, r, 1);
            --r;    /* revisit index */
        }
    }

    return ret;
}

void new_live(struct block *b)
{
    INIT_VECTOR(b->live.def, &func_arena);
    INIT_VECTOR(b->live.use, &func_arena);
    INIT_VECTOR(b->live.in, &func_arena);
    INIT_VECTOR(b->live.out, &func_arena);
    INIT_VECTOR(b->live.ranges, &func_arena);
}

#ifdef DEBUG

void out_live(struct block *b)
{
    int r;

    OUTC('\n');
    OUTS(";      DEF: "); out_regs(&b->live.def); OUTC('\n');
    OUTS(";      USE: "); out_regs(&b->live.use); OUTC('\n');
    OUTS(";  LIVE IN: "); out_regs(&b->live.in); OUTC('\n');
    OUTS("; LIVE OUT: "); out_regs(&b->live.out); OUTC('\n');

    for (r = 0; r < NR_RANGES(b); ++r)
        out(";    RANGE: %r %d ... %d\n", RANGE(b, r).reg,
                                          RANGE(b, r).def,
                                          RANGE(b, r).use);
}

#endif /* DEBUG */

/* vi: set ts=4 expandtab: */
