# 1 "expr.c"

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
# 13 "decl.h"
struct tnode;




void externals(void);



void locals(void);



struct tnode *abstract(void);
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
# 13 "stmt.h"
struct tree;





extern struct tree *stmt_tree;




void compound(int body);
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
# 13 "builtin.h"
struct string;
struct tree;







void seed_builtin(struct string *id);




struct tree *rewrite_builtin(struct tree *tree);
# 17 "expr.h"
int constant_expr(void);



struct tree *case_expr(void);



struct tree *static_expr(void);



struct tree *assignment(void);





struct tree *test(struct tree *tree, int cmp, int k);



struct tree *expression(void);




struct tree *build_tree(int k, struct tree *left, struct tree *right);






struct tree *fake(struct tree *tree, struct tnode *type, int k);
# 24 "expr.c"
static struct tree *cast(void);
# 60 "expr.c"
static struct tree *promote(struct tree *tree, int old_arg)
{
    if (((tree->type)->t & 0x0000000000008000L))
        tree = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (tree->type)), tree);
    else if (((tree->type)->t & 0x0000000000004000L))
        tree = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (((tree->type)->next))), tree);
    else if (((tree->type)->t & ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L )) || ((tree->type)->t & ( 0x0000000000000010L | 0x0000000000000020L )))
        tree = unary_tree(( 6 | 0x40000000 ), &int_type, tree);
    else if (old_arg && ((tree->type)->t & 0x0000000000000400L))
        tree = unary_tree(( 6 | 0x40000000 ), &double_type, tree);
    else
        do { if (((((tree->type)->t) & 0x0000000000060000L)) && !((tree->type)->t & 0x0000000000002000L)) (tree->type) = unqualify(tree->type); } while (0);

    return tree;
}








static struct tree *scale(struct tree *tree)
{
    struct tree *left = tree->left;
    struct tree *right = tree->right;
    struct tree *icon;
    int size;

    if (((left->type)->t & 0x0000000000010000L)) {
        size = size_of(((left->type)->next), 0);
        icon = ({ union con _con; _con.i = (size); con_tree((&long_type), &_con); });

        if (!((right->type)->t & 0x0000000000010000L)) {

            right = unary_tree(( 6 | 0x40000000 ), &long_type, right);
            right = binary_tree(( 25 | 0x20000000 ), &long_type, right, icon);
            tree->right = right;
            tree->type = left->type;
        } else {

            tree->type = &long_type;
            tree = binary_tree(( 23 ), &long_type, tree, icon);
        }
    } else
        tree->type = left->type;

    return tree;
}





static struct tree *null0(struct tree *con, struct tree *ptr)
{
    if (((ptr->type)->t & 0x0000000000010000L) && ((con->type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ))) {



        con = fold(con);

        if (((((con)->op == ( 2 | 0x80000000 )) && ((con)->sym == 0)) && (((con)->type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )) && ((con)->con.i == 0)))
            con = unary_tree(( 6 | 0x40000000 ), ptr->type, con);
    }

    return con;
}
# 150 "expr.c"
static struct { int op, idx, len, flags; } map[] =
{
                { ( 11 ),        2,  3,  0x00000004         |
                                        0x00000100       |
                                        0x00000400     |
                                        0x00000010         },

                { ( 12 | 0x08000000 ),     2,  1,  0x00000040        },
                { ( 13 | 0x08000000 ),     2,  1,  0x00000040        },
                { ( 14 | 0x08000000 ),     0,  1,  0x00000040        },

                { ( 15 | 0x08000000 ),     1,  2,  0x00000040        |
                                        0x00001000      },

                { ( 16 | 0x08000000 ),     1,  2,  0x00000040        |
                                        0x00001000      },

                { ( 17 ),     0,  1,  0x00000800      },
                { ( 18 ),     0,  1,  0x00000800      },
                { ( 19 ),     0,  1,  0x00000010         },
                { ( 20 ),      0,  1,  0x00000010         },
                { ( 21 ),     0,  1,  0x00000010         },

                { ( 30 | 0x20000000 ),        0,  1,  0x00000001       |
                                        0x00000020      },

                { ( 23 ),        2,  1,  0x00000001       |
                                        0x00000020      },

