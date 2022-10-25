# 1 "list.c"

# 39 "/home/charles/xcc/linux/include/sys/defs.h"
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
# 41 "/home/charles/xcc/linux/include/string.h"
typedef __size_t size_t;


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
# 53 "/home/charles/xcc/linux/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern double atof(const char *);
extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
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



int putenv(char *string);



int system(const char *command);
# 44 "/home/charles/xcc/linux/include/ctype.h"
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
# 41 "/home/charles/xcc/linux/include/time.h"
typedef __time_t time_t;







struct tm
{
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
};

struct timespec
{
    time_t  tv_sec;
    long    tv_nsec;
};








extern char *asctime(const struct tm *timeptr);








extern char *ctime(const time_t *timer);




extern struct tm *localtime(const time_t *timer);




extern struct tm *gmtime(const time_t *timer);




extern size_t strftime(char *s, size_t maxsize, const char *format,
                       const struct tm *timeptr);




extern time_t time(time_t *timer);



extern char *tzname[];
extern long timezone;







extern void tzset(void);




int nanosleep(const struct timespec *rqtp, struct timespec *rtmp);
# 41 "/home/charles/xcc/linux/include/sys/stat.h"
typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __ino_t ino_t;




typedef __mode_t mode_t;
# 89 "/home/charles/xcc/linux/include/sys/stat.h"
typedef __nlink_t nlink_t;




typedef __off_t off_t;









typedef __uid_t uid_t;






struct stat
{
    dev_t           st_dev;
    int             __pad0;
    ino_t           st_ino;
    int             __pad1;
    nlink_t         st_nlink;
    int             __pad2;

    mode_t          st_mode;
    uid_t           st_uid;
    gid_t           st_gid;
    int             __pad3;

    dev_t           st_rdev;
    int             __pad4;
    off_t           st_size;
    long            __pad5;
    long            __pad6;

    time_t          st_atime;
    long            __pad7;
    time_t          st_mtime;
    long            __pad8;
    time_t          st_ctime;
    long            __pad9;

    unsigned long   __pad[3];
};



extern int stat(const char *path, struct stat *buf);
extern int fstat(int fildes, struct stat *buf);



int chmod(const char *pathname, mode_t mode);
int fchmod(int fildes, mode_t mode);



int mkdir(const char *path, mode_t mode);



int mknod(const char *path, mode_t mode, dev_t dev);



extern mode_t umask(mode_t cmask);
# 48 "/home/charles/xcc/linux/include/stdio.h"
typedef __off_t fpos_t;












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
extern int fgetc(FILE *);
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
# 41 "/home/charles/xcc/linux/include/sys/types.h"
typedef __caddr_t caddr_t;




typedef __daddr_t daddr_t;
# 94 "/home/charles/xcc/linux/include/sys/types.h"
typedef __pid_t pid_t;









typedef __ssize_t ssize_t;
# 62 "tar.h"
union record {
    char        charptr[512];
    struct header {
        char    name[100];
        char    mode[8];
        char    uid[8];
        char    gid[8];
        char    size[12];
        char    mtime[12];
        char    chksum[8];
        char    linkflag;
        char    linkname[100];
        char    magic[8];
        char    uname[32];
        char    gname[32];
        char    devmajor[8];
        char    devminor[8];
    } header;
};
# 113 "tar.h"
extern union record *ar_block;
extern union record *ar_record;
extern union record *ar_last;
extern char     ar_reading;
extern int      blocking;
extern int      blocksize;
extern char     *ar_file;
extern char     *name_file;
extern char     *tar;




extern char f_reblock;
extern char f_create;
extern char f_diff;
extern char f_dironly;
extern char f_follow_links;
extern char f_ignorez;
extern char f_keep;
extern char f_local_filesys;
extern char f_modified;
extern char f_oldarch;
extern char f_use_protection;
extern char f_sayblock;
extern char f_sorted_names;
extern char f_list;
extern char f_namefile;
extern char f_verbose;
extern char f_extract;
extern char f_compress;
















struct name {
    struct name *next;
    short       length;
    char        found;
    char        firstch;
    char        regexp;
    char        name[100+1];
};

extern struct name  *namelist;
extern struct name  *namelast;

extern int      archive;
extern int      errors;











struct link {
    struct link *next;
    dev_t       dev;
    ino_t       ino;
    short       linkcount;
    char        name[100+1];
};

extern struct link  *linklist;





extern char     read_error_flag;






