/*****************************************************************************

  sprintf.c                                         tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdarg.h>

int sprintf(char *s, const char *fmt, ...)
{
    va_list args;
    int count;

    va_start(args, fmt);
    count = vsprintf(s, fmt, args);
    va_end(args);

    return count;
}

/* vi: set ts=4 expandtab: */
