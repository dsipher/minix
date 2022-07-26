/*****************************************************************************

  stdlib.h                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _STDLIB_H
#define _STDLIB_H

#include <sys/tahoe.h>

#define NULL        __NULL

#ifndef __SIZE_T
#define __SIZE_T
typedef __size_t size_t;
#endif /* __SIZE_T */

#define WEXITSTATUS     __WEXITSTATUS
#define WIFEXITED       __WIFEXITED
#define WIFSTOPPED      __WIFSTOPPED
#define WIFSIGNALED     __WIFSIGNALED
#define WSTOPSIG        __WSTOPSIG
#define WTERMSIG        __WTERMSIG

extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));

/* __exit() is the system call; exit() ties up the
   library's loose ends before calling __exit(). */

#define EXIT_SUCCESS    0
#define EXIT_FAILURE    1

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

#define RAND_MAX    32767

extern int rand(void);
extern void srand(unsigned);

#endif /* _STDLIB_H */

/* vi: set ts=4 expandtab: */
