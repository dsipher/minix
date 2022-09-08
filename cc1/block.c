/*****************************************************************************

   block.c                                             jewel/os c compiler

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
#include "dom.h"
#include "block.h"

struct block *all_blocks;               /* in current function */

struct block *entry_block;
struct block *exit_block;
struct block *current_block;

/* add b to the all_blocks list, at the front */

#define PUT_BLOCK(b)                                                        \
    do {                                                                    \
        (b)->prev = 0;                                                      \
                                                                            \
        if (all_blocks)                                                     \
            all_blocks->prev = (b);                                         \
                                                                            \
        (b)->next = all_blocks;                                             \
        all_blocks = (b);                                                   \
    } while (0)

/* add b to the all_blocks list, after the specified block */

#define PUT_BLOCK_AFTER(b, after)                                           \
    do {                                                                    \
        (b)->prev = (after);                                                \
        (b)->next = (after)->next;                                          \
        (after)->next = (b);                                                \
        if ((b)->next) (b)->next->prev = b;                                 \
    } while (0)

/* remove b from the all_blocks list */

#define GET_BLOCK(b)                                                        \
    do {                                                                    \
        if ((b)->next)                                                      \
            (b)->next->prev = (b)->prev;                                    \
                                                                            \
        if ((b)->prev)                                                      \
            (b)->prev->next = (b)->next;                                    \
        else                                                                \
            all_blocks = (b)->next;                                         \
    } while (0)

struct block *new_block(void)
{
    struct block *b;

    ARENA_ALIGN(&func_arena, UNIVERSAL_ALIGN);
    b = ARENA_ALLOC(&func_arena, sizeof(struct block));
    __builtin_memset(b, 0, sizeof(struct block));

    b->asmlab = ++last_asmlab;
    INIT_VECTOR(b->insns, &func_arena);
    INIT_VECTOR(b->preds, &func_arena);
    INIT_VECTOR(b->succs, &func_arena);

    INIT_VECTOR(b->dom, &func_arena);
    INIT_VECTOR(b->loop, &func_arena);
    INIT_VECTOR(b->exit, &func_arena);
    INIT_VECTOR(b->close, &func_arena);
    INIT_VECTOR(b->deps, &func_arena);

    new_live(b);
    new_reach(b);

    PUT_BLOCK(b);

    return b;
}

/* allocate a new block, duplicate its successors
   and then duplicate its insns. */

struct block *dup_block(struct block *src)
{
    struct block *dst;
    struct insn *insn;
    int i;

    dst = new_block();
    dup_succs(dst, src);
    GROW_VECTOR(dst->insns, NR_INSNS(src));

    FOR_EACH_INSN(src, i, insn)
        VECTOR_ELEM(dst->insns, i) = dup_insn(insn);

    return dst;
}

/* to 'kill' a block, it is sufficient to zap its successors so that it does
   not appear as a predecessor to any reachable blocks anywhere. we need not
   worry about removing it from its predecessors, since they are unreachable
   too and (per the comments in block.h) they will be, or already have been,
   killed. note that we can never remove exit_block, even if unreachable, but
   this is ok, since it has no successors, so the above logic still works. */

void kill_block(struct block *b)
{
    remove_succs(b);
    GET_BLOCK(b);
}

/* add (or remove) a predecessor from a block. this must be paired with
   the addition (or removal) of a successor or the CFG will be broken. */

static void add_pred(struct block *b, struct block *pred_b)
{
    GROW_VECTOR(b->preds, 1);
    VECTOR_LAST(b->preds) = pred_b;
}

static void remove_pred(struct block *b, struct block *pred_b)
{
    int i;

    for (i = 0; i < NR_PREDS(b); ++i)
        if (PRED(b, i) == pred_b) {
            VECTOR_DELETE(b->preds, i, 1);
            return;
        }
}

int is_pred(struct block *pred, struct block *succ)
{
    int n;

    for (n = 0; n < NR_PREDS(succ); ++n)
        if (PRED(succ, n) == pred)
            return 1;

    return 0;
}

void add_succ(struct block *b, int cc, struct block *succ_b)
{
    int i;
    int new_cc;

    if (cc != CC_NEVER) {
        for (i = 0; i < NR_SUCCS(b); ++i) {
            if (SUCC(b, i).b == succ_b) {
                new_cc = union_cc(cc, SUCC(b, i).cc);
                remove_succ(b, i);
                cc = new_cc;
                break;
            }
        }

        GROW_VECTOR(b->succs, 1);
        VECTOR_LAST(b->succs).cc = cc;
        VECTOR_LAST(b->succs).b = succ_b;
        add_pred(succ_b, b);
    }
}

