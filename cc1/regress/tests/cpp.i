# 1 "/home/charles/src/cc/cpp/cpp.c"

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
# 21 "/home/charles/xcc/include/stdarg.h"
typedef __va_list va_list;
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
# 15 "/home/charles/src/cc/cpp/directive.h"
extern void directive(struct list *);
extern void directive_check(void);
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
# 18 "/home/charles/src/cc/cpp/cpp.c"
static FILE *out_fp;
static char *out_path;




void error(char *fmt, ...)
{
    va_list args;

    if (((&input_stack)->slh_first)) {
        fprintf((&__stderr), "'%s'", (((((&input_stack)->slh_first)->path).u.in.flag) ? ((((&input_stack)->slh_first)->path).u.in.buf) : ((((&input_stack)->slh_first)->path).u.out.buf)));

        if (((&input_stack)->slh_first)->line_no)
            fprintf((&__stderr), " (%d)", ((&input_stack)->slh_first)->line_no);
    } else
        fprintf((&__stderr), "cpp");

    fprintf((&__stderr), " ERROR: ");
    (args = (((char *) &(fmt)) + (((sizeof(fmt)) + (8 - 1)) & ~(8 - 1))));
    vfprintf((&__stderr), fmt, args);
    ;
    fputc('\n', (&__stderr));

    if (out_fp) {
        fclose(out_fp);
        remove(out_path);
    }

    exit(1);
}




void *safe_malloc(size_t bytes)
{
    void *p;

    p = malloc(bytes);
    if (p == 0) error("out of memory");
    return p;
}







static int parentheses(struct list *list, struct token *ident)
{
    int no_args = 0;
    struct token *t;
    int parentheses;
    int count;
    int line_no;

    line_no = ((&input_stack)->slh_first)->line_no;

restart:

    for (;;) {
        t = ident;
        t = (((t))->links.tqe_next);
        parentheses = 0;
        count = 0;

        while (t && (t->class == ( 51 ))) {
            t = (((t))->links.tqe_next);
            ++count;
        }

        if (t == 0) {
            if (input_tokens(0, list) == -1)
                return no_args;

            no_args = -1;
            goto restart;
        }

        if (t->class != ( 15 | 0x20000000 )) return no_args;

        do {
            if (t == 0) {
                if (input_tokens(0, list) == -1) {
                    ((&input_stack)->slh_first)->line_no = line_no;
                    error("unterminated macro argument list");
                }

                goto restart;
            }

            if (t->class == ( 15 | 0x20000000 )) ++parentheses;
            if (t->class == ( 16 | 0x20000000 )) --parentheses;
            t = (((t))->links.tqe_next);
            ++count;
        } while (parentheses);

        return count;
    }
}









static int replace(struct list *list)
{
    struct list tmp = { 0, &(tmp).tqh_first };
    struct token *t;
    struct macro *m;
    int count = 0;

    t = ((list)->tqh_first);
    if (t->class != ( 52 )) return 0;
    m = macro_lookup(&t->u.text);
    if (!m || !(!((m)->flags & 0x00000001))) return 0;

    if (m->flags & 0x80000000) {
        count = parentheses(list, t);
        if (count <= 0) return count;
    } else
        t = (((t))->links.tqe_next);

    do { if (!(((list))->tqh_first == 0)) { *((&tmp))->tqh_last = ((list))->tqh_first; ((list))->tqh_first->links.tqe_prev = ((&tmp))->tqh_last; ((&tmp))->tqh_last = ((list))->tqh_last; do { (((list)))->tqh_first = 0; (((list)))->tqh_last = &(((list)))->tqh_first; } while (0); } } while (0);
    list_move(list, &tmp, count + 1);
    macro_replace(list);
    do { if (!(((&tmp))->tqh_first == 0)) { *((list))->tqh_last = ((&tmp))->tqh_first; ((&tmp))->tqh_first->links.tqe_prev = ((list))->tqh_last; ((list))->tqh_last = ((&tmp))->tqh_last; do { (((&tmp)))->tqh_first = 0; (((&tmp)))->tqh_last = &(((&tmp)))->tqh_first; } while (0); } } while (0);

    return 1;
}





token_class last_class;

static void output(struct list *list)
{
    struct token *t;

    t = ((list)->tqh_first);
    do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((list))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);

    if (t->class & 0x80000000)
        error("CPP INTERNAL: attempt to output non-text token %x", t->class);

    if (last_class && token_separate(last_class, t->class))
        fputc(' ', out_fp);

    if ((((t->u.text).u.in.flag) ? ((t->u.text).u.in.len) : ((t->u.text).u.out.len))) {
        fputs((((t->u.text).u.in.flag) ? ((t->u.text).u.in.buf) : ((t->u.text).u.out.buf)), out_fp);
        last_class = t->class;
    }

    token_free(t);
}







char need_resync;

static void resync(void)
{
    static int line_no = 1;

    if (need_resync || (line_no > ((&input_stack)->slh_first)->line_no)
      || (line_no < (((&input_stack)->slh_first)->line_no - 20))) {
        line_no = ((&input_stack)->slh_first)->line_no;
        fprintf(out_fp, "\n# %d \"%s\"\n", line_no,
          (((((&input_stack)->slh_first)->path).u.in.flag) ? ((((&input_stack)->slh_first)->path).u.in.buf) : ((((&input_stack)->slh_first)->path).u.out.buf)));
        need_resync = 0;
        last_class = 0;
    }

    while (line_no < ((&input_stack)->slh_first)->line_no) {
        fputc('\n', out_fp);
        ++line_no;
        last_class = 0;
    }
}






static void loop(void)
{
    struct list list = { 0, &(list).tqh_first };
    int repl;

    fprintf(out_fp, "# 1 \"%s\"\n", (((((&input_stack)->slh_first)->path).u.in.flag) ? ((((&input_stack)->slh_first)->path).u.in.buf) : ((((&input_stack)->slh_first)->path).u.out.buf)));
    need_resync = 0;

    for (;;) {
        if (((&list)->tqh_first == 0)
          && (input_tokens(1, &list) == -1)) {
            fputc('\n', out_fp);
            return;
        }

        while (!((&list)->tqh_first == 0)) {
            directive(&list);

            while (!((&list)->tqh_first == 0)) {
                resync();
                repl = replace(&list);
                if (repl == 1) continue;
                output(&list);
                if (repl == -1) break;
            }
        }
    }
}




char cxx_mode;

int main(int argc, char **argv)
{
    int opt;

    macro_predef();

    while ((opt = getopt(argc, argv, "xI:D:")) != (-1)) {
        switch (opt)
        {
        case 'x':       cxx_mode = 1; break;
        case 'I':       input_dir(optarg); break;
        case 'D':       macro_cmdline(optarg); break;
        default:        goto usage;
        }
    }

    if ((argc - optind) != 2) {
        fprintf((&__stderr), "cpp: incorrect number of arguments\n");
        goto usage;
    }

    out_path = argv[optind + 1];
    out_fp = fopen(out_path, "w");
    if (out_fp == 0) error("can't open output '%s'", out_path);

    input_open(argv[optind], 0);

    loop();
    fclose(out_fp);
    return 0;

usage:
    fprintf((&__stderr),
        "usage: cpp {<option>} <input> <output>"                        "\n"
                                                                        "\n"
        "options:"                                                      "\n"
        "   -x                      recognize C++ comments and tokens"  "\n"
        "   -I<dir>                 add <dir> to system include paths"  "\n"
        "   -D<name>[=<value>]      define macro (default value is 1)"  "\n"
    );

    exit(1);
}
