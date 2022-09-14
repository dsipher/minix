# 1 "y.tab.c"

static char yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93";
# 39 "/home/charles/xcc/jewel/include/sys/jewel.h"
typedef unsigned long   __caddr_t;
typedef unsigned        __daddr_t;
typedef unsigned        __dev_t;
typedef unsigned        __gid_t;
typedef unsigned        __ino_t;
typedef unsigned        __mode_t;
typedef unsigned        __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef long            __time_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 48 "/home/charles/xcc/jewel/include/stdio.h"
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
extern void perror(const char *s);
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


















extern char *tmpnam(char *);
# 44 "/home/charles/xcc/jewel/include/string.h"
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);



extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
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
# 53 "/home/charles/xcc/jewel/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void _exit(int);
extern void exit(int);

extern int abs(int);
extern long labs(long);
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
# 333 "flexdef.h"
struct hash_entry
    {
    struct hash_entry *prev, *next;
    char *name;
    char *str_val;
    int int_val;
    } ;

typedef struct hash_entry *hash_table[];





extern struct hash_entry *ndtbl[101];
extern struct hash_entry *sctbl[101];
extern struct hash_entry *ccltab[101];
# 383 "flexdef.h"
extern int printstats, syntaxerror, eofseen, ddebug, trace, spprdflt;
extern int interactive, caseins, useecs, fulltbl, usemecs;
extern int fullspd, gen_line_dirs, performance_report, backtrack_report, csize;
extern int yymore_used, reject, real_reject, continued_action;




extern int yymore_really_used, reject_really_used;


















extern int datapos, dataline, linenum;
extern FILE *skelfile, *yyin, *temp_action_file, *backtrack_file;
extern char *infilename;
extern char *action_file_name;
extern char **input_files;
extern int num_input_files;
extern char *program_name;










extern int onestate[500], onesym[500];
extern int onenext[500], onedef[500], onesp;
# 457 "flexdef.h"
extern int current_mns, num_rules, current_max_rules, lastnfa;
extern int *firstst, *lastst, *finalst, *transchar, *trans1, *trans2;
extern int *accptnum, *assoc_rule, *state_type, *rule_type, *rule_linenum;









extern int current_state_type;








extern int variable_trailing_context_rules;














extern int numtemps, numprots, protprev[50], protnext[50], prottbl[50];
extern int protcomst[50], firstprot, lastprot, protsave[2000];



















extern int numecs, nextecm[256 + 1], ecgroup[256 + 1], nummecs;






extern int tecfwd[256 + 1], tecbck[256 + 1];

extern int *xlation;
extern int num_xlations;













extern int lastsc, current_max_scs, *scset, *scbol, *scxclu, *sceof, *actvsc;
extern char **scname;
# 572 "flexdef.h"
extern int current_max_dfa_size, current_max_xpairs;
extern int current_max_template_xpairs, current_max_dfas;
extern int lastdfa, lasttemp, *nxt, *chk, *tnxt;
extern int *base, *def, *nultrans, NUL_ec, tblend, firstfree, **dss, *dfasiz;
extern union dfaacc_union
    {
    int *dfaacc_set;
    int dfaacc_state;
    } *dfaacc;
extern int *accsiz, *dhash, numas;
extern int numsnpairs, jambase, jamstate;
extern int end_of_buffer_state;













extern int lastccl, current_maxccls, *cclmap, *ccllen, *cclng, cclreuse;
extern int current_max_ccl_tbl_size;
extern unsigned char *ccltbl;
# 624 "flexdef.h"
extern char *starttime, *endtime, nmstr[1024];
extern int sectnum, nummt, hshcol, dfaeql, numeps, eps2, num_reallocs;
extern int tmpuses, totnst, peakpairs, numuniq, numdup, hshsave;
extern int num_backtracking, bol_needed;

void *allocate_array(), *reallocate_array();
# 667 "flexdef.h"
extern int yylval;







