# 1 "compress.c"

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
# 41 "/home/charles/xcc/linux/include/fcntl.h"
typedef __mode_t mode_t;





int creat(const char *path, mode_t mode);















int open(const char *path, int oflag, ...);











int fcntl(int fildes, int cmd, ...);
# 44 "/home/charles/xcc/linux/include/ctype.h"
extern char __ctype[];









extern int isalnum(int);
extern int isalpha(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int tolower(int);
extern int toupper(int);
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
# 41 "/home/charles/xcc/linux/include/utime.h"
typedef __time_t time_t;


struct utimbuf
{
    time_t  actime;
    time_t  modtime;
};

extern int utime(const char *path, const struct utimbuf *times);
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
# 41 "/home/charles/xcc/linux/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;




typedef __dev_t dev_t;
# 74 "/home/charles/xcc/linux/include/sys/types.h"
typedef __ino_t ino_t;









typedef __nlink_t nlink_t;
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
# 58 "compress.c"
unsigned char magic_header[] = "\037\235";













int n_bits;
int maxbits = 16;
int maxcode;
int maxmaxcode = 1 << 16;



long htab [69001];
unsigned short codetab [69001];

int hsize = 69001;
long fsize;












int free_ent = 0;
int exit_stat = 0;

int main(int argc, char **argv);
void Usage(void);
void compress(void);
void onintr(int dummy);
void oops(int dummy);
void output(int code);
int foreground(void);
void decompress(void);
int getcode(void);
void writeerr(void);
void copystat(char *ifname, char *ofname);
int foreground(void);
void cl_block(void);
void cl_hash(long hsize);
void prratio(FILE *stream, long int num, long int den);
void version(void);

void Usage() {





fprintf((&__stderr),"Usage: compress [-dfvcV] [-b maxbits] [file ...]\n");
}


int nomagic = 0;
int zcat_flg = 0;
int quiet = 0;




int block_compress = 0x80;
int clear_flg = 0;
long int ratio = 0;

long checkpoint = 10000;







int force = 0;
char ofname [100];




void (*bgnd_flag)(int);

int do_decomp = 0;


int main(argc, argv)
int argc;
char **argv;
{
    int overwrite = 0;
    char tempname[100];
    char **filelist, **fileptr;
    char *cp;
    struct stat statbuf;
    if ( (bgnd_flag = signal ( 2, ((__sighandler_t) 1) )) != ((__sighandler_t) 1) ) {
    signal ( 2, onintr );
    signal ( 11, oops );
    }

    filelist = fileptr = (char **)(malloc((size_t)(argc * sizeof(*argv))));
    *filelist = ((void *) 0);

    if((cp = strrchr(argv[0], '/')) != 0) {
    cp++;
    } else {
    cp = argv[0];
    }
    if(strcmp(cp, "uncompress") == 0) {
    do_decomp = 1;
    } else if(strcmp(cp, "zcat") == 0) {
    do_decomp = 1;
    zcat_flg = 1;
    }

    setvbuf((&__stderr), ((void *) 0), 0x040, 0);

    for (argc--, argv++; argc > 0; argc--, argv++)
    {
        if (**argv == '-')
        {
            while (*++(*argv))
            {
                switch (**argv)
                {








                case 'V':   version();
                            break;

                case 'v':   quiet = 0;
                            break;

                case 'd':   do_decomp = 1;
                            break;

                case 'f':
                case 'F':   overwrite = 1;
                            force = 1;
                            break;

                case 'n':   nomagic = 1;
                            break;

                case 'C':   block_compress = 0;
                            break;

                case 'b':   if (!(*++(*argv) || (--argc && *++argv)))
                            {
                                fprintf((&__stderr), "Missing maxbits\n");
                                Usage();
                                exit(1);
                            }

                            maxbits = atoi(*argv);
                            goto nextarg;

                case 'c':   zcat_flg = 1;
                            break;

                case 'q':   quiet = 1;
                            break;

                default:    fprintf((&__stderr), "Unknown flag: '%c'; ", **argv);
                            Usage();
                            exit(1);
                }
            }
        } else {
            *fileptr++ = *argv;
            *fileptr = ((void *) 0);
        }

        nextarg: continue;
    }

    if (maxbits < 9) maxbits = 9;
    if (maxbits > 16) maxbits = 16;
    maxmaxcode = 1 << maxbits;

    if (*filelist != ((void *) 0))
    {
        for (fileptr = filelist; *fileptr; fileptr++)
        {
            exit_stat = 0;

            if (do_decomp != 0)
            {

                if (strcmp(*fileptr + strlen(*fileptr) - 2, ".Z") != 0)
                {

                    strcpy(tempname, *fileptr);
                    strcat(tempname, ".Z");
                    *fileptr = tempname;
                }

                if ((freopen(*fileptr, "r", (&__stdin))) == ((void *) 0))
                {
                    perror(*fileptr); continue;
                }

                if (nomagic == 0)
                {
                    unsigned magic1, magic2;
                    if (((magic1 = (--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)))) != (magic_header[0] & 0xFF))
                     || ((magic2 = (--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)))) != (magic_header[1] & 0xFF)))
                    {
                        fprintf((&__stderr),
                        "%s: not in compressed format %x %x\n",
                        *fileptr,magic1,magic2);
                        continue;
                    }
                    maxbits = (--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)));
                    block_compress = maxbits & 0x80;
                    maxbits &= 0x1f;
                    maxmaxcode = 1 << maxbits;
                    if(maxbits > 16)
                    {
                        fprintf((&__stderr),
                    "%s: compressed with %d bits, can only handle %d bits\n",
                        *fileptr, maxbits, 16);
                        continue;
                    }
                }

                strcpy(ofname, *fileptr);
                ofname[strlen(*fileptr) - 2] = '\0';
            } else
            {
                if (strcmp(*fileptr + strlen(*fileptr) - 2, ".Z") == 0)
                {
                    fprintf((&__stderr), "%s: already has .Z suffix -- no change\n",
                    *fileptr);
                    continue;
                }

                if ((freopen(*fileptr, "r", (&__stdin))) == ((void *) 0))
                {
                    perror(*fileptr); continue;
                }
                (void)stat( *fileptr, &statbuf );
                fsize = (long) statbuf.st_size;





                hsize = 69001;

                if ( fsize < (1 << 12) )
                    hsize = ((5003>69001) ? 69001 : 5003);
                else if ( fsize < (1 << 13) )
                    hsize = ((9001>69001) ? 69001 : 9001);
                else if ( fsize < (1 << 14) )
                    hsize = ((18013>69001) ? 69001 : 18013);
                else if ( fsize < (1 << 15) )
                    hsize = ((35023>69001) ? 69001 : 35023);
                else if ( fsize < 47000 )
                    hsize = ((50021>69001) ? 69001 : 50021);



                strcpy(ofname, *fileptr);

                if ((cp=strrchr(ofname,'/')) != ((void *) 0))
                    cp++;
                else
                    cp = ofname;

                if (strlen(cp) > (28 - 2))
                {
                    fprintf((&__stderr), "%s: filename too long for .Z\n", cp);
                    continue;
                }

                strcat(ofname, ".Z");
            }

            if (overwrite == 0 && zcat_flg == 0)
            {
                if (stat(ofname, &statbuf) == 0)
                {
                    char response[2]; int fd;
                    response[0] = 'n';
                    fprintf((&__stderr), "%s already exists;", ofname);
                    if (foreground())
                    {
                        fd = open("/dev/tty", 00000000);
                        fprintf((&__stderr),
                        " do you wish to overwrite %s (y or n)? ", ofname);
                        fflush((&__stderr));
                        (void)read(fd, response, 2);
                        while (response[1] != '\n')
                        {
                            if (read(fd, response+1, 1) < 0)
                            {
                                perror("stderr");
                                break;
                            }
                        }
                        close(fd);
                    }
                    if (response[0] != 'y')
                    {
                        fprintf((&__stderr), "\tnot overwritten\n");
                        continue;
                    }
                }
            }

            if(zcat_flg == 0)
            {
                if (freopen(ofname, "w", (&__stdout)) == ((void *) 0))
                {
                    perror(ofname);
                    continue;
                }
                if(!quiet)
                    fprintf((&__stderr), "%s: ", *fileptr);
            }



            if (do_decomp == 0)
                compress();


            else
                decompress();










            if (zcat_flg == 0)
            {
                copystat(*fileptr, ofname);

                if (exit_stat == 1 || !quiet)
                    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
            }
        }
    } else
    {
        if (do_decomp == 0)
        {
            compress();



            if(!quiet)
                (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
        } else
        {


            if (nomagic == 0)
            {
                if (((--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)))!=(magic_header[0] & 0xFF))
                 || ((--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)))!=(magic_header[1] & 0xFF)))
                {
                    fprintf((&__stderr), "stdin: not in compressed format\n");
                    exit(1);
                }
                maxbits = (--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)));
                block_compress = maxbits & 0x80;
                maxbits &= 0x1f;
                maxmaxcode = 1 << maxbits;
                fsize = 100000;
                if(maxbits > 16)
                {
                    fprintf((&__stderr),
                    "stdin: compressed with %d bits, can only handle %d bits\n",
                    maxbits, 16);
                    exit(1);
                }
            }

            decompress();





        }
    }

    return(exit_stat);
}

