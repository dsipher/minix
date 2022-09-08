# 1 "block.c"

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
# 14 "block.c"
struct block *all_blocks;

struct block *entry_block;
struct block *exit_block;
struct block *current_block;
# 46 "block.c"
struct block *new_block(void)
{
    struct block *b;

    do { struct arena *_a = (&func_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);
    b = ({ struct arena *_a = (&func_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct block)); (_p); });
    __builtin_memset(b, 0, sizeof(struct block));

    b->asmlab = ++last_asmlab;
    do { (b->insns).cap = 0; (b->insns).size = 0; (b->insns).elements = 0; (b->insns).arena = (&func_arena); } while (0);
    do { (b->preds).cap = 0; (b->preds).size = 0; (b->preds).elements = 0; (b->preds).arena = (&func_arena); } while (0);
    do { (b->succs).cap = 0; (b->succs).size = 0; (b->succs).elements = 0; (b->succs).arena = (&func_arena); } while (0);
    do { (b->dom).cap = 0; (b->dom).size = 0; (b->dom).elements = 0; (b->dom).arena = (&func_arena); } while (0);
    do { (b->loop).cap = 0; (b->loop).size = 0; (b->loop).elements = 0; (b->loop).arena = (&func_arena); } while (0);
    do { (b)->prev = 0; if (all_blocks) all_blocks->prev = (b); (b)->next = all_blocks; all_blocks = (b); } while (0);

    new_live(b);
    new_reach(b);

    return b;
}








void kill_block(struct block *b)
{
    remove_succs(b);
    do { if ((b)->next) (b)->next->prev = (b)->prev; if ((b)->prev) (b)->prev->next = (b)->next; else all_blocks = (b)->next; } while (0);
}




static void add_pred(struct block *b, struct block *pred_b)
{
    do { int _n = (1); if ((((b->preds).size) + _n) < ((b->preds).cap)) ((b->preds).size) += _n; else vector_insert((struct vector *) &(b->preds), ((b->preds).size), _n, sizeof(*((b->preds).elements))); } while(0);
    ((b->preds).elements[(b->preds).size - 1]) = pred_b;
}

static void remove_pred(struct block *b, struct block *pred_b)
{
    int i;

    for (i = 0; i < (((b)->preds).size); ++i)
        if ((((b)->preds).elements[(i)]) == pred_b) {
            vector_delete((struct vector *) &(b->preds), (i), (1), sizeof(*((b->preds).elements)));
            return;
        }
}

int is_pred(struct block *pred, struct block *succ)
{
    int n;

    for (n = 0; n < (((succ)->preds).size); ++n)
        if ((((succ)->preds).elements[(n)]) == pred)
            return 1;

    return 0;
}

void add_succ(struct block *b, int cc, struct block *succ_b)
{
    int i;
    int new_cc;

    if (cc != 13) {
        for (i = 0; i < (((b)->succs).size); ++i) {
            if ((((b)->succs).elements[(i)]).b == succ_b) {
                new_cc = union_cc(cc, (((b)->succs).elements[(i)]).cc);
                remove_succ(b, i);
                cc = new_cc;
                break;
            }
        }

        do { int _n = (1); if ((((b->succs).size) + _n) < ((b->succs).cap)) ((b->succs).size) += _n; else vector_insert((struct vector *) &(b->succs), ((b->succs).size), _n, sizeof(*((b->succs).elements))); } while(0);
        ((b->succs).elements[(b->succs).size - 1]).cc = cc;
        ((b->succs).elements[(b->succs).size - 1]).b = succ_b;
        add_pred(succ_b, b);
    }
}






void replace_succ(struct block *b, struct block *old_b, struct block *new_b)
{
    int cc;
    int i;

    if (((b)->flags & 0x00000001)) {
        for (i = 0; i < (((b)->succs).size); ++i)
            if ((((b)->succs).elements[(i)]).b == old_b) {
                (((b)->succs).elements[(i)]).b = new_b;
                remove_pred(old_b, b);
                add_pred(new_b, b);
            }
    } else {
again:
        for (i = 0; i < (((b)->succs).size); ++i)
            if ((((b)->succs).elements[(i)]).b == old_b) {
                cc = (((b)->succs).elements[(i)]).cc;
                remove_succ(b, i);
                add_succ(b, cc, new_b);
                goto again;
            }
    }
}




