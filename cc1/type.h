/*****************************************************************************

  type.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef TYPE_H
#define TYPE_H

struct string;

/* type bits (T_*) are used to represent fundamental types and modifiers.
   by convention, we call variables with a single base bit t. where multiple
   base bits are allowed (to, e.g., match sets of types), we call them ts.

   the base bits are not arbitrarily positioned or ordered. many parts of
   the compiler are sensitive to their values and/or indices as mapped by
   T_INDEX_BASE() <-> T_BASE_INDEX(). (for example see usuals() in expr.c) */

#define T_VOID              0x0000000000000001L
#define T_CHAR              0x0000000000000002L
#define T_SCHAR             0x0000000000000004L
#define T_UCHAR             0x0000000000000008L
#define T_SHORT             0x0000000000000010L
#define T_USHORT            0x0000000000000020L
#define T_INT               0x0000000000000040L
#define T_UINT              0x0000000000000080L
#define T_LONG              0x0000000000000100L
#define T_ULONG             0x0000000000000200L
#define T_FLOAT             0x0000000000000400L
#define T_DOUBLE            0x0000000000000800L
#define T_LDOUBLE           0x0000000000001000L

#define T_STRUN             0x0000000000002000L
#define T_ARRAY             0x0000000000004000L
#define T_FUNC              0x0000000000008000L
#define T_PTR               0x0000000000010000L

#define T_BASE_BITS         17
#define T_BASE_MASK         0x000000000001FFFFL
#define T_BASE(t)           ((t) & T_BASE_MASK)

#define T_ANY               T_BASE_MASK

#define T_BASE_INDEX(t)     __builtin_ctzl(T_BASE(t))
#define T_INDEX_BASE(i)     (1L << (i))

#define T_INDEX_VOID        0       /* must map to T_BASE_INDEX() */
#define T_INDEX_CHAR        1       /* of base bits defined above */
#define T_INDEX_SCHAR       2
#define T_INDEX_UCHAR       3
#define T_INDEX_SHORT       4
#define T_INDEX_USHORT      5
#define T_INDEX_INT         6
#define T_INDEX_UINT        7
#define T_INDEX_LONG        8
#define T_INDEX_ULONG       9
#define T_INDEX_FLOAT       10
#define T_INDEX_DOUBLE      11
#define T_INDEX_LDOUBLE     12
#define T_INDEX_STRUN       13
#define T_INDEX_ARRAY       14
#define T_INDEX_FUNC        15
#define T_INDEX_PTR         16

#define T_INDEX_BITS        5       /* 0 .. 16 is 5 bits */
#define T_INDEX_MASK        0x1F

#define T_CONST             0x0000000000020000L
#define T_VOLATILE          0x0000000000040000L

#define T_QUAL_MASK         0x0000000000060000L
#define T_QUALS(t)          ((t) & T_QUAL_MASK)
#define T_UNQUAL(t)         ((t) & ~T_QUAL_MASK)

#define T_OLD_STYLE         0x0000000000080000L     /* old-style function */
#define T_VARIADIC          0x0000000000100000L     /* variadic function */

    /* if T_FIELD is set, then this is a bitfield. these only appear in the
       types of struct members and children of E_FETCH trees. the base must
       be integral, and indicates the size of the host word and signedness
       of the field. width and lsb tell us where in that word the field is.

       these descriptors of bitfields are clearly bitfields themselves...
       so meta. ironically, we don't define them as proper bitfields, but
       manually. this allows us to identify a tnode by (t, u, next) tuple. */

#define T_FIELD             0x0000008000000000L

#define T_WIDTH_MASK        0x0000007F00000000L     /* 0 .. 64 */
#define T_WIDTH_SHIFT       32
#define T_GET_WIDTH(t)      (((t) & T_WIDTH_MASK) >> T_WIDTH_SHIFT)
#define T_SET_WIDTH(t, w)   ((t) |= ((((long) (w)) << T_WIDTH_SHIFT)))

#define T_LSB_MASK          0x00003F0000000000L     /* 0 .. 63 */
#define T_LSB_SHIFT         40
#define T_GET_LSB(t)        (((t) & T_LSB_MASK) >> T_LSB_SHIFT)
#define T_SET_LSB(t, l)     ((t) |= ((((long) (l)) << T_LSB_SHIFT)))

    /* useful type classes */

