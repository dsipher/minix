# 1 "mkpar.c"

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
# 17 "mkpar.c"
action **parser;
int SRtotal;
int RRtotal;
short *SRconflicts;
short *RRconflicts;
short *defred;
short *rules_used;
short nunused;
short final_state;

static int SRcount;
static int RRcount;

extern action *add_reduce();


action *
parse_actions(int stateno)
{
    action *actions;

    actions = get_shifts(stateno);
    actions = add_reductions(stateno, actions);
    return (actions);
}


action *
get_shifts(int stateno)
{
    action *actions, *temp;
    shifts *sp;
    short *to_state;
    int i, k;
    int symbol;

    actions = 0;
    sp = shift_table[stateno];
    if (sp)
    {
	to_state = sp->shift;
	for (i = sp->nshifts - 1; i >= 0; i--)
	{
	    k = to_state[i];
	    symbol = accessing_symbol[k];
	    if (((symbol) < start_symbol))
	    {
		temp = ((action*)allocate(sizeof(action)));
		temp->next = actions;
		temp->symbol = symbol;
		temp->number = k;
		temp->prec = symbol_prec[symbol];
		temp->action_code = 1;
		temp->assoc = symbol_assoc[symbol];
		actions = temp;
	    }
	}
    }
    return (actions);
}


action *
add_reductions(int stateno, action *actions)
{
    int i, j, m, n;
    int ruleno, tokensetsize;
    unsigned *rowp;

    tokensetsize = (((ntokens)+(32-1))/32);
    m = lookaheads[stateno];
    n = lookaheads[stateno + 1];
    for (i = m; i < n; i++)
    {
	ruleno = LAruleno[i];
	rowp = LA + i * tokensetsize;
	for (j = ntokens - 1; j >= 0; j--)
	{
	    if (((((rowp)[(j)>>5])>>((j)&31))&1))
		actions = add_reduce(actions, ruleno, j);
	}
    }
    return (actions);
}


action *
add_reduce(action *actions, int ruleno, int symbol)
{
    action *temp, *prev, *next;

    prev = 0;
    for (next = actions; next && next->symbol < symbol; next = next->next)
	prev = next;

    while (next && next->symbol == symbol && next->action_code == 1)
    {
	prev = next;
	next = next->next;
    }

    while (next && next->symbol == symbol &&
	    next->action_code == 2 && next->number < ruleno)
    {
	prev = next;
	next = next->next;
    }

    temp = ((action*)allocate(sizeof(action)));
    temp->next = next;
    temp->symbol = symbol;
    temp->number = ruleno;
    temp->prec = rprec[ruleno];
    temp->action_code = 2;
    temp->assoc = rassoc[ruleno];

    if (prev)
	prev->next = temp;
    else
	actions = temp;

    return (actions);
}


static void
find_final_state(void)
{
    int goal, i;
    short *to_state;
    shifts *p;

    p = shift_table[0];
    to_state = p->shift;
    goal = ritem[1];
    for (i = p->nshifts - 1; i >= 0; --i)
    {
	final_state = to_state[i];
	if (accessing_symbol[final_state] == goal) break;
    }
}


static void
unused_rules(void)
{
    int i;
    action *p;

    rules_used = (short *) (malloc((unsigned)(nrules*sizeof(short))));
    if (rules_used == 0) no_space();

    for (i = 0; i < nrules; ++i)
	rules_used[i] = 0;

    for (i = 0; i < nstates; ++i)
    {
	for (p = parser[i]; p; p = p->next)
	{
	    if (p->action_code == 2 && p->suppressed == 0)
		rules_used[p->number] = 1;
	}
    }

    nunused = 0;
    for (i = 3; i < nrules; ++i)
	if (!rules_used[i]) ++nunused;

    if (nunused)
	if (nunused == 1)
	    fprintf((&__stderr), "%s: 1 rule never reduced\n", myname);
	else
	    fprintf((&__stderr), "%s: %d rules never reduced\n", myname, nunused);
}


