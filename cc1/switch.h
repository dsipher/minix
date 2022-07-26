/*****************************************************************************

  switch.h                                                tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef SWITCH_H
#define SWITCH_H

/* before lowering, we convert some switches to LIR */

void lir_switch(void);

/* convert remaining switches directly
   to MCH insns after lowering */

void mch_switch(void);

#endif /* SWITCH_H */

/* vi: set ts=4 expandtab: */
