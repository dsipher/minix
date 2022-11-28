/*****************************************************************************

   putenv.c                                         minix standard library

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).
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

#include <stdlib.h>
#include <string.h>
#include <errno.h>

int putenv(char *string)
{
    register char **epp;
    register int    len;
    static char ** lastenv;
    extern char ** environ;

    if (string == NULL) {
        errno = EFAULT;
        return -1;
    }

    /* validate `string', which must
       be of form `NAME=value' */

    for (len = 0; string[len] != '='; len++) {
        if (string[len] == '\0') {
            errno = EINVAL;
            return -1;
        }
    }

    len++;  /* include the `=' */

    /* search for existing value. if
       present, replace with `string' */

    for (epp = environ; *epp != NULL; epp++) {
        if (strncmp(string, *epp, len) == 0) {
            *epp = string;
            return 0;
        }
    }

    /* must add as a new element, so
       allocate new environment array */

    len = (epp - environ + 2) * sizeof(*epp);

    if ((epp = malloc(len)) == NULL) {
        errno = ENOMEM;
        return -1;
    }

    /* copy old environment to new environment,
       append new string and new terminator. */

    for (len = 0; epp[len] = environ[len]; ++len) ;
    epp[len++] = string;
    epp[len++] = NULL;

    /* if the old environment was a product of
       a previous call to putenv(), free it. */

    if (lastenv) free(lastenv);

    /* install new environment, and remember
       that we created it for the next putenv() */

    environ = epp;
    lastenv = epp;

    return 0;
}

/* vi: set ts=4 expandtab: */
