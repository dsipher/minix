/*****************************************************************************

   make.c                                            jewel/os make utility

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

#include "h.h"
#include <sys/wait.h>
#include <unistd.h>

static void tellstatus(FILE *out, char *name, int status);

static bool  execflag;

/*
 *	Exec a shell that returns exit status correctly (/bin/esh).
 *	The standard EON shell returns the process number of the last
 *	async command, used by the debugger (ugg).
 *	[exec on eon is like a fork+exec on unix]
 */
int dosh(string, shell)
char *string;
char *shell;
{
  int number;

  return system(string);
}


/*
 *    Make a file look very outdated after an error trying to make it.
 *    Don't remove, this keeps hard links intact.  (kjb)
 */
int makeold(name) char *name;
{
  struct utimbuf a;

  a.actime = a.modtime = 0;	/* The epoch */

  return utime(name, &a);
}


static void tellstatus(out, name, status)
FILE *out;
char *name;
int status;
{
  char cwd[PATH_MAX];

  fprintf(out, "%s in %s: ",
	name, getcwd(cwd, sizeof(cwd)) == NULL ? "?" : cwd);

  if (WIFEXITED(status)) {
	fprintf(out, "Exit code %d", WEXITSTATUS(status));
  } else {
	fprintf(out, "Signal %d%s",
		WTERMSIG(status), status & 0x80 ? " - core dumped" : "");
  }
}


/*
 *	Do commands to make a target
 */
void docmds1(np, lp)
struct name *np;
struct line *lp;
{
  register char       *q;
  register char       *p;
  register struct cmd *cp;
  bool                 ssilent;
  bool                 signore;
  int                  estat;
  char                *shell;


  if (*(shell = getmacro("SHELL")) == '\0')
	shell = "/bin/sh";

  for (cp = lp->l_cmd; cp; cp = cp->c_next) {
	execflag = TRUE;
	strcpy(str1, cp->c_cmd);
	expmake = FALSE;
	expand(&str1s);
	q = str1;
	ssilent = silent;
	signore = ignore;
	while ((*q == '@') || (*q == '-')) {
		if (*q == '@')	   /*  Specific silent  */
			ssilent = TRUE;
		else		   /*  Specific ignore  */
			signore = TRUE;
		if (!domake) putchar(*q);  /* Show all characters. */
		q++;		   /*  Not part of the command  */
	}

	for (p=q; *p; p++) {
		if (*p == '\n' && p[1] != '\0') {
			*p = ' ';
			if (!ssilent || !domake)
				fputs("\\\n", stdout);
		}
		else if (!ssilent || !domake)
			putchar(*p);
	}
	if (!ssilent || !domake)
		putchar('\n');

	if (domake || expmake) {	/*  Get the shell to execute it  */
		fflush(stdout);
		if ((estat = dosh(q, shell)) != 0) {
		    if (estat == -1)
			fatal("Couldn't execute %s", shell,0);
		    else if (signore) {
			tellstatus(stdout, myname, estat);
			printf(" (Ignored)\n");
		    } else {
			tellstatus(stderr, myname, estat);
			fprintf(stderr, "\n");
			if (!(np->n_flag & N_PREC))
			    if (makeold(np->n_name) == 0)
				fprintf(stderr,"%s: made '%s' look old.\n", myname, np->n_name);
			if (!conterr) exit(estat != 0);
			np->n_flag |= N_ERROR;
			return;
		    }
		}
	}
  }
}


void docmds(np)
struct name *np;
{
  register struct line *lp;

  for (lp = np->n_line; lp; lp = lp->l_next)
	docmds1(np, lp);
}

/*
 *	Get the modification time of a file.  If the first
 *	doesn't exist, it's modtime is set to 0.
 */
void modtime(np)
struct name *np;
{
  struct stat info;
  int r;

