/*****************************************************************************

  getopt.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <string.h>
#include <unistd.h>

int opterr = 1;
int optind = 1;
int optopt;
char *optarg;

int getopt(int argc, char *const argv[], const char *opts)
{
    static int sp = 1;
    int c;
    const char *cp;

    if (sp == 1)
        if ((optind >= argc) || (argv[optind][0] != '-')
          || (argv[optind][1] == '\0'))
            return EOF;
        else if (strcmp(argv[optind], "--") == 0) {
            optind++;
            return EOF;
        }

        optopt = c = argv[optind][sp];

        if (c == ':' || (cp=strchr(opts, c)) == 0) {
            if (opterr)
                fprintf(stderr, "%s: illegal option -- %c\n", argv[0], c);

            if (argv[optind][++sp] == '\0') {
            optind++;
            sp = 1;
        }

        return '?';
    }

    if (*++cp == ':') {
        if (argv[optind][sp+1] != '\0')
            optarg = &argv[optind++][sp+1];
        else if (++optind >= argc) {
            if (opterr)
                fprintf(stderr, "%s: option requires an argument -- %c\n",
                                argv[0], c);

            sp = 1;
            return '?';
        } else
            optarg = argv[optind++];

        sp = 1;
    } else {
        if (argv[optind][++sp] == '\0') {
            sp = 1;
            optind++;
        }

        optarg = 0;
    }

    return c;
}

/* vi: set ts=4 expandtab: */
