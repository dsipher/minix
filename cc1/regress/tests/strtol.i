# 1 "strtol.c"

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
# 15 "strtol.c"
static unsigned long __strtoul(const char *nptr, char **endptr,
                               int base, int uflag)
{
    const char *cp;
    unsigned long val;
    int c, sign, overflow, pflag, dlimit, ulimit, llimit;
    unsigned long quot, rem;

    cp = nptr;
    val = pflag = overflow = sign = 0;



    while (((__ctype+1)[c = *cp++]&0x08))
        ;



    switch(c) {
    case '-':
        sign = 1;

    case '+':
        c = *cp++;
    }



    if (base == 0) {
        if (c == '0')
            base = (*cp == 'x' || *cp == 'X') ? 16 : 8;
        else if (((unsigned) ((c)-'0') < 10))
            base = 10;
        else {
            cp = nptr;
            goto done;
        }
    }



    if (base == 16 && c == '0' && (*cp == 'x' || *cp == 'X')) {
        ++pflag;
        ++cp;
        c = *cp++;
    }



    dlimit = '0' + base;
    ulimit = 'A' + base - 10;
    llimit = 'a' + base - 10;




    if (!((((unsigned) ((c)-'0') < 10) && c < dlimit)
      || (((unsigned) ((c)-'A') < 26) && c < ulimit)
      || (((unsigned) ((c)-'a') < 26) && c < llimit))) {
        cp = (pflag) ? cp - 2 : nptr;
        goto done;
    }




    if (uflag) {
        quot = 18446744073709551615UL / base;
        rem = 18446744073709551615UL % base;
    } else {
        quot = 9223372036854775807L / base;
        rem = 9223372036854775807L % base;
    }



    for (;; c = *cp++) {
        if (((unsigned) ((c)-'0') < 10) && c < dlimit)
            c -= '0';
        else if (((unsigned) ((c)-'A') < 26) && c < ulimit)
            c -= 'A'-10;
        else if (((unsigned) ((c)-'a') < 26) && c < llimit)
            c -= 'a'-10;
        else {
            --cp;
            break;
        }

    if (val < quot || (val == quot && c <= rem))
        val = val * base + c;
    else
        ++overflow;
    }

done:



    if (endptr != (char **) 0)
        *endptr = (char *) cp;

    if (overflow) {
        errno = 34;

        if (uflag)
            return 18446744073709551615UL;

        return sign ? (-9223372036854775807L - 1L) : 9223372036854775807L;
    }

    return sign ? -val : val;
}


long strtol(const char *nptr, char **endptr, int base)
{
        return __strtoul(nptr, endptr, base, 0);
}

unsigned long strtoul(const char *nptr, char **endptr, int base)
{
        return __strtoul(nptr, endptr, base, 1);
}
