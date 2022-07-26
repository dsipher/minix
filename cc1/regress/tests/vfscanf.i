# 1 "vfscanf.c"

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
# 21 "/home/charles/xcc/include/stdarg.h"
typedef __va_list va_list;
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
# 51 "vfscanf.c"
static int dscan(char *buf, FILE *fp, int width, double *dp)
{
    int c, state, count;
    char *cp;

    cp = buf;

    for (state = count = 0; count < width; ++count) {
        *cp++ = c = (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++) : __fillbuf(fp));
        switch (c) {
        case '+': case '-':

            if (state != 0 && state != 6)
                break;

            state++;
            continue;

        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9':

            if (state == 0 || state == 1 || state == 3)
                state = 3;
            else if (state == 2 || state == 4 || state == 5)
                state = 5;
            else if (state == 6 || state == 7)
                state = 7;
            else
                break;

            continue;

        case 'E': case 'e':

            if (state < 3 || 5 < state)
                break;

            state = 6;
            continue;

        default:
            if (c != '.')
                break;

            if (state <= 1)
                state = 2;
            else if (state == 3)
                state++;
            else
                break;

            continue;
        }

        --cp;
        ungetc(c, fp);
        break;
    }

    *cp = '\0';
    *dp = strtod(buf, 0);
    return ((int)(cp - buf));
}
# 138 "vfscanf.c"
static int lscan(char *buf, FILE *fp, int base, int width, int flag, long *lp)
{
    int c, state, count;
    char *cp;

    cp = buf;
    state = (base == 0) ? 0 : (base == 16) ? 6 : 3;

    for (count = 0; count < width; ++count) {
        *cp++ = c = (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++) : __fillbuf(fp));

        switch(c) {
        case '+':
        case '-':
            if (state != 0 && state != 3 && state != 6)
                break;
            ++state;
            continue;

        case '0':
            if (state <= 1)
                state = 2;
            else if (state == 2) {
                base = 8;
                state = 5;
            } else if (state <= 5 || state == 8)
                state = 5;
            else
                state = 8;

            continue;

        case 'x':
        case 'X':
            if (state == 2) {
                base = 16;
                state = 5;
            } else if (state == 8)
                state = 5;
            else
                break;

            continue;

        default:
            if (state <= 2) {
                if (((unsigned) ((c)-'0') < 10)) {
                    base = 10;
                    state = 5;
                } else
                    break;

                continue;
            }

            if ((((unsigned) ((c)-'0') < 10) && c-'0' < base)
              || (((unsigned) ((c)-'a') < 26) && c-'a'+10 < base)
              || (((unsigned) ((c)-'A') < 26) && c-'A'+10 < base))
                state = 5;
            else
                break;

            continue;
        }

        --cp;
        ungetc(c, fp);
        break;
    }

    *cp = '\0';

    if (flag)
        *lp = strtol(buf, 0, base);
    else
        *lp = strtoul(buf, 0, base);

    return (int)(cp - buf);
}




