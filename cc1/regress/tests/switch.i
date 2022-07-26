# 1 "switch.c"

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
# 19 "/home/charles/xcc/include/stdlib.h"
typedef __size_t size_t;









extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void __exit(int);
extern void exit(int);

extern void free(void *);
extern char *getenv(const char *);
extern void *malloc(size_t);
extern float strtof(const char *, char **);
extern double strtod(const char *, char **);
extern long strtol(const char *, char **, int);
extern unsigned long strtoul(const char *, char **, int);

extern void qsort(void *, size_t, size_t,
                  int (*compar)(const void *, const void *));



extern int rand(void);
extern void srand(unsigned);
# 18 "/home/charles/xcc/include/stdio.h"
typedef __off_t fpos_t;












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
# 13 "init.h"
struct symbol;



void out_word(long t, union con con, struct symbol *sym);



void init_bss(struct symbol *sym);









void init_static(struct symbol *sym, int s);




void init_auto(struct symbol *sym);



void tentative(struct symbol *sym);



struct symbol *floateral(long t, double f);
# 15 "switch.h"
void lir_switch(void);




void mch_switch(void);
# 92 "switch.c"
long case_type(struct block *b)
{
    long t;
    int n;




    t = 0x0000000000000004L;

next:
    for (n = 1; n < (((b)->succs).size); ++n)
        if (!con_in_range(t, &(((b)->succs).elements[(n)]).label)) {
            t <<= 1;
            goto next;
        }




    if ((((t) & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((b->control.t) & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && (((t) == (b->control.t)) || (((((t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0) == (((b->control.t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)) && (t_size(t) == t_size(b->control.t))))))
        return b->control.t;
    else
        return t;
}











static struct insn *cmp0(struct operand *control, unsigned long u)
{
    struct insn *new;
    struct operand label;
    long t = control->t;

    do { union con _con; _con.i = (u); do { ((&label))->class = 2; ((&label))->con = (_con); ((&label))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&label)))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&label)))->t = (((0))); } while (0); } while (0); } while (0);

    new = new_insn(( 11 | ((2) << 28) | 0x04000000 ), 0);
    do { *(&new->operand[0]) = *(control); (&new->operand[0])->t = t; if (((&new->operand[0])->class == 2)) normalize_con(t, &(&new->operand[0])->con); } while (0);
    do { *(&new->operand[1]) = *(&label); (&new->operand[1])->t = t; if (((&new->operand[1])->class == 2)) normalize_con(t, &(&new->operand[1])->con); } while (0);
    return new;
}




static struct block *range0(struct block *b,
                            struct block *in,
                            struct succ *min,
                            struct block *below,
                            struct succ *max,
                            struct block *above)
{
    struct block *first = new_block();
    struct block *second = new_block();
    long t = b->control.t;

    append_insn(cmp0(&b->control, min->label.u), first);
    add_succ(first, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 11 : 7, below);
    add_succ(first, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 10 : 6, second);

    append_insn(cmp0(&b->control, max->label.u), second);
    add_succ(second, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 9 : 5, in);
    add_succ(second, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 8 : 4, above);

    return first;
}







