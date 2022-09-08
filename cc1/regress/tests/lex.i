# 1 "lex.c"

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
# 17 "/home/charles/xcc/include/fcntl.h"
typedef __mode_t mode_t;


int creat(const char *, mode_t);
int open(const char *, int, ...);
# 13 "/home/charles/xcc/include/errno.h"
extern int errno;
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
# 15 "/home/charles/xcc/include/sys/mman.h"
extern void *mmap(void *addr, __size_t length, int prot,
                  int flags, int fd, __off_t offset);
# 15 "/home/charles/xcc/include/sys/stat.h"
struct stat
{
    __dev_t         st_dev;
    __ino_t         st_ino;
    __nlink_t       st_nlink;

    __mode_t        st_mode;
    __uid_t         st_uid;
    __gid_t         st_gid;
    int             __pad0;

    __dev_t         st_rdev;
    __off_t         st_size;
    __blksize_t     st_blksize;
    __blkcnt_t      st_blocks;

    long            _st_atim[2];
    long            _st_mtim[2];
    long            _st_ctim[2];

    unsigned long   __reserved[3];
};

extern int fstat(int fd, struct stat *statbuf);
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
# 20 "string.h"
struct string
{
    unsigned hash;
    int len;
    char *text;
    int asmlab;
    int k;
    struct string *link;
};
# 59 "string.h"
struct string *string(char *text, size_t len, int arena);




void out_literal(struct string *s, int n);




void out_literals(void);




struct symbol *literal(struct string *s);
# 13 "builtin.h"
struct string;
struct tree;







void seed_builtin(struct string *id);




struct tree *rewrite_builtin(struct tree *tree);
# 236 "lex.h"
struct token
{
    int k;

    char *text;
    int len;

    union
    {
        union con con;
        struct string *s;
    };
};




void seed_keywords(void);



void init_lex(char *in_path);



extern struct token token;
extern struct string *path;
extern int line_no;

void lex(void);



struct token lookahead(void);




void print_k(FILE *fp, int k);
void print_token(FILE *fp, struct token *t);




void expect(int k);
# 24 "lex.c"
struct token token;
struct string *path;
int line_no;





static char *text;
static char *pos;
static char *eof;
# 55 "lex.c"
static unsigned short ctype[255] =
{
            0x1000,            0,              0,              0,
            0,              0,              0,              0,
            0,              0x0400,            0x8000,             0x0400,
            0x0400,            0x0400,            0,              0,
            0,              0,              0,              0,
            0,              0,              0,              0,
            0,              0,              0,              0,
            0,              0,              0,              0,
            0x0400,            0,              0x2000,            0,
            0,              0,              0,              0x4000,
            0,              0,              0,              0x0800,
            0,              0x0800,            0x0200,            0,
            0x0002|0x0004|0x0008,          0x0002|0x0004|0x0008,          0x0002|0x0004|0x0008,          0x0002|0x0004|0x0008,
            0x0002|0x0004|0x0008,          0x0002|0x0004|0x0008,          0x0002|0x0004|0x0008,          0x0002|0x0004|0x0008,
            0x0002|0x0008,            0x0002|0x0008,            0,              0,
            0,              0,              0,              0,
            0,              0x0001|0x0008,            0x0001|0x0008,            0x0001|0x0008,
            0x0001|0x0008,            0x0001|0x0008|0x0010,          0x0001|0x0008|0x0020,          0x0001,
            0x0001,              0x0001,              0x0001,              0x0001,
            0x0001|0x0040,            0x0001,              0x0001,              0x0001,
            0x0001,              0x0001,              0x0001,              0x0001,
            0x0001,              0x0001|0x0080,            0x0001,              0x0001,
            0x0001|0x0100,            0x0001,              0x0001,              0,
            0,              0,              0,              0x0001,
            0,              0x0001|0x0008,            0x0001|0x0008,            0x0001|0x0008,
            0x0001|0x0008,            0x0001|0x0008|0x0010,          0x0001|0x0008|0x0020,          0x0001,
            0x0001,              0x0001,              0x0001,              0x0001,
            0x0001|0x0040,            0x0001,              0x0001,              0x0001,
            0x0001,              0x0001,              0x0001,              0x0001,
            0x0001,              0x0001|0x0080,            0x0001,              0x0001,
            0x0001|0x0100,            0x0001,              0x0001,              0,
            0,              0,              0,              0
};







