/*****************************************************************************

   trap.c                                                      minix shell

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

#include <unistd.h>
#include <signal.h>
#include <sys/types.h>

#include "shell.h"
#include "main.h"
#include "nodes.h"  /* for other headers */
#include "eval.h"
#include "jobs.h"
#include "options.h"
#include "syntax.h"
#include "signames.h"
#include "output.h"
#include "memalloc.h"
#include "error.h"
#include "trap.h"
#include "mystring.h"

/*
 * Sigmode records the current value of the signal handlers for the various
 * modes.  A value of zero means that the current handler is not known.
 * S_HARD_IGN indicates that the signal was ignored on entry to the shell,
 */

#define S_DFL 1         /* default signal handling (SIG_DFL) */
#define S_CATCH 2       /* signal is caught */
#define S_IGN 3         /* signal is ignored (SIG_IGN) */
#define S_HARD_IGN 4        /* signal is ignored permenantly */


extern char nullstr[1];     /* null string */

char *trap[MAXSIG+1];       /* trap handler commands */
char sigmode[MAXSIG];    /* current value of signal */
char gotsig[MAXSIG];        /* indicates specified signal received */
int pendingsigs;            /* indicates some signal received */

/*
 * The trap builtin.
 */

trapcmd(argc, argv)  char **argv; {
    char *action;
    char **ap;
    int signo;

    if (argc <= 1) {
        for (signo = 0 ; signo <= MAXSIG ; signo++) {
            if (trap[signo] != NULL)
                out1fmt("%d: %s\n", signo, trap[signo]);
        }
        return 0;
    }
    ap = argv + 1;
    if (is_number(*ap))
        action = NULL;
    else
        action = *ap++;
    while (*ap) {
        if ((signo = number(*ap)) < 0 || signo > MAXSIG)
            error("%s: bad trap", *ap);
        INTOFF;
        if (action)
            action = savestr(action);
        if (trap[signo])
            ckfree(trap[signo]);
        trap[signo] = action;
        if (signo != 0)
            setsignal(signo);
        INTON;
        ap++;
    }
    return 0;
}



/*
 * Clear traps on a fork.
 */

void
clear_traps() {
    char **tp;

    for (tp = trap ; tp <= &trap[MAXSIG] ; tp++) {
        if (*tp && **tp) {  /* trap not NULL or SIG_IGN */
            INTOFF;
            ckfree(*tp);
            *tp = NULL;
            if (tp != &trap[0])
                setsignal(tp - trap);
            INTON;
        }
    }
}



/*
 * Set the signal handler for the specified signal.  The routine figures
 * out what it should be set to.
 */

int
setsignal(signo) {
    int action;
    void (*sigact)(int);
    char *t;
    extern void onsig();

    if ((t = trap[signo]) == NULL)
        action = S_DFL;
    else if (*t != '\0')
        action = S_CATCH;
    else
        action = S_IGN;
    if (rootshell && action == S_DFL) {
        switch (signo) {
        case SIGINT:
            if (iflag)
                action = S_CATCH;
            break;
        case SIGQUIT:
        case SIGTERM:
            if (iflag)
                action = S_IGN;
            break;
        }
    }
    t = &sigmode[signo - 1];
    if (*t == 0) {  /* current setting unknown */
        /*
         * There is a race condition here if action is not S_IGN.
         * A signal can be ignored that shouldn't be.
         */
        if ((int)(sigact = signal(signo, SIG_IGN)) == -1)
            error("Signal system call failed");
        if (sigact == SIG_IGN) {
            *t = S_HARD_IGN;
        } else {
            *t = S_IGN;
        }
    }
    if (*t == S_HARD_IGN || *t == action)
        return 0;
    switch (action) {
        case S_DFL: sigact = SIG_DFL;   break;
        case S_CATCH:   sigact = onsig;     break;
        case S_IGN: sigact = SIG_IGN;   break;
    }
    *t = action;
    return (int)signal(signo, sigact);
}


/*
 * Ignore a signal.
 */

void
ignoresig(signo) {
    if (sigmode[signo - 1] != S_IGN && sigmode[signo - 1] != S_HARD_IGN) {
        signal(signo, SIG_IGN);
    }
    sigmode[signo - 1] = S_HARD_IGN;
}


/*
 * Signal handler.
 */

void
onsig(signo) {
    signal(signo, onsig);
    if (signo == SIGINT && trap[SIGINT] == NULL) {
        onint();
        return;
    }
    gotsig[signo - 1] = 1;
    pendingsigs++;
}



/*
 * Called to execute a trap.  Perhaps we should avoid entering new trap
 * handlers while we are executing a trap handler.
 */

void
dotrap() {
    int i;
    int savestatus;

    for (;;) {
        for (i = 1 ; ; i++) {
            if (gotsig[i - 1])
                break;
            if (i >= MAXSIG)
                goto done;
        }
        gotsig[i - 1] = 0;
        savestatus=exitstatus;
        evalstring(trap[i]);
        exitstatus=savestatus;
    }
done:
    pendingsigs = 0;
}



/*
 * Controls whether the shell is interactive or not.
 */

int is_interactive;

void
setinteractive(on) {
    if (on == is_interactive)
        return;
    setsignal(SIGINT);
    setsignal(SIGQUIT);
    setsignal(SIGTERM);
    is_interactive = on;
}



/*
 * Called to exit the shell.
 */

void
exitshell(status) {
    struct jmploc loc1, loc2;
    char *p;

    if (setjmp(loc1.loc))  goto l1;
    if (setjmp(loc2.loc))  goto l2;
    handler = &loc1;
    if ((p = trap[0]) != NULL && *p != '\0') {
        trap[0] = NULL;
        evalstring(p);
    }
l1:   handler = &loc2;          /* probably unnecessary */
    flushall();
l2:   _exit(status);
}

/* vi: set ts=4 expandtab: */