                { ( 25 | 0x20000000 ),        2,  1,  0x00000001       |
                                        0x00000020      },

                { ( 26 | 0x20000000 ),        1,  2,  0x00000001       |
                                        0x00000020      |
                                        0x00001000      },

                { ( 27 ),        1,  3,  0x00000001       |
                                        0x00000020      |
                                        0x00001000      },

                { ( 35 ),         2,  2,  0x00000001       |
                                        0x00000020      |
                                        0x00002000        },

                { ( 28 ),        0,  1,  0x00000001       |
                                        0x00000800      },

                { ( 36 ),       2,  2,  0x00000001       |
                                        0x00000020      |
                                        0x00002000        },

                { ( 38 ),         2,  2,  0x00000001       |
                                        0x00000020      |
                                        0x00002000        },

                { ( 29 ),        0,  1,  0x00000001       |
                                        0x00000800      },

                { ( 37 ),       2,  2,  0x00000001       |
                                        0x00000020      |
                                        0x00002000        },

                { ( 31 | 0x20000000 ),        0,  1,  0x00000001       |
                                        0x00000020      },

                { ( 40 ),       0,  1,  0x00000001       |
                                        0x00000008           |
                                        0x00002000        },

                { ( 33 | 0x20000000 ),         2,  2,  0x00000001       |
                                        0x00000020      |
                                        0x00000002         |
                                        0x00000004         |
                                        0x00000080       |
                                        0x00000100       |
                                        0x00002000        },

                { ( 34 | 0x20000000 ),        2,  2,  0x00000001       |
                                        0x00000020      |
                                        0x00000002         |
                                        0x00000004         |
                                        0x00000080       |
                                        0x00000100       |
                                        0x00002000        },

                { ( 32 | 0x20000000 ),         0,  1,  0x00000001       |
                                        0x00000020      },

                { ( 39 ),        0,  1,  0x00000001       |
                                        0x00000008           |
                                        0x00002000        },

                { ( 24 ),        0,  1,  0x00000001       |
                                        0x00000020      },

                { ( 42 ),      2,  4,  0x00000001       |
                                        0x00000020      |
                                        0x00000200     |
                                        0x00000400     |
                                        0x00000002         |
                                        0x00000004         }
};




static struct { long left_ts; long right_ts; } operands[] =
{
                { ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ),               ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )                  },
                { 0x0000000000010000L,                    ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )                  },
                { ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ),                  ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) )                     },
                { 0x0000000000010000L,                    0x0000000000010000L                       },
                { 0x0000000000002000L,                  0x0000000000002000L                     },
                { 0x0000000000000001L,                   0x0000000000000001L                      }
};



















static void usuals(struct tree *tree, int flags)
{
    long t = 
(((((((tree->left->type)->t) & 0x000000000001FFFFL))) > (((((tree->right->type)->t) & 0x000000000001FFFFL)))) ? (((((tree->left->type)->t) & 0x000000000001FFFFL))) : (((((tree->right->type)->t) & 0x000000000001FFFFL))));

    if (flags & 0x00000020)
        do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL)) & t) == 0) tree->left = unary_tree(( 6 | 0x40000000 ), get_tnode(t, 0, 0), tree->left); } while (0);

    do { if (((((tree->left->type)->t) & 0x0000000000060000L)) && !((tree->left->type)->t & 0x0000000000002000L)) (tree->left->type) = unqualify(tree->left->type); } while (0);

    do { if ((((((tree->right->type)->t) & 0x000000000001FFFFL)) & t) == 0) tree->right = unary_tree(( 6 | 0x40000000 ), get_tnode(t, 0, 0), tree->right); } while (0);
    do { if (((((tree->right->type)->t) & 0x0000000000060000L)) && !((tree->right->type)->t & 0x0000000000002000L)) (tree->right->type) = unqualify(tree->right->type); } while (0);
}
# 322 "expr.c"
struct tree *build_tree(int k, struct tree *left, struct tree *right)
{
    int flags = map[(((k) & ( 0x1F000000 )) >> 24)].flags;
    struct tree *tree;

