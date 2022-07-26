/*****************************************************************************

  bsearch.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>

void *bsearch(const void *key, const void *base, size_t nmemb, size_t size,
              int (*compar)(const void *, const void *))
{
    const void *mid_point;
    int cmp;

    while (nmemb > 0) {
        mid_point = ((char *) base) + (size * (nmemb >> 1));

        if ((cmp = (*compar)(key, mid_point)) == 0)
            return (void *) mid_point;

        if (cmp >= 0) {
            base  = ((char *) mid_point) + size;
            nmemb = (nmemb - 1) >> 1;
        } else
            nmemb >>= 1;
    }

    return 0;
}

/* vi: set ts=4 expandtab: */
