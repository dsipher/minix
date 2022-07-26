# 1 "init.c"

# 15 "/home/charles/xcc/include/sys/tahoe.h"
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
# 17 "expr.h"
int constant_expr(void);



struct tree *case_expr(void);



struct tree *static_expr(void);



struct tree *assignment(void);





struct tree *test(struct tree *tree, int cmp, int k);



struct tree *expression(void);




struct tree *build_tree(int k, struct tree *left, struct tree *right);






struct tree *fake(struct tree *tree, struct tnode *type, int k);
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
# 13 "gen.h"
struct block;
struct operand;
struct tree;
struct symbol;







int loadstore(int op, struct symbol *sym, struct block *b, int i);



void branch(struct tree *tree, struct block *true, struct block *false);



struct tree *gen(struct tree *tree);




void leaf_operand(struct operand *o, struct tree *tree);
# 13 "init.h"
struct symbol;



void out_word(long t, union con con, struct symbol *sym);



void init_bss(struct symbol *sym);









void init_static(struct symbol *sym, int s);




void init_auto(struct symbol *sym);



void tentative(struct symbol *sym);



struct symbol *floateral(long t, double f);
# 22 "init.c"
static struct tnode *init(struct tnode *type, int flags, int offset);


















struct init_state
{
    struct symbol *sym;
    struct tree *tree;

    struct init_state *prev;
};

static struct init_state *state;

static void push(struct symbol *sym)
{
    struct init_state *new;

    do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);
    new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct init_state)); (_p); });
    new->sym = sym;
    new->tree = 0;
    new->prev = state;
    state = new;
}





static void header(struct symbol *sym)
{
    int align;

    seg((((((sym->type)->t) & 0x0000000000060000L)) & 0x0000000000020000L) ? 1 : 2);
    align = align_of(sym->type);
    if (align > 1) out(".align %d\n", align);
    out("%g:\n", sym);
}





static struct tree *ref(struct tnode *type, int offset)
{
    struct tree *tree;

    tree = sym_tree(state->sym);
    tree = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (type)), tree);

    if (offset) tree = binary_tree(( 26 | 0x20000000 ), get_tnode(0x0000000000010000L, 0, (type)), tree,
                                   ({ union con _con; _con.i = (offset); con_tree((&long_type), &_con); }));

    return tree;
}





static struct tree *pushback;

static struct tree *next(void)
{
    struct tree *tree;

    if (pushback) {
        tree = pushback;
        pushback = 0;
    } else
        if (state->sym)
            tree = assignment();
        else
            tree = static_expr();

    return tree;
}




static void out_bits(long i, int n)
{
    static char buf;
    static int pos;

    while (n--) {
        buf >>= 1;

        if (i & 1)
            buf |= 0x80;
        else
            buf &= 0x7F;

        i >>= 1;
        ++pos;

        if ((pos % 8) == 0)
            out(" .byte %d\n", buf & 0xFF);
    }
}




void out_word(long t, union con con, struct symbol *sym)
{
    if (t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) {
        switch (((t) & 0x000000000001FFFFL))
        {
        case 0x0000000000000400L:       {
                                float f = con.f;
                                out("\t.int %x # %f\n", *(int *)&f, f);
                                break;
                            }

        case 0x0000000000000800L:
        case 0x0000000000001000L:     out("\t.quad %X # %f\n", con.i, con.f);
                            break;
        }
    } else {
        switch (((t) & 0x000000000001FFFFL))
        {
        case 0x0000000000000002L:
        case 0x0000000000000004L:
        case 0x0000000000000008L:       fputs(("\t.byte"), out_f); break;

        case 0x0000000000000010L:
        case 0x0000000000000020L:      fputs(("\t.short"), out_f); break;

        case 0x0000000000000040L:
        case 0x0000000000000080L:        fputs(("\t.int"), out_f); break;

        case 0x0000000000010000L:
        case 0x0000000000000100L:
        case 0x0000000000000200L:       fputs(("\t.quad"), out_f); break;
        }

        out(" %G\n", sym, con.i);
    }
}




static void init_pad(int n)
{
    if (state->sym == 0) {
        if (n % 8)
            out_bits(0, n % 8);

        if (n / 8)
            out(" .fill %d, 1, 0\n", n / 8);
    }
}









static void init_value(struct tnode *type, int offset,
                       struct tree *value, int flags)
{
    struct tree *tree;

