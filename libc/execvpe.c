/*****************************************************************************

  execvpe.c                                         tahoe/64 standard library

             derived from COHERENT, Copyright (C) 1977-1995 by Robert Swartz.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

/* per Posix, we are supposed to invoke the shell to process scripts
   if execve() fails with ENOEXEC, but we do not support that- it is
   legacy behavior and quite limited. users should use #!/bin/sh or
   whatever for executable scripts, and we let the kernel handle it.
   we also don't embed a default path- set the PATH variable. */

#define DEFAULT_PATH ""

int execvpe(const char *name, char *const argv[], char *const envp[])
{
    char fname[PATH_MAX];
    const char *p1;
    char *p2, *p3, *sp;
    int isabs;

    if ((sp = getenv("PATH")) == 0)     /* find PATH */
        sp = DEFAULT_PATH;              /* or use an empty one */

    isabs = (strchr(name, '/') != 0);   /* if pathname is absolute */

    for (;;) {
        if (isabs)
            strcpy(fname, name);
        else {
            for (p2 = fname; *sp && (*sp != ':'); )
                *p2++ = *sp++;  /* copy element from PATH */

            if (p2 != fname)            /* append / if not empty */
                *p2++ = '/';

            for (p1 = name; *p1; )      /* append name */
                *p2++ = *p1++;

            *p2 = 0;                    /* and NUL terminate */
        }

        execve(fname, argv, envp);

        if (isabs)                      /* absolute path, fail */
            break;

        if (*sp == 0)                   /* end of PATH, fail */
            break;

        if (*sp == ':')
            ++sp;
    }

    return -1;
}

/* vi: set ts=4 expandtab: */
