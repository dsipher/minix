# 1 "reg.c"

# 15 "/home/charles/xcc/include/sys/jewel.h"
typedef long            __blkcnt_t;
typedef long            __blksize_t;
typedef unsigned long   __dev_t;
typedef unsigned        __gid_t;
typedef unsigned long   __ino_t;
typedef unsigned        __mode_t;
typedef unsigned long   __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 18 "/home/charles/xcc/include/stdio.h"
typedef __off_t fpos_t;



typedef __size_t size_t;








typedef struct __iobuf
{
    int _count;
    int _fd;
    int _flags;
    int _bufsiz;
    unsigned char *_buf;
    unsigned char *_ptr;
} FILE;

















extern FILE *__iotab[20];
extern FILE __stdin, __stdout, __stderr;








extern int __fillbuf(FILE *);
extern int __flushbuf(int, FILE *);

extern void clearerr(FILE *);
extern int fclose(FILE *);
extern int fflush(FILE *);
extern int fileno(FILE *);
extern char *fgets(char *, int n, FILE *);
extern int fgetpos(FILE *, fpos_t *);
extern int fsetpos(FILE *, fpos_t *);
extern int fprintf(FILE *, const char *, ...);
extern int fputc(int, FILE *);
extern int fputs(const char *, FILE *);
extern FILE *fopen(const char *, const char *);
extern size_t fread(void *, size_t, size_t, FILE *);
extern int fscanf(FILE *, const char *, ...);
extern int fseek(FILE *, long, int);
extern long ftell(FILE *);
extern size_t fwrite(const void *, size_t, size_t, FILE *);
extern char *gets(char *);
extern int printf(const char *, ...);
extern int puts(const char *);
extern int remove(const char *);
extern void rewind(FILE *);
extern int rename(const char *, const char *);
extern int scanf(const char *, ...);
extern int sscanf(const char *, const char *, ...);
extern void setbuf(FILE *, char *);
extern int setvbuf(FILE *, char *, int, size_t);
extern int sprintf(char *, const char *, ...);
extern int ungetc(int, FILE *);
extern int vfprintf(FILE *, const char *, __va_list);
extern int vfscanf(FILE *, const char *, __va_list);
extern int vsprintf(char *, const char *, __va_list);
# 15 "cc1.h"
struct string;
# 100 "cc1.h"
extern char g_flag;
extern char w_flag;



union con { long i; unsigned long u; double f; };




extern int last_asmlab;








void seg(int newseg);

















extern void error(int level, struct string *id, char *fmt, ...);




extern void out(char *fmt, ...);

extern FILE *out_f;
# 22 "/home/charles/xcc/include/stddef.h"
typedef long ptrdiff_t;
# 49 "heap.h"
struct arena { void *bottom; void *top; };

extern struct arena global_arena;
extern struct arena func_arena;
extern struct arena stmt_arena;
extern struct arena local_arena;
extern struct arena string_arena;

void init_arenas(void);




void init_arena(struct arena *a, size_t size);
# 105 "heap.h"
struct slab
{
    int per_obj;
    int per_slab;
    struct slab_obj { struct slab_obj *next; } *free;
    int alloc, avail;
};

struct slab_obj *refill_slab(struct slab *s);
# 160 "heap.h"
struct vector
{
    int cap;
    int size;
    void *elements;
    struct arena *arena;
};
# 190 "heap.h"
struct int_vector { int cap; int size; int *elements; struct arena *arena; };










void vector_insert(struct vector *v, int i, int n, int elem_size);







void vector_delete(struct vector *v, int i, int n, int elem_size);






void dup_vector(struct vector *dst, struct vector *src, int elem_size);
# 286 "heap.h"
struct bitvec_vector { int cap; int size; long *elements; struct arena *arena; };
# 13 "type.h"
struct string;
# 128 "type.h"
int t_size(long t);










struct tnode
{
    long t;
    unsigned long hash;

    union
    {
        long u;

        int nelem;
        struct symbol *tag;
        struct formal *formals;
    };

    struct tnode *next;
    struct tnode *link;
};

struct formal { struct tnode *type; struct formal *next; };




