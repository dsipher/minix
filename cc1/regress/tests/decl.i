# 1 "decl.c"

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
# 17 "expr.h"
int constant_expr(void);



struct tree *case_expr(void);



struct tree *static_expr(void);



struct tree *assignment(void);





struct tree *test(struct tree *tree, int cmp, int k);



struct tree *expression(void);




struct tree *build_tree(int k, struct tree *left, struct tree *right);






struct tree *fake(struct tree *tree, struct tnode *type, int k);
# 13 "init.h"
struct symbol;



void out_word(long t, union con con, struct symbol *sym);



void init_bss(struct symbol *sym);









void init_static(struct symbol *sym, int s);




void init_auto(struct symbol *sym);



void tentative(struct symbol *sym);



struct symbol *floateral(long t, double f);
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
# 13 "stmt.h"
struct tree;





extern struct tree *stmt_tree;




void compound(int body);
# 13 "decl.h"
struct tnode;




void externals(void);



void locals(void);



struct tnode *abstract(void);
# 22 "decl.c"
typedef int callback(struct string *id, int s, struct tnode *type,
                     int *flags, void *arg);

static void declarations(int flags, void *arg, callback declare);

static struct tnode *declarator(struct tnode *prefix,
                                struct string **id, int *flags);




static struct symbol *formal_chain;
# 54 "decl.c"
static void qualifiers(long *t, int *flags)
{
    for (;;)
    {
        switch (token.k)
        {
        case ( 66 | 0x80000000 | 0x20000000 ):       *t |= 0x0000000000020000L; break;
        case ( 92 | 0x80000000 | 0x20000000 ):    *t |= 0x0000000000040000L; break;

        default:            return;
        }

        if (flags) *flags |= 0x00000001;
        lex();
    }
}




static struct { int s; int k; } s_k_map[] =
{
        { 0x00000040,           ( 62 | 0x80000000 | 0x20000000 )          },
        { 0x00000080,       ( 80 | 0x80000000 | 0x20000000 )      },
        { 0x00000008,        ( 88 | 0x80000000 | 0x20000000 )       },
        { 0x00000020,         ( 73 | 0x80000000 | 0x20000000 )        },
        { 0x00000010,         ( 85 | 0x80000000 | 0x20000000 )        }
};










static int s_to_k(int s) { int i; for (i = 0; i < (sizeof(s_k_map) / sizeof(*(s_k_map))); ++i) if (s_k_map[i].s == s) return s_k_map[i].k; }
static int k_to_s(int k) { int i; for (i = 0; i < (sizeof(s_k_map) / sizeof(*(s_k_map))); ++i) if (s_k_map[i].k == k) return s_k_map[i].s; }










static int member(struct string *id, int s, struct tnode *type,
                  int *flags, void *arg)
{
    struct symbol *tag = arg;
    int width;

    do { if ((s) && !((s) & (0))) error(4, 0, "invalid storage class %k", s_to_k(s)); } while (0);

    if (((type)->t & 0x0000000000008000L))
        error(4, id, "functions can't be members");









    if (token.k == ( 22 | ((29) << 24) )) {
        lex();
        width = constant_expr();

        if (!((type)->t & ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) )))
            error(4, id, "bitfields must have integral type");

        if ((width < 0) || (width > (size_of(type, 0) * 8)))
            error(4, id, "field width exceeds that of host type");

        type = fieldify(type, width, 0);
    }

    if (((type)->t & 0x0000008000000000L) && ((((((type)->t) & 0x0000007F00000000L) >> 32)) == 0) && id)
        error(4, id, "alignment fields must be anonymous");

    if (id == 0) {
        if (((type)->t & 0x0000008000000000L))
                                             ;
        else if ((((type)->t & 0x0000000000002000L) && ((type)->tag->id == 0))
               && ((*flags & (0x00000010 | 0x00000008)) == 0x00000010)
               && (token.k == ( 23 ))) {



                                                                       ;
        } else
            error(4, 0, "missing member identifier");
    }

    if ((((type)->t & 0x0000000000004000L) && ((type)->nelem == 0))) {
        if (tag->s & 0x00000002)
            error(4, id, "unions can't have flexible arrays");
    } else
        size_of(type, id);

    insert_member(tag, id, type);
    return 0;
}




