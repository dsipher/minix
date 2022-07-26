/*****************************************************************************

  brk.c                                             tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <unistd.h>
#include <errno.h>

void *sbrk(ssize_t inc)
{
    char *old;
    char *new;

    old = __brk(0);

    if (inc != 0) {
        new = __brk(old + inc);

        if (new == old) {
            errno = ENOMEM;
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
        errno = ENOMEM;
        return -1;
    }

    return 0;
}

/* vi: set ts=4 expandtab: */
