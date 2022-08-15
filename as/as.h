/*****************************************************************************

   as.h                                                 tahoe/64 assembler

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

#ifndef AS_H
#define AS_H

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <unistd.h>
#include <fcntl.h>
#include "../include/crc32c.h"      /* FIXME */
#include "../include/a.out.h"       /* FIXME */
#include "y.tab.h"

/* we are an n-pass assembler. on each pass, we assemble into
   memory, and compare the state of the symbol table with the
   previous pass. if nothing has changed, we've converged and
   write the memory buffers to the output. (if we are listing
   we must run an additional list pass to generate the list.)

   theoretically, for some inputs, a single pass would suffice.
   those cases are rare enough to disregard (at worst, we waste
   some cpu time.) there might be pathological inputs for which
   convergence never occurs (unknown), so we place a limit on
   the number of passes to keep us from going off the rails. */

#define FIRST_PASS      1
#define MAX_PASSES      100

extern int pass;

/* the current default code size (see as.c for details) */

extern int code_size;

/* maximum sizes of various areas/tables. these can be arbitrary large
   (within reason) since they come out of the lazily-allocated bss. */

#define MAX_SEGMENT_SIZE    (64 * 1024 * 1024)
#define MAX_SYMS            100000
#define MAX_RELOCS          100000

/* the size of the line storage pool. this is a heap
   which is freed after every line is assembled. */

#define POOL_SIZE           (1 * 1024 * 1024)

extern char pool[];         /* the line pool */
extern char *pool_pos;      /* next available byte */

/* the quintessential swap operation */

#define SWAP(TYPE, a, b)    do {                                            \
                                TYPE _tmp = (a);                            \
                                (a) = (b);                                  \
                                (b) = _tmp;                                 \
                            } while (0)

/* the a.out header */

extern struct exec header;

/* the current segment offset. (doubles
   as the current segment indicator.) */

extern unsigned *segofs;

#define CURSEG()    ((segofs == &header.a_text) ? N_TEXT : N_DATA)

/* allocate `n' (aligned) bytes from the pool. we do not check for
   overflows, since overflow is impossible unless we've gone cuckoo.
   we maintain alignment by rounding `n' up to an alignment boundary.
   in most cases, the size of the allocation is known at compile time,
   so conditional constant propagation and folding make it very cheap */

#define ALIGNMENT   8

#define ALLOC(n)                                                            \
    ({                                                                      \
        size_t _n = (n);                                                    \
        char *_p = pool_pos;                                                \
        if (_n % ALIGNMENT) _n += ALIGNMENT - (_n % ALIGNMENT);             \
        pool_pos += _n;                                                     \
        (void *) (_p);                                                      \
    })

/* this is not configurable unless end_of_line() is rewritten to
   change the output format. this is the maximum number of bytes
   we will print, per assembly input line, in the listing output.
   we choose 15 because that's the longest AMD64 insn encoding. */

#define MAX_LIST_BYTES      15

/* the symbol table is, of course, a hash table. */

#define LOG2_NR_BUCKETS     9   /* configurable */

#define NR_BUCKETS          (1 << LOG2_NR_BUCKETS)
#define BUCKET_MASK         (NR_BUCKETS - 1)
#define BUCKET(h)           (h & BUCKET_MASK)

/* all NAME tokens are associated with a struct name which
   lives in table[]. these are either symbols or mnemonics. */

struct name
{
    /* the text of the name. if prepopulated (a mnemonic) then
       this points into a string literal in table.c. otherwise
       it points into our memory image of the string segment. */

    const char *text;                   /* NUL-terminated */

    unsigned len        : 24;           /* length of text[] */
    unsigned mnemonic   : 1;            /* mnemonic vs. symbol */
    unsigned            : 7;            /* unused */

    unsigned hash;                      /* CRC-32C */

    union
    {
        struct insn *insns;             /* insn templates (see insn.c) */
        struct nlist *sym;              /* a.out nlist entry */
    };

    struct name *link;          /* to next entry in bucket */
};

/* the table itself is found in table.c, which is generated
   at build time (to preseed insn mnemonics); see mktable.c */

extern struct name *table[NR_BUCKETS];

/* XXX */

#define O_REG_8         0x00000001      /* general-purpose register */
#define O_REG_16        0x00000002
#define O_REG_32        0x00000004
#define O_REG_64        0x00000008

