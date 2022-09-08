# 1 "insn.c"

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
# 18 "insn.c"
struct insn nop_insn = { ( 0 ) };



const char * const cc_text[] =
{
    "jz",   "jnz",  "js",   "jns",  "jg",   "jle",
    "jge",  "jl",   "ja",   "jbe",  "jae",  "jb",
    "jmp"
};




const char commuted_cc[] =
{
    0,   1,  0,      0,      7,   6,
    5,  4,   11,   10,  9,  8
};
















static const struct { char cc[2]; char or; char and; } ccops[] =
{
    {   4,   0,               6,          13    },
    {   4,   6,              6,          4        },
    {   4,   7,               1,          13    },
    {   4,   1,              1,          4        },
    {   4,   5,              12,      13    },
    {   0,   6,              6,          0        },
    {   0,   7,               5,          13    },
    {   0,   1,              12,      13    },
    {   0,   5,              5,          0        },
    {   6,  7,               12,      13    },
    {   6,  1,              12,      4        },
    {   6,  5,              12,      0        },
    {   7,   1,              1,          7        },
    {   7,   5,              5,          7        },
    {   1,  5,              12,      7        },

    {   8,   0,               10,          13    },
    {   8,   10,              10,          8        },
    {   8,   11,               1,          13    },
    {   8,   1,              1,          8        },
    {   8,   9,              12,      13    },
    {   0,   10,              10,          0        },
    {   0,   11,               9,          13    },
    {   0,   1,              12,      13    },
    {   0,   9,              9,          0        },
    {   10,  11,               12,      13    },
    {   10,  1,              12,      8        },
    {   10,  9,              12,      0        },
    {   11,   1,              1,          11        },
    {   11,   9,              9,          11        },
    {   1,  9,              12,      11        }
};

















int union_cc(int cc1, int cc2)
{
    if (cc1 == ((cc2) ^ 1)) return 12;
    if (cc1 == cc2) return cc1;
    if (cc1 == 13) return cc2;
    if (cc2 == 13) return cc1;

    if ((cc1 == 12) || (cc2 == 12))
        return 12;

    return ({ int _i; int _cc; for (_i = 0; _i < (sizeof(ccops) / sizeof(*(ccops))); ++_i) if (((cc1 == ccops[_i].cc[0]) && (cc2 == ccops[_i].cc[1])) || ((cc2 == ccops[_i].cc[0]) && (cc1 == ccops[_i].cc[1]))) { _cc = ccops[_i].or; break; } (_cc); });
}

int intersect_cc(int cc1, int cc2)
{
    if (cc1 == ((cc2) ^ 1)) return 13;
    if (cc1 == cc2) return cc1;
    if (cc1 == 12) return cc2;
    if (cc2 == 12) return cc1;

    if ((cc1 == 13) || (cc2 == 13))
        return 13;

    return ({ int _i; int _cc; for (_i = 0; _i < (sizeof(ccops) / sizeof(*(ccops))); ++_i) if (((cc1 == ccops[_i].cc[0]) && (cc2 == ccops[_i].cc[1])) || ((cc2 == ccops[_i].cc[0]) && (cc1 == ccops[_i].cc[1]))) { _cc = ccops[_i].and; break; } (_cc); });
}




