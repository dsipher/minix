/*****************************************************************************

   set.c                                                 ux/64 line editor

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
#include <string.h>
#include "tools.h"
#include "ed.h"

struct tbl
{
    char    *t_str;
    int     *t_ptr;
    int     t_val;
};

struct tbl *t;

struct tbl tbl[] = {    "number",       &nflg,      TRUE,
                        "nonumber",     &nflg,      FALSE,
                        "list",         &lflg,      TRUE,
                        "nolist",       &lflg,      FALSE,
                        "eightbit",     &eightbit,  TRUE,
                        "noeightbit",   &eightbit,  FALSE,  0   };

int set()
{
    char word[16];
    int i;

    inptr++;

    if (*inptr != 't') {
        if (*inptr != SP && *inptr != HT && *inptr != NL)
            return(ERR);
    } else
        inptr++;

    if (*inptr == NL) return(show());

    while (*inptr == SP || *inptr == HT)
        inptr++;    /* skip white space */

    for (i = 0; *inptr != SP && *inptr != HT && *inptr != NL;)
        word[i++] = *inptr++;

    word[i] = EOS;

    for (t = tbl; t->t_str; t++) {
        if (strcmp(word, t->t_str) == 0) {
            *t->t_ptr = t->t_val;
            return 0;
        }
    }

    return 0;
}

int show()
{
    extern int version;

    printf("ed version %d.%d\n", version / 100, version % 100);
    printf("number %s, list %s\n", nflg ? "ON" : "OFF", lflg ? "ON" : "OFF");

    return 0;
}

/* vi: set ts=4 expandtab: */
