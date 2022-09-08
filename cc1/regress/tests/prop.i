# 1 "prop.c"

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
# 20 "prop.c"
static void alloc0(struct block *b)
{
    do { (b->prop.state).cap = 0; (b->prop.state).size = 0; (b->prop.state).elements = 0; (b->prop.state).arena = (&local_arena); } while (0);
    do { (b->prop.defs).cap = 0; (b->prop.defs).size = 0; (b->prop.defs).elements = 0; (b->prop.defs).arena = (&local_arena); } while (0);
    do { struct bitvec_vector *_v = &(b->prop.gen); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(b->prop.kill); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(b->prop.in); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(b->prop.out); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
}


















static struct reg_vector tmp_regs;
static struct reg_vector tmp_defs;

static void local0(struct block *b)
{
    struct insn *insn;
    int i, j, k, src, dst;

    for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
        for (k = 0; k < (((b)->prop.state).size); ++k) {
            if (insn_substitute_reg(insn, (((b)->prop.state).elements[(k)]).dst,
                                          (((b)->prop.state).elements[(k)]).src,
                                          0x00000002, 0))
                opt_request |= 0x00000008 | 0x00000002 | 0x00000010;
        }

        do { int _n = (0); if (_n <= (((tmp_defs)).cap)) (((tmp_defs)).size) = _n; else vector_insert((struct vector *) &((tmp_defs)), (((tmp_defs)).size), _n - (((tmp_defs)).size), sizeof(*(((tmp_defs)).elements))); } while (0);
        insn_defs(insn, &tmp_defs, 0);

        do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0);
        union_regs(&tmp_regs, &b->prop.defs, &tmp_defs);
        do { struct reg_vector _tmp; _tmp = (b->prop.defs); (b->prop.defs) = (tmp_regs); (tmp_regs) = _tmp; } while (0);

        for ((j) = 0; ((j) < ((tmp_defs).size)) && ((dst) = (((tmp_defs)).elements[(j)])); ++(j))
            for (k = 0; k < (((b)->prop.state).size); ++k)
                if (((((b)->prop.state).elements[(k)]).dst == dst) || ((((b)->prop.state).elements[(k)]).src == dst)) {
                    vector_delete((struct vector *) &(b->prop.state), (k), (1), sizeof(*((b->prop.state).elements)));
                    --k;
                }

        if (insn_is_copy(insn, &dst, &src)) {
            do { int _n = (1); if ((((b->prop.state).size) + _n) < ((b->prop.state).cap)) ((b->prop.state).size) += _n; else vector_insert((struct vector *) &(b->prop.state), ((b->prop.state).size), _n, sizeof(*((b->prop.state).elements))); } while(0);
            ((b->prop.state).elements[(b->prop.state).size - 1]).blkno = b->asmlab;
            ((b->prop.state).elements[(b->prop.state).size - 1]).index = i;
            ((b->prop.state).elements[(b->prop.state).size - 1]).dst = dst;
            ((b->prop.state).elements[(b->prop.state).size - 1]).src = src;
        }
    }

    if (((b)->flags & 0x00000001) && ((&b->control)->class == 1))
        for (k = 0; k < (((b)->prop.state).size); ++k)
            if (b->control.reg == (((b)->prop.state).elements[(k)]).dst) {
                b->control.reg = (((b)->prop.state).elements[(k)]).src;
                opt_request |= 0x00000008;
            }
}




static struct copy_vector u;
static int u_card;
static int next_u;




