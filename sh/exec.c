/*****************************************************************************

   exec.c                                                      ux/64 shell

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
 * When commands are first encountered, they are entered in a hash table.
 * This ensures that a full path search will not have to be done for them
 * on each invocation.
 *
 * We should investigate converting to a linear search, even though that
 * would make the command name "hash" a misnomer.
 */

#include "shell.h"
#include "main.h"
#include "nodes.h"
#include "parser.h"
#include "redir.h"
#include "eval.h"
#include "exec.h"
#include "builtins.h"
#include "var.h"
#include "options.h"
#include "input.h"
#include "output.h"
#include "syntax.h"
#include "memalloc.h"
#include "error.h"
#include "init.h"
#include "mystring.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <limits.h>


#define CMDTABLESIZE 31     /* should be prime */
#define ARB 1           /* actual size determined at run time */



struct tblentry {
    struct tblentry *next;  /* next entry in hash chain */
    union param param;  /* definition of builtin function */
    short cmdtype;      /* index identifying command */
    char rehash;        /* if set, cd done since entry created */
    char cmdname[ARB];  /* name of command */
};


STATIC struct tblentry *cmdtable[CMDTABLESIZE];
STATIC int builtinloc = -1;     /* index in path of %builtin, or -1 */


STATIC void tryexec(char *, char **, char **);
STATIC void execinterp(char **, char **);
STATIC void printentry(struct tblentry *);
STATIC void clearcmdentry(int);
STATIC struct tblentry *cmdlookup(char *, int);
STATIC void delete_cmd_entry(void);



/*
 * Exec a program.  Never returns.  If you change this routine, you may
 * have to change the find_command routine as well.
 */

void
shellexec(argv, envp, path, index)
    char **argv, **envp;
    char *path;
    {
    char *cmdname;
    int e;

    if (strchr(argv[0], '/') != NULL) {
        tryexec(argv[0], argv, envp);
        e = errno;
    } else {
        e = ENOENT;
        while ((cmdname = padvance(&path, argv[0])) != NULL) {
            if (--index < 0 && pathopt == NULL) {
                tryexec(cmdname, argv, envp);
                if (errno != ENOENT && errno != ENOTDIR)
                    e = errno;
            }
            stunalloc(cmdname);
        }
    }
    error2(argv[0], errmsg(e, E_EXEC));
}


STATIC void
tryexec(cmd, argv, envp)
    char *cmd;
    char **argv;
    char **envp;
    {
    int e;
    char *p;

    execve(cmd, argv, envp);
}


/*
 * Do a path search.  The variable path (passed by reference) should be
 * set to the start of the path before the first call; padvance will update
 * this value as it proceeds.  Successive calls to padvance will return
 * the possible path expansions in sequence.  If an option (indicated by
 * a percent sign) appears in the path entry then the global variable
 * pathopt will be set to point to it; otherwise pathopt will be set to
 * NULL.
 */

char *pathopt;

char *
padvance(path, name)
    char **path;
    char *name;
    {
    register char *p, *q;
    char *start;
    int len;

    if (*path == NULL)
        return NULL;
    start = *path;
    for (p = start ; *p && *p != ':' && *p != '%' ; p++);
    len = p - start + strlen(name) + 2; /* "2" is for '/' and '\0' */
    while (stackblocksize() < len)
        growstackblock();
    q = stackblock();
    if (p != start) {
        bcopy(start, q, p - start);
        q += p - start;
        *q++ = '/';
    }
    strcpy(q, name);
    pathopt = NULL;
    if (*p == '%') {
        pathopt = ++p;
        while (*p && *p != ':')  p++;
    }
    if (*p == ':')
        *path = p + 1;
    else
        *path = NULL;
    return stalloc(len);
}



/*** Command hashing code ***/


