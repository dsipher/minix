/*****************************************************************************

   lex.c                                                  minix c compiler

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

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <string.h>
#include <limits.h>
#include "cc1.h"
#include "string.h"
#include "lex.h"

struct token token;         /* last token seen */
struct string *path;        /* path and line number, as modified by */
int line_no;                /* # directives (for error reporting) */

/* pointers into the source text (which is loaded in its entirety) */

static char *text;          /* first character of this token */
static char *pos;           /* current position */
static char *eof;           /* position of EOF (*eof == 0) */

/* standard ctype classes don't align with our needs, so we roll our own. */

#define A       0x0001      /* letter                       A-Z, a-z, _     */
#define D       0x0002      /* decimal digit                0-9             */
#define O       0x0004      /* octal digit                  0-7             */
#define H       0x0008      /* hexdecimal digit             0-9, A-F, a-f   */
#define E       0x0010      /* letter e                     e, E            */
#define F       0x0020      /* letter f                     f, F            */
#define L       0x0040      /* letter l                     l, L            */
#define U       0x0080      /* letter u                     u, U            */
#define X       0x0100      /* letter x                     x, X            */
#define DOT     0x0200      /* dot                          .               */
#define SPC     0x0400      /* non-newline whitespace       ' ' \t \v \f \r */
#define SGN     0x0800      /* sign                         + -             */
#define NUL     0x1000      /* NUL                          \0              */
#define QUO     0x2000      /* double quote                 "               */
#define TIC     0x4000      /* single quote                 '               */
#define NL      0x8000      /* newline                      \n              */

static unsigned short ctype[UCHAR_MAX] =
{
  /* 00 */  NUL,            0,              0,              0,
  /* 04 */  0,              0,              0,              0,
  /* 08 */  0,              SPC,            NL,             SPC,
  /* 0C */  SPC,            SPC,            0,              0,
  /* 10 */  0,              0,              0,              0,
  /* 14 */  0,              0,              0,              0,
  /* 18 */  0,              0,              0,              0,
  /* 1C */  0,              0,              0,              0,
  /* 20 */  SPC,            0,              QUO,            0,
  /* 24 */  0,              0,              0,              TIC,
  /* 28 */  0,              0,              0,              SGN,
  /* 2C */  0,              SGN,            DOT,            0,
  /* 30 */  D|O|H,          D|O|H,          D|O|H,          D|O|H,
  /* 34 */  D|O|H,          D|O|H,          D|O|H,          D|O|H,
  /* 38 */  D|H,            D|H,            0,              0,
  /* 3C */  0,              0,              0,              0,
  /* 40 */  0,              A|H,            A|H,            A|H,
  /* 44 */  A|H,            A|H|E,          A|H|F,          A,
  /* 48 */  A,              A,              A,              A,
  /* 4C */  A|L,            A,              A,              A,
  /* 50 */  A,              A,              A,              A,
  /* 54 */  A,              A|U,            A,              A,
  /* 58 */  A|X,            A,              A,              0,
  /* 5C */  0,              0,              0,              A,
  /* 60 */  0,              A|H,            A|H,            A|H,
  /* 64 */  A|H,            A|H|E,          A|H|F,          A,
  /* 68 */  A,              A,              A,              A,
  /* 6C */  A|L,            A,              A,              A,
  /* 70 */  A,              A,              A,              A,
  /* 74 */  A,              A|U,            A,              A,
  /* 78 */  A|X,            A,              A,              0,
  /* 7C */  0,              0,              0,              0
};

#define CTYPE(c, flags)     ((ctype[(c) & 0xFF] & (flags)) != 0)

/* map of [non-identifier] tokens to text for print_k(). tokens not in
   this table are assumed to be in keywords[]. the K_BASE() values are
   chosen to cluster all non-keywords together starting from 0. */

