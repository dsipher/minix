/*****************************************************************************

   ps2.c                                                   jewel/os kernel

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

#include <sys/ps2.h>
#include <sys/io.h>
#include <sys/spin.h>
#include <sys/clock.h>
#include <sys/apic.h>
#include <sys/log.h>
#include <sys/cons.h>
#include "config.h"

/* our own private non-table-based implementation of ctype.h */

#define isupper(c)      (((c) >= 'A') && ((c) <= 'Z'))
#define islower(c)      (((c) >= 'a') && ((c) <= 'z'))
#define isalpha(c)      (islower(c) || isupper(c))
#define toupper(c)      (islower(c) ? ((c) & ~0x20) : (c))

/* protects keyboard state and accesses to 8042 */

static spinlock_t ps2_lock;

/* current state. we track the shift keys, scan-code
   page, and the led-update state all in one place. */

#define STATE_SCRLCK    0x0001
#define STATE_NUMLCK    0x0002
#define STATE_CAPLCK    0x0004

#define STATE_LSHIFT    0x0008
#define STATE_RSHIFT    0x0010
#define STATE_LALT      0x0020
#define STATE_RALT      0x0040
#define STATE_LCTRL     0x0080
#define STATE_RCTRL     0x0100

#define STATE_PAGE1     0x0200      /* got 0xE0 prefix */
#define STATE_XMIT1     0x0400      /* waiting to send 0xED */
#define STATE_XMIT2     0x0800      /* ............... LED byte */

static unsigned short state = STATE_NUMLCK;

/* it is not a coincidence that our state
   lines up with the ps/2 led update byte */

#define STATE_LEDS      (STATE_SCRLCK | STATE_NUMLCK | STATE_CAPLCK)

#define STATE_XMIT      (STATE_XMIT1 | STATE_XMIT2)
#define STATE_CTRL      (STATE_LCTRL  | STATE_RCTRL)
#define STATE_SHIFT     (STATE_LSHIFT | STATE_RSHIFT)
#define STATE_ALT       (STATE_LALT   | STATE_RALT)

/* set to ignore `ignore' bytes of incoming keyboard data. used to
   ignore the SYSRQ key, which is 0xE1 + 5 bytes, which we discard. */

static unsigned char ignore;

/* keymap[] maps scan codes to key codes (usually ASCII). this is for US
   keyboards, scan code set 1, which is provided to us via translation by
   the 8042. each scan code has two mappings, unshifted and shifted (in
   that order). 0 means the scan code is invalid, or we wish to ignore it. */

#define KEYMAP_SIZE         0x60

