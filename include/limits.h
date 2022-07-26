/*****************************************************************************

  limits.h                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _LIMITS_H
#define _LIMITS_H

#define SCHAR_MAX   127
#define SCHAR_MIN   -128
#define UCHAR_MAX   255

#define CHAR_BIT    8
#define CHAR_MAX    SCHAR_MAX
#define CHAR_MIN    SCHAR_MIN

#define SHRT_MIN    -32768
#define SHRT_MAX    32767
#define USHRT_MAX   65535

#define INT_MAX     2147483647
#define INT_MIN     (-INT_MAX - 1)
#define UINT_MAX    4294967295U

#define LONG_MAX    9223372036854775807L
#define LONG_MIN    (-LONG_MAX - 1L)
#define ULONG_MAX   18446744073709551615UL

#define PATH_MAX    256

#endif /* _LIMITS_H */

/* vi: set ts=4 expandtab: */
