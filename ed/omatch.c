/*****************************************************************************

   omatch.c                                              ux/64 line editor

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

/* match one pattern element, pointed at by pat, with the character
   at **linp. return non-zero on match. otherwise, return 0. *linp is
   is advanced to skip over the matched character; it is not advanced
   on failure. the amount of advance is 0 for patterns that match null
   strings, 1 otherwise. `boln' should point at the position that will
   match a BOL token. */

int omatch(char **linp, TOKEN *pat, char *boln)
{
    int advance;

    advance = -1;

    if (**linp) {
        switch (pat->tok)
        {
        case LITCHAR:  if (**linp == pat->lchar) advance = 1;           break;
        case BOL:      if (*linp == boln) advance = 0;                  break;
        case ANY:      if (**linp != '\n') advance = 1;                 break;
        case EOL:      if (**linp == '\n') advance = 0;                 break;
        case CCL:      if (testbit(**linp, pat->bitmap)) advance = 1;   break;
        case NCCL:     if (!testbit(**linp, pat->bitmap)) advance = 1;  break;
        }
    }

    if (advance >= 0) *linp += advance;

    return (++advance);
}

/* vi: set ts=4 expandtab: */
