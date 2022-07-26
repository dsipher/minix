# 1 "/home/charles/src/cc/cpp/macro.c"

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
# 15 "/home/charles/xcc/include/time.h"
typedef long time_t;

struct tm
{
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
};

extern char *asctime(const struct tm *);
extern char *ctime(const time_t *);
extern struct tm *localtime(const time_t *);
extern struct tm *gmtime(const time_t *);
extern __size_t strftime(char *, __size_t, const char *, const struct tm *);
extern time_t time(time_t *);

extern char *tzname[];
extern long timezone;

extern void tzset(void);
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
# 28 "/home/charles/src/cc/cpp/token.h"
typedef int token_class;
# 126 "/home/charles/src/cc/cpp/token.h"
struct token
{
    token_class class;

    union {
        long i;
        unsigned long u;
        struct vstring text;
    } u;

    struct { struct token *tqe_next; struct token **tqe_prev; } links;
};

extern void token_free(struct token *);
extern struct token *token_number(int);
extern struct token *token_string(char *);
extern struct token *token_int(long);
extern void token_convert_number(struct token *);
extern void token_convert_char(struct token *);
extern struct token *token_scan(char *, char **);
extern struct token *token_paste(struct token *, struct token *);
extern int token_same(struct token *, struct token *);
extern void token_dequote(struct token *, struct vstring *);
extern void token_text(struct token *, struct vstring *);
extern struct token *token_space(void);
extern struct token *token_copy(struct token *);
extern int token_separate(token_class, token_class);







struct list { struct token *tqh_first; struct token **tqh_last; };
















extern int list_next_is(struct list *, struct token *, token_class);
extern int list_prev_is(struct list *, struct token *, token_class);
extern void list_cut(struct list *, struct token *);
extern void list_pop(struct list *, struct token **);
extern struct token *list_drop(struct list *, struct token *);
extern void list_match(struct list *, token_class, struct token **);
extern void list_strip_ends(struct list *);
extern void list_strip_all(struct list *);
extern void list_strip_around(struct list *, struct token *);
extern struct token *list_skip_spaces(struct token *);
extern void list_fold_spaces(struct list *);
extern int list_same(struct list *, struct list *);
extern void list_normalize(struct list *, struct list *);
extern void list_strip_around(struct list *, struct token *);
extern struct token *list_stringize(struct list *);
extern void list_copy(struct list *, struct list *);
extern void list_move(struct list *, struct list *, int);
extern void list_insert(struct list *, struct token *, struct token *);
extern void list_insert_list(struct list *, struct token *, struct list *);
extern void list_ennervate(struct list *, struct vstring *);
extern void list_placeholder(struct list *);
# 16 "/home/charles/src/cc/cpp/macro.h"
typedef int macro_flags;










struct macro
{
    struct vstring name;
    macro_flags flags;
    struct list formals;
    struct list tokens;
    struct { struct macro *tqe_next; struct macro **tqe_prev; } links;
};

extern void macro_predef(void);
extern struct macro *macro_lookup(struct vstring *);
extern void macro_define(struct list *);
extern int macro_cmdline(char *);
extern void macro_undef(struct list *);
extern int macro_replace(struct list *);
extern void macro_replace_all(struct list *);
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
# 21 "/home/charles/src/cc/cpp/input.h"
struct input
{
    FILE *fp;
    struct vstring path;
    int line_no;
    struct { struct input *sle_next; } link;
};

struct input_stack { struct input *slh_first; };

extern struct input_stack input_stack;







typedef int input_search;





extern void input_open(char *, input_search);
extern void input_dir(char *);

typedef int input_mode;




extern int input_tokenize(struct list *, char *);
extern int input_tokens(input_mode, struct list *);
# 23 "/home/charles/src/cc/cpp/macro.c"
static struct bucket { struct macro *tqh_first; struct macro **tqh_last; } buckets[64];



static unsigned hash(struct vstring *vs)
{
    unsigned hash = 0;
    char *s = (((*vs).u.in.flag) ? ((*vs).u.in.buf) : ((*vs).u.out.buf));

    while (*s) hash = (hash << 3) ^ *s++;
    return hash;
}






static struct macro *insert(struct vstring *name)
{
    int b = (hash(name) % 64);
    struct macro *m;

