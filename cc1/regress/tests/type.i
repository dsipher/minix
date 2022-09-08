# 1 "type.c"

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
# 21 "type.c"
static struct tnode *buckets[(1 << 7)];

static struct slab tnode_slab = { sizeof(struct tnode), (100) };
static struct slab formal_slab = { sizeof(struct formal), (100) };

struct tnode void_type      = { 0x0000000000000001L };
struct tnode char_type      = { 0x0000000000000002L };
struct tnode schar_type     = { 0x0000000000000004L };
struct tnode uchar_type     = { 0x0000000000000008L };
struct tnode short_type     = { 0x0000000000000010L };
struct tnode ushort_type    = { 0x0000000000000020L };
struct tnode int_type       = { 0x0000000000000040L };
struct tnode uint_type      = { 0x0000000000000080L };
struct tnode long_type      = { 0x0000000000000100L };
struct tnode ulong_type     = { 0x0000000000000200L };
struct tnode float_type     = { 0x0000000000000400L };
struct tnode double_type    = { 0x0000000000000800L };
struct tnode ldouble_type   = { 0x0000000000001000L };







static struct { int ks; struct tnode *type; } map[] =
{
    0x00000100,                                    &void_type,
    0x00000200,                                    &char_type,
    0x00010000 | 0x00000200,                    &schar_type,
    0x00008000 | 0x00000200,                  &uchar_type,
    0x00000400,                                   &short_type,
    0x00000400 | 0x00000800,                      &short_type,
    0x00010000 | 0x00000400,                   &short_type,
    0x00010000 | 0x00000400 | 0x00000800,      &short_type,
    0x00008000 | 0x00000400,                 &ushort_type,
    0x00008000 | 0x00000400 | 0x00000800,    &ushort_type,
    0x00000800,                                     &int_type,
    0x00010000,                                  &int_type,
    0x00010000 | 0x00000800,                     &int_type,
    0x00008000,                                &uint_type,
    0x00008000 | 0x00000800,                   &uint_type,
    0x00001000,                                    &long_type,
    0x00001000 | 0x00000800,                       &long_type,
    0x00010000 | 0x00001000,                    &long_type,
    0x00010000 | 0x00001000 | 0x00000800,       &long_type,
    0x00008000 | 0x00001000,                  &ulong_type,
    0x00008000 | 0x00001000 | 0x00000800,     &ulong_type,
    0x00002000,                                   &float_type,
    0x00004000,                                  &double_type,
    0x00004000 | 0x00001000,                    &ldouble_type
};

struct tnode *map_type(int ks)
{
    int i;

    for (i = 0; i < (sizeof(map) / sizeof(*(map))); ++i)
        if (map[i].ks == ks)
            return map[i].type;

    error(4, 0, "invalid type specification");
}


















void new_formal(struct tnode *tn, struct tnode *type)
{
    struct formal **ff, *f;

    f = ({ struct slab_obj *_obj; if (_obj = formal_slab.free) formal_slab.free = _obj->next; else _obj = refill_slab(&formal_slab); --formal_slab.avail; ((struct formal *) (_obj)); });
    f->type = unqualify(type);
    f->next = 0;

    for (ff = &tn->formals; *ff; ff = &(*ff)->next) ;
    *ff = f;
}

struct tnode *new_tnode(long t, long u, struct tnode *next)
{
    struct formal *f;
    struct tnode *tn;

    tn = ({ struct slab_obj *_obj; if (_obj = tnode_slab.free) tnode_slab.free = _obj->next; else _obj = refill_slab(&tnode_slab); --tnode_slab.avail; ((struct tnode *) (_obj)); });
    tn->t = t;
    tn->u = u;
    tn->next = next;

    if ((t & 0x0000000000008000L) && u) {
        tn->u = 0;

        for (f = (struct formal *) u; f; f = f->next)
            new_formal(tn, f->type);
    }

    return tn;
}







static unsigned long tnode_hash(long t, long u, struct tnode *next)
{
    unsigned long hash;
    struct formal *f;






    hash = (__builtin_ctz(((t) & 0x000000000001FFFFL)) + 1) << 2;
    if (t & 0x0000000000020000L) hash += 2;
    if (t & 0x0000000000040000L) hash += 1;
    hash *= 0x810204080204081L;

    if (t & 0x0000008000000000L) hash = (hash ^ 0xFFFFFFFFFFFFFFFFL) +
                            ((((t) & 0x0000007F00000000L) >> 32) + (((t) & 0x00003F0000000000L) >> 40));

    switch (((t) & 0x000000000001FFFFL))
    {
    case 0x0000000000004000L:   hash ^= u; break;
    case 0x0000000000002000L:   hash ^= (u >> 5); break;

    case 0x0000000000008000L:    for (f = (struct formal *) u; f; f = f->next)
                        hash ^= f->type->hash;
    }

    hash ^= ((long) next) >> 5;
    return hash;
}



