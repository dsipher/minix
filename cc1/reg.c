/*****************************************************************************

  reg.c                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "heap.h"
#include "type.h"
#include "symbol.h"
#include "reg.h"

/* registers used for passing arguments to functions.
   (in order). these roughly follow the System V ABI */

int iargs[MAX_IARGS] = { REG_RDI, REG_RSI, REG_RDX,
                         REG_RCX, REG_R8, REG_R9 };

int fargs[MAX_FARGS] = { REG_XMM0, REG_XMM1, REG_XMM2, REG_XMM3,
                         REG_XMM4, REG_XMM5, REG_XMM6, REG_XMM7 };

/* callee-saved registers. we differ from the System V
   ABI in that we do not nuke *all* the XMM regs. this
   is better for general-purpose (non-scientific) use. */

int iscratch[MAX_ISCRATCH] = { REG_RAX, REG_RDI, REG_RSI, REG_RDX, REG_RCX,
                               REG_R8,  REG_R9,  REG_R10, REG_R11 };

int fscratch[MAX_FSCRATCH] = { REG_XMM0, REG_XMM1, REG_XMM2, REG_XMM3,
                               REG_XMM4, REG_XMM5, REG_XMM6, REG_XMM7 };

/* these must match the indices assigned the registers in reg.h.
   they are ordered to put scratch registers first, so the graph
   allocator will prioritize them. */

static const char *gp_names[] =
{
        "%al",          "%ax",          "%eax",         "%rax",
        "%cl",          "%cx",          "%ecx",         "%rcx",
        "%dl",          "%dx",          "%edx",         "%rdx",
        "%sil",         "%si",          "%esi",         "%rsi",
        "%dil",         "%di",          "%edi",         "%rdi",
        "%r8b",         "%r8w",         "%r8d",         "%r8",
        "%r9b",         "%r9w",         "%r9d",         "%r9",
        "%r10b",        "%r10w",        "%r10d",        "%r10",
        "%r11b",        "%r11w",        "%r11d",        "%r11",
        "%bl",          "%bx",          "%ebx",         "%rbx",
        "%spl",         "%sp",          "%esp",         "%rsp",
        "%bpl",         "%bp",          "%ebp",         "%rbp",
        "%r12b",        "%r12w",        "%r12d",        "%r12",
        "%r13b",        "%r13w",        "%r13d",        "%r13",
        "%r14b",        "%r14w",        "%r14d",        "%r14",
        "%r15b",        "%r15w",        "%r15d",        "%r15"
};

static const char *other_names[] =
{
        "%xmm0",        "%xmm1",        "%xmm2",        "%xmm3",
        "%xmm4",        "%xmm5",        "%xmm6",        "%xmm7",
        "%xmm8",        "%xmm9",        "%xmm10",       "%xmm11",
        "%xmm12",       "%xmm13",       "%xmm14",       "%xmm15",

        "%cc",          "%mem"
};

/* we always assume the full-sized register unless there is compelling
   evidence to the contrary; i.e., we always use the full register name
   unless we're specifically dealing with sub-word integer types. */

void print_reg(FILE *fp, int reg, long t)
{
    int size = 3;

    if (REG_GP(reg)) {
        switch (T_BASE(t))
        {
        case T_CHAR:    case T_SCHAR:   case T_UCHAR:   --size;
        case T_SHORT:   case T_USHORT:                  --size;
        case T_INT:     case T_UINT:                    --size;
        }
    }

    if (MACHINE_REG(reg)) {
        /* use a table lookup for machine regs, even the XMM
           registers whose names could easily be constructed. */

        if (REG_GP(reg))
            fputs(gp_names[REG_INDEX(reg) * 4 + size], fp);
        else
            fputs(other_names[REG_INDEX(reg) - NR_GP_REGS], fp);
    } else {
        /* we resort to printf() for pseudo regs, but that's okay,
           since they will only be output for debugging purposes. */

        fprintf(fp, "%%%c%d", REG_GP(reg) ? 'i' : 'f', REG_INDEX(reg));
        if (REG_GP(reg)) putc(size["bwdq"], fp);
        if (REG_SUB(reg)) fprintf(fp, ".%d", REG_SUB(reg));
    }
}