static char *token_text[] =       /* indexed by K_BASE() */
{
    "end-of-file",
    "identifier",
    "string literal",
    "integral constant",
    "integral constant",
    "integral constant",
    "integral constant",
    "FP constant",
    "FP constant",
    "FP constant",

    0,      0,      /* K_HASH and K_NL should never be seen here */

    "(",    ")",    "[",    "]",    "{",    "}",    ".",    "...",
    "^",    ",",    ":",    ";",    "?",    "~",    "->",   "++",
    "--",   "!",    "/",    "*",    "+",    "-",    ">",    ">>",
    ">=",   ">>=",  "<",    "<<",   "<=",   "<<=",  "&",    "&&",
    "&=",   "|",    "||",   "|=",   "-=",   "+=",   "*=",   "/=",
    "==",   "!=",   "%",    "%=",   "^=",   "=",

    "initializer",
    "argument",
    "return"
};

/* keywords and other special identifiers. used to seed the string table
   at startup, but also as an extension of token_text[] for print_k().

   seeding the table at runtime, on every run, seems silly and wasteful.
   perhaps it is. pre-seeding properly will require a build-time script. */

static struct { char *text; int k; } keywords[] =
{
    "__asm",        K_ASM,

    "auto",         K_AUTO,         "break",        K_BREAK,
    "case",         K_CASE,         "char",         K_CHAR,
    "const",        K_CONST,        "continue",     K_CONTINUE,
    "default",      K_DEFAULT,      "do",           K_DO,
    "double",       K_DOUBLE,       "else",         K_ELSE,
    "enum",         K_ENUM,         "extern",       K_EXTERN,
    "float",        K_FLOAT,        "for",          K_FOR,
    "goto",         K_GOTO,         "if",           K_IF,
    "int",          K_INT,          "long",         K_LONG,
    "register",     K_REGISTER,     "return",       K_RETURN,
    "short",        K_SHORT,        "signed",       K_SIGNED,
    "sizeof",       K_SIZEOF,       "static",       K_STATIC,
    "struct",       K_STRUCT,       "switch",       K_SWITCH,
    "typedef",      K_TYPEDEF,      "union",        K_UNION,
    "unsigned",     K_UNSIGNED,     "void",         K_VOID,
    "volatile",     K_VOLATILE,     "while",        K_WHILE,

    "rax",          K_RAX,          "rbx",          K_RBX,
    "rcx",          K_RCX,          "rdx",          K_RDX,
    "rsi",          K_RSI,          "rdi",          K_RDI,
    "rsp",          K_RSP,          "rbp",          K_RBP,
    "r8",           K_R8,           "r9",           K_R9,
    "r10",          K_R10,          "r11",          K_R11,
    "r12",          K_R12,          "r13",          K_R13,
    "r14",          K_R14,          "r15",          K_R15,
    "xmm0",         K_XMM0,         "xmm1",         K_XMM1,
    "xmm2",         K_XMM2,         "xmm3",         K_XMM3,
    "xmm4",         K_XMM4,         "xmm5",         K_XMM5,
    "xmm6",         K_XMM6,         "xmm7",         K_XMM7,
    "xmm8",         K_XMM8,         "xmm9",         K_XMM9,
    "xmm10",        K_XMM10,        "xmm11",        K_XMM11,
    "xmm12",        K_XMM12,        "xmm13",        K_XMM13,
    "xmm14",        K_XMM14,        "xmm15",        K_XMM15,
    "mem",          K_MEM,          "cc",           K_CC
};

void seed_keywords(void)
{
    struct string *s;
    int i;

    for (i = 0; i < ARRAY_SIZE(keywords); ++i) {
        s = STRING(keywords[i].text, strlen(keywords[i].text));
        s->k = keywords[i].k;
    }
}

/* the linear search of the keywords[] table is slow,
   but this is only for error reporting, so -shrug- */

