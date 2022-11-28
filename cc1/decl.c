/*****************************************************************************

   decl.c                                                 minix c compiler

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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

#include "cc1.h"
#include "lex.h"
#include "heap.h"
#include "type.h"
#include "symbol.h"
#include "string.h"
#include "expr.h"
#include "init.h"
#include "func.h"
#include "stmt.h"
#include "decl.h"

typedef int callback(struct string *id, int s, struct tnode *type,
                     int *flags, void *arg);

static void declarations(int flags, void *arg, callback declare);

static struct tnode *declarator(struct tnode *prefix,
                                struct string **id, int *flags);

/* when a declarator contains an argument list that could
   belong to a function definition, the chain is saved here */

static struct symbol *formal_chain;

/* flags passed around between declaration functions.
   unfortunately these are ad hoc and a bit hackish */

#define DECL_SPEC       0x00000001      /* saw at least one specifier */
#define DECL_TAG        0x00000002      /* a (named) tag was declared */
#define DECL_CONSTS     0x00000004      /* enumeration constants defined */
#define DECL_TYPEDEF    0x00000008      /* unmodified typedef */
#define DECL_FIRST      0x00000010      /* first declarator in list */
#define DECL_FUNCDEF    0x00000020      /* can be a function definition */
#define DECL_UNTYPED    0x00000040      /* formal_chain has untyped symbols */
#define DECL_NOEMPTY    0x00000080      /* do not allow missing declarator */
#define DECL_NEEDID     0x00000100      /* no anonymous declarators allowed */

/* parse zero or more type qualifiers, and add their T_* bits to
   *t. we do not enforce the prohibition on duplicate qualifiers
   (C89 6.5.3) as this was lifted in C99, so we opt to be lazy.

   as a convenience to declarator(), we allow flags to be 0. */

static void qualifiers(long *t, int *flags)
{
    for (;;)
    {
        switch (token.k)
        {
        case K_CONST:       *t |= T_CONST; break;
        case K_VOLATILE:    *t |= T_VOLATILE; break;

        default:            return;
        }

        if (flags) *flags |= DECL_SPEC;
        lex();
    }
}

/* map between S_* storage classes
   and K_* keywords and vice-versa */

static struct { int s; int k; } s_k_map[] =
{
        { S_AUTO,           K_AUTO          },
        { S_REGISTER,       K_REGISTER      },
        { S_TYPEDEF,        K_TYPEDEF       },
        { S_EXTERN,         K_EXTERN        },
        { S_STATIC,         K_STATIC        }
};

#define S_TO_K(s, k)                                                        \
    {                                                                       \
        int i;                                                              \
                                                                            \
        for (i = 0; i < ARRAY_SIZE(s_k_map); ++i)                           \
            if (s_k_map[i].s == s)                                          \
                return s_k_map[i].k;                                        \
    }

static int s_to_k(int s) S_TO_K(s, k)
static int k_to_s(int k) S_TO_K(k, s)      /* n.b.: swapped arguments */

#define CHECK_CLASS(s, ss)                                                  \
    do {                                                                    \
        if ((s) && !((s) & (ss)))                                           \
            error(ERROR, 0, "invalid storage class %k", s_to_k(s));         \
    } while (0)

/* here we parse bitfields and do some preliminary validation of the
   member, then leave it to insert_member() to do the heavy lifting. */

