# 1 "symbol.c"

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
# 31 "symbol.c"
static struct symbol *symtab[(1 << 6) + 1];
# 61 "symbol.c"
int current_scope;
int outer_scope;






static long strun_scopes;





static struct symbol *chains[64];
static struct symbol **linkp[64];

static struct slab symbol_slab = { sizeof(struct symbol), (100) };

struct symbol *new_symbol(struct string *id, int s)
{
    static int last_num;
    struct symbol *sym;

    sym = ({ struct slab_obj *_obj; if (_obj = symbol_slab.free) symbol_slab.free = _obj->next; else _obj = refill_slab(&symbol_slab); --symbol_slab.avail; ((struct symbol *) (_obj)); });
    __builtin_memset(sym, 0, sizeof(*sym));

    sym->id = id;
    sym->s = s;
    sym->num = ++last_num;
    do { (sym)->path = path; (sym)->line_no = line_no; } while (0);

    return sym;
}





static struct symbol *zombies;
static int nr_zombies;

void free_symbols(struct symbol **chainp)
{
    struct symbol *sym;

    while (sym = *chainp) {
        *chainp = (*chainp)->link;

        if (sym->s & ( 0x00000001 | 0x00000002 | 0x00000004 )) {
            free_symbols(&sym->chain);
            sym->link = zombies;
            zombies = sym;
            ++nr_zombies;
        } else
            do { struct symbol *_p = (sym); ((struct slab_obj *) (sym))->next = symbol_slab.free; symbol_slab.free = ((struct slab_obj *) (sym)); ++symbol_slab.avail; } while (0);
    }
}




void insert(struct symbol *sym, int scope)
{
    struct symbol **symp;

    sym->scope = scope;

    for (symp = &symtab[((sym->id) ? ((sym->id)->hash % (1 << 6)) : (1 << 6))];
         *symp && ((*symp)->scope > scope);
         symp = &(*symp)->next) ;

    do { struct symbol **_symp = (symp); struct symbol *_sym = (sym); _sym->prev = _symp; _sym->next = *_symp; if (*_symp) (*_symp)->prev = &_sym->next; *_symp = _sym; } while (0);

    if (scope != 0) {
        *linkp[scope] = sym;
        linkp[scope] = &sym->link;
    }
}





void redirect(struct symbol *sym, int scope)
{
    struct symbol *old, *new;

    old = lookup(sym->id, 0x00000400, scope, scope);

    if (old == 0) {
        new = new_symbol(sym->id, 0x00000400);
        new->redirect = sym;
        insert(new, scope);
    }
}

struct symbol *lookup(struct string *id, int ss, int inner, int outer)
{
    struct symbol *sym, *next;
    long scopes;

    if (inner == outer)
        scopes = 0;
    else
        scopes = strun_scopes;

    for (sym = symtab[((id) ? ((id)->hash % (1 << 6)) : (1 << 6))]; sym; sym = next) {
        next = sym->next;

        if (sym->scope < outer) break;
        if (sym->scope > inner) continue;
        if ((((scopes) & (1L << (sym->scope))) != 0)) continue;
        if (sym->id != id) continue;

        if (sym->s & 0x00000400) sym = sym->redirect;
        if (sym->s & ss) return sym;
    }

    return 0;
}







struct symbol *lookup_member(struct string *id, struct symbol *tag)
{
    struct symbol *member;

    for (member = tag->members; member; member = member->next)
        if (member->id == id) {
            do { struct symbol *_sym = (member); if (_sym->next) _sym->next->prev = _sym->prev; *_sym->prev = _sym->next; } while (0);
            do { struct symbol **_symp = (&tag->members); struct symbol *_sym = (member); _sym->prev = _symp; _sym->next = *_symp; if (*_symp) (*_symp)->prev = &_sym->next; *_symp = _sym; } while (0);
            return member;
        }

    error(4, id, "no such member in %T", tag);
}

struct tnode *named_type(struct string *id)
{
    struct symbol *sym;

    sym = lookup(id, ( 0x00000008 | 0x00000010 | 0x00000020 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 | 0x00000400 ), outer_scope, 1);

    if (sym && (sym->s & 0x00000008))
        return sym->type;
    else
        return 0;
}










struct symbol *global(struct string *id, int s,
                      struct tnode *type, int scope)
{
    struct symbol *sym;
    int ss;

    sym = lookup(id, 0x00000020 | 0x00000010, 1, 0);