void            saverec(union record **pointer);
void            userec(union record *rec);
union record    *findrec(void);
union record    *endofrecs(void);
void            anno(FILE *stream, char *prefix, int savedp);
void            open_archive(int read);
void            close_archive(void);
void            name_close(void);
int             wildmat(char *s, char *p);
void            name_gather(void);
void            extr_init(void);
int             read_header(void);
int             finduid(char *uname);
int             findgid(char *gname);
int             name_match(char *p);
void            names_notfound(void);

void            decode_header(union record *header, struct stat *st,
                              int *stdp, int wantug);

int             getoldopt(int argc, char **argv, char *optstring);
void            read_and(void (*do_something)(void));
void            list_archive(void);
void            extract_archive(void);
void            create_archive(void);
void            print_header(FILE *outfile);
void            finduname(char *uname, int uid);
void            findgname(char *gname, int gid);
char            *name_next(void);
# 45 "list.c"
long from_oct();
void demode();

union record *head;
struct stat hstat;
int head_standard;

void skip_file();





void
read_and(void (*do_something)(void))
{
	int status = 3;
	int prev_status;

	name_gather();
	open_archive(1);

	for(;;) {
		prev_status = status;
		status = read_header();
		switch (status) {

		case 1:


			head->header.name[100-1] = '\0';

			if (!name_match(head->header.name)) {

				userec(head);

				skip_file((long)hstat.st_size);
				continue;
			}

			(*do_something)();
			continue;





		case 0:
			userec(head);
			switch (prev_status) {
			case 3:
				anno((&__stderr), tar, 0);
				fprintf((&__stderr),
				"Hmm, this doesn't look like a tar archive.\n");

			case 2:
			case 1:
				anno((&__stderr), tar, 0);
				fprintf((&__stderr),
					"Skipping to next file header...\n");
			case 0:
				break;
			}
			continue;

		case 2:
			userec(head);
			status = prev_status;
			if (f_ignorez)
				continue;

		case (-1):
			break;
		}
		break;
	};

	close_archive();
	names_notfound();
}






void
list_archive(void)
{


	saverec(&head);


	if (f_verbose) {
		if (f_verbose > 1)
			decode_header(head, &hstat, &head_standard, 0);
		print_header((&__stdout));
	}


	saverec((union record **) 0);
	userec(head);


	skip_file((long)hstat.st_size);
}














int
read_header(void)
{
	register int	i;
	register long	sum, recsum;
	register char	*p;
	register union record *header;

	header = findrec();
	head = header;
	if (((void *) 0) == header) return (-1);

	recsum = from_oct(8,  header->header.chksum);

	sum = 0;
	p = header->charptr;
	for (i = sizeof(*header); --i >= 0;) {




		sum += 0xFF & *p++;
	}


	for (i = sizeof(header->header.chksum); --i >= 0;)
		sum -= 0xFF & header->header.chksum[i];
	sum += ' '* sizeof header->header.chksum;

	if (sum == recsum) {



		if (header->header.linkflag == '1')
			hstat.st_size = 0;
		else
			hstat.st_size = from_oct(1+12, header->header.size);
		return 1;
	}

	if (sum == 8*' ') {




		return 2;
	}

	return 0;
}



















void
decode_header(union record *header, struct stat *st, int *stdp, int wantug)
{

	st->st_mode = from_oct(8,  header->header.mode);
	st->st_mtime = from_oct(1+12, header->header.mtime);

	if (0==strcmp(header->header.magic, "ustar  ")) {

		*stdp = 1;
		if (wantug) {




			st->st_uid = finduid(header->header.uname);
			st->st_gid = findgid(header->header.gname);

		}
		switch  (header->header.linkflag)
		case '4': case '3':
		    st->st_rdev = 
((dev_t) (((from_oct(8, header->header.devmajor)) << 8) | (from_oct(8, header->header.devminor))));
	} else {

		*stdp = 0;
		st->st_uid = from_oct(8,  header->header.uid);
		st->st_gid = from_oct(8,  header->header.gid);
		st->st_rdev = 0;
	}
}







long
from_oct(digs, where)
	register int	digs;
	register char	*where;
{
	register long	value;

	while (((__ctype+1)[*where]&0x08)) {
		where++;
		if (--digs <= 0)
			return -1;
	}
	value = 0;
	while (digs > 0 && ( ((*where) >= '0') && ((*where) <= '7') )) {
		value = (value << 3) | (*where++ - '0');
		--digs;
	}

	if (digs > 0 && *where && !((__ctype+1)[*where]&0x08))
		return -1;

	return value;
}



















