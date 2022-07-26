# 1 "brk.c"

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
# 19 "/home/charles/xcc/include/unistd.h"
typedef __size_t size_t;




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
# 13 "/home/charles/xcc/include/errno.h"
extern int errno;
# 13 "brk.c"
void *sbrk(ssize_t inc)
{
    char *old;
    char *new;

    old = __brk(0);

    if (inc != 0) {
        new = __brk(old + inc);

        if (new == old) {
            errno = 12;
            return (void *) -1;
        }
    }

    return old;
}

int brk(void *addr)
{
    char *new;

    new = __brk(addr);

    if (new < (char *) addr) {
        errno = 12;
        return -1;
    }

    return 0;
}
