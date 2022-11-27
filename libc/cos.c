/*****************************************************************************

   cos.c                                            minix standard library

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

/* (Hart 2923, 19.96) */

static const double sintab[] = {     0.523598775598298873071308e+00,
                                    -0.239245962039350458667960e-01,
                                     0.327953194428661969081000e-03,
                                    -0.214071976918198811800000e-05,
                                     0.815125650404748400000000e-08,
                                    -0.203153509377510000000000e-10,
                                     0.355397103280000000000000e-13     };

/* * (Hart 3824, 19.45) */

static const double costab[] = {     0.99999999999999999996415,
                                    -0.30842513753404245242414,
                                     0.01585434424381541089754,
                                    -0.00032599188692668755044,
                                     0.00000359086044588581953,
                                    -0.00000002461136382637005,
                                     0.00000000011500497024263,
                                    -0.00000000000038577620372      };

double cos(double x)
{
    double r;
    register int s;

    if ((x = modf(x/(2.0 * __PI), &r)) < 0.0) {
        x += 1.0;
        r -= 1.0;
    }

    s = 0;

    if (x > 0.5) {
        s = 1;
        x -= 0.5;
    }

    if (x > 0.25) {
        s ^= 1;
        x = 0.5 - x;
    }

    if (x > 0.125) {
        x = 3.0 - 12.0 * x;
        r = x * __poly(x * x, sintab, 7);
    } else {
        x *= 8.0;
        r = __poly(x * x, costab, 8);
    }

    return s ? -r : r;
}

/* vi: set ts=4 expandtab: */
