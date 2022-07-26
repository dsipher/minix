/*****************************************************************************

  stddef.h                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _STDDEF_H
#define _STDDEF_H

#include <sys/tahoe.h>

#define NULL __NULL

#ifndef __SIZE_T
#define __SIZE_T
typedef __size_t size_t;
#endif /* __SIZE_T */

typedef long ptrdiff_t;

#define offsetof(t, m)  ((size_t) (((char *) &((t *) 0)->m) - ((char *) 0)))

#endif /* _STDDEF_H */

/* vi: set ts=4 expandtab: */