    right = promote(right, 0);
    if (flags & 0x00000001) left = promote(left, 0);
    if (flags & 0x00000002) left = null0(left, right);
    if (flags & 0x00000004) right = null0(right, left);
    tree = binary_tree(map[(((k) & ( 0x1F000000 )) >> 24)].op, 0, left, right);
    do { if ((tree->op == ( 26 | 0x20000000 )) && ((tree->right->type)->t & 0x0000000000010000L)) do { struct tree * _tmp; _tmp = ((tree)->left); ((tree)->left) = ((tree)->right); ((tree)->right) = _tmp; } while (0); } while (0);

    if (flags & 0x00000008)
    {
        tree->right = test(tree->right, ( 53 | ((25) << 24) | 0x00700000 ), k);
        tree->left = test(tree->left, ( 53 | ((25) << 24) | 0x00700000 ), k);
    } else {
        int len = map[(((k) & ( 0x1F000000 )) >> 24)].len;
        int idx = map[(((k) & ( 0x1F000000 )) >> 24)].idx;
        int i;

        for (i = 0; i < len; ++i)
            if ((((((tree->left->type)->t) & 0x000000000001FFFFL)) & operands[idx + i].left_ts)
              && (((((tree->right->type)->t) & 0x000000000001FFFFL)) & operands[idx + i].right_ts))
                break;

        if (i == len) goto incompatible;
    }

    if (((tree->left->type)->t & 0x0000000000010000L) && ((tree->right->type)->t & 0x0000000000010000L))
    {
        long lquals = ((((((tree->left->type)->next))->t) & 0x0000000000060000L));
        long rquals = ((((((tree->right->type)->next))->t) & 0x0000000000060000L));

        if ((tree->op == ( 11 )) && ((lquals & rquals) != rquals))
            error(4, 0, "%k discards %q", k, (lquals & rquals) ^ rquals);

        do { if ((((tree->left->type)->t & 0x0000000000010000L) && ((((tree->left->type)->next))->t & 0x0000000000000001L))) if (flags & 0x00000080) tree->left->type = tree->right->type; else if (flags & 0x00000400) tree->right->type = get_tnode(0x0000000000010000L, 0, (qualify(&void_type, rquals))); } while (0);
        do { if ((((tree->right->type)->t & 0x0000000000010000L) && ((((tree->right->type)->next))->t & 0x0000000000000001L))) if (flags & 0x00000100) tree->right->type = tree->left->type; else if (flags & 0x00000200) tree->left->type = get_tnode(0x0000000000010000L, 0, (qualify(&void_type, lquals))); } while (0);

        if (compat(unqualify(((tree->left->type)->next)),
                   unqualify(((tree->right->type)->next))) == 0)
            goto incompatible;






        if (tree->op == ( 42 )) {




            struct tnode *composite;

            composite = compose(unqualify(((tree->left->type)->next)),
                                unqualify(((tree->right->type)->next)), 0);

            composite = get_tnode(0x0000000000010000L, 0, (qualify(composite, lquals | rquals)));
            tree->left->type = composite;
            tree->right->type = composite;
        }
    }

    if (((tree->left->type)->t & 0x0000000000002000L) && ((tree->right->type)->t & 0x0000000000002000L)
      && (((tree->left->type)->tag) != ((tree->right->type)->tag)))
        goto incompatible;

    if (((tree->left->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) )) && ((tree->right->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) )))
    {
        if (flags & (0x00000020 | 0x00000040))
            usuals(tree, flags);

        if (flags & 0x00000010)
            tree->right = unary_tree(( 6 | 0x40000000 ), tree->left->type, tree->right);
    }

    if (flags & 0x00000800)
        tree->right = unary_tree(( 6 | 0x40000000 ), &char_type, tree->right);

    if (flags & 0x00002000)
        tree->type = &int_type;
    else if (flags & 0x00001000)
        tree = scale(tree);
    else
        tree->type = tree->left->type;

    return tree;

incompatible:
    error(4, 0, "incompatible type(s) for %k", k);
}




struct tree *test(struct tree *tree, int cmp, int k)
{
    struct tree *zero;

    zero = ({ union con _con; _con.i = (0); con_tree((&int_type), &_con); });

