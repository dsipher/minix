/*****************************************************************************

   move.c                                                minix line editor

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

int move(int num)
{
    LINE *k0, *k1, *k2, *k3;

    if (line1 <= 0 || line2 < line1 || (line1 <= num && num <= line2))
	    return ERR;

    k0 = getptr(prevln(line1));
    k1 = getptr(line1);
    k2 = getptr(line2);
    k3 = getptr(nextln(line2));

    relink(k0, k3, k0, k3);
    lastln -= line2 - line1 + 1;

    if (num > line1) num -= line2 - line1 + 1;

    curln = num + (line2 - line1 + 1);

    k0 = getptr(num);
    k3 = getptr(nextln(num));

    relink(k0, k1, k2, k3);
    relink(k2, k3, k0, k1);
    lastln += line2 - line1 + 1;

    return 1;
}

int transfer(int num)
{
    int mid, lin, ntrans;

    if (line1 <= 0 || line1 > line2)
        return ERR;

    mid = num < line2 ? num : line2;
    curln = num;
    ntrans = 0;

    for (lin = line1; lin <= mid; lin++) {
	    ins(gettxt(lin));
	    ntrans++;
    }

    lin += ntrans;
    line2 += ntrans;

    for (; lin <= line2; lin += 2) {
	    ins(gettxt(lin));
	    line2++;
    }

    return 1;
}

/* vi: set ts=4 expandtab: */
