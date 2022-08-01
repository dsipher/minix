/*****************************************************************************

  sys/list.h                                        tahoe/64 standard library

       Copyright (c) 1991, 1993, The Regents of the University of California.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_LIST_H
#define _SYS_LIST_H

/* a list is headed by a single forward pointer (or an array of forward
   pointers for a hash table header). the elements are doubly linked so
   that an arbitrary element can be removed without a need to traverse
   the list. New elements can be added to the list before or after an
   existing element or at the head of the list. a list may only be
   traversed in the forward direction. */

#define LIST_HEAD(name, type)                                               \
    struct name {                                                           \
        struct type *lh_first;  /* first element */                         \
    }

#define LIST_HEAD_INITIALIZER(head)     { 0 }

#define LIST_ENTRY(type)                                                    \
    struct {                                                                \
        struct type *le_next;   /* next element */                          \
        struct type **le_prev;  /* address of previous next element */      \
    }

#define LIST_INIT(head)                                                     \
    do {                                                                    \
        (head)->lh_first = 0;                                               \
    } while (0)

#define LIST_INSERT_AFTER(listelm, elm, field)                              \
    do {                                                                    \
        if (((elm)->field.le_next = (listelm)->field.le_next) != 0)         \
            (listelm)->field.le_next->field.le_prev =                       \
                &(elm)->field.le_next;                                      \
        (listelm)->field.le_next = (elm);                                   \
        (elm)->field.le_prev = &(listelm)->field.le_next;                   \
    } while (0)

#define LIST_INSERT_BEFORE(listelm, elm, field)                             \
    do {                                                                    \
        (elm)->field.le_prev = (listelm)->field.le_prev;                    \
        (elm)->field.le_next = (listelm);                                   \
        *(listelm)->field.le_prev = (elm);                                  \
        (listelm)->field.le_prev = &(elm)->field.le_next;                   \
    } while (0)

#define LIST_INSERT_HEAD(head, elm, field)                                  \
    do {                                                                    \
        if (((elm)->field.le_next = (head)->lh_first) != 0)                 \
            (head)->lh_first->field.le_prev = &(elm)->field.le_next;        \
        (head)->lh_first = (elm);                                           \
        (elm)->field.le_prev = &(head)->lh_first;                           \
    } while (0)

#define LIST_REMOVE(elm, field)                                             \
    do {                                                                    \
        if ((elm)->field.le_next != 0)                                      \
            (elm)->field.le_next->field.le_prev =                           \
                (elm)->field.le_prev;                                       \
        *(elm)->field.le_prev = (elm)->field.le_next;                       \
    } while (0)

#define LIST_FOREACH(var, head, field)                                      \
    for ((var) = ((head)->lh_first);                                        \
        (var);                                                              \
        (var) = ((var)->field.le_next))

#define LIST_EMPTY(head)            ((head)->lh_first == 0)
#define LIST_FIRST(head)            ((head)->lh_first)
#define LIST_NEXT(elm, field)       ((elm)->field.le_next)

#endif /* _SYS_LIST_H */

/* vi: set ts=4 expandtab: */
