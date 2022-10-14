/*****************************************************************************

   macro.c                                           jewel/os make utility

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


static char   buf[256];

struct macro *getmp(name)
char *name;
{
  register struct macro *rp;

  for (rp = macrohead; rp; rp = rp->m_next)
		if (strcmp(name, rp->m_name) == 0)
			return rp;
  return (struct macro *)0;
}


char *getmacro(name)
char *name;
{
  struct macro *mp;

  if (mp = getmp(name))
		return mp->m_val;
/*	else*/
		return "";
}


struct macro *setmacro(name, val)
char *name;
char *val;
{
  register struct macro *rp;
  register char         *cp;


		/*  Replace macro definition if it exists  */
  for (rp = macrohead; rp; rp = rp->m_next)
	if (strcmp(name, rp->m_name) == 0) {
		if(rp->m_flag & M_OVERRIDE) return rp;	/* mustn't change */
		free(rp->m_val);	/*  Free space from old  */
		break;
		}

	if (!rp)		/*  If not defined, allocate space for new  */
	{
		if ((rp = (struct macro *)malloc(sizeof (struct macro)))
					 == (struct macro *)0)
			fatal("No memory for macro",(char *)0,0);

		rp->m_next = macrohead;
		macrohead = rp;
		rp->m_flag = FALSE;

		if ((cp = (char *) malloc(strlen(name)+1)) == (char *)0)
			fatal("No memory for macro",(char *)0,0);
		strcpy(cp, name);
		rp->m_name = cp;
	}

	if ((cp = (char *) malloc(strlen(val)+1)) == (char *)0)
		fatal("No memory for macro",(char *)0,0);
	strcpy(cp, val);		/*  Copy in new value  */
	rp->m_val = cp;

  return rp;
}


void setDFmacro(name, val)
char *name;
char *val;
{
  char        *c,*tmp;
  int          len;
  static char  filename[]="@F";
  static char  dirname[] ="@D";

  setmacro(name,val);
  *filename = *name;
  *dirname  = *name;
  /* Null string -- not defined macro */
  if ( !(*val)) {
     setmacro(filename,"");
     setmacro(dirname,"");
     return;
  }
  if (!(c = strrchr(val,(int)'/'))) {
     setmacro(filename,val);
     setmacro(dirname,"./");
     return;
  }
  setmacro(filename,c+1);
  len = c - val + 1;
  if((tmp = (char *) malloc(len + 1)) == (char *) 0)
     fatal("No memory for tmp",(char *)0,0);
  strncpy(tmp,val,len);
  tmp[len] = '\0';
  setmacro(dirname,tmp);
  free(tmp);
  return;
}

/*
 *	Do the dirty work for expand
 */
void doexp(to, from)
struct str *to;
char  *from;
{
  register char *rp;
  register char *p;
  char *q;
  struct macro *mp;


  rp = from;
  p  = &(*to->ptr)[to->pos];
  while (*rp) {
	if (*rp != '$') {
		*p++ = *rp++;
		to->pos++;
	}
	else {
		q = buf;
		if (*++rp == '{')
			while (*++rp && *rp != '}')
				*q++ = *rp;
		else if (*rp == '(')
			while (*++rp && *rp != ')')
				*q++ = *rp;
		else if (!*rp) {
			*p++ = '$';
			to->pos++;
			goto bail;
		}
		else
			*q++ = *rp;
		*q = '\0';
		if (*rp)
			rp++;
		if (!(mp = getmp(buf)))
			mp = setmacro(buf, "");
		if (mp->m_flag & M_MARK)
			fatal("Infinitely recursive macro %s", mp->m_name,0);
		mp->m_flag |= M_MARK;
		if ( mp->m_flag & M_MAKE) expmake = TRUE;
		doexp(to, mp->m_val);
		p = &(*to->ptr)[to->pos];
		mp->m_flag &= ~M_MARK;
	}
  bail:
	if (to->pos >= to->len) {
		strrealloc(to);
		p = &(*to->ptr)[to->pos];
	}
  }
  *p = '\0';
}


/*
 *	Expand any macros in str.
 */
void expand(strs)
struct str *strs;
{
  char  *a;

  if ((a = (char *) malloc(strlen(*strs->ptr)+1)) == (char *)0)
     fatal("No memory for temporary string",(char *)0,0);
  strcpy(a, *strs->ptr);
  strs->pos = 0;
  doexp(strs, a);
  free(a);
}
