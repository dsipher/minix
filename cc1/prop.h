/*****************************************************************************

  prop.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef PROP_H
#define PROP_H

#include "heap.h"
#include "reg.h"

/* global copy propagation */

void opt_lir_prop(void);

/* each 'available copy' is a dst/src register pair (of course) and is
   uniquely identified by the position of the insn which makes the copy
   (block/index). this formulation is a fairly standard approach, using
   one set of data-flow equations to obviate a separate computation of
   reaching definitions. see muchnick 12.5 or dragon (1st ed) 10.7 */

struct copy
{
    int blkno;          /* block asmlab of copy insn */
    int index;          /* insn index in that block */
    int dst;            /* destination register */
    int src;            /* source register */
};

DEFINE_VECTOR(copy, struct copy);

/* per-block copy propagation data. these data do not persist between
   invocations of opt_prop() and so are allocated in the local_arena. */

struct prop
{
    /* the first two are used/updated during the local phase(s) */

    VECTOR(copy) state;         /* current available copies */
    VECTOR(reg) defs;           /* registers DEFd in this block */

    /* this is the global propagation data. the indices
       in these bitsets correlate to entries in copy_u.
       GEN and KILL (muchnick calls the first COPY) are
       generated for each block once and for all, whereas
       IN and OUT converge during iterative analysis */

    VECTOR(bitvec) gen;         /* copies generated in block */
    VECTOR(bitvec) kill;        /* copies killed in this block */
    VECTOR(bitvec) in;          /* copies available at block entry */
    VECTOR(bitvec) out;         /* copies available at block exit */
};

#define NR_PROPS(b)     VECTOR_SIZE((b)->prop.state)
#define PROP(b, k)      VECTOR_ELEM((b)->prop.state, (k))

#endif /* PROP_H */

/* vi: set ts=4 expandtab: */
