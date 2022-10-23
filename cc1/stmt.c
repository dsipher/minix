/*****************************************************************************

   stmt.c                                                 ux/64 c compiler

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

#include "cc1.h"
#include "lex.h"
#include "heap.h"
#include "decl.h"
#include "expr.h"
#include "tree.h"
#include "gen.h"
#include "func.h"
#include "symbol.h"
#include "block.h"
#include "string.h"
#include "stmt.h"

static void stmt(void);

struct tree *stmt_tree;             /* for statement expressions */

/* block pointers relevant to the current context. these act as a stack,
   though these are only the topmost elements of those stacks; the other
   cells are in the activation records of the parsing functions. */

static struct block *break_block;       /* where to go on 'break' */
static struct block *continue_block;    /* .............. 'continue' */
static struct block *control_block;     /* block controlling switch */
static struct block *default_block;     /* of the current switch */
static int saw_default;                 /* have we seen a default case? */

#define IN_SWITCH()                                                         \
    do {                                                                    \
        if (control_block == 0)                                             \
            error(ERROR, 0, "misplaced %k (not in switch)", token.k);       \
    } while (0)

/* read a boolean expression in parentheses and generation
   a branch to one of two blocks based on its truth value.
   k is passed along to test(), only for error reporting. */

static void condition(struct block *true, struct block *false, int k)
{
    struct tree *tree;

    MATCH(K_LPAREN);
    tree = expression();
    tree = test(tree, K_NOTEQ, k);
    tree = gen(tree);
    branch(tree, true, false);
    MATCH(K_RPAREN);
}

/* common code for 'break' and 'continue' statements, which translate
   into 'goto' with an implied label (which the caller supplies). */

static void control(struct block *block)
{
    if (block == 0)
        error(ERROR, 0, "misplaced %k statement", token.k);

    add_succ(current_block, CC_ALWAYS, block);
    current_block = new_block();
    lex(); /* 'break' or 'continue' */
    MATCH(K_SEMI);
}

/* asm-statement: '__asm' '(' string [':' [use-map] [':' [def-map]]] ')' ';'

   use-map  :   map
   def-map  :   map

   map      :   map
            |   map ',' mapping

   mapping  :   'mem'
            |   'cc'
            |   reg [ '=' identifier ]

   'cc', and reg without an identifier, are prohibited in the use-map.

   we allow duplicate mappings. sometimes this makes sense (e.g., two
   machine registers initialized with the same identifier's value) and
   sometimes it doesn't (e.g., an output identifier set from multiple
   machine registers). where a conflict arises, like this latter case,
   it's undetermined which mapping wins. perhaps warning is warranted. */

static void asm0(int out, struct asm_insn *insn)
{
    VECTOR(regmap) *mapp;
    struct symbol *sym;
    int pseudo, mach;
    int k;

    mapp = out ? &insn->defs : &insn->uses;

    lex(); /* ':' */

    if (token.k == K_IDENT) {
        for (;;) {
            expect(K_IDENT);
            k = token.s->k;

            if (k & K_REG) {
                mach = K_TO_REG(k);
                lex();

                if (token.k == K_EQ) {
                    lex();
                    expect(K_IDENT);

                    sym = lookup(token.s, S_NORMAL,
                                 current_scope, FILE_SCOPE);

                    if (sym == 0)
                        error(ERROR, token.s, "unknown variable");

                    lex(); /* id */

                    if (!SCALAR_TYPE(sym->type))
                        error(ERROR, sym->id, "must be a scalar");

                    if ((DISCRETE_TYPE(sym->type) && !REG_GP(mach))
                      || (FLOATING_TYPE(sym->type) && !REG_XMM(mach)))
                        error(ERROR, sym->id, "invalid register class");

                    pseudo = symbol_to_reg(sym);
                } else {
                    pseudo = REG_NONE;
                    if (!out) error(ERROR, 0, "bogus register dependency");
                }

                add_regmap(mapp, pseudo, mach);
            } else if (k == K_CC) {
                if (out)
                    insn->hdr.defs_cc = 1;
                else
                    error(ERROR, 0, "bogus %%cc dependency");

                lex();
            } else if (k == K_MEM) {
                if (out)
                    insn->hdr.defs_mem = 1;
                else
                    insn->hdr.uses_mem = 1;

                lex();
            } else
                error(ERROR, 0, "expected register (got %K)", &token);

            if (token.k == K_COMMA)
                lex();
            else
                break;
        }
    }
}