static char *token_text[] =
{
    "end-of-file",
    "identifier",
    "string literal",
    "integral constant",
    "integral constant",
    "integral constant",
    "integral constant",
    "FP constant",
    "FP constant",
    "FP constant",

    0,      0,

    "(",    ")",    "[",    "]",    "{",    "}",    ".",    "...",
    "^",    ",",    ":",    ";",    "?",    "~",    "->",   "++",
    "--",   "!",    "/",    "*",    "+",    "-",    ">",    ">>",
    ">=",   ">>=",  "<",    "<<",   "<=",   "<<=",  "&",    "&&",
    "&=",   "|",    "||",   "|=",   "-=",   "+=",   "*=",   "/=",
    "==",   "!=",   "%",    "%=",   "^=",   "=",

    "initializer",
    "argument",
    "return"
};







static struct { char *text; int k; } keywords[] =
{
    "__asm",        ( 61 | 0x80000000 ),

    "auto",         ( 62 | 0x80000000 | 0x20000000 ),         "break",        ( 63 | 0x80000000 ),
    "case",         ( 64 | 0x80000000 ),         "char",         ( 65 | 0x80000000 | 0x20000000 | 0x00000200 ),
    "const",        ( 66 | 0x80000000 | 0x20000000 ),        "continue",     ( 67 | 0x80000000 ),
    "default",      ( 68 | 0x80000000 ),      "do",           ( 69 | 0x80000000 ),
    "double",       ( 70 | 0x80000000 | 0x20000000 | 0x00004000 ),       "else",         ( 71 | 0x80000000 ),
    "enum",         ( 72 | 0x80000000 | 0x20000000 ),         "extern",       ( 73 | 0x80000000 | 0x20000000 ),
    "float",        ( 74 | 0x80000000 | 0x20000000 | 0x00002000 ),        "for",          ( 75 | 0x80000000 ),
    "goto",         ( 76 | 0x80000000 ),         "if",           ( 77 | 0x80000000 ),
    "int",          ( 78 | 0x80000000 | 0x20000000 | 0x00000800 ),          "long",         ( 79 | 0x80000000 | 0x20000000 | 0x00001000 ),
    "register",     ( 80 | 0x80000000 | 0x20000000 ),     "return",       ( 81 | 0x80000000 ),
    "short",        ( 82 | 0x80000000 | 0x20000000 | 0x00000400 ),        "signed",       ( 83 | 0x80000000 | 0x20000000 | 0x00010000 ),
    "sizeof",       ( 84 | 0x80000000 ),       "static",       ( 85 | 0x80000000 | 0x20000000 ),
    "struct",       ( 86 | 0x80000000 | 0x20000000 ),       "switch",       ( 87 | 0x80000000 ),
    "typedef",      ( 88 | 0x80000000 | 0x20000000 ),      "union",        ( 89 | 0x80000000 | 0x20000000 ),
    "unsigned",     ( 90 | 0x80000000 | 0x20000000 | 0x00008000 ),     "void",         ( 91 | 0x80000000 | 0x20000000 | 0x00000100 ),
    "volatile",     ( 92 | 0x80000000 | 0x20000000 ),     "while",        ( 93 | 0x80000000 ),

    "rax",          ( 94 | 0x00020000 ),          "rbx",          ( 103 | 0x00020000 ),
    "rcx",          ( 95 | 0x00020000 ),          "rdx",          ( 96 | 0x00020000 ),
    "rsi",          ( 97 | 0x00020000 ),          "rdi",          ( 98 | 0x00020000 ),
    "rsp",          ( 104 | 0x00020000 ),          "rbp",          ( 105 | 0x00020000 ),
    "r8",           ( 99 | 0x00020000 ),           "r9",           ( 100 | 0x00020000 ),
    "r10",          ( 101 | 0x00020000 ),          "r11",          ( 102 | 0x00020000 ),
    "r12",          ( 106 | 0x00020000 ),          "r13",          ( 107 | 0x00020000 ),
    "r14",          ( 108 | 0x00020000 ),          "r15",          ( 109 | 0x00020000 ),
    "xmm0",         ( 110 | 0x00020000 ),         "xmm1",         ( 111 | 0x00020000 ),
    "xmm2",         ( 112 | 0x00020000 ),         "xmm3",         ( 113 | 0x00020000 ),
    "xmm4",         ( 114 | 0x00020000 ),         "xmm5",         ( 115 | 0x00020000 ),
    "xmm6",         ( 116 | 0x00020000 ),         "xmm7",         ( 117 | 0x00020000 ),
    "xmm8",         ( 118 | 0x00020000 ),         "xmm9",         ( 119 | 0x00020000 ),
    "xmm10",        ( 120 | 0x00020000 ),        "xmm11",        ( 121 | 0x00020000 ),
    "xmm12",        ( 122 | 0x00020000 ),        "xmm13",        ( 123 | 0x00020000 ),
    "xmm14",        ( 124 | 0x00020000 ),        "xmm15",        ( 125 | 0x00020000 ),
    "mem",          ( 126 ),          "cc",           ( 127 ),

