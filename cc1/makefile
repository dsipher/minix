##############################################################################
#
#                                                      tahoe/64 c compiler
#
##############################################################################

all:	cc1

clean:
	rm -f cc1 *.o
	rm -rf regress/stage1
	rm -rf regress/stage2
	rm -rf regress/stage3/bin
	rm -rf regress/stage3/lib
	rm -rf regress/stage3/include

HDRS=	cc1.h block.h builtin.h cmov.h cmp.h dealias.h 			\
	decl.h delay.h dep.h dom.h dvn.h expr.h fold.h 			\
	func.h fuse.h gen.h graph.h heap.h hoist.h init.h 		\
	insn.h lex.h live.h lower.h norm.h opt.h peep.h			\
	prop.h reach.h reassoc.h reg.h stmt.h string.h			\
	switch.h symbol.h tree.h type.h zlq.h

OBJS=	cc1.o block.o builtin.o cmov.o cmp.o dealias.o 			\
	decl.o delay.o dep.o dom.o dvn.o expr.o fold.o 			\
	func.o fuse.o gen.o graph.o heap.o hoist.o init.o 		\
	insn.o lex.o live.o lower.o norm.o opt.o peep.o			\
	prop.o reach.o reassoc.o reg.o stmt.o string.o			\
	switch.o symbol.o tree.o type.o zlq.o

cc1.o: 		cc1.c $(HDRS)
block.o:	block.c $(HDRS)
builtin.o:	builtin.c $(HDRS)
cmov.o:		cmov.c $(HDRS)
cmp.o:		cmp.c $(HDRS)
dealias.o:	dealias.c $(HDRS)
decl.o:		decl.c $(HDRS)
delay.o:	delay.c $(HDRS)
dep.o:		dep.c $(HDRS)
dom.o:		dom.c $(HDRS)
dvn.o:		dvn.c $(HDRS)
expr.o:		expr.c $(HDRS)
fold.o:		fold.c $(HDRS)
func.o:		func.c $(HDRS)
fuse.o:		fuse.c $(HDRS)
gen.o:		gen.c $(HDRS)
graph.o:	graph.c $(HDRS)
heap.o: 	heap.c $(HDRS)
hoist.o:	hoist.c $(HDRS)
init.o:		init.c $(HDRS)
insn.o:		insn.c $(HDRS)
lex.o:		lex.c $(HDRS)
live.o:		live.c $(HDRS)
lower.o:	lower.c $(HDRS)
norm.o:		norm.c $(HDRS)
opt.o:		opt.c $(HDRS)
peep.o:		peep.c $(HDRS)
prop.o:		prop.c $(HDRS)
reach.o:	reach.c $(HDRS)
reassoc.o:	reassoc.c $(HDRS)
reg.o:		reg.c $(HDRS)
stmt.o:		stmt.c $(HDRS)
string.o:	string.c $(HDRS)
switch.o:	switch.c $(HDRS)
symbol.o:	symbol.c $(HDRS)
tree.o:		tree.c $(HDRS)
type.o: 	type.c $(HDRS)
zlq.o:		zlq.c $(HDRS)

cc1: $(OBJS)
	$(CC) $(CFLAGS) -o cc1 $(OBJS)

