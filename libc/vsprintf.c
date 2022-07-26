/*****************************************************************************

  vsprintf.c                                        tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <limits.h>
#include <stdarg.h>

int vsprintf(char *s, const char *fmt, va_list args)
{
    FILE tmp;
    int count;

    tmp._fd = -1;
    tmp._flags = _IOWRITE + _IONBF + _IOWRITING;
    tmp._buf = (unsigned char *) s;
    tmp._ptr = (unsigned char *) s;
    tmp._count = INT_MAX;

    count = vfprintf(&tmp, fmt, args);

    tmp._count = 1;
    putc(0, &tmp);

    return count;
}

/* vi: set ts=4 expandtab: */