int rewrite_znz_succs(struct block *b, int nz)
{
    int res = 0;
    int n;

    for (n = 0; n < (((b)->succs).size); ++n) {
        switch ((((b)->succs).elements[(n)]).cc)
        {
        case 0:  (((b)->succs).elements[(n)]).cc = ((nz) ^ 1);
                    res = 1;
                    break;

        case 1: (((b)->succs).elements[(n)]).cc = nz;
                    res = 1;
                    break;
        }
    }

    return res;
}




void commute_succs(struct block *b)
{
    int n, cc;

    for (n = 0; n < (((b)->succs).size); ++n) {
        cc = (((b)->succs).elements[(n)]).cc;
        (((b)->succs).elements[(n)]).cc = commuted_cc[cc];
    }
}

void remove_succ(struct block *b, int n)
{
    remove_pred((((b)->succs).elements[(n)]).b, b);
    vector_delete((struct vector *) &(b->succs), (n), (1), sizeof(*((b->succs).elements)));
}

void remove_succs(struct block *b)
{
    struct block *succ_b;
    int i;

    for (i = 0; i < (((b)->succs).size); ++i) {
        succ_b = (((b)->succs).elements[(i)]).b;
        remove_pred(succ_b, b);
    }

    do { int _n = (0); if (_n <= (((b->succs)).cap)) (((b->succs)).size) = _n; else vector_insert((struct vector *) &((b->succs)), (((b->succs)).size), _n - (((b->succs)).size), sizeof(*(((b->succs)).elements))); } while (0);
    b->flags &= ~0x00000001;
}

void dup_succs(struct block *dst, struct block *src)
{
    int n;

    remove_succs(dst);
    do { int _dummy = &(dst->succs) == &(src->succs); dup_vector((struct vector *) &(dst->succs), (struct vector *) &(src->succs), sizeof(*((dst->succs).elements))); } while (0);

    if (((src)->flags & 0x00000001)) {
        dst->flags |= 0x00000001;
        dst->flags |= (src->flags & (0x00000008 | 0x00000010));
        dst->control = src->control;
    }

    for (n = 0; n < (((dst)->succs).size); ++n)
        add_pred((((dst)->succs).elements[(n)]).b, dst);
}

int fuse_block(struct block *b)
{
    struct block *succ_b;
    int count = 0;

    while ((b != entry_block)
      && (succ_b = unconditional_succ(b))
      && (succ_b != exit_block)
      && (succ_b != b)
      && ((((succ_b)->preds).size) == 1)
      && !(succ_b->flags & 0x00000020))
    {
        int i = (((b)->insns).size);
        int j = (((succ_b)->insns).size);

        if (j) {
            do { int _n = (j); if ((((b->insns).size) + _n) < ((b->insns).cap)) ((b->insns).size) += _n; else vector_insert((struct vector *) &(b->insns), ((b->insns).size), _n, sizeof(*((b->insns).elements))); } while(0);
            __builtin_memcpy(&(((b)->insns).elements[(i)]), &(((succ_b)->insns).elements[(0)]),
                            j * sizeof(*((b->insns).elements)));
        }

        dup_succs(b, succ_b);
        remove_succs(succ_b);

        do { if ((succ_b)->next) (succ_b)->next->prev = (succ_b)->prev; if ((succ_b)->prev) (succ_b)->prev->next = (succ_b)->next; else all_blocks = (succ_b)->next; } while (0);
        ++count;
    }

    return count;
}

