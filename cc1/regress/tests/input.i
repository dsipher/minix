# 1 "/home/charles/src/cc/cpp/input.c"

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
# 19 "/home/charles/src/cc/cpp/input.c"
struct input_stack input_stack = { 0 };




static void input_push(FILE *fp, char *path)
{
    struct input *tmp;

    tmp = safe_malloc(sizeof(struct input));
    vstring_init(&tmp->path);
    vstring_puts(&tmp->path, path);
    tmp->fp = fp;
    tmp->line_no = 0;
    do { (tmp)->link.sle_next = (&input_stack)->slh_first; (&input_stack)->slh_first = (tmp); } while (0);
    need_resync = 1;
}

static void input_pop(void)
{
    struct input *tmp = ((&input_stack)->slh_first);





    if (!((tmp)->link.sle_next))
        directive_check();

    do { (&input_stack)->slh_first = (&input_stack)->slh_first->link.sle_next; } while (0);
    fclose(tmp->fp);
    vstring_free(&tmp->path);
    free(tmp);
    need_resync = 1;
}





static char in_comment;

static void erase_comments(char *s)
{
    int delim = 0;
    char *space = 0;

    while (*s) {
        if (delim) {
            if (*s == delim) delim = 0;
            if ((*s == '\\') && (s[1] == delim)) ++s;
        } else if (in_comment) {
            if ((*s == '*') && (s[1] == '/')) {
                s[1] = ' ';
                in_comment = 0;
            }

            *s = ' ';
        } else {
            if ((*s == '/') && (s[1] == '*')) {
                *s = ' ';
                s[1] = ' ';
                in_comment = 1;
            } else if (cxx_mode && (*s == '/') && (s[1] == '/')) {
                *s = 0;
                break;
            } else {
                if ((*s == '"') || (*s == '\''))
                    delim = *s;
            }
        }

        if (*s == ' ') {
            if (space == 0)
                space = s;
        } else
            space = 0;

        ++s;
    }

    if (space) *space = 0;
}






static int unwind(input_mode mode)
{
    int c = -1;

    while (((&input_stack)->slh_first)) {
        c = (--(((&input_stack)->slh_first)->fp)->_count >= 0 ? (int) (*(((&input_stack)->slh_first)->fp)->_ptr++) : __fillbuf(((&input_stack)->slh_first)->fp));

        if (c == -1) {
            if (in_comment) error("end-of-file in comment");
            if (mode == 0) break;
            input_pop();
        } else {
            ungetc(c, ((&input_stack)->slh_first)->fp);
            break;
        }
    }

    return c;
}





static char *concat_line(input_mode mode)
{
    static struct vstring buf = { 1 };

    int c = 0;
    int esc;

    if (unwind(mode) == -1) return 0;
    ++(((&input_stack)->slh_first)->line_no);
    vstring_clear(&buf);

    for (;;) {
        esc = (c == '\\');
        c = (--(((&input_stack)->slh_first)->fp)->_count >= 0 ? (int) (*(((&input_stack)->slh_first)->fp)->_ptr++) : __fillbuf(((&input_stack)->slh_first)->fp));

        switch (c)
        {
        case '\n':
            if (esc) {
                vstring_rubout(&buf);
                ++(((&input_stack)->slh_first)->line_no);
                continue;
            }
        case -1:
            return (((buf).u.in.flag) ? ((buf).u.in.buf) : ((buf).u.out.buf));

        default:
            vstring_putc(&buf, c);
        }
    }
}




int input_tokenize(struct list *list, char *s)
{
    struct token *t;
    int count = 0;

    while (*s) {
        t = token_scan(s, &s);
        do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((list))->tqh_last; *((list))->tqh_last = ((t)); ((list))->tqh_last = &((t))->links.tqe_next; } while (0);
        ++count;
    }

    return count;
}





int input_tokens(input_mode mode, struct list *list)
{
    char *s;

    s = concat_line(mode);
    if (s == 0) return -1;
    erase_comments(s);
    return input_tokenize(list, s);
}



struct dir
{
    struct vstring path;
    struct { struct dir *sle_next; } link;
};

struct  { struct dir *slh_first; } system_dirs = { 0 };



void input_dir(char *path)
{
    struct dir *dir;

    dir = safe_malloc(sizeof(struct dir));
    vstring_init(&dir->path);
    vstring_puts(&dir->path, path);
    do { (dir)->link.sle_next = (&system_dirs)->slh_first; (&system_dirs)->slh_first = (dir); } while (0);
}









void input_open(char *path, input_search search)
{
    FILE *fp;
    struct vstring vs;
    struct dir *dir;

    vstring_init(&vs);
    dir = ((&system_dirs)->slh_first);

    for (;;) {
        vstring_clear(&vs);

        switch (search)
        {
        case 0:
            vstring_puts(&vs, path);
            goto open;

        case 2:
            vstring_concat(&vs, &(((&input_stack)->slh_first)->path));

            while ((((vs).u.in.flag) ? ((vs).u.in.len) : ((vs).u.out.len)) && (vstring_last(&vs) != '/'))
                vstring_rubout(&vs);

            vstring_puts(&vs, path);
            search = 1;
            break;

        case 1:
            if (dir == 0) error("can't find '%s'", path);
            vstring_concat(&vs, &dir->path);
            vstring_putc(&vs, '/');
            vstring_puts(&vs, path);
            dir = ((dir)->link.sle_next);
            break;
        }

        if (access((((vs).u.in.flag) ? ((vs).u.in.buf) : ((vs).u.out.buf)), 0) == 0) break;
    }

open:
    fp = fopen((((vs).u.in.flag) ? ((vs).u.in.buf) : ((vs).u.out.buf)), "r");
    if (fp == 0) error("can't open '%s' for reading", path);
    input_push(fp, (((vs).u.in.flag) ? ((vs).u.in.buf) : ((vs).u.out.buf)));
    vstring_free(&vs);
}
