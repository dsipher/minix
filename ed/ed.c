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