static struct tnode *strun_specifier(struct symbol *tag, int *flags)
{
    if (token.k == ( 16 )) {
        enter_scope(1);
        lex();

        while (( ((token).k & 0x20000000) || (((token).k == ( 1 )) && named_type((token).s)) ))
            declarations(0, tag, member);

        do { expect(( 17 )); lex(); } while (0);
        exit_strun(tag);
    }

    return get_tnode(0x0000000000002000L, (long) tag, 0);
}




static struct tnode *enum_specifier(struct symbol *tag, int *flags)
{
    struct symbol *sym;
    int value;

    if (token.k == ( 16 )) {
        lex();
        value = 0;

        for (;;)
        {
            expect(( 1 ));
            unique(token.s, ( 0x00000008 | 0x00000010 | 0x00000020 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 | 0x00000400 ), outer_scope, 0);
            sym = new_symbol(token.s, 0x00000200);
            lex();

            if (token.k == ( 57 | ((0) << 24) | 0x00100000 )) {
                lex();
                value = constant_expr();
            }

            sym->value = value++;
            insert(sym, outer_scope);

            if (token.k == ( 21 ))
                lex();
            else
                break;
        }

        do { expect(( 17 )); lex(); } while (0);
        do { (tag)->path = path; (tag)->line_no = line_no; } while (0);
        tag->s |= 0x40000000;
        *flags |= 0x00000004;
    }

    if (!((tag)->s & 0x40000000)) error(4, 0, "%T is incomplete", tag);
    return &int_type;
}






static struct tnode *tag_specifier(int *flags)
{
    struct symbol *tag = 0;
    struct string *id = 0;
    int s;

    switch (token.k)
    {
    case ( 86 | 0x80000000 | 0x20000000 ):  s = 0x00000001; break;
    case ( 89 | 0x80000000 | 0x20000000 ):   s = 0x00000002; break;
    case ( 72 | 0x80000000 | 0x20000000 ):    s = 0x00000004; break;
    }

    lex();

    if (token.k == ( 1 )) {
        id = token.s;
        lex();

        if ((token.k == ( 16 )) || ((token.k == ( 23 )) && (s != 0x00000004))) {




            *flags |= 0x00000002;
            tag = lookup(id, ( 0x00000001 | 0x00000002 | 0x00000004 ), outer_scope, outer_scope);
        } else
            tag = lookup(id, ( 0x00000001 | 0x00000002 | 0x00000004 ), outer_scope, 1);
    } else
        expect(( 16 ));

    if (tag == 0) {
        tag = new_symbol(id, s);
        insert(tag, outer_scope);
   }

    if (!(tag->s & s))
        error(4, 0, "tag confusion, previously %T %L", tag, tag);

    if (token.k == ( 16 )) {
        if (((tag)->s & 0x40000000))
            error(4, 0, "%T already defined %L", tag, tag);

        do { (tag)->path = path; (tag)->line_no = line_no; } while (0);
    }

    *flags |= 0x00000001;

    if (s == 0x00000004)
        return enum_specifier(tag, flags);
    else
        return strun_specifier(tag, flags);
}





static struct tnode *specifiers(int *s, int *flags)
{
    struct tnode *type = 0;
    int ks = 0;
    long quals = 0;

    if (s) *s = 0;

