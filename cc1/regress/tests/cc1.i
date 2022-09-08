# 1 "cc1.c"

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
# 21 "/home/charles/xcc/include/stdarg.h"
typedef __va_list va_list;
# 29 "/home/charles/xcc/include/stdlib.h"
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
# 20 "/home/charles/xcc/include/string.h"
extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);
extern char *strcat(char *, const char *);
extern char *strchr(const char *, int);
extern int strcmp(const char *, const char *);
extern char *strcpy(char *, const char *);
extern char *strerror(int);
extern size_t strlen(const char *);
extern char *strncat(char *, const char *, size_t);
extern int strncmp(const char *, const char *, size_t);
extern char *strncpy(char *, const char *, size_t);
extern char *strrchr(const char *, int);
# 13 "/home/charles/xcc/include/errno.h"
extern int errno;
# 24 "/home/charles/xcc/include/unistd.h"
typedef __ssize_t ssize_t;




typedef __pid_t pid_t;











extern int access(const char *, int);





extern void *__brk(void *);

extern int brk(void *);
extern void *sbrk(__ssize_t);

extern int close(int);
extern int execve(const char *, char *const [], char *const []);
extern int execvp(const char *, char *const []);
extern int execvpe(const char *, char *const [], char *const []);
extern pid_t fork(void);
extern pid_t getpid(void);
extern int isatty(int);





extern __off_t lseek(int, __off_t, int);

extern __ssize_t read(int, void *, __size_t);
extern int unlink(const char *);
extern __ssize_t write(int, const void *, __size_t);

extern char *optarg;
extern int optind;
extern int opterr;
extern int optopt;

extern int getopt(int, char *const[], const char *);
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
# 13 "init.h"
struct symbol;



void out_word(long t, union con con, struct symbol *sym);



void init_bss(struct symbol *sym);









void init_static(struct symbol *sym, int s);




void init_auto(struct symbol *sym);



void tentative(struct symbol *sym);



struct symbol *floateral(long t, double f);
# 13 "decl.h"
struct tnode;




void externals(void);



void locals(void);



struct tnode *abstract(void);
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
# 28 "cc1.c"
int last_asmlab;
char g_flag;
char w_flag;
FILE *out_f;
static char *out_path;

