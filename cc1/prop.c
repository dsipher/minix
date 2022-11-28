/*****************************************************************************

   prop.c                                                 minix c compiler

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
#include "block.h"
#include "reg.h"
#include "opt.h"
#include "prop.h"

/* all prop block data is allocated out of the
   local_arena at the beginning of each pass */

static void alloc0(struct block *b)
{
    INIT_VECTOR(b->prop.state, &local_arena);
    INIT_VECTOR(b->prop.defs, &local_arena);
    INIT_BITVEC(b->prop.gen, &local_arena);
    INIT_BITVEC(b->prop.kill, &local_arena);
    INIT_BITVEC(b->prop.in, &local_arena);
    INIT_BITVEC(b->prop.out, &local_arena);
}

/* starting from an initial state, we iterate over every
   insn in the block, and perform local propagation:

        1. substitute each reg USEd in the insn with
           an antecedent, if there's an available copy,
        2. remove available copies associated with any
           regs DEFd by the insn from our local state,
        3. if insn is a copy, add it to the local state.

   we remember all regs DEFd in this block and add them to props.defs.

   this is run twice per block. in the first go, the initial state is empty,
   and thus it performs local propagation within the block. the exit state
   becomes GEN(b) and prop.defs is populated with data to compute KILL(b).
   after global propagation, the initial state is imported from the results,
   and we are run a second time to complete the propagation into the block */

static VECTOR(reg) tmp_regs;
static VECTOR(reg) tmp_defs;

static void local0(struct block *b)
{
    struct insn *insn;
    int i, j, k, src, dst;

    FOR_EACH_INSN(b, i, insn) {
        for (k = 0; k < NR_PROPS(b); ++k) {
            if (insn_substitute_reg(insn, PROP(b, k).dst,
                                          PROP(b, k).src,
                                          INSN_SUBSTITUTE_USES))
                opt_request |= OPT_DEAD | OPT_LIR_NORM | OPT_LIR_REASSOC;
        }

        TRUNC_VECTOR(tmp_defs);
        insn_defs(insn, &tmp_defs, 0);

        TRUNC_VECTOR(tmp_regs);
        union_regs(&tmp_regs, &b->prop.defs, &tmp_defs);
        SWAP(VECTOR(reg), b->prop.defs, tmp_regs);

        FOR_EACH_REG(tmp_defs, j, dst)
            for (k = 0; k < NR_PROPS(b); ++k)
                if ((PROP(b, k).dst == dst) || (PROP(b, k).src == dst)) {
                    VECTOR_DELETE(b->prop.state, k, 1);
                    --k;
                }

        if (insn_is_copy(insn, &dst, &src)) {
            GROW_VECTOR(b->prop.state, 1);
            VECTOR_LAST(b->prop.state).blkno = b->asmlab;
            VECTOR_LAST(b->prop.state).index = i;
            VECTOR_LAST(b->prop.state).dst = dst;
            VECTOR_LAST(b->prop.state).src = src;
        }
    }

    if (SWITCH_BLOCK(b) && OPERAND_REG(&b->control))
        for (k = 0; k < NR_PROPS(b); ++k)
            if (b->control.reg == PROP(b, k).dst) {
                b->control.reg = PROP(b, k).src;
                opt_request |= OPT_DEAD;
            }
}

/* all global copies are collected here. their indices match
   those of the bit vectors in the global prop per-block data */

static VECTOR(copy) u;              /* the universe */
static int u_card;                  /* the cardinality of u */
static int next_u;                  /* next available index */

/* populate u with the universal entries originating
   in this block and initialize its GEN() set */

static void gen0(struct block *b)
{
    int i;

    RESIZE_BITVEC(b->prop.gen, u_card);
    CLR_BITVEC(b->prop.gen);

    for (i = 0; i < NR_PROPS(b); ++i) {
        VECTOR_ELEM(u, next_u) = PROP(b, i);
        BITVEC_SET(b->prop.gen, next_u);
        ++next_u;
    }
}