    if (!((tree->type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L ))) {
        tree = promote(tree, 0);

        if (!((tree->type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )))
            error(4, 0, "%k requires a scalar expression", k);
    }

    zero = unary_tree(( 6 | 0x40000000 ), tree->type, zero);
    return binary_tree((cmp == ( 52 | ((24) << 24) | 0x00700000 )) ? ( 33 | 0x20000000 ) : ( 34 | 0x20000000 ), &int_type, tree, zero);
}








static void lvalue(struct tree *tree, int k, int flags)
{
    if (!((tree)->op & 0x10000000))
        error(4, 0, "%k requires an lvalue", k);

    if (((flags & 0x00000002) && (tree->op == ( 1 | 0x80000000 | 0x10000000 ))
      && (tree->sym->s & 0x00000080)))
        error(4, 0, "can't apply %k to register variable", k);

    if ((flags & 0x00000001) && ((((((tree->type)->t) & 0x0000000000060000L)) & 0x0000000000020000L) || (((tree->type)->t & 0x0000000000002000L) && (((tree->type)->tag)->s & 0x00400000))))
        error(4, 0, "%k requires non-`const' target", k);

    if (flags & 0x00000004) do { if (((((tree->type)->t) & 0x0000000000060000L)) && !((tree->type)->t & 0x0000000000002000L)) (tree->type) = unqualify(tree->type); } while (0);
}





static struct tree *crement(struct tree *tree, int op, int k)
{
    struct tree *addend;
    int inc = (k == ( 27 )) ? 1 : -1;

    lvalue(tree, k, 0x00000001 | 0x00000004);

    if (((tree->type)->t & 0x0000000000010000L))
        addend = ({ union con _con; _con.i = (inc); con_tree((&long_type), &_con); });
    else if (((tree->type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )))
        addend = ({ union con _con; _con.i = (inc); con_tree((tree->type), &_con); });
    else if (((tree->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )))
        addend = ({ union con _con; _con.f = (inc); con_tree((tree->type), &_con); });
    else
        error(4, 0, "%k requires scalar operand", k);

    tree = binary_tree(op, 0, tree, addend);
    tree = scale(tree);
    return tree;
}








static int no_stmt_expr;

static struct tree *primary(void)
{
    struct string *id;
    struct symbol *sym;
    struct tree *tree;

    switch (token.k)
    {
    case ( 3 | 0x40000000 ):    tree = ({ union con _con; _con.i = (token.con.i); con_tree((&int_type), &_con); }); lex(); break;
    case ( 4 | 0x40000000 ):    tree = ({ union con _con; _con.i = (token.con.i); con_tree((&uint_type), &_con); }); lex(); break;
    case ( 5 | 0x40000000 ):    tree = ({ union con _con; _con.i = (token.con.i); con_tree((&long_type), &_con); }); lex(); break;
    case ( 6 | 0x40000000 ):   tree = ({ union con _con; _con.i = (token.con.i); con_tree((&ulong_type), &_con); }); lex(); break;
    case ( 7 | 0x40000000 ):    tree = ({ union con _con; _con.f = (token.con.f); con_tree((&float_type), &_con); }); lex(); break;
    case ( 8 | 0x40000000 ):    tree = ({ union con _con; _con.f = (token.con.f); con_tree((&double_type), &_con); }); lex(); break;
    case ( 9 | 0x40000000 ):   tree = ({ union con _con; _con.f = (token.con.f); con_tree((&ldouble_type), &_con); }); lex(); break;

    case ( 2 ):  sym = literal(token.s);
                    tree = sym_tree(sym);
                    lex();
                    break;

    case ( 12 ):  lex();

                    if (token.k == ( 16 )) {
                        if (no_stmt_expr)
                            error(4, 0, "statement expressions"
                                            " prohibited here");

                        enter_scope(0);
                        compound(0);
                        exit_scope(&func_chain);
                        tree = stmt_tree;
                    } else
                        tree = expression();

                    do { expect(( 13 )); lex(); } while (0);
                    break;

    case ( 1 ):   id = token.s;
                    lex();
                    sym = lookup(id, ( 0x00000008 | 0x00000010 | 0x00000020 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 | 0x00000400 ), outer_scope, 1);

                    if (sym) {
                        if (sym->s & 0x00000200) {
                            tree = ({ union con _con; _con.i = (sym->value); con_tree((&int_type), &_con); });
                            break;
                        }
                    } else {
                        if (token.k == ( 12 ))
                            sym = implicit(id);
                        else
                            error(4, id, "unknown identifier");
                    }

                    if (sym->s & 0x00000008)
                        error(4, id, "misplaced typedef name");

                    sym->s |= 0x20000000;
                    tree = sym_tree(sym);
                    break;

    default:        error(4, 0, "expected expression (got %k)", token.k);
    }

