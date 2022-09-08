# 1 "heap.c"

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
# 15 "/home/charles/xcc/include/sys/mman.h"
extern void *mmap(void *addr, __size_t length, int prot,
                  int flags, int fd, __off_t offset);
# 18 "/home/charles/xcc/include/stdio.h"
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
# 15 "cc1.h"
struct string;
# 100 "cc1.h"
extern char g_flag;
extern char w_flag;



union con { long i; unsigned long u; double f; };




extern int last_asmlab;








void seg(int newseg);

















extern void error(int level, struct string *id, char *fmt, ...);




extern void out(char *fmt, ...);

extern FILE *out_f;
# 22 "/home/charles/xcc/include/stddef.h"
typedef long ptrdiff_t;
# 49 "heap.h"
struct arena { void *bottom; void *top; };

extern struct arena global_arena;
extern struct arena func_arena;
extern struct arena stmt_arena;
extern struct arena local_arena;
extern struct arena string_arena;

void init_arenas(void);




void init_arena(struct arena *a, size_t size);
# 105 "heap.h"
struct slab
{
    int per_obj;
    int per_slab;
    struct slab_obj { struct slab_obj *next; } *free;
    int alloc, avail;
};

struct slab_obj *refill_slab(struct slab *s);
# 160 "heap.h"
struct vector
{
    int cap;
    int size;
    void *elements;
    struct arena *arena;
};
# 190 "heap.h"
struct int_vector { int cap; int size; int *elements; struct arena *arena; };










void vector_insert(struct vector *v, int i, int n, int elem_size);







void vector_delete(struct vector *v, int i, int n, int elem_size);






void dup_vector(struct vector *dst, struct vector *src, int elem_size);
# 286 "heap.h"
struct bitvec_vector { int cap; int size; long *elements; struct arena *arena; };
# 16 "heap.c"
struct arena global_arena;
struct arena func_arena;
struct arena local_arena;
struct arena stmt_arena;
struct arena string_arena;

void init_arenas(void)
{
    init_arena(&global_arena, (1L << 29));
    init_arena(&func_arena, (1L << 29));
    init_arena(&stmt_arena, (1L << 29));
    init_arena(&local_arena, (1L << 29));
    init_arena(&string_arena, (1L << 29));
}

void init_arena(struct arena *a, size_t size)
{
    void *p;

    if (a->bottom == 0) {
        p = mmap(0, size, 0x00000001 | 0x00000002,
                 0x00000020 | 0x00000002, -1, 0);

        if (p == ((void *) -1L)) error(2, 0, "init_arena: mmap failed");
        a->bottom = a->top = p;
    }
}





struct slab_obj *refill_slab(struct slab *s)
{
    int per_obj = s->per_obj;
    int per_slab = s->per_slab;
    char *p;
    int i;

    do { struct arena *_a = (&global_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);
    p = ({ struct arena *_a = (&global_arena); void *_p = _a->top; _a->top = (char *) _p + (per_obj * per_slab); (_p); });

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

        v->cap = 1 << ((sizeof(int) * 8) - 1 - __builtin_clz(new_size));
        if (v->cap < new_size) v->cap <<= 1;
        v->cap = (((v->cap) > (4)) ? (v->cap) : (4));

        do { struct arena *_a = (v->arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);
        new_elements = ({ struct arena *_a = (v->arena); void *_p = _a->top; _a->top = (char *) _p + (v->cap * elem_size); (_p); });
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

    __builtin_memcpy(dst->elements, src->elements, elem_size * src->size);
}
