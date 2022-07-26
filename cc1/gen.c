/*****************************************************************************

  gen.c                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "insn.h"
#include "func.h"
#include "tree.h"
#include "block.h"
#include "symbol.h"
#include "gen.h"

static struct tree *gen0(struct tree *tree);

void leaf_operand(struct operand *o, struct tree *tree)
{
    switch (tree->op)
    {
    case E_CON:     IMM_OPERAND(o, tree->type, 0, tree->con, tree->sym);
                    break;

    case E_SYM:     REG_OPERAND(o, tree->type, 0, symbol_to_reg(tree->sym));
                    break;
    }
}

/* create a temporary of the specified type and insert an I_LIR_FRAME
   insn into block b at index i to compute a frame address into it. */

static struct symbol *frame_addr(struct tnode *type, int offset,
                                 struct block *b, int i)
{
    struct insn *insn;
    struct symbol *tmp;

    tmp = temp(type);
    insn = new_insn(I_LIR_FRAME, 0);
    REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
    I_OPERAND(&insn->operand[1], 0, T_LONG, offset);
    insert_insn(insn, b, i);

    return tmp;
}

int loadstore(int op, struct symbol *sym, struct block *b, int i)
{
    struct operand *reg_o;
    struct operand *addr_o;
    struct insn *insn;
    int count = 1;

    insn = new_insn(op, 0);
    reg_o = &insn->operand[0];
    addr_o = &insn->operand[1];
    if (op == I_LIR_STORE) SWAP(struct operand *, reg_o, addr_o);
    REG_OPERAND(reg_o, sym->type, 0, symbol_to_reg(sym));

    if (sym->s & S_BLOCK) {
        struct symbol *tmp;

        tmp = frame_addr(&ulong_type, symbol_offset(sym), b, i++);
        REG_OPERAND(addr_o, tmp->type, 0, symbol_to_reg(tmp));
        ++count; /* frame_addr() emitted an insn */
    } else
        SYM_OPERAND(addr_o, &ulong_type, sym);

    if (VOLATILE_TYPE(sym->type)) insn->is_volatile = 1;
    insert_insn(insn, b, i);

    return count;
}

void branch(struct tree *tree, struct block *true, struct block *false)
{
    struct insn *insn;

    insn = new_insn(I_LIR_CMP, 0);
    leaf_operand(&insn->operand[0], tree);
    I_OPERAND(&insn->operand[1], 0, T_INT, 0);
    EMIT_INSN(insn);

    add_succ(current_block, CC_Z, false);
    add_succ(current_block, CC_NZ, true);
}

/* general binary operators:    E_ADD E_SUB E_MUL E_DIV E_MOD
                                E_SHL E_SHR E_AND E_OR  E_XOR */

static struct tree *gen_binary(struct tree *tree, int op)
{
    struct symbol *tmp;
    struct insn *insn;

    tmp = temp(tree->type);
    tree->left = gen0(tree->left);
    tree->right = gen0(tree->right);

    insn = new_insn(op, 0);
    REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
    leaf_operand(&insn->operand[1], tree->left);
    leaf_operand(&insn->operand[2], tree->right);
    EMIT_INSN(insn);

    return sym_tree(tmp);
}

/* general unary operators:     E_NEG E_COM E_BSF E_BSR */

static struct tree *gen_unary(struct tree *tree, int op)
{
    struct symbol *sym;
    struct insn *insn;

    tree->child = gen0(tree->child);

    sym = temp(tree->type);
    insn = new_insn(op, 0);
    REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
    leaf_operand(&insn->operand[1], tree->child);
    EMIT_INSN(insn);

    return sym_tree(sym);
}

/* casts: E_CAST. we expand casts between unsigned longs
   and floating-point numbers, as these are non-trivial.
   casts to void are squashed. others are straightforward
   translations to I_LIR_CAST insns. simplify() has already
   removed any [no-op] casts between simpatico types, but
   if have sneaked through, they'll disappear in lowering.

   expanding ulong <-> fp casts here, this early, renders
   them mostly opaque to the optimizer. this shouldn't be
   a problem, given the nature of the casts involved, but
   we can push this expansion to a later phase if needed. */

