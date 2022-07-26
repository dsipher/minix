/*****************************************************************************

  delay.h                                                 tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef DELAY_H
#define DELAY_H

/* shuffle I_LIR_LOAD and I_LIR_STORE insns to their
   earliest possible points (in their basic blocks) */

void opt_lir_delay(void);

#endif /* DELAY_H */

/* vi: set ts=4 expandtab: */
