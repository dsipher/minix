/*****************************************************************************

   eval.h                                                      ux/64 shell

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

#ifndef EVAL_H
#define EVAL_H

union node; /* nodes.h */

extern char             *commandname;       /* currently executing command */
extern int              exitstatus;         /* exit status of last command */
extern struct strlist   *cmdenviron;    /* environment for builtin command */

/* result of evalbackcmd */

struct backcmd
{
    int         fd;             /* file descriptor to read from */
    char        *buf;           /* buffer */
    int         nleft;          /* number of chars in buffer */
    struct job  *jp;            /* job structure for command */
};

extern void evalstring  (char *);
extern void evaltree    (union node *, int);
extern void evalbackcmd (union node *, struct backcmd *);
extern int  evalcmd     (int argc, char **argv);
extern int  bltincmd    (int argc, char **argv);
extern int  breakcmd    (int argc, char **argv);
extern int  returncmd   (int argc, char **argv);
extern int  truecmd     (int argc, char **argv);
extern int  execcmd     (int argc, char **argv);

/* in_function returns nonzero if we are
   currently evaluating a function */

extern int funcnest;

#define in_function()   funcnest

#endif /* EVAL_H */

/* vi: set ts=4 expandtab: */
