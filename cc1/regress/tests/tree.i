# 1 "tree.c"

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
# 19 "tree.c"
struct tree void_tree = { ( 0 | 0x80000000 ), 0, &void_type };
# 44 "tree.c"
struct tree *chop(struct tree *tree)        { do { tree->child->type = tree->type; tree = tree->child; if (tree->op == ( 2 | 0x80000000 )) normalize_con(((((tree->type)->t) & 0x000000000001FFFFL)), &tree->con); return tree; } while (0); }
struct tree *chop_left(struct tree *tree)   { do { tree->left->type = tree->type; tree = tree->left; if (tree->op == ( 2 | 0x80000000 )) normalize_con(((((tree->type)->t) & 0x000000000001FFFFL)), &tree->con); return tree; } while (0); }
struct tree *chop_right(struct tree *tree)  { do { tree->right->type = tree->type; tree = tree->right; if (tree->op == ( 2 | 0x80000000 )) normalize_con(((((tree->type)->t) & 0x000000000001FFFFL)), &tree->con); return tree; } while (0); }

struct tree *unary_tree(int op, struct tnode *type, struct tree *child)
{
    struct tree *new;

    new = ({ struct tree *_new; do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0); _new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct tree)); (_p); }); _new->op = (op); _new->nr_args = 0; _new->type = (type); _new; });
    new->child = child;
    new->args = 0;

    return new;
}

struct tree *binary_tree(int op, struct tnode *type, struct tree *left,
                                                     struct tree *right)
{
    struct tree *new;

    new = ({ struct tree *_new; do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0); _new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct tree)); (_p); }); _new->op = (op); _new->nr_args = 0; _new->type = (type); _new; });
    new->left = left;
    new->right = right;

    return new;
}

struct tree *con_tree(struct tnode *type, union con *conp)
{
    struct tree *new;

    new = ({ struct tree *_new; do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0); _new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct tree)); (_p); }); _new->op = (( 2 | 0x80000000 )); _new->nr_args = 0; _new->type = (type); _new; });
    new->con = *conp;
    new->sym = 0;

    return new;
}

struct tree *sym_tree(struct symbol *sym)
{
    struct tree *new;

    new = ({ struct tree *_new; do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0); _new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct tree)); (_p); }); _new->op = (( 1 | 0x80000000 | 0x10000000 )); _new->nr_args = 0; _new->type = (sym->type); _new; });
    new->sym = sym;
    new->con.i = 0;

    return new;
}

struct tree *seq_tree(struct tree *left, struct tree *right)
{
    struct tree *new;

    if (left == 0) return right;
    if (right == 0) return left;

    new = ({ struct tree *_new; do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0); _new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct tree)); (_p); }); _new->op = (( 44 )); _new->nr_args = 0; _new->type = (&void_type); _new; });
    new->left = left;
    new->right = right;

    return new;
}

struct tree *blk_tree(int op, struct tree *left, struct tree *right,
                              struct tree *size)
{
    struct tree *tree;

    tree = ({ struct tree *_new; do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0); _new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct tree)); (_p); }); _new->op = (op); _new->nr_args = 0; _new->type = (left->type); _new; });
    tree->left = ({ struct tree *_new; do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0); _new = ({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (sizeof(struct tree)); (_p); }); _new->op = (( 42 )); _new->nr_args = 0; _new->type = (&void_type); _new; });
    tree->left->left = left;
    tree->left->right = right;

    tree->right = size;

    return tree;
}











void actual(struct tree *call, struct tree *arg)
{
    struct tree **new_args;
    int new_nr_args;
    int i;

    if (call->nr_args == 63)
        error(1, 0, "can't handle that many arguments");

    if ((call->nr_args == 0) || ((call->nr_args >= 4)
                                    && (((call->nr_args) > 0) && !((call->nr_args) & ((call->nr_args) - 1)))))
    {
        new_nr_args = call->nr_args ? (call->nr_args << 1)
                                    : 4;

        do { struct arena *_a = (&stmt_arena); size_t _n = (8); unsigned long _p = (unsigned long) _a->top; if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; } } while (0);

        new_args = 
({ struct arena *_a = (&stmt_arena); void *_p = _a->top; _a->top = (char *) _p + (new_nr_args * sizeof(struct tree *)); (_p); });

        for (i = 0; i < call->nr_args; ++i)
            new_args[i] = call->args[i];

        call->args = new_args;
    }

    call->args[call->nr_args] = arg;
    ++call->nr_args;
}












