# 1 "gen.c"

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
# 36 "gen.c"
void gen_next_state (int);
void genecs ();
void indent_put2s (char [], char []);
void indent_puts (char []);


static int indent_level = 0;








static char C_short_decl[] = "static const short int %s[%d] =\n    {   0,\n";
static char C_long_decl[] = "static const long int %s[%d] =\n    {   0,\n";
static char C_state_decl[] =
	"static const yy_state_type %s[%d] =\n    {   0,\n";




void do_indent()

    {
    register int i = indent_level * 4;

    while ( i >= 8 )
	{
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\t')) : __flushbuf(('\t'),((&__stdout))));
	i -= 8;
	}

    while ( i > 0 )
	{
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (' ')) : __flushbuf((' '),((&__stdout))));
	--i;
	}
    }




void gen_backtracking()

    {
    if ( reject || num_backtracking == 0 )
	return;

    if ( fullspd )
	indent_puts( "if ( yy_current_state[-1].yy_nxt )" );
    else
	indent_puts( "if ( yy_accept[yy_current_state] )" );

    (++indent_level);
    indent_puts( "{" );
    indent_puts( "yy_last_accepting_state = yy_current_state;" );
    indent_puts( "yy_last_accepting_cpos = yy_cp;" );
    indent_puts( "}" );
    (--indent_level);
    }




void gen_bt_action()

    {
    if ( reject || num_backtracking == 0 )
	return;

    indent_level = 3;

    indent_puts( "case 0: /* must backtrack */" );
    indent_puts( "/* undo the effects of YY_DO_BEFORE_ACTION */" );
    indent_puts( "*yy_cp = yy_hold_char;" );

    if ( fullspd || fulltbl )
	indent_puts( "yy_cp = yy_last_accepting_cpos + 1;" );
    else



	indent_puts( "yy_cp = yy_last_accepting_cpos;" );

    indent_puts( "yy_current_state = yy_last_accepting_state;" );
    indent_puts( "goto yy_find_action;" );
    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));

    indent_level = 0;
    }








void genctbl()

    {
    register int i;
    int end_of_buffer_action = num_rules + 1;


    printf( "static const struct yy_trans_info yy_transition[%d] =\n",
	    tblend + numecs + 1 );
    printf( "    {\n" );



















    base[lastdfa + 1] = tblend + 2;
    nxt[tblend + 1] = end_of_buffer_action;
    chk[tblend + 1] = numecs + 1;
    chk[tblend + 2] = 1;
    nxt[tblend + 2] = 0;


    for ( i = 0; i <= lastdfa; ++i )
	{
	register int anum = dfaacc[i].dfaacc_state;

	chk[base[i]] = -1;
	chk[base[i] - 1] = -2;
	nxt[base[i] - 1] = anum;
	}

    for ( i = 0; i <= tblend; ++i )
	{
	if ( chk[i] == -1 )
	    transition_struct_out( 0, base[lastdfa + 1] - i );

	else if ( chk[i] == -2 )
	    transition_struct_out( 0, nxt[i] );

	else if ( chk[i] > numecs || chk[i] == 0 )
	    transition_struct_out( 0, 0 );

	else
	    transition_struct_out( chk[i], base[nxt[i]] - (i - chk[i]) );
	}



    transition_struct_out( chk[tblend + 1], nxt[tblend + 1] );
    transition_struct_out( chk[tblend + 2], nxt[tblend + 2] );

    printf( "    };\n" );
    printf( "\n" );


    printf( "static const struct yy_trans_info *yy_start_state_list[%d] =\n",
	    lastsc * 2 + 1 );
    printf( "    {\n" );

    for ( i = 0; i <= lastsc * 2; ++i )
	printf( "    &yy_transition[%d],\n", base[i] );

    dataend();

    if ( useecs )
	genecs();
    }




