# 1 "ctime.c"

# 15 "/home/charles/xcc/include/sys/jewel.h"
typedef long            __blkcnt_t;
typedef long            __blksize_t;
typedef unsigned long   __dev_t;
typedef unsigned        __gid_t;
typedef unsigned long   __ino_t;
typedef unsigned        __mode_t;
typedef unsigned long   __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 19 "/home/charles/xcc/include/stdlib.h"
typedef __size_t size_t;









extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void __exit(int);
extern void exit(int);

extern void free(void *);
extern char *getenv(const char *);
extern void *malloc(size_t);
extern float strtof(const char *, char **);
extern double strtod(const char *, char **);
extern long strtol(const char *, char **, int);
extern unsigned long strtoul(const char *, char **, int);

extern void qsort(void *, size_t, size_t,
                  int (*compar)(const void *, const void *));



extern int rand(void);
extern void srand(unsigned);
# 15 "/home/charles/xcc/include/time.h"
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
# 41 "ctime.c"
static char tzdstdef[] = "1.1.4:-1.1.10:2:60......";






static char daynames[3 * 7 + 1] = "SunMonTueWedThuFriSat";
static char dpm[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
static int dstadjust = 60 * 60;
static char dsthour = 2;

static struct dsttimes {
    char dst_occur;
    char dst_day;
    char dst_month;
} dsttimes[2] = {
    {  1, 0, 3 },
    { -1, 0, 9 }
};

static char months[3 * 12 + 1] = "JanFebMarAprMayJunJulAugSepOctNovDec";
static char timestr[] = "AAA AAA DD DD:DD:DD DDDD\n";
static struct tm tm;

static char tz0[31 + 1] = "GMT";
static char tz1[31 + 1] = "";

long timezone;
char *tzname[2] = { tz0, tz1 };



static int isleap(int yr)
{
    if (yr % 4000 == 0)
        return 0;

    return (yr % 400 == 0 || (yr % 100 != 0 && yr % 4 == 0));
}




static int nthday(struct dsttimes *dp)
{
    int nthday;
    int nth;

    if ((nth = dp->dst_occur) == 0)
        return dp->dst_day;

    nthday = tm.tm_mday - tm.tm_wday + dp->dst_day;

    if (nth > 0) {
        while (nthday > 0)
            nthday -= 7;

        do
            nthday += 7;
        while (--nth > 0);

    } else {
        while (nthday < dpm[tm.tm_mon])
            nthday += 7;

        do
            nthday -= 7;
        while (++nth < 0);
    }

    return nthday;
}






static int isdaylight(void)
{
    int month, start, end, xday;

    if (tzname[1][0] == 0)
        return 0;

    month = tm.tm_mon;
    start = dsttimes[0].dst_month;
    end = dsttimes[1].dst_month;

    if ((start <= end && (month < start || month > end))
      || (start > end && (month < start && month > end)))
        return 0;
    else if (month == start) {
        xday = nthday(&dsttimes[0]);

        if (tm.tm_mday != xday)
            return (tm.tm_mday > xday);

        return (tm.tm_hour >= dsthour);
    } else if (month == end) {
        xday = nthday(&dsttimes[1]);

        if (tm.tm_mday != xday)
            return (tm.tm_mday < xday);

        return (tm.tm_hour < dsthour-1);
    } else
        return 1;
}





static void setdst(char *cp1)
{


    if (*cp1) {
        dsttimes[0].dst_occur = atoi(cp1); while (*cp1 && *cp1++ != ('.'));
        dsttimes[0].dst_day = atoi(cp1)-1; while (*cp1 && *cp1++ != ('.'));
        dsttimes[0].dst_month = atoi(cp1)-1; while (*cp1 && *cp1++ != (':'));
    }



    if (*cp1) {
        dsttimes[1].dst_occur = atoi(cp1); while (*cp1 && *cp1++ != ('.'));
        dsttimes[1].dst_day = atoi(cp1) - 1; while (*cp1 && *cp1++ != ('.'));
        dsttimes[1].dst_month = atoi(cp1) - 1; while (*cp1 && *cp1++ != (':'));
    }



    if (*cp1) {
        dsthour = atoi(cp1); while (*cp1 && *cp1++ != (':'));
    }



    if (*cp1)
        dstadjust = atoi(cp1) * 60;
}



void tzset(void)
{
    char *cp1, *cp2;
    static int tzset = 0;

    if (tzset)
        return;

    tzset = 1;

    if ((cp1 = getenv("TIMEZONE")) == 0)
        return;

    timezone = 0;



    cp2 = tzname[0];

    while (*cp1 && *cp1 != ':' && cp2 < &tzname[0][31])
        *cp2++ = *cp1++;

    *cp2++ = '\0';

    while (*cp1 && *cp1++ != ':')
        ;



    timezone = atoi(cp1) * 60L;

    while (*cp1 && *cp1++ != ':')
        ;



    cp2 = tzname[1];

    while (*cp1 && *cp1 != ':' && cp2 < &tzname[1][31])
        *cp2++ = *cp1++;

    *cp2++ = '\0';

    while (*cp1 && *cp1++ != ':')
        ;



    if (tzname[1][0] == '\0')
        return;

    setdst(tzdstdef);
    setdst(cp1);
}



struct tm *gmtime(const time_t *tp)
{
    long xtime;
    unsigned days;
    long secs;
    int year;
    int ydays;
    int wday;
    char *mp;

    if ((xtime = *tp) < 0)
        xtime = 0;

    days = xtime / (60L * 60L * 24L);
    secs = xtime % (60L * 60L * 24L);
    tm.tm_hour = secs / (60L * 60L);
    secs = secs % (60L * 60L);
    tm.tm_min = secs / 60;
    tm.tm_sec = secs % 60;






    wday = (4 + days) % 7;
    year = 1970;

    for (;;) {
        ydays = isleap(year) ? 366 : 365;

        if (days < ydays)
            break;

        year++;
        days -= ydays;
    }

    tm.tm_year = year - 1900;
    tm.tm_yday = days;
    tm.tm_wday = wday;





    if (isleap(year))
        dpm[1] = 29;
    else
        dpm[1] = 28;

    for (mp = &dpm[0]; mp < &dpm[12] && days >= *mp; mp++)
        days -= *mp;

    tm.tm_mon = mp - dpm;
    tm.tm_mday = days + 1;
    return &tm;
}




struct tm *localtime(const time_t *tp)
{
    time_t ltime;

    tzset();
    ltime = *tp - timezone;
    gmtime(&ltime);

    if (isdaylight()) {
        ltime = *tp - timezone + dstadjust;
        gmtime(&ltime);
        tm.tm_isdst = 1;
    } else
        tm.tm_isdst = 0;

    return &tm;
}






char *asctime(const struct tm *tmp)
{
    char *cp, *xp;
    unsigned i;

    cp = timestr;



    if ((i = tmp->tm_wday) >= 7)
        i = 0;

    xp = &daynames[i * 3];
    *cp++ = *xp++;
    *cp++ = *xp++;
    *cp++ = *xp++;
    *cp++ = ' ';



    if ((i = tmp->tm_mon) >= 12)
        i = 0;

    xp = &months[i * 3];
    *cp++ = *xp++;
    *cp++ = *xp++;
    *cp++ = *xp++;
    *cp++ = ' ';



    if ((i = tmp->tm_mday) >= 10)
        *cp++ = ((i / 10)+'0');
    else
        *cp++ = ' ';

    *cp++ = ((i % 10)+'0');
    *cp++ = ' ';



    *cp++ = (((i = tmp->tm_hour) / 10)+'0');
    *cp++ = ((i % 10)+'0');
    *cp++ = ':';
    *cp++ = (((i = tmp->tm_min) / 10)+'0');
    *cp++ = ((i % 10)+'0');
    *cp++ = ':';
    *cp++ = (((i = tmp->tm_sec) / 10)+'0');
    *cp++ = ((i % 10)+'0');
    *cp++ = ' ';



    i = tmp->tm_year + 1900;
    *cp++ = ((i / 1000)+'0');
    i = i % 1000;
    *cp++ = ((i / 100)+'0');
    i = i % 100;
    *cp++ = ((i / 10)+'0');
    *cp++ = ((i % 10)+'0');
    *cp++ = '\n';
    *cp++ = '\0';

    return timestr;
}




char *ctime(const time_t *tp)
{
    return asctime(localtime(tp));
}