    if (state->sym) {
        if (!((state->sym->type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L ))) {
            tree = ref(type, offset);
            tree = unary_tree(( 3 | 0x40000000 | 0x10000000 ), type, tree);
            tree->type = unfieldify(type);
        } else
            tree = sym_tree(state->sym);

        tree = build_tree(( 58 | ((0) << 24) | 0x00100000 ), tree, value);
        state->tree = seq_tree(state->tree, tree);
    } else {
        value = fake(value, type, ( 58 | ((0) << 24) | 0x00100000 ));
        value = fold(value);

        if (((type)->t & 0x0000008000000000L)) {
            if (!(((value)->op == ( 2 | 0x80000000 )) && ((value)->sym == 0)))
                error(4, 0, "invalid bit-field initializer");

            out_bits(value->con.i, (((((type)->t) & 0x0000007F00000000L) >> 32)));
        } else
            out_word(value->type->t, value->con, value->sym);
    }
}




static int init_strlit(struct tnode *type, int offset, int flags)
{
    int nelem;

    if ((((type)->t & 0x0000000000004000L) && ((type)->nelem == 0)))
        nelem = token.s->len + 1;
    else {
        nelem = type->nelem;

        if (nelem < token.s->len)
            error(4, 0, "string literal exceeds length of array");
    }

    if (state->sym) {
        struct symbol *sym;
        struct tree *tree;
        int n;

        n = (((nelem) < (token.s->len)) ? (nelem) : (token.s->len));
        sym = literal(token.s);
        tree = sym_tree(sym);
        tree = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (tree->type)), tree);

        tree = blk_tree(( 45 ), ref(type, offset),
                        tree, ({ union con _con; _con.i = (n); con_tree((&ulong_type), &_con); }));

        state->tree = seq_tree(state->tree, tree);
    } else
        out_literal(token.s, nelem);

    lex();
    return nelem;
}



static int init_array(struct tnode *type, int offset, int flags)
{
    struct tnode *elem_type = ((type)->next);
    int elem_size = size_of(elem_type, 0);
    int nelem = 0;

    for (;;)
    {
        if (!(((type)->t & 0x0000000000004000L) && ((type)->nelem == 0)) && (nelem == type->nelem))
            error(4, 0, "too many initializers for array");

        init(elem_type, 0, offset + (nelem * elem_size));
        ++nelem;

        if (!(flags & 0x00000002) && (nelem == type->nelem))
            break;

        if (token.k == ( 21 ))
            lex();
        else
            break;
    }

    if (!(((type)->t & 0x0000000000004000L) && ((type)->nelem == 0)))
        init_pad((type->nelem - nelem) * elem_size * 8);

    return nelem;
}










static void init_strun(struct tnode *type, int offset, int flags)
{
    struct symbol *tag;
    struct symbol *member;
    int offset_bits = 0;
    int pad_bits;

    tag = ((type)->tag);
    member = tag->chain;
    do { while ((member) && ((member)->s & 0x02000000)) (member) = (member)->link; } while (0);

    if (!((tag)->s & 0x40000000))
        error(4, 0, "can't initialize incomplete %T", tag);

    for (;;)
    {
        if (member == 0)
            error(4, 0, "too many initializers for %T", tag);

        pad_bits = member->offset * 8 - offset_bits;
        if (((member->type)->t & 0x0000008000000000L)) pad_bits += (((((member->type)->t) & 0x00003F0000000000L) >> 40));
        init_pad(pad_bits);
        offset_bits += pad_bits;
        init(member->type, 0, offset + member->offset);

        if (((member->type)->t & 0x0000008000000000L))
            offset_bits += (((((member->type)->t) & 0x0000007F00000000L) >> 32));
        else
            offset_bits += size_of(member->type, 0) * 8;

        member = member->link;
        do { while ((member) && ((member)->s & 0x02000000)) (member) = (member)->link; } while (0);
        if (tag->s & 0x00000002) member = 0;

        if (!(flags & 0x00000002) && (member == 0))
            break;

        if (token.k == ( 21 ))
            lex();
        else
            break;
    }

    init_pad(size_of(type, 0) * 8 - offset_bits);
}





static struct tnode *init(struct tnode *type, int flags, int offset)
{
    struct tree *value;
    int nelem;

    if (token.k == ( 16 )) {
        flags |= 0x00000002;
        lex();
    } else
        flags &= ~0x00000002;







    if ((token.k != ( 2 )) && (token.k != ( 16 ))) {
        value = next();
        pushback = value;
    } else
        value = 0;

