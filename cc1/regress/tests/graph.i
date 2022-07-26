# 1 "graph.c"

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
# 21 "opt.h"
extern int opt_request;
extern int opt_prohibit;
# 50 "opt.h"
void opt_prune(void);
void opt_dead(void);




void opt(int request, int prohibit);
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
# 23 "dom.h"
void dom_analyze(int flags);

extern int max_depth;







void out_dom(struct block *b);
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
# 15 "fuse.h"
void opt_mch_fuse(void);
# 16 "graph.h"
void color(void);
# 20 "graph.c"
static struct reg_vector tmp_regs;
static struct reg_vector tmp2_regs;

struct node_ref_vector { int cap; int size; struct node * *elements; struct arena *arena; };

struct node
{
    int reg;
    int color;




    int cost;








    struct node_ref_vector edges;





    struct node *coalesced;




    struct node *link;
};










static struct node_ref_vector graph;
static struct node *stack;








static struct reg_vector gp_colors;
static struct reg_vector xmm_colors;






static void put(struct node *n)
{
    int reg = n->reg;

    n->link = ((graph).elements[(((reg) & 0x3FFFC000) >> 14)]);
    ((graph).elements[(((reg) & 0x3FFFC000) >> 14)]) = n;
}



static void get(struct node *n)
{
    struct node **p = &((graph).elements[(((n->reg) & 0x3FFFC000) >> 14)]);

    while (*p != n) p = &(*p)->link;
    *p = n->link;
}






static struct node *find(int reg, int create)
{
    struct node *n;

    n = ((graph).elements[(((reg) & 0x3FFFC000) >> 14)]);

    while (n && (n->reg != reg))
        n = n->link;

    if ((n == 0) && create) {
        do { struct arena *_a = (&local_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);
        n = ({ struct arena *_a = (&local_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct node)); (_p); });
        __builtin_memset(n, 0, sizeof(struct node));
        do { (n->edges).cap = 0; (n->edges).size = 0; (n->edges).elements = 0; (n->edges).arena = (&local_arena); } while (0);

        n->reg = reg;

        if (((((reg) & 0x3FFFC000) >> 14) < (16 + 16 + 2)))
            n->color = reg;

        put(n);
    }

    return n;
}



static void add_half(struct node *n1, struct node *n2)
{
    int m;

    for (m = 0; m < (((n1)->edges).size); ++m)
        if ((((n1)->edges).elements[(m)]) == n2)
            return;

    do { int _n = (1); if ((((n1->edges).size) + _n) < ((n1->edges).cap)) ((n1->edges).size) += _n; else vector_insert((struct vector *) &(n1->edges), ((n1->edges).size), _n, sizeof(*((n1->edges).elements))); } while(0);
    ((n1->edges).elements[(n1->edges).size - 1]) = n2;
}



static void remove_half(struct node *n1, struct node *n2)
{
    int m;

    for (m = 0; m < (((n1)->edges).size); ++m)
        if ((((n1)->edges).elements[(m)]) == n2) {
            vector_delete((struct vector *) &(n1->edges), (m), (1), sizeof(*((n1->edges).elements)));
            break;
        }
}




static void push(struct node *n)
{
    int m;

    for (m = 0; m < (((n)->edges).size); ++m)
        remove_half((((n)->edges).elements[(m)]), n);

    get(n);
    n->link = stack;
    stack = n;
}




static struct node *pop(void)
{
    struct node *n;
    struct node *n2;
    int m;

    n = stack;
    stack = n->link;

again:






    for (m = 0; m < (((n)->edges).size); ++m) {
        n2 = (((n)->edges).elements[(m)]);

        if (n2->coalesced) {
            while (n2->coalesced)
                n2 = n2->coalesced;

            vector_delete((struct vector *) &(n->edges), (m), (1), sizeof(*((n->edges).elements)));
            add_half(n, n2);

            goto again;
        }
    }

    for (m = 0; m < (((n)->edges).size); ++m)
        add_half((((n)->edges).elements[(m)]), n);