/* we need two strategies. for B_SWITCH blocks we can simply rewrite
   the successor and fix up the predecessors accordingly. for other
   blocks, we must use remove_succ()/add_succ() (slightly slower) in
   case the cc combines with an existing new_b successor in the block. */

void replace_succ(struct block *b, struct block *old_b, struct block *new_b)
{
    int cc;
    int i;

    if (SWITCH_BLOCK(b)) {
        for (i = 0; i < NR_SUCCS(b); ++i)
            if (SUCC(b, i).b == old_b) {
                SUCC(b, i).b = new_b;
                remove_pred(old_b, b);
                add_pred(new_b, b);
            }
    } else {
again:
        for (i = 0; i < NR_SUCCS(b); ++i)
            if (SUCC(b, i).b == old_b) {
                cc = SUCC(b, i).cc;
                remove_succ(b, i);
                add_succ(b, cc, new_b);
                goto again; /* indices may change */
            }
    }
}

/* remember: if one succ is Z or NZ, there will be
   exactly one other succ which is its complement. */

int rewrite_znz_succs(struct block *b, int nz)
{
    int res = 0;
    int n;

    for (n = 0; n < NR_SUCCS(b); ++n) {
        switch (SUCC(b, n).cc)
        {
        case CC_Z:  SUCC(b, n).cc = INVERT_CC(nz);
                    res = 1;
                    break;

        case CC_NZ: SUCC(b, n).cc = nz;
                    res = 1;
                    break;
        }
    }

    return res;
}

/* the caller will ensure the block is conditional, so we
   can assume all the conditions are subject to commutation */

void commute_succs(struct block *b)
{
    int n, cc;

    for (n = 0; n < NR_SUCCS(b); ++n) {
        cc = SUCC(b, n).cc;
        SUCC(b, n).cc = commuted_cc[cc];
    }
}

void remove_succ(struct block *b, int n)
{
    remove_pred(SUCC(b, n).b, b);
    VECTOR_DELETE(b->succs, n, 1);
}

void remove_succs(struct block *b)
{
    struct block *succ_b;
    int i;

    for (i = 0; i < NR_SUCCS(b); ++i) {
        succ_b = SUCC(b, i).b;
        remove_pred(succ_b, b);
    }

    TRUNC_VECTOR(b->succs);
    b->flags &= ~B_SWITCH;
}

void dup_succs(struct block *dst, struct block *src)
{
    int n;

    remove_succs(dst);
    DUP_VECTOR(dst->succs, src->succs);

    if (SWITCH_BLOCK(src)) {
        dst->flags |= B_SWITCH;
        dst->flags |= (src->flags & (B_DENSE | B_TABLE));
        dst->control = src->control;
    }

    for (n = 0; n < NR_SUCCS(dst); ++n)
        add_pred(SUCC(dst, n).b, dst);
}

int fuse_block(struct block *b)
{
    struct block *succ_b;
    int count = 0;

    while ((b != entry_block)
      && (succ_b = unconditional_succ(b))
      && (succ_b != exit_block)
      && (succ_b != b)
      && (NR_PREDS(succ_b) == 1)
      && !(succ_b->flags & B_IMMORTAL))
    {
        int i = NR_INSNS(b);        /* 1. hoist insns from succ_b to b */
        int j = NR_INSNS(succ_b);

        if (j) {
            GROW_VECTOR(b->insns, j);
            __builtin_memcpy(&INSN(b, i), &INSN(succ_b, 0),
                            j * VECTOR_ELEM_SIZE(b->insns));
        }

        dup_succs(b, succ_b);       /* 2. hoist branches from succ_b to b */
        remove_succs(succ_b);       /*    (succ_b heads nowhere now) */

        GET_BLOCK(succ_b);          /* 3. now succ_b is orphaned, forget it */
        ++count;
    }

    return count;
}