static int offset;
long int in_count = 1;
long int bytes_out;
long int out_count = 0;

















void compress()
{
    long fcode;
    int i = 0;
    int c;
    int ent;
    int disp;
    int hsize_reg;
    int hshift;

    if (nomagic == 0)
    {
        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (magic_header[0])) : __flushbuf((magic_header[0]),((&__stdout))));
        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (magic_header[1])) : __flushbuf((magic_header[1]),((&__stdout))));
        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ((char)(maxbits | block_compress))) : __flushbuf(((char)(maxbits | block_compress)),((&__stdout))));
        if(((((&__stdout))->_flags & 0x020) != 0))
            writeerr();
    }

    offset = 0;
    bytes_out = 3;
    out_count = 0;
    clear_flg = 0;
    ratio = 0;
    in_count = 1;
    checkpoint = 10000;
    maxcode = ((1 << (n_bits = 9)) - 1);
    free_ent = ((block_compress) ? 257 : 256 );

    ent = (--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)));

    hshift = 0;
    for ( fcode = (long) hsize;  fcode < 65536L; fcode *= 2L )
        hshift++;
    hshift = 8 - hshift;

    hsize_reg = hsize;
    cl_hash( (long) hsize_reg);

    while ( (c = (--((&__stdin))->_count >= 0 ? (int) (*((&__stdin))->_ptr++) : __fillbuf((&__stdin)))) != (-1) )
    {
        in_count++;
        fcode = (long) (((long) c << maxbits) + ent);
        i = ((c << hshift) ^ ent);

        if ( htab[i] == fcode )
        {
            ent = codetab[i];
            continue;
        } else if ( (long) htab[i] < 0 )
            goto nomatch;
        disp = hsize_reg - i;
        if ( i == 0 )
            disp = 1;
probe:
        if ( (i -= disp) < 0 )
            i += hsize_reg;

        if ( htab[i] == fcode )
        {
            ent = codetab[i];
            continue;
        }
        if ( (long) htab[i] > 0 )
            goto probe;
nomatch:
        output ( ent );
        out_count++;
        ent = c;
        if ( free_ent < maxmaxcode )
        {
            codetab[i] = free_ent++;
            htab[i] = fcode;
        }
        else if ( (long)in_count >= checkpoint && block_compress )
            cl_block ();
    }



    output( ent );
    out_count++;
    output( -1 );




    if(zcat_flg == 0 && !quiet)
    {












        fprintf( (&__stderr), "Compression: " );
        prratio( (&__stderr), in_count-bytes_out, in_count );

    }
    if(bytes_out > in_count)
        exit_stat = 2;
    return;
}


