    for (;;)
    {
        switch (token.k)
        {
        case ( 62 | 0x80000000 | 0x20000000 ):        case ( 73 | 0x80000000 | 0x20000000 ):      case ( 80 | 0x80000000 | 0x20000000 ):
        case ( 85 | 0x80000000 | 0x20000000 ):      case ( 88 | 0x80000000 | 0x20000000 ):

            if (!s) error(4, 0, "no storage class permitted here");
            if (*s) error(4, 0, "multiple storage class specifiers");
            *s = k_to_s(token.k);
            *flags |= 0x00000001;
            lex();
            break;

        case ( 66 | 0x80000000 | 0x20000000 ):       case ( 92 | 0x80000000 | 0x20000000 ):

            qualifiers(&quals, flags);
            break;

        case ( 83 | 0x80000000 | 0x20000000 | 0x00010000 ):      case ( 90 | 0x80000000 | 0x20000000 | 0x00008000 ):    case ( 65 | 0x80000000 | 0x20000000 | 0x00000200 ):
        case ( 82 | 0x80000000 | 0x20000000 | 0x00000400 ):       case ( 78 | 0x80000000 | 0x20000000 | 0x00000800 ):         case ( 79 | 0x80000000 | 0x20000000 | 0x00001000 ):
        case ( 74 | 0x80000000 | 0x20000000 | 0x00002000 ):       case ( 70 | 0x80000000 | 0x20000000 | 0x00004000 ):      case ( 91 | 0x80000000 | 0x20000000 | 0x00000100 ):

            if (type || (ks & ((token.k) & 0x0001FF00))) goto too_many;
            ks |= ((token.k) & 0x0001FF00);
            *flags |= 0x00000001;
            lex();
            break;

        case ( 86 | 0x80000000 | 0x20000000 ):      case ( 89 | 0x80000000 | 0x20000000 ):       case ( 72 | 0x80000000 | 0x20000000 ):

            if (type || ks) goto too_many;
            type = tag_specifier(flags);
            break;

        case ( 1 ):




            if (!type && !ks && (type = named_type(token.s))) {
                *flags |= 0x00000008 | 0x00000001;
                lex();
                break;
            }




        default:
            if (ks) type = map_type(ks);
            if (type == 0) type = &int_type;
            return qualify(type, quals);
        }
    }

too_many:
    error(4, 0, "too many type specifiers");
}




static void prototype0(struct symbol *sym)
{
    error(0, 0, "%T declared in argument list", sym);
}

static void prototype(struct tnode *prefix, struct symbol **chainp)
{
    struct tnode *base;
    struct tnode *type;
    struct string *id;
    struct symbol *sym;
    int flags;
    int s;

    prefix->t &= ~0x0000000000080000L;
    enter_scope(0);

    if ((token.k == ( 91 | 0x80000000 | 0x20000000 | 0x00000100 )) && (lookahead().k == ( 13 )))
        lex();
    else {
        while (( ((token).k & 0x20000000) || (((token).k == ( 1 )) && named_type((token).s)) )) {
            flags = 0;
            base = specifiers(&s, &flags);
            do { if ((s) && !((s) & (0x00000080))) error(4, 0, "invalid storage class %k", s_to_k(s)); } while (0);
            s = s ? s : 0x00000100;

            type = declarator(0, &id, &flags);
            type = graft(type, base);
            validate(type, id, 0);
            type = formal_type(type);
            new_formal(prefix, type);
            unique(id, 0x08000000, current_scope, 0);
            sym = new_symbol(id, s | 0x08000000);
            sym->type = type;
            insert(sym, outer_scope);

            if (token.k == ( 21 )) {
                lex();
                if (token.k == ( 19 )) {
                    lex();
                    prefix->t |= 0x0000000000100000L;
                    break;
                }
            } else
                break;
        }
    }

    walk_scope(outer_scope, ( 0x00000001 | 0x00000002 | 0x00000004 ), prototype0);
    exit_scope(chainp);
}




static void id_list(struct symbol **chainp)
{
    struct symbol *sym;
    struct string *id;

    enter_scope(0);

    for (;;)
    {
        expect(( 1 ));
        id = token.s;
        lex();





        if (named_type(id))
            error(4, id, "is a typedef");

        unique(id, 0x08000000, current_scope, 0);
        sym = new_symbol(id, 0x08000000 | 0x00000100);
        insert(sym, outer_scope);

        if (token.k == ( 21 ))
            lex();
        else
            break;
    }

    exit_scope(chainp);
}