/* now that u is populated, each block can construct its KILL() set by
   marking off entries with regs it has DEFd. this has poor asymptotic
   performance, but defs and the universe should be small. if we find
   this too inefficient in practice, we can use an intermediate step to
   build a per-reg KILL() in one pass over the universe, then merge here */

static void kill0(struct block *b)
{
    int i;

    RESIZE_BITVEC(b->prop.kill, u_card);
    CLR_BITVEC(b->prop.kill);

    for (i = 0; i < VECTOR_SIZE(u); ++i)
        if (contains_reg(&b->prop.defs, VECTOR_ELEM(u, i).dst)
          || contains_reg(&b->prop.defs, VECTOR_ELEM(u, i).src))
            BITVEC_SET(b->prop.kill, i);
}

/* initialize block state for iterative analysis */

static void init0(struct block *b)
{
    RESIZE_BITVEC(b->prop.in, u_card);
    RESIZE_BITVEC(b->prop.out, u_card);

    if (b == entry_block) {
        CLR_BITVEC(b->prop.in);
        CLR_BITVEC(b->prop.out);
    } else {
        SET_BITVEC(b->prop.in);
        SET_BITVEC(b->prop.out);
        BITVEC_BIC(b->prop.out, b->prop.kill);
        BITVEC_OR(b->prop.out, b->prop.gen);
    }
}

/* global propagation computation

   IN(b) = ^ OUT(preds)
   OUT(b) = GEN(b) V (IN(b) - KILL(b))

   convergence when IN(b) sets stabilize. */

static VECTOR(bitvec) tmp_bits;

static int global0(struct block *b)
{
    int n;

    CLR_BITVEC(tmp_bits);                           /* IN() -> tmp_bits */

    for (n = 0; n < NR_PREDS(b); ++n) {
        struct block *pred_b = PRED(b, n);

        if (n == 0)
            DUP_VECTOR(tmp_bits, pred_b->prop.out);
        else
            BITVEC_AND(tmp_bits, pred_b->prop.out);
    }

    if (SAME_BITVEC(tmp_bits, b->prop.in))
        return ITERATE_OK;

    DUP_VECTOR(b->prop.in, tmp_bits);

    DUP_VECTOR(b->prop.out, tmp_bits);                      /* OUT() */
    BITVEC_BIC(b->prop.out, b->prop.kill);
    BITVEC_OR(b->prop.out, b->prop.gen);

    return ITERATE_AGAIN;
}

/* import the results of the global propagation: put each
   available copy into the initial state of the block. */

static void import0(struct block *b)
{
    int i;

    TRUNC_VECTOR(b->prop.state);

    for (i = 0; i < u_card; ++i)
        if (BITVEC_IS_SET(b->prop.in, i)) {
            GROW_VECTOR(b->prop.state, 1);
            VECTOR_LAST(b->prop.state) = VECTOR_ELEM(u, i);
        }
}

void opt_lir_prop(void)
{
    struct block *b;

    INIT_VECTOR(u, &local_arena);
    INIT_BITVEC(tmp_bits, &local_arena);
    INIT_VECTOR(tmp_defs, &local_arena);
    INIT_VECTOR(tmp_regs, &local_arena);

    FOR_ALL_BLOCKS(b) alloc0(b);
    FOR_ALL_BLOCKS(b) local0(b);

    u_card = 0;
    next_u = 0;
    FOR_ALL_BLOCKS(b) { u_card += NR_PROPS(b); }
    RESIZE_VECTOR(u, u_card);

    FOR_ALL_BLOCKS(b) gen0(b);
    FOR_ALL_BLOCKS(b) kill0(b);
    FOR_ALL_BLOCKS(b) init0(b);

    RESIZE_BITVEC(tmp_bits, u_card);
    sequence_blocks(0);
    iterate_blocks(global0);

    FOR_ALL_BLOCKS(b) import0(b);
    FOR_ALL_BLOCKS(b) local0(b);

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
