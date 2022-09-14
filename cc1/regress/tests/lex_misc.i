# 1 "misc.c"

# 44 "/home/charles/xcc/jewel/include/ctype.h"
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
# 41 "misc.c"
void dataflush ();
int otoi (unsigned char []);










void action_out()

    {
    char buf[1024];

    while ( fgets( buf, 1024, temp_action_file ) != ((void *) 0) )
	if ( buf[0] == '%' && buf[1] == '%' )
	    break;
	else
	    fputs( buf, (&__stdout) );
    }




void *allocate_array( size, element_size )
int size, element_size;

    {
    register void *mem;





    if ( element_size * size <= 0 )
        flexfatal( "request for < 1 byte in allocate_array()" );

    mem = (void *) malloc( (unsigned) (element_size * size) );

    if ( mem == ((void *) 0) )
	flexfatal( "memory allocation failed in allocate_array()" );

    return ( mem );
    }










int all_lower( str )
register unsigned char *str;

    {
    while ( *str )
	{
	if ( ! ((unsigned) (*str) < 128) || ! ((__ctype+1)[*str]&0x02) )
	    return ( 0 );
	++str;
	}

    return ( 1 );
    }










int all_upper( str )
register unsigned char *str;

    {
    while ( *str )
	{
	if ( ! ((unsigned) (*str) < 128) || ! ((__ctype+1)[(char) *str]&0x01) )
	    return ( 0 );
	++str;
	}

    return ( 1 );
    }
















void bubble( v, n )
int v[], n;

    {
    register int i, j, k;

    for ( i = n; i > 1; --i )
	for ( j = 1; j < i; ++j )
	    if ( v[j] > v[j + 1] )
		{
		k = v[j];
		v[j] = v[j + 1];
		v[j + 1] = k;
		}
    }










unsigned char clower( c )
register int c;

    {
    return ( (((unsigned) (c) < 128) && ((__ctype+1)[c]&0x01)) ? tolower( c ) : c );
    }









char *copy_string( str )
register char *str;

    {
    register char *c;
    char *copy;


    for ( c = str; *c; ++c )
	;

    copy = malloc( (unsigned) ((c - str + 1) * sizeof( char )) );

    if ( copy == ((void *) 0) )
	flexfatal( "dynamic memory failure in copy_string()" );

    for ( c = copy; (*c++ = *str++); )
	;

    return ( copy );
    }










unsigned char *copy_unsigned_string( str )
register unsigned char *str;

    {
    register unsigned char *c;
    unsigned char *copy;


    for ( c = str; *c; ++c )
	;

    copy = (unsigned char *) malloc( (unsigned) ((c - str + 1) * sizeof( unsigned char )) );

    if ( copy == ((void *) 0) )
	flexfatal( "dynamic memory failure in copy_unsigned_string()" );

    for ( c = copy; (*c++ = *str++); )
	;

    return ( copy );
    }
# 262 "misc.c"
void cshell( v, n, special_case_0 )
unsigned char v[];
int n, special_case_0;

    {
    int gap, i, j, jg;
    unsigned char k;

    for ( gap = n / 2; gap > 0; gap = gap / 2 )
	for ( i = gap; i < n; ++i )
	    for ( j = i - gap; j >= 0; j = j - gap )
		{
		jg = j + gap;

		if ( special_case_0 )
		    {
		    if ( v[jg] == 0 )
			break;

		    else if ( v[j] != 0 && v[j] <= v[jg] )
			break;
		    }

		else if ( v[j] <= v[jg] )
		    break;

		k = v[j];
		v[j] = v[jg];
		v[jg] = k;
		}
    }








void dataend()

    {
    if ( datapos > 0 )
	dataflush();


    puts( "    } ;\n" );

    dataline = 0;
    datapos = 0;
    }









void dataflush()

    {
    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));

    if ( ++dataline >= 10 )
	{



	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
	dataline = 0;
	}


    datapos = 0;
    }









void flexerror( msg )
char msg[];

    {
    fprintf( (&__stderr), "%s: %s\n", program_name, msg );

    flexend( 1 );
    }









void flexfatal( msg )
char msg[];

    {
    fprintf( (&__stderr), "%s: fatal internal error, %s\n", program_name, msg );
    flexend( 1 );
    }
# 41 "/home/charles/xcc/jewel/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;




typedef __dev_t dev_t;






typedef __gid_t gid_t;




typedef __ino_t ino_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __off_t off_t;









typedef __ssize_t ssize_t;




typedef __time_t time_t;




typedef __uid_t uid_t;
# 400 "misc.c"
char *flex_gettime()

    {
    time_t t, time();
    char *result, *ctime(), *copy_string();

    t = time( (long *) 0 );

    result = copy_string( ctime( &t ) );


    result[24] = '\0';

    return ( result );
    }










void lerrif( msg, arg )
char msg[];
int arg;

    {
    char errmsg[1024];
    (void) sprintf( errmsg, msg, arg );
    flexerror( errmsg );
    }









