##############################################################################
#
#                                                             jewel/os lex
#
##############################################################################

CFLAGS=-DROOT=\"$(ROOT)\"

all:	lex

clean:
	rm -f y.tab.c y.tab.h scan.c *.o lex

OBJS=	ccl.o dfa.o ecs.o gen.o 	\
	main.o misc.o nfa.o scan.o 	\
	sym.o tblcmp.o y.tab.o yylex.o

ccl.o:		ccl.c 		flexdef.h y.tab.h
dfa.o:		dfa.c 		flexdef.h y.tab.h
ecs.o:		ecs.c 		flexdef.h y.tab.h
gen.o:		gen.c 		flexdef.h y.tab.h
main.o:		main.c 		flexdef.h y.tab.h
misc.o:		misc.c 		flexdef.h y.tab.h
nfa.o:		nfa.c 		flexdef.h y.tab.h
scan.o:		scan.c 		flexdef.h y.tab.h
sym.o: 		sym.c  		flexdef.h y.tab.h
tblcmp.o:	tblcmp.c	flexdef.h y.tab.h
y.tab.o:	y.tab.c		flexdef.h y.tab.h
yylex.o:	yylex.c		flexdef.h y.tab.h

# n.b.: when working on lex itself the following rule
# should be rewritten to generate scan.c from scan.l.

scan.c:	initscan.c
	cp initscan.c scan.c

y.tab.c y.tab.h: parse.y
	$(YACC) -d parse.y

lex: $(OBJS)
	$(CC) $(CFLAGS) -o lex $(OBJS)
