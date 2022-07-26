/*****************************************************************************

  fputs.c                                           tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

int fputs(const char *s, FILE *fp)
{
    int i = 0;

    while (*s)
        if (putc(*s++, fp) == EOF)
            return EOF;
        else
            i++;

    return i;
}

/* vi: set ts=4 expandtab: */
