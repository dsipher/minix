/*****************************************************************************

   lex.h                                                  ux/64 c compiler

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

#ifndef LEX_H
#define LEX_H

/* token classes are simply distinct ints. class variables are called
   k and the values are prefixed with K_ for 'historical' reasons. */

    /* bits[7:0] form a simple ordinal which ensures each token class is
       unique, and also provides an index into token_text[] in lex.c. */

#define K_BASE_MASK         0x000000FF              /* bits[7:0] */
#define K_BASE(k)           ((k) & K_BASE_MASK)

    /* bits[16:8] form a set which simplifies parsing type specifiers */

#define K_SPEC_MASK         0x0001FF00
#define K_SPEC(k)           ((k) & K_SPEC_MASK)

#define K_SPEC_VOID         0x00000100
#define K_SPEC_CHAR         0x00000200
#define K_SPEC_SHORT        0x00000400
#define K_SPEC_INT          0x00000800
#define K_SPEC_LONG         0x00001000
#define K_SPEC_FLOAT        0x00002000
#define K_SPEC_DOUBLE       0x00004000
#define K_SPEC_UNSIGNED     0x00008000
#define K_SPEC_SIGNED       0x00010000

#define K_REG               0x00020000      /* bit[17]: __asm register */

    /* bits[23:20] encode the precedence of (most) binary operators */

#define K_PREC_MASK         0x00F00000
#define K_PREC(k)           ((k) & K_PREC_MASK)

#define K_PREC_NEXT(k)      (K_PREC(k) + 0x00100000)

#define K_PREC_MUL          0x00B00000      /* highest precedence */
#define K_PREC_ADD          0x00A00000
#define K_PREC_SHIFT        0x00900000
#define K_PREC_REL          0x00800000
#define K_PREC_EQ           0x00700000
#define K_PREC_AND          0x00600000
#define K_PREC_XOR          0x00500000
#define K_PREC_OR           0x00400000
#define K_PREC_LAND         0x00300000
#define K_PREC_LOR          0x00200000
#define K_PREC_ASG          0x00100000      /* lowest precedence */

#define K_PREC_NONE         0x00000000

    /* bits[28:24] hold an index into the binary map[] in expr.c,
       mapping binary operator tokens to tree ops. keep in sync. */

#define K_MAP_MASK          ( 0x1F000000 )
#define K_MAP_SHIFT         24
#define K_MAP_IDX(k)        (((k) & K_MAP_MASK) >> K_MAP_SHIFT)
#define K_MAP_ENC(i)        ((i) << K_MAP_SHIFT)

#define K_DECL              0x20000000      /* bit[29]: see K_IS_DECL() */
#define K_NUMBER            0x40000000      /* bit[30]: numeric token */
#define K_KEYWORD           0x80000000      /* bit[31]: keyword token */

    /* token classes proper */

#define K_NONE      (   0 )                 /* reserve 0 for "none" */

#define K_IDENT     (   1 )                 /* identifier */
#define K_STRLIT    (   2 )                 /* string literal */
#define K_ICON      (   3 | K_NUMBER )      /* int constant */
#define K_UCON      (   4 | K_NUMBER )      /* unsigned constant */
#define K_LCON      (   5 | K_NUMBER )      /* long constant */
#define K_ULCON     (   6 | K_NUMBER )      /* unsigned long constant */
#define K_FCON      (   7 | K_NUMBER )      /* float constant */
#define K_DCON      (   8 | K_NUMBER )      /* double constant */
#define K_LDCON     (   9 | K_NUMBER )      /* long double constant */

#define K_HASH      (  10 )                 /* pseudo-tokens: should never */
#define K_NL        (  11 )                 /* appear outside the lexer */

