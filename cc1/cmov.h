/*****************************************************************************

  cmov.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef CMOV_H
#define CMOV_H

#define I_MCH_MOVE(op)      (   ((op) == I_MCH_MOVB     \
                            |   ((op) == I_MCH_MOVW     \
                            |   ((op) == I_MCH_MOVL     \
                            |   ((op) == I_MCH_MOVQ     )

/* XXX */

void opt_mch_cmov(void);

#endif /* CMOV_H */

/* vi: set ts=4 expandtab: */