static struct tree *gen_cast(struct tree *tree)
{
    struct symbol *sym;
    struct symbol *tmp, *tmp2;
    struct insn *insn;
    struct block *noadj_block;
    struct block *adj_block;
    struct block *join_block;

    tree->child = gen0(tree->child);
    sym = temp(tree->type);

    if (ULONG_TYPE(tree->type) && FLOATING_TYPE(tree->child->type)) {
        noadj_block = new_block();
        adj_block = new_block();
        join_block = new_block();

        /* is the floating-point source > LONG_MAX? n.b. LONG_MAX
           converted to floating point rounds to LONG_MAX + 1. */

        tmp = temp(tree->child->type);

        insn = new_insn(I_LIR_MOVE, 0);     /* MOVE (float) LONG_MAX, tmp */
        REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
        F_OPERAND(&insn->operand[1], tmp->type, 0, LONG_MAX);
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_CMP, 0);      /* CMP tmp, src */
        leaf_operand(&insn->operand[0], tree->child);
        REG_OPERAND(&insn->operand[1], tmp->type, 0, symbol_to_reg(tmp));
        EMIT_INSN(insn);

        add_succ(current_block, CC_B, noadj_block);
        add_succ(current_block, CC_AE, adj_block);

        /* no. just pretend the target is long and carry on. */

        current_block = noadj_block;

        insn = new_insn(I_LIR_CAST, 0);     /* CAST (signed) src, dst */
        REG_OPERAND(&insn->operand[0], 0, T_LONG, symbol_to_reg(sym));
        leaf_operand(&insn->operand[1], tree->child);
        EMIT_INSN(insn);

        add_succ(current_block, CC_ALWAYS, join_block);

        /* yes. subtract LONG_MAX to try to get the value in range, cast
           that to a long, then invert the high bit to adjust the result */

        current_block = adj_block;

