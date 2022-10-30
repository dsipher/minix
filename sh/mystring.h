/*****************************************************************************

   mystring.h                                                  ux/64 shell

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

#define strchr mystrchr

#ifdef __STDC__
void scopyn(const char *, char *, int);
char *strchr(const char *, int);
void mybcopy(const pointer, pointer, int);
int prefix(const char *, const char *);
int number(const char *);
int is_number(const char *);
int strcmp(const char *, const char *); /* from C library */
char *strcpy(char *, const char *); /* from C library */
int strlen(const char *);       /* from C library */
char *strcat(char *, const char *); /* from C library */
char *strerror(int);            /* from C library */
#else
void scopyn();
char *strchr();
void mybcopy();
int prefix();
int number();
int is_number();
int strcmp();
char *strcpy();
int strlen();
char *strcat();
char *strerror();
#endif

#define equal(s1, s2)   (strcmp(s1, s2) == 0)
#define scopy(s1, s2)   ((void)strcpy(s2, s1))
#define bcopy(src, dst, n)  mybcopy((pointer)(src), (pointer)(dst), n)

/* vi: set ts=4 expandtab: */
