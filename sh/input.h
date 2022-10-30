/*****************************************************************************

   input.h                                                     ux/64 shell

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

/* PEOF (the end of file marker) is defined in syntax.h */

/*
 * The input line number.  Input.c just defines this variable, and saves
 * and restores it when files are pushed and popped.  The user of this
 * package must set its value.
 */
extern int plinno;
extern int parsenleft;      /* number of characters left in input buffer */
extern char *parsenextc;    /* next character in input buffer */


#ifdef __STDC__
char *pfgets(char *, int);
int pgetc(void);
int preadbuffer(void);
void pungetc(void);
void ppushback(char *, int);
void setinputfile(char *, int);
void setinputfd(int, int);
void setinputstring(char *, int);
void popfile(void);
void popallfiles(void);
void closescript(void);
#else
char *pfgets();
int pgetc();
int preadbuffer();
void pungetc();
void ppushback();
void setinputfile();
void setinputfd();
void setinputstring();
void popfile();
void popallfiles();
void closescript();
#endif

#define pgetc_macro()   (--parsenleft >= 0? *parsenextc++ : preadbuffer())

/* vi: set ts=4 expandtab: */