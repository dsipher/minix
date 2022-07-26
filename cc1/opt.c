/*****************************************************************************

  opt.c                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "reg.h"
#include "gen.h"
#include "insn.h"
#include "block.h"
#include "norm.h"
#include "reassoc.h"
#include "prop.h"
#include "dvn.h"
#include "dom.h"
#include "hoist.h"
#include "delay.h"
#include "peep.h"
#include "fuse.h"
#include "cmp.h"
#include "mbz.h"
#include "cmov.h"
#include "mask.h"
#include "opt.h"

/* OPT_PRUNE. prune the CFG to 'minimal' form.

        (1) remove 'obvious' no-ops
        (2) unswitch degenerate switch blocks
        (3) fuse blocks into maximal basic blocks
        (4) elminate jumps-to-jumps and empty blocks
        (5) eliminate unreachable blocks

   O(n^2) in blocks (or worse) because we restart on changes to
   exploit new opportunities, but each pass is pretty cheap.

   n.b.: like OPT_DEAD, this works on both LIR and MCH */

void opt_prune(void)
{
    struct block *b;
    struct block *succ_b;
    struct block *succ_succ_b;
    struct insn *insn;
    int dst, src;
    int i;

    /* I_NOP obviously does nothing (by definition). we also eliminate
       self-copies. other potentially useless operations must wait as
       we might have to account for side effects (condition codes) */

    FOR_ALL_BLOCKS(b)
        FOR_EACH_INSN(b, i, insn)
            if ((insn->op == I_NOP)
              || (insn_is_copy(insn, &dst, &src) && (dst == src)))
            {
                VECTOR_DELETE(b->insns, i, 1);
                --i;  /* revisit this index */
            }

again:

    FOR_ALL_BLOCKS(b)               /* downgrade switch blocks if */
        if (SWITCH_BLOCK(b))        /* they're not switching anymore */
            unswitch_block(b);

    FOR_ALL_BLOCKS(b)               /* fuse into maximal basic blocks */
        if (fuse_block(b))
            goto again;

    FOR_ALL_BLOCKS(b)                           /* bypass empty blocks */
        for (i = 0; i < NR_SUCCS(b); ++i)
            if (bypass_succ(b, i)) {
                opt_request |= OPT_DEAD;
                goto again;
            }

    /* remove unreachable blocks. we walk the graph from the entry.
       if a block is not B_WALKED then it's not reachable. n.b. per
       the comment on kill_block() in block.h, we must remove all
       the blocks at once or we risk dangling edges in the CFG */

    walk_blocks(0, 0, 0);   /* we don't do anything, just walk */

    FOR_ALL_BLOCKS(b) {
        if (b == exit_block) continue;

        if ((b->flags & B_WALKED) == 0)
            kill_block(b);
    }
}

/* simplify tests against zero. e.g., informally,

        transforms  (((a == 0) != 0) == 0)  into   (a != 0)
               and  (((a > 5) == 0) != 0)   into   (a <= 5)

   these sorts of expressions arise in user code, but the code generator
   is by far the worst offender. more formally, if we encounter:

            (1)     I_LIR_SETcc %i100d

   and neither %100d nor the condition codes are defined until we encounter:

            (2)     I_LIR_CMP $0, %i100d    (or a copy of %i100d)
            (3)     I_LIR_SET[Z|NZ] %i200d

   and the condition codes are dead at (3), then we can eliminate (2) and
   rewrite (3) as a function of the cc from (1). similarly, if (2) is the
   last instruction of a conditional block with Z/NZ branches, we can kill
   (2) and rewrite the branch conditions, provided REG_CC is not live out. */

DEFINE_VECTOR(fixcc, char);         /* active I_LIR_SETcc insns: */
static VECTOR(fixcc) fixcc_map;     /* reg -> cc, CC_NEVER means no mapping */

#define CLEAR_FIXCC_MAP()   MEMSET_VECTOR(fixcc_map, CC_NEVER)
#define FIXCC_MAP(reg)      VECTOR_ELEM(fixcc_map, REG_INDEX(reg))

static VECTOR(reg) fixcc_regs;

