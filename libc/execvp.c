/*****************************************************************************

  execvp.c                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>
#include <unistd.h>

int execvp(const char *name, char *const argv[])
{
    extern char **environ;

    return execvpe(name, argv, environ);
}

/* vi: set ts=4 expandtab: */