static char buf[16];

unsigned char lmask[9] = {  0xff, 0xfe, 0xfc,
                            0xf8, 0xf0, 0xe0,
                            0xc0, 0x80, 0x00 };

unsigned char rmask[9] = {  0x00, 0x01, 0x03,
                            0x07, 0x0f, 0x1f,
                            0x3f, 0x7f, 0xff };

void output( code )
int  code;
{




    int r_off = offset, bits= n_bits;
    char * bp = buf;





    if ( code >= 0 )
    {






    bp += (r_off >> 3);
    r_off &= 7;




    *bp = (*bp & rmask[r_off]) | ((code << r_off) & lmask[r_off]);
    bp++;
    bits -= (8 - r_off);
    code >>= (8 - r_off);

    if ( bits >= 8 )
    {
        *bp++ = code;
        code >>= 8;
        bits -= 8;
    }

    if(bits)
        *bp = code;

    offset += n_bits;
    if ( offset == (n_bits << 3) )
    {
        bp = buf;
        bits = n_bits;
        bytes_out += bits;
        do
        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (*bp++)) : __flushbuf((*bp++),((&__stdout))));
        while(--bits);
        offset = 0;
    }





    if ( free_ent > maxcode || (clear_flg > 0))
    {




        if ( offset > 0 )
        {
            if( fwrite( buf, (size_t)1, (size_t)n_bits, (&__stdout) ) != n_bits)
                writeerr();
            bytes_out += n_bits;
        }
        offset = 0;

        if ( clear_flg )
        {
                maxcode = ((1 << (n_bits = 9)) - 1);
                clear_flg = 0;
        }
        else
        {
            n_bits++;
            if ( n_bits == maxbits )
                maxcode = maxmaxcode;
            else
                maxcode = ((1 << (n_bits)) - 1);
        }







    }
    } else
    {



    if ( offset > 0 )
        fwrite( buf, (size_t)1, (size_t)(offset + 7) / 8, (&__stdout) );
    bytes_out += (offset + 7) / 8;
    offset = 0;
    fflush( (&__stdout) );




    if( ((((&__stdout))->_flags & 0x020) != 0) )
        writeerr();
    }
}







