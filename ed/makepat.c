/*****************************************************************************

   makepat.c                                             minix line editor

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
#include <stdlib.h>
#include "tools.h"
#include "ed.h"

/* make a pattern template from the strinng pointed to by arg. stop
   when delim or '\000' or '\n' is found in arg. Return pointer to
   the pattern template.

   the pattern template used here are somewhat different than those
   used in the "Software Tools" book; each token is a structure of
   the form TOKEN (see tools.h). a token consists of an identifier,
   a pointer to a string, a literal character and a pointer to another
   token. this last is 0 if there is no subsequent token.

   the one strangeness here is caused (again) by CLOSURE which has
   to be put in front of the previous token. to make this insertion a
   little easier, the 'next' field of the last to point at the chain
   (the one pointed to by 'tail) is made to point at the previous node.
   when we are finished, tail->next is set to 0. */

TOKEN *makepat(char *arg, int delim)
{
    TOKEN *head, *tail, *ntok;
    int error;

    /* check for characters that aren't
       legal at the beginning of a template. */

    if (*arg == '\0' || *arg == delim || *arg == '\n' || *arg == CLOSURE)
        return(0);

    error = 0;
    tail = head = NULL;

    while (*arg && *arg != delim && *arg != '\n' && !error) {
        ntok = (TOKEN *) malloc(TOKSIZE);
        ntok->lchar = '\000';
        ntok->next = 0;

        switch (*arg) {
        case ANY:       ntok->tok = ANY; break;

        case BOL:       if (head == 0)  /* then this is the first symbol */
                            ntok->tok = BOL;
                        else
                            ntok->tok = LITCHAR;

                        ntok->lchar = BOL;
                        break;

        case EOL:       if (*(arg + 1) == delim || *(arg + 1) == '\000' ||
                          *(arg + 1) == '\n')
                        {
                            ntok->tok = EOL;
                        } else {
                            ntok->tok = LITCHAR;
                            ntok->lchar = EOL;
                        }
                        break;

        case CLOSURE:   if (head != 0) {
                            switch (tail->tok) {
                            case BOL:
                            case EOL:
                            case CLOSURE: return 0;

                            default: ntok->tok = CLOSURE;
                            }
                        }
                        break;

        case CCL:       if (*(arg + 1) == NEGATE) {
                            ntok->tok = NCCL;
                            arg += 2;
                        } else {
                            ntok->tok = CCL;
                            arg++;
                        }

                        if (ntok->bitmap = makebitmap(CLS_SIZE))
                            arg = dodash(CCLEND, arg, ntok->bitmap);
                        else {
                            fprintf(stderr, "Not enough memory for pat\n");
                            error = 1;
                        }
                        break;

        default:        if (*arg == ESCAPE && *(arg + 1) == OPEN) {
                            ntok->tok = OPEN;
                            arg++;
                        } else if (*arg == ESCAPE && *(arg + 1) == CLOSE) {
                            ntok->tok = CLOSE;
                            arg++;
                        } else {
                            ntok->tok = LITCHAR;
                            ntok->lchar = esc(&arg);
                        }
        }

        if (error || ntok == 0) {
            unmakepat(head);
            return(0);
        } else if (head == 0) {
            /* this is the first node in the chain. */

            ntok->next = 0;
            head = tail = ntok;
        } else if (ntok->tok != CLOSURE) {
            /* insert at end of list (after tail) */

            tail->next = ntok;
            ntok->next = tail;
            tail = ntok;
        } else if (head != tail) {
            /* more than one node in the chain. insert the
               CLOSURE node immediately in front of tail. */

            (tail->next)->next = ntok;
            ntok->next = tail;
        } else {
            /* only one node in the chain, insert the CLOSURE
               node at the head of the linked list. */

            ntok->next = head;
            tail->next = ntok;
            head = ntok;
        }

        arg++;
    }

    tail->next = 0;
    return head;
}

/* vi: set ts=4 expandtab: */