#define OQUO(q)     ((q) ? '`' : 0)     /* open and close quotes */
#define CQUO(q)     ((q) ? '\'' : 0)    /* (stupid formatting stuff) */

void print_k(FILE *fp, int k)
{
    int base = K_BASE(k);
    int quote, i;
    char *text;

    if (base < ARRAY_SIZE(token_text)) {
        text = token_text[base];
        quote = !CTYPE(*text, A);
    } else {
        for (i = 0; i < ARRAY_SIZE(keywords); ++i)
            if (keywords[i].k == k) {
                text = keywords[i].text;
                break;
            }

        quote = 1;
    }

    fprintf(fp, "%c%s%c", OQUO(quote), text, CQUO(quote));
}

/* when printing a full token, we
   try to be a little less vague */

void print_token(FILE *fp, struct token *t)
{
    int quote;

    print_k(fp, t->k);

    if (t->k == K_IDENT)
        fprintf(fp, " `" STRING_FMT "'", STRING_ARG(t->s));
    else if (t->k & K_NUMBER) {
        quote = (*t->text != '\'');  /* char constants already quoted */
        fprintf(fp, " %c%.*s%c", OQUO(quote), t->len, t->text, CQUO(quote));
    }
}

/* interpret an escape sequence and return its (unsigned) value. */

#define LOWER(c)    ((c) | 0x20)
#define VAL(c)      ((c) - '0')
#define XVAL(c)     (CTYPE(c, D) ? VAL(c) : ((LOWER(c) - 'a') + 10))

static int escape(void)
{
    int c;

    ++pos;  /* backslash */

    if (CTYPE(*pos, O)) {
        c = VAL(*pos); ++pos;
        if (CTYPE(*pos, O)) {
            c <<= 3; c += VAL(*pos); ++pos;
            if (CTYPE(*pos, O)) {
                c <<= 3; c += VAL(*pos); ++pos;
                if (c > UCHAR_MAX) goto range;
            }
        }
    } else if (*pos == 'x') {
        c = 0;
        ++pos;
        if (!CTYPE(*pos, H)) goto malformed;

        while (CTYPE(*pos, H)) {
            if (c & 0xF0) goto range;
            c <<= 4;
            c += XVAL(*pos);
            ++pos;
        }
    } else {
        switch (*pos) {
        case 'a':       c = '\a'; break;
        case 'b':       c = '\b'; break;
        case 'f':       c = '\f'; break;
        case 'n':       c = '\n'; break;
        case 'r':       c = '\r'; break;
        case 't':       c = '\t'; break;
        case 'v':       c = '\v'; break;

        case '?':
        case '"':
        case '\\':
        case '\'':      c = *pos; break;

        default:        goto malformed;
        }

        ++pos;
    }

    return c;

malformed:
    error(ERROR, 0, "malformed escape sequence");

range:
    error(ERROR, 0, "escaped character out of range");
}

/* character constants. single-character constants are type int and sign
   extended, for parity with unqualified char. multi-character constants
   are interpreted as base-256 values which are int or long. */

static int ccon(void)
{
    int len = 0;
    long i = 0;
    int k;
    int c;

    token.text = text;
    ++pos; /* ' */

    while (!CTYPE(*pos, NUL | NL | TIC)) {
        if (*pos == '\\')
            c = escape();
        else
            c = *pos++ & 0xFF;

        i <<= 8;
        i += c;
        ++len;
    }

    if (*pos != '\'') error(ERROR, 0, "unterminated character constant");

    switch (len)
    {
    case 1:                             k = K_ICON; i = (char) i; break;
    case 2: case 3: case 4:             k = K_ICON; i = (int) i; break;
    case 5: case 6: case 7: case 8:     k = K_LCON; break;

    default:    error(ERROR, 0, "malformed character constant");
    }

    ++pos; /* ' */
    token.len = pos - text;
    token.con.i = i;
    return k;
}

