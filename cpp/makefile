##############################################################################
#
#                                                     tahoe/64 c preprocessor
#
#    Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.
#
##############################################################################

all:	cpp

clean:
	rm -f cpp *.o

HDRS=	cpp.h directive.h evaluate.h input.h macro.h token.h vstring.h
OBJS=	cpp.o directive.o evaluate.o input.o macro.o token.o vstring.o

cpp.o: 		cpp.c $(HDRS)
directive.o:	directive.c $(HDRS)
evaluate.o:	evaluate.c $(HDRS)
input.o:	input.c $(HDRS)
macro.o:	macro.c $(HDRS)
token.o:	token.c $(HDRS)
vstring.o:	vstring.c $(HDRS)

cpp: $(OBJS)
	$(CC) $(CFLAGS) -o cpp $(OBJS)

