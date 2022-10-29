/*****************************************************************************

   amatch.c                                              ux/64 line editor

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

/* scans through the pattern template looking for a match
   with lin. each element of lin is compared with the template
   until either a mis-match is found or the end of the template
   is reached. in the former case a 0 is returned; in the latter,
   a pointer into lin (pointing to the character following the
   matched pattern) is returned.

  	"lin"	is a pointer to the line being searched.
  	"pat"	is a pointer to a template made by makepat().
  	"boln"	is a pointer into "lin" which points at the
  			character at the beginning of the line. */

char    *paropen[9], *parclose[9];
int     between, parnum;

char *amatch(char *lin, TOKEN *pat, char *boln)
{
    between = 0;
    parnum = 0;

    lin = match(lin, pat, boln);

    if (between) return 0;

    while (parnum < 9) {
	    paropen[parnum] = parclose[parnum] = "";
	    parnum++;
    }

    return lin;
}

char *match(char *lin, TOKEN *pat, char *boln)
{
    char *bocl, *rval, *strstart;

    if (pat == 0) return 0;

    strstart = lin;

    while (pat) {
	    if (pat->tok == CLOSURE && pat->next) {
		    /* process a closure: first skip over the closure
		       token to the object to be repeated. this object
		       can be a character class. */

		    pat = pat->next;

		    /* now match as many occurrences of
		       the closure pattern as possible. */

		    bocl = lin;

		    while (*lin && omatch(&lin, pat, boln)) ;

		    /* 'lin' now points to the character that made made
		       us fail. now go on to process the rest of the
		       string. a problem here is a character following
		       the closure which could have been in the closure.
		       for example, in the pattern "[a-z]*t" (which
		       matches any lower-case word ending in a t), the
		       final 't' will be sucked up in the while loop.
		       so, if the match fails, we back up a notch and try
		       to match the rest of the string again, repeating
		       this process recursively until we get back to the
		       beginning of the closure. the recursion goes, at
		       most two levels deep. */

		    if (pat = pat->next) {
			    int savbtwn = between;
			    int savprnm = parnum;

			    while (bocl <= lin) {
				    if (rval = match(lin, pat, boln)) {
					    /* success */
					    return(rval);
				    } else {
					    --lin;
					    between = savbtwn;
					    parnum = savprnm;
				    }
			    }

			    return(0);	/* match failed */
		    }
	    } else if (pat->tok == OPEN) {
		    if (between || parnum >= 9) return 0;
		    paropen[parnum] = lin;
		    between = 1;
		    pat = pat->next;
	    } else if (pat->tok == CLOSE) {
		    if (!between) return 0;
		    parclose[parnum++] = lin;
		    between = 0;
		    pat = pat->next;
	    } else if (omatch(&lin, pat, boln)) {
		    pat = pat->next;
	    } else {
		    return(0);
	    }
    }

    /* note that omatch() advances lin to point at the next character to
       be matched. consequently, when we reach the end of the template,
       lin will be pointing at the character following the last character
       matched. the exceptions are templates containing only a BOLN or
       EOLN token. in these cases omatch doesn't advance.

       a philosophical point should be mentioned here. Is $ a position or
       a character? (i.e. does $ mean the EOL character itself or does it
       mean the character at the end of the line?) i decided here to
       imake it mean the former, in order to make the behavior of match()
       consistent. if you give match the pattern ^$ (match all lines
       consisting only of an end of line) then, since something has to be
       returned, a pointer to the end of line character itself is returned */

    return((char *) max(strstart, lin));
}

/* vi: set ts=4 expandtab: */
