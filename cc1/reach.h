/*****************************************************************************

   reach.h                                                ux/64 c compiler

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

#ifndef REACH_H
#define REACH_H

#include "heap.h"
#include "reg.h"

struct block;

/* per-block reaching definitions data. reaching definitions require that
   the CFG be decorated such that each DEF of a reg has a unique subscript;
   the definitions that reach a point can then be represented as a reg set.

   this has some advantages for us over more conventional representations
   (e.g. ud chains). for starters, reg sets are fast and easy to work with,
   and are used extensively throughout the compiler. more importantly, the
   representation lends itself well to the labeling of webs in the CFG for
   register allocation, which is a primary use of reaching definitions.

   one disadvantage is that we can't quickly map a DEF to the block/insn
   where it occurs: at present we have no need of that information (at
   least, not to that precision). another problem is that the reaching
   data is only useful as long as the DEFs are decorated. not all passes
   of the compiler want or understand the decorated DEFs, so decorating
   and undecorating the CFG accordingly takes time. */

struct reach
{
    VECTOR(reg) in;     /* DEFs which reach block entry */
    VECTOR(reg) out;    /* DEFs which reach block exit */
    VECTOR(reg) gen;    /* DEFs in this block which survive to exit */
};

/* reset global reaching definitions for a new function */

void reset_reach(void);

/* initialize the struct reach for a new block b. */

void new_reach(struct block *b);

#ifdef DEBUG

/* output reaching data for block b. */

void out_reach(struct block *b);

#endif /* DEBUG */

/* perform reaching analysis. in the absence of flags, the end result
   is a CFG with decorated DEFs and populated reach.in in each block.

   if REACH_ANALYZE_WEBS is given, then the analysis is continued, and
   the maximal unions of the (effective) use-def and def-use chains are
   found to form `webs' (a.k.a. live ranges, but we use muchnick's term
   to differentiate from our struct ranges in live data). then the CFG
   is redecorated- DEFs and USEs alike- such that two regs have the same
   index and subscript iff they are part of the same web. (this final
   redecoration, perhaps ironically, invalidates block reach.in data.)

   use undecorate_blocks() to undo the decoration done by reach_analyze() */

#define REACH_ANALYZE_WEBS  0x00000001

void reach_analyze(int flags);

/* add the definitions which reach a USE of reg
   at the specified block/insn to the defs set. */

void reach(struct block *b, int i, int reg, VECTOR(reg) *defs);

#endif /* REACH_H */

/* vi: set ts=4 expandtab: */
