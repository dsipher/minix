# 1 "/home/charles/src/cc/cpp/evaluate.c"

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
# 15 "/home/charles/src/cc/cpp/evaluate.h"
extern int evaluate(struct list *);
# 19 "/home/charles/src/cc/cpp/evaluate.c"
static void expression(struct list *);

static void unary(struct list *list)
{
    struct token *t;

    t = ((list)->tqh_first);

    if (t) switch (t->class)
    {
    case ( 0 | 0x20000000 | 0x00000200 ):
        list_pop(list, 0);
        unary(list);
        return;

    case ( 1 | 0x20000000 | 0x00000200 ):
        list_pop(list, 0);
        unary(list);
        t = ((list)->tqh_first);
        t->u.i = -(t->u.i);
        return;

    case ( 46 | 0x20000000 ):
        list_pop(list, 0);
        unary(list);
        t = ((list)->tqh_first);
        t->u.i = ~(t->u.i);
        return;

    case ( 14 | 0x20000000 ):
        list_pop(list, 0);
        unary(list);
        t = ((list)->tqh_first);
        t->u.i = !(t->u.i);
        return;

    case ( 15 | 0x20000000 ):
        list_pop(list, 0);
        expression(list);
        t = ((list)->tqh_first);
        t = (((t))->links.tqe_next);

        if (!t || (t->class != ( 16 | 0x20000000 )))
            error("unmatched parentheses in expression");

        list_drop(list, t);
        return;

    case ( 56 ):
        token_convert_char(t);
        return;

    case ( 54 ):
        token_convert_number(t);
    case ( 59 | 0x80000000 ):
    case ( 60 | 0x80000000 ):
        return;
    }

    error("malformed expression");
}




static void binary(int prec, struct list *list)
{
    struct token *result;
    struct token *left;
    struct token *right;
    struct token *op;
    struct token *t;

    if (prec == 0x00000000) {
        unary(list);
        return;
    }

    binary(((prec) - 0x00000100), list);

    for (;;) {
        left = ((list)->tqh_first);
        op = (((left))->links.tqe_next);
        if (!op || (((op->class) & 0x00000F00) != prec)) return;
        list_pop(list, &left);
        list_pop(list, &op);
        binary(((prec) - 0x00000100), list);
        list_pop(list, &right);
        result = token_int(0);

        if ((left->class == ( 60 | 0x80000000 )) || (right->class == ( 60 | 0x80000000 )))
            ((result)->class = ( 60 | 0x80000000 ));

        switch (op->class)
        {
        case ( 0 | 0x20000000 | 0x00000200 ):    result->u.i = left->u.i + right->u.i; break;
        case ( 1 | 0x20000000 | 0x00000200 ):   result->u.i = left->u.i - right->u.i; break;
        case ( 2 | 0x20000000 | 0x00000100 ):     result->u.i = left->u.i * right->u.i; break;
        case ( 5 | 0x20000000 | 0x00000600 ):     result->u.i = left->u.i & right->u.i; break;
        case ( 6 | 0x20000000 | 0x00000800 ):      result->u.i = left->u.i | right->u.i; break;
        case ( 7 | 0x20000000 | 0x00000700 ):     result->u.i = left->u.i ^ right->u.i; break;
        case ( 11 | 0x20000000 | 0x00000300 ):     result->u.i = left->u.i << right->u.i; break;

        case ( 9 | 0x20000000 | 0x00000300 ):
            if (result->class == ( 60 | 0x80000000 ))
                result->u.u = left->u.u >> right->u.u;
            else
                result->u.i = left->u.i >> right->u.i;

            break;

        case ( 4 | 0x20000000 | 0x00000100 ):
            if (right->u.i == 0) error("modulus zero");

            if (result->class == ( 60 | 0x80000000 ))
                result->u.u = left->u.u % right->u.u;
            else
                result->u.i = left->u.i % right->u.i;

            break;

        case ( 3 | 0x20000000 | 0x00000100 ):
            if (right->u.i == 0) error("division by zero");

            if (result->class == ( 60 | 0x80000000 ))
                result->u.u = left->u.u / right->u.u;
            else
                result->u.i = left->u.i / right->u.i;

            break;

        case ( 35 | 0x20000000 | 0x00000400 ):
            if (result->class == ( 60 | 0x80000000 ))
                result->u.i = left->u.u >= right->u.u;
            else
                result->u.i = left->u.i >= right->u.i;

            ((result)->class = ( 59 | 0x80000000 ));
            break;

        case ( 8 | 0x20000000 | 0x00000400 ):
            if (result->class == ( 60 | 0x80000000 ))
                result->u.i = left->u.u > right->u.u;
            else
                result->u.i = left->u.i > right->u.i;

            ((result)->class = ( 59 | 0x80000000 ));
            break;

        case ( 10 | 0x20000000 | 0x00000400 ):
            if (result->class == ( 60 | 0x80000000 ))
                result->u.i = left->u.u < right->u.u;
            else
                result->u.i = left->u.i < right->u.i;

            ((result)->class = ( 59 | 0x80000000 ));
            break;

        case ( 37 | 0x20000000 | 0x00000400 ):
            if (result->class == ( 60 | 0x80000000 ))
                result->u.i = left->u.u <= right->u.u;
            else
                result->u.i = left->u.i <= right->u.i;

            ((result)->class = ( 59 | 0x80000000 ));
            break;

        case ( 21 | 0x20000000 | 0x00000500 ):
            result->u.i = left->u.i == right->u.i;
            ((result)->class = ( 59 | 0x80000000 ));
            break;

        case ( 22 | 0x20000000 | 0x00000500 ):
            result->u.i = left->u.i != right->u.i;
            ((result)->class = ( 59 | 0x80000000 ));
            break;

        case ( 31 | 0x20000000 | 0x00000900):
            result->u.i = left->u.i && right->u.i;
            ((result)->class = ( 59 | 0x80000000 ));
            break;

        case ( 33 | 0x20000000 | 0x00000A00):
            result->u.i = left->u.i || right->u.i;
            ((result)->class = ( 59 | 0x80000000 ));
            break;

        default:
            error("CPP INTERNAL: unknown binary operator");
        }

        do { if ((((result))->links.tqe_next = ((list))->tqh_first) != 0) ((list))->tqh_first->links.tqe_prev = &((result))->links.tqe_next; else ((list))->tqh_last = &((result))->links.tqe_next; ((list))->tqh_first = ((result)); ((result))->links.tqe_prev = &((list))->tqh_first; } while (0);
        token_free(left);
        token_free(op);
        token_free(right);
    }

    unary(list);
}