int bypass_succ(struct block *b, int n)
{
    struct block *succ_b        = SUCC(b, n).b;
    struct block *succ_succ_b   = unconditional_succ(succ_b);
    int m;

    /* we can't bypass      (a) non-empty blocks
                            (b) a B_SWITCH (it's not really empty)
                            (c) ourselves
                            (d) a B_IMMORTAL block
                            (e) an infinite loop */

    if (NR_INSNS(succ_b)) return 0;                                 /* (a) */
    if (SWITCH_BLOCK(succ_b)) return 0;                             /* (b) */
    if (succ_b == b) return 0;                                      /* (c) */
    if (succ_b->flags & B_IMMORTAL) return 0;                       /* (d) */
    if ((succ_succ_b = unconditional_succ(succ_b)) == succ_b)       /* (e) */
        return 0;

    if (SWITCH_BLOCK(b)) {
        /* if b itself is a switch block, we can only absorb an
           empty successor if it's unconditional, since we can't
           merge switch cases, or mix switch cases and conditions. */

        if (succ_succ_b == 0) return 0;
        SUCC(b, n).b = succ_succ_b;         /* bypass directly */
        add_pred(succ_succ_b, b);           /* we now precede succ_succ_b */
        remove_pred(succ_b, b);             /* but not succ_b anymore */
    } else {
        /* for normal blocks, we remove the branch from b, then hoist up
           the branches from succ_b, tweaking the conditions along the way */

        int cc;

        cc = SUCC(b, n).cc;
        remove_succ(b, n);

        for (m = 0; m < NR_SUCCS(succ_b); ++m) {
            succ_succ_b = SUCC(succ_b, m).b;
            add_succ(b, intersect_cc(cc, SUCC(succ_b, m).cc), succ_succ_b);
        }
    }

    return 1;
}

/* because the loop head duplicate is a new block, we can bypass
   remove_succ()/add_succ(). we won't break any of the invariants
   by rewriting the branches directly. */

void invert_loop(struct block *head)
{
    struct block *new;
    struct block *b;
    struct block *succ;
    int n, m;

    new = dup_block(head);

    FOR_EACH_BLOCK(head->loop, n, b) {
        for (m = 0; m < NR_SUCCS(b); ++m) {
            succ = SUCC(b, m).b;

            if (succ == head) {
                SUCC(b, m).b = new;
                remove_pred(head, succ);
                add_pred(new, succ);
            }
        }
    }
}

/* due to our invariants on the successors, if there are
   any conditional branches, they must all be conditional.
   so it suffices to check the first. */

int conditional_block(struct block *b)
{
    if (!SWITCH_BLOCK(b) && NR_SUCCS(b) && CONDITIONAL_CC(SUCC(b, 0).cc))
        return 1;
    else
        return 0;
}

struct block *predict_succ(struct block *b, int ccs, int fix)
{
    struct block *succ_b;
    int n;

    for (n = 0; n < NR_SUCCS(b); ++n)
        if (CCSET_IS_SET(ccs, SUCC(b, n).cc)) {
            succ_b = SUCC(b, n).b;
            break;
        }

    if (fix) {
        remove_succs(b);
        add_succ(b, CC_ALWAYS, succ_b);
    }

    return succ_b;
}

struct block *unconditional_succ(struct block *b)
{
    if (!SWITCH_BLOCK(b) && NR_SUCCS(b) && (SUCC(b, 0).cc == CC_ALWAYS))
        return SUCC(b, 0).b;
    else
        return 0;
}

void switch_block(struct block *b, struct operand *o, struct block *default_b)
{
    b->flags |= B_SWITCH;
    b->control = *o;
    add_succ(b, CC_DEFAULT, default_b);
}

/* a switch block is unswitched if

        1. the controlling expression is constant OR
        2. all switch cases lead to the same target */

int unswitch_block(struct block *b)
{
    struct block *succ_b;
    int n;

    if (OPERAND_PURE_IMM(&b->control)) {
        predict_switch_succ(b, b->control.con, 1);
    } else {
        succ_b = SUCC(b, 0).b;  /* CC_DEFAULT */

        for (n = 1; n < NR_SUCCS(b); ++n)
            if (SUCC(b, n).b != succ_b)
                return 0;

        remove_succs(b);
        add_succ(b, CC_ALWAYS, succ_b);
    }

    return 1;
}

/* the parser does not perform the conversions required by C89 6.6.4.2:
   it does not perform integral promotions on the controlling expression
   of the switch, nor does it cast the case labels to the promoted type,
   nor does it check for duplicate case labels. we handle it all here. */

void add_switch_succ(struct block *b, union con *conp, struct block *succ_b)
{
    int n;

    /* though we don't promote the control operand, we normalize
       the case constants to at least T_INT. this normalization
       might lose information, but the standard wants us to look
       for duplicates after the constants have been converted to
       the promoted type of the controlling expression. */

    normalize_con(MAX(b->control.t, T_INT), conp);

    for (n = 1; n < NR_SUCCS(b); ++n)
        if (SUCC(b, n).label.u == conp->u)
            error(ERROR, 0, "duplicate case label");

    GROW_VECTOR(b->succs, 1);
    VECTOR_LAST(b->succs).cc = CC_SWITCH;
    VECTOR_LAST(b->succs).label.u = conp->u;
    VECTOR_LAST(b->succs).b = succ_b;

    add_pred(succ_b, b);
}