    return tree;
}












static struct tree *access(struct tree *tree)
{
    struct symbol *tag;
    struct symbol *member;
    int fetch = ( 3 | 0x40000000 | 0x10000000 );
    long quals;

    if (token.k == ( 18 )) {
        if (!((tree)->op & 0x10000000)) fetch = ( 4 | 0x40000000 );
        tree = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (tree->type)), tree);
    }

    if (!(((tree->type)->t & 0x0000000000010000L) && ((((tree->type)->next))->t & 0x0000000000002000L)))
        error(4, 0, "%k requires struct or union type", token.k);

    tag = ((((tree->type)->next))->tag);
    quals = ((((((tree->type)->next))->t) & 0x0000000000060000L));

    if (!((tag)->s & 0x40000000))
        error(4, 0, "%k cannot be applied to incomplete %T", tag);

    lex();
    expect(( 1 ));
    member = lookup_member(token.s, tag);
    lex();

    tree = binary_tree(( 26 | 0x20000000 ), get_tnode(0x0000000000010000L, 0, (qualify(member->type, quals))),
                       tree, ({ union con _con; _con.i = (member->offset); con_tree((&long_type), &_con); }));

    tree = unary_tree(fetch, ((tree->type)->next), tree);
    tree->type = unfieldify(tree->type);

    return tree;
}




static struct tree *call(struct tree *tree)
{
    struct tnode *func;
    struct tnode *ret;
    struct tree *call;
    struct tree *arg;
    struct formal *formal;
    struct string *id;

    lex();





    id = (tree->op == ( 1 | 0x80000000 | 0x10000000 )) ? tree->sym->id : 0;

    tree = promote(tree, 0);
    func = ((tree->type)->next);

    if (!func || !((func)->t & 0x0000000000008000L))
        error(4, 0, "() requires function or pointer-to-function");

    ret = ((func)->next);

    tree = call = unary_tree(( 5 | 0x40000000 ), ret, tree);
    formal = func->formals;





    if (((ret)->t & 0x0000000000002000L)) {
        tree = sym_tree(temp(ret));
        tree = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (ret)), tree);
        actual(call, tree);
        call->type = get_tnode(0x0000000000010000L, 0, (ret));
        tree = unary_tree(( 4 | 0x40000000 ), ret, call);
    }

    if (token.k != ( 13 )) {
        for (;;) {
            arg = assignment();

            if (formal == 0) {
                if ((((func)->t & 0x0000000000008000L) && ((func)->t & 0x0000000000080000L)) || (((func)->t & 0x0000000000008000L) && ((func)->t & 0x0000000000100000L)))
                    arg = promote(arg, 1);
                else
                    error(4, id, "too many function arguments");
            } else {
                arg = fake(arg, formal->type, ( 59 | ((0) << 24) | 0x00100000 ));
                formal = formal->next;
            }

            size_of(arg->type, 0);
            actual(call, arg);

            if (token.k == ( 13 ))
                break;
            else
                do { expect(( 21 )); lex(); } while (0);
        }
    }

    do { expect(( 13 )); lex(); } while (0);
    if (formal) error(4, id, "too few function arguments");
    tree = rewrite_builtin(tree);

    return tree;
}










static struct tree *postfix(void)
{
    struct tree *tree;
    struct tree *rhs;

    tree = primary();

