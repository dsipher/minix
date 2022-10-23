/*****************************************************************************

   symbol.h                                               ux/64 c compiler

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

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

#ifndef SYMBOL_H
#define SYMBOL_H

#include "heap.h"

/* for simplicity, we place an arbitrary limit on the scope nesting depth, and
   further, we restrict it to <= BITS_PER_LONG to keep strun_scopes scalar. to
   comply with C89 5.2.4.1, NR_SCOPES must be ~ 16; we're fine there. */

#define NR_SCOPES       BITS_PER_LONG

extern int current_scope;
extern int outer_scope;

/* LURKER_SCOPE is for global symbols which are declared in inner scopes
   but which are not currently visible at file scope. FILE_SCOPE is file
   scope, and LOCAL_SCOPE .. MAX_SCOPE are for transient scopes. the latter
   scopes may be block scopes, struct/union scopes (during definitions), or
   function prototype scopes. during a function definition, LOCAL_SCOPE is
   always the outermost block scope of that function. */

#define LURKER_SCOPE    0
#define FILE_SCOPE      1
#define LOCAL_SCOPE     2
#define MAX_SCOPE       (NR_SCOPES - 1)

/* S_* constants are called storage classes, though they really represent a
   symbol's 'kind' as much as its storage class. the base bits of a storage
   class are mutually exclusive, but they are given distinct bits, so we can
   easily refer to groups of related classes (e.g., in namespaces). */

    /* struct/union/enum tags live in their own namespace */

#define S_STRUCT        0x00000001
#define S_UNION         0x00000002
#define S_ENUM          0x00000004

#define S_TAG           ( S_STRUCT | S_UNION | S_ENUM )

    /* S_LOCAL is the storage class assigned to a block-level variable
       declared with no explicit storage class. if its address is taken,
       it is demoted to S_AUTO; otherwise it is promoted to S_REGISTER
       when the current function parse is done (cheap alias analysis).

       S_CONSTs are enumeration constants (do not confuse with T_CONST).

       S_REDIRECTs are placeholders for symbols declared 'extern' in local
       scopes. they redirect to symbols in LURKER_SCOPE or FILE_SCOPE. */

#define S_TYPEDEF       0x00000008
#define S_STATIC        0x00000010
#define S_EXTERN        0x00000020
#define S_AUTO          0x00000040
#define S_REGISTER      0x00000080
#define S_LOCAL         0x00000100
#define S_CONST         0x00000200
#define S_REDIRECT      0x00000400

    /* these all share the 'normal' namespace */

#define S_NORMAL        ( S_TYPEDEF | S_STATIC | S_EXTERN | S_AUTO          \
                        | S_REGISTER | S_LOCAL | S_CONST | S_REDIRECT )

    /* local block-level symbols */

#define S_BLOCK         ( S_AUTO | S_REGISTER | S_LOCAL )

    /* strun members and c labels live in their own separate worlds */

#define S_MEMBER        0x00000800
#define S_LABEL         0x00001000

    /* in a symbol table entry, exactly one base bit will be set */

#define S_BASE_MASK     0x00001FFF
#define S_BASE(s)       ((s) & S_BASE_MASK)

    /* flag: set on symbols whose registers should not be spilled. */

#define S_NOSPILL       0x00080000

    /* flag: set on hidden argument for struct-return */

#define S_HIDDEN        0x00100000

    /* flag: set on temporary symbols, created with temp() */

#define S_TEMP          0x00200000

    /* flag: set on a struct/union tag if it has const members.
       a bit of a misnomer, since only part of it is immutable */

#define S_IMMUTABLE     0x00400000

    /* flag: set on a global function symbol if it has been
       implicitly declared at least once. for warnings only. */

#define S_IMPLICIT      0x00800000

    /* flag: set on old-style arguments declared float to remind us
       that we need to cast it on entry. see old_arg() in decl.c */

#define S_FIXFLOAT      0x01000000

    /* flag: set on S_MEMBERs which are absorbed from anonymous struns.
       called S_SKIP because we skip over them while parsing initializers. */

#define S_SKIP          0x02000000

    /* flag: set on S_STRUCT or S_UNION types when the last member
       is an unbounded array, i.e., a flexible array member (C99) */

#define S_FLEXIBLE      0x04000000

    /* flag: local is an argument to the current function */

