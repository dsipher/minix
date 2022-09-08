# 1 "output.c"

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
# 18 "output.c"
static int nvectors;
static int nentries;
static short **froms;
static short **tos;
static short *tally;
static short *width;
static short *state_count;
static short *order;
static short *base;
static short *pos;
static int maxtable;
static short *table;
static short *check;
static int lowzero;
static int high;


static void
output_prefix(void)
{
    if (symbol_prefix == ((void *) 0))
	symbol_prefix = "yy";
    else
    {
	++outline;
	fprintf(code_file, "#define yyparse %sparse\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yylex %slex\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyerror %serror\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yychar %schar\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyval %sval\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yylval %slval\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yydebug %sdebug\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yynerrs %snerrs\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyerrflag %serrflag\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyss %sss\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyssp %sssp\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyvs %svs\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyvsp %svsp\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yylhs %slhs\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yylen %slen\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yydefred %sdefred\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yydgoto %sdgoto\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yysindex %ssindex\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyrindex %srindex\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yygindex %sgindex\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yytable %stable\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yycheck %scheck\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyname %sname\n", symbol_prefix);
	++outline;
	fprintf(code_file, "#define yyrule %srule\n", symbol_prefix);
    }
    ++outline;
    fprintf(code_file, "#define YYPREFIX \"%s\"\n", symbol_prefix);
}


static void
output_rule_data(void)
{
    int i;
    int j;

    fprintf(output_file, "short %slhs[] = {%42d,", symbol_prefix,
	    symbol_value[start_symbol]);

    j = 10;
    for (i = 3; i < nrules; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
        else
	    ++j;

        fprintf(output_file, "%5d,", symbol_value[rlhs[i]]);
    }
    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");

    fprintf(output_file, "short %slen[] = {%42d,", symbol_prefix, 2);

    j = 10;
    for (i = 3; i < nrules; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
	else
	  j++;

        fprintf(output_file, "%5d,", rrhs[i + 1] - rrhs[i] - 1);
    }
    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");
}


static void
output_yydefred(void)
{
    int i, j;

    fprintf(output_file, "short %sdefred[] = {%39d,", symbol_prefix,
	    (defred[0] ? defred[0] - 2 : 0));

    j = 10;
    for (i = 1; i < nstates; i++)
    {
	if (j < 10)
	    ++j;
	else
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}

	fprintf(output_file, "%5d,", (defred[i] ? defred[i] - 2 : 0));
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");
}


static void
token_actions(void)
{
    int i, j;
    int shiftcount, reducecount;
    int max, min;
    short *actionrow, *r, *s;
    action *p;

    actionrow = ((short*)allocate((unsigned)((2*ntokens)*sizeof(short))));
    for (i = 0; i < nstates; ++i)
    {
	if (parser[i])
	{
	    for (j = 0; j < 2*ntokens; ++j)
	    actionrow[j] = 0;

	    shiftcount = 0;
	    reducecount = 0;
	    for (p = parser[i]; p; p = p->next)
	    {
		if (p->suppressed == 0)
		{
		    if (p->action_code == 1)
		    {
			++shiftcount;
			actionrow[p->symbol] = p->number;
		    }
		    else if (p->action_code == 2 && p->number != defred[i])
		    {
			++reducecount;
			actionrow[p->symbol + ntokens] = p->number;
		    }
		}
	    }

	    tally[i] = shiftcount;
	    tally[nstates+i] = reducecount;
	    width[i] = 0;
	    width[nstates+i] = 0;
	    if (shiftcount > 0)
	    {
		froms[i] = r = ((short*)allocate((unsigned)((shiftcount)*sizeof(short))));
		tos[i] = s = ((short*)allocate((unsigned)((shiftcount)*sizeof(short))));
		min = 32767;
		max = 0;
		for (j = 0; j < ntokens; ++j)
		{
		    if (actionrow[j])
		    {
			if (min > symbol_value[j])
			    min = symbol_value[j];
			if (max < symbol_value[j])
			    max = symbol_value[j];
			*r++ = symbol_value[j];
			*s++ = actionrow[j];
		    }
		}
		width[i] = max - min + 1;
	    }
	    if (reducecount > 0)
	    {
		froms[nstates+i] = r = ((short*)allocate((unsigned)((reducecount)*sizeof(short))));
		tos[nstates+i] = s = ((short*)allocate((unsigned)((reducecount)*sizeof(short))));
		min = 32767;
		max = 0;
		for (j = 0; j < ntokens; ++j)
		{
		    if (actionrow[ntokens+j])
		    {
			if (min > symbol_value[j])
			    min = symbol_value[j];
			if (max < symbol_value[j])
			    max = symbol_value[j];
			*r++ = symbol_value[j];
			*s++ = actionrow[ntokens+j] - 2;
		    }
		}
		width[nstates+i] = max - min + 1;
	    }
	}
    }
    (free((char*)(actionrow)));
}


