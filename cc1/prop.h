/*****************************************************************************

   prop.h                                                 minix c compiler

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
