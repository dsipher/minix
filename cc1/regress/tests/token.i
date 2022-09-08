# 1 "/home/charles/src/cc/cpp/token.c"

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
# 14 "/home/charles/xcc/include/ctype.h"
extern char __ctype[];









extern int isalnum(int);
extern int isalpha(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int tolower(int);
extern int toupper(int);
# 13 "/home/charles/xcc/include/errno.h"
extern int errno;
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
# 23 "/home/charles/src/cc/cpp/token.c"
static char digits[] = "0123456789ABCDEF";




static int escape(char **buf)
{
    char *cp;
    int c;

    cp = *buf;

    if (*cp == '\\') {
        ++cp;

        if ((((unsigned) ((*cp)-'0') < 10) && ((*cp) != '8') && ((*cp) != '9'))) {
            c = (strchr(digits, toupper(*cp)) - digits);
            ++cp;

            if ((((unsigned) ((*cp)-'0') < 10) && ((*cp) != '8') && ((*cp) != '9'))) {
                c <<= 3;
                c += (strchr(digits, toupper(*cp)) - digits);
                ++cp;
                if ((((unsigned) ((*cp)-'0') < 10) && ((*cp) != '8') && ((*cp) != '9'))) {
                    c <<= 3;
                    c += (strchr(digits, toupper(*cp)) - digits);
                    ++cp;
                    if (c > 255) return -1;
                }
            }
        } else if (*cp == 'x') {
            ++cp;
            if (!((__ctype+1)[*cp]&(0x04|0x40))) return -1;
            c = 0;

            while (((__ctype+1)[*cp]&(0x04|0x40))) {
                if (c & 0xF0) return -1;
                c <<= 4;
                c += (strchr(digits, toupper(*cp)) - digits);
                ++cp;
            }
        } else {
            switch (*cp) {
                case 'a':       c = '\a'; break;
                case 'b':       c = '\b'; break;
                case 'f':       c = '\f'; break;
                case 'n':       c = '\n'; break;
                case 'r':       c = '\r'; break;
                case 't':       c = '\t'; break;
                case 'v':       c = '\v'; break;

                case '?':
                case '"':
                case '\\':
                case '\'':      c = *cp; break;

                default:        return -1;
            }

            ++cp;
        }
    } else {
        c = *cp & 0xFF;
        ++cp;
    }

    *buf = cp;
    return c;
}




static struct list pool = { 0, &(pool).tqh_first };




static struct token *alloc(token_class class)
{
    struct token *t;

    if (((&pool)->tqh_first == 0))
        t = safe_malloc(sizeof(struct token));
    else {
        t = ((&pool)->tqh_first);
        do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((&pool))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);
    }

    t->class = class;
    if (!(class & 0x80000000)) vstring_init(&t->u.text);

    return t;
}



struct token *token_number(int i)
{
    char buf[21];
    struct token *t;

    sprintf(buf, "%d", i);
    t = alloc(( 54 ));
    vstring_puts(&t->u.text, buf);

    return t;
}



static void backslash(struct vstring *vs, int c)
{
    if ((c == '\\') || (c == '"'))
        vstring_putc(vs, '\\');

    vstring_putc(vs, c);
}




struct token *token_string(char *s)
{
    struct token *t;

    t = alloc(( 55 ));
    vstring_putc(&t->u.text, '"');
    while (*s) backslash(&t->u.text, *s++);
    vstring_putc(&t->u.text, '"');

    return t;
}



struct token *token_int(long i)
{
    struct token *t;

    t = alloc(( 59 | 0x80000000 ));
    t->u.i = i;
    return t;
}



void token_convert_number(struct token *t)
{
    unsigned long u;
    char *endptr;
    token_class class;

    class = ( 59 | 0x80000000 );
    errno = 0;
    u = strtoul((((t->u.text).u.in.flag) ? ((t->u.text).u.in.buf) : ((t->u.text).u.out.buf)), &endptr, 0);
    if (toupper(*endptr) == 'L') ++endptr;
    if (toupper(*endptr) == 'U') class = ( 60 | 0x80000000 );
    if (toupper(*endptr) == 'L') ++endptr;
    if (*endptr || errno) error("malformed integer constant");

    vstring_free(&t->u.text);
    t->class = class;
    t->u.i = u;
}



