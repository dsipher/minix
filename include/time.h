/*****************************************************************************

  time.h                                            tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _TIME_H
#define _TIME_H

#include <sys/tahoe.h>

typedef long time_t;

struct tm
{
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
};

extern char *asctime(const struct tm *);
extern char *ctime(const time_t *);
extern struct tm *localtime(const time_t *);
extern struct tm *gmtime(const time_t *);
extern __size_t strftime(char *, __size_t, const char *, const struct tm *);
extern time_t time(time_t *);

extern char *tzname[];
extern long timezone;

extern void tzset(void);

#endif /* _TIME_H */

/* vi: set ts=4 expandtab: */