/* in add_switch_succ(), we keep cases that are impossible to match
   (e.g., 128 with a T_CHAR control operand) so we can properly bomb
   on duplicates. they're just noise now, so remove them. */

void trim_switch_block(struct block *b)
{
    int n = 1;  /* skip CC_DEFAULT */

    while (n < NR_SUCCS(b)) {
        if (!con_in_range(b->control.t, &SUCC(b, n).label)) {
            remove_pred(SUCC(b, n).b, b);
            VECTOR_DELETE(b->succs, n, 1);
        } else
            ++n;
    }
}

/* again, the front end doesn't do integral promotions on the controlling
   expression, so we need to normalize it before doing any comparisons. */

struct block *predict_switch_succ(struct block *b, union con con, int fix)
{
    struct block *succ_b;
    int n;

    normalize_con(MAX(b->control.t, T_INT), &con);
    succ_b = SUCC(b, 0).b;  /* always CC_DEFAULT */

    for (n = 1; n < NR_SUCCS(b); ++n) {
        if (SUCC(b, n).label.u == con.u) {
            succ_b = SUCC(b, n).b;
            break;
        }
    }

    if (fix) {
        remove_succs(b);
        add_succ(b, CC_ALWAYS, succ_b);
    }

    return succ_b;
}

void reset_blocks(void)
{
    all_blocks = 0;

    entry_block = new_block();
    current_block = new_block();
    add_succ(entry_block, CC_ALWAYS, current_block);

    /* current_block is left dangling; exit_func() will
       tie the last current_block to the exit_block. */

    exit_block = new_block();
}

#define UNDECORATE0(o)                                                      \
    do {                                                                    \
        /* it doesn't matter what the class of the                          \
           operand is. if the regs are unused or                            \
           filled with junk, this is not harmful. */                        \
                                                                            \
        REG_SET_SUB((o)->reg, 0);                                           \
        REG_SET_SUB((o)->index, 0);                                         \
    } while (0)

void undecorate_blocks(void)
{
    struct block *b;
    struct insn *insn;
    int i, n;

    FOR_ALL_BLOCKS(b) {
        FOR_EACH_INSN(b, i, insn) {

            if (insn->op == I_ASM) {
                struct asm_insn *asm_insn = (struct asm_insn *) insn;

                undecorate_regmap(&asm_insn->uses);
                undecorate_regmap(&asm_insn->defs);
            } else
                for (n = 0; n < (I_OPERANDS(insn->op) + insn->nr_args); ++n)
                    UNDECORATE0(&insn->operand[n]);
        }

        UNDECORATE0(&b->control);
    }
}

void substitute_reg_everywhere(int src, int dst)
{
    struct block *b;
    struct insn *insn;
    int i;

    FOR_ALL_BLOCKS(b) {
        FOR_EACH_INSN(b, i, insn)
            insn_substitute_reg(insn, src, dst, INSN_SUBSTITUTE_USES
                                              | INSN_SUBSTITUTE_DEFS);

        if (SWITCH_BLOCK(b)
          && OPERAND_REG(&b->control)
          && (b->control.reg == src))
            b->control.reg = dst;
    }
}

void all_regs(VECTOR(reg) *regs)
{
    struct block *b;
    struct insn *insn;
    int i;

    TRUNC_VECTOR(*regs);

    FOR_ALL_BLOCKS(b) {
        FOR_EACH_INSN(b, i, insn) {
            insn_defs(insn, regs, 0);
            insn_uses(insn, regs, 0);
        }

        if (SWITCH_BLOCK(b) && OPERAND_REG(&b->control))
            add_reg(regs, b->control.reg);
    }
}

void iterate_blocks(int (*f)(struct block *))
{
    struct block *b;
    int again;

    do {
        again = 0;

        for (b = all_blocks; b; b = b->next)
            if (f(b) == ITERATE_AGAIN)
                again = 1;

    } while (again);
}