    for (;;)
    {
        switch (token.k)
        {
        case ( 27 ):
        case ( 28 ):     tree = crement(tree, ( 22 ), token.k);
                        lex();
                        break;

        case ( 12 ):  tree = call(tree);
                        break;

        case ( 18 ):
        case ( 26 ):   tree = access(tree);
                        break;

        case ( 14 ):  lex();
                        tree = promote(tree, 0);
                        rhs = promote(expression(), 0);
                        tree = binary_tree(( 26 | 0x20000000 ), 0, tree, rhs);
                        do { expect(( 15 )); lex(); } while (0);
                        do { if ((tree->op == ( 26 | 0x20000000 )) && ((tree->right->type)->t & 0x0000000000010000L)) do { struct tree * _tmp; _tmp = ((tree)->left); ((tree)->left) = ((tree)->right); ((tree)->right) = _tmp; } while (0); } while (0);

                        if (!((tree->left->type)->t & 0x0000000000010000L)
                          || !((tree->right->type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )))
                            error(4, 0, "invalid operands to []");

                        tree = scale(tree);
                        tree = unary_tree(( 3 | 0x40000000 | 0x10000000 ), ((tree->type)->next), tree);
                        break;

        default:        return tree;
        }
    }
}











static struct tree *unary(void)
{
    struct tree *tree;
    struct tnode *type;
    struct token peek;
    long ts;
    int op;
    int k;

    switch (k = token.k)
    {
    case ( 31 | ((13) << 24) | 0x00B00000 ):     lex();
                    tree = cast();
                    tree = promote(tree, 0);

                    if (!((tree->type)->t & 0x0000000000010000L))
                        error(4, 0, "illegal indirection");

                    return unary_tree(( 3 | 0x40000000 | 0x10000000 ), ((tree->type)->next), tree);

    case ( 42 | ((22) << 24) | 0x00600000 ):     lex();
                    tree = cast();
                    lvalue(tree, ( 42 | ((22) << 24) | 0x00600000 ), 0x00000002);











                    if (((((tree)->op == ( 3 | 0x40000000 | 0x10000000 )) || ((tree)->op == ( 4 | 0x40000000 ))) && (((((tree)->child->type)->next))->t & 0x0000008000000000L)))
                        error(4, 0, "can't apply %k to bitfield", ( 42 | ((22) << 24) | 0x00600000 ));

                    return unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (tree->type)), tree);

    case ( 29 ):     lex();
                    tree = cast();
                    return test(tree, ( 52 | ((24) << 24) | 0x00700000 ), ( 29 ));

    case ( 27 ):
    case ( 28 ):     lex();
                    return crement(unary(), ( 15 | 0x08000000 ), k);

    case ( 84 | 0x80000000 ):  lex();
                    peek = lookahead();

                    if ((token.k == ( 12 )) && ( ((peek).k & 0x20000000) || (((peek).k == ( 1 )) && named_type((peek).s)) )) {
                        lex();
                        type = abstract();
                        do { expect(( 13 )); lex(); } while (0);
                        tree = ({ union con _con; _con.i = (size_of(type, 0)); con_tree((&ulong_type), &_con); });
                    } else {
                        tree = unary();
                        tree = ({ union con _con; _con.i = (size_of(tree->type, 0)); con_tree((&ulong_type), &_con); });
                    }

                    return tree;

    default:        return postfix();




    case ( 33 | ((15) << 24) | 0x00A00000 ):   op = ( 8 | 0x40000000 ); ts = ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ); break;
    case ( 32 | ((14) << 24) | 0x00A00000 ):    op = ( 10 | 0x40000000 ); ts = ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ); break;
    case ( 25 ):   op = ( 9 | 0x40000000 ); ts = ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ); break;
    }

    lex();
    tree = cast();
    tree = promote(tree, 0);

    if ((((((tree->type)->t) & 0x000000000001FFFFL)) & ts) == 0)
        error(4, 0, "illegal operand to unary %k", k);

    return unary_tree(op, tree->type, tree);
}












static struct tree *cast(void)
{
    struct token peek;
    struct tnode *type;
    struct tree *tree;