void token_convert_char(struct token *t)
{
    char *cp;
    int c;

    cp = (((t->u.text).u.in.flag) ? ((t->u.text).u.in.buf) : ((t->u.text).u.out.buf));
    ++cp;
    c = escape(&cp);
    if (c == -1) error("invalid escape sequence");
    if (*cp != '\'') error("multi-character constants unsupported");
    vstring_free(&t->u.text);
    t->class = ( 59 | 0x80000000 );
    t->u.i = c;
}




void token_free(struct token *t)
{
    if (!(t->class & 0x80000000))
        vstring_free(&t->u.text);

    do { if ((((t))->links.tqe_next = ((&pool))->tqh_first) != 0) ((&pool))->tqh_first->links.tqe_prev = &((t))->links.tqe_next; else ((&pool))->tqh_last = &((t))->links.tqe_next; ((&pool))->tqh_first = ((t)); ((t))->links.tqe_prev = &((&pool))->tqh_first; } while (0);
}



struct token *token_space(void)
{
    struct token *t;

    t = alloc(( 51 ));
    vstring_putc(&t->u.text, ' ');

    return t;
}



static struct { token_class dup; token_class eq; } modifiers[] = {
    { ( 23 | 0x20000000 ),        ( 25 | 0x20000000 ) },
    { ( 24 | 0x20000000 ),        ( 26 | 0x20000000 ) },
    { 0,                ( 27 | 0x20000000 ) },
    { 0,                ( 28 | 0x20000000 ) },
    { 0,                ( 29 | 0x20000000 ) },
    { ( 31 | 0x20000000 | 0x00000900),     ( 30 | 0x20000000 ) },
    { ( 33 | 0x20000000 | 0x00000A00),       ( 32 | 0x20000000 ) },
    { 0,                ( 34 | 0x20000000 ) },
    { ( 9 | 0x20000000 | 0x00000300 ),        ( 35 | 0x20000000 | 0x00000400 ) },
    { 0,                ( 36 | 0x20000000 ) },
    { ( 11 | 0x20000000 | 0x00000300 ),        ( 37 | 0x20000000 | 0x00000400 ) },
    { 0,                ( 38 | 0x20000000 ) },
    { ( 42 | 0x20000000 | 0x40000000 ),   0          },
    { 0,                ( 21 | 0x20000000 | 0x00000500 ) },
    { 0,                ( 22 | 0x20000000 | 0x00000500 ) }
};




int token_separate(token_class first, token_class second)
{
    int index;

    switch (first)
    {
    case ( 52 ):
        if ((second == ( 52 )) || (second == ( 54 )))
            return 1;

	    break;

    case ( 54 ):
        if ((second == ( 52 )) || (second == ( 54 ))
          || (second == ( 40 | 0x20000000 )) || (second == ( 41 | 0x20000000 )))
            return 1;

        break;

    case ( 48 | 0x20000000 ):
    case ( 44 | 0x20000000 ):
        if (cxx_mode && ((second == ( 44 | 0x20000000 )) || (second == ( 48 | 0x20000000 ))))
            return 1;

        break;

    case ( 40 | 0x20000000 ):
        if ((second == ( 40 | 0x20000000 )) || (second == ( 41 | 0x20000000 ))
          || (cxx_mode && (second == ( 2 | 0x20000000 | 0x00000100 )))
          || (second == ( 54 )))
            return 1;

        break;

    case ( 39 | 0x20000000 ):
        if (cxx_mode && (second == ( 2 | 0x20000000 | 0x00000100 )))
            return 1;

        break;

    case ( 1 | 0x20000000 | 0x00000200 ):
        if ((second == ( 8 | 0x20000000 | 0x00000400 )) || (second == ( 35 | 0x20000000 | 0x00000400 ))
          || (second == ( 9 | 0x20000000 | 0x00000300 )) || (second == ( 36 | 0x20000000 )))
            return 1;

	

    default:
        index = ((first) & 0x000000FF);
        if (index >= (sizeof(modifiers) / sizeof(*(modifiers)))) break;

        if (modifiers[index].eq && ((second == ( 13 | 0x20000000 ))
          || (second == ( 21 | 0x20000000 | 0x00000500 ))))
            return 1;

        if (modifiers[index].dup) {
            if ((second == first) || (second == modifiers[index].dup)
              || (second == modifiers[index].eq))
                return 1;

            index = ((modifiers[index].dup) & 0x000000FF);
            if (index >= (sizeof(modifiers) / sizeof(*(modifiers)))) break;

            if ((second == modifiers[index].dup)
              || (second == modifiers[index].eq))
                return 1;
        }
    }

    return 0;
}




