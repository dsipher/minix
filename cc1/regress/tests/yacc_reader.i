# 1 "reader.c"

# 44 "/home/charles/xcc/include/assert.h"
extern void __assert(const char *e, const char *file, int line);
# 44 "/home/charles/xcc/include/ctype.h"
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
# 39 "/home/charles/xcc/include/sys/jewel.h"
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
# 48 "/home/charles/xcc/include/stdio.h"
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
extern FILE *freopen(const char *, const char *, FILE *);
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
# 44 "/home/charles/xcc/include/string.h"
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
# 53 "/home/charles/xcc/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void _exit(int);
extern void exit(int);

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
# 48 "/home/charles/xcc/include/unistd.h"
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
# 129 "defs.h"
typedef struct bucket bucket;
struct bucket
{
    struct bucket *link;
    struct bucket *next;
    char *name;
    char *tag;
    short value;
    short index;
    short prec;
    char class;
    char assoc;
};




typedef struct core core;
struct core
{
    struct core *next;
    struct core *link;
    short number;
    short accessing_symbol;
    short nitems;
    short items[1];
};




typedef struct shifts shifts;
struct shifts
{
    struct shifts *next;
    short number;
    short nshifts;
    short shift[1];
};




typedef struct reductions reductions;
struct reductions
{
    struct reductions *next;
    short number;
    short nreds;
    short rules[1];
};




typedef struct action action;
struct action
{
    struct action *next;
    short symbol;
    short number;
    short prec;
    char action_code;
    char assoc;
    char suppressed;
};




extern char dflag;
extern char lflag;
extern char rflag;
extern char tflag;
extern char vflag;
extern char *symbol_prefix;

extern char *myname;
extern char *cptr;
extern char *line;
extern int lineno;
extern int outline;

extern char *banner[];
extern char *tables[];
extern char *header[];
extern char *body[];
extern char *trailer[];

extern char *action_file_name;
extern char *code_file_name;
extern char *defines_file_name;
extern char *input_file_name;
extern char *output_file_name;
extern char *text_file_name;
extern char *union_file_name;
extern char *verbose_file_name;

extern FILE *action_file;
extern FILE *code_file;
extern FILE *defines_file;
extern FILE *input_file;
extern FILE *output_file;
extern FILE *text_file;
extern FILE *union_file;
extern FILE *verbose_file;

extern int nitems;
extern int nrules;
extern int nsyms;
extern int ntokens;
extern int nvars;
extern int ntags;

extern char unionized;
extern char line_format[];

extern int   start_symbol;
extern char  **symbol_name;
extern short *symbol_value;
extern short *symbol_prec;
extern char  *symbol_assoc;

extern short *ritem;
extern short *rlhs;
extern short *rrhs;
extern short *rprec;
extern char  *rassoc;

extern short **derives;
extern char *nullable;

extern bucket *first_symbol;
extern bucket *last_symbol;

extern int nstates;
extern core *first_state;
extern shifts *first_shift;
extern reductions *first_reduction;
extern short *accessing_symbol;
extern core **state_table;
extern shifts **shift_table;
extern reductions **reduction_table;
extern unsigned *LA;
extern short *LAruleno;
extern short *lookaheads;
extern short *goto_map;
extern short *from_state;
extern short *to_state;

extern action **parser;
extern int SRtotal;
extern int RRtotal;
extern short *SRconflicts;
extern short *RRconflicts;
extern short *defred;
extern short *rules_used;
extern short nunused;
extern short final_state;




extern char *allocate(size_t n);



extern void closure(short *nucleus, int n);
extern void set_first_derives(void);
extern void finalize_closure(void);



extern void fatal(char *msg);
extern void no_space(void);
extern void open_error(char *filename);
extern void unexpected_EOF(void);
extern void print_pos(char *st_line, char *st_cptr);
extern void syntax_error(int st_lineno, char *st_line, char *st_cptr);
extern void unterminated_comment(int c_lineno, char *c_line, char *c_cptr);
extern void unterminated_string(int s_lineno, char *s_line, char *s_cptr);
extern void unterminated_text(int t_lineno, char *t_line, char *t_cptr);
extern void unterminated_union(int u_lineno, char *u_line, char *u_cptr);
extern void over_unionized(char *u_cptr);
extern void illegal_tag(int t_lineno, char *t_line, char *t_cptr);
extern void illegal_character(char *c_cptr);
extern void used_reserved(char *s);
extern void tokenized_start(char *s);
extern void retyped_warning(char *s);
extern void reprec_warning(char *s);
extern void revalued_warning(char *s);
extern void terminal_start(char *s);
extern void restarted_warning(void);
extern void no_grammar(void);
extern void terminal_lhs(int s_lineno);
extern void prec_redeclared(void);
extern void unterminated_action(int a_lineno, char *a_line, char *a_cptr);
extern void dollar_warning(int a_lineno, int i);
extern void dollar_error(int a_lineno, char *a_line, char *a_cptr);
extern void untyped_lhs(void);
extern void untyped_rhs(int i, char *s);
extern void unknown_rhs(int i);
extern void default_action_warning(void);
extern void undefined_goal(char *s);
extern void undefined_symbol_warning(char *s);



extern void lalr(void);



extern void lr0(void);



extern void done(int k);



extern action *parse_actions(int stateno);
extern action *get_shifts(int stateno);
extern action *add_reductions(int stateno, action *actions);
extern action *add_reduce(action *actions, int ruleno, int symbol);
extern void make_parser(void);
extern void free_parser(void);



extern void output(void);



extern void reader(void);



extern void write_section(char *name[]);



extern void create_symbol_table(void);
extern void free_symbol_table(void);
extern void free_symbols(void);
extern bucket *lookup(char *name);
extern bucket *make_bucket(char *name);



extern void verbose(void);



extern void reflexive_transitive_closure(unsigned *R, int n);
# 25 "reader.c"
char *cache;
int cinc, cache_size;

int ntags, tagmax;
char **tag_table;

char saw_eof, unionized;
char *cptr, *line;
int linesize;

bucket *goal;
int prec;
int gensym;
char last_was_action;