static const char * const insn_text[] =
{
                "NOP",                    0,                0,  "FRAME",
                "LOAD",         "STORE",                   0,   "ARG",
                "RETURN",       "MOVE",         "CAST",         "CMP",
                "NEG",          "COM",          "ADD",          "SUB",
                "MUL",          "DIV",          "MOD",          "SHR",
                "SHL",          "AND",          "OR",           "XOR",
                "SETZ",         "SETNZ",        "SETS",         "SETNS",
                "SETG",         "SETLE",        "SETGE",        "SETL",
                "SETA",         "SETBE",        "SETAE",        "SETB",
                "BSF",          "BSR",          "BLKCPY",       "BLKSET",
                0,              0,              0,              0,
                0,              0,              0,              0,
                0,              0,              0,              0,
                0,              0,              0,              0,
                0,              0,              0,              0,
                0,              0,              0,              0,

                "call",         "ret",          "ret",          "ret",
                "movb",         "movw",         "movl",         "movq",
                "movss",        "movsd",        "movzbw",       "movzbl",
                "movzbq",       "movsbw",       "movsbl",       "movsbq",
                "movzwl",       "movzwq",       "movswl",       "movswq",
                "movl",         "movslq",       "cvtsi2ssl",    "cvtsi2ssq",
                "cvtsi2sdl",    "cvtsi2sdq",    "cvttss2sil",   "cvttss2siq",
                "cvttsd2sil",   "cvttsd2siq",   "cmpb",         "cmpw",
                "cmpl",         "cmpq",         "ucomiss",      "ucomisd",
                "leal",         "leal",         "leal",         "leaq",
                "notb",         "notw",         "notl",         "notq",
                "negb",         "negw",         "negl",         "negq",
                "addb",         "addw",         "addl",         "addq",
                "addss",        "addsd",        "subb",         "subw",
                "subl",         "subq",         "subss",        "subsd",
                "imulb",        "imulw",        "imull",        "imulq",
                "imulw",        "imull",        "imulq",        "mulss",
                "mulsd",        "divss",        "divsd",        "idivb",
                "idivw",        "idivl",        "idivq",        "divb",
                "divw",         "divl",         "divq",         "shrb",
                "shrw",         "shrl",         "shrq",         "sarb",
                "sarw",         "sarl",         "sarq",         "shlb",
                "shlw",         "shll",         "shlq",         "andb",
                "andw",         "andl",         "andq",         "orb",
                "orw",          "orl",          "orq",          "xorb",
                "xorw",         "xorl",         "xorq",         "setz",
                "setnz",        "sets",         "setns",        "setg",
                "setle",        "setge",        "setl",         "seta",
                "setbe",        "setae",        "setb",         "bsfl",
                "bsfq",         "bsrl",         "bsrq",         "movsb",
                "stosb",        "rep",          "cbtw",         "cwtd",
                "cltd",         "cqto",         "cvtss2sd",     "cvtsd2ss",
                "pushq",        "popq"
};

struct insn *new_insn(int op, int nr_args)
{
    struct insn *insn;

    do { struct arena *_a = (&func_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);

    switch (op)
    {
    case ( 1 | 0x00800000 ):
        {
            struct asm_insn *asm_insn;

            asm_insn = ({ struct arena *_a = (&func_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct asm_insn)); (_p); });
            __builtin_memset(asm_insn, 0, sizeof(struct asm_insn));
            do { (asm_insn->uses).cap = 0; (asm_insn->uses).size = 0; (asm_insn->uses).elements = 0; (asm_insn->uses).arena = (&func_arena); } while (0);
            do { (asm_insn->defs).cap = 0; (asm_insn->defs).size = 0; (asm_insn->defs).elements = 0; (asm_insn->defs).arena = (&func_arena); } while (0);

            insn = (struct insn *) asm_insn;
            break;
        }

    case ( 2 | 0x00800000 | 0x02000000 | 0x01000000 ):
        {
            struct line_insn *line_insn;

            line_insn = ({ struct arena *_a = (&func_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct line_insn)); (_p); });
            __builtin_memset(line_insn, 0, sizeof(struct line_insn));
            line_insn->path = path;
            line_insn->line_no = line_no;

            insn = (struct insn *) line_insn;
            break;
        }

    default:
        {
            int i = (((op) & 0x30000000) >> 28) + nr_args;
            size_t size = sizeof(struct insn) + i * sizeof(struct operand);

            insn = ({ struct arena *_a = (&func_arena); void *_p = _a->top; _a->top = (char *) _p + (size); (_p); });
            __builtin_memset(insn, 0, size);
            insn->nr_args = nr_args;

            for (i = (((op) & 0x30000000) >> 28); i--; )
                insn->operand[i].t = (1L << ((((op) >> (8 + (i) * 5)) & 0x1F)));

            break;
        }
    }

    insn->op = op;
    return insn;
}





struct insn *dup_insn(struct insn *src)
{
    struct insn *insn;

    insn = new_insn(src->op, src->nr_args);
    *insn = *src;