    if (sym) {
        if ((sym->s & 0x00000020) && (s & 0x00000010))
            error(4, id, "previously declared non-static");

        sym->type = compose(sym->type, type, sym);

        if (scope > sym->scope) {





            do { struct symbol *_sym = (sym); if (_sym->next) _sym->next->prev = _sym->prev; *_sym->prev = _sym->next; } while (0);
            insert(sym, 1);
        }
    } else {
        sym = new_symbol(id, s);
        sym->type = type;
        insert(sym, scope);
    }

    return sym;
}




void enter_scope(int strun)
{
    if (++current_scope == 64)
        error(1, 0, "scope nesting too deep");

    chains[current_scope] = 0;
    linkp[current_scope] = &chains[current_scope];

    if (strun)
        ((strun_scopes) |= (1L << (current_scope)));
    else {
        ((strun_scopes) &= ~(1L << (current_scope)));
        outer_scope = current_scope;
    }
}

void walk_scope(int scope, int ss, void f(struct symbol *))
{
    struct symbol *sym;

    for (sym = chains[scope]; sym; sym = sym->link)
        if (sym->s & ss) f(sym);
}

void exit_scope(struct symbol **chainp)
{
    struct symbol *sym;

    for (sym = chains[current_scope]; sym; sym = sym->link) do { struct symbol *_sym = (sym); if (_sym->next) _sym->next->prev = _sym->prev; *_sym->prev = _sym->next; } while (0);

    if (chainp) {
        *linkp[current_scope] = *chainp;
        *chainp = chains[current_scope];
    } else
        free_symbols(&chains[current_scope]);




    if (outer_scope == current_scope) {
        do --outer_scope;
        while ((((strun_scopes) & (1L << (outer_scope))) != 0));
    }

    --current_scope;
}

void reenter_scope(struct symbol **chainp)
{
    struct symbol *tmp;

    enter_scope(0);

    while (*chainp) {
        tmp = (*chainp)->link;
        insert(*chainp, outer_scope);
        *chainp = tmp;
    }
}

void unique(struct string *id, int ss, int scope, struct symbol *tag)
{
    struct symbol *sym;

    if (id && (sym = lookup(id, ss, scope, scope))) {
        switch (ss & (0x08000000 | 0x00000800))
        {
        case 0x08000000:
            error(4, id, "duplicate argument identifier");

        case 0x00000800:
            error(4, id, "already declared in %T %L", tag, sym);

        default:
            error(4, id, "already declared in this scope %L", sym);
        }
    }
}






static void absorb(struct symbol *dst, struct symbol *src, int offset)
{
    struct symbol *member;
    struct symbol *new;

    for (member = src->chain; member; member = member->link) {
        if (member->id) {
            unique(member->id, 0x00000800, current_scope, dst);
            new = new_symbol(member->id, 0x00000800 | 0x02000000);
            new->type = member->type;
            new->offset = member->offset + offset;
            insert(new, current_scope);
        }
    }
}






void insert_member(struct symbol *tag, struct string *id, struct tnode *type)
{
    int type_bits;
    int member_bits;
    int align_bytes;
    long offset_bits;
    int member_offset;
    struct symbol *member;

    unique(id, 0x00000800, current_scope, tag);
    align_bytes = align_of(type);
    tag->align = (((tag->align) > (align_bytes)) ? (tag->align) : (align_bytes));
    offset_bits = (tag->s & 0x00000002) ? 0 : tag->size;

    if (tag->s & 0x04000000)
        error(4, id, "no members allowed after flexible array");

    if (((((((type)->t) & 0x0000000000060000L)) & 0x0000000000020000L) || (((type)->t & 0x0000000000002000L) && (((type)->tag)->s & 0x00400000)))) tag->s |= 0x00400000;

    if ((((type)->t & 0x0000000000004000L) && ((type)->nelem == 0))) {
        type_bits = 0;
        tag->s |= 0x04000000;








        if (chains[current_scope] == 0)
            error(4, id, "flexible array is first named member");
    } else
        type_bits = size_of(type, 0) * 8;

    if (((type)->t & 0x0000008000000000L)) {
        member_bits = (((((type)->t) & 0x0000007F00000000L) >> 32));




        if ((member_bits == 0) || ((((offset_bits) / (type_bits)) * (type_bits))
          != (((offset_bits + member_bits - 1) / (type_bits)) * (type_bits))))
            offset_bits = ((((offset_bits) + ((type_bits) - 1)) / (type_bits)) * (type_bits));

        type = fieldify(type, member_bits, offset_bits % type_bits);
    } else {
        offset_bits = ((((offset_bits) + ((align_bytes * 8) - 1)) / (align_bytes * 8)) * (align_bytes * 8));
        member_bits = type_bits;
    }

    member_offset = (((offset_bits / 8) / (align_bytes)) * (align_bytes));

    if (tag->s & 0x00000002)
        tag->size = (((tag->size) > (member_bits)) ? (tag->size) : (member_bits));
    else {
        offset_bits += member_bits;
        tag->size = offset_bits;
    }

    if (offset_bits > ((1 << (28 - 1)) * 8))
        error(1, 0, "%T exceeds maximum struct/union size", tag);

    if (id == 0) {
        if ((((type)->t & 0x0000000000002000L) && ((type)->tag->id == 0)))
            absorb(tag, type->tag, member_offset);
        else
            return;
    }

    member = new_symbol(id, 0x00000800);
    member->id = id;
    member->type = type;
    member->offset = member_offset;
    insert(member, current_scope);
}














