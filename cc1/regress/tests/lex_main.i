# 1 "main.c"

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
# 33 "main.c"
static char flex_version[] = "2.3";




void flexinit (int, char**);
void readin ();
void set_up_initial_allocations ();



int printstats, syntaxerror, eofseen, ddebug, trace, spprdflt;
int interactive, caseins, useecs, fulltbl, usemecs;
int fullspd, gen_line_dirs, performance_report, backtrack_report, csize;
int yymore_used, reject, real_reject, continued_action;
int yymore_really_used, reject_really_used;
int datapos, dataline, linenum;
FILE *skelfile = ((void *) 0);
char *infilename = ((void *) 0);
int onestate[500], onesym[500];
int onenext[500], onedef[500], onesp;
int current_mns, num_rules, current_max_rules, lastnfa;
int *firstst, *lastst, *finalst, *transchar, *trans1, *trans2;
int *accptnum, *assoc_rule, *state_type, *rule_type, *rule_linenum;
int current_state_type;
int variable_trailing_context_rules;
int numtemps, numprots, protprev[50], protnext[50], prottbl[50];
int protcomst[50], firstprot, lastprot, protsave[2000];
int numecs, nextecm[256 + 1], ecgroup[256 + 1], nummecs, tecfwd[256 + 1];
int tecbck[256 + 1];
int *xlation = (int *) 0;
int num_xlations;
int lastsc, current_max_scs, *scset, *scbol, *scxclu, *sceof, *actvsc;
char **scname;
int current_max_dfa_size, current_max_xpairs;
int current_max_template_xpairs, current_max_dfas;
int lastdfa, *nxt, *chk, *tnxt;
int *base, *def, *nultrans, NUL_ec, tblend, firstfree, **dss, *dfasiz;
union dfaacc_union *dfaacc;
int *accsiz, *dhash, numas;
int numsnpairs, jambase, jamstate;
int lastccl, current_maxccls, *cclmap, *ccllen, *cclng, cclreuse;
int current_max_ccl_tbl_size;
unsigned char *ccltbl;
char *starttime, *endtime, nmstr[1024];
int sectnum, nummt, hshcol, dfaeql, numeps, eps2, num_reallocs;
int tmpuses, totnst, peakpairs, numuniq, numdup, hshsave;
int num_backtracking, bol_needed;
FILE *temp_action_file;
FILE *backtrack_file;
int end_of_buffer_state;
char *action_file_name = ((void *) 0);
char **input_files;
int num_input_files;
char *program_name;


static char *outfile = "lex.yy.c";



static int outfile_created = 0;
static int use_stdout;
static char *skelname = ((void *) 0);


int main( argc, argv )
int argc;
char **argv;

    {
    flexinit( argc, argv );

    readin();

    if ( syntaxerror )
	flexend( 1 );

    if ( yymore_really_used == 1 )
	yymore_used = 1;
    else if ( yymore_really_used == 2 )
	yymore_used = 0;

    if ( reject_really_used == 1 )
	reject = 1;
    else if ( reject_really_used == 2 )
	reject = 0;

    if ( performance_report )
	{
	if ( interactive )
	    fprintf( (&__stderr),
		     "-I (interactive) entails a minor performance penalty\n" );

	if ( yymore_used )
	    fprintf( (&__stderr), "yymore() entails a minor performance penalty\n" );

	if ( reject )
	    fprintf( (&__stderr), "REJECT entails a large performance penalty\n" );

	if ( variable_trailing_context_rules )
	    fprintf( (&__stderr),
"Variable trailing context rules entail a large performance penalty\n" );
	}

    if ( reject )
	real_reject = 1;

    if ( variable_trailing_context_rules )
	reject = 1;

    if ( (fulltbl || fullspd) && reject )
	{
	if ( real_reject )
	    flexerror( "REJECT cannot be used with -f or -F" );
	else
	    flexerror(
	"variable trailing context rules cannot be used with -f or -F" );
	}

    ntod();


    make_tables();



    flexend( 0 );


    }














