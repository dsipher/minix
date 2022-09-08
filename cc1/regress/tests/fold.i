# 1 "fold.c"

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
# 16 "live.h"
struct block;
















struct range { int def, reg, use; };

struct range_vector { int cap; int size; struct range *elements; struct arena *arena; };

struct live
{
    struct reg_vector def;
    struct reg_vector use;
    struct reg_vector in;
    struct reg_vector out;
    struct range_vector ranges;
};










void new_live(struct block *b);





int range_by_use(struct block *b, int reg, int use);
int range_by_def(struct block *b, int reg, int def);




int range_use_count(struct block *b, int r);




int range_span(struct block *b, int r);




void range_interf(struct block *b, int r, struct reg_vector *regs);



int range_doa(struct block *b, int reg, int def);





int live_ccs(struct block *b, int i);






int live_kill_dead(struct block *b, int i);
# 116 "live.h"
void live_analyze(int flags);
# 15 "fold.h"
struct block;



void opt_lir_fold(void);












struct constant
{
    int reg;
    union con con;
    struct symbol *sym;
};

struct constant_vector { int cap; int size; struct constant *elements; struct arena *arena; };











struct fold_state
{
    struct bitvec_vector nac;
    struct constant_vector constants;
};




struct fold
{
    struct fold_state state;
    struct fold_state prop;
};
# 155 "fold.h"
void normalize_con(long t, union con *conp);




int con_in_range(long t, union con *conp);








int cast_con(long to_t, long from_t, union con *conp, int pure);
# 18 "prop.h"
void opt_lir_prop(void);







struct copy
{
    int blkno;
    int index;
    int dst;
    int src;
};

struct copy_vector { int cap; int size; struct copy *elements; struct arena *arena; };




struct prop
{


    struct copy_vector state;
    struct reg_vector defs;







    struct bitvec_vector gen;
    struct bitvec_vector kill;
    struct bitvec_vector in;
    struct bitvec_vector out;
};
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
# 18 "dvn.h"
void opt_lir_dvn(void);

















struct value
{
    int v;
    int number;

    unsigned t : 17;

    union
    {
        struct
        {
            union con con;
            struct symbol *sym;
        };

        struct insn *insn;
    };
};

struct value_vector { int cap; int size; struct value *elements; struct arena *arena; };
struct value_ref_vector { int cap; int size; struct value * *elements; struct arena *arena; };














struct regval { int reg; int number; };
struct regval_vector { int cap; int size; struct regval *elements; struct arena *arena; };








struct reload
{
    int number;
    int base;
    long offset;
    struct symbol *sym;
    struct insn **store;
};

struct reload_vector { int cap; int size; struct reload *elements; struct arena *arena; };




struct dvn
{
    struct value_ref_vector exprs;
    struct regval_vector regvals;
    struct reload_vector reloads;
};
# 71 "insn.h"
void out_ccs(int ccs);




extern const char * const cc_text[];




int union_cc(int cc1, int cc2);




int intersect_cc(int cc1, int cc2);




extern const char commuted_cc[];
# 1057 "insn.h"
struct operand
{
    unsigned class : 3;
    unsigned scale : 2;








    unsigned t      : 17;
    unsigned size   : 28;
    unsigned align  : 4;

    int reg;




    union
    {
        int index;
        int number;
    };







    union con con;
    struct symbol *sym;
};

struct operand_vector { int cap; int size; struct operand * *elements; struct arena *arena; };



void normalize_operand(struct operand *o);



int same_operand(struct operand *o1, struct operand *o2);
# 1234 "insn.h"
struct insn
{
    int op;

    unsigned is_volatile : 1;
    unsigned was_hoisted : 1;

    unsigned uses_mem    : 1;
    unsigned defs_mem    : 1;
    unsigned defs_cc     : 1;






    unsigned nr_args     : 6;
    unsigned is_variadic : 1;




    unsigned nr_iargs : 3;
    unsigned nr_fargs : 4;

    struct operand operand[];
};

struct insn_vector { int cap; int size; struct insn * *elements; struct arena *arena; };













struct asm_insn
{
    struct insn hdr;

    struct string *text;
    struct regmap_vector uses;
    struct regmap_vector defs;
};




struct line_insn
{
    struct insn hdr;

    struct string *path;
    int line_no;
};




extern struct insn nop_insn;





struct insn *new_insn(int op, int nr_args);