int vfscanf(FILE *fp, const char *format, va_list args)
{
    int fc, gc;
    char *cp;
    int base, width, count, nitems, n, sflag, lflag, flag;
    long val;
    double d;
    char buf[128];

    for (nitems = count = 0; fc = *format++; ) {
        if (((__ctype+1)[fc]&0x08)) {
            while (((__ctype+1)[gc = (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++) : __fillbuf(fp))]&0x08))
                ++count;

            if (gc == (-1))
                break;

            ungetc(gc, fp);
            continue;
        } else if (fc != '%') {
matchin:
            if ((gc=(--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++) : __fillbuf(fp))) != fc) {
                ungetc(gc, fp);
                break;
            }

            count++;
            continue;
        } else {


            flag = sflag = lflag = 0;

            if ((fc = *format++) == '*') {
                ++sflag;
                fc = *format++;
            }

            if (((unsigned) ((fc)-'0') < 10))
                for (width = 0; ((unsigned) ((fc)-'0') < 10); fc = *format++)
                    width = width*10 + fc - '0';
            else
                width = -1;

            if (fc == 'h' || fc == 'l' || fc == 'L') {
                lflag = fc;
                fc = *format++;
            }



            if (fc != '[' && fc != 'c' && fc != 'n') {
                while (((__ctype+1)[gc = (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++) : __fillbuf(fp))]&0x08))
                    ++count;

                ungetc(gc, fp);
            }




            switch (fc) {
            default:
            case '\0':
                break;

            case 'd':
                base = 10;
                ++flag;
                goto fixed;

            case 'i':
                base = 0;
                ++flag;
                goto fixed;

            case 'o':
                base = 8;
                goto fixed;

            case 'u':
                base = 10;
                goto fixed;

            case 'X':
            case 'x':
                base = 16;
fixed:
                if (width == -1 || width > 128)
                    width = 128;

                if ((n = lscan(buf, fp, base, width, flag, &val)) == 0)
                    break;

                count += n;

                if (sflag)
                    continue;

                if (lflag == 'p')
                    *(((args += (((sizeof(void **)) + (8 - 1)) & ~(8 - 1))), *((void ** *) (args - (((sizeof(void **)) + (8 - 1)) & ~(8 - 1)))))) = (void *)val;
                else if (lflag == 'l')
                    *(((args += (((sizeof(long *)) + (8 - 1)) & ~(8 - 1))), *((long * *) (args - (((sizeof(long *)) + (8 - 1)) & ~(8 - 1)))))) = val;
                else if (lflag == 'h')
                    *(((args += (((sizeof(short *)) + (8 - 1)) & ~(8 - 1))), *((short * *) (args - (((sizeof(short *)) + (8 - 1)) & ~(8 - 1)))))) = (short)val;
                else
                    *(((args += (((sizeof(int *)) + (8 - 1)) & ~(8 - 1))), *((int * *) (args - (((sizeof(int *)) + (8 - 1)) & ~(8 - 1)))))) = (int)val;

                nitems++;
                continue;

            case 'e':
            case 'f':
            case 'g':
            case 'E':
            case 'G':
                if (width == -1 || width > 128)
                    width = 128;

                if ((n = dscan(buf, fp, width, &d)) == 0)
                    break;

                count += n;

                if (sflag)
                    continue;

                if (lflag == 'l' || lflag == 'L')
                    *(((args += (((sizeof(double *)) + (8 - 1)) & ~(8 - 1))), *((double * *) (args - (((sizeof(double *)) + (8 - 1)) & ~(8 - 1)))))) = d;
                else
                    *(((args += (((sizeof(float *)) + (8 - 1)) & ~(8 - 1))), *((float * *) (args - (((sizeof(float *)) + (8 - 1)) & ~(8 - 1)))))) = d;

                nitems++;
                continue;

            case 's':
scanin:
                if (!sflag)
                    cp = ((args += (((sizeof(char *)) + (8 - 1)) & ~(8 - 1))), *((char * *) (args - (((sizeof(char *)) + (8 - 1)) & ~(8 - 1)))));

                for (n = 0; width < 0 || n < width; n++) {
                    if ((gc = (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++) : __fillbuf(fp))) == (-1))
                        break;

                    if ((fc == 's' && ((__ctype+1)[gc]&0x08))
                      || (fc == '['
                      && flag != (strchr(buf, gc)==0))) {
                        ungetc(gc, fp);
                        break;
                    }

                    if (!sflag)
                        *cp++ = gc;
                }

                if (n == 0)
                    break;

                count += n;

                if (sflag)
                    continue;

                if (fc != 'c')
                    *cp = '\0';

                nitems++;
                continue;

            case '[':


                flag = 0;

                if ((fc = *format++) == '^') {
                    ++flag;
                    fc = *format++;
                }



                cp = buf;

                if (fc == ']') {
                    *cp++ = fc;
                    fc = *format++;
                }

                while (fc != '\0' && fc != ']') {


                    if (fc == '-' && cp != buf && *format != ']') {
                        gc = *(cp-1);
                        fc = *format++;

                        if (gc > fc)
                            --cp;
                        else while (++gc <= fc)
                            *cp++ = gc;
                    } else
                        *cp++ = fc;

                    fc = *format++;
                }

                *cp = '\0';
                fc = '[';
                goto scanin;

            case 'c':
                if (width == -1)
                    width = 1;

                goto scanin;

            case 'p':
                width = 16 + 2;
                base = 16;
                lflag = 'p';
                goto fixed;

            case 'n':
                if (lflag == 'l')
                    *(((args += (((sizeof(long *)) + (8 - 1)) & ~(8 - 1))), *((long * *) (args - (((sizeof(long *)) + (8 - 1)) & ~(8 - 1)))))) = (long)count;
                else if (lflag == 'h')
                    *(((args += (((sizeof(short *)) + (8 - 1)) & ~(8 - 1))), *((short * *) (args - (((sizeof(short *)) + (8 - 1)) & ~(8 - 1)))))) = (short)count;
                else
                    *(((args += (((sizeof(int *)) + (8 - 1)) & ~(8 - 1))), *((int * *) (args - (((sizeof(int *)) + (8 - 1)) & ~(8 - 1)))))) = count;

                continue;

            case '%':
                goto matchin;
            }

            break;
        }
        break;
    }

    return (nitems==0 && (((fp)->_flags & 0x010) != 0)) ? (-1) : nitems;
}
