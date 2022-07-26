# 1 "norm.c"

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
# 21 "opt.h"
extern int opt_request;
extern int opt_prohibit;
# 50 "opt.h"
void opt_prune(void);
void opt_dead(void);




void opt(int request, int prohibit);
# 15 "norm.h"
void opt_lir_norm(void);
# 23 "norm.c"
static struct insn *shl1(struct insn *insn, int dummy)
{
    insn->op = ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 );
    do { union con _con; _con.i = (1); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((&char_type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);
    return insn;
}




static struct insn *mod2(struct insn *insn, int dummy)
{
    insn->op = ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 );
    --(insn->operand[2].con.u);
    return insn;
}




struct insn *pow2(struct insn *insn, int op)
{
    insn->op = op;
    
do { union con _con; _con.i = (((sizeof(long) * 8) - 1 - __builtin_clzl(insn->operand[2].con.u))); do { ((&insn->operand[2]))->class = 2; ((&insn->operand[2]))->con = (_con); ((&insn->operand[2]))->sym = (0); do { struct tnode *_type = (((&char_type))); if (_type) (((&insn->operand[2])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[2])))->t = (((0))); } while (0); } while (0); } while (0);

    return insn;
}
















static struct insn *move0(struct insn *insn, int replace)
{
    struct insn *new;

    opt_request |= 0x00000008;

    new = new_insn(( 9 | ((2) << 28) | 0x80000000 ), 0);
    new->operand[0] = insn->operand[0];
    new->operand[1] = insn->operand[1];

    switch (replace)
    {
    case 0:      opt_request |= 0x00000004;
                        return new;

    case 1:     do { union con _con; _con.i = (0); do { ((&new->operand[1]))->class = 2; ((&new->operand[1]))->con = (_con); ((&new->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&new->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&new->operand[1])))->t = (((0))); } while (0); } while (0); } while (0); break;
    case 2:      do { union con _con; _con.i = (1); do { ((&new->operand[1]))->class = 2; ((&new->operand[1]))->con = (_con); ((&new->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&new->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&new->operand[1])))->t = (((0))); } while (0); } while (0); } while (0); break;
    }

    if (new->operand[0].t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))
        new->operand[1].con.f = new->operand[1].con.i;

    opt_request |= 0x00000040 | 0x00000010;
    return new;
}
# 113 "norm.c"
struct {
    long ts;
    int op;
    char left;
    char right;
    int arg;
    struct insn *(*f)(struct insn *, int);
} norms[] = {
    0x000000000001FFFFL,      ( 14 | ((3) << 28) | 0x80000000 ),  0,   1,  0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 14 | ((3) << 28) | 0x80000000 ),  0,   0,   0,          shl1,
    0x000000000001FFFFL,      ( 15 | ((3) << 28) | 0x80000000 ),  0,   1,  0,   move0,
    0x000000000001FFFFL,      ( 15 | ((3) << 28) | 0x80000000 ),  0,   0,   1,  move0,
    0x000000000001FFFFL,      ( 16 | ((3) << 28) | 0x80000000 ),  0,   1,  1,  move0,
    0x000000000001FFFFL,      ( 16 | ((3) << 28) | 0x80000000 ),  0,   2,   0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 16 | ((3) << 28) | 0x80000000 ),  0,   3,  ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ),  pow2,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   2,   1,  move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   0,   1,  move0,
    ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L ), ( 18 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   3,  0,          mod2,
    0x000000000001FFFFL,      ( 17 | ((3) << 28) | 0x80000000 ),  0,   2,   0,   move0,
    0x000000000001FFFFL,      ( 17 | ((3) << 28) | 0x80000000 ),  0,   0,   2,   move0,
    ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L ), ( 17 | ((3) << 28) | 0x80000000 ),  0,   3,  ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ),  pow2,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   1,  1,  move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   0,   0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   4,  0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ),   0,   1,  0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ),   0,   0,   0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   1,  0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   0,   1,  move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ),  1,  5,   1,  move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 20 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   1,  0,   move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ),  1,  5,   1,  move0,
    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ), ( 19 | ((3) << 28) | 0x80000000 | 0x04000000 ),  0,   1,  0,   move0
};

static struct bitvec_vector norm_0s;
static struct bitvec_vector norm_1s;








static struct reg_vector norm_regs;