        insn = new_insn(I_LIR_SUB, 0);      /* SUB tmp, src, tmp */
        REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
        leaf_operand(&insn->operand[1], tree->child);
        REG_OPERAND(&insn->operand[2], tmp->type, 0, symbol_to_reg(tmp));
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_CAST, 0);     /* CAST tmp, (signed) dst */
        REG_OPERAND(&insn->operand[0], 0, T_LONG, symbol_to_reg(sym));
        REG_OPERAND(&insn->operand[1], tmp->type, 0, symbol_to_reg(tmp));
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_XOR, 0);      /* XOR (high bit), dst */
        REG_OPERAND(&insn->operand[0], 0, T_ULONG, symbol_to_reg(sym));
        REG_OPERAND(&insn->operand[1], 0, T_ULONG, symbol_to_reg(sym));
        I_OPERAND(&insn->operand[2], 0, T_ULONG, 0x8000000000000000);
        EMIT_INSN(insn);

        add_succ(current_block, CC_ALWAYS, join_block);

        current_block = join_block;
    } else if (FLOATING_TYPE(tree->type) && ULONG_TYPE(tree->child->type)) {
        noadj_block = new_block();
        adj_block = new_block();
        join_block = new_block();

        /* if the high bit of the unsigned long is set, then it's out of
           range and must be adjusted. perform a SIGNED comparison with 0.
           (the peephole optimizer can tighten this up to test/js/jns) */

        insn = new_insn(I_LIR_CMP, 0);      /* CMP $0, (signed) src */
        leaf_operand(&insn->operand[0], tree->child);
        insn->operand[0].t = T_LONG;
        I_OPERAND(&insn->operand[1], 0, T_LONG, 0);
        EMIT_INSN(insn);

        add_succ(current_block, CC_G, noadj_block);
        add_succ(current_block, CC_LE, adj_block);

        /* in range, treat the source as signed and it'll work fine */

        current_block = noadj_block;

        insn = new_insn(I_LIR_CAST, 0);     /* CAST (signed) src, dst */
        REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
        leaf_operand(&insn->operand[1], tree->child);
        insn->operand[1].t = T_LONG;
        EMIT_INSN(insn);

        add_succ(current_block, CC_ALWAYS, join_block);

        /* out of range. the basic idea here is to half the source value
           which brings it into range, then cast, and double the result.
           there's some additional bit-tweaking to account for rounding */

        current_block = adj_block;
        tmp = temp(tree->child->type);
        tmp2 = temp(tree->child->type);

        insn = new_insn(I_LIR_MOVE, 0);     /* MOVE src, tmp */
        REG_OPERAND(&insn->operand[0], 0, T_ULONG, symbol_to_reg(tmp));
        leaf_operand(&insn->operand[1], tree->child);
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_SHR, 0);      /* SHR $1, tmp, tmp */
        REG_OPERAND(&insn->operand[0], 0, T_ULONG, symbol_to_reg(tmp));
        insn->operand[1] = insn->operand[0];
        I_OPERAND(&insn->operand[2], 0, T_CHAR, 1);

        insn = new_insn(I_LIR_MOVE, 0);     /* MOVE src, tmp2 */
        REG_OPERAND(&insn->operand[0], 0, T_ULONG, symbol_to_reg(tmp2));
        leaf_operand(&insn->operand[1], tree->child);
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_AND, 0);      /* AND $1, tmp2, tmp2 */
        REG_OPERAND(&insn->operand[0], 0, T_ULONG, symbol_to_reg(tmp2));
        insn->operand[1] = insn->operand[0];
        I_OPERAND(&insn->operand[2], 0, T_ULONG, 1);
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_OR, 0);       /* OR tmp2, tmp, tmp */
        REG_OPERAND(&insn->operand[0], 0, T_ULONG, symbol_to_reg(tmp));
        insn->operand[1] = insn->operand[0];
        REG_OPERAND(&insn->operand[2], 0, T_ULONG, symbol_to_reg(tmp2));
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_CAST, 0);     /* CAST (signed) tmp, dst */
        REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
        REG_OPERAND(&insn->operand[1], 0, T_LONG, symbol_to_reg(tmp));
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_ADD, 0);      /* ADD dst, dst, dst */
        REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
        insn->operand[1] = insn->operand[0];
        insn->operand[2] = insn->operand[0];
        EMIT_INSN(insn);

        add_succ(current_block, CC_ALWAYS, join_block);

        current_block = join_block;
    } else if (VOID_TYPE(tree->type)) {
        return &void_tree;
    } else {
        insn = new_insn(I_LIR_CAST, 0);
        REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
        leaf_operand(&insn->operand[1], tree->child);
        EMIT_INSN(insn);
    }

    return sym_tree(sym);
}

/* E_ADDROF. the only possible child is an E_SYM referring to a block-level
   symbol; all globals have already been reduced to E_CONs by simplify(). */

static struct tree *gen_addrof(struct tree *tree)
{
    struct symbol *tmp;
    int offset;

    offset = symbol_offset(tree->child->sym);
    tmp = frame_addr(tree->type, offset, current_block,
                     NEXT_INSN_INDEX(current_block));

    /* mark the symbol aliased if we haven't already. */

    if (tree->child->sym->s & S_LOCAL) {
        tree->child->sym->s &= ~S_LOCAL;
        tree->child->sym->s |= S_AUTO;
    }

    return sym_tree(tmp);
}

/* extract a bit field from sym into a new temporary. if the field is
   unsigned and already in proper position, we can extract with a mask.
   otherwise we extract by shifts, relying on the semantics of right
   shift to copy the sign bit into vacated high bits of signed types.

   sym->type may not be the same as the bitfield type; it might only be
   simpatico (e.g., when the result is cast), so we must be sure to use
   bitfield's type during right shifts to get proper sign/zero extension. */

static struct symbol *extract_field(struct symbol *sym, struct tnode *type)
{
    int host_width = size_of(sym->type, 0) * BITS_PER_BYTE;
    int width = FIELD_WIDTH(type);
    int lsb = FIELD_LSB(type);
    struct symbol *tmp = temp(sym->type);
    struct insn *insn;