extern void ccladd (int, int);
extern int cclinit ();
extern void cclnegate (int);


extern void list_character_set (FILE*, int[]);





extern void increase_max_dfas ();

extern void ntod ();





extern void ccl2ecl ();


extern int cre8ecs (int[], int[], int);


extern int ecs_from_xlation (int[]);


extern void mkeccl (unsigned char[], int, int[], int[], int, int);


extern void mkechar (int, int[], int[]);




extern void make_tables ();




extern void flexend (int);





extern void action_out ();


extern int all_lower (register unsigned char *);


extern int all_upper (register unsigned char *);


extern void bubble (int [], int);


extern void cshell (unsigned char [], int, int);

extern void dataend ();


extern void flexerror (char[]);


extern void flexfatal (char[]);


extern void lerrif (char[], int);


extern void lerrsf (char[], char[]);


extern void line_directive_out (FILE*);


extern void mk2data (int);

extern void mkdata (int);


extern int myctoi (unsigned char []);


extern void skelout ();


extern void transition_struct_out (int, int);





extern void add_accept (int, int);


extern int copysingl (int, int);


extern void dumpnfa (int);


extern void finish_rule (int, int, int, int);


extern int link_machines (int, int);




extern void mark_beginning_as_normal (register int);


extern int mkbranch (int, int);

extern int mkclos (int);
extern int mkopt (int);


extern int mkor (int, int);


extern int mkposcl (int);

extern int mkrep (int, int, int);


extern int mkstate (int);

extern void new_rule ();





extern void format_pinpoint_message (char[], char[]);


extern void pinpoint_message (char[]);

extern void synerr (char []);
extern int yyparse ();




extern int flexscan ();


extern void set_input_file (char*);

extern int yywrap ();





extern void cclinstal (unsigned char [], int);


extern int ccllookup (unsigned char []);

extern void ndinstal (char[], unsigned char[]);
extern void scinstal (char[], int);


extern int sclookup (char[]);





extern void bldtbl (int[], int, int, int, int);

extern void cmptmps ();
extern void inittbl ();
extern void mkdeftbl ();



extern void mk1tbl (int, int, int, int);


extern void place_state (int*, int, int);


extern void stack1 (int, int, int, int);




extern int yylex ();




extern int read (int, char*, int);
extern int unlink (char*);
extern int write (int, char*, int);
# 37 "parse.y"
int pat, scnum, eps, headcnt, trailcnt, anyccl, lastchar, i, actvp, rulelen;
int trlcontxt, xcluflg, cclsorted, varlength, variable_trail_rule;
unsigned char clower();

