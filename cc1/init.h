/*****************************************************************************

  init.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef INIT_H
#define INIT_H

struct symbol;

/* emit a value as data using the appropriate pseudo-op */

void out_word(long t, union con con, struct symbol *sym);

/* emit a definition for a symbol in zeroed storage (bss) */

void init_bss(struct symbol *sym);

/* perform initialization for the static storage of sym.
   processes an initializer if present. otherwise it sets
   aside zeroed storage, or marks the symbol tentatively
   defined, as appropriate. ensures sym has complete type
   unless it's explicitly extern.

   s is the explicit (not effective) storage class */

void init_static(struct symbol *sym, int s);

/* perform an initialization for the automatic sym. ensures sym
   has complete type, and processes an initializer, if present. */

void init_auto(struct symbol *sym);

/* finalize a tentatively-defined symbol (at the end of compilation) */

void tentative(struct symbol *sym);

/* emit a floating-point literal and return a symbol that refers to it */

struct symbol *floateral(long t, double f);

#endif /* INIT_H */

/* vi: set ts=4 expandtab: */