static int
default_goto(int symbol)
{
    int i;
    int m;
    int n;
    int default_state;
    int max;

    m = goto_map[symbol];
    n = goto_map[symbol + 1];

    if (m == n) return (0);

    for (i = 0; i < nstates; i++)
	state_count[i] = 0;

    for (i = m; i < n; i++)
	state_count[to_state[i]]++;

    max = 0;
    default_state = 0;
    for (i = 0; i < nstates; i++)
    {
	if (state_count[i] > max)
	{
	    max = state_count[i];
	    default_state = i;
	}
    }

    return (default_state);
}


static void
save_column(int symbol, int default_state)
{
    int i;
    int m;
    int n;
    short *sp;
    short *sp1;
    short *sp2;
    int count;
    int symno;

    m = goto_map[symbol];
    n = goto_map[symbol + 1];

    count = 0;
    for (i = m; i < n; i++)
    {
	if (to_state[i] != default_state)
	    ++count;
    }
    if (count == 0) return;

    symno = symbol_value[symbol] + 2*nstates;

    froms[symno] = sp1 = sp = ((short*)allocate((unsigned)((count)*sizeof(short))));
    tos[symno] = sp2 = ((short*)allocate((unsigned)((count)*sizeof(short))));

    for (i = m; i < n; i++)
    {
	if (to_state[i] != default_state)
	{
	    *sp1++ = from_state[i];
	    *sp2++ = to_state[i];
	}
    }

    tally[symno] = count;
    width[symno] = sp1[-1] - sp[0] + 1;
}


