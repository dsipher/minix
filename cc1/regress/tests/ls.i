# 1 "ls.c"

# 39 "/home/charles/xcc/minix/include/sys/defs.h"
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
# 48 "/home/charles/xcc/minix/include/stdio.h"
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

















extern FILE *__iotab[32];
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
# 44 "/home/charles/xcc/minix/include/string.h"
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
# 41 "/home/charles/xcc/minix/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;




typedef __dev_t dev_t;

















typedef __gid_t gid_t;




typedef __ino_t ino_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __off_t off_t;




typedef __pid_t pid_t;









typedef __ssize_t ssize_t;




typedef __time_t time_t;




typedef __uid_t uid_t;
# 111 "/home/charles/xcc/minix/include/sys/stat.h"
struct stat
{
    dev_t           st_dev;
    int             __pad0;
    ino_t           st_ino;
    int             __pad1;
    nlink_t         st_nlink;
    int             __pad2;

    mode_t          st_mode;
    uid_t           st_uid;
    gid_t           st_gid;
    int             __pad3;

    dev_t           st_rdev;
    int             __pad4;
    off_t           st_size;
    long            __pad5;
    long            __pad6;

    time_t          st_atime;
    long            __pad7;
    time_t          st_mtime;
    long            __pad8;
    time_t          st_ctime;
    long            __pad9;

    unsigned long   __pad[3];
};





extern int stat(const char *path, struct stat *buf);
extern int fstat(int fildes, struct stat *buf);



int chmod(const char *pathname, mode_t mode);
int fchmod(int fildes, mode_t mode);



int mkdir(const char *path, mode_t mode);



int mknod(const char *path, mode_t mode, dev_t dev);



extern mode_t umask(mode_t cmask);
# 46 "/home/charles/xcc/minix/include/stddef.h"
typedef long ptrdiff_t;
# 53 "/home/charles/xcc/minix/include/stdlib.h"
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
# 97 "/home/charles/xcc/minix/include/unistd.h"
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
# 46 "/home/charles/xcc/minix/include/dirent.h"
struct dirent
{
    ino_t           d_ino;
    int             __pad0;
    long            __pad1;
    unsigned short  d_reclen;
    char            d_name[];
};




extern int getdents(int fildes, struct dirent *dirp, int count);




typedef struct __DIR DIR;

struct __DIR
{
    int     fildes;
    int     pos;
    int     count;







    char    buf[1004];
};



DIR *opendir(const char *dirname);



struct dirent *readdir(DIR *dirp);



void rewinddir(DIR *dirp);



int closedir(DIR *dirp);
# 49 "/home/charles/xcc/minix/include/time.h"
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
    time_t  tv_sec;
    long    tv_nsec;
};








extern char *asctime(const struct tm *timeptr);








extern char *ctime(const time_t *timer);




extern struct tm *localtime(const time_t *timer);




extern struct tm *gmtime(const time_t *timer);




extern size_t strftime(char *s, size_t maxsize, const char *format,
                       const struct tm *timeptr);




extern time_t time(time_t *timer);



extern char *tzname[];
extern long timezone;







extern void tzset(void);




int nanosleep(const struct timespec *rqtp, struct timespec *rtmp);
# 51 "/home/charles/xcc/minix/include/pwd.h"
struct passwd
{
    char    *pw_name;
    char    *pw_passwd;
    uid_t   pw_uid;
    gid_t   pw_gid;
    char    *pw_gecos;
    char    *pw_dir;
    char    *pw_shell;
};



extern struct passwd *getpwuid(uid_t uid);



extern struct passwd *getpwnam(const char *name);



extern void setpwent(void);



extern struct passwd *getpwent(void);



extern void endpwent(void);
# 46 "/home/charles/xcc/minix/include/grp.h"
struct group
{
    char    *gr_name;
    char    *gr_passwd;
    gid_t   gr_gid;
    char    **gr_mem;
};



extern struct group *getgrgid(gid_t gid);



extern struct group *getgrnam(const char *name);



extern struct group *getgrent(void);



extern void setgrent(void);