static struct tnode *tnode_find(long t, long u, struct tnode *next,
                                unsigned long hash)
{
    struct tnode *tn;
    struct formal *old_f, *new_f;
    int b = ((hash) % (1 << 7));

    for (tn = buckets[b]; tn; tn = tn->link) {
        if ((tn->hash != hash) || (tn->t != t) || (tn->next != next))
            continue;

        if (tn->t & 0x0000000000008000L) {
            for (old_f = tn->formals, new_f = (struct formal *) u;
              old_f && new_f && (old_f->type == new_f->type);
              old_f = old_f->next, new_f = new_f->next) ;

            if (old_f || new_f) continue;
        } else
            if (tn->u != u) continue;

        return tn;
    }

    return 0;
}




struct tnode *get_tnode(long t, long u, struct tnode *next)
{
    unsigned long hash;
    struct tnode *tn;

    hash = tnode_hash(t, u, next);
    tn = tnode_find(t, u, next, hash);

    if (tn == 0) {
        tn = new_tnode(t, u, next);
        tn->hash = hash;
        do { struct tnode *_tn = (tn); int _b = ((_tn->hash) % (1 << 7)); _tn->link = buckets[_b]; buckets[_b] = _tn; } while (0);
    }

    return tn;
}

struct tnode *graft(struct tnode *prefix, struct tnode *type)
{
    struct tnode *tn, *tmp;

    while (tn = prefix) {
        prefix = prefix->next;
        tn->next = type;
        tn->hash = tnode_hash(tn->t, tn->u, tn->next);
        tmp = tnode_find(tn->t, tn->u, tn->next, tn->hash);

        if (tmp == 0) {
            do { struct tnode *_tn = (tn); int _b = ((_tn->hash) % (1 << 7)); _tn->link = buckets[_b]; buckets[_b] = _tn; } while (0);
            type = tn;
        } else {



            struct formal *f, *tmp_f;

            if (tn->t & 0x0000000000008000L) {
                for (f = tn->formals; f; f = tmp_f) {
                    tmp_f = f->next;
                    do { struct formal *_p = (f); ((struct slab_obj *) (f))->next = formal_slab.free; formal_slab.free = ((struct slab_obj *) (f)); ++formal_slab.avail; } while (0);
                }
            }

            do { struct tnode *_p = (tn); ((struct slab_obj *) (tn))->next = tnode_slab.free; tnode_slab.free = ((struct slab_obj *) (tn)); ++tnode_slab.avail; } while (0);
            type = tmp;
        }
    }

    return type;
}





static int nr_static_tnodes;

void seed_types(void)
{
    struct tnode *tn;
    int i;

    for (i = 0; i < (sizeof(map) / sizeof(*(map))); ++i) {
        tn = map[i].type;

        if (tn->hash == 0) {
            tn->hash = tnode_hash(tn->t, 0, 0);
            ++nr_static_tnodes;
            do { struct tnode *_tn = (tn); int _b = ((_tn->hash) % (1 << 7)); _tn->link = buckets[_b]; buckets[_b] = _tn; } while (0);
        }
    }
}





struct tnode *qualify(struct tnode *type, long quals)
{
    struct tnode *prefix;




    prefix = type;
    while (((prefix)->t & 0x0000000000004000L)) prefix = prefix->next;
    if ((type->t & quals) == quals) return type;

    prefix = 0;

    while (((type)->t & 0x0000000000004000L)) {
        prefix = new_tnode(0x0000000000004000L, type->nelem, prefix);
        type = type->next;
    }

    if (((type)->t & 0x0000000000008000L)) error(4, 0, "can't qualify function types");

    prefix = new_tnode(type->t | quals, type->u, prefix);
    return graft(prefix, type->next);
}





struct tnode *unqualify(struct tnode *type)
{
    if (((((type)->t) & 0x0000000000060000L)))
        type = get_tnode(((type->t) & ~0x0000000000060000L), type->u, type->next);

    return type;
}















