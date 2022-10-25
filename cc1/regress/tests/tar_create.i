# 1 "create.c"

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

















extern FILE *__iotab[20];
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
# 48 "/home/charles/xcc/linux/include/unistd.h"
typedef __ssize_t ssize_t;




typedef __gid_t gid_t;




typedef __uid_t uid_t;




typedef __off_t off_t;




typedef __pid_t pid_t;

















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
# 41 "/home/charles/xcc/linux/include/dirent.h"
typedef __ino_t ino_t;




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
# 41 "/home/charles/xcc/linux/include/fcntl.h"
typedef __mode_t mode_t;





int creat(const char *path, mode_t mode);















int open(const char *path, int oflag, ...);











int fcntl(int fildes, int cmd, ...);
# 39 "/home/charles/xcc/linux/include/errno.h"
extern int errno;
# 51 "/home/charles/xcc/linux/include/pwd.h"
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
# 46 "/home/charles/xcc/linux/include/grp.h"
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
# 41 "/home/charles/xcc/linux/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;




typedef __dev_t dev_t;
# 84 "/home/charles/xcc/linux/include/sys/types.h"
typedef __nlink_t nlink_t;
# 109 "/home/charles/xcc/linux/include/sys/types.h"
typedef __time_t time_t;
# 111 "/home/charles/xcc/linux/include/sys/stat.h"
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
# 62 "tar.h"
union record {
    char        charptr[512];
    struct header {
        char    name[100];
        char    mode[8];
        char    uid[8];
        char    gid[8];
        char    size[12];
        char    mtime[12];
        char    chksum[8];
        char    linkflag;
        char    linkname[100];
        char    magic[8];
        char    uname[32];
        char    gname[32];
        char    devmajor[8];
        char    devminor[8];
    } header;
};
# 113 "tar.h"
extern union record *ar_block;
extern union record *ar_record;
extern union record *ar_last;
extern char     ar_reading;
extern int      blocking;
extern int      blocksize;
extern char     *ar_file;
extern char     *name_file;
extern char     *tar;




extern char f_reblock;
extern char f_create;
extern char f_diff;
extern char f_dironly;
extern char f_follow_links;
extern char f_ignorez;
extern char f_keep;
extern char f_local_filesys;
extern char f_modified;
extern char f_oldarch;
extern char f_use_protection;
extern char f_sayblock;
extern char f_sorted_names;
extern char f_list;
extern char f_namefile;
extern char f_verbose;
extern char f_extract;
extern char f_compress;
















struct name {
    struct name *next;
    short       length;
    char        found;
    char        firstch;
    char        regexp;
    char        name[100+1];
};

extern struct name  *namelist;
extern struct name  *namelast;

extern int      archive;
extern int      errors;











struct link {
    struct link *next;
    dev_t       dev;
    ino_t       ino;
    short       linkcount;
    char        name[100+1];
};

extern struct link  *linklist;





extern char     read_error_flag;






void            saverec(union record **pointer);
void            userec(union record *rec);
union record    *findrec(void);
union record    *endofrecs(void);
void            anno(FILE *stream, char *prefix, int savedp);
void            open_archive(int read);
void            close_archive(void);
void            name_close(void);
int             wildmat(char *s, char *p);
void            name_gather(void);
void            extr_init(void);
int             read_header(void);
int             finduid(char *uname);
int             findgid(char *gname);
int             name_match(char *p);
void            names_notfound(void);

void            decode_header(union record *header, struct stat *st,
                              int *stdp, int wantug);

int             getoldopt(int argc, char **argv, char *optstring);
void            read_and(void (*do_something)(void));
void            list_archive(void);
void            extract_archive(void);
void            create_archive(void);
void            print_header(FILE *outfile);
void            finduname(char *uname, int uid);
void            findgname(char *gname, int gid);
char            *name_next(void);
# 49 "create.c"
extern union record *head;
extern struct stat hstat;
extern int head_standard;








union record *start_header();
void finish_header();
void to_oct();
void dump_file();

static nolinks;