extern void endgrent(void);
# 39 "/home/charles/xcc/minix/include/errno.h"
extern int errno;
# 74 "/home/charles/xcc/minix/include/fcntl.h"
int creat(const char *path, mode_t mode);



int open(const char *path, int oflag, ...);



int fcntl(int fildes, int cmd, ...);
# 37 "/home/charles/xcc/minix/include/termios.h"
typedef unsigned char cc_t;
typedef unsigned int speed_t;
typedef unsigned int tcflag_t;



struct termios
{
    tcflag_t c_iflag;
    tcflag_t c_oflag;
    tcflag_t c_cflag;
    tcflag_t c_lflag;
    cc_t c_line;
    cc_t c_cc[19];
};

struct winsize
{
    unsigned short  ws_row;
    unsigned short  ws_col;
    unsigned short  ws_xpixel;
    unsigned short  ws_ypixel;
};
# 37 "/home/charles/xcc/minix/include/sys/ioctl.h"
extern int ioctl(int fildes, int cmd, void *arg);
# 67 "ls.c"
char l_ifmt[] = "0pcCd?bB-?l?s???";









int     ncols = 79;

char    *arg0;
int     uid, gid;
int     ex;
int     istty;



void heaperr(void)
{
    fprintf((&__stderr), "%s: Out of memory\n", arg0);
    exit(-1);
}

void *allocate(size_t n)
{
    void *a;

    if ((a = malloc(n)) == 0) heaperr();
    return a;
}

void *reallocate(void *a, size_t n)
{
    if ((a = realloc(a, n)) == 0) heaperr();
    return a;
}

char allowed[] = "acdfghilnpqrstu1ACFLMRTX";
char flags[sizeof(allowed)];

void setflags(char *flgs)
{
    int c;

    while ((c= *flgs++) != 0) {
        if (strchr(allowed, c) == 0) {
            fprintf((&__stderr), "Usage: %s [-%s] [file ...]\n",
                arg0, allowed);

            exit(1);
        } else

        if (strchr(flags, c) == 0) {
            flags[strlen(flags)] = c;
        }
    }
}

int present(int f)
{
    return f == 0 || strchr(flags, f) != 0;
}




void report(char *f)
{
    fprintf((&__stderr), "%s: %s: %s\n", arg0, f, strerror(errno));
    ex= 1;
}







enum whatmap { PASSWD, GROUP };

struct idname {
    struct idname   *next;
    char            *name;
    uid_t           id;
} *uids[32], *gids[32];



char *idname(unsigned id, enum whatmap map)
{
    struct idname *i;
    struct idname **ids = &(map == PASSWD ? uids : gids)[id % 32];

    while ((i = *ids) != 0 && id < i->id) ids = &i->next;

    if (i == 0 || id != i->id) {



        char *name = 0;
        char noname[3 * sizeof(uid_t)];

        if (!present('n')) {
            if (map == PASSWD) {
                struct passwd *pw = getpwuid(id);
                if (pw != 0) name = pw->pw_name;
            } else {
                struct group *gr = getgrgid(id);
                if (gr != 0) name = gr->gr_name;
            }
        }

        if (name == 0) {



            sprintf(noname, "%u", id);
            name = noname;
        }



        i= allocate(sizeof(*i));
        i->id = id;
        i->name = allocate(strlen(name) + 1);
        strcpy(i->name, name);
        i->next = *ids;
        *ids = i;
    }
    return i->name;
}




char *path;
int plen = 0, pidx = 0;




void addpath(int *didx, char *name)
{
    if (plen == 0) path = (char *) allocate((plen = 32) * sizeof(path[0]));

    if (pidx == 1 && path[0] == '.') pidx= 0;
    *didx = pidx;
    if (pidx > 0 && path[pidx-1] != '/') path[pidx++] = '/';

    do {
        if (*name != '/' || pidx == 0 || path[pidx-1] != '/') {
            if (pidx == plen) {
                path = (char *) reallocate((void *) path,
                        (plen *= 2) * sizeof(path[0]));
            }
            path[pidx++]= *name;
        }
    } while (*name++ != 0);

    --pidx;

}



int field = 0;


