  if (is_archive_ref(np->n_name)) {
	r = archive_stat(np->n_name, &info);
  } else {
	r = stat(np->n_name, &info);
  }
  if (r < 0) {
	if (errno != ENOENT)
		fatal("Can't open %s: %s", np->n_name, errno);

	np->n_time = 0L;
	np->n_flag &= ~N_EXISTS;
  } else {
	np->n_time = info.st_mtime;
	np->n_flag |= N_EXISTS;
  }
}


/*
 *	Update the mod time of a file to now.
 */
void touch(np)
struct name *np;
{
  char  c;
  int   fd;

  if (!domake || !silent) printf("touch(%s)\n", np->n_name);

  if (domake) {
	struct utimbuf   a;

	a.actime = a.modtime = time((time_t *)NULL);
	if (utime(np->n_name, &a) < 0)
		printf("%s: '%s' not touched - non-existant\n",
				myname, np->n_name);
  }
}


/*
 *	Recursive routine to make a target.
 */
int make(np, level)
struct name *np;
int          level;
{
  register struct depend  *dp;
  register struct line    *lp;
  register struct depend  *qdp;
  time_t  now, t, dtime = 0;
  bool    dbgfirst     = TRUE;
  char   *basename  = (char *) 0;
  char   *inputname = (char *) 0;

  if (np->n_flag & N_DONE) {
     if(dbginfo) dbgprint(level,np,"already done");
     return 0;
  }

  modtime(np);		/*  Gets modtime of this file  */

  while (time(&now) == np->n_time) {
     /* Time of target is equal to the current time.  This bothers us, because
      * we can't tell if it needs to be updated if we update a file it depends
      * on within a second.  So wait a second.  (A per-second timer is too
      * coarse for today's fast machines.)
      */
     sleep(1);
  }

  if (rules) {
     for (lp = np->n_line; lp; lp = lp->l_next)
        if (lp->l_cmd)
           break;
     if (!lp)
        dyndep(np,&basename,&inputname);
  }

  if (!(np->n_flag & (N_TARG | N_EXISTS))) {
     fprintf(stderr,"%s: Don't know how to make %s\n", myname, np->n_name);
     if (conterr) {
        np->n_flag |= N_ERROR;
        if (dbginfo) dbgprint(level,np,"don't know how to make");
        return 0;
     }
     else  exit(1);
  }

  for (qdp = (struct depend *)0, lp = np->n_line; lp; lp = lp->l_next) {
     for (dp = lp->l_dep; dp; dp = dp->d_next) {
        if(dbginfo && dbgfirst) {
           dbgprint(level,np," {");
           dbgfirst = FALSE;
        }
        make(dp->d_name, level+1);
        if (np->n_time < dp->d_name->n_time)
           qdp = newdep(dp->d_name, qdp);
        dtime = max(dtime, dp->d_name->n_time);
        if (dp->d_name->n_flag & N_ERROR) np->n_flag |= N_ERROR;
        if (dp->d_name->n_flag & N_EXEC ) np->n_flag |= N_EXEC;
     }
     if (!quest && (np->n_flag & N_DOUBLE) &&
           (np->n_time < dtime || !( np->n_flag & N_EXISTS))) {
        execflag = FALSE;
        make1(np, lp, qdp, basename, inputname); /* free()'s qdp */
        dtime = 0;
        qdp = (struct depend *)0;
        if(execflag) np->n_flag |= N_EXEC;
     }
  }

  np->n_flag |= N_DONE;

  if (quest) {
     t = np->n_time;
     np->n_time = now;
     return (t < dtime);
  }
  else if ((np->n_time < dtime || !( np->n_flag & N_EXISTS))
               && !(np->n_flag & N_DOUBLE)) {
     execflag = FALSE;
     make1(np, (struct line *)0, qdp, basename, inputname); /* free()'s qdp */
     np->n_time = now;
     if ( execflag) np->n_flag |= N_EXEC;
  }
  else if ( np->n_flag & N_EXEC ) {
     np->n_time = now;
  }

  if (dbginfo) {
     if(dbgfirst) {
        if(np->n_flag & N_ERROR)
              dbgprint(level,np,"skipped because of error");
        else if(np->n_flag & N_EXEC)
              dbgprint(level,np,"successfully made");
        else  dbgprint(level,np,"is up to date");
     }
     else {
        if(np->n_flag & N_ERROR)
              dbgprint(level,(struct name *)0,"} skipped because of error");
        else if(np->n_flag & N_EXEC)
              dbgprint(level,(struct name *)0,"} successfully made");
        else  dbgprint(level,(struct name *)0,"} is up to date");
     }
  }
  if (level == 0 && !(np->n_flag & N_EXEC))
     printf("%s: '%s' is up to date\n", myname, np->n_name);

  if(basename)
     free(basename);
  return 0;
}