extern struct tnode void_type;
extern struct tnode char_type;
extern struct tnode schar_type;
extern struct tnode uchar_type;
extern struct tnode short_type;
extern struct tnode ushort_type;
extern struct tnode int_type;
extern struct tnode uint_type;
extern struct tnode long_type;
extern struct tnode ulong_type;
extern struct tnode float_type;
extern struct tnode double_type;
extern struct tnode ldouble_type;

void seed_types(void);




struct tnode *map_type(int ks);






struct tnode *new_tnode(long t, long u, struct tnode *next);



void new_formal(struct tnode *tn, struct tnode *type);




struct tnode *graft(struct tnode *prefix, struct tnode *type);




struct tnode *get_tnode(long t, long u, struct tnode *next);
# 281 "type.h"
struct tnode *qualify(struct tnode *type, long quals);
struct tnode *unqualify(struct tnode *type);



int compat(struct tnode *type1, struct tnode *type2);




struct tnode *compose(struct tnode *type1, struct tnode *type2,
                      struct symbol *sym);



struct tnode *formal_type(struct tnode *type);




struct tnode *fieldify(struct tnode *type, int width, int lsb);




struct tnode *unfieldify(struct tnode *type);




int size_of(struct tnode *type, struct string *id);




int align_of(struct tnode *type);










int simpatico(struct tnode *type1, struct tnode *type2);




int narrower(struct tnode *dst, struct tnode *src);
int wider(struct tnode *dst, struct tnode *src);





void validate(struct tnode *type, struct string *id, int void_ok);
# 21 "symbol.h"
extern int current_scope;
extern int outer_scope;
# 146 "symbol.h"
struct symbol_vector { int cap; int size; struct symbol * *elements; struct arena *arena; };

struct symbol
{
    struct string *id;
    int scope;
    int s;

    int num;

    int line_no;
    struct string *path;

    union
    {


        struct
        {
            struct tnode *type;

            int reg;
            int generation;

            union
            {
                int asmlab;
                int value;
                int offset;
                struct block *b;
                struct symbol *redirect;
            };
        };









        struct
        {
            int size;
            int align;

            struct symbol *chain;
            struct symbol *members;
        };
    };

    struct symbol *link;
    struct symbol **prev, *next;
};
# 227 "symbol.h"
struct symbol *new_symbol(struct string *id, int s);



void free_symbols(struct symbol **chainp);



void insert(struct symbol *sym, int scope);




void redirect(struct symbol *sym, int scope);






struct symbol *lookup(struct string *id, int ss, int inner, int outer);



struct symbol *lookup_member(struct string *id, struct symbol *tag);





void unique(struct string *id, int ss, int scope, struct symbol *tag);



struct tnode *named_type(struct string *id);


















struct symbol *global(struct string *id, int s,
                      struct tnode *type, int scope);



struct symbol *implicit(struct string *id);



void enter_scope(int strun);





void exit_scope(struct symbol **chainp);




void walk_scope(int scope, int ss, void f(struct symbol *));





void reenter_scope(struct symbol **chainp);







void insert_member(struct symbol *tag, struct string *id, struct tnode *type);





void exit_strun(struct symbol *tag);




struct symbol *lookup_label(struct string *id);





void check_labels(void);




struct symbol *anon_static(struct tnode *type, int asmlab);




void purge_anons(void);




void registerize(struct symbol **chainp);



extern int reg_generation;




int symbol_to_reg(struct symbol *sym);




int symbol_offset(struct symbol *sym);




void print_global(FILE *fp, struct symbol *sym);





void out_globls(void);
# 25 "reg.h"
extern int iargs[6];
extern int fargs[8];







extern int iscratch[9];
extern int fscratch[8];
# 154 "reg.h"
struct reg_vector { int cap; int size; int *elements; struct arena *arena; };










void add_reg(struct reg_vector *set, int reg);

int contains_reg(struct reg_vector *set, int reg);

int same_regs(struct reg_vector *set1, struct reg_vector *set2);

void union_regs(struct reg_vector *dst, struct reg_vector *src1,
                                  struct reg_vector *src2);

void intersect_regs(struct reg_vector *dst,
                    struct reg_vector *src1,
                    struct reg_vector *src2);

void diff_regs(struct reg_vector *dst, struct reg_vector *src1,
                                 struct reg_vector *src2);














void replace_indexed_regs(struct reg_vector *dst, struct reg_vector *src);