void exit_strun(struct symbol *tag)
{
    struct symbol *sym;
    long offset_bits;

    if (chains[current_scope] == 0)
        error(4, 0, "%T has no named members", tag);

    exit_scope(&tag->chain);

    for (sym = tag->chain; sym; sym = sym->link)
        do { struct symbol **_symp = (&tag->members); struct symbol *_sym = (sym); _sym->prev = _symp; _sym->next = *_symp; if (*_symp) (*_symp)->prev = &_sym->next; *_symp = _sym; } while (0);

    if (tag->size == 0)
        error(4, 0, "%T has zero size", tag);




    tag->size = ((((tag->size) + ((tag->align * 8) - 1)) / (tag->align * 8)) * (tag->align * 8));
    tag->size /= 8;
    tag->s |= 0x40000000;
}





struct symbol *lookup_label(struct string *id)
{
    struct symbol *label;

    label = lookup(id, 0x00001000, 2, 2);

    if (label == 0) {
        label = new_symbol(id, 0x00001000);
        label->b = new_block();
        insert(label, 2);
    }

    return label;
}

static void check0(struct symbol *label)
{
    if (!((label)->s & 0x40000000))
        error(4, label->id, "label never defined (%L)", label);
}

void check_labels(void)
{
    walk_scope(2, 0x00001000, check0);
}







static struct symbol *anons;

struct symbol *anon_static(struct tnode *type, int asmlab)
{
    struct symbol *sym;




    for (sym = anons; sym; sym = sym->link)
        if ((sym->asmlab == asmlab)
          && (sym->type == type))
            return sym;

    sym = new_symbol(0, 0x00000010);
    sym->type = type;
    sym->asmlab = asmlab;

    sym->link = anons;
    anons = sym;

    return sym;
}

void purge_anons(void) { free_symbols(&anons); }

struct symbol *implicit(struct string *id)
{
    struct tnode *type;
    struct symbol *sym;

    type = get_tnode(0x0000000000008000L | 0x0000000000080000L, 0, &int_type);
    sym = global(id, 0x00000020, type, 0);

    if (!(sym->s & 0x00800000)) {
        error(0, id, "implicit function declaration");
        sym->s |= 0x00800000;
    }

    return sym;
}

void registerize(struct symbol **chainp)
{
    struct symbol *sym;

    for (sym = *chainp; sym; sym = sym->link)
        if (sym->s & 0x00000100) {
            sym->s &= ~0x00000100;
            sym->s |= 0x00000080;
        }
}





int reg_generation;

int symbol_to_reg(struct symbol *sym)
{
    if (sym->generation < reg_generation) {
        sym->reg = assign_reg(sym);
        sym->generation = reg_generation;
    }

    return sym->reg;
}

int symbol_offset(struct symbol *sym)
{
    if (sym->offset == 0)
        sym->offset = frame_alloc(sym->type);

    return sym->offset;
}

void print_global(FILE *fp, struct symbol *sym)
{
    if ((sym->scope <= 1) && sym->id) {



        fprintf(fp, "_" "%.*s", (sym->id)->len, (sym->id)->text);
    } else {



        if (sym->asmlab == 0) sym->asmlab = ++last_asmlab;
        fprintf(fp, "L%d", sym->asmlab);
    }
}






void out_globls(void)
{
    struct symbol *sym;
    int b;

    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('\n'))) : __flushbuf((('\n')),(out_f)));

    for (b = 0; b < (1 << 6); ++b)
        for (sym = symtab[b]; sym; sym = sym->next)
            if ((sym->s & 0x00000020) && (sym->s & (0x20000000 | 0x40000000)))
                out(".globl %g\n", sym);
}
