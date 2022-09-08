# 1 "gen.c"

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
# 13 "func.h"
struct symbol;
struct tnode;




extern struct symbol *current_func;




extern struct symbol *func_chain;






extern struct symbol *func_ret_sym;




extern struct tnode *func_ret_type;




extern struct symbol *func_hidden_arg;



int func_size(void);



void enter_func(struct symbol *sym);



void exit_func(void);



struct symbol *temp(struct tnode *type);




int temp_reg(long t);




int frame_alloc(struct tnode *type);
# 17 "tree.h"
struct tree
{
    int op;
    int nr_args;

    struct tnode *type;

    union
    {
        struct
        {
            union con con;
            struct symbol *sym;
        };

        struct
        {
            struct tree *child;
            struct tree **args;
        };

        struct
        {
            struct tree *left;
            struct tree *right;
        };
    };
};
# 204 "tree.h"
struct tree *unary_tree(int op, struct tnode *type, struct tree *child);

struct tree *binary_tree(int op, struct tnode *type, struct tree *left,
                                                     struct tree *right);



















struct tree *seq_tree(struct tree *left, struct tree *right);




struct tree *blk_tree(int op, struct tree *left, struct tree *right,
                              struct tree *size);




struct tree *chop(struct tree *tree);
struct tree *chop_left(struct tree *tree);
struct tree *chop_right(struct tree *tree);
# 265 "tree.h"
int zero_tree(struct tree *tree);
int nonzero_tree(struct tree *tree);










struct tree *con_tree(struct tnode *type, union con *conp);


















struct tree *sym_tree(struct symbol *sym);



void actual(struct tree *call, struct tree *arg);





struct tree *addrof(struct tree *tree, struct tnode *type);



struct tree *fold(struct tree *tree);




struct tree *simplify(struct tree *tree);







struct tree *rewrite_volatiles(struct tree *tree);












extern struct tree void_tree;
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
# 13 "gen.h"
struct block;
struct operand;
struct tree;
struct symbol;







int loadstore(int op, struct symbol *sym, struct block *b, int i);



void branch(struct tree *tree, struct block *true, struct block *false);



struct tree *gen(struct tree *tree);




void leaf_operand(struct operand *o, struct tree *tree);
# 18 "gen.c"
static struct tree *gen0(struct tree *tree);

void leaf_operand(struct operand *o, struct tree *tree)
{
    switch (tree->op)
    {
    case ( 2 | 0x80000000 ):     do { (o)->class = 2; (o)->con = (tree->con); (o)->sym = (tree->sym); do { struct tnode *_type = ((tree->type)); if (_type) ((o))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((o))->t = ((0)); } while (0); } while (0);
                    break;

    case ( 1 | 0x80000000 | 0x10000000 ):     do { (o)->class = 1; (o)->reg = (symbol_to_reg(tree->sym)); do { struct tnode *_type = ((tree->type)); if (_type) ((o))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((o))->t = ((0)); } while (0); } while (0);
                    break;
    }
}




static struct symbol *frame_addr(struct tnode *type, int offset,
                                 struct block *b, int i)
{
    struct insn *insn;
    struct symbol *tmp;

    tmp = temp(type);
    insn = new_insn(( 3 | ((2) << 28) | 0x80000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (offset); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((&long_type))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
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
    if (op == ( 5 | ((2) << 28) | 0x01000000 )) do { struct operand * _tmp; _tmp = (reg_o); (reg_o) = (addr_o); (addr_o) = _tmp; } while (0);
    do { (reg_o)->class = 1; (reg_o)->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((reg_o))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((reg_o))->t = ((0)); } while (0); } while (0);

    if (sym->s & ( 0x00000040 | 0x00000080 | 0x00000100 )) {
        struct symbol *tmp;

        tmp = frame_addr(&ulong_type, symbol_offset(sym), b, i++);
        do { (addr_o)->class = 1; (addr_o)->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((addr_o))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((addr_o))->t = ((0)); } while (0); } while (0);
        ++count;
    } else
        do { (addr_o)->class = 2; (addr_o)->con.i = 0; (addr_o)->sym = (sym); do { struct tnode *_type = ((&ulong_type)); if (_type) ((addr_o))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); } while (0);

    if ((((((sym->type)->t) & 0x0000000000060000L)) & 0x0000000000040000L)) insn->is_volatile = 1;
    insert_insn(insn, b, i);

    return count;
}

