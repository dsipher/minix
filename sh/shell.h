/*****************************************************************************

   shell.h                                                     ux/64 shell

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

/*
 * The follow should be set to reflect the type of system you have:
 *  JOBS -> 1 if you have Berkeley job control, 0 otherwise.
 *  UDIR -> 1 if you want the shell to simulate the /u directory.
 *  TILDE -> 1 if you want the shell to expand ~logname.
 *  USEGETPW -> 1 if getpwnam() must be used to look up a name.
 *  SHORTNAMES -> 1 if your linker cannot handle long names.
 *  define BSD if you are running 4.2 BSD or later.
 *  define SYSV if you are running under System V.
 *  define DEBUG=1 to compile in debugging (set global "debug" to turn on)
 *  define DEBUG=2 to compile in and turn on debugging.
 *
 * When debugging is on, debugging info will be written to $HOME/trace and
 * a quit signal will generate a core dump.
 */


#define JOBS      0
#define UDIR      0
#define TILDE     1
#define USEGETPW  0
#define HASHBANG  0
/* #define BSD */
#define POSIX     1
#define DEBUG     0

#ifdef __STDC__
typedef void *pointer;
#ifndef NULL
#define NULL (void *)0
#endif
#else /* not __STDC__ */
typedef char *pointer;
#ifndef NULL
#define NULL 0
#endif
#endif /*  not __STDC__ */
#define STATIC  /* empty */
#define MKINIT  /* empty */

#include <sys/cdefs.h>

extern char nullstr[1];     /* null string */


#if DEBUG
#define TRACE(param)    trace param
#else
#define TRACE(param)
#endif

/* vi: set ts=4 expandtab: */
