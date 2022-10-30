/*****************************************************************************

   exec.h                                                      ux/64 shell

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

/* values of cmdtype */
#define CMDUNKNOWN -1       /* no entry in table for command */
#define CMDNORMAL 0     /* command is an executable program */
#define CMDBUILTIN 1        /* command is a shell builtin */
#define CMDFUNCTION 2       /* command is a shell function */


struct cmdentry {
    int cmdtype;
    union param {
        int index;
        union node *func;
    } u;
};


extern char *pathopt;       /* set by padvance */

#ifdef __STDC__
void shellexec(char **, char **, char *, int);
char *padvance(char **, char *);
void find_command(char *, struct cmdentry *, int);
int find_builtin(char *);
void hashcd(void);
void changepath(char *);
void defun(char *, union node *);
void unsetfunc(char *);
#else
void shellexec();
char *padvance();
void find_command();
int find_builtin();
void hashcd();
void changepath();
void defun();
void unsetfunc();
#endif

/* vi: set ts=4 expandtab: */
