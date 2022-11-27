##############################################################################
#
#                                                                   minix awk
#
##############################################################################

HOSTCC=$(CC)

all:	awk

clean:
	rm -f awk *.o y.tab.c y.tab.h proctab.c maketab

HDRS=	awk.h y.tab.h proto.h
OBJS=	b.o main.o parse.o proctab.o tran.o lib.o run.o lex.c y.tab.o

b.o:		b.c 		$(HDRS)
lex.o:		lex.c		$(HDRS)
lib.o:		lib.c		$(HDRS)
main.o:		main.c		$(HDRS)
parse.o:	parse.c		$(HDRS)
proctab.o:	proctab.c 	$(HDRS)
run.o:		run.c		$(HDRS)
tran.o:		tran.c		$(HDRS)
y.tab.o:	y.tab.c		$(HDRS)

y.tab.h y.tab.c: awkgram.y
	$(YACC) -d awkgram.y

maketab: maketab.c $(HDRS)
	$(HOSTCC) -o maketab maketab.c

proctab.c: maketab
	./maketab >proctab.c

awk: $(OBJS)
	$(CC) $(CFLAGS) -o awk $(OBJS)

