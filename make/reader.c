/*****************************************************************************

   reader.c                                             minix make utility

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
 *	Syntax error handler.  Print message, with line number, and exits.
 */
void error(msg, a1)
char *msg;
char *a1;
{
  fprintf(stderr, "%s: ", myname);
  fprintf(stderr, msg, a1);
  if (lineno)  fprintf(stderr, " in %s near line %d", makefile, lineno);
  fputc('\n', stderr);
  exit(1);
}


/*
 *	Read a line into the supplied string.  Remove
 *	comments, ignore blank lines. Deal with	quoted (\) #, and
 *	quoted newlines.  If EOF return TRUE.
 *
 *	The comment handling code has been changed to leave comments and
 *	backslashes alone in shell commands (lines starting with a tab).
 *	This is not what POSIX wants, but what all makes do.  (KJB)
 */
bool getlin(strs, fd)
struct str *strs;
FILE *fd;
{
  register char *p;
  char          *q;
  int            c;

  for (;;) {
	strs->pos = 0;
	for (;;) {
		do {
			if (strs->pos >= strs->len)
				strrealloc(strs);
			if ((c = getc(fd)) == EOF)
				return TRUE;		/* EOF */
			(*strs->ptr)[strs->pos++] = c;
		} while (c != '\n');

		lineno++;

		if (strs->pos >= 2 && (*strs->ptr)[strs->pos - 2] == '\\') {
			(*strs->ptr)[strs->pos - 2] = '\n';
			strs->pos--;
		} else {
			break;
		}
	}

	if (strs->pos >= strs->len)
		strrealloc(strs);
	(*strs->ptr)[strs->pos] = '\0';

	p = q =  *strs->ptr;
	while (isspace(*q)) q++;
	if (*p != '\t' || *q == '#') {
		while (((q = strchr(p, '#')) != (char *)0) &&
		    (p != q) && (q[-1] == '\\'))
		{
			char	*a;

			a = q - 1;	/*  Del \ chr; move rest back  */
			p = q;
			while (*a++ = *q++)
				;
		}
		if (q != (char *)0)
			{
			q[0] = '\n';
			q[1] = '\0';
		}
	}

	p = *strs->ptr;
	while (isspace(*p))	/*  Checking for blank  */
		p++;

	if (*p != '\0')
		return FALSE;
  }
}


/*
 *	Get a word from the current line, surounded by white space.
 *	return a pointer to it. String returned has no white spaces
 *	in it.
 */
char  *gettok(ptr)
register char **ptr;
{
  register char *p;


  while (isspace(**ptr))	/*  Skip spaces  */
	(*ptr)++;

  if (**ptr == '\0')	/*  Nothing after spaces  */
	return ((char *)NULL);

  p = *ptr;		/*  word starts here  */

  while ((**ptr != '\0') && (!isspace(**ptr)))
	(*ptr)++;	/*  Find end of word  */

  *(*ptr)++ = '\0';	/*  Terminate it  */

  return(p);
}