static unsigned char keymap[2][KEYMAP_SIZE][2] =
{
    /* page 0 (unescaped) */

    /* 0x00 */      0,    0  ,   0x1B, 0x1B  ,    '1',  '!'  ,    '2',  '@'  ,
    /* 0x04 */    '3',  '#'  ,    '4',  '$'  ,    '5',  '%'  ,    '6',  '^'  ,
    /* 0x08 */    '7',  '&'  ,    '8',  '*'  ,    '9',  '('  ,    '0',  ')'  ,
    /* 0x0C */    '-',  '_'  ,    '=',  '+'  ,   0x08, 0x08  ,   0x09, 0x09  ,
    /* 0x10 */    'q',  'Q'  ,    'w',  'W'  ,    'e',  'E'  ,    'r',  'R'  ,
    /* 0x14 */    't',  'T'  ,    'y',  'Y'  ,    'u',  'U'  ,    'i',  'I'  ,
    /* 0x18 */    'o',  'O'  ,    'p',  'P'  ,    '[',  '{'  ,    ']',  '}'  ,
    /* 0x1C */   0x0D, 0x0D  ,      0,    0  ,    'a',  'A'  ,    's',  'S'  ,
    /* 0x20 */    'd',  'D'  ,    'f',  'F'  ,    'g',  'G'  ,    'h',  'H'  ,
    /* 0x24 */    'j',  'J'  ,    'k',  'K'  ,    'l',  'L'  ,    ';',  ':'  ,
    /* 0x28 */   '\'', '\"'  ,    '`',  '~'  ,      0,    0  ,   '\\',  '|'  ,
    /* 0x2C */    'z',  'Z'  ,    'x',  'X'  ,    'c',  'C'  ,    'v',  'V'  ,
    /* 0x30 */    'b',  'B'  ,    'n',  'N'  ,    'm',  'M'  ,    ',',  '<'  ,
    /* 0x34 */    '.',  '>'  ,    '/',  '?'  ,      0,    0  ,    '*',  '*'  ,
    /* 0x38 */      0,    0  ,    ' ',  ' '  ,      0,    0  ,   KEY_F(1),0  ,
    /* 0x3C */   KEY_F(2),0  ,   KEY_F(3),0  ,   KEY_F(4),0  ,   KEY_F(5),0  ,
    /* 0x40 */   KEY_F(6),0  ,   KEY_F(7),0  ,   KEY_F(8),0  ,   KEY_F(9),0  ,
    /* 0x44 */  KEY_F(10),0  ,      0,    0  ,      0,    0  ,  KEY_HOME,'7' ,
    /* 0x48 */  KEY_UP, '8'  ,  KEY_PGUP,'9' ,    '-',  '-'  ,  KEY_LEFT,'4' ,
    /* 0x4C */    '5',  '5'  ,  KEY_RIGHT,'6',    '+',  '+'  ,  KEY_END,'1'  ,
    /* 0x50 */  KEY_DOWN,'2' ,  KEY_PGDN,'3' ,  KEY_INS,'0'  ,    0x7F, '.'  ,
    /* 0x54 */      0,    0  ,      0,    0  ,      0,    0  ,  KEY_F(11),0  ,
    /* 0x58 */  KEY_F(12),0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x5C */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,

    /* page 2 (0xE0 prefix) */

    /* 0x00 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x04 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x08 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x0C */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x10 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x14 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x18 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x1C */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x20 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x24 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x28 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x2C */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x30 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x34 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x38 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x3C */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x40 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x44 */      0,    0  ,      0,    0  ,      0,    0  ,   KEY_HOME,0  ,
    /* 0x48 */   KEY_UP,  0  ,   KEY_PGUP,0  ,      0,    0  ,   KEY_LEFT,0  ,
    /* 0x4C */      0,    0  ,  KEY_RIGHT,0  ,      0,    0  ,   KEY_END, 0  ,
    /* 0x50 */   KEY_DOWN,0  ,  KEY_PGDN, 0  ,   KEY_INS, 0  ,   0x7F,    0  ,
    /* 0x54 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x58 */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0  ,
    /* 0x5C */      0,    0  ,      0,    0  ,      0,    0  ,      0,    0
};

/* try to transmit byte b to the keyboard port.
   returns 1 on success, 0 if controller is busy. */

static
int xmit(int b)
{
    if (INB(PS2_STATUS) & PS2_STATUS_BUSY)
        return 0;
    else {
        OUTB(PS2_DATA, b);
        return 1;
    }
}

/* the only command we send to/via the 8042 is the
   update-LEDs sequence (0xED, state & STATE_LEDS).
   we don't want to busy-wait, so we use a callout.
   note: we don't check for ACK. this is intentional */

static void update(void *dummy);

static struct callo callo = { 0, 0, update };

static void
update(void *dummy)
{
    acquire(&ps2_lock);

    if (state & STATE_XMIT1) {
        if (xmit(0xED)) {
            state &= ~STATE_XMIT1;
            state |= STATE_XMIT2;
        }
    }

    if (state & STATE_XMIT2) {
        if (xmit(state & STATE_LEDS)) {
            state &= ~STATE_XMIT2;
            goto out; /* skip timeout() */
        }
    }

    callo.c_ticks = 1;
    timeout(&callo);

out:
    release(&ps2_lock);
}

/* if an LED update is not already in
   progress, start the ball rolling */