static int madeany = 0;
int previous_continued_action;
# 33 "y.tab.c"
short yylhs[] = {                                        -1,
    0,    1,    2,    2,    2,    3,    6,    6,    7,    7,
    7,    4,    4,    5,    8,    8,    8,    8,    8,    8,
    8,    9,   11,   11,   11,   10,   10,   10,   10,   13,
   13,   12,   14,   14,   15,   15,   15,   15,   15,   15,
   15,   15,   15,   15,   15,   15,   16,   16,   18,   18,
   18,   17,   17,
};
short yylen[] = {                                         2,
    5,    0,    5,    0,    2,    1,    1,    1,    3,    1,
    1,    4,    0,    0,    3,    2,    2,    1,    2,    1,
    1,    3,    3,    1,    1,    2,    3,    2,    1,    3,
    1,    2,    2,    1,    2,    2,    2,    6,    5,    4,
    1,    1,    1,    3,    3,    1,    3,    4,    4,    2,
    0,    2,    0,
};
short yydefred[] = {                                      2,
    0,    0,    0,    0,    5,    6,    7,    8,   13,    0,
   14,    0,    0,   11,   10,    0,   21,   46,   43,   20,
    0,    0,   41,   53,    0,    0,    0,    0,   18,    0,
    0,    0,    0,   42,    0,    3,   17,   25,   24,    0,
    0,    0,   51,    0,   12,   19,    0,   16,    0,   28,
    0,   32,    0,   35,   36,   37,    0,    9,   22,    0,
   52,   44,   45,    0,    0,   47,   15,   27,    0,    0,
   23,   48,    0,    0,   40,   49,    0,   39,   38,
};
short yydgoto[] = {                                       1,
    2,    4,    9,   11,   13,   10,   16,   27,   28,   29,
   40,   30,   31,   32,   33,   34,   41,   44,
};
short yysindex[] = {                                      0,
    0, -231,   28, -186,    0,    0,    0,    0,    0, -221,
    0, -212,  -32,    0,    0,   -9,    0,    0,    0,    0,
  -28, -203,    0,    0,  -28,  -39,   47,  -30,    0,  -28,
  -15,  -28,    4,    0, -205,    0,    0,    0,    0,    8,
  -29,  -19,    0,  -86,    0,    0,  -28,    0,  -16,    0,
  -28,    0,    4,    0,    0,    0, -193,    0,    0, -194,
    0,    0,    0,  -84,   34,    0,    0,    0,  -28,  -21,
    0,    0, -177, -110,    0,    0,  -43,    0,    0,
};
short yyrindex[] = {                                      0,
    0, -183,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   83,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  -82,    0,    0,    0,    0,
   75,    7,  -10,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   76,    0,
    0,    0,   -7,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  -80,    0,    0,    0,    9,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,
};
short yygindex[] = {                                      0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   21,
    0,    0,   41,   36,    3,    0,    0,   45,
};

short yytable[] = {                                      34,
   36,   24,   33,   24,   62,   24,   66,   25,   72,   25,
   51,   25,   50,   23,   78,   23,   31,   23,   30,   68,
   50,   63,   74,   34,    3,   34,   33,   22,   33,   34,
   34,   52,   33,   33,   53,   34,   34,    5,   33,   33,
   12,   37,   31,   14,   30,   54,   55,   31,   48,   30,
   15,   60,   38,   31,   43,   30,   45,   58,   26,   39,
   26,   21,   26,   47,   70,   42,   56,   67,   71,   59,
   49,   53,    6,    7,    8,    4,    4,    4,   73,   76,
   34,   79,    1,   33,   29,   26,   69,   64,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   75,   51,    0,    0,   51,   51,    0,
    0,    0,    0,   34,    0,    0,   33,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   57,    0,    0,    0,
   31,    0,   30,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   77,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   65,    0,   65,    0,   51,    0,   50,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   17,   18,    0,   18,   61,   18,    0,
    0,   19,   20,   19,   46,   19,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   34,    0,    0,   33,
    0,    0,   35,   34,    0,    0,   33,
};
short yycheck[] = {                                      10,
   10,   34,   10,   34,   34,   34,   93,   40,   93,   40,
   93,   40,   93,   46,  125,   46,   10,   46,   10,   36,
   36,   41,   44,   34,  256,   36,   34,   60,   36,   40,
   41,   47,   40,   41,   32,   46,   47,   10,   46,   47,
  262,   21,   36,  256,   36,   42,   43,   41,   28,   41,
  263,   44,  256,   47,   94,   47,   10,  263,   91,  263,
   91,   94,   91,   94,  258,   25,   63,   47,  263,   62,
   30,   69,  259,  260,  261,  259,  260,  261,   45,  257,
   91,  125,    0,   91,   10,   10,   51,   43,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  125,  124,   -1,   -1,  124,  124,   -1,
   -1,   -1,   -1,  124,   -1,   -1,  124,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  123,   -1,   -1,   -1,
  124,   -1,  124,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  258,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  257,   -1,  257,   -1,  257,   -1,  257,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  256,  257,   -1,  257,  257,  257,   -1,
   -1,  264,  265,  264,  265,  264,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  257,   -1,   -1,  257,
   -1,   -1,  262,  264,   -1,   -1,  264,
};
# 219 "y.tab.c"
typedef int YYSTYPE;












