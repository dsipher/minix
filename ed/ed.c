/*****************************************************************************

   ed.c                                                  ux/64 line editor

******************************************************************************

    derived from source found in Minix 2, Copyright 1987 Brian Beattie.

              Permission to copy and/or distribute granted
              under the following conditions:

                 (1) No charge may be made other than
                     reasonable charges for reproduction.

                 (2) This notice must remain intact.
                 (3) No further restrictions may be added.

*****************************************************************************/

/*	This program used to be in many little pieces, with this makefile:
.SUFFIXES:	.c .s

CFLAGS = -F

OBJS =	append.s catsub.s ckglob.s deflt.s del.s docmd.s doglob.s\
  doprnt.s doread.s dowrite.s ed.s egets.s find.s getfn.s getlst.s\
  getnum.s getone.s getptr.s getrhs.s gettxt.s ins.s join.s maksub.s\
  move.s optpat.s set.s setbuf.s subst.s getpat.s matchs.s amatch.s\
  unmkpat.s omatch.s makepat.s bitmap.s dodash.s esc.s System.s

ed:	$(OBJS)
  cc -T. -i -o ed $(OBJS)
*/

#include <stdio.h>
#include <setjmp.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "tools.h"
#include "ed.h"

jmp_buf env;

LINE line0;
int curln = 0;
int lastln = 0;
char *inptr;
static char inlin[MAXLINE];
int nflg, lflg;
int line1, line2, nlines;
extern char fname[];
int version = 1;
int diag = 1;

void intr(sig)
int sig;
{
  printf("?\n");
  longjmp(env, 1);
}

int main(argc, argv)
int argc;
char **argv;
{
  int stat, i, doflush;

  set_buf();
  doflush = isatty(1);

  if (argc > 1 && (strcmp(argv[1], "-") == 0 || strcmp(argv[1], "-s") == 0)) {
	diag = 0;
	argc--;
	argv++;
  }
  if (argc > 1) {
	for (i = 1; i < argc; i++) {
		if (doread(0, argv[i]) == 0) {
			curln = 1;
			strcpy(fname, argv[i]);
			break;
		}
	}
  }
  while (1) {
	setjmp(env);
	if (signal(SIGINT, SIG_IGN) != SIG_IGN) signal(SIGINT, intr);

	if (doflush) fflush(stdout);

	if (fgets(inlin, sizeof(inlin), stdin) == NULL) {
		break;
	}
	for (;;) {
		inptr = strchr(inlin, EOS);
		if (inptr >= inlin+2 && inptr[-2] == '\\' && inptr[-1] == NL) {
			inptr[-1] = 'n';
			if (fgets(inptr, sizeof(inlin) - (inptr - inlin),
						stdin) == NULL) break;
		} else {
			break;
		}
	}
	if (*inlin == '!') {
		if ((inptr = strchr(inlin, NL)) != NULL) *inptr = EOS;
		System(inlin + 1);
		continue;
	}
	inptr = inlin;
	if (getlst() >= 0)
		if ((stat = ckglob()) != 0) {
			if (stat >= 0 && (stat = doglob()) >= 0) {
				curln = stat;
				continue;
			}
		} else {
			if ((stat = docmd(0)) >= 0) {
				if (stat == 1) doprnt(curln, curln);
				continue;
			}
		}
	if (stat == EOF) {
		exit(0);
	}
	if (stat == FATAL) {
		fputs("FATAL ERROR\n", stderr);
		exit(1);
	}
	printf("?\n");
  }
  return(0);
}

/*	getpat.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */

/* Translate arg into a TOKEN string */
TOKEN *
 getpat(arg)
char *arg;
{

  return(makepat(arg, '\000'));
}

/*	getptr.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

LINE *
 getptr(num)
int num;
{
  LINE *ptr;
  int j;

  if (2 * num > lastln && num <= lastln) {	/* high line numbers */
	ptr = line0.l_prev;
	for (j = lastln; j > num; j--) ptr = ptr->l_prev;
  } else {			/* low line numbers */
	ptr = &line0;
	for (j = 0; j < num; j++) ptr = ptr->l_next;
  }
  return(ptr);
}

/*	getrhs.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

int getrhs(sub)
char *sub;
{
  if (inptr[0] == NL || inptr[1] == NL)	/* check for eol */
	return(ERR);

  if (maksub(sub, MAXPAT) == NULL) return(ERR);

  inptr++;			/* skip over delimter */
  while (*inptr == SP || *inptr == HT) inptr++;
  if (*inptr == 'g') {
	inptr++;
	return(1);
  }
  return(0);
}