    m = safe_malloc(sizeof(struct macro));
    vstring_init(&m->name);
    vstring_concat(&m->name, name);
    do { (&m->formals)->tqh_first = 0; (&m->formals)->tqh_last = &(&m->formals)->tqh_first; } while (0);
    do { (&m->tokens)->tqh_first = 0; (&m->tokens)->tqh_last = &(&m->tokens)->tqh_first; } while (0);
    m->flags = 0;
    do { if (((m)->links.tqe_next = (&buckets[b])->tqh_first) != 0) (&buckets[b])->tqh_first->links.tqe_prev = &(m)->links.tqe_next; else (&buckets[b])->tqh_last = &(m)->links.tqe_next; (&buckets[b])->tqh_first = (m); (m)->links.tqe_prev = &(&buckets[b])->tqh_first; } while (0);

    return m;
}



static struct { char *name; macro_flags flags; } predefs[] =
{
    { "__STDC__",       0x00000020 },
    { "__LINE__",       0x00000010 },
    { "__FILE__",       0x00000008 },
    { "__DATE__",       0x00000004 },
    { "__TIME__",       0x00000002 },
    { "defined",        0x00000001 }
};

void macro_predef(void)
{
    struct vstring vs = { 1 };
    struct macro *m;
    struct token *t;
    int i;

    for (i = 0; i < (sizeof(predefs) / sizeof(*(predefs))); ++i) {
        vstring_clear(&vs);
        vstring_puts(&vs, predefs[i].name);
        m = insert(&vs);
        m->flags = predefs[i].flags;
        t = 0;

        switch (m->flags)
        {
        case 0x00000020:
            t = token_number(1);
            break;
        }

        if (t) do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((&m->tokens))->tqh_last; *((&m->tokens))->tqh_last = ((t)); ((&m->tokens))->tqh_last = &((t))->links.tqe_next; } while (0);
    }

    vstring_free(&vs);
}




static void tokens(struct macro *m, struct list *dst)
{
    time_t epoch;
    struct token *t;
    char buf[64];

    switch (m->flags & 0x0000003F)
    {
    case 0x00000010:
        t = token_number(((&input_stack)->slh_first)->line_no);
        break;

    case 0x00000008:
        t = token_string((((((&input_stack)->slh_first)->path).u.in.flag) ? ((((&input_stack)->slh_first)->path).u.in.buf) : ((((&input_stack)->slh_first)->path).u.out.buf)));
        break;

    case 0x00000004:
        if (((&m->tokens)->tqh_first == 0)) {
            time(&epoch);
            strftime(buf, sizeof(buf), "%b %d %Y", localtime(&epoch));
            t = token_string(buf);
            do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((&m->tokens))->tqh_last; *((&m->tokens))->tqh_last = ((t)); ((&m->tokens))->tqh_last = &((t))->links.tqe_next; } while (0);
        }

    case 0x00000002:
        if (((&m->tokens)->tqh_first == 0)) {
            time(&epoch);
            strftime(buf, sizeof(buf), "%H:%M:%S", localtime(&epoch));
            t = token_string(buf);
            do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((&m->tokens))->tqh_last; *((&m->tokens))->tqh_last = ((t)); ((&m->tokens))->tqh_last = &((t))->links.tqe_next; } while (0);
        }

    default:
        list_copy(dst, &m->tokens);
        return;
    }

    do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((dst))->tqh_last; *((dst))->tqh_last = ((t)); ((dst))->tqh_last = &((t))->links.tqe_next; } while (0);
}





struct macro *macro_lookup(struct vstring *name)
{
    struct macro *m;
    int b = (hash(name) % 64);

    for (m = ((&buckets[b])->tqh_first); m; m = ((m)->links.tqe_next)) {
        if (vstring_same(&m->name, name)) {
            do { if (((m)->links.tqe_next) != 0) (m)->links.tqe_next->links.tqe_prev = (m)->links.tqe_prev; else (&buckets[b])->tqh_last = (m)->links.tqe_prev; *(m)->links.tqe_prev = (m)->links.tqe_next; } while (0);
            do { if (((m)->links.tqe_next = (&buckets[b])->tqh_first) != 0) (&buckets[b])->tqh_first->links.tqe_prev = &(m)->links.tqe_next; else (&buckets[b])->tqh_last = &(m)->links.tqe_next; (&buckets[b])->tqh_first = (m); (m)->links.tqe_prev = &(&buckets[b])->tqh_first; } while (0);
            return m;
        }
    }