void lerrsf( msg, arg )
char msg[], arg[];

    {
    char errmsg[1024];

    (void) sprintf( errmsg, msg, arg );
    flexerror( errmsg );
    }










int htoi( str )
unsigned char str[];

    {
    int result;

    (void) sscanf( (char *) str, "%x", &result );

    return ( result );
    }











int is_hex_digit( ch )
int ch;

    {
    if ( ((__ctype+1)[ch]&0x04) )
	return ( 1 );

    switch ( clower( ch ) )
	{
	case 'a':
	case 'b':
	case 'c':
	case 'd':
	case 'e':
	case 'f':
	    return ( 1 );

	default:
	    return ( 0 );
	}
    }




void line_directive_out( output_file_name )
FILE *output_file_name;

    {
    if ( infilename && gen_line_dirs )
        fprintf( output_file_name, "# line %d \"%s\"\n", linenum, infilename );
    }










void mk2data( value )
int value;

    {
    if ( datapos >= 10 )
	{
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (',')) : __flushbuf((','),((&__stdout))));
	dataflush();
	}

    if ( datapos == 0 )

	fputs( "    ", (&__stdout) );

    else
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (',')) : __flushbuf((','),((&__stdout))));

    ++datapos;

    printf( "%5d", value );
    }











void mkdata( value )
int value;

    {
    if ( datapos >= 10 )
	{
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (',')) : __flushbuf((','),((&__stdout))));
	dataflush();
	}

    if ( datapos == 0 )

	fputs( "    ", (&__stdout) );

    else
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (',')) : __flushbuf((','),((&__stdout))));

    ++datapos;

    printf( "%5d", value );
    }











int myctoi( array )
unsigned char array[];

    {
    int val = 0;

    (void) sscanf( (char *) array, "%d", &val );

    return ( val );
    }










unsigned char myesc( array )
unsigned char array[];

    {
    unsigned char c, esc_char;
    register int sptr;

    switch ( array[1] )
	{
	case 'a': return ( '\a' );
	case 'b': return ( '\b' );
	case 'f': return ( '\f' );
	case 'n': return ( '\n' );
	case 'r': return ( '\r' );
	case 't': return ( '\t' );
	case 'v': return ( '\v' );

	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
	    {
	    sptr = 1;

	    while ( ((unsigned) (array[sptr]) < 128) && ((__ctype+1)[array[sptr]]&0x04) )




		++sptr;

	    c = array[sptr];
	    array[sptr] = '\0';

	    esc_char = otoi( array + 1 );

	    array[sptr] = c;

	    return ( esc_char );
	    }

	case 'x':
	    {
	    int sptr = 2;

	    while ( ((unsigned) (array[sptr]) < 128) && is_hex_digit( array[sptr] ) )




		++sptr;

	    c = array[sptr];
	    array[sptr] = '\0';

	    esc_char = htoi( array + 2 );

	    array[sptr] = c;

	    return ( esc_char );
	    }

	default:
	    return ( array[1] );
	}
    }










int otoi( str )
unsigned char str[];

    {
    int result;

    (void) sscanf( (char *) str, "%o", &result );

    return ( result );
    }












char *readable_form( c )
register int c;

    {
    static char rform[10];

    if ( (c >= 0 && c < 32) || c >= 127 )
	{
	switch ( c )
	    {
	    case '\n': return ( "\\n" );
	    case '\t': return ( "\\t" );
	    case '\f': return ( "\\f" );
	    case '\r': return ( "\\r" );
	    case '\b': return ( "\\b" );

	    default:
		(void) sprintf( rform, "\\%.3o", c );
		return ( rform );
	    }
	}

    else if ( c == ' ' )
	return ( "' '" );

    else
	{
	rform[0] = c;
	rform[1] = '\0';

	return ( rform );
	}
    }




void *reallocate_array( array, size, element_size )
void *array;
int size, element_size;

    {
    register void *new_array;


    if ( size * element_size <= 0 )
        flexfatal( "attempt to increase array size by less than 1 byte" );

    new_array =
	(void *) realloc( (char *)array, (unsigned) (size * element_size ));

    if ( new_array == ((void *) 0) )
	flexfatal( "attempt to increase array size failed" );

    return ( new_array );
    }











void skelout()

    {
    char buf[1024];

    while ( fgets( buf, 1024, skelfile ) != ((void *) 0) )
	if ( buf[0] == '%' && buf[1] == '%' )
	    break;
	else
	    fputs( buf, (&__stdout) );
    }












void transition_struct_out( element_v, element_n )
int element_v, element_n;

    {
    printf( "%7d, %5d,", element_v, element_n );

    datapos += 15;

    if ( datapos >= 75 )
	{
	(--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));

	if ( ++dataline % 10 == 0 )
	    (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));

	datapos = 0;
	}
    }