/*	gettxt.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

char *
 gettxt(num)
int num;
{
  LINE *lin;
  static char txtbuf[MAXLINE];

  lin = getptr(num);
  strcpy(txtbuf, lin->l_buff);
  strcat(txtbuf, "\n");
  return(txtbuf);
}

/*	ins.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

int ins(str)
char *str;
{
  char buf[MAXLINE], *cp;
  LINE *new, *cur, *nxt;

  cp = buf;
  while (1) {
	if ((*cp = *str++) == NL) *cp = EOS;
	if (*cp) {
		cp++;
		continue;
	}
	if ((new = (LINE *) malloc(sizeof(LINE) + strlen(buf))) == NULL)
		return(ERR);	/* no memory */

	new->l_stat = 0;
	strcpy(new->l_buff, buf);	/* build new line */
	cur = getptr(curln);	/* get current line */
	nxt = cur->l_next;	/* get next line */
	relink(cur, new, new, nxt);	/* add to linked list */
	relink(new, nxt, cur, new);
	lastln++;
	curln++;

	if (*str == EOS)	/* end of line ? */
		return(1);

	cp = buf;
  }
}

/*	join.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

extern int fchanged;

int join(first, last)
int first, last;
{
  char buf[MAXLINE];
  char *cp = buf, *str;
  int num;

  if (first <= 0 || first > last || last > lastln) return(ERR);
  if (first == last) {
	curln = first;
	return 0;
  }
  for (num = first; num <= last; num++) {
	str = gettxt(num);

	while (*str != NL && cp < buf + MAXLINE - 1) *cp++ = *str++;

	if (cp == buf + MAXLINE - 1) {
		printf("line too long\n");
		return(ERR);
	}
  }
  *cp++ = NL;
  *cp = EOS;
  del(first, last);
  curln = first - 1;
  ins(buf);
  fchanged = TRUE;
  return 0;
}

/*	makepat.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */

/* Make a pattern template from the strinng pointed to by arg.  Stop
 * when delim or '\000' or '\n' is found in arg.  Return a pointer to
 * the pattern template.
 *
 * The pattern template used here are somewhat different than those
 * used in the "Software Tools" book; each token is a structure of
 * the form TOKEN (see tools.h).  A token consists of an identifier,
 * a pointer to a string, a literal character and a pointer to another
 * token.  This last is 0 if there is no subsequent token.
 *
 * The one strangeness here is caused (again) by CLOSURE which has
 * to be put in front of the previous token.  To make this insertion a
 * little easier, the 'next' field of the last to point at the chain
 * (the one pointed to by 'tail) is made to point at the previous node.
 * When we are finished, tail->next is set to 0.
 */
TOKEN *
 makepat(arg, delim)