static int member(struct string *id, int s, struct tnode *type,
                  int *flags, void *arg)
{
    struct symbol *tag = arg;
    int width;

    CHECK_CLASS(s, 0);

    if (FUNC_TYPE(type))
        error(ERROR, id, "functions can't be members");

    /* C99 prohibits this, but it's a common and useful extension
       which we employ ourselves (see struct insn and its operands).
       the compiler has no problem with this embedding; this check
       is solely pedantic. left here in case we change our minds. */

    /********* if (FLEXIBLE_STRUN_TYPE(type))                       *******/
    /*********    error(ERROR, id, "flexible structs do not nest"); *******/

    if (token.k == K_COLON) {
        lex();
        width = constant_expr();

        if (!INTEGRAL_TYPE(type))
            error(ERROR, id, "bitfields must have integral type");

        if ((width < 0) || (width > (size_of(type, 0) * BITS_PER_BYTE)))
            error(ERROR, id, "field width exceeds that of host type");

        type = fieldify(type, width, 0);
    }

    if (FIELD_TYPE(type) && (FIELD_WIDTH(type) == 0) && id)
        error(ERROR, id, "alignment fields must be anonymous");

    if (id == 0) {
        if (FIELD_TYPE(type))
            /* bitfields may be anonymous */ ;
        else if (ANONYMOUS_STRUN_TYPE(type)
               && ((*flags & (DECL_FIRST | DECL_TYPEDEF)) == DECL_FIRST)
               && (token.k == K_SEMI)) {
            /* anonymous struct or unions are .. anonymous. but they must
               possess a completely empty declarator and be alone on the
               line, and they must be explicit - a typedef which expands
               to an anonymous strun does not count. C11 extension. */ ;
        } else
            error(ERROR, 0, "missing member identifier");
    }

    if (UNBOUNDED_ARRAY_TYPE(type)) {
        if (tag->s & S_UNION)   /* C99 6.7.2.1 */
            error(ERROR, id, "unions can't have flexible arrays");
    } else
        size_of(type, id);  /* everyone else must be totally complete */

    insert_member(tag, id, type);
    return 0;
}

/* helper for tag_specifier to process struct or union specifiers. as
   with member(), the work is split with symbol.c, see exit_strun(). */

static struct tnode *strun_specifier(struct symbol *tag, int *flags)
{
    if (token.k == K_LBRACE) {
        enter_scope(1);
        lex();

        while (K_IS_DECL(token))
            declarations(0, tag, member);

        MATCH(K_RBRACE);
        exit_strun(tag);
    }

    return get_tnode(T_STRUN, (long) tag, 0);
}

/* helper for tag_specifier. we do not distinguish enums and
   ints at all, so the return type is always &int_type. */

static struct tnode *enum_specifier(struct symbol *tag, int *flags)
{
    struct symbol *sym;
    int value;

    if (token.k == K_LBRACE) {
        lex();
        value = 0;

        for (;;)
        {
            expect(K_IDENT);
            unique(token.s, S_NORMAL, outer_scope, 0);
            sym = new_symbol(token.s, S_CONST);
            lex();

            if (token.k == K_EQ) {
                lex();
                value = constant_expr();
            }

            sym->value = value++;
            insert(sym, outer_scope);

            if (token.k == K_COMMA)
                lex();
            else
                break;
        }

        MATCH(K_RBRACE);
        HERE_SYMBOL(tag);
        tag->s |= S_DEFINED;
        *flags |= DECL_CONSTS;
    }

    if (!DEFINED_SYMBOL(tag)) error(ERROR, 0, "%T is incomplete", tag);
    return &int_type;
}

/* the parser is position at a tag specifier; finds the corresponding tag
   symbol, or creates one in the current (outer) scope if appropriate. the
   latter occurs if the tag is unknown or the specification is followed by
   a '{' or ';', signaling a definition/forward declaration. returns type. */

static struct tnode *tag_specifier(int *flags)
{
    struct symbol *tag = 0;
    struct string *id = 0;
    int s;

    switch (token.k)
    {
    case K_STRUCT:  s = S_STRUCT; break;
    case K_UNION:   s = S_UNION; break;
    case K_ENUM:    s = S_ENUM; break;
    }

    lex();

