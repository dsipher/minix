/*****************************************************************************

   main.c                                                      minix shell

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
#include <stdlib.h>
#include <sys/types.h>
#include <fcntl.h>
#include "shell.h"
#include "main.h"
#include "mail.h"
#include "options.h"
#include "output.h"
#include "parser.h"
#include "nodes.h"
#include "eval.h"
#include "exec.h"
#include "jobs.h"
#include "input.h"
#include "trap.h"
#include "memalloc.h"
#include "error.h"
#include "init.h"
#include "mystring.h"

#define PROFILE 0

int rootpid;
int rootshell;
STATIC union node *curcmd;
STATIC union node *prevcmd;
extern int errno;
#if PROFILE
short profile_buf[16384];
extern int etext();
#endif

STATIC void read_profile(char *);


/*
 * Main routine.  We initialize things, parse the arguments, execute
 * profiles if we're a login shell, and then call cmdloop to execute
 * commands.  The setjmp call sets up the location to jump to when an
 * exception occurs.  When an exception occurs the variable "state"
 * is used to figure out how far we had gotten.
 */

main(argc, argv)  char **argv; {
    struct jmploc jmploc;
    struct stackmark smark;
    volatile int state;
    char *shinit, *home;
    char *profile = NULL, *ashrc = NULL;

#if PROFILE
    monitor(4, etext, profile_buf, sizeof profile_buf, 50);
#endif
    state = 0;
    if (setjmp(jmploc.loc)) {
        /*
         * When a shell procedure is executed, we raise the
         * exception EXSHELLPROC to clean up before executing
         * the shell procedure.
         */
        if (exception == EXSHELLPROC) {
            rootpid = getpid();
            rootshell = 1;
            minusc = NULL;
            state = 3;
        } else if (state == 0 || iflag == 0 || ! rootshell)
            exitshell(2);
        reset();
        if (exception == EXINT) {
            out2c('\n');
            flushout(&errout);
        }
        popstackmark(&smark);
        FORCEINTON;             /* enable interrupts */
        if (state == 1)
            goto state1;
        else if (state == 2)
            goto state2;
        else if (state == 3)
            goto state3;
        else
            goto state4;
    }
    handler = &jmploc;
    rootpid = getpid();
    rootshell = 1;
    init();
    setstackmark(&smark);
    procargs(argc, argv);
    if (eflag) eflag = 2;   /* Truly enable [ex]flag after init. */
    if (xflag) xflag = 2;
    if (argv[0] && argv[0][0] == '-') {
        state = 1;
        read_profile("/etc/profile");
state1:
        state = 2;
        if ((home = getenv("HOME")) != NULL
            && (profile = (char *) malloc(strlen(home) + 10)) != NULL)
        {
            strcpy(profile, home);
            strcat(profile, "/.profile");
            read_profile(profile);
        } else {
            read_profile(".profile");
        }
    } else if ((sflag || minusc) && (shinit = getenv("SHINIT")) != NULL) {
        state = 2;
        evalstring(shinit);
    }
state2:
    if (profile != NULL) free(profile);

    state = 3;
    if (!argv[0] || argv[0][0] != '-') {
        if ((home = getenv("HOME")) != NULL
            && (ashrc = (char *) malloc(strlen(home) + 8)) != NULL)
        {
            strcpy(ashrc, home);
            strcat(ashrc, "/.ashrc");
            read_profile(ashrc);
        }
    }
state3:
    if (ashrc != NULL) free(ashrc);
    if (eflag) eflag = 1;   /* Init done, enable [ex]flag */
    if (xflag) xflag = 1;
    exitstatus = 0;     /* Init shouldn't influence initial $? */

    state = 4;
    if (minusc) {
        evalstring(minusc);
    }
    if (sflag || minusc == NULL) {
state4:
        cmdloop(1);
    }
#if PROFILE
    monitor(0);
#endif
    exitshell(exitstatus);
}


/*
 * Read and execute commands.  "Top" is nonzero for the top level command
 * loop; it turns on prompting if the shell is interactive.
 */

void
cmdloop(top) {
    union node *n;
    struct stackmark smark;
    int inter;
    int numeof;

    setstackmark(&smark);
    numeof = 0;
    for (;;) {
        if (pendingsigs)
            dotrap();
        inter = 0;
        if (iflag && top) {
            inter++;
            showjobs(1);
            chkmail(0);
            flushout(&output);
        }
        n = parsecmd(inter);
        if (n == NEOF) {
            if (Iflag == 0 || numeof >= 50)
                break;
            out2str("\nUse \"exit\" to leave shell.\n");
            numeof++;
        } else if (n != NULL && nflag == 0) {
            if (inter) {
                INTOFF;
                if (prevcmd)
                    freefunc(prevcmd);
                prevcmd = curcmd;
                curcmd = copyfunc(n);
                INTON;
            }
            evaltree(n, 0);
        }
        popstackmark(&smark);
    }
    popstackmark(&smark);       /* unnecessary */
}



/*
 * Read /etc/profile or .profile.  Return on error.
 */

STATIC void
read_profile(name)
    char *name;
    {
    int fd;

    INTOFF;
    if ((fd = open(name, O_RDONLY)) >= 0)
        setinputfd(fd, 1);
    INTON;
    if (fd < 0)
        return;
    cmdloop(0);
    popfile();
}



/*
 * Read a file containing shell functions.
 */

void
readcmdfile(name)
    char *name;
    {
    int fd;

    INTOFF;
    if ((fd = open(name, O_RDONLY)) >= 0)
        setinputfd(fd, 1);
    else
        error("Can't open %s", name);
    INTON;
    cmdloop(0);
    popfile();
}


/*
 * Take commands from a file.  To be compatable we should do a path
 * search for the file, but a path search doesn't make any sense.
 */

dotcmd(argc, argv)  char **argv; {
    exitstatus = 0;
    if (argc >= 2) {        /* That's what SVR2 does */
        setinputfile(argv[1], 1);
        commandname = argv[1];
        cmdloop(0);
        popfile();
    }
    return exitstatus;
}


exitcmd(argc, argv)  char **argv; {
    if (argc > 1)
        exitstatus = number(argv[1]);
    exitshell(exitstatus);
}


lccmd(argc, argv)  char **argv; {
    if (argc > 1) {
        defun(argv[1], prevcmd);
        return 0;
    } else {
        INTOFF;
        freefunc(curcmd);
        curcmd = prevcmd;
        prevcmd = NULL;
        INTON;
        evaltree(curcmd, 0);
        return exitstatus;
    }
}



/* vi: set ts=4 expandtab: */
