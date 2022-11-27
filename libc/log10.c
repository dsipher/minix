/*****************************************************************************

   log10.c                                          minix standard library

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

/* (Hart 2355, 19.74) */

static const double logntab[] = {   -0.1042911213725266949744122e+02,
                                     0.1344458152275036223645300e+02,
                                    -0.4185596001312662063300000e+01,
                                     0.1828759212091999337000000e+00 };

static const double logmtab[] = {   -0.1200695907020063424342180e+02,
                                     0.1948096618798093652415500e+02,
                                    -0.8911109060902708565400000e+01,
                                     0.1000000000000000000000000e+01 };

double log10(double x)
{
    double r, z;
    int n;

    if (x <= 0.0) {
        errno = EDOM;
        return 0.0;
    }

    if (x == 1.0)
        return 0.0;

    x = frexp(x, &n);
    x *= __SQRT2;
    z = (x - 1.0) / (x + 1.0);
    r = z * z;
    r = z * (__poly(r, logntab, 4) / __poly(r, logmtab, 4));
    r += (n - 0.5) * __LOG2B10;

    return r;
}

/* vi: set ts=4 expandtab: */
