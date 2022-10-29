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
		sys(inlin + 1);
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

/* vi: set ts=4 expandtab: */