    if (token.k == K_IDENT) {
        id = token.s;
        lex();

        if ((token.k == K_LBRACE) || ((token.k == K_SEMI) && (s != S_ENUM))) {
            /* this is either a definition or a forward declaration. we
               consider these 'tag declarations', in the sense that C89
               6.5 will permit them to stand alone (with no declarators). */

            *flags |= DECL_TAG;
            tag = lookup(id, S_TAG, outer_scope, outer_scope);
        } else
            tag = lookup(id, S_TAG, outer_scope, FILE_SCOPE);
    } else
        expect(K_LBRACE);   /* if anonymous, must be a definition */

    if (tag == 0) {
        tag = new_symbol(id, s);
        insert(tag, outer_scope);
   }

    if (!(tag->s & s))
        error(ERROR, 0, "tag confusion, previously %T %L", tag, tag);

    if (token.k == K_LBRACE) {
        if (DEFINED_SYMBOL(tag))
            error(ERROR, 0, "%T already defined %L", tag, tag);

        HERE_SYMBOL(tag);
    }

    *flags |= DECL_SPEC;

    if (s == S_ENUM)
        return enum_specifier(tag, flags);
    else
        return strun_specifier(tag, flags);
}

/* parse type specifiers and return the resulting type.
   storage class is returned in *s -- 0, if none. if
   s itself is 0, then no storage class is permitted. */

static struct tnode *specifiers(int *s, int *flags)
{
    struct tnode *type = 0;
    int ks = 0;
    long quals = 0;

    if (s) *s = 0;

    for (;;)
    {
        switch (token.k)
        {
        case K_AUTO:        case K_EXTERN:      case K_REGISTER:
        case K_STATIC:      case K_TYPEDEF:

            if (!s) error(ERROR, 0, "no storage class permitted here");
            if (*s) error(ERROR, 0, "multiple storage class specifiers");
            *s = k_to_s(token.k);
            *flags |= DECL_SPEC;
            lex();
            break;

        case K_CONST:       case K_VOLATILE:

            qualifiers(&quals, flags);
            break;

        case K_SIGNED:      case K_UNSIGNED:    case K_CHAR:
        case K_SHORT:       case K_INT:         case K_LONG:
        case K_FLOAT:       case K_DOUBLE:      case K_VOID:

            if (type || (ks & K_SPEC(token.k))) goto too_many;
            ks |= K_SPEC(token.k);
            *flags |= DECL_SPEC;
            lex();
            break;

        case K_STRUCT:      case K_UNION:       case K_ENUM:

            if (type || ks) goto too_many;
            type = tag_specifier(flags);
            break;

        case K_IDENT:

            /* a type name is only recognized as such if we
               haven't seen a type specification already... */

            if (!type && !ks && (type = named_type(token.s))) {
                *flags |= DECL_TYPEDEF | DECL_SPEC;
                lex();
                break;
            }

            /* otherwise, fall through: the identifier
               belongs to the declarator, so we're done */

        default:
            if (ks) type = map_type(ks);
            if (type == 0) type = &int_type;
            return qualify(type, quals);
        }
    }

too_many:
    error(ERROR, 0, "too many type specifiers");
}

/* read a prototype argument list and fill in the prefix
   T_FUNC accordingly. chainp is forwarded to exit_scope(). */

static void prototype0(struct symbol *sym)
{
    error(WARNING, 0, "%T declared in argument list", sym);
}

static void prototype(struct tnode *prefix, struct symbol **chainp)
{
    struct tnode *base;
    struct tnode *type;
    struct string *id;
    struct symbol *sym;
    int flags;
    int s;

    prefix->t &= ~T_OLD_STYLE;
    enter_scope(0);

    if ((token.k == K_VOID) && (lookahead().k == K_RPAREN))
        lex();
    else {
        while (K_IS_DECL(token)) {
            flags = 0;
            base = specifiers(&s, &flags);
            CHECK_CLASS(s, S_REGISTER);
            s = s ? s : S_LOCAL;

            type = declarator(0, &id, &flags);
            type = graft(type, base);
            validate(type, id, 0);
            type = formal_type(type);
            new_formal(prefix, type);
            unique(id, S_ARG, current_scope, 0);
            sym = new_symbol(id, s | S_ARG);
            sym->type = type;
            insert(sym, outer_scope);

            if (token.k == K_COMMA) {
                lex();
                if (token.k == K_ELLIP) {
                    lex();
                    prefix->t |= T_VARIADIC;
                    break;
                }
            } else
                break;
        }
    }

    walk_scope(outer_scope, S_TAG, prototype0);
    exit_scope(chainp);
}

