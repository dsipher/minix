/*****************************************************************************

   builtins.c                                                  minix shell

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
#include "eval.h"
#include "builtins.h"

int cdcmd();
int dotcmd();
int exitcmd();
int exportcmd();
int getoptscmd();
int hashcmd();
int jobidcmd();
int jobscmd();
int localcmd();
int pwdcmd();
int readcmd();
int setcmd();
int setvarcmd();
int shiftcmd();
int trapcmd();
int umaskcmd();
int unsetcmd();
int waitcmd();

int (*const builtinfunc[])() = {
   bltincmd,
   breakcmd,
   cdcmd,
   dotcmd,
   evalcmd,
   execcmd,
   exitcmd,
   exportcmd,
   getoptscmd,
   hashcmd,
   jobidcmd,
   jobscmd,
   localcmd,
   pwdcmd,
   readcmd,
   returncmd,
   setcmd,
   setvarcmd,
   shiftcmd,
   trapcmd,
   truecmd,
   umaskcmd,
   unsetcmd,
   waitcmd
};

const struct builtincmd builtincmd[] = {
  "command", 0,
  "break", 1,
  "continue", 1,
  "cd", 2,
  "chdir", 2,
  ".", 3,
  "eval", 4,
  "exec", 5,
  "exit", 6,
  "export", 7,
  "readonly", 7,
  "getopts", 8,
  "hash", 9,
  "jobid", 10,
  "jobs", 11,
  "local", 12,
  "pwd", 13,
  "read", 14,
  "return", 15,
  "set", 16,
  "setvar", 17,
  "shift", 18,
  "trap", 19,
  ":", 20,
  "true", 20,
  "false", 20,
  "umask", 21,
  "unset", 22,
  "wait", 23,
  NULL, 0
};

/* vi: set ts=4 expandtab: */