int maxitems;
bucket **pitem;

int maxrules;
bucket **plhs;

int name_pool_size;
char *name_pool;

char line_format[] = "#line %d \"%s\"\n";


static void
cachec(int c)
{
    if (!(cinc >= 0)) __assert("cinc >= 0", "reader.c", 55);;
    if (cinc >= cache_size)
    {
	cache_size += 256;
	cache = (realloc((char*)(cache),(unsigned)(cache_size)));
	if (cache == 0) no_space();
    }
    cache[cinc] = c;
    ++cinc;
}


static void
get_line(void)
{
    FILE *f = input_file;
    int c;
    int i;

    if (saw_eof || (c = (--(f)->_count >= 0 ? (int) (*(f)->_ptr++) : __fillbuf(f))) == (-1))
    {
	if (line) { (free((char*)(line))); line = 0; }
	cptr = 0;
	saw_eof = 1;
	return;
    }

    if (line == 0 || linesize != (100 + 1))
    {
	if (line) (free((char*)(line)));
	linesize = 100 + 1;
	line = (malloc((unsigned)(linesize)));
	if (line == 0) no_space();
    }

    i = 0;
    ++lineno;
    for (;;)
    {
	line[i]  =  c;
	if (c == '\n') { cptr = line; return; }
	if (++i >= linesize)
	{
	    linesize += 100;
	    line = (realloc((char*)(line),(unsigned)(linesize)));
	    if (line ==  0) no_space();
	}
	c = (--(f)->_count >= 0 ? (int) (*(f)->_ptr++) : __fillbuf(f));
	if (c ==  (-1))
	{
	    line[i] = '\n';
	    saw_eof = 1;
	    cptr = line;
	    return;
	}
    }
}


static char *
dup_line(void)
{
    char *p, *s, *t;

    if (line == 0) return (0);
    s = line;
    while (*s != '\n') ++s;
    p = (malloc((unsigned)(s - line + 1)));
    if (p == 0) no_space();

    s = line;
    t = p;
    while ((*t++ = *s++) != '\n') continue;
    return (p);
}


static void
skip_comment(void)
{
    char *s;

    int st_lineno = lineno;
    char *st_line = dup_line();
    char *st_cptr = st_line + (cptr - line);

    s = cptr + 2;
    for (;;)
    {
	if (*s == '*' && s[1] == '/')
	{
	    cptr = s + 2;
	    (free((char*)(st_line)));
	    return;
	}
	if (*s == '\n')
	{
	    get_line();
	    if (line == 0)
		unterminated_comment(st_lineno, st_line, st_cptr);
	    s = cptr;
	}
	else
	    ++s;
    }
}


static int
nextc(void)
{
    char *s;

    if (line == 0)
    {
	get_line();
	if (line == 0)
	    return ((-1));
    }

    s = cptr;
    for (;;)
    {
	switch (*s)
	{
	case '\n':
	    get_line();
	    if (line == 0) return ((-1));
	    s = cptr;
	    break;

	case ' ':
	case '\t':
	case '\f':
	case '\r':
	case '\v':
	case ',':
	case ';':
	    ++s;
	    break;

	case '\\':
	    cptr = s;
	    return ('%');

	case '/':
	    if (s[1] == '*')
	    {
		cptr = s;
		skip_comment();
		s = cptr;
		break;
	    }
	    else if (s[1] == '/')
	    {
		get_line();
		if (line == 0) return ((-1));
		s = cptr;
		break;
	    }
	

	default:
	    cptr = s;
	    return (*s);
	}
    }
}


static int
keyword(void)
{
    int c;
    char *t_cptr = cptr;

    c = *++cptr;
    if (((__ctype+1)[c]&(0x01|0x02)))
    {
	cinc = 0;
	for (;;)
	{
	    if (((__ctype+1)[c]&(0x01|0x02)))
	    {
		if (((__ctype+1)[c]&0x01)) c = tolower(c);
		cachec(c);
	    }
	    else if (((__ctype+1)[c]&0x04) || c == '_' || c == '.' || c == '$')
		cachec(c);
	    else
		break;
	    c = *++cptr;
	}
	cachec('\0');

	if (strcmp(cache, "token") == 0 || strcmp(cache, "term") == 0)
	    return (0);
	if (strcmp(cache, "type") == 0)
	    return (6);
	if (strcmp(cache, "left") == 0)
	    return (1);
	if (strcmp(cache, "right") == 0)
	    return (2);
	if (strcmp(cache, "nonassoc") == 0 || strcmp(cache, "binary") == 0)
	    return (3);
	if (strcmp(cache, "start") == 0)
	    return (7);
	if (strcmp(cache, "union") == 0)
	    return (8);
	if (strcmp(cache, "ident") == 0)
	    return (9);
    }
    else
    {
	++cptr;
	if (c == '{')
	    return (5);
	if (c == '%' || c == '\\')
	    return (4);
	if (c == '<')
	    return (1);
	if (c == '>')
	    return (2);
	if (c == '0')
	    return (0);
	if (c == '2')
	    return (3);
    }
    syntax_error(lineno, line, t_cptr);

}


static void
copy_ident(void)
{
    int c;
    FILE *f = output_file;

    c = nextc();
    if (c == (-1)) unexpected_EOF();
    if (c != '"') syntax_error(lineno, line, cptr);
    ++outline;
    fprintf(f, "#ident \"");
    for (;;)
    {
	c = *++cptr;
	if (c == '\n')
	{
	    fprintf(f, "\"\n");
	    return;
	}
	(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
	if (c == '"')
	{
	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('\n')) : __flushbuf(('\n'),(f)));
	    ++cptr;
	    return;
	}
    }
}