#define T_CHARS             ( T_CHAR | T_UCHAR | T_SCHAR )
#define T_SHORTS            ( T_SHORT | T_USHORT )
#define T_INTS              ( T_INT | T_UINT )
#define T_LONGS             ( T_LONG | T_ULONG )
#define T_SIGNED            ( T_CHAR | T_SCHAR | T_SHORT | T_INT | T_LONG)
#define T_UNSIGNED          ( T_UCHAR | T_USHORT | T_UINT | T_ULONG )
#define T_INTEGRAL          ( T_CHARS | T_SHORTS | T_INTS | T_LONGS )
#define T_FLOATING          ( T_FLOAT | T_DOUBLE | T_LDOUBLE )
#define T_ARITH             ( T_INTEGRAL | T_FLOATING )
#define T_DISCRETE          ( T_INTEGRAL | T_PTR )
#define T_SCALAR            ( T_ARITH | T_PTR )

    /* we divide fundamental types into cast classes, such that casting
       between values in the same class is a change of interpretation as
       opposed to a real conversion. this is a long-winded way of saying
       that floating-point types are in one class, discrete types another.
       (casts only happen between scalars, so there are no other options) */

#define T_CAST_CLASS(t)     (((t) & T_FLOATING) == 0)

/* return the size of a fundamental type, T_CHAR .. T_LDOUBLE. all types are
   aligned 'naturally', so (by definition) the size is also the alignment. */

int t_size(long t);

/* types are represented by sequences of type nodes (tnodes). a proper type
   is a pointer to a tnode in the tnode forest, and following the next links
   of a type is a traversal down a branch to the root of a tree. all tnodes
   in the forest are hashed for quick lookup, and are immutable and immortal.

   in isolated cases -- when building or manipulating types -- 'prefixes' are
   used. prefixes are sequences of tnodes that are NOT in the forest, and they
   are linked together in reverse order, which turns out to be convenient. */

struct tnode
{
    long t;                 /* T_* */
    unsigned long hash;     /* keep this unsigned */

    union
    {
        long u;             /* universal handle for the union value */

        int nelem;                  /* T_ARRAY: # elements, 0 == unbounded */
        struct symbol *tag;         /* T_STRUN: S_STRUCT/S_UNION symbol */
        struct formal *formals;     /* T_FUNC: types of formal arguments */
    };

    struct tnode *next;     /* in this type/prefix */
    struct tnode *link;     /* in the forest hash */
};

struct formal { struct tnode *type; struct formal *next; };

/* handy predefined type nodes. seed_types() must
   be called to insert these into the forest. */

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

/* given a set of K_SPEC_* bits in ks, return the
   associated c type, or abort with an error */

struct tnode *map_type(int ks);

/* allocate a new tnode as described. if allocating a T_FUNC tnode,
   then any formals are duplicated for the new tnode, thus this can
   safely be used to copy a tnode. tnodes allocated are not added to
   the forest; they should be prepended to a prefix. */

struct tnode *new_tnode(long t, long u, struct tnode *next);

/* append a new formal of the given type to a tnode. */

void new_formal(struct tnode *tn, struct tnode *type);

/* graft a prefix into the tnode forest at type.
   returns the new type. the prefix is destroyed. */

struct tnode *graft(struct tnode *prefix, struct tnode *type);

/* find a tnode in the forest hash. if it does not exist, create it.
   should NOT be used for t == T_FUNC as we do not account for formals */

struct tnode *get_tnode(long t, long u, struct tnode *next);

#define PTR(type)                       get_tnode(T_PTR, 0, (type))
#define DEREF(type)                     ((type)->next)

#define TYPE_BASE(type)                 (T_BASE((type)->t))
#define TYPE_QUALS(type)                (T_QUALS((type)->t))
#define TYPE_CAST_CLASS(type)           (T_CAST_CLASS((type)->t))

#define SAME_CAST_CLASS(type1, type2)   (TYPE_CAST_CLASS(type1)             \
                                         == TYPE_CAST_CLASS(type2))

#define CONST_TYPE(type)                (TYPE_QUALS(type) & T_CONST)
#define VOLATILE_TYPE(type)             (TYPE_QUALS(type) & T_VOLATILE)

#define PTR_TYPE(type)                  ((type)->t & T_PTR)
#define FLOAT_TYPE(type)                ((type)->t & T_FLOAT)
#define FIELD_TYPE(type)                ((type)->t & T_FIELD)
#define ARRAY_TYPE(type)                ((type)->t & T_ARRAY)
#define ARITH_TYPE(type)                ((type)->t & T_ARITH)
#define VOID_TYPE(type)                 ((type)->t & T_VOID)
#define SCALAR_TYPE(type)               ((type)->t & T_SCALAR)
#define INTEGRAL_TYPE(type)             ((type)->t & T_INTEGRAL)
#define FLOATING_TYPE(type)             ((type)->t & T_FLOATING)
#define CHARS_TYPE(type)                ((type)->t & T_CHARS)
#define SHORTS_TYPE(type)               ((type)->t & T_SHORTS)
#define STRUN_TYPE(type)                ((type)->t & T_STRUN)
#define FUNC_TYPE(type)                 ((type)->t & T_FUNC)
#define DISCRETE_TYPE(type)             ((type)->t & T_DISCRETE)
#define SIGNED_TYPE(type)               ((type)->t & T_SIGNED)
#define UNSIGNED_TYPE(type)             ((type)->t & T_UNSIGNED)
#define UINT_TYPE(type)                 ((type)->t & T_UINT)
#define ULONG_TYPE(type)                ((type)->t & T_ULONG)

