# 1 "stmt.c"

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
# 13 "decl.h"
struct tnode;




void externals(void);



void locals(void);



struct tnode *abstract(void);
# 17 "expr.h"
int constant_expr(void);



struct tree *case_expr(void);



struct tree *static_expr(void);



struct tree *assignment(void);





struct tree *test(struct tree *tree, int cmp, int k);



struct tree *expression(void);




struct tree *build_tree(int k, struct tree *left, struct tree *right);






struct tree *fake(struct tree *tree, struct tnode *type, int k);
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
# 13 "gen.h"
struct block;
struct operand;
struct tree;
struct symbol;







int loadstore(int op, struct symbol *sym, struct block *b, int i);



void branch(struct tree *tree, struct block *true, struct block *false);



struct tree *gen(struct tree *tree);




void leaf_operand(struct operand *o, struct tree *tree);
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
# 20 "string.h"
struct string
{
    unsigned hash;
    int len;
    char *text;
    int asmlab;
    int k;
    struct string *link;
};
# 59 "string.h"
struct string *string(char *text, size_t len, int arena);




void out_literal(struct string *s, int n);




void out_literals(void);




struct symbol *literal(struct string *s);
# 13 "stmt.h"
struct tree;





extern struct tree *stmt_tree;




void compound(int body);
# 23 "stmt.c"
static void stmt(void);

struct tree *stmt_tree;





static struct block *break_block;
static struct block *continue_block;
static struct block *control_block;
static struct block *default_block;
static int saw_default;











static void condition(struct block *true, struct block *false, int k)
{
    struct tree *tree;

    do { expect(( 12 )); lex(); } while (0);
    tree = expression();
    tree = test(tree, ( 53 | ((25) << 24) | 0x00700000 ), k);
    tree = gen(tree);
    branch(tree, true, false);
    do { expect(( 13 )); lex(); } while (0);
}