static token_class classes[] =
{
                0,              0,              0,              0,
                0,              0,              0,              0,
                0,              ( 51 ),    0,              ( 51 ),
                ( 51 ),    ( 51 ),    0,              0,
                0,              0,              0,              0,
                0,              0,              0,              0,
                0,              0,              0,              0,
                0,              0,              0,              0,
                ( 51 ),    ( 14 | 0x20000000 ),      ( 55 ),   ( 12 | 0x20000000 | 0x40000000 ),
                ( 62 | 0x40000000 ),    ( 4 | 0x20000000 | 0x00000100 ),      ( 5 | 0x20000000 | 0x00000600 ),      ( 56 ),
                ( 15 | 0x20000000 ),   ( 16 | 0x20000000 ),   ( 2 | 0x20000000 | 0x00000100 ),      ( 0 | 0x20000000 | 0x00000200 ),
                ( 47 | 0x20000000 ),    ( 1 | 0x20000000 | 0x00000200 ),    ( 40 | 0x20000000 ),      ( 3 | 0x20000000 | 0x00000100 ),
                ( 54 ),   ( 54 ),   ( 54 ),   ( 54 ),
                ( 54 ),   ( 54 ),   ( 54 ),   ( 54 ),
                ( 54 ),   ( 54 ),   ( 44 | 0x20000000 ),    ( 43 | 0x20000000 ),
                ( 10 | 0x20000000 | 0x00000400 ),       ( 13 | 0x20000000 ),       ( 8 | 0x20000000 | 0x00000400 ),       ( 45 | 0x20000000 ),
                ( 62 | 0x40000000 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 19 | 0x20000000 ),
                ( 62 | 0x40000000 ),    ( 20 | 0x20000000 ),   ( 7 | 0x20000000 | 0x00000700 ),      ( 52 ),
                ( 62 | 0x40000000 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 52 ),
                ( 52 ),    ( 52 ),    ( 52 ),    ( 17 | 0x20000000 ),
                ( 6 | 0x20000000 | 0x00000800 ),       ( 18 | 0x20000000 ),   ( 46 | 0x20000000 ),    0
};




struct token *token_scan(char *buf, char **endptr)
{
    struct token *t;
    char *cp = buf;
    token_class class;

    if ((*cp > 0) && (*cp < (sizeof(classes) / sizeof(*(classes)))))
        class = classes[*cp];
    else
        class = 0;

