##############################################################################
#
#                                                            tahoe/64 yacc
#
##############################################################################

all:	yacc

clean:
	rm -f *.o yacc

HDRS=	defs.h

OBJS=	closure.o error.o lalr.o lr0.o 			\
	main.o mkpar.o output.o reader.o 		\
	skeleton.o symtab.o verbose.o warshall.o

closure.o:	closure.c $(HDRS)
error.o:	error.c $(HDRS)
lalr.o:		lalr.c $(HDRS)
lr0.o:		lr0.c $(HDRS)
main.o:		main.c $(HDRS)
mkpar.o:	mkpar.c $(HDRS)
output.o:	output.c $(HDRS)
reader.o:	reader.c $(HDRS)
skeleton.o:	skeleton.c $(HDRS)
symtab.o:	symtab.c $(HDRS)
verbose.o:	verbose.c $(HDRS)
warshall.o:	warshall.c $(HDRS)

yacc: $(OBJS)
	$(CC) $(CFLAGS) -o yacc $(OBJS)