void genecs()

    {
    register int i, j;
    static char C_char_decl[] = "static const %s %s[%d] =\n    {   0,\n";
    int numrows;
    unsigned char clower();

    if ( numecs < csize )
	printf( C_char_decl, "YY_CHAR", "yy_ec", csize );
    else
	printf( C_char_decl, "short", "yy_ec", csize );

    for ( i = 1; i < csize; ++i )
	{
	if ( caseins && (i >= 'A') && (i <= 'Z') )
	    ecgroup[i] = ecgroup[clower( i )];

	ecgroup[i] = abs( ecgroup[i] );
	mkdata( ecgroup[i] );
	}

    dataend();

    if ( trace )
	{
	char *readable_form();

	fputs( "\n\nEquivalence Classes:\n\n", (&__stderr) );

	numrows = csize / 8;

	for ( j = 0; j < numrows; ++j )
	    {
	    for ( i = j; i < csize; i = i + numrows )
		{
		fprintf( (&__stderr), "%4s = %-2d", readable_form( i ), ecgroup[i] );

		(--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = (' ')) : __flushbuf((' '),((&__stderr))));
		}

	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
	    }
	}
    }




void gen_find_action()

    {
    if ( fullspd )
	indent_puts( "yy_act = yy_current_state[-1].yy_nxt;" );

    else if ( fulltbl )
	indent_puts( "yy_act = yy_accept[yy_current_state];" );

    else if ( reject )
	{
	indent_puts( "yy_current_state = *--yy_state_ptr;" );
	indent_puts( "yy_lp = yy_accept[yy_current_state];" );

	puts( "find_rule: /* we branch to this label when backtracking */" );

	indent_puts( "for ( ; ; ) /* until we find what rule we matched */" );

	(++indent_level);

	indent_puts( "{" );

	indent_puts( "if ( yy_lp && yy_lp < yy_accept[yy_current_state + 1] )" );
	(++indent_level);
	indent_puts( "{" );
	indent_puts( "yy_act = yy_acclist[yy_lp];" );

	if ( variable_trailing_context_rules )
	    {
	    indent_puts( "if ( yy_act & YY_TRAILING_HEAD_MASK ||" );
	    indent_puts( "     yy_looking_for_trail_begin )" );
	    (++indent_level);
	    indent_puts( "{" );

	    indent_puts( "if ( yy_act == yy_looking_for_trail_begin )" );
	    (++indent_level);
	    indent_puts( "{" );
	    indent_puts( "yy_looking_for_trail_begin = 0;" );
	    indent_puts( "yy_act &= ~YY_TRAILING_HEAD_MASK;" );
	    indent_puts( "break;" );
	    indent_puts( "}" );
	    (--indent_level);

	    indent_puts( "}" );
	    (--indent_level);

	    indent_puts( "else if ( yy_act & YY_TRAILING_MASK )" );
	    (++indent_level);
	    indent_puts( "{" );
	    indent_puts(
		"yy_looking_for_trail_begin = yy_act & ~YY_TRAILING_MASK;" );
	    indent_puts(
		"yy_looking_for_trail_begin |= YY_TRAILING_HEAD_MASK;" );

	    if ( real_reject )
		{

		indent_puts( "yy_full_match = yy_cp;" );
		indent_puts( "yy_full_state = yy_state_ptr;" );
		indent_puts( "yy_full_lp = yy_lp;" );
		}

	    indent_puts( "}" );
	    (--indent_level);

	    indent_puts( "else" );
	    (++indent_level);
	    indent_puts( "{" );
	    indent_puts( "yy_full_match = yy_cp;" );
	    indent_puts( "yy_full_state = yy_state_ptr;" );
	    indent_puts( "yy_full_lp = yy_lp;" );
	    indent_puts( "break;" );
	    indent_puts( "}" );
	    (--indent_level);

	    indent_puts( "++yy_lp;" );
	    indent_puts( "goto find_rule;" );
	    }

	else
	    {



	    (++indent_level);
	    indent_puts( "{" );
	    indent_puts( "yy_full_match = yy_cp;" );
	    indent_puts( "break;" );
	    indent_puts( "}" );
	    (--indent_level);
	    }

	indent_puts( "}" );
	(--indent_level);

	indent_puts( "--yy_cp;" );





	indent_puts( "yy_current_state = *--yy_state_ptr;" );
	indent_puts( "yy_lp = yy_accept[yy_current_state];" );

	indent_puts( "}" );

	(--indent_level);
	}

    else

	indent_puts( "yy_act = yy_accept[yy_current_state];" );
    }