void add_regmap(VECTOR(regmap) *map, int from, int to)
{
    struct regmap new = { from, to };
    int n;

    for (n = 0; n < VECTOR_SIZE(*map); ++n)
        if (REGMAP_PRECEDES(VECTOR_ELEM(*map, n), new))
            break;

    VECTOR_INSERT(*map, n, 1);
    VECTOR_ELEM(*map, n) = new;
}

int same_regmap(VECTOR(regmap) *map1, VECTOR(regmap) *map2)
{
    int n;

    if (VECTOR_SIZE(*map1) != VECTOR_SIZE(*map2))
        return 0;

    for (n = 0; n < VECTOR_SIZE(*map1); ++n)
        if ((VECTOR_ELEM(*map1, n).from != VECTOR_ELEM(*map2, n).from)
          || (VECTOR_ELEM(*map1, n).to != VECTOR_ELEM(*map2, n).to))
            return 0;

    return 1;
}

void regmap_regs(VECTOR(regmap) *map, VECTOR(reg) *set)
{
    int i;

    for (i = 0; i < VECTOR_SIZE(*map); ++i)
        if (VECTOR_ELEM(*map, i).from)
            add_reg(set, VECTOR_ELEM(*map, i).from);
}

/* because regmaps tend to be small (tiny, really), it's actually just as
   efficient (or even more efficient) to sort the map after major changes
   rather than trying to keep it in order. long live the bubble sort.

   this is really efficiency theatre- the only reason we keep the regmaps
   sorted is to make same_regmap() easy; again, since regmaps tend to have
   so few elements (they're only for __asm statements) efficiency is moot */

static void sort_regmap(VECTOR(regmap) *map)
{
    int n;
    int changed;

    do {
        changed = 0;

        for (n = 0; n < (VECTOR_SIZE(*map) - 1); ++n)
            if (REGMAP_PRECEDES(VECTOR_ELEM(*map, n + 1),
                                VECTOR_ELEM(*map, n)))
            {
                SWAP(struct regmap, VECTOR_ELEM(*map, n + 1),
                                    VECTOR_ELEM(*map, n));
                ++changed;
            }

    } while (changed);
}

void invert_regmap(VECTOR(regmap) *map)
{
    int n;

    for (n = 0; n < VECTOR_SIZE(*map); ++n)
        SWAP(int, VECTOR_ELEM(*map, n).from, VECTOR_ELEM(*map, n).to);

    sort_regmap(map);
}

void undecorate_regmap(VECTOR(regmap) *map)
{
    int n;

    for (n = 0; n < VECTOR_SIZE(*map); ++n) {
        REG_SET_SUB(VECTOR_ELEM(*map, n).to, 0);
        REG_SET_SUB(VECTOR_ELEM(*map, n).from, 0);
    }
}

#define SUBSTITUTE0(fromto)                                                 \
    do {                                                                    \
        if (VECTOR_ELEM(*map, i).fromto == src) {                           \
            ++count;                                                        \
            VECTOR_ELEM(*map, i).fromto = dst;                              \
        }                                                                   \
    } while (0)

int regmap_substitute(VECTOR(regmap) *map, int src, int dst)
{
    int count = 0;
    int i;

    for (i = 0; i < VECTOR_SIZE(*map); ++i) {
        SUBSTITUTE0(from);
        SUBSTITUTE0(to);
    }

    if (count) sort_regmap(map);

    return count;
}

