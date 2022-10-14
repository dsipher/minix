/*****************************************************************************

   getcwd.c                                      jewel/os standard library

******************************************************************************

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

#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <limits.h>
#include <errno.h>
#include <sys/stat.h>

/* add the name of a directory entry at the front of the path
    being built. note that the result always starts with a `/'. */

static int addpath(const char *path, char **ap, const char *entry)
{
    const char *e = entry;
    char *p = *ap;

    while (*e != 0) e++;

    while (e > entry && p > path) *--p = *--e;

    if (p == path) return -1;
    *--p = '/';
    *ap = p;

    return 0;
}

/* undo all those chdir("..")'s that have been recorded by addpath(). this
   must be done entry by entry because the whole pathname may be too long. */

static int recover(char *p)
{
    int e = errno, slash;
    char *p0;

    while (*p != 0) {
        p0= ++p;

        do p++; while (*p != 0 && *p != '/');
        slash = *p; *p = 0;

        if (chdir(p0) < 0) return -1;
        *p= slash;
    }

    errno = e;
    return 0;
}

char *getcwd(char *path, size_t size)
{
    struct stat above, current, tmp;
    struct dirent *entry;
    DIR *d;
    char *p, *up;
    int cycle;

    if (path == 0 || size <= 1) {
        errno = EINVAL;
        return 0;
    }

    p = path + size;
    *--p = 0;

    if (stat(".", &current) < 0) return 0;

    for (;;)
    {
        if (stat("..", &above) < 0) {
            recover(p);
            return 0;
        }

        if (above.st_dev == current.st_dev
          && above.st_ino == current.st_ino)
            break;  /* root dir found */

        if ((d = opendir("..")) == 0) {
            recover(p);
            return 0;
        }

        /* `cycle' is 0 for a simple inode nr search, or 1
           1 for a search * for inode *and* device nr. */

        cycle = above.st_dev == current.st_dev ? 0 : 1;

        do {
            char name[3 + NAME_MAX + 1];

            tmp.st_ino = 0;

            if ((entry = readdir(d)) == 0) {
                switch (++cycle) {
                case 1:     rewinddir(d);
                            continue;

                case 2:     closedir(d);
                            errno = ENOENT;
                            recover(p);
                            return 0;
                }
            }

            if (strcmp(entry->d_name, ".") == 0) continue;
            if (strcmp(entry->d_name, "..") == 0) continue;

            switch (cycle) {
            case 0:     /* simple test on inode nr */
                        if (entry->d_ino != current.st_ino) continue;
                        /* FALLTHRU */

            case 1:     /* current is mounted */
                        strcpy(name, "../");
                        strcpy(name+3, entry->d_name);
                        if (stat(name, &tmp) < 0) continue;
                        break;
            }
        } while (tmp.st_ino != current.st_ino
              || tmp.st_dev != current.st_dev);

        up = p;

        if (addpath(path, &up, entry->d_name) < 0) {
            closedir(d);
            errno = ERANGE;
            recover(p);
            return 0;
        }

        closedir(d);

        if (chdir("..") < 0) {
            recover(p);
            return 0;
        }

        p = up;
        current = above;
    }

    if (recover(p) < 0) return 0;       /* undo all those chdir("..")'s. */
    if (*p == 0) *--p = '/';            /* cwd is `/' if nothing added */
    if (p > path) strcpy(path, p);      /* move result to start of `path' */

    return path;
}

/* vi: set ts=4 expandtab: */
