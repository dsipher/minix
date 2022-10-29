# 1 "move.c"

# 39 "/home/charles/xcc/linux/include/sys/defs.h"
typedef unsigned long   __caddr_t;
typedef unsigned        __daddr_t;
typedef unsigned        __dev_t;
typedef unsigned        __gid_t;
typedef unsigned        __ino_t;
typedef unsigned        __mode_t;
typedef unsigned        __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef long            __time_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 48 "/home/charles/xcc/linux/include/stdio.h"
typedef __off_t fpos_t;



typedef __size_t size_t;








typedef struct __iobuf
{
    int _count;
    int _fd;
    int _flags;
    int _bufsiz;
    unsigned char *_buf;
    unsigned char *_ptr;
} FILE;

















extern FILE *__iotab[16];
extern FILE __stdin, __stdout, __stderr;








extern int __fillbuf(FILE *);
extern int __flushbuf(int, FILE *);

extern void clearerr(FILE *);
extern int fclose(FILE *);
extern int fflush(FILE *);
extern int fileno(FILE *);
extern int fgetc(FILE *);
extern char *fgets(char *, int n, FILE *);
extern int fgetpos(FILE *, fpos_t *);
extern int fsetpos(FILE *, fpos_t *);
extern int fprintf(FILE *, const char *, ...);
extern int fputc(int, FILE *);
extern int fputs(const char *, FILE *);
extern FILE *fopen(const char *, const char *);
extern size_t fread(void *, size_t, size_t, FILE *);
extern FILE *freopen(const char *, const char *, FILE *);
extern int fscanf(FILE *, const char *, ...);
extern int fseek(FILE *, long, int);
extern long ftell(FILE *);
extern size_t fwrite(const void *, size_t, size_t, FILE *);
extern char *gets(char *);
extern void perror(const char *s);
extern int printf(const char *, ...);
extern int puts(const char *);
extern int remove(const char *);
extern void rewind(FILE *);
extern int rename(const char *, const char *);
extern int scanf(const char *, ...);
extern int sscanf(const char *, const char *, ...);
extern void setbuf(FILE *, char *);
extern int setvbuf(FILE *, char *, int, size_t);
extern int sprintf(char *, const char *, ...);
extern int ungetc(int, FILE *);
extern int vfprintf(FILE *, const char *, __va_list);
extern int vfscanf(FILE *, const char *, __va_list);
extern int vsprintf(char *, const char *, __va_list);


















extern char *tmpnam(char *);



extern FILE *popen(const char *command, const char *type);



extern int pclose(FILE *stream);



extern FILE *fdopen(int fildes, const char *mode);
# 91 "tools.h"
typedef char BITMAP;

struct token
{
    char            tok;
    char            lchar;
    BITMAP          *bitmap;
    struct token    *next;
};



typedef struct token TOKEN;
# 22 "ed.h"
struct line {
    int         l_stat;
    struct line *l_prev;
    struct line *l_next;
    char        l_buff[1];
};

typedef struct line LINE;








extern LINE     line0;
extern int      curln, lastln, line1, line2, nlines;

extern int      nflg;
extern int      lflg;
extern char     *inptr;
extern char     linbuf[], *linptr;
extern int      truncflg;
extern int      eightbit;
extern int      nonascii;
extern int      nullchar;
extern int      truncated;
extern int      fchanged;

extern int      diag;




char    *amatch(char *lin, TOKEN *pat, char *boln);
char    *match(char *lin, TOKEN *pat, char *boln);
int     append(int line, int glob);
BITMAP  *makebitmap(unsigned size);
int     setbit(unsigned c, char *map, unsigned val);
int     testbit(unsigned c, char *map);
char    *catsub(char *from, char *to, char *sub, char *new, char *newend);
int     ckglob(void);
int     deflt(int def1, int def2);
int     del(int from, int to);
int     docmd(int glob);
int     dolst(int line1, int line2);
char    *dodash(int delim, char *src, char *map);
int     doglob(void);
int     doprnt(int from, int to);
void    prntln(char *str, int vflg, int lin);
void    putcntl(int c, FILE *stream);
int     doread(int lin, char *fname);
int     dowrite(int from, int to, char *fname, int apflg);
void    intr(int sig);
int     egets(char *str, int size, FILE *stream);
int     esc(char **s);
int     find(TOKEN *pat, int dir);
char    *getfn(void);
int     getlst(void);
int     getnum(int first);
int     getone(void);
TOKEN   *getpat(char *arg);
LINE    *getptr(int num);
int     getrhs(char *sub);
char    *gettxt(int num);
int     ins(char *str);
int     sys(char *c);
int     join(int first, int last);
TOKEN   *makepat(char *arg, int delim);
char    *maksub(char *sub, int subsz);
char    *matchs(char *line, TOKEN *pat, int ret_endp);
int     move(int num);
int     transfer(int num);
int     omatch(char **linp, TOKEN *pat, char *boln);
TOKEN   *optpat(void);
int     set(void);
int     show(void);
void    relink(LINE *a, LINE *x, LINE *y, LINE *b);
void    clrbuf(void);
void    set_buf(void);
int     subst(TOKEN *pat, char *sub, int gflg, int pflag);
void    unmakepat(TOKEN *head);
# 24 "move.c"
int move(int num)
{
    LINE *k0, *k1, *k2, *k3;

    if (line1 <= 0 || line2 < line1 || (line1 <= num && num <= line2))
	    return -2;

    k0 = getptr(((line1)-1 < 0 ? lastln : (line1)-1));
    k1 = getptr(line1);
    k2 = getptr(line2);
    k3 = getptr(((line2)+1 > lastln ? 0 : (line2)+1));

    relink(k0, k3, k0, k3);
    lastln -= line2 - line1 + 1;

    if (num > line1) num -= line2 - line1 + 1;

    curln = num + (line2 - line1 + 1);

    k0 = getptr(num);
    k3 = getptr(((num)+1 > lastln ? 0 : (num)+1));

    relink(k0, k1, k2, k3);
    relink(k2, k3, k0, k1);
    lastln += line2 - line1 + 1;

    return 1;
}

int transfer(int num)
{
    int mid, lin, ntrans;

    if (line1 <= 0 || line1 > line2)
        return -2;

    mid = num < line2 ? num : line2;
    curln = num;
    ntrans = 0;

    for (lin = line1; lin <= mid; lin++) {
	    ins(gettxt(lin));
	    ntrans++;
    }

    lin += ntrans;
    line2 += ntrans;

    for (; lin <= line2; lin += 2) {
	    ins(gettxt(lin));
	    line2++;
    }

    return 1;
}
