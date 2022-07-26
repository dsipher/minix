/*****************************************************************************

  sys/wait.h                                        tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_WAIT_H
#define _SYS_WAIT_H

#include <sys/tahoe.h>

#ifndef __PID_T
#define __PID_T
typedef __pid_t pid_t;
#endif /* __PID_T */

#define WEXITSTATUS     __WEXITSTATUS
#define WIFEXITED       __WIFEXITED
#define WIFSTOPPED      __WIFSTOPPED
#define WIFSIGNALED     __WIFSIGNALED
#define WSTOPSIG        __WSTOPSIG
#define WTERMSIG        __WTERMSIG

extern pid_t wait(int *);
extern pid_t waitpid(pid_t, int *, int);

#endif /* _SYS_WAIT_H */

/* vi: set ts=4 expandtab: */