void decompress() {
    unsigned char *stackp;
    int finchar;
    int code, oldcode, incode;




    maxcode = ((1 << (n_bits = 9)) - 1);
    for ( code = 255; code >= 0; code-- ) {
    codetab[code] = 0;
    ((unsigned char *)(htab))[code] = (unsigned char)code;
    }
    free_ent = ((block_compress) ? 257 : 256 );

    finchar = oldcode = getcode();
    if(oldcode == -1)
    return;
    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ((char)finchar)) : __flushbuf(((char)finchar),((&__stdout))));
    if(((((&__stdout))->_flags & 0x020) != 0))
    writeerr();
    stackp = ((unsigned char *)&((unsigned char *)(htab))[1<<16]);

    while ( (code = getcode()) > -1 ) {

    if ( (code == 256) && block_compress ) {
        for ( code = 255; code >= 0; code-- )
        codetab[code] = 0;
        clear_flg = 1;
        free_ent = 257 - 1;
        if ( (code = getcode ()) == -1 )
        break;
    }
    incode = code;



    if ( code >= free_ent ) {
            *stackp++ = finchar;
        code = oldcode;
    }




    while ( code >= 256 ) {
        *stackp++ = ((unsigned char *)(htab))[code];
        code = codetab[code];
    }
    *stackp++ = finchar = ((unsigned char *)(htab))[code];




    do
        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (*--stackp)) : __flushbuf((*--stackp),((&__stdout))));
    while ( stackp > ((unsigned char *)&((unsigned char *)(htab))[1<<16]) );




    if ( (code=free_ent) < maxmaxcode )
    {
        codetab[code] = (unsigned short)oldcode;
        ((unsigned char *)(htab))[code] = finchar;
        free_ent = code+1;
    }



    oldcode = incode;
    }
    fflush( (&__stdout) );
    if(((((&__stdout))->_flags & 0x020) != 0))
    writeerr();
}











int
getcode()
{
    int code;
    static int offset = 0, size = 0;
    static unsigned char buf[16];
    int r_off, bits;
    unsigned char *bp = buf;

    if ( clear_flg > 0 || offset >= size || free_ent > maxcode )
    {





        if ( free_ent > maxcode )
        {
            n_bits++;
            if ( n_bits == maxbits )
                maxcode = maxmaxcode;
            else
                maxcode = ((1 << (n_bits)) - 1);
        }
        if ( clear_flg > 0)
        {
            maxcode = ((1 << (n_bits = 9)) - 1);
            clear_flg = 0;
        }
        size = fread( buf, (size_t)1, (size_t)n_bits, (&__stdin) );
        if ( size <= 0 )
            return -1;
        offset = 0;

        size = (size << 3) - (n_bits - 1);
    }
    r_off = offset;
    bits = n_bits;



    bp += (r_off >> 3);
    r_off &= 7;

    code = (*bp++ >> r_off);
    bits -= (8 - r_off);
    r_off = 8 - r_off;

    if ( bits >= 8 )
    {
        code |= *bp++ << r_off;
        r_off += 8;
        bits -= 8;
    }

    code |= (*bp & rmask[bits]) << r_off;
    offset += n_bits;

    return code;
}
# 1019 "compress.c"
void writeerr()
{
    perror ( ofname );
    unlink ( ofname );
    exit ( 1 );
}

