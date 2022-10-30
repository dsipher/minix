/*****************************************************************************

   builtins.h                                                  ux/64 shell

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

#define BLTINCMD 0
#define BREAKCMD 1
#define CDCMD 2
#define DOTCMD 3
#define EVALCMD 4
#define EXECCMD 5
#define EXITCMD 6
#define EXPORTCMD 7
#define GETOPTSCMD 8
#define HASHCMD 9
#define JOBIDCMD 10
#define JOBSCMD 11
#define LOCALCMD 12
#define PWDCMD 13
#define READCMD 14
#define RETURNCMD 15
#define SETCMD 16
#define SETVARCMD 17
#define SHIFTCMD 18
#define TRAPCMD 19
#define TRUECMD 20
#define UMASKCMD 21
#define UNSETCMD 22
#define WAITCMD 23

struct builtincmd {
      char *name;
      int code;
};

extern int (*const builtinfunc[])();
extern const struct builtincmd builtincmd[];

/* vi: set ts=4 expandtab: */
