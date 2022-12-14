/*****************************************************************************

   sys/tailq.h                                         minix system header

******************************************************************************

   Copyright (c) 1991, 1993, The Regents of the University of California.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   * Neither the name of the University nor the names of its contributors
     may be used to endorse or promote products derived from this software
     without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
   ANY EXPRESS OR IMPLIED WARRANTIES,  INCLUDING,  BUT NOT LIMITED TO, THE
   IMPLIED  WARRANTIES  OF  MERCHANTABILITY AND  FITNESS FOR  A PARTICULAR
   PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS  OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT,  INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING,  BUT NOT  LIMITED TO,  PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
   THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#ifndef _SYS_TAILQ_H
#define _SYS_TAILQ_H

/* a tail queue is headed by a pair of pointers, one to the head of the
   list and the other to the tail of the list. the elements are doubly
   linked so that an arbitrary element can be removed without a need to
   traverse the list. new elements can be added to the list before or
   after an existing element, at the head of the list, or at the end of
   the list. a tail queue may be traversed in either direction. */

#define TAILQ_HEAD(name, type)                                          \
    struct name {                                                       \
        struct type *tqh_first;         /* first element */             \
        struct type **tqh_last;         /* addr of last next element */ \
    }

#define TAILQ_HEAD_INITIALIZER(head)    { 0, &(head).tqh_first }

#define TAILQ_ENTRY(type)                                               \
    struct {                                                            \
        struct type *tqe_next;          /* next element */              \
        struct type **tqe_prev; /* address of previous next element */  \
    }

#define TAILQ_INIT(head)                                                \
    do {                                                                \
        (head)->tqh_first = 0;                                          \
        (head)->tqh_last = &(head)->tqh_first;                          \
    } while (0)

#define TAILQ_INSERT_HEAD(head, elm, field)                             \
    do {                                                                \
        if (((elm)->field.tqe_next = (head)->tqh_first) != 0)           \
            (head)->tqh_first->field.tqe_prev =                         \
                &(elm)->field.tqe_next;                                 \
        else                                                            \
            (head)->tqh_last = &(elm)->field.tqe_next;                  \
        (head)->tqh_first = (elm);                                      \
        (elm)->field.tqe_prev = &(head)->tqh_first;                     \
    } while (0)

#define TAILQ_INSERT_TAIL(head, elm, field)                             \
    do {                                                                \
        (elm)->field.tqe_next = 0;                                      \
        (elm)->field.tqe_prev = (head)->tqh_last;                       \
        *(head)->tqh_last = (elm);                                      \
        (head)->tqh_last = &(elm)->field.tqe_next;                      \
    } while (0)

#define TAILQ_INSERT_AFTER(head, listelm, elm, field)                   \
    do {                                                                \
        if (((elm)->field.tqe_next = (listelm)->field.tqe_next) != 0)   \
            (elm)->field.tqe_next->field.tqe_prev =                     \
                &(elm)->field.tqe_next;                                 \
        else                                                            \
            (head)->tqh_last = &(elm)->field.tqe_next;                  \
        (listelm)->field.tqe_next = (elm);                              \
        (elm)->field.tqe_prev = &(listelm)->field.tqe_next;             \
    } while (0)

#define TAILQ_INSERT_BEFORE(listelm, elm, field)                        \
    do {                                                                \
        (elm)->field.tqe_prev = (listelm)->field.tqe_prev;              \
        (elm)->field.tqe_next = (listelm);                              \
        *(listelm)->field.tqe_prev = (elm);                             \
        (listelm)->field.tqe_prev = &(elm)->field.tqe_next;             \
    } while (0)

#define TAILQ_REMOVE(head, elm, field)                                  \
    do {                                                                \
        if (((elm)->field.tqe_next) != 0)                               \
            (elm)->field.tqe_next->field.tqe_prev =                     \
                (elm)->field.tqe_prev;                                  \
        else                                                            \
            (head)->tqh_last = (elm)->field.tqe_prev;                   \
        *(elm)->field.tqe_prev = (elm)->field.tqe_next;                 \
    } while (0)

#define TAILQ_CONCAT(head1, head2, field)                               \
    do {                                                                \
        if (!TAILQ_EMPTY(head2)) {                                      \
            *(head1)->tqh_last = (head2)->tqh_first;                    \
            (head2)->tqh_first->field.tqe_prev = (head1)->tqh_last;     \
            (head1)->tqh_last = (head2)->tqh_last;                      \
            TAILQ_INIT((head2));                                        \
        }                                                               \
    } while (0)

#define TAILQ_EMPTY(head)               ((head)->tqh_first == 0)
#define TAILQ_FIRST(head)               ((head)->tqh_first)
#define TAILQ_NEXT(elm, field)          ((elm)->field.tqe_next)

#define TAILQ_LAST(head, headname) \
    (*(((struct headname *)((head)->tqh_last))->tqh_last))
#define TAILQ_PREV(elm, headname, field) \
    (*(((struct headname *)((elm)->field.tqe_prev))->tqh_last))

#define TAILQ_FOREACH(var, head, field)                                 \
    for ((var) = ((head)->tqh_first);                                   \
        (var);                                                          \
        (var) = ((var)->field.tqe_next))

#endif /* _SYS_TAILQ_H */

/* vi: set ts=4 expandtab: */
