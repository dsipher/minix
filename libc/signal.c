/*****************************************************************************

  signal.c                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <signal.h>

/* per POSIX, the only portable use of this function is to set a signal's
   disposition to SIG_IGN or SIG_DFL. the semantics are undefined otherwise.
   we go with classic System V (V7 really) unreliable signal behavior here. */

__sighandler_t signal(int sig, __sighandler_t handler)
{
    struct sigaction new = { 0 };   /* this is cheating, we do this */
    struct sigaction old = { 0 };   /* instead of using sigemptyset() */

    new.sa_handler = handler;
    new.sa_flags = SA_RESETHAND | SA_NODEFER;

    if (sigaction(sig, &new, &old) == -1)
        return SIG_ERR;
    else
        return old.sa_handler;
}

/* vi: set ts=4 expandtab: */
