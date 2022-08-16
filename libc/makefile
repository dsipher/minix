##############################################################################
#
#                                                   tahoe/64 standard library
#
#                                   Copyright (c) 2021, 2022 Charles E. Youse
#                                          See LICENSE file for more details.
#
##############################################################################

CC=~/xcc/bin/cc
CFLAGS=-n -I../include
AS=$(CC) -c

all:	crt0.o libc.a

clean:
	rm -f *.o libc.a

crt0.o:	crt0.s

HDRS=		../include/assert.h  	../include/ctype.h 	\
		../include/fcntl.h 	../include/float.h 	\
		../include/limits.h 	../include/math.h 	\
		../include/signal.h 	../include/stdarg.h 	\
		../include/stddef.h 	../include/stdint.h 	\
		../include/stdio.h 	../include/stdlib.h 	\
		../include/string.h 	../include/termios.h 	\
		../include/time.h 	../include/unistd.h 	\
		../include/sys/dir.h	../include/sys/ioctl.h	\
		../include/sys/mman.h	../include/sys/tahoe.h	\
		../include/sys/types.h 	../include/sys/wait.h

OBJS=		__assert.o __ctype.o __dtefg.o __fillbuf.o 	\
		__flushbuf.o __ieee_val.o __pow10.o abort.o 	\
		atoi.o atol.o brk.o bsearch.o calloc.o		\
		clearerr.o ctime.o exit.o execvp.o execvpe.o 	\
		fclose.o  fflush.o fgetpos.o fgets.o fileno.o 	\
		fopen.o fprintf.o fputc.o fputs.o fread.o 	\
		freopen.o frexp.o fscanf.o fseek.o fsetpos.o 	\
		ftell.o fwrite.o getenv.o getopt.o gets.o 	\
		isalnum.o isalpha.o iscntrl.o isdigit.o 	\
		isgraph.o islower.o isprint.o ispunct.o 	\
		isspace.o isupper.o isxdigit.o isatty.o 	\
		malloc.o memchr.o memcmp.o memcpy.o memmove.o 	\
		memset.o modf.o mktemp.o perror.o printf.o 	\
		puts.o qsort.o raise.o rand.o remove.o rewind.o \
		scanf.o setbuf.o setvbuf.o sigaction.o 		\
		sigemptyset.o signal.o sprintf.o sscanf.o 	\
		stdio.o strcat.o strchr.o strcmp.o strcpy.o 	\
		strerror.o strftime.o strlen.o strncat.o 	\
		strncmp.o strncpy.o strrchr.o strtof.o strtod.o \
		strtol.o syscall.o tcgetattr.o tolower.o 	\
		toupper.o ungetc.o  vfprintf.o vfscanf.o 	\
		vsprintf.o wait.o

libc.a:		$(OBJS)
	rm -f libc.a
	ar rc libc.a $(OBJS)

memcpy.o:		memcpy.s
memmove.o:		memmove.s
memset.o:		memset.s
syscall.o:		syscall.s