    "__builtin_memcpy",             ( 128 | 0x00040000 ),
    "__builtin_memset",             ( 129 | 0x00040000 ),
    "__builtin_clz",                ( 130 | 0x00040000 ),
    "__builtin_clzl",               ( 131 | 0x00040000 ),
    "__builtin_ctz",                ( 132 | 0x00040000 ),
    "__builtin_ctzl",               ( 133 | 0x00040000 )
};

void seed_keywords(void)
{
    struct string *s;
    int i;

    for (i = 0; i < (sizeof(keywords) / sizeof(*(keywords))); ++i) {
        s = (string((keywords[i].text), (strlen(keywords[i].text)), 0));
        s->k = keywords[i].k;
        if (s->k & 0x00040000) seed_builtin(s);
    }
}







void print_k(FILE *fp, int k)
{
    int base = ((k) & 0x000000FF);
    int quote, i;
    char *text;

    if (base < (sizeof(token_text) / sizeof(*(token_text)))) {
        text = token_text[base];
        quote = !((ctype[(*text) & 0xFF] & (0x0001)) != 0);
    } else {
        for (i = 0; i < (sizeof(keywords) / sizeof(*(keywords))); ++i)
            if (keywords[i].k == k) {
                text = keywords[i].text;
                break;
            }

        quote = 1;
    }

    fprintf(fp, "%c%s%c", ((quote) ? '`' : 0), text, ((quote) ? '\'' : 0));
}




void print_token(FILE *fp, struct token *t)
{
    int quote;

    print_k(fp, t->k);

    if (t->k == ( 1 ))
        fprintf(fp, " `" "%.*s" "'", (t->s)->len, (t->s)->text);
    else if (t->k & 0x40000000) {
        quote = (*t->text != '\'');
        fprintf(fp, " %c%.*s%c", ((quote) ? '`' : 0), t->len, t->text, ((quote) ? '\'' : 0));
    }
}







static int escape(void)
{
    int c;

    ++pos;

    if (((ctype[(*pos) & 0xFF] & (0x0004)) != 0)) {
        c = ((*pos) - '0'); ++pos;
        if (((ctype[(*pos) & 0xFF] & (0x0004)) != 0)) {
            c <<= 3; c += ((*pos) - '0'); ++pos;
            if (((ctype[(*pos) & 0xFF] & (0x0004)) != 0)) {
                c <<= 3; c += ((*pos) - '0'); ++pos;
                if (c > 255) goto range;
            }
        }
    } else if (*pos == 'x') {
        c = 0;
        ++pos;
        if (!((ctype[(*pos) & 0xFF] & (0x0008)) != 0)) goto malformed;

        while (((ctype[(*pos) & 0xFF] & (0x0008)) != 0)) {
            if (c & 0xF0) goto range;
            c <<= 4;
            c += (((ctype[(*pos) & 0xFF] & (0x0002)) != 0) ? ((*pos) - '0') : ((((*pos) | 0x20) - 'a') + 10));
            ++pos;
        }
    } else {
        switch (*pos) {
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
        case '\'':      c = *pos; break;

        default:        goto malformed;
        }

        ++pos;
    }

    return c;

malformed:
    error(4, 0, "malformed escape sequence");

range:
    error(4, 0, "escaped character out of range");
}





static int ccon(void)
{
    int len = 0;
    long i = 0;
    int k;
    int c;

    token.text = text;
    ++pos;

    while (!((ctype[(*pos) & 0xFF] & (0x1000 | 0x8000 | 0x4000)) != 0)) {
        if (*pos == '\\')
            c = escape();
        else
            c = *pos++ & 0xFF;

        i <<= 8;
        i += c;
        ++len;
    }

    if (*pos != '\'') error(4, 0, "unterminated character constant");

    switch (len)
    {
    case 1:                             k = ( 3 | 0x40000000 ); i = (char) i; break;
    case 2: case 3: case 4:             k = ( 3 | 0x40000000 ); i = (int) i; break;
    case 5: case 6: case 7: case 8:     k = ( 5 | 0x40000000 ); break;

    default:    error(4, 0, "malformed character constant");
    }

    ++pos;
    token.len = pos - text;
    token.con.i = i;
    return k;
}








