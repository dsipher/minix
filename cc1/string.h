/*****************************************************************************

   string.h                                               minix c compiler

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

#ifndef STRING_H
#define STRING_H

#include "heap.h"

/* immutable string table. all lexical strings encountered (identifiers and
   string literals) are kept in a hash table for the lifetime of compilation.
   this simplifies memory management and speeds comparisons for equality, as
   two strings are lexically equivalent iff they refer to the same entry. */

struct string
{
    unsigned hash;          /* must remain unsigned */
    int len;                /* purposely an int, to play nice with stdio */
    char *text;             /* not guaranteed to be NUL terminated */
    int asmlab;             /* if set, emit in out_literals() */
    int k;                  /* set on special identifiers */
    struct string *link;    /* next in hash bucket */
};

/* for stdio output, e.g., printf("text: " STRING_FMT, STRING_ARG(s)); */

#define STRING_FMT      "%.*s"
#define STRING_ARG(s)   (s)->len, (s)->text     /* can't put in parens! */

/* most strings' text fields point into the lexical buffer or static tables
   in the compiler text (e.g., keywords), but this doesn't work for string
   literals which contain escape sequences or are built via concatenation.
   the string_arena is just for these cases.

   use STRING_STASH() to build a string one character at a time, then call
   either STRING_PRESERVE() or STRING_DISCARD() to keep it or toss it. */

#define STRING_STASH(c)     (*ARENA_STASH(&string_arena) = (c))
#define STRING_DISCARD()    ARENA_FREE(&string_arena)

/* return the string entry for the most recently stashed string */

#define STRING_PRESERVE()   (string(string_arena.bottom,                    \
                                   (char *) string_arena.top -              \
                                   (char *) string_arena.bottom, 1))

/* return the string entry for text of the specified len. text must point to a
   static, immutable buffer, as the string table may retain the reference. */

#define STRING(text, len)   (string((text), (len), 0))

/* internal helper for STRING() and STRING_PRESERVE() */

struct string *string(char *text, size_t len, int arena);

/* output the first n bytes of a string with .byte pseudo-ops. if n
   is longer than the string text, the output is padded with zeroes. */

void out_literal(struct string *s, int n);

/* called near the end of compilation to scan the string
   table and output all anonymous string literals. */

void out_literals(void);

/* return an anonymous S_STATIC symbol which
   references the specified string literal */

struct symbol *literal(struct string *s);

#endif /* STRING_H */

/* vi: set ts=4 expandtab: */
