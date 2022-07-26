/*****************************************************************************

  sigemptyset.c                                     tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <signal.h>

int sigemptyset(sigset_t *set)
{
    *set = 0;
    return 0;
}

/* vi: set ts=4 expandtab: */
