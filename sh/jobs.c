/*****************************************************************************

   jobs.c                                                      ux/64 shell

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

#include "shell.h"
#include "main.h"
#include "parser.h"
#include "nodes.h"
#include "jobs.h"
#include "options.h"
#include "trap.h"
#include "signames.h"
#include "syntax.h"
#include "input.h"
#include "output.h"
#include "memalloc.h"
#include "error.h"
#include "mystring.h"
#include "redir.h"
#include <sys/types.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>
#include <sys/wait.h>



struct job *jobtab;     /* array of jobs */
int njobs;          /* size of array */
MKINIT short backgndpid = -1;   /* pid of last background process */

STATIC void restartjob(struct job *);
STATIC struct job *getjob(char *);
STATIC void freejob(struct job *);
STATIC int procrunning(int);
STATIC int dowait(int, struct job *);
STATIC int waitproc(int, int *);
STATIC char *commandtext(union node *);



int
jobscmd(argc, argv)  char **argv; {
    showjobs(0);
    return 0;
}


/*
 * Print a list of jobs.  If "change" is nonzero, only print jobs whose
 * statuses have changed since the last call to showjobs.
 *
 * If the shell is interrupted in the process of creating a job, the
 * result may be a job structure containing zero processes.  Such structures
 * will be freed here.
 */

void
showjobs(change) {
    int jobno;
    int procno;
    int i;
    struct job *jp;
    struct procstat *ps;
    int col;
    char s[64];

    while (dowait(0, (struct job *)NULL) > 0);
    for (jobno = 1, jp = jobtab ; jobno <= njobs ; jobno++, jp++) {
        if (! jp->used)
            continue;
        if (jp->nprocs == 0) {
            freejob(jp);
            continue;
        }
        if (change && ! jp->changed)
            continue;
        procno = jp->nprocs;
        for (ps = jp->ps ; ; ps++) {    /* for each process */
            if (ps == jp->ps)
                fmtstr(s, 64, "[%d] %d ", jobno, ps->pid);
            else
                fmtstr(s, 64, "    %d ", ps->pid);
            out1str(s);
            col = strlen(s);
            s[0] = '\0';
            if (ps->status == -1) {
                /* don't print anything */
            } else if ((ps->status & 0xFF) == 0) {
                fmtstr(s, 64, "Exit %d", ps->status >> 8);
            } else {
                i = ps->status;
                if ((i & 0x7F) <= MAXSIG && sigmesg[i & 0x7F])
                    scopy(sigmesg[i & 0x7F], s);
                else
                    fmtstr(s, 64, "Signal %d", i & 0x7F);
                if (i & 0x80)
                    strcat(s, " (core dumped)");
            }
            out1str(s);
            col += strlen(s);
            do {
                out1c(' ');
                col++;
            } while (col < 30);
            out1str(ps->cmd);
            out1c('\n');
            if (--procno <= 0)
                break;
        }
        jp->changed = 0;
        if (jp->state == JOBDONE) {
            freejob(jp);
        }
    }
}


/*
 * Mark a job structure as unused.
 */

STATIC void
freejob(jp)
    struct job *jp;
    {
    struct procstat *ps;
    int i;

    INTOFF;
    for (i = jp->nprocs, ps = jp->ps ; --i >= 0 ; ps++) {
        if (ps->cmd != nullstr)
            ckfree(ps->cmd);
    }
    if (jp->ps != &jp->ps0)
        ckfree(jp->ps);
    jp->used = 0;
    INTON;
}



int
waitcmd(argc, argv)  char **argv; {
    struct job *job;
    int status;
    struct job *jp;

    if (argc > 1) {
        job = getjob(argv[1]);
    } else {
        job = NULL;
    }
    for (;;) {  /* loop until process terminated or stopped */
        if (job != NULL) {
            if (job->state) {
                status = job->ps[job->nprocs - 1].status;
                if ((status & 0xFF) == 0)
                    status = status >> 8 & 0xFF;
                else
                    status = (status & 0x7F) + 128;
                if (! iflag)
                    freejob(job);
                return status;
            }
        } else {
            for (jp = jobtab ; ; jp++) {
                if (jp >= jobtab + njobs) { /* no running procs */
                    return 0;
                }
                if (jp->used && jp->state == 0)
                    break;
            }
        }
        dowait(1, (struct job *)NULL);
    }
}



