/*****************************************************************************

   ldexp.c                                          minix standard library

******************************************************************************

   derived from musl, Copyright (c) 2005-2020 Rich Felker, et al.

   Permission is hereby granted, free of charge, to any person obtaining
   a  copy of  this  software and  associated  documentation  files (the
   "Software"), to deal  in the  Software without restriction, including
   without  limitation the rights to  use, copy, modify, merge, publish,
   distribute,  sublicense, and/or sell  copies of the Software,  and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

      The above copyright notice and this permission notice shall be
      included in all copies or substantial portions of the Software.

   THE  SOFTWARE  IS  PROVIDED "AS  IS",  WITHOUT WARRANTY  OF ANY  KIND,
   EXPRESS OR  IMPLIED,  INCLUDING BUT NOT LIMITED TO  THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER  IN AN ACTION  OF CONTRACT,
   TORT  OR OTHERWISE, ARISING  FROM, OUT OF OR IN  CONNECTION WITH  THE
   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*****************************************************************************/

#include <float.h>
#include <math.h>

double ldexp(double x, int n)
{
	union __ieee_double u;
	double y = x;

	if (n > 1023) {
		y *= __double_2_1023;
		n -= 1023;

		if (n > 1023) {
			y *= __double_2_1023;
			n -= 1023;

			if (n > 1023)
				n = 1023;
		}
	} else if (n < -1022) {
		/* make sure final n < -53 to avoid double
		   rounding in the subnormal range */

		y *= __double_2_n969;
		n += 1022 - 53;

		if (n < -1022) {
			y *= __double_2_n969;
			n += 1022 - 53;

			if (n < -1022)
				n = -1022;
		}
	}

	u.i = (unsigned long)(0x3ff+n)<<52;
	x = y * u.f;

	return x;
}
