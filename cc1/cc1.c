/*****************************************************************************

   cc1.c                                               jewel/os c compiler

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
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include "cc1.h"
#include "heap.h"
#include "type.h"
#include "string.h"
#include "symbol.h"
#include "func.h"
#include "lex.h"
#include "reg.h"
#include "init.h"
#include "decl.h"
#include "insn.h"

int last_asmlab;                /* last assigned asmlab */
char w_flag;                    /* -w: enable warnings */
FILE *out_f;                    /* output file handle ... */
static char *out_path;          /* ... and the path to it */

void out(char *fmt, ...)
{
    va_list args;

    va_start(args, fmt);

    while (*fmt) {
        if (*fmt != '%')
            putc(*fmt, out_f);
        else switch (*++fmt)
        {
        case 'd':   fprintf(out_f, "%d", va_arg(args, int)); break;
        case 'f':   fprintf(out_f, "%f", va_arg(args, double)); break;
        case 'r':   print_reg(out_f, va_arg(args, int), 0); break;
        case 's':   fprintf(out_f, "%s", va_arg(args, char *)); break;
        case 'x':   fprintf(out_f, "0x%x", va_arg(args, int)); break;
        case 'g':   print_global(out_f, va_arg(args, struct symbol *)); break;
        case 'D':   fprintf(out_f, "%ld", va_arg(args, long)); break;

        case 'G':   {
                        struct symbol *sym = va_arg(args, struct symbol *);
                        long i = va_arg(args, long);

                        if (sym) {
                            print_global(out_f, sym);
                            if (i) fprintf(out_f, "%+ld", i);
                        } else
                            fprintf(out_f, "%ld", i);

                        break;
                    }

        case 'L':   fprintf(out_f, ASMLAB_FMT, va_arg(args, int)); break;

        case 'R':   {
                        int reg = va_arg(args, int);
                        int t = va_arg(args, long);

                        print_reg(out_f, reg, t);
                        break;
                    }

        case 'S':   {
                        struct string *s = va_arg(args, struct string *);
                        fprintf(out_f, STRING_FMT, STRING_ARG(s));
                        break;
                    }

        case 'X':   fprintf(out_f, "0x%lx", va_arg(args, long)); break;

        default:    /* covers %%, but also gives us a
                       clue in case of a bungled out() */

                    putc(*fmt, out_f);
        }

        ++fmt;
    }

    va_end(args);
}

void seg(int newseg)
{
    static int curseg;  /* initialized to 0 == 'no segment' */

    if (newseg != curseg) {
        fputs((newseg == SEG_TEXT) ? ".text\n" : ".data\n", out_f);
        curseg = newseg;
    }
}

void error(int level, struct string *id, char *fmt, ...)
{
    static const char *errors[] = {     "WARNING",  /* indexed by level */
                                        "SORRY",
                                        "SYSTEM ERROR",
                                        "INTERNAL ERROR",
                                        "ERROR"             };

    va_list args;

    if ((level == WARNING) && !w_flag)
        return;

    if (path) {
        fprintf(stderr, STRING_FMT, STRING_ARG(path));
        if (line_no) fprintf(stderr, " (%d)", line_no);
        fprintf(stderr, ": ");
    }

    fprintf(stderr, "%s: ", errors[level]);
    if (id) fprintf(stderr, "`" STRING_FMT "': ", STRING_ARG(id));

    va_start(args, fmt);

    while (*fmt) {
        if (*fmt != '%')
            putc(*fmt, stderr);
        else switch (*++fmt)
        {
        case 'd':   fprintf(stderr, "%d", va_arg(args, int)); break;
        case 'k':   print_k(stderr, va_arg(args, int)); break;

        case 'q':   {
                        long quals = va_arg(args, long);

                        fprintf(stderr, "`%s%s%s` qualifier%s",
                            (quals & T_CONST) ? "const" : "",
                            (quals == (T_CONST | T_VOLATILE)) ? " " : "",
                            (quals & T_VOLATILE) ? "volatile" : "",
                            (quals == (T_CONST | T_VOLATILE)) ? "s" : "");

                        break;
                    }

        case 's':   fprintf(stderr, "%s", va_arg(args, char *)); break;
        case 'K':   print_token(stderr, va_arg(args, struct token *)); break;

        case 'L':   {
                        struct symbol *sym = va_arg(args, struct symbol *);

                        if (BUILTIN_SYMBOL(sym)) {
                            fputs("(built-in)", stderr);
                            break;
                        }

                        fprintf(stderr, "(%s ",
                                        DEFINED_SYMBOL(sym) ? "defined"
                                                            : "first seen");

                        if (sym->path != path)
                            fprintf(stderr, "in `" STRING_FMT "' ",
                                        STRING_ARG(sym->path));

                        fprintf(stderr, "at line %d)", sym->line_no);
                        break;
                    }

        case 'S':   {
                        struct string *s = va_arg(args, struct string *);

                        fprintf(stderr, STRING_FMT, STRING_ARG(s));
                        break;
                    }

        case 'T':   {
                        struct symbol *sym = va_arg(args, struct symbol *);

                        switch (S_BASE(sym->s))
                        {
                        case S_STRUCT:  fputs("struct", stderr); break;
                        case S_UNION:   fputs("union", stderr); break;
                        case S_ENUM:    fputs("enum", stderr); break;
                        }

                        if (sym->id) fprintf(stderr, " `" STRING_FMT "'",
                                                     STRING_ARG(sym->id));

                        break;
                    }

        case '%':   putc('%', stderr);
        }

        ++fmt;
    }

    if (level == SYSTEM) fprintf(stderr, " (%s)", strerror(errno));
    putc('\n', stderr);
    va_end(args);

    if (level > WARNING) {
        if (out_f) {
            fclose(out_f);
            unlink(out_path);
        }

        exit(1);
    }
}

int main(int argc, char **argv)
{
    int opt;

    while ((opt = getopt(argc, argv, "gkw")) != -1) {
        switch (opt)
        {
        case 'w':   w_flag = 1; break;
        case '?':   goto usage;
        }
    }

    argc -= optind;
    argv += optind;
    if (argc != 2) goto usage;
    out_path = argv[1];

    if ((out_f = fopen(out_path, "w")) == 0)
        error(SYSTEM, 0, "can't open output `%s'", out_path);

    init_arenas();          /* order is important! */
    seed_types();
    enter_scope(0);
    seed_keywords();
    init_lex(argv[0]);
    externals();
    out_literals();
    walk_scope(FILE_SCOPE, S_TENTATIVE, tentative);
    out_globls();

    fclose(out_f);
    return 0;

usage:
    fprintf(stderr, "usage: cc1 [ -w ] input output\n");
    return -1;
}

/* vi: set ts=4 expandtab: */
