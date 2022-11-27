/*****************************************************************************

   trap.c                                                     minix kernel

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

#include <sys/trap.h>
#include <sys/log.h>

static void
unknown(int trapno, long code)
{
    printf("unknown trap: %d code %X\n", trapno, code);
    panic("trap");
}

void (*tsr[])(int, long) =
{
    /*  0 */        unknown,
    /*  1 */        unknown,
    /*  2 */        unknown,
    /*  3 */        unknown,
    /*  4 */        unknown,
    /*  5 */        unknown,
    /*  6 */        unknown,
    /*  7 */        unknown,
    /*  8 */        unknown,
    /*  9 */        unknown,
    /* 10 */        unknown,
    /* 11 */        unknown,
    /* 12 */        unknown,
    /* 13 */        unknown,
    /* 14 */        unknown,
    /* 15 */        unknown,
    /* 16 */        unknown,
    /* 17 */        unknown,
    /* 18 */        unknown,
    /* 19 */        unknown,
    /* 20 */        unknown,
    /* 21 */        unknown,
    /* 22 */        unknown,
    /* 23 */        unknown,
    /* 24 */        unknown,
    /* 25 */        unknown,
    /* 26 */        unknown,
    /* 27 */        unknown,
    /* 28 */        unknown,
    /* 29 */        unknown,
    /* 30 */        unknown,
    /* 31 */        unknown
};

/* vi: set ts=4 expandtab: */