void flexend( status )
int status;

    {
    int tblsiz;
    char *flex_gettime();

    if ( skelfile != ((void *) 0) )
	{
	if ( (((skelfile)->_flags & 0x020) != 0) )
	    flexfatal( "error occurred when writing skeleton file" );

	else if ( fclose( skelfile ) )
	    flexfatal( "error occurred when closing skeleton file" );
	}

    if ( temp_action_file )
	{
	if ( (((temp_action_file)->_flags & 0x020) != 0) )
	    flexfatal( "error occurred when writing temporary action file" );

	else if ( fclose( temp_action_file ) )
	    flexfatal( "error occurred when closing temporary action file" );

	else if ( unlink( action_file_name ) )
	    flexfatal( "error occurred when deleting temporary action file" );
	}

    if ( status != 0 && outfile_created )
	{
	if ( ((((&__stdout))->_flags & 0x020) != 0) )
	    flexfatal( "error occurred when writing output file" );

	else if ( fclose( (&__stdout) ) )
	    flexfatal( "error occurred when closing output file" );

	else if ( unlink( outfile ) )
	    flexfatal( "error occurred when deleting output file" );
	}

    if ( backtrack_report && backtrack_file )
	{
	if ( num_backtracking == 0 )
	    fprintf( backtrack_file, "No backtracking.\n" );
	else if ( fullspd || fulltbl )
	    fprintf( backtrack_file,
		     "%d backtracking (non-accepting) states.\n",
		     num_backtracking );
	else
	    fprintf( backtrack_file, "Compressed tables always backtrack.\n" );

	if ( (((backtrack_file)->_flags & 0x020) != 0) )
	    flexfatal( "error occurred when writing backtracking file" );

	else if ( fclose( backtrack_file ) )
	    flexfatal( "error occurred when closing backtracking file" );
	}

    if ( printstats )
	{
	endtime = flex_gettime();

	fprintf( (&__stderr), "%s version %s usage statistics:\n", program_name,
		 flex_version );
	fprintf( (&__stderr), "  started at %s, finished at %s\n",
		 starttime, endtime );

	fprintf( (&__stderr), "  scanner options: -" );

	if ( backtrack_report )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('b')) : __flushbuf(('b'),((&__stderr))));
	if ( ddebug )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('d')) : __flushbuf(('d'),((&__stderr))));
	if ( interactive )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('I')) : __flushbuf(('I'),((&__stderr))));
	if ( caseins )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('i')) : __flushbuf(('i'),((&__stderr))));
	if ( ! gen_line_dirs )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('L')) : __flushbuf(('L'),((&__stderr))));
	if ( performance_report )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('p')) : __flushbuf(('p'),((&__stderr))));
	if ( spprdflt )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('s')) : __flushbuf(('s'),((&__stderr))));
	if ( use_stdout )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('t')) : __flushbuf(('t'),((&__stderr))));
	if ( trace )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('T')) : __flushbuf(('T'),((&__stderr))));
	if ( printstats )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('v')) : __flushbuf(('v'),((&__stderr))));
	if ( csize == 256 )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('8')) : __flushbuf(('8'),((&__stderr))));

	fprintf( (&__stderr), " -C" );

	if ( fulltbl )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('f')) : __flushbuf(('f'),((&__stderr))));
	if ( fullspd )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('F')) : __flushbuf(('F'),((&__stderr))));
	if ( useecs )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('e')) : __flushbuf(('e'),((&__stderr))));
	if ( usemecs )
	    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('m')) : __flushbuf(('m'),((&__stderr))));

	if ( strcmp( skelname,  "/lib/flex.skel" ) )
	    fprintf( (&__stderr), " -S%s", skelname );

	(--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));

	fprintf( (&__stderr), "  %d/%d NFA states\n", lastnfa, current_mns );
	fprintf( (&__stderr), "  %d/%d DFA states (%d words)\n", lastdfa,
		 current_max_dfas, totnst );
	fprintf( (&__stderr),
		 "  %d rules\n", num_rules - 1                         );

	if ( num_backtracking == 0 )
	    fprintf( (&__stderr), "  No backtracking\n" );
	else if ( fullspd || fulltbl )
	    fprintf( (&__stderr), "  %d backtracking (non-accepting) states\n",
		     num_backtracking );
	else
	    fprintf( (&__stderr), "  compressed tables always backtrack\n" );

	if ( bol_needed )
	    fprintf( (&__stderr), "  Beginning-of-line patterns used\n" );

	fprintf( (&__stderr), "  %d/%d start conditions\n", lastsc,
		 current_max_scs );
	fprintf( (&__stderr), "  %d epsilon states, %d double epsilon states\n",
		 numeps, eps2 );

	if ( lastccl == 0 )
	    fprintf( (&__stderr), "  no character classes\n" );
	else
	    fprintf( (&__stderr),
	"  %d/%d character classes needed %d/%d words of storage, %d reused\n",
		     lastccl, current_maxccls,
		     cclmap[lastccl] + ccllen[lastccl],
		     current_max_ccl_tbl_size, cclreuse );

	fprintf( (&__stderr), "  %d state/nextstate pairs created\n", numsnpairs );
	fprintf( (&__stderr), "  %d/%d unique/duplicate transitions\n",
		 numuniq, numdup );

	if ( fulltbl )
	    {
	    tblsiz = lastdfa * numecs;
	    fprintf( (&__stderr), "  %d table entries\n", tblsiz );
	    }

	else
	    {
	    tblsiz = 2 * (lastdfa + numtemps) + 2 * tblend;

	    fprintf( (&__stderr), "  %d/%d base-def entries created\n",
		     lastdfa + numtemps, current_max_dfas );
	    fprintf( (&__stderr), "  %d/%d (peak %d) nxt-chk entries created\n",
		     tblend, current_max_xpairs, peakpairs );
	    fprintf( (&__stderr),
		     "  %d/%d (peak %d) template nxt-chk entries created\n",
		     numtemps * nummecs, current_max_template_xpairs,
		     numtemps * numecs );
	    fprintf( (&__stderr), "  %d empty table entries\n", nummt );
	    fprintf( (&__stderr), "  %d protos created\n", numprots );
	    fprintf( (&__stderr), "  %d templates created, %d uses\n",
		     numtemps, tmpuses );
	    }

	if ( useecs )
	    {
	    tblsiz = tblsiz + csize;
	    fprintf( (&__stderr), "  %d/%d equivalence classes created\n",
		     numecs, csize );
	    }

	if ( usemecs )
	    {
	    tblsiz = tblsiz + numecs;
	    fprintf( (&__stderr), "  %d/%d meta-equivalence classes created\n",
		     nummecs, csize );
	    }

	fprintf( (&__stderr), "  %d (%d saved) hash collisions, %d DFAs equal\n",
		 hshcol, hshsave, dfaeql );
	fprintf( (&__stderr), "  %d sets of reallocations needed\n", num_reallocs );
	fprintf( (&__stderr), "  %d total table entries needed\n", tblsiz );
	}


    exit( status );



    }










