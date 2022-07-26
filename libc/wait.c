/*****************************************************************************

  wait.c                                            tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <sys/wait.h>

int wait(int *wstatus)
{
    return waitpid(-1, wstatus, 0);
}

/* vi: set ts=4 expandtab: */