static void asm_stmt(void)
{
    struct asm_insn *insn = (struct asm_insn *) new_insn(I_ASM, 0);

    lex(); /* '__asm' */
    MATCH(K_LPAREN);
    expect(K_STRLIT);
    insn->text = token.s;
    lex();

    if (token.k == K_COLON) asm0(0, insn);
    if (token.k == K_COLON) asm0(1, insn);

    MATCH(K_RPAREN);
    MATCH(K_SEMI);
    EMIT_INSN((struct insn *) insn);
}

/* case-label : 'case' expression ':' statement */

static void case_label(void)
{
    struct block *block;
    struct tree *tree;

    IN_SWITCH();

    lex(); /* 'case' */
    tree = case_expr();
    MATCH(K_COLON);

    block = new_block();
    add_switch_succ(control_block, &tree->con, block);
    add_succ(current_block, CC_ALWAYS, block);
    current_block = block;
}

/* default-label : 'default' ':' statement */

static void default_label(void)
{
    IN_SWITCH();

    if (saw_default) error(ERROR, 0, "duplicate default case");

    lex(); /* 'default' */
    MATCH(K_COLON);
    saw_default = 1;
    add_succ(current_block, CC_ALWAYS, default_block);
    current_block = default_block;
}

/* do-statement : 'do' statement while '(' expression ')' ';' */

static void do_stmt(void)
{
    struct block *saved_continue = continue_block;
    struct block *saved_break = break_block;
    struct block *body_block = new_block();

    break_block = new_block();
    continue_block = new_block();
    add_succ(current_block, CC_ALWAYS, body_block);
    current_block = body_block;

    lex(); /* 'do' */
    stmt();
    add_succ(current_block, CC_ALWAYS, continue_block);
    current_block = continue_block;

    MATCH(K_WHILE);
    condition(body_block, break_block, K_WHILE);
    MATCH(K_SEMI);

    current_block = break_block;
    continue_block = saved_continue;
    break_block = saved_break;
}

/* for-statement :
     'for' '(' [expression] ';' [expression] ';' [expression] ')' statement */

static void for_stmt(void)
{
    struct block *saved_continue = continue_block;
    struct block *saved_break = break_block;
    struct block *test_block = new_block();
    struct block *body_block = new_block();
    struct tree *test_tree = 0;
    struct tree *step_tree = 0;

    continue_block = new_block();
    break_block = new_block();

    lex(); /* 'for' */                                  MATCH(K_LPAREN);
    if (token.k != K_SEMI) gen(expression());           MATCH(K_SEMI);
    if (token.k != K_SEMI) test_tree = expression();    MATCH(K_SEMI);
    if (token.k != K_RPAREN) step_tree = expression();  MATCH(K_RPAREN);

    add_succ(current_block, CC_ALWAYS, test_block);
    current_block = test_block;

    if (test_tree) {
        test_tree = test(test_tree, K_NOTEQ, K_FOR);
        test_tree = gen(test_tree);
        branch(test_tree, body_block, break_block);
    } else
        add_succ(current_block, CC_ALWAYS, body_block);

    current_block = body_block;
    stmt();
    add_succ(current_block, CC_ALWAYS, continue_block);

    current_block = continue_block;
    if (step_tree) gen(step_tree);
    add_succ(current_block, CC_ALWAYS, test_block);

    current_block = break_block;
    continue_block = saved_continue;
    break_block = saved_break;
}

/* goto-statement : 'goto' identifier ';' */

static void goto_stmt(void)
{
    struct symbol *label;

    lex(); /* 'goto' */
    expect(K_IDENT);
    label = lookup_label(token.s);
    add_succ(current_block, CC_ALWAYS, label->b);
    current_block = new_block();
    lex(); /* id */
    MATCH(K_SEMI);
}

/* if-statement : 'if' '(' expression ')' statement ['else' statement] */

static void if_stmt(void)
{
    struct block *true_block = new_block();
    struct block *else_block = new_block();
    struct block *join_block = new_block();

    lex(); /* 'if' */
    condition(true_block, else_block, K_IF);

    current_block = true_block;
    stmt();
    add_succ(current_block, CC_ALWAYS, join_block);

    if (token.k == K_ELSE) {
        lex();
        current_block = else_block;
        stmt();
        else_block = current_block;
    }

    add_succ(else_block, CC_ALWAYS, join_block);
    current_block = join_block;
}

/* return-statement: 'return' [expression] ';'
   the mechanics of return are explained in func.h. */

static void return_stmt(void)
{
    struct tree *tree;

    lex(); /* 'return' */

    if (!VOID_TYPE(func_ret_type)) {
        tree = expression();

        if (STRUN_TYPE(func_ret_type) && STRUN_TYPE(tree->type))
            tree = unary_tree(E_ADDROF, PTR(tree->type), tree);

        tree = build_tree(K_RET, sym_tree(func_ret_sym), tree);
        gen(tree);
    } else
        /* if the user attempts to return a value from a void
           function, we'll issue a syntax error at the MATCH. */ ;

    add_succ(current_block, CC_ALWAYS, exit_block);
    current_block = new_block();

    MATCH(K_SEMI);
}

