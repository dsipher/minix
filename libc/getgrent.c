/*****************************************************************************

   getgrent.c                                       ux/64 standard library

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
#include <grp.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

/* the logic here is, understandably, nearly identical to that in getpwent.c.
   as such many of the comments here are sparse (see the aforementined file).
   it would be nice if we could refactor to not repeat ourselves. -cey */

#define ARRAY_SIZE(a)       (sizeof(a) / sizeof((a)[0]))
#define ARRAY_LIMIT(a)      ((a) + ARRAY_SIZE(a))

#define GROUP           "/etc/group"

static char             buf[1024];          /* read buffer */
static char             grline[512];        /* one line from group file */
static struct group     entry;              /* entry to fill and return */
static char             *members[64];       /* group members for entry */
static int              grfd = -1;          /* handle to group database */
static char             *bufptr;            /* position in buf */
static ssize_t          buflen;             /* remaining characters in buf */
static char             *lineptr;           /* position in grline[] */

void endgrent(void)
{
    if (grfd >= 0) {
        close(grfd);
        grfd = -1;
        buflen = 0;
    }
}

void setgrent(void)
{
    if (grfd >= 0) endgrent();

    if ((grfd = open(GROUP, O_RDONLY)) < 0)
        return;

    fcntl(grfd, F_SETFD, fcntl(grfd, F_GETFD) | FD_CLOEXEC);
}

static int getline(void)
{
    lineptr = grline;

    do {
        if (buflen == 0) {
            if ((buflen= read(grfd, buf, sizeof(buf))) <= 0)
                return 0;

            bufptr = buf;
        }

        if (lineptr == ARRAY_LIMIT(grline))
            return 0;

        --buflen;
    } while ((*lineptr++ = *bufptr++) != '\n');

    lineptr = grline;
    return 1;
}

static char *scan_punct(int punct)
{
    char *field = lineptr;
    char *last;

    for (;;) {
        last = lineptr;
        if (*lineptr == 0) return 0;
        if (*lineptr == '\n') break;
        if (*lineptr++ == punct) break;
        if (lineptr[-1] == ':') return 0;   /* :::,,,:,,,? */
    }

    *last = 0;
    return field;
}

struct group *getgrent(void)
{
    char *p;
    char **mem;

    if (grfd < 0) setgrent();
    if (grfd < 0) return 0;

again:
    for (;;) {
        if (!getline()) return 0;

        if ((entry.gr_name = scan_punct(':')) == 0)     continue;
        if ((entry.gr_passwd = scan_punct(':')) == 0)   continue;
        if ((p = scan_punct(':')) == 0)                 continue;

        entry.gr_gid = atoi(p);
        entry.gr_mem = mem = members;

        if (*lineptr != '\n') {
            do {
                if ((*mem = scan_punct(',')) == 0) goto again;
                if (mem < ARRAY_LIMIT(members) - 1) ++mem;
            } while (*lineptr);
        }

        *mem = 0;
        return &entry;
    }
}

struct group *getgrgid(gid_t gid)
{
    struct group *gr;

    endgrent();

    while ((gr = getgrent()) && gr->gr_gid != gid)
        ;

    endgrent();
    return gr;
}

struct group *getgrnam(const char *name)
{
    struct group *gr;

    endgrent();

    while ((gr = getgrent()) && strcmp(gr->gr_name, name) != 0)
        ;

    endgrent();
    return gr;
}

/* vi: set ts=4 expandtab: */