static int fixcc0(struct block *b)
{
    struct insn *insn;
    struct insn *next;
    int i, next_i;
    int src, dst; /* regs */
    int j, cc;
    int again;
    int r;

    again = 0;
    CLEAR_FIXCC_MAP();

    FOR_EACH_INSN(b, i, insn) {
        if (I_LIR_IS_SETCC(insn->op)) {
            FIXCC_MAP(insn->operand[0].reg) = I_LIR_SETCC_TO_CC(insn->op);
            continue;
        }

        if (insn_is_copy(insn, &dst, &src)) {
            FIXCC_MAP(dst) = FIXCC_MAP(src);
            continue;
        }

        if (insn_is_cmpz(insn, &dst) && ((cc = FIXCC_MAP(dst)) != CC_NEVER)) {
            next_i = i + 1;
            next = (next_i < NR_INSNS(b)) ? INSN(b, next_i) : 0;
            r = range_by_def(b, REG_CC, i);

            if (range_span(b, r) <= (next ? next_i : INSN_INDEX_BRANCH)) {
                if (next) {
                    switch (next->op)
                    {
                    case I_LIR_SETZ:    cc = INVERT_CC(cc); break;
                    case I_LIR_SETNZ:   break;
                    default:            goto ineligible;
                    }

                    next->op = I_CC_TO_LIR_SETCC(cc);
                } else if (!rewrite_znz_succs(b, cc))
                    goto ineligible;

                INSN(b, i) = &nop_insn;
                again |= live_kill_dead(b, i);
                opt_request |= OPT_PRUNE;

                /* since we killed the I_LIR_CMP, we don't want to hit the
                   ineligible code. if this was a branch replacement, the
                   loop will terminate now. if we replaced a I_LIR_SETcc,
                   we'll pick up the mapping next as it's the next insn. */

                continue;
            }
        }

ineligible:
        if (INSN_DEFS_CC(insn))
            CLEAR_FIXCC_MAP();
        else {
            TRUNC_VECTOR(fixcc_regs);
            insn_defs(insn, &fixcc_regs, 0);
            FOR_EACH_REG(fixcc_regs, j, dst) FIXCC_MAP(dst) = CC_NEVER;
        }
    }

    return again;
}

static void opt_lir_fixcc(void)
{
    struct block *b;
    int again;

    do {
        again = 0;
        live_analyze(LIVE_ANALYZE_CC);
        INIT_VECTOR(fixcc_regs, &local_arena);
        INIT_VECTOR(fixcc_map, &local_arena);
        RESIZE_VECTOR(fixcc_map, nr_assigned_regs);
        FOR_ALL_BLOCKS(b) again |= fixcc0(b);
        ARENA_FREE(&local_arena);
    } while (again);
}

/* remove dead insns. an insn is dead if:

        (1) all the regs it DEFs are dead after the insn (if any)
        (2) no one depends on its resulting condition codes (if any)
        (3) it does not DEF aliased memory
        (4) it has no (other) side effects (including volatile)

   we iterate over each block backwards to unpeel dependencies properly */

void opt_dead(void)
{
    VECTOR(reg) regs;
    struct block *b;
    struct insn *insn;
    int i, j, r;
    int reg;
    int again;

    do {
        again = 0;
        live_analyze(LIVE_ANALYZE_REGS | LIVE_ANALYZE_CC);
        INIT_VECTOR(regs, &local_arena);

        FOR_ALL_BLOCKS(b) {
            REVERSE_EACH_INSN(b, i, insn) {
                if (INSN_SIDEFFS(insn)) goto skip;
                if (INSN_DEFS_MEM(insn)) goto skip;

                TRUNC_VECTOR(regs);
                insn_defs(insn, &regs, I_FLAG_DEFS_CC);

                FOR_EACH_REG(regs, j, reg)
                    if (!range_doa(b, reg, i))
                        goto skip;

                INSN(b, i) = &nop_insn;
                again |= live_kill_dead(b, i);
                opt_request |= OPT_PRUNE;

            skip: ;
            }
        }

        ARENA_FREE(&local_arena);
    } while (again);
}

/* opt_lir_merge() has found at least two predecessors of succ_b which share
   a final insn. create a new block, redirect the predecessors (in blocks)
   to the new block instead, and move all shared insns into it. this is a
   simple process that's surprisingly difficult to explain w/o diagrams */

static void merge0(struct block *succ_b, VECTOR(block) *blocks)
{
    struct block *new;
    struct insn *insn;
    struct block *b;
    int n;

    new = new_block();
    add_succ(new, CC_ALWAYS, succ_b);

    for (n = 0; n < VECTOR_SIZE(*blocks); ++n) {
        b = VECTOR_ELEM(*blocks, n);
        replace_succ(b, succ_b, new);
    }

    for (;;)
    {
        /* there is nothing special about the first member of blocks:
           we simply need a reference point. if it's empty, we're done.
           if not, use its last insn as the reference. */

        b = VECTOR_ELEM(*blocks, 0);
        if (NR_INSNS(b) == 0) return;
        insn = LAST_INSN(b);

        /* now ensure all the other blocks have the same final insn.
           if any of them does not, we've finished the tail merge */

        for (n = 1; n < VECTOR_SIZE(*blocks); ++n) {
            b = VECTOR_ELEM(*blocks, n);
            if (NR_INSNS(b) == 0) return;
            if (!same_insn(insn, LAST_INSN(b))) return;
        }

        /* looks like all blocks have the same final insn. move
           it to the new block and delete it from the preds. */

        for (n = 0; n < VECTOR_SIZE(*blocks); ++n) {
            b = VECTOR_ELEM(*blocks, n);
            delete_insn(b, LAST_INSN_INDEX(b));
        }

        append_insn(insn, new);
    }
}

