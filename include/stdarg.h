/*****************************************************************************

  stdarg.h                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _STDARG_H
#define _STDARG_H

#include <sys/tahoe.h>

#define __VA_ALIGNMENT  8

#define __VA_PAD(x)     (((x) + (__VA_ALIGNMENT - 1)) & ~(__VA_ALIGNMENT - 1))

#ifndef __VA_LIST
#define __VA_LIST
typedef __va_list va_list;
#endif /* __VA_LIST */

#define va_start(ap, last)          (ap = (((char *) &(last))               \
                                     + __VA_PAD(sizeof(last))))

#define va_arg(ap, type)        ((ap += __VA_PAD(sizeof(type))),            \
                                 *((type *) (ap - __VA_PAD(sizeof(type)))))

#define va_end(ap)

#endif /* _STDARG_H */

/* vi: set ts=4 expandtab: */