int bypass_succ(struct block *b, int n)
{
    struct block *succ_b        = (((b)->succs).elements[(n)]).b;
    struct block *succ_succ_b   = unconditional_succ(succ_b);
    int m;







    if ((((succ_b)->insns).size)) return 0;
    if (((succ_b)->flags & 0x00000001)) return 0;
    if (succ_b == b) return 0;
    if (succ_b->flags & 0x00000020) return 0;
    if ((succ_succ_b = unconditional_succ(succ_b)) == succ_b)
        return 0;

    if (((b)->flags & 0x00000001)) {




        if (succ_succ_b == 0) return 0;
        (((b)->succs).elements[(n)]).b = succ_succ_b;
        add_pred(succ_succ_b, b);
        remove_pred(succ_b, b);
    } else {



        int cc;

        cc = (((b)->succs).elements[(n)]).cc;
        remove_succ(b, n);

        for (m = 0; m < (((succ_b)->succs).size); ++m) {
            succ_succ_b = (((succ_b)->succs).elements[(m)]).b;
            add_succ(b, intersect_cc(cc, (((succ_b)->succs).elements[(m)]).cc), succ_succ_b);
        }
    }

    return 1;
}





int conditional_block(struct block *b)
{
    if (!((b)->flags & 0x00000001) && (((b)->succs).size) && (((((b)->succs).elements[(0)]).cc) <= 11))
        return 1;
    else
        return 0;
}

struct block *predict_succ(struct block *b, int ccs, int fix)
{
    struct block *succ_b;
    int n;

    for (n = 0; n < (((b)->succs).size); ++n)
        if (((ccs) & (1 << ((((b)->succs).elements[(n)]).cc)))) {
            succ_b = (((b)->succs).elements[(n)]).b;
            break;
        }

    if (fix) {
        remove_succs(b);
        add_succ(b, 12, succ_b);
    }

    return succ_b;
}

struct block *unconditional_succ(struct block *b)
{
    if (!((b)->flags & 0x00000001) && (((b)->succs).size) && ((((b)->succs).elements[(0)]).cc == 12))
        return (((b)->succs).elements[(0)]).b;
    else
        return 0;
}

void switch_block(struct block *b, struct operand *o, struct block *default_b)
{
    b->flags |= 0x00000001;
    b->control = *o;
    add_succ(b, 14, default_b);
}






int unswitch_block(struct block *b)
{
    struct block *succ_b;
    int n;

    if ((((&b->control)->class == 2) && ((&b->control)->sym == 0))) {
        predict_switch_succ(b, b->control.con, 1);
    } else {
        succ_b = (((b)->succs).elements[(0)]).b;

        for (n = 1; n < (((b)->succs).size); ++n)
            if ((((b)->succs).elements[(n)]).b != succ_b)
                return 0;

        remove_succs(b);
        add_succ(b, 12, succ_b);
    }

    return 1;
}






void add_switch_succ(struct block *b, union con *conp, struct block *succ_b)
{
    int n;







    normalize_con((((b->control.t) > (0x0000000000000040L)) ? (b->control.t) : (0x0000000000000040L)), conp);

    for (n = 1; n < (((b)->succs).size); ++n)
        if ((((b)->succs).elements[(n)]).label.u == conp->u)
            error(4, 0, "duplicate case label");

    do { int _n = (1); if ((((b->succs).size) + _n) < ((b->succs).cap)) ((b->succs).size) += _n; else vector_insert((struct vector *) &(b->succs), ((b->succs).size), _n, sizeof(*((b->succs).elements))); } while(0);
    ((b->succs).elements[(b->succs).size - 1]).cc = 15;
    ((b->succs).elements[(b->succs).size - 1]).label.u = conp->u;
    ((b->succs).elements[(b->succs).size - 1]).b = succ_b;

    add_pred(succ_b, b);
}





void trim_switch_block(struct block *b)
{
    int n = 1;

    while (n < (((b)->succs).size)) {
        if (!con_in_range(b->control.t, &(((b)->succs).elements[(n)]).label)) {
            remove_pred((((b)->succs).elements[(n)]).b, b);
            vector_delete((struct vector *) &(b->succs), (n), (1), sizeof(*((b->succs).elements)));
        } else
            ++n;
    }
}




struct block *predict_switch_succ(struct block *b, union con con, int fix)
{
    struct block *succ_b;
    int n;

    normalize_con((((b->control.t) > (0x0000000000000040L)) ? (b->control.t) : (0x0000000000000040L)), &con);
    succ_b = (((b)->succs).elements[(0)]).b;

    for (n = 1; n < (((b)->succs).size); ++n) {
        if ((((b)->succs).elements[(n)]).label.u == con.u) {
            succ_b = (((b)->succs).elements[(n)]).b;
            break;
        }
    }

