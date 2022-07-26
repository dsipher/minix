/*****************************************************************************

  remove.c                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <unistd.h>

int remove(const char *path)
{
    return unlink(path);
}

/* vi: set ts=4 expandtab: */
