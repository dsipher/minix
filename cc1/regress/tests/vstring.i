# 1 "/home/charles/src/cc/cpp/vstring.c"

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
# 20 "/home/charles/src/cc/cpp/cpp.h"
extern char need_resync;
extern char cxx_mode;

void *safe_malloc(size_t);
void error(char *, ...);
# 22 "/home/charles/xcc/include/stddef.h"
typedef long ptrdiff_t;
# 20 "/home/charles/src/cc/cpp/vstring.h"
struct vstring_out
{
    size_t cap;
    size_t len;
    char *buf;
};



struct vstring_in
{
    int flag : 1;
    int len : 7;
    char buf[(sizeof(struct vstring_out) - 1)];
};

struct vstring
{
    union
    {
        struct vstring_in in;
        struct vstring_out out;
    } u;
};












extern void vstring_clear(struct vstring *);
extern void vstring_rubout(struct vstring *);
extern void vstring_put(struct vstring *, char *, size_t);
extern void vstring_putc(struct vstring *, char);
extern void vstring_puts(struct vstring *, char *);
extern void vstring_free(struct vstring *);
extern void vstring_init(struct vstring *);
extern void vstring_concat(struct vstring *, struct vstring *);
extern char vstring_last(struct vstring *);
extern int vstring_same(struct vstring *, struct vstring *);
# 19 "/home/charles/src/cc/cpp/vstring.c"
void vstring_clear(struct vstring *vs)
{
    if (vs->u.in.flag) {
        vs->u.in.len = 0;
        vs->u.in.buf[0] = 0;
    } else {
        vs->u.out.len = 0;
        vs->u.out.buf[0] = 0;
    }
}




void vstring_init(struct vstring *vs)
{
    vs->u.in.flag = 1;
    vs->u.in.len = 0;
    vs->u.in.buf[0] = 0;
}





void vstring_free(struct vstring *vs)
{
    if (vs->u.in.flag == 0)
        free(vs->u.out.buf);
}




void vstring_rubout(struct vstring *vs)
{
    if ((((*vs).u.in.flag) ? ((*vs).u.in.len) : ((*vs).u.out.len)) == 0)
        error("CPP INTERNAL: vstring underflow");

    if (vs->u.in.flag)
        --(vs->u.in.len);
    else
        --(vs->u.out.len);
}




char vstring_last(struct vstring *vs)
{
    if ((((*vs).u.in.flag) ? ((*vs).u.in.len) : ((*vs).u.out.len)) == 0) return 0;

    if (vs->u.in.flag)
        return vs->u.in.buf[vs->u.in.len - 1];
    else
        return vs->u.out.buf[vs->u.out.len - 1];
}







void vstring_put(struct vstring *vs, char *buf, size_t len)
{
    size_t min_cap;
    size_t new_cap;
    char *new_buf;

    min_cap = (((*vs).u.in.flag) ? ((*vs).u.in.len) : ((*vs).u.out.len));
    min_cap += len + 1;
    if (min_cap < len) error("CPP INTERNAL: vstring overflow");

    if (min_cap > (((*vs).u.in.flag) ? (sizeof(struct vstring_out) - 1) : ((*vs).u.out.cap))) {
        new_cap = (1 << 5);
        while (new_cap && (new_cap < min_cap)) new_cap <<= 1;
        if (new_cap == 0) error("CPP INTERNAL: vstring overflow");
        new_buf = safe_malloc(new_cap);

        if (vs->u.in.flag) {
            memcpy(new_buf, vs->u.in.buf, vs->u.in.len);
            vs->u.out.len = vs->u.in.len;
        } else {
            memcpy(new_buf, vs->u.out.buf, vs->u.out.len);
            free(vs->u.out.buf);
        }

        vs->u.out.cap = new_cap;
        vs->u.out.buf = new_buf;
    }

    if (vs->u.in.flag) {
        memcpy(vs->u.in.buf + vs->u.in.len, buf, len);
        vs->u.in.len += len;
        vs->u.in.buf[vs->u.in.len] = 0;
    } else {
        memcpy(vs->u.out.buf + vs->u.out.len, buf, len);
        vs->u.out.len += len;
        vs->u.out.buf[vs->u.out.len] = 0;
    }
}





void vstring_putc(struct vstring *vs, char c)
{
    if ((((*vs).u.in.flag) ? ((*vs).u.in.len) : ((*vs).u.out.len)) <= ((((*vs).u.in.flag) ? (sizeof(struct vstring_out) - 1) : ((*vs).u.out.cap)) - 2)) {



        if (vs->u.in.flag) {
            vs->u.in.buf[vs->u.in.len++] = c;
            vs->u.in.buf[vs->u.in.len] = 0;
        } else {
            vs->u.out.buf[vs->u.out.len++] = c;
            vs->u.out.buf[vs->u.out.len] = 0;
        }
    } else
        vstring_put(vs, &c, 1);
}



void vstring_concat(struct vstring *dst, struct vstring *src)
{
    vstring_put(dst, (((*src).u.in.flag) ? ((*src).u.in.buf) : ((*src).u.out.buf)), (((*src).u.in.flag) ? ((*src).u.in.len) : ((*src).u.out.len)));
}



void vstring_puts(struct vstring *dst, char *s)
{
    vstring_put(dst, s, strlen(s));
}



int vstring_same(struct vstring *vs1, struct vstring *vs2)
{
    if (((((*vs1).u.in.flag) ? ((*vs1).u.in.len) : ((*vs1).u.out.len)) == (((*vs2).u.in.flag) ? ((*vs2).u.in.len) : ((*vs2).u.out.len)))
      && !memcmp((((*vs1).u.in.flag) ? ((*vs1).u.in.buf) : ((*vs1).u.out.buf)), (((*vs2).u.in.flag) ? ((*vs2).u.in.buf) : ((*vs2).u.out.buf)), (((*vs1).u.in.flag) ? ((*vs1).u.in.len) : ((*vs1).u.out.len))))
        return 1;
    else
        return 0;
}