void flexinit( argc, argv )
int argc;
char **argv;

    {
    int i, sawcmpflag;
    char *arg, *flex_gettime(), *mktemp();

    printstats = syntaxerror = trace = spprdflt = interactive = caseins = 0;
    backtrack_report = performance_report = ddebug = fulltbl = fullspd = 0;
    yymore_used = continued_action = reject = 0;
    yymore_really_used = reject_really_used = 0;
    gen_line_dirs = usemecs = useecs = 1;

    sawcmpflag = 0;
    use_stdout = 0;

    csize = 128;

    program_name = argv[0];


    for ( --argc, ++argv; argc ; --argc, ++argv )
	{
	if ( argv[0][0] != '-' || argv[0][1] == '\0' )
	    break;

	arg = argv[0];

	for ( i = 1; arg[i] != '\0'; ++i )
	    switch ( arg[i] )
		{
		case 'b':
		    backtrack_report = 1;
		    break;

		case 'c':
		    fprintf( (&__stderr),
	"%s: Assuming use of deprecated -c flag is really intended to be -C\n",
			     program_name );



		case 'C':
		    if ( i != 1 )
			flexerror( "-C flag must be given separately" );

		    if ( ! sawcmpflag )
			{
			useecs = 0;
			usemecs = 0;
			fulltbl = 0;
			sawcmpflag = 1;
			}

		    for ( ++i; arg[i] != '\0'; ++i )
			switch ( arg[i] )
			    {
			    case 'e':
				useecs = 1;
				break;

			    case 'F':
				fullspd = 1;
				break;

			    case 'f':
				fulltbl = 1;
				break;

			    case 'm':
				usemecs = 1;
				break;

			    default:
				lerrif( "unknown -C option '%c'",
					(int) arg[i] );
				break;
			    }

		    goto get_next_arg;

		case 'd':
		    ddebug = 1;
		    break;

		case 'f':
		    useecs = usemecs = 0;
		    fulltbl = 1;
		    break;

		case 'F':
		    useecs = usemecs = 0;
		    fullspd = 1;
		    break;

		case 'I':
		    interactive = 1;
		    break;

		case 'i':
		    caseins = 1;
		    break;

		case 'L':
		    gen_line_dirs = 0;
		    break;

		case 'n':

		    break;

		case 'p':
		    performance_report = 1;
		    break;

		case 'S':
		    if ( i != 1 )
			flexerror( "-S flag must be given separately" );

		    skelname = arg + i + 1;
		    goto get_next_arg;

		case 's':
		    spprdflt = 1;
		    break;

		case 't':
		    use_stdout = 1;
		    break;

		case 'T':
		    trace = 1;
		    break;

		case 'v':
		    printstats = 1;
		    break;

		case '8':
		    csize = 256;
		    break;

		default:
		    lerrif( "unknown flag '%c'", (int) arg[i] );
		    break;
		}

get_next_arg:
	;
	}

    if ( (fulltbl || fullspd) && usemecs )
	flexerror( "full table and -Cm don't make sense together" );

    if ( (fulltbl || fullspd) && interactive )
	flexerror( "full table and -I are (currently) incompatible" );

    if ( fulltbl && fullspd )
	flexerror( "full table and -F are mutually exclusive" );

    if ( ! skelname )
	{
	static char skeleton_name_storage[400];

	skelname = skeleton_name_storage;
	(void) strcpy( skelname,  "/lib/flex.skel" );
	}

    if ( ! use_stdout )
	{
	FILE *prev_stdout = freopen( outfile, "w", (&__stdout) );

	if ( prev_stdout == ((void *) 0) )
	    lerrsf( "could not create %s", outfile );

	outfile_created = 1;
	}

    num_input_files = argc;
    input_files = argv;
    set_input_file( num_input_files > 0 ? input_files[0] : ((void *) 0) );

    if ( backtrack_report )
	{

	backtrack_file = fopen( "lex.backtrack", "w" );




	if ( backtrack_file == ((void *) 0) )
	    flexerror( "could not create lex.backtrack" );
	}

    else
	backtrack_file = ((void *) 0);


    lastccl = 0;
    lastsc = 0;


    starttime = flex_gettime();

    if ( (skelfile = fopen( skelname, "r" )) == ((void *) 0) )
	lerrsf( "can't open skeleton file %s", skelname );


    action_file_name = tmpnam( ((void *) 0) );


    if ( action_file_name == ((void *) 0) )
	{
	static char temp_action_file_name[32];


	(void) strcpy( temp_action_file_name, "/tmp/flexXXXXXX" );



	(void) mktemp( temp_action_file_name );

	action_file_name = temp_action_file_name;
	}

    if ( (temp_action_file = fopen( action_file_name, "w" )) == ((void *) 0) )
	lerrsf( "can't open temporary action file %s", action_file_name );

    lastdfa = lastnfa = num_rules = numas = numsnpairs = tmpuses = 0;
    numecs = numeps = eps2 = num_reallocs = hshcol = dfaeql = totnst = 0;
    numuniq = numdup = hshsave = eofseen = datapos = dataline = 0;
    num_backtracking = onesp = numprots = 0;
    variable_trailing_context_rules = bol_needed = 0;

    linenum = sectnum = 1;
    firstprot = 0;




    lastprot = 1;

    if ( useecs )
	{



	ecgroup[1] = 0;

	for ( i = 2; i <= csize; ++i )
	    {
	    ecgroup[i] = i - 1;
	    nextecm[i - 1] = i;
	    }

	nextecm[csize] = 0;
	}

    else
	{
	for ( i = 1; i <= csize; ++i )
	    {
	    ecgroup[i] = i;
	    nextecm[i] = -32767;
	    }
	}

    set_up_initial_allocations();
    }








