/*****************************************************************************

   var.h                                                       minix shell

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
 * Shell variables.
 */

/* flags */
#define VEXPORT     01  /* variable is exported */
#define VREADONLY   02  /* variable cannot be modified */
#define VSTRFIXED   04  /* variable struct is staticly allocated */
#define VTEXTFIXED  010 /* text is staticly allocated */
#define VSTACK      020 /* text is allocated on the stack */
#define VUNSET      040 /* the variable is not set */


struct var {
    struct var *next;       /* next entry in hash list */
    int flags;      /* flags are defined above */
    char *text;     /* name=value */
};


struct localvar {
    struct localvar *next;  /* next local variable in list */
    struct var *vp;     /* the variable that was made local */
    int flags;      /* saved flags */
    char *text;     /* saved text */
};


extern struct localvar *localvars;

extern struct var vifs;
extern struct var vmail;
extern struct var vmpath;
extern struct var vpath;
extern struct var vps1;
extern struct var vps2;
extern struct var vpse;

/*
 * The following macros access the values of the above variables.
 * They have to skip over the name.  They return the null string
 * for unset variables.
 */

#define ifsval()    (vifs.text + 4)
#define mailval()   (vmail.text + 5)
#define mpathval()  (vmpath.text + 9)
#define pathval()   (vpath.text + 5)
#define ps1val()    (vps1.text + 4)
#define ps2val()    (vps2.text + 4)
#define pseval()    (vpse.text + 4)

#define mpathset()  ((vmpath.flags & VUNSET) == 0)


void initvar();
void setvar(char *, char *, int);
void setvareq(char *, int);
struct strlist;
void listsetvar(struct strlist *);
char *lookupvar(char *);
char *bltinlookup(char *, int);
char **environment();
int showvarscmd(int, char **);
int unsetvarcmd(int, char **);
int unsetcmd(int, char **);
void mklocal(char *);
void poplocalvars(void);

/* vi: set ts=4 expandtab: */
