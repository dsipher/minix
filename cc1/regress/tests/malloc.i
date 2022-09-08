# 1 "malloc.c"

# 15 "/home/charles/xcc/include/sys/jewel.h"
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
# 19 "/home/charles/xcc/include/stdlib.h"
typedef __size_t size_t;









extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void __exit(int);
extern void exit(int);

extern void free(void *);
extern char *getenv(const char *);
extern void *malloc(size_t);
extern float strtof(const char *, char **);
extern double strtod(const char *, char **);
extern long strtol(const char *, char **, int);
extern unsigned long strtoul(const char *, char **, int);

extern void qsort(void *, size_t, size_t,
                  int (*compar)(const void *, const void *));



extern int rand(void);
extern void srand(unsigned);
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
# 13 "/home/charles/xcc/include/stdint.h"
typedef long intptr_t;
typedef unsigned long uintptr_t;
# 22 "/home/charles/xcc/include/stddef.h"
typedef long ptrdiff_t;
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
# 48 "malloc.c"
struct region
{



    union {
        struct region *next_free;

        struct {
            int magic;
            int bucket;
        };
    };

    char data[];
};

static struct region *buckets[((30 - 5) + 1)];





static int refill(int bucket)
{
    size_t size;
    uintptr_t brk;
    int alloc;
    struct region *new;
    int n;
    int i;

    size = (((size_t) 1) << ((bucket) + 5));
    brk = (uintptr_t) sbrk(0);
    alloc = ((((brk) + ((4096) - 1)) / (4096)) * (4096)) - brk;

    if (size < 4096)
        n = (4096 / size);
    else
        n = 1;

    alloc += n * size;
    new = sbrk(alloc);

    if (new == (void *) -1)
        return 0;

    for (i = 0; i < n; ++i) {
        new->next_free = buckets[bucket];
        buckets[bucket] = new;
        new = (struct region *) (((char *) new) + size);
    }

    return n;
}

void *malloc(size_t bytes)
{
    struct region *r;
    int bucket;

    bytes += ((size_t) (((char *) &((struct region *) 0)->data) - ((char *) 0)));

    for (bucket = 0; bucket < ((30 - 5) + 1); ++bucket)
        if (bytes <= (((size_t) 1) << ((bucket) + 5)))
            break;

    if (bucket == ((30 - 5) + 1))
        return 0;

    if (buckets[bucket] == 0)
        if (refill(bucket) == 0)
            return 0;

    r = buckets[bucket];
    buckets[bucket] = r->next_free;

    r->bucket = bucket;
    r->magic = 0x4B696E67;

    return r->data;
}

void free(void *ptr)
{
    struct region *r;
    int bucket;

    r = (struct region *) ((char *) ptr - ((size_t) (((char *) &((struct region *) 0)->data) - ((char *) 0))));

    if (r->magic == 0x4B696E67) {
        bucket = r->bucket;
        r->next_free = buckets[bucket];
        buckets[bucket] = r;
    }
}
