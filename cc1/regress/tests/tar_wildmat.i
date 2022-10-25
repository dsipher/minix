# 1 "wildmat.c"

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
# 41 "/home/charles/xcc/linux/include/sys/types.h"
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
# 37 "wildmat.c"
static int
star(char *s, char *p)
{
    while (wildmat(s, p) == 0)
        if (*++s == '\0')
            return 0;

    return 1;
}

int
wildmat(char *s, char *p)
{
    int last;
    int matched;
    int reverse;

    for (; *p; s++, p++)
        switch (*p) {
        case '\\':


                        p++;

        default:        if (*s != *p)
                            return 0;

                        break;

        case '?':

                        if (*s == '\0')
                            return 0;

                        break;

        case '*':

                        return (*++p ? star(s, p) : 1);

        case '[':


                        if (reverse = p[1] == '^')
                            p++;

                        for (last = 0400, matched = 0;
                             *++p && *p != ']'; last = *p)
                        {

                            if (*p == '-' ? *s <= *++p && *s >= last
                                          : *s == *p)
                                matched = 1;

                            if (matched == reverse)
                                return 0;
                        }
    }

    return (*s == '\0' || *s == '/');
}