static void chain0(struct block *b, long case_t)
{
    struct block *first;
    struct block *this;
    struct block *next;
    struct succ *min = 0;
    struct succ *max = 0;
    struct block *def = (((b)->succs).elements[(0)]).b;
    struct insn *insn;
    long t = b->control.t;
    int n, tmp;

    first = this = new_block();
    next = new_block();

    if (case_t != t) {








        min = (&((((b))->succs).elements[(1)]));
        max = (&((((b))->succs).elements[((((b)->succs).size) - 1)]));

        append_insn(cmp0(&b->control, min->label.u), this);
        add_succ(this, 0, min->b);
        add_succ(this, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 11 : 7, def);
        add_succ(this, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 8 : 4, next);
        this = next; next = new_block();

        append_insn(cmp0(&b->control, max->label.u), this);
        add_succ(this, 0, max->b);
        add_succ(this, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 8 : 4, def);
        add_succ(this, (t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? 11 : 7, next);
        this = next; next = new_block();







        tmp = temp_reg(case_t);
        insn = new_insn(( 10 | ((2) << 28) | 0x80000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (tmp); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((case_t)) ((&insn->operand[0]))->t = ((case_t)); } while (0); } while (0);
        insn->operand[1] = b->control;
        append_insn(insn, this);

        b->control = insn->operand[0];
    }

    for (n = 1; n < (((b)->succs).size); ++n) {
        if (&(((b)->succs).elements[(n)]) == min) continue;
        if (&(((b)->succs).elements[(n)]) == max) continue;

        append_insn(cmp0(&b->control, (((b)->succs).elements[(n)]).label.u), this);
        add_succ(this, 0, (((b)->succs).elements[(n)]).b);
        add_succ(this, 1, next);
        this = next; next = new_block();
    }

    add_succ(this, 12, def);

    remove_succs(b);
    add_succ(b, 12, first);
}















static void split1(struct block *b, int m, int len)
{
    struct block *new;
    struct block *rem;
    struct block *entry;
    struct block *def;
    int i, n;

    def = (((b)->succs).elements[(0)]).b;

    new = new_block(); switch_block(new, &b->control, def);
    rem = new_block(); switch_block(rem, &b->control, def);

    new->flags |= 0x00000008;
    n = m + len - 1;

    entry = range0(b, new,
                   &(((b)->succs).elements[(m)]),
                   rem,
                   &(((b)->succs).elements[(n)]),
                   rem);

    for (i = m; i <= n; ++i)
        add_switch_succ(new, &(((b)->succs).elements[(i)]).label, (((b)->succs).elements[(i)]).b);

    for (i = 1; i < (((b)->succs).size); ++i)
        if ((i < m) || (i > n))
            add_switch_succ(rem, &(((b)->succs).elements[(i)]).label, (((b)->succs).elements[(i)]).b);




    remove_succs(b);
    add_succ(b, 12, entry);
}






static int split0(struct block *b)
{
    int m, n;
    int max_m = 0, max_len = 0;

    for (m = 1; m <= ((((b)->succs).size) - 1); ++m)
    {
        for (n = m; n <= ((((b)->succs).size) - 1); ++n)
            if (((1.0 + ((&(((b)->succs).elements[(n)])) - (&(((b)->succs).elements[(m)])))) / (1.0 + (&(((b)->succs).elements[(n)]))->label.i - (&(((b)->succs).elements[(m)]))->label.i)) < 0.5)
                break;





        if ((n - m) > max_len) {
            max_m = m;
            max_len = n - m;
        }
    }

    if (max_len < 5)
        return 0;
    else {
        split1(b, max_m, max_len);
        return 1;
    }
}




static void dense0(struct block *b)
{
    struct block *entry;
    struct block *new;
    struct block *def = (((b)->succs).elements[(0)]).b;




    new = new_block();
    dup_succs(new, b);
    new->flags |= 0x00000008;




    entry = range0(b, new, (&((((new))->succs).elements[(1)])), def, (&((((new))->succs).elements[((((new)->succs).size) - 1)])), def);



    remove_succs(b);
    add_succ(b, 12, entry);
}














static int compars0(const void *left, const void *right) { const struct succ *l = left; const struct succ *r = right; if (l->label.i == r->label.i) return 0; if (l->label.i > r->label.i) return 1; if (l->label.i < r->label.i) return -1; }
static int comparu0(const void *left, const void *right) { const struct succ *l = left; const struct succ *r = right; if (l->label.u == r->label.u) return 0; if (l->label.u > r->label.u) return 1; if (l->label.u < r->label.u) return -1; }

static void sort0(struct block *b)
{
    int (*compar)(const void *, const void *);

    compar = (b->control.t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L )) ? comparu0 : compars0;
    qsort(&(((b)->succs).elements[(1)]), ((((b)->succs).size) - 1), sizeof(struct succ), compar);
}





void lir_switch(void)
{
    struct block *b;
    int n;

restart:
    for ((b) = all_blocks; (b); (b) = (b)->next)
        if (((b)->flags & 0x00000001))
        {
            n = ((((b)->succs).size) - 1);






            if (n == 0) {
                unswitch_block(b);
                continue;
            }




            if (b->flags & (0x00000008 | 0x00000010)) continue;




            if (n <= 4) {
                chain0(b, b->control.t);
                continue;
            }




            sort0(b);





            if (((1.0 + (((&((((b))->succs).elements[((((b)->succs).size) - 1)]))) - ((&((((b))->succs).elements[(1)]))))) / (1.0 + ((&((((b))->succs).elements[((((b)->succs).size) - 1)])))->label.i - ((&((((b))->succs).elements[(1)])))->label.i)) >= 0.5) {
                dense0(b);
                continue;
            }




            if (split0(b)) goto restart;






            if (n <= 10) {
                long case_t = case_type(b);

                if (case_t < 0x0000000000000100L) {
                    chain0(b, case_t);
                    continue;
                }
            }




            b->flags |= 0x00000010;
        }
}





