/*****************************************************************************

   live.h                                              jewel/os c compiler

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

#ifndef LIVE_H
#define LIVE_H

#include "heap.h"
#include "reg.h"

struct block;

/* per-block live variable data. DEF/USE/IN/OUT have their usual meanings.

   ranges describe live ranges within a block. the basic interpretation of
   a range is that the DEF of reg at insn index 'def' in the block is USEd
   at insn index 'use' in the block. collectively they form local du chains.
   a nonsense range where def == use is used as a placeholder for the def
   which governs a chain. the vector is ordered by (def, reg, use), so the
   placeholder entry will be first, followed immediately by all uses reached
   by the def. a placeholder by itself, with no uses, is a dead store.

   if def is INSN_INDEX_BEFORE then the reg is live-in. similarly, if use is
   INSN_INDEX_AFTER, the reg is live-out. if use is INSN_INDEX_BRANCH, then
   the block branch logic depends on reg, either directly (when a conditional
   branch depends on REG_CC) or indirectly (B_SWITCH on the control reg). */

struct range { int def, reg, use; };

DEFINE_VECTOR(range, struct range);

struct live
{
    VECTOR(reg) def;
    VECTOR(reg) use;
    VECTOR(reg) in;
    VECTOR(reg) out;
    VECTOR(range) ranges;
};

#define NR_RANGES(b)    VECTOR_SIZE((b)->live.ranges)
#define RANGE(b, r)     VECTOR_ELEM((b)->live.ranges, (r))

/* rather messy looking macros which merely determine if, given a
   range index r, the next (prev) index belongs to the same range */

#define NEXT_IN_RANGE(b, r)                                                 \
    ((((r) + 1) < NR_RANGES(b))                                             \
    && (RANGE((b), (r)).def == RANGE((b), ((r) + 1)).def)                   \
    && (RANGE((b), (r)).reg == RANGE((b), ((r) + 1)).reg))

#define PREV_IN_RANGE(b, r)                                                 \
    (((r) > 0)                                                              \
    && (RANGE((b), (r)).def == RANGE((b), ((r) - 1)).def)                   \
    && (RANGE((b), (r)).reg == RANGE((b), ((r) - 1)).reg))

/* true if this range is the placeholder DEF at the head of the chain */

#define RANGE_HEAD(b, r)    (RANGE((b), (r)).def == RANGE((b), (r)).use)

/* initialize the live struct for a new block b */

void new_live(struct block *b);

/* range_by_use() returns the range index for the USE of reg at insn 'use'
   in block b. range_by_def() returns the first (placeholder) index for the
   DEF of reg at insn 'def'. range_by_reg() blindly returns the first range
   for reg in b. in all cases, the entry must exist; returns garbage if not */

int range_by_reg(struct block *b, int reg);
int range_by_use(struct block *b, int reg, int use);
int range_by_def(struct block *b, int reg, int def);

/* given a range index r, return the total number of uses of
   the range. r can be any index in the range of interest */

int range_use_count(struct block *b, int r);

/* given a range index r, return the insn index of the last use
   in that range. r can be any index in the range of interest. */

int range_span(struct block *b, int r);

/* given a DEF (placeholder) index r, add all regs
   which interfere with that range to regs. */

void range_interf(struct block *b, int r, VECTOR(reg) *regs);

/* is this def a dead store? */

int range_doa(struct block *b, int reg, int def);

/* returns true if at least one (other) live range of the same
   reg type dies during the lifetime of the specified range. */

int range_spans_death(struct block *b, int r);

/* returns the ccset of conditions generated by the insn at index i
   in block b, if any, that are actually later inspected, if any.
   this is conservative, answering 'all conditions' if it is unsure. */

int live_ccs(struct block *b, int i);

/* returns true if reg is alive across insn in i block b. i.e.,
   if a DEF of reg occurred before i which has a span beyond i. */

int live_across(struct block *b, int reg, int i);

/* a dead store at insn index i of block b has been killed (with an
   I_NOP). update the live ranges accordingly. returns true if the
   global data is (might have been) invalidated, false otherwise.
   [the invalidated data is usable, as it is conservatively wrong.] */

int live_kill_dead(struct block *b, int i);

#ifdef DEBUG

/* output the live data for block b. */

void out_live(struct block *b);

#endif /* DEBUG */

/* perform global live-variable analysis. updates the struct live for
   every block. the flags indicate which sets of registers to include
   in the analysis. beware REG_MEM: the local ranges can be used for,
   e.g., scheduling loads and stores, but the global info is useless. */

#define LIVE_ANALYZE_REGS   0x00000001      /* normal registers */
#define LIVE_ANALYZE_CC     0x00000002      /* include REG_CC  */
#define LIVE_ANALYZE_MEM    0x00000004      /* include REG_MEM */

#define LIVE_ANALYZE_ALL    ( LIVE_ANALYZE_REGS | LIVE_ANALYZE_CC           \
                                                | LIVE_ANALYZE_MEM          )

void live_analyze(int flags);

#endif /* LIVE_H */

/* vi: set ts=4 expandtab: */
