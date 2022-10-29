# 1 "sys.c"

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
# 41 "/home/charles/xcc/linux/include/sys/wait.h"
typedef __pid_t pid_t;











extern pid_t wait(int *wstatus);
extern pid_t waitpid(pid_t pid, int *wstatus, int options);
# 48 "/home/charles/xcc/linux/include/unistd.h"
typedef __ssize_t ssize_t;




typedef __gid_t gid_t;




typedef __uid_t uid_t;




typedef __off_t off_t;
# 86 "/home/charles/xcc/linux/include/unistd.h"
extern int access(const char *path, int amode);









extern void *__brk(void *addr);







extern int brk(void *addr);
extern void *sbrk(ssize_t increment);



extern int chdir(const char *path);



extern int close(int fildes);



extern int chown(const char *pathname, uid_t owner, gid_t group);



extern void _exit(int status);



extern int dup(int fildes);
extern int dup2(int fildes, int fildes2);





extern int execvp(const char *file, char *const argv[]);
extern int execvpe(const char *file, char *const argv[], char *const envp[]);
extern int execve(const char *path, char *const argv[], char *const envp[]);

extern int execl(const char *path, const char *arg0, ...);
extern int execlp(const char *file, const char *arg0, ...);



extern pid_t fork(void);



extern char *getcwd(char *buf, size_t size);



extern uid_t getuid(void);
extern gid_t getgid(void);
extern uid_t geteuid(void);
extern gid_t getegid(void);



extern pid_t getpid(void);



extern int link(const char *existing, const char *new);



extern int isatty(int fildes);







extern off_t lseek(int fildes, off_t offset, int whence);



extern int pipe(int fildes[2]);



extern int pause(void);



extern ssize_t read(int fildes, void *buf, size_t nbyte);
extern ssize_t write(int fildes, const void *buf, size_t nbyte);



extern int unlink(const char *path);



extern unsigned sleep(unsigned seconds);



extern int  optopt;
extern char *optarg;
extern int  optind;
extern int  opterr;

extern int getopt(int argc, char * const argv[], const char *optstring);
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
# 29 "sys.c"
int sys(c)
char *c;
{
    int pid, status;

    switch (pid = fork()) {
    case -1:    return -1;

    case 0:     execl("/bin/sh", "sh", "-c", c, (char *) 0);
                exit(-1);

    default:    while (wait(&status) != pid);
    }

    return status;
}