int yydebug;
int yynerrs;
int yyerrflag;
int yychar;
short *yyssp;
YYSTYPE *yyvsp;
YYSTYPE yyval;
YYSTYPE yylval;
short yyss[500];
YYSTYPE yyvs[500];
# 631 "parse.y"
void build_eof_action()

    {
    register int i;

    for ( i = 1; i <= actvp; ++i )
	{
	if ( sceof[actvsc[i]] )
	    format_pinpoint_message(
		"multiple <<EOF>> rules for start condition %s",
		    scname[actvsc[i]] );

	else
	    {
	    sceof[actvsc[i]] = 1;
	    fprintf( temp_action_file, "case YY_STATE_EOF(%s):\n",
		     scname[actvsc[i]] );
	    }
	}

    line_directive_out( temp_action_file );
    }




void synerr( str )
char str[];

    {
    syntaxerror = 1;
    pinpoint_message( str );
    }






void format_pinpoint_message( msg, arg )
char msg[], arg[];

    {
    char errmsg[1024];

    (void) sprintf( errmsg, msg, arg );
    pinpoint_message( errmsg );
    }




void pinpoint_message( str )
char str[];

    {
    fprintf( (&__stderr), "\"%s\", line %d: %s\n", infilename, linenum, str );
    }






void yyerror( msg )
char msg[];

    {
    }
# 324 "y.tab.c"
int
yyparse()
{
    register int yym, yyn, yystate;












    yynerrs = 0;
    yyerrflag = 0;
    yychar = (-1);

    yyssp = yyss;
    yyvsp = yyvs;
    *yyssp = yystate = 0;

yyloop:
    if (yyn = yydefred[yystate]) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = yylex()) < 0) yychar = 0;










    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= 257 && yycheck[yyn] == yychar)
    {





        if (yyssp >= yyss + 500 - 1)
        {
            goto yyoverflow;
        }
        *++yyssp = yystate = yytable[yyn];
        *++yyvsp = yylval;
        yychar = (-1);
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= 257 && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;



yynewerror:
    yyerror("syntax error");



yyerrlab:
    ++yynerrs;
yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yyssp]) && (yyn += 256) >= 0 &&
                    yyn <= 257 && yycheck[yyn] == 256)
            {





                if (yyssp >= yyss + 500 - 1)
                {
                    goto yyoverflow;
                }
                *++yyssp = yystate = yytable[yyn];
                *++yyvsp = yylval;
                goto yyloop;
            }
            else
            {





                if (yyssp <= yyss) goto yyabort;
                --yyssp;
                --yyvsp;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;










        yychar = (-1);
        goto yyloop;
    }
yyreduce:





    yym = yylen[yyn];
    yyval = yyvsp[1-yym];
    switch (yyn)
    {
case 1:
# 48 "parse.y"
{
			int def_rule;

			pat = cclinit();
			cclnegate( pat );

			def_rule = mkstate( -pat );

			finish_rule( def_rule, 0, 0, 0 );

			for ( i = 1; i <= lastsc; ++i )
			    scset[i] = mkbranch( scset[i], def_rule );

			if ( spprdflt )
			    fputs( "YY_FATAL_ERROR( \"flex scanner jammed\" )",
				   temp_action_file );
			else
			    fputs( "ECHO", temp_action_file );

			fputs( ";\n\tYY_BREAK\n", temp_action_file );
			}
break;
case 2:
# 72 "parse.y"
{



			scinstal( "INITIAL", 0 );
			}
break;
case 5:
# 83 "parse.y"
{ synerr( "unknown error processing section 1" ); }
break;
case 7:
# 90 "parse.y"
{





			xcluflg = 0;
			}
break;
case 8:
# 100 "parse.y"
{ xcluflg = 1; }
break;
case 9:
# 104 "parse.y"
{ scinstal( nmstr, xcluflg ); }
break;
case 10:
# 107 "parse.y"
{ scinstal( nmstr, xcluflg ); }
break;
case 11:
# 110 "parse.y"
{ synerr( "bad start condition list" ); }
break;
case 14:
# 118 "parse.y"
{

			trlcontxt = variable_trail_rule = varlength = 0;
			trailcnt = headcnt = rulelen = 0;
			current_state_type = 0x1;
			previous_continued_action = continued_action;
			new_rule();
			}
break;
case 15:
# 129 "parse.y"
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );

			for ( i = 1; i <= actvp; ++i )
			    scbol[actvsc[i]] =
				mkbranch( scbol[actvsc[i]], pat );

			if ( ! bol_needed )
			    {
			    bol_needed = 1;

			    if ( performance_report )
				pinpoint_message(
			    "'^' operator results in sub-optimal performance" );
			    }
			}
