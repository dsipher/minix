/*****************************************************************************

  printf.c                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdarg.h>

int printf(const char *fmt, ...)
{
    va_list args;
    int count;

    va_start(args, fmt);
    count = vfprintf(stdout, fmt, args);
    va_end(args);

    return count;
}

/* vi: set ts=4 expandtab: */