    put(n);
    return n;
}



static int is_neighbor(struct node *n1, struct node *n2)
{
    int m;

    for (m = 0; m < (((n1)->edges).size); ++m)
        if ((((n1)->edges).elements[(m)]) == n2)
            return 1;

    return 0;
}




static void build0(void)
{
    struct block *b;
    struct node *n1, *n2;
    int j, reg;
    int r;

    for ((b) = all_blocks; (b); (b) = (b)->next)
        for (r = 0; r < (((b)->live.ranges).size); ++r)
            if ((((((b))->live.ranges).elements[((r))]).def == ((((b))->live.ranges).elements[((r))]).use)) {
                n1 = find((((b)->live.ranges).elements[(r)]).reg, 1);

                do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0);
                range_interf(b, r, &tmp_regs);

                for ((j) = 0; ((j) < ((tmp_regs).size)) && ((reg) = (((tmp_regs)).elements[(j)])); ++(j)) {
                    n2 = find(reg, 1);
                    add_half(n1, n2);
                    add_half(n2, n1);
                }
            }
}








static struct node dummy;

static int merge0(int r1, int r2)
{
    struct node *n1 = find(r1, 0);
    struct node *n2 = find(r2, 0);
    int nr_sigs;
    int m;
    int k = (((r1) & 0xC0000000) == 0x80000000) ? ((gp_colors).size) : ((xmm_colors).size);

    if (!n1 || !n2) return 0;
    if (is_neighbor(n1, n2)) return 0;

    if (((((n1->reg) & 0x3FFFC000) >> 14) < (16 + 16 + 2)) && ((((n2->reg) & 0x3FFFC000) >> 14) < (16 + 16 + 2)))
        return 0;

    if (((((n2->reg) & 0x3FFFC000) >> 14) < (16 + 16 + 2)))
        do { struct node * _tmp; _tmp = (n1); (n1) = (n2); (n2) = _tmp; } while (0);





    do { int _n = (0); if (_n <= (((dummy.edges)).cap)) (((dummy.edges)).size) = _n; else vector_insert((struct vector *) &((dummy.edges)), (((dummy.edges)).size), _n - (((dummy.edges)).size), sizeof(*(((dummy.edges)).elements))); } while (0);
    do { int _dummy = &(dummy.edges) == &(n1->edges); dup_vector((struct vector *) &(dummy.edges), (struct vector *) &(n1->edges), sizeof(*((dummy.edges).elements))); } while (0);

    for (m = 0; m < (((n2)->edges).size); ++m)
        add_half(&dummy, (((n2)->edges).elements[(m)]));

    for (nr_sigs = 0, m = 0; m < (((&dummy)->edges).size); ++m)
        if (((((((&dummy)->edges).elements[(m)]))->edges).size) > k)
            ++nr_sigs;

    if (nr_sigs >= k) return 0;




    for (m = 0; m < (((n2)->edges).size); ++m) {
        remove_half((((n2)->edges).elements[(m)]), n2);

        if ((((n2)->edges).elements[(m)]) != n1) {
            add_half(n1, (((n2)->edges).elements[(m)]));
            add_half((((n2)->edges).elements[(m)]), n1);
        }
    }

    substitute_reg(n2->reg, n1->reg);
    n2->coalesced = n1;
    do { int _n = (0); if (_n <= (((n2->edges)).cap)) (((n2->edges)).size) = _n; else vector_insert((struct vector *) &((n2->edges)), (((n2->edges)).size), _n - (((n2->edges)).size), sizeof(*(((n2->edges)).elements))); } while (0);
    get(n2);

    return 1;
}