static void
copy_text(void)
{
    int c;
    int quote;
    FILE *f = text_file;
    int need_newline = 0;
    int t_lineno = lineno;
    char *t_line = dup_line();
    char *t_cptr = t_line + (cptr - line - 2);

    if (*cptr == '\n')
    {
	get_line();
	if (line == 0)
	    unterminated_text(t_lineno, t_line, t_cptr);
    }
    if (!lflag) fprintf(f, line_format, lineno, input_file_name);

loop:
    c = *cptr++;
    switch (c)
    {
    case '\n':
    next_line:
	(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('\n')) : __flushbuf(('\n'),(f)));
	need_newline = 0;
	get_line();
	if (line) goto loop;
	unterminated_text(t_lineno, t_line, t_cptr);

    case '\'':
    case '"':
	{
	    int s_lineno = lineno;
	    char *s_line = dup_line();
	    char *s_cptr = s_line + (cptr - line - 1);

	    quote = c;
	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
	    for (;;)
	    {
		c = *cptr++;
		(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
		if (c == quote)
		{
		    need_newline = 1;
		    (free((char*)(s_line)));
		    goto loop;
		}
		if (c == '\n')
		    unterminated_string(s_lineno, s_line, s_cptr);
		if (c == '\\')
		{
		    c = *cptr++;
		    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
		    if (c == '\n')
		    {
			get_line();
			if (line == 0)
			    unterminated_string(s_lineno, s_line, s_cptr);
		    }
		}
	    }
	}

    case '/':
	(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
	need_newline = 1;
	c = *cptr;
	if (c == '/')
	{
	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('*')) : __flushbuf(('*'),(f)));
	    while ((c = *++cptr) != '\n')
	    {
		if (c == '*' && cptr[1] == '/')
		    fprintf(f, "* ");
		else
		    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
	    }
	    fprintf(f, "*/");
	    goto next_line;
	}
	if (c == '*')
	{
	    int c_lineno = lineno;
	    char *c_line = dup_line();
	    char *c_cptr = c_line + (cptr - line - 1);

	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('*')) : __flushbuf(('*'),(f)));
	    ++cptr;
	    for (;;)
	    {
		c = *cptr++;
		(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
		if (c == '*' && *cptr == '/')
		{
		    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('/')) : __flushbuf(('/'),(f)));
		    ++cptr;
		    (free((char*)(c_line)));
		    goto loop;
		}
		if (c == '\n')
		{
		    get_line();
		    if (line == 0)
			unterminated_comment(c_lineno, c_line, c_cptr);
		}
	    }
	}
	need_newline = 1;
	goto loop;

    case '%':
    case '\\':
	if (*cptr == '}')
	{
	    if (need_newline) (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('\n')) : __flushbuf(('\n'),(f)));
	    ++cptr;
	    (free((char*)(t_line)));
	    return;
	}
	

    default:
	(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
	need_newline = 1;
	goto loop;
    }
}


static void
copy_union(void)
{
    int c;
    int quote;
    int depth;
    int u_lineno = lineno;
    char *u_line = dup_line();
    char *u_cptr = u_line + (cptr - line - 6);

    if (unionized) over_unionized(cptr - 6);
    unionized = 1;

    if (!lflag)
	fprintf(text_file, line_format, lineno, input_file_name);

    fprintf(text_file, "typedef union");
    if (dflag) fprintf(union_file, "typedef union");

    depth = 0;
loop:
    c = *cptr++;
    (--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = (c)) : __flushbuf((c),(text_file)));
    if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = (c)) : __flushbuf((c),(union_file)));
    switch (c)
    {
    case '\n':
    next_line:
	get_line();
	if (line == 0) unterminated_union(u_lineno, u_line, u_cptr);
	goto loop;

    case '{':
	++depth;
	goto loop;

    case '}':
	if (--depth == 0)
	{
	    fprintf(text_file, " YYSTYPE;\n");
	    (free((char*)(u_line)));
	    return;
	}
	goto loop;

    case '\'':
    case '"':
	{
	    int s_lineno = lineno;
	    char *s_line = dup_line();
	    char *s_cptr = s_line + (cptr - line - 1);

	    quote = c;
	    for (;;)
	    {
		c = *cptr++;
		(--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = (c)) : __flushbuf((c),(text_file)));
		if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = (c)) : __flushbuf((c),(union_file)));
		if (c == quote)
		{
		    (free((char*)(s_line)));
		    goto loop;
		}
		if (c == '\n')
		    unterminated_string(s_lineno, s_line, s_cptr);
		if (c == '\\')
		{
		    c = *cptr++;
		    (--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = (c)) : __flushbuf((c),(text_file)));
		    if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = (c)) : __flushbuf((c),(union_file)));
		    if (c == '\n')
		    {
			get_line();
			if (line == 0)
			    unterminated_string(s_lineno, s_line, s_cptr);
		    }
		}
	    }
	}

    case '/':
	c = *cptr;
	if (c == '/')
	{
	    (--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = ('*')) : __flushbuf(('*'),(text_file)));
	    if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = ('*')) : __flushbuf(('*'),(union_file)));
	    while ((c = *++cptr) != '\n')
	    {
		if (c == '*' && cptr[1] == '/')
		{
		    fprintf(text_file, "* ");
		    if (dflag) fprintf(union_file, "* ");
		}
		else
		{
		    (--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = (c)) : __flushbuf((c),(text_file)));
		    if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = (c)) : __flushbuf((c),(union_file)));
		}
	    }
	    fprintf(text_file, "*/\n");
	    if (dflag) fprintf(union_file, "*/\n");
	    goto next_line;
	}
	if (c == '*')
	{
	    int c_lineno = lineno;
	    char *c_line = dup_line();
	    char *c_cptr = c_line + (cptr - line - 1);

	    (--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = ('*')) : __flushbuf(('*'),(text_file)));
	    if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = ('*')) : __flushbuf(('*'),(union_file)));
	    ++cptr;
	    for (;;)
	    {
		c = *cptr++;
		(--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = (c)) : __flushbuf((c),(text_file)));
		if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = (c)) : __flushbuf((c),(union_file)));
		if (c == '*' && *cptr == '/')
		{
		    (--(text_file)->_count >= 0 ? (int) (*(text_file)->_ptr++ = ('/')) : __flushbuf(('/'),(text_file)));
		    if (dflag) (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++ = ('/')) : __flushbuf(('/'),(union_file)));
		    ++cptr;
		    (free((char*)(c_line)));
		    goto loop;
		}
		if (c == '\n')
		{
		    get_line();
		    if (line == 0)
			unterminated_comment(c_lineno, c_line, c_cptr);
		}
	    }
	}
	goto loop;

    default:
	goto loop;
    }
}


