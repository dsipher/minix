/*****************************************************************************

   mktemp.c                                      tahoe/64 standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from COHERENT, Copyright (c) 1977-1995 by Robert Swartz.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

   3. Neither the name of the copyright holder nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

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

#include <unistd.h>

/* produce a unique filename by replacing the trailing 6 X's on the user's
   input string with process id and a unique letter. it is assumed but not
   checked that the X's are present. this function has a classic race in it,
   which is exacerbated by the fact that tahoe pids are not unique in their
   lower 5 digits. we attempt some mitigation with the access() outer loop */

char *mktemp(char *template)
{
    static char generator = 'a';

    char *p;
    int i, pid;

    pid = getpid();

    do {
        for (p = template; *p; p++)
            ;

        switch (generator)  {
        case '~':
            *--p = generator;
            generator = 'A';
            break;
        case '_':
            *--p = generator;
            generator = '!';
            break;
        case '*':
            *--p = ++generator;
            generator++;
            break;
        case '?':
            *--p = (generator = '@');
            break;
        case '@':
            generator = 'a';
            *--p = generator++;
            break;
        default:
            *--p = generator++;
        }

        for (i = 0; i < 5; ++i) {
            *--p = pid % 10 + '0';
            pid /= 10;
        }
    } while (access(template, F_OK) >= 0);

    return (template);
}

/* vi: set ts=4 expandtab: */