struct file {
    struct file *next;
    char        *name;
    ino_t       ino;
    mode_t      mode;
    uid_t       uid;
    gid_t       gid;
    nlink_t     nlink;
    dev_t       rdev;
    off_t       size;
    time_t      mtime;
    time_t      atime;
    time_t      ctime;
};

void setstat(struct file *f, struct stat *stp)
{
    f->ino=     stp->st_ino;
    f->mode=    stp->st_mode;
    f->nlink=   stp->st_nlink;
    f->uid=     stp->st_uid;
    f->gid=     stp->st_gid;
    f->rdev=    stp->st_rdev;
    f->size=    stp->st_size;
    f->mtime=   stp->st_mtime;
    f->atime=   stp->st_atime;
    f->ctime=   stp->st_ctime;
}








static char *timestamp(struct file *f)
{
    struct tm *tm;
    time_t t;
    static time_t now;
    static int drift = 0;
    static char date[] = "Jan 19 03:14:07 2038";
    static char month[] = "JanFebMarAprMayJunJulAugSepOctNovDec";

    t = f->mtime;
    if (field & 0x0080) t = f->atime;
    if (field & 0x0100) t = f->ctime;

    tm = localtime(&t);
    if (--drift < 0) { time(&now); drift = 50; }

    if (field & 0x1000) {
        sprintf(date, "%.3s %2d %02d:%02d:%02d %d",
            month + 3*tm->tm_mon,
            tm->tm_mday,
            tm->tm_hour, tm->tm_min, tm->tm_sec,
            1900 + tm->tm_year);
    } else
        if (t < now - (26*7*24*3600L) || t > now + ( 1*7*24*3600L)) {
            sprintf(date, "%.3s %2d  %d",
                month + 3*tm->tm_mon,
                tm->tm_mday,
                1900 + tm->tm_year);
        } else {
            sprintf(date, "%.3s %2d %02d:%02d",
                month + 3*tm->tm_mon,
                tm->tm_mday,
                tm->tm_hour, tm->tm_min);
        }

    return date;
}



char *permissions(struct file *f)
{
    static char rwx[] = "drwxr-x--x";

    rwx[0] = l_ifmt[((f->mode) >> 12) & 0xF];





    if (field & 0x0004) {
        int mode = f->mode, ucase= 0;

        if (uid == f->uid) {

            ucase = (mode<<3) | (mode<<6);

        } else
            if (gid == f->gid) {
                mode <<= 3;
            } else {
                mode <<= 6;
            }

        rwx[1] = mode&0000400 ? (ucase&0000400 ? 'R' : 'r') : '-';
        rwx[2] = mode&0000200 ? (ucase&0000200 ? 'W' : 'w') : '-';

        if (mode & 0000100) {
            static char sbit[] = { 'x', 'g', 'u', 's' };

            rwx[3] = sbit[(f->mode&(0004000|0002000))>>10];
            if (ucase & 0000100) rwx[3] += 'A'-'a';
        } else {
            rwx[3] = f->mode & (0004000|0002000) ? '=' : '-';
        }
        rwx[4] = 0;
    } else {
        char *p = rwx+1;
        int mode = f->mode;

        do {
            p[0] = (mode & 0000400) ? 'r' : '-';
            p[1] = (mode & 0000200) ? 'w' : '-';
            p[2] = (mode & 0000100) ? 'x' : '-';
            mode <<= 3;
        } while ((p += 3) <= rwx+7);

        if (f->mode & 0004000) rwx[3] = f->mode&(0000100 >> 0) ? 's' : '=';
        if (f->mode & 0002000) rwx[6] = f->mode&(0000100 >> 3) ? 's' : '=';
        if (f->mode & 0001000) rwx[9] = f->mode&(0000100 >> 6) ? 't' : '=';
    }

    return rwx;
}

void numeral(int i, char **pp)
{
    char itoa[3*sizeof(int)], *a=itoa;

    do *a++ = i%10 + '0'; while ((i/=10) > 0);
    do *(*pp)++ = *--a; while (a>itoa);
}






