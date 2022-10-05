/*****************************************************************************

   cc1.h                                               jewel/os c compiler

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

#ifndef CC1_H
#define CC1_H

#include <stdio.h>
#include <string.h>

struct string;

/* configurable constants */

#define LOG2_NR_TNODE_BUCKETS   7       /* 128 tnode buckets */
#define LOG2_NR_STRING_BUCKETS  8       /* 256 string buckets */
#define LOG2_NR_STRING_FILTERS  3       /* 8 words = 512 bits per bucket */
#define LOG2_NR_SYMTAB_BUCKETS  6       /* 64 symbol table buckets */

/* fixed constants */

#define BITS_PER_BYTE           8
#define BITS_PER_LONG           64
#define PAGE_SIZE               4096
#define UNIVERSAL_ALIGN         8
#define STACK_ALIGN             8

#define MAX(a, b)               (((a) > (b)) ? (a) : (b))
#define MIN(a, b)               (((a) < (b)) ? (a) : (b))
#define ARRAY_SIZE(a)           (sizeof(a) / sizeof(*(a)))
#define ROUND_UP(n, b)          ((((n) + ((b) - 1)) / (b)) * (b))
#define ROUND_DOWN(n, b)        (((n) / (b)) * (b))

#define SWAP(T, _a, _b)         do {                                        \
                                    T _tmp;                                 \
                                    _tmp = (_a);                            \
                                    (_a) = (_b);                            \
                                    (_b) = _tmp;                            \
                                } while (0)

/* return a long which is a bit mask
   for n bits (right-justified) */

#define BIT_MASK(n)             (~(-1L << (n)))

/* technically, floor(log2(n)). works for signed or unsigned
   integers, but of course produces nonsense if n <= 0 */

#define LOG2(n)     ((sizeof(int) * BITS_PER_BYTE) - 1 - __builtin_clz(n))
#define LOG2L(n)    ((sizeof(long) * BITS_PER_BYTE) - 1 - __builtin_clzl(n))

/* true if n is an integral power of two */

#define POW2(n)     (((n) > 0) && !((n) & ((n) - 1)))

/* MAX_TYPE_BITS and MAX_ALIGN_BITS give the number of bits required to store
   the maximum size (alignment) of any type or object as an unsigned quantity.

   MAX_ALIGN_BYTES is obviously fixed architecturally.
   MAX_TYPE_BYTES/MAX_TYPE_BITS must be chosen such that:

   1. MAX_TYPE_BYTES * BITS_PER_BYTE can be represented in an int, and
      thus MAX_TYPE_BYTES^2 * BITS_PER_BYTE can be represented in long.
      these assumptions allow us to avoid excessive overflowing checking
      when building and manipulating types.

   2. (MAX_TYPE_BITS + MAX_ALIGN_BITS) <= 32.
      we assume this in the layout of struct operand.

   3. MAX_TYPE_BYTES is a multiple of MAX_ALIGN_BYTES. obviates overflow
      checking when adjusting a type's size to account for its alignment.

   C89 5.2.4.1 says MAX_TYPE_BYTES must be at least ~32k. C99 says ~64k. */

#define MAX_TYPE_BITS           28
#define MAX_ALIGN_BITS          4

#define MAX_ALIGN_BYTES         8
#define MAX_TYPE_BYTES          (1 << (MAX_TYPE_BITS - 1))      /* 128M */

/* C89 5.2.4.1 says we must accept at least 31 arguments per function call.
   (C99 raises this to 127, which is ludicrous.) we must allow at least 32
   arguments since, for our purposes, functions which return a struct take
   an additional hidden argument. round up to 63.

   for simplicity, we only enforce this limit at the point of call, which
   means we'll accept prototypes and definitions with more arguments. but
   such functions can never be called with all their arguments; if a user
   hits this limit and finds the error confusing, he deserves it. */

#define MAX_ARGS_BITS           6
#define MAX_ARGS                63

/* compiler command-line flags: see cc1.c */

extern char w_flag;
extern char O_flag;

/* general constant container */

union con { long i; unsigned long u; double f; };

/* assembler labels are generated from a simple counter,
   and give them a prefix to make them digestible to as. */

extern int last_asmlab;

#define ASMLAB_FMT          "L%d"

/* select between .text and .data segments in the output */

#define SEG_TEXT            1
#define SEG_DATA            2

void seg(int newseg);

/* error() reports an error to the user with a printf()-style format
   if id is not 0, then it's prefixed to the message (for context).
   we attempt no error recovery; anything but a WARNING is fatal.

   WARNINGs are issued sparingly, and only on request (with -w).
   SORRY messages result from arbitrary compiler limitations.
   SYSTEM errors report errno after the message, for system problems.
   INTERNAL errors are bugs in the compiler and "should never happen".
   ERRORs cover all other situations which result from bogus input. */

#define WARNING     0           /* relative values are important, */
#define SORRY       1           /* and they are indexes into a table */
#define SYSTEM      2           /* in error(), so keep in sync */
#define INTERNAL    3
#define ERROR       4

extern void error(int level, struct string *id, char *fmt, ...);

/* write to the output assembly file with a printf()-style format. use
   OUTC() and OUTS() for efficiency where formatting is not required */

extern void out(char *fmt, ...);

extern FILE *out_f;

#define OUTC(c)     putc((c), out_f)
#define OUTS(s)     fputs((s), out_f)

#endif /* CC1_H */

/* vi: set ts=4 expandtab: */