void readin()

    {
    skelout();

    if ( ddebug )
	puts( "#define FLEX_DEBUG" );

    if ( csize == 256 )
	puts( "#define YY_CHAR unsigned char" );
    else
	puts( "#define YY_CHAR char" );

    line_directive_out( (&__stdout) );

    if ( yyparse() )
	{
	pinpoint_message( "fatal parse error" );
	flexend( 1 );
	}

    if ( xlation )
	{
	numecs = ecs_from_xlation( ecgroup );
	useecs = 1;
	}

    else if ( useecs )
	numecs = cre8ecs( nextecm, ecgroup, csize );

    else
	numecs = csize;


    ecgroup[0] = ecgroup[csize];
    NUL_ec = abs( ecgroup[0] );

    if ( useecs )
	ccl2ecl();
    }





void set_up_initial_allocations()

    {
    current_mns = 2000;
    firstst = (int *) allocate_array( current_mns, sizeof( int ) );
    lastst = (int *) allocate_array( current_mns, sizeof( int ) );
    finalst = (int *) allocate_array( current_mns, sizeof( int ) );
    transchar = (int *) allocate_array( current_mns, sizeof( int ) );
    trans1 = (int *) allocate_array( current_mns, sizeof( int ) );
    trans2 = (int *) allocate_array( current_mns, sizeof( int ) );
    accptnum = (int *) allocate_array( current_mns, sizeof( int ) );
    assoc_rule = (int *) allocate_array( current_mns, sizeof( int ) );
    state_type = (int *) allocate_array( current_mns, sizeof( int ) );

    current_max_rules = 100;
    rule_type = (int *) allocate_array( current_max_rules, sizeof( int ) );
    rule_linenum = (int *) allocate_array( current_max_rules, sizeof( int ) );

    current_max_scs = 40;
    scset = (int *) allocate_array( current_max_scs, sizeof( int ) );
    scbol = (int *) allocate_array( current_max_scs, sizeof( int ) );
    scxclu = (int *) allocate_array( current_max_scs, sizeof( int ) );
    sceof = (int *) allocate_array( current_max_scs, sizeof( int ) );
    scname = (char **) allocate_array( current_max_scs, sizeof( char * ) );
    actvsc = (int *) allocate_array( current_max_scs, sizeof( int ) );

    current_maxccls = 100;
    cclmap = (int *) allocate_array( current_maxccls, sizeof( int ) );
    ccllen = (int *) allocate_array( current_maxccls, sizeof( int ) );
    cclng = (int *) allocate_array( current_maxccls, sizeof( int ) );

    current_max_ccl_tbl_size = 500;
    ccltbl = (unsigned char *) allocate_array( current_max_ccl_tbl_size, sizeof( unsigned char ) );

    current_max_dfa_size = 750;

    current_max_xpairs = 2000;
    nxt = (int *) allocate_array( current_max_xpairs, sizeof( int ) );
    chk = (int *) allocate_array( current_max_xpairs, sizeof( int ) );

    current_max_template_xpairs = 2500;
    tnxt = (int *) allocate_array( current_max_template_xpairs, sizeof( int ) );

    current_max_dfas = 1000;
    base = (int *) allocate_array( current_max_dfas, sizeof( int ) );
    def = (int *) allocate_array( current_max_dfas, sizeof( int ) );
    dfasiz = (int *) allocate_array( current_max_dfas, sizeof( int ) );
    accsiz = (int *) allocate_array( current_max_dfas, sizeof( int ) );
    dhash = (int *) allocate_array( current_max_dfas, sizeof( int ) );
    dss = (int **) allocate_array( current_max_dfas, sizeof( int * ) );
    dfaacc = (union dfaacc_union *) allocate_array( current_max_dfas, sizeof( union dfaacc_union ) );

    nultrans = (int *) 0;
    }
