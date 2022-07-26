/*****************************************************************************

  vstring.h                                           tahoe/64 c preprocessor

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef VSTRING_H
#define VSTRING_H

#include <stddef.h>

/* we use so-called small-string optimization in representation of strings:
   a string that is small enough is kept in the struct itself to avoid the
   overhead of allocating an external buffer. this is not very portable:
   in particular, vstring_in.flag must overlap the lsb of vstring_out.cap. */

struct vstring_out
{
    size_t cap;
    size_t len;
    char *buf;
};

#define VSTRING_IN_CAP (sizeof(struct vstring_out) - 1)

struct vstring_in
{
    int flag : 1;
    int len : 7;
    char buf[VSTRING_IN_CAP];
};

struct vstring
{
    union
    {
        struct vstring_in in;
        struct vstring_out out;
    } u;
};

#define VSTRING_MIN_ALLOC (1 << 5)      /* power of 2, please */

#define VSTRING_INITIALIZER { 1 }       /* flag = 1, len/buf 0s */

/* buffers are always NUL terminated for convenience, so VSTRING_BUF()
   can be used where standard c strings are called for. */

#define VSTRING_BUF(vs) (((vs).u.in.flag) ? ((vs).u.in.buf) : ((vs).u.out.buf))
#define VSTRING_LEN(vs) (((vs).u.in.flag) ? ((vs).u.in.len) : ((vs).u.out.len))
#define VSTRING_CAP(vs) (((vs).u.in.flag) ? VSTRING_IN_CAP : ((vs).u.out.cap))

extern void vstring_clear(struct vstring *);
extern void vstring_rubout(struct vstring *);
extern void vstring_put(struct vstring *, char *, size_t);
extern void vstring_putc(struct vstring *, char);
extern void vstring_puts(struct vstring *, char *);
extern void vstring_free(struct vstring *);
extern void vstring_init(struct vstring *);
extern void vstring_concat(struct vstring *, struct vstring *);
extern char vstring_last(struct vstring *);
extern int vstring_same(struct vstring *, struct vstring *);

#endif /* VSTRING_H */

/* vi: set ts=4 expandtab: */