/* tail merging. for each block B, we search for predecessors P1, P2, ... Pn
   which unconditionally proceed to block B and which share a final insn. */

static void opt_lir_merge(void)
{
    struct block *b;
    struct block *x, *y;
    int m, n;
    VECTOR(block) blocks;

    INIT_VECTOR(blocks, &local_arena);

again:
    FOR_ALL_BLOCKS(b) {
        for (m = 0; m < NR_PREDS(b); ++m) {
            x = PRED(b, m);
            TRUNC_VECTOR(blocks);
            if (!unconditional_succ(x)) continue;
            if (EMPTY_BLOCK(x)) continue;

            for (n = 0; n < NR_PREDS(b); ++n) {
                y = PRED(b, n);
                if (x == y) continue;
                if (!unconditional_succ(y)) continue;
                if (EMPTY_BLOCK(y)) continue;

                if (same_insn(LAST_INSN(x), LAST_INSN(y)))
                    add_block(&blocks, y);
            }

            if (VECTOR_SIZE(blocks)) {
                add_block(&blocks, x);
                merge0(b, &blocks);
                opt_request |= OPT_PRUNE;
                goto again; /* CFG changed */
            }
        }
    }

    ARENA_FREE(&local_arena);
}

/* the passes[] table is in priority order. this mirrors ordering in opt.h,
   and the bit ordering in the OPT_* constants, but the table is definitive.
   poor ordering of the table can result in excessive compilation times (or
   infinite loops if someone really goofs) or missed opportunities, etc. */

static struct { int bit; void (*pass)(void); char *name; } passes[] =
{
            OPT_LIR_FIXCC,      opt_lir_fixcc,      "lir_fixcc",
            OPT_LIR_NORM,       opt_lir_norm,       "lir_norm",
            OPT_LIR_DELAY,      opt_lir_delay,      "lir_delay",
            OPT_LIR_PROP,       opt_lir_prop,       "lir_prop",
            OPT_DEAD,           opt_dead,           "dead",
            OPT_LIR_REASSOC,    opt_lir_reassoc,    "lir_reassoc",
            OPT_PRUNE,          opt_prune,          "prune",
            OPT_LIR_FOLD,       opt_lir_fold,       "lir_fold",
            OPT_LIR_HOIST,      opt_lir_hoist,      "lir_hoist",
            OPT_LIR_DVN,        opt_lir_dvn,        "lir_dvn",
            OPT_LIR_LICM,       opt_lir_licm,       "lir_licm",
            OPT_LIR_MASK,       opt_lir_mask,       "lir_mask",
            OPT_LIR_CMP,        opt_lir_cmp,        "lir_cmp",
            OPT_LIR_PEEP,       opt_lir_peep,       "lir_peep",
            OPT_LIR_MERGE,      opt_lir_merge,      "lir_merge",
            OPT_MCH_EARLY,      opt_mch_early,      "mch_early",
            OPT_MCH_CMP,        opt_mch_cmp,        "mch_cmp",
            OPT_MCH_FUSE,       opt_mch_fuse,       "mch_fuse",
            OPT_MCH_CMOV,       opt_mch_cmov,       "mch_cmov",
            OPT_MCH_LATE,       opt_mch_late,       "mch_late",
            OPT_MCH_MBZ,        opt_mch_mbz,        "mch_mbz"
};

int opt_request;
int opt_prohibit;

void opt(int request, int prohibit)
{
    int bit, i;

    opt_request = request;
    prohibit |= opt_prohibit;

    while (bit = (opt_request & ~prohibit))
    {
        for (i = 0; i < ARRAY_SIZE(passes); ++i)
            if (passes[i].bit & bit) {
                opt_request &= ~passes[i].bit;
#ifdef DEBUG
                fprintf(stderr, "opt: %s\n", passes[i].name);
#endif /* DEBUG */
                passes[i].pass();
                break; /* restart */
            }
    }
}

/* vi: set ts=4 expandtab: */