int
hexval(c)
int c;
{
    if (c >= '0' && c <= '9')
	return (c - '0');
    if (c >= 'A' && c <= 'F')
	return (c - 'A' + 10);
    if (c >= 'a' && c <= 'f')
	return (c - 'a' + 10);
    return (-1);
}


bucket *
get_literal()
{
    int c, quote;
    int i;
    int n;
    char *s;
    bucket *bp;
    int s_lineno = lineno;
    char *s_line = dup_line();
    char *s_cptr = s_line + (cptr - line);

    quote = *cptr++;
    cinc = 0;
    for (;;)
    {
	c = *cptr++;
	if (c == quote) break;
	if (c == '\n') unterminated_string(s_lineno, s_line, s_cptr);
	if (c == '\\')
	{
	    char *c_cptr = cptr - 1;

	    c = *cptr++;
	    switch (c)
	    {
	    case '\n':
		get_line();
		if (line == 0) unterminated_string(s_lineno, s_line, s_cptr);
		continue;

	    case '0': case '1': case '2': case '3':
	    case '4': case '5': case '6': case '7':
		n = c - '0';
		c = *cptr;
		if (((c) >= '0' && (c) <= '7'))
		{
		    n = (n << 3) + (c - '0');
		    c = *++cptr;
		    if (((c) >= '0' && (c) <= '7'))
		    {
			n = (n << 3) + (c - '0');
			++cptr;
		    }
		}
		if (n > 255) illegal_character(c_cptr);
		c = n;
	    	break;

	    case 'x':
		c = *cptr++;
		n = hexval(c);
		if (n < 0 || n >= 16)
		    illegal_character(c_cptr);
		for (;;)
		{
		    c = *cptr;
		    i = hexval(c);
		    if (i < 0 || i >= 16) break;
		    ++cptr;
		    n = (n << 4) + i;
		    if (n > 255) illegal_character(c_cptr);
		}
		c = n;
		break;

	    case 'a': c = 7; break;
	    case 'b': c = '\b'; break;
	    case 'f': c = '\f'; break;
	    case 'n': c = '\n'; break;
	    case 'r': c = '\r'; break;
	    case 't': c = '\t'; break;
	    case 'v': c = '\v'; break;
	    }
	}
	cachec(c);
    }
    (free((char*)(s_line)));

    n = cinc;
    s = (malloc((unsigned)(n)));
    if (s == 0) no_space();

    for (i = 0; i < n; ++i)
	s[i] = cache[i];

    cinc = 0;
    if (n == 1)
	cachec('\'');
    else
	cachec('"');

    for (i = 0; i < n; ++i)
    {
	c = ((unsigned char *)s)[i];
	if (c == '\\' || c == cache[0])
	{
	    cachec('\\');
	    cachec(c);
	}
	else if (((unsigned) ((c)-' ') < 95))
	    cachec(c);
	else
	{
	    cachec('\\');
	    switch (c)
	    {
	    case 7: cachec('a'); break;
	    case '\b': cachec('b'); break;
	    case '\f': cachec('f'); break;
	    case '\n': cachec('n'); break;
	    case '\r': cachec('r'); break;
	    case '\t': cachec('t'); break;
	    case '\v': cachec('v'); break;
	    default:
		cachec(((c >> 6) & 7) + '0');
		cachec(((c >> 3) & 7) + '0');
		cachec((c & 7) + '0');
		break;
	    }
	}
    }

    if (n == 1)
	cachec('\'');
    else
	cachec('"');

    cachec('\0');
    bp = lookup(cache);
    bp->class = 1;
    if (n == 1 && bp->value == (-1))
	bp->value = *(unsigned char *)s;
    (free((char*)(s)));

    return (bp);
}


int
is_reserved(name)
char *name;
{
    char *s;

    if (strcmp(name, ".") == 0 ||
	    strcmp(name, "$accept") == 0 ||
	    strcmp(name, "$end") == 0)
	return (1);

    if (name[0] == '$' && name[1] == '$' && ((__ctype+1)[name[2]]&0x04))
    {
	s = name + 3;
	while (((__ctype+1)[*s]&0x04)) ++s;
	if (*s == '\0') return (1);
    }

    return (0);
}


bucket *
get_name()
{
    int c;

    cinc = 0;
    for (c = *cptr; (((__ctype+1)[c]&(0x01|0x02|0x04)) || (c) == '_' || (c) == '.' || (c) == '$'); c = *++cptr)
	cachec(c);
    cachec('\0');

    if (is_reserved(cache)) used_reserved(cache);

    return (lookup(cache));
}


static int
get_number()
{
    int c;
    int n;

    n = 0;
    for (c = *cptr; ((__ctype+1)[c]&0x04); c = *++cptr)
	n = 10*n + (c - '0');

    return (n);
}


static char *
get_tag()
{
    int c;
    int i;
    char *s;
    int t_lineno = lineno;
    char *t_line = dup_line();
    char *t_cptr = t_line + (cptr - line);

    ++cptr;
    c = nextc();
    if (c == (-1)) unexpected_EOF();
    if (!((__ctype+1)[c]&(0x01|0x02)) && c != '_' && c != '$')
	illegal_tag(t_lineno, t_line, t_cptr);

    cinc = 0;
    do { cachec(c); c = *++cptr; } while ((((__ctype+1)[c]&(0x01|0x02|0x04)) || (c) == '_' || (c) == '.' || (c) == '$'));
    cachec('\0');

    c = nextc();
    if (c == (-1)) unexpected_EOF();
    if (c != '>')
	illegal_tag(t_lineno, t_line, t_cptr);
    ++cptr;

    for (i = 0; i < ntags; ++i)
    {
	if (strcmp(cache, tag_table[i]) == 0)
	    return (tag_table[i]);
    }

    if (ntags >= tagmax)
    {
	tagmax += 16;
	tag_table = (char **)
			(tag_table ? (realloc((char*)(tag_table),(unsigned)(tagmax*sizeof(char *))))
				   : (malloc((unsigned)(tagmax*sizeof(char *)))));
	if (tag_table == 0) no_space();
    }

    s = (malloc((unsigned)(cinc)));
    if  (s == 0) no_space();
    strcpy(s, cache);
    tag_table[ntags] = s;
    ++ntags;
    (free((char*)(t_line)));
    return (s);
}


