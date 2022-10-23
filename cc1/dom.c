/*****************************************************************************

   dom.c                                                  ux/64 c compiler

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
#include "dom.h"

VECTOR(block) loop_heads;

void reset_dom(void)
{
    INIT_VECTOR(loop_heads, &func_arena);
}

static VECTOR(block) all;               /* all-blocks set */
static VECTOR(block) tmp1, tmp2;
static VECTOR(block) stack;

/* basic dominator analysis. there are faster algorithms. this
   is the old standby found in, e.g., dragon (1st ed) 10.10. */

static int dom0(struct block *b)
{
    int n;

    if (b == entry_block)
        return ITERATE_OK;

    /* DOM(b) = b V ( ^ DOM(preds) ) */

    TRUNC_VECTOR(tmp1);
    TRUNC_VECTOR(tmp2);

    for (n = 0; n < NR_PREDS(b); ++n)
        if (n == 0)
            DUP_VECTOR(tmp1, PRED(b, n)->dom);
        else {
            intersect_blocks(&tmp2, &tmp1, &PRED(b, n)->dom);
            SWAP(VECTOR(block), tmp1, tmp2);
        }

    add_block(&tmp1, b);

    if (same_blocks(&tmp1, &b->dom))
        return ITERATE_OK;

    DUP_VECTOR(b->dom, tmp1);
    return ITERATE_AGAIN;
}

static void dom(void)
{
    struct block *b;

    /* initial state: entry block dominates itself.
       all other blocks are dominated by all blocks. */

    FOR_ALL_BLOCKS(b)
        if (b == entry_block)
            add_block(&b->dom, entry_block);
        else
            DUP_VECTOR(b->dom, all);

    iterate_blocks(dom0);
}

/* build the dominator tree. formally, A idom B iff A sdom B and there
   exists no C such that A sdom C and C sdom B; calculate by brute-force
   with direct application of the definition. this isn't as bad as might
   seem: both A and C are both in DOM(B), so the search space is small.

   entry_block and unreachable blocks do not have idoms. entry_block is
   the root of the tree. unreachable blocks are not connected to it. */

static void dom_tree(void)
{
    struct block *a, *b, *c;
    int i, j;

    FOR_ALL_BLOCKS(b) {
        FOR_EACH_BLOCK(b->dom, i, a) {
            if (a == b) goto next_a;

            FOR_EACH_BLOCK(b->dom, j, c) {
                if ((c == a) || (c == b)) continue;
                if (DOMINATES(a, c)) goto next_a;
            }

            b->idom = a;
            goto next_b;
next_a: ;
        }

next_b: ;
    }
}

/* block d has been identified as a loop head, because block n has a back
   edge leading to block d. identify all blocks that comprise the natural
   loop just described and add them to block d's loop blocks set. this is
   essentially a verbatim transcription of algorithm 10.1 from dragon. */

static void insert0(struct block *d, struct block *m)
{
    if (!contains_block(&d->loop, m)) {
        add_block(&d->loop, m);
        VECTOR_PUSH(stack, m);
    }
}

static void loop0(struct block *d, struct block *n)
{
    struct block *m;
    int i;

    TRUNC_VECTOR(stack);
    add_block(&d->loop, d);
    insert0(d, n);

    while (VECTOR_SIZE(stack)) {
        m = VECTOR_TOP(stack);
        VECTOR_POP(stack);

        for (i = 0; i < NR_PREDS(m); ++i)
            insert0(d, PRED(m, i));
    }
}

/* scan the CFG looking for back edges, then invoke loop0() to populate
   the blocks of the loop heads found. (if a block heads multiple loops,
   this will conservatively assume they're one loop.) then we populate
   the global loop variables and per-block loop fields. */

int loop_max_depth;

