/*****************************************************************************

   wildmat.c                                           minix tape archiver

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from John Gilmore's public domain tar (USENET, Nov 1987)

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

#include "tar.h"

static int
star(char *s, char *p)
{
    while (wildmat(s, p) == 0)
        if (*++s == '\0')
            return 0;

    return 1;
}

int
wildmat(char *s, char *p)
{
    int last;
    int matched;
    int reverse;

    for (; *p; s++, p++)
        switch (*p) {
        case '\\':      /* literal match with following
                           character; fall through. */

                        p++;

        default:        if (*s != *p)
                            return 0;

                        break;

        case '?':       /* match anything */

                        if (*s == '\0')
                            return 0;

                        break;

        case '*':       /* trailing star matches everything */

                        return (*++p ? star(s, p) : 1);

        case '[':       /* character classes.  [^.....]
                           means inverse character class. */

                        if (reverse = p[1] == '^')
                            p++;

                        for (last = 0400, matched = 0;
                             *++p && *p != ']'; last = *p)
                        {
                            /* this next line requires a good compiler */
                            if (*p == '-' ? *s <= *++p && *s >= last
                                          : *s == *p)
                                matched = 1;

                            if (matched == reverse)
                                return 0;
                        }
    }

    return (*s == '\0' || *s == '/');
}

/* vi: set ts=4 expandtab: */
