/*****************************************************************************

   sys.c                                                 minix line editor

******************************************************************************

    derived from source found in Minix 2, Copyright 1987 Brian Beattie.

              Permission to copy and/or distribute granted
              under the following conditions:

                 (1) No charge may be made other than
                     reasonable charges for reproduction.
                 (2) This notice must remain intact.
                 (3) No further restrictions may be added.

*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include "tools.h"
#include "ed.h"

#define SHELL   "/bin/sh"

int sys(c)
char *c;
{
    int pid, status;

    switch (pid = fork()) {
    case -1:    return -1;

    case 0:     execl(SHELL, "sh", "-c", c, (char *) 0);
                exit(-1);

    default:    while (wait(&status) != pid);
    }

    return status;
}

/* vi: set ts=4 expandtab: */