static int strlit(void)
{
    int arena = -1;
    char *tmp;
    int adj, c;

    for (;;) {
        ++pos;
        ++arena;

        while (!((ctype[(*pos) & 0xFF] & (0x1000 | 0x8000 | 0x2000)) != 0)) {
            if (*pos == '\\') {
                c = escape();
                ++arena;
            } else
                c = *pos++;

            (* (char *) ({ struct arena *_a = (&string_arena); void *_p = _a->top; _a->top = (char *) _p + (1); (_p); }) = (c));
        }

        if (*pos != '\"') error(4, 0, "unterminated string literal");
        ++pos;





        adj = 0;
        tmp = pos;

        while (((ctype[(*tmp) & 0xFF] & (0x0400 | 0x8000)) != 0)) {
            if (*tmp == '\n') ++adj;
            ++tmp;
        }

        if (*tmp == '"') {
            line_no += adj;
            pos = tmp;
        } else
            break;
    }




    if (arena)
        token.s = (string(string_arena.bottom, (char *) string_arena.top - (char *) string_arena.bottom, 1));
    else {
        do { struct arena *_a = (&string_arena); _a->top = _a->bottom; } while (0);
        token.s = (string((text + 1), (pos - text - 2), 0));
    }

    return ( 2 );
}





static int number(void)
{
    char *endptr;
    int is_unsigned = 0;
    int is_long = 0;
    int must_float = 0;
    int might_float = 0;
    int k;

    token.text = text;




    while (((ctype[(*pos) & 0xFF] & (0x0200 | 0x0002 | 0x0001)) != 0)) {
        if (((ctype[(*pos) & 0xFF] & (0x0200)) != 0))
            must_float = 1;

        if (((ctype[(*pos) & 0xFF] & (0x0010)) != 0)) {
            if (((ctype[(pos[1]) & 0xFF] & (0x0800)) != 0)) {
                ++pos;
                must_float = 1;
            } else if (((ctype[(pos[1]) & 0xFF] & (0x0002)) != 0))
                might_float = 1;
        }

        ++pos;
    }

    errno = 0;
    token.len = pos - text;




    if ((*text != '0') || !((ctype[(text[1]) & 0xFF] & (0x0100)) != 0))
        must_float |= might_float;

    if (must_float) {
        k = ( 8 | 0x40000000 );
        token.con.f = strtod(text, &endptr);

        if (((ctype[(*endptr) & 0xFF] & (0x0040)) != 0)) {
            k = ( 9 | 0x40000000 );
            ++endptr;
        } else if (((ctype[(*endptr) & 0xFF] & (0x0020)) != 0)) {
            token.con.f = strtof(text, &endptr);
            k = ( 7 | 0x40000000 );
            ++endptr;
        }
    } else {
        token.con.i = strtoul(text, &endptr, 0);
        if (((ctype[(*endptr) & 0xFF] & (0x0040)) != 0)) { is_long = 1; ++endptr; }
        if (((ctype[(*endptr) & 0xFF] & (0x0080)) != 0)) { is_unsigned = 1; ++endptr; }
        if (!is_long && ((ctype[(*endptr) & 0xFF] & (0x0040)) != 0)) { is_long = 1; ++endptr; }

        if (is_long && is_unsigned)
            k = ( 6 | 0x40000000 );
        else if (is_long) {
            if (token.con.u > 9223372036854775807L)
                k = ( 6 | 0x40000000 );
            else
                k = ( 5 | 0x40000000 );
        } else if (is_unsigned) {
            if (token.con.u > 4294967295U)
                k = ( 6 | 0x40000000 );
            else
                k = ( 4 | 0x40000000 );
        } else {
            if (token.con.u > 9223372036854775807L)
                k = ( 6 | 0x40000000 );
            else if (token.con.u > 4294967295U)
                k = ( 5 | 0x40000000 );
            else if (token.con.u > 2147483647) {
                if (*text == '0')
                    k = ( 4 | 0x40000000 );
                else
                    k = ( 5 | 0x40000000 );
            } else
                k = ( 3 | 0x40000000 );
        }
    }

    if (endptr != pos) error(4, 0, "malformed numeric constant");
    if (errno) error(4, 0, "numeric constant out of range");

    return k;
}
# 518 "lex.c"
static int lex0()
{
    while (((ctype[(*pos) & 0xFF] & (0x0400)) != 0)) ++pos;
    text = pos;

    switch (*pos)
    {
    case '\n':  ++pos; return ( 11 );
    case '#':   ++pos; return ( 10 );
    case '?':   ++pos; return ( 24 );
    case ':':   ++pos; return ( 22 | ((29) << 24) );
    case ';':   ++pos; return ( 23 );
    case ',':   ++pos; return ( 21 );
    case '(':   ++pos; return ( 12 );
    case ')':   ++pos; return ( 13 );
    case '{':   ++pos; return ( 16 );
    case '}':   ++pos; return ( 17 );
    case '[':   ++pos; return ( 14 );
    case ']':   ++pos; return ( 15 );
    case '~':   ++pos; return ( 25 );

    case '=':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (( 52 | ((24) << 24) | 0x00700000 ) && (pos[1] == *pos)) { pos += 2; return ( 52 | ((24) << 24) | 0x00700000 ); } if (0 && (pos[1] == '=')) { pos += 2; return 0; } ++pos; return ( 57 | ((0) << 24) | 0x00100000 ); } while(0);
    case '!':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (0 && (pos[1] == *pos)) { pos += 2; return 0; } if (( 53 | ((25) << 24) | 0x00700000 ) && (pos[1] == '=')) { pos += 2; return ( 53 | ((25) << 24) | 0x00700000 ); } ++pos; return ( 29 ); } while(0);
    case '<':   do { if (( 41 | ((6) << 24) | 0x00100000 ) && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return ( 41 | ((6) << 24) | 0x00100000 ); } if (( 39 | ((20) << 24) | 0x00900000 ) && (pos[1] == *pos)) { pos += 2; return ( 39 | ((20) << 24) | 0x00900000 ); } if (( 40 | ((21) << 24) | 0x00800000 ) && (pos[1] == '=')) { pos += 2; return ( 40 | ((21) << 24) | 0x00800000 ); } ++pos; return ( 38 | ((19) << 24) | 0x00800000 ); } while(0);
    case '>':   do { if (( 37 | ((7) << 24) | 0x00100000 ) && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return ( 37 | ((7) << 24) | 0x00100000 ); } if (( 35 | ((17) << 24) | 0x00900000 ) && (pos[1] == *pos)) { pos += 2; return ( 35 | ((17) << 24) | 0x00900000 ); } if (( 36 | ((18) << 24) | 0x00800000 ) && (pos[1] == '=')) { pos += 2; return ( 36 | ((18) << 24) | 0x00800000 ); } ++pos; return ( 34 | ((16) << 24) | 0x00800000 ); } while(0);
    case '^':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (0 && (pos[1] == *pos)) { pos += 2; return 0; } if (( 56 | ((10) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 56 | ((10) << 24) | 0x00100000 ); } ++pos; return ( 20 | ((11) << 24) | 0x00500000 ); } while(0);
    case '|':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (( 46 | ((27) << 24) | 0x00200000 ) && (pos[1] == *pos)) { pos += 2; return ( 46 | ((27) << 24) | 0x00200000 ); } if (( 47 | ((9) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 47 | ((9) << 24) | 0x00100000 ); } ++pos; return ( 45 | ((26) << 24) | 0x00400000 ); } while(0);
    case '&':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (( 43 | ((23) << 24) | 0x00300000 ) && (pos[1] == *pos)) { pos += 2; return ( 43 | ((23) << 24) | 0x00300000 ); } if (( 44 | ((8) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 44 | ((8) << 24) | 0x00100000 ); } ++pos; return ( 42 | ((22) << 24) | 0x00600000 ); } while(0);
    case '*':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (0 && (pos[1] == *pos)) { pos += 2; return 0; } if (( 50 | ((1) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 50 | ((1) << 24) | 0x00100000 ); } ++pos; return ( 31 | ((13) << 24) | 0x00B00000 ); } while(0);
    case '/':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (0 && (pos[1] == *pos)) { pos += 2; return 0; } if (( 51 | ((2) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 51 | ((2) << 24) | 0x00100000 ); } ++pos; return ( 30 | ((12) << 24) | 0x00B00000 ); } while(0);
    case '%':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (0 && (pos[1] == *pos)) { pos += 2; return 0; } if (( 55 | ((3) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 55 | ((3) << 24) | 0x00100000 ); } ++pos; return ( 54 | ((28) << 24) | 0x00B00000 ); } while(0);
    case '+':   do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (( 27 ) && (pos[1] == *pos)) { pos += 2; return ( 27 ); } if (( 49 | ((4) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 49 | ((4) << 24) | 0x00100000 ); } ++pos; return ( 32 | ((14) << 24) | 0x00A00000 ); } while(0);

    case '-':   if (pos[1] == '>') {
                    pos += 2;
                    return ( 26 );
                }

                do { if (0 && (pos[1] == *pos) && (pos[2] == '=')) { pos += 3; return 0; } if (( 28 ) && (pos[1] == *pos)) { pos += 2; return ( 28 ); } if (( 48 | ((5) << 24) | 0x00100000 ) && (pos[1] == '=')) { pos += 2; return ( 48 | ((5) << 24) | 0x00100000 ); } ++pos; return ( 33 | ((15) << 24) | 0x00A00000 ); } while(0);

    case '.':   if ((pos[1] == '.') && (pos[2] == '.')) {
                    pos += 3;
                    return ( 19 );
                }

                if (!((ctype[(pos[1]) & 0xFF] & (0x0002)) != 0)) {
                    ++pos;
                    return ( 18 );
                }



    case '0': case '1': case '2': case '3': case '4':
    case '5': case '6': case '7': case '8': case '9':

                return number();

    case 'A': case 'B': case 'C': case 'D': case 'E':
    case 'F': case 'G': case 'H': case 'I': case 'J':
    case 'K': case 'L': case 'M': case 'N': case 'O':
    case 'P': case 'Q': case 'R': case 'S': case 'T':
    case 'U': case 'V': case 'W': case 'X': case 'Y':
    case 'Z': case '_': case 'a': case 'b': case 'c':
    case 'd': case 'e': case 'f': case 'g': case 'h':
    case 'i': case 'j': case 'k': case 'l': case 'm':
    case 'n': case 'o': case 'p': case 'q': case 'r':
    case 's': case 't': case 'u': case 'v': case 'w':
    case 'x': case 'y': case 'z':






        while (((ctype[(*pos) & 0xFF] & (0x0001 | 0x0002)) != 0)) ++pos;
        token.s = (string((text), (pos - text), 0));

        if (token.s->k & 0x80000000)
            return token.s->k;
        else
            return ( 1 );

    case '\"':  return strlit();
    case '\'':  return ccon();

    case 0:
        if (pos == eof) return 0;

    default:
        error(4, 0, "invalid character in input (ASCII %d)", *pos & 0xFF);
    }
}





