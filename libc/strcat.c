/*****************************************************************************

  strcat.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

char *strcat(char *ret, const char *s2)
{
    char *s1 = ret;

    while (*s1++ != '\0')
        /* EMPTY */ ;

    s1--;

    while (*s1++ = *s2++)
        /* EMPTY */ ;

    return ret;
}

/* vi: set ts=4 expandtab: */
