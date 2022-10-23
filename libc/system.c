/*****************************************************************************

   system.c                                         ux/64 standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from COHERENT, Copyright (c) 1977-1995 by Robert Swartz.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

   3. Neither the name of the copyright holder nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

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

#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

int system(const char *command)
{
    static char *argv[] = { "/bin/sh", "-c", 0, 0 };
    extern char **environ;

    int status, pid;
    int wpid;
    __sighandler_t intfun, quitfun;

    /* assume /bin/sh hasn't disappeared. C89 7.10.4.5 says
       "a null pointer may be used ... to inquire whether a
       command processor exists", which is an environmental
       query, and does not imply testing if we can exec it */

    if (command == 0) return 1;

    if ((pid = fork()) < 0)
        return (-1);

    if (pid == 0) { /* child */
        argv[2] = (char *) command;
        execve("/bin/sh", argv, environ);
        exit(0177); /* exec failed */
    }

    intfun = signal(SIGINT, SIG_IGN);
    quitfun = signal(SIGQUIT, SIG_IGN);

    while ((wpid = wait(&status)) != pid && wpid >= 0)
        ;

    if (wpid < 0)
        status = wpid;

    signal(SIGINT, intfun);
    signal(SIGQUIT, quitfun);

    return (status);
}

/* vi: set ts=4 expandtab: */