    switch (insn->op)
    {
    case ( 1 | 0x00800000 ):
        {
            struct asm_insn *asm_insn = (struct asm_insn *) insn;
            struct asm_insn *src_asm_insn = (struct asm_insn *) src;

            asm_insn->text = src_asm_insn->text;
            do { int _dummy = &(asm_insn->uses) == &(src_asm_insn->uses); dup_vector((struct vector *) &(asm_insn->uses), (struct vector *) &(src_asm_insn->uses), sizeof(*((asm_insn->uses).elements))); } while (0);
            do { int _dummy = &(asm_insn->defs) == &(src_asm_insn->defs); dup_vector((struct vector *) &(asm_insn->defs), (struct vector *) &(src_asm_insn->defs), sizeof(*((asm_insn->defs).elements))); } while (0);

            break;
        }

    case ( 2 | 0x00800000 | 0x02000000 | 0x01000000 ):
        {




            struct line_insn *line_insn;
            struct line_insn *src_line_insn = (struct line_insn *) src;

            line_insn->path = src_line_insn->path;
            line_insn->line_no = src_line_insn->line_no;

            break;
        }

    default:
        __builtin_memcpy(insn->operand, src->operand,
                         ((((insn->op) & 0x30000000) >> 28) + insn->nr_args)
                            * sizeof(struct operand));
    }

    return insn;
}

void commute_insn(struct insn *insn)
{
    switch (insn->op)
    {
    case ( 14 | ((3) << 28) | 0x80000000 ):
    case ( 16 | ((3) << 28) | 0x80000000 ):
    case ( 21 | ((3) << 28) | 0x80000000 | 0x04000000 ):
    case ( 22 | ((3) << 28) | 0x80000000 | 0x04000000 ):
    case ( 23 | ((3) << 28) | 0x80000000 | 0x04000000 ):         
do { struct operand _tmp; _tmp = (insn->operand[1]); (insn->operand[1]) = (insn->operand[2]); (insn->operand[2]) = _tmp; } while (0);
    }
}















void normalize_operand(struct operand *o)
{
    if (o->t != 0x0000000000002000L) {
        o->size = 0;
        o->align = 0;
    }

    switch (o->class)
    {
    case 2:     o->reg = 0;
                    o->index = 0;
                    o->scale = 0;
                    break;

    case 1:     o->index = 0;
                    o->scale = 0;
                    o->con.i = 0;
                    o->sym = 0;
    }

    if ((o->index != 0)
      && (o->scale == 0)
      && (o->reg == 0))
    {
        o->reg = o->index;
        o->index = 0;
    }

    if (o->class != 3) {
        o->class = 4;

        if ((o->reg == 0)
          && (o->index == 0))
            o->class = 2;

        if ((o->reg != 0)
          && (o->index == 0)
          && (o->con.i == 0)
          && (o->sym == 0))
            o->class = 1;
    }
}






int same_operand(struct operand *o1, struct operand *o2)
{
    if (o1->class != o2->class) return 0;
    if (o1->class == 0) return 1;
    if (o1->t != o2->t) return 0;

    if (o1->t & 0x0000000000002000L) {
        if (o1->size != o2->size) return 0;
        if (o1->align != o2->align) return 0;
    }

    switch (o1->class)
    {
    case 1:     if (o1->reg != o2->reg) return 0;
                    break;

    case 3:
    case 4:      if (o1->reg != o2->reg) return 0;
                    if (o1->index != o2->index) return 0;
                    if (o1->scale != o2->scale) return 0;



    case 2:


                    if (o1->con.i != o2->con.i) return 0;
                    if (o1->sym != o2->sym) return 0;
                    break;
    }

    return 1;
}

int same_insn(struct insn *insn1, struct insn *insn2)
{
    int m, n;

    if (insn1->op != insn2->op) return 0;
    if (insn1->is_volatile != insn2->is_volatile) return 0;

    switch (insn1->op)
    {
    case ( 1 | 0x00800000 ):
        if (insn1->uses_mem != insn2->uses_mem) return 0;
        if (insn1->defs_mem != insn2->defs_mem) return 0;
        if (insn1->defs_cc != insn2->defs_cc) return 0;

        {
            struct asm_insn *asm_insn1 = (struct asm_insn *) insn1;
            struct asm_insn *asm_insn2 = (struct asm_insn *) insn2;

            if (asm_insn1->text != asm_insn2->text) return 0;
            if (!same_regmap(&asm_insn1->uses, &asm_insn2->uses)) return 0;
            if (!same_regmap(&asm_insn1->defs, &asm_insn2->defs)) return 0;
        }

        break;

    case ( 6 | ((2) << 28) | 0x80000000 | 0x02000000 | 0x01000000 | 0x04000000 ):
        if (insn1->nr_args != insn2->nr_args) return 0;
        if (insn1->is_variadic != insn2->is_variadic) return 0;
        break;

    case ( 64 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x02000000 | 0x01000000 | 0x04000000 ):
        if (insn1->nr_iargs != insn2->nr_iargs) return 0;
        if (insn1->nr_fargs != insn2->nr_fargs) return 0;
        break;
    }

    m = (((insn1->op) & 0x30000000) >> 28) + insn1->nr_args;

    for (n = 0; n < m; ++n)
        if (!same_operand(&insn1->operand[n], &insn2->operand[n]))
            return 0;

    return 1;
}







