/*****************************************************************************

   limits.h                                            ux/64 system header

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

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

/* values required by POSIX.1-1990, see table 2-3 */

#define _POSIX_ARG_MAX          4096
#define _POSIX_CHILD_MAX        6
#define _POSIX_LINK_MAX         8
#define _POSIX_MAX_CANON        255
#define _POSIX_MAX_INPUT        255
#define _POSIX_NAME_MAX         14
#define _POSIX_NGROUPS_MAX      0
#define _POSIX_OPEN_MAX         16
#define _POSIX_PATH_MAX         255
#define _POSIX_PIPE_BUF         512
#define _POSIX_SSIZE_MAX        LONG_MAX
#define _POSIX_STREAM_MAX       8
#define _POSIX_TZNAME_MAX       3

#define NAME_MAX    28                  /* dictated by fs; see <sys/fs.h> */

#define OPEN_MAX    _POSIX_OPEN_MAX     /* these should be the same, and */
#define STREAM_MAX  _POSIX_OPEN_MAX     /* must be == FOPEN_MAX (stdio.h) */

#define PATH_MAX    _POSIX_PATH_MAX

#endif /* _LIMITS_H */

/* vi: set ts=4 expandtab: */
