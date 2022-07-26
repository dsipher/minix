# 1 "__pow10.c"

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
# 13 "__pow10.c"
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
        else if (exp <= - -307)
            return powtab0[exp & 15] / powtab2[(exp >> 4) - 1];
        else
            return 0.0;
    } else if (exp < 16)
        return powtab1[exp];
    else if (exp <= 308)
        return powtab1[exp & 15] * powtab2[(exp >> 4) - 1];
    else
        return (__huge_val);
}