void branch(struct tree *tree, struct block *true, struct block *false)
{
    struct insn *insn;

    insn = new_insn(( 11 | ((2) << 28) | 0x04000000 ), 0);
    leaf_operand(&insn->operand[0], tree);
    do { union con _con; _con.i = (0); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((&int_type))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn((insn), current_block);

    add_succ(current_block, 0, false);
    add_succ(current_block, 1, true);
}




static struct tree *gen_binary(struct tree *tree, int op)
{
    struct symbol *tmp;
    struct insn *insn;

    tmp = temp(tree->type);
    tree->left = gen0(tree->left);
    tree->right = gen0(tree->right);

    insn = new_insn(op, 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    leaf_operand(&insn->operand[1], tree->left);
    leaf_operand(&insn->operand[2], tree->right);
    append_insn((insn), current_block);

    return sym_tree(tmp);
}



static struct tree *gen_unary(struct tree *tree, int op)
{
    struct symbol *sym;
    struct insn *insn;

    tree->child = gen0(tree->child);

    sym = temp(tree->type);
    insn = new_insn(op, 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    leaf_operand(&insn->operand[1], tree->child);
    append_insn((insn), current_block);

    return sym_tree(sym);
}













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

    if (((tree->type)->t & 0x0000000000000200L) && ((tree->child->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) {
        noadj_block = new_block();
        adj_block = new_block();
        join_block = new_block();




        tmp = temp(tree->child->type);

        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { union con _con; _con.f = (9223372036854775807L); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((tmp->type))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
        append_insn((insn), current_block);

        insn = new_insn(( 11 | ((2) << 28) | 0x04000000 ), 0);
        leaf_operand(&insn->operand[0], tree->child);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        append_insn((insn), current_block);

        add_succ(current_block, 11, noadj_block);
        add_succ(current_block, 10, adj_block);



        current_block = noadj_block;

        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000100L)) ((&insn->operand[0]))->t = ((0x0000000000000100L)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tree->child);
        append_insn((insn), current_block);

        add_succ(current_block, 12, join_block);




        current_block = adj_block;

        insn = new_insn(( 15 | ((3) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tree->child);
        do { (&insn->operand[2])->class = 1; (&insn->operand[2])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[2]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[2]))->t = ((0)); } while (0); } while (0);
        append_insn((insn), current_block);

        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000100L)) ((&insn->operand[0]))->t = ((0x0000000000000100L)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        append_insn((insn), current_block);

        insn = new_insn(( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[0]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[1]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        do { union con _con; _con.i = (0x8000000000000000); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000200L))) (((&insn->operand[2])))->t = (((0x0000000000000200L))); } while (0); } while (0); } while (0);
        append_insn((insn), current_block);

        add_succ(current_block, 12, join_block);

        current_block = join_block;
    } else if (((tree->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) && ((tree->child->type)->t & 0x0000000000000200L)) {
        noadj_block = new_block();
        adj_block = new_block();
        join_block = new_block();





        insn = new_insn(( 11 | ((2) << 28) | 0x04000000 ), 0);
        leaf_operand(&insn->operand[0], tree->child);
        insn->operand[0].t = 0x0000000000000100L;
        do { union con _con; _con.i = (0); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000100L))) (((&insn->operand[1])))->t = (((0x0000000000000100L))); } while (0); } while (0); } while (0);
        append_insn((insn), current_block);

        add_succ(current_block, 4, noadj_block);
        add_succ(current_block, 5, adj_block);



        current_block = noadj_block;

        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tree->child);
        insn->operand[1].t = 0x0000000000000100L;
        append_insn((insn), current_block);

        add_succ(current_block, 12, join_block);





        current_block = adj_block;
        tmp = temp(tree->child->type);
        tmp2 = temp(tree->child->type);

        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[0]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tree->child);
        append_insn((insn), current_block);

        insn = new_insn(( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[0]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        insn->operand[1] = insn->operand[0];
        do { union con _con; _con.i = (1); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000002L))) (((&insn->operand[2])))->t = (((0x0000000000000002L))); } while (0); } while (0); } while (0);

        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp2)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[0]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tree->child);
        append_insn((insn), current_block);

        insn = new_insn(( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp2)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[0]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        insn->operand[1] = insn->operand[0];
        do { union con _con; _con.i = (1); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000200L))) (((&insn->operand[2])))->t = (((0x0000000000000200L))); } while (0); } while (0); } while (0);
        append_insn((insn), current_block);

        insn = new_insn(( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[0]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        insn->operand[1] = insn->operand[0];
        do { (&insn->operand[2])->class = 1; (&insn->operand[2])->reg = (symbol_to_reg(tmp2)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[2]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000200L)) ((&insn->operand[2]))->t = ((0x0000000000000200L)); } while (0); } while (0);
        append_insn((insn), current_block);

        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000100L)) ((&insn->operand[1]))->t = ((0x0000000000000100L)); } while (0); } while (0);
        append_insn((insn), current_block);

        insn = new_insn(( 14 | ((3) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        insn->operand[1] = insn->operand[0];
        insn->operand[2] = insn->operand[0];
        append_insn((insn), current_block);

        add_succ(current_block, 12, join_block);

        current_block = join_block;
    } else if (((tree->type)->t & 0x0000000000000001L)) {
        return &void_tree;
    } else {
        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tree->child);
        append_insn((insn), current_block);
    }

    return sym_tree(sym);
}