static int tnode_compat(struct tnode *tn1, struct tnode *tn2)
{
    struct formal *f1, *f2;

    if (((tn1->t) & 0x0000000000060000L) != ((tn2->t) & 0x0000000000060000L)) return 0;
    if (((tn1->t) & 0x000000000001FFFFL) != ((tn2->t) & 0x000000000001FFFFL)) return 0;

    switch (((tn1->t) & 0x000000000001FFFFL))
    {
    case 0x0000000000002000L:   return (tn1->tag == tn2->tag);

    case 0x0000000000004000L:   if (tn1->nelem && tn2->nelem)
                        return tn1->nelem == tn2->nelem;

                    return 1;

    case 0x0000000000008000L:    if ((((tn1)->t & 0x0000000000008000L) && ((tn1)->t & 0x0000000000100000L)) != (((tn2)->t & 0x0000000000008000L) && ((tn2)->t & 0x0000000000100000L)))
                        return 0;

                    if ((((tn1)->t & 0x0000000000008000L) && ((tn1)->t & 0x0000000000080000L)) || (((tn2)->t & 0x0000000000008000L) && ((tn2)->t & 0x0000000000080000L)))
                        return 1;

                    for (f1 = tn1->formals, f2 = tn2->formals;
                         f1 && f2; f1 = f1->next, f2 = f2->next) ;

                    return (f1 == f2);

    default:        return 1;
    }
}








int compat(struct tnode *type1, struct tnode *type2)
{
    struct formal *f1, *f2;
    struct tnode *tn1, *tn2;

    for (tn1 = type1, tn2 = type2;
         tn1 && tn2 && (tn1 != tn2) && tnode_compat(tn1, tn2);
         tn1 = tn1->next, tn2 = tn2->next)
    {
        if (((tn1)->t & 0x0000000000008000L) && !(((tn1)->t & 0x0000000000008000L) && ((tn1)->t & 0x0000000000080000L)) && !(((tn2)->t & 0x0000000000008000L) && ((tn2)->t & 0x0000000000080000L)))
            for (f1 = tn1->formals, f2 = tn2->formals; f1 && f2;
              f1 = f1->next, f2 = f2->next)
                if (compat(f1->type, f2->type) == 0)
                    return 0;
    }

    return (tn1 == tn2);
}












struct tnode *compose(struct tnode *type1, struct tnode *type2,
                      struct symbol *sym)
{
    struct tnode *prefix = 0;
    struct tnode *tn1, *tn2;
    struct formal *f1, *f2;

    for (tn1 = type1, tn2 = type2;
         tn1 && tn2 && (tn1 != tn2) && tnode_compat(tn1, tn2);
         tn1 = tn1->next, tn2 = tn2->next)
    {
        if (tn1->t & 0x0000000000004000L)
            prefix = new_tnode(0x0000000000004000L, (((tn1->nelem) > (tn2->nelem)) ? (tn1->nelem) : (tn2->nelem)), prefix);
        else if (tn1->t & 0x0000000000008000L) {
            if ((((tn1)->t & 0x0000000000008000L) && ((tn1)->t & 0x0000000000080000L)))
                prefix = new_tnode(tn2->t, tn2->u, prefix);
            else if ((((tn2)->t & 0x0000000000008000L) && ((tn2)->t & 0x0000000000080000L)))
                prefix = new_tnode(tn1->t, tn1->u, prefix);
            else {
                prefix = new_tnode(tn1->t, 0, prefix);

                for (f1 = tn1->formals, f2 = tn2->formals;
                  f1 && f2; f1 = f1->next, f2 = f2->next)
                    new_formal(prefix, compose(f1->type, f2->type, sym));
            }
        } else
            prefix = new_tnode(tn1->t, tn1->u, prefix);
    }

    if (tn1 != tn2)
        error(4, sym->id, "conflicting types %L", sym);

    return graft(prefix, tn1);
}






struct tnode *formal_type(struct tnode *type)
{
    if (((type)->t & 0x0000000000004000L))
        type = get_tnode(0x0000000000010000L, 0, (type->next));
    else if (((type)->t & 0x0000000000008000L))
        type = get_tnode(0x0000000000010000L, 0, (type));

    return type;
}

int t_size(long t)
{
    if (t & ( 0x0000000000000010L | 0x0000000000000020L )) return 2;
    if (t & (( 0x0000000000000040L | 0x0000000000000080L ) | 0x0000000000000400L)) return 4;
    if (t & (( 0x0000000000000100L | 0x0000000000000200L ) | 0x0000000000000800L | 0x0000000000001000L | 0x0000000000010000L)) return 8;

    return 1;
}