char *cxsize(struct file *f)
{
    static char siz[] = "1.2m";
    char *p = siz;
    off_t z;

    siz[1] = siz[2] = siz[3] = 0;

    if (f->size <= 5*1024L) {
        numeral((int) f->size, &p);
        return siz;
    }

    z = (f->size + 1024L-1) / 1024L;

    if (z <= 999) {
        numeral((int) z, &p);
        *p = 'k';
    } else
        if (z*10 <= 99*1000L) {
            z = (z*10 + 1000L-1) / 1000L;
            numeral((int) z / 10, &p);
            *p++ = '.';
            numeral((int) z % 10, &p);
            *p = 'm';
        } else
            if (z <= 999*1000L) {
                numeral((int) ((z + 1000L-1) / 1000L), &p);
                *p = 'm';
            } else {
                z= (z*10 + 1000L*1000L-1) / (1000L*1000L);
                numeral((int) z / 10, &p);
                *p++ = '.';
                numeral((int) z % 10, &p);
                *p = 'g';
            }

    return siz;
}










static int (*CMP)(struct file *f1, struct file *f2);
static int (*rCMP)(struct file *f1, struct file *f2);






static void mergesort(struct file **al)
{
    struct file *l1, **mid;
    struct file *l2;

    l1 = *(mid= &(*al)->next);
    do {
        if ((l1 = l1->next) == 0) break;
        mid = &(*mid)->next;
    } while ((l1 = l1->next) != 0);

    l2 = *mid;
    *mid = 0;

    if ((*al)->next != 0) mergesort(al);
    if (l2->next != 0) mergesort(&l2);

    l1= *al;
    for (;;) {
        if ((*CMP)(l1, l2) <= 0) {
            if ((l1 = *(al = &l1->next)) == 0) {
                *al = l2;
                break;
            }
        } else {
            *al = l2;
            l2 = *(al= &l2->next);
            *al = l1;
            if (l2 == 0) break;
        }
    }
}

int namecmp(struct file *f1, struct file *f2)
{
    return strcmp(f1->name, f2->name);
}

int mtimecmp(struct file *f1, struct file *f2)
{
    return f1->mtime == f2->mtime ? 0 : f1->mtime > f2->mtime ? -1 : 1;
}

int atimecmp(struct file *f1, struct file *f2)
{
    return f1->atime == f2->atime ? 0 : f1->atime > f2->atime ? -1 : 1;
}

int ctimecmp(struct file *f1, struct file *f2)
{
    return f1->ctime == f2->ctime ? 0 : f1->ctime > f2->ctime ? -1 : 1;
}

int revcmp(struct file *f1, struct file *f2) { return (*rCMP)(f2, f1); }



static void sort(struct file **al)
{
    if (!present('f') && *al != 0 && (*al)->next != 0) {
        CMP = namecmp;

        if (!(field & 0x0040)) {


            if (present('r')) { rCMP = CMP; CMP = revcmp; }
            mergesort(al);
        } else {


            mergesort(al);
            if (field & 0x0100) {
                CMP = ctimecmp;
            } else
            if (field & 0x0080) {
                CMP = atimecmp;
            } else {
                CMP = mtimecmp;
            }

            if (present('r')) { rCMP = CMP; CMP = revcmp; }
            mergesort(al);
        }
    }
}



struct file *newfile(char *name)
{
    struct file *new;

    new= (struct file *) allocate(sizeof(*new));
    new->name= strcpy((char *) allocate(strlen(name)+1), name);
    return new;
}



void pushfile(struct file **flist, struct file *new)
{
    new->next= *flist;
    *flist= new;
}



void delfile(struct file *old)
{
    free((void *) old->name);
    free((void *) old);
}



struct file *popfile(struct file **flist)
{
    struct file *f;

    f= *flist;
    *flist= f->next;
    return f;
}



int dotflag(char *name)
{
    if (*name++ != '.') return 0;

    switch (*name++) {
    case 0:     return 'a';
    case '.':   if (*name == 0) return 'a';
    default:    return 'A';
    }
}



