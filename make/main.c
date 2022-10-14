/*****************************************************************************

   main.c                                            jewel/os make utility

******************************************************************************

   derived from MINIX make, Copyright (c) 1987, 1997 by Prentice Hall,
   itself derived from Neil Russell's public domain make (USENET 1986)

   Redistribution and use of the MINIX operating system in source and
   binary forms, with or without modification, are permitted provided
   that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following
     disclaimer in the documentation and/or other materials provided
     with the distribution.

   * Neither the name of Prentice Hall nor the names of the software
     authors or contributors may be used to endorse or promote
     products derived from this software without specific prior
     written permission.

   THIS  SOFTWARE  IS  PROVIDED  BY  THE  COPYRIGHT HOLDERS,  AUTHORS, AND
   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED  WARRANTIES, INCLUDING,
   BUT  NOT LIMITED TO,  THE IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND
   FITNESS FOR  A PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN NO  EVENT SHALL
   PRENTICE HALL  OR ANY AUTHORS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
   INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR  CONSEQUENTIAL DAMAGES
   (INCLUDING,  BUT NOT  LIMITED TO,  PROCUREMENT  OF SUBSTITUTE  GOODS OR
   SERVICES;  LOSS OF USE,  DATA, OR  PROFITS; OR  BUSINESS  INTERRUPTION)
   HOWEVER  CAUSED AND  ON ANY THEORY OF  LIABILITY,  WHETHER IN CONTRACT,
   STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING
   IN ANY WAY  OUT  OF THE  USE OF  THIS SOFTWARE,  EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

/*
 *	make:
 *
 *	-a try to guess undefined ambiguous macros (*,<)
 *	-d print debugging info
 *	-e environment macro def. overwrite makefile def.
 *	-f makefile name
 *	-i ignore exit status
 *	-k continue on errors
 *	-n pretend to make
 *	-p print all macros & targets
 *	-q question up-to-dateness of target.  Return exit status 1 if not
 *	-r don't not use inbuilt rules
 *	-s make silently
 *	-t touch files instead of making them
 */

#define EXTERN
#define INIT(x) = x
#define INITARRAY
#include "h.h"

static char version[]= "2.0";

static FILE *ifd;           /*  Input file desciptor  */
static char *ptrmakeflags;

/* There must be enough 'space' for all possible flags ! */
static char  makeflags[] = "MAKEFLAGS=                    ";

void main(argc, argv)
int    argc;
char **argv;
{
  register char        *p;		/*  For argument processing  */
  int                   estat = 0;	/*  For question  */
  register struct name *np;
  struct macro         *mp;
  int                   targc;		/* temporary for multiple scans */
  char                **targv;
  char                **nargv;		/* for removing items from argv */
  char                **envp;      /* enivironment ptr */


  ptrmakeflags = &makeflags[10];
  myname = (argc-- < 1) ? "make" : *argv++;

  targc = argc;
  targv = nargv = argv;
  while (targc--) {
	if((p = strchr(*targv, '=')) != (char *)NULL) {
		*p = '\0';
		mp = setmacro(*targv, p + 1);
		mp->m_flag |= M_OVERRIDE;
		--argc;
	} else
		*nargv++ = *targv;

	++targv;
  }

  targc = argc;
  targv = nargv = argv;
  while (targc--) {
	if (**targv == '-') {
		--argc;
		p = *targv++;
		while (*++p != '\0') {
			switch(mylower(*p)) {
			case 'f':	/*  Alternate file name  */
				if (*++p == '\0') {
					--argc;
					if (targc-- == 0)
						usage();
					p = *targv++;
				}
				makefile = p;
				goto end_of_args;
			default :
				setoption(*p);
				break;
			}
		}
	end_of_args:;
	} else
		*nargv++ = *targv++;
  }

  /* evaluate and update environment MAKEFLAGS */
  if((p =getenv("MAKEFLAGS")) != (char *)0)
	while(*p) setoption(*p++);
  for( p = ptrmakeflags; !isspace((int)*p); p++) ;
  *p = '\0';
  putenv(makeflags);

  if (makefile && strcmp(makefile, "-") == 0)  /*   use stdin as makefile  */
	ifd = stdin;
  else if (!makefile) {    /*  If no file, then use default */
	if ((ifd = fopen(makefile = DEFN1, "r")) == (FILE *)0) {
		if (errno != MNOENT || !DEFN2)
			fatal("Can't open %s: %s", DEFN1, errno);
		else if ((ifd = fopen(makefile = DEFN2, "r")) == (FILE *)0)
			fatal("Can't open %s: %s", DEFN2, errno);
	}
  }
  else if ((ifd = fopen(makefile, "r")) == (FILE *)0)
	fatal("Can't open %s: %s", makefile, errno);

  init();

  makerules();

  mp = setmacro("MAKE", myname);
  mp->m_flag |= M_MAKE;
  setmacro("$", "$");

  /* set environment macros */
  envp = environ; /* get actual environment ptr. */
  while (*envp) {
	if((p = strchr(*envp, '=')) != (char *)NULL) {
		*p = '\0';
		mp = setmacro(*envp, p + 1);
		*p = '=';
		if (useenv) mp->m_flag |= M_OVERRIDE;
	} else
		fatal("invalid environment: %s",*envp,0);

	++envp;
  }

  input(ifd);	/*  Input all the gunga  */
  fclose(ifd);	/*  Finished with makefile  */
  lineno = 0;	/*  Any calls to error now print no line number */

  if (print)
	prt();	/*  Print out structures  */

  np = newname(".SILENT");
  if (np->n_flag & N_TARG)  silent = TRUE;

  np = newname(".IGNORE");
  if (np->n_flag & N_TARG)  ignore = TRUE;

  precious();

  if (!firstname)
	fatal("No targets defined",(char *)0,0);

  circh();	/*  Check circles in target definitions  */

  if (!argc)
	estat = make(firstname, 0);
  else
	while (argc--) {
		estat |= make(newname(*argv++), 0);
	}

  if (quest)
	exit(estat);
  else
		exit(0);
}