static void
goto_actions(void)
{
    int i, j, k;

    state_count = ((short*)allocate((unsigned)((nstates)*sizeof(short))));

    k = default_goto(start_symbol + 1);
    fprintf(output_file, "short %sdgoto[] = {%40d,", symbol_prefix, k);
    save_column(start_symbol + 1, k);

    j = 10;
    for (i = start_symbol + 2; i < nsyms; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
	else
	    ++j;

	k = default_goto(i);
	fprintf(output_file, "%5d,", k);
	save_column(i, k);
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");
    (free((char*)(state_count)));
}


static void
sort_actions(void)
{
  int i;
  int j;
  int k;
  int t;
  int w;

  order = ((short*)allocate((unsigned)((nvectors)*sizeof(short))));
  nentries = 0;

  for (i = 0; i < nvectors; i++)
    {
      if (tally[i] > 0)
	{
	  t = tally[i];
	  w = width[i];
	  j = nentries - 1;

	  while (j >= 0 && (width[order[j]] < w))
	    j--;

	  while (j >= 0 && (width[order[j]] == w) && (tally[order[j]] < t))
	    j--;

	  for (k = nentries - 1; k > j; k--)
	    order[k + 1] = order[k];

	  order[j + 1] = i;
	  nentries++;
	}
    }
}


















static int
matching_vector(int vector)
{
    int i;
    int j;
    int k;
    int t;
    int w;
    int match;
    int prev;

    i = order[vector];
    if (i >= 2*nstates)
	return (-1);

    t = tally[i];
    w = width[i];

    for (prev = vector - 1; prev >= 0; prev--)
    {
	j = order[prev];
	if (width[j] != w || tally[j] != t)
	    return (-1);

	match = 1;
	for (k = 0; match && k < t; k++)
	{
	    if (tos[j][k] != tos[i][k] || froms[j][k] != froms[i][k])
		match = 0;
	}

	if (match)
	    return (j);
    }

    return (-1);
}


static int
pack_vector(int vector)
{
    int i, j, k, l;
    int t;
    int loc;
    int ok;
    short *from;
    short *to;
    int newmax;

    i = order[vector];
    t = tally[i];
    if (!(t)) __assert("t", "output.c", 472);;

    from = froms[i];
    to = tos[i];

    j = lowzero - from[0];
    for (k = 1; k < t; ++k)
	if (lowzero - from[k] > j)
	    j = lowzero - from[k];
    for (;; ++j)
    {
	if (j == 0)
	    continue;
	ok = 1;
	for (k = 0; ok && k < t; k++)
	{
	    loc = j + from[k];
	    if (loc >= maxtable)
	    {
		if (loc >= 32500)
		    fatal("maximum table size exceeded");

		newmax = maxtable;
		do { newmax += 200; } while (newmax <= loc);
		table = (short *) (realloc((char*)(table),(unsigned)(newmax*sizeof(short))));
		if (table == 0) no_space();
		check = (short *) (realloc((char*)(check),(unsigned)(newmax*sizeof(short))));
		if (check == 0) no_space();
		for (l  = maxtable; l < newmax; ++l)
		{
		    table[l] = 0;
		    check[l] = -1;
		}
		maxtable = newmax;
	    }

	    if (check[loc] != -1)
		ok = 0;
	}
	for (k = 0; ok && k < vector; k++)
	{
	    if (pos[k] == j)
		ok = 0;
	}
	if (ok)
	{
	    for (k = 0; k < t; k++)
	    {
		loc = j + from[k];
		table[loc] = to[k];
		check[loc] = from[k];
		if (loc > high) high = loc;
	    }

	    while (check[lowzero] != -1)
		++lowzero;

	    return (j);
	}
    }
}


static void
pack_table(void)
{
    int i;
    int place;
    int state;

    base = ((short*)allocate((unsigned)((nvectors)*sizeof(short))));
    pos = ((short*)allocate((unsigned)((nentries)*sizeof(short))));

    maxtable = 1000;
    table = ((short*)allocate((unsigned)((maxtable)*sizeof(short))));
    check = ((short*)allocate((unsigned)((maxtable)*sizeof(short))));

    lowzero = 0;
    high = 0;

    for (i = 0; i < maxtable; i++)
	check[i] = -1;

    for (i = 0; i < nentries; i++)
    {
	state = matching_vector(i);

	if (state < 0)
	    place = pack_vector(i);
	else
	    place = base[state];

	pos[i] = place;
	base[order[i]] = place;
    }

    for (i = 0; i < nvectors; i++)
    {
	if (froms[i])
	    (free((char*)(froms[i])));
	if (tos[i])
	    (free((char*)(tos[i])));
    }

    (free((char*)(froms)));
    (free((char*)(tos)));
    (free((char*)(pos)));
}


static void
output_base(void)
{
    int i, j;

    fprintf(output_file, "short %ssindex[] = {%39d,", symbol_prefix, base[0]);

    j = 10;
    for (i = 1; i < nstates; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
	else
	    ++j;

	fprintf(output_file, "%5d,", base[i]);
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\nshort %srindex[] = {%39d,", symbol_prefix,
	    base[nstates]);

    j = 10;
    for (i = nstates + 1; i < 2*nstates; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
	else
	    ++j;

	fprintf(output_file, "%5d,", base[i]);
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\nshort %sgindex[] = {%39d,", symbol_prefix,
	    base[2*nstates]);

    j = 10;
    for (i = 2*nstates + 1; i < nvectors - 1; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
	else
	    ++j;

	fprintf(output_file, "%5d,", base[i]);
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");
    (free((char*)(base)));
}


static void
output_table(void)
{
    int i;
    int j;

    ++outline;
    fprintf(code_file, "#define YYTABLESIZE %d\n", high);
    fprintf(output_file, "short %stable[] = {%40d,", symbol_prefix,
	    table[0]);

    j = 10;
    for (i = 1; i <= high; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
	else
	    ++j;

	fprintf(output_file, "%5d,", table[i]);
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");
    (free((char*)(table)));
}


static void
output_check(void)
{
    int i;
    int j;

    fprintf(output_file, "short %scheck[] = {%40d,", symbol_prefix,
	    check[0]);

    j = 10;
    for (i = 1; i <= high; i++)
    {
	if (j >= 10)
	{
	    if (!rflag) ++outline;
	    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
	    j = 1;
	}
	else
	    ++j;

	fprintf(output_file, "%5d,", check[i]);
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");
    (free((char*)(check)));
}


static void
output_actions(void)
{
    nvectors = 2*nstates + nvars;

    froms = ((short **)allocate((unsigned)((nvectors)*sizeof(short *))));
    tos = ((short **)allocate((unsigned)((nvectors)*sizeof(short *))));
    tally = ((short*)allocate((unsigned)((nvectors)*sizeof(short))));
    width = ((short*)allocate((unsigned)((nvectors)*sizeof(short))));

    token_actions();
    (free((char*)(lookaheads)));
    (free((char*)(LA)));
    (free((char*)(LAruleno)));
    (free((char*)(accessing_symbol)));

    goto_actions();
    (free((char*)(goto_map + ntokens)));
    (free((char*)(from_state)));
    (free((char*)(to_state)));

    sort_actions();
    pack_table();
    output_base();
    output_table();
    output_check();
}


static int
is_C_identifier(char *name)
{
    char *s;
    int c;

    s = name;
    c = *s;
    if (c == '"')
    {
	c = *++s;
	if (!((__ctype+1)[c]&(0x01|0x02)) && c != '_' && c != '$')
	    return (0);
	while ((c = *++s) != '"')
	{
	    if (!((__ctype+1)[c]&(0x01|0x02|0x04)) && c != '_' && c != '$')
		return (0);
	}
	return (1);
    }

    if (!((__ctype+1)[c]&(0x01|0x02)) && c != '_' && c != '$')
	return (0);
    while (c = *++s)
    {
	if (!((__ctype+1)[c]&(0x01|0x02|0x04)) && c != '_' && c != '$')
	    return (0);
    }
    return (1);
}


static void
output_defines(void)
{
    int c, i;
    char *s;

    for (i = 2; i < ntokens; ++i)
    {
	s = symbol_name[i];
	if (is_C_identifier(s))
	{
	    fprintf(code_file, "#define ");
	    if (dflag) fprintf(defines_file, "#define ");
	    c = *s;
	    if (c == '"')
	    {
		while ((c = *++s) != '"')
		{
		    (--(code_file)->_count >= 0 ? (int) (*(code_file)->_ptr++ = (c)) : __flushbuf((c),(code_file)));
		    if (dflag) (--(defines_file)->_count >= 0 ? (int) (*(defines_file)->_ptr++ = (c)) : __flushbuf((c),(defines_file)));
		}
	    }
	    else
	    {
		do
		{
		    (--(code_file)->_count >= 0 ? (int) (*(code_file)->_ptr++ = (c)) : __flushbuf((c),(code_file)));
		    if (dflag) (--(defines_file)->_count >= 0 ? (int) (*(defines_file)->_ptr++ = (c)) : __flushbuf((c),(defines_file)));
		}
		while (c = *++s);
	    }
	    ++outline;
	    fprintf(code_file, " %d\n", symbol_value[i]);
	    if (dflag) fprintf(defines_file, " %d\n", symbol_value[i]);
	}
    }

    ++outline;
    fprintf(code_file, "#define YYERRCODE %d\n", symbol_value[1]);

    if (dflag && unionized)
    {
	fclose(union_file);
	union_file = fopen(union_file_name, "r");
	if (union_file == ((void *) 0)) open_error(union_file_name);
	while ((c = (--(union_file)->_count >= 0 ? (int) (*(union_file)->_ptr++) : __fillbuf(union_file))) != (-1))
	    (--(defines_file)->_count >= 0 ? (int) (*(defines_file)->_ptr++ = (c)) : __flushbuf((c),(defines_file)));
	fprintf(defines_file, " YYSTYPE;\nextern YYSTYPE %slval;\n",
		symbol_prefix);
    }
}


static void
output_stored_text(void)
{
    int c;
    FILE *in, *out;

    fclose(text_file);
    text_file = fopen(text_file_name, "r");
    if (text_file == ((void *) 0))
	open_error(text_file_name);
    in = text_file;
    if ((c = (--(in)->_count >= 0 ? (int) (*(in)->_ptr++) : __fillbuf(in))) == (-1))
	return;
    out = code_file;
    if (c ==  '\n')
	++outline;
    (--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = (c)) : __flushbuf((c),(out)));
    while ((c = (--(in)->_count >= 0 ? (int) (*(in)->_ptr++) : __fillbuf(in))) != (-1))
    {
	if (c == '\n')
	    ++outline;
	(--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = (c)) : __flushbuf((c),(out)));
    }
    if (!lflag)
	fprintf(out, line_format, ++outline + 1, code_file_name);
}


static void
output_debug(void)
{
    int i, j, k, max;
    char **symnam, *s;

    ++outline;
    fprintf(code_file, "#define YYFINAL %d\n", final_state);
    outline += 3;
    fprintf(code_file, "#ifndef YYDEBUG\n#define YYDEBUG %d\n#endif\n",
	    tflag);
    if (rflag)
	fprintf(output_file, "#ifndef YYDEBUG\n#define YYDEBUG %d\n#endif\n",
		tflag);

    max = 0;
    for (i = 2; i < ntokens; ++i)
	if (symbol_value[i] > max)
	    max = symbol_value[i];
    ++outline;
    fprintf(code_file, "#define YYMAXTOKEN %d\n", max);

    symnam = (char **) (malloc((unsigned)((max+1)*sizeof(char *))));
    if (symnam == 0) no_space();



    for (i = 0; i < max; ++i)
	symnam[i] = 0;
    for (i = ntokens - 1; i >= 2; --i)
	symnam[symbol_value[i]] = symbol_name[i];
    symnam[0] = "end-of-file";

    if (!rflag) ++outline;
    fprintf(output_file, "#if YYDEBUG\nchar *%sname[] = {", symbol_prefix);
    j = 80;
    for (i = 0; i <= max; ++i)
    {
	if (s = symnam[i])
	{
	    if (s[0] == '"')
	    {
		k = 7;
		while (*++s != '"')
		{
		    ++k;
		    if (*s == '\\')
		    {
			k += 2;
			if (*++s == '\\')
			    ++k;
		    }
		}
		j += k;
		if (j > 80)
		{
		    if (!rflag) ++outline;
		    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
		    j = k;
		}
		fprintf(output_file, "\"\\\"");
		s = symnam[i];
		while (*++s != '"')
		{
		    if (*s == '\\')
		    {
			fprintf(output_file, "\\\\");
			if (*++s == '\\')
			    fprintf(output_file, "\\\\");
			else
			    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = (*s)) : __flushbuf((*s),(output_file)));
		    }
		    else
			(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = (*s)) : __flushbuf((*s),(output_file)));
		}
		fprintf(output_file, "\\\"\",");
	    }
	    else if (s[0] == '\'')
	    {
		if (s[1] == '"')
		{
		    j += 7;
		    if (j > 80)
		    {
			if (!rflag) ++outline;
			(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
			j = 7;
		    }
		    fprintf(output_file, "\"'\\\"'\",");
		}
		else
		{
		    k = 5;
		    while (*++s != '\'')
		    {
			++k;
			if (*s == '\\')
			{
			    k += 2;
			    if (*++s == '\\')
				++k;
			}
		    }
		    j += k;
		    if (j > 80)
		    {
			if (!rflag) ++outline;
			(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
			j = k;
		    }
		    fprintf(output_file, "\"'");
		    s = symnam[i];
		    while (*++s != '\'')
		    {
			if (*s == '\\')
			{
			    fprintf(output_file, "\\\\");
			    if (*++s == '\\')
				fprintf(output_file, "\\\\");
			    else
				(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = (*s)) : __flushbuf((*s),(output_file)));
			}
			else
			    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = (*s)) : __flushbuf((*s),(output_file)));
		    }
		    fprintf(output_file, "'\",");
		}
	    }
	    else
	    {
		k = strlen(s) + 3;
		j += k;
		if (j > 80)
		{
		    if (!rflag) ++outline;
		    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
		    j = k;
		}
		(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('"')) : __flushbuf(('"'),(output_file)));
		do { (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = (*s)) : __flushbuf((*s),(output_file))); } while (*++s);
		fprintf(output_file, "\",");
	    }
	}
	else
	{
	    j += 2;
	    if (j > 80)
	    {
		if (!rflag) ++outline;
		(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(output_file)));
		j = 2;
	    }
	    fprintf(output_file, "0,");
	}
    }
    if (!rflag) outline += 2;
    fprintf(output_file, "\n};\n");
    (free((char*)(symnam)));

    if (!rflag) ++outline;
    fprintf(output_file, "char *%srule[] = {\n", symbol_prefix);
    for (i = 2; i < nrules; ++i)
    {
	fprintf(output_file, "\"%s :", symbol_name[rlhs[i]]);
	for (j = rrhs[i]; ritem[j] > 0; ++j)
	{
	    s = symbol_name[ritem[j]];
	    if (s[0] == '"')
	    {
		fprintf(output_file, " \\\"");
		while (*++s != '"')
		{
		    if (*s == '\\')
		    {
			if (s[1] == '\\')
			    fprintf(output_file, "\\\\\\\\");
			else
			    fprintf(output_file, "\\\\%c", s[1]);
			++s;
		    }
		    else
			(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = (*s)) : __flushbuf((*s),(output_file)));
		}
		fprintf(output_file, "\\\"");
	    }
	    else if (s[0] == '\'')
	    {
		if (s[1] == '"')
		    fprintf(output_file, " '\\\"'");
		else if (s[1] == '\\')
		{
		    if (s[2] == '\\')
			fprintf(output_file, " '\\\\\\\\");
		    else
			fprintf(output_file, " '\\\\%c", s[2]);
		    s += 2;
		    while (*++s != '\'')
			(--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = (*s)) : __flushbuf((*s),(output_file)));
		    (--(output_file)->_count >= 0 ? (int) (*(output_file)->_ptr++ = ('\'')) : __flushbuf(('\''),(output_file)));
		}
		else
		    fprintf(output_file, " '%c'", s[1]);
	    }
	    else
		fprintf(output_file, " %s", s);
	}
	if (!rflag) ++outline;
	fprintf(output_file, "\",\n");
    }

    if (!rflag) outline += 2;
    fprintf(output_file, "};\n#endif\n");
}