static void
remove_conflicts(void)
{
    int i;
    int symbol;
    action *p, *pref;

    SRtotal = 0;
    RRtotal = 0;
    SRconflicts = ((short*)allocate((unsigned)((nstates)*sizeof(short))));
    RRconflicts = ((short*)allocate((unsigned)((nstates)*sizeof(short))));
    for (i = 0; i < nstates; i++)
    {
	SRcount = 0;
	RRcount = 0;
	symbol = -1;
	for (p = parser[i]; p; p = p->next)
	{
	    if (p->symbol != symbol)
	    {
		pref = p;
		symbol = p->symbol;
	    }
	    else if (i == final_state && symbol == 0)
	    {
		SRcount++;
		p->suppressed = 1;
	    }
	    else if (pref->action_code == 1)
	    {
		if (pref->prec > 0 && p->prec > 0)
		{
		    if (pref->prec < p->prec)
		    {
			pref->suppressed = 2;
			pref = p;
		    }
		    else if (pref->prec > p->prec)
		    {
			p->suppressed = 2;
		    }
		    else if (pref->assoc == 1)
		    {
			pref->suppressed = 2;
			pref = p;
		    }
		    else if (pref->assoc == 2)
		    {
			p->suppressed = 2;
		    }
		    else
		    {
			pref->suppressed = 2;
			p->suppressed = 2;
		    }
		}
		else
		{
		    SRcount++;
		    p->suppressed = 1;
		}
	    }
	    else
	    {
		RRcount++;
		p->suppressed = 1;
	    }
	}
	SRtotal += SRcount;
	RRtotal += RRcount;
	SRconflicts[i] = SRcount;
	RRconflicts[i] = RRcount;
    }
}


static void
total_conflicts(void)
{
    fprintf((&__stderr), "%s: ", myname);
    if (SRtotal == 1)
	fprintf((&__stderr), "1 shift/reduce conflict");
    else if (SRtotal > 1)
	fprintf((&__stderr), "%d shift/reduce conflicts", SRtotal);

    if (SRtotal && RRtotal)
	fprintf((&__stderr), ", ");

    if (RRtotal == 1)
	fprintf((&__stderr), "1 reduce/reduce conflict");
    else if (RRtotal > 1)
	fprintf((&__stderr), "%d reduce/reduce conflicts", RRtotal);

    fprintf((&__stderr), ".\n");
}


static int
sole_reduction(int stateno)
{
    int count, ruleno;
    action *p;

    count = 0;
    ruleno = 0;
    for (p = parser[stateno]; p; p = p->next)
    {
	if (p->action_code == 1 && p->suppressed == 0)
	    return (0);
	else if (p->action_code == 2 && p->suppressed == 0)
	{
	    if (ruleno > 0 && p->number != ruleno)
		return (0);
	    if (p->symbol != 1)
		++count;
	    ruleno = p->number;
	}
    }

    if (count == 0)
	return (0);
    return (ruleno);
}


static void
defreds(void)
{
    int i;

    defred = ((short*)allocate((unsigned)((nstates)*sizeof(short))));
    for (i = 0; i < nstates; i++)
	defred[i] = sole_reduction(i);
}


static void
free_action_row(action *p)
{
    action *q;

    while (p)
    {
        q = p->next;
        (free((char*)(p)));
        p = q;
    }
}


void
free_parser(void)
{
    int i;

    for (i = 0; i < nstates; i++)
        free_action_row(parser[i]);

    (free((char*)(parser)));
}


void
make_parser(void)
{
    int i;

    parser = ((action **)allocate((unsigned)((nstates)*sizeof(action *))));
    for (i = 0; i < nstates; i++)
	parser[i] = parse_actions(i);

    find_final_state();
    remove_conflicts();
    unused_rules();
    if (SRtotal + RRtotal > 0) total_conflicts();
    defreds();
}
