/*****************************************************************************

   popen.c                                          ux/64 standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from MINIX, Copyright (c) 1987, 1997 by Prentice Hall.

   Redistribution and use of the MINIX operating system in source and
   binary forms, with or without modification, are permitted provided
   that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following
     disclaimer in the documentation and/or other materials provided
     with the distribution.

   * Neither the name of Prentice Hall nor the names of the software
     authors or contributors may be used to endorse or promote
     products derived from this software without specific prior
     written permission.

   THIS  SOFTWARE  IS  PROVIDED  BY  THE  COPYRIGHT HOLDERS,  AUTHORS, AND
   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED  WARRANTIES, INCLUDING,
   BUT  NOT LIMITED TO,  THE IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND
   FITNESS FOR  A PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN NO  EVENT SHALL
   PRENTICE HALL  OR ANY AUTHORS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
   INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR  CONSEQUENTIAL DAMAGES
   (INCLUDING,  BUT NOT  LIMITED TO,  PROCUREMENT  OF SUBSTITUTE  GOODS OR
   SERVICES;  LOSS OF USE,  DATA, OR  PROFITS; OR  BUSINESS  INTERRUPTION)
   HOWEVER  CAUSED AND  ON ANY THEORY OF  LIABILITY,  WHETHER IN CONTRACT,
   STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING
   IN ANY WAY  OUT  OF THE  USE OF  THIS SOFTWARE,  EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#include <stdio.h>
#include <signal.h>
#include <limits.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>

static pid_t pids[OPEN_MAX];

FILE *popen(const char *command, const char *type)
{
    int piped[2];
    int xtype;
    pid_t pid;

    switch (*type)
    {
    case 'r':   xtype = 0; break;
    case 'w':   xtype = 1; break;

    default:    errno = EINVAL;
                return 0;
    }

    if (pipe(piped) < 0 || (pid = fork()) < 0)
        return 0;

    if (pid == 0)   /* child */
    {
        int *p;

        for (p = pids; p < &pids[OPEN_MAX]; ++p)
            if (*p) close(p - pids);

        close(piped[xtype]);
        dup2(piped[!xtype], !xtype);
        close(piped[!xtype]);
        execl("/bin/sh", "sh", "-c", command, 0);
        _exit(127); /* exec failed */
    }

    pids[piped[xtype]] = pid;
    close(piped[!xtype]);
    return fdopen(piped[xtype], type);
}

int pclose(FILE *stream)
{
    int fildes = fileno(stream);
    int status;

    void (*intsave)(int) = signal(SIGINT, SIG_IGN);
    void (*quitsave)(int) = signal(SIGQUIT, SIG_IGN);

    fclose(stream);

    if (waitpid(pids[fildes], &status, 0) == -1)
        status = -1;

    signal(SIGINT, intsave);
    signal(SIGQUIT, quitsave);

    pids[fildes] = 0;

    return status;
}

/* vi: set ts=4 expandtab: */