static void dom_loop(void)
{
    struct block *d;
    struct block *n;
    int i, j, k;

    TRUNC_VECTOR(loop_heads);
    loop_max_depth = 0;

    FOR_ALL_BLOCKS(n) {
        for (i = 0; i < NR_SUCCS(n); ++i) {
            d = SUCC(n, i).b;

            if (DOMINATES(d, n))
                loop0(d, n);
        }
    }

    /* now compute the loop b->loop_depth for each block by counting how
       many loops each appears in, and accumulate b->loop_nr_insns. */

    FOR_ALL_BLOCKS(n)
        FOR_EACH_BLOCK(n->loop, i, d) {
            d->loop_depth++;
            loop_max_depth = MAX(d->loop_depth, loop_max_depth);
            n->loop_nr_insns += NR_INSNS(d);
        }

    /* build the loop_heads vector by naively scanning the CFG
       for loop heads at each possible loop depth (ascending) */

    for (i = 1; i <= loop_max_depth; ++i)
        FOR_ALL_BLOCKS(n)
            if (!EMPTY_BLOCKS(n->loop) && (n->loop_depth == i))
                VECTOR_PUSH(loop_heads, n);

    /* for each loop head, populate b->exit and b->close:

       1. an exit block of a loop is one which has at least
          one branch to a block that is not in the loop.
       2. a close block of a loop is one which has a branch
          back to the loop head (loop-closing, hence `close'). */

    FOR_EACH_BLOCK(loop_heads, i, d)
        FOR_EACH_BLOCK(d->loop, j, n)
            for (k = 0; k < NR_SUCCS(n); ++k)
            {
                struct block *succ = SUCC(n, k).b;

                if (succ == d)
                    add_block(&d->close, n);

                if (!contains_block(&d->loop, succ))
                    add_block(&d->exit, n);
            }
}

void dom_analyze(int flags)
{
    struct block *b;

    INIT_VECTOR(all, &local_arena);
    INIT_VECTOR(tmp1, &local_arena);
    INIT_VECTOR(tmp2, &local_arena);
    INIT_VECTOR(stack, &local_arena);

    FOR_ALL_BLOCKS(b) {
        b->loop_depth = 0;          /* zap block state */
        b->loop_nr_insns = 0;
        b->idom = 0;
        TRUNC_VECTOR(b->loop);
        TRUNC_VECTOR(b->exit);
        TRUNC_VECTOR(b->close);
        TRUNC_VECTOR(b->dom);

        add_block(&all, b);         /* populate all blocks set */
    }

    dom();  /* must be done first */
    if (flags & DOM_ANALYZE_TREE) dom_tree();
    if (flags & DOM_ANALYZE_LOOP) dom_loop();

    ARENA_FREE(&local_arena);
}

int loop_succs(struct block *b, struct block *head)
{
    int count = 0;
    int n;

    for (n = 0; n < NR_SUCCS(b); ++n)
        if (contains_block(&head->loop, SUCC(b, n).b))
            ++count;

    return count;
}

int loop_preds(struct block *b, struct block *head)
{
    int count = 0;
    int n;

    for (n = 0; n < NR_PREDS(b); ++n)
        if (contains_block(&head->loop, PRED(b, n)))
            ++count;

    return count;
}

void out_dom(struct block *b)
{
    struct block *tmp;
    int n;

    OUTS("# DOM:");

    FOR_EACH_BLOCK(b->dom, n, tmp) {
        out(" %L", tmp->asmlab);
        if (tmp == b->idom) OUTC('*');
    }

    OUTC('\n');

    if (VECTOR_SIZE(b->loop) || b->loop_depth) {
        out("# LOOP: [depth=%d, insns=%d]", b->loop_depth,
                                            b->loop_nr_insns);

        FOR_EACH_BLOCK(b->loop, n, tmp)
            out(" %L", tmp->asmlab);

        OUTC('\n');
    }

    if (VECTOR_SIZE(b->exit)) {
        OUTS("# EXIT: ");
        out_blocks(&b->exit);
        OUTC('\n');
    }

    if (VECTOR_SIZE(b->close)) {
        OUTS("# CLOSE: ");
        out_blocks(&b->close);
        OUTC('\n');
    }
}

/* vi: set ts=4 expandtab: */