static void
start_update(void)  /* held: ps2_lock */
{
    if (!(state & STATE_XMIT))
    {
        state |= STATE_XMIT1;
        callo.c_ticks = 1;
        timeout(&callo);
    }
}

/* XXX */

void
ps2init(void)
{
    acquire(&ps2_lock);

    while (INB(PS2_STATUS) & PS2_STATUS_READY)
        INB(PS2_DATA); /* drain input */

    start_update();
    enable(KBD_IRQ, 1);
    release(&ps2_lock);
}

/* XXX */

void ps2isr(int irq)
{
    unsigned char old_state;
    unsigned char code;
    int key = -1;

    acquire(&ps2_lock);

    /* fetch the scancode. */

    code = INB(PS2_DATA);

    /* the SYSRQ key sends an extended sequence of 6
       data bytes, starting with 0xE1. discard them. */

    if (ignore) {
        --ignore;
        release(&ps2_lock);
        return;
    }

    if (code == 0xE1) ignore = 5;

    /* 0xE0 is a prefix which tells us
       to use the secondary keymap */

    if (code == 0xE0) state |= STATE_PAGE1;

    /* check for make/break codes for shift-style keys */

    if (state & STATE_PAGE1) {
        switch (code)
        {
        case 0x1D: state |=  STATE_RCTRL;   break;
        case 0x9D: state &= ~STATE_RCTRL;   break;
        case 0x38: state |=  STATE_RALT;    break;
        case 0xB8: state &= ~STATE_RALT;    break;
        }
    } else {
        switch (code)
        {
        case 0x3A: state ^= STATE_CAPLCK;   break;
        case 0x45: state ^= STATE_NUMLCK;   break;
        case 0x46: state ^= STATE_SCRLCK;   break;

        case 0x2A: state |=  STATE_LSHIFT;  break;
        case 0xAA: state &= ~STATE_LSHIFT;  break;
        case 0x36: state |=  STATE_RSHIFT;  break;
        case 0xB6: state &= ~STATE_RSHIFT;  break;
        case 0x38: state |=  STATE_LALT;    break;
        case 0xB8: state &= ~STATE_LALT;    break;
        case 0x1D: state |=  STATE_LCTRL;   break;
        case 0x9D: state &= ~STATE_LCTRL;   break;
        }
    }

    /* now, deal with make codes for other keys. note that < KEYMAP_SIZE
       excludes break codes, keyboard ACK, and other things we ignore. */

    if (code < KEYMAP_SIZE) {
        int page = (state & STATE_PAGE1) != 0;
        int shift = (state & STATE_SHIFT) != 0;

        /* if NUMLCK is on, and the key pressed is on the
           number pad, we invert the sense of the shift key. */

        if (    page == 0
            &&  code >= 0x47
            &&  code <= 0x53
            && (state & STATE_NUMLCK)) shift = !shift;

        key = keymap[page][code][shift];
        if (key == 0) key = -1; /* ignore */

        /* CAPLCK inverts the sense of the shift
           key, but only for alphabetic keys */

        if ((state & STATE_CAPLCK) && isalpha(key))
            key ^= 0x20;

        /* CTRL and ALT only work on '@' through '_' (and
           sometimes '?') otherwise we ignore the keypress. */

        if (state & (STATE_CTRL | STATE_ALT)) {
            key = toupper(key);

            if ((key < '@' || key > '_') && key != '?')
                key = -1;
            else {
                if (state & STATE_CTRL)
                    key = KEY_CTRL(key);
                else {
                    if (key == '?')
                        key = -1;
                    else
                        key = KEY_ALT(key);
                }
            }
        }
    }

    /* if the LEDs have changed, make sure
       they're going to be updated */

    if ((old_state & STATE_LEDS) != (state & STATE_LEDS))
        start_update();

    /* we only use the secondary map for one scan code */

    if (code != 0xE0) state &= ~STATE_PAGE1;

    release(&ps2_lock);

    if (key >= 0) printf("%c", key);        /* XXX cnkey() */
}

/* vi: set ts=4 expandtab: */