/*****************************************************************************

  func.c                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "reg.h"
#include "tree.h"
#include "block.h"
#include "symbol.h"
#include "heap.h"
#include "insn.h"
#include "lex.h"
#include "type.h"
#include "gen.h"
#include "opt.h"
#include "dom.h"
#include "live.h"
#include "dealias.h"
#include "lower.h"
#include "fuse.h"
#include "graph.h"
#include "switch.h"
#include "func.h"

#define FIRST_STACK_ARG     16      /* frame offset of first stack arguemnt */

struct symbol *current_func;        /* symbol of current function */
struct symbol *func_chain;          /* out-of-scope local function symbols */
struct symbol *func_hidden_arg;     /* hidden argument for struct return */
struct symbol *func_ret_sym;        /* anonymous symbol for return value */
struct tnode *func_ret_type;        /* type of function return value */
static int frame_size;              /* size of local frame storage */

/* we use this as an input to simple heuristics.
   in particular, mch_switch() in switch.c uses
   insn count to determine if long or short code
   addresses should be used. */

int func_size(void)
{
    struct block *b;
    int count = 0;

    FOR_ALL_BLOCKS(b) count += NR_INSNS(b);
    return count;
}

/* called for each argument as we enter a new function definition (in
   order). after some validation, we make arrangements to retrieve the
   arguments' values from the caller.

        1. the first MAX_IARGS discrete arguments and the first
           MAX_FARGS floating-point arguments will be passed in
           registers; everything else arrives on the stack, EXCEPT:
        2. all arguments to variadic functions arrive on the stack.
        3. volatiles always live in memory; if we receive a volatile
           argument in a register, we must immediately spill it.
        4. an old-style function definition with a float argument
           it will arrive as a double anyway, and we must cast it.

   the last is annoying. beware especially the old-style volatile float.

   note that each stack argument is aligned to STACK_ALIGN, which differs
   from the less restrictive policy applied to local frame storage. */

static int nr_iargs;            /* number of discrete reg arguments */
static int nr_fargs;            /* ........ floating-point ........ */
static int next_stack_arg;      /* frame offset of next stack argument */

static void arg0(struct symbol *sym)
{
    struct insn *insn;
    struct symbol *fix = 0;
    int size;

    if ((sym->id == 0) && !(sym->s & S_HIDDEN))
        error(ERROR, 0, "arguments must be named");

    if (sym->type == 0)
        /* old-style definition, default */
        sym->type = &int_type;

    size = size_of(sym->type, sym->id);

    if (sym->s & S_FIXFLOAT) {      /* the actual argument is a double, so */
        fix = sym;                  /* pretend the argument is too for now. */
        sym = temp(&double_type);   /* we will cast it back into sym later */
    }

    if (VARIADIC_FUNC(current_func->type) || STRUN_TYPE(sym->type)
      || (DISCRETE_TYPE(sym->type) && (nr_iargs == MAX_IARGS))
      || (FLOATING_TYPE(sym->type) && (nr_fargs == MAX_FARGS)))
    {
        sym->offset = next_stack_arg;       /* record stack position */
        next_stack_arg += size;
        next_stack_arg = ROUND_UP(next_stack_arg, STACK_ALIGN);

        if (STRUN_TYPE(sym->type) || VOLATILE_TYPE(sym->type))
            return;     /* nothing more to do */

        loadstore(I_LIR_LOAD, sym, current_block,
                  NEXT_INSN_INDEX(current_block));
    } else {
        insn = new_insn(I_LIR_ARG, 0);
        REG_OPERAND(&insn->operand[0], sym->type, 0, symbol_to_reg(sym));
        append_insn(insn, current_block);

        if (DISCRETE_TYPE(sym->type))
            ++nr_iargs;
        else
            ++nr_fargs;
    }

    if (fix) {
        insn = new_insn(I_LIR_CAST, 0);
        REG_OPERAND(&insn->operand[0], fix->type, 0, symbol_to_reg(fix));
        REG_OPERAND(&insn->operand[1], sym->type, 0, symbol_to_reg(sym));
        append_insn(insn, current_block);
        sym = fix;
    }

    /* this only applies to volatiles that arrive in registers, since we
       exited early for volatiles on the stack (above). this is the ONLY
       time a register associated with a volatile symbol is allocated or
       permitted in the IR, because rewrite_volatiles() eliminates direct
       references. dealias() must ignore 'aliased' volatiles, but there
       are otherwise no ill effects from breaking the rule here. */

    if (VOLATILE_TYPE(sym->type))
        loadstore(I_LIR_STORE, sym, current_block,
                  NEXT_INSN_INDEX(current_block));
}