static void control(struct block *block)
{
    if (block == 0)
        error(4, 0, "misplaced %k statement", token.k);

    add_succ(current_block, 12, block);
    current_block = new_block();
    lex();
    do { expect(( 23 )); lex(); } while (0);
}
# 93 "stmt.c"
static void asm0(int out, struct asm_insn *insn)
{
    struct regmap_vector *mapp;
    struct symbol *sym;
    int pseudo, mach;
    int k;

    mapp = out ? &insn->defs : &insn->uses;

    lex();

    if (token.k == ( 1 )) {
        for (;;) {
            expect(( 1 ));
            k = token.s->k;

            if (k & 0x00020000) {
                mach = ((((k) - ( 94 | 0x00020000 )) < 16) ? ((((k) - ( 94 | 0x00020000 )) << 14) | 0x80000000) : ((((k) - ( 94 | 0x00020000 )) << 14) | 0xC0000000));
                lex();

                if (token.k == ( 57 | ((0) << 24) | 0x00100000 )) {
                    lex();
                    expect(( 1 ));

                    sym = lookup(token.s, ( 0x00000008 | 0x00000010 | 0x00000020 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 | 0x00000400 ),
                                 current_scope, 1);

                    if (sym == 0)
                        error(4, token.s, "unknown variable");

                    lex();

                    if (!((sym->type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )))
                        error(4, sym->id, "must be a scalar");

                    if ((((sym->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )) && !(((mach) & 0xC0000000) == 0x80000000))
                      || (((sym->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) && !(((mach) & 0xC0000000) == 0xC0000000)))
                        error(4, sym->id, "invalid register class");

                    pseudo = symbol_to_reg(sym);
                } else {
                    pseudo = 0;
                    if (!out) error(4, 0, "bogus register dependency");
                }

                add_regmap(mapp, pseudo, mach);
            } else if (k == ( 127 )) {
                if (out)
                    insn->hdr.defs_cc = 1;
                else
                    error(4, 0, "bogus %%cc dependency");

                lex();
            } else if (k == ( 126 )) {
                if (out)
                    insn->hdr.defs_mem = 1;
                else
                    insn->hdr.uses_mem = 1;

                lex();
            } else
                error(4, 0, "expected register (got %K)", &token);

            if (token.k == ( 21 ))
                lex();
            else
                break;
        }
    }
}

static void asm_stmt(void)
{
    struct asm_insn *insn = (struct asm_insn *) new_insn(( 1 | 0x00800000 ), 0);

    lex();
    do { expect(( 12 )); lex(); } while (0);
    expect(( 2 ));
    insn->text = token.s;
    lex();

    if (token.k == ( 22 | ((29) << 24) )) asm0(0, insn);
    if (token.k == ( 22 | ((29) << 24) )) asm0(1, insn);

    do { expect(( 13 )); lex(); } while (0);
    do { expect(( 23 )); lex(); } while (0);
    append_insn(((struct insn *) insn), current_block);
}



static void case_label(void)
{
    struct block *block;
    struct tree *tree;

    do { if (control_block == 0) error(4, 0, "misplaced %k (not in switch)", token.k); } while (0);

    lex();
    tree = case_expr();
    do { expect(( 22 | ((29) << 24) )); lex(); } while (0);

    block = new_block();
    add_switch_succ(control_block, &tree->con, block);
    add_succ(current_block, 12, block);
    current_block = block;
}



static void default_label(void)
{
    do { if (control_block == 0) error(4, 0, "misplaced %k (not in switch)", token.k); } while (0);

    if (saw_default) error(4, 0, "duplicate default case");

    lex();
    do { expect(( 22 | ((29) << 24) )); lex(); } while (0);
    saw_default = 1;
    add_succ(current_block, 12, default_block);
    current_block = default_block;
}



static void do_stmt(void)
{
    struct block *saved_continue = continue_block;
    struct block *saved_break = break_block;
    struct block *body_block = new_block();

    break_block = new_block();
    continue_block = new_block();
    add_succ(current_block, 12, body_block);
    current_block = body_block;

    lex();
    stmt();
    add_succ(current_block, 12, continue_block);
    current_block = continue_block;

    do { expect(( 93 | 0x80000000 )); lex(); } while (0);
    condition(body_block, break_block, ( 93 | 0x80000000 ));
    do { expect(( 23 )); lex(); } while (0);

    current_block = break_block;
    continue_block = saved_continue;
    break_block = saved_break;
}




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

    lex();                                              do { expect(( 12 )); lex(); } while (0);
    if (token.k != ( 23 )) gen(expression());           do { expect(( 23 )); lex(); } while (0);
    if (token.k != ( 23 )) test_tree = expression();    do { expect(( 23 )); lex(); } while (0);
    if (token.k != ( 13 )) step_tree = expression();  do { expect(( 13 )); lex(); } while (0);

    add_succ(current_block, 12, test_block);
    current_block = test_block;

    if (test_tree) {
        test_tree = test(test_tree, ( 53 | ((25) << 24) | 0x00700000 ), ( 75 | 0x80000000 ));
        test_tree = gen(test_tree);
        branch(test_tree, body_block, break_block);
    } else
        add_succ(current_block, 12, body_block);

    current_block = body_block;
    stmt();
    add_succ(current_block, 12, continue_block);

    current_block = continue_block;
    if (step_tree) gen(step_tree);
    add_succ(current_block, 12, test_block);

    current_block = break_block;
    continue_block = saved_continue;
    break_block = saved_break;
}



static void goto_stmt(void)
{
    struct symbol *label;

    lex();
    expect(( 1 ));
    label = lookup_label(token.s);
    add_succ(current_block, 12, label->b);
    current_block = new_block();
    lex();
    do { expect(( 23 )); lex(); } while (0);
}



static void if_stmt(void)
{
    struct block *true_block = new_block();
    struct block *else_block = new_block();
    struct block *join_block = new_block();

    lex();
    condition(true_block, else_block, ( 77 | 0x80000000 ));

    current_block = true_block;
    stmt();
    add_succ(current_block, 12, join_block);

    if (token.k == ( 71 | 0x80000000 )) {
        lex();
        current_block = else_block;
        stmt();
        else_block = current_block;
    }

    add_succ(else_block, 12, join_block);
    current_block = join_block;
}