static int coalesce0(void)
{
    struct block *b;
    struct insn *insn;
    int total;
    int src, dst;
    int depth;
    int i;

    total = 0;

restart:
    for (depth = max_depth; depth >= 0; --depth)
        for ((b) = all_blocks; (b); (b) = (b)->next) {
            if (b->depth != depth) continue;

            for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i))
                if (insn_is_copy(insn, &dst, &src))
                    if (dst == src) {





                        (((b)->insns).elements[(i)]) = &nop_insn;
                    } else if (merge0(dst, src)) {
                        ++total;
                        (((b)->insns).elements[(i)]) = &nop_insn;
                        goto restart;
                    }

        }

    return total;
}
# 402 "graph.c"
static struct node *cost0(void)
{
    struct node *n;
    struct block *b;
    struct insn *insn;
    struct node *lowest;
    int i;

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
            do { int j, reg; do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0); insn_uses(insn, &tmp_regs, 0); for ((j) = 0; ((j) < ((tmp_regs).size)) && ((reg) = (((tmp_regs)).elements[(j)])); ++(j)) { if (((((reg) & 0x3FFFC000) >> 14) < (16 + 16 + 2))) continue; n = find(reg, 0); n->cost += 1 * (64 << b->depth); } } while (0);
            do { int j, reg; do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0); insn_defs(insn, &tmp_regs, 0); for ((j) = 0; ((j) < ((tmp_regs).size)) && ((reg) = (((tmp_regs)).elements[(j)])); ++(j)) { if (((((reg) & 0x3FFFC000) >> 14) < (16 + 16 + 2))) continue; n = find(reg, 0); n->cost += 1 * (64 << b->depth); } } while (0);
        }
    }

    lowest = 0;

    for (i = (16 + 16 + 2); i < nr_assigned_regs; ++i)
        for (n = ((graph).elements[i]); n; n = n->link) {
            n->cost /= (((n)->edges).size) + 1;

            if ((lowest == 0) || (n->cost < lowest->cost))
                lowest = n;
        }

    return lowest;
}








static void spill0(void)
{
    struct block *b;
    struct insn *insn;
    struct node *n;
    struct operand reg;
    struct operand addr;
    struct symbol *sym;
    int old, new;
    int i;

    n = cost0();
    old = n->reg;






    sym = temp((((old) & 0xC0000000) == 0x80000000) ? &long_type : &double_type);
    new = symbol_to_reg(sym);
    do { (&reg)->class = 1; (&reg)->reg = (new); do { struct tnode *_type = ((0)); if (_type) ((&reg))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&reg))->t = ((0)); } while (0); } while (0);
    do { (&addr)->class = (3); (&addr)->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); (&addr)->index = 0; (&addr)->scale = 0; (&addr)->con.i = (symbol_offset(sym)); (&addr)->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&addr))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&addr))->t = ((0)); } while (0); } while (0);






    for ((b) = all_blocks; (b); (b) = (b)->next) {
        for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
            long use_t;
            long def_t;

            do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0);
            insn_uses(insn, &tmp_regs, 0);





            insn_substitute_reg(insn, old, new, 0x00000001, &def_t);
            if (def_t) insert_insn(move(def_t, &addr, &reg), b, i + 1);





            insn_substitute_reg(insn, old, new, 0x00000002, &use_t);

            if (contains_reg(&tmp_regs, old)) {
                insert_insn(move(use_t ? use_t : def_t, &reg, &addr), b, i);
                ++i;
            }
        }

        if (((b)->flags & 0x00000001)
          && ((&b->control)->class == 1)
          && (b->control.reg == old))
        {
            append_insn(move(b->control.t, &reg, &addr), b);
            b->control.reg = new;
        }
    }
}






static int simplify0(void)
{
    struct node *n;
    struct node *next;

    int success;
    int failure;
    int i;

    do {
        success = 0;
        failure = 0;

        for (i = (16 + 16 + 2); i < nr_assigned_regs; ++i)
            for (n = ((graph).elements[i]); n; n = next) {
                next = n->link;

                if ((((n)->edges).size) < ((((n->reg) & 0xC0000000) == 0x80000000) ? ((gp_colors).size) : ((xmm_colors).size))) {
                    push(n);
                    ++success;
                } else
                    ++failure;
            }
    } while (success);

    return !failure;
}