void out_operand(struct operand *o, int rel)
{
    switch (o->class)
    {
    case 1:     if (rel) (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('*'))) : __flushbuf((('*')),(out_f)));
                    out("%R", o->reg, o->t);
                    break;

    case 2:     if (!rel) (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('$'))) : __flushbuf((('$')),(out_f)));

                    if (o->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))
                        out("%f", o->con.f);
                    else
                        out("%G", o->sym, o->con.i);

                    break;

    case 4:
    case 3:     if (rel) (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('*'))) : __flushbuf((('*')),(out_f)));









                    if (o->t & ( 0x0000000000000040L | 0x0000000000000080L )) o->con.i = (int) o->con.i;

                    if (o->sym || o->con.i || !(o->reg || o->index))
                        out("%G", o->sym, o->con.i);

                    if (o->reg || o->index) {
                        (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('('))) : __flushbuf((('(')),(out_f)));
                        if (o->reg) out("%r", o->reg);
                        if (o->index) out(",%r", o->index);
                        if (o->scale) out(",%d", 1 << o->scale);
                        (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((')'))) : __flushbuf(((')')),(out_f)));
                    } else
                        fputs(("(%rip)"), out_f);

                    break;
    }
}

void out_ccs(int ccs)
{
    static const char *text[] = {   "Z",    "NZ",   "S",    "NS",
                                    "G",    "LE",   "GE",   "L",
                                    "A",    "BE",   "AE",   "B"     };

    int cc;

    fputs(("[ "), out_f);

    for (cc = 0; cc < (sizeof(text) / sizeof(*(text))); ++cc)
        if (((ccs) & (1 << (cc))))
            out("%s ", text[cc]);

    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((']'))) : __flushbuf(((']')),(out_f)));
}




void out_insn(struct insn *insn)
{
    int op = insn->op;
    int i;

    switch (op)
    {
    case ( 1 | 0x00800000 ):
        {
            struct asm_insn *asm_insn = (struct asm_insn *) insn;







            out("%S", asm_insn->text);






            out("\n");
            break;
        }

    case ( 2 | 0x00800000 | 0x02000000 | 0x01000000 ):
        {



            static struct string *last_path;

            struct line_insn *line_insn = (struct line_insn *) insn;

            out("\t.line %d", line_insn->line_no);

            if (line_insn->path != last_path) {
                out(",\"%S\"", line_insn->path);
                last_path = path;
            }

            break;
        }

    case ( 6 | ((2) << 28) | 0x80000000 | 0x02000000 | 0x01000000 | 0x04000000 ):
        fputs(("\tCALL "), out_f);
        out_operand(&insn->operand[1], 1);
        (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('('))) : __flushbuf((('(')),(out_f)));

        if (insn->nr_args)
            for (i = 0; i < insn->nr_args; ++i) {
                if (i) (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((','))) : __flushbuf(((',')),(out_f)));
                out_operand(&insn->operand[2 + i], 0);

                if (insn->operand[2 + i].t & 0x0000000000002000L) {
                    out(" <%d:%d>", insn->operand[2 + i].size,
                                    insn->operand[2 + i].align);
                }
            }

        (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((')'))) : __flushbuf(((')')),(out_f)));

        if (insn->operand[0].class != 0) {
            (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((','))) : __flushbuf(((',')),(out_f)));
            out_operand(&insn->operand[0], 0);
        }

        break;

    default:
        out("\t%s ", insn_text[((op) & 0x000000FF)]);

        for (i = (((op) & 0x30000000) >> 28); i--; ) {
            out_operand(&insn->operand[i], insn->op == ( 64 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x02000000 | 0x01000000 | 0x04000000 ));
            if (i) (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = ((','))) : __flushbuf(((',')),(out_f)));
        }

        break;
    }