    if (UNSIGNED_TYPE(type) && (lsb == 0)) {
        insn = new_insn(I_LIR_AND, 0);
        REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
        REG_OPERAND(&insn->operand[1], sym->type, 0, symbol_to_reg(sym));
        I_OPERAND(&insn->operand[2], sym->type, 0, BIT_MASK(width));
        EMIT_INSN(insn);
    } else {
        int left_shift = host_width - (width + lsb);
        int right_shift = host_width - width;
        struct symbol *tmp2 = temp(sym->type);

        /* shift left into tmp2, then shift that right into tmp. using
           different registers keeps the results available for DVN. */

        insn = new_insn(I_LIR_SHL, 0);
        REG_OPERAND(&insn->operand[0], tmp2->type, 0, symbol_to_reg(tmp2));
        REG_OPERAND(&insn->operand[1], sym->type, 0, symbol_to_reg(sym));
        I_OPERAND(&insn->operand[2], 0, T_CHAR, left_shift);
        EMIT_INSN(insn);

        insn = new_insn(I_LIR_SHR, 0);
        REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
        REG_OPERAND(&insn->operand[1], type, 0, symbol_to_reg(tmp2));
        I_OPERAND(&insn->operand[2], 0, T_CHAR, right_shift);
        EMIT_INSN(insn);
    }

    return tmp;
}

/* return a temporary which is the result of inserting value
   into the host word sym as a bitfield of the specified type. */

static struct symbol *insert_field(struct tree *value, struct symbol *host,
                                   struct tnode *type)
{
    int host_width = size_of(host->type, 0) * BITS_PER_BYTE;
    int width = FIELD_WIDTH(type);
    int lsb = FIELD_LSB(type);
    struct symbol *tmp = temp(host->type);
    struct symbol *field = temp(value->type);
    struct insn *insn;
    long mask;

    insn = new_insn(I_LIR_AND, 0);
    REG_OPERAND(&insn->operand[0], field->type, 0, symbol_to_reg(field));
    leaf_operand(&insn->operand[1], value);
    I_OPERAND(&insn->operand[2], value->type, 0, BIT_MASK(width));
    EMIT_INSN(insn);

    insn = new_insn(I_LIR_SHL, 0);
    REG_OPERAND(&insn->operand[0], field->type, 0, symbol_to_reg(field));
    REG_OPERAND(&insn->operand[1], field->type, 0, symbol_to_reg(field));
    I_OPERAND(&insn->operand[2], 0, T_CHAR, lsb);
    EMIT_INSN(insn);

    insn = new_insn(I_LIR_AND, 0);
    REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
    REG_OPERAND(&insn->operand[1], host->type, 0, symbol_to_reg(host));
    I_OPERAND(&insn->operand[2], host->type, 0, ~(BIT_MASK(width) << lsb));
    EMIT_INSN(insn);

    insn = new_insn(I_LIR_OR, 0);
    REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
    REG_OPERAND(&insn->operand[1], tmp->type, 0, symbol_to_reg(tmp));
    REG_OPERAND(&insn->operand[2], field->type, 0, symbol_to_reg(field));
    EMIT_INSN(insn);

    return tmp;
}

/* fetch a value from memory: E_FETCH E_RFETCH. if fetching a bitfield, the
   value is extracted; in this case, the symbol holding the pre-extraction
   value is stored in *host. (the caller can pass in 0 if it is unneeded).

   we may be asked to fetch a strun: we simply ignore this. such a fetch is
   constrained by the parser to appear only in places where the compiler is
   uninterested in the actual value for the moment. we preserve the tree in
   case this is the final ('return') expression of a statement expression. */

static struct tree *gen_fetch(struct tree *tree, struct symbol **host)
{
    struct insn *insn;
    struct symbol *tmp;

    tree->child = gen0(tree->child);

    if (STRUN_TYPE(tree->type))
        return tree;

