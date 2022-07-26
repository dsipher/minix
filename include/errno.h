/*****************************************************************************

  errno.h                                           tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _ERRNO_H
#define _ERRNO_H

extern int errno;

#define ENOMEM      12      /* out of memory */
#define ENOTTY      25      /* not a typewriter */
#define EDOM        33      /* math argument out of domain of func */
#define ERANGE      34      /* math result not representable */

#endif /* _ERRNO_H */

/* vi: set ts=4 expandtab: */
