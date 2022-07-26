/*****************************************************************************

  string.h                                                tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

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

#define STRING_STASH(c)     (* (char *) ARENA_ALLOC(&string_arena, 1) = (c))
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