#define K_LPAREN    (  12 )                                         /* ( */
#define K_RPAREN    (  13 )                                         /* ) */
#define K_LBRACK    (  14 )                                         /* [ */
#define K_RBRACK    (  15 )                                         /* ] */
#define K_LBRACE    (  16 )                                         /* { */
#define K_RBRACE    (  17 )                                         /* } */
#define K_DOT       (  18 )                                         /* . */
#define K_ELLIP     (  19 )                                         /* ... */
#define K_XOR       (  20 | K_MAP_ENC(11) | K_PREC_XOR )            /* ^ */
#define K_COMMA     (  21 )                                         /* , */
#define K_COLON     (  22 | K_MAP_ENC(29) )                         /* : */
#define K_SEMI      (  23 )                                         /* ; */
#define K_QUEST     (  24 )                                         /* ? */
#define K_TILDE     (  25 )                                         /* ~ */
#define K_ARROW     (  26 )                                         /* -> */
#define K_INC       (  27 )                                         /* ++ */
#define K_DEC       (  28 )                                         /* -- */
#define K_NOT       (  29 )                                         /* ! */
#define K_DIV       (  30 | K_MAP_ENC(12) | K_PREC_MUL )            /* / */
#define K_MUL       (  31 | K_MAP_ENC(13) | K_PREC_MUL )            /* * */
#define K_PLUS      (  32 | K_MAP_ENC(14) | K_PREC_ADD )            /* + */
#define K_MINUS     (  33 | K_MAP_ENC(15) | K_PREC_ADD )            /* - */
#define K_GT        (  34 | K_MAP_ENC(16) | K_PREC_REL )            /* > */
#define K_SHR       (  35 | K_MAP_ENC(17) | K_PREC_SHIFT )          /* >> */
#define K_GTEQ      (  36 | K_MAP_ENC(18) | K_PREC_REL )            /* >= */
#define K_SHREQ     (  37 | K_MAP_ENC( 7) | K_PREC_ASG )            /* >>= */
#define K_LT        (  38 | K_MAP_ENC(19) | K_PREC_REL )            /* < */
#define K_SHL       (  39 | K_MAP_ENC(20) | K_PREC_SHIFT )          /* << */
#define K_LTEQ      (  40 | K_MAP_ENC(21) | K_PREC_REL )            /* <= */
#define K_SHLEQ     (  41 | K_MAP_ENC( 6) | K_PREC_ASG )            /* <<= */
#define K_AND       (  42 | K_MAP_ENC(22) | K_PREC_AND )            /* & */
#define K_LAND      (  43 | K_MAP_ENC(23) | K_PREC_LAND )           /* && */
#define K_ANDEQ     (  44 | K_MAP_ENC( 8) | K_PREC_ASG )            /* &= */
#define K_OR        (  45 | K_MAP_ENC(26) | K_PREC_OR )             /* | */
#define K_LOR       (  46 | K_MAP_ENC(27) | K_PREC_LOR )            /* || */
#define K_OREQ      (  47 | K_MAP_ENC( 9) | K_PREC_ASG )            /* |= */
#define K_MINUSEQ   (  48 | K_MAP_ENC( 5) | K_PREC_ASG )            /* -= */
#define K_PLUSEQ    (  49 | K_MAP_ENC( 4) | K_PREC_ASG )            /* += */
#define K_MULEQ     (  50 | K_MAP_ENC( 1) | K_PREC_ASG )            /* *= */
#define K_DIVEQ     (  51 | K_MAP_ENC( 2) | K_PREC_ASG )            /* /= */
#define K_EQEQ      (  52 | K_MAP_ENC(24) | K_PREC_EQ )             /* == */
#define K_NOTEQ     (  53 | K_MAP_ENC(25) | K_PREC_EQ )             /* != */
#define K_MOD       (  54 | K_MAP_ENC(28) | K_PREC_MUL )            /* % */
#define K_MODEQ     (  55 | K_MAP_ENC( 3) | K_PREC_ASG )            /* %= */
#define K_XOREQ     (  56 | K_MAP_ENC(10) | K_PREC_ASG )            /* ^= */
#define K_EQ        (  57 | K_MAP_ENC( 0) | K_PREC_ASG )            /* = */

    /* pseudo tokens used when constructing binary trees. these are all
       equivalent in function to K_EQ, since initializers, arguments and
       return values behave like assignment; we distingish them to map
       them to different token_text[] for error messages that make sense */

#define K_INIT      (  58 | K_MAP_ENC( 0) | K_PREC_ASG )    /* initializers */
#define K_ARG       (  59 | K_MAP_ENC( 0) | K_PREC_ASG )       /* arguments */
#define K_RET       (  60 | K_MAP_ENC( 0) | K_PREC_ASG )       /* returns */

    /* special identifiers should come last (as ordered by
       K_BASE) to accommodate the the logic in print_k() */

#define K_ASM       (  61 | K_KEYWORD )
#define K_AUTO      (  62 | K_KEYWORD | K_DECL )
#define K_BREAK     (  63 | K_KEYWORD )
#define K_CASE      (  64 | K_KEYWORD )
#define K_CHAR      (  65 | K_KEYWORD | K_DECL | K_SPEC_CHAR )
#define K_CONST     (  66 | K_KEYWORD | K_DECL )
#define K_CONTINUE  (  67 | K_KEYWORD )
#define K_DEFAULT   (  68 | K_KEYWORD )
#define K_DO        (  69 | K_KEYWORD )
#define K_DOUBLE    (  70 | K_KEYWORD | K_DECL | K_SPEC_DOUBLE )
#define K_ELSE      (  71 | K_KEYWORD )
#define K_ENUM      (  72 | K_KEYWORD | K_DECL )
#define K_EXTERN    (  73 | K_KEYWORD | K_DECL )
#define K_FLOAT     (  74 | K_KEYWORD | K_DECL | K_SPEC_FLOAT )
#define K_FOR       (  75 | K_KEYWORD )
#define K_GOTO      (  76 | K_KEYWORD )
#define K_IF        (  77 | K_KEYWORD )
#define K_INT       (  78 | K_KEYWORD | K_DECL | K_SPEC_INT )
#define K_LONG      (  79 | K_KEYWORD | K_DECL | K_SPEC_LONG )
#define K_REGISTER  (  80 | K_KEYWORD | K_DECL )
#define K_RETURN    (  81 | K_KEYWORD )
#define K_SHORT     (  82 | K_KEYWORD | K_DECL | K_SPEC_SHORT )
#define K_SIGNED    (  83 | K_KEYWORD | K_DECL | K_SPEC_SIGNED )
#define K_SIZEOF    (  84 | K_KEYWORD )
#define K_STATIC    (  85 | K_KEYWORD | K_DECL )
#define K_STRUCT    (  86 | K_KEYWORD | K_DECL )
#define K_SWITCH    (  87 | K_KEYWORD )
#define K_TYPEDEF   (  88 | K_KEYWORD | K_DECL )
#define K_UNION     (  89 | K_KEYWORD | K_DECL )
#define K_UNSIGNED  (  90 | K_KEYWORD | K_DECL | K_SPEC_UNSIGNED )
#define K_VOID      (  91 | K_KEYWORD | K_DECL | K_SPEC_VOID )
#define K_VOLATILE  (  92 | K_KEYWORD | K_DECL )
#define K_WHILE     (  93 | K_KEYWORD )

