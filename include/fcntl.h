/*****************************************************************************

  fcntl.h                                           tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _FCNTL_H
#define _FCNTL_H

#include <sys/tahoe.h>

#ifndef __MODE_T
#define __MODE_T
typedef __mode_t mode_t;
#endif /* __MODE_T */

int creat(const char *, mode_t);
int open(const char *, int, ...);

#define O_RDONLY    00000000
#define O_WRONLY    00000001
#define O_RDWR      00000002
#define O_CREAT     00000100
#define O_TRUNC     00001000
#define O_APPEND    00002000

#endif /* _FCNTL_H */

/* vi: set ts=4 expandtab: */