static void
declare_tokens(int assoc)
{
    int c;
    bucket *bp;
    int value;
    char *tag = 0;

    if (assoc != 0) ++prec;

    c = nextc();
    if (c == (-1)) unexpected_EOF();
    if (c == '<')
    {
	tag = get_tag();
	c = nextc();
	if (c == (-1)) unexpected_EOF();
    }

    for (;;)
    {
	if (((__ctype+1)[c]&(0x01|0x02)) || c == '_' || c == '.' || c == '$')
	    bp = get_name();
	else if (c == '\'' || c == '"')
	    bp = get_literal();
	else
	    return;

	if (bp == goal) tokenized_start(bp->name);
	bp->class = 1;

	if (tag)
	{
	    if (bp->tag && tag != bp->tag)
		retyped_warning(bp->name);
	    bp->tag = tag;
	}

	if (assoc != 0)
	{
	    if (bp->prec && prec != bp->prec)
		reprec_warning(bp->name);
	    bp->assoc = assoc;
	    bp->prec = prec;
	}

	c = nextc();
	if (c == (-1)) unexpected_EOF();
	value = (-1);
	if (((__ctype+1)[c]&0x04))
	{
	    value = get_number();
	    if (bp->value != (-1) && value != bp->value)
		revalued_warning(bp->name);
	    bp->value = value;
	    c = nextc();
	    if (c == (-1)) unexpected_EOF();
	}
    }
}


static void
declare_types(void)
{
    int c;
    bucket *bp;
    char *tag;

    c = nextc();
    if (c == (-1)) unexpected_EOF();
    if (c != '<') syntax_error(lineno, line, cptr);
    tag = get_tag();

    for (;;)
    {
	c = nextc();
	if (((__ctype+1)[c]&(0x01|0x02)) || c == '_' || c == '.' || c == '$')
	    bp = get_name();
	else if (c == '\'' || c == '"')
	    bp = get_literal();
	else
	    return;

	if (bp->tag && tag != bp->tag)
	    retyped_warning(bp->name);
	bp->tag = tag;
    }
}


static void
declare_start(void)
{
    int c;
    bucket *bp;

    c = nextc();
    if (c == (-1)) unexpected_EOF();
    if (!((__ctype+1)[c]&(0x01|0x02)) && c != '_' && c != '.' && c != '$')
	syntax_error(lineno, line, cptr);
    bp = get_name();
    if (bp->class == 1)
	terminal_start(bp->name);
    if (goal && goal != bp)
	restarted_warning();
    goal = bp;
}


static void
read_declarations(void)
{
    int c, k;

    cache_size = 256;
    cache = (malloc((unsigned)(cache_size)));
    if (cache == 0) no_space();

    for (;;)
    {
	c = nextc();
	if (c == (-1)) unexpected_EOF();
	if (c != '%') syntax_error(lineno, line, cptr);
	switch (k = keyword())
	{
	case 4:
	    return;

	case 9:
	    copy_ident();
	    break;

	case 5:
	    copy_text();
	    break;

	case 8:
	    copy_union();
	    break;

	case 0:
	case 1:
	case 2:
	case 3:
	    declare_tokens(k);
	    break;

	case 6:
	    declare_types();
	    break;

	case 7:
	    declare_start();
	    break;
	}
    }
}


static void
initialize_grammar(void)
{
    nitems = 4;
    maxitems = 300;
    pitem = (bucket **) (malloc((unsigned)(maxitems*sizeof(bucket *))));
    if (pitem == 0) no_space();
    pitem[0] = 0;
    pitem[1] = 0;
    pitem[2] = 0;
    pitem[3] = 0;

    nrules = 3;
    maxrules = 100;
    plhs = (bucket **) (malloc((unsigned)(maxrules*sizeof(bucket *))));
    if (plhs == 0) no_space();
    plhs[0] = 0;
    plhs[1] = 0;
    plhs[2] = 0;
    rprec = (short *) (malloc((unsigned)(maxrules*sizeof(short))));
    if (rprec == 0) no_space();
    rprec[0] = 0;
    rprec[1] = 0;
    rprec[2] = 0;
    rassoc = (char *) (malloc((unsigned)(maxrules*sizeof(char))));
    if (rassoc == 0) no_space();
    rassoc[0] = 0;
    rassoc[1] = 0;
    rassoc[2] = 0;
}


static void
expand_items(void)
{
    maxitems += 300;
    pitem = (bucket **) (realloc((char*)(pitem),(unsigned)(maxitems*sizeof(bucket *))));
    if (pitem == 0) no_space();
}


static void
expand_rules(void)
{
    maxrules += 100;
    plhs = (bucket **) (realloc((char*)(plhs),(unsigned)(maxrules*sizeof(bucket *))));
    if (plhs == 0) no_space();
    rprec = (short *) (realloc((char*)(rprec),(unsigned)(maxrules*sizeof(short))));
    if (rprec == 0) no_space();
    rassoc = (char *) (realloc((char*)(rassoc),(unsigned)(maxrules*sizeof(char))));
    if (rassoc == 0) no_space();
}


static void
start_rule(bucket *bp, int s_lineno)
{
    if (bp->class == 1)
	terminal_lhs(s_lineno);
    bp->class = 2;
    if (nrules >= maxrules)
	expand_rules();
    plhs[nrules] = bp;
    rprec[nrules] = (-1);
    rassoc[nrules] = 0;
}


