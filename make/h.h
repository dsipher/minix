/*****************************************************************************

   h.h                                                  minix make utility

******************************************************************************

   derived from MINIX 2 make, Copyright (c) 1987, 1997 by Prentice Hall,
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

#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <utime.h>
#include <stdio.h>
#include <limits.h>
#include <ctype.h>
#include <stdio.h>
#include <assert.h>

#ifndef uchar
#define uchar  unsigned char
#endif

#define bool   uchar
#ifndef time_t
#define time_t long
#endif
#define TRUE   (1)
#define FALSE  (0)
#define max(a,b) ((a)>(b)?(a):(b))

#define DEFN1   "makefile"
#define DEFN2   "Makefile"

#define TABCHAR '\t'

#define LZ1	(2048)		/*  Initial input/expand string size  */
#define LZ2	(256)		/*  Initial input/expand string size  */



/*
 *	A name.  This represents a file, either to be made, or existant
 */

struct name
{
  struct name  *n_next;		/* Next in the list of names */
  char         *n_name;		/* Called */
  struct line  *n_line;		/* Dependencies */
  time_t        n_time;		/* Modify time of this name */
  uchar         n_flag;		/* Info about the name */
};

#define N_MARK    0x01			/* For cycle check */
#define N_DONE    0x02			/* Name looked at */
#define N_TARG    0x04			/* Name is a target */
#define N_PREC    0x08			/* Target is precious */
#define N_DOUBLE  0x10			/* Double colon target */
#define N_EXISTS  0x20			/* File exists */
#define N_ERROR   0x40			/* Error occured */
#define N_EXEC    0x80			/* Commands executed */

/*
 *	Definition of a target line.
 */
struct	line
{
  struct line    *l_next;		/* Next line (for ::) */
  struct depend  *l_dep;		/* Dependents for this line */
  struct cmd     *l_cmd;		/* Commands for this line */
};


/*
 *	List of dependents for a line
 */
struct	depend
{
  struct depend  *d_next;		/* Next dependent */
  struct name    *d_name;		/* Name of dependent */
};


/*
 *	Commands for a line
 */
struct	cmd
{
  struct cmd  *c_next;		/* Next command line */
  char        *c_cmd;		/* Command line */
};


/*
 *	Macro storage
 */
struct	macro
{
  struct macro *m_next;	/* Next variable */
  char *m_name;		/* Called ... */
  char *m_val;		/* Its value */
  uchar m_flag;		/* Infinite loop check */
};


#define M_MARK		0x01	/* for infinite loop check */
#define M_OVERRIDE	0x02	/* command-line override */
#define M_MAKE		0x04	/* for MAKE macro */

/*
 *	String
 */
struct	str
{
  char **ptr;		/* ptr to real ptr. to string */
  int    len;		/* length of string */
  int    pos;		/* position */
};


/* Declaration, definition & initialization of variables */

#ifndef EXTERN
#define EXTERN extern
#endif

#ifndef INIT
#define INIT(x)
#endif

extern int    errno;
extern char **environ;

EXTERN char *myname;
EXTERN bool  domake   INIT(TRUE);  /*  Go through the motions option  */
EXTERN bool  ignore   INIT(FALSE); /*  Ignore exit status option      */
EXTERN bool  conterr  INIT(FALSE); /*  continue on errors  */
EXTERN bool  silent   INIT(FALSE); /*  Silent option  */
EXTERN bool  print    INIT(FALSE); /*  Print debuging information  */
EXTERN bool  rules    INIT(TRUE);  /*  Use inbuilt rules  */
EXTERN bool  dotouch  INIT(FALSE); /*  Touch files instead of making  */
EXTERN bool  quest    INIT(FALSE); /*  Question up-to-dateness of file  */
EXTERN bool  useenv   INIT(FALSE); /*  Env. macro def. overwrite makefile def.*/
EXTERN bool  dbginfo  INIT(FALSE); /*  Print lot of debugging information */
EXTERN bool  ambigmac INIT(TRUE);  /*  guess undef. ambiguous macros (*,<) */
EXTERN struct name  *firstname;
EXTERN char         *str1;
EXTERN char         *str2;
EXTERN struct str    str1s;
EXTERN struct str    str2s;
EXTERN struct name **suffparray; /* ptr. to array of ptrs. to name chains */
EXTERN int           sizesuffarray INIT(20); /* size of suffarray */
EXTERN int           maxsuffarray INIT(0);   /* last used entry in suffarray */
EXTERN struct macro *macrohead;
EXTERN bool          expmake; /* TRUE if $(MAKE) has been expanded */
EXTERN char	    *makefile;     /*  The make file  */
EXTERN int           lineno;

#define  suffix(name)   strrchr(name,(int)'.')

EXTERN int _ctypech;
#define mylower(x)  (islower(_ctypech=(x)) ? _ctypech :tolower(_ctypech))
#define myupper(x)  (isupper(_ctypech=(x)) ? _ctypech :toupper(_ctypech))

/* Prototypes. */

struct sgtbuf;

/* check.c */

void prt(void);
void check(struct name *np);
void circh(void);
void precious(void);

/* input.c */

void init(void);
void strrealloc(struct str *strs);
struct name *newname(char *name);
struct name *testname(char *name);
struct depend *newdep(struct name *np, struct depend *dp);
struct cmd *newcmd(char *str, struct cmd *cp);
void newline(struct name *np, struct depend *dp, struct cmd *cp, int flag);
void input(FILE *fd);

/* macro.c */

struct macro *getmp(char *name);
char *getmacro(char *name);
struct macro *setmacro(char *name, char *val);
void setDFmacro(char *name, char *val);
void doexp(struct str *to, char *from);
void expand(struct str *strs);

/* main.c */

void main(int argc, char **argv);
void setoption(char option);
void usage(void);
void fatal(char *msg, char *a1, int a2);

/* make.c */

int dosh(char *string, char *shell);
int makeold(char *name);
void docmds1(struct name *np, struct line *lp);
void docmds(struct name *np);
int Tosexec(char *string);
time_t mstonix(unsigned int date, unsigned int time);
void getmdate(int fd, struct sgtbuf *tbp);
time_t cnvtime(struct sgtbuf *tbp);
void modtime(struct name *np);
void touch(struct name *np);
int make(struct name *np, int level);
void make1(struct name *np, struct line *lp, struct depend *qdp,
					char *basename, char *inputname);
void implmacros(struct name *np, struct line *lp,
					char **pbasename, char **pinputname);
void dbgprint(int level, struct name *np, char *comment);

/* reader.c */

void error(char *msg, char *a1);
bool getlin(struct str *strs, FILE *fd);
char *gettok(char **ptr);

/* rules.c */

bool dyndep(struct name *np, char **pbasename, char **pinputname);
void makerules(void);

/* archive.c */

int is_archive_ref(char *name);
int archive_stat(char *name, struct stat *stp);
