# 1 "__ctype.c"

# 14 "/home/charles/xcc/include/ctype.h"
extern char __ctype[];









extern int isalnum(int);
extern int isalpha(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int tolower(int);
extern int toupper(int);
# 12 "__ctype.c"
char __ctype[] = {
                0,

                0x20,     0x20,     0x20,     0x20,     0x20,     0x20,     0x20,     0x20,
                0x20,     0x20|0x08,  0x20|0x08,  0x20|0x08,  0x20|0x08,  0x20|0x08,  0x20,     0x20,
                0x20,     0x20,     0x20,     0x20,     0x20,     0x20,     0x20,     0x20,
                0x20,     0x20,     0x20,     0x20,     0x20,     0x20,     0x20,     0x20,
                0x08,     0x10,     0x10,     0x10,     0x10,     0x10,     0x10,     0x10,
                0x10,     0x10,     0x10,     0x10,     0x10,     0x10,     0x10,     0x10,
                0x04,     0x04,     0x04,     0x04,     0x04,     0x04,     0x04,     0x04,
                0x04,     0x04,     0x10,     0x10,     0x10,     0x10,     0x10,     0x10,
                0x10,     0x01|0x40,  0x01|0x40,  0x01|0x40,  0x01|0x40,  0x01|0x40,  0x01|0x40,  0x01,
                0x01,     0x01,     0x01,     0x01,     0x01,     0x01,     0x01,     0x01,
                0x01,     0x01,     0x01,     0x01,     0x01,     0x01,     0x01,     0x01,
                0x01,     0x01,     0x01,     0x10,     0x10,     0x10,     0x10,     0x10,
                0x10,     0x02|0x40,  0x02|0x40,  0x02|0x40,  0x02|0x40,  0x02|0x40,  0x02|0x40,  0x02,
                0x02,     0x02,     0x02,     0x02,     0x02,     0x02,     0x02,     0x02,
                0x02,     0x02,     0x02,     0x02,     0x02,     0x02,     0x02,     0x02,
                0x02,     0x02,     0x02,     0x10,     0x10,     0x10,     0x10,     0x20,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0,
                0,      0,      0,      0,      0,      0,      0,      0
};