    tmp = temp(tree->type);
    insn = new_insn(I_LIR_LOAD, 0);
    leaf_operand(&insn->operand[1], tree->child);
    REG_OPERAND(&insn->operand[0], tree->type, 0, symbol_to_reg(tmp));
    if (VOLATILE_PTR_TYPE(tree->child->type)) insn->is_volatile = 1;
    EMIT_INSN(insn);

    if (FIELD_TREE(tree)) {
        if (host) *host = tmp;
        tmp = extract_field(tmp, DEREF(tree->child->type));
    }

    return sym_tree(tmp);
}

/* handles scalar assignment (E_ASG), also a helper for gen_compound(). the
   result of assignment is the value of the left operand (C89 6.3.16), but
   we usually return the right child, since further uses of the left child
   will cause excessive memory accesses if it is indirect and volatile. for
   bitfields, we must re-extract the value we inserted, to account for any
   truncation effected by the assignment.

   if the assignment is to a bitfield, then the caller may provide host,
   which holds the already-fetched value of the containing host word, to
   avoid another fetch. gen_compound() uses this. usually the optimizer
   will eliminate such extra fetches, but it can't if field is volatile,
   and if the field is volatile, the double-fetch would be double-bad. */

static struct tree *gen_assign(struct tree *tree, struct symbol *host)
{
    struct symbol *sym;
    struct insn *insn;

    tree->right = gen0(tree->right);

    if (tree->left->op == E_SYM) {
        sym = tree->left->sym;
        insn = new_insn(I_LIR_MOVE, 0);
        REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
        leaf_operand(&insn->operand[1], tree->right);
        EMIT_INSN(insn);
    } else {
        tree->left->child = gen0(tree->left->child);
        insn = new_insn(I_LIR_STORE, 0);
        leaf_operand(&insn->operand[0], tree->left->child);

        if (VOLATILE_PTR_TYPE(tree->left->child->type))
            insn->is_volatile = 1;

        if (FIELD_TREE(tree->left)) {
            if (host)
                sym = host;
            else
                gen_fetch(tree->left, &sym);

            sym = insert_field(tree->right, sym,
                               DEREF(tree->left->child->type));

            REG_OPERAND(&insn->operand[1], sym->type, 0, symbol_to_reg(sym));
            EMIT_INSN(insn);
            sym = extract_field(sym, DEREF(tree->left->child->type));
            tree->right = sym_tree(sym);
        } else {
            leaf_operand(&insn->operand[1], tree->right);
            EMIT_INSN(insn);
        }
    }

    tree = chop_right(tree);
    return tree;
}

/* compound assignments: E_MULASG E_DIVASG E_MODASG
                         E_ADDASG E_SUBASG E_POST
                         E_SHLASG E_SHRASG E_ANDASG
                         E_ORASG  E_XORASG

   much of the work is buried in gen_fetch() and gen_assign(), which deal
   with the details of memory accesses and bitfields. if assigning a field,
   we cache the value of the host word and pass it along to gen_assign() to
   avoid the double-fetch; see details above. */

static struct tree *gen_compound(struct tree *tree, int op)
{
    struct symbol *pre = 0;     /* if E_POST, the pre-modified value */
    struct symbol *host = 0;    /* if bitfield, tmp holding the host word */
    struct symbol *tmp;         /* result */
    struct symbol *lhs;
    struct insn *insn;

    tmp = temp(tree->type);
    tree->right = gen0(tree->right);

    if (tree->left->op == E_SYM)
        lhs = tree->left->sym;
    else
        lhs = gen_fetch(tree->left, &host)->sym;

    if (tree->op == E_POST) {
        pre = temp(tree->type);
        insn = new_insn(I_LIR_MOVE, 0);
        REG_OPERAND(&insn->operand[0], pre->type, 0, symbol_to_reg(pre));
        REG_OPERAND(&insn->operand[1], lhs->type, 0, symbol_to_reg(lhs));
        EMIT_INSN(insn);
    }

