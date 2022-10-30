/*****************************************************************************

   mail.c                                                      ux/64 shell

******************************************************************************

   derived from ash, contributed to Berkeley by Kenneth Almquist.
   Copyright (c) 1991 The Regents of the University of California.

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

/*
 * Routines to check for mail.  (Perhaps make part of main.c?)
 */

#include "shell.h"
#include "exec.h"   /* defines padvance() */
#include "var.h"
#include "output.h"
#include "memalloc.h"
#include "error.h"
#include <sys/types.h>
#include <sys/stat.h>


#define MAXMBOXES 10


STATIC int nmboxes;         /* number of mailboxes */
STATIC time_t mailtime[MAXMBOXES];  /* times of mailboxes */



/*
 * Print appropriate message(s) if mail has arrived.  If the argument is
 * nozero, then the value of MAIL has changed, so we just update the
 * values.
 */

void
chkmail(silent) {
    register int i;
    char *mpath;
    char *p;
    register char *q;
    struct stackmark smark;
    struct stat statb;

    if (silent)
        nmboxes = 10;
    if (nmboxes == 0)
        return;
    setstackmark(&smark);
    mpath = mpathset()? mpathval() : mailval();
    for (i = 0 ; i < nmboxes ; i++) {
        p = padvance(&mpath, nullstr);
        if (p == NULL)
            break;
        if (*p == '\0')
            continue;
        for (q = p ; *q ; q++);
        if (q[-1] != '/')
            abort();
        q[-1] = '\0';           /* delete trailing '/' */
        if (stat(p, &statb) < 0)
            statb.st_mtime = 0;
        if (!silent
            && statb.st_size > 0
            && statb.st_mtime > mailtime[i]
            && statb.st_mtime > statb.st_atime
        ) {
            out2str(pathopt? pathopt : "You have mail");
            out2c('\n');
        }
        mailtime[i] = statb.st_mtime;
    }
    nmboxes = i;
    popstackmark(&smark);
}

/* vi: set ts=4 expandtab: */