static void ternary(struct list *list)
{
    struct token *control;
    struct token *left;
    struct token *right;

    binary(0x00000A00, list);
    control = ((list)->tqh_first);

    if (list_next_is(list, control, ( 45 | 0x20000000 ))) {
        list_pop(list, &control);
        list_pop(list, 0);
        expression(list);
        list_pop(list, &left);

        if (!(((list)->tqh_first) && (((list)->tqh_first)->class == (( 44 | 0x20000000 )))))
            error("missing ':' after '?'");

        list_pop(list, 0);
        ternary(list);
        list_pop(list, &right);

        if (control->u.i) {
            do { if ((((left))->links.tqe_next = ((list))->tqh_first) != 0) ((list))->tqh_first->links.tqe_prev = &((left))->links.tqe_next; else ((list))->tqh_last = &((left))->links.tqe_next; ((list))->tqh_first = ((left)); ((left))->links.tqe_prev = &((list))->tqh_first; } while (0);
            token_free(right);
        } else {
            do { if ((((right))->links.tqe_next = ((list))->tqh_first) != 0) ((list))->tqh_first->links.tqe_prev = &((right))->links.tqe_next; else ((list))->tqh_last = &((right))->links.tqe_next; ((list))->tqh_first = ((right)); ((right))->links.tqe_prev = &((list))->tqh_first; } while (0);
            token_free(left);
        }

        token_free(control);
    }
}



static void expression(struct list *list)
{
    struct token *t;

    for (;;) {
        ternary(list);
        t = ((list)->tqh_first);

        if (list_next_is(list, t, ( 47 | 0x20000000 ))) {
            list_pop(list, 0);
            list_pop(list, 0);
        } else
            break;
    }
}



static void undefined(struct list *list)
{
    struct token *t;

    t = ((list)->tqh_first);

    while (t) {
        if (t->class == ( 52 )) {
            t = list_drop(list, t);
            list_insert(list, t, token_int(0));
        } else
            t = (((t))->links.tqe_next);
    }
}



static void defined(struct list *list)
{
    struct macro *m;
    struct token *t;
    int parentheses;

    t = ((list)->tqh_first);

    while (t) {
        if ((t->class == ( 52 )) && (m = macro_lookup(&t->u.text))
          && (m->flags & 0x00000001)) {
            t = list_drop(list, t);

            if (t && (t->class == ( 15 | 0x20000000 ))) {
                t = list_drop(list, t);
                parentheses = 1;
            } else
                parentheses = 0;

            if (!t || (t->class != ( 52 )))
                error("missing identifier after 'defined'");

            if ((m = macro_lookup(&t->u.text)) && (!((m)->flags & 0x00000001)))
                list_insert(list, t, token_int(1));
            else
                list_insert(list, t, token_int(0));

            t = list_drop(list, t);

            if (parentheses) {
                if (!t || (t->class != ( 16 | 0x20000000 )))
                    error("missing closing parenthesis after 'defined'");

                t = list_drop(list, t);
            }
        } else
            t = (((t))->links.tqe_next);
    }
}



int evaluate(struct list *list)
{
    struct token *t;
    int true;

    list_strip_all(list);
    defined(list);
    macro_replace_all(list);
    undefined(list);
    list_strip_all(list);
    expression(list);

    if (!(((list)->tqh_first) && (((list)->tqh_first)->class == (( 59 | 0x80000000 )))) && !(((list)->tqh_first) && (((list)->tqh_first)->class == (( 60 | 0x80000000 )))))
        error("CPP INTERNAL: botched expression evaluation");

    t = ((list)->tqh_first);
    true = (t->u.i != 0);
    list_drop(list, t);

    return true;
}
