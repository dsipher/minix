##############################################################################
#
#                                                           ux/64 line editor
#
##############################################################################

all:	ed

clean:
	rm -f ed *.o

HDRS=	ed.h tools.h

OBJS=	amatch.o append.o bitmap.o catsub.o ckglob.o 	\
	deflt.o del.o docmd.o ed.o

amatch.o:	amatch.c	$(HDRS)
append.o:	append.c	$(HDRS)
bitmap.o:	bitmap.c	$(HDRS)
catsub.o:	catsub.c	$(HDRS)
ckglob.o:	ckglob.c	$(HDRS)
deflt.o:	deflt.c		$(HDRS)
del.o:		del.c 		$(HDRS)
docmd.o:	docmd.c		$(HDRS)
ed.o: 		ed.c 		$(HDRS)

ed: $(OBJS)
	$(CC) $(CFLAGS) -o ed $(OBJS)