/* read the identifier-list of an old-style function definition,
   and return the resulting scope chain in *chainp. */

static void id_list(struct symbol **chainp)
{
    struct symbol *sym;
    struct string *id;

    enter_scope(0);

    for (;;)
    {
        expect(K_IDENT);
        id = token.s;
        lex();

        /* the first id will never be a typedef, as the parser will
           interpret that as the beginning of a prototype. C89 6.7.1
           says NO argument may share an id with a visible typedef. */

        if (named_type(id))
            error(ERROR, id, "is a typedef");

        unique(id, S_ARG, current_scope, 0);
        sym = new_symbol(id, S_ARG | S_LOCAL);
        insert(sym, outer_scope);

        if (token.k == K_COMMA)
            lex();
        else
            break;
    }

    exit_scope(chainp);
}

/* declarator() (in cooperation with declarator0) parses a declarator.
   if id is 0, then the declarator must be abstract. on the other hand,
   if *flags & DECL_NEEDID, the declarator may not be abstract. *id is
   set to the declared identifer (0 if none). returns the type prefix.

   if DECL_FUNCDEF is in *flags, we preserve any potential formal
   arguments in formal_chain. external() must dispose of them. */

static struct tnode *declarator0(struct tnode *prefix,
                                 struct string **id, int *flags)
{
    struct symbol *chain;
    struct token peek;

    if ((token.k == K_LPAREN)
      && (peek = lookahead(), peek.k != K_RPAREN)
      && !K_IS_DECL(peek)) {
        lex();
        prefix = declarator(prefix, id, flags);
        MATCH(K_RPAREN);
    } else {
        if (*flags & DECL_NEEDID) expect(K_IDENT);

        if (token.k == K_IDENT) {
            if (id) {
                *id = token.s;
                lex();
            } else
                error(ERROR, token.s, "abstract type required");
        } else
            if (id) *id = 0;
    }

    for (;;)
    {
        switch (token.k)
        {
        case K_LBRACK:
            lex();
            prefix = new_tnode(T_ARRAY, 0, prefix);

            if (token.k != K_RBRACK) {
                prefix->nelem = constant_expr();

                if (prefix->nelem <= 0)
                    error(ERROR, (id ? *id : 0), "bogus dimension (%d)",
                                                 prefix->nelem);

                if (prefix->nelem > MAX_TYPE_BYTES)
                    error(ERROR, (id ? *id : 0), "sorry, dimension too big");
            }

            MATCH(K_RBRACK);
            break;

        case K_LPAREN:
            lex();
            prefix = new_tnode(T_FUNC | T_OLD_STYLE, 0, prefix);

            /* what a mess. we need to save the arguments in formal_chain
               if they might be part of a function definition. that's only
               possible if DECL_FUNCDEF and this is the outermost function
               modifier in this type (prefix->next == 0). */

            if (token.k != K_RPAREN) {
                if ((prefix->next == 0) && (*flags & DECL_FUNCDEF)) {
                    if (K_IS_DECL(token))
                        prototype(prefix, &formal_chain);
                    else {
                        *flags |= DECL_UNTYPED;
                        id_list(&formal_chain);
                    }
                } else {
                    if (K_IS_DECL(token))
                        prototype(prefix, 0);
                    else
                        /* fall thru, old-style argments not permitted */ ;
                }
            }

            MATCH(K_RPAREN);
            break;

        default:
            return prefix;
        }
    }
}

