/*****************************************************************************

   jobs.h                                                      ux/64 shell

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

/* Mode argument to forkshell.  Don't change FORK_FG or FORK_BG. */
#define FORK_FG 0
#define FORK_BG 1
#define FORK_NOJOB 2


/*
 * A job structure contains information about a job.  A job is either a
 * single process or a set of processes contained in a pipeline.  In the
 * latter case, pidlist will be non-NULL, and will point to a -1 terminated
 * array of pids.
 */

struct procstat {
    short pid;      /* process id */
    short status;       /* status flags (defined above) */
    char *cmd;      /* text of command being run */
};


/* states */
#define JOBSTOPPED 1        /* all procs are stopped */
#define JOBDONE 2       /* all procs are completed */


struct job {
    struct procstat ps0;    /* status of process */
    struct procstat *ps;    /* status or processes when more than one */
    short nprocs;       /* number of processes */
    short pgrp;     /* process group of this job */
    char state;     /* true if job is finished */
    char used;      /* true if this entry is in used */
    char changed;       /* true if status has changed */
};

extern short backgndpid;    /* pid of last background process */


#ifdef __STDC__
void setjobctl(int);
void showjobs(int);
struct job *makejob(union node *, int);
int forkshell(struct job *, union node *, int);
int waitforjob(struct job *);
#else
void setjobctl();
void showjobs();
struct job *makejob();
int forkshell();
int waitforjob();
#endif

#define setjobctl(on)   /* do nothing */

/* vi: set ts=4 expandtab: */
