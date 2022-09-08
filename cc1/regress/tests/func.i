# 1 "func.c"

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
# 236 "lex.h"
struct token
{
    int k;

    char *text;
    int len;

    union
    {
        union con con;
        struct string *s;
    };
};




void seed_keywords(void);



void init_lex(char *in_path);



extern struct token token;
extern struct string *path;
extern int line_no;

void lex(void);



struct token lookahead(void);




void print_k(FILE *fp, int k);
void print_token(FILE *fp, struct token *t);




void expect(int k);
# 13 "gen.h"
struct block;
struct operand;
struct tree;
struct symbol;







int loadstore(int op, struct symbol *sym, struct block *b, int i);



void branch(struct tree *tree, struct block *true, struct block *false);



struct tree *gen(struct tree *tree);




void leaf_operand(struct operand *o, struct tree *tree);
# 21 "opt.h"
extern int opt_request;
extern int opt_prohibit;
# 50 "opt.h"
void opt_prune(void);
void opt_dead(void);




void opt(int request, int prohibit);
# 23 "dom.h"
void dom_analyze(int flags);

extern int max_depth;







void out_dom(struct block *b);
# 16 "dealias.h"
void dealias(void);





int deconst(void);
# 15 "fuse.h"
void opt_mch_fuse(void);
# 16 "graph.h"
void color(void);
# 15 "switch.h"
void lir_switch(void);




void mch_switch(void);
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
# 32 "func.c"
struct symbol *current_func;
struct symbol *func_chain;
struct symbol *func_hidden_arg;
struct symbol *func_ret_sym;
struct tnode *func_ret_type;
static int frame_size;






int func_size(void)
{
    struct block *b;
    int count = 0;

    for ((b) = all_blocks; (b); (b) = (b)->next) count += (((b)->insns).size);
    return count;
}



















static int nr_iargs;
static int nr_fargs;
static int next_stack_arg;