#define K_RAX       (  94 | K_REG )         /* for __asm statements */
#define K_RCX       (  95 | K_REG )
#define K_RDX       (  96 | K_REG )         /* these registers must be */
#define K_RSI       (  97 | K_REG )         /* in the same order as */
#define K_RDI       (  98 | K_REG )         /* machine register indices */
#define K_R8        (  99 | K_REG )         /* in reg.h, in order for */
#define K_R9        ( 100 | K_REG )         /* K_TO_REG() to work */
#define K_R10       ( 101 | K_REG )
#define K_R11       ( 102 | K_REG )
#define K_RBX       ( 103 | K_REG )
#define K_RSP       ( 104 | K_REG )
#define K_RBP       ( 105 | K_REG )
#define K_R12       ( 106 | K_REG )
#define K_R13       ( 107 | K_REG )
#define K_R14       ( 108 | K_REG )
#define K_R15       ( 109 | K_REG )
#define K_XMM0      ( 110 | K_REG )
#define K_XMM1      ( 111 | K_REG )
#define K_XMM2      ( 112 | K_REG )
#define K_XMM3      ( 113 | K_REG )
#define K_XMM4      ( 114 | K_REG )
#define K_XMM5      ( 115 | K_REG )
#define K_XMM6      ( 116 | K_REG )
#define K_XMM7      ( 117 | K_REG )
#define K_XMM8      ( 118 | K_REG )
#define K_XMM9      ( 119 | K_REG )
#define K_XMM10     ( 120 | K_REG )
#define K_XMM11     ( 121 | K_REG )
#define K_XMM12     ( 122 | K_REG )
#define K_XMM13     ( 123 | K_REG )
#define K_XMM14     ( 124 | K_REG )
#define K_XMM15     ( 125 | K_REG )

#define K_MEM       ( 126 )
#define K_CC        ( 127 )

/* convert the token value for a machine register
   into the actual machine register. relies on the
   identical sequencing of K_* and REG_* constants */

#define K_TO_REG(k)     REG((k) - K_RAX)

/* struct token is the full description of a token, i.e. its class and any
   associated payload. we also keep track of the original text of the token
   in the lexical buffer (the text/len pair) for improved error reporting. */

struct token
{
    int k;

    char *text;     /* these are only set when (k & K_NUMBER), since we */
    int len;        /* can't reproduce their text from the value alone */

    union
    {
        union con con;      /* K_ICON .. K_LDCON */
        struct string *s;   /* K_IDENT, K_STRLIT */
    };
};

/* seeds keywords and special identifiers. */

void seed_keywords(void);

/* open the input file and initialize the lexer */

void init_lex(char *in_path);

/* scan for the next token. updates token, path and line_no */

extern struct token token;
extern struct string *path;
extern int line_no;

void lex(void);

/* return the next token WITHOUT advancing. */

struct token lookahead(void);

/* print human-readable token class or full token
   to fp. this is for error reporting only. */

void print_k(FILE *fp, int k);
void print_token(FILE *fp, struct token *t);

/* parsing helpers: bomb with an error if the
   next token is not of the specified class */

void expect(int k);

#define MATCH(_k)    do { expect(_k); lex(); } while (0)

/* parsing helper for non-standard constructions.

   if the next token is a comma
        1. consume it, and then
        2. return true iff the next token is not '}'

   otherwise return false.

   this is used by parsing routines to distinguish
   between separating commas vs trailing commas in
   enum definitions, initializers, etc. C89 rather
   pedantically prohibits them where K&R did not.
   C99 once again relaxed the syntax, so we do too */

int comma(void);

/* true if the token t looks like the start of a declaration- that
   is, a declaration-specifier or an identifier that names a type.
   (use of this macro requires that the caller include symbol.h) */

#define K_IS_DECL(t)        ( ((t).k & K_DECL) ||                           \
                              (((t).k == K_IDENT) && named_type((t).s)) )

#endif /* LEX_H */

/* vi: set ts=4 expandtab: */