void genftbl()

    {
    register int i;
    int end_of_buffer_action = num_rules + 1;

    printf( C_short_decl, "yy_accept", lastdfa + 1 );


    dfaacc[end_of_buffer_state].dfaacc_state = end_of_buffer_action;

    for ( i = 1; i <= lastdfa; ++i )
	{
	register int anum = dfaacc[i].dfaacc_state;

	mkdata( anum );

	if ( trace && anum )
	    fprintf( (&__stderr), "state # %d accepts: [%d]\n", i, anum );
	}

    dataend();

    if ( useecs )
	genecs();




    }




void gen_next_compressed_state( char_map )
char *char_map;

    {
    indent_put2s( "register YY_CHAR yy_c = %s;", char_map );





    gen_backtracking();

    indent_puts(
    "while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )" );
    (++indent_level);
    indent_puts( "{" );
    indent_puts( "yy_current_state = yy_def[yy_current_state];" );

    if ( usemecs )
	{







	do_indent();

	printf( "if ( yy_current_state >= %d )\n", lastdfa + 2 );

	(++indent_level);
	indent_puts( "yy_c = yy_meta[yy_c];" );
	(--indent_level);
	}

    indent_puts( "}" );
    (--indent_level);

    indent_puts(
	"yy_current_state = yy_nxt[yy_base[yy_current_state] + yy_c];" );
    }




void gen_next_match()

    {



    char *char_map = useecs ? "yy_ec[*yy_cp]" : "*yy_cp";
    char *char_map_2 = useecs ? "yy_ec[*++yy_cp]" : "*++yy_cp";

    if ( fulltbl )
	{
	indent_put2s(
	    "while ( (yy_current_state = yy_nxt[yy_current_state][%s]) > 0 )",
		char_map );

	(++indent_level);

	if ( num_backtracking > 0 )
	    {
	    indent_puts( "{" );
	    gen_backtracking();
	    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
	    }

	indent_puts( "++yy_cp;" );

	if ( num_backtracking > 0 )
	    indent_puts( "}" );

	(--indent_level);

	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
	indent_puts( "yy_current_state = -yy_current_state;" );
	}

    else if ( fullspd )
	{
	indent_puts( "{" );
	indent_puts( "register const struct yy_trans_info *yy_trans_info;\n" );
	indent_puts( "register YY_CHAR yy_c;\n" );
	indent_put2s( "for ( yy_c = %s;", char_map );
	indent_puts(
	"      (yy_trans_info = &yy_current_state[yy_c])->yy_verify == yy_c;" );
	indent_put2s( "      yy_c = %s )", char_map_2 );

	(++indent_level);

	if ( num_backtracking > 0 )
	    indent_puts( "{" );

	indent_puts( "yy_current_state += yy_trans_info->yy_nxt;" );

	if ( num_backtracking > 0 )
	    {
	    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
	    gen_backtracking();
	    indent_puts( "}" );
	    }

	(--indent_level);
	indent_puts( "}" );
	}

    else
	{
	indent_puts( "do" );

	(++indent_level);
	indent_puts( "{" );

	gen_next_state( 0 );

	indent_puts( "++yy_cp;" );

	indent_puts( "}" );
	(--indent_level);

	do_indent();

	if ( interactive )
	    printf( "while ( yy_base[yy_current_state] != %d );\n", jambase );
	else
	    printf( "while ( yy_current_state != %d );\n", jamstate );

	if ( ! reject && ! interactive )
	    {

	    indent_puts( "yy_cp = yy_last_accepting_cpos;" );
	    indent_puts( "yy_current_state = yy_last_accepting_state;" );
	    }
	}
    }




