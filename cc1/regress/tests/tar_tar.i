# 1 "tar.c"

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
# 43 "/home/charles/xcc/linux/include/stdlib.h"
typedef __size_t size_t;









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
# 48 "/home/charles/xcc/linux/include/stdio.h"
typedef __off_t fpos_t;












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
# 41 "/home/charles/xcc/linux/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;




typedef __dev_t dev_t;
# 74 "/home/charles/xcc/linux/include/sys/types.h"
typedef __ino_t ino_t;




typedef __mode_t mode_t;




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
 union record *ar_block;
 union record *ar_record;
 union record *ar_last;
 char     ar_reading;
 int      blocking;
 int      blocksize;
 char     *ar_file;
 char     *name_file;
 char     *tar;




 char f_reblock;
 char f_create;
 char f_diff;
 char f_dironly;
 char f_follow_links;
 char f_ignorez;
 char f_keep;
 char f_local_filesys;
 char f_modified;
 char f_oldarch;
 char f_use_protection;
 char f_sayblock;
 char f_sorted_names;
 char f_list;
 char f_namefile;
 char f_verbose;
 char f_extract;
 char f_compress;
















struct name {
    struct name *next;
    short       length;
    char        found;
    char        firstch;
    char        regexp;
    char        name[100+1];
};

 struct name  *namelist;
 struct name  *namelast;

 int      archive;
 int      errors;











struct link {
    struct link *next;
    dev_t       dev;
    ino_t       ino;
    short       linkcount;
    char        name[100+1];
};

 struct link  *linklist;





 char     read_error_flag;






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
# 48 "tar.c"
static FILE     *namef;
static char     **n_argv;
static int      n_argc;




static void
describe(void)
{
    fputs(
        "tar: valid options:\n"
        "-b N    blocking factor N (block size = Nx512 bytes)\n"
        "-B  reblock as we read (for reading 4.2BSD pipes)\n"
        "-c  create an archive\n"
        "-D  don't dump the contents of directories, just the directory\n"
        "-f F read/write archive from file or device F (or hostname:/ForD)\n"
        "-h  don't dump symbolic links; dump the files they point to\n"
        "-i  ignore blocks of zeros in the archive, which normally mean EOF\n"
        "-k  keep existing files, don't overwrite them from the archive\n"
        "-l  stay in the local file system when creating an archive\n"
        "-m  don't extract file modified time\n"
        "-o  write an old V7 format archive, rather than POSIX format\n"
        "-p  do extract all protection information\n"
        "-R  dump record number within archive with each message\n"
        "-s  list of names to extract is sorted to match the archive\n"
        "-t  list a table of contents of an archive\n"
        "-T F    get names to extract or create from file F\n"
        "-v  verbosely list what files we process\n"
        "-x  extract files from an archive\n"
        "-z or Z run the archive through compress\n", (&__stderr));
}



static int
options(int argc, char **argv)
{
    int c;



    blocking = 20;
    ar_file = getenv("TAPE");

    if (ar_file == 0)
        ar_file = "-";

    while ((c = getoldopt(argc, argv, "b:BcDf:hiklmopRstT:vxzZ")) != (-1)) {
        switch (c) {

        case 'b':
            blocking = atoi(optarg);
            break;

        case 'B':
            f_reblock++;
            break;

        case 'c':
            f_create++;
            break;

        case 'D':
            f_dironly++;
            break;

        case 'f':
            ar_file = optarg;
            break;

        case 'h':
            f_follow_links++;
            break;

        case 'i':
            f_ignorez++;





            break;

        case 'k':
            f_keep++;
            break;

        case 'l':
            f_local_filesys++;
            break;

        case 'm':
            f_modified++;
            break;

        case 'o':
            f_oldarch++;
            break;

        case 'p':
            f_use_protection++;
            break;

        case 'R':
            f_sayblock++;
            break;

        case 's':
            f_sorted_names++;
            break;

        case 't':
            f_list++;
            f_verbose++;
            break;

        case 'T':
            name_file = optarg;
            f_namefile++;
            break;

        case 'v':
            f_verbose++;
            break;

        case 'x':
            f_extract++;
            break;

        case 'z':
        case 'Z':
            f_compress++;
            break;

        case '?':
            describe();
            exit(1);

        }
    }

    blocksize = blocking * 512;
}





