/*****************************************************************************

   dep.c                                                  minix c compiler

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
