# 1 "names.c"

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
# 43 "/home/charles/xcc/linux/include/unistd.h"
typedef __size_t size_t;




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
# 44 "names.c"
static int  saveuid = -993;
static char saveuname[32];
static int  my_uid = -993;

static int  savegid = -993;
static char savegname[32];
static int  my_gid = -993;













void
finduname(char *uname, int uid)
{
    struct passwd   *pw;
    extern struct passwd *getpwuid ();

    if (uid != saveuid) {
        saveuid = uid;
        saveuname[0] = '\0';
        pw = getpwuid(uid);
        if (pw)
            strncpy(saveuname, pw->pw_name, 32);
    }
    strncpy(uname, saveuname, 32);
}

int
finduid(char *uname)
{
    struct passwd   *pw;
    extern struct passwd *getpwnam();

    if (uname[0] != saveuname[0]
        || 0!=strncmp(uname, saveuname, 32)) {
        strncpy(saveuname, uname, 32);
        pw = getpwnam(uname);
        if (pw) {
            saveuid = pw->pw_uid;
        } else {
            saveuid = ( my_uid < 0? (my_uid = getuid()): my_uid );
        }
    }
    return saveuid;
}


void
findgname(char *gname, int gid)
{
    struct group    *gr;
    extern struct group *getgrgid ();

    if (gid != savegid) {
        savegid = gid;
        savegname[0] = '\0';
        setgrent();
        gr = getgrgid(gid);
        if (gr)
            strncpy(savegname, gr->gr_name, 32);
    }
    (void) strncpy(gname, savegname, 32);
}


int
findgid(char *gname)
{
    struct group    *gr;
    extern struct group *getgrnam();

    if (gname[0] != savegname[0]
        || 0!=strncmp(gname, savegname, 32)) {
        strncpy(savegname, gname, 32);
        gr = getgrnam(gname);
        if (gr) {
            savegid = gr->gr_gid;
        } else {
            savegid = ( my_gid < 0? (my_gid = getgid()): my_gid );
        }
    }
    return savegid;
}
