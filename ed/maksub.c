/*****************************************************************************

   maksub.c                                              ux/64 line editor

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

char *maksub(char *sub, int subsz)
{
    int size;
    char delim, *cp;

    size = 0;
    cp = sub;

    delim = *inptr++;

    for (size = 0; *inptr != delim && *inptr != NL && size < subsz; size++) {
        if (*inptr == '&') {
            *cp++ = DITTO;
            inptr++;
        } else if ((*cp++ = *inptr++) == ESCAPE) {
            if (size >= subsz) return NULL;

            switch (toupper(*inptr))
            {
            case NL:    *cp++ = ESCAPE;         break;
            case 'S':   *cp++ = SP; inptr++;    break;
            case 'N':   *cp++ = NL; inptr++;    break;
            case 'T':   *cp++ = HT; inptr++;    break;
            case 'B':   *cp++ = BS; inptr++;    break;
            case 'R':   *cp++ = CR; inptr++;    break;

            case '0':
                {
                    int i = 3;
                    *cp = 0;

                    do {
                        if (*++inptr < '0' || *inptr > '7')
                            break;

                        *cp = (*cp << 3) | (*inptr - '0');
                    } while (--i != 0);

                    cp++;
                    break;
                }

            default:    *cp++ = *inptr++;       break;
            }
        }
    }

    if (size >= subsz) return(NULL);
    *cp = EOS;

    return sub;
}

/* vi: set ts=4 expandtab: */