static void
name_init(int argc, char **argv)
{
    if (f_namefile) {
        if (optind < argc) {
            fprintf((&__stderr), "tar: too many args with -T option\n");
            exit(1);
        }
        if (!strcmp(name_file, "-")) {
            namef = (&__stdin);
        } else {
            namef = fopen(name_file, "r");
            if (namef == ((void *) 0)) {
                fprintf((&__stderr), "tar: ");
                perror(name_file);
                exit(2);
            }
        }
    } else {

        n_argc = argc;
        n_argv = argv;
    }
}




char *
name_next(void)
{
    static char buffer[100+2];

    char *p;
    char *q;

    if (namef == ((void *) 0)) {

        if (optind < n_argc)
            return n_argv[optind++];

        return ((void *) 0);
    }

    for (;;) {
        p = fgets(buffer, 100+1       , namef);
        if (p == ((void *) 0)) return p;
        q = p+strlen(p)-1;
        if (q <= p) continue;
        *q-- = '\0';
        while (q > p && *q == '/')  *q-- = '\0';
        return p;
    }
}



void
name_close(void)
{
    if (namef != ((void *) 0) && namef != (&__stdin)) fclose(namef);
}



static void
addname(char *name)
{
    struct name *p;
    int         i;

    i = strlen(name);
    p = malloc((i + sizeof(struct name) - 100));

    if (!p) {
        fprintf((&__stderr),"tar: cannot allocate mem for namelist entry\n");
        exit(4);
    }

    p->next = (struct name *)((void *) 0);
    p->length = i;
    strncpy(p->name, name, i);
    p->name[i] = '\0';
    p->found = 0;
    p->regexp = 0;
    p->firstch = 1;

    if (strchr(name, '*') || strchr(name, '[') || strchr(name, '?')) {
        p->regexp = 1;
        if (name[0] == '*' || name[0] == '[' || name[0] == '?')
            p->firstch = 0;
    }

    if (namelast) namelast->next = p;
    namelast = p;
    if (!namelist) namelist = p;
}









void
name_gather(void)
{
    static struct name namebuf[1];

    char *p;

    if (f_sorted_names) {
        p = name_next();

        if (p) {
            namebuf[0].length = strlen(p);

            if (namebuf[0].length >= sizeof namebuf[0].name) {
                fprintf((&__stderr), "Argument name too long: %s\n", p);
                namebuf[0].length = (sizeof namebuf[0].name) - 1;
            }

            strncpy(namebuf[0].name, p, namebuf[0].length);
            namebuf[0].name[ namebuf[0].length ] = 0;
            namebuf[0].next = (struct name *)((void *) 0);
            namebuf[0].found = 0;
            namelist = namebuf;
            namelast = namelist;
        }
        return;
    }



    while (((void *) 0) != (p = name_next()))
        addname(p);
}



int
name_match(char *p)
{
    struct name *nlp;
    int         len;

again:
    if (0 == (nlp = namelist))
        return 1;

    len = strlen(p);
    for (; nlp != 0; nlp = nlp->next) {


        if (nlp->firstch && nlp->name[0] != p[0])
            continue;



        if (nlp->regexp) {
            if (wildmat(p, nlp->name)) {
                nlp->found = 1;
                return 1;
            }
            continue;
        }



        if (nlp->length <= len
         && (p[nlp->length] == '\0' || p[nlp->length] == '/')

         && strncmp(p, nlp->name, nlp->length) == 0)
        {
            nlp->found = 1;
            return 1;
        }
    }







    if (f_sorted_names && namelist->found) {
        name_gather();
        if (!namelist->found) goto again;
    }

    return 0;
}



void
names_notfound(void)
{
    register struct name    *nlp;
    register char       *p;

    for (nlp = namelist; nlp != 0; nlp = nlp->next) {
        if (!nlp->found) {
            fprintf((&__stderr), "tar: %s not found in archive\n",
                nlp->name);
        }
    }

    namelist = ((void *) 0);
    namelast = ((void *) 0);

    if (f_sorted_names) {
        while (0 != (p = name_next()))
            fprintf((&__stderr), "tar: %s not found in archive\n", p);
    }
}



int
main(int argc, char **argv)
{
    tar = "tar";

    options(argc, argv);
    name_init(argc, argv);

    if (f_create) {
        if (f_extract || f_list) goto dupflags;
        create_archive();
    } else if (f_extract) {
        if (f_list) goto dupflags;
        extr_init();
        read_and(extract_archive);
    } else if (f_list) {
        read_and(list_archive);
    } else {
dupflags:
        fprintf ((&__stderr), "tar: you must specify exactly "
                         " one of the c, t, or x options\n");
        describe();
        exit(1);
    }

    exit(0);
}
