/*****************************************************************************

   time.h                                              minix system header

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

#ifndef _TIME_H
#define _TIME_H

#include <sys/defs.h>

#ifndef __TIME_T
#define __TIME_T
typedef __time_t time_t;
#endif /* __TIME_T */

#ifndef __SIZE_T
#define __SIZE_T
typedef __size_t size_t;
#endif /* __SIZE_T */

struct tm
{
    int tm_sec;         /* seconds after the minute [0, 61] */
    int tm_min;         /* minutes after the hour [0, 59] */
    int tm_hour;        /* hours since midnight [0, 23] */
    int tm_mday;        /* day of the month [1, 31] */
    int tm_mon;         /* months since January [0, 11] */
    int tm_year;        /* years since 1900 */
    int tm_wday;        /* days since Sunday [0, 6] */
    int tm_yday;        /* days since Janaury 1 [0, 365] */
    int tm_isdst;       /* Daylight Savings Time flag */
};

struct timespec
{
    time_t  tv_sec;         /* seconds */
    long    tv_nsec;        /* nanoseconds */
};

/* converts the broken-down time in the structure
   pointed to by `timeptr' into a string in the form

          "Sun Sep 16 01:03:52 1973\n"

   (with the implied NUL terminator) */

extern char *asctime(const struct tm *timeptr);

/* converts the calendar time pointed to by `timer' to
   local time in the form of a string. equivalent to:

            asctime(localtime(timer))

   (and in fact, implemented in exactly this way) */

extern char *ctime(const time_t *timer);

/* converts the calendar time pointed to by `timer'
   into a broken-down time, expressed as local time */

extern struct tm *localtime(const time_t *timer);

/* converts the caledar time pointed to by `timer'
   into a broken-down time, expressed as UTC */

extern struct tm *gmtime(const time_t *timer);

/* a sprintf()-style function to format
   the data in `timeptr' as a string */

extern size_t strftime(char *s, size_t maxsize, const char *format,
                       const struct tm *timeptr);

/* determines the current calendar time as
   seconds since midnight Jan 1 1970 UTC */

extern time_t time(time_t *timer);

/* some variables set by tzset() */

extern char *tzname[];      /* e.g. { "EST", "EDT" } */
extern long timezone;       /* seconds west of UTC */

/* uses the value of the environment variable `TIMEZONE'
   to set time-conversion data for local timezone. n.b.
   this is not-quite-POSIX: POSIX uses a `TZ' variable
   with a different format. see libc/strftime.c for the
   format of `TIMEZONE'. */

extern void tzset(void);

/* suspend the current process until the interval `rqtp'
   has elapsed (or an unmasked signal is delivered) */

int nanosleep(const struct timespec *rqtp, struct timespec *rtmp);

#endif /* _TIME_H */

/* vi: set ts=4 expandtab: */
