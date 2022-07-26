# 1 "dvn.c"

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
# 20 "dvn.c"
static struct value_vector values;













static struct value_ref_vector imms;













static int new_number(struct block *b, int v, long t)
{
    int number = ((values).size);

    do { int _n = (1); if ((((values).size) + _n) < ((values).cap)) ((values).size) += _n; else vector_insert((struct vector *) &(values), ((values).size), _n, sizeof(*((values).elements))); } while(0);
    ((values).elements[(number)]).v = v;
    ((values).elements[(number)]).number = number;
    ((values).elements[(number)]).t = t;

    switch (v)
    {
    case 1:     do { int _n = (1); if ((((imms).size) + _n) < ((imms).cap)) ((imms).size) += _n; else vector_insert((struct vector *) &(imms), ((imms).size), _n, sizeof(*((imms).elements))); } while(0);
                    ((imms).elements[(imms).size - 1]) = &((values).elements[(number)]);
                    break;

    case 2:    do { int _n = (1); if ((((b->dvn.exprs).size) + _n) < ((b->dvn.exprs).cap)) ((b->dvn.exprs).size) += _n; else vector_insert((struct vector *) &(b->dvn.exprs), ((b->dvn.exprs).size), _n, sizeof(*((b->dvn.exprs).elements))); } while(0);
                    ((b->dvn.exprs).elements[(b->dvn.exprs).size - 1]) = &((values).elements[(number)]);
                    break;
    }

    return number;
}








