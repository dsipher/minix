/*****************************************************************************

   init.h                                              jewel/os c compiler

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
