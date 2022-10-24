/*****************************************************************************

   __pow10.c                                        ux/64 standard library

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

#include <float.h>
#include <math.h>

/* there are lots of ways to do this, with varying accuracy, size, and
   speed. this version is nonrecursive and fast but uses somewhat bulky
   tables. it does the common cases -16 < exp 16 by table lookup with no
   fp arithmetic. it does 16 <= exp <= DBL_MAX_10_EXP with one multiply.
   it does DBL_MIN_10_EXP <= exp <= -16 with one divide. */

static const double powtab0[] = {
    1e0,    1e-1,   1e-2,   1e-3,   1e-4,   1e-5,   1e-6,   1e-7,
    1e-8,   1e-9,   1e-10,  1e-11,  1e-12,  1e-13,  1e-14,  1e-15
};

static const double powtab1[] = {
    1e0,    1e1,    1e2,    1e3,    1e4,    1e5,    1e6,    1e7,
    1e8,    1e9,    1e10,   1e11,   1e12,   1e13,   1e14,   1e15
};

static const double powtab2[] = {
    1e16,   1e32,   1e48,   1e64,   1e80,   1e96,   1e112,  1e128,
    1e144,  1e160,  1e176,  1e192,  1e208,  1e224,  1e240,  1e256,
    1e272,  1e288,  1e304
};

double __pow10(int exp)
{
    if (exp < 0) {
        if ((exp = -exp) < 16)
            return powtab0[exp];
        else if (exp <= -DBL_MIN_10_EXP)
            return powtab0[exp & 15] / powtab2[(exp >> 4) - 1];
        else
            return 0.0;         /* exponent underflow */
    } else if (exp < 16)
        return powtab1[exp];
    else if (exp <= DBL_MAX_10_EXP)
        return powtab1[exp & 15] * powtab2[(exp >> 4) - 1];
    else
        return HUGE_VAL;        /* exponent overflow */
}

/* vi: set ts=4 expandtab: */