int adddir(struct file **aflist, char *name)
{
    DIR *d;
    struct dirent *e;

    if (access(name, 0) < 0) {
        report(name);
        return 0;
    }

    if ((d = opendir(name)) == 0) {
        report(name);
        return 0;
    }

    while ((e = readdir(d)) != 0) {
        if (e->d_ino != 0 && present(dotflag(e->d_name))) {
            pushfile(aflist, newfile(e->d_name));
            aflist = &(*aflist)->next;
        }
    }

    closedir(d);
    return 1;
}



off_t countblocks(struct file *flist)
{
    off_t cb = 0;

    while (flist != 0) {
        switch (flist->mode & 0170000) {
        case 0040000:
        case 0100000:
            cb += (((flist)->size + 512-1) / 512);
        }
        flist = flist->next;
    }

    return cb;
}




void printname(char *name)
{
    int c, q= present('q');

    while ((c= (unsigned char) *name++) != 0) {
        if (q && (c < ' ' || c == 0177)) c= '?';
        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (c)) : __flushbuf((c),((&__stdout))));
    }
}

int mark(struct file *f, int doit)
{
    int c;

    c= 0;

    if (field & 0x0200) {
        switch (f->mode & 0170000) {
        case 0040000:   c= '/'; break;
        case 0100000:
            if (f->mode & (0000100 | 0000010 | 0000001)) c= '*';
            break;
        }
    } else
        if (field & 0x0400) {
            if ((((f->mode) & 0170000) == 0040000)) c= '/';
        }

    if (doit && c != 0) (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (c)) : __flushbuf((c),((&__stdout))));
    return c;
}



enum { W_COL, W_INO, W_BLK, W_NLINK, W_UID, W_GID, W_SIZE, W_NAME, MAXFLDS };

unsigned char fieldwidth[128][MAXFLDS];




void maxise(unsigned char *aw, int w)
{
    if (w > *aw) {
        if (w > 255) w = 255;
        *aw = w;
    }
}



int numwidth(unsigned long n)
{
    int width = 0;

    do { width++; } while ((n /= 10) > 0);
    return width;
}

int numxwidth(unsigned long n)

{
    int width= 0;

    do { width++; } while ((n /= 16) > 0);
    return width;
}

static int nsp = 0;







void print1(struct file *f, int col, int doit)
{
    int width = 0, n;
    char *p;
    unsigned char *f1width = fieldwidth[col];

    while (nsp>0) { (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (' ')) : __flushbuf((' '),((&__stdout)))); nsp--; }

    if (field & 0x0001) {
        if (doit) {
            printf("%*d ", f1width[W_INO], f->ino);
        } else {
            maxise(&f1width[W_INO], numwidth(f->ino));
            width++;
        }
    }

    if (field & 0x0002) {
        unsigned long nb = ((((((f)->size + 512-1) / 512)) + (1024 / 512 - 1)) / (1024 / 512));

        if (doit) {
            printf("%*lu ", f1width[W_BLK], nb);
        } else {
            maxise(&f1width[W_BLK], numwidth(nb));
            width++;
        }
    }

    if (field & 0x0008) {
        if (doit) {
            printf("%s ", permissions(f));
        } else {
            width += (field & 0x0004) ? 5 : 11;
        }
    }

    if (field & 0x0004) {
        p = cxsize(f);
        n = strlen(p)+1;

        if (doit) {
            n = f1width[W_SIZE] - n;
            while (n > 0) { (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (' ')) : __flushbuf((' '),((&__stdout)))); --n; }
            printf("%s ", p);
        } else {
            maxise(&f1width[W_SIZE], n);
        }
    }

    if (field & 0x0010) {
        if (doit) {
            printf("%*u ", f1width[W_NLINK], (unsigned) f->nlink);
        } else {
            maxise(&f1width[W_NLINK], numwidth(f->nlink));
            width++;
        }

        if (!(field & 0x0020)) {
            if (doit) {
                printf("%-*s  ", f1width[W_UID],
                            idname((f->uid), PASSWD));
            } else {
                maxise(&f1width[W_UID],
                        strlen(idname((f->uid), PASSWD)));
                width += 2;
            }
        }

        if (doit) {
            printf("%-*s  ", f1width[W_GID], idname((f->gid), GROUP));
        } else {
            maxise(&f1width[W_GID], strlen(idname((f->gid), GROUP)));
            width += 2;
        }

        switch (f->mode & 0170000) {
        case 0060000:
        case 0020000:
            if (doit) {
                printf("%*d, %3d ", f1width[W_SIZE] - 5,
                    (((f->rdev) >> 8) & 0xFF), ((f->rdev) & 0xFF));
            } else {
                maxise(&f1width[W_SIZE],
                        numwidth((((f->rdev) >> 8) & 0xFF)) + 5);
                width++;
            }
            break;
        default:
            if (field & 0x4000) {
                p = cxsize(f);
                n = strlen(p)+1;

                if (doit) {
                    n= f1width[W_SIZE] - n;
                    while (n > 0) { (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (' ')) : __flushbuf((' '),((&__stdout)))); --n; }
                    printf("%s ", p);
                } else {
                    maxise(&f1width[W_SIZE], n);
                }
            } else {
                if (doit) {
                    printf("%*lu ", f1width[W_SIZE],
                        (unsigned long) f->size);
                } else {
                    maxise(&f1width[W_SIZE],
                        numwidth(f->size));
                    width++;
                }
            }
        }

        if (doit) {
            printf("%s ", timestamp(f));
        } else {
            width += (field & 0x1000) ? 21 : 13;
        }
    }

    n = strlen(f->name);

    if (doit) {
        printname(f->name);
        if (mark(f, 1) != 0) n++;
        (nsp = (f1width[W_NAME] - n));
    } else {
        if (mark(f, 0) != 0) n++;
        maxise(&f1width[W_NAME], n + 3);

        for (n = 1; n < MAXFLDS; n++) width += f1width[n];
        maxise(&f1width[W_COL], width);
    }
}



