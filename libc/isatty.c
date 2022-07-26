/*****************************************************************************

  isatty.c                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <unistd.h>
#include <termios.h>

int isatty(int fd)
{
    struct termios dummy;

    return (tcgetattr(fd, &dummy) != -1);
}

/* vi: set ts=4 expandtab: */
