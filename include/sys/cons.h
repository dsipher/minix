/*****************************************************************************

   sys/cons.h                                          ux/64 system header

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

/* parameters for console BEL */

#define BEL_FREQ            740         /* sound a high F# */
#define BEL_TICKS           10          /* for 1/10th second */

/* color values in VGA attribute byte */

#define CONS_BLACK          0
#define CONS_BLUE           1
#define CONS_GREEN          2
#define CONS_CYAN           3
#define CONS_RED            4
#define CONS_MAGENTA        5
#define CONS_BROWN          6
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

/* all keyboard input is mapped to these `universal'
   codes. all keys generate a single, possibly 8-bit,
   code (i.e., no escape sequences like a VT-100). */

    /* 0x00 - 0x1F ... ASCII control codes

       we map ^@ .. ^_ to 0x00-0x1F per convention.
       also ^? is synonymous with 0x7F (KEY_DEL).

       if `c' is alphabetic. it must be uppercase. */

#define KEY_CTRL(c)     (((c) == '?') ? 0x7F : ((c) - 0x40))

#define KEY_DEL         0x7F

    /* 0x80 - 0xCA are currently unassigned */

#define KEY_HOME        0xCB
#define KEY_END         0xCC
#define KEY_INS         0xCD
#define KEY_PGUP        0xCE
#define KEY_PGDN        0xCF

#define KEY_F1          0xD0
#define KEY_F2          0xD1
#define KEY_F3          0xD2
#define KEY_F4          0xD3
#define KEY_F5          0xD4
#define KEY_F6          0xD5
#define KEY_F7          0xD6
#define KEY_F8          0xD7
#define KEY_F9          0xD8
#define KEY_F10         0xD9
#define KEY_F11         0xDA
#define KEY_F12         0xDB

#define KEY_UP          0xDC
#define KEY_DN          0xDD
#define KEY_LT          0xDE
#define KEY_RT          0xDF

    /* 0xE0 - 0xFF ... ALT sequences

       ALT+@ .. ALT+_ are mapped much like ^@ .. ^_ are, except they
       are mapped to this upper range. note ALT+? is not valid. also
       like KEY_CTRL, if `c' is alphabetic, it must be uppercase. */

#define KEY_ALT(c)     ((c) + 0x90)


#ifdef _KERNEL

extern void cninit(void);           /* early console initialization */
extern void cnputchar(int c);       /* print character to console */
extern void cnkey(int key);         /* report a key pressed on keyboard */

#endif /* _KERNEL */

#endif /* _SYS_CONS_H */

/* vi: set ts=4 expandtab: */