/* string literals. when possible (no escapes and no concatenation) we reuse
   the token text from the lexical buffer. otherwise we use the string arena.
   (it's tempting to overwrite the string in-place in the lexical buffer, but
   that complicates lookahead, making it more trouble than it's worth.)

   we concatenate strings here. this is technically incorrect, because this
   should happen after all directives disappear; a #line or #pragma between
   string literals will expose this flaw. */

static int strlit(void)
{
    int arena = -1;
    char *tmp;
    int adj, c;

    for (;;) {
        ++pos;  /* " */
        ++arena;

        while (!CTYPE(*pos, NUL | NL | QUO)) {
            if (*pos == '\\') {
                c = escape();
                ++arena;
            } else
                c = *pos++;

            STRING_STASH(c);
        }

        if (*pos != '\"') error(ERROR, 0, "unterminated string literal");
        ++pos; /* " */

        /* scan forward to see if another literal follows. if so, we must
           maintain line_no since the outer lexer won't see the newlines.
           if the next token isn't a literal, we don't consume the space. */

        adj = 0;
        tmp = pos;

        while (CTYPE(*tmp, SPC | NL)) {
            if (*tmp == '\n') ++adj;
            ++tmp;
        }

        if (*tmp == '"') {
            line_no += adj;
            pos = tmp;
        } else
            break;
    }

    /* too 'clever' here: arena will be 0 iff the main loop executes exactly
       once (no concatenation) and no escape sequences are encountered. */

    if (arena)
        token.s = STRING_PRESERVE();
    else {
        STRING_DISCARD();
        token.s = STRING(text + 1, pos - text - 2);
    }

    return K_STRLIT;
}

/* scan a numeric constant. ANSI really made a mess of these
   (for dubious reasons), but luckily we can fob off much of
   the dirty work on the standard library. */

static int number(void)
{
    char *endptr;
    int is_unsigned = 0;
    int is_long = 0;
    int must_float = 0;
    int might_float = 0;
    int k;

    token.text = text;

    /* we are compelled to consume the entirety of what constitutes
       a preprocessing number (C89 6.1.8) no matter how preposterous */

    while (CTYPE(*pos, DOT | D | A)) {
        if (CTYPE(*pos, DOT))           /* decimal point, must be a float */
            must_float = 1;

        if (CTYPE(*pos, E)) {
            if (CTYPE(pos[1], SGN)) {       /* [Ee][+-], must be a float */
                ++pos;
                must_float = 1;
            } else if (CTYPE(pos[1], D))    /* looks like an exponent */
                might_float = 1;            /* so might be a float */
        }

        ++pos;
    }

    errno = 0;
    token.len = pos - text;

    /* if this isn't a hex number, then what
       looks like an exponent IS an exponent */

    if ((*text != '0') || !CTYPE(text[1], X))
        must_float |= might_float;

    if (must_float) {
        k = K_DCON;
        token.con.f = strtod(text, &endptr);

        if (CTYPE(*endptr, L)) {
            k = K_LDCON;
            ++endptr;
        } else if (CTYPE(*endptr, F)) {
            token.con.f = strtof(text, &endptr);
            k = K_FCON;
            ++endptr;
        }
    } else {
        token.con.i = strtoul(text, &endptr, 0);
        if (CTYPE(*endptr, L)) { is_long = 1; ++endptr; }
        if (CTYPE(*endptr, U)) { is_unsigned = 1; ++endptr; }
        if (!is_long && CTYPE(*endptr, L)) { is_long = 1; ++endptr; }

        if (is_long && is_unsigned)
            k = K_ULCON;
        else if (is_long) {
            if (token.con.u > LONG_MAX)
                k = K_ULCON;
            else
                k = K_LCON;
        } else if (is_unsigned) {           /* surely there is a */
            if (token.con.u > UINT_MAX)     /* more elegant way to */
                k = K_ULCON;                /* determine the type */
            else                            /* of an integral constant? */
                k = K_UCON;
        } else {
            if (token.con.u > LONG_MAX)
                k = K_ULCON;
            else if (token.con.u > UINT_MAX)
                k = K_LCON;
            else if (token.con.u > INT_MAX) {
                if (*text == '0')
                    k = K_UCON;
                else
                    k = K_LCON;
            } else
                k = K_ICON;
        }
    }

    if (endptr != pos) error(ERROR, 0, "malformed numeric constant");
    if (errno) error(ERROR, 0, "numeric constant out of range");

    return k;
}

