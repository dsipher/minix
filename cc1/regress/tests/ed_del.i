# 1 "del.c"

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
# 53 "/home/charles/xcc/linux/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern double atof(const char *);
extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void exit(int);

extern int abs(int);
extern long labs(long);
extern void *calloc(size_t, size_t);
extern void free(void *);
extern char *getenv(const char *);
extern void *malloc(size_t);
extern char *mktemp(char *);
extern void *realloc(void *, size_t);
extern float strtof(const char *, char **);
extern double strtod(const char *, char **);
extern long strtol(const char *, char **, int);
extern unsigned long strtoul(const char *, char **, int);

extern void qsort(void *, size_t, size_t,
                  int (*compar)(const void *, const void *));



extern int rand(void);
extern void srand(unsigned);



int putenv(char *string);



int system(const char *command);
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
# 25 "del.c"
int del(int from, int to)
{
    LINE *first, *last, *next, *tmp;

    if (from < 1) from = 1;
    first = getptr(((from)-1 < 0 ? lastln : (from)-1));
    last = getptr(((to)+1 > lastln ? 0 : (to)+1));
    next = first->l_next;

    while (next != last && next != &line0) {
	    tmp = next->l_next;
	    free(next);
	    next = tmp;
    }

    relink(first, last, first, last);
    lastln -= (to - from) + 1;
    curln = ((from)-1 < 0 ? lastln : (from)-1);

    return(0);
}
