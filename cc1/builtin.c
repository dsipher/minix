/*****************************************************************************

  builtin.c                                               tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "lex.h"
#include "type.h"
#include "tree.h"
#include "string.h"
#include "symbol.h"
#include "builtin.h"

/* if the number of builtins grows large, we
   should replace with a tabular initialization. */

void seed_builtin(struct string *id)
{
    struct symbol *sym;
    struct tnode *func;
    struct tnode *ret;

    func = new_tnode(T_FUNC, 0, 0);

    switch (id->k)
    {
    case K_BUILTIN_MEMCPY:
        ret = PTR(&void_type);
        new_formal(func, PTR(&void_type));
        new_formal(func, PTR(qualify(&void_type, T_CONST)));
        new_formal(func, &ulong_type);
        break;

    case K_BUILTIN_MEMSET:
        ret = PTR(&void_type);
        new_formal(func, PTR(&void_type));
        new_formal(func, &int_type);
        new_formal(func, &ulong_type);
        break;

    case K_BUILTIN_CLZ:
    case K_BUILTIN_CTZ:
        ret = &int_type;
        new_formal(func, &int_type);
        break;

    case K_BUILTIN_CLZL:
    case K_BUILTIN_CTZL:
        ret = &int_type;
        new_formal(func, &long_type);
        break;
    }

    sym = new_symbol(id, S_STATIC);
    sym->type = graft(func, ret);
    sym->s |= S_BUILTIN | S_DEFINED;
    insert(sym, FILE_SCOPE);
}

/* a proper call of a builtin will be of the form

                    __builtin_func (args...)
   or even          (__builtin_func) (args...)

   but we don't permit otherwise semantically equivalent forms like

                    (*(&__builtin_func)) (args...)

   because this would require call() to simplify() the function child
   or we would need a more sophisticated matching method here. because
   these are extensions, we get to make the rules. (currently, the last
   form will cause as/ld to complain that __builtin_func is undefined.) */

struct tree *rewrite_builtin(struct tree *tree)
{
    struct symbol *sym;
    int k;

    if ((tree->left->op != E_ADDROF)
      || (tree->left->child->op != E_SYM)
      || (!BUILTIN_SYMBOL(tree->left->child->sym)))
        return tree;

    k = tree->left->child->sym->id->k;

    switch (k)
    {
    case K_BUILTIN_CLZ:
    case K_BUILTIN_CLZL:
        tree = unary_tree(E_BSR, &int_type, tree->args[0]);
        tree = binary_tree(E_XOR, &int_type, tree, (k == K_BUILTIN_CLZ)
                                                    ? I_TREE(&int_type, 31)
                                                    : I_TREE(&int_type, 63));
        return tree;

    case K_BUILTIN_CTZ:
    case K_BUILTIN_CTZL:
        return unary_tree(E_BSF, &int_type, tree->args[0]);

    case K_BUILTIN_MEMCPY:
    case K_BUILTIN_MEMSET:
        /* conveniently, the prototypes for the builtins have
           already molded the arguments to acceptable types */

        return blk_tree((k == K_BUILTIN_MEMCPY) ? E_BLKCPY : E_BLKSET,
                         tree->args[0], tree->args[1], tree->args[2]);
    }

    return tree;
}

/* vi: set ts=4 expandtab: */