/* lex0() is the inner lexer, which does token recognition.
   it updates all the state EXCEPT (surprisingly) token.k:
   instead lex0() returns the token class and lex1() sets it. */

#define OPERATOR(self, dup, eq, dupeq)                                  \
    do {                                                                \
        if (dupeq && (pos[1] == *pos) && (pos[2] == '=')) {             \
            pos += 3;                                                   \
            return dupeq;                                               \
        }                                                               \
                                                                        \
        if (dup && (pos[1] == *pos)) {                                  \
            pos += 2;                                                   \
            return dup;                                                 \
        }                                                               \
                                                                        \
        if (eq && (pos[1] == '=')) {                                    \
            pos += 2;                                                   \
            return eq;                                                  \
        }                                                               \
                                                                        \
        ++pos;                                                          \
        return self;                                                    \
    } while(0)

static int lex0()
{
    while (CTYPE(*pos, SPC)) ++pos;     /* skip whitespace */
    text = pos;                         /* new token begins here */

    switch (*pos)
    {
    case '\n':  ++pos; return K_NL;
    case '#':   ++pos; return K_HASH;
    case '?':   ++pos; return K_QUEST;
    case ':':   ++pos; return K_COLON;
    case ';':   ++pos; return K_SEMI;
    case ',':   ++pos; return K_COMMA;
    case '(':   ++pos; return K_LPAREN;
    case ')':   ++pos; return K_RPAREN;
    case '{':   ++pos; return K_LBRACE;
    case '}':   ++pos; return K_RBRACE;
    case '[':   ++pos; return K_LBRACK;
    case ']':   ++pos; return K_RBRACK;
    case '~':   ++pos; return K_TILDE;

    case '=':   OPERATOR(K_EQ, K_EQEQ, 0, 0);
    case '!':   OPERATOR(K_NOT, 0, K_NOTEQ, 0);
    case '<':   OPERATOR(K_LT, K_SHL, K_LTEQ, K_SHLEQ);
    case '>':   OPERATOR(K_GT, K_SHR, K_GTEQ, K_SHREQ);
    case '^':   OPERATOR(K_XOR, 0, K_XOREQ, 0);
    case '|':   OPERATOR(K_OR, K_LOR, K_OREQ, 0);
    case '&':   OPERATOR(K_AND, K_LAND, K_ANDEQ, 0);
    case '*':   OPERATOR(K_MUL, 0, K_MULEQ, 0);
    case '/':   OPERATOR(K_DIV, 0, K_DIVEQ, 0);
    case '%':   OPERATOR(K_MOD, 0, K_MODEQ, 0);
    case '+':   OPERATOR(K_PLUS, K_INC, K_PLUSEQ, 0);

    case '-':   if (pos[1] == '>') {
                    pos += 2;
                    return K_ARROW;
                }

                OPERATOR(K_MINUS, K_DEC, K_MINUSEQ, 0);

    case '.':   if ((pos[1] == '.') && (pos[2] == '.')) {
                    pos += 3;
                    return K_ELLIP;
                }

                if (!CTYPE(pos[1], D)) {
                    ++pos;
                    return K_DOT;
                }

                /* FALLTHRU */

    case '0': case '1': case '2': case '3': case '4':
    case '5': case '6': case '7': case '8': case '9':

                return number();

    case 'A': case 'B': case 'C': case 'D': case 'E':
    case 'F': case 'G': case 'H': case 'I': case 'J':
    case 'K': case 'L': case 'M': case 'N': case 'O':
    case 'P': case 'Q': case 'R': case 'S': case 'T':
    case 'U': case 'V': case 'W': case 'X': case 'Y':
    case 'Z': case '_': case 'a': case 'b': case 'c':
    case 'd': case 'e': case 'f': case 'g': case 'h':
    case 'i': case 'j': case 'k': case 'l': case 'm':
    case 'n': case 'o': case 'p': case 'q': case 'r':
    case 's': case 't': case 'u': case 'v': case 'w':
    case 'x': case 'y': case 'z':

        /* identifers/keywords. the string table differentiates
           for us. only K_KEYWORDs are automatically recognized:
           this is the defining difference between keywords and
           special identifiers. */

        while (CTYPE(*pos, A | D)) ++pos;
        token.s = STRING(text, pos - text);

        if (token.s->k & K_KEYWORD)
            return token.s->k;
        else
            return K_IDENT;

    case '\"':  return strlit();
    case '\'':  return ccon();

    case 0:
        if (pos == eof) return 0;
        /* FALLTHRU */
    default:
        error(ERROR, 0, "invalid character in input (ASCII %d)", *pos & 0xFF);
    }
}