#define S_ARG           0x08000000

    /* flag: a tentative definition for the symbol has been seen. this is
       not reset if an actual definition is seen, so S_DEFINED overrides */

#define S_TENTATIVE     0x10000000

    /* flag: set if symbol has been referenced in an expression */

#define S_REFERENCED    0x20000000

    /* flag: symbol has been defined. specifics differ depending
       on the storage class, but has the expected meaning */

#define S_DEFINED       0x40000000

/* symbols cover a lot of ground. the storage
   class determines which fields are valid. */

DEFINE_VECTOR(symbol, struct symbol *);

struct symbol
{
    struct string *id;          /* can be 0 if anonymous */
    int scope;                  /* *_SCOPE (when in symtab) */
    int s;                      /* S_* storage class */

    int num;                    /* unique identifier (for debug only) */

    int line_no;                /* where the symbol was first seen */
    struct string *path;        /* or was defined (if S_DEFINED) */

    union
    {
        /* all storage classes except S_TAGs use this first layout */

        struct
        {
            struct tnode *type;     /* if applicable, 0 otherwise */

            int reg;                /* assigned pseudo-register and its */
            int generation;         /* generation: see symbol_to_reg() */

            union
            {
                int asmlab;         /* S_STATIC */
                int value;          /* S_CONST */
                int offset;         /* S_MEMBER/S_AUTO/S_REGISTER/S_LOCAL */
                struct block *b;                /* S_LABEL */
                struct symbol *redirect;        /* S_REDIRECT */
            };
        };

        /* S_TAGs get their own layout. (S_ENUMs have no data here.)
           struct/union members attach here: the same members in two
           lists. the chain (as always) is in declaration order, for
           initializers. the members list is in MRU order, for lookups.

           these fields are in flux and used as working storage by the
           parser until the symbol is S_DEFINED and they are frozen. */

        struct
        {
            int size;           /* these are in bytes, except when ... */
            int align;          /* ... not S_DEFINED, size is in bits */

            struct symbol *chain;
            struct symbol *members;
        };
    };

    struct symbol *link;            /* chain link, in declaration order */
    struct symbol **prev, *next;    /* symbol table or member list links */
};

#define DEFINED_SYMBOL(sym)             ((sym)->s & S_DEFINED)
#define TAG_SYMBOL(sym)                 ((sym)->s & S_TAG)
#define TEMP_SYMBOL(sym)                ((sym)->s & S_TEMP)
#define STRUCT_SYMBOL(sym)              ((sym)->s & S_STRUCT)
#define NOSPILL_SYMBOL(sym)             ((sym)->s & S_NOSPILL)

#define FLEXIBLE_STRUCT_SYMBOL(sym)     (STRUCT_SYMBOL(sym) &&              \
                                         ((sym)->s & S_FLEXIBLE))

/* update the symbol's reference location to 'right here' */

#define HERE_SYMBOL(sym)                do {                                \
                                            (sym)->path = path;             \
                                            (sym)->line_no = line_no;       \
                                        } while (0)

/* we assume everything is aliased unless it's S_REGISTER. */

#define ALIASED_SYMBOL(sym)             (!(sym->s & S_REGISTER))

/* allocate and initialize a new symbol with the given id and storage class */

struct symbol *new_symbol(struct string *id, int s);

/* discard chain of symbols. *chainp is nulled for the caller. */

void free_symbols(struct symbol **chainp);

/* insert sym into the symbol table at scope */

void insert(struct symbol *sym, int scope);

/* we need an S_REDIRECT to sym in the
   specified scope- make one if necessary */

void redirect(struct symbol *sym, int scope);

/* find the innermost symbol in the symbol table with the id specified and
   (one of) the storage classes in ss in scopes [inner, outer] inclusive.
   if inner == outer, then that scope is searched; otherwise only non-strun
   scopes are examined. returns 0 if there are no matches. */

struct symbol *lookup(struct string *id, int ss, int inner, int outer);

/* find a member in a struct/union by id. error if no such member exists. */

struct symbol *lookup_member(struct string *id, struct symbol *tag);

/* ensure that id is unique in the storage classes and scope specified.
   bombs with a (hopefully) intelligent message based on ss if not. if
   looking in S_MEMBER, tag is needed for the error message (0 otherwise) */

