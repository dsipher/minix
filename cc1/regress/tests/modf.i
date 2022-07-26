# 1 "modf.c"

# 13 "/home/charles/xcc/include/math.h"
extern double __huge_val;
extern double __frexp_adj;



extern char *__dtefg(char *, double *, int, int, int, int *);

extern double modf(double, double *);
extern double frexp(double, int *);
extern double __pow10(int);







union __ieee_double
{
    double value;

    struct
    {
        int lsw;
        int msw;
    } words;

    struct
    {
        unsigned manl : 32;
        unsigned manh : 20;
        unsigned exp : 11;
        unsigned sign : 1;
    } bits;
};
# 46 "modf.c"
static const double one = 1.0;

double modf(double x, double *iptr)
{
    int i0, i1, j0;
    unsigned i;
    unsigned high;

    do { union __ieee_double ew_u; ew_u.value = (x); (i0) = ew_u.words.msw; (i1) = ew_u.words.lsw; } while (0);
    j0 = ((i0 >> 20) & 0x7ff) - 0x3ff;

    if (j0 < 20) {
        if (j0 < 0) {
            do { union __ieee_double iw_u; iw_u.words.msw = (i0 & 0x80000000); iw_u.words.lsw = (0); (*iptr) = iw_u.value; } while (0);
            return x;
        } else {
            i = (0x000fffff) >> j0;

            if(((i0 & i) | i1) == 0) {
                *iptr = x;
                do { union __ieee_double gh_u; gh_u.value = (x); (high) = gh_u.words.msw; } while (0);
                do { union __ieee_double iw_u; iw_u.words.msw = (high & 0x80000000); iw_u.words.lsw = (0); (x) = iw_u.value; } while (0);
                return x;
            } else {
                do { union __ieee_double iw_u; iw_u.words.msw = (i0 & (~i)); iw_u.words.lsw = (0); (*iptr) = iw_u.value; } while (0);
                return x - *iptr;
            }
        }
    } else if (j0 > 51) {
        if (j0 == 0x400) {
            *iptr = x;
            return 0.0 / x;
        }

        *iptr = x * one;
        do { union __ieee_double gh_u; gh_u.value = (x); (high) = gh_u.words.msw; } while (0);
        do { union __ieee_double iw_u; iw_u.words.msw = (high & 0x80000000); iw_u.words.lsw = (0); (x) = iw_u.value; } while (0);
        return x;
    } else {
        i = ((unsigned) (0xffffffff)) >> (j0 - 20);

        if((i1 & i) == 0) {
            *iptr = x;
            do { union __ieee_double gh_u; gh_u.value = (x); (high) = gh_u.words.msw; } while (0);
            do { union __ieee_double iw_u; iw_u.words.msw = (high & 0x80000000); iw_u.words.lsw = (0); (x) = iw_u.value; } while (0);
            return x;
        } else {
            do { union __ieee_double iw_u; iw_u.words.msw = (i0); iw_u.words.lsw = (i1 & (~i)); (*iptr) = iw_u.value; } while (0);
            return x - *iptr;
        }
    }
}
