# 1 "tolower.c"

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
# 12 "tolower.c"
int tolower(int c)
{
    return ((unsigned) ((c)-'A') < 26) ? c - 'A' + 'a' : c ;
}
