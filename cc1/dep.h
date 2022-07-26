/*****************************************************************************

  dep.h                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

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