void select_indexed_regs(struct reg_vector *dst, struct reg_vector *src, int reg);



void out_regs(struct reg_vector *set);



struct regmap { int from; int to; };
struct regmap_vector { int cap; int size; struct regmap *elements; struct arena *arena; };











void add_regmap(struct regmap_vector *map, int from, int to);



int same_regmap(struct regmap_vector *map1, struct regmap_vector *map2);



void regmap_regs(struct regmap_vector *map, struct reg_vector *set);




int regmap_substitute(struct regmap_vector *map, int src, int dst);



void invert_regmap(struct regmap_vector *map);



void undecorate_regmap(struct regmap_vector *map);



void out_regmap(struct regmap_vector *map);





extern int nr_assigned_regs;




extern struct symbol_vector reg_to_symbol;






void reset_regs(void);




int assign_reg(struct symbol *sym);




void print_reg(FILE *fp, int reg, long t);
# 19 "reg.c"
int iargs[6] = { (((4) < 16) ? (((4) << 14) | 0x80000000) : (((4) << 14) | 0xC0000000)), (((3) < 16) ? (((3) << 14) | 0x80000000) : (((3) << 14) | 0xC0000000)), (((2) < 16) ? (((2) << 14) | 0x80000000) : (((2) << 14) | 0xC0000000)),
                         (((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000)), (((5) < 16) ? (((5) << 14) | 0x80000000) : (((5) << 14) | 0xC0000000)), (((6) < 16) ? (((6) << 14) | 0x80000000) : (((6) << 14) | 0xC0000000)) };

int fargs[8] = { (((16) < 16) ? (((16) << 14) | 0x80000000) : (((16) << 14) | 0xC0000000)), (((17) < 16) ? (((17) << 14) | 0x80000000) : (((17) << 14) | 0xC0000000)), (((18) < 16) ? (((18) << 14) | 0x80000000) : (((18) << 14) | 0xC0000000)), (((19) < 16) ? (((19) << 14) | 0x80000000) : (((19) << 14) | 0xC0000000)),
                         (((20) < 16) ? (((20) << 14) | 0x80000000) : (((20) << 14) | 0xC0000000)), (((21) < 16) ? (((21) << 14) | 0x80000000) : (((21) << 14) | 0xC0000000)), (((22) < 16) ? (((22) << 14) | 0x80000000) : (((22) << 14) | 0xC0000000)), (((23) < 16) ? (((23) << 14) | 0x80000000) : (((23) << 14) | 0xC0000000)) };





int iscratch[9] = { (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000)), (((4) < 16) ? (((4) << 14) | 0x80000000) : (((4) << 14) | 0xC0000000)), (((3) < 16) ? (((3) << 14) | 0x80000000) : (((3) << 14) | 0xC0000000)), (((2) < 16) ? (((2) << 14) | 0x80000000) : (((2) << 14) | 0xC0000000)), (((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000)),
                               (((5) < 16) ? (((5) << 14) | 0x80000000) : (((5) << 14) | 0xC0000000)),  (((6) < 16) ? (((6) << 14) | 0x80000000) : (((6) << 14) | 0xC0000000)),  (((7) < 16) ? (((7) << 14) | 0x80000000) : (((7) << 14) | 0xC0000000)), (((8) < 16) ? (((8) << 14) | 0x80000000) : (((8) << 14) | 0xC0000000)) };

int fscratch[8] = { (((16) < 16) ? (((16) << 14) | 0x80000000) : (((16) << 14) | 0xC0000000)), (((17) < 16) ? (((17) << 14) | 0x80000000) : (((17) << 14) | 0xC0000000)), (((18) < 16) ? (((18) << 14) | 0x80000000) : (((18) << 14) | 0xC0000000)), (((19) < 16) ? (((19) << 14) | 0x80000000) : (((19) << 14) | 0xC0000000)),
                               (((20) < 16) ? (((20) << 14) | 0x80000000) : (((20) << 14) | 0xC0000000)), (((21) < 16) ? (((21) << 14) | 0x80000000) : (((21) << 14) | 0xC0000000)), (((22) < 16) ? (((22) << 14) | 0x80000000) : (((22) << 14) | 0xC0000000)), (((23) < 16) ? (((23) << 14) | 0x80000000) : (((23) << 14) | 0xC0000000)) };





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





void print_reg(FILE *fp, int reg, long t)
{
    int size = 3;

    if ((((reg) & 0xC0000000) == 0x80000000)) {
        switch (((t) & 0x000000000001FFFFL))
        {
        case 0x0000000000000002L:    case 0x0000000000000004L:   case 0x0000000000000008L:   --size;
        case 0x0000000000000010L:   case 0x0000000000000020L:                  --size;
        case 0x0000000000000040L:     case 0x0000000000000080L:                    --size;
        }
    }

    if (((((reg) & 0x3FFFC000) >> 14) < (16 + 16 + 2))) {



        if ((((reg) & 0xC0000000) == 0x80000000))
            fputs(gp_names[(((reg) & 0x3FFFC000) >> 14) * 4 + size], fp);
        else
            fputs(other_names[(((reg) & 0x3FFFC000) >> 14) - 16], fp);
    } else {



        fprintf(fp, "%%%c%d", (((reg) & 0xC0000000) == 0x80000000) ? 'i' : 'f', (((reg) & 0x3FFFC000) >> 14));
        if ((((reg) & 0xC0000000) == 0x80000000)) (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (size["bwdq"])) : __flushbuf((size["bwdq"]),(fp)));
        if ((((reg) & 0x00003FFF) >> 0)) fprintf(fp, ".%d", (((reg) & 0x00003FFF) >> 0));
    }
}