static struct tnode *declarator(struct tnode *prefix,
                                struct string **id, int *flags)
{
    long quals = 0;

    if (token.k == K_MUL) {
        lex();
        qualifiers(&quals, 0);
        prefix = declarator(prefix, id, flags);
        prefix = new_tnode(T_PTR | quals, 0, prefix);
    } else
        prefix = declarator0(prefix, id, flags);

    return prefix;
}

/* declarations() processes a line of declarations
   invoking the callback for each declarator. the
   callback returns non-zero to force abort (after
   processing a function definition), 0 otherwise. */

static void declarations(int flags, void *arg, callback declare)
{
    struct tnode *base;
    struct tnode *prefix;
    struct tnode *type;
    struct string *id;
    int dtor_flags;
    int s;

    base = specifiers(&s, &flags);

    /* C89 6.5 says an empty declarator list is fine if either a struct
       or union tag is declared, or enumeration constants are defined.

       C89 6.7.1 does not allow empty declarators in the declaration list
       of an old-style function definition, hence the DECL_NOEMPTY flag. */

    if ((token.k == K_SEMI)
      && (flags & (DECL_TAG | DECL_CONSTS))
      && !(flags & DECL_NOEMPTY)) {
        /* one would think that qualifiers or storage classes here
           would be prohibited, especially in the case of typedef,
           but neither the standard nor its successors seem to care. */

        if (s) error(WARNING, 0, "stray storage class %k", s_to_k(s));

        if (TYPE_QUALS(base))
            error(WARNING, 0, "useless %q", TYPE_QUALS(base));

        lex(); /* ; */
        return;
    }

    flags |= DECL_FIRST;

    for (;;)
    {
        dtor_flags = flags;
        prefix = declarator(0, &id, &dtor_flags);
        if (prefix) dtor_flags &= ~DECL_TYPEDEF;
        type = graft(prefix, base);
        validate(type, id, 0);
        if (declare(id, s, type, &dtor_flags, arg)) return;

        /* specifiers may only be omitted entirely in a
           function definition- see EBNF in C89 6.5. */

        if ((dtor_flags & DECL_SPEC) == 0)
            error(ERROR, id, "missing declaration specifiers");

        if (token.k == K_COMMA)
            lex();
        else
            break;

        flags &= ~(DECL_FIRST | DECL_FUNCDEF);
    }

    MATCH(K_SEMI);
}

/* the only wrinkle when processing locals is 'extern'.
   n.b. we also process typedefs on behalf on external(). */

static int local(struct string *id, int s, struct tnode *type,
                  int *flags, void *arg)
{
    struct symbol *sym;

    if (s == 0) s = FUNC_TYPE(type) ? S_EXTERN : S_LOCAL;

    if (s & S_EXTERN) {
        /* notice that we allow redeclaration of redirects.
           C89 6.1.2.6 implictly allows this, just as it
           does for file-scope declarations. this is stupid. */

        unique(id, S_NORMAL & ~S_REDIRECT, outer_scope, 0);
        sym = global(id, s, type, LURKER_SCOPE);
        redirect(sym, outer_scope);
    } else {
        unique(id, S_NORMAL, outer_scope, 0);
        sym = new_symbol(id, s);
        sym->type = type;
        insert(sym, outer_scope);

        if (!(s & S_TYPEDEF)) {
            if (FUNC_TYPE(type))
                error(ERROR, id, "no local functions");
            else {
                if (s & S_BLOCK)
                    init_auto(sym);
                else
                    init_static(sym, s);
            }
        }
    }

    return 0;
}

void locals(void)
{
    while (K_IS_DECL(token))
        declarations(DECL_NEEDID, 0, local);
}

