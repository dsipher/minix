# 1 "qsort.c"

# 15 "/home/charles/xcc/include/sys/tahoe.h"
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
# 12 "qsort.c"
static int (*qcompar)(const char *, const char *);

static void qexchange(char *p, char *q, size_t n)
{
    int c;

    while (n-- > 0) {
        c = *p;
        *p++ = *q;
        *q++ = c;
    }
}

static void q3exchange(char *p, char *q, char *r, size_t n)
{
    int c;

    while (n-- > 0) {
        c = *p;
        *p++ = *r;
        *r++ = *q;
        *q++ = c;
    }
}

static void qsort1(char *a1, char *a2, size_t width)
{
    char *left, *right;
    char *lefteq, *righteq;
    int cmp;

    for (;;) {
        if (a2 <= a1)
            return;

        left = a1;
        right = a2;
        lefteq = righteq = a1 + width * (((a2 - a1) + width) / (2 * width));







again:
        while (left < lefteq && (cmp = (*qcompar)(left, lefteq)) <= 0) {
            if (cmp < 0) {


                left += width;
            } else {



                lefteq -= width;
                qexchange(left, lefteq, width);
            }
        }

        while (right > righteq) {
            if ((cmp = (*qcompar)(right, righteq)) < 0) {


                if (left < lefteq) {



                    qexchange(left, right, width);
                    left += width;
                    right -= width;
                    goto again;
                }






                righteq += width;
                q3exchange(left, righteq, right, width);
                lefteq += width;
                left = lefteq;
            } else if (cmp == 0) {



                righteq += width;
                qexchange(right, righteq, width);
            } else
                right -= width;
        }

        if (left < lefteq) {




            lefteq -= width;
            q3exchange(right, lefteq, left, width);
            righteq -= width;
            right = righteq;
            goto again;
        }



        qsort1(a1, lefteq - width, width);




        a1 = righteq + width;
    }
}

void qsort(void *base, size_t nel, size_t width,
           int (*compar)(const void *, const void *))
{
    if (!nel)
        return;

    qcompar = (int (*)(const char *, const char *)) compar;
    qsort1(base, (char *) base + (nel - 1) * width, width);
}
