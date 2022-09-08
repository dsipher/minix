# 1 "strtod.c"

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
# 14 "/home/charles/xcc/include/ctype.h"
extern char __ctype[];









extern int isalnum(int);
extern int isalpha(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int tolower(int);
extern int toupper(int);
# 13 "/home/charles/xcc/include/errno.h"
extern int errno;
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
# 28 "strtod.c"
double strtod(const char *nptr, char **endptr)
{
    const char *cp;
    const char *savcp;
    int c, flag, eexp;
    unsigned long val;
    int exp, edigits, sdigits, vdigits;
    double d;

    cp = nptr;
    val = flag = exp = sdigits = vdigits = 0;
    d = 0;

    while (((__ctype+1)[c = *cp++]&0x08))
        ;

    switch (c)
    {
    case '-':
        flag |= ( 0x00000001 );

    case '+':
        c = *cp++;
    }




    if (!((unsigned) ((c)-'0') < 10) && ((c != '.') || ((c == '.') && !((unsigned) ((*cp)-'0') < 10)))) {
        cp = nptr;
        goto done;
    }





    for (; ; c = *cp++) {
        if (((unsigned) ((c)-'0') < 10)) {
            c -= '0';

            if (c == 0 && (flag & ( 0x00000002 ))) {


                const char *look;
                int d;

                for (look = cp; (d = *look++) == '0'; )
                    ;

                if (!((unsigned) ((d)-'0') < 10)) {
                    cp = look;
                    c = d;
                    break;
                }
            }

            if (sdigits != 0 || c != 0)
                ++sdigits;

            if (val > (18446744073709551615UL - 9) / 10) {

                if (flag & ( 0x00000008 ))
                    d = d * __pow10(vdigits) + val;
                else {
                    d = val;
                    flag |= ( 0x00000008 );
                }

                vdigits = 1;
                val = c;
            } else {
                ++vdigits;
                val = val * 10 + c;
            }

            if (flag & ( 0x00000002 ))
                --exp;
        } else if (c == '.' && (flag & ( 0x00000002 )) == 0)
            flag |= ( 0x00000002 );
        else
            break;
    }



    if (flag & ( 0x00000008 ))
        d = d * __pow10(vdigits) + val;
    else
        d = val;



    if (c == 'e'  ||  c == 'E') {
        savcp = cp - 1;

        switch (c = *cp++) {
        case '-':
            flag |= ( 0x00000004 );

        case '+':
            c = *cp++;
        }



        if (!((unsigned) ((c)-'0') < 10)) {
            cp = savcp;
            goto done;
        }



        for (eexp = edigits = 0; ((unsigned) ((c)-'0') < 10); c = *cp++) {
            if (edigits != 0 || c != '0')
                ++edigits;

            eexp = eexp * 10 + c - '0';
        }

        if (edigits > 3) {
            flag |= ((flag & ( 0x00000004 )) ? ( 0x00000020 ) : ( 0x00000010 ));
            --cp;
            goto done;
        }



        if (flag & ( 0x00000004 ))
            exp -= eexp;
        else
            exp += eexp;
    }
    --cp;



    if (exp <= -307)
        flag |= ( 0x00000020 );
    else if (exp + sdigits - 1 >= 308)
        flag |= ( 0x00000010 );
    else if (exp != 0)
        d *= __pow10(exp);

done:
    if (endptr != 0)
        *endptr = (char *) cp;

    if (flag & ( 0x00000020 )) {
        errno = 34;
        return 0.0;
    }

    if (flag & ( 0x00000010 )) {
        errno = 34;
        d = (__huge_val);
    }

    return ((flag & ( 0x00000001 )) ? -d : d);
}
