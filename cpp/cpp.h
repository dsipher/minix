/*****************************************************************************

  cpp.h                                               tahoe/64 c preprocessor

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef CPP_H
#define CPP_H

#include <stdlib.h>

#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(*(a)))

#define NR_MACRO_BUCKETS 64
#define RESYNC_WINDOW 20

extern char need_resync;
extern char cxx_mode;

void *safe_malloc(size_t);
void error(char *, ...);

#endif /* CPP_H */

/* vi: set ts=4 expandtab: */