static struct tnode *declarator0(struct tnode *prefix,
                                 struct string **id, int *flags)
{
    struct symbol *chain;
    struct token peek;

    if ((token.k == ( 12 ))
      && (peek = lookahead(), peek.k != ( 13 ))
      && !( ((peek).k & 0x20000000) || (((peek).k == ( 1 )) && named_type((peek).s)) )) {
        lex();
        prefix = declarator(prefix, id, flags);
        do { expect(( 13 )); lex(); } while (0);
    } else {
        if (*flags & 0x00000100) expect(( 1 ));

        if (token.k == ( 1 )) {
            if (id) {
                *id = token.s;
                lex();
            } else
                error(4, token.s, "abstract type required");
        } else
            if (id) *id = 0;
    }

    for (;;)
    {
        switch (token.k)
        {
        case ( 14 ):
            lex();
            prefix = new_tnode(0x0000000000004000L, 0, prefix);

            if (token.k != ( 15 )) {
                prefix->nelem = constant_expr();

                if (prefix->nelem <= 0)
                    error(4, (id ? *id : 0), "bogus dimension (%d)",
                                                 prefix->nelem);

                if (prefix->nelem > (1 << (28 - 1)))
                    error(4, (id ? *id : 0), "sorry, dimension too big");
            }

            do { expect(( 15 )); lex(); } while (0);
            break;

        case ( 12 ):
            lex();
            prefix = new_tnode(0x0000000000008000L | 0x0000000000080000L, 0, prefix);






            if (token.k != ( 13 )) {
                if ((prefix->next == 0) && (*flags & 0x00000020)) {
                    if (( ((token).k & 0x20000000) || (((token).k == ( 1 )) && named_type((token).s)) ))
                        prototype(prefix, &formal_chain);
                    else {
                        *flags |= 0x00000040;
                        id_list(&formal_chain);
                    }
                } else {
                    if (( ((token).k & 0x20000000) || (((token).k == ( 1 )) && named_type((token).s)) ))
                        prototype(prefix, 0);
                    else
                                                                          ;
                }
            }

            do { expect(( 13 )); lex(); } while (0);
            break;

        default:
            return prefix;
        }
    }
}

static struct tnode *declarator(struct tnode *prefix,
                                struct string **id, int *flags)
{
    long quals = 0;

    if (token.k == ( 31 | ((13) << 24) | 0x00B00000 )) {
        lex();
        qualifiers(&quals, 0);
        prefix = declarator(prefix, id, flags);
        prefix = new_tnode(0x0000000000010000L | quals, 0, prefix);
    } else
        prefix = declarator0(prefix, id, flags);

    return prefix;
}






static void declarations(int flags, void *arg, callback declare)
{
    struct tnode *base;
    struct tnode *prefix;
    struct tnode *type;
    struct string *id;
    int dtor_flags;
    int s;

    base = specifiers(&s, &flags);







    if ((token.k == ( 23 ))
      && (flags & (0x00000002 | 0x00000004))
      && !(flags & 0x00000080)) {




        if (s) error(0, 0, "stray storage class %k", s_to_k(s));

        if (((((base)->t) & 0x0000000000060000L)))
            error(0, 0, "useless %q", ((((base)->t) & 0x0000000000060000L)));

        lex();
        return;
    }

    flags |= 0x00000010;

    for (;;)
    {
        dtor_flags = flags;
        prefix = declarator(0, &id, &dtor_flags);
        if (prefix) dtor_flags &= ~0x00000008;
        type = graft(prefix, base);
        validate(type, id, 0);
        if (declare(id, s, type, &dtor_flags, arg)) return;




        if ((dtor_flags & 0x00000001) == 0)
            error(4, id, "missing declaration specifiers");

        if (token.k == ( 21 ))
            lex();
        else
            break;

        flags &= ~(0x00000010 | 0x00000020);
    }

    do { expect(( 23 )); lex(); } while (0);
}




