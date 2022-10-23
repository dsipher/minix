/*****************************************************************************

   dom.h                                                  ux/64 c compiler

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
