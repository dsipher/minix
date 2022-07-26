/*****************************************************************************

  mbz.h                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef MBZ_H
#define MBZ_H

/* a late (destructive) optimization. eliminate
   unnecessary zero extensions into bits[63:32]
   when the last write to a reg was 32 bits. */

void opt_mch_mbz(void);

#endif /* OPT_H */

/* vi: set ts=4 expandtab: */
