##############################################################################
#
#                                                         ux/64 tape archiver
#
##############################################################################

all:	tar

clean:
	rm -f tar *.o

HDRS	=	tar.h port.h

OBJS	=	buffer.o create.o extract.o getoldopt.o \
		list.o names.o tar.o wildmat.o

buffer.o:	buffer.c $(HDRS)
create.o:	create.c $(HDRS)
extract.o:	extract.c $(HDRS)
getoldopt.o:	getoldopt.c $(HDRS)
list.o:		list.c $(HDRS)
names.o:	names.c $(HDRS)
tar.o:		tar.c $(HDRS)
wildmat.o:	wildmat.c $(HDRS)

tar:	$(OBJS)
	$(CC) $(CFLAGS) -o tar $(OBJS)
