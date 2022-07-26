# 1 "/home/charles/src/cc/cpp/directive.c"

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
# 17 "/home/charles/xcc/include/string.h"
typedef __size_t size_t;


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
# 29 "/home/charles/xcc/include/stdlib.h"
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
# 15 "/home/charles/src/cc/cpp/directive.h"
extern void directive(struct list *);
extern void directive_check(void);
# 18 "/home/charles/src/cc/cpp/directive.c"
typedef int directive_index;


















static const char directives[][7+1] =
{
    { "define" },     { "elif" },       { "else" },     { "endif" },
    { "error" },      { "if" },         { "ifdef" },      { "ifndef" },
    { "include" },    { "line" },       { "pragma" },     { "undef" }
};

static directive_index lookup(struct token *t)
{
    directive_index i;

    if (t->class == ( 52 )) {
        for (i = 0; i < (sizeof(directives) / sizeof(*(directives))); ++i)
            if (!strcmp(directives[i], (((t->u.text).u.in.flag) ? ((t->u.text).u.in.buf) : ((t->u.text).u.out.buf))))
                return i;
    }

    return -1;
}



struct state
{
    char copying;
    char saw_true;
    char saw_else;

    struct { struct state *sle_next; } link;
};

static struct  { struct state *slh_first; } state_stack;







static void state_push(int copying)
{
    struct state *st;

    st = safe_malloc(sizeof(struct state));

    if ((((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1)) {
        st->saw_true = copying;
        st->copying = copying;
    } else {
        st->copying = 0;
        st->saw_true = 1;
    }

    st->saw_else = 0;
    do { (st)->link.sle_next = (&state_stack)->slh_first; (&state_stack)->slh_first = (st); } while (0);
}

static void state_pop(void)
{
    struct state *c;

    c = ((&state_stack)->slh_first);
    do { (&state_stack)->slh_first = (&state_stack)->slh_first->link.sle_next; } while (0);
    free(c);
}





static void do_ifdef(token_class which, struct list *list)
{
    struct token *ident;
    struct macro *m;
    int defined;

    list_match(list, ( 52 ), &ident);
    m = macro_lookup(&ident->u.text);
    defined = m && (!((m)->flags & 0x00000001));

    if (which == 6)
        state_push(defined);
    else
         state_push(!defined);

    token_free(ident);
}

static void do_if(struct list *list)
{
    if ((((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1))
        state_push(evaluate(list));
    else
        state_push(0);
}

static void do_elif(struct list *list)
{
    if (!((&state_stack)->slh_first)) error("#elif without #if");
    if (((&state_stack)->slh_first)->saw_else) error("#elif after #else");

    if (!((&state_stack)->slh_first)->saw_true) {
        ((&state_stack)->slh_first)->saw_true = evaluate(list);
        ((&state_stack)->slh_first)->copying = ((&state_stack)->slh_first)->saw_true;
    }
}

static void do_else(struct list *list)
{
    if (!((&state_stack)->slh_first)) error("#else without #if");
    if (((&state_stack)->slh_first)->saw_else) error("duplicate #else");
    ((&state_stack)->slh_first)->copying = !((&state_stack)->slh_first)->saw_true;
    ((&state_stack)->slh_first)->saw_else = 1;
}

static void do_endif(void)
{
    if (!((&state_stack)->slh_first)) error("#endif without #if");
    state_pop();
}

static void do_line(struct list *list)
{
    struct token *line_no;
    struct token *path = 0;

    list_strip_all(list);
    list_match(list, ( 54 ), &line_no);
    if (!((list)->tqh_first == 0)) list_match(list, ( 55 ), &path);
    token_convert_number(line_no);
    ((&input_stack)->slh_first)->line_no = line_no->u.i - 1;

    if (path) {
        vstring_clear(&((&input_stack)->slh_first)->path);
        vstring_concat(&((&input_stack)->slh_first)->path, &path->u.text);
        token_free(path);
    }

    token_free(line_no);
    need_resync = 1;
}

static void do_error(struct list *list)
{
    struct token *t;

    t = list_stringize(list);
    error("#error directive: %s", (((t->u.text).u.in.flag) ? ((t->u.text).u.in.buf) : ((t->u.text).u.out.buf)));
}

static void do_include(struct list *list)
{
    struct vstring path = { 1 };
    struct token *t;
    input_search search;

    if (!(((list)->tqh_first) && (((list)->tqh_first)->class == (( 55 ))))
      && !(((list)->tqh_first) && (((list)->tqh_first)->class == (( 10 | 0x20000000 | 0x00000400 ))))) {
        macro_replace_all(list);
        list_strip_ends(list);
    }

    if ((((list)->tqh_first) && (((list)->tqh_first)->class == (( 55 ))))) {
        list_pop(list, &t);
        token_dequote(t, &path);
        token_free(t);
        search = 2;
    } else if ((((list)->tqh_first) && (((list)->tqh_first)->class == (( 10 | 0x20000000 | 0x00000400 ))))) {
        list_pop(list, 0);

        while (!((list)->tqh_first == 0) && !(((list)->tqh_first) && (((list)->tqh_first)->class == (( 8 | 0x20000000 | 0x00000400 ))))) {
            list_pop(list, &t);
            token_text(t, &path);
            token_free(t);
        }

        list_match(list, ( 8 | 0x20000000 | 0x00000400 ), 0);
        search = 1;
    } else
        error("expected file name after #include");

    input_open((((path).u.in.flag) ? ((path).u.in.buf) : ((path).u.out.buf)), search);
    vstring_free(&path);
}





void directive(struct list *list)
{
    struct token *t;
    directive_index d;
    int defined;

    t = ((list)->tqh_first);
    t = list_skip_spaces(t);

    if (t && (t->class == ( 12 | 0x20000000 | 0x40000000 ))) {
        t = (((t))->links.tqe_next);
        t = list_skip_spaces(t);

        if (t) {
            d = lookup(t);
            t = (((t))->links.tqe_next);
        } else
            d = 12;

        if (d == 10) goto out;

        t = list_skip_spaces(t);
        list_cut(list, t);

        switch (d)
        {
        case 8: do_include(list); break;

        case 6:
        case 7:  do_ifdef(d, list); break;

        case 5:      do_if(list); break;
        case 1:    do_elif(list); break;
        case 2:    do_else(list); break;
        case 3:   do_endif(); break;

        case 0:  if ((((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1)) macro_define(list); break;
        case 11:   if ((((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1)) macro_undef(list); break;
        case -1: if ((((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1)) error("unknown directive"); break;

        case 9:    do_line(list); break;
        case 4:   if ((((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1)) do_error(list); break;

        case 12:   break;
        }

        if ((((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1) && !((list)->tqh_first == 0))
            error("trailing garbage after directive");
    }

out:
    if (!(((&state_stack)->slh_first) ? (((&state_stack)->slh_first)->copying) : 1)) list_cut((list), 0);
}



void directive_check(void)
{
    if (((&state_stack)->slh_first)) error("end-of-file in #if/ifdef/ifndef");
}