jobidcmd(argc, argv)  char **argv; {
    struct job *jp;
    int i;

    jp = getjob(argv[1]);
    for (i = 0 ; i < jp->nprocs ; ) {
        out1fmt("%d", jp->ps[i].pid);
        out1c(++i < jp->nprocs? ' ' : '\n');
    }
    return 0;
}



/*
 * Convert a job name to a job structure.
 */

STATIC struct job *
getjob(name)
    char *name;
    {
    int jobno;
    register struct job *jp;
    int pid;
    int i;

    if (name == NULL) {
        error("No current job");
    } else if (name[0] == '%') {
        if (is_digit(name[1])) {
            jobno = number(name + 1);
            if (jobno > 0 && jobno <= njobs
             && jobtab[jobno - 1].used != 0)
                return &jobtab[jobno - 1];
        } else {
            register struct job *found = NULL;
            for (jp = jobtab, i = njobs ; --i >= 0 ; jp++) {
                if (jp->used && jp->nprocs > 0
                 && prefix(name + 1, jp->ps[0].cmd)) {
                    if (found)
                        error("%s: ambiguous", name);
                    found = jp;
                }
            }
            if (found)
                return found;
        }
    } else if (is_number(name)) {
        pid = number(name);
        for (jp = jobtab, i = njobs ; --i >= 0 ; jp++) {
            if (jp->used && jp->nprocs > 0
             && jp->ps[jp->nprocs - 1].pid == pid)
                return jp;
        }
    }
    error("No such job: %s", name);
}



/*
 * Return a new job structure,
 */

struct job *
makejob(node, nprocs)
    union node *node;
    {
    int i;
    struct job *jp;

    for (i = njobs, jp = jobtab ; ; jp++) {
        if (--i < 0) {
            INTOFF;
            if (njobs == 0) {
                jobtab = ckmalloc(4 * sizeof jobtab[0]);
            } else {
                jp = ckmalloc((njobs + 4) * sizeof jobtab[0]);
                bcopy(jobtab, jp, njobs * sizeof jp[0]);
                for (i= 0; i<njobs; i++)
                {
                    if (jobtab[i].ps == &jobtab[i].ps0)
                        jp[i].ps= &jp[i].ps0;
                }
                ckfree(jobtab);
                jobtab = jp;
            }
            jp = jobtab + njobs;
            for (i = 4 ; --i >= 0 ; jobtab[njobs++].used = 0);
            INTON;
            break;
        }
        if (jp->used == 0)
            break;
    }
    INTOFF;
    jp->state = 0;
    jp->used = 1;
    jp->changed = 0;
    jp->nprocs = 0;
    if (nprocs > 1) {
        jp->ps = ckmalloc(nprocs * sizeof (struct procstat));
    } else {
        jp->ps = &jp->ps0;
    }
    INTON;
    return jp;
}


/*
 * Fork of a subshell.  If we are doing job control, give the subshell its
 * own process group.  Jp is a job structure that the job is to be added to.
 * N is the command that will be evaluated by the child.  Both jp and n may
 * be NULL.  The mode parameter can be one of the following:
 *  FORK_FG - Fork off a foreground process.
 *  FORK_BG - Fork off a background process.
 *  FORK_NOJOB - Like FORK_FG, but don't give the process its own
 *           process group even if job control is on.
 *
 * When job control is turned off, background processes have their standard
 * input redirected to /dev/null (except for the second and later processes
 * in a pipeline).
 */

int
forkshell(jp, n, mode)
    union node *n;
    struct job *jp;
    {
    int pid;
    int pgrp;

    INTOFF;
    pid = fork();
    if (pid == -1) {
        INTON;
        error("Cannot fork");
    }
    if (pid == 0) {
        struct job *p;
        int wasroot;
        int i;

        wasroot = rootshell;
        rootshell = 0;
        for (i = njobs, p = jobtab ; --i >= 0 ; p++)
            if (p->used)
                freejob(p);
        closescript();
        INTON;
        clear_traps();
        if (mode == FORK_BG) {
            ignoresig(SIGINT);
            ignoresig(SIGQUIT);
            if ((jp == NULL || jp->nprocs == 0)
                && ! fd0_redirected_p ()) {
                close(0);
                if (open("/dev/null", O_RDONLY) != 0)
                    error("Can't open /dev/null");
            }
        }
        if (wasroot && iflag) {
            setsignal(SIGINT);
            setsignal(SIGQUIT);
            setsignal(SIGTERM);
        }
        return pid;
    }
    if (rootshell && mode != FORK_NOJOB && jflag) {
        if (jp == NULL || jp->nprocs == 0)
            pgrp = pid;
        else
            pgrp = jp->ps[0].pid;
    }
    if (mode == FORK_BG)
        backgndpid = pid;       /* set $! */
    if (jp) {
        struct procstat *ps = &jp->ps[jp->nprocs++];
        ps->pid = pid;
        ps->status = -1;
        ps->cmd = nullstr;
        if (iflag && rootshell && n)
            ps->cmd = commandtext(n);
    }
    INTON;
    return pid;
}



