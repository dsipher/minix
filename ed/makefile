##############################################################################
#
#                                                           ux/64 line editor
#
##############################################################################

all:	ed

clean:
	rm -f ed *.o

HDRS=	ed.h tools.h

OBJS=	amatch.o append.o bitmap.o ed.o

amatch.o:	amatch.c	$(HDRS)
append.o:	append.c	$(HDRS)
bitmap.o:	bitmap.c	$(HDRS)
ed.o: 		ed.c 		$(HDRS)

ed: $(OBJS)
	$(CC) $(CFLAGS) -o ed $(OBJS)