hashcmd(argc, argv)  char **argv; {
    struct tblentry **pp;
    struct tblentry *cmdp;
    int c;
    int verbose;
    struct cmdentry entry;
    char *name;

    if (argc <= 1) {
        for (pp = cmdtable ; pp < &cmdtable[CMDTABLESIZE] ; pp++) {
            for (cmdp = *pp ; cmdp ; cmdp = cmdp->next) {
                printentry(cmdp);
            }
        }
        return 0;
    }
    verbose = 0;
    while ((c = nextopt("rv")) != '\0') {
        if (c == 'r') {
            clearcmdentry(0);
        } else if (c == 'v') {
            verbose++;
        }
    }
    while ((name = *argptr) != NULL) {
        if ((cmdp = cmdlookup(name, 0)) != NULL
         && (cmdp->cmdtype == CMDNORMAL
             || cmdp->cmdtype == CMDBUILTIN && builtinloc >= 0))
            delete_cmd_entry();
        find_command(name, &entry, 1);
        if (verbose) {
            if (entry.cmdtype != CMDUNKNOWN) {  /* if no error msg */
                cmdp = cmdlookup(name, 0);
                printentry(cmdp);
            }
            flushall();
        }
        argptr++;
    }
    return 0;
}


STATIC void
printentry(cmdp)
    struct tblentry *cmdp;
    {
    int index;
    char *path;
    char *name;

    if (cmdp->cmdtype == CMDNORMAL) {
        index = cmdp->param.index;
        path = pathval();
        do {
            name = padvance(&path, cmdp->cmdname);
            stunalloc(name);
        } while (--index >= 0);
        out1str(name);
    } else if (cmdp->cmdtype == CMDBUILTIN) {
        out1fmt("builtin %s", cmdp->cmdname);
    } else if (cmdp->cmdtype == CMDFUNCTION) {
        out1fmt("function %s", cmdp->cmdname);
#if DEBUG
    } else {
        error("internal error: cmdtype %d", cmdp->cmdtype);
#endif
    }
    if (cmdp->rehash)
        out1c('*');
    out1c('\n');
}



/*
 * Resolve a command name.  If you change this routine, you may have to
 * change the shellexec routine as well.
 */

void
find_command(name, entry, printerr)
    char *name;
    struct cmdentry *entry;
    {
    struct tblentry *cmdp;
    int index;
    int prev;
    char *path;
    char *fullname;
    struct stat statb;
    int e;
    int i;

    /* If name contains a slash, don't use the hash table */
    if (strchr(name, '/') != NULL) {
        entry->cmdtype = CMDNORMAL;
        entry->u.index = 0;
        return;
    }

    /* If name is in the table, and not invalidated by cd, we're done */
    if ((cmdp = cmdlookup(name, 0)) != NULL && cmdp->rehash == 0)
        goto success;

    /* If %builtin not in path, check for builtin next */
    if (builtinloc < 0 && (i = find_builtin(name)) >= 0) {
        INTOFF;
        cmdp = cmdlookup(name, 1);
        cmdp->cmdtype = CMDBUILTIN;
        cmdp->param.index = i;
        INTON;
        goto success;
    }

    /* We have to search path. */
    prev = -1;      /* where to start */
    if (cmdp) {     /* doing a rehash */
        if (cmdp->cmdtype == CMDBUILTIN)
            prev = builtinloc;
        else
            prev = cmdp->param.index;
    }

    path = pathval();
    e = ENOENT;
    index = -1;
loop:
    while ((fullname = padvance(&path, name)) != NULL) {
        stunalloc(fullname);
        index++;
        if (pathopt) {
            if (prefix("builtin", pathopt)) {
                if ((i = find_builtin(name)) < 0)
                    goto loop;
                INTOFF;
                cmdp = cmdlookup(name, 1);
                cmdp->cmdtype = CMDBUILTIN;
                cmdp->param.index = i;
                INTON;
                goto success;
            } else if (prefix("func", pathopt)) {
                /* handled below */
            } else {
                goto loop;  /* ignore unimplemented options */
            }
        }
        /* if rehash, don't redo absolute path names */
        if (fullname[0] == '/' && index <= prev) {
            if (index < prev)
                goto loop;
            TRACE(("searchexec \"%s\": no change\n", name));
            goto success;
        }
        while (stat(fullname, &statb) < 0) {
            if (errno != ENOENT && errno != ENOTDIR)
                e = errno;
            goto loop;
        }
        e = EACCES; /* if we fail, this will be the error */
        if ((statb.st_mode & S_IFMT) != S_IFREG)
            goto loop;
        if (pathopt) {      /* this is a %func directory */
            stalloc(strlen(fullname) + 1);
            readcmdfile(fullname);
            if ((cmdp = cmdlookup(name, 0)) == NULL || cmdp->cmdtype != CMDFUNCTION)
                error("%s not defined in %s", name, fullname);
            stunalloc(fullname);
            goto success;
        }
        if (statb.st_uid == geteuid()) {
            if ((statb.st_mode & 0100) == 0)
                goto loop;
        } else if (statb.st_gid == getegid()) {
            if ((statb.st_mode & 010) == 0)
                goto loop;
        } else {
            if ((statb.st_mode & 01) == 0)
                goto loop;
        }
        TRACE(("searchexec \"%s\" returns \"%s\"\n", name, fullname));
        INTOFF;
        cmdp = cmdlookup(name, 1);
        cmdp->cmdtype = CMDNORMAL;
        cmdp->param.index = index;
        INTON;
        goto success;
    }

    /* We failed.  If there was an entry for this command, delete it */
    if (cmdp)
        delete_cmd_entry();
    if (printerr)
        outfmt(out2, "%s: %s\n", name, errmsg(e, E_EXEC));
    entry->cmdtype = CMDUNKNOWN;
    return;

success:
    cmdp->rehash = 0;
    entry->cmdtype = cmdp->cmdtype;
    entry->u = cmdp->param;
}