    if ((tree->op & E_HALF)
             && ((tree->op == E_DIVASG)     /* simpatico isn't good */
             ||  (tree->op == E_MODASG)     /* enough for divide ops */
             ||  !simpatico(tree->left->type, tree->right->type)))
    {
        /* we're only half-promoted; we must perform op
           as if both operands had the type of the right.
           casts can be non-trivial. we generate them from
           trees instead of directly so that simplify() and
           gen_cast() can handle the corner cases for us. */

        struct tree *tmp1;
        struct tree *tmp2;

        /* CAST lhs, (type of rhs) tmp1 */

        tmp1 = unary_tree(E_CAST, tree->right->type, sym_tree(lhs));
        tmp1 = gen(tmp1);   /* n.b.: NOT gen0(), need simplify() */

        /* <op> rhs, tmp1, tmp1 */

        insn = new_insn(op, 0);
        leaf_operand(&insn->operand[0], tmp1);
        leaf_operand(&insn->operand[1], tmp1);
        leaf_operand(&insn->operand[2], tree->right);
        EMIT_INSN(insn);

        /* CAST tmp1, (type of lhs) tmp2 */

        tmp2 = unary_tree(E_CAST, tree->left->type, tmp1);
        tmp2 = gen(tmp2);   /* again, NOT gen0() */

        /* MOVE tmp2, tmp (the result tmp) */

        insn = new_insn(I_LIR_MOVE, 0);
        REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
        leaf_operand(&insn->operand[1], tmp2);
        EMIT_INSN(insn);
    } else {
        insn = new_insn(op, 0);
        REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
        REG_OPERAND(&insn->operand[1], lhs->type, 0, symbol_to_reg(lhs));
        leaf_operand(&insn->operand[2], tree->right);
        EMIT_INSN(insn);
    }

    tree->right = sym_tree(tmp);
    tree = gen_assign(tree, host);
    return pre ? sym_tree(pre) : tree;
}

/* relational operators:    E_EQ E_NEQ E_GT E_LT E_GTEQ E_LTEQ

   all we need to do is map relations to condition codes, after considering
   the types of the operands. conveniently there are only two categories to
   consider: signed integers, and everything else. */

static struct tree *gen_rel(struct tree *tree)
{
    struct symbol *tmp;
    struct insn *insn;
    int cc;

    tree->left = gen0(tree->left);
    tree->right = gen0(tree->right);

    insn = new_insn(I_LIR_CMP, 0);
    leaf_operand(&insn->operand[0], tree->left);
    leaf_operand(&insn->operand[1], tree->right);
    EMIT_INSN(insn);

    switch (tree->op)
    {
    case E_EQ:   cc = CC_Z; break;
    case E_NEQ:  cc = CC_NZ; break;
    case E_GT:   cc = SIGNED_TYPE(tree->left->type) ? CC_G : CC_A; break;
    case E_LT:   cc = SIGNED_TYPE(tree->left->type) ? CC_L : CC_B; break;
    case E_GTEQ: cc = SIGNED_TYPE(tree->left->type) ? CC_GE : CC_AE; break;
    case E_LTEQ: cc = SIGNED_TYPE(tree->left->type) ? CC_LE : CC_BE; break;
    }

    tmp = temp(tree->type);
    insn = new_insn(I_CC_TO_LIR_SETCC(cc), 0);
    REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
    EMIT_INSN(insn);

    return sym_tree(tmp);
}

/* logical operators: E_LAND and E_LOR. what we emit here is a big mess
   that is subject to heavy rewriting by the optimizer (thank goodness). */

static struct tree *gen_log(struct tree *tree)
{
    struct symbol *tmp = temp(tree->type);
    struct block *right_block = new_block();
    struct block *true_block = new_block();
    struct block *false_block = new_block();
    struct block *join_block = new_block();
    struct insn *insn;

    insn = new_insn(I_LIR_MOVE, 0);
    REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
    I_OPERAND(&insn->operand[1], 0, T_INT, 0);
    append_insn(insn, false_block);
    add_succ(false_block, CC_ALWAYS, join_block);

