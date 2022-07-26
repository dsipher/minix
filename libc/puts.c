/*****************************************************************************

  puts.c                                            tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

int puts(const char *s)
{
    int i = 0;

    while (*s) {
        if (putc(*s++, stdout) == EOF)
            return EOF;
        else
            i++;
    }

    if (putc('\n', stdout) == EOF)
        return EOF;

    return i + 1;
}

/* vi: set ts=4 expandtab: */
