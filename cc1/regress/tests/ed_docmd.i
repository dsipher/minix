# 1 "docmd.c"

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
# 44 "/home/charles/xcc/linux/include/string.h"
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);
extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
extern char *strcat(char *, const char *);
extern char *strchr(const char *, int);
extern int strcmp(const char *, const char *);
extern char *strcpy(char *, const char *);
extern char *strerror(int);
extern size_t strlen(const char *);
extern char *strncat(char *, const char *, size_t);
extern int strncmp(const char *, const char *, size_t);
extern char *strncpy(char *, const char *, size_t);
extern char *strrchr(const char *, int);



extern char *strdup(const char *s);
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
# 25 "docmd.c"
char fname[1024];
int fchanged;
extern int nofname;

extern int mark[];

int docmd(int glob)
{
    static char rhs[256];
    TOKEN *subpat;
    int c, err, line3;
    int apflg, pflag, gflag;
    int nchng;
    char *fptr;

    pflag = 0;
    while (*inptr == 0x20 && *inptr == 0x09) inptr++;

    c = *inptr++;

    switch (c) {
    case '\n':
        if (nlines == 0) {
            if ((line2 = ((curln)+1 > lastln ? 0 : (curln)+1)) == 0) return(-2);
        }

        curln = line2;
        return(1);
        break;

    case '=':
        printf("%d\n", line2);
        break;

    case 'a':
        if (*inptr != '\n' || nlines > 1) return(-2);
        if (append(line1, glob) < 0) return(-2);;
        fchanged = 1;
        break;

    case 'c':
        if (*inptr != '\n') return(-2);
        if (deflt(curln, curln) < 0) return(-2);
        if (del(line1, line2) < 0) return(-2);
        if (append(curln, glob) < 0) return (-2);
        fchanged = 1;
        break;

    case 'd':
        if (*inptr != '\n') return(-2);
        if (deflt(curln, curln) < 0) return(-2);
        if (del(line1, line2) < 0) return(-2);
        if (((curln)+1 > lastln ? 0 : (curln)+1) != 0) curln = ((curln)+1 > lastln ? 0 : (curln)+1);
        fchanged = 1;
        break;

    case 'e':
        if (nlines > 0) return(-2);

        if (fchanged) {
            fchanged = 0;
            return(-2);
        }



    case 'E':
        if (nlines > 0) return(-2);
        if (*inptr != ' ' && *inptr != 0x09 && *inptr != '\n') return(-2);
        if ((fptr = getfn()) == ((void *) 0)) return(-2);
        clrbuf();
        if ((err = doread(0, fptr)) < 0) return(err);
        strcpy(fname, fptr);
        fchanged = 0;
        break;

      case 'f':
        if (nlines > 0) return(-2);
        if (*inptr != ' ' && *inptr != 0x09 && *inptr != '\n') return(-2);
        if ((fptr = getfn()) == ((void *) 0)) return(-2);

        if (nofname)
            printf("%s\n", fname);
        else
            strcpy(fname, fptr);

        break;

    case 'i':
        if (*inptr != '\n' || nlines > 1) return(-2);
        if (append(((line1)-1 < 0 ? lastln : (line1)-1), glob) < 0) return(-2);
        fchanged = 1;
        break;

    case 'j':
        if (*inptr != '\n' || deflt(curln, curln + 1) < 0) return(-2);
        if (join(line1, line2) < 0) return(-2);
        break;

    case 'k':
        while (*inptr == ' ' || *inptr == 0x09) inptr++;
        if (*inptr < 'a' || *inptr > 'z') return -2;
        c = *inptr++;
        if (*inptr != ' ' && *inptr != 0x09 && *inptr != '\n') return(-2);
        mark[c - 'a'] = line1;
        break;

    case 'l':
        if (*inptr != '\n') return(-2);
        if (deflt(curln, curln) < 0) return (-2);
        if (dolst(line1, line2) < 0) return (-2);
        break;

    case 'm':
        if ((line3 = getone()) < 0) return(-2);
        if (deflt(curln, curln) < 0) return (-2);
        if (move(line3) < 0) return (-2);
        fchanged = 1;
        break;

    case 'P':
    case 'p':
        if (*inptr != '\n') return(-2);
        if (deflt(curln, curln) < 0) return (-2);
        if (doprnt(line1, line2) < 0) return (-2);
        break;

    case 'q':
        if (fchanged) {
            fchanged = 0;
            return(-2);
        }



    case 'Q':
        if (*inptr == '\n' && nlines == 0 && !glob)
            return((-1));
        else
            return(-2);

    case 'r':
        if (nlines > 1) return(-2);
        if (nlines == 0) line2 = lastln;
        if (*inptr != ' ' && *inptr != 0x09 && *inptr != '\n') return(-2);
        if ((fptr = getfn()) == ((void *) 0)) return(-2);
        if ((err = doread(line2, fptr)) < 0) return(err);
        fchanged = 1;
        break;

    case 's':
        if (*inptr == 'e') return(set());
        while (*inptr == 0x20 || *inptr == 0x09) inptr++;
        if ((subpat = optpat()) == ((void *) 0)) return (-2);
        if ((gflag = getrhs(rhs)) < 0) return (-2);
        if (*inptr == 'p') pflag++;
        if (deflt(curln, curln) < 0) return (-2);
        if ((nchng = subst(subpat, rhs, gflag, pflag)) < 0) return (-2);
        if (nchng) fchanged = 1;
        break;

    case 't':
        if ((line3 = getone()) < 0) return(-2);
        if (deflt(curln, curln) < 0) return (-2);
        if (transfer(line3) < 0) return (-2);
        fchanged = 1;
        break;

    case 'W':
    case 'w':
        apflg = (c == 'W');
        if (*inptr != ' ' && *inptr != 0x09 && *inptr != '\n') return(-2);
        if ((fptr = getfn()) == ((void *) 0)) return(-2);
        if (deflt(1, lastln) < 0) return(-2);
        if (dowrite(line1, line2, fptr, apflg) < 0) return (-2);
        fchanged = 0;
        break;

    case 'x':
        if (*inptr == '\n' && nlines == 0 && !glob) {
            if ((fptr = getfn()) == ((void *) 0)) return(-2);
            if (dowrite(1, lastln, fptr, 0) >= 0) return ((-1));
        }

        return(-2);

    case 'z':
        if (deflt(curln, curln) < 0) return(-2);

        switch (*inptr) {
        case '-':
            if (doprnt(line1 - 21, line1) < 0) return(-2);
            break;

        case '.':
            if (doprnt(line1 - 11, line1 + 10) < 0) return(-2);
            break;

        case '+':
        case '\n':
            if (doprnt(line1, line1 + 21) < 0) return(-2);
            break;
        }

        break;

    default:  return(-2);
    }

    return(0);
}

int dolst(int line1, int line2)
{
    int oldlflg = lflg, p;

    lflg = 1;
    p = doprnt(line1, line2);
    lflg = oldlflg;

    return p;
}
