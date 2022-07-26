/*****************************************************************************

  rand.c                                            tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>

/* this was obviously written to accommodate 16-bit systems. it
   works fine as-is but could be improved to extend RAND_MAX - cey */

static unsigned next = 1;

int rand(void)
{
    next = next * 1103515245 + 12345;
    return (next / (2 * (RAND_MAX + 1L)) % (RAND_MAX + 1L));
}

void srand(unsigned seed)
{
    next = seed;
}

/* vi: set ts=4 expandtab: */
