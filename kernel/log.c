/*****************************************************************************

   log.c                                                      ux/64 kernel

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

#include <stdarg.h>
#include <sys/cons.h>
#include <sys/log.h>

void (*putchar)(int) = cnputchar;

static void
printu(unsigned long n, int base)
{
    static char digits[] = "0123456789ABCDEF";
    char buf[22]; /* 2^64 is 22 octal digits */
    char *cp = buf;

    do {
        *cp++ = digits[n % base];
        n /= base;
    } while (n);

    while (cp > buf) putchar(*--cp);
}

static void
printn(long n)
{
    if (n < 0) {
        putchar('-');
        n = -n;
    }

    printu(n, 10);
}

void
printf(char *fmt, ...)
{
    va_list args;

    va_start(args, fmt);

    while (*fmt) {
        if (*fmt != '%') {
            /* since we don't filter through the tty
               driver, do the caller a solid and add
               carriage returns before linefeeds */

            if (*fmt == '\n') putchar('\r');
            putchar(*fmt);
        } else {
            switch (*++fmt)
            {
            case 'c':   putchar(va_arg(args, int)); break;

            case 's':   {
                            char *s = va_arg(args, char *);
                            while (*s) putchar(*s++);
                            break;
                        }

            case 'd':   printn(va_arg(args, int)); break;
            case 'u':   printu(va_arg(args, unsigned), 10); break;
            case 'o':   printu(va_arg(args, unsigned), 8); break;
            case 'x':   printu(va_arg(args, unsigned), 16); break;

            case 'D':   printn(va_arg(args, long)); break;
            case 'U':   printu(va_arg(args, long), 10); break;
            case 'O':   printu(va_arg(args, long), 8); break;
            case 'X':   printu(va_arg(args, long), 16); break;

            default:    putchar(*fmt);      /* %, or goofed specifier */
            }
        }

        ++fmt;
    }

    va_end(args);
}

/* obviously a placeholder. at a minimum we'll need
   to grab the scheduler lock to halt other CPUs. */

void
panic(char *where)  /* XXX */
{
    printf("panic: %s\n", where);
    for (;;) ;
}

/* vi: set ts=4 expandtab: */
