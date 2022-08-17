# 1 "ar.c"

# 39 "/home/charles/xcc/include/sys/tahoe.h"
typedef long            __blkcnt_t;
typedef long            __blksize_t;
typedef unsigned long   __dev_t;
typedef unsigned        __gid_t;
typedef unsigned long   __ino_t;
typedef unsigned        __mode_t;
typedef unsigned long   __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef long            __time_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 48 "/home/charles/xcc/include/stdio.h"
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

















extern FILE *__iotab[20];
extern FILE __stdin, __stdout, __stderr;








extern int __fillbuf(FILE *);
extern int __flushbuf(int, FILE *);

extern void clearerr(FILE *);
extern int fclose(FILE *);
extern int fflush(FILE *);
extern int fileno(FILE *);
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
# 41 "/home/charles/xcc/include/fcntl.h"
typedef __mode_t mode_t;


int creat(const char *, mode_t);
int open(const char *, int, ...);
# 48 "/home/charles/xcc/include/unistd.h"
typedef __ssize_t ssize_t;




typedef __pid_t pid_t;











extern int access(const char *, int);





extern void *__brk(void *);

extern int brk(void *);
extern void *sbrk(__ssize_t);

extern int close(int);
extern int execve(const char *, char *const [], char *const []);
extern int execvp(const char *, char *const []);
extern int execvpe(const char *, char *const [], char *const []);
extern pid_t fork(void);
extern pid_t getpid(void);
extern int isatty(int);





extern __off_t lseek(int, __off_t, int);

extern __ssize_t read(int, void *, __size_t);
extern int unlink(const char *);
extern __ssize_t write(int, const void *, __size_t);

extern char *optarg;
extern int optind;
extern int opterr;
extern int optopt;

extern int getopt(int, char *const[], const char *);
# 53 "/home/charles/xcc/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void _exit(int);
extern void exit(int);

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
# 53 "/home/charles/xcc/include/signal.h"
extern int kill(pid_t, int);
extern int raise(int sig);

typedef void(*__sighandler_t)(int);





typedef unsigned long sigset_t;

struct sigaction
{
    __sighandler_t sa_handler;
    unsigned long sa_flags;
    void (*sa_restorer)(void);
    sigset_t sa_mask;
};





extern __sighandler_t signal(int, __sighandler_t);
extern void __sigreturn(void);
extern int __sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigemptyset(sigset_t *);
# 41 "/home/charles/xcc/include/time.h"
typedef __time_t time_t;


struct tm
{
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
};

struct timespec
{
    time_t tv_sec;
    long   tv_nsec;
};

extern char *asctime(const struct tm *);
extern char *ctime(const time_t *);
extern struct tm *localtime(const time_t *);
extern struct tm *gmtime(const time_t *);
extern __size_t strftime(char *, __size_t, const char *, const struct tm *);
extern time_t time(time_t *);

extern char *tzname[];
extern long timezone;

extern void tzset(void);
# 44 "/home/charles/xcc/include/string.h"
extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);
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
# 37 "/home/charles/xcc/include/errno.h"
extern int errno;
# 41 "/home/charles/xcc/include/sys/dir.h"
struct direct
{
    __ino_t     d_ino;
    char        d_name[28];
};
# 52 "/home/charles/xcc/include/ar.h"
struct ar_hdr
{
    char        ar_name[28];
    __uid_t     ar_uid;
    __gid_t     ar_gid;
    __mode_t    ar_mode;
    __time_t    ar_date;
    __off_t     ar_size;
};
# 46 "/home/charles/xcc/include/sys/types.h"
typedef __off_t off_t;
# 41 "/home/charles/xcc/include/sys/stat.h"
typedef __blkcnt_t blkcnt_t;




typedef __blksize_t blksize_t;




typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __ino_t ino_t;
# 99 "/home/charles/xcc/include/sys/stat.h"
typedef __nlink_t nlink_t;














typedef __uid_t uid_t;



struct stat
{
    dev_t           st_dev;
    ino_t           st_ino;
    nlink_t         st_nlink;

    mode_t          st_mode;
    uid_t           st_uid;
    gid_t           st_gid;
    int             __pad0;

    dev_t           st_rdev;
    off_t           st_size;
    blksize_t       st_blksize;
    blkcnt_t        st_blocks;

    time_t          st_atime;
    long            st_atimensec;
    time_t          st_mtime;
    long            st_mtimensec;
    time_t          st_ctime;
    long            st_ctimensec;

    unsigned long   __reserved[3];
};

extern int fstat(int fd, struct stat *statbuf);
# 49 "ar.c"
char man[] = "mrxtdpq";
char opt[] = "uvnbail";



int signum[] = { 1, 2, 3, 0 };



char flg[26];






char **namv;    int namc;