# 623 "insn.c"
    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (('\n'))) : __flushbuf((('\n')),(out_f)));
}




int insn_defs_cc0(struct insn *insn)
{
    switch (insn->op)
    {
    case ( 1 | 0x00800000 ):         return insn->defs_cc;

    case ( 12 | ((2) << 28) | 0x80000000 ):
    case ( 14 | ((3) << 28) | 0x80000000 ):
    case ( 15 | ((3) << 28) | 0x80000000 ):
    case ( 16 | ((3) << 28) | 0x80000000 ):
    case ( 17 | ((3) << 28) | 0x80000000 ):     if (insn->operand[0].t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ))
                            return 1;
                        else
                            return 0;
    }

    return 0;
}





int insn_uses_mem0(struct insn *insn)
{
    int i;

    switch (insn->op)
    {
    case ( 1 | 0x00800000 ):     return insn->uses_mem;
    }

    i = 0;

    if (insn->op & 0x80000000)
        i = !((insn->op) & 0x40000000);

    for (; i < (((insn->op) & 0x30000000) >> 28); ++i)
        if (insn->operand[i].class == 3)
            return 1;

    return 0;
}

int insn_defs_mem0(struct insn *insn)
{
    switch (insn->op)
    {
    case ( 1 | 0x00800000 ):     return insn->defs_mem;
    }

    if ((insn->op & 0x80000000) && (insn->operand[0].class == 3))
        return 1;

    return 0;
}

void insn_uses(struct insn *insn, struct reg_vector *set, int flags)
{
    int i, n;

    if ((flags & 0x08000000) && ((insn)->op & 0x08000000))
        add_reg(set, ( (32 << 14) | 0x40000000 ));

    if ((flags & 0x02000000) && (((insn)->op & 0x02000000) || insn_uses_mem0(insn)))
        add_reg(set, ( (33 << 14) | 0x40000000 ));

    switch (insn->op)
    {
    case ( 1 | 0x00800000 ):         regmap_regs(&((struct asm_insn *) insn)->uses, set);
                        return;

    case ( 2 | 0x00800000 | 0x02000000 | 0x01000000 ):        return;

    case ( 8 | 0x00800000 | 0x02000000 ):  if (!((func_ret_type)->t & 0x0000000000000001L))
                            add_reg(set, symbol_to_reg(func_ret_sym));

                        return;

    case ( 64 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x02000000 | 0x01000000 | 0x04000000 ):    for (i = 0; i < insn->nr_iargs; ++i)
                            add_reg(set, iargs[i]);

                        for (i = 0; i < insn->nr_fargs; ++i)
                            add_reg(set, fargs[i]);

                        break;

    case ( 67 | 0x02000000 | 0x00800000 ):    add_reg(set, (((16) < 16) ? (((16) << 14) | 0x80000000) : (((16) << 14) | 0xC0000000))); return;
    case ( 66 | 0x02000000 | 0x00800000 ):    add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000)));  return;

    case ( 139 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 124 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 135 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ):   add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); break;

    case ( 140 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 141 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 142 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ):

    case ( 136 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 137 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 138 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ):   add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000)));
                        add_reg(set, (((2) < 16) ? (((2) << 14) | 0x80000000) : (((2) << 14) | 0xC0000000))); break;

    case ( 183 | 0x02000000 | 0x01000000 ):   add_reg(set, (((3) < 16) ? (((3) << 14) | 0x80000000) : (((3) << 14) | 0xC0000000)));
                        add_reg(set, (((4) < 16) ? (((4) << 14) | 0x80000000) : (((4) << 14) | 0xC0000000)));
                        add_reg(set, (((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000))); return;

    case ( 184 | 0x01000000 ):   add_reg(set, (((4) < 16) ? (((4) << 14) | 0x80000000) : (((4) << 14) | 0xC0000000)));
                        add_reg(set, (((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000)));
                        add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); return;

    case ( 186 ):
    case ( 187 ):
    case ( 188 ):
    case ( 189 ):    add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); return;
    }

    n = (((insn->op) & 0x30000000) >> 28) + insn->nr_args;

    for (i = 0; i < n; ++i)
        if ((((i) != 0) || !((insn)->op & 0x80000000) || ((insn)->op & 0x40000000) || ((insn)->operand[i].class != 1))) {
            struct operand *o = &insn->operand[i];

            switch (o->class)
            {
            case 3:
            case 4:      if (o->index) add_reg(set, o->index);
            case 1:     if (o->reg) add_reg(set, o->reg);
            }
        }
}

