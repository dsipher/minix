##############################################################################
#
#                                                          ux/64 make utility
#
##############################################################################

OBJS = 	check.o input.o macro.o main.o 	\
	make.o reader.o rules.o archive.o

all:	make

make:	$(OBJS)
	$(CC) -o make $(OBJS)

archive.o:	archive.c  h.h
check.o:	check.c    h.h
input.o:	input.c    h.h
macro.o:	macro.c    h.h
make.o:		make.c 	   h.h
reader.o:	reader.c   h.h
rules.o:  	rules.c    h.h

clean:
	rm -f *.o make
