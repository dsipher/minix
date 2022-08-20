/*****************************************************************************

   mktable.c                                            tahoe/64 assembler

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

#include "as.h"

struct name *table[NR_BUCKETS];

/* these need not be in any particular order, but we keep them
   alphabetical so we don't get lost.  for each mnemonic there
   must be a matching set of templates named i_<template>[] in
   insns.c. if `template' is 0, it's the same as `text' (which
   is the usual case, but some insns have multiple mnemonics). */

struct { const char *text; const char *template; } insns[] =
{
    {   "aaa",          0               },
    {   "aad",          0               },
    {   "aam",          0               },
    {   "aas",          0               },
    {   "adcb",         0               },
    {   "adcw",         0               },
    {   "adcl",         0               },
    {   "adcq",         0               },
    {   "addb",         0               },
    {   "addw",         0               },
    {   "addl",         0               },
    {   "addq",         0               },
    {   "andb",         0               },
    {   "andw",         0               },
    {   "andl",         0               },
    {   "andq",         0               },
    {   "bsfw",         0               },
    {   "bsfl",         0               },
    {   "bsfq",         0               },
    {   "bsrw",         0               },
    {   "bsrl",         0               },
    {   "bsrq",         0               },
    {   "call",         0               },
    {   "clc",          0               },
    {   "cld",          0               },
    {   "cli",          0               },
    {   "cmc",          0               },
    {   "cmpb",         0               },
    {   "cmpw",         0               },
    {   "cmpl",         0               },
    {   "cmpq",         0               },
    {   "hlt",          0               },
    {   "iret",         0               },
    {   "ja",           "jnbe"          },
    {   "jae",          "jnb"           },
    {   "jb",           0               },
    {   "jbe",          0               },
    {   "jc",           "jb"            },
    {   "je",           0               },
    {   "jg",           "jnle"          },
    {   "jge",          "jnl"           },
    {   "jl",           0               },
    {   "jle",          0               },
    {   "jmp",          0               },
    {   "jna",          "jbe"           },
    {   "jnae",         "jb"            },
    {   "jnb",          0               },
    {   "jnbe",         0               },
    {   "jnc",          "jnb"           },
    {   "jne",          0               },
    {   "jng",          "jle"           },
    {   "jnge",         "jl"            },
    {   "jnl",          0               },
    {   "jnle",         0               },
    {   "jno",          0               },
    {   "jnp",          0               },
    {   "jns",          0               },
    {   "jnz",          "jne"           },
    {   "jo",           0               },
    {   "jp",           0               },
    {   "jpe",          "jp"            },
    {   "jpo",          "jnp"           },
    {   "js",           0               },
    {   "jz",           "je"            },
    {   "lock",         0               },
    {   "rep",          0               },
    {   "ret",          0,              },
    {   "seg",          0               },
    {   "stc",          0               },
    {   "std",          0               },
    {   "sti",          0               },
    {   "xlat",         0               },
    {   "xorb",         0               },
    {   "xorw",         0               },
    {   "xorl",         0               },
    {   "xorq",         0               }
};

#define NR_INSNS (sizeof(insns) / sizeof(*insns))

/* nothing exciting here, should be pretty self-explanatory. for
   each mnemonic, we build a name entry, both internally for our
   hash table, and externally in the output file- the process is
   conceptually the same for both. once that's done, we can dump
   the top-level buckets. we don't bother with any error checks. */

int main(void)
{
    struct name *name;
    const char *template;
    int b, i;

    printf("/* auto-generated by mktable.c */\n\n");
    printf("#include \"as.h\"\n\n");

    for (i = 0; i < NR_INSNS; ++i) {
        template = insns[i].template;
        if (!template) template = insns[i].text;

        name = calloc(sizeof(struct name), 1);
        name->text = insns[i].text;
        name->len = strlen(name->text);
        name->hash = crc32c(0, name->text, name->len);

        b = BUCKET(name->hash);
        name->link = table[b];
        table[b] = name;

        printf("extern struct insn i_%s[];\n", template);

        printf("static struct name n_%s = { \"%s\", %d, 1, 0x%08x, i_%s, ",
                name->text, name->text, name->len, name->hash, template);

        name->link ? printf("&n_%s", name->link->text) : printf("0");

        printf(" };\n\n");
    }

    printf("struct name *table[NR_BUCKETS] = {\n");

    for (i = 0; i < NR_BUCKETS; ++i) {
        if (i) printf(",\n");

        name = table[i];
        printf("    /* %4d */ ", i);
        name ? printf("&n_%s", name->text) : printf("0");
    }

    printf("\n};\n");

    return 0;
}

/* vi: set ts=4 expandtab: */