void unique(struct string *id, int ss, int scope, struct symbol *tag);

/* if id refers to a visible typedef, return the type. otherwise 0. */

struct tnode *named_type(struct string *id);

/* handle the definition of a global. c scope rules are quirky, so this is
   almost, but not quite, the same as file scope. globals are visible to as
   and/or ld, and possibly across compilation units. to illustrate:

                typedef int f;

                g() { extern int f(); }
                h() { extern int f(); }

   at file scope, f is a typedef, but at global scope, it's a function.
   globals may be declared multiple times and in different scopes, and
   are subject to type compatibility rules and type composition.

   global() handles most of the messy details. when called to process
   a declaration at file scope, pass in scope == FILE_SCOPE, otherwise
   LURKER_SCOPE. returns the correct symbol table entry. */

struct symbol *global(struct string *id, int s,
                      struct tnode *type, int scope);

/* declare a function implicitly (C89 6.3.2.2). returns its symbol. */

struct symbol *implicit(struct string *id);

/* enter a new scope. if strun is non-zero, then mark it a strun scope. */

void enter_scope(int strun);

/* exit the current scope. the scope's symbols are removed from the
   symbol table and are prepended to chainp. if chainp is null, the
   scope's symbols are discarded. */

void exit_scope(struct symbol **chainp);

/* call f for each symbol in scope and one of storage classes ss.
   the symbols are enumerated in the order they were inserted */

void walk_scope(int scope, int ss, void f(struct symbol *));

/* re-enter a scope: enter a new (non-strun scope) scope and import
   the symbols in the chain. used when entering a function definition
   to revive the argument scope. the chain is emptied. */

void reenter_scope(struct symbol **chainp);

/* insert a member into current_scope which is the strun_scope for tag.
   the caller must ensure that the type/id makes sense as a member, but
   insert_member() will ensure that the id is unique, compute the member's
   offset, absorb any members of anonymous struct/unions, and update the
   state of the tag symbol accordingly. */

void insert_member(struct symbol *tag, struct string *id, struct tnode *type);

/* exit the strun scope for tag. the scope chain is saved to tag->chain,
   the symbols are attached to tag->members, the size and alignment are
   finalized, and the tag is marked S_DEFINED. */

void exit_strun(struct symbol *tag);

/* return the symbol associated with the user label with the
   given id. create the label symbol if it doesn't exist. */

struct symbol *lookup_label(struct string *id);

/* called after function parsing is complete to ensure
   all referenced user labels have been defined. must be
   called BEFORE exiting the function's LOCAL_SCOPE. */

void check_labels(void);

/* return an anonymous S_STATIC symbol which
   references the specified assembler label */

struct symbol *anon_static(struct tnode *type, int asmlab);

/* symbols created with anon_static() live until purge_anons() is
   called (at present, after each round of external definitions) */

void purge_anons(void);

/* promote all symbols in the chain from S_LOCAL to S_REGISTER.
   this is one half of the 'alias analysis' discussed above. */

void registerize(struct symbol **chainp);

/* increment at the start of each new function. see symbol_to_reg() */

extern int reg_generation;

/* return the register assigned to the symbol (which
   must be scalar), assigning a new one if necessary. */

int symbol_to_reg(struct symbol *sym);

/* return the frame offset of the symbol's storage. allocate storage
   if none yet assigned. should only be invoked for S_BLOCK symbols. */

int symbol_offset(struct symbol *sym);

/* print the name of a global symbol to fp. this is either its actual name
   prefixed with an underscore, or the compiler-generated numeric label */

void print_global(FILE *fp, struct symbol *sym);

/* find all symbols which need .globl directives, i.e., symbols which are
   S_EXTERN and (S_REFERENCED or S_DEFINED), and emit the directives. call
   near the end of compilation (after processing tentatives). */

void out_globls(void);

#ifdef DEBUG

/* print a symbol table entry to stderr */

void dump_symbol(struct symbol *sym);

/* print a chain of symbols to stderr */

void dump_symbols(struct symbol **chainp);

/* print the scope chain of symbols to stderr */

void dump_scope(int scope);

/* print the contents of the current symbol table to stderr */

void dump_symtab(void);

#endif /* DEBUG */

#endif /* SYMBOL_H */

/* vi: set ts=4 expandtab: */
