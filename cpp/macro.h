/*****************************************************************************

  macro.h                                             tahoe/64 c preprocessor

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef MACRO_H
#define MACRO_H

#include "token.h"
#include "vstring.h"

typedef int macro_flags;    /* MACRO_* */

#define MACRO_HAS_ARGS          0x80000000
#define MACRO_PREDEF_STDC       0x00000020
#define MACRO_PREDEF_LINE       0x00000010
#define MACRO_PREDEF_FILE       0x00000008
#define MACRO_PREDEF_DATE       0x00000004
#define MACRO_PREDEF_TIME       0x00000002
#define MACRO_PREDEF_DEFINED    0x00000001
#define MACRO_PREDEF_MASK       0x0000003F

struct macro
{
    struct vstring name;
    macro_flags flags;
    struct list formals;        /* formal argument names (TOKEN_IDENTs) */
    struct list tokens;         /* replacement token sequence */
    TAILQ_ENTRY(macro) links;
};

extern void macro_predef(void);
extern struct macro *macro_lookup(struct vstring *);
extern void macro_define(struct list *);
extern int macro_cmdline(char *);
extern void macro_undef(struct list *);
extern int macro_replace(struct list *);
extern void macro_replace_all(struct list *);

/* we have to exclude 'defined' because it's not
   technically defined. there's an irony here.. */

#define MACRO_DEFINED(m)    (!((m)->flags & MACRO_PREDEF_DEFINED))

#endif /* MACRO_H */

/* vi: set ts=4 expandtab: */
