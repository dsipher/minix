# 1 "buffer.c"

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
# 39 "/home/charles/xcc/linux/include/errno.h"
extern int errno;
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
# 41 "/home/charles/xcc/linux/include/signal.h"
typedef __pid_t pid_t;
















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
# 41 "/home/charles/xcc/linux/include/fcntl.h"
typedef __mode_t mode_t;





int creat(const char *path, mode_t mode);















int open(const char *path, int oflag, ...);











int fcntl(int fildes, int cmd, ...);
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
# 41 "/home/charles/xcc/linux/include/sys/stat.h"
typedef __dev_t dev_t;









typedef __ino_t ino_t;
# 89 "/home/charles/xcc/linux/include/sys/stat.h"
typedef __nlink_t nlink_t;









typedef __time_t time_t;











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
# 53 "/home/charles/xcc/linux/include/sys/wait.h"
extern pid_t wait(int *wstatus);
extern pid_t waitpid(pid_t pid, int *wstatus, int options);
# 41 "/home/charles/xcc/linux/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;
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
# 64 "buffer.c"
static union record **save_rec;
static union record record_save_area;
static long     saved_recno;




static int  childpid = 0;




static long baserec;




static int  r_error_count;




static int  eof;


static void flush_archive(void);








union record *
findrec(void)
{
    if (ar_record == ar_last) {
        if (eof)
            return (union record *)((void *) 0);
        flush_archive();
        if (ar_record == ar_last) {
            eof++;
            return (union record *)((void *) 0);
        }
    }
    return ar_record;
}







void
userec(union record *rec)
{
    while(rec >= ar_record)
        ar_record++;






    if (ar_record > ar_last)
        abort();
}








union record *
endofrecs(void)
{
    return ar_last;
}







static void
dupto(int from, int to, char *msg)
{
    int err;

    if (from != to) {
        (void) close(to);
        err = dup(from);
        if (err != to) {
            fprintf((&__stderr), "tar: cannot dup ");
            perror(msg);
            exit(4);
        }
        (void) close(from);
    }
}






void
child_open(char *rem_host, char *rem_file)
{
    int pipes[2];
    int err;
    struct stat arstat;
    char cmdbuf[1000];


    err = pipe(pipes);
    if (err < 0) {
        perror ("tar: cannot create pipe to child");
        exit(4);
    }


    childpid = fork();
    if (childpid < 0) {
        perror("tar: cannot fork");
        exit(4);
    }













    if (childpid > 0) {
        (void) close (archive);
        if (ar_reading) {
            (void) close (pipes[1]);
            archive = pipes[0];
            f_reblock++;
        } else {
            (void) close (pipes[0]);
            archive = pipes[1];
        }
        return;
    }




    if (ar_reading) {








        (void) close (pipes[0]);
        dupto(pipes[1], 1, "to stdout");
        if (rem_host) {
            (void) close (0);
            if (0 != open("/dev/null", 00000000))
                perror("Can't open /dev/null");
            sprintf(cmdbuf,
                "rsh '%s' dd '<%s' bs=%db",
                rem_host, rem_file, blocking);
            if (f_compress)
                strcat(cmdbuf, "| compress -d");



            execlp("sh", "sh", "-c", cmdbuf, (char *)0);
            perror("tar: cannot exec sh");
        } else {





            dupto(archive, 0, "to stdin");
            err = fstat(0, &arstat);
            if (err != 0) {
                perror("tar: can't fstat archive");
                exit(4);
            }
            if ((arstat.st_mode & 0170000) == 0100000) {
                execlp("compress", "compress", "-d", (char *)0);
                perror("tar: cannot exec compress");
            } else {

                sprintf(cmdbuf,
                    "dd bs=%db | compress -d",
                    blocking);



                execlp("sh", "sh", "-c", cmdbuf, (char *)0);
                perror("tar: cannot exec sh");
            }
        }
        exit(105);
    } else {
# 310 "buffer.c"
        (void) close (pipes[1]);
        dupto(pipes[0], 0, "to stdin");
        if (!rem_host)
            dupto(archive, 1, "to stdout");

        cmdbuf[0] = '\0';
        if (f_compress) {
            if (!rem_host) {
                err = fstat(1, &arstat);
                if (err != 0) {
                    perror("tar: can't fstat archive");
                    exit(4);
                }
                if ((arstat.st_mode & 0170000) == 0100000) {
                    execlp("compress", "compress", (char *)0);
                    perror("tar: cannot exec compress");
                }
            }
            strcat(cmdbuf, "compress | ");
        }
        if (rem_host) {
            sprintf(cmdbuf+strlen(cmdbuf),
              "rsh '%s' dd obs=%db '>%s'",
                 rem_host, blocking, rem_file);
        } else {
            sprintf(cmdbuf+strlen(cmdbuf),
                "dd obs=%db",
                blocking);
        }



        execlp("sh", "sh", "-c", cmdbuf, (char *)0);
        perror("tar: cannot exec sh");
        exit(105);
    }
}