break;
case 16:
# 149 "parse.y"
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );

			for ( i = 1; i <= actvp; ++i )
			    scset[actvsc[i]] =
				mkbranch( scset[actvsc[i]], pat );
			}
break;
case 17:
# 160 "parse.y"
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );





			for ( i = 1; i <= lastsc; ++i )
			    if ( ! scxclu[i] )
				scbol[i] = mkbranch( scbol[i], pat );

			if ( ! bol_needed )
			    {
			    bol_needed = 1;

			    if ( performance_report )
				pinpoint_message(
			    "'^' operator results in sub-optimal performance" );
			    }
			}
break;
case 18:
# 184 "parse.y"
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );

			for ( i = 1; i <= lastsc; ++i )
			    if ( ! scxclu[i] )
				scset[i] = mkbranch( scset[i], pat );
			}
break;
case 19:
# 195 "parse.y"
{ build_eof_action(); }
break;
case 20:
# 198 "parse.y"
{



			actvp = 0;

			for ( i = 1; i <= lastsc; ++i )
			    if ( ! sceof[i] )
				actvsc[++actvp] = i;

			if ( actvp == 0 )
			    pinpoint_message(
		"warning - all start conditions already have <<EOF>> rules" );

			else
			    build_eof_action();
			}
break;
case 21:
# 217 "parse.y"
{ synerr( "unrecognized rule" ); }
break;
case 23:
# 224 "parse.y"
{
			if ( (scnum = sclookup( nmstr )) == 0 )
			    format_pinpoint_message(
				"undeclared start condition %s", nmstr );

			else
			    actvsc[++actvp] = scnum;
			}
break;
case 24:
# 234 "parse.y"
{
			if ( (scnum = sclookup( nmstr )) == 0 )
			    format_pinpoint_message(
				"undeclared start condition %s", nmstr );
			else
			    actvsc[actvp = 1] = scnum;
			}
break;
case 25:
# 243 "parse.y"
{ synerr( "bad start condition list" ); }
break;
case 26:
# 247 "parse.y"
{
			if ( transchar[lastst[yyvsp[0]]] != (256 + 1) )




			    yyvsp[0] = link_machines( yyvsp[0], mkstate( (256 + 1) ) );

			mark_beginning_as_normal( yyvsp[0] );
			current_state_type = 0x1;

			if ( previous_continued_action )
			    {








			    if ( ! varlength || headcnt != 0 )
				{
				fprintf( (&__stderr),
    "%s: warning - trailing context rule at line %d made variable because\n",
					 program_name, linenum );
				fprintf( (&__stderr),
					 "      of preceding '|' action\n" );
				}


			    varlength = 1;
			    headcnt = 0;
			    }

			if ( varlength && headcnt == 0 )
			    {









			    add_accept( yyvsp[-1], num_rules | 0x4000 );
			    variable_trail_rule = 1;
			    }

			else
			    trailcnt = rulelen;

			yyval = link_machines( yyvsp[-1], yyvsp[0] );
			}
