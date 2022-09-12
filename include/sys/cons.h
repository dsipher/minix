/*****************************************************************************

   sys/cons.h                                    jewel/os standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

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

#ifndef _SYS_CONS_H
#define _SYS_CONS_H

/* color values in VGA attribute byte */

#define CONS_BLACK          0
#define CONS_GREEN          1
#define CONS_BLUE           2
#define CONS_CYAN           3
#define CONS_RED            4
#define CONS_BROWN          5
#define CONS_MAGENTA        6
#define CONS_GRAY           7

/* construct an attribute byte from
   (foreground, background) colors */

#define CONS_ATTR(fg, bg)       (((bg) << 4) | (fg))

/* our default attribute is boring, but conventional */

#define CONS_ATTR_DEFAULT       CONS_ATTR(CONS_GRAY, CONS_BLACK)

/* mask for value bits in an attribute byte. we
   specifically disallow use of the blink bit. */

#define CONS_ATTR_MASK          0x7F

/* flip the high-intensity bit on or
   off in the given attribute byte */

#define CONS_BOLD(a)            ((a) | 0x08)
#define CONS_UNBOLD(a)          ((a) & ~0x08)

#ifdef _KERNEL

extern void cninit(void);           /* early console initialization */
extern void cnputchar(int);         /* print character to console */

#endif /* _KERNEL */

#endif /* _SYS_CONS_H */

/* vi: set ts=4 expandtab: */