char tmpnam[]   = "/tmp/" "arXXXXXX",
     tmp1nam[]  = "/tmp/" "arXXXXXX",
     tmp2nam[]  = "/tmp/" "arXXXXXX";

char *tfnam;    int tf;
char *tf1nam;   int tf1;
char *tf2nam;   int tf2;

char *arnam;    int af;
char *ponam;
char *file;

int qf;






struct ar_hdr arbuf;

int
getdir(void)
{
    static char name[28+1];
    int i;

    i = read(af, &arbuf, sizeof arbuf);

    if(i != sizeof arbuf) {
        if (tf1nam) {
            i = tf;
            tf = tf1;
            tf1 = i;
        }

        return(1);
    }

    for(i = 0; i < 28; i++)
        name[i] = arbuf.ar_name[i];

    file = name;
    return(0);
}




int
morefil(void)
{
    int i, n;

    n = 0;

    for (i=0; i < namc; i++)
        if (namv[i])
            n++;

    return n;
}




struct stat stbuf;

int
stats(void)
{
    int f;

    f = open(file, 0);
    if (f < 0) return(f);

    if (fstat(f, &stbuf) < 0) {
        close(f);
        return(-1);
    }

    return(f);
}




char *
trim(char *s)
{
    char *p1, *p2;

    for (p1 = s; *p1; p1++)
        ;

    while (p1 > s) {
        if(*--p1 != '/')
            break;

        *p1 = 0;
    }

    p2 = s;

    for (p1 = s; *p1; p1++)
        if (*p1 == '/')
            p2 = p1+1;

    return(p2);
}



void
mesg(int c)
{
    if(flg['v'-'a'])
        if(c != 'c' || flg['v'-'a'] > 1)
            printf("%c - %s\n", c, file);
}




void
done(int status)
{
    if(tfnam) unlink(tfnam);
    if(tf1nam) unlink(tf1nam);
    if(tf2nam) unlink(tf2nam);
    exit(status);
}



void
wrerr(void)
{
    perror("ar write error");
    done(1);
}



void
usage(void)
{
    printf("usage: ar [%s][%s] archive files ...\n", opt, man);
    done(1);
}



void
sigdone(int sig)
{
    done(100);
}












int
getaf(int must)
{
    long mbuf;

    af = open(arnam, 0);

    if (af < 0)
        if (must) {
            fprintf((&__stderr), "ar: %s does not exist\n", arnam);
            done(1);
        } else
            return(1);

    if (read(af, &mbuf, sizeof(mbuf)) != sizeof(mbuf) || mbuf!='<tahar!>') {
        fprintf((&__stderr), "ar: %s not in archive format\n", arnam);
        done(1);
    }

    return(0);
}




void
init(void)
{
    static long mbuf = '<tahar!>';

    tfnam = mktemp(tmpnam);
    close(creat(tfnam, 0600));
    tf = open(tfnam, 2);

    if(tf < 0) {
        fprintf((&__stderr), "ar: cannot create temp file\n");
        done(1);
    }

    if (write(tf, &mbuf, sizeof(mbuf)) != sizeof(mbuf))
        wrerr();
}
















int bastate;

void
bamatch(void)
{
    int f;

    switch(bastate) {

    case 1:
        if(strcmp(file, ponam) != 0)
            return;

        bastate = 2;

        if(flg['a'-'a'])
            return;

    case 2:
        bastate = 0;
        tf1nam = mktemp(tmp1nam);
        close(creat(tf1nam, 0600));
        f = open(tf1nam, 2);

        if(f < 0) {
            fprintf((&__stderr), "ar: cannot create second temp\n");
            return;
        }

        tf1 = tf;
        tf = f;
    }
}









void
copyfil(int fi, int fo, int flag)
{
    int i, o;
    int pe;
    int pad;
    char buf[4096];

    if (flag & 8)
        if (write(fo, (char *)&arbuf, sizeof arbuf) != sizeof arbuf)
            wrerr();

    pe = 0;

    while (arbuf.ar_size > 0) {
        i = o = 4096;

        if (arbuf.ar_size < i) {
            i = o = arbuf.ar_size;

            if (i & (8 - 1)) {
                pad = 8 - (i & (8 - 1));
                if(flag & 2) i += pad;
                if(flag & 4) o += pad;
            }
        }

        if (read(fi, buf, i) != i) pe++;

        if ((flag & 1) == 0)
            if (write(fo, buf, o) != o)
                wrerr();

        arbuf.ar_size -= 4096;
    }

    if (pe) fprintf((&__stderr), "ar: phase error on %s\n", file);
}





void
install0(char *nam, int tf)
{
    int i;
    char buf[4096];

    if (nam) {
        lseek(tf, 0, 0);

        while ((i = read(tf, buf, 4096)) > 0)
            if (write(af, buf, i) != i)
                wrerr();
    }
}

