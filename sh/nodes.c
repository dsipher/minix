/*****************************************************************************

   nodes.c                                                     ux/64 shell

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

/*
 * Routine for dealing with parsed shell commands.
 */

#include "shell.h"
#include "nodes.h"
#include "memalloc.h"
#include "machdep.h"
#include "mystring.h"


int funcblocksize;      /* size of structures in function */
int funcstringsize;     /* size of strings in node */
void *funcblock;        /* block to allocate function from */
char *funcstring;       /* block to allocate strings from */

static const short nodesize[23] = {
      ALIGN(sizeof (struct nbinary)),
      ALIGN(sizeof (struct ncmd)),
      ALIGN(sizeof (struct npipe)),
      ALIGN(sizeof (struct nredir)),
      ALIGN(sizeof (struct nredir)),
      ALIGN(sizeof (struct nredir)),
      ALIGN(sizeof (struct nbinary)),
      ALIGN(sizeof (struct nbinary)),
      ALIGN(sizeof (struct nif)),
      ALIGN(sizeof (struct nbinary)),
      ALIGN(sizeof (struct nbinary)),
      ALIGN(sizeof (struct nfor)),
      ALIGN(sizeof (struct ncase)),
      ALIGN(sizeof (struct nclist)),
      ALIGN(sizeof (struct narg)),
      ALIGN(sizeof (struct narg)),
      ALIGN(sizeof (struct nfile)),
      ALIGN(sizeof (struct nfile)),
      ALIGN(sizeof (struct nfile)),
      ALIGN(sizeof (struct ndup)),
      ALIGN(sizeof (struct ndup)),
      ALIGN(sizeof (struct nhere)),
      ALIGN(sizeof (struct nhere)),
};


STATIC void calcsize(union node *);
STATIC void sizenodelist(struct nodelist *);
STATIC union node *copynode(union node *);
STATIC struct nodelist *copynodelist(struct nodelist *);
STATIC char *nodesavestr(char *);



/*
 * Make a copy of a parse tree.
 */

union node *
copyfunc(n)
      union node *n;
      {
      if (n == NULL)
        return NULL;
      funcblocksize = 0;
      funcstringsize = 0;
      calcsize(n);
      funcblock = ckmalloc(funcblocksize + funcstringsize);
      funcstring = (char *)funcblock + funcblocksize;
      return copynode(n);
}



STATIC void
calcsize(n)
      union node *n;
      {
      if (n == NULL)
     return;
      funcblocksize += nodesize[n->type];
      switch (n->type) {
      case NSEMI:
      case NAND:
      case NOR:
      case NWHILE:
      case NUNTIL:
	    calcsize(n->nbinary.ch2);
	    calcsize(n->nbinary.ch1);
	    break;
      case NCMD:
	    calcsize(n->ncmd.redirect);
	    calcsize(n->ncmd.args);
	    break;
      case NPIPE:
	    sizenodelist(n->npipe.cmdlist);
	    break;
      case NREDIR:
      case NBACKGND:
      case NSUBSHELL:
	    calcsize(n->nredir.redirect);
	    calcsize(n->nredir.n);
	    break;
      case NIF:
	    calcsize(n->nif.elsepart);
	    calcsize(n->nif.ifpart);
	    calcsize(n->nif.test);
	    break;
      case NFOR:
	    funcstringsize += strlen(n->nfor.var) + 1;
	    calcsize(n->nfor.body);
	    calcsize(n->nfor.args);
	    break;
      case NCASE:
	    calcsize(n->ncase.cases);
	    calcsize(n->ncase.expr);
	    break;
      case NCLIST:
	    calcsize(n->nclist.body);
	    calcsize(n->nclist.pattern);
	    calcsize(n->nclist.next);
	    break;
      case NDEFUN:
      case NARG:
	    sizenodelist(n->narg.backquote);
	    funcstringsize += strlen(n->narg.text) + 1;
	    calcsize(n->narg.next);
	    break;
      case NTO:
      case NFROM:
      case NAPPEND:
	    calcsize(n->nfile.fname);
	    calcsize(n->nfile.next);
	    break;
      case NTOFD:
      case NFROMFD:
	    calcsize(n->ndup.next);
	    break;
      case NHERE:
      case NXHERE:
	    calcsize(n->nhere.doc);
	    calcsize(n->nhere.next);
	    break;
      };
}



