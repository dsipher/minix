/*****************************************************************************

   cd.c                                                        ux/64 shell

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

/*
 * The cd and pwd commands.
 */

#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "shell.h"
#include "var.h"
#include "redir.h"
#include "nodes.h"  /* for jobs.h */
#include "jobs.h"
#include "options.h"
#include "output.h"
#include "memalloc.h"
#include "error.h"
#include "mystring.h"


STATIC int docd(char *, int, int);
STATIC void updatepwd(char *);
STATIC void getpwd(void);
STATIC char *getcomponent(void);


char *curdir;           /* current working directory */
STATIC char *cdcomppath;

extern int didudir;     /* set if /u/logname or ~logname expanded */


int
cdcmd(argc, argv)  char **argv; {
    char *dest;
    char *path;
    char *p;
    struct stat statb;
    char *padvance();
    int tohome= 0;

    nextopt(nullstr);
    if ((dest = *argptr) == NULL) {
        if ((dest = bltinlookup("HOME", 1)) == NULL)
            error("HOME not set");
        tohome = 1;
    }
    if (*dest == '/' || (path = bltinlookup("CDPATH", 1)) == NULL)
        path = nullstr;
    while ((p = padvance(&path, dest)) != NULL) {
        if (stat(p, &statb) >= 0
         && (statb.st_mode & S_IFMT) == S_IFDIR
         && docd(p, strcmp(p, dest), tohome) >= 0)
            return 0;
    }
    error("can't cd to %s", dest);
}


/*
 * Actually do the chdir.  If the name refers to symbolic links, we
 * compute the actual directory name before doing the cd.  In an
 * interactive shell, print the directory name if "print" is nonzero
 * or if the name refers to a symbolic link.  We also print the name
 * if "/u/logname" was expanded in it, since this is similar to a
 * symbolic link.  (The check for this breaks if the user gives the
 * cd command some additional, unused arguments.)
 */

STATIC int
docd(dest, print, tohome)
    char *dest;
    {
    if (didudir)
        print = 1;
    INTOFF;
    if (chdir(dest) < 0) {
        INTON;
        return -1;
    }
    updatepwd(dest);
    INTON;
    if (print && iflag)
        out1fmt("%s\n", stackblock());
    return 0;
}


/*
 * Get the next component of the path name pointed to by cdcomppath.
 * This routine overwrites the string pointed to by cdcomppath.
 */

STATIC char *
getcomponent() {
    register char *p;
    char *start;

    if ((p = cdcomppath) == NULL)
        return NULL;
    start = cdcomppath;
    while (*p != '/' && *p != '\0')
        p++;
    if (*p == '\0') {
        cdcomppath = NULL;
    } else {
        *p++ = '\0';
        cdcomppath = p;
    }
    return start;
}



/*
 * Update curdir (the name of the current directory) in response to a
 * cd command.  We also call hashcd to let the routines in exec.c know
 * that the current directory has changed.
 */

void hashcd();

STATIC void
updatepwd(dir)
    char *dir;
    {
    char *new;
    char *p;

    hashcd();               /* update command hash table */
    cdcomppath = stalloc(strlen(dir) + 1);
    scopy(dir, cdcomppath);
    STARTSTACKSTR(new);
    if (*dir != '/') {
        if (curdir == NULL)
            return;
        p = curdir;
        while (*p)
            STPUTC(*p++, new);
        if (p[-1] == '/')
            STUNPUTC(new);
    }
    while ((p = getcomponent()) != NULL) {
        if (equal(p, "..")) {
            while (new > stackblock() && (STUNPUTC(new), *new) != '/');
        } else if (*p != '\0' && ! equal(p, ".")) {
            STPUTC('/', new);
            while (*p)
                STPUTC(*p++, new);
        }
    }
    if (new == stackblock())
        STPUTC('/', new);
    STACKSTRNUL(new);
    if (curdir)
        ckfree(curdir);
    curdir = savestr(stackblock());
}



int
pwdcmd(argc, argv)  char **argv; {
    getpwd();
    out1str(curdir);
    out1c('\n');
    return 0;
}



/*
 * Run /bin/pwd to find out what the current directory is.  We suppress
 * interrupts throughout most of this, but the user can still break out
 * of it by killing the pwd program.  If we already know the current
 * directory, this routine returns immediately.
 */

#define MAXPWD 256

STATIC void
getpwd() {
    char buf[MAXPWD];
    char *p;
    int i;
    int status;
    struct job *jp;
    int pip[2];

    if (curdir)
        return;
    INTOFF;
    if (pipe(pip) < 0)
        error("Pipe call failed");
    jp = makejob((union node *)NULL, 1);
    if (forkshell(jp, (union node *)NULL, FORK_NOJOB) == 0) {
        close(pip[0]);
        if (pip[1] != 1) {
            close(1);
            copyfd(pip[1], 1);
            close(pip[1]);
        }
        execl("/bin/pwd", "pwd", (char *)0);
        error("Cannot exec /bin/pwd");
    }
    close(pip[1]);
    pip[1] = -1;
    p = buf;
    while ((i = read(pip[0], p, buf + MAXPWD - p)) > 0
         || i == -1 && errno == EINTR) {
        if (i > 0)
            p += i;
    }
    close(pip[0]);
    pip[0] = -1;
    status = waitforjob(jp);
    if (status != 0)
        error((char *)0);
    if (i < 0 || p == buf || p[-1] != '\n')
        error("pwd command failed");
    p[-1] = '\0';
    curdir = savestr(buf);
    INTON;
}

/* vi: set ts=4 expandtab: */
