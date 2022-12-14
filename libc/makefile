##############################################################################
#
#                                                      minix standard library
#
##############################################################################

AS=$(CC) -c
CFLAGS=-O

all:	crt0.o libc.a

clean:
	rm -f *.o libc.a

crt0.o:	crt0.s

OBJS=		__assert.o __ctype.o __dtefg.o __fillbuf.o 		\
		__flushbuf.o __ieee_val.o __poly.o __pow10.o 		\
		__setjmp.o __two.o abort.o abs.o atan.o atan2.o 	\
		atof.o atoi.o atol.o brk.o bsearch.o calloc.o 		\
		clearerr.o closedir.o cos.o ctime.o execl.o 		\
		execlp.o execvp.o execvpe.o exit.o exp.o fclose.o 	\
		fdopen.o fflush.o fgetc.o fgetpos.o fgets.o fileno.o 	\
		fopen.o fprintf.o fputc.o fputs.o fread.o freopen.o	\
		frexp.o fscanf.o fseek.o fsetpos.o ftell.o		\
		fwrite.o getcwd.o getenv.o getgrent.o getopt.o		\
		getpwent.o gets.o isalnum.o isalpha.o iscntrl.o 	\
		isdigit.o isgraph.o islower.o isprint.o ispunct.o 	\
		isspace.o isupper.o isxdigit.o isatty.o labs.o 		\
		ldexp.o log.o log10.o malloc.o memchr.o memcmp.o 	\
		memcpy.o memmove.o memset.o modf.o mktemp.o opendir.o 	\
		perror.o popen.o pow.o printf.o putenv.o puts.o 	\
		qsort.o raise.o rand.o readdir.o remove.o rewind.o 	\
		rewinddir.o scanf.o setbuf.o setvbuf.o sigaction.o 	\
		sigemptyset.o signal.o sin.o sleep.o sprintf.o 		\
		sqrt.o sscanf.o stdio.o strcat.o strchr.o strcmp.o 	\
		strcpy.o strdup.o strerror.o strftime.o strlen.o 	\
		strncat.o strncmp.o strncpy.o strrchr.o strtof.o 	\
		strtod.o strtol.o syscall.o system.o tmpnam.o 		\
		tolower.o toupper.o ungetc.o vfprintf.o vfscanf.o 	\
		vsprintf.o wait.o

libc.a:		$(OBJS)
	rm -f libc.a
	$(AR) rc libc.a $(OBJS)

__setjmp.o:		__setjmp.s
memcpy.o:		memcpy.s
memmove.o:		memmove.s
memset.o:		memset.s
syscall.o:		syscall.s

__assert.o:		__assert.c
__ctype.o:		__ctype.c
__fillbuf.o:		__fillbuf.c
__flushbuf.o:		__flushbuf.c
__ieee_val.o:		__ieee_val.s
__poly.o:		__poly.c
__pow10.o:		__pow10.c
__two.o:		__two.c
abort.o:		abort.c
abs.o:			abs.c
atan.o:			atan.c
atan2.o:		atan2.c
atof.o:			atof.c
atoi.o:			atoi.c
atol.o:			atol.c
brk.o:			brk.c
bsearch.o: 		bsearch.c
calloc.o:		calloc.c
clearerr.o:		clearerr.c
closedir.o:		closedir.c
cos.o:			cos.c
ctime.o:		ctime.c
execl.o:		execl.c
execlp.o:		execlp.c
execvp.o:		execvp.c
execvpe.o:		execvpe.c
exit.o:			exit.c
exp.o:			exp.c
fclose.o:		fclose.c
fdopen.o:		fdopen.c
fflush.o:		fflush.c
fgetc.o:		fgetc.c
fgetpos.o:		fgetpos.c
fgets.o:		fgets.c
fileno.o:		fileno.c
fopen.o:		fopen.c
fprintf.o:		fprintf.c
fputc.o:		fputc.c
fputs.o:		fputs.c
fread.o:		fread.c
freopen.o:		freopen.c
frexp.o:		frexp.c
fscanf.o:		fscanf.c
fseek.o:		fseek.c
fsetpos.o:		fsetpos.c
ftell.o:		ftell.c
fwrite.o:		fwrite.c
getcwd.o:		getcwd.c
getenv.o:		getenv.c
getgrent.o:		getgrent.c
getopt.o:		getopt.c
getpwent.o:		getpwent.c
gets.o:			gets.c
isalnum.o:		isalnum.c
isalpha.o:		isalpha.c
iscntrl.o:		iscntrl.c
isdigit.o:		isdigit.c
isgraph.o:		isgraph.c
islower.o:		islower.c
isprint.o:		isprint.c
ispunct.o:		ispunct.c
isspace.o:		isspace.c
isupper.o:		isupper.c
isxdigit.o:		isxdigit.c
isatty.o:		isatty.c
labs.o:			labs.c
ldexp.o:		ldexp.c
log.o:			log.c
log10.o:		log10.c
malloc.o:		malloc.c
memchr.o:		memchr.c
memcmp.o:		memcmp.c
modf.o:			modf.c
mktemp.o:		mktemp.c
opendir.o:		opendir.c
perror.o:		perror.c
popen.o:		popen.c
pow.o:			pow.c
printf.o:		printf.c
putenv.o:		putenv.c
puts.o:			puts.c
qsort.o:		qsort.c
raise.o:		raise.c
rand.o:			rand.c
readdir.o:		readdir.c
remove.o:		remove.c
rewind.o:		rewind.c
rewinddir.o:		rewinddir.c
scanf.o:		scanf.c
setbuf.o:		setbuf.c
setvbuf.o:		setvbuf.c
sigaction.o:		sigaction.c
sigemptyset.o:		sigemptyset.c
signal.o:		signal.c
sin.o:			sin.c
sleep.o:		sleep.c
sprintf.o:		sprintf.c
sqrt.o:			sqrt.c
sscanf.o:		sscanf.c
stdio.o:		stdio.c
strcat.o:		strcat.c
strchr.o:		strchr.c
strcmp.o:		strcmp.c
strcpy.o:		strcpy.c
strdup.o:		strdup.c
strerror.o:		strerror.c
strftime.o:		strftime.c
strlen.o:		strlen.c
strncat.o:		strncat.c
strncmp.o:		strncmp.c
strncpy.o:		strncpy.c
strrchr.o:		strrchr.c
strtod.o:		strtod.c
strtof.o:		strtof.c
strtol.o:		strtol.c
system.o:		system.c
tmpnam.o:		tmpnam.c
tolower.o:		tolower.c
toupper.o:		toupper.c
ungetc.o:		ungetc.c
vfprintf.o:		vfprintf.c
vfscanf.o:		vfscanf.c
vsprintf.o:		vsprintf.c
wait.o:			wait.c