#ifdef __STDC__
void setoption(char option)
#else
void setoption(option)
char option;
#endif
{
  register char *c;

  option = mylower(option);
  switch(option) {
	case 'n':	/*  Pretend mode  */
		domake = FALSE;
		break;
	case 'i':	/*  Ignore fault mode  */
		ignore = TRUE;
		break;
	case 'k':	/*  Continue on errror  */
		conterr = TRUE;
		break;
	case 's':	/*  Silent about commands  */
		silent = TRUE;
		break;
	case 'p':
		print = TRUE;
		break;
	case 'r':
		rules = FALSE;
		break;
	case 't':
		dotouch = TRUE;
		break;
	case 'q':
		quest = TRUE;
		break;
	case 'e':
		useenv = TRUE;
		break;
	case 'd':
		dbginfo = TRUE;
		break;
	case 'a':
		ambigmac = TRUE;
		break;
	default:	/*  Wrong option  */
		usage();
  }
  for( c = ptrmakeflags; !isspace((int)*c); c++)
	if ( *c == option) return;
  *c = option;
}

void usage()
{
  fprintf(stderr, "Syntax: %s [{options | macro=val | target}]\n", myname);
  fprintf(stderr, "Function: maintaining computer programs      V%s\n",version);
  fprintf(stderr, "Options : -a : try to guess undefined ambiguous macros (*,<)\n");
  fprintf(stderr, "          -d : print debugging information\n");
  fprintf(stderr, "          -e : environment macro def. overwrite makefile def.\n");
  fprintf(stderr, "          -f filename : makefile name (default: makefile, Makefile)\n");
  fprintf(stderr, "          -i : ignore exit status of executed commands\n");
  fprintf(stderr, "          -k : continue with unrelated branches on errors\n");
  fprintf(stderr, "          -n : pretend to make\n");
  fprintf(stderr, "          -p : print all macros & targets\n");
  fprintf(stderr, "          -q : question up-to-dateness of target\n");
  fprintf(stderr, "          -r : don't use inbuilt rules\n");
  fprintf(stderr, "          -s : make silently\n");
  fprintf(stderr, "          -t : touch files instead of making them\n");
  fprintf(stderr, "Environment: MAKEFLAGS\n");
  exit(1);
}


void fatal(msg, a1, a2)
char *msg;
char *a1;
int   a2;
{
  fprintf(stderr, "%s: ", myname);
  fprintf(stderr, msg, a1, strerror(a2));
  fputc('\n', stderr);
  exit(1);
}