    if (fix) {
        remove_succs(b);
        add_succ(b, 12, succ_b);
    }

    return succ_b;
}

void reset_blocks(void)
{
    all_blocks = 0;

    entry_block = new_block();
    current_block = new_block();
    add_succ(entry_block, 12, current_block);




    exit_block = new_block();
}











void undecorate_blocks(void)
{
    struct block *b;
    struct insn *insn;
    int i, n;

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {

            if (insn->op == ( 1 | 0x00800000 )) {
                struct asm_insn *asm_insn = (struct asm_insn *) insn;

                undecorate_regmap(&asm_insn->uses);
                undecorate_regmap(&asm_insn->defs);
            } else
                for (n = 0; n < ((((insn->op) & 0x30000000) >> 28) + insn->nr_args); ++n)
                    do { (((&insn->operand[n])->reg) = (((&insn->operand[n])->reg) & ~0x00003FFF) | ((0) << 0)); (((&insn->operand[n])->index) = (((&insn->operand[n])->index) & ~0x00003FFF) | ((0) << 0)); } while (0);
        }

        do { (((&b->control)->reg) = (((&b->control)->reg) & ~0x00003FFF) | ((0) << 0)); (((&b->control)->index) = (((&b->control)->index) & ~0x00003FFF) | ((0) << 0)); } while (0);
    }
}

void substitute_reg(int src, int dst)
{
    struct block *b;
    struct insn *insn;
    int i;

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i))
            insn_substitute_reg(insn, src, dst, 0x00000002
                                              | 0x00000001, 0);

        if (((b)->flags & 0x00000001)
          && ((&b->control)->class == 1)
          && (b->control.reg == src))
            b->control.reg = dst;
    }
}

void all_regs(struct reg_vector *regs)
{
    struct block *b;
    struct insn *insn;
    int i;

    do { int _n = (0); if (_n <= (((*regs)).cap)) (((*regs)).size) = _n; else vector_insert((struct vector *) &((*regs)), (((*regs)).size), _n - (((*regs)).size), sizeof(*(((*regs)).elements))); } while (0);

    for ((b) = all_blocks; (b); (b) = (b)->next) {
        for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
            insn_defs(insn, regs, 0);
            insn_uses(insn, regs, 0);
        }

        if (((b)->flags & 0x00000001) && ((&b->control)->class == 1))
            add_reg(regs, b->control.reg);
    }
}

void iterate_blocks(int (*f)(struct block *))
{
    struct block *b;
    int again;

    do {
        again = 0;

        for (b = all_blocks; b; b = b->next)
            if (f(b) == 1)
                again = 1;

    } while (again);
}

static void walk0(int backward, struct block *b, void (*pre)(struct block *),
                                                 void (*post)(struct block *))
{
    int i;

    if (!(b->flags & 0x00000002)) {
        b->flags |= 0x00000002;

        if (pre) pre(b);

        if (backward == 0)
            for (i = 0; i < (((b)->succs).size); ++i)
                walk0(0, (((b)->succs).elements[(i)]).b, pre, post);
        else
            for (i = 0; i < (((b)->preds).size); ++i)
                walk0(1, (((b)->preds).elements[(i)]), pre, post);

        if (post) post(b);
    }
}

void walk_blocks(int backward, void (*pre)(struct block *),
                               void (*post)(struct block *))
{
    struct block *b;

    for (b = all_blocks; b; b = b->next) b->flags &= ~0x00000002;
    walk0(backward, backward ? exit_block : entry_block, pre, post);
}




static void sequence0(struct block *b) { do { if ((b)->next) (b)->next->prev = (b)->prev; if ((b)->prev) (b)->prev->next = (b)->next; else all_blocks = (b)->next; } while (0); do { (b)->prev = 0; if (all_blocks) all_blocks->prev = (b); (b)->next = all_blocks; all_blocks = (b); } while (0); }
void sequence_blocks(int backward) { walk_blocks(backward, 0, sequence0); }

void out_block(struct block *b)
{
    int i;
    int ccs;

    out("%L:", b->asmlab);










    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('\n'))) : __flushbuf((('\n')),(out_f)));

    for (i = 0; i < (((b)->insns).size); ++i)
        out_insn((((b)->insns).elements[(i)]));
}