void out_regmap(VECTOR(regmap) *map)
{
    int i;

    OUTC('[');

    for (i = 0; i < VECTOR_SIZE(*map); ++i) {
        if (i != 0) OUTC(' ');

        if (VECTOR_ELEM(*map, i).from)
            out("%r", VECTOR_ELEM(*map, i).from);

        if (VECTOR_ELEM(*map, i).to)
            out(":%r", VECTOR_ELEM(*map, i).to);
    }

    OUTC(']');
}

int nr_assigned_regs;

VECTOR(symbol) reg_to_symbol;

void reset_regs(void)
{
    nr_assigned_regs = NR_MACHINE_REGS;
    INIT_VECTOR(reg_to_symbol, &func_arena);
}

int assign_reg(struct symbol *sym)
{
    int index = nr_assigned_regs++;
    int i = index - NR_MACHINE_REGS;
    int reg;

    RESIZE_VECTOR(reg_to_symbol, (i + 1));
    VECTOR_ELEM(reg_to_symbol, i) = sym;

    if (FLOATING_TYPE(sym->type))
        reg = REG_TYPE_XMM;
    else
        reg = REG_TYPE_GP;

    REG_SET_INDEX(reg, index);

    return reg;
}

void add_reg(VECTOR(reg) *set, int reg)
    SET_ADD(reg, REG_PRECEDES)

void remove_reg(VECTOR(reg) *set, int reg)
    SET_REMOVE(reg, REG_PRECEDES)

int contains_reg(VECTOR(reg) *set, int reg)
    SET_CONTAINS(reg, REG_PRECEDES)

int same_regs(VECTOR(reg) *set1, VECTOR(reg) *set2)
    SAME_SET()

void union_regs(VECTOR(reg) *dst, VECTOR(reg) *src1, VECTOR(reg) *src2)
    UNION_SETS(int, REG_PRECEDES)

void intersect_regs(VECTOR(reg) *dst, VECTOR(reg) *src1, VECTOR(reg) *src2)
    INTERSECT_SETS(REG_PRECEDES)

void diff_regs(VECTOR(reg) *dst, VECTOR(reg) *src1, VECTOR(reg) *src2)
    DIFF_SETS(REG_PRECEDES)

void replace_indexed_regs(VECTOR(reg) *dst, VECTOR(reg) *src)
{
    int i = 0;
    int j = 0;

    while ((i < VECTOR_SIZE(*dst)) && (j < VECTOR_SIZE(*src)))
    {
        int dst_basis = REG_BASIS(VECTOR_ELEM(*dst, i));
        int src_basis = REG_BASIS(VECTOR_ELEM(*src, j));

        if (REG_PRECEDES(dst_basis, src_basis))
            /* dst not in src, keep it */
            ++i;
        else if (dst_basis == src_basis)
            /* dst is in src, delete it */
            VECTOR_DELETE(*dst, i, 1);
        else {
            /* src is not in dst, add it */
            VECTOR_INSERT(*dst, i, 1);
            VECTOR_ELEM(*dst, i) = VECTOR_ELEM(*src, j);
            ++i;
            ++j;
        }
    }

    while (j < VECTOR_SIZE(*src)) {
        GROW_VECTOR(*dst, 1);
        VECTOR_LAST(*dst) = VECTOR_ELEM(*src, j);
        ++j;
    }
}

void select_indexed_regs(VECTOR(reg) *dst, VECTOR(reg) *src, int reg)
{
    int i;

    for (i = 0; i < VECTOR_SIZE(*src); ++i)
        if (REG_BASIS(VECTOR_ELEM(*src, i)) == REG_BASIS(reg))
            add_reg(dst, VECTOR_ELEM(*src, i));
}

void out_regs(VECTOR(reg) *set)
{
    int i;

    OUTC('[');

    for (i = 0; i < VECTOR_SIZE(*set); ++i) {
        if (i > 0) OUTC(' ');
        out("%r", VECTOR_ELEM(*set, i));
    }

    OUTC(']');
}

/* vi: set ts=4 expandtab: */