static void gen0(struct block *b)
{
    int i;

    do { struct bitvec_vector *_v = &(b->prop.gen); do { int _n = ((((u_card) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);
    __builtin_memset(((b->prop.gen)).elements, (0), (((b->prop.gen)).size) * sizeof(*(((b->prop.gen)).elements)));

    for (i = 0; i < (((b)->prop.state).size); ++i) {
        ((u).elements[next_u]) = (((b)->prop.state).elements[(i)]);
        do { struct bitvec_vector *_v = &(b->prop.gen); _v->elements[((next_u) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << ((next_u) & (64 - 1))); } while (0);
        ++next_u;
    }
}







static void kill0(struct block *b)
{
    int i;

    do { struct bitvec_vector *_v = &(b->prop.kill); do { int _n = ((((u_card) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);
    __builtin_memset(((b->prop.kill)).elements, (0), (((b->prop.kill)).size) * sizeof(*(((b->prop.kill)).elements)));

    for (i = 0; i < ((u).size); ++i)
        if (contains_reg(&b->prop.defs, ((u).elements[i]).dst)
          || contains_reg(&b->prop.defs, ((u).elements[i]).src))
            do { struct bitvec_vector *_v = &(b->prop.kill); _v->elements[((i) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << ((i) & (64 - 1))); } while (0);
}



static void init0(struct block *b)
{
    do { struct bitvec_vector *_v = &(b->prop.in); do { int _n = ((((u_card) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(b->prop.out); do { int _n = ((((u_card) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);

    if (b == entry_block) {
        __builtin_memset(((b->prop.in)).elements, (0), (((b->prop.in)).size) * sizeof(*(((b->prop.in)).elements)));
        __builtin_memset(((b->prop.out)).elements, (0), (((b->prop.out)).size) * sizeof(*(((b->prop.out)).elements)));
    } else {
        __builtin_memset(((b->prop.in)).elements, (0xFF), (((b->prop.in)).size) * sizeof(*(((b->prop.in)).elements)));
        __builtin_memset(((b->prop.out)).elements, (0xFF), (((b->prop.out)).size) * sizeof(*(((b->prop.out)).elements)));
        do { struct bitvec_vector *_dst = &((b->prop.out)); struct bitvec_vector *_src = &((b->prop.kill)); int _i; int _size = (((b->prop.out)).size); for (_i = 0; _i < _size; ++_i) (_dst->elements[_i]) &=~ (_src->elements[_i]); } while (0);
        do { struct bitvec_vector *_dst = &((b->prop.out)); struct bitvec_vector *_src = &((b->prop.gen)); int _i; int _size = (((b->prop.out)).size); for (_i = 0; _i < _size; ++_i) (_dst->elements[_i]) |= (_src->elements[_i]); } while (0);
    }
}








static struct bitvec_vector tmp_bits;

static int global0(struct block *b)
{
    int n;

    __builtin_memset(((tmp_bits)).elements, (0), (((tmp_bits)).size) * sizeof(*(((tmp_bits)).elements)));

    for (n = 0; n < (((b)->preds).size); ++n) {
        struct block *pred_b = (((b)->preds).elements[(n)]);

        if (n == 0)
            do { int _dummy = &(tmp_bits) == &(pred_b->prop.out); dup_vector((struct vector *) &(tmp_bits), (struct vector *) &(pred_b->prop.out), sizeof(*((tmp_bits).elements))); } while (0);
        else
            do { struct bitvec_vector *_dst = &((tmp_bits)); struct bitvec_vector *_src = &((pred_b->prop.out)); int _i; int _size = (((tmp_bits)).size); for (_i = 0; _i < _size; ++_i) (_dst->elements[_i]) &= (_src->elements[_i]); } while (0);
    }

    if (({ struct bitvec_vector *_dst = &(tmp_bits); struct bitvec_vector *_src = &(b->prop.in); int _size = ((tmp_bits).size); int _same = 1; int _i; for (_i = 0; _i < _size; ++_i) if (_dst->elements[_i] != (_src->elements[_i])) { _same = 0; break; } (_same); }))
        return 0;

    do { int _dummy = &(b->prop.in) == &(tmp_bits); dup_vector((struct vector *) &(b->prop.in), (struct vector *) &(tmp_bits), sizeof(*((b->prop.in).elements))); } while (0);

    do { int _dummy = &(b->prop.out) == &(tmp_bits); dup_vector((struct vector *) &(b->prop.out), (struct vector *) &(tmp_bits), sizeof(*((b->prop.out).elements))); } while (0);
    do { struct bitvec_vector *_dst = &((b->prop.out)); struct bitvec_vector *_src = &((b->prop.kill)); int _i; int _size = (((b->prop.out)).size); for (_i = 0; _i < _size; ++_i) (_dst->elements[_i]) &=~ (_src->elements[_i]); } while (0);
    do { struct bitvec_vector *_dst = &((b->prop.out)); struct bitvec_vector *_src = &((b->prop.gen)); int _i; int _size = (((b->prop.out)).size); for (_i = 0; _i < _size; ++_i) (_dst->elements[_i]) |= (_src->elements[_i]); } while (0);

    return 1;
}




static void import0(struct block *b)
{
    int i;

    do { int _n = (0); if (_n <= (((b->prop.state)).cap)) (((b->prop.state)).size) = _n; else vector_insert((struct vector *) &((b->prop.state)), (((b->prop.state)).size), _n - (((b->prop.state)).size), sizeof(*(((b->prop.state)).elements))); } while (0);

    for (i = 0; i < u_card; ++i)
        if (({ struct bitvec_vector *_v = &(b->prop.in); ((_v->elements[((i) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << ((i) & (64 - 1)))) != 0); })) {
            do { int _n = (1); if ((((b->prop.state).size) + _n) < ((b->prop.state).cap)) ((b->prop.state).size) += _n; else vector_insert((struct vector *) &(b->prop.state), ((b->prop.state).size), _n, sizeof(*((b->prop.state).elements))); } while(0);
            ((b->prop.state).elements[(b->prop.state).size - 1]) = ((u).elements[i]);
        }
}

void opt_lir_prop(void)
{
    struct block *b;

    do { (u).cap = 0; (u).size = 0; (u).elements = 0; (u).arena = (&local_arena); } while (0);
    do { struct bitvec_vector *_v = &(tmp_bits); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
    do { (tmp_defs).cap = 0; (tmp_defs).size = 0; (tmp_defs).elements = 0; (tmp_defs).arena = (&local_arena); } while (0);
    do { (tmp_regs).cap = 0; (tmp_regs).size = 0; (tmp_regs).elements = 0; (tmp_regs).arena = (&local_arena); } while (0);

    for ((b) = all_blocks; (b); (b) = (b)->next) alloc0(b);
    for ((b) = all_blocks; (b); (b) = (b)->next) local0(b);

    u_card = 0;
    next_u = 0;
    for ((b) = all_blocks; (b); (b) = (b)->next) { u_card += (((b)->prop.state).size); }
    do { int _n = (u_card); if (_n <= ((u).cap)) ((u).size) = _n; else vector_insert((struct vector *) &(u), ((u).size), _n - ((u).size), sizeof(*((u).elements))); } while (0);

    for ((b) = all_blocks; (b); (b) = (b)->next) gen0(b);
    for ((b) = all_blocks; (b); (b) = (b)->next) kill0(b);
    for ((b) = all_blocks; (b); (b) = (b)->next) init0(b);

    do { struct bitvec_vector *_v = &(tmp_bits); do { int _n = ((((u_card) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);
    sequence_blocks(0);
    iterate_blocks(global0);

    for ((b) = all_blocks; (b); (b) = (b)->next) import0(b);
    for ((b) = all_blocks; (b); (b) = (b)->next) local0(b);

    do { struct arena *_a = (&local_arena); _a->top = _a->bottom; } while (0);
}