/*
 * Search the table of builtin commands.
 */

int
find_builtin(name)
    char *name;
    {
    const register struct builtincmd *bp;

    for (bp = builtincmd ; bp->name ; bp++) {
        if (*bp->name == *name && equal(bp->name, name))
            return bp->code;
    }
    return -1;
}



/*
 * Called when a cd is done.  Marks all commands so the next time they
 * are executed they will be rehashed.
 */

void
hashcd() {
    struct tblentry **pp;
    struct tblentry *cmdp;

    for (pp = cmdtable ; pp < &cmdtable[CMDTABLESIZE] ; pp++) {
        for (cmdp = *pp ; cmdp ; cmdp = cmdp->next) {
            if (cmdp->cmdtype == CMDNORMAL
             || cmdp->cmdtype == CMDBUILTIN && builtinloc >= 0)
                cmdp->rehash = 1;
        }
    }
}



/*
 * Called before PATH is changed.  The argument is the new value of PATH;
 * pathval() still returns the old value at this point.  Called with
 * interrupts off.
 */

void
changepath(newval)
    char *newval;
    {
    char *old, *new;
    int index;
    int firstchange;
    int bltin;

    old = pathval();
    new = newval;
    firstchange = 9999; /* assume no change */
    index = 0;
    bltin = -1;
    for (;;) {
        if (*old != *new) {
            firstchange = index;
            if (*old == '\0' && *new == ':'
             || *old == ':' && *new == '\0')
                firstchange++;
            old = new;  /* ignore subsequent differences */
        }
        if (*new == '\0')
            break;
        if (*new == '%' && bltin < 0 && prefix("builtin", new + 1))
            bltin = index;
        if (*new == ':') {
            index++;
        }
        new++, old++;
    }
    if (builtinloc < 0 && bltin >= 0)
        builtinloc = bltin;     /* zap builtins */
    if (builtinloc >= 0 && bltin < 0)
        firstchange = 0;
    clearcmdentry(firstchange);
    builtinloc = bltin;
}


/*
 * Clear out command entries.  The argument specifies the first entry in
 * PATH which has changed.
 */