static void optimist0(void)
{
    struct node *choice;
    struct node *n;
    int i;

    choice = 0;

    for (i = (16 + 16 + 2); i < nr_assigned_regs; ++i)
        for (n = ((graph).elements[i]); n; n = n->link)
            if ((choice == 0) || ((((choice)->edges).size) > (((n)->edges).size)))
                choice = n;

    push(choice);
}





static int select0(void)
{
    struct node *n;
    int m;

    while (stack) {
        n = pop();



        do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0);

        for (m = 0; m < (((n)->edges).size); ++m)
            add_reg(&tmp_regs, (((n)->edges).elements[(m)])->color);



        diff_regs(&tmp2_regs,
                  (((n->reg) & 0xC0000000) == 0x80000000) ? &gp_colors : &xmm_colors,
                  &tmp_regs);





        if ((((tmp2_regs).size) == 0)) return 0;



        n->color = ((tmp2_regs).elements[0]);
    }

    return 1;
}



static void marker0(void)
{
    struct node *n;
    int i;

    for (i = (16 + 16 + 2); i < nr_assigned_regs; ++i)
        for (n = ((graph).elements[i]); n; n = n->link)
            substitute_reg(n->reg, n->color);
}

void color(void)
{
    int i;





    reach_analyze(0x00000001);

retry:




    opt(0x00000400 | ( 0x00000008 | 0x00000020 ), ( 0x00000001 | 0x00000002 | 0x00000004 | 0x00000010 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 ));

    dom_analyze(0x00000002);
    live_analyze(0x00000001);











    do { (gp_colors).cap = 0; (gp_colors).size = 0; (gp_colors).elements = 0; (gp_colors).arena = (&local_arena); } while (0);
    do { (xmm_colors).cap = 0; (xmm_colors).size = 0; (xmm_colors).elements = 0; (xmm_colors).arena = (&local_arena); } while (0);

    for (i = 0; i < 16; ++i)
        if (((((i) < 16) ? (((i) << 14) | 0x80000000) : (((i) << 14) | 0xC0000000)) != (((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))) && ((((i) < 16) ? (((i) << 14) | 0x80000000) : (((i) << 14) | 0xC0000000)) != (((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))))
            add_reg(&gp_colors, (((i) < 16) ? (((i) << 14) | 0x80000000) : (((i) << 14) | 0xC0000000)));

    for (i = 0; i < 16; ++i)
        add_reg(&xmm_colors, (((16 + i) < 16) ? (((16 + i) << 14) | 0x80000000) : (((16 + i) << 14) | 0xC0000000)));

    stack = 0;

    do { (graph).cap = 0; (graph).size = 0; (graph).elements = 0; (graph).arena = (&local_arena); } while (0);
    do { int _n = (nr_assigned_regs); if (_n <= ((graph).cap)) ((graph).size) = _n; else vector_insert((struct vector *) &(graph), ((graph).size), _n - ((graph).size), sizeof(*((graph).elements))); } while (0);
    __builtin_memset((graph).elements, (0), ((graph).size) * sizeof(*((graph).elements)));

    do { (tmp_regs).cap = 0; (tmp_regs).size = 0; (tmp_regs).elements = 0; (tmp_regs).arena = (&local_arena); } while (0);
    do { (tmp2_regs).cap = 0; (tmp2_regs).size = 0; (tmp2_regs).elements = 0; (tmp2_regs).arena = (&local_arena); } while (0);
    do { (dummy.edges).cap = 0; (dummy.edges).size = 0; (dummy.edges).elements = 0; (dummy.edges).arena = (&local_arena); } while (0);

    build0();
    coalesce0();

    while (simplify0() == 0) {
        if (coalesce0()) continue;
        optimist0();
    }

    if (select0() == 0) {
        while (stack) pop();
        spill0();

        goto retry;
    }

    marker0();
    opt_prune();
    do { struct arena *_a = (&local_arena); _a->top = _a->bottom; } while (0);
}
