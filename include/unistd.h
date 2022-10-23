/*****************************************************************************

   unistd.h                                            ux/64 system header

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#ifndef _UNISTD_H
#define _UNISTD_H

#include <sys/defs.h>

#define NULL __NULL

#ifndef __SIZE_T
#define __SIZE_T
typedef __size_t size_t;
#endif /* __SIZE_T */

#ifndef __SSIZE_T
#define __SSIZE_T
typedef __ssize_t ssize_t;
#endif /* __SSIZE_T */

#ifndef __GID_T
#define __GID_T
typedef __gid_t gid_t;
#endif /* __GID_T */

#ifndef __UID_T
#define __UID_T
typedef __uid_t uid_t;
#endif /* __UID_T */

#ifndef __OFF_T
#define __OFF_T
typedef __off_t off_t;
#endif /* __OFF_T */

#ifndef __PID_T
#define __PID_T
typedef __pid_t pid_t;
#endif /* __PID_T */

/* posix wants us to name the
   standard file descriptors */

#define STDIN_FILENO    0
#define STDOUT_FILENO   1
#define STDERR_FILENO   2

/* determine the accessibility of
   a file (by the current user) */

#define F_OK  0     /* exists */
#define X_OK  1     /* executable */
#define W_OK  2     /* writeable */
#define R_OK  4     /* readable */

extern int access(const char *path, int amode);

/* __brk() is the actual system call. it sets the new
   program break to `addr', if possible, and returns
   the new program break. if impossible, the returned
   value is the unchanged break.

   since 0 is never a valid program break, __brk(0) is
   used to interrogate the current program break. */

extern void *__brk(void *addr);     /* system call */

/* wrappers for __brk() which provide more conventional
   functionality. brk() sets the new break to `addr' and
   returns 0 on success, or -1 on error. sbrk() attempts
   to grow the break by `increment' bytes, and returns
   the base of the new region, or (void *) -1 on error. */

extern int brk(void *addr);
extern void *sbrk(ssize_t increment);

/* change working directory */

extern int chdir(const char *path);

/* close a file descriptor */

extern int close(int fildes);

/* duplicate an open file descriptor */

extern int dup(int fildes);
extern int dup2(int fildes, int fildes2);

/* launch a new executable - replace the current
   process with that specified. only execve() is
   actually a system call, the others are wrappers. */

extern int execvp(const char *file, char *const argv[]);
extern int execvpe(const char *file, char *const argv[], char *const envp[]);
extern int execve(const char *path, char *const argv[], char *const envp[]);

extern int execl(const char *path, const char *arg0, ...);
extern int execlp(const char *file, const char *arg0, ...);

/* create a new process */

extern pid_t fork(void);

/* get working directory name */

char *getcwd(char *buf, size_t size);

/* get the current process ID */

extern pid_t getpid(void);

/* test for a terminal device */

extern int isatty(int fildes);

/* move the read/write file offset */

#define SEEK_SET    __SEEK_SET      /* offset is absolute */
#define SEEK_CUR    __SEEK_CUR      /* offset from current position */
#define SEEK_END    __SEEK_END      /* offset from end of file */

extern off_t lseek(int fildes, off_t offset, int whence);

/* create an inter-process channel */

extern int pipe(int fildes[2]);

/* wait for a signal */

extern int pause(void);

/* read to or write from a file */

extern ssize_t read(int fildes, void *buf, size_t nbyte);
extern ssize_t write(int fildes, const void *buf, size_t nbyte);

/* remove a directory entry */

extern int unlink(const char *path);

/* sleep for `seconds' or until a signal arrives */

extern unsigned sleep(unsigned seconds);

/* command option parsing */

extern int  optopt;         /* this option flag */
extern char *optarg;        /* this option argument */
extern int  optind;         /* next index of argv[] to process */
extern int  opterr;         /* (flag) print option error diagnostics */

extern int getopt(int argc, char * const argv[], const char *optstring);

#endif /* _UNISTD_H */

/* vi: set ts=4 expandtab: */
