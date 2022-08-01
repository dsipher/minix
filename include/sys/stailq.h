/*****************************************************************************

  sys/stailq.h                                      tahoe/64 standard library

       Copyright (c) 1991, 1993, The Regents of the University of California.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_STAILQ_H
#define _SYS_STAILQ_H

/* a singly-linked tail queue is headed by a pair of pointers, one to the
   head of the list and the other to the tail of the list. the elements are
   singly linked for minimum space and pointer manipulation overhead at the
   expense of O(n) removal for arbitrary elements. new elements can be added
   to the list after an existing element, at the head of the list, or at the
   end of the list. elements being removed from the head of the tail queue
   should use the explicit macro for this purpose for optimum efficiency.
   a singly-linked tail queue may only be traversed in the forward direction.
   singly-linked tail queues are ideal for applications with large datasets
   and few or no removals or for implementing a FIFO queue. */

#define STAILQ_HEAD(name, type)                                             \
    struct name {                                                           \
        struct type *stqh_first;    /* first element */                     \
        struct type **stqh_last;    /* addr of last next element */         \
    }

#define STAILQ_HEAD_INITIALIZER(head) { 0, &(head).stqh_first }

#define STAILQ_ENTRY(type)                                                  \
    struct {                                                                \
        struct type *stqe_next; /* next element */                          \
    }

#define STAILQ_INIT(head)                                                   \
    do {                                                                    \
        (head)->stqh_first = 0;                                             \
        (head)->stqh_last = &(head)->stqh_first;                            \
    } while (0)

#define STAILQ_INSERT_HEAD(head, elm, field)                                \
    do {                                                                    \
        if (((elm)->field.stqe_next = (head)->stqh_first) == 0)             \
            (head)->stqh_last = &(elm)->field.stqe_next;                    \
        (head)->stqh_first = (elm);                                         \
    } while (0)

#define STAILQ_INSERT_TAIL(head, elm, field)                                \
    do {                                                                    \
        (elm)->field.stqe_next = 0;                                         \
        *(head)->stqh_last = (elm);                                         \
        (head)->stqh_last = &(elm)->field.stqe_next;                        \
    } while (0)

#define STAILQ_INSERT_AFTER(head, listelm, elm, field)                      \
    do {                                                                    \
        if (((elm)->field.stqe_next = (listelm)->field.stqe_next) == 0)     \
            (head)->stqh_last = &(elm)->field.stqe_next;                    \
        (listelm)->field.stqe_next = (elm);                                 \
    } while (0)

#define STAILQ_REMOVE_HEAD(head, field)                                     \
    do {                                                                    \
        if (((head)->stqh_first = (head)->stqh_first->field.stqe_next) == 0)\
            (head)->stqh_last = &(head)->stqh_first;                        \
    } while (0)

#define STAILQ_REMOVE(head, elm, type, field)                               \
    do {                                                                    \
        if ((head)->stqh_first == (elm)) {                                  \
            STAILQ_REMOVE_HEAD((head), field);                              \
        } else {                                                            \
            struct type *curelm = (head)->stqh_first;                       \
            while (curelm->field.stqe_next != (elm))                        \
                curelm = curelm->field.stqe_next;                           \
            if ((curelm->field.stqe_next =                                  \
                curelm->field.stqe_next->field.stqe_next) == 0)             \
                    (head)->stqh_last = &(curelm)->field.stqe_next;         \
        }                                                                   \
    } while (0)

#define STAILQ_FOREACH(var, head, field)                                    \
    for ((var) = ((head)->stqh_first);                                      \
        (var);                                                              \
        (var) = ((var)->field.stqe_next))

#define STAILQ_CONCAT(head1, head2)                                         \
    do {                                                                    \
        if (!STAILQ_EMPTY((head2))) {                                       \
            *(head1)->stqh_last = (head2)->stqh_first;                      \
            (head1)->stqh_last = (head2)->stqh_last;                        \
            STAILQ_INIT((head2));                                           \
        }                                                                   \
    } while (0)

#define STAILQ_EMPTY(head)          ((head)->stqh_first == 0)
#define STAILQ_FIRST(head)          ((head)->stqh_first)
#define STAILQ_NEXT(elm, field)     ((elm)->field.stqe_next)

#endif /* _SYS_STAILQ_H */

/* vi: set ts=4 expandtab: */