static struct token next = { ( 11 ) };

static void lex1(void)
{
    if (next.k == 0)
        token.k = lex0();
    else {
        token = next;
        next.k = 0;
    }
}

struct token lookahead(void)
{
    struct token tmp;

    if (next.k == 0) {
        tmp = token;
        lex();
        next = token;
        token = tmp;
    }

    return next;
}






void lex(void)
{
    lex1();

    while (token.k == ( 11 )) {
        ++line_no;
        lex1();

        if (token.k == ( 10 )) {
            lex1();
            if (token.k == ( 3 | 0x40000000 )) {
                line_no = token.con.i;
                lex1();
                if (token.k == ( 2 )) {
                    path = token.s;
                    lex1();
                }
            }





            if (token.k != ( 11 )) error(4, 0, "malformed directive");
            lex1();
        }
    }
}




void init_lex(char *in_path)
{
    struct stat statbuf;
    int fd;

    path = (string((in_path), (strlen(in_path)), 0));
    fd = open(in_path, 00000000);
    if (fd == -1) error(2, 0, "can't open input");
    if (fstat(fd, &statbuf) == -1) error(2, 0, "can't stat input");

    if (statbuf.st_size > 0) {
        text = mmap(0, statbuf.st_size, 0x00000001, 0x00000002, fd, 0);
        if (text == ((void *) -1L)) error(2, 0, "can't mmap input");
        eof = text + statbuf.st_size;

        if ((statbuf.st_size % 4096) == 0) {
            eof = mmap(eof, 4096, 0x00000001,
                            0x00000020 | 0x00000002, -1, 0);

            if (eof == ((void *) -1L)) error(2, 0, "can't mmap guard");
        }
    } else
        text = eof = "";

    pos = text;
    close(fd);
    lex();
}

void expect(int k)
{
    if (token.k != k)
        error(4, 0, "expected %k before %K", k, &token);
}