#define O_REG           (O_REG_8 | O_REG_16 | O_REG_32 | O_REG_64)

#define O_ACC_8         0x00000010      /* accumulator (i.e., %rax) */
#define O_ACC_16        0x00000020
#define O_ACC_32        0x00000040
#define O_ACC_64        0x00000080

#define O_XMM           0x00000100      /* sse register (%xmm0..15) */
#define O_CR            0x00000200      /* control register (%cr0..15) */

#define O_MEM_16        0x00000400      /* value in memory: the size */
#define O_MEM_32        0x00000800      /* refers to the address size, */
#define O_MEM_64        0x00001000      /* not that of referenced data */

#define O_MEM           (O_MEM_16 | O_MEM_32 | O_MEM_64)

#define O_IMM_S8        0x00002000      /* immediate value */
#define O_IMM_U8        0x00004000
#define O_IMM_S16       0x00008000
#define O_IMM_U16       0x00010000
#define O_IMM_S32       0x00020000
#define O_IMM_U32       0x00040000
#define O_IMM_64        0x00080000

#define O_IMM_8         (O_IMM_S8 | O_IMM_U8)
#define O_IMM_16        (O_IMM_S16 | O_IMM_U16)
#define O_IMM_32        (O_IMM_S32 | O_IMM_U32)
#define O_IMM           (O_IMM_8 | O_IMM_16 | O_IMM_32 | O_IMM_64)

#define O_MOFS_8        0x00100000      /* absolute memory operands */
#define O_MOFS_16       0x00200000      /* (these only appear in legacy */
#define O_MOFS_32       0x00400000      /* MOVs between memory and %rax) */
#define O_MOFS_64       0x00800000

#define O_MOFS          (O_MOFS_8 | O_MOFS_16 | O_MOFS_32 | O_MOFS_64)

#define O_REL_8         0x01000000      /* relative addresses */
#define O_REL_16        0x02000000      /* (for branch targets) */
#define O_REL_32        0x04000000

#define O_REL           (O_REL_8 | O_REL_16 | O_REL_32)

struct operand
{
    int classes;            /* set of all applicable classes (O_* above) */
    int reg;                /* [base] register */
    int index;              /* index register */
    int scale;              /* scaling factor */
    long value;             /* value of an operand (if applicable) is... */
    struct nlist *sym;      /* ...a constant, possibly offset by a symbol */
};

/* the maximum number of operands and opcodes allowed
   in an insn template. note that these will have to
   grow if we include support for extension insns. */

#define MAX_OPERANDS        3
#define MAX_OPCODES         3

/* an insn template. if the class of every actual operand has a
   non-empty intersection with the class of its corresponding
   formal operand, then this template is matched and used for
   encoding. templates are organized into arrays (with an all-0
   terminating entry) that are indexed by mnemonic (see insns.c).
   order of the templates can be important; first match wins. */

struct insn
{
    int i_flags;                /* (I_*) flags apply to entire template */

    char nr_opcodes;            /* 1..MAX_INSN_OPCODES (nr_opcodes == 0 ... */
    char opcodes[MAX_OPCODES];  /* ... means this is the terminating entry) */

    struct
    {
        int classes;            /* (O_*) matching operand classes */
        int f_flags;            /* (F_*) flags specific to operand */
    } formals[MAX_OPERANDS];
};

#define I_NO_CODE16     0x00000001          /* insn not allowed in .code16 */
#define I_NO_CODE32     0x00000002          /* ................... .code32 */
#define I_NO_CODE64     0x00000004          /* ................... .code64 */

/* as.c */

extern void error(const char *fmt, ...);
extern void end_of_line(void);
extern void emit(int byte);
extern void emit_value(struct operand *o);
extern int immclass(long value);
extern int size2(long value, const char *kind);
extern struct name *lookup(const char *text, int len);
extern void define(struct nlist *sym, int type, long value, long align);
extern void undef(struct nlist *sym);
extern int resolve(struct operand *o, int adj, int fixup);

extern void encode(struct insn *insns, struct operand *operand0,
                                       struct operand *operand1,
                                       struct operand *operand2);


/* tokens.l (lex.yy.c) */

extern int yylex(void);
extern int yywrap(void);
extern void yyrestart(FILE *yyin);

/* grammar.y (y.tab.c) */

extern void yyerror(const char *msg);
extern int yyparse(void);

#endif /* AS_H */

/* vi: set ts=4 expandtab: */
