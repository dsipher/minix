/*****************************************************************************

  sigaction.c                                       tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <signal.h>

/* under linux, we need to trampoline back to a sigreturn syscall.
   posix has no concept of this, so we must intercept sigaction(). */

int sigaction(int sig, const struct sigaction *act, struct sigaction *oact)
{
    struct sigaction new;

    new = *act;
    new.sa_flags |= SA_RESTORER;
    new.sa_restorer = __sigreturn;

    return __sigaction(sig, &new, oact);
}

/* vi: set ts=4 expandtab: */