#define FIELD_WIDTH(type)               (T_GET_WIDTH((type)->t))
#define FIELD_LSB(type)                 (T_GET_LSB((type)->t))

#define STRUN_TAG(type)                 ((type)->tag)

#define STRUN_PTR_TYPE(type)            (PTR_TYPE(type) &&                  \
                                         STRUN_TYPE(DEREF(type)))

#define VOID_PTR_TYPE(type)             (PTR_TYPE(type) &&                  \
                                         VOID_TYPE(DEREF(type)))

#define FUNC_PTR_TYPE(type)             (PTR_TYPE(type) &&                  \
                                         FUNC_TYPE(DEREF(type)))

#define VOLATILE_PTR_TYPE(type)         (PTR_TYPE(type) &&                  \
                                         VOLATILE_TYPE(DEREF(type)))

#define UNBOUNDED_ARRAY_TYPE(type)      (ARRAY_TYPE(type) &&                \
                                         ((type)->nelem == 0))

#define CHAR_ARRAY_TYPE(type)           (ARRAY_TYPE(type) &&                \
                                         CHARS_TYPE(DEREF(type)))

#define ANONYMOUS_STRUN_TYPE(type)      (STRUN_TYPE(type) &&                \
                                         ((type)->tag->id == 0))

#define FLEXIBLE_STRUN_TYPE(type)       (STRUN_TYPE(type) &&                \
                                         ((type)->tag->s & S_FLEXIBLE))

#define IMMUTABLE_TYPE(type)            (CONST_TYPE(type) ||                \
                                         (STRUN_TYPE(type) &&               \
                                         (STRUN_TAG(type)->s & S_IMMUTABLE)))

#define OLD_STYLE_FUNC(type)            (FUNC_TYPE(type) &&                 \
                                         ((type)->t & T_OLD_STYLE))

#define VARIADIC_FUNC(type)             (FUNC_TYPE(type) &&                 \
                                         ((type)->t & T_VARIADIC))

#define VARIADIC_FUNC_PTR(type)         (FUNC_PTR_TYPE(type) &&             \
                                         VARIADIC_FUNC(DEREF(type)))

/* return type with added qualifiers, or
   stripped of any top-level qualifiers */

struct tnode *qualify(struct tnode *type, long quals);
struct tnode *unqualify(struct tnode *type);

/* returns true if two types are compatible (C89 6.1.2.6) */

int compat(struct tnode *type1, struct tnode *type2);

/* return the composition of two types. bomb with an error if
   they're not compatible: sym is solely for the error message */

struct tnode *compose(struct tnode *type1, struct tnode *type2,
                      struct symbol *sym);

/* return the actual type of a formal argument declared as type */

struct tnode *formal_type(struct tnode *type);

/* convert a type into a bitfield as specified. caller must
   be sure type is integral, and width and lsb make sense. */

struct tnode *fieldify(struct tnode *type, int width, int lsb);

/* given a type, return an equivalent type which is not a
   bitfield. for non-bitfields this is obviously a no-op. */

struct tnode *unfieldify(struct tnode *type);

/* return the size of a type, in bytes. abort if the type is
   incomplete or has no size. id is for error reporting only. */

int size_of(struct tnode *type, struct string *id);

/* return the alignment of a type, in bytes. returns byte alignment (1) for
   incomplete types (including void), which is worst-case for block insns. */

int align_of(struct tnode *type);

/* returns true if two types are the same, or differ only conceptually.
   types 'differ only conceptually' if casts between them are no-ops. */

#define T_SIMPATICO(t1, t2)         (((t1) & T_SCALAR)                      \
                                &&  ((t2) & T_SCALAR)                       \
                                &&  (((t1) == (t2))  /* short cut */        \
                                ||  ((T_CAST_CLASS(t1) == T_CAST_CLASS(t2)) \
                                &&  (t_size(t1) == t_size(t2)))))

int simpatico(struct tnode *type1, struct tnode *type2);

/* returns true if the dst type is a narrower (wider) version of the
   src type, that is in the same cast class but with fewer (more) bits */

int narrower(struct tnode *dst, struct tnode *src);
int wider(struct tnode *dst, struct tnode *src);

/* make sure the type is semantically valid. bombs with an error if not.
   if id is not 0, the id is cited in any error message- it is otherwise
   unused. void_ok is a flag: non-zero means naked void type is permitted. */

void validate(struct tnode *type, struct string *id, int void_ok);

#ifdef DEBUG

/* print a type in human-readable format to stderr */

void dump_type(struct tnode *type);

/* print the entire tnode forest to stderr */

void dump_forest(void);

#endif /* DEBUG */

#endif /* TYPE_H */

/* vi: set ts=4 expandtab: */
