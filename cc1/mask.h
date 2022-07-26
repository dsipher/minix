/*****************************************************************************

  mask.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef MASK_H
#define MASK_H

#include "heap.h"

/* determine which regs must have non-negative values
   and convert any sign extensions to zero extensions */

void opt_lir_mask(void);

/* the optimization gets its name from its implementation.
   in each block, we track the value of each reg as a mask:
   the mask is a 0..n contiguous bits from the right (lsb)
   and extends far enough to cover any possible values the
   reg might have at that point, i.e., (reg & mask) == value
   for any possible value of the reg. if the value of the reg
   is unknown, then the mask is all 1s (appropriate to type).
   conversely, if no DEF of the reg has been seen, it is all 0s.
   in data-flow analysis terms, top = all 0s, bottom = all 1s. */

struct mask
{
    VECTOR(long) state;     /* both of these are */
    VECTOR(long) exit;      /* indexed by REG_INDEX */
};

#endif /* MASK_H */

/* vi: set ts=4 expandtab: */