void insn_defs(struct insn *insn, struct reg_vector *set, int flags)
{
    int i;

    if ((flags & 0x04000000) && (((insn)->op & 0x04000000) || insn_defs_cc0(insn)))
        add_reg(set, ( (32 << 14) | 0x40000000 ));

    if ((flags & 0x01000000) && (((insn)->op & 0x01000000) || insn_defs_mem0(insn)))
        add_reg(set, ( (33 << 14) | 0x40000000 ));

    switch (insn->op)
    {
    case ( 1 | 0x00800000 ):         regmap_regs(&((struct asm_insn *) insn)->defs, set);
                        break;

    case ( 2 | 0x00800000 | 0x02000000 | 0x01000000 ):        break;

    case ( 64 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x02000000 | 0x01000000 | 0x04000000 ):    for (i = 0; i < 9; ++i)
                            add_reg(set, iscratch[i]);

                        for (i = 0; i < 8; ++i)
                            add_reg(set, fscratch[i]);

                        break;

    case ( 139 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 124 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 135 | ((1) << 28) | ((1) << (8 + (0) * 5)) | 0x04000000 ):   add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); break;

    case ( 140 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 141 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 142 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ):

    case ( 136 | ((1) << 28) | ((4) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 137 | ((1) << 28) | ((6) << (8 + (0) * 5)) | 0x04000000 ):
    case ( 138 | ((1) << 28) | ((8) << (8 + (0) * 5)) | 0x04000000 ):   add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000)));
                        add_reg(set, (((2) < 16) ? (((2) << 14) | 0x80000000) : (((2) << 14) | 0xC0000000))); break;

    case ( 183 | 0x02000000 | 0x01000000 ):   add_reg(set, (((3) < 16) ? (((3) << 14) | 0x80000000) : (((3) << 14) | 0xC0000000)));
    case ( 184 | 0x01000000 ):   add_reg(set, (((4) < 16) ? (((4) << 14) | 0x80000000) : (((4) << 14) | 0xC0000000)));
                        add_reg(set, (((1) < 16) ? (((1) << 14) | 0x80000000) : (((1) << 14) | 0xC0000000))); return;

    case ( 187 ):
    case ( 188 ):
    case ( 189 ):    add_reg(set, (((2) < 16) ? (((2) << 14) | 0x80000000) : (((2) << 14) | 0xC0000000)));
    case ( 186 ):    add_reg(set, (((0) < 16) ? (((0) << 14) | 0x80000000) : (((0) << 14) | 0xC0000000))); return;

    default:        if ((((0) == 0) && ((insn)->op & 0x80000000) && ((insn)->operand[0].class == 1)))
                        add_reg(set, insn->operand[0].reg);
    }
}

int insn_substitute_con(struct insn *insn, int reg,
                        union con con, struct symbol *sym)
{
    int count = 0;
    int i, n;

    n = (((insn->op) & 0x30000000) >> 28) + insn->nr_args;

    for (i = 0; i < n; ++i)
        if ((((i) != 0) || !((insn)->op & 0x80000000) || ((insn)->op & 0x40000000) || ((insn)->operand[i].class != 1))
          && ((&insn->operand[i])->class == 1)
          && (insn->operand[i].reg == reg))
        {
            normalize_con(insn->operand[i].t, &con);
            do { (&insn->operand[i])->class = 2; (&insn->operand[i])->con = (con); (&insn->operand[i])->sym = (sym); do { struct tnode *_type = ((0)); if (_type) ((&insn->operand[i]))->t = ((((_type)->t) & 0x000000000001FFFFL)); } while (0); do { if ((0)) ((&insn->operand[i]))->t = ((0)); } while (0); } while (0);
            ++count;
        }