    switch (class)
    {
    case ( 56 ):
    case ( 55 ):
        {
            int esc = 1;

            for (;;) {
                if (!*cp) {
                    if (class == ( 55 ))
                        error("unterminated string literal");
                    else
                        error("unterminated char constant");
                }

                if ((*cp++ == *buf) && !esc) break;
                esc = !esc && (cp[-1] == '\\');
            }
        }
        break;

    case ( 40 | 0x20000000 ):
        if ((cp[1] == '.') && (cp[2] == '.')) {
            cp += 3;
            class = ( 41 | 0x20000000 );
            break;
        } else if (cxx_mode && (cp[1] == '*')) {
            cp += 2;
            class = ( 49 | 0x20000000 );
            break;
        } else if (!((unsigned) ((*cp)-'0') < 10)) {
            ++cp;
            break;
        }



    case ( 54 ):
        while (((__ctype+1)[*cp]&(0x01|0x02|0x04)) || (*cp == '.') || (*cp == '_')) {
            if ((toupper(*cp) == 'E') && ((cp[1] == '-') || (cp[1] == '+')))
                ++cp;

            ++cp;
        }
        break;

    case ( 51 ):
        while (((__ctype+1)[*cp]&0x08)) ++cp;
        break;

    case ( 52 ):
        while (((__ctype+1)[*cp]&(0x01|0x02|0x04)) || (*cp == '_')) ++cp;
        break;

    case ( 44 | 0x20000000 ):
        if (cxx_mode && (cp[1] == ':')) {
            class = ( 48 | 0x20000000 );
            cp += 2;
            break;
        } else {
            ++cp;
            break;
        }

    case ( 1 | 0x20000000 | 0x00000200 ):
        if (cxx_mode && (cp[1] == '>') && (cp[2] == '*')) {
            class = ( 50 | 0x20000000 );
            cp += 3;
            break;
        } else if (cp[1] == '>') {
            class = ( 39 | 0x20000000 );
            cp += 2;
            break;
        }



    default:
        {
            int index;

            ++cp;

            while ((index = ((class) & 0x000000FF)) < (sizeof(modifiers) / sizeof(*(modifiers)))) {
                if ((*cp == *buf) && (modifiers[index].dup)) {
                    class = modifiers[index].dup;
                    ++cp;
                } else if ((*cp == '=') && (modifiers[index].eq)) {
                    class = modifiers[index].eq;
                    ++cp;
                } else
                    break;
            }
        }
        break;

    case 0:
        error("invalid character (ASCII %d) in input", *cp & 0xFF);
    }

    t = alloc(class);
    vstring_put(&t->u.text, buf, cp - buf);
    *endptr = cp;
    return t;
}




struct token *token_paste(struct token *t1, struct token *t2)
{
    struct vstring vs = { 1 };
    struct token *t;
    char *endptr;

    token_text(t1, &vs);
    token_text(t2, &vs);
    t = token_scan((((vs).u.in.flag) ? ((vs).u.in.buf) : ((vs).u.out.buf)), &endptr);

    if ((*endptr) || (t->class & 0x40000000))
        error("result of paste (##) '%s' is not a token", (((vs).u.in.flag) ? ((vs).u.in.buf) : ((vs).u.out.buf)));

    return t;
}



int token_same(struct token *t1, struct token *t2)
{
    if (t1->class == t2->class) {
        if (t1->class & 0x20000000) return 1;
        if (t1->class & 0x80000000) return (t1->u.i == t2->u.i);
        return vstring_same(&t1->u.text, &t2->u.text);
    }

    return 0;
}



struct token *token_copy(struct token *t)
{
    struct token *t2;

    t2 = alloc(t->class);

    if (t2->class & 0x80000000)
        t2->u.i = t->u.i;
    else
        vstring_concat(&t2->u.text, &t->u.text);

    return t2;
}



void token_text(struct token *token, struct vstring *vs)
{
    if (token->class & 0x80000000)
        error("CPP INTERNAL: can't get text of non-text token");

    vstring_put(vs, (((token->u.text).u.in.flag) ? ((token->u.text).u.in.buf) : ((token->u.text).u.out.buf)), (((token->u.text).u.in.flag) ? ((token->u.text).u.in.len) : ((token->u.text).u.out.len)));
}




void token_dequote(struct token *token, struct vstring *vs)
{
    size_t i;
    size_t len;
    char *buf;

    if (token->class != ( 55 ))
        error("CPP INTERNAL: can't dequote non-string token");

    len = (((token->u.text).u.in.flag) ? ((token->u.text).u.in.len) : ((token->u.text).u.out.len));
    buf = (((token->u.text).u.in.flag) ? ((token->u.text).u.in.buf) : ((token->u.text).u.out.buf));

    for (i = 1; i < (len - 1); ++i)
            vstring_putc(vs, *++buf);
}




void list_cut(struct list *list, struct token *where)
{
    struct token *t;

    while (!((list)->tqh_first == 0)) {
        t = ((list)->tqh_first);
        if (t == where) break;
        do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((list))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);
        token_free(t);
    }
}




struct token *list_skip_spaces(struct token *t)
{
    while (t && (t->class == ( 51 )))
        t = (((t))->links.tqe_next);

    return t;
}



