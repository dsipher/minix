/*****************************************************************************

  tolower.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <ctype.h>

int tolower(int c)
{
    return isupper(c) ? c - 'A' + 'a' : c ;
}

/* vi: set ts=4 expandtab: */
