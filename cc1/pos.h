/*****************************************************************************

   pos.h                                                  minix c compiler

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

#ifndef POS_H
#define POS_H

#include "heap.h"

/* convert sign extensions to zero extensions
   where an integer is known to be non-negative. */

void opt_lir_pos(void);

/* the bit vectors are indexed by REG_INDEX(). we maintain
   two states: a working state `now' and an exit state `out'.

   each register is in one of three states, analogous
   to the quintessential constant propagation lattice:

   undef (top)     definition not seen          (not in either set)
   pos             known to be non-negative     (in set pos)
   neg (bottom)    not guaranteed non-negative  (in set neg)

   the set names are perhaps poorly chosen. `pos' means
   not-negative, and `neg' means might-be-negative. */

struct pos_state
{
    VECTOR(bitvec) pos;
    VECTOR(bitvec) neg;
};

/* pos states for every block.
   allocated from local_arena. */

struct pos
{
    struct pos_state now, out;
};

#endif /* POS_H */

/* vi: set ts=4 expandtab: */
