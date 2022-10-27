##############################################################################
#
#                                                                   ux/64 sed
#
##############################################################################

all:	sed

clean:
	rm -f sed *.o

HDRS=	sed.h
OBJS=	comp.o exec.o

comp.o:	comp.c $(HDRS)
exec.o:	exec.c $(HDRS)

sed: $(OBJS)
	$(CC) $(CFLAGS) -o sed $(OBJS)

