/*****************************************************************************

   syntax.c                                                    ux/64 shell

******************************************************************************

   derived from ash, contributed to Berkeley by Kenneth Almquist.
   Copyright (c) 1991 The Regents of the University of California.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#include <sys/cdefs.h>
/* Syntax classes */
#define CWORD 0			/* character is nothing special */
#define CNL 1			/* newline character */
#define CBACK 2			/* a backslash character */
#define CSQUOTE 3		/* single quote */
#define CDQUOTE 4		/* double quote */
#define CENDQUOTE 5		/* a terminating quote */
#define CBQUOTE 6		/* backwards single quote */
#define CVAR 7			/* a dollar sign */
#define CENDVAR 8		/* a '}' character */
#define CEOF 9			/* end of file */
#define CCTL 10			/* like CWORD, except it must be escaped */
#define CSPCL 11		/* these terminate a word */

/* Syntax classes for is_ functions */
#define ISDIGIT 01		/* a digit */
#define ISUPPER 02		/* an upper case letter */
#define ISLOWER 04		/* a lower case letter */
#define ISUNDER 010		/* an underscore */
#define ISSPECL 020		/* the name of a special parameter */

#define SYNBASE 129
#define PEOF -129


#define BASESYNTAX (basesyntax + SYNBASE)
#define DQSYNTAX (dqsyntax + SYNBASE)
#define SQSYNTAX (sqsyntax + SYNBASE)

#define is_digit(c)	((unsigned)((c) - '0') <= 9)
#define is_alpha(c)	((is_type+SYNBASE)[c] & (ISUPPER|ISLOWER))
#define is_name(c)	((is_type+SYNBASE)[c] & (ISUPPER|ISLOWER|ISUNDER))
#define is_in_name(c)	((is_type+SYNBASE)[c] & (ISUPPER|ISLOWER|ISUNDER|ISDIGIT))
#define is_special(c)	((is_type+SYNBASE)[c] & (ISSPECL|ISDIGIT))
#define digit_val(c)	((c) - '0')

extern const char basesyntax[];
extern const char dqsyntax[];
extern const char sqsyntax[];
extern const char is_type[];

/* vi: set ts=4 expandtab: */
