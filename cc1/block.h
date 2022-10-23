/*****************************************************************************

   block.h                                                ux/64 c compiler

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

#ifndef BLOCK_H
#define BLOCK_H

#include "heap.h"
#include "live.h"
#include "fold.h"
#include "prop.h"
#include "dvn.h"
#include "dep.h"
#include "hoist.h"
#include "insn.h"
#include "reach.h"
#include "lower.h"
#include "pos.h"

/* the intermediate representation is a control flow graph: a collection of
   basic blocks (struct block) and directed edges (struct succ). all blocks
   also are linked together in all_blocks, in an order which is used when
   iterating over them for analysis or output. see iterate_blocks() et al. */

extern struct block *all_blocks;

/* for simple iteration over all blocks (vs. iterative analysis). */

#define FOR_ALL_BLOCKS(b)   for ((b) = all_blocks; (b); (b) = (b)->next)

/* entry and exit blocks for the current function. the entry_block is empty
   until immediately before output, when the backend fills in the prologue. */

extern struct block *entry_block;
extern struct block *exit_block;

/* current position of the parser */

extern struct block *current_block;

/* each successor of a block is represented by a struct succ. conditions
   covered by all successors of a block must be exclusive and exhaustive.
   (the exit block is exempt from this rule, since it has no successors.)
   for each struct succ, there is a matching entry in that successor's
   preds list (even if that leads to duplicate entries in preds). */

struct succ
{
    int cc;                 /* CC_*, condition for this edge */
    union con label;        /* case label, if cc == CC_SWITCH */
    struct block *b;        /* the successor block */
};

DEFINE_VECTOR(succ, struct succ);

    /* a B_SWITCH block is the controlling block of a switch(). in such a
       block, succs must hold exactly one CC_DEFAULT successor and zero or
       more CC_SWITCH successors- no other kinds are permitted. in LIR,
       the control operand holds the value being switched on (O_REG or
       O_IMM only). in MCH, the only B_SWITCHes which survived are those
       with a computed goto, and the control operand is the jump target.
       thus in LIR there is a direct relationship between the control and
       the case labels, whereas in MCH the relationship is more oblique */

#define B_SWITCH        0x00000001      /* controlling block of switch() */
#define B_WALKED        0x00000002      /* visited by walk_blocks() */
#define B_MARKED        0x00000004      /* marked executable (fold.c) */
#define B_DENSE         0x00000008      /* dense switch block (switch.c) */
#define B_TABLE         0x00000010      /* table switch block (switch.c) */
#define B_IMMORTAL      0x00000020      /* block can't be pruned */
#define B_INVERTED      0x00000040      /* inverted already (block.c) */

DEFINE_VECTOR(block, struct block *);

struct block
{
    int asmlab;                     /* for block entry */
    int flags;                      /* B_* above */
    VECTOR(insn) insns;
    VECTOR(block) preds;            /* not a set! dups present */
    VECTOR(succ) succs;
    struct operand control;         /* controlling expression of switch() */
    struct block *next, *prev;      /* in all_blocks */

    /* dominator/loop data. the only valid fields here will be those most
       recently computed by dom_analyze(). CFG changes invalidate them */

    VECTOR(block) dom;              /* dominators of this block */
    struct block *idom;             /* immediate dominator */
    VECTOR(block) loop;             /* blocks in loop headed by this block */
    VECTOR(block) exit;             /* ... and the exit blocks of that loop */
    VECTOR(block) close;            /* ... and its loop-closing blocks .... */
    int loop_depth;                 /* loop nesting depth (0 .. n) */
    int loop_nr_insns;              /* total number of insns in loop */

    /* private/semi-private data for other optimizations/analyses */

    int zlq;                        /* zero-extended regs (zlq.c) */
    struct live live;               /* live analysis data (live.c) */
    struct fold fold;               /* constant propagation data (fold.c) */
    struct prop prop;               /* copy propagation data (prop.c) */
    struct hoist hoist;             /* hoisting/unification data (hoist.c) */
    struct reach reach;             /* reaching definitions (reach.c) */
    struct dvn dvn;                 /* value numbering data (dvn.c) */
    struct lower lower;             /* lowering data (lower.c) */
    struct insn *cmp;               /* last I_LIR_CMP on path (cmp.c) */
    struct pos pos;                 /* must-be-positive data (pos.c) */

    VECTOR(dep) deps;               /* insn dependencies (dep.c) */
};

