/*****************************************************************************

   init.c                                                      minix shell

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

#include <sys/types.h>
#include "shell.h"
#include "mystring.h"
#include "eval.h"
#include "input.h"
#include "error.h"
#include "options.h"
#include "redir.h"
#include "signames.h"
#include "trap.h"
#include "output.h"
#include "memalloc.h"
#include "var.h"

#define S_DFL 1         /* default signal handling (SIG_DFL) */
#define S_CATCH 2       /* signal is caught */
#define S_IGN 3         /* signal is ignored (SIG_IGN) */
#define S_HARD_IGN 4        /* signal is ignored permenantly */

extern int evalskip;        /* set if we are skipping commands */
extern int loopnest;        /* current loop nesting level */

extern void deletefuncs();

struct parsefile {
    int linno;      /* current line */
    int fd;         /* file descriptor (or -1 if string) */
    int nleft;      /* number of chars left in buffer */
    char *nextc;        /* next char in buffer */
    struct parsefile *prev; /* preceding file on stack */
    char *buf;      /* input buffer */
};

extern int parsenleft;      /* copy of parsefile->nleft */
extern struct parsefile basepf; /* top level input file */

extern pid_t backgndpid;   /* pid of last background process */

extern int tokpushback;     /* last token pushed back */

struct redirtab {
    struct redirtab *next;
    short renamed[10];
};

extern struct redirtab *redirlist;

extern char sigmode[MAXSIG];    /* current value of signal */

extern void shprocvar();



/*
 * Initialization code.
 */

void
init() {

      /* from input.c: */
      {
      extern char basebuf[];

      basepf.nextc = basepf.buf = basebuf;
      }

      /* from var.c: */
      {
      char **envp;
      extern char **environ;

      initvar();
      for (envp = environ ; *envp ; envp++) {
          if (strchr(*envp, '=')) {
          setvareq(*envp, VEXPORT|VTEXTFIXED);
          }
      }
      }
}



/*
 * This routine is called when an error or an interrupt occurs in an
 * interactive shell and control is returned to the main command loop.
 */

void
reset() {

      /* from eval.c: */
      {
      evalskip = 0;
      loopnest = 0;
      funcnest = 0;
      }

      /* from input.c: */
      {
      if (exception != EXSHELLPROC)
          parsenleft = 0;            /* clear input buffer */
      popallfiles();
      }

      /* from parser.c: */
      {
      tokpushback = 0;
      }

      /* from redir.c: */
      {
      while (redirlist)
          popredir();
      }

      /* from output.c: */
      {
      out1 = &output;
      out2 = &errout;
      if (memout.buf != NULL) {
          ckfree(memout.buf);
          memout.buf = NULL;
      }
      }
}



/*
 * This routine is called to initialize the shell to run a shell procedure.
 */

void
initshellproc() {

      /* from eval.c: */
      {
      exitstatus = 0;
      }

      /* from exec.c: */
      {
      deletefuncs();
      }

      /* from input.c: */
      {
      popallfiles();
      }

      /* from jobs.c: */
      {
      backgndpid = -1;
      }

      /* from options.c: */
      {
      char *p;

      for (p = optval ; p < optval + sizeof optval ; p++)
          *p = 0;
      }

      /* from redir.c: */
      {
      clearredir();
      }

      /* from trap.c: */
      {
      char *sm;

      clear_traps();
      for (sm = sigmode ; sm < sigmode + MAXSIG ; sm++) {
          if (*sm == S_IGN)
          *sm = S_HARD_IGN;
      }
      }

      /* from var.c: */
      {
      shprocvar();
      }
}

/* vi: set ts=4 expandtab: */
