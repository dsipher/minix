/*****************************************************************************

  toupper.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <ctype.h>

int toupper(int c)
{
    return islower(c) ? c - 'a' + 'A' : c ;
}

/* vi: set ts=4 expandtab: */