void gen_next_state( worry_about_NULs )
int worry_about_NULs;

    {
    char char_map[256];

    if ( worry_about_NULs && ! nultrans )
	{
	if ( useecs )
	    (void) sprintf( char_map, "(*yy_cp ? yy_ec[*yy_cp] : %d)", NUL_ec );
	else
	    (void) sprintf( char_map, "(*yy_cp ? *yy_cp : %d)", NUL_ec );
	}

    else
	(void) strcpy( char_map, useecs ? "yy_ec[*yy_cp]" : "*yy_cp" );

    if ( worry_about_NULs && nultrans )
	{
	if ( ! fulltbl && ! fullspd )

	    gen_backtracking();

	indent_puts( "if ( *yy_cp )" );
	(++indent_level);
	indent_puts( "{" );
	}

    if ( fulltbl )
	indent_put2s( "yy_current_state = yy_nxt[yy_current_state][%s];",
		char_map );

    else if ( fullspd )
	indent_put2s( "yy_current_state += yy_current_state[%s].yy_nxt;",
		    char_map );

    else
	gen_next_compressed_state( char_map );

    if ( worry_about_NULs && nultrans )
	{
	indent_puts( "}" );
	(--indent_level);
	indent_puts( "else" );
	(++indent_level);
	indent_puts( "yy_current_state = yy_NUL_trans[yy_current_state];" );
	(--indent_level);
	}

    if ( fullspd || fulltbl )
	gen_backtracking();

    if ( reject )
	indent_puts( "*yy_state_ptr++ = yy_current_state;" );
    }




void gen_NUL_trans()

    {
    int need_backtracking = (num_backtracking > 0 && ! reject);

    if ( need_backtracking )

	indent_puts( "register YY_CHAR *yy_cp = yy_c_buf_p;" );

    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));

    if ( nultrans )
	{
	indent_puts( "yy_current_state = yy_NUL_trans[yy_current_state];" );
	indent_puts( "yy_is_jam = (yy_current_state == 0);" );
	}

    else if ( fulltbl )
	{
	do_indent();
	printf( "yy_current_state = yy_nxt[yy_current_state][%d];\n",
		NUL_ec );
	indent_puts( "yy_is_jam = (yy_current_state <= 0);" );
	}

    else if ( fullspd )
	{
	do_indent();
	printf( "register int yy_c = %d;\n", NUL_ec );

	indent_puts(
	    "register const struct yy_trans_info *yy_trans_info;\n" );
	indent_puts( "yy_trans_info = &yy_current_state[yy_c];" );
	indent_puts( "yy_current_state += yy_trans_info->yy_nxt;" );

	indent_puts( "yy_is_jam = (yy_trans_info->yy_verify != yy_c);" );
	}

    else
	{
	char NUL_ec_str[20];

	(void) sprintf( NUL_ec_str, "%d", NUL_ec );
	gen_next_compressed_state( NUL_ec_str );

	if ( reject )
	    indent_puts( "*yy_state_ptr++ = yy_current_state;" );

	do_indent();

	if ( interactive )
	    printf( "yy_is_jam = (yy_base[yy_current_state] == %d);\n",
		    jambase );
	else
	    printf( "yy_is_jam = (yy_current_state == %d);\n", jamstate );
	}





    if ( need_backtracking && (fullspd || fulltbl) )
	{
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
	indent_puts( "if ( ! yy_is_jam )" );
	(++indent_level);
	indent_puts( "{" );
	gen_backtracking();
	indent_puts( "}" );
	(--indent_level);
	}
    }




void gen_start_state()

    {
    if ( fullspd )
	indent_put2s( "yy_current_state = yy_start_state_list[yy_start%s];",
		bol_needed ? " + (yy_bp[-1] == '\\n' ? 1 : 0)" : "" );

    else
	{
	indent_puts( "yy_current_state = yy_start;" );

	if ( bol_needed )
	    {
	    indent_puts( "if ( yy_bp[-1] == '\\n' )" );
	    (++indent_level);
	    indent_puts( "++yy_current_state;" );
	    (--indent_level);
	    }

	if ( reject )
	    {

	    indent_puts( "yy_state_ptr = yy_state_buf;" );
	    indent_puts( "*yy_state_ptr++ = yy_current_state;" );
	    }
	}
    }








