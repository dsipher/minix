/*****************************************************************************

   sys/io.h                                      jewel/os standard library

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

#ifndef _SYS_IO_H
#define _SYS_IO_H

/* port i/o operations. these should be self-explanatory:
   they are direct analogs of their assembler equivalents. */

#define INB(p)      ({                                                      \
                        unsigned _port = (p);                               \
                        unsigned char _b;                                   \
                                                                            \
                        __asm("\tinb %dx, %al" : rdx = _port                \
                                               : rax = _b);                 \
                                                                            \
                        (_b);                                               \
                    })

#define INW(p)      ({                                                      \
                        unsigned _port = (p);                               \
                        unsigned short _w;                                  \
                                                                            \
                        __asm("\tinw %dx, %ax" : rdx = _port                \
                                               : rax = _w);                 \
                                                                            \
                        (_w);                                               \
                    })

#define INL(p)      ({                                                      \
                        unsigned _port = (p);                               \
                        unsigned _l;                                        \
                                                                            \
                        __asm("\tinl %dx, %eax" : rdx = _port               \
                                                : rax = _l);                \
                                                                            \
                        (_l);                                               \
                    })

#define OUTB(p, b)  do {                                                    \
                        unsigned _port = (p);                               \
                        unsigned char _b = (b);                             \
                                                                            \
                        __asm("\toutb %al, %dx" : rdx = _port,              \
                                                  rax = _b);                \
                    } while (0)

#define OUTW(p, w)  do {                                                    \
                        unsigned _port = (p);                               \
                        unsigned short _w = (w);                            \
                                                                            \
                        __asm("\toutw %ax, %dx" : rdx = _port,              \
                                                  rax = _w);                \
                    } while (0)

#define OUTL(p, l)  do {                                                    \
                        unsigned _port = (p);                               \
                        unsigned _l = (l);                                  \
                                                                            \
                        __asm("\toutl %eax, %dx" : rdx = _port,             \
                                                   rax = _l);               \
                    } while (0)

#define STOSW(dst, val, n)  do {                                            \
                                void *_dst = (dst);                         \
                                short _val = (val);                         \
                                long _n = (n);                              \
                                                                            \
                                __asm("\trep\n"                             \
                                      "\tstosw" : rdi=_dst, rax=_val,       \
                                                  rcx=_n                    \
                                                : rdi, rcx, mem );          \
                            } while (0)

#define MOVSQ(dst, src, n)  do {                                            \
                                void *_dst = (dst);                         \
                                void *_src = (src);                         \
                                long _n = (n);                              \
                                                                            \
                                __asm("\trep\n"                             \
                                      "\tmovsq" : rdi=_dst, rsi=_src,       \
                                                  rcx=_n, mem               \
                                                : rdi, rsi, rcx, mem );     \
                            } while (0)

#endif /* _SYS_IO_H */

/* vi: set ts=4 expandtab: */
