# 1 "getopt.c"

# 15 "/home/charles/xcc/include/sys/tahoe.h"
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
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 18 "/home/charles/xcc/include/stdio.h"
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
extern int fscanf(FILE *, const char *, ...);
extern int fseek(FILE *, long, int);
extern long ftell(FILE *);
extern size_t fwrite(const void *, size_t, size_t, FILE *);
extern char *gets(char *);
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
# 20 "/home/charles/xcc/include/string.h"
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
# 24 "/home/charles/xcc/include/unistd.h"
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
# 14 "getopt.c"
int opterr = 1;
int optind = 1;
int optopt;
char *optarg;

int getopt(int argc, char *const argv[], const char *opts)
{
    static int sp = 1;
    int c;
    const char *cp;

    if (sp == 1)
        if ((optind >= argc) || (argv[optind][0] != '-')
          || (argv[optind][1] == '\0'))
            return (-1);
        else if (strcmp(argv[optind], "--") == 0) {
            optind++;
            return (-1);
        }

        optopt = c = argv[optind][sp];

        if (c == ':' || (cp=strchr(opts, c)) == 0) {
            if (opterr)
                fprintf((&__stderr), "%s: illegal option -- %c\n", argv[0], c);

            if (argv[optind][++sp] == '\0') {
            optind++;
            sp = 1;
        }

        return '?';
    }

    if (*++cp == ':') {
        if (argv[optind][sp+1] != '\0')
            optarg = &argv[optind++][sp+1];
        else if (++optind >= argc) {
            if (opterr)
                fprintf((&__stderr), "%s: option requires an argument -- %c\n",
                                argv[0], c);

            sp = 1;
            return '?';
        } else
            optarg = argv[optind++];

        sp = 1;
    } else {
        if (argv[optind][++sp] == '\0') {
            sp = 1;
            optind++;
        }

        optarg = 0;
    }

    return c;
}