    return 0;
}




void macro_define(struct list *list)
{
    struct macro *m;
    struct token *ident;
    struct token *t;
    struct list formals = { 0, &(formals).tqh_first };
    macro_flags flags = 0;

    list_match(list, ( 52 ), &ident);

    if ((((list)->tqh_first) && (((list)->tqh_first)->class == (( 15 | 0x20000000 ))))) {
        list_pop(list, 0);
        flags = 0x80000000;

        if (!(((list)->tqh_first) && (((list)->tqh_first)->class == (( 16 | 0x20000000 ))))) {
            for (;;) {
                list_strip_ends(list);
                list_match(list, ( 52 ), &t);
                do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((&formals))->tqh_last; *((&formals))->tqh_last = ((t)); ((&formals))->tqh_last = &((t))->links.tqe_next; } while (0);
                list_strip_ends(list);

                if ((((list)->tqh_first) && (((list)->tqh_first)->class == (( 47 | 0x20000000 )))))
                    list_pop(list, 0);
                else
                    break;
            }
        }

        list_match(list, ( 16 | 0x20000000 ), 0);
    }

    list_normalize(list, &formals);
    m = macro_lookup(&ident->u.text);

    if (m) {
        if (m->flags & 0x0000003F)
            error("can't #define reserved identifier '%s'",
              (((m->name).u.in.flag) ? ((m->name).u.in.buf) : ((m->name).u.out.buf)));

        if (!list_same(&m->formals, &formals)
          || !list_same(&m->tokens, list)
          || (m->flags != flags))
            error("incompatible re-#definition of '%s'",
              (((m->name).u.in.flag) ? ((m->name).u.in.buf) : ((m->name).u.out.buf)));

        list_cut((&formals), 0);
        list_cut((list), 0);
    } else {
        m = insert(&ident->u.text);
        m->flags = flags;
        do { if (!(((&formals))->tqh_first == 0)) { *((&m->formals))->tqh_last = ((&formals))->tqh_first; ((&formals))->tqh_first->links.tqe_prev = ((&m->formals))->tqh_last; ((&m->formals))->tqh_last = ((&formals))->tqh_last; do { (((&formals)))->tqh_first = 0; (((&formals)))->tqh_last = &(((&formals)))->tqh_first; } while (0); } } while (0);
        do { if (!(((list))->tqh_first == 0)) { *((&m->tokens))->tqh_last = ((list))->tqh_first; ((list))->tqh_first->links.tqe_prev = ((&m->tokens))->tqh_last; ((&m->tokens))->tqh_last = ((list))->tqh_last; do { (((list)))->tqh_first = 0; (((list)))->tqh_last = &(((list)))->tqh_first; } while (0); } } while (0);
    }

    token_free(ident);
}




int macro_cmdline(char *s)
{
    struct list list = { 0, &(list).tqh_first };
    struct token *t;

    input_tokenize(&list, s);
    list_strip_ends(&list);
    t = ((&list)->tqh_first);
    if (!t || (t->class != ( 52 ))) return 0;
    t = (((t))->links.tqe_next);

    if (t) {
        if (t->class != ( 13 | 0x20000000 )) return 0;
        list_drop(&list, t);
    } else {
        t = token_number(1);
        do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((&list))->tqh_last; *((&list))->tqh_last = ((t)); ((&list))->tqh_last = &((t))->links.tqe_next; } while (0);
    }

    macro_define(&list);
    return 1;
}





void macro_undef(struct list *list)
{
    struct token *ident;
    struct macro *m;
    int b;

    list_match(list, ( 52 ), &ident);
    m = macro_lookup(&ident->u.text);

    if (m) {
        if (m->flags & 0x0000003F)
            error("can't #undef reserved identifier '%s'",
              (((m->name).u.in.flag) ? ((m->name).u.in.buf) : ((m->name).u.out.buf)));

        list_cut((&m->formals), 0);
        list_cut((&m->tokens), 0);
        vstring_free(&m->name);
        b = (hash(&ident->u.text) % 64);
        do { if (((m)->links.tqe_next) != 0) (m)->links.tqe_next->links.tqe_prev = (m)->links.tqe_prev; else (&buckets[b])->tqh_last = (m)->links.tqe_prev; *(m)->links.tqe_prev = (m)->links.tqe_next; } while (0);
        free(m);
    }

    token_free(ident);
}



