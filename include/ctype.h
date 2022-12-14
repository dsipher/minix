/*****************************************************************************

   ctype.h                                             minix system header

******************************************************************************

   derived from MINIX 2, Copyright (c) 1987, 1997 by Prentice Hall.

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

#ifndef _CTYPE_H
#define _CTYPE_H

extern char __ctype[];

#define _U  0x01    /* upper-case letters [A-Z] */
#define _L  0x02    /* lower-case letters [a-z] */
#define _N  0x04    /* numbers [0-9] */
#define _S  0x08    /* white space \t \n \f etc */
#define _P  0x10    /* punctuation characters */
#define _C  0x20    /* control characters */
#define _X  0x40    /* hex digits [a-f] and [A-F] */

extern int isalnum(int);
extern int isalpha(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int tolower(int);
extern int toupper(int);

#define isalnum(c)      ((__ctype+1)[c]&(_U|_L|_N))
#define isalpha(c)      ((__ctype+1)[c]&(_U|_L))
#define iscntrl(c)      ((__ctype+1)[c]&_C)
#define isdigit(c)      ((__ctype+1)[c]&_N)
#define isgraph(c)      ((__ctype+1)[c]&(_P|_U|_L|_N))
#define islower(c)      ((__ctype+1)[c]&_L)
#define ispunct(c)      ((__ctype+1)[c]&_P)
#define isspace(c)      ((__ctype+1)[c]&_S)
#define isupper(c)      ((__ctype+1)[c]&_U)
#define isxdigit(c)     ((__ctype+1)[c]&(_N|_X))

#define isprint(c)      ((unsigned) ((c)-' ') < 95)
#define isascii(c)      ((unsigned) (c) < 128)

#endif /* _CTYPE_H */

/* vi: set ts=4 expandtab: */
