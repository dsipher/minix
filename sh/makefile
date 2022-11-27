##############################################################################
#
#                                                                 minix shell
#
##############################################################################

all:	sh

clean:
	rm -f sh *.o

HDRS=	builtins.h error.h eval.h exec.h expand.h		\
	init.h input.h jobs.h machdep.h mail.h main.h 		\
	memalloc.h mystring.h nodes.h options.h 		\
	output.h parser.h redir.h shell.h signames.h 		\
	syntax.h token.h trap.h var.h

OBJS=	builtins.o cd.o error.o eval.o exec.o expand.o		\
	init.o input.o jobs.o mail.o main.o memalloc.o  	\
	miscbltin.o mystring.o nodes.o options.o output.o  	\
	parser.o redir.o signames.o syntax.o trap.o var.o

builtins.o:	builtins.c	$(HDRS)
cd.o:		cd.c		$(HDRS)
error.o:	error.c		$(HDRS)
eval.o:		eval.c		$(HDRS)
exec.o:		exec.c		$(HDRS)
expand.o:	expand.c	$(HDRS)
init.o:		init.c		$(HDRS)
input.o:	input.c		$(HDRS)
jobs.o:		jobs.c		$(HDRS)
mail.o:		mail.c		$(HDRS)
main.o:		main.c		$(HDRS)
memalloc.o:	memalloc.c	$(HDRS)
miscbltin.o:	miscbltin.c	$(HDRS)
mystring.o:	mystring.c	$(HDRS)
nodes.o:	nodes.c		$(HDRS)
options.o:	options.c	$(HDRS)
output.o:	output.c	$(HDRS)
parser.o:	parser.c	$(HDRS)
redir.o:	redir.c		$(HDRS)
signames.o:	signames.c	$(HDRS)
syntax.o:	syntax.c	$(HDRS)
trap.o:		trap.c		$(HDRS)
var.o:		var.c		$(HDRS)

sh: $(OBJS)
	$(CC) $(CFLAGS) -o sh $(OBJS)
