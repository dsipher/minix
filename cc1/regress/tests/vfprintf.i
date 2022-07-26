# 1 "vfprintf.c"

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
# 21 "/home/charles/xcc/include/stdarg.h"
typedef __va_list va_list;
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
# 24 "vfprintf.c"
static const char digits[] = {
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
};

static const char ldigits[] = {
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
};




static char *convert(char *cp, unsigned long n, unsigned b, int c)
{
    char *ep;
    const char *dp;
    char pbuf[23];

    dp = (c == 'x') ? ldigits : digits;
    ep = &pbuf[23-1];
    *ep = '\0';

    do {
        *--ep = dp[n%b];
    } while ((n /= b) != 0);

    while (*ep)
        *cp++ = *ep++;

    return cp;
}

int vfprintf(FILE *fp, const char *format, va_list args)
{
    char cbuf[512];
    char *cbp;
    char *cbs;
    char *s;
    int count, c;
    long l;
    int fwidth, prec, base, len;
    int leftjustify, plusflag, spaceflag, altflag, longflag;
    int padchar, padwidth, issigned, prefix, ispfx, nzeros;
    double d;

    count = 0;

    for (;;) {



        while ((c = *format++) != '%') {
            if (c == '\0')
                return count;

            ++count;
            (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (c)) : __flushbuf((c),(fp)));
        }



        leftjustify = plusflag = spaceflag = altflag = 0;
        padchar = ' ';

        for (;;) {
            switch(c = *format++) {
            case '-':   ++leftjustify; continue;
            case '+':   ++plusflag; continue;
            case ' ':   ++spaceflag; continue;
            case '#':   ++altflag; continue;
            case '0':   padchar = '0'; continue;
            default:    break;
            }
            break;
        }



        if (c == '*') {
            if ((fwidth = ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))))) < 0) {
                leftjustify = 1;
                fwidth = -fwidth;
            }
            c = *format++;
        } else
            for (fwidth = 0; c >= '0' && c <= '9'; c = *format++)
                fwidth = fwidth*10 + c-'0';



        if (c == '.') {
            c = *format++;
            if (c == '*') {
                prec = ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))));

                if (prec < 0)
                    prec = -1;

                c = *format++;
            } else
                for (prec=0; c>='0' && c<='9'; c = *format++)
                    prec = prec*10 + c-'0';
        } else
            prec = -1;



        if (c == 'l' || c == 'h' || c == 'L' || c == 'z') {
            if (c == 'z')
                c = (sizeof(size_t) == 8) ? 'l' : 0;
            else
                longflag = c;

            c = *format++;
        } else
            longflag = 0;



        cbp = cbs = cbuf;
        issigned = nzeros = prefix = ispfx = 0;

        switch (c) {
        case 'd':
        case 'i':
            base = 10;

            if (longflag=='l')
                l = ((args += (((sizeof(long)) + (8 - 1)) & ~(8 - 1))), *((long *) (args - (((sizeof(long)) + (8 - 1)) & ~(8 - 1)))));
            else
                l = (long) ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))));

            if (longflag == 'h')
                l = (short) l;

            if (l < 0L) {
                l = -l;
                --issigned;
            } else
                ++issigned;

            goto conv;

        case 'o':
            base = 8;
            goto unsconv;

        case 'u':
            base = 10;
            goto unsconv;

        case 'x':
        case 'X':
            base = 16;

unsconv:
            if (longflag=='l')
                l = ((args += (((sizeof(long)) + (8 - 1)) & ~(8 - 1))), *((long *) (args - (((sizeof(long)) + (8 - 1)) & ~(8 - 1)))));
            else
                l = (unsigned long) ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))));

            if (longflag == 'h')
                l = (unsigned short) l;

            if (altflag && ((l != 0L && base == 8) || base == 16))
                prefix = c;

conv:
            if (prec == 0 && l == 0L)
                break;

            if (prec != -1)
                padchar = ' ';

            cbp = convert(cbp, l, base, c);

            if ((nzeros = prec - (cbp - cbs)) < 0)
                nzeros = 0;

            break;

        case 'f':
        case 'e':
        case 'E':
        case 'g':
        case 'G':
            d = ((args += (((sizeof(double)) + (8 - 1)) & ~(8 - 1))), *((double *) (args - (((sizeof(double)) + (8 - 1)) & ~(8 - 1)))));
            cbp = __dtefg(cbp, &d, c, prec, altflag, &issigned);
            break;

        case 'c':
            *cbp++ = (unsigned char) ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))));
            break;

        case 's':
            if ((s = ((args += (((sizeof(char *)) + (8 - 1)) & ~(8 - 1))), *((char * *) (args - (((sizeof(char *)) + (8 - 1)) & ~(8 - 1)))))) == ((void *) 0))
                s = "{NULL}";

            cbp = cbs = s;

            while (*cbp++ != '\0')
                if ((prec >= 0) && ((cbp - s) > prec))
                    break;

            cbp--;
            break;

        case 'p':
            longflag = 'l';
            prec = 16;
            ++altflag;
            c = 'X';
            base = 16;
            goto unsconv;

        case 'n':
            if (longflag == 'h')
                *(((args += (((sizeof(short *)) + (8 - 1)) & ~(8 - 1))), *((short * *) (args - (((sizeof(short *)) + (8 - 1)) & ~(8 - 1)))))) = (short)count;
            else if (longflag == 'l')
                *(((args += (((sizeof(long *)) + (8 - 1)) & ~(8 - 1))), *((long * *) (args - (((sizeof(long *)) + (8 - 1)) & ~(8 - 1)))))) = (long)count;
            else
                *(((args += (((sizeof(int *)) + (8 - 1)) & ~(8 - 1))), *((int * *) (args - (((sizeof(int *)) + (8 - 1)) & ~(8 - 1)))))) = count;
            break;

        default:
            ++count;
            (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (c)) : __flushbuf((c),(fp)));
            continue;
        }



        len = cbp - cbs;

        if (issigned && (issigned == -1 || plusflag || spaceflag)) {
            ++len;
            ++ispfx;
        }

        if (prefix) {
            ++len;
            ++ispfx;

            if (prefix != 'o')
                ++len;
        }

        if ((padwidth = fwidth - nzeros - len) < 0)
            padwidth = 0;

        count += len + padwidth + nzeros;

        if (!leftjustify && padwidth > 0) {
            if (ispfx && padchar == '0')
                nzeros += padwidth;
            else
                while (padwidth-- > 0)
                    (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (padchar)) : __flushbuf((padchar),(fp)));
        }

        if (issigned) {
            if (issigned == -1)
                (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('-')) : __flushbuf(('-'),(fp)));
            else if (plusflag)
                (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('+')) : __flushbuf(('+'),(fp)));
            else if (spaceflag)
                (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (' ')) : __flushbuf((' '),(fp)));
        }

        if (prefix) {
            (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('0')) : __flushbuf(('0'),(fp)));

            if (prefix != 'o')
                (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (prefix)) : __flushbuf((prefix),(fp)));
        }

        while (nzeros-- > 0)
            (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('0')) : __flushbuf(('0'),(fp)));

        len = cbp - cbs;

        while (len-- > 0)
            (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (*cbs++)) : __flushbuf((*cbs++),(fp)));

        if (leftjustify)
            while (padwidth-- > 0)
                (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (' ')) : __flushbuf((' '),(fp)));
    }
}