break;
case 27:
# 304 "parse.y"
{ synerr( "trailing context used twice" ); }
break;
case 28:
# 307 "parse.y"
{
			if ( trlcontxt )
			    {
			    synerr( "trailing context used twice" );
			    yyval = mkstate( (256 + 1) );
			    }

			else if ( previous_continued_action )
			    {



			    if ( ! varlength || headcnt != 0 )
				{
				fprintf( (&__stderr),
    "%s: warning - trailing context rule at line %d made variable because\n",
					 program_name, linenum );
				fprintf( (&__stderr),
					 "      of preceding '|' action\n" );
				}


			    varlength = 1;
			    headcnt = 0;
			    }

			trlcontxt = 1;

			if ( ! varlength )
			    headcnt = rulelen;

			++rulelen;
			trailcnt = 1;

			eps = mkstate( (256 + 1) );
			yyval = link_machines( yyvsp[-1],
				 link_machines( eps, mkstate( '\n' ) ) );
			}
break;
case 29:
# 347 "parse.y"
{
		        yyval = yyvsp[0];

			if ( trlcontxt )
			    {
			    if ( varlength && headcnt == 0 )

				variable_trail_rule = 1;
			    else
				trailcnt = rulelen;
			    }
		        }
break;
case 30:
# 363 "parse.y"
{
			varlength = 1;
			yyval = mkor( yyvsp[-2], yyvsp[0] );
			}
break;
case 31:
# 369 "parse.y"
{ yyval = yyvsp[0]; }
break;
case 32:
# 374 "parse.y"
{





			if ( trlcontxt )
			    synerr( "trailing context used twice" );
			else
			    trlcontxt = 1;

			if ( varlength )

			    varlength = 0;
			else
			    headcnt = rulelen;

			rulelen = 0;

			current_state_type = 0x2;
			yyval = yyvsp[-1];
			}
break;
case 33:
# 399 "parse.y"
{



			yyval = link_machines( yyvsp[-1], yyvsp[0] );
			}
break;
case 34:
# 407 "parse.y"
{ yyval = yyvsp[0]; }
break;
case 35:
# 411 "parse.y"
{
			varlength = 1;

			yyval = mkclos( yyvsp[-1] );
			}
break;
case 36:
# 418 "parse.y"
{
			varlength = 1;

			yyval = mkposcl( yyvsp[-1] );
			}
break;
case 37:
# 425 "parse.y"
{
			varlength = 1;

			yyval = mkopt( yyvsp[-1] );
			}
break;
case 38:
# 432 "parse.y"
{
			varlength = 1;

			if ( yyvsp[-3] > yyvsp[-1] || yyvsp[-3] < 0 )
			    {
			    synerr( "bad iteration values" );
			    yyval = yyvsp[-5];
			    }
			else
			    {
			    if ( yyvsp[-3] == 0 )
				yyval = mkopt( mkrep( yyvsp[-5], yyvsp[-3], yyvsp[-1] ) );
			    else
				yyval = mkrep( yyvsp[-5], yyvsp[-3], yyvsp[-1] );
			    }
			}
break;
case 39:
# 450 "parse.y"
{
			varlength = 1;

			if ( yyvsp[-2] <= 0 )
			    {
			    synerr( "iteration value must be positive" );
			    yyval = yyvsp[-4];
			    }

			else
			    yyval = mkrep( yyvsp[-4], yyvsp[-2], -1 );
			}
break;
case 40:
# 464 "parse.y"
{




			varlength = 1;

			if ( yyvsp[-1] <= 0 )
			    {
			    synerr( "iteration value must be positive" );
			    yyval = yyvsp[-3];
			    }

			else
			    yyval = link_machines( yyvsp[-3], copysingl( yyvsp[-3], yyvsp[-1] - 1 ) );
			}
