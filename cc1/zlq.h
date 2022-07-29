/*****************************************************************************

  zlq.h                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef ZLQ_H
#define ZLQ_H

/* a late (destructive) optimization. eliminate
   unnecessary zero extensions into bits[63:32]
   when the last write to a reg was 32 bits. */

void opt_mch_zlq(void);

#endif /* ZLQ_H */

/* vi: set ts=4 expandtab: */
