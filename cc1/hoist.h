/*****************************************************************************

  hoist.h                                                 tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef HOIST_H
#define HOIST_H

#include "insn.h"

/* code hoisting (unification) */

void opt_lir_hoist(void);

/* per-block hoisting data */

DEFINE_VECTOR(hoist, struct insn **);

struct hoist
{
    VECTOR(hoist) eval;         /* EVAL set- see eval() */
    struct insn **match;        /* candidate for hoisting */
};

#endif /* HOIST_H */

/* vi: set ts=4 expandtab: */
