/*****************************************************************************

   check.c                                           jewel/os make utility

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


/*
 *	Prints out the structures as defined in memory.  Good for check
 *	that you make file does what you want (and for debugging make).
 */
void prt()
{
  register struct name   *np;
  register struct depend *dp;
  register struct line   *lp;
  register struct cmd    *cp;
  register struct macro  *mp;

  register int   		i;

  for (mp = macrohead; mp; mp = mp->m_next)
	printf("%s = %s\n", mp->m_name, mp->m_val);

  putchar('\n');

  for (i = 0; i <= maxsuffarray ; i++)
	    for (np = suffparray[i]->n_next; np; np = np->n_next)
	    {
		if (np->n_flag & N_DOUBLE)
			printf("%s::\n", np->n_name);
		else
			printf("%s:\n", np->n_name);
		if (np == firstname)
			printf("(MAIN NAME)\n");
		for (lp = np->n_line; lp; lp = lp->l_next)
		{
			putchar(':');
			for (dp = lp->l_dep; dp; dp = dp->d_next)
				printf(" %s", dp->d_name->n_name);
			putchar('\n');

			for (cp = lp->l_cmd; cp; cp = cp->c_next)
#ifdef os9
				printf("-   %s\n", cp->c_cmd);
#else
				printf("-\t%s\n", cp->c_cmd);
#endif
			putchar('\n');
		}
		putchar('\n');
	    }
}


/*
 *	Recursive routine that does the actual checking.
 */
void check(np)
struct name *np;
{
  register struct depend *dp;
  register struct line   *lp;


	if (np->n_flag & N_MARK)
		fatal("Circular dependency from %s", np->n_name,0);

	np->n_flag |= N_MARK;

	for (lp = np->n_line; lp; lp = lp->l_next)
		for (dp = lp->l_dep; dp; dp = dp->d_next)
			check(dp->d_name);

	np->n_flag &= ~N_MARK;
}


/*
 *	Look for circular dependancies.
 *	ie.
 *		a: b
 *		b: a
 *	is a circular dep
 */
void circh()
{
  register struct name *np;
  register int          i;


  for (i = 0; i <= maxsuffarray ; i++)
	   for (np = suffparray[i]->n_next; np; np = np->n_next)
		check(np);
}


/*
 *	Check the target .PRECIOUS, and mark its dependentd as precious
 */
void precious()
{
  register struct depend *dp;
  register struct line   *lp;
  register struct name   *np;


  if (!((np = newname(".PRECIOUS"))->n_flag & N_TARG))
	return;

  for (lp = np->n_line; lp; lp = lp->l_next)
	for (dp = lp->l_dep; dp; dp = dp->d_next)
		dp->d_name->n_flag |= N_PREC;
}