/* process declaration of an old-style argument for funcdef().

   K&R would silently promote the declared argument types. C89
   expects us to honor them as written, and effect an assignment
   from the type-as-passed to the type-as-declared. in our case,
   this only affects floats, which arrive as doubles. we make a
   note of that in symbol table entry and let the code generator
   deal with it when it writes the argument-acceptance sequence */

static int old_arg(struct string *id, int s, struct tnode *type,
                   int *flags, void *arg)
{
    struct symbol *sym;

    CHECK_CLASS(s, S_REGISTER);
    s = s ? s : S_LOCAL;
    sym = lookup(id, S_ARG, LOCAL_SCOPE, LOCAL_SCOPE);
    if (sym == 0) error(ERROR, id, "is not an argument");
    if (sym->type) error(ERROR, id, "type already declared");

    if (FLOAT_TYPE(type)) s |= S_FIXFLOAT;

    sym->s = S_ARG | s;
    sym->type = formal_type(type);

    return 0;
}

/* process a function definition. sym is its entry in the symbol table.
   beware: sym->type might indicate a prototype even though we're amidst
   an old-style definition. we use *flags & DECL_UNTYPED to differentiate. */

static void funcdef(int *flags, struct symbol *sym)
{
    reenter_scope(&formal_chain);

    if (*flags & DECL_UNTYPED)
        while (K_IS_DECL(token))
            declarations(DECL_NEEDID | DECL_NOEMPTY, 0, old_arg);

    enter_func(sym);
    compound(1);
    exit_scope(&func_chain);
    exit_func();
}

/* typedefs are the oddballs here, since they follow 'local'
   rules, whereas objects and functions may be redeclared and
   their types composed (per C89 6.1.2.6).

   since externals() specifies DECL_FUNCDEF, we inherit formal_chain
   from declarator() and and are responsible for the symbols there. */

static int external(struct string *id, int s, struct tnode *type,
                    int *flags, void *arg)
{
    struct symbol *sym;
    int was_def = 0;
    int eff_s;

    CHECK_CLASS(s, S_EXTERN | S_STATIC | S_TYPEDEF);
    eff_s = s ? s : S_EXTERN;

    if (s & S_TYPEDEF)
        local(id, s, type, flags, 0);
    else {
        unique(id, S_CONST | S_TYPEDEF, FILE_SCOPE, 0);
        sym = global(id, eff_s, type, FILE_SCOPE);

        if (FUNC_TYPE(type)) {
            /* if the next token can't terminate a declarator and a function
               definition is allowed here, then assume a function definition.

               the DECL_TYPEDEF business prevents, e.g.,

                        typedef int f(); f g {}

               from being accepted as a valid function definition. */

            if ((token.k != K_COMMA)
              && (token.k != K_SEMI)
              && (*flags & DECL_FUNCDEF)
              && !(*flags & DECL_TYPEDEF))
            {
                funcdef(flags, sym);
                was_def = 1;
            }
        } else
            init_static(sym, s);
    }

    /* funcdef() consumes the formal_chain, so if it's still full, this
       was not a function definition. if the arguments are untyped, then
       this should have been an old-style definition- error. otherwise
       they're just leftovers from a prototype and we dispose of them. */

    if (formal_chain) {
        if (*flags & DECL_UNTYPED)
            error(ERROR, id, "misplaced old-style arguments");

        free_symbols(&formal_chain);
    }

    return was_def;
}

void externals(void)
{
    while (token.k) {
        declarations(DECL_FUNCDEF | DECL_NEEDID, 0, external);
        ARENA_FREE(&stmt_arena);   /* in case of initializer trees */
        purge_anons();             /* and/or function definitions */
    }
}

struct tnode *abstract(void)
{
    struct tnode *base;
    struct tnode *type;
    int flags;

    flags = 0;
    base = specifiers(0, &flags);
    type = declarator(0, 0, &flags);
    type = graft(type, base);
    validate(type, 0, 1);

    return type;
}

/* vi: set ts=4 expandtab: */