void add_regmap(struct regmap_vector *map, int from, int to)
{
    struct regmap new = { from, to };
    int n;

    for (n = 0; n < ((*map).size); ++n)
        if ((((((*map).elements[n])).from < (new).from) || (((((*map).elements[n])).from == (new).from) && ((((*map).elements[n])).to < (new).to))))
            break;

    vector_insert((struct vector *) &(*map), (n), (1), sizeof(*((*map).elements)));
    ((*map).elements[n]) = new;
}

int same_regmap(struct regmap_vector *map1, struct regmap_vector *map2)
{
    int n;

    if (((*map1).size) != ((*map2).size))
        return 0;

    for (n = 0; n < ((*map1).size); ++n)
        if ((((*map1).elements[n]).from != ((*map2).elements[n]).from)
          || (((*map1).elements[n]).to != ((*map2).elements[n]).to))
            return 0;

    return 1;
}

void regmap_regs(struct regmap_vector *map, struct reg_vector *set)
{
    int i;

    for (i = 0; i < ((*map).size); ++i)
        if (((*map).elements[i]).from)
            add_reg(set, ((*map).elements[i]).from);
}









static void sort_regmap(struct regmap_vector *map)
{
    int n;
    int changed;

    do {
        changed = 0;

        for (n = 0; n < (((*map).size) - 1); ++n)
            if (
(((((*map).elements[n + 1])).from < (((*map).elements[n])).from) || (((((*map).elements[n + 1])).from == (((*map).elements[n])).from) && ((((*map).elements[n + 1])).to < (((*map).elements[n])).to))))
            {
                
do { struct regmap _tmp; _tmp = (((*map).elements[n + 1])); (((*map).elements[n + 1])) = (((*map).elements[n])); (((*map).elements[n])) = _tmp; } while (0);
                ++changed;
            }

    } while (changed);
}

void invert_regmap(struct regmap_vector *map)
{
    int n;

    for (n = 0; n < ((*map).size); ++n)
        do { int _tmp; _tmp = (((*map).elements[n]).from); (((*map).elements[n]).from) = (((*map).elements[n]).to); (((*map).elements[n]).to) = _tmp; } while (0);

    sort_regmap(map);
}

void undecorate_regmap(struct regmap_vector *map)
{
    int n;

    for (n = 0; n < ((*map).size); ++n) {
        ((((*map).elements[n]).to) = ((((*map).elements[n]).to) & ~0x00003FFF) | ((0) << 0));
        ((((*map).elements[n]).from) = ((((*map).elements[n]).from) & ~0x00003FFF) | ((0) << 0));
    }
}