void gentabs()

    {
    int i, j, k, *accset, nacc, *acc_array, total_states;
    int end_of_buffer_action = num_rules + 1;




    static char C_char_decl[] =
	"static const YY_CHAR %s[%d] =\n    {   0,\n";

    acc_array = (int *) allocate_array( current_max_dfas, sizeof( int ) );
    nummt = 0;






    ++num_backtracking;

    if ( reject )
	{






	int EOB_accepting_list[2];


	EOB_accepting_list[0] = 0;
	EOB_accepting_list[1] = end_of_buffer_action;
	accsiz[end_of_buffer_state] = 1;
	dfaacc[end_of_buffer_state].dfaacc_set = EOB_accepting_list;

	printf( C_short_decl, "yy_acclist", ((numas) > (1) ? (numas) : (1)) + 1 );

	j = 1;

	for ( i = 1; i <= lastdfa; ++i )
	    {
	    acc_array[i] = j;

	    if ( accsiz[i] != 0 )
		{
		accset = dfaacc[i].dfaacc_set;
		nacc = accsiz[i];

		if ( trace )
		    fprintf( (&__stderr), "state # %d accepts: ", i );

		for ( k = 1; k <= nacc; ++k )
		    {
		    int accnum = accset[k];

		    ++j;

		    if ( variable_trailing_context_rules &&
			 ! (accnum & 0x4000) &&
			 accnum > 0 && accnum <= num_rules &&
			 rule_type[accnum] == 1 )
			{



			accnum |= 0x2000;
			}

		    mkdata( accnum );

		    if ( trace )
			{
			fprintf( (&__stderr), "[%d]", accset[k] );

			if ( k < nacc )
			    fputs( ", ", (&__stderr) );
			else
			    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
			}
		    }
		}
	    }


	acc_array[i] = j;

	dataend();
	}

    else
	{
	dfaacc[end_of_buffer_state].dfaacc_state = end_of_buffer_action;

	for ( i = 1; i <= lastdfa; ++i )
	    acc_array[i] = dfaacc[i].dfaacc_state;


	acc_array[i] = 0;
	}









    k = lastdfa + 2;

    if ( reject )





	++k;

    printf( C_short_decl, "yy_accept", k );

    for ( i = 1; i <= lastdfa; ++i )
	{
	mkdata( acc_array[i] );

	if ( ! reject && trace && acc_array[i] )
	    fprintf( (&__stderr), "state # %d accepts: [%d]\n", i, acc_array[i] );
	}


    mkdata( acc_array[i] );

    if ( reject )

	mkdata( acc_array[i] );

    dataend();

    if ( useecs )
	genecs();

    if ( usemecs )
	{


	if ( trace )
	    fputs( "\n\nMeta-Equivalence Classes:\n", (&__stderr) );

	printf( C_char_decl, "yy_meta", numecs + 1 );

	for ( i = 1; i <= numecs; ++i )
	    {
	    if ( trace )
		fprintf( (&__stderr), "%d = %d\n", i, abs( tecbck[i] ) );

	    mkdata( abs( tecbck[i] ) );
	    }

	dataend();
	}

    total_states = lastdfa + numtemps;

    printf( tblend > 32766 ? C_long_decl : C_short_decl,
	    "yy_base", total_states + 1 );

    for ( i = 1; i <= lastdfa; ++i )
	{
	register int d = def[i];

	if ( base[i] == -32766 )
	    base[i] = jambase;

	if ( d == -32766 )
	    def[i] = jamstate;

	else if ( d < 0 )
	    {

	    ++tmpuses;
	    def[i] = lastdfa - d + 1;
	    }

	mkdata( base[i] );
	}


    mkdata( base[i] );

    for ( ++i                     ; i <= total_states; ++i )
	{
	mkdata( base[i] );
	def[i] = jamstate;
	}

    dataend();

    printf( tblend > 32766 ? C_long_decl : C_short_decl,
	    "yy_def", total_states + 1 );

    for ( i = 1; i <= total_states; ++i )
	mkdata( def[i] );

    dataend();

    printf( lastdfa > 32766 ? C_long_decl : C_short_decl,
	    "yy_nxt", tblend + 1 );

    for ( i = 1; i <= tblend; ++i )
	{
	if ( nxt[i] == 0 || chk[i] == 0 )
	    nxt[i] = jamstate;

	mkdata( nxt[i] );
	}

    dataend();

    printf( lastdfa > 32766 ? C_long_decl : C_short_decl,
	    "yy_chk", tblend + 1 );

    for ( i = 1; i <= tblend; ++i )
	{
	if ( chk[i] == 0 )
	    ++nummt;

	mkdata( chk[i] );
	}

    dataend();
    }






void indent_put2s( fmt, arg )
char fmt[], arg[];

    {
    do_indent();
    printf( fmt, arg );
    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
    }






