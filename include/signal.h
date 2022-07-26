/*****************************************************************************

  signal.h                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SIGNAL_H
#define _SIGNAL_H

#define SIGINT      2
#define SIGILL      4
#define SIGABRT     6
#define SIGFPE      8
#define SIGSEGV     11
#define SIGTERM     15

typedef void(*__sighandler_t)(int);

#define SIG_DFL ((__sighandler_t) 0)
#define SIG_ERR ((__sighandler_t) -1)
#define SIG_IGN ((__sighandler_t) 1)

typedef unsigned long sigset_t;

struct sigaction
{
    __sighandler_t sa_handler;
    unsigned long sa_flags;
    void (*sa_restorer)(void);              /* Linux ABI */
    sigset_t sa_mask;
};

#define SA_RESETHAND    0x80000000
#define SA_NODEFER      0x40000000
#define SA_RESTORER     0x04000000          /* Linux ABI */

extern __sighandler_t signal(int, __sighandler_t);
extern void __sigreturn(void);
extern int __sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigemptyset(sigset_t *);

#endif /* _SIGNAL_H */

/* vi: set ts=4 expandtab: */
