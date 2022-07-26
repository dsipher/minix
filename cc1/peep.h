/*****************************************************************************

  peep.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef PEEP_H
#define PEEP_H

/* early MCH peephole substitutions */

void opt_mch_early(void);

/* late MCH peephole substitutions */

void opt_mch_late(void);

#endif /* PEEP_H */

/* vi: set ts=4 expandtab: */