struct insn *dup_insn(struct insn *src);



void commute_insn(struct insn *insn);



int same_insn(struct insn *insn1, struct insn *insn2);




int insn_defs_cc0(struct insn *insn);
int insn_uses_mem0(struct insn *insn);
int insn_defs_mem0(struct insn *insn);
# 1354 "insn.h"
void insn_uses(struct insn *insn, struct reg_vector *set, int flags);




void insn_defs(struct insn *insn, struct reg_vector *set, int flags);




int insn_substitute_con(struct insn *insn, int reg,
                        union con con, struct symbol *sym);
















int insn_substitute_reg(struct insn *insn, int src,
                        int dst, int flags, long *tp);





int insn_is_copy(struct insn *insn, int *dst, int *src);




int insn_is_cmpz(struct insn *insn, int *reg);



int insn_is_cmp_con(struct insn *insn, int *reg);



void out_insn(struct insn *insn);




void out_operand(struct operand *o, int rel);
# 17 "hoist.h"
void opt_lir_hoist(void);



struct hoist_vector { int cap; int size; struct insn ** *elements; struct arena *arena; };

struct hoist
{
    struct hoist_vector eval;
    struct insn **match;
};
# 16 "reach.h"
struct block;


















struct reach
{
    struct reg_vector in;
    struct reg_vector out;
    struct reg_vector gen;
};



void reset_reach(void);



void new_reach(struct block *b);
# 73 "reach.h"
void reach_analyze(int flags);




void reach(struct block *b, int i, int reg, struct reg_vector *defs);
# 18 "lower.h"
void lower(void);




struct insn *move(long t, struct operand *dst, struct operand *src);













struct cache { int reg; struct operand operand; };

struct cache_vector { int cap; int size; struct cache *elements; struct arena *arena; };

struct cache_state
{
    struct bitvec_vector naa;
    struct cache_vector cache;
};





struct lower { struct cache_state state, exit; };
# 28 "block.h"
extern struct block *all_blocks;








extern struct block *entry_block;
extern struct block *exit_block;



extern struct block *current_block;







struct succ
{
    int cc;
    union con label;
    struct block *b;
};

struct succ_vector { int cap; int size; struct succ *elements; struct arena *arena; };

















struct block_vector { int cap; int size; struct block * *elements; struct arena *arena; };

struct block
{
    int asmlab;
    int flags;
    struct insn_vector insns;
    struct block_vector preds;
    struct succ_vector succs;
    struct operand control;
    struct block *next, *prev;




    struct block_vector dom;
    struct block *idom;
    struct block_vector loop;
    int depth;



    struct live live;
    struct fold fold;
    struct prop prop;
    struct hoist hoist;
    struct reach reach;
    struct dvn dvn;
    struct lower lower;
};
# 141 "block.h"
struct block *new_block(void);





void kill_block(struct block *b);





void switch_block(struct block *b, struct operand *o,
                  struct block *default_b);






void add_switch_succ(struct block *b, union con *conp, struct block *succ_b);




void trim_switch_block(struct block *b);






int unswitch_block(struct block *b);



int is_pred(struct block *pred, struct block *succ);




void add_succ(struct block *b, int cc, struct block *succ_b);



void remove_succ(struct block *b, int n);



void remove_succs(struct block *b);




void dup_succs(struct block *dst, struct block *src);




void replace_succ(struct block *b, struct block *old_b, struct block *new_b);





int rewrite_znz_succs(struct block *b, int nz);




void commute_succs(struct block *b);



int conditional_block(struct block *b);





struct block *predict_succ(struct block *b, int ccs, int fix);





struct block *predict_switch_succ(struct block *b, union con con, int fix);




struct block *unconditional_succ(struct block *b);




int fuse_block(struct block *b);






int bypass_succ(struct block *b, int n);



void reset_blocks(void);



void undecorate_blocks(void);




void substitute_reg(int src, int dst);




void all_regs(struct reg_vector *regs);










void iterate_blocks(int (*f)(struct block *));





void walk_blocks(int backward, void (*pre)(struct block *),
                               void (*post)(struct block *));



void sequence_blocks(int backward);



void out_block(struct block *b);



int append_insn(struct insn *insn, struct block *b);













void insert_insn(struct insn *insn, struct block *b, int i);



void delete_insn(struct block *b, int i);