static struct tree *gen_addrof(struct tree *tree)
{
    struct symbol *tmp;
    int offset;

    offset = symbol_offset(tree->child->sym);
    tmp = frame_addr(tree->type, offset, current_block,
                     (((current_block)->insns).size));



    if (tree->child->sym->s & 0x00000100) {
        tree->child->sym->s &= ~0x00000100;
        tree->child->sym->s |= 0x00000040;
    }

    return sym_tree(tmp);
}










static struct symbol *extract_field(struct symbol *sym, struct tnode *type)
{
    int host_width = size_of(sym->type, 0) * 8;
    int width = (((((type)->t) & 0x0000007F00000000L) >> 32));
    int lsb = (((((type)->t) & 0x00003F0000000000L) >> 40));
    struct symbol *tmp = temp(sym->type);
    struct insn *insn;

    if (((type)->t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) && (lsb == 0)) {
        insn = new_insn(( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        do { union con _con; _con.i = (~(-1L << width)); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((sym->type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
        append_insn((insn), current_block);
    } else {
        int left_shift = host_width - (width + lsb);
        int right_shift = host_width - width;

        insn = new_insn(( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        do { union con _con; _con.i = (left_shift); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((&char_type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
        append_insn((insn), current_block);

        insn = new_insn(( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        do { union con _con; _con.i = (right_shift); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((&char_type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
        append_insn((insn), current_block);
    }

    return tmp;
}




static struct symbol *insert_field(struct tree *value, struct symbol *host,
                                   struct tnode *type)
{
    int host_width = size_of(host->type, 0) * 8;
    int width = (((((type)->t) & 0x0000007F00000000L) >> 32));
    int lsb = (((((type)->t) & 0x00003F0000000000L) >> 40));
    struct symbol *tmp = temp(host->type);
    struct symbol *field = temp(value->type);
    struct insn *insn;
    long mask;

    insn = new_insn(( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(field)); do { struct tnode *_type = ((field->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    leaf_operand(&insn->operand[1], value);
    do { union con _con; _con.i = (~(-1L << width)); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((value->type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn((insn), current_block);

    insn = new_insn(( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(field)); do { struct tnode *_type = ((field->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(field)); do { struct tnode *_type = ((field->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (lsb); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((&char_type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn((insn), current_block);

    insn = new_insn(( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(host)); do { struct tnode *_type = ((host->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (~((~(-1L << width)) << lsb)); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((host->type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn((insn), current_block);

    insn = new_insn(( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
    do { (&insn->operand[2])->class = 1; (&insn->operand[2])->reg = (symbol_to_reg(field)); do { struct tnode *_type = ((field->type)); if (_type) ((&insn->operand[2]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[2]))->t = ((0)); } while (0); } while (0);
    append_insn((insn), current_block);

    return tmp;
}










static struct tree *gen_fetch(struct tree *tree, struct symbol **host)
{
    struct insn *insn;
    struct symbol *tmp;

    tree->child = gen0(tree->child);

    if (((tree->type)->t & 0x0000000000002000L))
        return tree;

    tmp = temp(tree->type);
    insn = new_insn(( 4 | ((2) << 28) | 0x80000000 | 0x02000000 ), 0);
    leaf_operand(&insn->operand[1], tree->child);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tree->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    if ((((tree->child->type)->t & 0x0000000000010000L) && (((((((tree->child->type)->next))->t) & 0x0000000000060000L)) & 0x0000000000040000L))) insn->is_volatile = 1;
    append_insn((insn), current_block);

    if (((((tree)->op == ( 3 | 0x40000000 | 0x10000000 )) || ((tree)->op == ( 4 | 0x40000000 ))) && (((((tree)->child->type)->next))->t & 0x0000008000000000L))) {
        if (host) *host = tmp;
        tmp = extract_field(tmp, ((tree->child->type)->next));
    }

    return sym_tree(tmp);
}














static struct tree *gen_assign(struct tree *tree, struct symbol *host)
{
    struct symbol *sym;
    struct insn *insn;

    tree->right = gen0(tree->right);

    if (tree->left->op == ( 1 | 0x80000000 | 0x10000000 )) {
        sym = tree->left->sym;
        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tree->right);
        append_insn((insn), current_block);
    } else {
        tree->left->child = gen0(tree->left->child);
        insn = new_insn(( 5 | ((2) << 28) | 0x01000000 ), 0);
        leaf_operand(&insn->operand[0], tree->left->child);

        if ((((tree->left->child->type)->t & 0x0000000000010000L) && (((((((tree->left->child->type)->next))->t) & 0x0000000000060000L)) & 0x0000000000040000L)))
            insn->is_volatile = 1;

        if (((((tree->left)->op == ( 3 | 0x40000000 | 0x10000000 )) || ((tree->left)->op == ( 4 | 0x40000000 ))) && (((((tree->left)->child->type)->next))->t & 0x0000008000000000L))) {
            if (host)
                sym = host;
            else
                gen_fetch(tree->left, &sym);

            sym = insert_field(tree->right, sym,
                               ((tree->left->child->type)->next));

            do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
            append_insn((insn), current_block);
            sym = extract_field(sym, ((tree->left->child->type)->next));
            tree->right = sym_tree(sym);
        } else {
            leaf_operand(&insn->operand[1], tree->right);
            append_insn((insn), current_block);
        }
    }

    tree = chop_right(tree);
    return tree;
}











static struct tree *gen_compound(struct tree *tree, int op)
{
    struct symbol *pre = 0;
    struct symbol *host = 0;
    struct symbol *tmp;
    struct symbol *lhs;
    struct insn *insn;

    tmp = temp(tree->type);
    tree->right = gen0(tree->right);

    if (tree->left->op == ( 1 | 0x80000000 | 0x10000000 ))
        lhs = tree->left->sym;
    else
        lhs = gen_fetch(tree->left, &host)->sym;

    if (tree->op == ( 22 )) {
        pre = temp(tree->type);
        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(pre)); do { struct tnode *_type = ((pre->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(lhs)); do { struct tnode *_type = ((lhs->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        append_insn((insn), current_block);
    }

    if ((tree->op & 0x08000000) && !simpatico(tree->left->type,
                                          tree->right->type))
    {






        struct tree *tmp1;
        struct tree *tmp2;



        tmp1 = unary_tree(( 6 | 0x40000000 ), tree->right->type, sym_tree(lhs));
        tmp1 = gen(tmp1);



        insn = new_insn(op, 0);
        leaf_operand(&insn->operand[0], tmp1);
        leaf_operand(&insn->operand[1], tmp1);
        leaf_operand(&insn->operand[2], tree->right);
        append_insn((insn), current_block);



        tmp2 = unary_tree(( 6 | 0x40000000 ), tree->left->type, tmp1);
        tmp2 = gen(tmp2);



        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        leaf_operand(&insn->operand[1], tmp2);
        append_insn((insn), current_block);
    } else {
        insn = new_insn(op, 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(lhs)); do { struct tnode *_type = ((lhs->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        leaf_operand(&insn->operand[2], tree->right);
        append_insn((insn), current_block);
    }

    tree->right = sym_tree(tmp);
    tree = gen_assign(tree, host);
    return pre ? sym_tree(pre) : tree;
}







static struct tree *gen_rel(struct tree *tree)
{
    struct symbol *tmp;
    struct insn *insn;
    int cc;

    tree->left = gen0(tree->left);
    tree->right = gen0(tree->right);

    insn = new_insn(( 11 | ((2) << 28) | 0x04000000 ), 0);
    leaf_operand(&insn->operand[0], tree->left);
    leaf_operand(&insn->operand[1], tree->right);
    append_insn((insn), current_block);

    switch (tree->op)
    {
    case ( 33 | 0x20000000 ):   cc = 0; break;
    case ( 34 | 0x20000000 ):  cc = 1; break;
    case ( 35 ):   cc = ((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) ? 4 : 8; break;
    case ( 38 ):   cc = ((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) ? 7 : 11; break;
    case ( 36 ): cc = ((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) ? 6 : 10; break;
    case ( 37 ): cc = ((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) ? 5 : 9; break;
    }

    tmp = temp(tree->type);
    insn = new_insn((( 24 | ((1) << 28) | 0x80000000 | 0x08000000 ) + (cc)), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    append_insn((insn), current_block);

    return sym_tree(tmp);
}




static struct tree *gen_log(struct tree *tree)
{
    struct symbol *tmp = temp(tree->type);
    struct block *right_block = new_block();
    struct block *true_block = new_block();
    struct block *false_block = new_block();
    struct block *join_block = new_block();
    struct insn *insn;

    insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (0); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((&int_type))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn(insn, false_block);
    add_succ(false_block, 12, join_block);

    insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (1); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((&int_type))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn(insn, true_block);
    add_succ(true_block, 12, join_block);

    tree->left = gen0(tree->left);

    if (tree->op == ( 39 ))
        branch(tree->left, true_block, right_block);
    else
        branch(tree->left, right_block, false_block);

    current_block = right_block;
    tree->right = gen0(tree->right);
    branch(tree->right, true_block, false_block);
    current_block = join_block;

    return sym_tree(tmp);
}
# 682 "gen.c"
static struct tree *gen_ternary(struct tree *tree)
{
    struct symbol *tmp = ((tree->type)->t & 0x0000000000000001L) ? 0 : temp(tree->type);
    struct block *true_block = new_block();
    struct block *false_block = new_block();
    struct block *join_block = new_block();

    tree->left = gen0(tree->left);
    branch(tree->left, true_block, false_block);

    do { struct insn *insn; current_block = true_block; tree->right->left = gen0(tree->right->left); if (tmp) { insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0); do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0); leaf_operand(&insn->operand[1], tree->right->left); append_insn((insn), current_block); } add_succ(current_block, 12, join_block); } while (0);
    do { struct insn *insn; current_block = false_block; tree->right->right = gen0(tree->right->right); if (tmp) { insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0); do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(tmp)); do { struct tnode *_type = ((tmp->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0); leaf_operand(&insn->operand[1], tree->right->right); append_insn((insn), current_block); } add_succ(current_block, 12, join_block); } while (0);

    current_block = join_block;
    return tmp ? sym_tree(tmp) : &void_tree;
}




static struct tree *gen_blk(struct tree *tree, int op)
{
    struct insn *insn;

    tree->left = gen0(tree->left);
    tree->right = gen0(tree->right);

    insn = new_insn(op, 0);
    leaf_operand(&insn->operand[0], tree->left->left);
    leaf_operand(&insn->operand[1], tree->left->right);
    leaf_operand(&insn->operand[2], tree->right);
    append_insn((insn), current_block);

    tree = chop_left(tree);
    tree = chop_left(tree);

    return tree;
}







static struct tree *gen_call(struct tree *tree)
{
    struct symbol *sym = ((tree->type)->t & 0x0000000000000001L) ? 0 : temp(tree->type);
    struct insn *insn = new_insn(( 6 | ((2) << 28) | 0x80000000 | 0x02000000 | 0x01000000 | 0x04000000 ), tree->nr_args);
    struct operand *o;
    struct tnode *type;
    int i;

    for (i = 0; i < tree->nr_args; ++i) {
        o = &insn->operand[2 + i];
        type = tree->args[i]->type;

        if (((type)->t & 0x0000000000002000L))
            tree->args[i] = addrof(tree->args[i], get_tnode(0x0000000000010000L, 0, (type)));

        tree->args[i] = gen0(tree->args[i]);
        leaf_operand(o, tree->args[i]);

        if (((type)->t & 0x0000000000002000L)) {
            o->t = 0x0000000000002000L;
            o->size = size_of(type, 0);
            o->align = align_of(type);
        }
    }

    tree->left = gen0(tree->left);
    leaf_operand(&insn->operand[1], tree->left);
    if (((((tree->left->type)->t & 0x0000000000010000L) && ((((tree->left->type)->next))->t & 0x0000000000008000L)) && (((((tree->left->type)->next))->t & 0x0000000000008000L) && ((((tree->left->type)->next))->t & 0x0000000000100000L)))) insn->is_variadic = 1;

    if (sym)
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    else
                                                                         ;

    append_insn((insn), current_block);

    return sym ? sym_tree(sym) : &void_tree;
}

static struct tree *gen0(struct tree *tree)
{
    switch (tree->op)
    {
    case ( 0 | 0x80000000 ):
    case ( 1 | 0x80000000 | 0x10000000 ):
    case ( 2 | 0x80000000 ):         return tree;

    case ( 3 | 0x40000000 | 0x10000000 ):
    case ( 4 | 0x40000000 ):      return gen_fetch(tree, 0);

    case ( 5 | 0x40000000 ):        return gen_call(tree);
    case ( 6 | 0x40000000 ):        return gen_cast(tree);

    case ( 7 | 0x40000000 ):      return gen_addrof(tree);
    case ( 8 | 0x40000000 ):         return gen_unary(tree, ( 12 | ((2) << 28) | 0x80000000 ));
    case ( 9 | 0x40000000 ):         return gen_unary(tree, ( 13 | ((2) << 28) | 0x80000000 | 0x04000000 ));

    case ( 10 | 0x40000000 ):        tree = chop(tree);
                        return gen0(tree);

    case ( 11 ):         return gen_assign(tree, 0);

    case ( 12 | 0x08000000 ):      return gen_compound(tree, ( 16 | ((3) << 28) | 0x80000000 ));
    case ( 13 | 0x08000000 ):      return gen_compound(tree, ( 17 | ((3) << 28) | 0x80000000 ));
    case ( 14 | 0x08000000 ):      return gen_compound(tree, ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 15 | 0x08000000 ):      return gen_compound(tree, ( 14 | ((3) << 28) | 0x80000000 ));
    case ( 16 | 0x08000000 ):      return gen_compound(tree, ( 15 | ((3) << 28) | 0x80000000 ));
    case ( 17 ):      return gen_compound(tree, ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 18 ):      return gen_compound(tree, ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 19 ):      return gen_compound(tree, ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 20 ):       return gen_compound(tree, ( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 21 ):      return gen_compound(tree, ( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 22 ):        return gen_compound(tree, ( 14 | ((3) << 28) | 0x80000000 ));

    case ( 23 ):         return gen_binary(tree, ( 17 | ((3) << 28) | 0x80000000 ));
    case ( 24 ):         return gen_binary(tree, ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 25 | 0x20000000 ):         return gen_binary(tree, ( 16 | ((3) << 28) | 0x80000000 ));
    case ( 26 | 0x20000000 ):         return gen_binary(tree, ( 14 | ((3) << 28) | 0x80000000 ));
    case ( 27 ):         return gen_binary(tree, ( 15 | ((3) << 28) | 0x80000000 ));
    case ( 28 ):         return gen_binary(tree, ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 29 ):         return gen_binary(tree, ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 30 | 0x20000000 ):         return gen_binary(tree, ( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 31 | 0x20000000 ):         return gen_binary(tree, ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ));
    case ( 32 | 0x20000000 ):          return gen_binary(tree, ( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ));

    case ( 33 | 0x20000000 ):
    case ( 34 | 0x20000000 ):
    case ( 35 ):
    case ( 36 ):
    case ( 37 ):
    case ( 38 ):          return gen_rel(tree);

    case ( 39 ):
    case ( 40 ):        return gen_log(tree);

    case ( 41 ):       return gen_ternary(tree);




    case ( 42 ):       tree->left = gen0(tree->left);
                        tree->right = gen0(tree->right);
                        return tree;






    case ( 43 ):       tree->left = gen0(tree->left);
                        tree->right = gen0(tree->right);
                        tree = chop_right(tree);
                        return tree;

    case ( 44 ):         tree->left = gen0(tree->left);
                        tree->right = gen0(tree->right);
                        return &void_tree;

    case ( 45 ):      return gen_blk(tree, ( 38 | ((3) << 28) | 0x02000000 | 0x01000000 ));
    case ( 46 ):      return gen_blk(tree, ( 39 | ((3) << 28) | 0x01000000 ));

    case ( 47 | 0x40000000 ):         return gen_unary(tree, ( 36 | ((2) << 28) | 0x80000000 | 0x04000000 ));
    case ( 48 | 0x40000000 ):         return gen_unary(tree, ( 37 | ((2) << 28) | 0x80000000 | 0x04000000 ));
    }
}

struct tree *gen(struct tree *tree)
{
    tree = simplify(tree);
    tree = rewrite_volatiles(tree);
    return gen0(tree);
}
