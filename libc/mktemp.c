/*****************************************************************************

   mktemp.c                                         minix standard library

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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

#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

/* produce a unique filename by replacing the trailing 6 X's on the user's
   input string with a set of characters to based on the current process ID
   and a sequential counter, which are both encoded using a form of base 62.
   this function suffers from a well-known race condition which has security
   implications; the problem is rooted in interface, not implementation, so
   it can't be addressed here. (that's fine because we don't really care.)

   n.b. we implement the ANSI function tmpnam() by wrapping mktemp(), thus
   TMP_MAX (in stdio.h) is somewhat dependent on BASE. keep them in sync. */

#define NR_XS       6       /* number of Xs expected in template */
#define BASE        62      /* the base of the encoded numbers */

char *mktemp(char *template)
{
    static const char encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"   /* 26 + */
                                 "abcdefghijklmnopqrstuvwxyz"   /* 26 + */
                                 "1234567890";                  /* 10 = 62 */

    /* we remember the last sequence number used. this is a simple way
       to limit the number of access() calls made when a process makes
       several temp files from the same template, a common occurrence */

    static const char *next = encode;

    char *p;
    int i, pid;

    pid = getpid();

    for (p = template; *p; ++p) ;           /* NUL terminator -> p */

    if ((p - template) < NR_XS)             /* too short? don't go */
        goto einval;                        /* writing into random memory */

    for (i = 0; i < NR_XS; ++i)             /* check for trailing Xs. not */
        if (*--p != 'X') goto einval;       /* required by POSIX, but ... */

    for (i = 0; i < (NR_XS - 1); ++i) {     /* replace first Xs with pid, */
        *p++ = encode[pid % BASE];          /* base-62 encoded (backwards) */
        pid /= BASE;
    }

    for (i = 0; i < BASE; ++i) {
        *p = *next++;
        if (*next == 0) next = encode;

        /* we assume an error means "does not exist", though it
           could be any number of other things. the onus is on
           the caller to check the return code of the subsequent
           attempt to open the file (as it should be, of course) */

        if (access(template, F_OK) < 0) goto success;
    }

    /* can't find an unused name. POSIX
       does not specify an errno here. */

    goto toomany;

einval:
    errno = EINVAL;
toomany:
    *template = 0;
success:
    return template;
}

/* vi: set ts=4 expandtab: */