void list_fold_spaces(struct list *list)
{
    struct token *t;
    struct token *t2;

    for (t = ((list)->tqh_first); t; t = (((t))->links.tqe_next)) {
        if (t->class == ( 51 )) {
            vstring_free(&t->u.text);
            vstring_init(&t->u.text);
            vstring_putc(&t->u.text, ' ');

            while ((t2 = (((t))->links.tqe_next)) && (t2->class == ( 51 ))) {
                do { if ((((t2))->links.tqe_next) != 0) ((t2))->links.tqe_next->links.tqe_prev = ((t2))->links.tqe_prev; else ((list))->tqh_last = ((t2))->links.tqe_prev; *((t2))->links.tqe_prev = ((t2))->links.tqe_next; } while (0);
                token_free(t2);
            }
        }
    }
}



void list_strip_ends(struct list *list)
{
    struct token *t;

    while (((t = ((list)->tqh_first)) && (t->class == ( 51 )))
      || ((t = (*(((struct list *)(((list))->tqh_last))->tqh_last))) && (t->class == ( 51 ))))
    {
        do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((list))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);
        token_free(t);
    }
}



void list_strip_all(struct list *list)
{
    struct token *t;
    struct token *t2;

    t = ((list)->tqh_first);

    while (t) {
        t2 = (((t))->links.tqe_next);

        if ((t->class == ( 51 )) || ((t->class == ( 62 | 0x40000000 ))
          && ((((t->u.text).u.in.flag) ? ((t->u.text).u.in.len) : ((t->u.text).u.out.len)) == 0))) {
            do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((list))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);
            token_free(t);
        }

        t = t2;
    }
}



void list_strip_around(struct list *list, struct token *around)
{
    struct token *t;

    while ((t = (*(((struct list *)(((around))->links.tqe_prev))->tqh_last))) && (t->class == ( 51 )))
        list_drop(list, t);

    while ((t = (((around))->links.tqe_next)) && (t->class == ( 51 )))
        list_drop(list, t);
}




void list_pop(struct list *list, struct token **tp)
{
    struct token *t;

    t = ((list)->tqh_first);
    do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((list))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);

    if (tp)
        *tp = t;
    else
        token_free(t);
}




struct token *list_drop(struct list *list, struct token *token)
{
    struct token *t;

    t = (((token))->links.tqe_next);
    do { if ((((token))->links.tqe_next) != 0) ((token))->links.tqe_next->links.tqe_prev = ((token))->links.tqe_prev; else ((list))->tqh_last = ((token))->links.tqe_prev; *((token))->links.tqe_prev = ((token))->links.tqe_next; } while (0);
    token_free(token);

    return t;
}





void list_match(struct list *list, token_class class, struct token **tp)
{
    struct token *t;

    t = ((list)->tqh_first);

    if (t && (t->class == class))
        list_pop(list, tp);
    else
        error("syntax");
}



int list_same(struct list *l1, struct list *l2)
{
    struct token *t1 = ((l1)->tqh_first);
    struct token *t2 = ((l2)->tqh_first);

    while (t1 && t2 && token_same(t1, t2)) {
        t1 = (((t1))->links.tqe_next);
        t2 = (((t2))->links.tqe_next);
    }

    if (t1 || t2)
        return 0;
    else
        return 1;
}










void list_normalize(struct list *list, struct list *formals)
{
    struct token *t;
    struct token *t2;
    int i;

    list_strip_ends(list);
    list_fold_spaces(list);

    for (t = ((list)->tqh_first); t; t = (((t))->links.tqe_next)) {
        if (t->class == ( 12 | 0x20000000 | 0x40000000 )) t->class = ( 57 | 0x20000000 | 0x40000000 );
        if (t->class == ( 42 | 0x20000000 | 0x40000000 )) t->class = ( 58 | 0x20000000 | 0x40000000 );
    }

    for (t = ((formals)->tqh_first), i = 0; t; t = (((t))->links.tqe_next), ++i) {
        for (t2 = ((list)->tqh_first); t2; t2 = (((t2))->links.tqe_next)) {
            if (token_same(t, t2)) {
                vstring_free(&t2->u.text);
                t2->class = ( 61 | 0x80000000 );
                t2->u.i = i;
            }
        }
    }
}




