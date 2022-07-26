/*****************************************************************************

  unistd.h                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _UNISTD_H
#define _UNISTD_H

#include <sys/tahoe.h>

#define NULL __NULL

#ifndef __SIZE_T
#define __SIZE_T
typedef __size_t size_t;
#endif /* __SIZE_T */

#ifndef __SSIZE_T
#define __SSIZE_T
typedef __ssize_t ssize_t;
#endif /* __SSIZE_T */

#ifndef __PID_T
#define __PID_T
typedef __pid_t pid_t;
#endif /* __PID_T */

#define STDIN_FILENO    0
#define STDOUT_FILENO   1
#define STDERR_FILENO   2

#define F_OK  0
#define X_OK  1
#define W_OK  2
#define R_OK  4

extern int access(const char *, int);

/* the program break is always manipulated with the __brk
   system call. the brk() and sbrk() library functions are
   wrappers that provide the posix semantics. */

extern void *__brk(void *);     /* system call */

extern int brk(void *);
extern void *sbrk(__ssize_t);

extern int close(int);
extern int execve(const char *, char *const [], char *const []);
extern int execvp(const char *, char *const []);
extern int execvpe(const char *, char *const [], char *const []);
extern pid_t fork(void);
extern pid_t getpid(void);
extern int isatty(int);

#define SEEK_SET        __SEEK_SET
#define SEEK_CUR        __SEEK_CUR
#define SEEK_END        __SEEK_END

extern __off_t lseek(int, __off_t, int);

extern __ssize_t read(int, void *, __size_t);
extern int unlink(const char *);
extern __ssize_t write(int, const void *, __size_t);

extern char *optarg;
extern int optind;
extern int opterr;
extern int optopt;

extern int getopt(int, char *const[], const char *);

#endif /* _UNISTD_H */

/* vi: set ts=4 expandtab: */