void make1(np, lp, qdp, basename, inputname)
struct name *np;
struct line *lp;
register struct depend *qdp;
char        *basename;
char        *inputname;
{
  register struct depend *dp;


  if (dotouch)
    touch(np);
  else if (!(np->n_flag & N_ERROR)) {
    strcpy(str1, "");

    if(!inputname) {
       inputname = str1;  /* default */
       if (ambigmac) implmacros(np,lp,&basename,&inputname);
    }
    setDFmacro("<",inputname);

    if(!basename)
       basename = str1;
    setDFmacro("*",basename);

    for (dp = qdp; dp; dp = qdp) {
       if (strlen(str1))
          strcat(str1, " ");
       strcat(str1, dp->d_name->n_name);
       qdp = dp->d_next;
       free(dp);
    }
    setmacro("?", str1);
    setDFmacro("@", np->n_name);

    if (lp)		/* lp set if doing a :: rule */
       docmds1(np, lp);
    else
       docmds(np);
  }
}

void implmacros(np,lp, pbasename,pinputname)
struct name *np;
struct line *lp;
char        **pbasename;		/*  Name without suffix  */
char        **pinputname;
{
  struct line   *llp;
  register char *p;
  register char *q;
  register char *suff;				/*  Old suffix  */
  int            baselen;
  struct depend *dp;
  bool           dpflag = FALSE;

  /* get basename out of target name */
  p = str2;
  q = np->n_name;
  suff = suffix(q);
  while ( *q && (q < suff || !suff)) *p++ = *q++;
  *p = '\0';
  if ((*pbasename = (char *) malloc(strlen(str2)+1)) == (char *)0 )
     fatal("No memory for basename",(char *)0,0);
  strcpy(*pbasename,str2);
  baselen = strlen(str2);

  if ( lp)
     llp = lp;
  else
     llp = np->n_line;

  while (llp) {
     for (dp = llp->l_dep; dp; dp = dp->d_next) {
        if( strncmp(*pbasename,dp->d_name->n_name,baselen) == 0) {
           *pinputname = dp->d_name->n_name;
           return;
        }
        if( !dpflag) {
           *pinputname = dp->d_name->n_name;
           dpflag = TRUE;
        }
     }
     if (lp) break;
     llp = llp->l_next;
  }

#if NO_WE_DO_WANT_THIS_BASENAME
  free(*pbasename);  /* basename ambiguous or no dependency file */
  *pbasename = (char *)0;
#endif
  return;
}

void dbgprint(level,np,comment)
int          level;
struct name *np;
char        *comment;
{
  char *timep;

  if(np) {
     timep = ctime(&np->n_time);
     timep[24] = '\0';
     fputs(&timep[4],stdout);
  }
  else fputs("                    ",stdout);
  fputs("   ",stdout);
  while(level--) fputs("  ",stdout);
  if (np) {
     fputs(np->n_name,stdout);
     if (np->n_flag & N_DOUBLE) fputs("  :: ",stdout);
     else                       fputs("  : ",stdout);
  }
  fputs(comment,stdout);
  putchar((int)'\n');
  fflush(stdout);
  return;
}