void
open_archive(int read)
{
    char *colon, *slash;
    char *rem_host = 0, *rem_file;

    colon = strchr(ar_file, ':');
    if (colon) {
        slash = strchr(ar_file, '/');
        if (slash && slash > colon) {




            rem_file = colon + 1;
            rem_host = ar_file;
            *colon = '\0';
            goto gotit;
        }
    }

    if (ar_file[0] == '-' && ar_file[1] == '\0') {
        f_reblock++;
        if (read)   archive = 0;
        else        archive = 1;
    } else if (read) {
        archive = open(ar_file, 00000000);
    } else {
        archive = creat(ar_file, 0666);
    }

    if (archive < 0) {
        perror(ar_file);
        exit(3);
    }

gotit:
    if (blocksize == 0) {
        fprintf((&__stderr), "tar: invalid value for blocksize\n");
        exit(1);
    }


    ar_block = (union record *) malloc((unsigned)blocksize);
    if (!ar_block) {
        fprintf((&__stderr),
        "tar: could not allocate memory for blocking factor %d\n",
            blocking);
        exit(1);
    }

    ar_record = ar_block;
    ar_last   = ar_block + blocking;
    ar_reading = read;

    if (f_compress || rem_host)
        child_open(rem_host, rem_file);

    if (read) {
        ar_last = ar_block;
        (void) findrec();
    }
}













void
saverec(union record **pointer)
{
    long offset;

    save_rec = pointer;
    offset = ar_record - ar_block;
    saved_recno = baserec + offset;
}





static void
fl_write(void)
{
    int err;

    err = write(archive, ar_block->charptr, blocksize);
    if (err == blocksize) return;

    if (err < 0)
        perror(ar_file);
    else
        fprintf((&__stderr), "tar: %s: write failed, short %d bytes\n",
            ar_file, blocksize - err);
    exit(3);
}








static void
readerror(void)
{


    read_error_flag++;

    anno((&__stderr), tar, 0);
    fprintf((&__stderr), "Read error on ");
    perror(ar_file);

    if (baserec == 0) {

        exit(3);
    }






    if (r_error_count++ > 10) {
        anno((&__stderr), tar, 0);
        fprintf((&__stderr), "Too many errors, quitting.\n");
        exit(3);
    }
    return;
}






static void
fl_read(void)
{
    int err;
    int left;
    char *more;






    r_error_count = 0;






    if (save_rec &&
        *save_rec >= ar_record &&
        *save_rec < ar_last) {
        record_save_area = **save_rec;
        *save_rec = &record_save_area;
    }
error_loop:
    err = read(archive, ar_block->charptr, blocksize);
    if (err == blocksize) return;
    if (err < 0) {
        readerror();
        goto error_loop;
    }

    more = ar_block->charptr + err;
    left = blocksize - err;

again:
    if (0 == (((unsigned)left) % 512)) {


        if (!f_reblock && baserec == 0 && f_verbose && err > 0) {
            anno((&__stderr), tar, 0);
            fprintf((&__stderr), "Blocksize = %d record%s\n",
                err / 512, (err > 512)? "s": "");
        }
        ar_last = ar_block + ((unsigned)(blocksize - left))/512;
        return;
    }
    if (f_reblock) {



        if (left > 0) {
error2loop:
            err = read(archive, more, left);
            if (err < 0) {
                readerror();
                goto error2loop;
            }
            if (err == 0) {
                anno((&__stderr), tar, 0);
                fprintf((&__stderr),
        "%s: eof not on block boundary, strange...\n",
                    ar_file);
                exit(3);
            }
            left -= err;
            more += err;
            goto again;
        }
    } else {
        anno((&__stderr), tar, 0);
        fprintf((&__stderr), "%s: read %d bytes, strange...\n",
            ar_file, err);
        exit(3);
    }
}






void
flush_archive(void)
{

    baserec += ar_last - ar_block;
    ar_record = ar_block;
    ar_last = ar_block + blocking;

    if (!ar_reading)
        fl_write();
    else
        fl_read();
}





void
close_archive(void)
{
    int child;
    int status;

    if (!ar_reading) flush_archive();
    (void) close(archive);

    if (childpid) {




        while (((child = wait(&status)) != childpid) && child != -1)
            ;

        if (child != -1) {
            switch (((status) & 0x7F)) {
            case 0:

                if (((status) >> 8) == 105) {
                    exit(4);
                }
                if (((status) >> 8) == (13 + 128)) {




                    break;
                } else if (((status) >> 8))
                    fprintf((&__stderr),
                  "tar: child returned status %d\n",
                        ((status) >> 8));
            case 13:
                break;

            default:
                fprintf((&__stderr),
                 "tar: child died with signal %d%s\n",
                 ((status) & 0x7F),
                 (((status) & 0x80) != 0)? " (core dumped)": "");
            }
        }
    }
}


















void
anno(FILE *stream, char *prefix, int savedp)
{

    char    buffer[50];

    int space;
    long    offset;


    if (stream == (&__stderr))
        fflush((&__stdout));
    if (f_sayblock) {
        if (prefix) {
            fputs(prefix, stream);
            (--(stream)->_count >= 0 ? (int) (*(stream)->_ptr++ = (' ')) : __flushbuf((' '),(stream)));
        }
        offset = ar_record - ar_block;
        sprintf(buffer, "rec %d: ",
            savedp? saved_recno:
                baserec + offset);
        fputs(buffer, stream);
        space = 13 - strlen(buffer);
        if (space > 0) {
            fprintf(stream, "%*s", space, "");
        }
    } else if (prefix) {
        fputs(prefix, stream);
        fputs(": ", stream);
    }
}
