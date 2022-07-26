/*****************************************************************************

  dealias.h                                               tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef DEALIAS_H
#define DEALIAS_H

/* call before opt() to rewrite aliased
   variable accesses as memory operations */

void dealias(void);

/* call after opt() but before lower() to eliminate
   huge and floating-point constants in LIR operands.
   returns true if the LIR was modified. */

int deconst(void);

#endif /* DEALIAS_H */

/* vi: set ts=4 expandtab: */
