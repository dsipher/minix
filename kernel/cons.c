/*****************************************************************************

   cons.c                                                     minix kernel

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

#include <sys/cons.h>
#include <sys/io.h>
#include <sys/clock.h>
#include <sys/spin.h>
#include <sys/log.h>

/* number of virtual ttys. the minimum is 1, since the first vty
   is the console. the maximum is 12, since we use ALT + Fkey to
   select the console, and we've only got twelve of them. almost
   all storage associated with a vty is allocated on-demand, so
   there's little reason to reduce this below the max. */

#define NR_VTYS     12

/* at some point, either by choice or by force, we'll move to a
   bitmapped console. for now we use the legacy 80x25 text mode. */

#define COLS        80
#define ROWS        25

#define LAST_COL    (COLS - 1)
#define LAST_ROW    (ROWS - 1)

/* space is at a premium: to make dynamic allocations cheap
   and easy, a struct vty must fit in one page. the lion's
   share of the space is occupied by the backing framebuf[]. */

struct vty
{
    char            x, y;       /* cursor position (0, 0 = origin) */
    unsigned char   attr;       /* attribute - see CONS_ATTR_* (cons.h) */
    unsigned char   state;      /* see *_STATE et al. below */

    /* the backing buffer. (this is only valid for the
       consoles which are not currently displayed.) we
       force framebuf[] to be quadword-aligned so that
       optimizations in blank() and scroll() will work */

    unsigned long   : 0;
    unsigned short  framebuf[COLS * ROWS];
};

#define FRAMEBUF(vty)               (((vty) == current_vty)                 \
                                        ? ((unsigned short *) 0xB8000)      \
                                        : ((vty)->framebuf))

/* protects all the following global data, as well
   as access to the framebuffer and 6845 registers. */

static spinlock_t cons_lock;

/* only the console vty is pre-allocated. the rest are [will
   be] allocated on demand, the first time they're opened. */

static struct vty cons_vty;
static struct vty *vtys[NR_VTYS] = { &cons_vty };
static struct vty *current_vty = &cons_vty;

/* values for vty.state. STATE values drive
   the finite state machine in cnputc() */

#define CURSOR              0x80        /* cursor is displayed */
#define WRAP                0x40        /* automatic line wrap */

#define STATE_MASK          0x0F

#define GET_STATE(v)        ((v)->state & STATE_MASK)
#define SET_STATE(v, s)     ((v)->state = ((v)->state & ~STATE_MASK) | (s))

#define NORMAL_STATE        0           /* the usual situation */
#define ESC_STATE           1           /* last char was ESCape */
#define Y_STATE             2           /* expecting Y position next */
#define X_STATE             3           /* ......... X position next */
#define ATTR_STATE          4           /* ......... attribute next */

/* there has not been an actual MC6845 in a PC video card since
   the CGA/MDA days, of course, but we still pretend there is. */

#define ADDRESS             0x3D4       /* MC6845 address latch */
#define DATA                0x3D5       /* ...... data window */

#define READ_BYTE(addr)         ({                                          \
                                    OUTB(ADDRESS, (addr));                  \
                                    INB(DATA);                              \
                                })

#define READ_WORD(addr)         ({                                          \
                                    unsigned _addr = (addr);                \
                                    unsigned _u;                            \
                                                                            \
                                    OUTB(ADDRESS, _addr);                   \
                                    _u = INB(DATA) << 8;                    \
                                    OUTB(ADDRESS, _addr + 1);               \
                                    _u |= INB(DATA);                        \
                                })

#define WRITE_BYTE(addr, b)     do {                                        \
                                    OUTB(ADDRESS, (addr));                  \
                                    OUTB(DATA, (b));                        \
                                } while (0)

#define WRITE_WORD(addr, w)     do {                                        \
                                    unsigned _addr = (addr);                \
                                    unsigned _w = (w);                      \
                                                                            \
                                    OUTB(ADDRESS, _addr);                   \
                                    OUTB(DATA, _w >> 8);                    \
                                    OUTB(ADDRESS, _addr + 1);               \
                                    OUTB(DATA, _w);                         \
                                } while (0)