    insn = new_insn(I_LIR_MOVE, 0);
    REG_OPERAND(&insn->operand[0], tmp->type, 0, symbol_to_reg(tmp));
    I_OPERAND(&insn->operand[1], 0, T_INT, 1);
    append_insn(insn, true_block);
    add_succ(true_block, CC_ALWAYS, join_block);

    tree->left = gen0(tree->left);

    if (tree->op == E_LOR)
        branch(tree->left, true_block, right_block);
    else
        branch(tree->left, right_block, false_block);

    current_block = right_block;
    tree->right = gen0(tree->right);
    branch(tree->right, true_block, false_block);
    current_block = join_block;

    return sym_tree(tmp);
}

/* the ternary operator (E_QUEST). as with the logical operators above,
   the output the convoluted, but the optimizer cleans it up later. */

#define TERNARY0(BLOCK, CHILD)                                              \
    do {                                                                    \
        struct insn *insn;                                                  \
                                                                            \
        current_block = BLOCK;                                              \
        tree->right->CHILD = gen0(tree->right->CHILD);                      \
                                                                            \
        if (tmp) {                                                          \
            insn = new_insn(I_LIR_MOVE, 0);                                 \
            REG_OPERAND(&insn->operand[0], tmp->type,                       \
                        0, symbol_to_reg(tmp));                             \
            leaf_operand(&insn->operand[1], tree->right->CHILD);            \
            EMIT_INSN(insn);                                                \
        }                                                                   \
                                                                            \
        add_succ(current_block, CC_ALWAYS, join_block);                     \
    } while (0)

static struct tree *gen_ternary(struct tree *tree)
{
    struct symbol *tmp = VOID_TYPE(tree->type) ? 0 : temp(tree->type);
    struct block *true_block = new_block();
    struct block *false_block = new_block();
    struct block *join_block = new_block();

    tree->left = gen0(tree->left);
    branch(tree->left, true_block, false_block);

    TERNARY0(true_block, left);
    TERNARY0(false_block, right);

    current_block = join_block;
    return tmp ? sym_tree(tmp) : &void_tree;
}

/* block operations: E_BLKCPY and E_BLKSET. this is easy because
   the LIR insns' operands mirror the trees' operands so closely. */

static struct tree *gen_blk(struct tree *tree, int op)
{
    struct insn *insn;

    tree->left = gen0(tree->left);
    tree->right = gen0(tree->right);

    insn = new_insn(op, 0);
    leaf_operand(&insn->operand[0], tree->left->left);
    leaf_operand(&insn->operand[1], tree->left->right);
    leaf_operand(&insn->operand[2], tree->right);
    EMIT_INSN(insn);

    tree = chop_left(tree);
    tree = chop_left(tree);

    return tree;
}

/* function call (E_CALL). straightforward, except for strun arguments. while
   the front end has rewritten struct-return so that it is transparent to us,
   it has left strun arguments untouched; though we pass struns by value, the
   LIR expects a T_STRUN argument value to be a pointer to the strun, with its
   size and alignment in the operand type, so we must do some fixing up. */

static struct tree *gen_call(struct tree *tree)
{
    struct symbol *sym = VOID_TYPE(tree->type) ? 0 : temp(tree->type);
    struct insn *insn = new_insn(I_LIR_CALL, tree->nr_args);
    struct operand *o;
    struct tnode *type;
    int i;

    for (i = 0; i < tree->nr_args; ++i) {
        o = &insn->operand[2 + i];
        type = tree->args[i]->type;

        if (STRUN_TYPE(type))
            tree->args[i] = addrof(tree->args[i], PTR(type));

        tree->args[i] = gen0(tree->args[i]);
        leaf_operand(o, tree->args[i]);

        if (STRUN_TYPE(type)) {
            o->t = T_STRUN;
            o->size = size_of(type, 0);
            o->align = align_of(type);
        }
    }

    tree->left = gen0(tree->left);
    leaf_operand(&insn->operand[1], tree->left);
    if (VARIADIC_FUNC_PTR(tree->left->type)) insn->is_variadic = 1;

