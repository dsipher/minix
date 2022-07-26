/*****************************************************************************

  cmp.h                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef CMP_H
#define CMP_H

/* eliminate redundant I_LIR_CMPs */

void opt_lir_cmp(void);

/* eliminate some comparisons against 0 if an
   arithmetic operation has already set Z/S */

void opt_mch_cmp(void);

#endif /* CMP_H */

/* vi: set ts=4 expandtab: */
