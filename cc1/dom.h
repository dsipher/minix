/*****************************************************************************

  dom.h                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef DOM_H
#define DOM_H

#include "block.h"

/* dominator analysis. the basic analysis (no flags) will fill in the
   dom vector for each block. DOM_ANALYZE_TREE extends the analysis to
   build the dominator tree, populating idom; DOM_ANALYZE_LOOP uses the
   dominators to identify natural loops and fill in the depth/loop data
   fields in each block, then populates populates loop_heads with all loop
   heads in the CFG, ordered from outermost (first) to innermost (last). */

#define DOM_ANALYZE_TREE    0x00000001
#define DOM_ANALYZE_LOOP    0x00000002

void dom_analyze(int flags);

/* the maximum loop depth found by DOM_ANALYZE_LOOP
   and the list of loop_heads, outermost first */

extern int loop_max_depth;
extern VECTOR(block) loop_heads;

/* reset dom data upon entering a new function definition */

void reset_dom(void);

/* (if the dominator data is valid) returns true if block a dom b */

#define DOMINATES(a, b)     contains_block(&(b)->dom, (a))

/* return number of successors (predecessors)
   of b who are in the loop headed by head */

int loop_succs(struct block *b, struct block *head);
int loop_preds(struct block *b, struct block *head);

/* output the dominator data for block b. for verbose output only. */

void out_dom(struct block *b);

#endif /* DOM_H */

/* vi: set ts=4 expandtab: */
