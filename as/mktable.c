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
    {   "cbtw",         0               },
    {   "clc",          0               },
    {   "cld",          0               },
    {   "cli",          0               },
    {   "cltd",         0               },
    {   "cmc",          0               },
    {   "cmovaw",       "cmovnbew"      },
    {   "cmoval",       "cmovnbel"      },
    {   "cmovaq",       "cmovnbeq"      },
    {   "cmovaew",      "cmovnbw"       },
    {   "cmovael",      "cmovnbl"       },
    {   "cmovaeq",      "cmovnbq"       },
    {   "cmovbew",      0               },
    {   "cmovbel",      0               },
    {   "cmovbeq",      0               },
    {   "cmovbw",       0               },
    {   "cmovbl",       0               },
    {   "cmovbq",       0               },
    {   "cmovcw",       "cmovbw"        },
    {   "cmovcl",       "cmovbl"        },
    {   "cmovcq",       "cmovbq"        },
    {   "cmovew",       "cmovzw"        },
    {   "cmovel",       "cmovzl"        },
    {   "cmoveq",       "cmovzq"        },
    {   "cmovgw",       "cmovnlew"      },
    {   "cmovgl",       "cmovnlel"      },
    {   "cmovgq",       "cmovnleq"      },
    {   "cmovgew",      "cmovnlw"       },
    {   "cmovgel",      "cmovnll"       },
    {   "cmovgeq",      "cmovnlq"       },
    {   "cmovlew",      0               },
    {   "cmovlel",      0               },
    {   "cmovleq",      0               },
    {   "cmovlw",       0               },
    {   "cmovll",       0               },
    {   "cmovlq",       0               },
    {   "cmovnaw",      "cmovbew"       },
    {   "cmovnal",      "cmovbel"       },
    {   "cmovnaq",      "cmovbeq"       },
    {   "cmovnaew",     "cmovbw"        },
    {   "cmovnael",     "cmovbl"        },
    {   "cmovnaeq",     "cmovbq"        },
    {   "cmovnbew",     0               },
    {   "cmovnbel",     0               },
    {   "cmovnbeq",     0               },
    {   "cmovnbw",      0               },
    {   "cmovnbl",      0               },
    {   "cmovnbq",      0               },
    {   "cmovncw",      "cmovnbw"       },
    {   "cmovncl",      "cmovnbl"       },
    {   "cmovncq",      "cmovnbq"       },
    {   "cmovnew",      "cmovnzw"       },
    {   "cmovnel",      "cmovnzl"       },
    {   "cmovneq",      "cmovnzq"       },
    {   "cmovngew",     "cmovlw"        },
    {   "cmovngel",     "cmovll"        },
    {   "cmovngeq",     "cmovlq"        },
    {   "cmovngw",      "cmovlew"       },
    {   "cmovngl",      "cmovlel"       },
    {   "cmovngq",      "cmovleq"       },
    {   "cmovnlew",     0               },
    {   "cmovnlel",     0               },
    {   "cmovnleq",     0               },
    {   "cmovnlw",      0               },
    {   "cmovnll",      0               },
    {   "cmovnlq",      0               },
    {   "cmovnow",      0               },
    {   "cmovnol",      0               },
    {   "cmovnoq",      0               },
    {   "cmovnpw",      0               },
    {   "cmovnpl",      0               },
    {   "cmovnpq",      0               },
    {   "cmovnsw",      0               },
    {   "cmovnsl",      0               },
    {   "cmovnsq",      0               },
    {   "cmovnzw",      0               },
    {   "cmovnzl",      0               },
    {   "cmovnzq",      0               },
    {   "cmovow",       0               },
    {   "cmovol",       0               },
    {   "cmovoq",       0               },
    {   "cmovpow",      "cmovnpw"       },
    {   "cmovpol",      "cmovnpl"       },
    {   "cmovpoq",      "cmovnpq"       },
    {   "cmovpw",       0               },
    {   "cmovpl",       0               },
    {   "cmovpq",       0               },
    {   "cmovpew",      "cmovpw"        },
    {   "cmovpel",      "cmovpl"        },
    {   "cmovpeq",      "cmovpq"        },
    {   "cmovsw",       0               },
    {   "cmovsl",       0               },
    {   "cmovsq",       0               },
    {   "cmovzw",       0               },
    {   "cmovzl",       0               },
    {   "cmovzq",       0               },
    {   "cmpb",         0               },
    {   "cmpw",         0               },
    {   "cmpl",         0               },
    {   "cmpq",         0               },
    {   "cmpsb",        0               },
    {   "cmpsw",        0               },
    {   "cmpsl",        0               },
    {   "cmpsq",        0               },
    {   "cqto",         0               },
    {   "cwtd",         0               },
    {   "decb",         0               },
    {   "decw",         0               },
    {   "decl",         0               },
    {   "decq",         0               },
    {   "hlt",          0               },
    {   "imulb",        0               },
    {   "imulw",        0               },
    {   "imull",        0               },
    {   "imulq",        0               },
    {   "incb",         0               },
    {   "incw",         0               },
    {   "incl",         0               },
    {   "incq",         0               },
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
    {   "leaw",         0               },
    {   "leal",         0               },
    {   "leaq",         0               },
    {   "lock",         0               },
    {   "lodsb",        0               },
    {   "lodsw",        0               },
    {   "lodsl",        0               },
    {   "lodsq",        0               },
    {   "movb",         0               },
    {   "movl",         0               },
    {   "movq",         0               },
    {   "movsb",        0               },
    {   "movsbw",       0               },
    {   "movsbl",       0               },
    {   "movsbq",       0               },
    {   "movsw",        0               },
    {   "movswl",       0               },
    {   "movswq",       0               },
    {   "movsl",        0               },
    {   "movslq",       0               },
    {   "movsq",        0               },
    {   "movw",         0               },
    {   "movzbw",       0               },
    {   "movzbl",       0               },
    {   "movzbq",       0               },
    {   "movzwl",       0               },
    {   "movzwq",       0               },
    {   "negb",         0               },
    {   "negw",         0               },
    {   "negl",         0               },
    {   "negq",         0               },
    {   "notb",         0               },
    {   "notw",         0               },
    {   "notl",         0               },
    {   "notq",         0               },
    {   "orb",          0               },
    {   "orw",          0               },
    {   "orl",          0               },
    {   "orq",          0               },
    {   "popw",         0               },
    {   "popl",         0               },
    {   "popq",         0               },
    {   "pushw",        0               },
    {   "pushl",        0               },
    {   "pushq",        0               },
    {   "rep",          0               },
    {   "ret",          0               },
    {   "sbbb",         0               },
    {   "sbbw",         0               },
    {   "sbbl",         0               },
    {   "sbbq",         0               },
    {   "scasb",        0               },
    {   "scasw",        0               },
    {   "scasl",        0               },
    {   "scasq",        0               },
    {   "seg",          0               },
    {   "seta",         "setnbe"        },
    {   "setae",        "setnb"         },
    {   "setb",         0               },
    {   "setbe",        0               },
    {   "setc",         "setb"          },
    {   "sete",         "setz"          },
    {   "setg",         "setnle"        },
    {   "setge",        "setnl"         },
    {   "setl",         0               },
    {   "setle",        0               },
    {   "setna",        "setbe"         },
    {   "setnae",       "setb"          },
    {   "setnb",        0,              },
    {   "setnbe",       0               },
    {   "setnc",        "setnb"         },
    {   "setne",        "setnz"         },
    {   "setng",        "setle"         },
    {   "setnge",       "setl"          },
    {   "setnl",        0               },
    {   "setnle",       0               },
    {   "setno",        0               },
    {   "setnp",        0               },
    {   "setns",        0               },
    {   "setnz",        0               },
    {   "seto",         0               },
    {   "setp",         0               },
    {   "setpe",        "setp"          },
    {   "setpo",        "setnp"         },
    {   "sets",         0               },
    {   "setz",         0               },
    {   "salb",         "shlb"          },
    {   "salw",         "shlw"          },
    {   "sall",         "shll"          },
    {   "salq",         "shlq"          },
    {   "sarb",         0               },
    {   "sarw",         0               },
    {   "sarl",         0               },
    {   "sarq",         0               },
    {   "shlb",         0               },
    {   "shlw",         0               },
    {   "shll",         0               },
    {   "shlq",         0               },
    {   "shrb",         0               },
    {   "shrw",         0               },
    {   "shrl",         0               },
    {   "shrq",         0               },
    {   "stc",          0               },
    {   "std",          0               },
    {   "sti",          0               },
    {   "stosb",        0               },
    {   "stosw",        0               },
    {   "stosl",        0               },
    {   "stosq",        0               },
    {   "subb",         0               },
    {   "subw",         0               },
    {   "subl",         0               },
    {   "subq",         0               },
    {   "testb",        0               },
    {   "testw",        0               },
    {   "testl",        0               },
    {   "testq",        0               },
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
