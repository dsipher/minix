/*****************************************************************************

  licm.c                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "dom.h"
#include "opt.h"
#include "licm.h"

/* we automatically invert BASIC loops which have at most this many insns.
   this is just a heuristic. the reason to automatically invert relatively
   small loops is to minimize the impact of an extra branch insn in the
   code path; the larger the loop, the less the impact of the branch. */

#define LICM_AUTO_INVERT_MAX    15

/* true if a block is a trivial comparison. */

#define TRIVIAL_CMP(b)  ((NR_INSNS(b) == 1) && (INSN(b, 0)->op == I_LIR_CMP))

/* true if the block is a BASIC loop, which we define
   as a loop which:

   1. has a two-pronged conditional head, with exactly
      one successor not in the loop; AND

   2. has a unique close block, distinct from the head
      block, which returns unconditionally to the head.

   this definition is meant to capture the essence of the
   typical while() or for() loop as it initially rendered
   to us by the front end, before any manipulation. */

static int basic_loop(struct block *head)
{
    struct block *close;
    struct block *b;
    int n, m;

    if (!conditional_block(head)            /* conditional head */
      || (NR_SUCCS(head) != 2)              /* ... two-pronged */
      || (loop_succs(head, head) != 1)      /* ... one loop successor */
      || (NR_BLOCKS(head->close) != 1))     /* exactly one close block */
        return 0;

    close = VECTOR_ELEM(head->close, 0);                /* must close loop */
    if (unconditional_succ(close) != head) return 0;    /* unconditionally */

    return 1;
}

/* scan the insns of a loop and return non-zero
   if there are any I_LIR_CALL insns present. */

static int scan_loop(struct block *head)
{
    struct block *b;
    struct insn *insn;
    int n, i;

    FOR_EACH_BLOCK(head->loop, n, b) {
        FOR_EACH_INSN(b, i, insn) {
            if (insn->op == I_LIR_CALL)
                return 0;
        }
    }

    return 1;
}

/* identify loops that will almost certainly benefit from
   inversion, and invert them. inversion has a minor cost
   in program size, but really helps small, tight loops on
   many CPUs. we automatically invert loops which:

        1. are BASIC loops (see above)
        2. have at most LICM_AUTO_INVERT_MAX insns
        3. contain no CALL insns
        4. have trivial heads (I_LIR_CMP only)

   if we find and invert a loop, we request pruning since
   such inversion will usually result in blocks which can
   be fused, and abort this pass (to return again later).
   this is an overly conservative approach, but every time
   we change the CFG we invalidate the dom_analyze() data. */

static int auto_invert(void)
{
    struct block *head;
    int n;

    dom_analyze(DOM_ANALYZE_LOOP);

    for (n = VECTOR_SIZE(loop_heads); n--; )
    {
        head = VECTOR_ELEM(loop_heads, n);

        if (basic_loop(head)
          && TRIVIAL_CMP(head)
          && (head->loop_nr_insns <= LICM_AUTO_INVERT_MAX)
          && scan_loop(head))
        {
            invert_loop(head);
            opt_request |= OPT_PRUNE | OPT_LIR_LICM;
            return 1;
        }
    }

    return 0;
}

void opt_lir_licm(void)
{
    dom_analyze(DOM_ANALYZE_LOOP);
    if (auto_invert()) return;
}

/* vi: set ts=4 expandtab: */