STATIC void
clearcmdentry(firstchange) {
    struct tblentry **tblp;
    struct tblentry **pp;
    struct tblentry *cmdp;

    INTOFF;
    for (tblp = cmdtable ; tblp < &cmdtable[CMDTABLESIZE] ; tblp++) {
        pp = tblp;
        while ((cmdp = *pp) != NULL) {
            if (cmdp->cmdtype == CMDNORMAL && cmdp->param.index >= firstchange
             || cmdp->cmdtype == CMDBUILTIN && builtinloc >= firstchange) {
                *pp = cmdp->next;
                ckfree(cmdp);
            } else {
                pp = &cmdp->next;
            }
        }
    }
    INTON;
}


/*
 * Delete all functions.
 */

#ifdef mkinit
MKINIT void deletefuncs();

SHELLPROC {
    deletefuncs();
}
#endif

void
deletefuncs() {
    struct tblentry **tblp;
    struct tblentry **pp;
    struct tblentry *cmdp;

    INTOFF;
    for (tblp = cmdtable ; tblp < &cmdtable[CMDTABLESIZE] ; tblp++) {
        pp = tblp;
        while ((cmdp = *pp) != NULL) {
            if (cmdp->cmdtype == CMDFUNCTION) {
                *pp = cmdp->next;
                freefunc(cmdp->param.func);
                ckfree(cmdp);
            } else {
                pp = &cmdp->next;
            }
        }
    }
    INTON;
}



/*
 * Locate a command in the command hash table.  If "add" is nonzero,
 * add the command to the table if it is not already present.  The
 * variable "lastcmdentry" is set to point to the address of the link
 * pointing to the entry, so that delete_cmd_entry can delete the
 * entry.
 */

struct tblentry **lastcmdentry;


STATIC struct tblentry *
cmdlookup(name, add)
    char *name;
    {
    int hashval;
    register char *p;
    struct tblentry *cmdp;
    struct tblentry **pp;

    p = name;
    hashval = *p << 4;
    while (*p)
        hashval += *p++;
    hashval &= 0x7FFF;
    pp = &cmdtable[hashval % CMDTABLESIZE];
    for (cmdp = *pp ; cmdp ; cmdp = cmdp->next) {
        if (equal(cmdp->cmdname, name))
            break;
        pp = &cmdp->next;
    }
    if (add && cmdp == NULL) {
        INTOFF;
        cmdp = *pp = ckmalloc(sizeof (struct tblentry) - ARB
                    + strlen(name) + 1);
        cmdp->next = NULL;
        cmdp->cmdtype = CMDUNKNOWN;
        cmdp->rehash = 0;
        strcpy(cmdp->cmdname, name);
        INTON;
    }
    lastcmdentry = pp;
    return cmdp;
}


/*
 * Delete the command entry returned on the last lookup.
 */

STATIC void
delete_cmd_entry() {
    struct tblentry *cmdp;

    INTOFF;
    cmdp = *lastcmdentry;
    *lastcmdentry = cmdp->next;
    ckfree(cmdp);
    INTON;
}



/*
 * Add a new command entry, replacing any existing command entry for
 * the same name.
 */

void
addcmdentry(name, entry)
    char *name;
    struct cmdentry *entry;
    {
    struct tblentry *cmdp;

    INTOFF;
    cmdp = cmdlookup(name, 1);
    if (cmdp->cmdtype == CMDFUNCTION) {
        freefunc(cmdp->param.func);
    }
    cmdp->cmdtype = entry->cmdtype;
    cmdp->param = entry->u;
    INTON;
}


/*
 * Define a shell function.
 */

void
defun(name, func)
    char *name;
    union node *func;
    {
    struct cmdentry entry;

    INTOFF;
    entry.cmdtype = CMDFUNCTION;
    entry.u.func = copyfunc(func);
    addcmdentry(name, &entry);
    INTON;
}


/*
 * Delete a function if it exists.
 */

void
unsetfunc(name)
    char *name;
    {
    struct tblentry *cmdp;

    if ((cmdp = cmdlookup(name, 0)) != NULL && cmdp->cmdtype == CMDFUNCTION) {
        freefunc(cmdp->param.func);
        delete_cmd_entry();
    }
}

/* vi: set ts=4 expandtab: */