void add_block(struct block_vector *set,
               struct block *b);

int contains_block(struct block_vector *set,
                   struct block *b);

int same_blocks(struct block_vector *set1,
                struct block_vector *set2);

void union_blocks(struct block_vector *dst,
                  struct block_vector *src1,
                  struct block_vector *src2);

void intersect_blocks(struct block_vector *dst,
                      struct block_vector *src1,
                      struct block_vector *src2);
# 21 "opt.h"
extern int opt_request;
extern int opt_prohibit;
# 50 "opt.h"
void opt_prune(void);
void opt_dead(void);




void opt(int request, int prohibit);
# 18 "fold.c"
void normalize_con(long t, union con *conp)
{
    switch (((t) & 0x000000000001FFFFL))
    {
        case 0x0000000000000002L:
        case 0x0000000000000004L:   conp->i = (char) conp->i; break;
        case 0x0000000000000008L:   conp->i = (unsigned char) conp->i; break;
        case 0x0000000000000010L:   conp->i = (short) conp->i; break;
        case 0x0000000000000020L:  conp->i = (unsigned short) conp->i; break;
        case 0x0000000000000040L:     conp->i = (int) conp->i; break;
        case 0x0000000000000080L:    conp->i = (unsigned) conp->i; break;
    }
}

int con_in_range(long t, union con *conp)
{
    switch (((t) & 0x000000000001FFFFL))
    {
    case 0x0000000000000002L:
    case 0x0000000000000004L:   return (conp->i >= -128) && (conp->i <= 127);
    case 0x0000000000000010L:   return (conp->i >= -32768) && (conp->i <= 32767);
    case 0x0000000000000040L:     return (conp->i >= (-2147483647 - 1)) && (conp->i <= 2147483647);

    case 0x0000000000000008L:   return (conp->i >= 0) && (conp->i <= 255);
    case 0x0000000000000020L:  return (conp->i >= 0) && (conp->i <= 65535);
    case 0x0000000000000080L:    return (conp->i >= 0) && (conp->i <= 4294967295U);

    default:        return 1;
    }
}

int cast_con(long to_t, long from_t, union con *conp, int pure)
{
    if ((((to_t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0) == (((from_t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0))
                                                                 ;
    else if (to_t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) {



        if (!pure) return 0;

        if (from_t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))
            conp->f = conp->i;
        else
            conp->f = conp->u;
    } else {



        if (to_t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))
            conp->i = conp->f;
        else
            conp->u = conp->f;
    }

    return 1;
}
# 121 "fold.c"
static int cmp_cons(long t, struct constant *left, struct constant *right)
{
    int ccs = 0;

    if (t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))
        do { if (left->con.f == right->con.f) { ((ccs) |= (1 << (10))); ((ccs) |= (1 << (9))); ((ccs) |= (1 << (0))); } if (left->con.f > right->con.f) { ((ccs) |= (1 << (8))); ((ccs) |= (1 << (10))); ((ccs) |= (1 << (1))); } if (left->con.f < right->con.f) { ((ccs) |= (1 << (11))); ((ccs) |= (1 << (9))); ((ccs) |= (1 << (1))); } } while (0);
    else if (t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))
        do { if (left->con.i == right->con.i) { ((ccs) |= (1 << (6))); ((ccs) |= (1 << (5))); ((ccs) |= (1 << (0))); } if (left->con.i > right->con.i) { ((ccs) |= (1 << (4))); ((ccs) |= (1 << (6))); ((ccs) |= (1 << (1))); } if (left->con.i < right->con.i) { ((ccs) |= (1 << (7))); ((ccs) |= (1 << (5))); ((ccs) |= (1 << (1))); } } while (0);
    else
        do { if (left->con.u == right->con.u) { ((ccs) |= (1 << (10))); ((ccs) |= (1 << (9))); ((ccs) |= (1 << (0))); } if (left->con.u > right->con.u) { ((ccs) |= (1 << (8))); ((ccs) |= (1 << (10))); ((ccs) |= (1 << (1))); } if (left->con.u < right->con.u) { ((ccs) |= (1 << (11))); ((ccs) |= (1 << (9))); ((ccs) |= (1 << (1))); } } while (0);

    return ccs;
}