break;
case 41:
# 482 "parse.y"
{
			if ( ! madeany )
			    {

			    anyccl = cclinit();
			    ccladd( anyccl, '\n' );
			    cclnegate( anyccl );

			    if ( useecs )
				mkeccl( ccltbl + cclmap[anyccl],
					ccllen[anyccl], nextecm,
					ecgroup, csize, csize );

			    madeany = 1;
			    }

			++rulelen;

			yyval = mkstate( -anyccl );
			}
break;
case 42:
# 504 "parse.y"
{
			if ( ! cclsorted )



			    cshell( ccltbl + cclmap[yyvsp[0]], ccllen[yyvsp[0]], 1 );

			if ( useecs )
			    mkeccl( ccltbl + cclmap[yyvsp[0]], ccllen[yyvsp[0]],
				    nextecm, ecgroup, csize, csize );

			++rulelen;

			yyval = mkstate( -yyvsp[0] );
			}
break;
case 43:
# 521 "parse.y"
{
			++rulelen;

			yyval = mkstate( -yyvsp[0] );
			}
break;
case 44:
# 528 "parse.y"
{ yyval = yyvsp[-1]; }
break;
case 45:
# 531 "parse.y"
{ yyval = yyvsp[-1]; }
break;
case 46:
# 534 "parse.y"
{
			++rulelen;

			if ( caseins && yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
			    yyvsp[0] = clower( yyvsp[0] );

			yyval = mkstate( yyvsp[0] );
			}
break;
case 47:
# 545 "parse.y"
{ yyval = yyvsp[-1]; }
break;
case 48:
# 548 "parse.y"
{







			cclnegate( yyvsp[-1] );
			yyval = yyvsp[-1];
			}
break;
case 49:
# 562 "parse.y"
{
			if ( yyvsp[-2] > yyvsp[0] )
			    synerr( "negative range in character class" );

			else
			    {
			    if ( caseins )
				{
				if ( yyvsp[-2] >= 'A' && yyvsp[-2] <= 'Z' )
				    yyvsp[-2] = clower( yyvsp[-2] );
				if ( yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
				    yyvsp[0] = clower( yyvsp[0] );
				}

			    for ( i = yyvsp[-2]; i <= yyvsp[0]; ++i )
			        ccladd( yyvsp[-3], i );




			    cclsorted = cclsorted && (yyvsp[-2] > lastchar);
			    lastchar = yyvsp[0];
			    }

			yyval = yyvsp[-3];
			}
break;
case 50:
# 590 "parse.y"
{
			if ( caseins )
			    if ( yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
				yyvsp[0] = clower( yyvsp[0] );

			ccladd( yyvsp[-1], yyvsp[0] );
			cclsorted = cclsorted && (yyvsp[0] > lastchar);
			lastchar = yyvsp[0];
			yyval = yyvsp[-1];
			}
break;
case 51:
# 602 "parse.y"
{
			cclsorted = 1;
			lastchar = 0;
			yyval = cclinit();
			}
break;
case 52:
# 610 "parse.y"
{
			if ( caseins )
			    if ( yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
				yyvsp[0] = clower( yyvsp[0] );

			++rulelen;

			yyval = link_machines( yyvsp[-1], mkstate( yyvsp[0] ) );
			}
break;
case 53:
# 621 "parse.y"
{ yyval = mkstate( (256 + 1) ); }
break;
# 1055 "y.tab.c"
    }
    yyssp -= yym;
    yystate = *yyssp;
    yyvsp -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {





        yystate = 1;
        *++yyssp = 1;
        *++yyvsp = yyval;
        if (yychar < 0)
        {
            if ((yychar = yylex()) < 0) yychar = 0;










        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= 257 && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];





    if (yyssp >= yyss + 500 - 1)
    {
        goto yyoverflow;
    }
    *++yyssp = yystate;
    *++yyvsp = yyval;
    goto yyloop;
yyoverflow:
    yyerror("yacc stack overflow");
yyabort:
    return (1);
yyaccept:
    return (0);
}
