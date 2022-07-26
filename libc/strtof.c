/*****************************************************************************

  strtof.c                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>

/* this is a placeholder. it should not call strtod; this will
   not properly generate errors if out of range of a float. */

float strtof(const char *nptr, char **endptr)
{
    return strtod(nptr, endptr);
}

/* vi: set ts=4 expandtab: */
