/*****************************************************************************

  ctype.h                                           tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

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
#define isgraph(c)      ((__ctype+1)[c]&(_P|_U|_L|_N))
#define ispunct(c)      ((__ctype+1)[c]&_P)
#define isspace(c)      ((__ctype+1)[c]&_S)
#define isxdigit(c)     ((__ctype+1)[c]&(_N|_X))

#define isdigit(c)      ((unsigned) ((c)-'0') < 10)
#define islower(c)      ((unsigned) ((c)-'a') < 26)
#define isupper(c)      ((unsigned) ((c)-'A') < 26)
#define isprint(c)      ((unsigned) ((c)-' ') < 95)
#define isascii(c)      ((unsigned) (c) < 128)

#endif /* _CTYPE_H */

/* vi: set ts=4 expandtab: */
