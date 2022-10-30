/*****************************************************************************

   nodes.h                                                     ux/64 shell

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

#define NSEMI 0
#define NCMD 1
#define NPIPE 2
#define NREDIR 3
#define NBACKGND 4
#define NSUBSHELL 5
#define NAND 6
#define NOR 7
#define NIF 8
#define NWHILE 9
#define NUNTIL 10
#define NFOR 11
#define NCASE 12
#define NCLIST 13
#define NDEFUN 14
#define NARG 15
#define NTO 16
#define NFROM 17
#define NAPPEND 18
#define NTOFD 19
#define NFROMFD 20
#define NHERE 21
#define NXHERE 22



struct nbinary {
      int type;
      union node *ch1;
      union node *ch2;
};


struct ncmd {
      int type;
      int backgnd;
      union node *args;
      union node *redirect;
};


struct npipe {
      int type;
      int backgnd;
      struct nodelist *cmdlist;
};


struct nredir {
      int type;
      union node *n;
      union node *redirect;
};


struct nif {
      int type;
      union node *test;
      union node *ifpart;
      union node *elsepart;
};


struct nfor {
      int type;
      union node *args;
      union node *body;
      char *var;
};


struct ncase {
      int type;
      union node *expr;
      union node *cases;
};


struct nclist {
      int type;
      union node *next;
      union node *pattern;
      union node *body;
};


struct narg {
      int type;
      union node *next;
      char *text;
      struct nodelist *backquote;
};


struct nfile {
      int type;
      union node *next;
      int fd;
      union node *fname;
      char *expfname;
};


struct ndup {
      int type;
      union node *next;
      int fd;
      int dupfd;
};


struct nhere {
      int type;
      union node *next;
      int fd;
      union node *doc;
};


union node {
      int type;
      struct nbinary nbinary;
      struct ncmd ncmd;
      struct npipe npipe;
      struct nredir nredir;
      struct nif nif;
      struct nfor nfor;
      struct ncase ncase;
      struct nclist nclist;
      struct narg narg;
      struct nfile nfile;
      struct ndup ndup;
      struct nhere nhere;
};


struct nodelist {
	struct nodelist *next;
	union node *n;
};


union node *copyfunc(union node *);
void freefunc(union node *);

/* vi: set ts=4 expandtab: */
