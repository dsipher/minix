/*****************************************************************************

   frexp.c                                          minix standard library

******************************************************************************

   derived from FreeBSD, Copyright (c) 2004 David Schultz (das@freebsd.org).

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

#include <math.h>

double frexp(double d, int *ex)
{
    union __ieee_double u;

    u.f = d;

    switch (u.bits.exp) {
    case 0:     /* 0 or subnormal */
        if ((u.bits.manl | u.bits.manh) == 0) {
            *ex = 0;
        } else {
            u.f *= __double_2_514;
            *ex = u.bits.exp - 1536;
            u.bits.exp = 1022;
        }
        break;

    case 2047:  /* infinity or NaN; value of *ex is unspecified */
        break;

    default:    /* normal */
        *ex = u.bits.exp - 1022;
        u.bits.exp = 1022;
        break;
    }

    return (u.f);
}

/* vi: set ts=4 expandtab: */