int countfiles(struct file *flist)
{
    int n = 0;

    while (flist != 0) { n++; flist= flist->next; }

    return n;
}

struct file *filecol[128];
int nfiles, nlines;




void columnise(struct file *flist, int nplin)
{
    int i, j;

    nlines = (nfiles + nplin - 1) / nplin;

    filecol[0]= flist;

    for (i = 1; i < nplin; i++) {
        for (j = 0; j < nlines && flist != 0; j++) flist = flist->next;
        filecol[i] = flist;
    }
}




int print(struct file *flist, int nplin, int doit)
{
    register struct file *f;
    register int col, fld, totlen;

    columnise(flist, nplin);

    if (!doit) {
        for (col = 0; col < nplin; col++) {
            for (fld = 0; fld < MAXFLDS; fld++) {
                fieldwidth[col][fld] = 0;
            }
        }
    }

    while (--nlines >= 0) {
        totlen = 0;

        for (col = 0; col < nplin; col++) {
            if ((f = filecol[col]) != 0) {
                filecol[col] = f->next;
                print1(f, col, doit);
            }

            if (!doit && nplin > 1) {

                if (fieldwidth[col][W_COL] == 255) {
                    return 0;
                }
                totlen += fieldwidth[col][W_COL];
                if (totlen > ncols+3) return 0;
            }
        }

        if (doit) (nsp = 0, (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout)))));
    }

    return 1;
}

enum depth { SURFACE, SURFACE1, SUBMERGED };
enum state { BOTTOM, SINKING, FLOATING };






