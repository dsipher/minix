# 1 "ld.c"

# 39 "/home/charles/xcc/ux64/include/sys/defs.h"
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
# 48 "/home/charles/xcc/ux64/include/stdio.h"
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
# 45 "/home/charles/xcc/ux64/include/stdarg.h"
typedef __va_list va_list;
# 41 "/home/charles/xcc/ux64/include/fcntl.h"
typedef __mode_t mode_t;
# 74 "/home/charles/xcc/ux64/include/fcntl.h"
int creat(const char *path, mode_t mode);



int open(const char *path, int oflag, ...);



int fcntl(int fildes, int cmd, ...);
# 44 "/home/charles/xcc/ux64/include/string.h"
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
# 53 "/home/charles/xcc/ux64/include/stdlib.h"
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
# 48 "/home/charles/xcc/ux64/include/unistd.h"
typedef __ssize_t ssize_t;




typedef __gid_t gid_t;




typedef __uid_t uid_t;




typedef __off_t off_t;




typedef __pid_t pid_t;
# 97 "/home/charles/xcc/ux64/include/unistd.h"
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
# 39 "/home/charles/xcc/ux64/include/errno.h"
extern int errno;
# 41 "/home/charles/xcc/ux64/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;




typedef __dev_t dev_t;
# 74 "/home/charles/xcc/ux64/include/sys/types.h"
typedef __ino_t ino_t;









typedef __nlink_t nlink_t;
# 109 "/home/charles/xcc/ux64/include/sys/types.h"
typedef __time_t time_t;
# 74 "/home/charles/xcc/ux64/include/sys/fs.h"
struct filsys
{
    int             s_magic;
    int             s_flags;

    time_t          s_ctime;
    time_t          s_mtime;
    daddr_t         s_bmap_blocks;
    daddr_t         s_imap_blocks;
    daddr_t         s_inode_blocks;
    daddr_t         s_blocks;
    ino_t           s_inodes;

    int             s_reserved[4];

    short           s_magic2;
    short           s_boot_magic;
};
# 115 "/home/charles/xcc/ux64/include/sys/fs.h"
struct dinode
{
    mode_t          di_mode;
    nlink_t         di_nlink;
    uid_t           di_uid;
    gid_t           di_gid;

    union
    {
        off_t           di_size;
        dev_t           di_rdev;
    };

    time_t          di_atime;
    time_t          di_mtime;
    time_t          di_ctime;

    int             di_reserved;

    daddr_t         di_addr[19];
};
# 183 "/home/charles/xcc/ux64/include/sys/fs.h"
struct direct
{
    union
    {
        struct
        {
            ino_t       d_ino;
            char        d_name[28];
        };

        long    d_qwords[4];
        int     d_dwords[8];
    };
};
# 50 "/home/charles/xcc/ux64/include/ar.h"
typedef long armag_t;




struct ar_hdr
{
    char        ar_name[28];
    uid_t       ar_uid;
    gid_t       ar_gid;
    mode_t      ar_mode;
    time_t      ar_date;
    off_t       ar_size;
};
# 43 "/home/charles/xcc/ux64/include/a.out.h"
struct exec
{
    unsigned a_magic;
    unsigned a_text;
    unsigned a_data;
    unsigned a_bss;

    unsigned a_syms;
    unsigned a_relocs;





    unsigned a_reserved[2];
};
# 135 "/home/charles/xcc/ux64/include/a.out.h"
struct nlist
{
    unsigned n_stridx : 24;
    unsigned n_type   : 3;
    unsigned n_globl  : 1;
    unsigned n_align  : 2;
    unsigned long     : 34;

    unsigned long   n_value;
};











struct reloc
{
    unsigned r_symidx : 28;
    unsigned r_rel    : 1;
    unsigned r_text   : 1;
    unsigned r_size   : 2;

    unsigned r_offset;
};
# 111 "/home/charles/xcc/ux64/include/sys/stat.h"
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
# 46 "/home/charles/xcc/ux64/include/stddef.h"
typedef long ptrdiff_t;
# 47 "/home/charles/xcc/ux64/include/crc32c.h"
extern unsigned (*crc32c)(unsigned crc, const void *buf, size_t len);
# 51 "ld.c"
char            *aout = "a.out";
int             outfd = -1;
struct exec     exec;
struct nlist    *syms;
char            *strtab;
size_t          a_strsz;
struct object   *objects;
struct globl    *globls[(1 << 9)];
unsigned        base = 0x00180000;
unsigned        address;
char            s_flag;






struct object
{
    char            *path;
    char            *member;
    int             flags;
    struct exec     *hdr;
    char            *text;
    char            *data;
    unsigned        text_base;
    unsigned        data_base;
    struct nlist    *syms;
    struct reloc    *relocs;
    char            *strtab;
    struct object   *link;
};



















