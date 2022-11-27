##############################################################################
#
#                                                             minix assembler
#
##############################################################################

HOSTCC=$(CC)

all:	as

clean:
	rm -f as *.o y.tab.* lex.yy.c mktable table.c
	rm -rf regress/a.out
	rm -rf regress/*.bin
	rm -rf regress/*.gas

HDRS=	as.h y.tab.h ../include/crc32c.h ../include/a.out.h
OBJS=	as.o insns.o lex.yy.o y.tab.o table.o crc32c.o

as.o:  		as.c $(HDRS)
insns.o:	insns.c $(HDRS)
lex.yy.o:	lex.yy.c $(HDRS)
y.tab.o:	y.tab.c $(HDRS)
table.o:	table.c $(HDRS)

crc32c.o: ../libc/crc32c.c $(HDRS)
	$(CC) $(CFLAGS) -c -o crc32c.o ../libc/crc32c.c

y.tab.h y.tab.c: grammar.y
	$(YACC) -d grammar.y

lex.yy.c: tokens.l
	$(LEX) tokens.l

# FIXME: we only need HOSTCC for cross-builds.
# once removed, the dependency should be on
# crc32c.o, not on the libc/crc32c.c source.

table.c: mktable.c ../libc/crc32c.c $(HDRS)
	$(HOSTCC) -o mktable mktable.c ../libc/crc32c.c
	./mktable >table.c

as: $(OBJS)
	$(CC) $(CFLAGS) -o as $(OBJS)
