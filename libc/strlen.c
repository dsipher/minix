/*****************************************************************************

  strlen.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

size_t strlen(const char *org)
{
    const char *s = org;

    while (*s++)
        /* EMPTY */ ;

    return --s - org;
}

/* vi: set ts=4 expandtab: */
