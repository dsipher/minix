/*****************************************************************************

   sys/cmos.h                                          minix system header

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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

#ifndef _SYS_CMOS_H
#define _SYS_CMOS_H

#define CMOS_ADDR       0x70        /* CMOS address port */
#define CMOS_DATA       0x71        /* CMOS data window */

#define CMOS_SECOND     0           /* RTC addresses in CMOS */
#define CMOS_MINUTE     2
#define CMOS_HOUR       4
#define CMOS_DAY        7
#define CMOS_MONTH      8
#define CMOS_YEAR       9
#define CMOS_STATUS_A   10
#define CMOS_STATUS_B   11

/* it is the caller's responsibilty to deal with synchronization issues.
   the address port is shared with the global NMI mask (hence the 0x80). */

#define READ_CMOS(addr)         ({                                          \
                                    OUTB(CMOS_ADDR, (addr) | 0x80);         \
                                    INB(CMOS_DATA);                         \
                                })

#endif /* _SYS_CMOS_H */

/* vi: set ts=4 expandtab: */