void copystat(ifname, ofname)
char *ifname, *ofname;
{
    struct stat statbuf;
    int mode;
    time_t timep[2];

    fflush((&__stdout));
    close((((&__stdout))->_fd));
    if (stat(ifname, &statbuf))
    {
        perror(ifname);
        return;
    }


    if ((statbuf.st_mode & 0170000           ) != 0100000           )
    {
        if(quiet)
            fprintf((&__stderr), "%s: ", ifname);
        fprintf((&__stderr), " -- not a regular file: unchanged");
        exit_stat = 1;
    } else if (statbuf.st_nlink > 1)
    {
        if(quiet)
            fprintf((&__stderr), "%s: ", ifname);
        fprintf((&__stderr), " -- has %d other links: unchanged",
        statbuf.st_nlink - 1);
        exit_stat = 1;
    } else
    if (exit_stat == 2 && (!force))
    {
        if(!quiet)
            fprintf((&__stderr), " -- file unchanged");
    } else
    {
        exit_stat = 0;
        mode = statbuf.st_mode & 07777;
        if (chmod(ofname, mode))
            perror(ofname);
        chown(ofname, statbuf.st_uid, statbuf.st_gid);
        timep[0] = statbuf.st_atime;
        timep[1] = statbuf.st_mtime;
        utime(ofname, (struct utimbuf *)timep);




        if(!quiet)
            if(do_decomp == 0)
            fprintf((&__stderr), " -- compressed to %s", ofname);
            else
            fprintf((&__stderr), " -- decompressed to %s", ofname);
        return;
    }


    if (unlink(ofname))
        perror(ofname);
}




int foreground()
{
    if(bgnd_flag) {
        return(0);
    } else {
        if(isatty(2)) {
            return(1);
        } else {
            return(0);
        }
    }
}
void onintr (dummy)
int dummy;
{
    (void)signal(2,((__sighandler_t) 1));
    unlink ( ofname );
    exit ( 1 );
}

void oops (dummy)
int dummy;
{
    (void)signal(11,((__sighandler_t) 1));
    if ( do_decomp == 1 )
        fprintf ( (&__stderr), "uncompress: corrupt input\n" );
    unlink ( ofname );
    exit ( 1 );
}

void cl_block ()
{
    long int rat;

    checkpoint = in_count + 10000;








    if(in_count > 0x007fffff) {
    rat = bytes_out >> 8;
    if(rat == 0) {
        rat = 0x7fffffff;
    } else {
        rat = in_count / rat;
    }
    } else {
    rat = (in_count << 8) / bytes_out;
    }
    if ( rat > ratio ) {
    ratio = rat;
    } else {
    ratio = 0;




    cl_hash ( (long) hsize );
    free_ent = 257;
    clear_flg = 1;
    output ( 256 );




    }
}

void cl_hash(hsize)
    long hsize;
{
    memset(htab, -1, hsize * sizeof(long));
}

void prratio(stream, num, den)
FILE *stream;
long int num;
long int den;
{
    int q;
    if(num > 214748L)
    {
        q = (int)(num / (den / 10000L));
    } else
    {
        q = (int)(10000L * num / den);
    }
    if (q < 0)
    {
        (--(stream)->_count >= 0 ? (int) (*(stream)->_ptr++ = ('-')) : __flushbuf(('-'),(stream)));
        q = -q;
    }
    fprintf(stream, "%d.%02d%c", q / 100, q % 100, '%');
}

void version()
{
    fprintf((&__stderr), "compress 4.1\n");
    fprintf((&__stderr), "Options: ");






    fprintf((&__stderr), "BITS = %d\n", 16);
}
