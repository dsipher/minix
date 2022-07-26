/*****************************************************************************

  dep.c                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "block.h"
#include "dep.h"

/* for each insn this, we examine each of its predecessors
   that in the block, in turn, deciding if this depends on
   that. this depends on that iff:

            1. they are both marked volatile, OR
            2. this USEs a reg DEFd by that, OR
            3. that USEs a reg DEFd by this, OR
            4. this and that both DEF the same reg.

   #1 is c-specific: volatile operations can't be re-ordered.
   the remaining rules are conventional, e.g, muchnick 9.2.

   we make use of the pseudo-registers REG_CC and REG_MEM, so, e.g.,
   #2 could equally read `if this USEs memory and that DEFs memory'.

   this analysis is O(n^2), but basic blocks are [should be] short. */

void dep_analyze(struct block *b)
{
    int this;                   /* the insn whose deps we are building */
    struct insn *this_insn;
    VECTOR(reg) this_uses;
    VECTOR(reg) this_defs;

    int that;                   /* ... and some insn prior to it in b */
    struct insn *that_insn;
    VECTOR(reg) that_uses;
    VECTOR(reg) that_defs;
    VECTOR(reg) tmp_regs;

    TRUNC_VECTOR(b->deps);

    INIT_VECTOR(this_uses, &local_arena);
    INIT_VECTOR(this_defs, &local_arena);
    INIT_VECTOR(that_uses, &local_arena);
    INIT_VECTOR(that_defs, &local_arena);
    INIT_VECTOR(tmp_regs, &local_arena);

    for (this = 1; this < NR_INSNS(b); ++this) {
        this_insn = INSN(b, this);

        TRUNC_VECTOR(this_uses);
        insn_uses(this_insn, &this_uses, I_FLAG_USES_CC
                                       | I_FLAG_USES_MEM);

        TRUNC_VECTOR(this_defs);
        insn_defs(this_insn, &this_defs, I_FLAG_DEFS_CC
                                       | I_FLAG_DEFS_MEM);

        for (that = (this - 1); that >= 0; --that) {
            that_insn = INSN(b, that);

            TRUNC_VECTOR(that_uses);
            insn_uses(that_insn, &that_uses, I_FLAG_USES_CC
                                           | I_FLAG_USES_MEM);

            TRUNC_VECTOR(that_defs);
            insn_defs(that_insn, &that_defs, I_FLAG_DEFS_CC
                                           | I_FLAG_DEFS_MEM);

            if (that_insn->is_volatile && this_insn->is_volatile)
                goto depends;

            intersect_regs(&tmp_regs, &this_uses, &that_defs);
            if (!EMPTY_VECTOR(tmp_regs)) goto depends;

            intersect_regs(&tmp_regs, &that_uses, &this_defs);
            if (!EMPTY_VECTOR(tmp_regs)) goto depends;

            intersect_regs(&tmp_regs, &this_defs, &that_defs);
            if (!EMPTY_VECTOR(tmp_regs)) goto depends;

            continue;

depends:    GROW_VECTOR(b->deps, 1);
            VECTOR_LAST(b->deps).i = this;
            VECTOR_LAST(b->deps).j = that;
        }
    }

    ARENA_FREE(&local_arena);
}

int deps(struct block *b, int i, int j)
{
    int n;

    for (n = 0; n < NR_DEPS(b); ++n)
        if ((DEP(b, n).i == i)
          && DEP(b, n).j == j)
            return 1;

    return 0;
}

#ifdef DEBUG

void out_deps(struct block *b, int i)
{
    int n;
    int c = 0;

    for (n = 0; n < NR_DEPS(b); ++n)
        if (DEP(b, n).i == i) {
            if (!c) {
                OUTC('#');
                c = 1;
            }

            out(" %d", DEP(b, n).j);
        }
}

#endif /* DEBUG */

/* vi: set ts=4 expandtab: */