    if (token.k == ( 12 )) {
        peek = lookahead();

        if (( ((peek).k & 0x20000000) || (((peek).k == ( 1 )) && named_type((peek).s)) )) {
            lex();
            type = abstract();
            do { expect(( 13 )); lex(); } while (0);
            tree = cast();
            tree = promote(tree, 0);

            if ((!((type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && !((type)->t & 0x0000000000000001L))
              || (((type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) && ((tree->type)->t & 0x0000000000010000L))
              || (((tree->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) && ((type)->t & 0x0000000000010000L))
              || !((tree->type)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )))
                error(4, 0, "invalid cast");

            return unary_tree(( 6 | 0x40000000 ), type, tree);
        }
    }

    return unary();
}













static struct tree *binary(struct tree *lhs, int prec)
{
    struct tree *rhs;
    int k;

    while (((token.k) & 0x00F00000) >= prec) {
        k = token.k;
        lex();
        rhs = cast();

        while (((token.k) & 0x00F00000) > ((k) & 0x00F00000))
            rhs = binary(rhs, (((k) & 0x00F00000) + 0x00100000));

        lhs = build_tree(k, lhs, rhs);
    }

    return lhs;
}
# 920 "expr.c"
static struct tree *ternary(void)
{
    struct tree *tree;
    struct tree *lhs;
    struct tree *rhs;
    int wrap = 0;

    tree = binary(cast(), 0x00200000);

    if (token.k == ( 24 )) {
        tree = test(tree, ( 53 | ((25) << 24) | 0x00700000 ), ( 24 ));
        lex();
        lhs = expression();
        do { expect(( 22 | ((29) << 24) )); lex(); } while (0);
        rhs = ternary();

        if (((lhs->type)->t & 0x0000000000002000L) && ((rhs->type)->t & 0x0000000000002000L)) {
            wrap = 1;
            lhs = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (lhs->type)), lhs);
            rhs = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (rhs->type)), rhs);
        }

        lhs = build_tree(( 22 | ((29) << 24) ), lhs, rhs);
        tree = binary_tree(( 41 ), lhs->type, tree, lhs);
        if (wrap) tree = unary_tree(( 4 | 0x40000000 ), ((tree->type)->next), tree);
    }

    return tree;
}








struct tree *assignment(void)
{
    struct tree *tree;
    struct tree *right;
    int k;

    tree = ternary();

    if (((token.k) & 0x00F00000) == 0x00100000) {
        k = token.k;
        lex();
        right = assignment();
        lvalue(tree, k, 0x00000001 | 0x00000004);
        tree = build_tree(k, tree, right);
    }

    return tree;
}











struct tree *expression(void)
{
    struct tree *tree;
    struct tree *right;
    int wrap;

    tree = assignment();

    if (token.k == ( 21 )) {
        lex();
        right = expression();

        if (wrap = (((right->type)->t & 0x0000000000002000L) != 0))
            right = unary_tree(( 7 | 0x40000000 ), get_tnode(0x0000000000010000L, 0, (right->type)), right);

        tree = binary_tree(( 43 ), right->type, tree, right);
        if (wrap) tree = unary_tree(( 4 | 0x40000000 ), ((tree->type)->next), tree);
    }

    return tree;
}

struct tree *fake(struct tree *tree, struct tnode *type, int k)
{
    static struct tree none = { ( 0 | 0x80000000 ) };

    none.type = type;
    tree = build_tree(k, &none, tree);
    tree = chop_right(tree);

    return tree;
}

struct tree *case_expr(void)
{
    struct tree *tree;

    ++no_stmt_expr;
    tree = assignment();
    tree = fold(tree);
    --no_stmt_expr;

    if (!(((tree)->op == ( 2 | 0x80000000 )) && ((tree)->sym == 0)) || !((tree->type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )))
        error(4, 0, "integral constant expression required");

    return tree;
}

int constant_expr(void)
{
    struct tree *tree;

    tree = case_expr();

    if (!con_in_range(0x0000000000000040L, &tree->con))
        error(4, 0, "constant expression out of range");

    return tree->con.i;
}

struct tree *static_expr(void)
{
    struct tree *tree;

    ++no_stmt_expr;
    tree = ternary();
    tree = promote(tree, 0);
    tree = fold(tree);
    --no_stmt_expr;

    if (!((tree)->op == ( 2 | 0x80000000 )))
        error(4, 0, "constant expression required");

    return tree;
}