static void
write_eot(void)
{
    union record *p;
    int bufsize;

    p = findrec();
    bufsize = endofrecs()->charptr - p->charptr;
    memset(p->charptr, 0, bufsize);
    userec(p);
}

void
create_archive(void)
{
    register char   *p;

    open_archive(0);

    while (p = name_next()) {
        dump_file(p, -1);
    }

    write_eot();
    close_archive();
    name_close();
}






void
dump_file(p, curdev)
    char    *p;
    int curdev;
{
    union record    *header;
    char type;






    if (0 != f_follow_links? stat(p, &hstat): stat(p, &hstat))
    {
badperror:
        perror(p);
badfile:
        errors++;
        return;
    }





    if (f_local_filesys && curdev >= 0 && curdev != hstat.st_dev) {
        anno((&__stderr), tar, 0);
        fprintf((&__stderr),
            "%s: is on a different filesystem; not dumped\n",
            p);
        return;
    }








    if (hstat.st_nlink > 1) switch (hstat.st_mode & 0170000) {
        register struct link    *lp;

    case 0100000:




    case 0020000:



    case 0060000:







        for (lp = linklist; lp; lp = lp->next) {
            if (lp->ino == hstat.st_ino &&
                lp->dev == hstat.st_dev) {

                hstat.st_size = 0;
                header = start_header(p, &hstat);
                if (header == ((void *) 0)) goto badfile;
                strcpy(header->header.linkname,
                    lp->name);
                header->header.linkflag = '1';
                finish_header(header);

                return;
            }
        }


        lp = (struct link *) malloc( (unsigned)
            (strlen(p) + sizeof(struct link) - 100));
        if (!lp) {
            if (!nolinks) {
                fprintf((&__stderr),
    "tar: no memory for links, they will be dumped as separate files\n");
                nolinks++;
            }
        }
        lp->ino = hstat.st_ino;
        lp->dev = hstat.st_dev;
        strcpy(lp->name, p);
        lp->next = linklist;
        linklist = lp;
    }




    switch (hstat.st_mode & 0170000) {

    case 0100000:



    {
        int f;
        int bufsize, count;
        register long   sizeleft;
        register union record   *start;

        sizeleft = hstat.st_size;

        if (sizeleft > 0 || 0444 != (0444 & hstat.st_mode)) {
            f = open(p, 00000000);
            if (f < 0) goto badperror;
        } else {
            f = -1;
        }
        header = start_header(p, &hstat);
        if (header == ((void *) 0)) goto badfile;






        finish_header(header);
        while (sizeleft > 0) {
            start = findrec();
            bufsize = endofrecs()->charptr - start->charptr;
            if (sizeleft < bufsize) {

                bufsize = (int)sizeleft;
                count = bufsize % 512;
                if (count)
                    memset(start->charptr + sizeleft,
                        0, 512 - count);
            }
            count = read(f, start->charptr, bufsize);
            if (count < 0) {
                anno((&__stderr), tar, 0);
                fprintf((&__stderr),
                  "read error at byte %ld, reading %d bytes, in file ",
                    hstat.st_size - sizeleft,
                    bufsize);
                perror(p);
                goto padit;
            }
            sizeleft -= count;

            userec(start+(count-1)/512);
            if (count == bufsize) continue;
            anno((&__stderr), tar, 0);
            fprintf((&__stderr),
              "%s: file shrunk by %d bytes, padding with zeros.\n",
                p, sizeleft);
            goto padit;
        }
        if (f >= 0)
            (void)close(f);

        break;





    padit:
        abort();
    }
# 299 "create.c"
    case 0040000:
    {
        register DIR *dirp;
        register struct dirent *d;
        char namebuf[100+2];
        register int len;
        int our_device = hstat.st_dev;


        strncpy(namebuf, p, sizeof (namebuf));
        len = strlen(namebuf);
        while (len >= 1 && '/' == namebuf[len-1])
            len--;
        namebuf[len++] = '/';
        namebuf[len] = '\0';






        if (!f_oldarch) {
            hstat.st_size = 0;







            header = start_header(namebuf, &hstat);
            if (header == ((void *) 0))
                goto badfile;
            if ((!f_oldarch)) {
                header->header.linkflag = '5';
            }
            finish_header(header);
        }


        if (len == 2 && namebuf[0] == '.') {
            len = 0;
        }


        if (f_dironly)
            break;
        errno = 0;
        dirp = opendir(p);
        if (!dirp) {
            if (errno) {
                perror (p);
            } else {
                anno((&__stderr), tar, 0);
                fprintf((&__stderr), "%s: error opening directory",
                    p);
            }
            break;
        }


        while (((void *) 0) != (d=readdir(dirp))) {

            if (d->d_name[0] == '.') {
                if (d->d_name[1] == '\0') continue;
                if (d->d_name[1] == '.') {
                    if (d->d_name[2] == '\0') continue;
                }
            }
            if (strlen(d->d_name) + len >= 100) {
                anno((&__stderr), tar, 0);
                fprintf((&__stderr), "%s%s: name too long\n",
                    namebuf, d->d_name);
                continue;
            }
            strcpy(namebuf+len, d->d_name);
            dump_file(namebuf, our_device);
        }

        closedir(dirp);
    }
        break;


    case 0020000:
        type = '3';
        goto easy;



    case 0060000:
        type = '4';
        goto easy;







    easy:
        if (!(!f_oldarch)) goto unknown;

        hstat.st_size = 0;
        header = start_header(p, &hstat);
        if (header == ((void *) 0)) goto badfile;

        header->header.linkflag = type;
        if (type != '6') {
            to_oct((long) (((hstat.st_rdev) >> 8) & 0xFF), 8,
                header->header.devmajor);
            to_oct((long) ((hstat.st_rdev) & 0xFF), 8,
                header->header.devminor);
        }

        finish_header(header);
        break;

    default:
    unknown:
        anno((&__stderr), tar, 0);
        fprintf((&__stderr),
            "%s: Unknown file type; file ignored.\n", p);
        break;
    }
}






