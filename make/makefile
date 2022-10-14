##############################################################################
#
#                                                       jewel/os make utility
#
##############################################################################

CFLAGS = -O -Dunix

OBJ =	check.o input.o macro.o main.o make.o reader.o rules.o archive.o

all:	make

make:	$(OBJ)
	$(CC) -o make $(OBJ)

$(OBJ): h.h

clean:
	rm -f *.o make