/* MC6845 registers 10 and 11 hold the cursor start and end scan lines,
   respectively. we always write these together, so for convenience we
   treat them as a single word register. */

#define CURSOR_SHAPE        10

#define NO_CURSOR           0xFFFF
#define BLOCK_CURSOR        0x000F

/* MC6845 registers 14 and 15 hold the cursor position, as an offset into
   the frame buffer. as the chip itself was blissfully unaware of things
   like characters and attributes, this is a [16-bit] word address. */

#define CURSOR_POS          14          /* MC6845 reg: cursor position */

/* update the hardware cursor shape to reflect the state of
   the CURSOR bit. ignore if the vty is not the current_vty. */

static void
toggle(struct vty *vty)    /* hold: cons_lock */
{
    if (vty == current_vty) {
        int shape = (vty->state & CURSOR) ? BLOCK_CURSOR
                                          : NO_CURSOR;

        WRITE_WORD(CURSOR_SHAPE, shape);
    }
}

/* update the position of the hardware cursor to agree
   with vty. ignore if the vty is not the current_vty,
   or if the cursor is currently hidden. */

static void
move(struct vty *vty)    /* hold: cons_lock */
{
    if ((vty == current_vty) && (vty->state & CURSOR))
    {
        int pos = (vty->y * COLS + vty->x);
        WRITE_WORD(CURSOR_POS, pos);
    }
}

/* write a series of `n' blanks on the vty using
   the current attribute, starting at (x, y). */

static void
blank(struct vty *vty, int x, int y, int n)    /* hold: cons_lock */
{
    unsigned short *framebuf = FRAMEBUF(vty);
    unsigned blank = (vty->attr << 8) | ' ';

    framebuf += y * COLS + x;
    STOSW(framebuf, blank, n);
}

/* check to see if vty->y has run out of bounds, and if
   so, scroll the screen up and fix the cursor position. */

static void
scroll(struct vty *vty)    /* hold: cons_lock */
{
    if (vty->y > LAST_ROW) {
        unsigned short *framebuf = FRAMEBUF(vty);
        int n = COLS * (ROWS - 1) / 4;

        MOVSQ(framebuf, framebuf + COLS, n);
        blank(vty, 0, LAST_ROW, COLS);

        --vty->y;
    }
}

/* clear the screen and home the cursor. */

static void
home(struct vty *vty)    /* hold: cons_lock */
{
    blank(vty, 0, 0, ROWS * COLS);
    vty->y = 0;
    vty->x = 0;
    move(vty);
}

/* output `c' to `vty', handling scrolling, cursor movement, etc. the terminal
   emulation is similar to, but not the same as, a VT52. there's little reason
   to get fancy, since we're not actually on a serial link. we'll use `vi' (or
   `elvis') as the litmus test: if it can take advantage of a special sequence
   (say, clear-from-cursor-to-end-of-line) then we'll implement it. otherwise,
   it is almost certainly a waste of time. */