    if (sym)
        REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
    else
        /* if the function returns void, leave the destination O_NONE */ ;

    EMIT_INSN(insn);

    return sym ? sym_tree(sym) : &void_tree;
}

static struct tree *gen0(struct tree *tree)
{
    switch (tree->op)
    {
    case E_NONE:
    case E_SYM:
    case E_CON:         return tree;

    case E_FETCH:
    case E_RFETCH:      return gen_fetch(tree, 0);

    case E_CALL:        return gen_call(tree);
    case E_CAST:        return gen_cast(tree);

    case E_ADDROF:      return gen_addrof(tree);
    case E_NEG:         return gen_unary(tree, I_LIR_NEG);
    case E_COM:         return gen_unary(tree, I_LIR_COM);

    case E_PLUS:        tree = chop(tree);
                        return gen0(tree);

    case E_ASG:         return gen_assign(tree, 0);

    case E_MULASG:      return gen_compound(tree, I_LIR_MUL);
    case E_DIVASG:      return gen_compound(tree, I_LIR_DIV);
    case E_MODASG:      return gen_compound(tree, I_LIR_MOD);
    case E_ADDASG:      return gen_compound(tree, I_LIR_ADD);
    case E_SUBASG:      return gen_compound(tree, I_LIR_SUB);
    case E_SHLASG:      return gen_compound(tree, I_LIR_SHL);
    case E_SHRASG:      return gen_compound(tree, I_LIR_SHR);
    case E_ANDASG:      return gen_compound(tree, I_LIR_AND);
    case E_ORASG:       return gen_compound(tree, I_LIR_OR);
    case E_XORASG:      return gen_compound(tree, I_LIR_XOR);
    case E_POST:        return gen_compound(tree, I_LIR_ADD);

    case E_DIV:         return gen_binary(tree, I_LIR_DIV);
    case E_MOD:         return gen_binary(tree, I_LIR_MOD);
    case E_MUL:         return gen_binary(tree, I_LIR_MUL);
    case E_ADD:         return gen_binary(tree, I_LIR_ADD);
    case E_SUB:         return gen_binary(tree, I_LIR_SUB);
    case E_SHR:         return gen_binary(tree, I_LIR_SHR);
    case E_SHL:         return gen_binary(tree, I_LIR_SHL);
    case E_XOR:         return gen_binary(tree, I_LIR_XOR);
    case E_AND:         return gen_binary(tree, I_LIR_AND);
    case E_OR:          return gen_binary(tree, I_LIR_OR);

    case E_EQ:
    case E_NEQ:
    case E_GT:
    case E_GTEQ:
    case E_LTEQ:
    case E_LT:          return gen_rel(tree);

    case E_LOR:
    case E_LAND:        return gen_log(tree);

    case E_QUEST:       return gen_ternary(tree);

            /* E_COLON is never generated itself, per se, but
               it's convenient to have it generate its children. */

    case E_COLON:       tree->left = gen0(tree->left);
                        tree->right = gen0(tree->right);
                        return tree;

            /* we could probably get away with merging E_COMMA and
               E_SEQ: the E_SEQ could generate a botched tree with
               a void type that isn't simpatico, but the result of
               E_SEQ should always be discarded, anyway. */

    case E_COMMA:       tree->left = gen0(tree->left);
                        tree->right = gen0(tree->right);
                        tree = chop_right(tree);
                        return tree;

    case E_SEQ:         tree->left = gen0(tree->left);
                        tree->right = gen0(tree->right);
                        return &void_tree;

    case E_BLKCPY:      return gen_blk(tree, I_LIR_BLKCPY);
    case E_BLKSET:      return gen_blk(tree, I_LIR_BLKSET);

    case E_BSF:         return gen_unary(tree, I_LIR_BSF);
    case E_BSR:         return gen_unary(tree, I_LIR_BSR);
    }
}

struct tree *gen(struct tree *tree)
{
    tree = simplify(tree);
    tree = rewrite_volatiles(tree);
    return gen0(tree);
}

/* vi: set ts=4 expandtab: */