int size_of(struct tnode *type, struct string *id)
{
    long size = 1;

    while (type) {
        switch (((type->t) & 0x000000000001FFFFL))
        {
        case 0x0000000000004000L:
            if (type->nelem > 0)
                size *= type->nelem;
            else
                error(4, id, "incomplete array type");

            break;

        case 0x0000000000002000L:
            if (((type->tag)->s & 0x40000000))
                size *= type->tag->size;
            else
                error(4, id, "%T is incomplete", type->tag);

            break;

        case 0x0000000000000001L:    error(4, id, "illegal use of void type");
        case 0x0000000000008000L:    error(4, id, "illegal use of function type");

        default:        size *= t_size(type->t); break;
        }

        if (size > (1 << (28 - 1))) error(1, id, "type too large");
        if (type->t & 0x0000000000010000L) break;
        type = type->next;
    }

    return size;
}












int align_of(struct tnode *type)
{
    while (((type)->t & 0x0000000000004000L))
        type = type->next;

    switch (((((type)->t) & 0x000000000001FFFFL)))
    {
    case 0x0000000000002000L:   if (((((type)->tag))->s & 0x40000000))
                        return type->tag->align;

    case 0x0000000000008000L:
    case 0x0000000000000001L:    return 1;

    default:        return t_size(type->t);
    }
}












int simpatico(struct tnode *type1, struct tnode *type2)
{
    do { if (((type1)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((type2)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((((((type1)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)) == (((((type2)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0))) && (t_size(((((type1)->t) & 0x000000000001FFFFL))) == t_size(((((type2)->t) & 0x000000000001FFFFL))))) return 1; else return 0; } while (0);
}

int narrower(struct tnode *dst, struct tnode *src)
{
    do { if (((dst)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((src)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((((((dst)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)) == (((((src)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0))) && (t_size(((((dst)->t) & 0x000000000001FFFFL))) < t_size(((((src)->t) & 0x000000000001FFFFL))))) return 1; else return 0; } while (0);
}

int wider(struct tnode *dst, struct tnode *src)
{
    do { if (((dst)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((src)->t & ( ( ( ( 0x0000000000000002L | 0x0000000000000008L | 0x0000000000000004L ) | ( 0x0000000000000010L | 0x0000000000000020L ) | ( 0x0000000000000040L | 0x0000000000000080L ) | ( 0x0000000000000100L | 0x0000000000000200L ) ) | ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L ) ) | 0x0000000000010000L )) && ((((((dst)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0)) == (((((src)->t) & ( 0x0000000000000400L | 0x0000000000000800L | 0x0000000000001000L )) == 0))) && (t_size(((((dst)->t) & 0x000000000001FFFFL))) > t_size(((((src)->t) & 0x000000000001FFFFL))))) return 1; else return 0; } while (0);
}

struct tnode *fieldify(struct tnode *type, int width, int lsb)
{
    long t;

    t = ((type->t) & 0x000000000001FFFFL);
    t |= ((type->t) & 0x0000000000060000L);
    t |= 0x0000008000000000L;
    ((t) |= ((((long) (width)) << 32)));
    ((t) |= ((((long) (lsb)) << 40)));

    return get_tnode(t, 0, 0);
}

struct tnode *unfieldify(struct tnode *type)
{
    long t;

    if (type->t & 0x0000008000000000L) {
        t = ((type->t) & 0x000000000001FFFFL);
        t |= ((type->t) & 0x0000000000060000L);
        type = get_tnode(t, 0, 0);
    }

    return type;
}














void validate(struct tnode *type, struct string *id, int void_ok)
{
    struct tnode *next;

    if (((type)->t & 0x0000000000000001L) && !void_ok)
        error(4, id, "illegal use of void type");

    for (; type; type = next) {
        next = type->next;

        if (((type)->t & 0x0000000000004000L)) {




            if ((((next)->t & 0x0000000000004000L) && ((next)->nelem == 0)))
                error(4, id, "invalid array specification");

            if (((next)->t & 0x0000000000008000L)) error(4, id, "array of function");
            if (((next)->t & 0x0000000000000001L)) error(4, id, "array of void");

            if (((next)->t & 0x0000000000002000L)) {
                if (!((next->tag)->s & 0x40000000))
                    error(4, id, "array of incomplete %T", next->tag);

                if ((((next->tag)->s & 0x00000001) && ((next->tag)->s & 0x04000000)))
                    error(4, id, "array of flexible %T", next->tag);
            }
        }

        if (((type)->t & 0x0000000000008000L) && (((next)->t & 0x0000000000004000L) || ((next)->t & 0x0000000000008000L)))
            error(4, id, "functions can't return %s", ((next)->t & 0x0000000000004000L)
                                                            ? "arrays"
                                                            : "functions");
    }
}