static void
output_stype(void)
{
    if (!unionized && ntags == 0)
    {
	outline += 3;
	fprintf(code_file, "#ifndef YYSTYPE\ntypedef int YYSTYPE;\n#endif\n");
    }
}


static void
output_trailing_text(void)
{
    int c, last;
    FILE *in, *out;

    if (line == 0)
	return;

    in = input_file;
    out = code_file;
    c = *cptr;
    if (c == '\n')
    {
	++lineno;
	if ((c = (--(in)->_count >= 0 ? (int) (*(in)->_ptr++) : __fillbuf(in))) == (-1))
	    return;
	if (!lflag)
	{
	    ++outline;
	    fprintf(out, line_format, lineno, input_file_name);
	}
	if (c == '\n')
	    ++outline;
	(--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = (c)) : __flushbuf((c),(out)));
	last = c;
    }
    else
    {
	if (!lflag)
	{
	    ++outline;
	    fprintf(out, line_format, lineno, input_file_name);
	}
	do { (--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = (c)) : __flushbuf((c),(out))); } while ((c = *++cptr) != '\n');
	++outline;
	(--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = ('\n')) : __flushbuf(('\n'),(out)));
	last = '\n';
    }

    while ((c = (--(in)->_count >= 0 ? (int) (*(in)->_ptr++) : __fillbuf(in))) != (-1))
    {
	if (c == '\n')
	    ++outline;
	(--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = (c)) : __flushbuf((c),(out)));
	last = c;
    }

    if (last != '\n')
    {
	++outline;
	(--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = ('\n')) : __flushbuf(('\n'),(out)));
    }
    if (!lflag)
	fprintf(out, line_format, ++outline + 1, code_file_name);
}