/* we're at the opening brace of a function definition. funcdef() has
   already reentered LOCAL_SCOPE (importing the arguments) for us and
   processed the declaration-list for old-style definitions if present.

   our job is to reset the global function state, process incoming args
   and, if necessary, make arrangements for struct-return. it is the
   last part that consumes most of our energy. */

void enter_func(struct symbol *sym)
{
    current_func = sym;

    if (DEFINED_SYMBOL(sym))  /* ... homage to Greenhills/MPW C ... */
        error(ERROR, sym->id, "we already did this function %L", sym);

    HERE_SYMBOL(sym);
    sym->s |= S_DEFINED;

    reset_blocks();
    reset_dom();
    reset_regs();
    reset_reach();
    ++reg_generation;
    frame_size = 0;
    nr_iargs = 0;
    nr_fargs = 0;
    next_stack_arg = FIRST_STACK_ARG;
    func_ret_type = DEREF(sym->type);

    if (!VOID_TYPE(func_ret_type))      /* return type */
        size_of(func_ret_type, 0);      /* must be complete */

    if (STRUN_TYPE(func_ret_type)) {
        func_hidden_arg = temp(PTR(func_ret_type));
        func_hidden_arg->s |= S_HIDDEN | S_ARG;
        arg0(func_hidden_arg);
        func_ret_sym = temp(PTR(func_ret_type));
    } else {
        func_hidden_arg = 0;

        if (VOID_TYPE(func_ret_type))
            func_ret_sym = 0;
        else
            func_ret_sym = temp(func_ret_type);
    }

    walk_scope(LOCAL_SCOPE, S_ARG, arg0);

    if (STRUN_TYPE(func_ret_type)) {
        struct block *tmp = current_block;

        current_block = exit_block;

        gen(blk_tree(E_BLKCPY,
                     sym_tree(func_hidden_arg),
                     sym_tree(func_ret_sym),
                     I_TREE(&ulong_type, size_of(func_ret_type, 0))));

        current_block = tmp;
    }

    append_insn(new_insn(I_LIR_RETURN, 0), exit_block);
}

/* output the function. we output the blocks in a modified RPO order,
   and tie them together with branches. we take the opportunity to do
   a little bit of final polishing:

    1. if a block branches to a trivial exit_block (RET only), and
       and we can safely rewrite the jump as a RET instead, do it.

    2. if the exit_block is trivial and all its predecessors issued
       RET themselves, don't bother to emit the [unused] exit_block. */

void out_func(void)
{
    struct block *b;
    int trivial_exit;       /* if the exit block is trivial */
    int shortcuts = 0;      /* number of shortcut RETs issued */
    int fallthru;
    int i;

    trivial_exit = (NR_INSNS(exit_block) == 1);

    loop_sequence();
    seg(SEG_TEXT);
    out("\n%g:\n", current_func);

    for (b = all_blocks; b; b = b->next) {
        if (trivial_exit                    /* exit block is trivial, */
          && (b == exit_block)              /* this is the exit_block */
          && (NR_PREDS(b) == shortcuts))    /* we've shortcut every ret */
            continue;                       /* so don't bother to emit it */

        out_block(b);

        /* blocks still labeled B_SWITCH at this point have table-
           driven jump logic; b->control holds the target address. */

        if (b->flags & B_SWITCH) {
            OUTS("\tjmp ");
            out_operand(&b->control, 1);
            OUTC('\n');
            continue;
        }

        fallthru = 0;

        for (i = 0; i < NR_SUCCS(b); ++i) {
            if (SUCC(b, i).b == b->next) {
                fallthru = 1;   /* will fall through */
                continue;       /* so just say nothing */
            }

            if (trivial_exit                /* the exit block is trivial, */
              && !fallthru                  /* no fallthru to next block, */
              && (i == (NR_SUCCS(b) - 1))       /* this is the last branch */
              && (SUCC(b, i).b == exit_block))  /* and it heads to out ... */
            {
                OUTS("\tret\n");
                ++shortcuts;
                continue;
            }

            out("\t%s %L\n", cc_text[SUCC(b, i).cc], SUCC(b, i).b->asmlab);
        }
    }

    OUTC('\n');
}