static void
cnputc(struct vty *vty, int c)
{
    acquire(&cons_lock);
    c &= 0xFF;

    if (GET_STATE(vty) == NORMAL_STATE) {
        switch (c)
        {
        case 0:     /* NUL */   break;

        case 7:     /* BEL */   bell();
                                break;

        case 8:     /* BS */    --vty->x;

                                if (vty->x < 0) {
                                    vty->x = 0;

                                    if ((vty->state & WRAP) && (vty->y)) {
                                        vty->x = LAST_COL;
                                        --vty->y;
                                    }
                                }

                                move(vty);
                                break;

        /* note: we don't do any processing on HT (9) like a real VT-52.
           the tty driver does tab expansion, so we let it deal with 'em */

        case 10:    /* LF */    ++vty->y; scroll(vty); move(vty); break;

        /* we also ignore VT (11), does anyone use this anymore? */

        case 12:    /* FF */    home(vty); break;
        case 13:    /* CR */    vty->x = 0; move(vty); break;
        case 27:    /* ESC */   SET_STATE(vty, ESC_STATE); break;

        default:    {
                        unsigned short *framebuf = FRAMEBUF(vty);
                        unsigned short word = (vty->attr << 8) | c;

                        framebuf[vty->y * COLS + vty->x] = word;

                        if (vty->x == LAST_COL) {
                            if (vty->state & WRAP) {
                                vty->x = 0;
                                ++vty->y;
                                scroll(vty);
                            }
                        } else
                            ++vty->x;

                        move(vty);
                    }
        }
    } else if (GET_STATE(vty) == ESC_STATE) {
        switch (c)
        {
        case 'a':   /* set attribute */ SET_STATE(vty, ATTR_STATE);
                                        goto out;

        case 'e':   /* show cursor */   vty->state |= CURSOR;
                                        toggle(vty);
                                        move(vty);
                                        break;

        case 'f':   /* hide cursor */   vty->state &= ~CURSOR;
                                        toggle(vty);
                                        break;

        case 'p':   /* bold on */       vty->attr = CONS_BOLD(vty->attr);
                                        break;

        case 'q':   /* bold off */      vty->attr = CONS_UNBOLD(vty->attr);
                                        break;

        case 'w':   /* linewrap off */  vty->state &= ~WRAP; break;
        case 'v':   /* linewrap on */   vty->state |= WRAP; break;

        case 'A':   /* cursor up */     if (vty->y) {
                                            --vty->y;
                                            move(vty);
                                        }

                                        break;

        case 'B':   /* cursor down */   if (vty->y < LAST_ROW) {
                                            ++vty->y;
                                            move(vty);
                                        }

                                        break;

        case 'C':   /* cursor right */  if (vty->x < LAST_COL) {
                                            ++vty->x;
                                            move(vty);
                                        }

                                        break;

        case 'D':   /* cursor left */   if (vty->x) {
                                            --vty->x;
                                            move(vty);
                                        }

                                        break;

        case 'E':   /* clear & home */  home(vty); break;

        case 'Y':   /* set position */  SET_STATE(vty, Y_STATE);
                                        goto out;
        }

        SET_STATE(vty, NORMAL_STATE);
    } else if (GET_STATE(vty) == Y_STATE) {
        vty->y = (c - ' ');
        if (vty->y < 0) vty->y = 0;
        if (vty->y >= ROWS) vty->y = LAST_ROW;
        SET_STATE(vty, X_STATE);
    } else if (GET_STATE(vty) == X_STATE) {
        vty->x = (c - ' ');
        if (vty->x < 0) vty->x = 0;
        if (vty->x >= ROWS) vty->x = LAST_COL;
        SET_STATE(vty, NORMAL_STATE);
    } else if (GET_STATE(vty) == ATTR_STATE) {
        vty->attr = c & CONS_ATTR_MASK;
        SET_STATE(vty, NORMAL_STATE);
    }

out:
    release(&cons_lock);
}

/* called early to initialize the system console. since the
   system is barely running, don't bother with cons_lock. */

void
cninit(void)
{
    unsigned pos;

    pos = READ_WORD(CURSOR_POS);        /* read the cursor position */
    cons_vty.y = pos / COLS;            /* so we can pick up where */
    cons_vty.x = pos % COLS;            /* the BIOS left off */

    cons_vty.attr = CONS_ATTR_DEFAULT;
    cons_vty.state = CURSOR | WRAP;
    SET_STATE(&cons_vty, NORMAL_STATE);

    toggle(&cons_vty);                  /* block cursor, please */
}

/* the default putchar for printf(). see log.c */

void cnputchar(int c) { cnputc(&cons_vty, c); }

/* process an incoming key from a keyboard.
   this is obviously a placeholder for now. */

void
cnkey(int key)
{
    printf("%c", key);
}

/* vi: set ts=4 expandtab: */
