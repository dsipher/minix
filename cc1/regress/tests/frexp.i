# 1 "frexp.c"

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
# 12 "frexp.c"
double frexp(double d, int *ex)
{
    union __ieee_double u;

    u.value = d;

    switch (u.bits.exp) {
    case 0:
        if ((u.bits.manl | u.bits.manh) == 0) {
            *ex = 0;
        } else {
            u.value *= __frexp_adj;
            *ex = u.bits.exp - 1536;
            u.bits.exp = 1022;
        }
        break;

    case 2047:
        break;

    default:
        *ex = u.bits.exp - 1022;
        u.bits.exp = 1022;
        break;
    }

    return (u.value);
}
