# 1 "heap.c"

# 39 "/home/charles/xcc/jewel/include/sys/jewel.h"
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
# 43 "/home/charles/xcc/jewel/include/stdlib.h"
typedef __size_t size_t;









extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void _exit(int);
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
# 48 "/home/charles/xcc/jewel/include/unistd.h"
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
# 44 "/home/charles/xcc/jewel/include/string.h"
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
# 48 "/home/charles/xcc/jewel/include/stdio.h"
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
# 40 "cc1.h"
struct string;
# 134 "cc1.h"
extern char w_flag;
extern char O_flag;



union con { long i; unsigned long u; double f; };




extern int last_asmlab;








void seg(int newseg);

















extern void error(int level, struct string *id, char *fmt, ...);




extern void out(char *fmt, ...);

extern FILE *out_f;
# 46 "/home/charles/xcc/jewel/include/stddef.h"
typedef long ptrdiff_t;
# 73 "heap.h"
struct arena { void *bottom; void *top; };

extern struct arena global_arena;
extern struct arena func_arena;
extern struct arena stmt_arena;
extern struct arena local_arena;
extern struct arena string_arena;



void init_arenas(void);
# 118 "heap.h"
void *arena_alloc(struct arena *a, size_t n, int zero);













struct slab
{
    int per_obj;
    int per_slab;
    struct slab_obj { struct slab_obj *next; } *free;
    int alloc, avail;
};

struct slab_obj *refill_slab(struct slab *s);
# 187 "heap.h"
struct vector
{
    int cap;
    int size;
    void *elements;
    struct arena *arena;
};
# 217 "heap.h"
struct int_vector { int cap; int size; int *elements; struct arena *arena; };
struct long_vector { int cap; int size; long *elements; struct arena *arena; };













void vector_insert(struct vector *v, int i, int n, int elem_size);







void vector_delete(struct vector *v, int i, int n, int elem_size);






void dup_vector(struct vector *dst, struct vector *src, int elem_size);
# 317 "heap.h"
struct bitvec_vector { int cap; int size; long *elements; struct arena *arena; };
# 40 "heap.c"
struct arena global_arena;
struct arena func_arena;
struct arena local_arena;
struct arena stmt_arena;
struct arena string_arena;

void init_arenas(void)
{
    unsigned long adj;
    char *p;

    p = sbrk(0);
    adj = (unsigned long) p;

    if (adj % 8) {
        adj = 8 - (adj % 8);
        p = sbrk(adj);



    }

    p = sbrk(   (1L << 27)
              + (1L << 27)
              + (1L << 27)
              + (1L << 27)
              + (1L << 27) );

    if (p == (void *) -1) error(2, 0, "arena allocations failed");

    global_arena.top = global_arena.bottom = p;     p += (1L << 27);
    func_arena.top   = func_arena.bottom   = p;     p += (1L << 27);
    stmt_arena.top   = stmt_arena.bottom   = p;     p += (1L << 27);
    local_arena.top  = local_arena.bottom  = p;     p += (1L << 27);
    string_arena.top = string_arena.bottom = p;
}





struct slab_obj *refill_slab(struct slab *s)
{
    int per_obj = s->per_obj;
    int per_slab = s->per_slab;
    char *p;
    int i;

    p = arena_alloc(&global_arena, per_obj * per_slab, 0);

    for (i = 0; i < (per_slab - 1); ++i, p += per_obj) {
        ((struct slab_obj *) (p))->next = s->free;
        s->free = ((struct slab_obj *) (p));
    }

    s->alloc += per_slab;
    s->avail += per_slab;

    return ((struct slab_obj *) (p));
}




void vector_insert(struct vector *v, int i, int n, int elem_size)
{
    int new_size = v->size + n;

    if (v->cap < new_size) {
        char *new_elements;





        v->cap = (((v->cap) > (8)) ? (v->cap) : (8));
        while (v->cap < new_size) v->cap <<= 1;

        new_elements = arena_alloc(v->arena, v->cap * elem_size, 0);
        memcpy(new_elements, v->elements, i * elem_size);
        memcpy(new_elements + (i + n) * elem_size,
               ((char *) v->elements) + i * elem_size,
               (v->size - i) * elem_size);

        v->elements = new_elements;
    } else
        memmove(((char *) v->elements) + (i + n) * elem_size,
                ((char *) v->elements) + i * elem_size,
                (v->size - i) * elem_size);

    v->size = new_size;
}

void vector_delete(struct vector *v, int i, int n, int elem_size)
{
    char *elements = v->elements;

    memmove(elements + i * elem_size,
            elements + (i + n) * elem_size,
            (v->size - (i + n)) * elem_size);

    v->size -= n;
}




void dup_vector(struct vector *dst, struct vector *src, int elem_size)
{
    if (src->size > dst->cap) {
        dst->size = 0;
        vector_insert(dst, 0, src->size, elem_size);
    } else
        dst->size = src->size;

    memcpy(dst->elements, src->elements, elem_size * src->size);
}






void *arena_alloc(struct arena *a, size_t n, int zero)
{
    void *p;

    do { struct arena *_a = (a); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);
    ((((n) + ((8) - 1)) / (8)) * (8));
    p = ({ struct arena *_a = (a); void *_p = _a->top; _a->top = (char *) _p + (n); (_p); });
    if (zero) memset(p, 0, n);

    return p;
}