/* generate function prolog and epilog. called as
   the last step before the function is output. */

static void logues(void)
{
    VECTOR(reg) func_regs;
    VECTOR(reg) scratch_regs;
    VECTOR(reg) save_regs;
    int need_frame;
    int i, j, reg;
    int nr_fsave;
    int entry_i, exit_i;
    struct insn *insn;

    /* the biggest job of the logues is to save and restore the
       callee-save registers, so figure out what those are */

    INIT_VECTOR(scratch_regs, &func_arena);

    for (i = 0; i < MAX_ISCRATCH; ++i) add_reg(&scratch_regs, iscratch[i]);
    for (i = 0; i < MAX_FSCRATCH; ++i) add_reg(&scratch_regs, fscratch[i]);

    INIT_VECTOR(func_regs, &func_arena);
    INIT_VECTOR(save_regs, &func_arena);
    all_regs(&func_regs);
    diff_regs(&save_regs, &func_regs, &scratch_regs);

    need_frame = 0;     /* if we need to create a proper frame */
    nr_fsave = 0;       /* number of fregs that must be saved */

    FOR_EACH_REG(save_regs, j, reg) {
        if (reg == REG_RSP) continue;

        if (REG_GP(reg)) {
            if (reg == REG_RBP)
                need_frame = 1;
        } else
            ++nr_fsave;
    }

    /* set aside space in the frame for any saved
       floating-point regs, and finally adjust the
       frame size to keep the stack aligned */

    frame_size += nr_fsave * 8; /* sizeof(double) */
    frame_size = ROUND_UP(frame_size, STACK_ALIGN);
    if (frame_size) need_frame = 1;

    /* we insert the logues as matching insns, forwards
       in the entry block, and backwards from the RET in
       the exit block (always the last insn in that block) */

    entry_i = 0;
    exit_i = NR_INSNS(exit_block) - 1;

    if (need_frame) {
        insn = new_insn(I_MCH_PUSHQ, 0);
        REG_OPERAND(&insn->operand[0], 0, 0, REG_RBP);
        insert_insn(insn, entry_block, entry_i++);

        insn = new_insn(I_MCH_POPQ, 0);
        REG_OPERAND(&insn->operand[0], 0, 0, REG_RBP);
        insert_insn(insn, exit_block, exit_i);

        insn = new_insn(I_MCH_MOVQ, 0);
        REG_OPERAND(&insn->operand[0], 0, 0, REG_RBP);
        REG_OPERAND(&insn->operand[1], 0, 0, REG_RSP);
        insert_insn(insn, entry_block, entry_i++);

        if (frame_size) {
            insn = new_insn(I_MCH_SUBQ, 0);
            REG_OPERAND(&insn->operand[0], 0, 0, REG_RSP);
            I_OPERAND(&insn->operand[1], 0, T_LONG, frame_size);
            insert_insn(insn, entry_block, entry_i++);

            insn = new_insn(I_MCH_MOVQ, 0);
            REG_OPERAND(&insn->operand[0], 0, 0, REG_RSP);
            REG_OPERAND(&insn->operand[1], 0, 0, REG_RBP);
            insert_insn(insn, exit_block, exit_i);
        }
    }

    /* XMM regs are manually moved to/from the frame */

    i = -frame_size;

    FOR_EACH_REG(save_regs, j, reg)
        if (REG_XMM(reg)) {
            struct operand addr;
            struct operand xmm;

            REG_OPERAND(&xmm, 0, 0, reg);
            BASED_OPERAND(&addr, 0, 0, O_MEM, REG_RBP, i);

            insert_insn(move(T_DOUBLE, &addr, &xmm), entry_block, entry_i++);
            insert_insn(move(T_DOUBLE, &xmm, &addr), exit_block, exit_i);

            i += 8;
        }

    /* GP regs are saved/restored with PUSHQ/POPQ */

    FOR_EACH_REG(save_regs, j, reg)
        if (REG_GP(reg) && (reg != REG_RBP) & (reg != REG_RSP)) {
            insn = new_insn(I_MCH_PUSHQ, 0);
            REG_OPERAND(&insn->operand[0], 0, 0, reg);
            insert_insn(insn, entry_block, entry_i++);

            insn = new_insn(I_MCH_POPQ, 0);
            REG_OPERAND(&insn->operand[0], 0, 0, reg);
            insert_insn(insn, exit_block, exit_i);
        }
}