static int local(struct string *id, int s, struct tnode *type,
                  int *flags, void *arg)
{
    struct symbol *sym;

    if (s == 0) s = ((type)->t & 0x0000000000008000L) ? 0x00000020 : 0x00000100;

    if (s & 0x00000020) {




        unique(id, ( 0x00000008 | 0x00000010 | 0x00000020 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 | 0x00000400 ) & ~0x00000400, outer_scope, 0);
        sym = global(id, s, type, 0);
        redirect(sym, outer_scope);
    } else {
        unique(id, ( 0x00000008 | 0x00000010 | 0x00000020 | 0x00000040 | 0x00000080 | 0x00000100 | 0x00000200 | 0x00000400 ), outer_scope, 0);
        sym = new_symbol(id, s);
        sym->type = type;
        insert(sym, outer_scope);

        if (!(s & 0x00000008)) {
            if (((type)->t & 0x0000000000008000L))
                error(4, id, "no local functions");
            else {
                if (s & ( 0x00000040 | 0x00000080 | 0x00000100 ))
                    init_auto(sym);
                else
                    init_static(sym, s);
            }
        }
    }

    return 0;
}

void locals(void)
{
    while (( ((token).k & 0x20000000) || (((token).k == ( 1 )) && named_type((token).s)) ))
        declarations(0x00000100, 0, local);
}










static int old_arg(struct string *id, int s, struct tnode *type,
                   int *flags, void *arg)
{
    struct symbol *sym;

    do { if ((s) && !((s) & (0x00000080))) error(4, 0, "invalid storage class %k", s_to_k(s)); } while (0);
    s = s ? s : 0x00000100;
    sym = lookup(id, 0x08000000, 2, 2);
    if (sym == 0) error(4, id, "is not an argument");
    if (sym->type) error(4, id, "type already declared");

    if (((type)->t & 0x0000000000000400L)) s |= 0x01000000;

    sym->s = 0x08000000 | s;
    sym->type = formal_type(type);

    return 0;
}





static void funcdef(int *flags, struct symbol *sym)
{
    reenter_scope(&formal_chain);

    if (*flags & 0x00000040)
        while (( ((token).k & 0x20000000) || (((token).k == ( 1 )) && named_type((token).s)) ))
            declarations(0x00000100 | 0x00000080, 0, old_arg);

    enter_func(sym);
    compound(1);
    exit_scope(&func_chain);
    exit_func();
}








static int external(struct string *id, int s, struct tnode *type,
                    int *flags, void *arg)
{
    struct symbol *sym;
    int was_def = 0;
    int eff_s;

    do { if ((s) && !((s) & (0x00000020 | 0x00000010 | 0x00000008))) error(4, 0, "invalid storage class %k", s_to_k(s)); } while (0);
    eff_s = s ? s : 0x00000020;

    if (s & 0x00000008)
        local(id, s, type, flags, 0);
    else {
        unique(id, 0x00000200 | 0x00000008, 1, 0);
        sym = global(id, eff_s, type, 1);

        if (((type)->t & 0x0000000000008000L)) {









            if ((token.k != ( 21 ))
              && (token.k != ( 23 ))
              && (*flags & 0x00000020)
              && !(*flags & 0x00000008))
            {
                funcdef(flags, sym);
                was_def = 1;
            }
        } else
            init_static(sym, s);
    }






    if (formal_chain) {
        if (*flags & 0x00000040)
            error(4, id, "misplaced old-style arguments");

        free_symbols(&formal_chain);
    }

    return was_def;
}

void externals(void)
{
    while (token.k) {
        declarations(0x00000020 | 0x00000100, 0, external);
        do { struct arena *_a = (&stmt_arena); _a->top = _a->bottom; } while (0);
        purge_anons();
    }
}

struct tnode *abstract(void)
{
    struct tnode *base;
    struct tnode *type;
    int flags;

    flags = 0;
    base = specifiers(0, &flags);
    type = declarator(0, 0, &flags);
    type = graft(type, base);
    validate(type, 0, 1);

    return type;
}