static void target0(struct block *b, int long_func)
{
    int asmlab = b->asmlab;

    if (long_func)
        out("\t.int %L\n", asmlab);
    else
        out("\t.short %L-%g\n", asmlab, current_func);




    b->flags |= 0x00000020;
}






static int control0(struct block *b)
{
    if (((&b->control)->class == 2)) {
        long t = b->control.t;
        struct operand dst;
        int creg;

        creg = temp_reg(t);
        do { (&dst)->class = 1; (&dst)->reg = (creg); do { struct tnode *_type = ((0)); if (_type) ((&dst))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&dst))->t = ((0)); } while (0); } while (0);
        append_insn(move(t, &dst, &b->control), b);

        return creg;
    } else
        return b->control.reg;
}













static void dense1(struct block *b, int long_func)
{
    static const int leax[] = { ( 100 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), ( 101 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ),
                                ( 102 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), ( 103 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ) };

    static const int zerox[] = { ( 75 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ), ( 80 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ), 0, 0 };

    struct symbol *ttab;
    int treg;
    int creg;
    long t = b->control.t;
    struct insn *insn;
    long i;
    int n;

    ttab = anon_static(&void_type, ++last_asmlab);
    treg = temp_reg(0x0000000000000100L);

    seg(1);
    out(".align %d\n", long_func ? 4 : 2);
    out("%g:\n", ttab);

    for (n = 1, i = (&((((b))->succs).elements[(1)]))->label.i; n < (((b)->succs).size); ++i)
        if (i != (((b)->succs).elements[(n)]).label.i)
            target0((((b)->succs).elements[(0)]).b, long_func);
        else {
            target0((((b)->succs).elements[(n)]).b, long_func);
            ++n;
        }

    creg = control0(b);




    i = (&((((b))->succs).elements[(1)]))->label.i;

    if ((t & ( 0x0000000000000100L | 0x0000000000000200L )) && (((i) < (-2147483647 - 1)) || ((i) > 2147483647))) {



        insn = new_insn(( 71 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { union con _con; _con.i = (-i); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
        append_insn(insn, b);

        insn = new_insn(( 115 | ((2) << 28) | 0x80000000 | 0x40000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (creg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        append_insn(insn, b);
    } else {





        insn = new_insn((leax)[((sizeof(int) * 8) - 1 - __builtin_clz(t_size(t)))], 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = (4); (&insn->operand[1])->reg = (creg); (&insn->operand[1])->index = 0; (&insn->operand[1])->scale = 0; (&insn->operand[1])->con.i = (-i); (&insn->operand[1])->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        append_insn(insn, b);

        if ((zerox)[((sizeof(int) * 8) - 1 - __builtin_clz(t_size(t)))]) {
            insn = new_insn((zerox)[((sizeof(int) * 8) - 1 - __builtin_clz(t_size(t)))], 0);
            do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
            do { (&insn->operand[1])->class = 1; (&insn->operand[1])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
            append_insn(insn, b);
        }
    }




    if (long_func) {
        insn = new_insn(( 70 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = (3); (&insn->operand[1])->reg = 0; (&insn->operand[1])->index = (treg); (&insn->operand[1])->scale = (2); (&insn->operand[1])->con.i = 0; (&insn->operand[1])->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        insn->operand[1].sym = ttab;
        append_insn(insn, b);
    } else {
        insn = new_insn(( 80 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = (3); (&insn->operand[1])->reg = 0; (&insn->operand[1])->index = (treg); (&insn->operand[1])->scale = (1); (&insn->operand[1])->con.i = 0; (&insn->operand[1])->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        insn->operand[1].sym = ttab;
        append_insn(insn, b);

        insn = new_insn(( 114 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 2; (&insn->operand[1])->con.i = 0; (&insn->operand[1])->sym = (current_func); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); } while (0);
        append_insn(insn, b);
    }

    do { (&b->control)->class = 1; (&b->control)->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&b->control))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000100L)) ((&b->control))->t = ((0x0000000000000100L)); } while (0); } while (0);
}











static void table0(struct block *b, int long_func)
{
    struct symbol *ctab;
    struct symbol *ttab;
    int treg;
    int creg;
    int ireg;
    long t = b->control.t;
    struct insn *insn;
    int n;

    static const int cmps[] = { ( 94 | ((2) << 28) | 0x04000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ), ( 95 | ((2) << 28) | 0x04000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ),
                                ( 96 | ((2) << 28) | 0x04000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), ( 97 | ((2) << 28) | 0x04000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ) };

    struct block *test = new_block();
    struct block *match = new_block();
    struct block *nomatch = new_block();

    seg(1);

    ctab = anon_static(&void_type, ++last_asmlab);
    out(".align %d\n", t_size(t));
    out("%g:\n", ctab);

    for (n = 1; n <= ((((b)->succs).size) - 1); ++n)
        out_word(t, (((b)->succs).elements[(n)]).label, 0);

    ttab = anon_static(&void_type, ++last_asmlab);
    out(".align %d\n", long_func ? 4 : 2);
    out("%g:\n", ttab);

    for (n = 1; n <= ((((b)->succs).size) - 1); ++n)
        target0((((b)->succs).elements[(n)]).b, long_func);

    creg = control0(b);
    treg = temp_reg(0x0000000000000100L);
    ireg = temp_reg(0x0000000000000040L);

    insn = new_insn(( 70 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (ireg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (0); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn(insn, b);

    insn = new_insn((cmps)[((sizeof(int) * 8) - 1 - __builtin_clz(t_size(t)))], 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (creg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { (&insn->operand[1])->class = (3); (&insn->operand[1])->reg = 0; (&insn->operand[1])->index = (ireg); (&insn->operand[1])->scale = (((sizeof(int) * 8) - 1 - __builtin_clz(t_size(t)))); (&insn->operand[1])->con.i = 0; (&insn->operand[1])->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
    insn->operand[1].sym = ctab;
    append_insn(insn, test);
    add_succ(test, 0, match);
    add_succ(test, 1, nomatch);

    insn = new_insn(( 114 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (ireg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (1); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn(insn, nomatch);

    insn = new_insn(( 96 | ((2) << 28) | 0x04000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), 0);
    do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (ireg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
    do { union con _con; _con.i = (((((b)->succs).size) - 1)); do { ((&insn->operand[1]))->class = 2; ((&insn->operand[1]))->con = (_con); ((&insn->operand[1]))->sym = (0); do { struct tnode *_type = (((0))); if (_type) (((&insn->operand[1])))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if (((0))) (((&insn->operand[1])))->t = (((0))); } while (0); } while (0); } while (0);
    append_insn(insn, nomatch);
    add_succ(nomatch, 11, test);
    add_succ(nomatch, 10, (((b)->succs).elements[(0)]).b);

    if (long_func) {
        insn = new_insn(( 70 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = (3); (&insn->operand[1])->reg = 0; (&insn->operand[1])->index = (ireg); (&insn->operand[1])->scale = (2); (&insn->operand[1])->con.i = 0; (&insn->operand[1])->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        insn->operand[1].sym = ttab;
        append_insn(insn, match);
    } else {
        insn = new_insn(( 80 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = (3); (&insn->operand[1])->reg = 0; (&insn->operand[1])->index = (ireg); (&insn->operand[1])->scale = (1); (&insn->operand[1])->con.i = 0; (&insn->operand[1])->sym = 0; do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[1]))->t = ((0)); } while (0); } while (0);
        insn->operand[1].sym = ttab;
        append_insn(insn, match);

        insn = new_insn(( 114 | ((2) << 28) | 0x80000000 | 0x40000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) | 0x04000000 ), 0);
        do { (&insn->operand[0])->class = 1; (&insn->operand[0])->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[0]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[0]))->t = ((0)); } while (0); } while (0);
        do { (&insn->operand[1])->class = 2; (&insn->operand[1])->con.i = 0; (&insn->operand[1])->sym = (current_func); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[1]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); } while (0);
        append_insn(insn, match);
    }








    dup_succs(match, b);
    do { (&match->control)->class = 1; (&match->control)->reg = (treg); do { struct tnode *_type = ((0)); if (_type) ((&match->control))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0x0000000000000100L)) ((&match->control))->t = ((0x0000000000000100L)); } while (0); } while (0);

    remove_succs(b);
    add_succ(b, 12, test);
}











void mch_switch(void)
{
    int long_func = func_size() > 2048;
    struct block *b;

    for ((b) = all_blocks; (b); (b) = (b)->next)
        if (((b)->flags & 0x00000001))
        {
            if (b->flags & 0x00000008)
                dense1(b, long_func);
            else if (b->flags & 0x00000010)
                table0(b, long_func);
        }
}