__assert.o:		__assert.c $(HDRS)
__ctype.o:		__ctype.c $(HDRS)
__fillbuf.o:		__fillbuf.c $(HDRS)
__flushbuf.o:		__flushbuf.c $(HDRS)
__ieee_val.o:		__ieee_val.s
__pow10.o:		__pow10.c $(HDRS)
abort.o:		abort.c $(HDRS)
atoi.o:			atoi.c $(HDRS)
atol.o:			atol.c $(HDRS)
brk.o:			brk.c $(HDRS)
bsearch.o: 		bsearch.c $(HDRS)
calloc.o:		calloc.c $(HDRS)
clearerr.o:		clearerr.c $(HDRS)
ctime.o:		ctime.c $(HDRS)
exit.o:			exit.c $(HDRS)
execvp.o:		execvp.c $(HDRS)
execvpe.o:		execvpe.c $(HDRS)
fclose.o:		fclose.c $(HDRS)
fflush.o:		fflush.c $(HDRS)
fgetpos.o:		fgetpos.c $(HDRS)
fgets.o:		fgets.c $(HDRS)
fileno.o:		fileno.c $(HDRS)
fopen.o:		fopen.c $(HDRS)
fprintf.o:		fprintf.c $(HDRS)
fputc.o:		fputc.c $(HDRS)
fputs.o:		fputs.c $(HDRS)
fread.o:		fread.c $(HDRS)
freopen.o:		freopen.c $(HDRS)
frexp.o:		frexp.c $(HDRS)
fscanf.o:		fscanf.c $(HDRS)
fseek.o:		fseek.c $(HDRS)
fsetpos.o:		fsetpos.c $(HDRS)
ftell.o:		ftell.c $(HDRS)
fwrite.o:		fwrite.c $(HDRS)
getenv.o:		getenv.c $(HDRS)
getopt.o:		getopt.c $(HDRS)
gets.o:			gets.c $(HDRS)
isalnum.o:		isalnum.c $(HDRS)
isalpha.o:		isalpha.c $(HDRS)
iscntrl.o:		iscntrl.c $(HDRS)
isdigit.o:		isdigit.c $(HDRS)
isgraph.o:		isgraph.c $(HDRS)
islower.o:		islower.c $(HDRS)
isprint.o:		isprint.c $(HDRS)
ispunct.o:		ispunct.c $(HDRS)
isspace.o:		isspace.c $(HDRS)
isupper.o:		isupper.c $(HDRS)
isxdigit.o:		isxdigit.c $(HDRS)
isatty.o:		isatty.c $(HDRS)
malloc.o:		malloc.c $(HDRS)
memchr.o:		memchr.c $(HDRS)
memcmp.o:		memcmp.c $(HDRS)
modf.o:			modf.c $(HDRS)
mktemp.o:		mktemp.c $(HDRS)
perror.o:		perror.c $(HDRS)
printf.o:		printf.c $(HDRS)
puts.o:			puts.c $(HDRS)
qsort.o:		qsort.c $(HDRS)
raise.o:		raise.c $(HDRS)
rand.o:			rand.c $(HDRS)
remove.o:		remove.c $(HDRS)
rewind.o:		rewind.c $(HDRS)
scanf.o:		scanf.c $(HDRS)
setbuf.o:		setbuf.c $(HDRS)
setvbuf.o:		setvbuf.c $(HDRS)
sigaction.o:		sigaction.c $(HDRS)
sigemptyset.o:		sigemptyset.c $(HDRS)
signal.o:		signal.c $(HDRS)
sprintf.o:		sprintf.c $(HDRS)
sscanf.o:		sscanf.c $(HDRS)
stdio.o:		stdio.c $(HDRS)
strcat.o:		strcat.c $(HDRS)
strchr.o:		strchr.c $(HDRS)
strcmp.o:		strcmp.c $(HDRS)
strcpy.o:		strcpy.c $(HDRS)
strerror.o:		strerror.c $(HDRS)
strftime.o:		strftime.c $(HDRS)
strlen.o:		strlen.c $(HDRS)
strncat.o:		strncat.c $(HDRS)
strncmp.o:		strncmp.c $(HDRS)
strncpy.o:		strncpy.c $(HDRS)
strrchr.o:		strrchr.c $(HDRS)
strtod.o:		strtod.c $(HDRS)
strtof.o:		strtof.c $(HDRS)
strtol.o:		strtol.c $(HDRS)
tcgetattr.o:		tcgetattr.c $(HDRS)
tolower.o:		tolower.c $(HDRS)
toupper.o:		toupper.c $(HDRS)
ungetc.o:		ungetc.c $(HDRS)
vfprintf.o:		vfprintf.c $(HDRS)
vfscanf.o:		vfscanf.c $(HDRS)
vsprintf.o:		vsprintf.c $(HDRS)
wait.o:			wait.c $(HDRS)