int regmap_substitute(struct regmap_vector *map, int src, int dst)
{
    int count = 0;
    int i;

    for (i = 0; i < ((*map).size); ++i) {
        do { if (((*map).elements[i]).from == src) { ++count; ((*map).elements[i]).from = dst; } } while (0);
        do { if (((*map).elements[i]).to == src) { ++count; ((*map).elements[i]).to = dst; } } while (0);
    }

    if (count) sort_regmap(map);

    return count;
}

void out_regmap(struct regmap_vector *map)
{
    int i;

    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('['))) : __flushbuf((('[')),(out_f)));

    for (i = 0; i < ((*map).size); ++i) {
        if (i != 0) (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((' '))) : __flushbuf(((' ')),(out_f)));

        if (((*map).elements[i]).from)
            out("%r", ((*map).elements[i]).from);

        if (((*map).elements[i]).to)
            out(":%r", ((*map).elements[i]).to);
    }

    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((']'))) : __flushbuf(((']')),(out_f)));
}

int nr_assigned_regs;

struct symbol_vector reg_to_symbol;

void reset_regs(void)
{
    nr_assigned_regs = (16 + 16 + 2);
    do { (reg_to_symbol).cap = 0; (reg_to_symbol).size = 0; (reg_to_symbol).elements = 0; (reg_to_symbol).arena = (&func_arena); } while (0);
}

int assign_reg(struct symbol *sym)
{
    int index = nr_assigned_regs++;
    int i = index - (16 + 16 + 2);
    int reg;

    do { int _n = ((i + 1)); if (_n <= ((reg_to_symbol).cap)) ((reg_to_symbol).size) = _n; else vector_insert((struct vector *) &(reg_to_symbol), ((reg_to_symbol).size), _n - ((reg_to_symbol).size), sizeof(*((reg_to_symbol).elements))); } while (0);
    ((reg_to_symbol).elements[i]) = sym;

    if (((sym->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )))
        reg = 0xC0000000;
    else
        reg = 0x80000000;

    ((reg) = (((reg) & ~0x3FFFC000) | ((index) << 14)));

    return reg;
}

void add_reg(struct reg_vector *set, int reg)
    { int i; for (i = 0; i < ((*set).size); ++i) { if (((*set).elements[i]) == reg) return; if ((((unsigned) (reg)) < ((unsigned) (((*set).elements[i]))))) break; } vector_insert((struct vector *) &(*set), (i), (1), sizeof(*((*set).elements))); ((*set).elements[i]) = reg; }

int contains_reg(struct reg_vector *set, int reg)
    { int i; for (i = 0; i < ((*set).size); ++i) { if (((*set).elements[i]) == reg) return 1; if ((((unsigned) (reg)) < ((unsigned) (((*set).elements[i]))))) break; } return 0; }

int same_regs(struct reg_vector *set1, struct reg_vector *set2)
    { int i; if (((*set1).size) != ((*set2).size)) return 0; for (i = 0; i < ((*set1).size); ++i) if (((*set1).elements[i]) != ((*set2).elements[i])) return 0; return 1; }

void union_regs(struct reg_vector *dst, struct reg_vector *src1, struct reg_vector *src2)
    { int i1 = 0; int i2 = 0; int size1 = ((*src1).size); int size2 = ((*src2).size); int elem; do { int _n = (0); if (_n <= (((*dst)).cap)) (((*dst)).size) = _n; else vector_insert((struct vector *) &((*dst)), (((*dst)).size), _n - (((*dst)).size), sizeof(*(((*dst)).elements))); } while (0); while ((i1 < size1) || (i2 < size2)) { if (i1 == ((*src1).size)) elem = ((*src2).elements[i2++]); else if (i2 == ((*src2).size)) elem = ((*src1).elements[i1++]); else if ((((unsigned) (((*src1).elements[i1]))) < ((unsigned) (((*src2).elements[i2]))))) elem = ((*src1).elements[i1++]); else if ((((unsigned) (((*src2).elements[i2]))) < ((unsigned) (((*src1).elements[i1]))))) elem = ((*src2).elements[i2++]); else { elem = ((*src2).elements[i2++]); ++i1; } do { int _n = (1); if ((((*dst).size) + _n) < ((*dst).cap)) ((*dst).size) += _n; else vector_insert((struct vector *) &(*dst), ((*dst).size), _n, sizeof(*((*dst).elements))); } while(0); ((*dst).elements[(*dst).size - 1]) = elem; } }

