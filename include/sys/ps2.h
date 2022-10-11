/*****************************************************************************

   sys/ps2.h                                     jewel/os standard library

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

#ifndef _SYS_PS2_H
#define _SYS_PS2_H

/* ports assigned to the i8042 keyboard/mouse controller
   (rather its chipset equivalent, or even faked via SMM).
   we somewhat inaccurately call this the PS/2 device. */

#define PS2_DATA        0x60
#define PS2_PORTB       0x61
#define PS2_STATUS      0x64

/* the PS/2 controller uses confusing definitions (from the
   bus devices' point of view), which means they give status
   bits odd names. we name them according to our perspective. */

#define PS2_STATUS_READY    0x01        /* data is waiting in PS2_DATA */
#define PS2_STATUS_BUSY     0x02        /* don't write to controller */

/* PORT B is actually not controlled by the 8042 (fake or
   otherwise), but historically it was connected to the
   same 8255 PPI used for the keyboard, so put it here.

   when set, bits[1:0] connect PIT channel 2 to the speaker. */

#define PS2_PORTB_SPK   0x03


#ifdef _KERNEL

/* initialize device(s) on PS/2 port(s) */

extern void ps2init(void);

/* handle IRQs from PS/2 device(s) */

extern void ps2isr(int irq);

#endif /* _KERNEL */


#endif /* _SYS_PS2_H */

/* vi: set ts=4 expandtab: */