static void return_stmt(void)
{
    struct tree *tree;

    lex();

    if (!((func_ret_type)->t & 0x0000000000000001L)) {
        tree = expression();

        if (((func_ret_type)->t & 0x0000000000002000L) && ((tree->type)->t & 0x0000000000002000L))
            tree = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (tree->type)), tree);

        tree = build_tree(( 60 | ((0) << 24) | 0x00100000 ), sym_tree(func_ret_sym), tree);
        gen(tree);
    } else

                                                                 ;

    add_succ(current_block, 12, exit_block);
    current_block = new_block();

    do { expect(( 23 )); lex(); } while (0);
}



static void switch_stmt(void)
{
    struct block *saved_control = control_block;
    struct block *saved_default = default_block;
    struct block *saved_break = break_block;
    int saved_saw_default = saw_default;
    struct block *body_block;
    struct operand o;
    struct tree *tree;

    lex();
    do { expect(( 12 )); lex(); } while (0);
    tree = expression();
    do { expect(( 13 )); lex(); } while (0);

    if (!((tree->type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )))
        error(4, 0, "controlling expression must be integral");

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
    add_succ(current_block, 12, break_block);
    if (!saw_default) add_succ(default_block, 12, break_block);
    trim_switch_block(control_block);

    current_block = break_block;
    control_block = saved_control;
    break_block = saved_break;
    default_block = saved_default;
    saw_default = saved_saw_default;
}



static void while_stmt(void)
{
    struct block *saved_break = break_block;
    struct block *saved_continue = continue_block;
    struct block *test_block = new_block();
    struct block *body_block = new_block();

    break_block = new_block();
    continue_block = test_block;

    add_succ(current_block, 12, test_block);
    current_block = test_block;

    lex();
    condition(body_block, break_block, ( 93 | 0x80000000 ));

    current_block = body_block;
    stmt();
    add_succ(current_block, 12, test_block);

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
    do { if (g_flag) append_insn(new_insn(( 2 | 0x00800000 | 0x02000000 | 0x01000000 ), 0), current_block); } while (0);

    switch (token.k)
    {
    case ( 61 | 0x80000000 ):         asm_stmt(); break;
    case ( 63 | 0x80000000 ):       control(break_block); break;
    case ( 64 | 0x80000000 ):        case_label(); goto again;
    case ( 67 | 0x80000000 ):    control(continue_block); break;
    case ( 68 | 0x80000000 ):     default_label(); goto again;
    case ( 69 | 0x80000000 ):          do_stmt(); break;
    case ( 75 | 0x80000000 ):         for_stmt(); break;
    case ( 76 | 0x80000000 ):        goto_stmt(); break;
    case ( 77 | 0x80000000 ):          if_stmt(); break;
    case ( 81 | 0x80000000 ):      return_stmt(); break;
    case ( 87 | 0x80000000 ):      switch_stmt(); break;
    case ( 93 | 0x80000000 ):       while_stmt(); break;

    case ( 16 ):
        enter_scope(0);
        compound(0);
        exit_scope(&func_chain);
        break;

    case ( 1 ):
        peek = lookahead();

        if (peek.k == ( 22 | ((29) << 24) )) {
            label = lookup_label(token.s);

            if (((label)->s & 0x40000000))
                error(4, token.s, "duplicate label %L", label);

            do { (label)->path = path; (label)->line_no = line_no; } while (0);
            label->s |= 0x40000000;

            lex();
            lex();
            add_succ(current_block, 12, label->b);
            current_block = label->b;
            goto again;
        }



    default:
        tree = expression();
        tree = gen(tree);



    case ( 23 ):
        do { expect(( 23 )); lex(); } while (0);
        break;
    }

    stmt_tree = tree;
}






void compound(int body)
{
    do { expect(( 16 )); lex(); } while (0);

    locals();













    stmt_tree = &void_tree;

    while (token.k != ( 17 )) {
        if (body) do { struct arena *_a = (&stmt_arena); _a->top = _a->bottom; } while (0);
        stmt();
    }

    if (body) check_labels();
    do { expect(( 17 )); lex(); } while (0);
}
