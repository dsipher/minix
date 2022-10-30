/*****************************************************************************

   memalloc.h                                                  ux/64 shell

******************************************************************************

   derived from ash, contributed to Berkeley by Kenneth Almquist.
   Copyright (c) 1991 The Regents of the University of California.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

struct stackmark {
    struct stack_block *stackp;
    char *stacknxt;
    int stacknleft;
};


extern char *stacknxt;
extern int stacknleft;
extern int sstrnleft;
extern int herefd;

pointer ckmalloc(int);
pointer ckrealloc(pointer, int);
void free(pointer);     /* defined in C library */
char *savestr(char *);
pointer stalloc(int);
void stunalloc(pointer);
void setstackmark(struct stackmark *);
void popstackmark(struct stackmark *);
void growstackblock(void);
void grabstackblock(int);
char *growstackstr(void);
char *makestrspace(void);
void ungrabstackstr(char *, char *);



#define stackblock() stacknxt
#define stackblocksize() stacknleft
#define STARTSTACKSTR(p)    p = stackblock(), sstrnleft = stackblocksize()
#define STPUTC(c, p)    (--sstrnleft >= 0? (*p++ = (c)) : (p = growstackstr(), *p++ = (c)))
#define CHECKSTRSPACE(n, p) if (sstrnleft < n) p = makestrspace(); else
#define USTPUTC(c, p)   (--sstrnleft, *p++ = (c))
#define STACKSTRNUL(p)  (sstrnleft == 0? (p = growstackstr(), *p = '\0') : (*p = '\0'))
#define STUNPUTC(p) (++sstrnleft, --p)
#define STTOPC(p)   p[-1]
#define STADJUST(amount, p) (p += (amount), sstrnleft -= (amount))
#define grabstackstr(p) stalloc(stackblocksize() - sstrnleft)

#define ckfree(p)   free((pointer)(p))

/* vi: set ts=4 expandtab: */