static void walk0(int backward, struct block *b, void (*pre)(struct block *),
                                                 void (*post)(struct block *))
{
    int i;

    if (!(b->flags & B_WALKED)) {
        b->flags |= B_WALKED;

        if (pre) pre(b);

        if (backward == 0)
            for (i = 0; i < NR_SUCCS(b); ++i)
                walk0(0, SUCC(b, i).b, pre, post);
        else
            for (i = 0; i < NR_PREDS(b); ++i)
                walk0(1, PRED(b, i), pre, post);

        if (post) post(b);
    }
}

void walk_blocks(int backward, void (*pre)(struct block *),
                               void (*post)(struct block *))
{
    struct block *b;

    for (b = all_blocks; b; b = b->next) b->flags &= ~B_WALKED;
    walk0(backward, backward ? exit_block : entry_block, pre, post);
}

/* we want reverse post-order. the walk_blocks() gets us the post order;
   moving the blocks with PUT_BLOCK() as they are processed reverses them. */

static void sequence0(struct block *b) { GET_BLOCK(b); PUT_BLOCK(b); }
void sequence_blocks(int backward) { walk_blocks(backward, 0, sequence0); }

#define SORT(OP)                                                            \
    do {                                                                    \
        struct block *_b;                                                   \
        int _n;                                                             \
        int _again;                                                         \
                                                                            \
        FOR_ALL_BLOCKS(_b) {                                                \
            do {                                                            \
                _again = 0;                                                 \
                                                                            \
                for (_n = 0; _n < (NR_SUCCS(_b) - 1); ++_n)                 \
                    if (SUCC(_b, _n).b->loop_depth                          \
                      OP SUCC(_b, _n + 1).b->loop_depth)                    \
                    {                                                       \
                        SWAP(struct succ, SUCC(_b, _n), SUCC(_b, _n + 1));  \
                        _again = 1;                                         \
                    }                                                       \
            } while (_again);                                               \
        }                                                                   \
    } while (0)

void loop_sequence(void)
{
    VECTOR(block) stack;
    struct block *head;
    struct block *b;
    int depth;
    int n;

    dom_analyze(DOM_ANALYZE_LOOP);

    /* first, we sort the successors of each block in ascending order
       of loop depth. then, when we call sequence_blocks(), we'll get
       an RPO that keeps the blocks of loop bodies contiguous. */

    SORT(>);
    sequence_blocks(0);

    /* finally, sort the successors in descending order. this ensures that
       when multiple branch insns occur at the end of a block, the branches
       to the innermost loops are output first. artificially put exit_block
       at the outermost loop, so branches to it are always last. [this last
       tweak helps out_func() shortcut trivial exit_blocks, see func.c.] */

    exit_block->loop_depth = -1;
    SORT(<);
}

void out_block(struct block *b)
{
    struct insn *insn;
    int i;

    out("%L:\n", b->asmlab);

    FOR_EACH_INSN(b, i, insn)
        out_insn(insn);
}

int append_insn(struct insn *insn, struct block *b)
{
    int i;

    GROW_VECTOR(b->insns, 1);
    i = NR_INSNS(b) - 1;
    INSN(b, i) = insn;

    return i;
}

void insert_insn(struct insn *insn, struct block *b, int i)
{
    VECTOR_INSERT((b)->insns, i, 1);
    INSN(b, i) = insn;
}

void delete_insn(struct block *b, int i)
{
    VECTOR_DELETE((b)->insns, i, 1);
}

/* for set operations, we need to provide an ordering for blocks.
   any ordering will do, and the pointers are distinct, so ... */

#define BLOCK_PRECEDES(b1, b2)  ((b1) < (b2))

void add_block(VECTOR(block) *set, struct block *b)
    SET_ADD(b, BLOCK_PRECEDES)

int contains_block(VECTOR(block) *set, struct block *b)
    SET_CONTAINS(b, BLOCK_PRECEDES)

int same_blocks(VECTOR(block) *set1, VECTOR(block) *set2)
    SAME_SET()

void union_blocks(VECTOR(block) *dst, VECTOR(block) *src1,
                                      VECTOR(block) *src2)
    UNION_SETS(struct block *, BLOCK_PRECEDES)

void intersect_blocks(VECTOR(block) *dst, VECTOR(block) *src1,
                                          VECTOR(block) *src2)
    INTERSECT_SETS(BLOCK_PRECEDES)

void out_blocks(VECTOR(block) *set)
{
    struct block *b;
    int n;

    OUTC('[');

    FOR_EACH_BLOCK(*set, n, b) {
        if (n) OUTC(' ');
        out("%L", b->asmlab);
    }

    OUTC(']');
}

/* vi: set ts=4 expandtab: */
