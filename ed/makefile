##############################################################################
#
#                                                           minix line editor
#
##############################################################################

all:	ed

clean:
	rm -f ed *.o

HDRS=	ed.h tools.h

OBJS=	amatch.o append.o bitmap.o catsub.o ckglob.o deflt.o 	\
	del.o docmd.o dodash.o doglob.o doprnt.o doread.o 	\
	dowrite.o ed.o egets.o esc.o find.o getfn.o getlst.o	\
	getnum.o getone.o getpat.o getptr.o getrhs.o gettxt.o	\
	ins.o join.o makepat.o maksub.o matchs.o move.o 	\
	omatch.o optpat.o set.o setbuf.o subst.o sys.o unmkpat.o

amatch.o:	amatch.c	$(HDRS)
append.o:	append.c	$(HDRS)
bitmap.o:	bitmap.c	$(HDRS)
catsub.o:	catsub.c	$(HDRS)
ckglob.o:	ckglob.c	$(HDRS)
deflt.o:	deflt.c		$(HDRS)
del.o:		del.c 		$(HDRS)
docmd.o:	docmd.c		$(HDRS)
dodash.o:	dodash.c	$(HDRS)
doglob.o:	doglob.c	$(HDRS)
doprnt.o:	doprnt.c	$(HDRS)
doread.o:	doread.c	$(HDRS)
dowrite.o:	dowrite.c	$(HDRS)
ed.o: 		ed.c 		$(HDRS)
egets.o:	egets.c		$(HDRS)
esc.o:		esc.c		$(HDRS)
find.o:		find.c		$(HDRS)
getfn.o:	getfn.c 	$(HDRS)
getlst.o:	getlst.c	$(HDRS)
getnum.o:	getnum.c	$(HDRS)
getone.o:	getone.c	$(HDRS)
getpat.o:	getpat.c	$(HDRS)
getptr.o:	getptr.c	$(HDRS)
getrhs.o:	getrhs.c	$(HDRS)
gettxt.o:	gettxt.c	$(HDRS)
ins.o:		ins.c		$(HDRS)
join.o:		join.c		$(HDRS)
makepat.o:	makepat.c	$(HDRS)
maksub.o:	maksub.c	$(HDRS)
matchs.o:	matchs.c	$(HDRS)
move.o:		move.c		$(HDRS)
omatch.o:	omatch.c	$(HDRS)
optpat.o:	optpat.c	$(HDRS)
set.o:		set.c		$(HDRS)
setbuf.o:	setbuf.c	$(HDRS)
subst.o:	subst.c		$(HDRS)
unmkpat.o:	unmkpat.c	$(HDRS)
sys.o:		sys.c		$(HDRS)

ed: $(OBJS)
	$(CC) $(CFLAGS) -o ed $(OBJS)