static void init_state(struct fold_state *state)
{
    do { struct bitvec_vector *_v = &(state->nac); do { int _n = ((((nr_assigned_regs) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);
    __builtin_memset(((state->nac)).elements, (0), (((state->nac)).size) * sizeof(*(((state->nac)).elements)));
    do { int _n = (0); if (_n <= (((state->constants)).cap)) (((state->constants)).size) = _n; else vector_insert((struct vector *) &((state->constants)), (((state->constants)).size), _n - (((state->constants)).size), sizeof(*(((state->constants)).elements))); } while (0);
}





static int lookup_constant(struct block *b, int reg, int create)
{
    int i;

    for (i = 0; i < (((b)->fold.state.constants).size); ++i) {
        if ((((b)->fold.state.constants).elements[(i)]).reg == reg)
            return i;

        if ((((unsigned) (reg)) < ((unsigned) ((((b)->fold.state.constants).elements[(i)]).reg))))
            break;
    }

    if (create) {
        vector_insert((struct vector *) &(b->fold.state.constants), (i), (1), sizeof(*((b->fold.state.constants).elements)));
        (((b)->fold.state.constants).elements[(i)]).reg = reg;
        return i;
    } else
        return -1;
}

static void remove_constant(struct block *b, int reg)
{
    int i;

    i = lookup_constant(b, reg, 0);
    if (i != -1) vector_delete((struct vector *) &(b->fold.state.constants), (i), (1), sizeof(*((b->fold.state.constants).elements)));
}






static void set_ccs(struct block *b, int ccs)
{
    int k;

    k = lookup_constant(b, ( (32 << 14) | 0x40000000 ), 1);
    (((b)->fold.state.constants).elements[(k)]).con.u = ccs;
    (((b)->fold.state.constants).elements[(k)]).sym = 0;

    do { struct bitvec_vector *_v = &((b)->fold.state.nac); _v->elements[(((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
}

static int get_ccs(struct block *b)
{
    int k;

    k = lookup_constant(b, ( (32 << 14) | 0x40000000 ), 0);

    if (k == -1)
        return 0;
    else
        return (((b)->fold.state.constants).elements[(k)]).con.u;
}


















static struct reg_vector tmp_regs;













static void eval(struct block *b, int i)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    int op = insn->op;

    struct constant src[2];
    struct constant *left = &src[0];
    struct constant *right = &src[1];
    long t;






    if ((op == ( 11 | ((2) << 28) | 0x04000000 ))
      && ((&insn->operand[0])->class == 1)
      && ((&insn->operand[1])->class == 1)
      && (insn->operand[0].reg == insn->operand[1].reg))
    {
        int ccs = 0;

        if (insn->operand[0].t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) {
            ((ccs) |= (1 << (0)));
            ((ccs) |= (1 << (5)));
            ((ccs) |= (1 << (6)));
        } else {
            ((ccs) |= (1 << (0)));
            ((ccs) |= (1 << (10)));
            ((ccs) |= (1 << (9)));
        }

        set_ccs(b, ccs);
        return;
    }



    switch (op)
    {
    case ( 0 ):
    case ( 2 | 0x00800000 | 0x02000000 | 0x01000000 ):
    case ( 38 | ((3) << 28) | 0x02000000 | 0x01000000 ):
    case ( 39 | ((3) << 28) | 0x01000000 ):
    case ( 5 | ((2) << 28) | 0x01000000 ):
    case ( 8 | 0x00800000 | 0x02000000 ):          return;
    }




    switch (op)
    {
    case ( 1 | 0x00800000 ):
    case ( 3 | ((2) << 28) | 0x80000000 ):
    case ( 7 | ((1) << 28) | 0x80000000 | 0x00800000 ):
    case ( 6 | ((2) << 28) | 0x80000000 | 0x02000000 | 0x01000000 | 0x04000000 ):
    case ( 4 | ((2) << 28) | 0x80000000 | 0x02000000 ):            goto nac;
    }




    if (((((op) & 0x000000FF) >= ((( 24 | ((1) << 28) | 0x80000000 | 0x08000000 )) & 0x000000FF)) && (((op) & 0x000000FF) <= ((( 35 | ((1) << 28) | 0x80000000 | 0x08000000 )) & 0x000000FF)))) {
        int cc;

        if (({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) goto nac;
        if (get_ccs(b) == 0) goto undef;

        cc = ((op) - ( 24 | ((1) << 28) | 0x80000000 | 0x08000000 ));
        left->sym = 0;
        left->con.i = ((get_ccs(b)) & (1 << (cc))) != 0;
        goto constant;
    }






    right->sym = 0;

    {
        int s = 0;
        int o = 0;
        int k;
        int is_undef = 0;
        int reg;

        if (op & 0x80000000) ++o;





        t = insn->operand[o].t;

        while (o < (((op) & 0x30000000) >> 28)) {
            if (((&insn->operand[o])->class == 1)) {
                reg = insn->operand[o].reg;
                if (({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) goto nac;

                if ((k = lookup_constant(b, reg, 0)) != -1) {



                    src[s].con = (((b)->fold.state.constants).elements[(k)]).con;
                    src[s].sym = (((b)->fold.state.constants).elements[(k)]).sym;
                    normalize_con(insn->operand[o].t, &src[s].con);
                } else
                    is_undef = 1;
            } else {
                src[s].con = insn->operand[o].con;
                src[s].sym = insn->operand[o].sym;
            }

            ++o;
            ++s;
        }

        if (is_undef) goto undef;
    }




    switch (op)
    {
    case ( 11 | ((2) << 28) | 0x04000000 ):
    case ( 15 | ((3) << 28) | 0x80000000 ):     do { if ((left)->sym == (right)->sym) (left)->sym = (right)->sym = 0; } while (0); break;
    case ( 14 | ((3) << 28) | 0x80000000 ):     do { if (((right)->sym) && !((left)->sym == 0)) do { struct constant * _tmp; _tmp = ((left)); ((left)) = ((right)); ((right)) = _tmp; } while (0); } while (0); break;
    }

    if (!((*right).sym == 0)) goto nac;



    switch (op)
    {
    case ( 14 | ((3) << 28) | 0x80000000 ):     do { if ((t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (left)->con.f = (left)->con.f + (right)->con.f; else if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i + (right)->con.i; else (left)->con.u = (left)->con.u + (right)->con.u; } while (0); goto constant;
    case ( 15 | ((3) << 28) | 0x80000000 ):     do { if ((t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (left)->con.f = (left)->con.f - (right)->con.f; else if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i - (right)->con.i; else (left)->con.u = (left)->con.u - (right)->con.u; } while (0); goto constant;

    case ( 10 | ((2) << 28) | 0x80000000 ):    if (!cast_con(insn->operand[0].t, t,
                                      &left->con, ((*left).sym == 0)))
                            goto nac;



    case ( 9 | ((2) << 28) | 0x80000000 ):    goto constant;
    }



    if (!((*left).sym == 0)) goto nac;

    switch (op)
    {
        case ( 11 | ((2) << 28) | 0x04000000 ):     set_ccs(b, cmp_cons(t, left, right)); return;
        case ( 12 | ((2) << 28) | 0x80000000 ):     do { if ((t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (left)->con.f = - (left)->con.f; else (left)->con.i = - (left)->con.i; } while (0); goto constant;
        case ( 13 | ((2) << 28) | 0x80000000 | 0x04000000 ):     do { (left)->con.i = ~ (left)->con.i; } while (0); goto constant;
        case ( 16 | ((3) << 28) | 0x80000000 ):     do { if ((t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (left)->con.f = (left)->con.f * (right)->con.f; else if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i * (right)->con.i; else (left)->con.u = (left)->con.u * (right)->con.u; } while (0); goto constant;
        case ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ):     do { if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i >> (right)->con.i; else (left)->con.u = (left)->con.u >> (right)->con.u; } while (0); goto constant;
        case ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ):     do { if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i << (right)->con.i; else (left)->con.u = (left)->con.u << (right)->con.u; } while (0); goto constant;
        case ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ):     do { if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i & (right)->con.i; else (left)->con.u = (left)->con.u & (right)->con.u; } while (0); goto constant;
        case ( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ):      do { if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i | (right)->con.i; else (left)->con.u = (left)->con.u | (right)->con.u; } while (0); goto constant;
        case ( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ):     do { if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i ^ (right)->con.i; else (left)->con.u = (left)->con.u ^ (right)->con.u; } while (0); goto constant;

        case ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ):     if (right->con.i == 0) goto nac;
                            do { if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i % (right)->con.i; else (left)->con.u = (left)->con.u % (right)->con.u; } while (0); goto constant;

        case ( 17 | ((3) << 28) | 0x80000000 ):

                            if ((t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )) && (right->con.i == 0))
                                goto nac;

                            do { if ((t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (left)->con.f = (left)->con.f / (right)->con.f; else if ((t) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (left)->con.i = (left)->con.i / (right)->con.i; else (left)->con.u = (left)->con.u / (right)->con.u; } while (0); goto constant;




        case ( 36 | ((2) << 28) | 0x80000000 | 0x04000000 ):     do { if ((t) & ( 0x0000000000000100L | 0x0000000000000200L )) (left)->con.i = __builtin_ctzl((left)->con.i); else (left)->con.i = __builtin_ctz((left)->con.i); } while (0); goto constant;
        case ( 37 | ((2) << 28) | 0x80000000 | 0x04000000 ):     do { if ((t) & ( 0x0000000000000100L | 0x0000000000000200L )) (left)->con.i = (__builtin_clzl((left)->con.i) ^ 63); else (left)->con.i = (__builtin_clz((left)->con.i) ^ 31); } while (0); goto constant;
    }




nac:    do { int _i; int _reg; do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0); insn_defs(insn, &tmp_regs, 0x04000000); for ((_i) = 0; ((_i) < ((tmp_regs).size)) && ((_reg) = (((tmp_regs)).elements[(_i)])); ++(_i)) do { remove_constant((b), (_reg)); do { struct bitvec_vector *_v = &(((b))->fold.state.nac); _v->elements[((((((_reg)) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << ((((((_reg)) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); } while (0); } while (0);     return;
undef:  do { int _i; int _reg; do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0); insn_defs(insn, &tmp_regs, 0x04000000); for ((_i) = 0; ((_i) < ((tmp_regs).size)) && ((_reg) = (((tmp_regs)).elements[(_i)])); ++(_i)) do { remove_constant((b), (_reg)); do { struct bitvec_vector *_v = &(((b))->fold.state.nac); _v->elements[((((((_reg)) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << ((((((_reg)) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); } while (0); } while (0);   return;




constant:
    {
        int dst = insn->operand[0].reg;
        struct symbol *sym = ((reg_to_symbol).elements[(((dst) & 0x3FFFC000) >> 14) - (16 + 16 + 2)]);
        int k;




        normalize_con(((((sym->type)->t) & 0x000000000001FFFFL)), &left->con);
        k = lookup_constant(b, dst, 1);
        (((b)->fold.state.constants).elements[(k)]).con = left->con;
        (((b)->fold.state.constants).elements[(k)]).sym = left->sym;





        if ((((insn)->op & 0x04000000) || insn_defs_cc0(insn))) do { remove_constant((b), (( (32 << 14) | 0x40000000 ))); do { struct bitvec_vector *_v = &(((b))->fold.state.nac); _v->elements[((((((( (32 << 14) | 0x40000000 ))) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << ((((((( (32 << 14) | 0x40000000 ))) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); } while (0);
    }
}





static int mark(struct block *b)
{
    int marked = 0;

    do {
        if (b->flags & 0x00000004)
            break;

        b->flags |= 0x00000004;
        ++marked;
    } while (b = unconditional_succ(b));

    return marked;
}




static int mark_all(struct block *b)
{
    int marked = 0;
    int n;

    for (n = 0; n < (((b)->succs).size); ++n)
        marked += mark((((b)->succs).elements[(n)]).b);

    return marked;
}












static void meet0(struct block *b)
{
    int n;

    init_state(&b->fold.state);

    for (n = 0; n < (((b)->preds).size); ++n) {
        struct block *pred_b = (((b)->preds).elements[(n)]);
        int pred_k = 0, pred_reg;
        int k = 0, reg;

        do { struct bitvec_vector *_dst = &((b->fold.state.nac)); struct bitvec_vector *_src = &((pred_b->fold.prop.nac)); int _i; int _size = (((b->fold.state.nac)).size); for (_i = 0; _i < _size; ++_i) (_dst->elements[_i]) |= (_src->elements[_i]); } while (0);

        while ((k < (((b)->fold.state.constants).size))
          && (pred_k < (((pred_b)->fold.prop.constants).size)))
        {
            reg = (((b)->fold.state.constants).elements[(k)]).reg;
            pred_reg = (((pred_b)->fold.prop.constants).elements[(pred_k)]).reg;

            if (({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) {

                vector_delete((struct vector *) &(b->fold.state.constants), (k), (1), sizeof(*((b->fold.state.constants).elements)));
            } else if (({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((pred_reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((pred_reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) {

                ++pred_k;
            } else if ((((unsigned) (reg)) < ((unsigned) (pred_reg)))) {

                ++k;
            } else if ((((unsigned) (pred_reg)) < ((unsigned) (reg)))) {

                vector_insert((struct vector *) &(b->fold.state.constants), (k), (1), sizeof(*((b->fold.state.constants).elements)));
                (((b)->fold.state.constants).elements[(k)]) = (((pred_b)->fold.prop.constants).elements[(pred_k)]);
                ++k;
                ++pred_k;
            } else {




                if (!
((((((b)->fold.state.constants).elements[(k)])).con.u == ((((pred_b)->fold.prop.constants).elements[(pred_k)])).con.u) && (((((b)->fold.state.constants).elements[(k)])).sym == ((((pred_b)->fold.prop.constants).elements[(pred_k)])).sym)))
                {
                    vector_delete((struct vector *) &(b->fold.state.constants), (k), (1), sizeof(*((b->fold.state.constants).elements)));
                    do { struct bitvec_vector *_v = &((b)->fold.state.nac); _v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
                    ++pred_k;
                } else {
                    ++k;
                    ++pred_k;
                }
            }
        }



        while (k < (((b)->fold.state.constants).size)) {
            reg = (((b)->fold.state.constants).elements[(k)]).reg;

            if (({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); }))
                vector_delete((struct vector *) &(b->fold.state.constants), (k), (1), sizeof(*((b->fold.state.constants).elements)));
            else
                ++k;
        }



        while (pred_k < (((pred_b)->fold.prop.constants).size)) {
            pred_reg = (((pred_b)->fold.prop.constants).elements[(pred_k)]).reg;

            if (!({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((pred_reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((pred_reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) {
                do { int _n = (1); if ((((b->fold.state.constants).size) + _n) < ((b->fold.state.constants).cap)) ((b->fold.state.constants).size) += _n; else vector_insert((struct vector *) &(b->fold.state.constants), ((b->fold.state.constants).size), _n, sizeof(*((b->fold.state.constants).elements))); } while(0);

                ((b->fold.state.constants).elements[(b->fold.state.constants).size - 1])
                    = (((pred_b)->fold.prop.constants).elements[(pred_k)]);
            }

            ++pred_k;
        }
    }
}







static int prop0(struct block *b)
{
    int ret = 1;
    int i, k;

    if ((b->flags & 0x00000004) == 0)
        return 0;

    meet0(b);
    for (i = 0; i < (((b)->insns).size); ++i) eval(b, i);

    if (!({ struct bitvec_vector *_dst = &(b->fold.state.nac); struct bitvec_vector *_src = &(b->fold.prop.nac); int _size = ((b->fold.state.nac).size); int _same = 1; int _i; for (_i = 0; _i < _size; ++_i) if (_dst->elements[_i] != (_src->elements[_i])) { _same = 0; break; } (_same); }))
        goto out;

    if ((((b)->fold.state.constants).size) != (((b)->fold.prop.constants).size))
        goto out;

    for (k = 0; k < (((b)->fold.state.constants).size); ++k)
        if (!((((((b)->fold.state.constants).elements[(k)])).con.u == ((((b)->fold.prop.constants).elements[(k)])).con.u) && (((((b)->fold.state.constants).elements[(k)])).sym == ((((b)->fold.prop.constants).elements[(k)])).sym)))
            goto out;

    ret = 0;

out:
    do { struct fold_state _tmp; _tmp = (b->fold.state); (b->fold.state) = (b->fold.prop); (b->fold.prop) = _tmp; } while (0);
    return ret;
}












static void fold0(struct block *b)
{
    struct insn *insn;
    int i, k, r;
    int dst;

    meet0(b);

    for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {


        for (k = 0; k < (((b)->fold.state.constants).size); ++k)
            if (insn_substitute_con(insn, (((b)->fold.state.constants).elements[(k)]).reg,
                                          (((b)->fold.state.constants).elements[(k)]).con,
                                          (((b)->fold.state.constants).elements[(k)]).sym))
                opt_request |= 0x00000008 | 0x00000002 | 0x00000010;

        eval(b, i);





        do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0);
        insn_defs(insn, &tmp_regs, 0);
        if (((tmp_regs).size) != 1) continue;
        dst = ((tmp_regs).elements[0]);
        k = lookup_constant(b, dst, 0);
        if (k == -1) continue;

        if ((((insn)->op & 0x01000000) || insn_defs_mem0(insn))) continue;
        if ((((insn)->op & 0x00800000) || (insn)->is_volatile)) continue;





        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        insn->operand[0] = (((b)->insns).elements[(i)])->operand[0];
        insn->operand[1] = (((b)->insns).elements[(i)])->operand[0];

        insn_substitute_con(insn, dst, (((b)->fold.state.constants).elements[(k)]).con,
                                       (((b)->fold.state.constants).elements[(k)]).sym);

        (((b)->insns).elements[(i)]) = insn;
        opt_request |= 0x00000008 | 0x00000002 | 0x00000010;
    }





    if (conditional_block(b) && !({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); }) && get_ccs(b)) {
        predict_succ(b, get_ccs(b), 1);
        opt_request |= 0x00000020;
    }

    if (((b)->flags & 0x00000001)
      && ((&b->control)->class == 1)
      && ((k = lookup_constant(b, b->control.reg, 0)) != -1)
      && (((((b)->fold.state.constants).elements[(k)])).sym == 0))
    {
        predict_switch_succ(b, (((b)->fold.state.constants).elements[(k)]).con, 1);
        opt_request |= 0x00000020;
    }
}

















static void project0(struct block *b)
{
    struct block *succ_b;
    struct insn *insn;
    int reg;
    int k;

    if ((succ_b = unconditional_succ(b))
      && ((((succ_b)->insns).size) == 1)
      && insn_is_cmp_con((((succ_b)->insns).elements[(0)]), &reg)
      && ((k = lookup_constant(b, reg, 0)) != -1)
      && (((((b)->fold.state.constants).elements[(k)])).sym == 0))
    {
        insn = dup_insn((((succ_b)->insns).elements[(0)]));
        append_insn(insn, b);
        dup_succs(b, succ_b);
        opt_request |= 0x00000040;
    }
}














void opt_lir_fold(void)
{
    struct block *b;
    int marked;

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        b->flags &= ~0x00000004;

        do { struct bitvec_vector *_v = &(b->fold.state.nac); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
        do { (b->fold.state.constants).cap = 0; (b->fold.state.constants).size = 0; (b->fold.state.constants).elements = 0; (b->fold.state.constants).arena = (&local_arena); } while (0);
        init_state(&b->fold.state);

        do { struct bitvec_vector *_v = &(b->fold.prop.nac); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
        do { (b->fold.prop.constants).cap = 0; (b->fold.prop.constants).size = 0; (b->fold.prop.constants).elements = 0; (b->fold.prop.constants).arena = (&local_arena); } while (0);
        init_state(&b->fold.prop);
    }







    sequence_blocks(0);
    mark(entry_block);

    do { (tmp_regs).cap = 0; (tmp_regs).size = 0; (tmp_regs).elements = 0; (tmp_regs).arena = (&local_arena); } while (0);

    do {
        iterate_blocks(prop0);
        marked = 0;

        for ((b) = all_blocks; (b); (b) = (b)->next) {
            if ((b->flags & 0x00000004) == 0)
                continue;






            if (conditional_block(b)) {
                if (({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((( (32 << 14) | 0x40000000 )) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); }) || !get_ccs(b))
                    marked += mark_all(b);
                else
                    marked += mark(predict_succ(b, get_ccs(b), 0));
            } else if (((b)->flags & 0x00000001) && ((&b->control)->class == 1)) {
                int reg = b->control.reg;
                int k;

                if (({ struct bitvec_vector *_v = &((b)->fold.state.nac); ((_v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })
                  || ((k = lookup_constant(b, reg, 0)) == -1)
                  || !(((((b)->fold.state.constants).elements[(k)])).sym == 0))
                    marked += mark_all(b);
                else
                    marked += mark(predict_switch_succ(b,
                                    (((b)->fold.state.constants).elements[(k)]).con, 0));
            }
        }
    } while (marked);



    for ((b) = all_blocks; (b); (b) = (b)->next)
        if (b->flags & 0x00000004)
            fold0(b);




    for ((b) = all_blocks; (b); (b) = (b)->next)
        if (b->flags & 0x00000004)
            project0(b);

    do { struct arena *_a = (&local_arena); _a->top = _a->bottom; } while (0);
}
