/*****************************************************************************

   atan.c                                           ux/64 standard library

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

static double tanntab[] = { 0.12097470017580907217240715e+04,
                            0.30310745956115083044212807e+04,
                            0.27617198246138834959053784e+04,
                            0.11141290728455183546172942e+04,
                            0.19257920144815596134742860e+03,
                            0.11322159411676465523624500e+02,
                            0.97627215917176330369830000e-01 };

static double tanmtab[] = { 0.12097470017580907287514197e+04,
                            0.34343235961975351716547069e+04,
                            0.36645449563283749893504796e+04,
                            0.18216003392918464941509225e+04,
                            0.42307164648090478045242060e+03,
                            0.39917884248653798150199900e+02,
                            0.10000000000000000000000000e+01 };

double atan(double x)
{
    double r;
    int i, s;

    s = 0;
    i = 0;

    if (x < 0.0) {
        s = 1;
        x = -x;
    }

    if (x > 1.0) {
        i = 1;
        x = 1/x;
    }

    r = x * x;
    r = x * (__poly(r, tanntab, 7) / __poly(r, tanmtab, 7));

    if (i) r = __PI/2.0 - r;
    if (s) r = -r;

    return (r);
}

/* vi: set ts=4 expandtab: */