char *arg;
int delim;
{
  TOKEN *head, *tail, *ntok;
  int error;

  /* Check for characters that aren't legal at the beginning of a template. */

  if (*arg == '\0' || *arg == delim || *arg == '\n' || *arg == CLOSURE)
	return(0);

  error = 0;
  tail = head = NULL;

  while (*arg && *arg != delim && *arg != '\n' && !error) {
	ntok = (TOKEN *) malloc(TOKSIZE);
	ntok->lchar = '\000';
	ntok->next = 0;

	switch (*arg) {
	    case ANY:	ntok->tok = ANY;	break;

	    case BOL:
		if (head == 0)	/* then this is the first symbol */
			ntok->tok = BOL;
		else
			ntok->tok = LITCHAR;
		ntok->lchar = BOL;
		break;

	    case EOL:
		if (*(arg + 1) == delim || *(arg + 1) == '\000' ||
		    *(arg + 1) == '\n') {
			ntok->tok = EOL;
		} else {
			ntok->tok = LITCHAR;
			ntok->lchar = EOL;
		}
		break;

	    case CLOSURE:
		if (head != 0) {
			switch (tail->tok) {
			    case BOL:
			    case EOL:
			    case CLOSURE:
				return(0);

			    default:
				ntok->tok = CLOSURE;
			}
		}
		break;

	    case CCL:

		if (*(arg + 1) == NEGATE) {
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

	    default:
		if (*arg == ESCAPE && *(arg + 1) == OPEN) {
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
		/* This is the first node in the chain. */

		ntok->next = 0;
		head = tail = ntok;
	} else if (ntok->tok != CLOSURE) {
		/* Insert at end of list (after tail) */

		tail->next = ntok;
		ntok->next = tail;
		tail = ntok;
	} else if (head != tail) {
		/* More than one node in the chain.  Insert the
		 * CLOSURE node immediately in front of tail. */

		(tail->next)->next = ntok;
		ntok->next = tail;
	} else {
		/* Only one node in the chain,  Insert the CLOSURE
		 * node at the head of the linked list. */

		ntok->next = head;
		tail->next = ntok;
		head = ntok;
	}
	arg++;
  }

  tail->next = 0;
  return(head);
}

/*	maksub.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

char *
 maksub(sub, subsz)
char *sub;
int subsz;
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
		if (size >= subsz) return(NULL);

		switch (toupper(*inptr)) {
		    case NL:	*cp++ = ESCAPE;		break;
			break;
		    case 'S':
			*cp++ = SP;
			inptr++;
			break;
		    case 'N':
			*cp++ = NL;
			inptr++;
			break;
		    case 'T':
			*cp++ = HT;
			inptr++;
			break;
		    case 'B':
			*cp++ = BS;
			inptr++;
			break;
		    case 'R':
			*cp++ = CR;
			inptr++;
			break;
		    case '0':{
				int i = 3;
				*cp = 0;
				do {
					if (*++inptr < '0' || *inptr > '7')
						break;

					*cp = (*cp << 3) | (*inptr - '0');
				} while (--i != 0);
				cp++;
			} break;
		    default:	*cp++ = *inptr++;	break;
		}
	}
  }
  if (size >= subsz) return(NULL);

  *cp = EOS;
  return(sub);
}

/*	matchs.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */

/* Compares line and pattern.  Line is a character string while pat
 * is a pattern template made by getpat().
 * Returns:
 *	1. A zero if no match was found.
 *
 *	2. A pointer to the last character satisfing the match
 *	   if ret_endp is non-zero.
 *
 *	3. A pointer to the beginning of the matched string if
 *	   ret_endp is zero.
 *
 * e.g.:
 *
 *	matchs ("1234567890", getpat("4[0-9]*7), 0);
 * will return a pointer to the '4', while:
 *
 *	matchs ("1234567890", getpat("4[0-9]*7), 1);
 * will return a pointer to the '7'.
 */
char *
 matchs(line, pat, ret_endp)
char *line;
TOKEN *pat;
int ret_endp;
{

  char *rval, *bptr;
  char *line2;
  TOKEN *pat2;
  char c;
  short ok;

  bptr = line;

  while (*line) {

	if (pat && pat->tok == LITCHAR) {
		while (*line) {
			pat2 = pat;
			line2 = line;
			if (*line2 != pat2->lchar) {
				c = pat2->lchar;
				while (*line2 && *line2 != c) ++line2;
				line = line2;
				if (*line2 == '\0') break;
			}
			ok = 1;
			++line2;
			pat2 = pat2->next;
			while (pat2 && pat2->tok == LITCHAR) {
				if (*line2 != pat2->lchar) {
					ok = 0;
					break;
				}
				++line2;
				pat2 = pat2->next;
			}
			if (!pat2) {
				if (ret_endp)
					return(--line2);
				else
					return(line);
			} else if (ok)
				break;
			++line;
		}
		if (*line == '\0') return(0);
	} else {
		line2 = line;
		pat2 = pat;
	}
	if ((rval = amatch(line2, pat2, bptr)) == 0) {
		if (pat && pat->tok == BOL) break;
		line++;
	} else {
		if (rval > bptr && rval > line)
			rval--;	/* point to last char matched */
		rval = ret_endp ? rval : line;
		break;
	}
  }
  return(rval);
}

/*	move.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

int move(num)
int num;
{
  LINE *k0, *k1, *k2, *k3;

  if (line1 <= 0 || line2 < line1 || (line1 <= num && num <= line2))
	return(ERR);
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

  return(1);
}

int transfer(num)
int num;
{
  int mid, lin, ntrans;

  if (line1 <= 0 || line1 > line2) return(ERR);

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
  return(1);
}

/*	omatch.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */

/* Match one pattern element, pointed at by pat, with the character at
 * **linp.  Return non-zero on match.  Otherwise, return 0.  *Linp is
 * advanced to skip over the matched character; it is not advanced on
 * failure.  The amount of advance is 0 for patterns that match null
 * strings, 1 otherwise.  "boln" should point at the position that will
 * match a BOL token.
 */
int omatch(linp, pat, boln)
char **linp;
TOKEN *pat;
char *boln;
{

  register int advance;

  advance = -1;

  if (**linp) {
	switch (pat->tok) {
	    case LITCHAR:
		if (**linp == pat->lchar) advance = 1;
		break;

	    case BOL:
		if (*linp == boln) advance = 0;
		break;

	    case ANY:
		if (**linp != '\n') advance = 1;
		break;

	    case EOL:
		if (**linp == '\n') advance = 0;
		break;

	    case CCL:
		if (testbit(**linp, pat->bitmap)) advance = 1;
		break;

	    case NCCL:
		if (!testbit(**linp, pat->bitmap)) advance = 1;
		break;
	}
  }
  if (advance >= 0) *linp += advance;

  return(++advance);
}

/*	optpat.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

TOKEN *oldpat;

TOKEN *
 optpat()
{
  char delim, str[MAXPAT], *cp;

  delim = *inptr++;
  cp = str;
  while (*inptr != delim && *inptr != NL) {
	if (*inptr == ESCAPE && inptr[1] != NL) *cp++ = *inptr++;
	*cp++ = *inptr++;
  }

  *cp = EOS;
  if (*str == EOS) return(oldpat);
  if (oldpat) unmakepat(oldpat);
  oldpat = getpat(str);
  return(oldpat);
}

/*	set.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

struct tbl {
  char *t_str;
  int *t_ptr;
  int t_val;
} *t, tbl[] = {

  "number", &nflg, TRUE,
  "nonumber", &nflg, FALSE,
  "list", &lflg, TRUE,
  "nolist", &lflg, FALSE,
  "eightbit", &eightbit, TRUE,
  "noeightbit", &eightbit, FALSE,
  0
};

int set()
{
  char word[16];
  int i;

  inptr++;
  if (*inptr != 't') {
	if (*inptr != SP && *inptr != HT && *inptr != NL) return(ERR);
  } else
	inptr++;

  if (*inptr == NL) return(show());
  /* Skip white space */
  while (*inptr == SP || *inptr == HT) inptr++;

  for (i = 0; *inptr != SP && *inptr != HT && *inptr != NL;)
	word[i++] = *inptr++;
  word[i] = EOS;
  for (t = tbl; t->t_str; t++) {
	if (strcmp(word, t->t_str) == 0) {
		*t->t_ptr = t->t_val;
		return(0);
	}
  }
  return(0);
}

int show()
{
  extern int version;

  printf("ed version %d.%d\n", version / 100, version % 100);
  printf("number %s, list %s\n", nflg ? "ON" : "OFF", lflg ? "ON" : "OFF");
  return(0);
}

/*	setbuf.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

void relink(a, x, y, b)
LINE *a, *x, *y, *b;
{
  x->l_prev = a;
  y->l_next = b;
}

void clrbuf()
{
  del(1, lastln);
}

void set_buf()
{
  relink(&line0, &line0, &line0, &line0);
  curln = lastln = 0;
}

/*	subst.c	*/
/* #include <stdio.h> */
/* #include "tools.h" */
/* #include "ed.h" */

int subst(pat, sub, gflg, pflag)
TOKEN *pat;
char *sub;
int gflg, pflag;
{
  int lin, chngd, nchngd;
  char *txtptr, *txt;
  char *lastm, *m, *new, buf[MAXLINE];

  if (line1 <= 0) return(ERR);
  nchngd = 0;			/* reset count of lines changed */
  for (lin = line1; lin <= line2; lin++) {
	txt = txtptr = gettxt(lin);
	new = buf;
	chngd = 0;
	lastm = NULL;
	while (*txtptr) {
		if (gflg || !chngd)
			m = amatch(txtptr, pat, txt);
		else
			m = NULL;
		if (m != NULL && lastm != m) {
			chngd++;
			new = catsub(txtptr, m, sub, new,
				     buf + MAXLINE);
			lastm = m;
		}
		if (m == NULL || m == txtptr) {
			*new++ = *txtptr++;
		} else {
			txtptr = m;
		}
	}
	if (chngd) {
		if (new >= buf + MAXLINE) return(ERR);
		*new++ = EOS;
		del(lin, lin);
		ins(buf);
		nchngd++;
		if (pflag) doprnt(curln, curln);
	}
  }
  if (nchngd == 0 && !gflg) {
	return(ERR);
  }
  return(nchngd);
}

/*	System.c	*/
#define SHELL	"/bin/sh"
#define SHELL2	"/usr/bin/sh"

int System(c)
char *c;
{
  int pid, status;

  switch (pid = fork()) {
      case -1:
	return -1;
      case 0:
	execl(SHELL, "sh", "-c", c, (char *) 0);
	execl(SHELL2, "sh", "-c", c, (char *) 0);
	exit(-1);
      default:	while (wait(&status) != pid);
}
  return status;
}

/* vi: set ts=4 expandtab: */