struct globl
{
    char            *name;
    unsigned        len;
    unsigned        hash;
    struct object   *object;
    struct nlist    *nlist;
    struct globl    *link;
};




static void
error(const char *fmt, ...)
{
    va_list args;

    fprintf((&__stderr), "[ld] ERROR: ");
    (args = (((char *) &(fmt)) + (((sizeof(fmt)) + (8 - 1)) & ~(8 - 1))));

    while (*fmt)
    {
        if (*fmt != '%')
            fputc(*fmt, (&__stderr));
        else switch (*++fmt)
        {
        case 's':   fprintf((&__stderr), "%s", ((args += (((sizeof(char *)) + (8 - 1)) & ~(8 - 1))), *((char * *) (args - (((sizeof(char *)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'E':   fprintf((&__stderr), "%s", strerror(errno)); break;

        case 'O':   {
                        struct object *o = ((args += (((sizeof(struct object *)) + (8 - 1)) & ~(8 - 1))), *((struct object * *) (args - (((sizeof(struct object *)) + (8 - 1)) & ~(8 - 1)))));

                        fprintf((&__stderr), "`%s'", o->path);
                        if (o->member) fprintf((&__stderr), " [%s]", o->member);
                        break;
                    }

        default:    fputc(*fmt, (&__stderr));
        }

        ++fmt;
    }

    ;
    fputc('\n', (&__stderr));
    if (outfd != -1) unlink(aout);

    exit(1);
}





static void *
alloc(size_t sz, int zero)
{
    char *p, *p2;

    p = malloc(sz);
    if (sz != 0 && p == 0) error("allocation failed (%E)");

    if (zero)
        for (p2 = p; sz--; ++p2)
            *p2 = 0;

    return p;
}




static void
new_object(char *path, char *member, char *buf)
{
    static struct object **next = &objects;

    struct object *o;

    o = alloc(sizeof(struct object), 0);

    o->path = path;
    o->member = member;
    o->flags = 0;

    o->hdr = (struct exec *) buf;
    if (o->hdr->a_magic != 0x16d61eeb) error("%O is not an object", o);

    o->text     =                  (buf + (((*o->hdr).a_magic == 0x16d61eeb) ? sizeof(struct exec) : 0));
    o->data     =                  (buf + ({ unsigned _c = ((((*o->hdr).a_magic == 0x16d61eeb) ? sizeof(struct exec) : 0) + ((*o->hdr).a_text)); if ((*o->hdr).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }));
    o->syms     = (struct nlist *) (buf + ({ unsigned _c = (({ unsigned _c = ((((*o->hdr).a_magic == 0x16d61eeb) ? sizeof(struct exec) : 0) + ((*o->hdr).a_text)); if ((*o->hdr).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((*o->hdr).a_data)); if ((*o->hdr).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }));
    o->relocs   = (struct reloc *) (buf + (({ unsigned _c = (({ unsigned _c = ((((*o->hdr).a_magic == 0x16d61eeb) ? sizeof(struct exec) : 0) + ((*o->hdr).a_text)); if ((*o->hdr).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((*o->hdr).a_data)); if ((*o->hdr).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((*o->hdr).a_syms * sizeof(struct nlist))));
    o->strtab   =                  (buf + ( (({ unsigned _c = (({ unsigned _c = ((((*o->hdr).a_magic == 0x16d61eeb) ? sizeof(struct exec) : 0) + ((*o->hdr).a_text)); if ((*o->hdr).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((*o->hdr).a_data)); if ((*o->hdr).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((*o->hdr).a_syms * sizeof(struct nlist))) + + ((*o->hdr).a_relocs * sizeof(struct reloc)) + ((*o->hdr).a_reserved[0]) + ((*o->hdr).a_reserved[1]) ));

    o->link = 0;
    *next = o;
    next = &o->link;
}




static void
pass1(char **paths)
{
    char *path;

    for (; path = *paths; ++paths)
    {




        int inf;
        char *buf;
        struct stat sb;

        inf = open(path, 00000000);
        if (inf == -1) error("`%s': can't open (%E)", path);
        if (fstat(inf, &sb) == -1) error("`%s': can't stat (%E)", path);
        if (!(((sb.st_mode) & 0170000) == 0100000)) error("`%s': not a regular file", path);

        buf = alloc(sb.st_size, 0);

        if (read(inf, buf, sb.st_size) != sb.st_size)
            error("`%s': read error (%E)", path);

        close(inf);

        if (*((armag_t *) buf) == '<tahar!>') {



            struct ar_hdr *ar;
            char *member;

            buf += sizeof(armag_t);
            sb.st_size -= sizeof(armag_t);

            while (sb.st_size)
            {
                ar = (struct ar_hdr *) buf;
                member = alloc(28 + 1, 1);
                strncpy(member, ar->ar_name, 28);

                buf += sizeof(struct ar_hdr);
                sb.st_size -= sizeof(struct ar_hdr);

                new_object(path, member, buf);

                if (ar->ar_size & (8 - 1))
                    ar->ar_size += 8 - (ar->ar_size & (8 - 1));

                buf += ar->ar_size;
                sb.st_size -= ar->ar_size;
            }
        } else



            new_object(path, 0, buf);
    }
}




static struct globl *
lookup(char *name)
{
    struct globl *g;
    unsigned hash, len;
    int b;

    len = strlen(name);
    hash = crc32c(0, name, len);
    b = ((hash) & ((1 << 9) - 1));

    for (g = globls[b]; g; g = g->link)
        if ((g->hash == hash)
          && (g->len == len)
          && !memcmp(g->name, name, len)) return g;




    g = alloc(sizeof(struct globl), 0);

    g->name = name;
    g->hash = hash;
    g->len = len;
    g->nlist = 0;
    g->object = 0;
    g->link = globls[b];
    globls[b] = g;

    return g;
}




static void
pass2(void)
{
    struct object   *o;
    struct nlist    *n;
    struct globl    *g;
    int             i;

    for (o = objects; o; o = o->link)
        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];

            if (n->n_type == 0 || n->n_globl == 0)
                continue;

            g = lookup((((o)->strtab) + (n->n_stridx)));

            if (g->nlist)
                error("%O: `%s' redefined (previously in %O)", o,
                                                               g->name,
                                                               g->object);

            g->object = o;
            g->nlist = n;
        }
}






static void
pass3(void)
{
    struct object   *o;
    struct nlist    *n;
    struct globl    *g;
    int             marked, i;

    objects->flags |= 0x00000001;

    do {
        marked = 0;

        for (o = objects; o; o = o->link) {
            if (!(o->flags & 0x00000001)) continue;
            if (o->flags & 0x00000002) continue;

            for (i = 0; i < o->hdr->a_syms; ++i) {
                n = &o->syms[i];
                if (n->n_type != 0) continue;
                g = lookup((((o)->strtab) + (n->n_stridx)));

                if (g->nlist == 0)
                    error("%O: unresolved reference to `%s'",
                            o, (((o)->strtab) + (n->n_stridx)));

                if ((g->object->flags & 0x00000001) == 0)  {
                    g->object->flags |= 0x00000001;
                    ++marked;
                }
            }

            o->flags |= 0x00000002;
        }
    } while (marked);
}
# 405 "ld.c"
static void pass4(void) { struct object *o; struct nlist *n; int i; if (2 == 3) address = ({ unsigned _a = (address); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); for (o = objects; o; o = o->link) { if (!(o->flags & 0x00000001)) continue; for (i = 0; i < o->hdr->a_syms; ++i) { n = &o->syms[i]; if (n->n_type != 2) continue; n->n_value += address; } o->text_base = address; address += o->hdr->a_text; exec.a_text += o->hdr->a_text; } }
static void pass5(void) { struct object *o; struct nlist *n; int i; if (3 == 3) address = ({ unsigned _a = (address); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); for (o = objects; o; o = o->link) { if (!(o->flags & 0x00000001)) continue; for (i = 0; i < o->hdr->a_syms; ++i) { n = &o->syms[i]; if (n->n_type != 3) continue; n->n_value += address; } o->data_base = address; address += o->hdr->a_data; exec.a_data += o->hdr->a_data; } }




static void
pass6(void)
{
    struct object   *o;
    struct nlist    *n;
    int             i;
    unsigned        size;
    int             pad;
    int             align;

    for (o = objects; o; o = o->link) {
        if (!(o->flags & 0x00000001)) continue;

        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];
            if (n->n_type != 4) continue;

            size = n->n_value;
            align = 1 << n->n_align;

            if (address & (align - 1)) {
                pad = align - (address & (align - 1));
                address += pad;
                exec.a_bss += pad;
            }

            n->n_type = 3;
            n->n_value = address;
            n->n_align = 0;

            address += size;
            exec.a_bss += size;
        }
    }

    exec.a_bss = ({ unsigned _a = (exec.a_bss); unsigned _b = (8); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); });
}




static void
pass7(void)
{
    struct object   *o;
    struct globl    *g;
    struct nlist    *n;
    struct reloc    *r;
    int             i;
    long            current;
    long            value;
    char            *loc;
    int             size;
    unsigned        base;

    for (o = objects; o; o = o->link) {
        if (!(o->flags & 0x00000001)) continue;

        for (i = 0; i < o->hdr->a_relocs; ++i) {
            r = &o->relocs[i];




            loc = r->r_text ? o->text : o->data;
            loc += r->r_offset;

            size = 1 << r->r_size;





            switch (size)
            {
            case 1:     current = *(char *)     loc; break;
            case 2:     current = *(short *)    loc; break;
            case 4:     current = *(int *)      loc; break;
            case 8:     current = *(long *)     loc; break;
            }

            n = &o->syms[r->r_symidx];




            if (n->n_type == 0) {
                g = lookup((((o)->strtab) + (n->n_stridx)));
                n = g->nlist;
            }

            value = n->n_value;

            if (r->r_rel) {



                base = r->r_text ? o->text_base : o->data_base;
                value -= base + r->r_offset + size;
            }

            value += current;



            switch (size)
            {
            case 1:     *(char *)   loc = value; break;
            case 2:     *(short *)  loc = value; break;
            case 4:     *(int *)    loc = value; break;
            case 8:     *(long *)   loc = value; break;
            }
        }
    }
}




static void
pass8(void)
{
    struct object   *o;
    struct nlist    *n;
    int             i;
    int             nsyms = 0;
    size_t          strsz = 0;




    for (o = objects; o; o = o->link) {
        if (!(o->flags & 0x00000001)) continue;

        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];

            if (n->n_type == 0 || n->n_globl == 0)
                continue;

            ++nsyms;
            strsz += strlen((((o)->strtab) + (n->n_stridx))) + 1;
        }
    }

    syms = alloc(sizeof(struct nlist) * nsyms, 0);
    strtab = alloc(strsz, 0);



    for (o = objects; o; o = o->link) {
        if (!(o->flags & 0x00000001)) continue;

        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];

            if (n->n_type == 0 || n->n_globl == 0)
                continue;

            strcpy(&strtab[a_strsz], (((o)->strtab) + (n->n_stridx)));
            n->n_stridx = a_strsz;
            a_strsz += strlen(&strtab[a_strsz]) + 1;

            syms[exec.a_syms++] = *n;
        }
    }
}




static void
out(off_t where, void *buf, size_t len)
{
    if (lseek(outfd, where, 0) != where)
        error("`%s': seek error (%E)", aout);

    if (write(outfd, buf, len) != len)
        error("`%s': write error (%E)", aout);
}



static void
pass9(void)
{
    struct object *o;

    outfd = open(aout, 00000100 | 00001000 | 00000001, 0777);
    if (outfd == -1) error("`%s': can't create (%E)", aout);

    out(0, &exec, sizeof(exec));

    for (o = objects; o; o = o->link) {
        if (!(o->flags & 0x00000001)) continue;
        out(o->text_base - base, o->text, o->hdr->a_text);
        out(o->data_base - base, o->data, o->hdr->a_data);
    }




    out(({ unsigned _c = (({ unsigned _c = ((((exec).a_magic == 0x16d61eeb) ? sizeof(struct exec) : 0) + ((exec).a_text)); if ((exec).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((exec).a_data)); if ((exec).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }), syms, sizeof(struct nlist) * exec.a_syms);
    out(( (({ unsigned _c = (({ unsigned _c = ((((exec).a_magic == 0x16d61eeb) ? sizeof(struct exec) : 0) + ((exec).a_text)); if ((exec).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((exec).a_data)); if ((exec).a_magic == 0x17b81eeb) _c = ({ unsigned _a = (_c); unsigned _b = (4096); if (_a & (_b - 1)) _a += _b - (_a & (_b - 1)); (_a); }); (_c); }) + ((exec).a_syms * sizeof(struct nlist))) + + ((exec).a_relocs * sizeof(struct reloc)) + ((exec).a_reserved[0]) + ((exec).a_reserved[1]) ), strtab, a_strsz);

    close(outfd);
}

int
main(int argc, char **argv)
{
    int opt;

    while ((opt = getopt(argc, argv, "b:e:o:s")) != -1)
    {
        switch (opt)
        {
        case 'b':   {
                        char *endptr;
                        base = strtol(optarg, &endptr, 0);
                        if (*endptr != 0) goto usage;
                        break;
                    }

        case 'e':                       ; break;
        case 'o':   aout = optarg; break;
        case 's':   ++s_flag; break;

        default:    goto usage;
        }
    }

    if (argv[optind] == 0) goto usage;

    exec.a_magic = 0x17b81eeb;
    address = base;

    exec.a_text = sizeof(struct exec);
    address += sizeof(struct exec);

    pass1(&argv[optind]);
    pass2();
    pass3();
    pass4();
    pass5();
    pass6();
    pass7();
    if (!s_flag) pass8();
    pass9();

    exit(0);

usage:
    fprintf((&__stderr), "usage: ld [-b addr] [-s] [-o a.out] input...\n");
    exit(1);
}
