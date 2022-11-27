/*****************************************************************************

   dodash.c                                              minix line editor

******************************************************************************

    derived from source found in Minix 2, Copyright 1987 Brian Beattie.

              Permission to copy and/or distribute granted
              under the following conditions:

                 (1) No charge may be made other than
                     reasonable charges for reproduction.
                 (2) This notice must remain intact.
                 (3) No further restrictions may be added.

*****************************************************************************/

#include <stdio.h>
#include "tools.h"
#include "ed.h"

/* expand the set pointed to by *src into dest. stop at delim.
   return 0 on error or size of character class on success.
   update *src to point at delim. a set can have one element
   {x} or several elements ( {abcdefghijklmnopqrstuvwxyz} and
   {a-z} are equivalent ). note that the dash notation is
   expanded as sequential numbers. this means (since we are
   using the ASCII character set) that a-Z will contain the
   entire alphabet plus the symbols: [\]^_`. the maximum number
   of characters in a character class is defined by maxccl. */

char *dodash(int delim, char *src, char *map)
{
    int first, last;
    char *start;

    start = src;

    while (*src && *src != delim) {
        if (*src != '-')
            setbit(esc(&src), map, 1);
        else
            if (src == start || *(src + 1) == delim)
                setbit('-', map, 1);
            else {
                src++;

                if (*src < *(src - 2)) {
                    first = *src;
                    last = *(src - 2);
                } else {
                    first = *(src - 2);
                    last = *src;
                }

                while (++first <= last) setbit(first, map, 1);
            }

        src++;
    }

    return(src);
}

/* vi: set ts=4 expandtab: */
