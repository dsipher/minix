/*****************************************************************************

  sys/types.h                                       tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_TYPES_H
#define _SYS_TYPES_H

#include <sys/tahoe.h>

#ifndef __MODE_T
#define __MODE_T
typedef __mode_t mode_t;
#endif /* __MODE_T */

#ifndef __OFF_T
#define __OFF_T
typedef __off_t off_t;
#endif /* __OFF_T */

#ifndef __SSIZE_T
#define __SSIZE_T
typedef __ssize_t ssize_t;
#endif /* __SSIZE_T */

#endif /* _SYS_TYPES_H */

/* vi: set ts=4 expandtab: */
