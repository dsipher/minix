# 1 "fopen.c"

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
# 17 "/home/charles/xcc/include/sys/types.h"
typedef __mode_t mode_t;




typedef __off_t off_t;




typedef __ssize_t ssize_t;
# 20 "/home/charles/xcc/include/fcntl.h"
int creat(const char *, mode_t);
int open(const char *, int, ...);
# 29 "/home/charles/xcc/include/unistd.h"
typedef __pid_t pid_t;











extern int access(const char *, int);





extern void *__brk(void *);

extern int brk(void *);
extern void *sbrk(__ssize_t);

extern int close(int);
extern int execve(const char *, char *const [], char *const []);
extern int execvp(const char *, char *const []);
extern int execvpe(const char *, char *const [], char *const []);
extern pid_t fork(void);
extern pid_t getpid(void);
extern int isatty(int);





extern __off_t lseek(int, __off_t, int);

extern __ssize_t read(int, void *, __size_t);
extern int unlink(const char *);
extern __ssize_t write(int, const void *, __size_t);

extern char *optarg;
extern int optind;
extern int opterr;
extern int optopt;

extern int getopt(int, char *const[], const char *);
# 29 "fopen.c"
FILE *fopen(const char *name, const char *mode)
{
    int i;
    int rwmode = 0;
    int rwflags = 0;
    FILE *fp;
    int fd;
    int flags = 0;

    for (i = 0; __iotab[i] != 0; i++)
        if (i >= (20 - 1))
            return 0;

    switch (*mode++)
    {
    case 'r':
        flags |= 0x001 | 0x080;
        rwmode = 00000000;
        break;
    case 'w':
        flags |= 0x002 | 0x100;
        rwmode = 00000001;
        rwflags = 00000100 | 00001000;
        break;
    case 'a':
        flags |= 0x002 | 0x100 | 0x200;
        rwmode = 00000001;
        rwflags |= 00002000 | 00000100;
        break;
    default:
        return 0;
    }

    while (*mode) {
        switch(*mode++) {
        case 'b':
            continue;
        case '+':
            rwmode = 00000002;
            flags |= 0x001 | 0x002;
            continue;

        default:
            break;
        }
        break;
    }




    if ((rwflags & 00001000)
      || (((fd = open(name, rwmode)) < 0)
      && (rwflags & 00000100))) {
        if (((fd = creat(name, 0666)) > 0) && flags  | 0x001) {
            close(fd);
            fd = open(name, rwmode);
        }
    }

    if (fd < 0)
        return 0;

    if ((fp = malloc(sizeof(FILE))) == 0) {
        close(fd);
        return 0;
    }

    if ((flags & (0x001 | 0x002)) == (0x001 | 0x002))
        flags &= ~(0x080 | 0x100);

    fp->_count = 0;
    fp->_fd = fd;
    fp->_flags = flags;
    fp->_buf = 0;
    __iotab[i] = fp;
    return fp;
}