int zero_tree(struct tree *tree) { if ((((tree)->op == ( 2 | 0x80000000 )) && ((tree)->sym == 0))) if (((tree->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) return tree->con.f == 0; else return tree->con.i == 0; return 0; }
int nonzero_tree(struct tree *tree) { if ((((tree)->op == ( 2 | 0x80000000 )) && ((tree)->sym == 0))) if (((tree->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) return tree->con.f != 0; else return tree->con.i != 0; return 0; }
# 238 "tree.c"
static struct tree *fold0(struct tree *tree)
{
    if (((tree)->op & 0x40000000)) {
        if ((tree->op == ( 6 | 0x40000000 )) && ((tree->child)->op == ( 2 | 0x80000000 ))) {
            if (cast_con(((((tree->type)->t) & 0x000000000001FFFFL)),
                         ((((tree->child->type)->t) & 0x000000000001FFFFL)),
                         &tree->child->con,
                         (tree->child->sym == 0)))
            {
                tree = chop(tree);
            }

            return tree;
        }

        if ((((tree->child)->op == ( 2 | 0x80000000 )) && ((tree->child)->sym == 0))) {
            switch (tree->op)
            {
            case ( 10 | 0x40000000 ):    tree = chop(tree); return tree;
            case ( 8 | 0x40000000 ):     do { do { if ((((((tree->child->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (tree->child)->con.f = - (tree->child)->con.f; else (tree->child)->con.i = - (tree->child)->con.i; } while (0); tree = chop(tree); } while (0); return tree;
            case ( 9 | 0x40000000 ):     do { do { (tree->child)->con.i = ~ (tree->child)->con.i; } while (0); tree = chop(tree); } while (0); return tree;
            }
        }
    } else if ((!((tree)->op & 0x80000000) && !((tree)->op & 0x40000000))) {
        if (nonzero_tree(tree->left)) {
            switch (tree->op)
            {
            case ( 41 ):   tree = chop_right(tree);
                            tree = chop_left(tree);
                            return tree;

            case ( 40 ):    tree = chop_right(tree);
                            return tree;

            case ( 39 ):     return ({ union con _con; _con.i = (1); con_tree((&int_type), &_con); });
            }
        } else if (zero_tree(tree->left)) {
            switch (tree->op)
            {
            case ( 41 ):   tree = chop_right(tree);
                            tree = chop_right(tree);
                            return tree;

            case ( 40 ):    return ({ union con _con; _con.i = (0); con_tree((&int_type), &_con); });

            case ( 39 ):     tree = chop_right(tree);
                            return tree;
            }
        }

        if (((tree)->op & 0x20000000)
          && ((tree->left)->op == ( 2 | 0x80000000 ))
          && ((tree->right)->op == ( 2 | 0x80000000 )))
            do { if (((tree->right)->sym) && !((tree->left)->sym == 0)) do { struct tree * _tmp; _tmp = ((tree->left)); ((tree->left)) = ((tree->right)); ((tree->right)) = _tmp; } while (0); } while (0);

        if ((tree->op == ( 27 ))
          && ((tree->left)->op == ( 2 | 0x80000000 ))
          && ((tree->right)->op == ( 2 | 0x80000000 )))
            do { if ((tree->left)->sym == (tree->right)->sym) (tree->left)->sym = (tree->right)->sym = 0; } while (0);

        if ((((tree->right)->op == ( 2 | 0x80000000 )) && ((tree->right)->sym == 0))) {
            if (((tree->left)->op == ( 2 | 0x80000000 ))) {
                switch (tree->op)
                {
                case ( 26 | 0x20000000 ):     do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (tree->left)->con.f = (tree->left)->con.f + (tree->right)->con.f; else if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i + (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u + (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                case ( 27 ):     do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (tree->left)->con.f = (tree->left)->con.f - (tree->right)->con.f; else if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i - (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u - (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                }
            }

            if ((((tree->left)->op == ( 2 | 0x80000000 )) && ((tree->left)->sym == 0))) {
                switch (tree->op)
                {
                case ( 23 ):




                                if (!zero_tree(tree->right))
                                    do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (tree->left)->con.f = (tree->left)->con.f / (tree->right)->con.f; else if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i / (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u / (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0);

                                return tree;

                case ( 24 ):     if (!zero_tree(tree->right))
                                    do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i % (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u % (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0);

                                return tree;

                case ( 25 | 0x20000000 ):     do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) (tree->left)->con.f = (tree->left)->con.f * (tree->right)->con.f; else if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i * (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u * (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                case ( 29 ):     do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i << (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u << (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                case ( 28 ):     do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i >> (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u >> (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                case ( 31 | 0x20000000 ):     do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i & (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u & (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                case ( 32 | 0x20000000 ):      do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i | (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u | (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                case ( 30 | 0x20000000 ):     do { do { if ((((((tree->left->type)->t) & 0x000000000001FFFFL))) & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L)) (tree->left)->con.i = (tree->left)->con.i ^ (tree->right)->con.i; else (tree->left)->con.u = (tree->left)->con.u ^ (tree->right)->con.u; } while (0); tree = chop_left(tree); } while (0); return tree;
                case ( 33 | 0x20000000 ):      do { int _result; if (((tree->left->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) _result = tree->left->con.f == tree->right->con.f; else _result = tree->left->con.u == tree->right->con.u; tree = ({ union con _con; _con.i = (_result); con_tree((&int_type), &_con); }); } while (0); return tree;
                case ( 34 | 0x20000000 ):     do { int _result; if (((tree->left->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) _result = tree->left->con.f != tree->right->con.f; else _result = tree->left->con.u != tree->right->con.u; tree = ({ union con _con; _con.i = (_result); con_tree((&int_type), &_con); }); } while (0); return tree;
                case ( 35 ):      do { int _result; if (((tree->left->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) _result = tree->left->con.f > tree->right->con.f; else if (((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))) _result = tree->left->con.i > tree->right->con.i; else _result = tree->left->con.u > tree->right->con.u; tree = ({ union con _con; _con.i = (_result); con_tree((&int_type), &_con); }); } while (0); return tree;
                case ( 36 ):    do { int _result; if (((tree->left->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) _result = tree->left->con.f >= tree->right->con.f; else if (((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))) _result = tree->left->con.i >= tree->right->con.i; else _result = tree->left->con.u >= tree->right->con.u; tree = ({ union con _con; _con.i = (_result); con_tree((&int_type), &_con); }); } while (0); return tree;
                case ( 38 ):      do { int _result; if (((tree->left->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) _result = tree->left->con.f < tree->right->con.f; else if (((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))) _result = tree->left->con.i < tree->right->con.i; else _result = tree->left->con.u < tree->right->con.u; tree = ({ union con _con; _con.i = (_result); con_tree((&int_type), &_con); }); } while (0); return tree;
                case ( 37 ):    do { int _result; if (((tree->left->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ))) _result = tree->left->con.f <= tree->right->con.f; else if (((tree->left->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))) _result = tree->left->con.i <= tree->right->con.i; else _result = tree->left->con.u <= tree->right->con.u; tree = ({ union con _con; _con.i = (_result); con_tree((&int_type), &_con); }); } while (0); return tree;
                }
            }
        }
    }

    return tree;
}











static struct tree *indirect0(struct tree *tree)
{
    struct tree *child = tree->child;

    switch (tree->op)
    {
    case ( 7 | 0x40000000 ):
        if ((child->op == ( 1 | 0x80000000 | 0x10000000 )) && (child->sym->s & (0x00000020 | 0x00000010))) {
            tree = chop(tree);
            tree->op = ( 2 | 0x80000000 );
            tree->con.i = 0;
        } else if ((((child)->op == ( 3 | 0x40000000 | 0x10000000 )) || ((child)->op == ( 4 | 0x40000000 )))) {
            tree = chop(tree);
            tree = chop(tree);
        }

        break;

    case ( 3 | 0x40000000 | 0x10000000 ):
    case ( 4 | 0x40000000 ):












        if ((child->op == ( 2 | 0x80000000 )) && child->sym && (child->con.i == 0)) {
            if (simpatico(tree->type, child->sym->type))
            {
                tree = chop(tree);
                tree->op = ( 1 | 0x80000000 | 0x10000000 );
            }
        } else if (child->op == ( 7 | 0x40000000 )) {
            if ((child->child->op != ( 1 | 0x80000000 | 0x10000000 ))
              || simpatico(tree->type, child->child->sym->type))
            {
                tree = chop(tree);
                tree = chop(tree);
            }
        }

        break;
    }

    return tree;
}
# 430 "tree.c"
static struct tree *restrun0(struct tree *tree)
{
    struct tree *lhs;
    struct tree *rhs;

    if ((tree->op == ( 11 )) && ((tree->type)->t & 0x0000000000002000L)) {
        do { lhs = tree->left; lhs = addrof(lhs, get_tnode(0x0000000000010000L, 0, (lhs->type))); } while (0);
        do { rhs = tree->right; rhs = addrof(rhs, get_tnode(0x0000000000010000L, 0, (rhs->type))); } while (0);





        if ((rhs->op == ( 5 | 0x40000000 ))
          && (rhs->nr_args)
          && (rhs->args[0]->op == ( 7 | 0x40000000 ))
          && (rhs->args[0]->child->op == ( 1 | 0x80000000 | 0x10000000 ))
          && (((rhs->args[0]->child->sym)->s & 0x00200000)))
        {
            rhs->args[0] = lhs;
            tree = unary_tree(( 4 | 0x40000000 ), tree->type, rhs);
        } else {
            lhs = blk_tree(( 45 ), lhs, rhs,
                           ({ union con _con; _con.i = (size_of(tree->type, 0)); con_tree((&ulong_type), &_con); }));

            tree = unary_tree(( 4 | 0x40000000 ), tree->type, lhs);
        }
    }

    return tree;
}













static struct tree *recast0(struct tree *tree)
{
    while (tree->op == ( 6 | 0x40000000 ))
    {



        if (simpatico(tree->type, tree->child->type))
            goto chop;
# 504 "tree.c"
        if (((tree->op == ( 6 | 0x40000000 )) && wider(tree->type, tree->child->type)) && ((tree->child->op == ( 6 | 0x40000000 )) && wider(tree->child->type, tree->child->child->type))
          && !(((tree->child->type)->t & ( 0x0000000000000008L | 0x0000000000000020L | 0x0000000000000080L | 0x0000000000000200L ))
          && ((tree->child->child->type)->t & ( 0x0000000000000002L | 0x0000000000000004L | 0x0000000000000010L | 0x0000000000000040L | 0x0000000000000100L))))
            goto chop;

        if (((tree->op == ( 6 | 0x40000000 )) && narrower(tree->type, tree->child->type)) && ((tree->child->op == ( 6 | 0x40000000 )) && wider(tree->child->type, tree->child->child->type)))
            goto chop;

        if (((tree->op == ( 6 | 0x40000000 )) && narrower(tree->type, tree->child->type)) && ((tree->child->op == ( 6 | 0x40000000 )) && narrower(tree->child->type, tree->child->child->type)))
            goto chop;










        if (((tree->op == ( 6 | 0x40000000 )) && !((((((tree->type)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)) == (((((tree->child->type)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)))) && ((tree->child->op == ( 6 | 0x40000000 )) && wider(tree->child->type, tree->child->child->type)))
            goto chop;

        break;

chop:
        tree = chop(tree);
    }

    return tree;
}









static struct tree *fpcast0(struct tree *tree)
{
    if ((tree->op == ( 6 | 0x40000000 )) && ((tree->type)->t & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )))
    {
        if (((tree->child->type)->t & ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L )) || ((tree->child->type)->t & ( 0x0000000000000010L | 0x0000000000000020L )))



            tree->child = unary_tree(( 6 | 0x40000000 ), &int_type, tree->child);

        else if (((tree->child->type)->t & 0x0000000000000080L))



            tree->child = unary_tree(( 6 | 0x40000000 ), &long_type, tree->child);
    }

    return tree;
}










static struct tnode *underlying(struct tree *left, struct tree *right)
{
    struct tnode *left_under = 0;
    struct tnode *right_under = 0;

    if (((left->op == ( 6 | 0x40000000 )) && wider(left->type, left->child->type))) left_under = left->child->type;
    if (((right->op == ( 6 | 0x40000000 )) && wider(right->type, right->child->type))) right_under = right->child->type;

    if (left_under && right_under) {



        if (((((left_under)->t) & 0x000000000001FFFFL)) == ((((right_under)->t) & 0x000000000001FFFFL)))
            return left_under;
    } else {



        if (left_under && (((right)->op == ( 2 | 0x80000000 )) && ((right)->sym == 0))
          && con_in_range(((((left_under)->t) & 0x000000000001FFFFL)), &right->con))
            return left_under;

        if (right_under && (((left)->op == ( 2 | 0x80000000 )) && ((left)->sym == 0))
          && con_in_range(((((right_under)->t) & 0x000000000001FFFFL)), &left->con))
            return right_under;
    }

    return 0;
}














static struct tree *uncast0(struct tree *tree)
{
    if (!((tree->op == ( 6 | 0x40000000 )) && narrower(tree->type, tree->child->type))
      || !((tree->type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ))
      || ((tree->child->op != ( 8 | 0x40000000 ))
      && (tree->child->op != ( 9 | 0x40000000 ))))
        return tree;

    tree = chop(tree);
    tree->child = unary_tree(( 6 | 0x40000000 ), tree->type, tree->child);
    tree->child = simplify(tree->child);

    return tree;
}




static struct tree *bincast0(struct tree *tree)
{
    if (!((tree->op == ( 6 | 0x40000000 )) && narrower(tree->type, tree->child->type)) || !((tree->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )))
        return tree;

    switch (tree->child->op)
    {
    case ( 26 | 0x20000000 ):
    case ( 27 ):
    case ( 25 | 0x20000000 ):
    case ( 29 ):
    case ( 31 | 0x20000000 ):
    case ( 32 | 0x20000000 ):
    case ( 30 | 0x20000000 ):






        tree = chop(tree);
        tree->left = unary_tree(( 6 | 0x40000000 ), tree->type, tree->left);
        tree->left = simplify(tree->left);




        if (tree->op != ( 29 )) {
            tree->right = unary_tree(( 6 | 0x40000000 ), tree->type, tree->right);
            tree->right = simplify(tree->right);
        }

        break;

    case ( 28 ):






        if (((tree->child->left->op == ( 6 | 0x40000000 )) && wider(tree->child->left->type, tree->child->left->child->type))
          && simpatico(tree->type, tree->child->left->child->type))
        {
            tree = chop(tree);
            tree->left = tree->left->child;
        }

        break;

    case ( 23 ):
    case ( 24 ):







        {
            struct tnode *type = underlying(tree->child->left,
                                            tree->child->right);

            if (type && simpatico(type, tree->type))
            {
                tree = chop(tree);
                tree->left = unary_tree(( 6 | 0x40000000 ), type, tree->left);
                tree->right = unary_tree(( 6 | 0x40000000 ), type, tree->right);
                tree->left = simplify(tree->left);
                tree->right = simplify(tree->right);
            }
        }

        break;

    }

    return tree;
}





static struct tree *asgcast0(struct tree *tree)
{
    if (!(!((tree)->op & 0x80000000) && !((tree)->op & 0x40000000))
      || !((tree->left->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L ))
      || !((tree->right->type)->t & ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | 0x0000000000010000L )))
        return tree;

    switch (tree->op)
    {
    case ( 15 | 0x08000000 ):
    case ( 16 | 0x08000000 ):
    case ( 12 | 0x08000000 ):



        if (!simpatico(tree->left->type, tree->right->type))
            goto rewrite;

        break;

    case ( 13 | 0x08000000 ):
    case ( 14 | 0x08000000 ):




        if ((((tree->right)->op == ( 2 | 0x80000000 )) && ((tree->right)->sym == 0)) &&
          con_in_range(((((tree->left->type)->t) & 0x000000000001FFFFL)), &tree->right->con))
            goto rewrite;




        if (((tree->right->op == ( 6 | 0x40000000 )) && wider(tree->right->type, tree->right->child->type)) && (((((tree->left->type)->t) & 0x000000000001FFFFL))
                                    == ((((tree->right->child->type)->t) & 0x000000000001FFFFL))))
            goto rewrite;

        break;
    }

    return tree;

rewrite:
    tree->right = unary_tree(( 6 | 0x40000000 ), tree->left->type, tree->right);
    tree->right = simplify(tree->right);
    return tree;
}







static struct tree *relcast0(struct tree *tree)
{
    switch (tree->op)
    {
    case ( 33 | 0x20000000 ):
    case ( 34 | 0x20000000 ):
    case ( 35 ):
    case ( 36 ):
    case ( 37 ):
    case ( 38 ):
        {
            struct tnode *type = underlying(tree->left, tree->right);

            if (type) {
                tree->left = unary_tree(( 6 | 0x40000000 ), type, tree->left);
                tree->right = unary_tree(( 6 | 0x40000000 ), type, tree->right);
                tree->left = simplify(tree->left);
                tree->right = simplify(tree->right);
            }
        }
    }

    return tree;
}




struct tree *simplify(struct tree *tree)
{
    do { int I; if (((tree)->op & 0x40000000)) { tree->child = simplify(tree->child); for (I = 0; I < tree->nr_args; ++I) tree->args[I] = simplify(tree->args[I]); } else if ((!((tree)->op & 0x80000000) && !((tree)->op & 0x40000000))) { tree->left = simplify(tree->left); tree->right = simplify(tree->right); } } while (0);

    tree = indirect0(tree);
    tree = fold0(tree);
    tree = restrun0(tree);
    tree = recast0(tree);
    tree = fpcast0(tree);
    tree = uncast0(tree);
    tree = bincast0(tree);
    tree = asgcast0(tree);
    tree = relcast0(tree);

    return tree;
}

struct tree *addrof(struct tree *tree, struct tnode *type)
{
    tree = unary_tree(( 7 | 0x40000000 ), type, tree);
    tree = indirect0(tree);
    return tree;
}

struct tree *fold(struct tree *tree)
{
    do { int I; if (((tree)->op & 0x40000000)) { tree->child = fold(tree->child); for (I = 0; I < tree->nr_args; ++I) tree->args[I] = fold(tree->args[I]); } else if ((!((tree)->op & 0x80000000) && !((tree)->op & 0x40000000))) { tree->left = fold(tree->left); tree->right = fold(tree->right); } } while (0);

    tree = indirect0(tree);
    tree = fold0(tree);

    return tree;
}






struct tree *rewrite_volatiles(struct tree *tree)
{
    if (tree->op == ( 7 | 0x40000000 ))
        return tree;

    if ((tree->op == ( 1 | 0x80000000 | 0x10000000 )) && (((((tree->sym->type)->t) & 0x0000000000060000L)) & 0x0000000000040000L)) {
        tree = addrof(tree, get_tnode(0x0000000000010000L, 0, (tree->sym->type)));
        tree = unary_tree(( 3 | 0x40000000 | 0x10000000 ), tree->child->type, tree);
    } else
        do { int I; if (((tree)->op & 0x40000000)) { tree->child = rewrite_volatiles(tree->child); for (I = 0; I < tree->nr_args; ++I) tree->args[I] = rewrite_volatiles(tree->args[I]); } else if ((!((tree)->op & 0x80000000) && !((tree)->op & 0x40000000))) { tree->left = rewrite_volatiles(tree->left); tree->right = rewrite_volatiles(tree->right); } } while (0);

    return tree;
}