/* switch-statement: 'switch' '(' expression ')' statement */

static void switch_stmt(void)
{
    struct block *saved_control = control_block;
    struct block *saved_default = default_block;
    struct block *saved_break = break_block;
    int saved_saw_default = saw_default;
    struct block *body_block;
    struct operand o;
    struct tree *tree;

    lex(); /* 'switch' */
    MATCH(K_LPAREN);
    tree = expression();
    MATCH(K_RPAREN);

    if (!INTEGRAL_TYPE(tree->type))
        error(ERROR, 0, "controlling expression must be integral");

    tree = gen(tree);
    leaf_operand(&o, tree);

    control_block = current_block;
    saw_default = 0;
    default_block = new_block();
    break_block = new_block();
    body_block = new_block();
    switch_block(current_block, &o, default_block);

    current_block = body_block;
    stmt();
    add_succ(current_block, CC_ALWAYS, break_block);
    if (!saw_default) add_succ(default_block, CC_ALWAYS, break_block);
    trim_switch_block(control_block);

    current_block = break_block;
    control_block = saved_control;
    break_block = saved_break;
    default_block = saved_default;
    saw_default = saved_saw_default;
}

/* while-statement : 'while' '(' expression ')' statement */

static void while_stmt(void)
{
    struct block *saved_break = break_block;
    struct block *saved_continue = continue_block;
    struct block *test_block = new_block();
    struct block *body_block = new_block();

    break_block = new_block();
    continue_block = test_block;

    add_succ(current_block, CC_ALWAYS, test_block);
    current_block = test_block;

    lex(); /* 'while' */
    condition(body_block, break_block, K_WHILE);

    current_block = body_block;
    stmt();
    add_succ(current_block, CC_ALWAYS, test_block);

    current_block = break_block;

    continue_block = saved_continue;
    break_block = saved_break;
}

static void stmt(void)
{
    struct token peek;
    struct symbol *label;
    struct tree *tree = &void_tree;

again:
    switch (token.k)
    {
    case K_ASM:         asm_stmt(); break;
    case K_BREAK:       control(break_block); break;
    case K_CASE:        case_label(); goto again;
    case K_CONTINUE:    control(continue_block); break;
    case K_DEFAULT:     default_label(); goto again;
    case K_DO:          do_stmt(); break;
    case K_FOR:         for_stmt(); break;
    case K_GOTO:        goto_stmt(); break;
    case K_IF:          if_stmt(); break;
    case K_RETURN:      return_stmt(); break;
    case K_SWITCH:      switch_stmt(); break;
    case K_WHILE:       while_stmt(); break;

    case K_LBRACE:
        enter_scope(0);
        compound(0);
        exit_scope(&func_chain);
        break;

    case K_IDENT:
        peek = lookahead();

        if (peek.k == K_COLON) {
            label = lookup_label(token.s);

            if (DEFINED_SYMBOL(label))
                error(ERROR, token.s, "duplicate label %L", label);

            HERE_SYMBOL(label);
            label->s |= S_DEFINED;

            lex();  /* id */
            lex();  /* : */
            add_succ(current_block, CC_ALWAYS, label->b);
            current_block = label->b;
            goto again;
        }

        /* FALLTHRU */

    default:
        tree = expression();
        tree = gen(tree);

        /* FALLTHRU */

    case K_SEMI:
        MATCH(K_SEMI);
        break;
    }

    stmt_tree = tree;
}

/* if this statement is the body of a function definition, then we dump
   the statement arena between statements. (see heap.h.) also, we check
   for dangling labels here, rather than, e.g., funcdef(), in part so we
   can more accurately report the error location- at the closing brace. */

void compound(int body)
{
    MATCH(K_LBRACE);

    locals();

    /* we free the stmt_arena _before_ every
       statement. this seems backwards, but

            1. locals() above very likely used stmt_arena
               (initializers and/or statement expressions)

            2. since we only free while processing a body, we know
               externals() will free (eventually) after we return.

       so the effect is that we do indeed free the stmt_arena
       _after_ every occasion it might have been populated. */

    stmt_tree = &void_tree;

    while (token.k != K_RBRACE) {
        if (body) ARENA_FREE(&stmt_arena);
        stmt();
    }

    if (body) check_labels();
    MATCH(K_RBRACE);
}

/* vi: set ts=4 expandtab: */