void listfiles(struct file *flist, enum depth depth, enum state state)
{
    struct file *dlist= 0, **afl= &flist, **adl= &dlist;
    int nplin;
    static int white = 1;




    fflush((&__stdout));

    if (field != 0 || state != BOTTOM) {
        while (*afl != 0) {
            static struct stat st;
            int r, didx;

            addpath(&didx, (*afl)->name);

            if ((r = stat(path, &st)) < 0) {
                if (depth != SUBMERGED || errno != 2)
                    report((*afl)->name);

                delfile(popfile(afl));
            } else {
                setstat(*afl, &st);
                afl= &(*afl)->next;
            }
            (path[pidx = didx] = 0);
        }
    }

    sort(&flist);

    if (depth == SUBMERGED && (field & (0x0002 | 0x0010))) {
        printf("total %ld\n", (((countblocks(flist)) + (1024 / 512 - 1)) / (1024 / 512)));
    }

    if (state == SINKING || depth == SURFACE1) {



        afl= &flist;

        while (*afl != 0) {
            if (((*afl)->mode & 0170000) == 0040000) {
                pushfile(adl, popfile(afl));
                adl= &(*adl)->next;
            } else {
                afl= &(*afl)->next;
            }
        }
    }

    if ((nfiles = countfiles(flist)) > 0) {

        nplin = !present('C') ? 1 : nfiles < 128 ? nfiles : 128;
        while (!print(flist, nplin, 0)) nplin--;
        print(flist, nplin, 1);
        white = 0;
    }

    while (flist != 0) {
        if (state == FLOATING && (flist->mode & 0170000) == 0040000) {

            pushfile(adl, popfile(&flist));
            adl = &(*adl)->next;
        } else {
            delfile(popfile(&flist));
        }
    }

    while (dlist != 0) {
        if (dotflag(dlist->name) != 'a' || depth != SUBMERGED) {
            int didx;

            addpath(&didx, dlist->name);

            flist = 0;
            if (adddir(&flist, path)) {
                if (depth != SURFACE1) {
                    if (!white) (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
                    printf("%s:\n", path);
                    white = 0;
                }

                listfiles(flist, SUBMERGED,
                    state == FLOATING ? FLOATING : BOTTOM);
            }

            (path[pidx = didx] = 0);
        }

        delfile(popfile(&dlist));
    }
}

int main(int argc, char **argv)
{
    struct file *flist= 0, **aflist= &flist;
    enum depth depth;
    char *lsflags;
    struct winsize ws;

    uid= geteuid();
    gid= getegid();

    if ((arg0= strrchr(argv[0], '/')) == 0) arg0 = argv[0]; else arg0++;
    argv++;

    while (*argv != 0 && (*argv)[0] == '-') {
        if ((*argv)[1] == '-' && (*argv)[2] == 0) {
            argv++;
            break;
        }

        setflags(*argv++ + 1);
    }

    istty = isatty(1);

    if (istty && (lsflags = getenv("LSOPTS")) != 0) {
        if (*lsflags == '-') lsflags++;
        setflags(lsflags);
    }

    if (!present('1') && !present('C') && !present('l')
        && (istty || present('M') || present('X') || present('F'))
    ) setflags("C");

    if (istty) setflags("q");

    if (uid == 0 || present('a')) setflags("A");

    if (present('i')) field |= 0x0001;
    if (present('s')) field |= 0x0002;
    if (present('M')) field |= 0x0008;
    if (present('X')) field |= 0x0004 | 0x0008;
    if (present('t')) field |= 0x0040;
    if (present('u')) field |= 0x0080;
    if (present('c')) field |= 0x0100;
    if (present('l')) field |= 0x0008 | 0x0010;
    if (present('g')) field |= 0x0008 | 0x0010 | 0x0020;
    if (present('F')) field |= 0x0200;
    if (present('p')) field |= 0x0400;
    if (present('T')) field |= 0x0008 | 0x0010 | 0x1000;
    if (present('d')) field |= 0x2000;
    if (present('h')) field |= 0x4000;

    if (field & 0x0010) field &= ~0x0004;

    if (present('C')) {
        int t = istty ? 1 : open("/dev/tty", 00000001);

        if (t >= 0 && ioctl(t, 0x00005413, &ws) == 0 && ws.ws_col > 0)
            ncols = ws.ws_col - 1;

        if (t != 1 && t != -1) close(t);
    }

    depth = SURFACE;

    if (*argv == 0) {
        if (!(field & 0x2000)) depth= SURFACE1;
        pushfile(aflist, newfile("."));
    } else {
        if (argv[1] == 0 && !(field & 0x2000)) depth= SURFACE1;

        do {
            pushfile(aflist, newfile(*argv++));
            aflist= &(*aflist)->next;
        } while (*argv!=0);
    }

    listfiles(flist, depth,
        (field & 0x2000) ? BOTTOM : present('R') ? FLOATING : SINKING);

    return ex;
}
