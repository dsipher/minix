# 1 "builtin.c"

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
# 13 "builtin.h"
struct string;
struct tree;







void seed_builtin(struct string *id);




struct tree *rewrite_builtin(struct tree *tree);
# 21 "builtin.c"
void seed_builtin(struct string *id)
{
    struct symbol *sym;
    struct tnode *func;
    struct tnode *ret;

    func = new_tnode(0x0000000000008000L, 0, 0);

    switch (id->k)
    {
    case ( 128 | 0x00040000 ):
        ret = get_tnode(0x0000000000010000L, 0, (&void_type));
        new_formal(func, get_tnode(0x0000000000010000L, 0, (&void_type)));
        new_formal(func, get_tnode(0x0000000000010000L, 0, (qualify(&void_type, 0x0000000000020000L))));
        new_formal(func, &ulong_type);
        break;

    case ( 129 | 0x00040000 ):
        ret = get_tnode(0x0000000000010000L, 0, (&void_type));
        new_formal(func, get_tnode(0x0000000000010000L, 0, (&void_type)));
        new_formal(func, &int_type);
        new_formal(func, &ulong_type);
        break;

    case ( 130 | 0x00040000 ):
    case ( 132 | 0x00040000 ):
        ret = &int_type;
        new_formal(func, &int_type);
        break;

    case ( 131 | 0x00040000 ):
    case ( 133 | 0x00040000 ):
        ret = &int_type;
        new_formal(func, &long_type);
        break;
    }

    sym = new_symbol(id, 0x00000010);
    sym->type = graft(func, ret);
    sym->s |= 0x80000000 | 0x40000000;
    insert(sym, 1);
}















struct tree *rewrite_builtin(struct tree *tree)
{
    struct symbol *sym;
    int k;

    if ((tree->left->op != ( 7 | 0x40000000 ))
      || (tree->left->child->op != ( 1 | 0x80000000 | 0x10000000 ))
      || (!((tree->left->child->sym)->s & 0x80000000)))
        return tree;

    k = tree->left->child->sym->id->k;

    switch (k)
    {
    case ( 130 | 0x00040000 ):
    case ( 131 | 0x00040000 ):
        tree = unary_tree(( 48 | 0x40000000 ), &int_type, tree->args[0]);
        tree = binary_tree(( 30 | 0x20000000 ), &int_type, tree, (k == ( 130 | 0x00040000 ))
                                                    ? ({ union con _con; _con.i = (31); con_tree((&int_type), &_con); })
                                                    : ({ union con _con; _con.i = (63); con_tree((&int_type), &_con); }));
        return tree;

    case ( 132 | 0x00040000 ):
    case ( 133 | 0x00040000 ):
        return unary_tree(( 47 | 0x40000000 ), &int_type, tree->args[0]);

    case ( 128 | 0x00040000 ):
    case ( 129 | 0x00040000 ):



        return blk_tree((k == ( 128 | 0x00040000 )) ? ( 45 ) : ( 46 ),
                         tree->args[0], tree->args[1], tree->args[2]);
    }

    return tree;
}
