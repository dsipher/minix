/*****************************************************************************

   getpwent.c                                       minix standard library

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

#include <sys/types.h>
#include <pwd.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define ARRAY_SIZE(a)       (sizeof(a) / sizeof((a)[0]))
#define ARRAY_LIMIT(a)      ((a) + ARRAY_SIZE(a))

#define PASSWD          "/etc/passwd"

static char             buf[1024];      /* read buffer */
static char             pwline[256];    /* one line from password file */
static struct passwd    entry;          /* entry to fill and return */
static int              pwfd = -1;      /* handle to password file */
static char             *bufptr;        /* position in buf */
static ssize_t          buflen;         /* remaining characters in buf */
static char             *lineptr;       /* position in pwline */

void endpwent(void)
{
    if (pwfd >= 0) {
        close(pwfd);
        pwfd = -1;
        buflen = 0;
    }
}

void setpwent(void)
{
    if (pwfd >= 0) endpwent();

    if ((pwfd = open(PASSWD, O_RDONLY)) < 0)
        return; /* yikes */

    /* don't leave the descriptor dangling
       open if we exec a new process */

    fcntl(pwfd, F_SETFD, fcntl(pwfd, F_GETFD) | FD_CLOEXEC);
}

/* get one line from the password
   file, return 0 if bad or EOF */

static int getline(void)
{
    lineptr = pwline;

    do {
        if (buflen == 0) {
            if ((buflen = read(pwfd, buf, sizeof(buf))) <= 0)
                return 0;

            bufptr = buf;
        }

        if (lineptr == ARRAY_LIMIT(pwline))
            return 0;

        --buflen;
    } while ((*lineptr++ = *bufptr++) != '\n');

    lineptr = pwline;
    return 1;
}

/* scan for a field separator (`:' or '\n') in
   the line. return the start of the field. */

static char *scan_colon(void)
{
    char *field = lineptr;
    char *last;

    for (;;) {
        last = lineptr;

        if (*lineptr == 0) return 0;
        if (*lineptr == '\n') break;
        if (*lineptr++ == ':') break;
    }

    *last = 0;
    return field;
}

struct passwd *getpwent(void)
{
    char *p;

    /* open the file if not yet open */

    if (pwfd < 0) setpwent();
    if (pwfd < 0) return 0;

    /* until a good line is read... */

    for (;;) {
        if (!getline()) return 0;   /* EOF or corrupt. */

        if ((entry.pw_name = scan_colon()) == 0)    continue;
        if ((entry.pw_passwd = scan_colon()) == 0)  continue;

        if ((p = scan_colon()) == 0) continue; entry.pw_uid = atoi(p);
        if ((p = scan_colon()) == 0) continue; entry.pw_gid = atoi(p);

        if ((entry.pw_gecos = scan_colon()) == 0)   continue;
        if ((entry.pw_dir = scan_colon()) == 0)     continue;
        if ((entry.pw_shell = scan_colon()) == 0)   continue;

        if (*lineptr == 0) return &entry;
    }
}

struct passwd *getpwuid(uid_t uid)
{
    struct passwd *pw;

    endpwent();

    while ((pw = getpwent()) != 0 && pw->pw_uid != uid)
        ;

    endpwent();
    return pw;
}

struct passwd *getpwnam(const char *name)
{
    struct passwd *pw;

    endpwent();

    while ((pw = getpwent()) != 0 && strcmp(pw->pw_name, name) != 0)
        ;

    endpwent();
    return pw;
}

/* vi: set ts=4 expandtab: */
