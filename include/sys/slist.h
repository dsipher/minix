/*****************************************************************************

  sys/slist.h                                       tahoe/64 standard library

       Copyright (c) 1991, 1993, The Regents of the University of California.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_SLIST_H
#define _SYS_SLIST_H

/* a singly-linked list is headed by a single forward pointer. the
   elements are singly linked for minimum space and pointer manipulation
   overhead at the expense of O(n) removal for arbitrary elements. new
   elements can be added to the list after an existing element or at the
   head of the list. elements being removed from the head of the list
   should use the explicit macro for this purpose for optimum
   efficiency. a singly-linked list may only be traversed in the forward
   direction. singly-linked lists are ideal for applications with large
   datasets and few or no removals or for implementing a LIFO queue. */

#define SLIST_HEAD(name, type)                                          \
    struct name {                                                       \
        struct type *slh_first; /* first element */                     \
    }

#define SLIST_HEAD_INITIALIZER(head)    { 0 }

#define SLIST_ENTRY(type)                                               \
    struct {                                                            \
        struct type *sle_next;  /* next element */                      \
    }

#define SLIST_INIT(head)                                                \
    do {                                                                \
        (head)->slh_first = NULL;                                       \
    } while (0)

#define SLIST_INSERT_AFTER(slistelm, elm, field)                        \
    do {                                                                \
        (elm)->field.sle_next = (slistelm)->field.sle_next;             \
        (slistelm)->field.sle_next = (elm);                             \
    } while (0)

#define SLIST_INSERT_HEAD(head, elm, field)                             \
    do {                                                                \
        (elm)->field.sle_next = (head)->slh_first;                      \
        (head)->slh_first = (elm);                                      \
    } while (0)

#define SLIST_REMOVE_HEAD(head, field)                                  \
    do {                                                                \
        (head)->slh_first = (head)->slh_first->field.sle_next;          \
    } while (0)

#define SLIST_REMOVE(head, elm, type, field)                            \
    do {                                                                \
        if ((head)->slh_first == (elm)) {                               \
            SLIST_REMOVE_HEAD((head), field);                           \
        }                                                               \
        else {                                                          \
            struct type *curelm = (head)->slh_first;                    \
            while(curelm->field.sle_next != (elm))                      \
                curelm = curelm->field.sle_next;                        \
            curelm->field.sle_next =                                    \
              curelm->field.sle_next->field.sle_next;                   \
        }                                                               \
    } while (0)

#define SLIST_EMPTY(head)       ((head)->slh_first == NULL)
#define SLIST_FIRST(head)       ((head)->slh_first)
#define SLIST_NEXT(elm, field)  ((elm)->field.sle_next)

#define SLIST_FOREACH(var, head, field)                                 \
    for((var) = (head)->slh_first; (var); (var) = (var)->field.sle_next)

#endif /* _SYS_SLIST_H */

/* vi: set ts=4 expandtab: */