static void
advance_to_start(void)
{
    int c;
    bucket *bp;
    char *s_cptr;
    int s_lineno;

    for (;;)
    {
	c = nextc();
	if (c != '%') break;
	s_cptr = cptr;
	switch (keyword())
	{
	case 4:
	    no_grammar();

	case 5:
	    copy_text();
	    break;

	case 7:
	    declare_start();
	    break;

	default:
	    syntax_error(lineno, line, s_cptr);
	}
    }

    c = nextc();
    if (!((__ctype+1)[c]&(0x01|0x02)) && c != '_' && c != '.' && c != '_')
	syntax_error(lineno, line, cptr);
    bp = get_name();
    if (goal == 0)
    {
	if (bp->class == 1)
	    terminal_start(bp->name);
	goal = bp;
    }

    s_lineno = lineno;
    c = nextc();
    if (c == (-1)) unexpected_EOF();
    if (c != ':') syntax_error(lineno, line, cptr);
    start_rule(bp, s_lineno);
    ++cptr;
}


static void
end_rule(void)
{
    int i;

    if (!last_was_action && plhs[nrules]->tag)
    {
	for (i = nitems - 1; pitem[i]; --i) continue;
	if (pitem[i+1] == 0 || pitem[i+1]->tag != plhs[nrules]->tag)
	    default_action_warning();
    }

    last_was_action = 0;
    if (nitems >= maxitems) expand_items();
    pitem[nitems] = 0;
    ++nitems;
    ++nrules;
}


static void
insert_empty_rule(void)
{
    bucket *bp, **bpp;

    if (!(cache)) __assert("cache", "reader.c", 1151);;
    sprintf(cache, "$$%d", ++gensym);
    bp = make_bucket(cache);
    last_symbol->next = bp;
    last_symbol = bp;
    bp->tag = plhs[nrules]->tag;
    bp->class = 2;

    if ((nitems += 2) > maxitems)
	expand_items();
    bpp = pitem + nitems - 1;
    *bpp-- = bp;
    while (bpp[0] = bpp[-1]) --bpp;

    if (++nrules >= maxrules)
	expand_rules();
    plhs[nrules] = plhs[nrules-1];
    plhs[nrules-1] = bp;
    rprec[nrules] = rprec[nrules-1];
    rprec[nrules-1] = 0;
    rassoc[nrules] = rassoc[nrules-1];
    rassoc[nrules-1] = 0;
}


static void
add_symbol(void)
{
    int c;
    bucket *bp;
    int s_lineno = lineno;

    c = *cptr;
    if (c == '\'' || c == '"')
	bp = get_literal();
    else
	bp = get_name();

    c = nextc();
    if (c == ':')
    {
	end_rule();
	start_rule(bp, s_lineno);
	++cptr;
	return;
    }

    if (last_was_action)
	insert_empty_rule();
    last_was_action = 0;

    if (++nitems > maxitems)
	expand_items();
    pitem[nitems-1] = bp;
}


static void
copy_action(void)
{
    int c;
    int i, n;
    int depth;
    int quote;
    char *tag;
    FILE *f = action_file;
    int a_lineno = lineno;
    char *a_line = dup_line();
    char *a_cptr = a_line + (cptr - line);

    if (last_was_action)
	insert_empty_rule();
    last_was_action = 1;

    fprintf(f, "case %d:\n", nrules - 2);
    if (!lflag)
	fprintf(f, line_format, lineno, input_file_name);
    if (*cptr == '=') ++cptr;

    n = 0;
    for (i = nitems - 1; pitem[i]; --i) ++n;

    depth = 0;
loop:
    c = *cptr;
    if (c == '$')
    {
	if (cptr[1] == '<')
	{
	    int d_lineno = lineno;
	    char *d_line = dup_line();
	    char *d_cptr = d_line + (cptr - line);

	    ++cptr;
	    tag = get_tag();
	    c = *cptr;
	    if (c == '$')
	    {
		fprintf(f, "yyval.%s", tag);
		++cptr;
		(free((char*)(d_line)));
		goto loop;
	    }
	    else if (((__ctype+1)[c]&0x04))
	    {
		i = get_number();
		if (i > n) dollar_warning(d_lineno, i);
		fprintf(f, "yyvsp[%d].%s", i - n, tag);
		(free((char*)(d_line)));
		goto loop;
	    }
	    else if (c == '-' && ((__ctype+1)[cptr[1]]&0x04))
	    {
		++cptr;
		i = -get_number() - n;
		fprintf(f, "yyvsp[%d].%s", i, tag);
		(free((char*)(d_line)));
		goto loop;
	    }
	    else
		dollar_error(d_lineno, d_line, d_cptr);
	}
	else if (cptr[1] == '$')
	{
	    if (ntags)
	    {
		tag = plhs[nrules]->tag;
		if (tag == 0) untyped_lhs();
		fprintf(f, "yyval.%s", tag);
	    }
	    else
		fprintf(f, "yyval");
	    cptr += 2;
	    goto loop;
	}
	else if (((__ctype+1)[cptr[1]]&0x04))
	{
	    ++cptr;
	    i = get_number();
	    if (ntags)
	    {
		if (i <= 0 || i > n)
		    unknown_rhs(i);
		tag = pitem[nitems + i - n - 1]->tag;
		if (tag == 0) untyped_rhs(i, pitem[nitems + i - n - 1]->name);
		fprintf(f, "yyvsp[%d].%s", i - n, tag);
	    }
	    else
	    {
		if (i > n)
		    dollar_warning(lineno, i);
		fprintf(f, "yyvsp[%d]", i - n);
	    }
	    goto loop;
	}
	else if (cptr[1] == '-')
	{
	    cptr += 2;
	    i = get_number();
	    if (ntags)
		unknown_rhs(-i);
	    fprintf(f, "yyvsp[%d]", -i - n);
	    goto loop;
	}
    }
    if (((__ctype+1)[c]&(0x01|0x02)) || c == '_' || c == '$')
    {
	do
	{
	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
	    c = *++cptr;
	} while (((__ctype+1)[c]&(0x01|0x02|0x04)) || c == '_' || c == '$');
	goto loop;
    }
    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
    ++cptr;
    switch (c)
    {
    case '\n':
    next_line:
	get_line();
	if (line) goto loop;
	unterminated_action(a_lineno, a_line, a_cptr);

    case ';':
	if (depth > 0) goto loop;
	fprintf(f, "\nbreak;\n");
	return;

    case '{':
	++depth;
	goto loop;

    case '}':
	if (--depth > 0) goto loop;
	fprintf(f, "\nbreak;\n");
	return;

    case '\'':
    case '"':
	{
	    int s_lineno = lineno;
	    char *s_line = dup_line();
	    char *s_cptr = s_line + (cptr - line - 1);

	    quote = c;
	    for (;;)
	    {
		c = *cptr++;
		(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
		if (c == quote)
		{
		    (free((char*)(s_line)));
		    goto loop;
		}
		if (c == '\n')
		    unterminated_string(s_lineno, s_line, s_cptr);
		if (c == '\\')
		{
		    c = *cptr++;
		    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
		    if (c == '\n')
		    {
			get_line();
			if (line == 0)
			    unterminated_string(s_lineno, s_line, s_cptr);
		    }
		}
	    }
	}

    case '/':
	c = *cptr;
	if (c == '/')
	{
	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('*')) : __flushbuf(('*'),(f)));
	    while ((c = *++cptr) != '\n')
	    {
		if (c == '*' && cptr[1] == '/')
		    fprintf(f, "* ");
		else
		    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
	    }
	    fprintf(f, "*/\n");
	    goto next_line;
	}
	if (c == '*')
	{
	    int c_lineno = lineno;
	    char *c_line = dup_line();
	    char *c_cptr = c_line + (cptr - line - 1);

	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('*')) : __flushbuf(('*'),(f)));
	    ++cptr;
	    for (;;)
	    {
		c = *cptr++;
		(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (c)) : __flushbuf((c),(f)));
		if (c == '*' && *cptr == '/')
		{
		    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('/')) : __flushbuf(('/'),(f)));
		    ++cptr;
		    (free((char*)(c_line)));
		    goto loop;
		}
		if (c == '\n')
		{
		    get_line();
		    if (line == 0)
			unterminated_comment(c_lineno, c_line, c_cptr);
		}
	    }
	}
	goto loop;

    default:
	goto loop;
    }
}