void indent_puts( str )
char str[];

    {
    do_indent();
    puts( str );
    }










void make_tables()

    {
    register int i;
    int did_eof_rule = 0;

    skelout();


    indent_level = 2;

    if ( yymore_used )
	{
	indent_puts( "yytext -= yy_more_len; \\" );
	indent_puts( "yyleng = yy_cp - yytext; \\" );
	}

    else
	indent_puts( "yyleng = yy_cp - yy_bp; \\" );

    indent_level = 0;

    skelout();


    printf( "#define YY_END_OF_BUFFER %d\n", num_rules + 1 );

    if ( fullspd )
	{


	int total_table_size = tblend + numecs + 1;
	char *trans_offset_type =
	    total_table_size > 32766 ? "long" : "short";

	indent_level = 0;
	indent_puts( "struct yy_trans_info" );
	(++indent_level);
        indent_puts( "{" );
        indent_puts( "short yy_verify;" );








        indent_put2s( "%s yy_nxt;", trans_offset_type );
        indent_puts( "};" );
	(--indent_level);

	indent_puts( "typedef const struct yy_trans_info *yy_state_type;" );
	}

    else
	indent_puts( "typedef int yy_state_type;" );

    if ( fullspd )
	genctbl();

    else if ( fulltbl )
	genftbl();

    else
	gentabs();

    if ( num_backtracking > 0 )
	{
	indent_puts( "static yy_state_type yy_last_accepting_state;" );
	indent_puts( "static YY_CHAR *yy_last_accepting_cpos;\n" );
	}

    if ( nultrans )
	{
	printf( C_state_decl, "yy_NUL_trans", lastdfa + 1 );

	for ( i = 1; i <= lastdfa; ++i )
	    {
	    if ( fullspd )
		{
		if ( nultrans )
		    printf( "    &yy_transition[%d],\n", base[i] );
		else
		    printf( "    0,\n" );
		}

	    else
		mkdata( nultrans[i] );
	    }

	dataend();
	}

    if ( ddebug )
	{
	indent_puts( "extern int yy_flex_debug;" );
	indent_puts( "int yy_flex_debug = 1;\n" );

	printf( C_short_decl, "yy_rule_linenum", num_rules );
	for ( i = 1; i < num_rules; ++i )
	    mkdata( rule_linenum[i] );
	dataend();
	}

    if ( reject )
	{

	puts(
	"static yy_state_type yy_state_buf[YY_BUF_SIZE + 2], *yy_state_ptr;" );
	puts( "static YY_CHAR *yy_full_match;" );
	puts( "static int yy_lp;" );

	if ( variable_trailing_context_rules )
	    {
	    puts( "static int yy_looking_for_trail_begin = 0;" );
	    puts( "static int yy_full_lp;" );
	    puts( "static int *yy_full_state;" );
	    printf( "#define YY_TRAILING_MASK 0x%x\n", 0x2000 );
	    printf( "#define YY_TRAILING_HEAD_MASK 0x%x\n",
		    0x4000 );
	    }

	puts( "#define REJECT \\" );
        puts( "{ \\" );
        puts(
	"*yy_cp = yy_hold_char; /* undo effects of setting up yytext */ \\" );
        puts(
	    "yy_cp = yy_full_match; /* restore poss. backed-over text */ \\" );

	if ( variable_trailing_context_rules )
	    {
	    puts( "yy_lp = yy_full_lp; /* restore orig. accepting pos. */ \\" );
	    puts(
		"yy_state_ptr = yy_full_state; /* restore orig. state */ \\" );
	    puts(
	    "yy_current_state = *yy_state_ptr; /* restore curr. state */ \\" );
	    }

        puts( "++yy_lp; \\" );
        puts( "goto find_rule; \\" );
        puts( "}" );
	}

    else
	{
	puts( "/* the intent behind this definition is that it'll catch" );
	puts( " * any uses of REJECT which flex missed" );
	puts( " */" );
	puts( "#define REJECT reject_used_but_not_detected" );
	}

    if ( yymore_used )
	{
	indent_puts( "static int yy_more_flag = 0;" );
	indent_puts( "static int yy_doing_yy_more = 0;" );
	indent_puts( "static int yy_more_len = 0;" );
	indent_puts(
	    "#define yymore() { yy_more_flag = 1; }" );
	indent_puts(
	    "#define YY_MORE_ADJ (yy_doing_yy_more ? yy_more_len : 0)" );
	}

    else
	{
	indent_puts( "#define yymore() yymore_used_but_not_detected" );
	indent_puts( "#define YY_MORE_ADJ 0" );
	}

    skelout();

    if ( (((temp_action_file)->_flags & 0x020) != 0) )
	flexfatal( "error occurred when writing temporary action file" );

    else if ( fclose( temp_action_file ) )
	flexfatal( "error occurred when closing temporary action file" );

    temp_action_file = fopen( action_file_name, "r" );

    if ( temp_action_file == ((void *) 0) )
	flexfatal( "could not re-open temporary action file" );


    action_out();

    skelout();

    indent_level = 2;

    if ( yymore_used )
	{
	indent_puts( "yy_more_len = 0;" );
	indent_puts( "yy_doing_yy_more = yy_more_flag;" );
	indent_puts( "if ( yy_doing_yy_more )" );
	(++indent_level);
	indent_puts( "{" );
	indent_puts( "yy_more_len = yyleng;" );
	indent_puts( "yy_more_flag = 0;" );
	indent_puts( "}" );
	(--indent_level);
	}

    skelout();

    gen_start_state();


    puts( "yy_match:" );
    gen_next_match();

    skelout();
    indent_level = 2;
    gen_find_action();

    skelout();
    if ( ddebug )
	{
	indent_puts( "if ( yy_flex_debug )" );
	(++indent_level);

	indent_puts( "{" );
	indent_puts( "if ( yy_act == 0 )" );
	(++indent_level);
	indent_puts( "fprintf( stderr, \"--scanner backtracking\\n\" );" );
	(--indent_level);

	do_indent();
	printf( "else if ( yy_act < %d )\n", num_rules );
	(++indent_level);
	indent_puts(
	"fprintf( stderr, \"--accepting rule at line %d (\\\"%s\\\")\\n\"," );
	indent_puts( "         yy_rule_linenum[yy_act], yytext );" );
	(--indent_level);

	do_indent();
	printf( "else if ( yy_act == %d )\n", num_rules );
	(++indent_level);
	indent_puts(
	"fprintf( stderr, \"--accepting default rule (\\\"%s\\\")\\n\"," );
	indent_puts( "         yytext );" );
	(--indent_level);

	do_indent();
	printf( "else if ( yy_act == %d )\n", num_rules + 1 );
	(++indent_level);
	indent_puts( "fprintf( stderr, \"--(end of buffer or a NUL)\\n\" );" );
	(--indent_level);

	do_indent();
	printf( "else\n" );
	(++indent_level);
	indent_puts( "fprintf( stderr, \"--EOF\\n\" );" );
	(--indent_level);

	indent_puts( "}" );
	(--indent_level);
	}


    skelout();
    (++indent_level);
    gen_bt_action();
    action_out();


    for ( i = 1; i <= lastsc; ++i )
	if ( ! sceof[i] )
	    {
	    do_indent();
	    printf( "case YY_STATE_EOF(%s):\n", scname[i] );
	    did_eof_rule = 1;
	    }

    if ( did_eof_rule )
	{
	(++indent_level);
	indent_puts( "yyterminate();" );
	(--indent_level);
	}







    skelout();
    indent_level = 7;

    if ( fullspd || fulltbl )
	indent_puts( "yy_cp = yy_c_buf_p;" );

    else
	{
	if ( ! reject && ! interactive )
	    {

	    indent_puts( "yy_cp = yy_last_accepting_cpos;" );
	    indent_puts( "yy_current_state = yy_last_accepting_state;" );
	    }
	}



    indent_level = 1;
    skelout();

    if ( bol_needed )
	indent_puts( "register YY_CHAR *yy_bp = yytext;\n" );

    gen_start_state();

    indent_level = 2;
    skelout();
    gen_next_state( 1 );

    indent_level = 1;
    skelout();
    gen_NUL_trans();

    skelout();



    line_directive_out( (&__stdout) );
    (void) flexscan();
    }