void out(char *fmt, ...)
{
    va_list args;

    (args = (((char *) &(fmt)) + (((sizeof(fmt)) + (8 - 1)) & ~(8 - 1))));

    while (*fmt) {
        if (*fmt != '%')
            (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (*fmt)) : __flushbuf((*fmt),(out_f)));
        else switch (*++fmt)
        {
        case 'd':   fprintf(out_f, "%d", ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'f':   fprintf(out_f, "%f", ((args += (((sizeof(double)) + (8 - 1)) & ~(8 - 1))), *((double *) (args - (((sizeof(double)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'r':   print_reg(out_f, ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1))))), 0); break;
        case 's':   fprintf(out_f, "%s", ((args += (((sizeof(char *)) + (8 - 1)) & ~(8 - 1))), *((char * *) (args - (((sizeof(char *)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'x':   fprintf(out_f, "0x%x", ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'g':   print_global(out_f, ((args += (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1))), *((struct symbol * *) (args - (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'D':   fprintf(out_f, "%ld", ((args += (((sizeof(long)) + (8 - 1)) & ~(8 - 1))), *((long *) (args - (((sizeof(long)) + (8 - 1)) & ~(8 - 1)))))); break;

        case 'G':   {
                        struct symbol *sym = ((args += (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1))), *((struct symbol * *) (args - (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1)))));
                        long i = ((args += (((sizeof(long)) + (8 - 1)) & ~(8 - 1))), *((long *) (args - (((sizeof(long)) + (8 - 1)) & ~(8 - 1)))));

                        if (sym) {
                            print_global(out_f, sym);
                            if (i) fprintf(out_f, "%+ld", i);
                        } else
                            fprintf(out_f, "%ld", i);

                        break;
                    }

        case 'L':   fprintf(out_f, "L%d", ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))))); break;

        case 'R':   {
                        int reg = ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))));
                        int t = ((args += (((sizeof(long)) + (8 - 1)) & ~(8 - 1))), *((long *) (args - (((sizeof(long)) + (8 - 1)) & ~(8 - 1)))));

                        print_reg(out_f, reg, t);
                        break;
                    }

        case 'S':   {
                        struct string *s = ((args += (((sizeof(struct string *)) + (8 - 1)) & ~(8 - 1))), *((struct string * *) (args - (((sizeof(struct string *)) + (8 - 1)) & ~(8 - 1)))));
                        fprintf(out_f, "%.*s", (s)->len, (s)->text);
                        break;
                    }

        case 'X':   fprintf(out_f, "0x%lx", ((args += (((sizeof(long)) + (8 - 1)) & ~(8 - 1))), *((long *) (args - (((sizeof(long)) + (8 - 1)) & ~(8 - 1)))))); break;

        default:


                    (--(out_f)->_count >= 0 ? (int) (*(out_f)->_ptr++ = (*fmt)) : __flushbuf((*fmt),(out_f)));
        }

        ++fmt;
    }

    ;
}

void seg(int newseg)
{
    static int curseg;

    if (newseg != curseg) {
        fputs((newseg == 1) ? ".text\n" : ".data\n", out_f);
        curseg = newseg;
    }
}

void error(int level, struct string *id, char *fmt, ...)
{
    static const char *errors[] = {     "WARNING",
                                        "SORRY",
                                        "SYSTEM ERROR",
                                        "INTERNAL ERROR",
                                        "ERROR"             };

    va_list args;

    if ((level == 0) && !w_flag)
        return;

    if (path) {
        fprintf((&__stderr), "%.*s", (path)->len, (path)->text);
        if (line_no) fprintf((&__stderr), " (%d)", line_no);
        fprintf((&__stderr), ": ");
    }

    fprintf((&__stderr), "%s: ", errors[level]);
    if (id) fprintf((&__stderr), "`" "%.*s" "': ", (id)->len, (id)->text);

    (args = (((char *) &(fmt)) + (((sizeof(fmt)) + (8 - 1)) & ~(8 - 1))));

    while (*fmt) {
        if (*fmt != '%')
            (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = (*fmt)) : __flushbuf((*fmt),((&__stderr))));
        else switch (*++fmt)
        {
        case 'd':   fprintf((&__stderr), "%d", ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'k':   print_k((&__stderr), ((args += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (args - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))))); break;

        case 'q':   {
                        long quals = ((args += (((sizeof(long)) + (8 - 1)) & ~(8 - 1))), *((long *) (args - (((sizeof(long)) + (8 - 1)) & ~(8 - 1)))));

                        fprintf((&__stderr), "`%s%s%s` qualifier%s",
                            (quals & 0x0000000000020000L) ? "const" : "",
                            (quals == (0x0000000000020000L | 0x0000000000040000L)) ? " " : "",
                            (quals & 0x0000000000040000L) ? "volatile" : "",
                            (quals == (0x0000000000020000L | 0x0000000000040000L)) ? "s" : "");

                        break;
                    }

        case 's':   fprintf((&__stderr), "%s", ((args += (((sizeof(char *)) + (8 - 1)) & ~(8 - 1))), *((char * *) (args - (((sizeof(char *)) + (8 - 1)) & ~(8 - 1)))))); break;
        case 'K':   print_token((&__stderr), ((args += (((sizeof(struct token *)) + (8 - 1)) & ~(8 - 1))), *((struct token * *) (args - (((sizeof(struct token *)) + (8 - 1)) & ~(8 - 1)))))); break;

        case 'L':   {
                        struct symbol *sym = ((args += (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1))), *((struct symbol * *) (args - (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1)))));

                        if (((sym)->s & 0x80000000)) {
                            fputs("(built-in)", (&__stderr));
                            break;
                        }

                        fprintf((&__stderr), "(%s ",
                                        ((sym)->s & 0x40000000) ? "defined"
                                                            : "first seen");

                        if (sym->path != path)
                            fprintf((&__stderr), "in `" "%.*s" "' ",
                                        (sym->path)->len, (sym->path)->text);

                        fprintf((&__stderr), "at line %d)", sym->line_no);
                        break;
                    }

        case 'S':   {
                        struct string *s = ((args += (((sizeof(struct string *)) + (8 - 1)) & ~(8 - 1))), *((struct string * *) (args - (((sizeof(struct string *)) + (8 - 1)) & ~(8 - 1)))));

                        fprintf((&__stderr), "%.*s", (s)->len, (s)->text);
                        break;
                    }

        case 'T':   {
                        struct symbol *sym = ((args += (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1))), *((struct symbol * *) (args - (((sizeof(struct symbol *)) + (8 - 1)) & ~(8 - 1)))));

                        switch (((sym->s) & 0x00001FFF))
                        {
                        case 0x00000001:  fputs("struct", (&__stderr)); break;
                        case 0x00000002:   fputs("union", (&__stderr)); break;
                        case 0x00000004:    fputs("enum", (&__stderr)); break;
                        }

                        if (sym->id) fprintf((&__stderr), " `" "%.*s" "'",
                                                     (sym->id)->len, (sym->id)->text);

                        break;
                    }

        case '%':   (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('%')) : __flushbuf(('%'),((&__stderr))));
        }

        ++fmt;
    }

    if (level == 2) fprintf((&__stderr), " (%s)", strerror(errno));
    (--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
    ;

    if (level > 0) {
        if (out_f) {
            fclose(out_f);
            unlink(out_path);
        }

        exit(1);
    }
}

int main(int argc, char **argv)
{
    int opt;

    while ((opt = getopt(argc, argv, "gkw")) != -1) {
        switch (opt)
        {
        case 'g':   g_flag = 1; break;
        case 'w':   w_flag = 1; break;
        case '?':   goto usage;
        }
    }

    argc -= optind;
    argv += optind;
    if (argc != 2) goto usage;
    out_path = argv[1];

    if ((out_f = fopen(out_path, "w")) == 0)
        error(2, 0, "can't open output `%s'", out_path);

    init_arenas();
    seed_types();
    enter_scope(0);
    seed_keywords();
    init_lex(argv[0]);
    externals();
    out_literals();
    walk_scope(1, 0x10000000, tentative);
    out_globls();

    fclose(out_f);
    return 0;

usage:
    fprintf((&__stderr), "usage: cc1 [ -gw ] input output\n");
    return -1;
}
