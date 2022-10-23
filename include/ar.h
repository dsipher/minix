/*****************************************************************************

   ar.h                                                ux/64 system header

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from UNIX (Seventh Edition), which is in the public domain.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#ifndef _AR_H
#define _AR_H

#include <limits.h>             /* POSIX.1-1990 does not specify the */
#include <sys/types.h>          /* presence of <ar.h>, so we need not */
#include <sys/fs.h>             /* worry about namespace leaks here. */

/* we use a traditional V7-style binary format, rather than the
   POSIX `portable' plaintext format. we differ from V7 in that:

    (1) the field sizes have been changed (including the magic)
    (2) the order has been changed (to avoid alignment padding)
    (2) members are aligned to quadword boundaries (not words)
    (3) `ld' does not require (or understand) a __.SYMDEF member */

typedef long armag_t;

#define ARMAG     '<tahar!>'                /* magic quadword */
#define ARPAD     8                         /* pad alignment */

struct ar_hdr
{
    char        ar_name[NAME_MAX];
    uid_t       ar_uid;
    gid_t       ar_gid;
    mode_t      ar_mode;
    time_t      ar_date;
    off_t       ar_size;
};

#endif /* _AR_H */

/* vi: set ts=4 expandtab: */