/*
 * Wait for job to finish.
 *
 * Under job control we have the problem that while a child process is
 * running interrupts generated by the user are sent to the child but not
 * to the shell.  This means that an infinite loop started by an inter-
 * active user may be hard to kill.  With job control turned off, an
 * interactive user may place an interactive program inside a loop.  If
 * the interactive program catches interrupts, the user doesn't want
 * these interrupts to also abort the loop.  The approach we take here
 * is to have the shell ignore interrupt signals while waiting for a
 * forground process to terminate, and then send itself an interrupt
 * signal if the child process was terminated by an interrupt signal.
 * Unfortunately, some programs want to do a bit of cleanup and then
 * exit on interrupt; unless these processes terminate themselves by
 * sending a signal to themselves (instead of calling exit) they will
 * confuse this approach.
 */

int
waitforjob(jp)
    register struct job *jp;
    {
    int status;
    int st;

    INTOFF;
    while (jp->state == 0 && dowait(1, jp) != -1) ;
    status = jp->ps[jp->nprocs - 1].status;
    /* convert to 8 bits */
    if ((status & 0xFF) == 0)
        st = status >> 8 & 0xFF;
    else
        st = (status & 0x7F) + 128;
    if (!0 || jp->state == JOBDONE)     /* XXX */
        freejob(jp);
    CLEAR_PENDING_INT;
    if ((status & 0x7F) == SIGINT)
        kill(getpid(), SIGINT);
    INTON;
    return st;
}



/*
 * Wait for a process to terminate.
 */

STATIC int
dowait(block, job)
    struct job *job;
    {
    int pid;
    int status;
    struct procstat *sp;
    struct job *jp;
    struct job *thisjob;
    int done;
    int stopped;
    int core;

    do {
        pid = waitproc(block, &status);
    } while (pid == -1 && errno == EINTR);
    if (pid <= 0)
        return pid;
    INTOFF;
    thisjob = NULL;
    for (jp = jobtab ; jp < jobtab + njobs ; jp++) {
        if (jp->used) {
            done = 1;
            stopped = 1;
            for (sp = jp->ps ; sp < jp->ps + jp->nprocs ; sp++) {
                if (sp->pid == -1)
                    continue;
                if (sp->pid == pid) {
                    sp->status = status;
                    thisjob = jp;
                }
                if (sp->status == -1)
                    stopped = 0;
                else if ((sp->status & 0377) == 0177)
                    done = 0;
            }
            if (stopped) {      /* stopped or done */
                int state = done? JOBDONE : JOBSTOPPED;
                if (jp->state != state) {
                    jp->state = state;
                }
            }
        }
    }
    INTON;
    if (! rootshell || ! iflag || (job && thisjob == job)) {
        core = status & 0x80;
        status &= 0x7F;
        if (status != 0 && status != SIGINT && status != SIGPIPE) {
            if (thisjob != job)
                outfmt(out2, "%d: ", pid);
            if (status <= MAXSIG && sigmesg[status])
                out2str(sigmesg[status]);
            else
                outfmt(out2, "Signal %d", status);
            if (core)
                out2str(" - core dumped");
            out2c('\n');
            flushout(&errout);
        } else {
        }
    } else {
        if (thisjob)
            thisjob->changed = 1;
    }
    return pid;
}



/*
 * Do a wait system call. If block is zero, we
 * return a value of zero rather than blocking.
 */

STATIC int
waitproc(block, status)
    int *status;
    {
    return waitpid(-1, status, block == 0 ? WNOHANG : 0);
}



/*
 * Return a string identifying a command (to be printed by the
 * jobs command.
 */

STATIC char *cmdnextc;
STATIC int cmdnleft;
STATIC void cmdtxt(), cmdputs();

STATIC char *
commandtext(n)
    union node *n;
    {
    char *name;

    cmdnextc = name = ckmalloc(50);
    cmdnleft = 50 - 4;
    cmdtxt(n);
    *cmdnextc = '\0';
    return name;
}