int append_insn(struct insn *insn, struct block *b)
{
    int i;

    do { int _n = (1); if ((((b->insns).size) + _n) < ((b->insns).cap)) ((b->insns).size) += _n; else vector_insert((struct vector *) &(b->insns), ((b->insns).size), _n, sizeof(*((b->insns).elements))); } while(0);
    i = (((b)->insns).size) - 1;
    (((b)->insns).elements[(i)]) = insn;

    return i;
}

void insert_insn(struct insn *insn, struct block *b, int i)
{
    vector_insert((struct vector *) &((b)->insns), (i), (1), sizeof(*(((b)->insns).elements)));
    (((b)->insns).elements[(i)]) = insn;
}

void delete_insn(struct block *b, int i)
{
    vector_delete((struct vector *) &((b)->insns), (i), (1), sizeof(*(((b)->insns).elements)));
}






void add_block(struct block_vector *set, struct block *b)
    { int i; for (i = 0; i < ((*set).size); ++i) { if (((*set).elements[i]) == b) return; if (((b) < (((*set).elements[i])))) break; } vector_insert((struct vector *) &(*set), (i), (1), sizeof(*((*set).elements))); ((*set).elements[i]) = b; }

int contains_block(struct block_vector *set, struct block *b)
    { int i; for (i = 0; i < ((*set).size); ++i) { if (((*set).elements[i]) == b) return 1; if (((b) < (((*set).elements[i])))) break; } return 0; }

int same_blocks(struct block_vector *set1, struct block_vector *set2)
    { int i; if (((*set1).size) != ((*set2).size)) return 0; for (i = 0; i < ((*set1).size); ++i) if (((*set1).elements[i]) != ((*set2).elements[i])) return 0; return 1; }

void union_blocks(struct block_vector *dst, struct block_vector *src1,
                                      struct block_vector *src2)
    { int i1 = 0; int i2 = 0; int size1 = ((*src1).size); int size2 = ((*src2).size); struct block * elem; do { int _n = (0); if (_n <= (((*dst)).cap)) (((*dst)).size) = _n; else vector_insert((struct vector *) &((*dst)), (((*dst)).size), _n - (((*dst)).size), sizeof(*(((*dst)).elements))); } while (0); while ((i1 < size1) || (i2 < size2)) { if (i1 == ((*src1).size)) elem = ((*src2).elements[i2++]); else if (i2 == ((*src2).size)) elem = ((*src1).elements[i1++]); else if (((((*src1).elements[i1])) < (((*src2).elements[i2])))) elem = ((*src1).elements[i1++]); else if (((((*src2).elements[i2])) < (((*src1).elements[i1])))) elem = ((*src2).elements[i2++]); else { elem = ((*src2).elements[i2++]); ++i1; } do { int _n = (1); if ((((*dst).size) + _n) < ((*dst).cap)) ((*dst).size) += _n; else vector_insert((struct vector *) &(*dst), ((*dst).size), _n, sizeof(*((*dst).elements))); } while(0); ((*dst).elements[(*dst).size - 1]) = elem; } }

void intersect_blocks(struct block_vector *dst, struct block_vector *src1,
                                          struct block_vector *src2)
    { int i1 = 0; int i2 = 0; int size1 = ((*src1).size); int size2 = ((*src2).size); do { int _n = (0); if (_n <= (((*dst)).cap)) (((*dst)).size) = _n; else vector_insert((struct vector *) &((*dst)), (((*dst)).size), _n - (((*dst)).size), sizeof(*(((*dst)).elements))); } while (0); while ((i1 < size1) && (i2 < size2)) { if (((((*src1).elements[i1])) < (((*src2).elements[i2])))) ++i1; else if (((((*src2).elements[i2])) < (((*src1).elements[i1])))) ++i2; else { do { int _n = (1); if ((((*dst).size) + _n) < ((*dst).cap)) ((*dst).size) += _n; else vector_insert((struct vector *) &(*dst), ((*dst).size), _n, sizeof(*((*dst).elements))); } while(0); ((*dst).elements[(*dst).size - 1]) = ((*src1).elements[i1]); ++i1; ++i2; } } }
