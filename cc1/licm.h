/*****************************************************************************

  licm.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef LICM_H
#define LICM_H

struct licm
{
    struct block *preheader;    /* preheader for this loop (0 if none yet) */
};

/* LICM means from `loop-invariant code motion', but this
   pass actually performs a range of loop optimizations. */

void opt_lir_licm(void);

#endif /* LICM_H */

/* vi: set ts=4 expandtab: */