    if (((type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L ))
      || (((type)->t & 0x0000000000002000L)
          && value
          && ((value->type)->t & 0x0000000000002000L)
          && !(flags & 0x00000002)))
    {
        value = next();
        init_value(type, offset, value, flags);
    } else {




        if ((((type)->t & 0x0000000000004000L) && ((type)->nelem == 0)) && !(flags & 0x00000001))
            error(4, 0, "can't initialize flexible array members");

        if ((((type)->t & 0x0000000000004000L) && ((((type)->next))->t & ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ))) && (token.k == ( 2 )))
            nelem = init_strlit(type, offset, flags);
        else {



            if ((flags & 0x00000001) && !(flags & 0x00000002))
                error(4, 0, "aggregate initializer requires braces");

            if (((type)->t & 0x0000000000002000L))
                init_strun(type, offset, flags);
            else
                nelem = init_array(type, offset, flags);
        }
    }

    if (flags & 0x00000002)
        do { expect(( 17 )); lex(); } while (0);

    if ((((type)->t & 0x0000000000004000L) && ((type)->nelem == 0)))
        type = get_tnode(0x0000000000004000L, nelem, ((type)->next));

    return type;
}

void init_bss(struct symbol *sym)
{
    int size;
    int align;

    size = size_of(sym->type, sym->id);
    align = align_of(sym->type);






    if (sym->s & 0x00000010) out(".local %g\n", sym);
    out(".comm %g, %d, %d\n", sym, size, align);

    sym->s |= 0x40000000;
}

void init_static(struct symbol *sym, int s)
{
    if (token.k == ( 57 | ((0) << 24) | 0x00100000 )) {
        push(0);

        if (s & 0x00000020)
            error(4, sym->id, "initializer on `extern' declaration");

        if (((sym)->s & 0x40000000))
            error(4, sym->id, "redefinition %L", sym);

        lex();
        do { (sym)->path = path; (sym)->line_no = line_no; } while (0);
        sym->s |= 0x40000000;
        header(sym);
        sym->type = init(sym->type, 0x00000001, 0);

        do { state = state->prev; } while (0);
    } else {
        if (s != 0x00000020) {
            if (sym->scope == 1) {



                sym->s |= 0x10000000;




                if (s == 0x00000010) size_of(sym->type, sym->id);
            } else
                init_bss(sym);
        }
    }
}

void init_auto(struct symbol *sym)
{
    struct tree *tree;

    if (token.k == ( 57 | ((0) << 24) | 0x00100000 )) {
        push(sym);

        lex();
        do { if (g_flag) append_insn(new_insn(( 2 | 0x00800000 | 0x02000000 | 0x01000000 ), 0), current_block); } while (0);
        sym->type = init(sym->type, 0x00000001, 0);

        if (!((sym->type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L ))) {
            tree = blk_tree(( 46 ),
                            ref(sym->type, 0),
                            ({ union con _con; _con.i = (0); con_tree((&int_type), &_con); }),
                            ({ union con _con; _con.i = (size_of(sym->type, 0)); con_tree((&ulong_type), &_con); }));

            state->tree = seq_tree(tree, state->tree);
        }

        gen(state->tree);
        do { state = state->prev; } while (0);
    } else
        size_of(sym->type, sym->id);
}







void tentative(struct symbol *sym)
{
    if (((sym)->s & 0x40000000)) return;

    if ((((sym->type)->t & 0x0000000000004000L) && ((sym->type)->nelem == 0))) {
        error(0, sym->id, "incomplete array assigned one element");
        sym->type = get_tnode(0x0000000000004000L, 1, ((sym->type)->next));
    }

    if (((sym->type)->t & 0x0000000000002000L) && !((sym->type->tag)->s & 0x40000000))
        error(4, sym->id, "has incomplete type %T", sym->type->tag);

    init_bss(sym);
}





struct fcon
{
    union con con;
    int f_asmlab;
    int d_asmlab;

    struct fcon *link;
};

static struct fcon *fcons;
static struct slab fcon_slab = { sizeof(struct fcon), (10) };

struct symbol *floateral(long t, double f)
{
    struct fcon *p;
    int *asmlab;

    t = ((t) & ~0x0000000000060000L);

    for (p = fcons; p; p = p->link)
        if (p->con.f == f)
            break;

    if (p == 0) {
        p = ({ struct slab_obj *_obj; if (_obj = fcon_slab.free) fcon_slab.free = _obj->next; else _obj = refill_slab(&fcon_slab); --fcon_slab.avail; ((struct fcon *) (_obj)); });
        p->con.f = f;
        p->f_asmlab = 0;
        p->d_asmlab = 0;
        p->link = fcons;
        fcons = p;
    }

    asmlab = (t == 0x0000000000000400L) ? &p->f_asmlab : &p->d_asmlab;

    if (*asmlab == 0) {
        *asmlab = ++last_asmlab;
        seg(1);
        out("%L:\n", *asmlab);
        out_word(t, p->con, 0);
    }

    return anon_static((t == 0x0000000000000400L) ? &float_type : &double_type, *asmlab);
}