STATIC void
sizenodelist(lp)
      struct nodelist *lp;
      {
      while (lp) {
        funcblocksize += ALIGN(sizeof (struct nodelist));
        calcsize(lp->n);
        lp = lp->next;
      }
}



STATIC union node *
copynode(n)
      union node *n;
      {
      union node *new;

      if (n == NULL)
     return NULL;
      new = funcblock;
      *(char **)&funcblock += nodesize[n->type];
      switch (n->type) {
      case NSEMI:
      case NAND:
      case NOR:
      case NWHILE:
      case NUNTIL:
	    new->nbinary.ch2 = copynode(n->nbinary.ch2);
	    new->nbinary.ch1 = copynode(n->nbinary.ch1);
	    break;
      case NCMD:
	    new->ncmd.redirect = copynode(n->ncmd.redirect);
	    new->ncmd.args = copynode(n->ncmd.args);
	    new->ncmd.backgnd = n->ncmd.backgnd;
	    break;
      case NPIPE:
	    new->npipe.cmdlist = copynodelist(n->npipe.cmdlist);
	    new->npipe.backgnd = n->npipe.backgnd;
	    break;
      case NREDIR:
      case NBACKGND:
      case NSUBSHELL:
	    new->nredir.redirect = copynode(n->nredir.redirect);
	    new->nredir.n = copynode(n->nredir.n);
	    break;
      case NIF:
	    new->nif.elsepart = copynode(n->nif.elsepart);
	    new->nif.ifpart = copynode(n->nif.ifpart);
	    new->nif.test = copynode(n->nif.test);
	    break;
      case NFOR:
	    new->nfor.var = nodesavestr(n->nfor.var);
	    new->nfor.body = copynode(n->nfor.body);
	    new->nfor.args = copynode(n->nfor.args);
	    break;
      case NCASE:
	    new->ncase.cases = copynode(n->ncase.cases);
	    new->ncase.expr = copynode(n->ncase.expr);
	    break;
      case NCLIST:
	    new->nclist.body = copynode(n->nclist.body);
	    new->nclist.pattern = copynode(n->nclist.pattern);
	    new->nclist.next = copynode(n->nclist.next);
	    break;
      case NDEFUN:
      case NARG:
	    new->narg.backquote = copynodelist(n->narg.backquote);
	    new->narg.text = nodesavestr(n->narg.text);
	    new->narg.next = copynode(n->narg.next);
	    break;
      case NTO:
      case NFROM:
      case NAPPEND:
	    new->nfile.fname = copynode(n->nfile.fname);
	    new->nfile.fd = n->nfile.fd;
	    new->nfile.next = copynode(n->nfile.next);
	    break;
      case NTOFD:
      case NFROMFD:
	    new->ndup.dupfd = n->ndup.dupfd;
	    new->ndup.fd = n->ndup.fd;
	    new->ndup.next = copynode(n->ndup.next);
	    break;
      case NHERE:
      case NXHERE:
	    new->nhere.doc = copynode(n->nhere.doc);
	    new->nhere.fd = n->nhere.fd;
	    new->nhere.next = copynode(n->nhere.next);
	    break;
      };
      new->type = n->type;
      return new;
}


STATIC struct nodelist *
copynodelist(lp)
      struct nodelist *lp;
      {
      struct nodelist *start;
      struct nodelist **lpp;

      lpp = &start;
      while (lp) {
        *lpp = funcblock;
        *(char **)&funcblock += ALIGN(sizeof (struct nodelist));
        (*lpp)->n = copynode(lp->n);
        lp = lp->next;
        lpp = &(*lpp)->next;
      }
      *lpp = NULL;
      return start;
}



STATIC char *
nodesavestr(s)
      char *s;
      {
      register char *p = s;
      register char *q = funcstring;
      char *rtn = funcstring;

      while (*q++ = *p++);
      funcstring = q;
      return rtn;
}



/*
 * Free a parse tree.
 */

void
freefunc(n)
      union node *n;
      {
      if (n)
        ckfree(n);
}

/* vi: set ts=4 expandtab: */