/* called from funcdef() after it's closed the function LOCAL_SCOPE */

void exit_func(void)
{
    add_succ(current_block, CC_ALWAYS, exit_block);
    registerize(&func_chain);

    dealias();

    opt(OPT_LIR_PASSES | OPT_ANY_PASSES, OPT_MCH_PASSES);

    lir_switch();               /* simple switches -> LIR */

    /* if deconst() actually does anything, run another (abbreviated)
       opt() pass to deal with any redundant load/stores we might have
       issued, but not OPT_LIR_FOLD, as it will simply undo the work ... */

    if (deconst()) opt(OPT_LIR_HOIST | OPT_LIR_DVN,
                       OPT_LIR_FOLD | OPT_MCH_PASSES);

    lower();                    /* convert to MCH IR */
    mch_switch();               /* complex switches -> MCH */

    /* first MCH optimization pass; cleans up the output from lower
       and also gives us an opportunity to run the PRECOLOR pass(es). */

    opt(OPT_MCH_PRECOLOR | OPT_MCH_PASSES | OPT_ANY_PASSES, OPT_LIR_PASSES);

    color();                    /* allocate registers */

    /* the register allocator interleaves OPT_MCH_PASSES with
       coalescing and spilling; we give it a last once-over. */

    opt(OPT_MCH_PASSES | OPT_ANY_PASSES, OPT_LIR_PASSES);

    /* and now the final passes; rewrite to eliminate synthetic insns
       and perform optimizations that can mangle the IR a bit. */

    lower_more();
    opt(OPT_MCH_FINAL, ~OPT_MCH_FINAL);

    logues();                       /* generate prolog/epilog */
    out_func();
    free_symbols(&func_chain);
    ARENA_FREE(&func_arena);
    current_func = 0;
}

/* we align local objects according to their types (contrast with stack
   arguments, which are each aligned to STACK_ALIGN). we round the total
   storage to STACK_ALIGN when generating the function prolog. */

int frame_alloc(struct tnode *type)
{
    int size = size_of(type, 0);
    int align = align_of(type);

    frame_size += size;
    frame_size = ROUND_UP(frame_size, align);

    return -frame_size;
}

/* temporaries can be allocated at any time while processing a function, so

    (1) we must add the temporary directly to the func_chain to ensure it
        gets cleaned up. if we're not actually processing a function, this
        is fine because eventually whatever the user is doing will error.
        (e.g., calling a struct-return function in a static initializer)

    (2) we can't rely on the usual alias analyis to decide on the symbol's
        final storage class. this is no problem, since temporary scalars
        are never aliased (S_REGISTER) and non-scalars always are (S_AUTO). */

struct symbol *temp(struct tnode *type)
{
    struct symbol *sym;

    sym = new_symbol(0, S_TEMP | (SCALAR_TYPE(type) ? S_REGISTER : S_AUTO));
    sym->type = type;
    sym->link = func_chain;
    func_chain = sym;

    return sym;
}

int temp_reg(long t)
{
    struct tnode *type = get_tnode(t, 0, 0);
    struct symbol *sym = temp(type);
    return symbol_to_reg(sym);
}

/* vi: set ts=4 expandtab: */