    return count;
}
# 869 "insn.c"
int insn_substitute_reg(struct insn *insn, int src,
                        int dst, int flags, long *tp)
{
    int count = 0;
    long t = 0;

    if (insn->op == ( 1 | 0x00800000 )) {
        struct asm_insn *asm_insn = (struct asm_insn *) insn;

        if (flags & 0x00000002)
            count += regmap_substitute(&asm_insn->uses, src, dst);

        if (flags & 0x00000001)
            count += regmap_substitute(&asm_insn->defs, src, dst);
    } else {
        int i, n;

        n = (((insn->op) & 0x30000000) >> 28) + insn->nr_args;

        for (i = 0; i < n; ++i) {
            do { int _count = 0; if ((flags & 0x00000002) && (((i) != 0) || !((insn)->op & 0x80000000) || ((insn)->op & 0x40000000) || ((insn)->operand[i].class != 1))) { struct operand *_o = &insn->operand[i]; switch (_o->class) { case 3: case 4: if (_o->index == src) { ++_count; _o->index = dst; } case 1: if (_o->reg == src) { ++_count; _o->reg = dst; } } if (_count) if (((_o)->class == 3)) t = 0x0000000000000100L; else t = (((t) > (_o->t)) ? (t) : (_o->t)); count += _count; } } while (0);
            do { int _count = 0; if ((flags & 0x00000001) && (((i) == 0) && ((insn)->op & 0x80000000) && ((insn)->operand[0].class == 1))) { struct operand *_o = &insn->operand[i]; switch (_o->class) { case 3: case 4: if (_o->index == src) { ++_count; _o->index = dst; } case 1: if (_o->reg == src) { ++_count; _o->reg = dst; } } if (_count) if (((_o)->class == 3)) t = 0x0000000000000100L; else t = (((t) > (_o->t)) ? (t) : (_o->t)); count += _count; } } while (0);
        }
    }

    if (tp) *tp = t;
    return count;
}

int insn_is_copy(struct insn *insn, int *dst, int *src)
{
    switch (insn->op)
    {
    case ( 9 | ((2) << 28) | 0x80000000 ):

    case ( 68 | ((2) << 28) | 0x80000000 | ((1) << (8 + (0) * 5)) | ((1) << (8 + (1) * 5)) ):
    case ( 69 | ((2) << 28) | 0x80000000 | ((4) << (8 + (0) * 5)) | ((4) << (8 + (1) * 5)) ):
    case ( 70 | ((2) << 28) | 0x80000000 | ((6) << (8 + (0) * 5)) | ((6) << (8 + (1) * 5)) ):
    case ( 71 | ((2) << 28) | 0x80000000 | ((8) << (8 + (0) * 5)) | ((8) << (8 + (1) * 5)) ):
    case ( 72 | ((2) << 28) | 0x80000000 | ((10) << (8 + (0) * 5)) | ((10) << (8 + (1) * 5)) ):
    case ( 73 | ((2) << 28) | 0x80000000 | ((11) << (8 + (0) * 5)) | ((11) << (8 + (1) * 5)) ):       if (((&insn->operand[0])->class == 1)
                              && ((&insn->operand[1])->class == 1))
                            {
                                *dst = insn->operand[0].reg;
                                *src = insn->operand[1].reg;
                                return 1;
                            }



    default:                return 0;
    }
}










int insn_is_cmpz(struct insn *insn, int *reg)
{
    switch (insn->op)
    {
    case ( 11 | ((2) << 28) | 0x04000000 ):     do { if (((((&insn->operand[0])->class == 2) && ((&insn->operand[0])->sym == 0)) && ((&insn->operand[0])->con.i == 0)) && ((&insn->operand[1])->class == 1)) { *reg = insn->operand[1].reg; return 1; } } while (0);
                        do { if (((((&insn->operand[1])->class == 2) && ((&insn->operand[1])->sym == 0)) && ((&insn->operand[1])->con.i == 0)) && ((&insn->operand[0])->class == 1)) { *reg = insn->operand[0].reg; return 1; } } while (0);


    default:            return 0;
    }
}










int insn_is_cmp_con(struct insn *insn, int *reg)
{
    switch (insn->op)
    {
    case ( 11 | ((2) << 28) | 0x04000000 ):     do { if ((((&insn->operand[0])->class == 2) && ((&insn->operand[0])->sym == 0)) && ((&insn->operand[1])->class == 1)) { *reg = insn->operand[1].reg; return 1; } } while (0);
                        do { if ((((&insn->operand[1])->class == 2) && ((&insn->operand[1])->sym == 0)) && ((&insn->operand[0])->class == 1)) { *reg = insn->operand[0].reg; return 1; } } while (0);


    default:            return 0;
    }
}
