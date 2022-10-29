/*****************************************************************************

   bitmap.c                                              ux/64 line editor

******************************************************************************

   Bit-map manipulation routines, Copyright (c) Allen I. Holub. All rights
   reserved. This program may for copied for personal, non-profit use only.

*****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include "tools.h"

/* make a bit map with "size" bits. the first entry in the map
   is an "unsigned int" representing the maximum bit. the map
   itself is concatenated to this integer. return a pointer to
   a map on success, 0 if there's not enough memory. */

BITMAP *makebitmap(unsigned size)
{
    unsigned *map, numbytes;

    numbytes = (size >> 3) + ((size & 0x07) ? 1 : 0);

    if (map = malloc(numbytes + sizeof(unsigned))) {
	    *map = size;
	    memset(map + 1, 0, numbytes);
    }

    return((BITMAP *) map);
}

/* set bit c in the map to val. if c > map-size,
   0 is returned, else 1 is returned. */

int setbit(unsigned c, char *map, unsigned val)
{
    if (c >= *(unsigned *) map)	    /* if c >= map size */
	    return 0;

    map += sizeof(unsigned);	    /* skip past size */

    if (val)
	    map[c >> 3] |= 1 << (c & 0x07);
    else
	    map[c >> 3] &= ~(1 << (c & 0x07));

    return 1;
}

/* return 1 if the bit corresponding to
   c in map is set. 0 if it is not. */

int testbit(c, map)
unsigned c;
char *map;
{
    if (c >= *(unsigned *) map) return 0;
    map += sizeof(unsigned);
    return (map[c >> 3] & (1 << (c & 0x07)));
}

/* vi: set ts=4 expandtab: */