#define NR_PREDS(b)     VECTOR_SIZE((b)->preds)
#define PRED(b, n)      VECTOR_ELEM((b)->preds, (n))
#define NR_SUCCS(b)     VECTOR_SIZE((b)->succs)
#define SUCC(b, n)      VECTOR_ELEM((b)->succs, (n))
#define NR_INSNS(b)     VECTOR_SIZE((b)->insns)
#define INSN(b, i)      VECTOR_ELEM((b)->insns, (i))

/* true if the block contains no insns .. obvy */

#define EMPTY_BLOCK(b)          (NR_INSNS(b) == 0)

/* the last valid insn index or insn in the block. junk if block is empty! */

#define LAST_INSN_INDEX(b)      (NR_INSNS(b) - 1)
#define LAST_INSN(b)            VECTOR_ELEM((b)->insns, LAST_INSN_INDEX(b))

/* the next available insn index in the block */

#define NEXT_INSN_INDEX(b)      NR_INSNS(b)

/* iterate over every insn in block b. i is an int for the insn index, at the
   top of the loop, insn will be set to the insn at index i in the block. the
   index i and/or block insns may modified, with care, in the body. this will
   terminate early if insn at index i is 0, but that should never happen. */

#define FOR_EACH_INSN(b, i, insn)                                           \
    for ((i) = 0; ((i) < NR_INSNS(b)) && ((insn) = INSN((b), (i))); ++(i))

/* same as above, but iterate in reverse */

#define REVERSE_EACH_INSN(b, i, insn)                                       \
    for ((i) = NR_INSNS(b); i-- && ((insn) = INSN((b), (i))); )

/* create and initialize a new block */

struct block *new_block(void);

/* create a new block as a duplicate of src. the new block
   will have the same insns and successors as the src, but
   obviously not the same preds (so it is unreachable). */

struct block *dup_block(struct block *src);

/* remove an unreachable block from the CFG (all_blocks). this is a crude
   tool; it is expected that the caller will remove all unreachable blocks
   in one go so some shortcuts can be taken w/r/t cleanup. see source. */

void kill_block(struct block *b);

/* mark a block as a switch control block (B_SWITCH), with the given
   control operand and default target. the block must be a 'virgin':
   in particular, it must have no existing successors. */

void switch_block(struct block *b, struct operand *o,
                  struct block *default_b);

#define SWITCH_BLOCK(b)     ((b)->flags & B_SWITCH)

/* add a CC_SWITCH successor to the specified switch block. this takes care
   of checking the range of the constant, detecting duplicate labels, etc. */

void add_switch_succ(struct block *b, union con *conp, struct block *succ_b);

/* call on a block after all switch cases have been added. removes cases
   that can't possibly be reached based on the type of the control operand. */

void trim_switch_block(struct block *b);

/* attempt to collapse a B_SWITCH block into a standard block, if the
   switch is bogus, i.e., all cases are the same or the controlling
   expression is a constant. if so, the block is rewritten as a normal
   unconditional block and true is returned. */

int unswitch_block(struct block *b);

/* returns true if block pred is a predecessor of block succ */

int is_pred(struct block *pred, struct block *succ);

/* add a successor to a (non-B_SWITCH) block. if succ_B is already
   a successor to b, we combine the two conditions into one edge */

void add_succ(struct block *b, int cc, struct block *succ_b);

/* remove the nth successor from a block */

void remove_succ(struct block *b, int n);

/* remove all successors from a block */

void remove_succs(struct block *b);

/* remove all successors from dst block, then replace
   them with duplicates of successors from src block */

void dup_succs(struct block *dst, struct block *src);

/* replace all references to successor old_b in block b with new_b.
   old_b can't be the same as new_b, or this may loop forever. */

void replace_succ(struct block *b, struct block *old_b, struct block *new_b);

/* if block b is conditional with Z/NZ branches, rewrite Z/NZ
   in terms of the conditions indicated by nz (and its inverse).
   returns true if the rewrite occurred, false otherwise. */

int rewrite_znz_succs(struct block *b, int nz);

/* commute the conditions of a block's successors. the
   caller must ensure the block is in fact conditional. */

void commute_succs(struct block *b);

/* true if the block ends with a branch dependent on condition codes */

int conditional_block(struct block *b);

/* given a conditional block b and a COMPLETE set of condition codes,
   predict which branch will be taken and return the target block. if
   fix is true, the block will be rewritten to branch there. */

