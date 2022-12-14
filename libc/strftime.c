/*****************************************************************************

   strftime.c                                       minix standard library

******************************************************************************

   derived from COHERENT, Copyright (c) 1977-1995 by Robert Swartz.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

   3. Neither the name of the copyright holder nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

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

#include <stddef.h>
#include <string.h>
#include <time.h>

static const char *weekdays[] =
{
    "Sunday",       "Monday",       "Tuesday",      "Wednesday",
    "Thursday",     "Friday",       "Saturday"
};

static const char *months[] =
{
    "January",      "February",     "March",        "April",
    "May",          "June",         "July",         "August",
    "September",    "October",      "November",     "December"
};

/* convert i to n ascii decimal digits */

static char *toasc(int i, int n)
{
    static char buf[6];
    char *cp;

    cp = &buf[5];
    *cp = '\0';

    while (n--) {
        *--cp = '0' + (i % 10);
        i /= 10;
    }

    return cp;
}

/* convert a time or date to hh:mm:ss or mm/dd/yy */

static char *convert(int i1, int i2, int i3, int sep)
{
    static char buf[8];
    register char *s;

    s = &buf[0];
    *s++ = '0' + i1 / 10;
    *s++ = '0' + i1 % 10;
    *s++ = sep;
    *s++ = '0' + i2 / 10;
    *s++ = '0' + i2 % 10;
    *s++ = sep;
    *s++ = '0' + i3 / 10;
    *s++ = '0' + i3 % 10;

    return buf;
}

size_t strftime(char *s, size_t maxsize, const char *format,
                const struct tm *timeptr)
{
    size_t nchars, i;
    const char *x;
    int j;
    char c;

    for (nchars = 0;;) {
        if ((c = *format++) != '%') {
            if (++nchars > maxsize)
                return 0;

            *s++ = c;

            if (c == '\0')
                return --nchars;
        } else {
            x = 0;

            switch (c = *format++) {
            case 'a':
            case 'A':
                x = weekdays[timeptr->tm_wday];
                i = (c == 'a') ? 3 : strlen(x);
                break;

            case 'b':
            case 'B':
                x = months[timeptr->tm_mon];
                i = (c == 'b') ? 3 : strlen(x);
                break;

            case 'c':
                x = asctime(timeptr);
                i = 24;                 /* suppress the '\n' */
                break;

            case 'd':
                j = timeptr->tm_mday;
                i = 2;
                break;

            case 'H':
                j = timeptr->tm_hour;
                i = 2;
                break;

            case 'I':
                if ((j = timeptr->tm_hour % 12) == 0)
                    j = 12;

                i = 2;
                break;

            case 'j':
                j = timeptr->tm_yday + 1;
                i = 3;
                break;

            case 'm':
                j = timeptr->tm_mon + 1;
                i = 2;
                break;

            case 'M':
                j = timeptr->tm_min;
                i = 2;
                break;

            case 'p':
                x = (timeptr->tm_hour) < 12 ? "AM" : "PM";
                i = 2;
                break;

            case 'S':
                j = timeptr->tm_sec;
                i = 2;
                break;

            case 'U':
                j = (timeptr->tm_yday + 7 - timeptr->tm_wday) / 7;
                i = 2;
                break;

            case 'w':
                j = (timeptr->tm_yday + 8 - timeptr->tm_wday) / 7;

                if (timeptr->tm_wday == 0)
                    --j;

                i = 2;
                break;

            case 'W':
                j = timeptr->tm_wday;
                i = 1;
                break;

            case 'x':
                x = convert(timeptr->tm_mon+1,
                            timeptr->tm_mday,
                            timeptr->tm_year,
                            '/');
                i = 8;
                break;

            case 'X':
                x = convert(timeptr->tm_hour,
                            timeptr->tm_min,
                            timeptr->tm_sec,
                            ':');
                i = 8;
                break;

            case 'y':
                j = timeptr->tm_year;
                i = 2;
                break;

            case 'Y':
                j = timeptr->tm_year + 1900;
                i = 4;
                break;

            case 'z':
                x = &tzname[(timeptr->tm_isdst==1) ? 1 :0][0];
                i = strlen(x);
                break;

            /* in the Standard, the default case has undefined behavior. */
            /* we copy the given character, e.g. "%e" copies "e". */

            case '%':
            default:
                x = &c;
                i = 1;
                break;
            }

            /* Convert j to i ASCII digits if necessary. */

            if (x == 0)
                x = toasc(j, i);

            /* copy i characters from x to the result string. */
            /* if nchars+i == maxsize, there will be no room for NUL. */

            if ((nchars += i) >= maxsize)
                return 0;

            strncpy(s, x, i);
            s += i;
        }
    }
}

/* vi: set ts=4 expandtab: */