struct arg
{
    struct list tokens;
    struct { struct arg *tqe_next; struct arg **tqe_prev; } links;
};

struct arg_list { struct arg *tqh_first; struct arg **tqh_last; };



static struct arg *arg_new(struct arg_list *args)
{
    struct arg *a;

    a = safe_malloc(sizeof(struct arg));
    do { (&a->tokens)->tqh_first = 0; (&a->tokens)->tqh_last = &(&a->tokens)->tqh_first; } while (0);
    do { (a)->links.tqe_next = 0; (a)->links.tqe_prev = (args)->tqh_last; *(args)->tqh_last = (a); (args)->tqh_last = &(a)->links.tqe_next; } while (0);
    return a;
}



static void args_clear(struct arg_list *args)
{
    struct arg *a;

    while (a = ((args)->tqh_first)) {
        list_cut((&a->tokens), 0);
        free(a);
        do { if (((a)->links.tqe_next) != 0) (a)->links.tqe_next->links.tqe_prev = (a)->links.tqe_prev; else (args)->tqh_last = (a)->links.tqe_prev; *(a)->links.tqe_prev = (a)->links.tqe_next; } while (0);
    }
}



static struct arg *arg_i(struct arg_list *args, int i)
{
    struct arg *a;

    for (a = ((args)->tqh_first); i > 0; --i)
        a = ((a)->links.tqe_next);

    if (a == 0) error("CPP INTERNAL: argument out of bounds");
    return a;
}



static void gather(struct list *list, struct macro *m, struct arg_list *args)
{
    struct token *formal;
    struct token *t;
    struct arg *a;
    int parentheses;

    list_pop(list, 0);

    formal = ((&m->formals)->tqh_first);

    while (formal) {
        a = arg_new(args);
        parentheses = 0;

        while (t = ((list)->tqh_first)) {
            if ((parentheses == 0) && ((t->class == ( 47 | 0x20000000 ))
              || (t->class == ( 16 | 0x20000000 ))))
                break;

            if (t->class == ( 15 | 0x20000000 )) ++parentheses;
            if (t->class == ( 16 | 0x20000000 )) --parentheses;

            do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((list))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);
            do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((&a->tokens))->tqh_last; *((&a->tokens))->tqh_last = ((t)); ((&a->tokens))->tqh_last = &((t))->links.tqe_next; } while (0);
        }

        list_strip_ends(&a->tokens);
        list_fold_spaces(&a->tokens);
        list_placeholder(&a->tokens);
        formal = (((formal))->links.tqe_next);

        if ((((list)->tqh_first) && (((list)->tqh_first)->class == (( 47 | 0x20000000 )))))
            list_pop(list, 0);
        else
            break;
    }

    if (formal)
        error("too few arguments to macro '%s'", (((m->name).u.in.flag) ? ((m->name).u.in.buf) : ((m->name).u.out.buf)));

    t = ((list)->tqh_first);
    t = list_skip_spaces(t);

    if (t == 0)
        error("deformed arguments to macro '%s'", (((m->name).u.in.flag) ? ((m->name).u.in.buf) : ((m->name).u.out.buf)));

    if (t->class != ( 16 | 0x20000000 ))
        error("too many arguments to macro '%s'", (((m->name).u.in.flag) ? ((m->name).u.in.buf) : ((m->name).u.out.buf)));

    t = (((t))->links.tqe_next);
    list_cut(list, t);
}



static void stringize(struct list *list, struct arg_list *args)
{
    struct arg *a;
    struct token *t;
    struct token *t2;

    t = ((list)->tqh_first);

    while (t) {
        if (t->class == ( 57 | 0x20000000 | 0x40000000 )) {
            t = list_drop(list, t);

            while (t && (t->class == ( 51 )))
                t = list_drop(list, t);

            if (!t || (t->class != ( 61 | 0x80000000 )))
                error("illegal operand to stringize (#)");

            a = arg_i(args, t->u.i);
            t = list_drop(list, t);
            t2 = list_stringize(&a->tokens);
            list_insert(list, t, t2);
        } else
            t = (((t))->links.tqe_next);
    }
}