/* the middle pipeline stage reinjects tokens buffered by lookahead().
   the initial K_NL syncs up the line-tracking in the outer lexer. */

static struct token next = { K_NL };

static void lex1(void)
{
    if (next.k == 0)
        token.k = lex0();
    else {
        token = next;
        next.k = 0;
    }
}

struct token lookahead(void)
{
    struct token tmp;

    if (next.k == 0) {
        tmp = token;
        lex();
        next = token;
        token = tmp;
    }

    return next;
}

/* the outer lexer is responsible for tracking the error-reporting location,
   both by counting newlines and interpreting (and filtering) # lines from
   the preprocessor. if/when we implement #pragmas, the preprocessor will
   pass them along unchanged, and they will be dispatched from here. */

void lex(void)
{
    lex1();

    while (token.k == K_NL) {
        ++line_no;
        lex1();

        if (token.k == K_HASH) {
            lex1();
            if (token.k == K_ICON) {
                line_no = token.con.i;
                lex1();
                if (token.k == K_STRLIT) {
                    path = token.s;
                    lex1();
                }
            }

            /* completely mangled directives should never get past
               the preprocessor, and the preprocessor should never
               generate bogus directives itself. nevertheless... */

            if (token.k != K_NL) error(ERROR, 0, "malformed directive");
            lex1();
        }
    }
}

/* read the entire file in one go into a dynamically-allocated buffer.
   we append a NUL to the buffer to ensure we don't run off its end. */

void init_lex(char *in_path)
{
    struct stat statbuf;
    int fd;

    path = STRING(in_path, strlen(in_path));
    fd = open(in_path, O_RDONLY);
    if (fd == -1) error(SYSTEM, 0, "can't open input");
    if (fstat(fd, &statbuf) == -1) error(SYSTEM, 0, "can't stat input");

    pos = sbrk(statbuf.st_size + 1); /* +1 for NUL terminator */

    if (pos == (void *) -1) error(SYSTEM, 0, "can't allocate lexical buffer");

    if (read(fd, pos, statbuf.st_size) != statbuf.st_size)
        error(SYSTEM, 0, "can't read input");

    eof = pos + statbuf.st_size;
    *eof = 0;
    text = pos;

    close(fd);
    lex();  /* prime the pump */
}

void expect(int k)
{
    if (token.k != k)
        error(ERROR, 0, "expected %k before %K", k, &token);
}

int comma(void)
{
    if (token.k == K_COMMA) {
        lex();
        return (token.k != K_RBRACE);
    }

    return 0;
}

/* vi: set ts=4 expandtab: */
