# 1 "lower.c"

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
# 20 "lower.c"
static struct reg_vector tmp_regs;












static int combine(struct operand *dst, struct operand *src)
{
    int regs = 0;
    int scales = 0;
    long i;



    if ((dst->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) || (src->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) return 0;
    if (((dst)->class == 3) || ((src)->class == 3)) return 0;
    if ((((dst)->class == 2) && ((dst)->t & (( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L)) && ((((dst)->con.i) < (-2147483647 - 1)) || (((dst)->con.i) > 2147483647))) || (((src)->class == 2) && ((src)->t & (( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L)) && ((((src)->con.i) < (-2147483647 - 1)) || (((src)->con.i) > 2147483647)))) return 0;




    normalize_operand(dst); do { if ((dst)->reg != 0) ++regs; if ((dst)->index != 0) ++regs; if ((dst)->scale != 0) ++scales; } while (0);
    normalize_operand(src); do { if ((src)->reg != 0) ++regs; if ((src)->index != 0) ++regs; if ((src)->scale != 0) ++scales; } while (0);

    if (regs > 2) return 0;
    if (scales > 1) return 0;
    if (dst->sym && src->sym) return 0;

    if ((i = dst->con.i + src->con.i)
      && (dst->t & (( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L))
      && (((i) < (-2147483647 - 1)) || ((i) > 2147483647)))
        return 0;




    if (dst->sym == 0) dst->sym = src->sym;

    if ((dst->reg != 0) && (src->reg != 0))
        dst->index = src->reg;
    else {
        if (dst->reg == 0) dst->reg = src->reg;
        if (dst->index == 0) dst->index = src->index;
        if (dst->scale == 0) dst->scale = src->scale;
    }

    dst->class = 4;
    dst->con.i = i;
    normalize_con(dst->t, &dst->con);
    normalize_operand(dst);
    return 1;
}









static void cache_expand(struct block *b, struct operand *o)
{
    int n;

    if (((o)->class == 1)) {
        int dst = o->reg;

        for (n = 0; n < (((b)->lower.state.cache).size); ++n) {
            if ((((b)->lower.state.cache).elements[(n)]).reg == dst) {
                do { long _t = (o)->t; *(o) = *(&(((b)->lower.state.cache).elements[(n)]).operand); (o)->t = _t; } while (0);
                break;
            }

            if ((((unsigned) (dst)) < ((unsigned) ((((b)->lower.state.cache).elements[(n)]).reg))))
                break;
        }
    }
}






static int cache_add(struct block *b, struct operand *lhs,
                                      struct operand *rhs)
{
    struct operand new_lhs;
    struct operand new_rhs;

    new_lhs = *lhs; cache_expand(b, &new_lhs);
    new_rhs = *rhs; cache_expand(b, &new_rhs);

    if (!combine(&new_lhs, &new_rhs)) {
        new_lhs = *lhs;
        new_rhs = *rhs;

        if (!combine(&new_lhs, &new_rhs))
            return 0;
    }

    *lhs = new_lhs;
    return 1;
}









static void cache_invalidate(struct block *b, int reg, int recurse)
{
    int n;

    do { struct bitvec_vector *_v = &((b)->lower.state.naa); _v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);

    for (n = 0; n < (((b)->lower.state.cache).size); ++n) {
        struct cache *c = &(((b)->lower.state.cache).elements[(n)]);

        if ((c->operand.reg == reg) || (c->operand.index == reg))
            if (!({ struct bitvec_vector *_v = &((b)->lower.state.naa); ((_v->elements[(((((c->reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((c->reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); }))
                cache_invalidate(b, c->reg, 1);
    }

    if (!recurse) {
        for (n = 0; n < (((b)->lower.state.cache).size); ++n) {
            if (({ struct bitvec_vector *_v = &((b)->lower.state.naa); ((_v->elements[((((((((b)->lower.state.cache).elements[(n)]).reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << ((((((((b)->lower.state.cache).elements[(n)]).reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) {
                vector_delete((struct vector *) &(b->lower.state.cache), (n), (1), sizeof(*((b->lower.state.cache).elements)));
                --n;
            }
        }
    }
}











static void cache_set(struct block *b, int reg, struct operand *o)
{
    int n;

    cache_invalidate(b, reg, 0);
    normalize_operand(o);

    if (!(((o)->class == 2) && ((o)->t & (( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L)) && ((((o)->con.i) < (-2147483647 - 1)) || (((o)->con.i) > 2147483647))) && (o->reg != reg) && (o->index != reg)) {
        for (n = 0; n < (((b)->lower.state.cache).size); ++n)
            if ((((unsigned) (reg)) < ((unsigned) ((((b)->lower.state.cache).elements[(n)]).reg))))
                break;

        vector_insert((struct vector *) &(b->lower.state.cache), (n), (1), sizeof(*((b->lower.state.cache).elements)));
        ((b->lower.state.cache).elements[n]).reg = reg;
        ((b->lower.state.cache).elements[n]).operand = *o;
        do { struct bitvec_vector *_v = &((b)->lower.state.naa); _v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
    }
}



static void cache_undef(struct block *b, int reg)
{
    cache_invalidate(b, reg, 0);
    do { struct bitvec_vector *_v = &((b)->lower.state.naa); _v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
}






static int cache_is_undef(struct block *b, int reg)
{
    int n;

    if (({ struct bitvec_vector *_v = &((b)->lower.state.naa); ((_v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) return 0;

    for (n = 0; n < (((b)->lower.state.cache).size); ++n) {
        if ((((b)->lower.state.cache).elements[(n)]).reg == reg)
            return 0;

        if ((((unsigned) (reg)) < ((unsigned) ((((b)->lower.state.cache).elements[(n)]).reg))))
            break;
    }

    return 1;
}




static void cache_update(struct block *b, int i)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand l, r;
    int n, reg;

    switch (insn->op)
    {
    case ( 3 | ((2) << 28) | 0x80000000 ):
    case ( 9 | ((2) << 28) | 0x80000000 ):
    case ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ):
    case ( 14 | ((3) << 28) | 0x80000000 ):



        for (n = 0; n < (((((insn)->op) & 0x30000000) >> 28) + (insn)->nr_args); ++n) {
            reg = insn->operand[n].reg;

            if (((&insn->operand[n])->class == 1)
              && (((n) != 0) || !((insn)->op & 0x80000000) || ((insn)->op & 0x40000000) || ((insn)->operand[n].class != 1))
              && cache_is_undef(b, reg))
            {
                cache_undef(b, reg);
                return;
            }
        }

        break;

    default:



        do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0);
        insn_defs(insn, &tmp_regs, 0);

        for ((n) = 0; ((n) < ((tmp_regs).size)) && ((reg) = (((tmp_regs)).elements[(n)])); ++(n))
            cache_invalidate(b, reg, 0);

        return;
    }

    reg = insn->operand[0].reg;

    switch (insn->op)
    {
    case ( 3 | ((2) << 28) | 0x80000000 ):



        do { (&l)->class = (4); (&l)->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); (&l)->index = 0; (&l)->scale = 0; (&l)->con.i = (insn->operand[1].con.i); (&l)->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&l))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000100L)) ((&l))->t = ((0x0000000000000100L)); } while (0); } while (0);
        cache_set(b, reg, &l);
        return;

    case ( 9 | ((2) << 28) | 0x80000000 ):



        l = insn->operand[1];
        cache_expand(b, &l);
        cache_set(b, reg, &l);
        return;

    case ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ):



        if (!((&insn->operand[1])->class == 1)
          || !(((&insn->operand[2])->class == 2) && ((&insn->operand[2])->sym == 0))
          || (insn->operand[2].con.i < 1)
          || (insn->operand[2].con.i > 3))
            break;

        
do { (&l)->class = (4); (&l)->reg = 0; (&l)->index = (insn->operand[1].reg); (&l)->scale = (insn->operand[2].con.i); (&l)->con.i = 0; (&l)->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&l))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((insn->operand[1].t)) ((&l))->t = ((insn->operand[1].t)); } while (0); } while (0);

        cache_set(b, reg, &l);
        return;

    case ( 14 | ((3) << 28) | 0x80000000 ):
        l = insn->operand[1];
        r = insn->operand[2];

        if (cache_add(b, &l, &r) == 0)
            break;

        cache_set(b, reg, &l);
        return;
    }

    cache_invalidate(b, reg, 0);
}







static int same_cache(struct cache_state *cs1, struct cache_state *cs2)
{
    int n;

    if (!({ struct bitvec_vector *_dst = &(cs1->naa); struct bitvec_vector *_src = &(cs2->naa); int _size = ((cs1->naa).size); int _same = 1; int _i; for (_i = 0; _i < _size; ++_i) if (_dst->elements[_i] != (_src->elements[_i])) { _same = 0; break; } (_same); })) return 0;
    if (((cs1->cache).size) != ((cs2->cache).size)) return 0;

    for (n = 0; n < ((cs1->cache).size); ++n) {
        if (((cs1->cache).elements[n]).reg
          != ((cs2->cache).elements[n]).reg)
            return 0;

        if (!same_operand(&((cs1->cache).elements[n]).operand,
                          &((cs2->cache).elements[n]).operand))
            return 0;
    }

    return 1;
}







static void meet0(struct block *b)
{
    int n;

    __builtin_memset(((b->lower.state.naa)).elements, (0), (((b->lower.state.naa)).size) * sizeof(*(((b->lower.state.naa)).elements)));
    do { int _n = (0); if (_n <= (((b->lower.state.cache)).cap)) (((b->lower.state.cache)).size) = _n; else vector_insert((struct vector *) &((b->lower.state.cache)), (((b->lower.state.cache)).size), _n - (((b->lower.state.cache)).size), sizeof(*(((b->lower.state.cache)).elements))); } while (0);

    for (n = 0; n < (((b)->preds).size); ++n) {
        struct block *pred_b = (((b)->preds).elements[(n)]);
        int pred_i = 0, pred_reg;
        int i = 0, reg;

        do { struct bitvec_vector *_dst = &((b->lower.state.naa)); struct bitvec_vector *_src = &((pred_b->lower.exit.naa)); int _i; int _size = (((b->lower.state.naa)).size); for (_i = 0; _i < _size; ++_i) (_dst->elements[_i]) |= (_src->elements[_i]); } while (0);

        while ((i < (((b)->lower.state.cache).size)) && (pred_i < (((pred_b)->lower.exit.cache).size))) {
            reg = (((b)->lower.state.cache).elements[(i)]).reg;
            pred_reg = (((pred_b)->lower.exit.cache).elements[(pred_i)]).reg;

            if (({ struct bitvec_vector *_v = &((b)->lower.state.naa); ((_v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) {

                vector_delete((struct vector *) &(b->lower.state.cache), (i), (1), sizeof(*((b->lower.state.cache).elements)));
            } else if (({ struct bitvec_vector *_v = &((b)->lower.state.naa); ((_v->elements[(((((pred_reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((pred_reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) {

                ++pred_i;
            } else if ((((unsigned) (reg)) < ((unsigned) (pred_reg)))) {

                ++i;
            } else if ((((unsigned) (pred_reg)) < ((unsigned) (reg)))) {

                vector_insert((struct vector *) &(b->lower.state.cache), (i), (1), sizeof(*((b->lower.state.cache).elements)));
                (((b)->lower.state.cache).elements[(i)]) = (((pred_b)->lower.exit.cache).elements[(pred_i)]);
                ++i;
                ++pred_i;
            } else {



                if (!same_operand(&(((b)->lower.state.cache).elements[(i)]).operand,
                                  &(((pred_b)->lower.exit.cache).elements[(pred_i)]).operand))
                {
                    vector_delete((struct vector *) &(b->lower.state.cache), (i), (1), sizeof(*((b->lower.state.cache).elements)));
                    do { struct bitvec_vector *_v = &((b)->lower.state.naa); _v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
                    ++pred_i;
                } else {
                    ++i;
                    ++pred_i;
                }
            }
        }




        while (i < (((b)->lower.state.cache).size)) {
            reg = (((b)->lower.state.cache).elements[(i)]).reg;

            if (({ struct bitvec_vector *_v = &((b)->lower.state.naa); ((_v->elements[(((((reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); }))
                vector_delete((struct vector *) &(b->lower.state.cache), (i), (1), sizeof(*((b->lower.state.cache).elements)));
            else
                ++i;
        }




        while (pred_i < (((pred_b)->lower.exit.cache).size)) {
            pred_reg = (((pred_b)->lower.exit.cache).elements[(pred_i)]).reg;

            if (!({ struct bitvec_vector *_v = &((b)->lower.state.naa); ((_v->elements[(((((pred_reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((pred_reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) {
                do { int _n = (1); if ((((b->lower.state.cache).size) + _n) < ((b->lower.state.cache).cap)) ((b->lower.state.cache).size) += _n; else vector_insert((struct vector *) &(b->lower.state.cache), ((b->lower.state.cache).size), _n, sizeof(*((b->lower.state.cache).elements))); } while(0);
                ((b->lower.state.cache).elements[(b->lower.state.cache).size - 1]) = (((pred_b)->lower.exit.cache).elements[(pred_i)]);
            }

            ++pred_i;
        }
    }
}








static int cache0(struct block *b)
{
    int i;

    meet0(b);

    for (i = 0; i < (((b)->insns).size); ++i) cache_update(b, i);
    do { struct cache_state _tmp; _tmp = (b->lower.state); (b->lower.state) = (b->lower.exit); (b->lower.exit) = _tmp; } while (0);

    if (same_cache(&b->lower.state, &b->lower.exit))
        return 0;
    else
        return 1;
}




static void alloc0(struct cache_state *cs)
{
    do { struct bitvec_vector *_v = &(cs->naa); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(cs->naa); do { int _n = ((((nr_assigned_regs) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);
    do { (cs->cache).cap = 0; (cs->cache).size = 0; (cs->cache).elements = 0; (cs->cache).arena = (&local_arena); } while (0);
}

struct insn *move(long t, struct operand *dst, struct operand *src)
{
    struct insn *new;
    int op;

    switch (((t) & 0x000000000001FFFFL))
    {
    case 0x0000000000000002L:
    case 0x0000000000000008L:
    case 0x0000000000000004L:       op = ( 68 | ((2) << 28) | 0x80000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ); break;

    case 0x0000000000000010L:
    case 0x0000000000000020L:      op = ( 69 | ((2) << 28) | 0x80000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ); break;

    case 0x0000000000000040L:
    case 0x0000000000000080L:        op = ( 70 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ); break;

    case 0x0000000000000100L:
    case 0x0000000000000200L:
    case 0x0000000000010000L:         op = ( 71 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ); break;

    case 0x0000000000000400L:       op = ( 72 | ((2) << 28) | 0x80000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ); break;

    case 0x0000000000000800L:
    case 0x0000000000001000L:     op = ( 73 | ((2) << 28) | 0x80000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ); break;
    }

    new = new_insn(op, 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(dst); (&new->operand[0])->t = _t; } while (0);
    do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(src); (&new->operand[1])->t = _t; } while (0);
    return new;
}






static struct insn *remat(struct block *b, long t, struct operand *dst,
                                                   struct operand *src)
{
    struct operand expand = *src;
    struct insn *new;
    int op;

    cache_expand(b, &expand);

    if (((&expand)->class == 4)) {
        switch (((t) & 0x000000000001FFFFL)) {
        case 0x0000000000000002L:
        case 0x0000000000000008L:
        case 0x0000000000000004L:       op = ( 100 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ); break;

        case 0x0000000000000010L:
        case 0x0000000000000020L:      op = ( 101 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ); break;

        case 0x0000000000000040L:
        case 0x0000000000000080L:        op = ( 102 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ); break;

        case 0x0000000000000100L:
        case 0x0000000000000200L:
        case 0x0000000000010000L:         op = ( 103 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ); break;
        }

        new = new_insn(op, 0);
        do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(dst); (&new->operand[0])->t = _t; } while (0);
        do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(&expand); (&new->operand[1])->t = _t; } while (0);
    } else
        new = move(t, dst, src);

    return new;
}






struct choice
{
    long ts[3];
    int op;
    int flags;

    int (*handler)(struct block *b,
                   int i,
                   int orig_i,
                   struct choice *c);
};







static int choose(struct block *b, int i, int orig_i, struct choice *cs)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    int n = (((((insn)->op) & 0x30000000) >> 28) + (insn)->nr_args);
    int m;

    while (cs->handler) {
        for (m = 0; m < n; ++m)
            if ((insn->operand[m].t & cs->ts[m]) == 0)
                break;

        if (m == n)
            return cs->handler(b, i, orig_i, cs);

        ++cs;
    }

    error(3, 0, "choose() %d %d", b->asmlab, orig_i);
}





static int deimm(struct block *b, int i, struct operand *src)
{
    struct operand dst;
    int reg;

    if (((src)->class == 2)) {
        reg = temp_reg(src->t);
        do { (&dst)->class = 1; (&dst)->reg = (reg); do { struct tnode *_type = ((0)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((src->t)) ((&dst))->t = ((src->t)); } while (0); } while (0);
        insert_insn(move(src->t, &dst, src), b, i);
        *src = dst;
        return 1;
    } else
        return 0;
}




static int lower_cmp(struct block *b, int i,
                     int unused0, struct choice *c)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand lhs = insn->operand[0];
    struct operand *rhs = &insn->operand[1];
    struct insn *new;
    int count;

    count = deimm(b, i, &lhs);
    i += count;

    new = new_insn(c->op, 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(&lhs); (&new->operand[0])->t = _t; } while (0);
    do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(rhs); (&new->operand[1])->t = _t; } while (0);
    insert_insn(new, b, i);

    return ++count;
}

static struct choice cmp_choices[] =
{
    ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                0,
    ( 94 | ((2) << 28) | 0x04000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),             0,                      lower_cmp,

    ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),               0,
    ( 95 | ((2) << 28) | 0x04000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ),             0,                      lower_cmp,

    ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),                 0,
    ( 96 | ((2) << 28) | 0x04000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),             0,                      lower_cmp,

    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0,
    ( 97 | ((2) << 28) | 0x04000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ),             0,                      lower_cmp,

    ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),                 0,
    ( 96 | ((2) << 28) | 0x04000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),             0,                      lower_cmp,

    0x0000000000000400L,                0x0000000000000400L,                0,
    ( 98 | ((2) << 28) | 0x04000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),          0,                      lower_cmp,

    0x0000000000000800L | 0x0000000000001000L,   0x0000000000000800L | 0x0000000000001000L,   0,
    ( 99 | ((2) << 28) | 0x04000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),          0,                      lower_cmp,

    { 0 }
};










static int lower_unary2(struct block *b, int i,
                      int unused0, struct choice *c)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];
    struct operand src = insn->operand[1];
    struct insn *new;
    int count = 0;

    if (c->flags & 0x00000002) {
        count = deimm(b, i, &src);
        i += count;
    }

    new = new_insn(c->op, 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(dst); (&new->operand[0])->t = _t; } while (0);
    do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(&src); (&new->operand[1])->t = _t; } while (0);
    insert_insn(new, b, i);

    return ++count;
}

static struct choice bsf_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 0,
    ( 179 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),             0x00000002,                lower_unary2,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0,
    ( 180 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),             0x00000002,                lower_unary2,

    { 0 }
};

static struct choice bsr_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 0,
    ( 181 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),             0x00000002,                lower_unary2,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0,
    ( 182 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),             0x00000002,                lower_unary2,

    { 0 }
};

static struct choice cast_choices[] =
{
    ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ),             0,
    ( 68 | ((2) << 28) | 0x80000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),             0,                      lower_unary2,

    ( 0x0000000000000010L | 0x0000000000000020L ),               0x0000000000000008L,                0,
    ( 74 | ((2) << 28) | 0x80000000 | ((4) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000010L | 0x0000000000000020L ),               0x0000000000000002L | 0x0000000000000004L,       0,
    ( 77 | ((2) << 28) | 0x80000000 | ((4) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000010L | 0x0000000000000020L ),               ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ),             0,
    ( 69 | ((2) << 28) | 0x80000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ),             0,                      lower_unary2,

    ( 0x0000000000000040L | 0x0000000000000080L ),                 0x0000000000000008L,                0,
    ( 75 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000040L | 0x0000000000000080L ),                 0x0000000000000002L | 0x0000000000000004L,       0,
    ( 78 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000040L | 0x0000000000000080L ),                 0x0000000000000020L,               0,
    ( 80 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000040L | 0x0000000000000080L ),                 0x0000000000000010L,                0,
    ( 82 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000040L | 0x0000000000000080L ),                 ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ),             0,
    ( 70 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),             0,                      lower_unary2,

    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0x0000000000000008L,                0,
    ( 76 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0x0000000000000002L | 0x0000000000000004L,       0,
    ( 79 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0x0000000000000020L,               0,
    ( 81 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0x0000000000000010L,                0,
    ( 83 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,



    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0x0000000000000080L,                 0,
    ( 84 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0x0000000000000040L,                  0,
    ( 85 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),           0x00000002,                lower_unary2,

    ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ),             0,
    ( 71 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ),             0,                      lower_unary2,








    ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L )
    | ( 0x0000000000000010L | 0x0000000000000020L )
    | 0x0000000000000040L,                0x0000000000000400L,                0,
    ( 90 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000100L | 0x0000000000000080L,        0x0000000000000400L,                0,
    ( 91 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000400L,                0x0000000000000040L,                  0,
    ( 86 | ((2) << 28) | 0x80000000 | ((10) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000400L,                0x0000000000000100L,                 0,
    ( 87 | ((2) << 28) | 0x80000000 | ((10) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000400L,                0x0000000000000800L | 0x0000000000001000L,   0,
    ( 191 | ((2) << 28) | 0x80000000 | ((10) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),         0,                      lower_unary2,

    0x0000000000000400L,                0x0000000000000400L,                0,
    ( 72 | ((2) << 28) | 0x80000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),            0,                      lower_unary2,

    ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L )
    | ( 0x0000000000000010L | 0x0000000000000020L )
    | 0x0000000000000040L,                0x0000000000000800L | 0x0000000000001000L,   0,
    ( 92 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000100L | 0x0000000000000080L,        0x0000000000000800L | 0x0000000000001000L,   0,
    ( 93 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000800L | 0x0000000000001000L,   0x0000000000000040L,                  0,
    ( 88 | ((2) << 28) | 0x80000000 | ((11) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000800L | 0x0000000000001000L,   0x0000000000000100L,                 0,
    ( 89 | ((2) << 28) | 0x80000000 | ((11) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ),        0x00000002,                lower_unary2,

    0x0000000000000800L | 0x0000000000001000L,   0x0000000000000400L,                0,
    ( 190 | ((2) << 28) | 0x80000000 | ((11) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),         0,                      lower_unary2,

    0x0000000000000800L | 0x0000000000001000L,   0x0000000000000800L | 0x0000000000001000L,   0,
    ( 73 | ((2) << 28) | 0x80000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),            0,                      lower_unary2,

    { 0 }
};








static int lower_unary(struct block *b, int i,
                       int unused0, struct choice *c)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];
    struct operand *src = &insn->operand[1];
    struct insn *new;
    int count = 0;

    if (!(((dst)->class == 1) && ((src)->class == 1) && ((dst)->reg == (src)->reg))) {
        insert_insn(move(dst->t, dst, src), b, i++);
        ++count;
    }

    new = new_insn(c->op, 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(dst); (&new->operand[0])->t = _t; } while (0);
    insert_insn(new, b, i);
    ++count;

    return count;
}

static struct choice neg_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                0,
    ( 108 | ((1) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_unary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               0,
    ( 109 | ((1) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_unary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 0,
    ( 110 | ((1) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_unary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0,
    ( 111 | ((1) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_unary,




    { 0 }
};

static struct choice com_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                0,
    ( 104 | ((1) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) ),             0,                      lower_unary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               0,
    ( 105 | ((1) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) ),             0,                      lower_unary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 0,
    ( 106 | ((1) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) ),             0,                      lower_unary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0,
    ( 107 | ((1) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) ),             0,                      lower_unary,

    { 0 }
};
# 892 "lower.c"
static int lower_binary(struct block *b, int i,
                        int orig_i, struct choice *c)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst, *lhs;
    struct operand rhs;
    struct insn *new;
    int count = 0;
    int tmp;
    int r;




    if (!(((&insn->operand[0])->class == 1) && ((&insn->operand[1])->class == 1) && ((&insn->operand[0])->reg == (&insn->operand[1])->reg))) {
        if ((((&insn->operand[0])->class == 1) && ((&insn->operand[2])->class == 1) && ((&insn->operand[0])->reg == (&insn->operand[2])->reg)))
            commute_insn(insn);
        else if (((&insn->operand[2])->class == 1)) {
            r = range_by_use(b, insn->operand[2].reg, orig_i);

            if (range_span(b, r) == orig_i)


                commute_insn(insn);
        }
    }

    dst = &insn->operand[0];
    lhs = &insn->operand[1];
    rhs = insn->operand[2];
    tmp = 0;

    if ((c->flags & 0x00000001) && !(((&rhs)->class == 2) && ((&rhs)->sym == 0)))
        tmp = (((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000));

    if ((((&insn->operand[0])->class == 1) && ((&rhs)->class == 1) && ((&insn->operand[0])->reg == (&rhs)->reg)))
        tmp = temp_reg(rhs.t);

    if (tmp != 0) {
        do { (&rhs)->class = 1; (&rhs)->reg = (tmp); do { struct tnode *_type = ((0)); if (_type) ((&rhs))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((rhs.t)) ((&rhs))->t = ((rhs.t)); } while (0); } while (0);
        insert_insn(move(rhs.t, &rhs, &insn->operand[2]), b, i++);
        ++count;
    }

    if (!(((dst)->class == 1) && ((lhs)->class == 1) && ((dst)->reg == (lhs)->reg))) {
        insert_insn(move(dst->t, dst, lhs), b, i++);
        ++count;
    }

    new = new_insn(c->op, 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(dst); (&new->operand[0])->t = _t; } while (0);
    do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(&rhs); (&new->operand[1])->t = _t; } while (0);
    insert_insn(new, b, i++);
    ++count;

    return count;
}

static struct choice add_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),
    ( 112 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 113 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 114 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 115 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,



    { 0 }
};

static struct choice sub_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),
    ( 118 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 119 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 120 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 121 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  0x0000000000000400L,                0x0000000000000400L,
    ( 122 | ((2) << 28) | 0x80000000 | 0x40000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),            0,                      lower_binary,

    0x000000000001FFFFL,                  0x0000000000000800L | 0x0000000000001000L,   0x0000000000000800L | 0x0000000000001000L,
    ( 123 | ((2) << 28) | 0x80000000 | 0x40000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),            0,                      lower_binary,

    { 0 }
};

static struct choice mul2_choices[] =
{


    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 125 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) | 0x04000000 ),            0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 126 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),            0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 127 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),            0,                      lower_binary,



    { 0 }
};

static struct choice and_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),
    ( 155 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 156 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 157 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 158 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    { 0 }
};

static struct choice or_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),
    ( 159 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),              0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 160 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) | 0x04000000 ),              0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 161 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),              0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 162 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),              0,                      lower_binary,

    { 0 }
};

static struct choice xor_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),
    ( 163 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 164 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 165 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 166 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ),             0,                      lower_binary,

    { 0 }
};

static struct choice shl_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                0x0000000000000002L,
    ( 151 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               0x0000000000000002L,
    ( 152 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 0x0000000000000002L,
    ( 153 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        0x0000000000000002L,
    ( 154 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    { 0 }
};

static struct choice shr_choices[] =
{
    0x000000000001FFFFL,                  0x0000000000000008L,                0x0000000000000002L,
    ( 143 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  0x0000000000000002L | 0x0000000000000004L,       0x0000000000000002L,
    ( 147 | ((2) << 28) | 0x80000000 | 0x40000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  0x0000000000000020L,               0x0000000000000002L,
    ( 144 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  0x0000000000000010L,                0x0000000000000002L,
    ( 148 | ((2) << 28) | 0x80000000 | 0x40000000 | ((4) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  0x0000000000000080L,                 0x0000000000000002L,
    ( 145 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  0x0000000000000040L,                  0x0000000000000002L,
    ( 149 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  0x0000000000000200L | 0x0000000000010000L,        0x0000000000000002L,
    ( 146 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    0x000000000001FFFFL,                  0x0000000000000100L,                 0x0000000000000002L,
    ( 150 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ),             0x00000001,                lower_binary,

    { 0 }
};




static int lower_mul8(struct block *b, int i,
                      int unused0, struct choice *unused1)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];
    struct operand *lhs;
    struct operand rhs;
    struct operand rax;
    struct insn *new;
    int count;

    do { (&rax)->class = 1; (&rax)->reg = ((((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rax))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000002L)) ((&rax))->t = ((0x0000000000000002L)); } while (0); } while (0);




    if (((&insn->operand[2])->class == 2)) commute_insn(insn);

    lhs = &insn->operand[1];
    rhs = insn->operand[2];

    count = deimm(b, i, &rhs);
    i += count;

    insert_insn(remat(b, 0x0000000000000002L, &rax, lhs), b, i++);

    new = new_insn(( 124 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ), 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(&rhs); (&new->operand[0])->t = _t; } while (0);
    insert_insn(new, b, i++);

    insert_insn(move(0x0000000000000002L, dst, &rax), b, i++);

    return count + 3;
}




static int lower_mul3(struct block *b, int i,
                      int orig_i, struct choice *c)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst;
    struct operand lhs;
    struct operand *rhs;
    struct insn *new;
    int count;

    if (((&insn->operand[1])->class == 2))
        commute_insn(insn);

    if (!((&insn->operand[2])->class == 2))
        return choose(b, i, orig_i, mul2_choices);

    dst = &insn->operand[0];
    lhs = insn->operand[1];
    rhs = &insn->operand[2];

    count = deimm(b, i, &lhs);
    i += count;

    new = new_insn(c->op, 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(dst); (&new->operand[0])->t = _t; } while (0);
    do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(&lhs); (&new->operand[1])->t = _t; } while (0);
    do { long _t = (&new->operand[2])->t; *(&new->operand[2]) = *(rhs); (&new->operand[2])->t = _t; } while (0);
    insert_insn(new, b, i);

    return ++count;
}

static struct choice mul_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),
    ( 124 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ),            0,                      lower_mul8,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 128 | ((3) << 28) | 0x80000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) | ((4) << (8 + (2) * 5)) | 0x04000000 ),           0,                      lower_mul3,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 129 | ((3) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | ((6) << (8 + (2) * 5)) | 0x04000000 ),           0,                      lower_mul3,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 130 | ((3) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | ((8) << (8 + (2) * 5)) | 0x04000000 ),           0,                      lower_mul3,

    0x000000000001FFFFL,                  0x0000000000000400L,                0x0000000000000400L,
    ( 131 | ((2) << 28) | 0x80000000 | 0x40000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),            0,                      lower_binary,

    0x000000000001FFFFL,                  0x0000000000000800L | 0x0000000000001000L,   0x0000000000000800L | 0x0000000000001000L,
    ( 132 | ((2) << 28) | 0x80000000 | 0x40000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),            0,                      lower_binary,

    { 0 }
};







static int lower_divmod(struct block *b, int i,
                        struct choice *c, int mod)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];
    struct operand *lhs = &insn->operand[1];
    struct operand rhs = insn->operand[2];
    struct operand rax;
    struct operand rdx;
    struct insn *new;
    int byte;
    int count;

    do { (&rax)->class = 1; (&rax)->reg = ((((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rax))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((dst->t)) ((&rax))->t = ((dst->t)); } while (0); } while (0);
    do { (&rdx)->class = 1; (&rdx)->reg = ((((2) < 16) ? (((2) << 14) | 0x80000000) : (((2) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rdx))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((dst->t)) ((&rdx))->t = ((dst->t)); } while (0); } while (0);



    byte = (dst->t & ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L )) != 0;



    count = deimm(b, i, &rhs);
    i += count;

    if (byte) {





        new = new_insn(c->flags ? ( 78 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ) : ( 75 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ), 0);
        do { (&new->operand[0])->class = 1; (&new->operand[0])->reg = ((((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&new->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000040L)) ((&new->operand[0]))->t = ((0x0000000000000040L)); } while (0); } while (0);
        do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(lhs); (&new->operand[1])->t = _t; } while (0);
        insert_insn(new, b, i++);
        ++count;
    } else {





        insert_insn(remat(b, dst->t, &rax, lhs), b, i++);

        if (c->flags)
            insert_insn(new_insn(c->flags, 0), b, i++);
        else {
            new = new_insn(( 70 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), 0);
            do { (&new->operand[0])->class = 1; (&new->operand[0])->reg = ((((2) < 16) ? (((2) << 14) | 0x80000000) : (((2) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&new->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000040L)) ((&new->operand[0]))->t = ((0x0000000000000040L)); } while (0); } while (0);
            do { union con _con; _con.i = (0); do { ((&new->operand[1]))->class = 2; ((&new->operand[1]))->con = (_con); ((&new->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&new->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000040L))) (((&new->operand[1])))->t = (((0x0000000000000040L))); } while (0); } while (0); } while (0);
            insert_insn(new, b, i++);
        }

        count += 2;
    }

    new = new_insn(c->op, 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(&rhs); (&new->operand[0])->t = _t; } while (0);
    insert_insn(new, b, i++);
    ++count;







    if (mod && byte) {
        new = new_insn(( 145 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) | 0x04000000 ), 0);
        do { (&new->operand[0])->class = 1; (&new->operand[0])->reg = ((((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&new->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000040L)) ((&new->operand[0]))->t = ((0x0000000000000040L)); } while (0); } while (0);
        do { union con _con; _con.i = (8); do { ((&new->operand[1]))->class = 2; ((&new->operand[1]))->con = (_con); ((&new->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&new->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000002L))) (((&new->operand[1])))->t = (((0x0000000000000002L))); } while (0); } while (0); } while (0);
        insert_insn(new, b, i++);
        ++count;
        mod = 0;
    }

    if (mod)
        insert_insn(move(dst->t, dst, &rdx), b, i);
    else
        insert_insn(move(dst->t, dst, &rax), b, i);

    return ++count;
}

static int lower_div(struct block *b, int i,
                     int unused0, struct choice *c)
{
    return lower_divmod(b, i, c, 0);
}

static int lower_mod(struct block *b, int i,
                     int unused0, struct choice *c)
{
    return lower_divmod(b, i, c, 1);
}

static struct choice mod_choices[] =
{
    0x000000000001FFFFL,                  0x0000000000000008L,                0x0000000000000008L,
    ( 139 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_mod,

    0x000000000001FFFFL,                  0x0000000000000002L | 0x0000000000000004L,       0x0000000000000002L | 0x0000000000000004L,
    ( 135 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ),            ( 186 ),             lower_mod,

    0x000000000001FFFFL,                  0x0000000000000020L,               0x0000000000000020L,
    ( 140 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_mod,

    0x000000000001FFFFL,                  0x0000000000000010L,                0x0000000000000010L,
    ( 136 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ),            ( 187 ),             lower_mod,

    0x000000000001FFFFL,                  0x0000000000000080L,                 0x0000000000000080L,
    ( 141 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_mod,

    0x000000000001FFFFL,                  0x0000000000000040L,                  0x0000000000000040L,
    ( 137 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ),            ( 188 ),             lower_mod,

    0x000000000001FFFFL,                  0x0000000000000200L | 0x0000000000010000L,        0x0000000000000200L | 0x0000000000010000L,
    ( 142 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_mod,

    0x000000000001FFFFL,                  0x0000000000000100L,                 0x0000000000000100L,
    ( 138 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ),            ( 189 ),             lower_mod,

    { 0 }
};

static struct choice div_choices[] =
{
    0x000000000001FFFFL,                  0x0000000000000008L,                0x0000000000000008L,
    ( 139 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_div,

    0x000000000001FFFFL,                  0x0000000000000002L | 0x0000000000000004L,       0x0000000000000002L | 0x0000000000000004L,
    ( 135 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ),            ( 186 ),             lower_div,

    0x000000000001FFFFL,                  0x0000000000000020L,               0x0000000000000020L,
    ( 140 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_div,

    0x000000000001FFFFL,                  0x0000000000000010L,                0x0000000000000010L,
    ( 136 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ),            ( 187 ),             lower_div,

    0x000000000001FFFFL,                  0x0000000000000080L,                 0x0000000000000080L,
    ( 141 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_div,

    0x000000000001FFFFL,                  0x0000000000000040L,                  0x0000000000000040L,
    ( 137 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ),            ( 188 ),             lower_div,

    0x000000000001FFFFL,                  0x0000000000000200L | 0x0000000000010000L,        0x0000000000000200L | 0x0000000000010000L,
    ( 142 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ),             0,                      lower_div,

    0x000000000001FFFFL,                  0x0000000000000100L,                 0x0000000000000100L,
    ( 138 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ),            ( 189 ),             lower_div,

    0x000000000001FFFFL,                  0x0000000000000400L,                0x0000000000000400L,
    ( 133 | ((2) << 28) | 0x80000000 | 0x40000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),            0,                      lower_binary,

    0x000000000001FFFFL,                  0x0000000000000800L | 0x0000000000001000L,   0x0000000000000800L | 0x0000000000001000L,
    ( 134 | ((2) << 28) | 0x80000000 | 0x40000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),            0,                      lower_binary,

    { 0 }
};



















static int lower_lea(struct block *b, int i,
                     int orig_i, struct choice *c)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];
    struct operand lhs = insn->operand[1];
    struct operand rhs = insn->operand[2];
    struct insn *new;

    if (cache_add(b, &lhs, &rhs)) {
        if (((&lhs)->class == 4)) {
            new = new_insn(c->op, 0);
            do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(dst); (&new->operand[0])->t = _t; } while (0);
            do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(&lhs); (&new->operand[1])->t = _t; } while (0);
        } else
            new = move(dst->t, dst, &lhs);

        insert_insn(new, b, i);
        return 1;
    } else
        return choose(b, i, orig_i, add_choices);
}

static struct choice lea_choices[] =
{
    0x000000000001FFFFL,                  ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),                ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ),
    ( 100 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),             0,                      lower_lea,

    0x000000000001FFFFL,                  ( 0x0000000000000010L | 0x0000000000000020L ),               ( 0x0000000000000010L | 0x0000000000000020L ),
    ( 101 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),             0,                      lower_lea,

    0x000000000001FFFFL,                  ( 0x0000000000000040L | 0x0000000000000080L ),                 ( 0x0000000000000040L | 0x0000000000000080L ),
    ( 102 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),             0,                      lower_lea,

    0x000000000001FFFFL,                  ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,        ( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000010000L,
    ( 103 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ),             0,                      lower_lea,

    0x000000000001FFFFL,                  0x0000000000000400L,                0x0000000000000400L,
    ( 116 | ((2) << 28) | 0x80000000 | 0x40000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ),            0,                      lower_binary,

    0x000000000001FFFFL,                  0x0000000000000800L | 0x0000000000001000L,   0x0000000000000800L | 0x0000000000001000L,
    ( 117 | ((2) << 28) | 0x80000000 | 0x40000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ),            0,                      lower_binary,

    { 0 }
};




static int lower_return(struct block *b, int i,
                        int unused0, struct choice *unused1)
{
    struct operand dst;
    struct operand src;
    int op = ( 65 | 0x02000000 | 0x00800000 );
    int count = 1;

    if (!((func_ret_type)->t & 0x0000000000000001L)) {


        op = ( 66 | 0x02000000 | 0x00800000 );
        count = 2;
        do { (&dst)->class = 1; (&dst)->reg = ((((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); do { struct tnode *_type = ((func_ret_type)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&dst))->t = ((0)); } while (0); } while (0);
        do { (&src)->class = 1; (&src)->reg = (symbol_to_reg(func_ret_sym)); do { struct tnode *_type = ((func_ret_type)); if (_type) ((&src))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&src))->t = ((0)); } while (0); } while (0);

        if (((func_ret_type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) {
            op = ( 67 | 0x02000000 | 0x00800000 );
            dst.reg = (((16) < 16) ? (((16) << 14) | 0x80000000) : (((16) << 14) | 0xC0000000));
        }

        if (((func_ret_type)->t & 0x0000000000002000L)) {




            src.t = 0x0000000000010000L;
            dst.t = 0x0000000000010000L;
            src.reg = symbol_to_reg(func_hidden_arg);
        }

        insert_insn(move(dst.t, &dst, &src), b, i++);
    }

    insert_insn(new_insn(op, 0), b, i);
    return count;
}



static int nr_iargs;
static int nr_fargs;

static int lower_arg(struct block *b, int i,
                     int unused0, struct choice *unused1)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];
    struct operand src;
    int reg;

    if (dst->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))
        reg = fargs[nr_fargs++];
    else
        reg = iargs[nr_iargs++];

    do { (&src)->class = 1; (&src)->reg = (reg); do { struct tnode *_type = ((0)); if (_type) ((&src))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&src))->t = ((0)); } while (0); } while (0);
    insert_insn(move(dst->t, dst, &src), b, i);

    return 1;
}





static int lower_mem(struct block *b, int i,
                     int unused0, struct choice *unused)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    int n = (insn->op == ( 4 | ((2) << 28) | 0x80000000 | 0x02000000 ));
    struct insn *new;
    struct operand addr;
    long t;

    addr = insn->operand[n];
    cache_expand(b, &addr);
    normalize_operand(&addr);
    addr.class = 3;

    t = insn->operand[n ^ 1].t;

    if (insn->op == ( 4 | ((2) << 28) | 0x80000000 | 0x02000000 ))
        new = move(t, &insn->operand[n ^ 1], &addr);
    else
        new = move(t, &addr, &insn->operand[n ^ 1]);

    insert_insn(new, b, i);
    return 1;
}




static int lower_frame(struct block *b, int i,
                       int unused0, struct choice *unused1)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct insn *new;

    new = new_insn(( 103 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ), 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(&insn->operand[0]); (&new->operand[0])->t = _t; } while (0);
    
do { (&new->operand[1])->class = (4); (&new->operand[1])->reg = ((((11) < 16) ? (((11) << 14) | 0x80000000) : (((11) << 14) | 0xC0000000))); (&new->operand[1])->index = 0; (&new->operand[1])->scale = 0; (&new->operand[1])->con.i = (insn->operand[1].con.i); (&new->operand[1])->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&new->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&new->operand[1]))->t = ((0)); } while (0); } while (0);

    insert_insn(new, b, i);
    return 1;
}






static int asm0(struct block *b, int i, struct regmap_vector *rm)
{
    struct symbol *sym;
    struct operand dst, src;
    int from, to;
    int n;

    for (n = 0; n < ((*rm).size); ++n) {
        from = ((*rm).elements[n]).from;
        to = ((*rm).elements[n]).to;




        if ((!((((to) & 0x3FFFC000) >> 14) < (16 + 16 + 2))))
            sym = ((reg_to_symbol).elements[(((to) & 0x3FFFC000) >> 14) - (16 + 16 + 2)]);
        else
            sym = ((reg_to_symbol).elements[(((from) & 0x3FFFC000) >> 14) - (16 + 16 + 2)]);

        do { (&dst)->class = 1; (&dst)->reg = (to); do { struct tnode *_type = ((sym->type)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&dst))->t = ((0)); } while (0); } while (0);
        do { (&src)->class = 1; (&src)->reg = (from); do { struct tnode *_type = ((sym->type)); if (_type) ((&src))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&src))->t = ((0)); } while (0); } while (0);
        insert_insn(move(dst.t, &dst, &src), b, i++);
    }

    return n;
}

static int lower_asm(struct block *b, int i,
                     int unused0, struct choice *unused)
{
    struct asm_insn *insn = (struct asm_insn *) (((b)->insns).elements[(i)]);
    struct asm_insn *new = (struct asm_insn *) dup_insn((((b)->insns).elements[(i)]));
    int count;




    count = asm0(b, i, &new->uses);
    i += count;

    invert_regmap(&new->uses);
    invert_regmap(&new->defs);
    insert_insn((struct insn *) new, b, i++);
    ++count;




    count += asm0(b, i, &new->defs);
    return count;
}










static int lower_setcc(struct block *b, int i,
                       int unused0, struct choice *unused)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct insn *new;
    int cc;

    cc = ((insn->op) - ( 24 | ((1) << 28) | 0x80000000 | 0x08000000 ));
    new = new_insn((( 167 | ((1) << 28) | 0x80000000 | ((1) << (8 + (0) * 5)) | 0x08000000 ) + (cc)), 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(&insn->operand[0]); (&new->operand[0])->t = _t; } while (0);
    insert_insn(new, b, i++);

    new = new_insn(( 75 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ), 0);
    do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(&insn->operand[0]); (&new->operand[0])->t = _t; } while (0);
    do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(&insn->operand[0]); (&new->operand[1])->t = _t; } while (0);
    insert_insn(new, b, i);

    return 2;
}




static int lower_move(struct block *b, int i,
                      int unused0, struct choice *unused1)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];

    insert_insn(remat(b, dst->t, dst, &insn->operand[1]), b, i);

    return 1;
}





static int words(struct operand *bytes)
{
    int words = bytes->con.i >> 3;
    int bits = bytes->con.i & 7;

    if (!(((bytes)->class == 2) && ((bytes)->sym == 0))) return 2147483647;

    if (bits & 4) ++words;
    if (bits & 2) ++words;
    if (bits & 1) ++words;

    return words;
}











static void blkaddr(struct block *b, struct operand *o, int size)
{
    struct operand exp;

    exp = *o;
    cache_expand(b, &exp);

    switch (size)
    {
    default:



                if (((&exp)->class == 1)
                  && (size <= 127))
                    goto expanded;






                if (((&exp)->class == 4)
                  && (exp.reg != 0)
                  && (exp.sym == 0)
                  && (exp.con.i >= -128)
                  && ((exp.con.i + size) <= 127))
                    goto expanded;

                goto original;

    case 8:
    case 4:
    case 2:
    case 1:     goto expanded;
    }

expanded:
    *o = exp;
original:
    normalize_operand(o);
    o->class = 3;
}















static int copy(struct block *b, int i, struct operand *dst,
                                        struct operand *src,
                                        struct operand *bytes)
{
    int count = 0;
    int n;

    if (words(bytes) <= 3) {
        struct operand from = *src;
        struct operand to = *dst;
        int rem = bytes->con.i;
        struct operand tmp;
        struct insn *new;
        long t;

        do { (&tmp)->class = 1; (&tmp)->reg = (temp_reg(0x0000000000000100L)); do { struct tnode *_type = ((0)); if (_type) ((&tmp))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000100L)) ((&tmp))->t = ((0x0000000000000100L)); } while (0); } while (0);

        blkaddr(b, &to, rem);
        blkaddr(b, &from, rem);

        while (rem)
        {
            if (rem >= 8)       { t = 0x0000000000000100L;   n = 8; }
            else if (rem >= 4)  { t = 0x0000000000000040L;    n = 4; }
            else if (rem >= 2)  { t = 0x0000000000000010L;  n = 2; }
            else                { t = 0x0000000000000002L;   n = 1; }

            insert_insn(move(t, &tmp, &from), b, i++);
            insert_insn(move(t, &to, &tmp), b, i++);

            to.con.i += n;
            from.con.i += n;
            rem -= n;
            count += 2;
        }
    } else {
        struct operand rcx, rsi, rdi;

        do { (&rcx)->class = 1; (&rcx)->reg = ((((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rcx))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&rcx))->t = ((0)); } while (0); } while (0);
        do { (&rsi)->class = 1; (&rsi)->reg = ((((3) < 16) ? (((3) << 14) | 0x80000000) : (((3) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rsi))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&rsi))->t = ((0)); } while (0); } while (0);
        do { (&rdi)->class = 1; (&rdi)->reg = ((((4) < 16) ? (((4) << 14) | 0x80000000) : (((4) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rdi))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&rdi))->t = ((0)); } while (0); } while (0);

        insert_insn(move(0x0000000000000100L, &rcx, bytes), b, i++);
        insert_insn(move(0x0000000000000100L, &rsi, src), b, i++);
        insert_insn(move(0x0000000000000100L, &rdi, dst), b, i++);
        insert_insn(new_insn(( 185 | 0x00800000 ), 0), b, i++);
        insert_insn(new_insn(( 183 | 0x02000000 | 0x01000000 ), 0), b, i++);

        count = 5;
    }

    return count;
}






static int lower_blkcpy(struct block *b, int i,
                        int unused0, struct choice *unused1)
{
    struct insn *insn = (((b)->insns).elements[(i)]);

    return copy(b, i, &insn->operand[0],
                      &insn->operand[1],
                      &insn->operand[2]);
}







static int lower_blkset(struct block *b, int i,
                        int unused0, struct choice *unused1)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct operand *dst = &insn->operand[0];
    struct operand *val = &insn->operand[1];
    struct operand *bytes = &insn->operand[2];
    struct insn *new;
    int count = 0;
    int n;

    if (((n = words(bytes)) <= 7) && ((((val)->class == 2) && ((val)->sym == 0)) && ((val)->con.i == 0))) {
        int rem = bytes->con.i;
        struct operand zero;
        struct operand to;
        long t;
        int tmp;

        to = *dst;
        blkaddr(b, &to, rem);
        do { union con _con; _con.i = (0); do { ((&zero))->class = 2; ((&zero))->con = (_con); ((&zero))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&zero)))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&zero)))->t = (((0))); } while (0); } while (0); } while (0);

        if (n > 1) {



            tmp = temp_reg(0x0000000000000100L);

            new = new_insn(( 71 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ), 0);
            do { (&new->operand[0])->class = 1; (&new->operand[0])->reg = (tmp); do { struct tnode *_type = ((0)); if (_type) ((&new->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&new->operand[0]))->t = ((0)); } while (0); } while (0);
            do { long _t = (&new->operand[1])->t; *(&new->operand[1]) = *(&zero); (&new->operand[1])->t = _t; } while (0);
            insert_insn(new, b, i++);
            ++count;

            do { (&zero)->class = 1; (&zero)->reg = (tmp); do { struct tnode *_type = ((0)); if (_type) ((&zero))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&zero))->t = ((0)); } while (0); } while (0);
        }

        while (rem)
        {
            if (rem >= 8)       { t = 0x0000000000000100L;   n = 8; }
            else if (rem >= 4)  { t = 0x0000000000000040L;    n = 4; }
            else if (rem >= 2)  { t = 0x0000000000000010L;  n = 2; }
            else                { t = 0x0000000000000002L;   n = 1; }

            insert_insn(move(t, &to, &zero), b, i++);

            to.con.i += n;
            rem -= n;
            ++count;
        }
    } else {
        struct operand rax, rcx, rdi;

        do { (&rcx)->class = 1; (&rcx)->reg = ((((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rcx))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&rcx))->t = ((0)); } while (0); } while (0);
        do { (&rdi)->class = 1; (&rdi)->reg = ((((4) < 16) ? (((4) << 14) | 0x80000000) : (((4) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rdi))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&rdi))->t = ((0)); } while (0); } while (0);
        do { (&rax)->class = 1; (&rax)->reg = ((((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&rax))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&rax))->t = ((0)); } while (0); } while (0);

        insert_insn(move(0x0000000000000100L, &rcx, bytes), b, i++);
        insert_insn(move(0x0000000000000100L, &rdi, dst), b, i++);
        insert_insn(move(0x0000000000000002L, &rax, val), b, i++);
        insert_insn(new_insn(( 185 | 0x00800000 ), 0), b, i++);
        insert_insn(new_insn(( 184 | 0x01000000 ), 0), b, i++);

        count = 5;
    }

    return count;
}



















static int lower_call(struct block *b, int i,
                      int unused0, struct choice *unused1)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct insn *new;
    struct insn *call;
    struct insn *adj;
    int arg_i;
    int use_pushq;
    int offset;
    int count = 0;
    int n;

    arg_i = i;

    call = new_insn(( 64 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x02000000 | 0x01000000 | 0x04000000 ), 0);
    do { long _t = (&call->operand[0])->t; *(&call->operand[0]) = *(&insn->operand[1]); (&call->operand[0])->t = _t; } while (0);
    insert_insn(call, b, i++);
    ++count;




    if (((&insn->operand[0])->class == 1)) {
        struct operand src;
        long t = insn->operand[0].t;

        if (t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ))
            do { (&src)->class = 1; (&src)->reg = ((((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&src))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&src))->t = ((0)); } while (0); } while (0);
        else
            do { (&src)->class = 1; (&src)->reg = ((((16) < 16) ? (((16) << 14) | 0x80000000) : (((16) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&src))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&src))->t = ((0)); } while (0); } while (0);

        insert_insn(move(t, &insn->operand[0], &src), b, i++);
        ++count;
    }






    adj = new_insn(( 115 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ), 0);
    do { (&adj->operand[0])->class = 1; (&adj->operand[0])->reg = ((((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&adj->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&adj->operand[0]))->t = ((0)); } while (0); } while (0);

    adj->is_volatile = 1;
    insert_insn(adj, b, i++);
    ++count;






    if (!insn->is_variadic) {
        for (n = 2; n < (insn->nr_args + 2); ++n) {
            struct operand src;
            struct operand dst;
            long t = insn->operand[n].t;

            if (t & 0x0000000000002000L) continue;

            if (t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )) {
                if (call->nr_iargs == 6) continue;
                do { (&dst)->class = 1; (&dst)->reg = (iargs[call->nr_iargs]); do { struct tnode *_type = ((0)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&dst))->t = ((0)); } while (0); } while (0);
                ++call->nr_iargs;
            } else {
                if (call->nr_fargs == 8) continue;
                do { (&dst)->class = 1; (&dst)->reg = (fargs[call->nr_fargs]); do { struct tnode *_type = ((0)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&dst))->t = ((0)); } while (0); } while (0);
                ++call->nr_fargs;
            }

            do { long _t = (&src)->t; *(&src) = *(&insn->operand[n]); (&src)->t = _t; } while (0);
            insert_insn(remat(b, t, &dst, &src), b, arg_i);
            ++count;

            insn->operand[n].class = 0;
        }
    }






    use_pushq = 1;

    for (n = 2; n < (insn->nr_args + 2); ++n) {
        if (((&insn->operand[n])->class == 0))
            continue;

        if (!(insn->operand[n].t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ))) {
            use_pushq = 0;
            break;
        }
    }






    offset = 0;

    for (n = 2; n < (insn->nr_args + 2); ++n) {
        struct operand *src = &insn->operand[n];
        struct operand dst;
        struct operand bytes;
        int size = (src->t & 0x0000000000002000L) ? src->size : t_size(src->t);

        if (((src)->class == 0))
            continue;

        if (use_pushq) {
            new = new_insn(( 192 | ((1) << 28) | 0x00800000 | ((8) << (8 + (0) * 5)) ), 0);
            do { long _t = (&new->operand[0])->t; *(&new->operand[0]) = *(src); (&new->operand[0])->t = _t; } while (0);
            insert_insn(new, b, arg_i);
            ++count;
        } else {
            if (src->t & 0x0000000000002000L) {

                do { (&dst)->class = (4); (&dst)->reg = ((((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))); (&dst)->index = 0; (&dst)->scale = 0; (&dst)->con.i = (offset); (&dst)->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&dst))->t = ((0)); } while (0); } while (0);
                do { union con _con; _con.i = (size); do { ((&bytes))->class = 2; ((&bytes))->con = (_con); ((&bytes))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&bytes)))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000100L))) (((&bytes)))->t = (((0x0000000000000100L))); } while (0); } while (0); } while (0);
                count += copy(b, arg_i, &dst, src, &bytes);
            } else {
                do { (&dst)->class = (3); (&dst)->reg = ((((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))); (&dst)->index = 0; (&dst)->scale = 0; (&dst)->con.i = (offset); (&dst)->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&dst))->t = ((0)); } while (0); } while (0);
                insert_insn(move(src->t, &dst, src), b, arg_i);
                ++count;
            }
        }

        offset += size;
        offset = ((((offset) + ((8) - 1)) / (8)) * (8));
    }






    if (offset && !use_pushq) {
        new = new_insn(( 121 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ), 0);
        do { (&new->operand[0])->class = 1; (&new->operand[0])->reg = ((((10) < 16) ? (((10) << 14) | 0x80000000) : (((10) << 14) | 0xC0000000))); do { struct tnode *_type = ((0)); if (_type) ((&new->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&new->operand[0]))->t = ((0)); } while (0); } while (0);
        do { union con _con; _con.i = (offset); do { ((&new->operand[1]))->class = 2; ((&new->operand[1]))->con = (_con); ((&new->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&new->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000100L))) (((&new->operand[1])))->t = (((0x0000000000000100L))); } while (0); } while (0); } while (0);
        new->is_volatile = 1;
        insert_insn(new, b, arg_i);
        ++count;
    }

    if (offset)
        do { union con _con; _con.i = (offset); do { ((&adj->operand[1]))->class = 2; ((&adj->operand[1]))->con = (_con); ((&adj->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&adj->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0x0000000000000100L))) (((&adj->operand[1])))->t = (((0x0000000000000100L))); } while (0); } while (0); } while (0);
    else
        adj->op = ( 0 );

    return count;
}






