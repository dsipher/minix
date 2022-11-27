/*****************************************************************************

   error.c                                                     minix shell

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
 * Errors and exceptions.
 */

#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/types.h>

#include "shell.h"
#include "main.h"
#include "options.h"
#include "output.h"
#include "error.h"


/*
 * Code to handle exceptions in C.
 */

struct jmploc *handler;
int exception;
volatile int suppressint;
volatile int intpending;
char *commandname;


/*
 * Called to raise an exception.  Since C doesn't include exceptions, we
 * just do a longjmp to the exception handler.  The type of exception is
 * stored in the global variable "exception".
 */

void
exraise(e) {
    if (handler == NULL)
        abort();
    exception = e;
    longjmp(handler->loc, 1);
}


/*
 * Called from trap.c when a SIGINT is received.  (If the user specifies
 * that SIGINT is to be trapped or ignored using the trap builtin, then
 * this routine is not called.)  Suppressint is nonzero when interrupts
 * are held using the INTOFF macro.  The call to _exit is necessary because
 * there is a short period after a fork before the signal handlers are
 * set to the appropriate value for the child.  (The test for iflag is
 * just defensive programming.)
 */

void
onint() {
    if (suppressint) {
        intpending++;
        return;
    }
    intpending = 0;
    if (rootshell && iflag)
        exraise(EXINT);
    else
        _exit(128 + SIGINT);
}



void
error2(a, b)
    char *a, *b;
    {
    error("%s: %s", a, b);
}


/*
 * Error is called to raise the error exception.  If the first argument
 * is not NULL then error prints an error message using printf style
 * formatting.  It then raises the error exception.
 */

void
error(char *msg, ...) {
    va_list ap;

    CLEAR_PENDING_INT;
    INTOFF;
    va_start(ap, msg);

    if (msg) {
        if (commandname)
            outfmt(&errout, "%s: ", commandname);
        doformat(&errout, msg, ap);
        out2c('\n');
    }
    va_end(ap);
    flushall();
    exraise(EXERROR);
}

/* vi: set ts=4 expandtab: */
