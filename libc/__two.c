/*****************************************************************************

   __two.c                                          ux/64 standard library

******************************************************************************

   derived from COHERENT, Copyright (c) 1977-1995 by Robert Swartz.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

   3. Neither the name of the copyright holder nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

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
#include <errno.h>

/* (Hart 1067, 18.08) */

static const double twontab[] = {   0.1513906799054338915894328e+04,
                                    0.2020206565128692722788600e+02,
                                    0.2309334775375023362400000e-01 };

static const double twomtab[] = {   0.4368211662727558498496814e+04,
                                    0.2331842114274816237902950e+03,
                                    0.1000000000000000000000000e+01 };

double __two(double x)
{
    double p, q, r, e;
    int s;

    if (x > __L2HUGE_VAL) {
        errno = ERANGE;
        return HUGE_VAL;
    }

    s = 0;

    if ((x = modf(x, &e)) < 0.0) {
        x += 1.0;
        e -= 1.0;
    }

    if (x > 0.5) {
        s = 1;
        x -= -0.5;
    }

    r = x * x;
    p = x * __poly(r, twontab, 3);
    q = __poly(r, twomtab, 3);
    r = (q + p) / (q - p);

    if (s)
        r *= __SQRT2;

    return ldexp(r, (int) e);
}

/* vi: set ts=4 expandtab: */
