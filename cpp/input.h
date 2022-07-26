/*****************************************************************************

  input.h                                             tahoe/64 c preprocessor

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef INPUT_H
#define INPUT_H

#include <stdio.h>
#include <sys/queue.h>
#include "vstring.h"
#include "token.h"

/* the stack formed by the main input file and its nested #includes
   is represented by (... wait for it ...) a stack, using an SLIST. */

struct input
{
    FILE *fp;
    struct vstring path;
    int line_no;
    SLIST_ENTRY(input) link;
};

SLIST_HEAD(input_stack, input);

extern struct input_stack input_stack;

/* the top of the stack is exposed to allow access to the line_no
   and path of the topmost file, and determine when end-of-input is
   reached (when INPUT_STACK is NULL). */

#define INPUT_STACK         SLIST_FIRST(&input_stack)

typedef int input_search;   /* INPUT_SEARCH_* */

#define INPUT_SEARCH_NOWHERE    0
#define INPUT_SEARCH_SYSTEM     1
#define INPUT_SEARCH_LOCAL      2

extern void input_open(char *, input_search);
extern void input_dir(char *);

typedef int input_mode;  /* INPUT_MODE_* */

#define INPUT_MODE_THIS 0
#define INPUT_MODE_ANY  1

extern int input_tokenize(struct list *, char *);
extern int input_tokens(input_mode, struct list *);

#endif /* INPUT_H */

/* vi: set ts=4 expandtab: */