static void norm(struct block *b)
{
    struct insn *insn;
    int src, dst;
    int i, j;

    __builtin_memset(((norm_0s)).elements, (0), (((norm_0s)).size) * sizeof(*(((norm_0s)).elements)));
    __builtin_memset(((norm_1s)).elements, (0), (((norm_1s)).size) * sizeof(*(((norm_1s)).elements)));

    for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
        if ((((((insn->op) & 0x30000000) >> 28) == 3) && (insn->op & 0x80000000) && !(insn->op & 0x40000000))) {
            for (j = 0; j < (sizeof(norms) / sizeof(*(norms))); ++j)
                if (norms[j].op == insn->op) break;

            if (((&insn->operand[2])->class == 1))
                commute_insn(insn);

            for (; (j < (sizeof(norms) / sizeof(*(norms)))) && (norms[j].op == insn->op); ++j)
            {
                if ((insn->operand[1].t & norms[j].ts) == 0) continue;

                if ((norms[j].left == 0) &&
                  !((&insn->operand[1])->class == 1))
                    continue;

                if ((norms[j].left == 1) &&
                  !((((&insn->operand[1])->class == 2) && ((&insn->operand[1])->sym == 0)) && ((&insn->operand[1])->con.i == 0))
                  && !(((&insn->operand[1])->class == 1)
                  && ({ struct bitvec_vector *_v = &(norm_0s); ((_v->elements[(((((insn->operand[1].reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((insn->operand[1].reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })))
                    continue;

                switch (norms[j].right)
                {
                case 0:
                    if (((&insn->operand[2])->class == 1)
                      && (insn->operand[1].reg == insn->operand[2].reg))
                        break; else continue;

                case 1:
                    if (((((&insn->operand[2])->class == 2) && ((&insn->operand[2])->sym == 0)) && ((&insn->operand[2])->con.i == 0))
                      || (((&insn->operand[2])->class == 1)
                      && ({ struct bitvec_vector *_v = &(norm_0s); ((_v->elements[(((((insn->operand[2].reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((insn->operand[2].reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })))
                        break; else continue;

                case 2:
                    if (((((&insn->operand[2])->class == 2) && ((&insn->operand[2])->sym == 0)) && ((((&insn->operand[2])->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) && ((&insn->operand[2])->con.f == 1)) || ((&insn->operand[2])->con.i == 1)))
                      || (((&insn->operand[2])->class == 1)
                      && ({ struct bitvec_vector *_v = &(norm_1s); ((_v->elements[(((((insn->operand[2].reg) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((insn->operand[2].reg) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })))
                        break; else continue;

                case 3:
                    if ((((&insn->operand[2])->class == 2) && ((&insn->operand[2])->sym == 0))
                      && (((insn->operand[2].con.u) > 0) && !((insn->operand[2].con.u) & ((insn->operand[2].con.u) - 1))))
                        break; else continue;

                case 4:
                    if ((((&insn->operand[2])->class == 2) && ((&insn->operand[2])->sym == 0))) {
                        union con con;
                        con.i = -1;
                        normalize_con(insn->operand[2].t, &con);
                        if (insn->operand[2].con.i == con.i) break;
                    }

                    continue;

                case 5:                          break;
                }

                insn = (norms[j].f)(insn, norms[j].arg);
                (((b)->insns).elements[(i)]) = insn;
                goto next_insn;
            }
        }

next_insn:
        if (insn_is_copy(insn, &dst, &src)) {
            if (({ struct bitvec_vector *_v = &(norm_0s); ((_v->elements[(((((src) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((src) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) do { struct bitvec_vector *_v = &(norm_0s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); else do { struct bitvec_vector *_v = &(norm_0s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
            if (({ struct bitvec_vector *_v = &(norm_1s); ((_v->elements[(((((src) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] & (1L << (((((src) & 0x3FFFC000) >> 14)) & (64 - 1)))) != 0); })) do { struct bitvec_vector *_v = &(norm_1s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); else do { struct bitvec_vector *_v = &(norm_1s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
        } else if (insn->op == ( 9 | ((2) << 28) | 0x80000000 )) {
            dst = insn->operand[0].reg;
            if (((((&insn->operand[1])->class == 2) && ((&insn->operand[1])->sym == 0)) && ((&insn->operand[1])->con.i == 0))) do { struct bitvec_vector *_v = &(norm_0s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); else do { struct bitvec_vector *_v = &(norm_0s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
            if (((((&insn->operand[1])->class == 2) && ((&insn->operand[1])->sym == 0)) && ((((&insn->operand[1])->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) && ((&insn->operand[1])->con.f == 1)) || ((&insn->operand[1])->con.i == 1)))) do { struct bitvec_vector *_v = &(norm_1s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] |= (1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); else do { struct bitvec_vector *_v = &(norm_1s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0);
        } else {
            do { int _n = (0); if (_n <= (((norm_regs)).cap)) (((norm_regs)).size) = _n; else vector_insert((struct vector *) &((norm_regs)), (((norm_regs)).size), _n - (((norm_regs)).size), sizeof(*(((norm_regs)).elements))); } while (0);
            insn_defs(insn, &norm_regs, 0);
            for ((j) = 0; ((j) < ((norm_regs).size)) && ((dst) = (((norm_regs)).elements[(j)])); ++(j)) { do { struct bitvec_vector *_v = &(norm_0s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); do { struct bitvec_vector *_v = &(norm_1s); _v->elements[(((((dst) & 0x3FFFC000) >> 14)) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))] &= ~(1L << (((((dst) & 0x3FFFC000) >> 14)) & (64 - 1))); } while (0); }
        }
    }
}

















static void cmp(struct block *b)
{
    struct insn *insn;
    int i, r, cc;

    for ((i) = 0; ((i) < (((b)->insns).size)) && ((insn) = ((((b))->insns).elements[((i))])); ++(i)) {
        if (insn->op != ( 11 | ((2) << 28) | 0x04000000 )) continue;
        r = range_by_def(b, ( (32 << 14) | 0x40000000 ), i);

        if (range_span(b, r) > (2147483647 - 1))
            continue;

        if (((&insn->operand[0])->class == 2) && ((&insn->operand[1])->class == 2))
            continue;

        if (((&insn->operand[0])->class == 1) && ((&insn->operand[1])->class == 1)
          && (((unsigned) (insn->operand[0].reg)) < ((unsigned) (insn->operand[1].reg))))
            continue;

        if (((&insn->operand[1])->class == 2))
            continue;

        do { struct operand _tmp; _tmp = (insn->operand[0]); (insn->operand[0]) = (insn->operand[1]); (insn->operand[1]) = _tmp; } while (0);

        for (;;) {
            ++r;

            if (((((b)->live.ranges).elements[(r)]).def != i) || ((((b)->live.ranges).elements[(r)]).reg != ( (32 << 14) | 0x40000000 )))
                break;

            if ((((b)->live.ranges).elements[(r)]).use == (2147483647 - 1))
                commute_succs(b);
            else {
                insn = (((b)->insns).elements[((((b)->live.ranges).elements[(r)]).use)]);
                cc = ((insn->op) - ( 24 | ((1) << 28) | 0x80000000 | 0x08000000 ));
                cc = commuted_cc[cc];
                insn->op = (( 24 | ((1) << 28) | 0x80000000 | 0x08000000 ) + (cc));
            }
        }
    }
}

void opt_lir_norm(void)
{
    struct block *b;

    live_analyze(0x00000002);

    do { (norm_regs).cap = 0; (norm_regs).size = 0; (norm_regs).elements = 0; (norm_regs).arena = (&local_arena); } while (0);
    do { struct bitvec_vector *_v = &(norm_0s); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(norm_1s); do { (*_v).cap = 0; (*_v).size = 0; (*_v).elements = 0; (*_v).arena = ((&local_arena)); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(norm_0s); do { int _n = ((((nr_assigned_regs) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);
    do { struct bitvec_vector *_v = &(norm_1s); do { int _n = ((((nr_assigned_regs) + 64 - 1) >> ((sizeof(int) * 8) - 1 - __builtin_clz(64)))); if (_n <= ((*_v).cap)) ((*_v).size) = _n; else vector_insert((struct vector *) &(*_v), ((*_v).size), _n - ((*_v).size), sizeof(*((*_v).elements))); } while (0); } while (0);

    for ((b) = all_blocks; (b); (b) = (b)->next) cmp(b);
    for ((b) = all_blocks; (b); (b) = (b)->next) norm(b);

    do { struct arena *_a = (&local_arena); _a->top = _a->bottom; } while (0);
}