struct block *predict_succ(struct block *b, int ccs, int fix);

/* given a switch block b and a (pure) constant control value con, predict
   which branch will be taken and return the target block. again, if fix
   is non-zero, the branch will be rewritten. */

struct block *predict_switch_succ(struct block *b, union con con, int fix);

/* if block b has a single CC_ALWAYS successor,
   return that successor block, null otherwise. */

struct block *unconditional_succ(struct block *b);

/* make a maximal basic block out of b and its successors,
   if possible. returns the number of blocks fused. */

int fuse_block(struct block *b);

/* check to see if successor n of b is empty, and if so, attempt
   to bypass it, i.e., rewrite the branch of b to skip the empty
   block and go directly to the successor(s) of the empty block.
   returns true if bypassed, false otherwise. */

int bypass_succ(struct block *b, int n);

/* create a new skeleton CFG */

void reset_blocks(void);

/* undecorate all register references in the CFG */

void undecorate_blocks(void);

/* substitute all appearances of a reg (src) with
   a new reg (dst) thoughout the entire CFG */

void substitute_reg_everywhere(int src, int dst);

/* populate regs with the set of all
   registers referenced in the CFG. */

void all_regs(VECTOR(reg) *regs);

/* iterate over all_blocks (in order) and invoke f on each block
   (to solve data flow equations). the callback returns one of

        ITERATE_OK      data unchanged, nothing interesting to report
        ITERATE_AGAIN   data changed, a new iteration will be needed */

#define ITERATE_OK      0
#define ITERATE_AGAIN   1

void iterate_blocks(int (*f)(struct block *));

/* walk the CFG forward (backward), starting at the entry_block (exit_block).
   invoke pre()/post() before/after visiting the successors (predecessors).
   either pre() or post() (or both) may be 0, indicating no action. */

void walk_blocks(int backward, void (*pre)(struct block *),
                               void (*post)(struct block *));

/* sequence all_blocks in reverse post-order of a forward (backward) walk */

void sequence_blocks(int backward);

/* sequence all_blocks for output. this produces a modified RPO ordering
   which takes loops into account. this should not be until immediately
   before output, and certainly not before lowering is complete, as the
   resulting CFG may break the invariant on CC_DEFAULTs in switch blocks. */

void loop_sequence(void);

/* invert a loop with the given head. this assumes the loop data in the
   block head is valid (from dom_analyze). the head is duplicated, then
   all branches inside the loop to the head are rewritten to proceed to
   the duplicate. the original head remains as a loop entry guard. */

void invert_loop(struct block *head);

/* output a block: its label, all its insns. does not handle the branches */

void out_block(struct block *b);

/* append insn to block b. returns the insn's index */

int append_insn(struct insn *insn, struct block *b);

#define EMIT_INSN(insn)     append_insn((insn), current_block)

/* insert insn into block b at index i */

void insert_insn(struct insn *insn, struct block *b, int i);

/* delete insn at index i in block b */

void delete_insn(struct block *b, int i);

/* block set operations (see heap.h) */

void add_block(VECTOR(block) *set,              /* SET_ADD */
               struct block *b);

int contains_block(VECTOR(block) *set,          /* SET_CONTAINS */
                   struct block *b);

int same_blocks(VECTOR(block) *set1,            /* SAME_SET */
                VECTOR(block) *set2);

void union_blocks(VECTOR(block) *dst,           /* UNION_SETS */
                  VECTOR(block) *src1,
                  VECTOR(block) *src2);

void intersect_blocks(VECTOR(block) *dst,       /* INTERSECT_SETS */
                      VECTOR(block) *src1,
                      VECTOR(block) *src2);

#define NR_BLOCKS(set)          VECTOR_SIZE(set)
#define EMPTY_BLOCKS(set)       (NR_BLOCKS(set) == 0)
#define FIRST_BLOCK(set)        VECTOR_ELEM(set, 0)

/* output a block set for human consumption */

void out_blocks(VECTOR(block) *set);

/* iterate over a block set. will not tolerate any null blocks */

#define FOR_EACH_BLOCK(blocks, n, b)                                        \
    for ((n) = 0; ((n) < VECTOR_SIZE(blocks))                               \
                  && ((b) = VECTOR_ELEM((blocks), (n))); ++(n))

#endif /* BLOCK_H */

/* vi: set ts=4 expandtab: */