static int imm(struct block *b, long t, union con con, struct symbol *sym)
{
    int number;
    int n;

    for (n = 0; n < ((imms).size); ++n) {
        struct value *v = ((imms).elements[(n)]);

        if (v->sym != sym) continue;
        if (!(((v->t) & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((t) & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && (((v->t) == (t)) || (((((v->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0) == (((t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)) && (t_size(v->t) == t_size(t)))))) continue;
        normalize_con(v->t, &con);

        if (v->con.i == con.i)
            return v->number;
    }

    normalize_con(t, &con);
    number = new_number(b, 1, t);
    ((values).elements[(number)]).con = con;
    ((values).elements[(number)]).sym = sym;

    return number;
}




static void assoc(struct block *b, int reg, int number)
{
    int n;

    for (n = 0; n < (((b)->dvn.regvals).size); ++n) {
        if ((((b)->dvn.regvals).elements[(n)]).reg == reg) {
            (((b)->dvn.regvals).elements[(n)]).number = number;
            return;
        }

        if ((((unsigned) (reg)) < ((unsigned) ((((b)->dvn.regvals).elements[(n)]).reg))))
            break;
    }

    vector_insert((struct vector *) &(b->dvn.regvals), (n), (1), sizeof(*((b->dvn.regvals).elements)));
    (((b)->dvn.regvals).elements[(n)]).reg = reg;
    (((b)->dvn.regvals).elements[(n)]).number = number;
}




static int reg_to_number(struct block *b, int reg, long t)
{
    int n;

    for (n = 0; n < (((b)->dvn.regvals).size); ++n) {
        if ((((b)->dvn.regvals).elements[(n)]).reg == reg)
            return (((b)->dvn.regvals).elements[(n)]).number;

        if ((((unsigned) (reg)) < ((unsigned) ((((b)->dvn.regvals).elements[(n)]).reg))))
            break;
    }

    vector_insert((struct vector *) &(b->dvn.regvals), (n), (1), sizeof(*((b->dvn.regvals).elements)));
    (((b)->dvn.regvals).elements[(n)]).reg = reg;
    (((b)->dvn.regvals).elements[(n)]).number = new_number(b, 0, t);

    return (((b)->dvn.regvals).elements[(n)]).number;
}




static int number_to_reg(struct block *b, int number)
{
    int n;

    for (n = 0; n < (((b)->dvn.regvals).size); ++n)
        if ((((b)->dvn.regvals).elements[(n)]).number == number)
            return (((b)->dvn.regvals).elements[(n)]).reg;

    return 0;
}



static void dissoc(struct block *b, int reg)
{
    int n;

    for (n = 0; n < (((b)->dvn.regvals).size); ++n) {
        if ((((b)->dvn.regvals).elements[(n)]).reg == reg) {
            vector_delete((struct vector *) &(b->dvn.regvals), (n), (1), sizeof(*((b->dvn.regvals).elements)));
            break;
        }

        if ((((unsigned) (reg)) < ((unsigned) ((((b)->dvn.regvals).elements[(n)]).reg))))
            break;
    }
}















static int reload_precedes(struct reload *r1, struct reload *r2)
{
    if (r1->base < r2->base) return 1;
    if (r1->base > r2->base) return 0;

    if (r1->offset < r2->offset) return 1;
    if (r1->offset > r2->offset) return 0;

    if (r1->sym < r2->sym) return 1;
    if (r1->sym > r2->sym) return 0;

    return ((((values).elements[((r1)->number)]).t) < (((values).elements[((r2)->number)]).t));
}




static struct reload *new_reload(struct block *b, struct reload *new)
{
    int n;

    for (n = 0; n < (((b)->dvn.reloads).size); ++n)
        if (reload_precedes(new, &(((b)->dvn.reloads).elements[(n)])))
            break;

    vector_insert((struct vector *) &(b->dvn.reloads), (n), (1), sizeof(*((b->dvn.reloads).elements)));
    (((b)->dvn.reloads).elements[(n)]) = *new;

    return &(((b)->dvn.reloads).elements[(n)]);
}



static void label(struct block *b, int i, int n)
{
    struct operand *o = &(((b)->insns).elements[(i)])->operand[n];
    union con con;

    if (((o)->class == 1))
        o->number = reg_to_number(b, o->reg, o->t);
    else
        o->number = imm(b, o->t, o->con, o->sym);
}




static int match(struct block *b, struct insn *insn)
{
    struct value *v;
    int strict = 0;
    int i, n;

    switch (insn->op)
    {
        case ( 17 | ((3) << 28) | 0x80000000 ):
        case ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ):
        case ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ):
        case ( 10 | ((2) << 28) | 0x80000000 ):        strict = 1; break;
    }

    for (i = 0; i < (((b)->dvn.exprs).size); ++i) {
        v = (((b)->dvn.exprs).elements[(i)]);

        if (v->insn->op != insn->op) continue;

        for (n = (insn->op & 0x80000000) ? 1 : 0;
             n < (((insn->op) & 0x30000000) >> 28); ++n)
        {
            if (v->insn->operand[n].number != insn->operand[n].number)
                goto mismatch;

            if (strict && (v->insn->operand[n].t != insn->operand[n].t))
                goto mismatch;
        }






        if ((insn->op == ( 10 | ((2) << 28) | 0x80000000 ))
          && !(((v->t) & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((insn->operand[0].t) & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && (((v->t) == (insn->operand[0].t)) || (((((v->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0) == (((insn->operand[0].t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)) && (t_size(v->t) == t_size(insn->operand[0].t))))))
            goto mismatch;




        if (!((((values).elements[(v->number)]).v == 1) || (number_to_reg((b), (v->number)) != 0))) {
            vector_delete((struct vector *) &(b->dvn.exprs), (i), (1), sizeof(*((b->dvn.exprs).elements)));
            --i;
            goto mismatch;
        }

        return v->number;

mismatch:   ;
    }

    return -1;
}
# 320 "dvn.c"
static void replace(struct block *b, int i, int number, int bits)
{
    struct value *v = &((values).elements[(number)]);
    struct insn *insn = (((b)->insns).elements[(i)]);
    int final_reg = insn->operand[0].reg;
    long final_t = insn->operand[0].t;
    int move_reg;

    if (t_size(final_t) != t_size(v->t))
        move_reg = temp_reg(v->t);
    else
        move_reg = final_reg;




    if (v->v == 1) {
        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (move_reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((v->t)) ((&insn->operand[0]))->t = ((v->t)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 2; (&insn->operand[1])->con = (v->con); (&insn->operand[1])->sym = (v->sym); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        insn->operand[1].t = insn->operand[0].t;
        opt_request |= 0x00000040;
    } else {
        int value_reg = number_to_reg(b, number);
        insn = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (move_reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((v->t)) ((&insn->operand[0]))->t = ((v->t)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (value_reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((v->t)) ((&insn->operand[1]))->t = ((v->t)); } while (0); } while (0);
        opt_request |= 0x00000020 | 0x00000004;
    }

    (((b)->insns).elements[(i)]) = insn;
    assoc(b, move_reg, number);




    if (move_reg != final_reg) {
        insn = new_insn(( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (move_reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((v->t)) ((&insn->operand[0]))->t = ((v->t)); } while (0); } while (0);
        insn->operand[1] = insn->operand[0];
        do { union con _con; _con.i = (bits); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((&char_type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
        insert_insn(insn, b, i + 1);

        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (final_reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((final_t)) ((&insn->operand[0]))->t = ((final_t)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (move_reg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((v->t)) ((&insn->operand[1]))->t = ((v->t)); } while (0); } while (0);
        insert_insn(insn, b, i + 2);

        opt_request |= 0x00000004 | 0x00000010 | 0x00000040;
    }

    opt_request |= 0x00000100 | 0x00000008;
}

static struct reg_vector tmp_regs;

















static void invalidate(struct block *b, struct insn *insn)
{
    int defs_mem = insn ? (((insn)->op & 0x01000000) || insn_defs_mem0(insn)) : 0;
    int uses_mem = insn ? (((insn)->op & 0x02000000) || insn_uses_mem0(insn)) : 1;
    int n, reg;

    if (insn) {
        do { int _n = (0); if (_n <= (((tmp_regs)).cap)) (((tmp_regs)).size) = _n; else vector_insert((struct vector *) &((tmp_regs)), (((tmp_regs)).size), _n - (((tmp_regs)).size), sizeof(*(((tmp_regs)).elements))); } while (0);
        insn_defs(insn, &tmp_regs, 0);
        for ((n) = 0; ((n) < ((tmp_regs).size)) && ((reg) = (((tmp_regs)).elements[(n)])); ++(n)) dissoc(b, reg);
    }

    if (defs_mem) do { int _n = (0); if (_n <= (((b->dvn.reloads)).cap)) (((b->dvn.reloads)).size) = _n; else vector_insert((struct vector *) &((b->dvn.reloads)), (((b->dvn.reloads)).size), _n - (((b->dvn.reloads)).size), sizeof(*(((b->dvn.reloads)).elements))); } while (0);

    if (uses_mem)
        for (n = 0; n < (((b)->dvn.reloads).size); ++n)
            (((b)->dvn.reloads).elements[(n)]).store = 0;
}







static void address(struct block *b, int number, struct reload *reload)
{
    __builtin_memset(reload, 0, sizeof(struct reload));
    reload->base = number;

    while ((reload->base >= 0))
    {
        struct value *v = &((values).elements[(reload->base)]);

        if (v->v == 2)
        {
            int sign = -1;
            struct operand *left = &v->insn->operand[1];
            struct operand *right = &v->insn->operand[2];

            switch (v->insn->op)
            {
            case ( 14 | ((3) << 28) | 0x80000000 ):
                sign = 1;

                if ((((left)->class == 2) && ((left)->sym == 0)))
                    do { struct operand * _tmp; _tmp = (left); (left) = (right); (right) = _tmp; } while (0);



            case ( 15 | ((3) << 28) | 0x80000000 ):
                if (!(((right)->class == 2) && ((right)->sym == 0))) return;
                reload->offset += right->con.i * sign;
                reload->base = left->number;
                break;

            case ( 3 | ((2) << 28) | 0x80000000 ):
                reload->offset += left->con.i;
                reload->base = -2;


            default:
                return;
            }
        } else if (v->v == 1) {
            reload->offset += v->con.i;
            reload->sym = v->sym;
            reload->base = -3;
            return;
        } else
            return;
    }
}
# 496 "dvn.c"
static int overlaps(struct reload *r1, struct reload *r2)
{
    int r1_size;
    int r2_size;

    if ((r1->base == -3)
      && (r2->base == -3)
      && (r1->sym != r2->sym))
        return 0;



    if ( ((r1->base == -3) && (r2->base == -2))
      || ((r2->base == -3) && (r1->base == -2)))
        return 0;




    if (r1->base != r2->base) return 1;
    if (r1->sym != r2->sym) return 1;




    r1_size = t_size((((values).elements[((r1)->number)]).t));
    r2_size = t_size((((values).elements[((r2)->number)]).t));



    if ((r1->offset == r2->offset) && (r1_size == r2_size))
        return 2;





    if (((r1->offset >= r2->offset) && (r1->offset < ((r2->offset) + r2_size))))
        if ((r1->offset + r1_size) <= (r2->offset + r2_size))
            return 3;
        else
            return 1;

    if (((r2->offset >= r1->offset) && (r2->offset < ((r1->offset) + r1_size)))) return 1;

    return 0;
}







static void load(struct block *b, int i)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct reload *match;
    struct reload new;
    int n;
    int bits;

    if (insn->is_volatile) {









        invalidate(b, 0);
        return;
    }

    label(b, i, 1);
    address(b, insn->operand[1].number, &new);
    new.number = new_number(b, 0, insn->operand[0].t);

    match = 0;

    for (n = 0; n < (((b)->dvn.reloads).size); ++n) {
        struct reload *reload = &(((b)->dvn.reloads).elements[(n)]);




        if (!((((values).elements[(reload->number)]).v == 1) || (number_to_reg((b), (reload->number)) != 0))) {
            vector_delete((struct vector *) &(b->dvn.reloads), (n), (1), sizeof(*((b->dvn.reloads).elements)));
            --n;
            continue;
        }

        if (((((((values).elements[((reload)->number)]).t)) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0) != ((((((values).elements[((&new)->number)]).t)) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0))
            continue;

        switch (overlaps(&new, reload))
        {
        case 2:


                        match = reload;
                        bits = 0;
                        goto matched;

        case 3:


                        if (((((values).elements[((&new)->number)]).t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0) {
                            match = reload;
                            bits = (new.offset - reload->offset)
                                    * 8;
                        }

                        break;
        }
    }

matched:
    if (match)
        replace(b, i, match->number, bits);
    else {
        match = new_reload(b, &new);
        invalidate(b, 0);
        assoc(b, insn->operand[0].reg, match->number);
    }
}










static int overwrite(struct block *b, struct reload *new,
                                      struct reload *reload)
{
    struct value *new_v = &((values).elements[(new->number)]);
    struct value *reload_v = &((values).elements[(reload->number)]);

    union con con;
    int shift;
    int width;



    if (!(((new_v)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )) && ((new_v)->v == 1) && ((new_v)->sym == 0)) || !(((reload_v)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )) && ((reload_v)->v == 1) && ((reload_v)->sym == 0)))
        return -1;



    width = t_size(new_v->t) * 8;
    shift = (new->offset - reload->offset) * 8;

    con.i = reload_v->con.i;
    con.i &= ~((~(-1L << (width))) << shift);
    con.i |= (new_v->con.i & (~(-1L << (width)))) << shift;

    return imm(b, reload_v->t, con, 0);
}







static void store(struct block *b, int i)
{
    struct insn *insn = (((b)->insns).elements[(i)]);
    struct reload *reload;
    struct reload new;
    int n;

    label(b, i, 0);
    label(b, i, 1);

    address(b, insn->operand[0].number, &new);
    new.number = insn->operand[1].number;
    new.store = insn->is_volatile ? 0 : &(((b)->insns).elements[(i)]);

    for (n = 0; n < (((b)->dvn.reloads).size); ++n) {
        reload = &(((b)->dvn.reloads).elements[(n)]);






        switch (overlaps(reload, &new))
        {
        case 2:
        case 3:
            if (reload->store) {
                *reload->store = &nop_insn;
                opt_request |= 0x00000008 | 0x00000100;
            }

            goto zap;
        }

        switch (overlaps(&new, reload))
        {
        case 3:





            reload->number = overwrite(b, &new, reload);

            if (reload->number == -1)
                goto zap;
            else {
                if (reload->store && !insn->is_volatile) {
                    struct insn *patch_insn;




                    patch_insn = new_insn(( 5 | ((2) << 28) | 0x01000000 ), 0);
                    patch_insn->operand[0] = (*reload->store)->operand[0];

                    
do { (&patch_insn->operand[1])->class = 2; (&patch_insn->operand[1])->con = (((values).elements[(reload->number)]).con); (&patch_insn->operand[1])->sym = (0); do { struct tnode *_type = ((0)); if (_type) ((&patch_insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&patch_insn->operand[1]))->t = ((0)); } while (0); } while (0);

                    patch_insn->operand[1].t = ((values).elements[(reload->number)]).t;
                    *reload->store = patch_insn;





                    new.store = 0;
                    (((b)->insns).elements[(i)]) = &nop_insn;
                    opt_request |= 0x00000008;
                }

                continue;
            }



        case 1:
            goto zap;





        default:
            continue;
        }

zap:    vector_delete((struct vector *) &(b->dvn.reloads), (n), (1), sizeof(*((b->dvn.reloads).elements)));
        --n;
    }




    if ((((b)->insns).elements[(i)]) != &nop_insn) new_reload(b, &new);
}




static void meet0(struct block *b, struct block *pred_b)
{
    int i, pred_i;




    i = 0;
    pred_i = 0;

    while ((i < (((b)->dvn.exprs).size)) && (pred_i < (((pred_b)->dvn.exprs).size)))
    {
        struct value *v = (((b)->dvn.exprs).elements[(i)]);
        struct value *pred_v = (((pred_b)->dvn.exprs).elements[(pred_i)]);

        if (pred_v->number < v->number)
            ++pred_i;
        else if (v->number < pred_v->number)
            vector_delete((struct vector *) &(b->dvn.exprs), (i), (1), sizeof(*((b->dvn.exprs).elements)));
        else
            ++i;
    }

    do { int _n = (i); if (_n <= ((b->dvn.exprs).cap)) ((b->dvn.exprs).size) = _n; else vector_insert((struct vector *) &(b->dvn.exprs), ((b->dvn.exprs).size), _n - ((b->dvn.exprs).size), sizeof(*((b->dvn.exprs).elements))); } while (0);




    i = 0;
    pred_i = 0;

    while ((i < (((b)->dvn.regvals).size)) && (pred_i < (((pred_b)->dvn.regvals).size)))
    {
        struct regval *rv = &(((b)->dvn.regvals).elements[(i)]);
        struct regval *pred_rv = &(((pred_b)->dvn.regvals).elements[(pred_i)]);

        if ((((unsigned) (pred_rv->reg)) < ((unsigned) (rv->reg))))
            ++pred_i;
        else if ((((unsigned) (rv->reg)) < ((unsigned) (pred_rv->reg)))
                || (rv->number != pred_rv->number))
            vector_delete((struct vector *) &(b->dvn.regvals), (i), (1), sizeof(*((b->dvn.regvals).elements)));
        else
            ++i;
    }

    do { int _n = (i); if (_n <= ((b->dvn.regvals).cap)) ((b->dvn.regvals).size) = _n; else vector_insert((struct vector *) &(b->dvn.regvals), ((b->dvn.regvals).size), _n - ((b->dvn.regvals).size), sizeof(*((b->dvn.regvals).elements))); } while (0);





    i = 0;
    pred_i = 0;

    while ((i < (((b)->dvn.reloads).size)) && (pred_i < (((pred_b)->dvn.reloads).size)))
    {
        struct reload *rel = &(((b)->dvn.reloads).elements[(i)]);
        struct reload *pred_rel = &(((pred_b)->dvn.reloads).elements[(pred_i)]);

        if (reload_precedes(pred_rel, rel))
            ++pred_i;
        else if (reload_precedes(rel, pred_rel)
                || (rel->number != pred_rel->number))
            vector_delete((struct vector *) &(b->dvn.reloads), (i), (1), sizeof(*((b->dvn.reloads).elements)));
        else
            ++i;
    }

    do { int _n = (i); if (_n <= ((b->dvn.reloads).cap)) ((b->dvn.reloads).size) = _n; else vector_insert((struct vector *) &(b->dvn.reloads), ((b->dvn.reloads).size), _n - ((b->dvn.reloads).size), sizeof(*((b->dvn.reloads).elements))); } while (0);
}











static void inherit0(struct block *b)
{
    int n;

    if (!is_pred(b, b)) {
        for (n = 0; n < (((b)->preds).size); ++n) {
            struct block *pred_b = (((b)->preds).elements[(n)]);

            if (n == 0) {
                do { int _dummy = &(b->dvn.exprs) == &(pred_b->dvn.exprs); dup_vector((struct vector *) &(b->dvn.exprs), (struct vector *) &(pred_b->dvn.exprs), sizeof(*((b->dvn.exprs).elements))); } while (0);
                do { int _dummy = &(b->dvn.regvals) == &(pred_b->dvn.regvals); dup_vector((struct vector *) &(b->dvn.regvals), (struct vector *) &(pred_b->dvn.regvals), sizeof(*((b->dvn.regvals).elements))); } while (0);
                do { int _dummy = &(b->dvn.reloads) == &(pred_b->dvn.reloads); dup_vector((struct vector *) &(b->dvn.reloads), (struct vector *) &(pred_b->dvn.reloads), sizeof(*((b->dvn.reloads).elements))); } while (0);
            } else
                meet0(b, pred_b);
        }
    }
}

static void dvn0(struct block *b)
{
    struct insn *insn;
    int i, n;
    int number;

    inherit0(b);
    invalidate(b, 0);

    for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
        switch (insn->op)
        {


        case ( 3 | ((2) << 28) | 0x80000000 ):   case ( 10 | ((2) << 28) | 0x80000000 ):    case ( 12 | ((2) << 28) | 0x80000000 ):
        case ( 13 | ((2) << 28) | 0x80000000 | 0x04000000 ):     case ( 14 | ((3) << 28) | 0x80000000 ):     case ( 15 | ((3) << 28) | 0x80000000 ):
        case ( 16 | ((3) << 28) | 0x80000000 ):     case ( 17 | ((3) << 28) | 0x80000000 ):     case ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ):
        case ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ):     case ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ):     case ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ):
        case ( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ):      case ( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ):     case ( 36 | ((2) << 28) | 0x80000000 | 0x04000000 ):
        case ( 37 | ((2) << 28) | 0x80000000 | 0x04000000 ):

                            break;



        case ( 9 | ((2) << 28) | 0x80000000 ):    label(b, i, 1);
                            assoc(b, insn->operand[0].reg,
                                insn->operand[1].number);
                            continue;

        case ( 4 | ((2) << 28) | 0x80000000 | 0x02000000 ):    load(b, i); continue;
        case ( 5 | ((2) << 28) | 0x01000000 ):   store(b, i); continue;



        default:            invalidate(b, insn); continue;
        }





        for (n = 1; n < (((insn->op) & 0x30000000) >> 28); ++n) label(b, i, n);

        if (((((insn->op) & 0x30000000) >> 28) == 3)
          && (insn->operand[1].number < insn->operand[2].number))
            commute_insn(insn);

        number = match(b, insn);

        if (number == -1) {
            number = new_number(b, 2, insn->operand[0].t);
            ((values).elements[(number)]).insn = insn;
            assoc(b, insn->operand[0].reg, number);
        } else
            replace(b, i, number, 0);
    }
}

void opt_lir_dvn(void)
{
    struct block *b;

    do { (tmp_regs).cap = 0; (tmp_regs).size = 0; (tmp_regs).elements = 0; (tmp_regs).arena = (&local_arena); } while (0);
    do { (values).cap = 0; (values).size = 0; (values).elements = 0; (values).arena = (&local_arena); } while (0);
    do { (imms).cap = 0; (imms).size = 0; (imms).elements = 0; (imms).arena = (&local_arena); } while (0);

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        do { (b->dvn.exprs).cap = 0; (b->dvn.exprs).size = 0; (b->dvn.exprs).elements = 0; (b->dvn.exprs).arena = (&local_arena); } while (0);
        do { (b->dvn.regvals).cap = 0; (b->dvn.regvals).size = 0; (b->dvn.regvals).elements = 0; (b->dvn.regvals).arena = (&local_arena); } while (0);
        do { (b->dvn.reloads).cap = 0; (b->dvn.reloads).size = 0; (b->dvn.reloads).elements = 0; (b->dvn.reloads).arena = (&local_arena); } while (0);
    }

    sequence_blocks(0);
    for ((b) = all_blocks; (b); (b) = (b)->next) dvn0(b);

    do { struct arena *_a = (&local_arena); _a->top = _a->bottom; } while (0);




    opt_request |= 0x00000002;
}