static int
mark_symbol(void)
{
    int c;
    bucket *bp;

    c = cptr[1];
    if (c == '%' || c == '\\')
    {
	cptr += 2;
	return (1);
    }

    if (c == '=')
	cptr += 2;
    else if ((c == 'p' || c == 'P') &&
	     ((c = cptr[2]) == 'r' || c == 'R') &&
	     ((c = cptr[3]) == 'e' || c == 'E') &&
	     ((c = cptr[4]) == 'c' || c == 'C') &&
	     ((c = cptr[5], !(((__ctype+1)[c]&(0x01|0x02|0x04)) || (c) == '_' || (c) == '.' || (c) == '$'))))
	cptr += 5;
    else
	syntax_error(lineno, line, cptr);

    c = nextc();
    if (((__ctype+1)[c]&(0x01|0x02)) || c == '_' || c == '.' || c == '$')
	bp = get_name();
    else if (c == '\'' || c == '"')
	bp = get_literal();
    else
    {
	syntax_error(lineno, line, cptr);
	
    }

    if (rprec[nrules] != (-1) && bp->prec != rprec[nrules])
	prec_redeclared();

    rprec[nrules] = bp->prec;
    rassoc[nrules] = bp->assoc;
    return (0);
}


static void
read_grammar(void)
{
    int c;

    initialize_grammar();
    advance_to_start();

    for (;;)
    {
	c = nextc();
	if (c == (-1)) break;
	if (((__ctype+1)[c]&(0x01|0x02)) || c == '_' || c == '.' || c == '$' || c == '\'' ||
		c == '"')
	    add_symbol();
	else if (c == '{' || c == '=')
	    copy_action();
	else if (c == '|')
	{
	    end_rule();
	    start_rule(plhs[nrules-1], 0);
	    ++cptr;
	}
	else if (c == '%')
	{
	    if (mark_symbol()) break;
	}
	else
	    syntax_error(lineno, line, cptr);
    }
    end_rule();
}


static void
free_tags(void)
{
    int i;

    if (tag_table == 0) return;

    for (i = 0; i < ntags; ++i)
    {
	if (!(tag_table[i])) __assert("tag_table[i]", "reader.c", 1519);;
	(free((char*)(tag_table[i])));
    }
    (free((char*)(tag_table)));
}


static void
pack_names(void)
{
    bucket *bp;
    char *p, *s, *t;

    name_pool_size = 13;
    for (bp = first_symbol; bp; bp = bp->next)
	name_pool_size += strlen(bp->name) + 1;
    name_pool = (malloc((unsigned)(name_pool_size)));
    if (name_pool == 0) no_space();

    strcpy(name_pool, "$accept");
    strcpy(name_pool+8, "$end");
    t = name_pool + 13;
    for (bp = first_symbol; bp; bp = bp->next)
    {
	p = t;
	s = bp->name;
	while (*t++ = *s++) continue;
	(free((char*)(bp->name)));
	bp->name = p;
    }
}


static void
check_symbols(void)
{
    bucket *bp;

    if (goal->class == 0)
	undefined_goal(goal->name);

    for (bp = first_symbol; bp; bp = bp->next)
    {
	if (bp->class == 0)
	{
	    undefined_symbol_warning(bp->name);
	    bp->class = 1;
	}
    }
}


