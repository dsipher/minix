/*****************************************************************************

   dep.h                                                  minix c compiler

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

#ifndef DEP_H
#define DEP_H

#include "heap.h"

struct block;

/* we use a dag to show insn dependencies within a basic block.
   the dag is represented as a set of unique edge tuples, (i, j),
   where i and j are insn indices in the block. each tuple reads
   `i is dependent on j`. the terminology is a little misleading:
   what this means is that j must occur before i in the block.

   the tuples in deps aren't ordered at all, and we manipulate it
   using straightforward linear accesses. this is near optimal for
   almost all cases (except pathologically large basic blocks). */

struct dep { int i, j; };
DEFINE_VECTOR(dep, struct dep);

#define NR_DEPS(b)  VECTOR_SIZE((b)->deps)
#define DEP(b, n)   VECTOR_ELEM((b)->deps, (n))

/* analyze dependencies in b and populate the
   dag. dependency analysis is strictly local. */

void dep_analyze(struct block *b);

/* returns true if i is dependent on j in block b.
   obviously dep_analyze() must have been run. */

int deps(struct block *b, int i, int j);

#ifdef DEBUG

/* output the dependencies of insn i in block b as
   a list of insn indices, in an assembly comment */

void out_deps(struct block *b, int i);

#endif /* DEBUG */

#endif /* DEP_H */

/* vi: set ts=4 expandtab: */