static int	ugswidth = 11;

void
print_header(FILE *outfile)
{
	char modes[11];
	char *timestamp;
	char uform[11], gform[11];
	char *user, *group;
	char size[24];
	long longie;
	int	pad;

	anno(outfile, (char *)((void *) 0), 1);

	if (f_verbose <= 1) {

		fprintf(outfile, "%s\n", head->header.name);
		return;
	} else {

		modes[0] = '?';
		switch (head->header.linkflag) {
		case '0':
		case '\0':
		case '1':
				modes[0] = '-';
				if ('/' == head->header.name[strlen(head->header.name)-1])
					modes[0] = 'd';
				break;
		case '5':	modes[0] = 'd'; break;
		case '2':modes[0] = 'l'; break;
		case '4':	modes[0] = 'b'; break;
		case '3':	modes[0] = 'c'; break;
		case '6':	modes[0] = 'p'; break;
		case '7':	modes[0] = 'C'; break;
		}

		demode((unsigned)hstat.st_mode, modes+1);


		longie = hstat.st_mtime;
		timestamp = ctime(&longie);
		timestamp[16] = '\0';
		timestamp[24] = '\0';


		if (*head->header.uname && head_standard) {
			user  = head->header.uname;
		} else {
			user = uform;
			(void)sprintf(uform, "%d", (int)hstat.st_uid);
		}
		if (*head->header.gname && head_standard) {
			group = head->header.gname;
		} else {
			group = gform;
			(void)sprintf(gform, "%d", (int)hstat.st_gid);
		}


		switch (head->header.linkflag) {
		case '3':
		case '4':
			(void)sprintf(size, "%d,%d",
					(((hstat.st_rdev) >> 8) & 0xFF),
					((hstat.st_rdev) & 0xFF));
			break;

		default:
			(void)sprintf(size, "%ld", (long)hstat.st_size);
		}


		pad = strlen(user) + strlen(group) + strlen(size) + 1;
		if (pad > ugswidth) ugswidth = pad;

		fprintf(outfile, "%s %s/%s %*s%s %s %s %.*s",
			modes,
			user,
			group,
			ugswidth - pad,
			"",
			size,
			timestamp+4, timestamp+20,
			sizeof(head->header.name),
			head->header.name);

		switch (head->header.linkflag) {
		case '2':
			fprintf(outfile, " -> %s\n", head->header.linkname);
			break;

		case '1':
			fprintf(outfile, " link to %s\n", head->header.linkname);
			break;

		default:
			fprintf(outfile, " unknown file type '%c'\n",
				head->header.linkflag);
			break;

		case '\0':
		case '0':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
			(--(outfile)->_count >= 0 ? (int) (*(outfile)->_ptr++ = ('\n')) : __flushbuf(('\n'),(outfile)));
			break;
		}
	}
}




void
pr_mkdir(pathname, length, mode, outfile)
	char *pathname;
	int length;
	int mode;
	FILE *outfile;
{
	char modes[11];

	if (f_verbose > 1) {

		modes[0] = 'd';
		demode((unsigned)mode, modes+1);

		anno(outfile, (char *)((void *) 0), 1);
		fprintf(outfile, "%s %*s %.*s\n",
			modes,
			ugswidth+19,
			"Creating directory:",
			length,
			pathname);
	}
}





void
skip_file(size)
	register long size;
{
	union record *x;

	while (size > 0) {
		x = findrec();
		if (x == ((void *) 0)) {
			anno((&__stderr), tar, 0);
			fprintf((&__stderr), "Unexpected EOF on archive file\n");
			exit(3);
		}
		userec(x);
		size -= 512;
	}
}





void
demode(mode, string)
	register unsigned mode;
	register char *string;
{
	register unsigned mask;
	register char *rwx = "rwxrwxrwx";

	for (mask = 0400; mask != 0; mask >>= 1) {
		if (mode & mask)
			*string++ = *rwx++;
		else {
			*string++ = '-';
			rwx++;
		}
	}

	if (mode & 0004000)
		if (string[-7] == 'x')
			string[-7] = 's';
		else
			string[-7] = 'S';
	if (mode & 0002000)
		if (string[-4] == 'x')
			string[-4] = 's';
		else
			string[-4] = 'S';
	if (mode & 0001000)
		if (string[-1] == 'x')
			string[-1] = 't';
		else
			string[-1] = 'T';
	*string = '\0';
}
