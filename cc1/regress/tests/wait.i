# 1 "wait.c"

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
# 17 "/home/charles/xcc/include/sys/wait.h"
typedef __pid_t pid_t;









extern pid_t wait(int *);
extern pid_t waitpid(pid_t, int *, int);
# 12 "wait.c"
int wait(int *wstatus)
{
    return waitpid(-1, wstatus, 0);
}