struct token *list_stringize(struct list *list)
{
    struct token *str;
    struct token *t;
    char *s;

    str = alloc(( 55 ));
    vstring_putc(&str->u.text, '"');

    for (t = ((list)->tqh_first); t; t = (((t))->links.tqe_next)) {
        if (t->class & 0x80000000)
            error("CPP INTERNAL: can't stringize a textless token");

        if ((t->class == ( 51 )) && ((t == ((list)->tqh_first))
          || ((((t))->links.tqe_next) == 0)))
            continue;

        s = (((t->u.text).u.in.flag) ? ((t->u.text).u.in.buf) : ((t->u.text).u.out.buf));

        while (*s) {
            if ((t->class == ( 55 )) || (t->class == ( 56 )))
                backslash(&str->u.text, *s++);
            else
                vstring_putc(&str->u.text, *s++);
        }
    }

    vstring_putc(&str->u.text, '"');
    return str;
}




void list_ennervate(struct list *list, struct vstring *name)
{
    struct token *t;

    for (t = ((list)->tqh_first); t; t = (((t))->links.tqe_next))
        if ((t->class == ( 52 )) && vstring_same(&t->u.text, name))
            t->class = ( 62 | 0x40000000 );
}



void list_copy(struct list *dst, struct list *src)
{
    struct token *t;
    struct token *t2;

    for (t = ((src)->tqh_first); t; t = (((t))->links.tqe_next)) {
        t2 = token_copy(t);
        do { ((t2))->links.tqe_next = 0; ((t2))->links.tqe_prev = ((dst))->tqh_last; *((dst))->tqh_last = ((t2)); ((dst))->tqh_last = &((t2))->links.tqe_next; } while (0);
    }
}



void list_move(struct list *dst, struct list *src, int n)
{
    struct token *t;

    while (n--) {
        t = ((src)->tqh_first);
        if (t == 0) error("CPP INTERNAL: list_move");
        do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((src))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);
        do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((dst))->tqh_last; *((dst))->tqh_last = ((t)); ((dst))->tqh_last = &((t))->links.tqe_next; } while (0);
    }
}




int list_next_is(struct list *list, struct token *after, token_class class)
{
    after = (((after))->links.tqe_next);

    while (after && (after->class == ( 51 )))
        after = (((after))->links.tqe_next);

    if (after && (after->class == class))
        return 1;
    else
        return 0;
}

int list_prev_is(struct list *list, struct token *before, token_class class)
{
    before = (*(((struct list *)(((before))->links.tqe_prev))->tqh_last));

    while (before && (before->class == ( 51 )))
        before = (*(((struct list *)(((before))->links.tqe_prev))->tqh_last));

    if (before && (before->class == class))
        return 1;
    else
        return 0;
}




void list_insert(struct list *list, struct token *before, struct token *t)
{
    if (before)
        do { (t)->links.tqe_prev = (before)->links.tqe_prev; (t)->links.tqe_next = (before); *(before)->links.tqe_prev = (t); (before)->links.tqe_prev = &(t)->links.tqe_next; } while (0);
    else
        do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((list))->tqh_last; *((list))->tqh_last = ((t)); ((list))->tqh_last = &((t))->links.tqe_next; } while (0);
}






void list_insert_list(struct list *dst, struct token *before, struct list *src)
{
    struct token *t;

    while (t = ((src)->tqh_first)) {
        do { if ((((t))->links.tqe_next) != 0) ((t))->links.tqe_next->links.tqe_prev = ((t))->links.tqe_prev; else ((src))->tqh_last = ((t))->links.tqe_prev; *((t))->links.tqe_prev = ((t))->links.tqe_next; } while (0);
        list_insert(dst, before, t);
    }
}




void list_placeholder(struct list *list)
{
    struct token *t;

    if (((list)->tqh_first == 0)) {
        t = alloc(( 62 | 0x40000000 ));
        do { ((t))->links.tqe_next = 0; ((t))->links.tqe_prev = ((list))->tqh_last; *((list))->tqh_last = ((t)); ((list))->tqh_last = &((t))->links.tqe_next; } while (0);
    }
}