static void
pack_symbols(void)
{
    bucket *bp;
    bucket **v;
    int i, j, k, n;

    nsyms = 2;
    ntokens = 1;
    for (bp = first_symbol; bp; bp = bp->next)
    {
	++nsyms;
	if (bp->class == 1) ++ntokens;
    }
    start_symbol = ntokens;
    nvars = nsyms - ntokens;

    symbol_name = (char **) (malloc((unsigned)(nsyms*sizeof(char *))));
    if (symbol_name == 0) no_space();
    symbol_value = (short *) (malloc((unsigned)(nsyms*sizeof(short))));
    if (symbol_value == 0) no_space();
    symbol_prec = (short *) (malloc((unsigned)(nsyms*sizeof(short))));
    if (symbol_prec == 0) no_space();
    symbol_assoc = (malloc((unsigned)(nsyms)));
    if (symbol_assoc == 0) no_space();

    v = (bucket **) (malloc((unsigned)(nsyms*sizeof(bucket *))));
    if (v == 0) no_space();

    v[0] = 0;
    v[start_symbol] = 0;

    i = 1;
    j = start_symbol + 1;
    for (bp = first_symbol; bp; bp = bp->next)
    {
	if (bp->class == 1)
	    v[i++] = bp;
	else
	    v[j++] = bp;
    }
    if (!(i == ntokens && j == nsyms)) __assert("i == ntokens && j == nsyms", "reader.c", 1612);;

    for (i = 1; i < ntokens; ++i)
	v[i]->index = i;

    goal->index = start_symbol + 1;
    k = start_symbol + 2;
    while (++i < nsyms)
	if (v[i] != goal)
	{
	    v[i]->index = k;
	    ++k;
	}

    goal->value = 0;
    k = 1;
    for (i = start_symbol + 1; i < nsyms; ++i)
    {
	if (v[i] != goal)
	{
	    v[i]->value = k;
	    ++k;
	}
    }

    k = 0;
    for (i = 1; i < ntokens; ++i)
    {
	n = v[i]->value;
	if (n > 256)
	{
	    for (j = k++; j > 0 && symbol_value[j-1] > n; --j)
		symbol_value[j] = symbol_value[j-1];
	    symbol_value[j] = n;
	}
    }

    if (v[1]->value == (-1))
	v[1]->value = 256;

    j = 0;
    n = 257;
    for (i = 2; i < ntokens; ++i)
    {
	if (v[i]->value == (-1))
	{
	    while (j < k && n == symbol_value[j])
	    {
		while (++j < k && n == symbol_value[j]) continue;
		++n;
	    }
	    v[i]->value = n;
	    ++n;
	}
    }

    symbol_name[0] = name_pool + 8;
    symbol_value[0] = 0;
    symbol_prec[0] = 0;
    symbol_assoc[0] = 0;
    for (i = 1; i < ntokens; ++i)
    {
	symbol_name[i] = v[i]->name;
	symbol_value[i] = v[i]->value;
	symbol_prec[i] = v[i]->prec;
	symbol_assoc[i] = v[i]->assoc;
    }
    symbol_name[start_symbol] = name_pool;
    symbol_value[start_symbol] = -1;
    symbol_prec[start_symbol] = 0;
    symbol_assoc[start_symbol] = 0;
    for (++i; i < nsyms; ++i)
    {
	k = v[i]->index;
	symbol_name[k] = v[i]->name;
	symbol_value[k] = v[i]->value;
	symbol_prec[k] = v[i]->prec;
	symbol_assoc[k] = v[i]->assoc;
    }

    (free((char*)(v)));
}


static void
pack_grammar(void)
{
    int i, j;
    int assoc, prec;

    ritem = (short *) (malloc((unsigned)(nitems*sizeof(short))));
    if (ritem == 0) no_space();
    rlhs = (short *) (malloc((unsigned)(nrules*sizeof(short))));
    if (rlhs == 0) no_space();
    rrhs = (short *) (malloc((unsigned)((nrules+1)*sizeof(short))));
    if (rrhs == 0) no_space();
    rprec = (short *) (realloc((char*)(rprec),(unsigned)(nrules*sizeof(short))));
    if (rprec == 0) no_space();
    rassoc = (realloc((char*)(rassoc),(unsigned)(nrules)));
    if (rassoc == 0) no_space();

    ritem[0] = -1;
    ritem[1] = goal->index;
    ritem[2] = 0;
    ritem[3] = -2;
    rlhs[0] = 0;
    rlhs[1] = 0;
    rlhs[2] = start_symbol;
    rrhs[0] = 0;
    rrhs[1] = 0;
    rrhs[2] = 1;

    j = 4;
    for (i = 3; i < nrules; ++i)
    {
	rlhs[i] = plhs[i]->index;
	rrhs[i] = j;
	assoc = 0;
	prec = 0;
	while (pitem[j])
	{
	    ritem[j] = pitem[j]->index;
	    if (pitem[j]->class == 1)
	    {
		prec = pitem[j]->prec;
		assoc = pitem[j]->assoc;
	    }
	    ++j;
	}
	ritem[j] = -i;
	++j;
	if (rprec[i] == (-1))
	{
	    rprec[i] = prec;
	    rassoc[i] = assoc;
	}
    }
    rrhs[i] = j;

    (free((char*)(plhs)));
    (free((char*)(pitem)));
}


static void
print_grammar(void)
{
    int i, j, k;
    int spacing;
    FILE *f = verbose_file;

    if (!vflag) return;

    k = 1;
    for (i = 2; i < nrules; ++i)
    {
	if (rlhs[i] != rlhs[i-1])
	{
	    if (i != 2) fprintf(f, "\n");
	    fprintf(f, "%4d  %s :", i - 2, symbol_name[rlhs[i]]);
	    spacing = strlen(symbol_name[rlhs[i]]) + 1;
	}
	else
	{
	    fprintf(f, "%4d  ", i - 2);
	    j = spacing;
	    while (--j >= 0) (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = (' ')) : __flushbuf((' '),(f)));
	    (--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('|')) : __flushbuf(('|'),(f)));
	}

	while (ritem[k] >= 0)
	{
	    fprintf(f, " %s", symbol_name[ritem[k]]);
	    ++k;
	}
	++k;
	(--(f)->_count >= 0 ? (int) (*(f)->_ptr++ = ('\n')) : __flushbuf(('\n'),(f)));
    }
}


void
reader(void)
{
    write_section(banner);
    create_symbol_table();
    read_declarations();
    read_grammar();
    free_symbol_table();
    free_tags();
    pack_names();
    check_symbols();
    pack_symbols();
    pack_grammar();
    free_symbols();
    print_grammar();
}