void
install(void)
{
    int i;

    for(i=0; signum[i]; i++)
        signal(signum[i], ((__sighandler_t) 1));

    if(af < 0)
        if(!flg['c'-'a'])
            fprintf((&__stderr), "ar: creating %s\n", arnam);

    close(af);
    af = creat(arnam, 0666);

    if (af < 0) {
        fprintf((&__stderr), "ar: cannot create %s\n", arnam);
        done(1);
    }

    install0(tfnam, tf);
    install0(tf2nam, tf2);
    install0(tf1nam, tf1);
}





void
movefil(int f)
{
    char *cp;
    int i;

    cp = trim(file);

    for (i = 0; i < 28; i++)
        if(arbuf.ar_name[i] = *cp)
            cp++;

    arbuf.ar_size = stbuf.st_size;
    arbuf.ar_date = stbuf.st_mtime;
    arbuf.ar_uid = stbuf.st_uid;
    arbuf.ar_gid = stbuf.st_gid;
    arbuf.ar_mode = stbuf.st_mode;
    copyfil(f, tf, 4+8);
    close(f);
}







int
match(void)
{
    int i;

    for(i=0; i<namc; i++) {
        if(namv[i] == 0)
            continue;

        if (strcmp(trim(namv[i]), file) == 0) {
            file = namv[i];
            namv[i] = 0;
            return(1);
        }
    }

    return(0);
}



void
rcmd(void)
{
    int f, i;

    init();
    getaf(0);

    while(!getdir()) {
        bamatch();

        if(namc == 0 || match()) {
            f = stats();

            if(f < 0) {
                if(namc)
                    fprintf((&__stderr), "ar: cannot open %s\n", file);
                goto cp;
            }

            if(flg['u'-'a'])
                if(stbuf.st_mtime <= arbuf.ar_date) {
                    close(f);
                    goto cp;
                }

            mesg('r');
            copyfil(af, -1, 2+1);
            movefil(f);
            continue;
        }

cp:
        mesg('c');
        copyfil(af, tf, 2+4+8);
    }

    for (i = 0; i < namc; i++) {
        file = namv[i];
        if (file == 0) continue;

        namv[i] = 0;
        mesg('a');
        f = stats();

        if (f < 0) {
            fprintf((&__stderr), "ar: %s cannot open\n", file);
            continue;
        }

        movefil(f);
    }

    install();
}



void
dcmd(void)
{
    init();
    getaf(1);

    while (!getdir()) {
        if (match()) {
            mesg('d');
            copyfil(af, -1, 2+1);
        } else {
            mesg('c');
            copyfil(af, tf, 2+4+8);
        }
    }

    install();
}



void
xcmd(void)
{
    int f;

    getaf(1);

    while(!getdir()) {
        if(namc == 0 || match()) {
            f = creat(file, arbuf.ar_mode & 0777);
            if(f < 0) {
                fprintf((&__stderr), "ar: %s cannot create\n", file);
                goto sk;
            }
            mesg('x');
            copyfil(af, f, 2);
            close(f);
            continue;
        }
sk:
        mesg('c');
        copyfil(af, -1, 2+1);

        if (namc > 0 && !morefil())
            done(0);
    }
}



void
pcmd(void)
{
    getaf(1);

    while (!getdir()) {
        if (namc == 0 || match()) {
            if(flg['v'-'a']) {
                printf("\n<%s>\n\n", file);
                fflush((&__stdout));
            }
            copyfil(af, 1, 2);
        } else
            copyfil(af, -1, 2+1);
    }
}



void
mcmd(void)
{
    init();
    getaf(1);

    tf2nam = mktemp(tmp2nam);
    close(creat(tf2nam, 0600));
    tf2 = open(tf2nam, 2);
    if(tf2 < 0) {
        fprintf((&__stderr), "ar: cannot create third temp\n");
        done(1);
    }
    while(!getdir()) {
        bamatch();
        if(match()) {
            mesg('m');
            copyfil(af, tf2, 2+4+8);
            continue;
        }
        mesg('c');
        copyfil(af, tf, 2+4+8);
    }
    install();
}






int m1[] = { 1, 0000400, 'r', '-' };
int m2[] = { 1, 0000200, 'w', '-' };
int m3[] = { 2, 0004000, 's', 0000100, 'x', '-' };
int m4[] = { 1, 0000040, 'r', '-' };
int m5[] = { 1, 0000020, 'w', '-' };
int m6[] = { 2, 0002000, 's', 0000010, 'x', '-' };
int m7[] = { 1, 0000004, 'r', '-' };
int m8[] = { 1, 0000002, 'w', '-' };
int m9[] = { 2, 0001000, 't', 0000001, 'x', '-' };

