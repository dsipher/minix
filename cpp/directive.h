/*****************************************************************************

  directive.h                                         tahoe/64 c preprocessor

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef DIRECTIVE_H
#define DIRECTIVE_H

#include "token.h"

extern void directive(struct list *);
extern void directive_check(void);

#endif /* DIRECTIVE_H */

/* vi: set ts=4 expandtab: */