static void expand(struct list *list, struct arg_list *args)
{
    struct token *t;
    struct arg *a;
    struct list tmp = { 0, &(tmp).tqh_first };

    t = ((list)->tqh_first);

    while (t) {
        if (t->class == ( 61 | 0x80000000 )) {
            a = arg_i(args, t->u.i);
            list_copy(&tmp, &a->tokens);

            if (!list_next_is(list, t, ( 58 | 0x20000000 | 0x40000000 ))
              && !list_prev_is(list, t, ( 58 | 0x20000000 | 0x40000000 )))
                macro_replace_all(&tmp);

            t = list_drop(list, t);
            list_insert_list(list, t, &tmp);
        } else
            t = (((t))->links.tqe_next);
    }
}



static void paste(struct list *list)
{
    struct token *t;
    struct token *result;
    struct token *left;
    struct token *right;

    t = ((list)->tqh_first);

    while (t) {
        if (t->class == ( 58 | 0x20000000 | 0x40000000 )) {
            list_strip_around(list, t);
            left = (*(((struct list *)(((t))->links.tqe_prev))->tqh_last));
            right = (((t))->links.tqe_next);

            if (!left || !right)
                error("missing operands to paste (##) operator");

            result = token_paste(left, right);
            list_drop(list, left);
            list_drop(list, right);
            t = list_drop(list, t);
            list_insert(list, t, result);
        } else
            t = (((t))->links.tqe_next);
    }
}




int macro_replace(struct list *list)
{
    struct macro *m;
    struct token *t;
    struct arg_list args = { 0, &(args).tqh_first };
    struct list repl = { 0, &(repl).tqh_first };

    t = ((list)->tqh_first);
    if (t->class != ( 52 )) return 0;
    m = macro_lookup(&t->u.text);
    if (!m || !(!((m)->flags & 0x00000001))) return 0;

    if (m->flags & 0x80000000) {
        t = (((t))->links.tqe_next);
        t = list_skip_spaces(t);
        if (!t || (t->class != ( 15 | 0x20000000 ))) return 0;
        list_cut(list, t);
        gather(list, m, &args);
    } else
        list_pop(list, 0);

    tokens(m, &repl);

    stringize(&repl, &args);
    expand(&repl, &args);
    paste(&repl);
    list_ennervate(&repl, &m->name);
    do { if (!(((list))->tqh_first == 0)) { *((&repl))->tqh_last = ((list))->tqh_first; ((list))->tqh_first->links.tqe_prev = ((&repl))->tqh_last; ((&repl))->tqh_last = ((list))->tqh_last; do { (((list)))->tqh_first = 0; (((list)))->tqh_last = &(((list)))->tqh_first; } while (0); } } while (0);
    do { if (!(((&repl))->tqh_first == 0)) { *((list))->tqh_last = ((&repl))->tqh_first; ((&repl))->tqh_first->links.tqe_prev = ((list))->tqh_last; ((list))->tqh_last = ((&repl))->tqh_last; do { (((&repl)))->tqh_first = 0; (((&repl)))->tqh_last = &(((&repl)))->tqh_first; } while (0); } } while (0);
    args_clear(&args);

    return 1;
}




void macro_replace_all(struct list *list)
{
    struct list tmp = { 0, &(tmp).tqh_first };
    struct token *t;

    do { if (!(((list))->tqh_first == 0)) { *((&tmp))->tqh_last = ((list))->tqh_first; ((list))->tqh_first->links.tqe_prev = ((&tmp))->tqh_last; ((&tmp))->tqh_last = ((list))->tqh_last; do { (((list)))->tqh_first = 0; (((list)))->tqh_last = &(((list)))->tqh_first; } while (0); } } while (0);

    while (!((&tmp)->tqh_first == 0))
        if (!macro_replace(&tmp)) {
            list_pop(&tmp, &t);
            do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((list))->tqh_last; *((list))->tqh_last = ((t)); ((list))->tqh_last = &((t))->links.tqe_next; } while (0);
        }
}