int *m[] = { m1, m2, m3, m4, m5, m6, m7, m8, m9};

void
longt(void)
{
    char *cp;
    int n, *ap, **mp;

    for (mp = &m[0]; mp < &m[9];) {
        int n, *ap;

        ap = *mp++;
        n = *ap++;

        while (--n >= 0 && (arbuf.ar_mode & *ap++) == 0)
            ap++;

        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (*ap)) : __flushbuf((*ap),((&__stdout))));
    }

    cp = ctime(&arbuf.ar_date);
    printf("  %-12.12s %-4.4s", cp+4, cp+20);

    printf("  %d/%d", arbuf.ar_uid, arbuf.ar_gid);
    printf("  %ld", arbuf.ar_size);
}



void
tcmd(void)
{
    getaf(1);

    while(!getdir()) {
        if(namc == 0 || match()) {
            printf("%-*s", 28, trim(file));

            if(flg['v'-'a'])
                longt();

            (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
        }
        copyfil(af, -1, 2+1);
    }
}



void
getqf(void)
{
    long mbuf;

    if ((qf = open(arnam, 2)) < 0) {
        if(!flg['c'-'a'])
            fprintf((&__stderr), "ar: creating %s\n", arnam);
        close(creat(arnam, 0666));
        if ((qf = open(arnam, 2)) < 0) {
            fprintf((&__stderr), "ar: cannot create %s\n", arnam);
            done(1);
        }
        mbuf = '<tahar!>';
        if (write(qf, &mbuf, sizeof(mbuf)) != sizeof(mbuf))
            wrerr();
    }
    else if (read(qf, &mbuf, sizeof(mbuf)) != sizeof(mbuf) || mbuf!='<tahar!>') {
        fprintf((&__stderr), "ar: %s not in archive format\n", arnam);
        done(1);
    }
}




void
qcmd(void)
{
    int i, f;

    if (flg['a'-'a'] || flg['b'-'a']) {
        fprintf((&__stderr), "ar: abi not allowed with q\n");
        done(1);
    }

    getqf();

    for (i = 0; signum[i]; i++)
        signal(signum[i], ((__sighandler_t) 1));

    lseek(qf, 0, 2);

    for (i = 0; i < namc; i++) {
        file = namv[i];
        if (file == 0) continue;
        namv[i] = 0;
        mesg('q');
        f = stats();

        if (f < 0)
            fprintf((&__stderr), "ar: %s cannot open\n", file);
        else {
            tf = qf;
            movefil(f);
            qf = tf;
        }
    }
}





int
notfound(void)
{
    int i, n;

    n = 0;

    for (i = 0; i < namc; i++)
        if (namv[i]) {
            fprintf((&__stderr), "ar: %s not found\n", namv[i]);
            n++;
        }

    return n;
}



void (*comfun)(void);

void
setcom(void (*fun)(void))
{
    if (comfun != 0) {
        fprintf((&__stderr), "ar: only one of [%s] allowed\n", man);
        done(1);
    }

    comfun = fun;
}

int
main(int argc, char **argv)
{
    int i;
    char *cp;

    for (i = 0; signum[i]; i++)
        if (signal(signum[i], ((__sighandler_t) 1)) != ((__sighandler_t) 1))
            signal(signum[i], sigdone);

    if (argc < 3) usage();

    for (cp = argv[1]; *cp; cp++)
        switch(*cp)
        {
        case 'l':
        case 'v':
        case 'u':
        case 'n':
        case 'a':
        case 'b':
        case 'c':
        case 'i':   flg[*cp - 'a']++; break;

        case 'r':   setcom(rcmd); break;
        case 'd':   setcom(dcmd); break;
        case 'x':   setcom(xcmd); break;
        case 't':   setcom(tcmd); break;
        case 'p':   setcom(pcmd); break;
        case 'm':   setcom(mcmd); break;
        case 'q':   setcom(qcmd); break;

        default:    fprintf((&__stderr), "ar: bad option `%c'\n", *cp);
                    done(1);
        }

    if (flg['l'-'a']) {
        strcpy(tmpnam, "arXXXXXX");
        strcpy(tmp1nam, "arXXXXXX");
        strcpy(tmp2nam, "arXXXXXX");
    }

    if (flg['i'-'a'])
        flg['b'-'a']++;

    if (flg['a'-'a'] || flg['b'-'a']) {
        bastate = 1;
        ponam = trim(argv[2]);
        argv++;
        argc--;
        if(argc < 3) usage();
    }

    arnam = argv[2];
    namv = argv + 3;
    namc = argc - 3;

    if (comfun == 0) {
        if (flg['u'-'a'] == 0) {
            fprintf((&__stderr), "ar: one of [%s] must be specified\n", man);
            done(1);
        }

        setcom(rcmd);
    }

    (*comfun)();
    done(notfound());
}
