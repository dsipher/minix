# 1 "fflush.c"

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
# 24 "/home/charles/xcc/include/unistd.h"
typedef __ssize_t ssize_t;




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
# 13 "fflush.c"
int fflush(FILE *fp)
{
    int count;
    int c1;
    int i;
    int retval = 0;

    if (fp == 0) {
        for (i = 0; i < 20; i++)
            if (__iotab[i] && fflush(__iotab[i]))
                retval = (-1);

        return retval;
    }

    if (!fp->_buf ||
      (!(fp->_flags & 0x080)
      && !(fp->_flags & 0x100)))
        return 0;

    if (fp->_flags & 0x080) {

        int adjust = 0;

        if (fp->_buf && !(fp->_flags & 0x004))
            adjust = -fp->_count;

        fp->_count = 0;

        if (lseek(fp->_fd, adjust, 1) == -1) {
            fp->_flags |= 0x020;
            return (-1);
        }

        if (fp->_flags & 0x002)
            fp->_flags &= ~(0x080 | 0x100);

        fp->_ptr = fp->_buf;
        return 0;
    } else if (fp->_flags & 0x004)
        return 0;

    if (fp->_flags & 0x001)
        fp->_flags &= ~0x100;

    count = fp->_ptr - fp->_buf;
    fp->_ptr = fp->_buf;

    if (count <= 0)
        return 0;

    if (fp->_flags & 0x200) {
        if (lseek(fp->_fd, 0L, 2) == -1) {
            fp->_flags |= 0x020;
            return (-1);
        }
    }

    c1 = write(fp->_fd, fp->_buf, count);
    fp->_count = 0;

    if (count == c1)
        return 0;

    fp->_flags |= 0x020;
    return (-1);
}

void __stdio_cleanup(void)
{
    int i;

    for (i = 0; i < 20; i++)
        if (__iotab[i] && (__iotab[i]->_flags & 0x100))
            fflush(__iotab[i]);
}
