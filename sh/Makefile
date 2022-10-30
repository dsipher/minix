# Makefile for ash.

SRCS=	builtins.c cd.c error.c eval.c exec.c expand.c input.c \
	jobs.c mail.c main.c memalloc.c miscbltin.c mystring.c nodes.c \
	options.c parser.c redir.c show.c signames.c syntax.c trap.c \
	output.c var.c

OBJS=	builtins.o cd.o error.o eval.o exec.o expand.o input.o \
	jobs.o mail.o main.o memalloc.o miscbltin.o mystring.o nodes.o \
	options.o parser.o redir.o show.o signames.o syntax.o trap.o \
	output.o var.o init.o

CFLAGS=	-w -DSHELL -I.

CLEANFILES= $(OBJS) \
	builtins.c builtins.h init.c mkinit

all:	sh

sh:	$(OBJS)
	$(CC) $(CFLAGS) -o sh $(OBJS) $(LIBS)

clean:
	rm -f $(CLEANFILES) sh core

parser.o: token.h

builtins.c builtins.h: builtins.table shell.h
	sh mkbuiltins shell.h builtins.table

init.o: mkinit $(SRCS)
	./mkinit '$(CC) -c $(CFLAGS) init.c' $(SRCS)

mkinit: mkinit.c
	$(CC) $(CFLAGS) -o $@ mkinit.c

# Dependencies you say?  This will have to do.
$(OBJS): error.h eval.h exec.h expand.h init.h input.h \
	jobs.h machdep.h mail.h main.h memalloc.h mystring.h options.h \
	output.h parser.h redir.h shell.h trap.h var.h \
	builtins.h nodes.h signames.h syntax.h