struct sel
{
    struct choice *choices;

    int (*handler)(struct block *b,
                   int i,
                   int orig_i,
                   struct choice *choices);
};

static struct sel sel[] =
{
    {   0                                   },
    {   0,              lower_asm           },
    {   0                                   },
    {   0,              lower_frame         },
    {   0,              lower_mem           },
    {   0,              lower_mem           },
    {   0,              lower_call          },
    {   0,              lower_arg           },
    {   0,              lower_return        },
    {   0,              lower_move          },
    {   cast_choices,   choose              },
    {   cmp_choices,    choose              },
    {   neg_choices,    choose              },
    {   com_choices,    choose              },
    {   lea_choices,    choose              },
    {   sub_choices,    choose              },
    {   mul_choices,    choose              },
    {   div_choices,    choose              },
    {   mod_choices,    choose              },
    {   shr_choices,    choose              },
    {   shl_choices,    choose              },
    {   and_choices,    choose              },
    {   or_choices,     choose              },
    {   xor_choices,    choose              },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   0,              lower_setcc         },
    {   bsf_choices,    choose              },
    {   bsr_choices,    choose              },
    {   0,              lower_blkcpy        },
    {   0,              lower_blkset        }
};
# 2129 "lower.c"
void lower(void)
{
    struct block *b;
    struct insn *insn;
    struct sel *selp;
    int i, orig_i;

    do { (tmp_regs).cap = 0; (tmp_regs).size = 0; (tmp_regs).elements = 0; (tmp_regs).arena = (&local_arena); } while (0);

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        alloc0(&b->lower.state);
        alloc0(&b->lower.exit);
        __builtin_memset(((b->lower.exit.naa)).elements, (0), (((b->lower.exit.naa)).size) * sizeof(*(((b->lower.exit.naa)).elements)));
    }

    sequence_blocks(0);
    iterate_blocks(cache0);

    live_analyze(0x00000001);

    nr_iargs = 0;
    nr_fargs = 0;

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        meet0(b);
        orig_i = 0;

        for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
            selp = sel + ((insn->op) & 0x000000FF);

            if (selp->handler == 0)
                cache_update(b, i);
            else {
                i += selp->handler(b, i, orig_i, selp->choices);
                cache_update(b, i);
                vector_delete((struct vector *) &(b->insns), (i), (1), sizeof(*((b->insns).elements)));
                --i;
            }

            ++orig_i;
        }
    }

    do { struct arena *_a = (&local_arena); _a->top = _a->bottom; } while (0);
}