STATIC void
cmdtxt(n)
    union node *n;
    {
    union node *np;
    struct nodelist *lp;
    char *p;
    int i;
    char s[2];

    if (n == NULL) return;

    switch (n->type) {
    case NSEMI:
        cmdtxt(n->nbinary.ch1);
        cmdputs("; ");
        cmdtxt(n->nbinary.ch2);
        break;
    case NAND:
        cmdtxt(n->nbinary.ch1);
        cmdputs(" && ");
        cmdtxt(n->nbinary.ch2);
        break;
    case NOR:
        cmdtxt(n->nbinary.ch1);
        cmdputs(" || ");
        cmdtxt(n->nbinary.ch2);
        break;
    case NPIPE:
        for (lp = n->npipe.cmdlist ; lp ; lp = lp->next) {
            cmdtxt(lp->n);
            if (lp->next)
                cmdputs(" | ");
        }
        break;
    case NSUBSHELL:
        cmdputs("(");
        cmdtxt(n->nredir.n);
        cmdputs(")");
        break;
    case NREDIR:
    case NBACKGND:
        cmdtxt(n->nredir.n);
        break;
    case NIF:
        cmdputs("if ");
        cmdtxt(n->nif.test);
        cmdputs("; then ");
        cmdtxt(n->nif.ifpart);
        cmdputs("...");
        break;
    case NWHILE:
        cmdputs("while ");
        goto until;
    case NUNTIL:
        cmdputs("until ");
until:
        cmdtxt(n->nbinary.ch1);
        cmdputs("; do ");
        cmdtxt(n->nbinary.ch2);
        cmdputs("; done");
        break;
    case NFOR:
        cmdputs("for ");
        cmdputs(n->nfor.var);
        cmdputs(" in ...");
        break;
    case NCASE:
        cmdputs("case ");
        cmdputs(n->ncase.expr->narg.text);
        cmdputs(" in ...");
        break;
    case NDEFUN:
        cmdputs(n->narg.text);
        cmdputs("() ...");
        break;
    case NCMD:
        for (np = n->ncmd.args ; np ; np = np->narg.next) {
            cmdtxt(np);
            if (np->narg.next)
                cmdputs(" ");
        }
        for (np = n->ncmd.redirect ; np ; np = np->nfile.next) {
            cmdputs(" ");
            cmdtxt(np);
        }
        break;
    case NARG:
        cmdputs(n->narg.text);
        break;
    case NTO:
        p = ">";  i = 1;  goto redir;
    case NAPPEND:
        p = ">>";  i = 1;  goto redir;
    case NTOFD:
        p = ">&";  i = 1;  goto redir;
    case NFROM:
        p = "<";  i = 0;  goto redir;
    case NFROMFD:
        p = "<&";  i = 0;  goto redir;
redir:
        if (n->nfile.fd != i) {
            s[0] = n->nfile.fd + '0';
            s[1] = '\0';
            cmdputs(s);
        }
        cmdputs(p);
        if (n->type == NTOFD || n->type == NFROMFD) {
            s[0] = n->ndup.dupfd + '0';
            s[1] = '\0';
            cmdputs(s);
        } else {
            cmdtxt(n->nfile.fname);
        }
        break;
    case NHERE:
    case NXHERE:
        cmdputs("<<...");
        break;
    default:
        cmdputs("???");
        break;
    }
}



STATIC void
cmdputs(s)
    char *s;
    {
    register char *p, *q;
    register char c;
    int subtype = 0;

    if (cmdnleft <= 0)
        return;
    p = s;
    q = cmdnextc;
    while ((c = *p++) != '\0') {
        if (c == CTLESC)
            *q++ = *p++;
        else if (c == CTLVAR) {
            *q++ = '$';
            if (--cmdnleft > 0)
                *q++ = '{';
            subtype = *p++;
        } else if (c == '=' && subtype != 0) {
            *q++ = "}-+?="[(subtype & VSTYPE) - VSNORMAL];
            subtype = 0;
        } else if (c == CTLENDVAR) {
            *q++ = '}';
        } else if (c == CTLBACKQ | c == CTLBACKQ+CTLQUOTE)
            cmdnleft++;     /* ignore it */
        else
            *q++ = c;
        if (--cmdnleft <= 0) {
            *q++ = '.';
            *q++ = '.';
            *q++ = '.';
            break;
        }
    }
    cmdnextc = q;
}

/* vi: set ts=4 expandtab: */
