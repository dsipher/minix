# 1 "error.c"

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
# 39 "/home/charles/xcc/include/sys/tahoe.h"
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
# 19 "error.c"
void
fatal(char *msg)
{
    fprintf((&__stderr), "%s: f - %s\n", myname, msg);
    done(2);
}


void
no_space(void)
{
    fprintf((&__stderr), "%s: f - out of space\n", myname);
    done(2);
}


void
open_error(char *filename)
{
    fprintf((&__stderr), "%s: f - cannot open \"%s\"\n", myname, filename);
    done(2);
}


void
unexpected_EOF(void)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", unexpected end-of-file\n",
	    myname, lineno, input_file_name);
    done(1);
}


void
print_pos(char *st_line, char *st_cptr)
{
    char *s;

    if (st_line == 0) return;
    for (s = st_line; *s != '\n'; ++s)
    {
	if (((unsigned) ((*s)-' ') < 95) || *s == '\t')
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = (*s)) : __flushbuf((*s),((&__stderr))));
	else
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('?')) : __flushbuf(('?'),((&__stderr))));
    }
    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
    for (s = st_line; s < st_cptr; ++s)
    {
	if (*s == '\t')
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\t')) : __flushbuf(('\t'),((&__stderr))));
	else
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = (' ')) : __flushbuf((' '),((&__stderr))));
    }
    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('^')) : __flushbuf(('^'),((&__stderr))));
    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
}


void
syntax_error(int st_lineno, char *st_line, char *st_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", syntax error\n",
	    myname, st_lineno, input_file_name);
    print_pos(st_line, st_cptr);
    done(1);
}


void
unterminated_comment(int c_lineno, char *c_line, char *c_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", unmatched /*\n",
	    myname, c_lineno, input_file_name);
    print_pos(c_line, c_cptr);
    done(1);
}


void
unterminated_string(int s_lineno, char *s_line, char *s_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", unterminated string\n",
	    myname, s_lineno, input_file_name);
    print_pos(s_line, s_cptr);
    done(1);
}


void
unterminated_text(int t_lineno, char *t_line, char *t_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", unmatched %%{\n",
	    myname, t_lineno, input_file_name);
    print_pos(t_line, t_cptr);
    done(1);
}


void
unterminated_union(int u_lineno, char *u_line, char *u_cptr)
{

    fprintf((&__stderr), "%s: e - line %d of \"%s\", unterminated %%union declaration\n", myname, u_lineno, input_file_name);
    print_pos(u_line, u_cptr);
    done(1);
}


void
over_unionized(char *u_cptr)
{

    fprintf((&__stderr), "%s: e - line %d of \"%s\", too many %%union declarations\n", myname, lineno, input_file_name);
    print_pos(line, u_cptr);
    done(1);
}


void
illegal_tag(int t_lineno, char *t_line, char *t_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", illegal tag\n",
	    myname, t_lineno, input_file_name);
    print_pos(t_line, t_cptr);
    done(1);
}


void
illegal_character(char *c_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", illegal character\n",
	    myname, lineno, input_file_name);
    print_pos(line, c_cptr);
    done(1);
}


void
used_reserved(char *s)
{

    fprintf((&__stderr), "%s: e - line %d of \"%s\", illegal use of reserved symbol %s\n", myname, lineno, input_file_name, s);
    done(1);
}


void
tokenized_start(char *s)
{

     fprintf((&__stderr), "%s: e - line %d of \"%s\", the start symbol %s cannot be declared to be a token\n", myname, lineno, input_file_name, s);
     done(1);
}


void
retyped_warning(char *s)
{

    fprintf((&__stderr), "%s: w - line %d of \"%s\", the type of %s has been redeclared\n", myname, lineno, input_file_name, s);
}


void
reprec_warning(char *s)
{

    fprintf((&__stderr), "%s: w - line %d of \"%s\", the precedence of %s has been redeclared\n", myname, lineno, input_file_name, s);
}


void
revalued_warning(char *s)
{

    fprintf((&__stderr), "%s: w - line %d of \"%s\", the value of %s has been redeclared\n", myname, lineno, input_file_name, s);
}


void
terminal_start(char *s)
{

    fprintf((&__stderr), "%s: e - line %d of \"%s\", the start symbol %s is a token\n", myname, lineno, input_file_name, s);
    done(1);
}


void
restarted_warning(void)
{

    fprintf((&__stderr), "%s: w - line %d of \"%s\", the start symbol has been redeclared\n", myname, lineno, input_file_name);
}


void
no_grammar(void)
{

    fprintf((&__stderr), "%s: e - line %d of \"%s\", no grammar has been specified\n", myname, lineno, input_file_name);
    done(1);
}


void
terminal_lhs(int s_lineno)
{

    fprintf((&__stderr), "%s: e - line %d of \"%s\", a token appears on the lhs of a production\n", myname, s_lineno, input_file_name);
    done(1);
}


void
prec_redeclared(void)
{

    fprintf((&__stderr), "%s: w - line %d of  \"%s\", conflicting %%prec specifiers\n", myname, lineno, input_file_name);
}


void
unterminated_action(int a_lineno, char *a_line, char *a_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", unterminated action\n",
	    myname, a_lineno, input_file_name);
    print_pos(a_line, a_cptr);
    done(1);
}


void
dollar_warning(int a_lineno, int i)
{

    fprintf((&__stderr), "%s: w - line %d of \"%s\", $%d references beyond the end of the current rule\n", myname, a_lineno, input_file_name, i);
}


void
dollar_error(int a_lineno, char *a_line, char *a_cptr)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", illegal $-name\n",
	    myname, a_lineno, input_file_name);
    print_pos(a_line, a_cptr);
    done(1);
}


void
untyped_lhs(void)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", $$ is untyped\n",
	    myname, lineno, input_file_name);
    done(1);
}


void
untyped_rhs(int i, char *s)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", $%d (%s) is untyped\n",
	    myname, lineno, input_file_name, i, s);
    done(1);
}


void
unknown_rhs(int i)
{
    fprintf((&__stderr), "%s: e - line %d of \"%s\", $%d is untyped\n",
	    myname, lineno, input_file_name, i);
    done(1);
}


void
default_action_warning(void)
{

    fprintf((&__stderr), "%s: w - line %d of \"%s\", the default action assigns an undefined value to $$\n", myname, lineno, input_file_name);
}


void
undefined_goal(char *s)
{
    fprintf((&__stderr), "%s: e - the start symbol %s is undefined\n", myname, s);
    done(1);
}


void
undefined_symbol_warning(char *s)
{
    fprintf((&__stderr), "%s: w - the symbol %s is undefined\n", myname, s);
}