void intersect_regs(struct reg_vector *dst, struct reg_vector *src1, struct reg_vector *src2)
    { int i1 = 0; int i2 = 0; int size1 = ((*src1).size); int size2 = ((*src2).size); do { int _n = (0); if (_n <= (((*dst)).cap)) (((*dst)).size) = _n; else vector_insert((struct vector *) &((*dst)), (((*dst)).size), _n - (((*dst)).size), sizeof(*(((*dst)).elements))); } while (0); while ((i1 < size1) && (i2 < size2)) { if ((((unsigned) (((*src1).elements[i1]))) < ((unsigned) (((*src2).elements[i2]))))) ++i1; else if ((((unsigned) (((*src2).elements[i2]))) < ((unsigned) (((*src1).elements[i1]))))) ++i2; else { do { int _n = (1); if ((((*dst).size) + _n) < ((*dst).cap)) ((*dst).size) += _n; else vector_insert((struct vector *) &(*dst), ((*dst).size), _n, sizeof(*((*dst).elements))); } while(0); ((*dst).elements[(*dst).size - 1]) = ((*src1).elements[i1]); ++i1; ++i2; } } }

void diff_regs(struct reg_vector *dst, struct reg_vector *src1, struct reg_vector *src2)
    { int i1 = 0; int i2 = 0; int size1 = ((*src1).size); int size2 = ((*src2).size); do { int _n = (0); if (_n <= (((*dst)).cap)) (((*dst)).size) = _n; else vector_insert((struct vector *) &((*dst)), (((*dst)).size), _n - (((*dst)).size), sizeof(*(((*dst)).elements))); } while (0); while (i1 < size1) { if ((i2 == size2) || (((unsigned) (((*src1).elements[i1]))) < ((unsigned) (((*src2).elements[i2]))))) { do { int _n = (1); if ((((*dst).size) + _n) < ((*dst).cap)) ((*dst).size) += _n; else vector_insert((struct vector *) &(*dst), ((*dst).size), _n, sizeof(*((*dst).elements))); } while(0); ((*dst).elements[(*dst).size - 1]) = ((*src1).elements[i1++]); } else if ((((unsigned) (((*src2).elements[i2]))) < ((unsigned) (((*src1).elements[i1]))))) { ++i2; } else { ++i1; ++i2; } } }

void replace_indexed_regs(struct reg_vector *dst, struct reg_vector *src)
{
    int i = 0;
    int j = 0;

    while ((i < ((*dst).size)) && (j < ((*src).size)))
    {
        int dst_basis = ((((*dst).elements[i])) & ~0x00003FFF);
        int src_basis = ((((*src).elements[j])) & ~0x00003FFF);

        if ((((unsigned) (dst_basis)) < ((unsigned) (src_basis))))

            ++i;
        else if (dst_basis == src_basis)

            vector_delete((struct vector *) &(*dst), (i), (1), sizeof(*((*dst).elements)));
        else {

            vector_insert((struct vector *) &(*dst), (i), (1), sizeof(*((*dst).elements)));
            ((*dst).elements[i]) = ((*src).elements[j]);
            ++i;
            ++j;
        }
    }

    while (j < ((*src).size)) {
        do { int _n = (1); if ((((*dst).size) + _n) < ((*dst).cap)) ((*dst).size) += _n; else vector_insert((struct vector *) &(*dst), ((*dst).size), _n, sizeof(*((*dst).elements))); } while(0);
        ((*dst).elements[(*dst).size - 1]) = ((*src).elements[j]);
        ++j;
    }
}

void select_indexed_regs(struct reg_vector *dst, struct reg_vector *src, int reg)
{
    int i;

    for (i = 0; i < ((*src).size); ++i)
        if (((((*src).elements[i])) & ~0x00003FFF) == ((reg) & ~0x00003FFF))
            add_reg(dst, ((*src).elements[i]));
}

void out_regs(struct reg_vector *set)
{
    int i;

    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('['))) : __flushbuf((('[')),(out_f)));

    for (i = 0; i < ((*set).size); ++i) {
        if (i > 0) (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((' '))) : __flushbuf(((' ')),(out_f)));
        out("%r", ((*set).elements[i]));
    }

    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((']'))) : __flushbuf(((']')),(out_f)));
}