static void
output_semantic_actions(void)
{
    int c, last;
    FILE *out;

    fclose(action_file);
    action_file = fopen(action_file_name, "r");
    if (action_file == ((void *) 0))
	open_error(action_file_name);

    if ((c = (--(action_file)->_count >= 0 ? (int) (*(action_file)->_ptr++) : __fillbuf(action_file))) == (-1))
	return;

    out = code_file;
    last = c;
    if (c == '\n')
	++outline;
    (--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = (c)) : __flushbuf((c),(out)));
    while ((c = (--(action_file)->_count >= 0 ? (int) (*(action_file)->_ptr++) : __fillbuf(action_file))) != (-1))
    {
	if (c == '\n')
	    ++outline;
	(--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = (c)) : __flushbuf((c),(out)));
	last = c;
    }

    if (last != '\n')
    {
	++outline;
	(--(out)->_count >= 0 ? (int) (*(out)->_ptr++ = ('\n')) : __flushbuf(('\n'),(out)));
    }

    if (!lflag)
	fprintf(out, line_format, ++outline + 1, code_file_name);
}


static void
free_itemsets(void)
{
    core *cp, *next;

    (free((char*)(state_table)));
    for (cp = first_state; cp; cp = next)
    {
	next = cp->next;
	(free((char*)(cp)));
    }
}


static void
free_shifts(void)
{
    shifts *sp, *next;

    (free((char*)(shift_table)));
    for (sp = first_shift; sp; sp = next)
    {
	next = sp->next;
	(free((char*)(sp)));
    }
}


static void
free_reductions(void)
{
    reductions *rp, *next;

    (free((char*)(reduction_table)));
    for (rp = first_reduction; rp; rp = next)
    {
	next = rp->next;
	(free((char*)(rp)));
    }
}


void
output(void)
{
    free_itemsets();
    free_shifts();
    free_reductions();
    output_prefix();
    output_stored_text();
    output_defines();
    output_rule_data();
    output_yydefred();
    output_actions();
    free_parser();
    output_debug();
    output_stype();
    if (rflag) write_section(tables);
    write_section(header);
    output_trailing_text();
    write_section(body);
    output_semantic_actions();
    write_section(trailer);
}
