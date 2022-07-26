/*****************************************************************************

  exit.c                                            tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>

void (*__exit_cleanup)(void);

void exit(int status)
{
    if (__exit_cleanup)
        __exit_cleanup();

    __exit(status);
}

/* vi: set ts=4 expandtab: */