static void arg0(struct symbol *sym)
{
    struct insn *insn;
    struct symbol *fix = 0;
    int size;

    if ((sym->id == 0) && !(sym->s & 0x00100000))
        error(4, 0, "arguments must be named");

    if (sym->type == 0)

        sym->type = &int_type;

    size = size_of(sym->type, sym->id);

    if (sym->s & 0x01000000) {
        fix = sym;
        sym = temp(&double_type);
    }

    if ((((current_func->type)->t & 0x0000000000008000L) && ((current_func->type)->t & 0x0000000000100000L)) || ((sym->type)->t & 0x0000000000002000L)
      || (((sym->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )) && (nr_iargs == 6))
      || (((sym->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) && (nr_fargs == 8)))
    {
        sym->offset = next_stack_arg;
        next_stack_arg += size;
        next_stack_arg = ((((next_stack_arg) + ((8) - 1)) / (8)) * (8));

        if (((sym->type)->t & 0x0000000000002000L) || (((((sym->type)->t) & 0x0000000000060000L)) & 0x0000000000040000L))
            return;

        loadstore(( 4 | ((2) << 28) | 0x80000000 | 0x02000000 ), sym, current_block,
                  (((current_block)->insns).size));
    } else {
        insn = new_insn(( 7 | ((1) << 28) | 0x80000000 | 0x00800000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        append_insn(insn, current_block);

        if (((sym->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )))
            ++nr_iargs;
        else
            ++nr_fargs;
    }

    if (fix) {
        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (symbol_to_reg(fix)); do { struct tnode *_type = ((fix->type)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (symbol_to_reg(sym)); do { struct tnode *_type = ((sym->type)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        append_insn(insn, current_block);
        sym = fix;
    }








    if ((((((sym->type)->t) & 0x0000000000060000L)) & 0x0000000000040000L))
        loadstore(( 5 | ((2) << 28) | 0x01000000 ), sym, current_block,
                  (((current_block)->insns).size));
}









void enter_func(struct symbol *sym)
{
    current_func = sym;

    if (((sym)->s & 0x40000000))
        error(4, sym->id, "we already did this function %L", sym);

    do { (sym)->path = path; (sym)->line_no = line_no; } while (0);
    sym->s |= 0x40000000;

    reset_blocks();
    reset_regs();
    reset_reach();
    ++reg_generation;
    frame_size = 0;
    nr_iargs = 0;
    nr_fargs = 0;
    next_stack_arg = 16;
    func_ret_type = ((sym->type)->next);

    if (!((func_ret_type)->t & 0x0000000000000001L))
        size_of(func_ret_type, 0);

    if (((func_ret_type)->t & 0x0000000000002000L)) {
        func_hidden_arg = temp(get_tnode(0x0000000000010000L, 0, (func_ret_type)));
        func_hidden_arg->s |= 0x00100000 | 0x08000000;
        arg0(func_hidden_arg);
        func_ret_sym = temp(get_tnode(0x0000000000010000L, 0, (func_ret_type)));
    } else {
        func_hidden_arg = 0;

        if (((func_ret_type)->t & 0x0000000000000001L))
            func_ret_sym = 0;
        else
            func_ret_sym = temp(func_ret_type);
    }

    walk_scope(2, 0x08000000, arg0);

    if (((func_ret_type)->t & 0x0000000000002000L)) {
        struct block *tmp = current_block;

        current_block = exit_block;

        gen(blk_tree(( 45 ),
                     sym_tree(func_hidden_arg),
                     sym_tree(func_ret_sym),
                     ({ union con _con; _con.i = (size_of(func_ret_type, 0)); con_tree((&ulong_type), &_con); })));

        current_block = tmp;
    }

    append_insn(new_insn(( 8 | 0x00800000 | 0x02000000 ), 0), exit_block);
}




void out_func(void)
{
    struct block *b;
    int i;

    sequence_blocks(0);
    seg(1);
    out("\n%g:\n", current_func);

    for (b = all_blocks; b; b = b->next) {
        out_block(b);




        if (b->flags & 0x00000001) {
            out("\tjmp ");
            out_operand(&b->control, 1);
            (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('\n'))) : __flushbuf((('\n')),(out_f)));
            continue;
        }

        for (i = 0; i < ((b->succs).size); ++i) {
            if ((((b)->succs).elements[(i)]).b == b->next)
                continue;

            out("\t%s %L\n", cc_text[(((b)->succs).elements[(i)]).cc], (((b)->succs).elements[(i)]).b->asmlab);
        }
    }

    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('\n'))) : __flushbuf((('\n')),(out_f)));
}




static void logues(void)
{
    struct reg_vector func_regs;
    struct reg_vector scratch_regs;
    struct reg_vector save_regs;
    int need_frame;
    int i, j, reg;
    int nr_fsave;
    int entry_i, exit_i;
    struct insn *insn;




    do { (scratch_regs).cap = 0; (scratch_regs).size = 0; (scratch_regs).elements = 0; (scratch_regs).arena = (&func_arena); } while (0);

    for (i = 0; i < 9; ++i) add_reg(&scratch_regs, iscratch[i]);
    for (i = 0; i < 8; ++i) add_reg(&scratch_regs, fscratch[i]);

    do { (func_regs).cap = 0; (func_regs).size = 0; (func_regs).elements = 0; (func_regs).arena = (&func_arena); } while (0);
    do { (save_regs).cap = 0; (save_regs).size = 0; (save_regs).elements = 0; (save_regs).arena = (&func_arena); } while (0);
    all_regs(&func_regs);
    diff_regs(&save_regs, &func_regs, &scratch_regs);

    need_frame = 0;
    nr_fsave = 0;

    for ((j) = 0; ((j) < ((save_regs).size)) && ((reg) = (((save_regs)).elements[(j)])); ++(j)) {
        if (reg == (((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))) continue;

        if ((((reg) & 0xC0000000) == 0x80000000)) {
            if (reg == (((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000)))
                need_frame = 1;
        } else
            ++nr_fsave;
    }





    frame_size += nr_fsave * 8;
    frame_size = ((((frame_size) + ((8) - 1)) / (8)) * (8));
    if (frame_size) need_frame = 1;





    entry_i = 0;
    exit_i = (((exit_block)->insns).size) - 1;

    if (need_frame) {
        insn = new_insn(( 192 | ((1) << 28) | 0x00800000 | ((8) << (8 + (0) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        insert_insn(insn, entry_block, entry_i++);

        insn = new_insn(( 193 | ((1) << 28) | 0x80000000 | 0x00800000 | ((8) << (8 + (0) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        insert_insn(insn, exit_block, exit_i);

        insn = new_insn(( 71 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = ((((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        insert_insn(insn, entry_block, entry_i++);

        if (frame_size) {
            insn = new_insn(( 121 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ), 0);
            do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = ((((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
            do { union con _con; _con.i = (frame_size); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000100L))) (((&insn->operand[1])))->t = (((0x0000000000000100L))); } while (0); } while (0); } while (0);
            insert_insn(insn, entry_block, entry_i++);

            insn = new_insn(( 71 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ), 0);
            do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = ((((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
            do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
            insert_insn(insn, exit_block, exit_i);
        }
    }



    i = -frame_size;

    for ((j) = 0; ((j) < ((save_regs).size)) && ((reg) = (((save_regs)).elements[(j)])); ++(j))
        if ((((reg) & 0xC0000000) == 0xC0000000)) {
            struct operand addr;
            struct operand xmm;

            do { (&xmm)->class = 1; (&xmm)->reg = (reg); do { struct tnode *_type = ((0)); if (_type) ((&xmm))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&xmm))->t = ((0)); } while (0); } while (0);
            do { (&addr)->class = (3); (&addr)->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); (&addr)->index = 0; (&addr)->scale = 0; (&addr)->con.i = (i); (&addr)->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&addr))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&addr))->t = ((0)); } while (0); } while (0);

            insert_insn(move(0x0000000000000800L, &addr, &xmm), entry_block, entry_i++);
            insert_insn(move(0x0000000000000800L, &xmm, &addr), exit_block, exit_i);

            i += 8;
        }



    for ((j) = 0; ((j) < ((save_regs).size)) && ((reg) = (((save_regs)).elements[(j)])); ++(j))
        if ((((reg) & 0xC0000000) == 0x80000000) && (reg != (((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))) & (reg != (((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000)))) {
            insn = new_insn(( 192 | ((1) << 28) | 0x00800000 | ((8) << (8 + (0) * 5)) ), 0);
            do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
            insert_insn(insn, entry_block, entry_i++);

            insn = new_insn(( 193 | ((1) << 28) | 0x80000000 | 0x00800000 | ((8) << (8 + (0) * 5)) ), 0);
            do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
            insert_insn(insn, exit_block, exit_i);
        }
}



void exit_func(void)
{
    add_succ(current_block, 12, exit_block);
    registerize(&func_chain);

    dealias();

    opt(( 0x00000001 | 0x00000002 | 0x00000004 | 0x00000010 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 ) | ( 0x00000008 | 0x00000020 ), ( 0x00000400 ));

    lir_switch();





    if (deconst()) opt(0x00000080 | 0x00000100,
                       0x00000040 | ( 0x00000400 ));

    lower();
    mch_switch();
    color();
    logues();

    out_func();
    free_symbols(&func_chain);
    do { struct arena *_a = (&func_arena); _a->top = _a->bottom; } while (0);
    current_func = 0;
}





int frame_alloc(struct tnode *type)
{
    int size = size_of(type, 0);
    int align = align_of(type);

    frame_size += size;
    frame_size = ((((frame_size) + ((align) - 1)) / (align)) * (align));

    return -frame_size;
}












struct symbol *temp(struct tnode *type)
{
    struct symbol *sym;

    sym = new_symbol(0, 0x00200000 | (((type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) ? 0x00000080 : 0x00000040));
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
