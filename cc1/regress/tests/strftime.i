# 1 "strftime.c"

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
# 19 "/home/charles/xcc/include/stddef.h"
typedef __size_t size_t;


typedef long ptrdiff_t;
# 20 "/home/charles/xcc/include/string.h"
extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);
extern char *strcat(char *, const char *);
extern char *strchr(const char *, int);
extern int strcmp(const char *, const char *);
extern char *strcpy(char *, const char *);
extern char *strerror(int);
extern size_t strlen(const char *);
extern char *strncat(char *, const char *, size_t);
extern int strncmp(const char *, const char *, size_t);
extern char *strncpy(char *, const char *, size_t);
extern char *strrchr(const char *, int);
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
# 14 "strftime.c"
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
                i = 24;
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




            case '%':
            default:
                x = &c;
                i = 1;
                break;
            }



            if (x == 0)
                x = toasc(j, i);




            if ((nchars += i) >= maxsize)
                return 0;

            strncpy(s, x, i);
            s += i;
        }
    }
}
