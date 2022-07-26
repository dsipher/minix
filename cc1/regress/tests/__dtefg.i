# 1 "__dtefg.c"

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
# 18 "/home/charles/xcc/include/stdio.h"
typedef __off_t fpos_t;



typedef __size_t size_t;








typedef struct __iobuf
{
    int _count;
    int _fd;
    int _flags;
    int _bufsiz;
    unsigned char *_buf;
    unsigned char *_ptr;
} FILE;

















extern FILE *__iotab[20];
extern FILE __stdin, __stdout, __stderr;








extern int __fillbuf(FILE *);
extern int __flushbuf(int, FILE *);

extern void clearerr(FILE *);
extern int fclose(FILE *);
extern int fflush(FILE *);
extern int fileno(FILE *);
extern char *fgets(char *, int n, FILE *);
extern int fgetpos(FILE *, fpos_t *);
extern int fsetpos(FILE *, fpos_t *);
extern int fprintf(FILE *, const char *, ...);
extern int fputc(int, FILE *);
extern int fputs(const char *, FILE *);
extern FILE *fopen(const char *, const char *);
extern size_t fread(void *, size_t, size_t, FILE *);
extern int fscanf(FILE *, const char *, ...);
extern int fseek(FILE *, long, int);
extern long ftell(FILE *);
extern size_t fwrite(const void *, size_t, size_t, FILE *);
extern char *gets(char *);
extern int printf(const char *, ...);
extern int puts(const char *);
extern int remove(const char *);
extern void rewind(FILE *);
extern int rename(const char *, const char *);
extern int scanf(const char *, ...);
extern int sscanf(const char *, const char *, ...);
extern void setbuf(FILE *, char *);
extern int setvbuf(FILE *, char *, int, size_t);
extern int sprintf(char *, const char *, ...);
extern int ungetc(int, FILE *);
extern int vfprintf(FILE *, const char *, __va_list);
extern int vfscanf(FILE *, const char *, __va_list);
extern int vsprintf(char *, const char *, __va_list);
# 29 "/home/charles/xcc/include/stdlib.h"
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
# 13 "/home/charles/xcc/include/math.h"
extern double __huge_val;
extern double __frexp_adj;



extern char *__dtefg(char *, double *, int, int, int, int *);

extern double modf(double, double *);
extern double frexp(double, int *);
extern double __pow10(int);







union __ieee_double
{
    double value;

    struct
    {
        int lsw;
        int msw;
    } words;

    struct
    {
        unsigned manl : 32;
        unsigned manh : 20;
        unsigned exp : 11;
        unsigned sign : 1;
    } bits;
};
# 23 "__dtefg.c"
static char *dtof(char *buf, char *cp, int prec,
                  int decexp, int fmt, int aflag)
{
    if (decexp < 0)
        *buf++ = '0';
    else
        do
            *buf++ = *cp ? *cp++ : '0';
        while (decexp--);

    if (!aflag && (prec == 0 || ((fmt=='g'|| fmt=='G') && *cp == '\0')))
        return buf;

    *buf++ = '.';

    while (prec-- > 0) {
        if ((fmt=='g' || fmt=='G') && *cp == '\0' && !aflag)
            break;

        if (++decexp < 0)
            *buf++ = '0';
        else
            *buf++ = *cp ? *cp++ : '0';
    }

    return buf;
}
















static void dtoa(int fmt, double *dp, int prec, int *decexpp, char *buf)
{
    char *cp;
    int digit;
    int decexp;
    int ndigits;
    int binexp;
    double d;
    double dexp;



    cp = buf;
    if ((d = *dp) == 0.0) {
ret0:
        *decexpp = 0;
        *cp++ = '0';
        *cp ='\0';
        return;
    }





    frexp(d, &binexp);

    if (modf((--binexp)/0.33219280948873623e+01, &dexp) < 0.0)
        dexp -= 1.0;

    decexp = dexp;
    d *= __pow10(-decexp);

    if (d >= 10) {
        ++decexp;
        d *= 0.10;
    }

    *decexpp = decexp;



    if (fmt == 'e' || fmt == 'E')
        ndigits = prec + 1;
    else if (fmt == 'f')
        ndigits = prec + decexp + 1;
    else
        ndigits = prec;
    if (ndigits <= 0) {
        if (ndigits == 0 && d > 5.0)
            goto ret1;
        else
            goto ret0;
    } else if (ndigits > 15)
        ndigits = 15;



    for ( ; cp < &buf[ndigits] && d != 0.0; ) {
        digit = (int) d;
        *cp++ = digit + '0';
        d = 10.0 * (d-digit);
    }

    *cp = '\0';



    if (d <= 5.0) {
        while (--cp != buf && *cp == '0')
            *cp = '\0';

        return;
    }

    while (cp-- != buf) {
        if (++*cp <= '9')
            return;

        *cp = '\0';
    }

    ++cp;

ret1:
    ++*decexpp;
    *cp++ = '1';
    *cp = '\0';
}












char *__dtefg(char *cp, double *dp, int fmt, int prec, int aflag, int *signp)
{
    int eflag, decexp;
    char tbuf[15+1];
    double d;

    d = *dp;

    if (prec == 0 && (fmt == 'g' || fmt == 'G'))
        prec = 1;
    else if (prec == -1)
        prec = 6;

    if (d < 0.0) {
        d = -d;
        *signp = -1;
    } else
        *signp = 1;

    dtoa(fmt, &d, prec, &decexp, tbuf);

    eflag = (fmt=='e' || fmt=='E'
          || ((fmt=='g' || fmt=='G') && (decexp < -4 || decexp >= prec)));

    cp = dtof(cp, tbuf, prec, eflag ? 0 : decexp, fmt, aflag);

    if (eflag) {
        *cp++ = (fmt == 'E' || fmt == 'G') ? 'E' : 'e';
        cp += sprintf(cp, "%+03d", decexp);
    }

    return cp;
}