union record *
start_header(name, st)
    char    *name;
    register struct stat *st;
{
    register union record *header;

    header = (union record *) findrec();
    memset(header->charptr, 0, sizeof(*header));




    while ('/' == *name) {
        static int warned_once = 0;

        name++;
        if (!warned_once++) {
            anno((&__stderr), tar, 0);
            fprintf((&__stderr),
    "Removing leading / from absolute path names in the archive.\n");
        }
    }
    strcpy(header->header.name, name);
    if (header->header.name[100-1]) {
        anno((&__stderr), tar, 0);
        fprintf((&__stderr), "%s: name too long\n", name);
        return ((void *) 0);
    }

    to_oct((long) (st->st_mode & ~0170000),
                    8,  header->header.mode);
    to_oct((long) st->st_uid,   8,  header->header.uid);
    to_oct((long) st->st_gid,   8,  header->header.gid);
    to_oct((long) st->st_size,  1+12, header->header.size);
    to_oct((long) st->st_mtime, 1+12, header->header.mtime);




    if ((!f_oldarch)) {
        header->header.linkflag = '0';
        strcpy(header->header.magic, "ustar  ");
        finduname(header->header.uname, st->st_uid);
        findgname(header->header.gname, st->st_gid);
    }

    return header;
}





void
finish_header(header)
    register union record *header;
{
    register int    i, sum;
    register char   *p;

    memcpy(header->header.chksum, "        ", sizeof(header->header.chksum));

    sum = 0;
    p = header->charptr;
    for (i = sizeof(*header); --i >= 0; ) {




        sum += 0xFF & *p++;
    }












    to_oct((long) sum,  8,  header->header.chksum);
    header->header.chksum[6] = '\0';

    userec(header);

    if (f_verbose) {

        head = header;

        head_standard = (!f_oldarch);
        print_header((&__stderr));
    }

    return;
}















void
to_oct(value, digs, where)
    register long   value;
    register int    digs;
    register char   *where;
{

    --digs;
    where[--digs] = ' ';


    do {
        where[--digs] = '0' + (char)(value & 7);
        value >>= 3;
    } while (digs > 0 && value != 0);


    while (digs > 0)
        where[--digs] = ' ';

}
