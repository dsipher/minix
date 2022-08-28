%{
#include "as.h"
#include "y.tab.h"
%}

D               [0-9]
L               [A-Za-z_]
X               [0-9A-Za-z_]
S               [ \t\v\f]

%%

{S}+            /* eat whitespace */ ;

"#".*\n         |
"/".*\n         |
\n              return '\n';

"."             |
"*"             |
":"             |
","             |
"$"             |
"+"             |
"("             |
")"             |
"="             |
"-"             return *yytext;

{D}{X}*         {
                    /* numbers can be octal, decimal, or hex,
                       using c rules; let strtoul do the work */

                    char *endptr;

                    errno = 0;
                    yylval.l = strtoul(yytext, &endptr, 0);

                    if (*endptr || errno)
                        error("malformed number `%s'", yytext);

                    return NUMBER;
                }

{L}{X}+         {
                    /* an identifier is either a mnemonic or
                       a symbol. mnemonics are reserved words. */

                    struct name *n;

                    n = lookup(yytext, yyleng);

                    if (n->mnemonic) {
                        yylval.insns = n->insns;
                        return MNEMONIC;
                    } else {
                        undef(n->sym);
                        yylval.sym = n->sym;
                        return SYMBOL;
                    }
                }

\"[^"\n]+\"     {
                    /* stash the contents of string in the line
                       pool, NUL-terminated with delimiters */

                    int len = yyleng - 2;
                    yylval.s = ALLOC(len + 1);
                    memcpy(yylval.s, yytext + 1, len);
                    yylval.s[len] = 0;
                    return STRLIT;
                }

".align"        return ALIGN;
".ascii"        return ASCII;
".bss"          return BSS;
".byte"         return BYTE;
".code16"       return CODE16;
".code32"       return CODE32;
".code64"       return CODE64;
".comm"         return BSS;
".data"         return DATA;
".fill"         return FILL;
".globl"        return GLOBL;
".int"          return INT;
".local"        return LOCAL;
".org"          return ORG;
".quad"         return QUAD;
".short"        return SHORT;
".text"         return TEXT;

"."({L}|{D})+   error("unknown pseudo-op `%s'", yytext);

"%rip"          return RIP;

"%cs"           return CS;
"%ds"           return DS;
"%ss"           return SS;
"%es"           return ES;
"%fs"           return FS;
"%gs"           return GS;

"%al"           return AL;
"%ah"           return AH;
"%ax"           return AX;
"%eax"          return EAX;
"%rax"          return RAX;
"%bl"           return BL;
"%bh"           return BH;
"%bx"           return BX;
"%ebx"          return EBX;
"%rbx"          return RBX;
"%cl"           return CL;
"%ch"           return CH;
"%cx"           return CX;
"%ecx"          return ECX;
"%rcx"          return RCX;
"%dl"           return DL;
"%dh"           return DH;
"%dx"           return DX;
"%edx"          return EDX;
"%rdx"          return RDX;
"%sil"          return SIL;
"%si"           return SI;
"%esi"          return ESI;
"%rsi"          return RSI;
"%dil"          return DIL;
"%di"           return DI;
"%edi"          return EDI;
"%rdi"          return RDI;
"%bpl"          return BPL;
"%bp"           return BP;
"%ebp"          return EBP;
"%rbp"          return RBP;
"%spl"          return SPL;
"%sp"           return SP;
"%esp"          return ESP;
"%rsp"          return RSP;
"%r8b"          return R8B;
"%r8w"          return R8W;
"%r8d"          return R8D;
"%r8"           return R8;
"%r9b"          return R9B;
"%r9w"          return R9W;
"%r9d"          return R9D;
"%r9"           return R9;
"%r10b"         return R10B;
"%r10w"         return R10W;
"%r10d"         return R10D;
"%r10"          return R10;
"%r11b"         return R11B;
"%r11w"         return R11W;
"%r11d"         return R11D;
"%r11"          return R11;
"%r12b"         return R12B;
"%r12w"         return R12W;
"%r12d"         return R12D;
"%r12"          return R12;
"%r13b"         return R13B;
"%r13w"         return R13W;
"%r13d"         return R13D;
"%r13"          return R13;
"%r14b"         return R14B;
"%r14w"         return R14W;
"%r14d"         return R14D;
"%r14"          return R14;
"%r15b"         return R15B;
"%r15w"         return R15W;
"%r15d"         return R15D;
"%r15"          return R15;
"%xmm0"         return XMM0;
"%xmm1"         return XMM1;
"%xmm2"         return XMM2;
"%xmm3"         return XMM3;
"%xmm4"         return XMM4;
"%xmm5"         return XMM5;
"%xmm6"         return XMM6;
"%xmm7"         return XMM7;
"%xmm8"         return XMM8;
"%xmm9"         return XMM9;
"%xmm10"        return XMM10;
"%xmm11"        return XMM11;
"%xmm12"        return XMM12;
"%xmm13"        return XMM13;
"%xmm14"        return XMM14;
"%xmm15"        return XMM15;
"%cr0"          return CR0;
"%cr1"          return CR1;
"%cr2"          return CR2;
"%cr3"          return CR3;
"%cr4"          return CR4;
"%cr5"          return CR5;
"%cr6"          return CR6;
"%cr7"          return CR7;
"%cr8"          return CR8;
"%cr9"          return CR9;
"%cr10"         return CR10;
"%cr11"         return CR11;
"%cr12"         return CR12;
"%cr13"         return CR13;
"%cr14"         return CR14;
"%cr15"         return CR15;

"%"({L}|{D})+   error("`%s' is not a register", yytext);

.               {
                    if (isprint(*yytext))
                        error("malformed token (starting at `%c')", *yytext);
                    else
                        error("invalid character (%d) in input", *yytext);
                }

%%

/* vi: set ts=4 expandtab: */
