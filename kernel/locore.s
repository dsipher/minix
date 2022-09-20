//////////////////////////////////////////////////////////////////////////////
/
/  boot.s                                                  jewel/os kernel
/
//////////////////////////////////////////////////////////////////////////////
/
/  Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
/
/  Redistribution and use in source and binary forms, with or without
/  modification, are permitted provided that the following conditions
/  are met:
/
/  * Redistributions of source code must retain the above copyright
/    notice, this list of conditions and the following disclaimer.
/
/  * Redistributions in binary form must reproduce the above copyright
/    notice, this list of conditions and the following disclaimer in the
/    documentation and/or other materials provided with the distribution.
/
/  THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
/  "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
/  LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
/  FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
/  COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
/  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
/  BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
/  OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/  ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
/  TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
/  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
/
//////////////////////////////////////////////////////////////////////////////

/ kernel entry point (for the BSP).
/ head off to main(), never to return.

                    lidt idt_48

/ configure the u. area. while u. is remapped on context switch, pginit() in
/ page.c keeps process 0's u. identity-mapped to avoid bootstrap headaches.

                    movq $_proc0, U_PROCP           / we are process 0
                    movb $1, U_LOCKS                / interrupts disabled

                    jmp _main

.globl _main
.globl _proc0

//////////////////////////////////////////////////////////////////////////////
/
/ definitions pertaining to the u. area; keep in sync with sys/user.h.

.globl _u
_u = 0x00100000                 / USER_ADDR from sys/page.h

U_FXSAVE    =   _u + 0x0000
U_PROCP     =   _u + 0x0200
U_LOCKS     =   _u + 0x0208

//////////////////////////////////////////////////////////////////////////////
/
/ the E820 map is retrieved by boot and stored at these locations.

.globl _e820_map
.globl _e820_count

_e820_count = 0x7000
_e820_map   = 0x7008

//////////////////////////////////////////////////////////////////////////////
/
/ the IDT is deliberately in the .text, and here in locore, because it
/ (and its related handlers) need to be... low in the core. if we can
/ assume everything here lives at or below 64k, it simplifies things.

.align 8

idt:                .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0
                    .short 0, 0, 0, 0, 0, 0, 0, 0

idt_48:             .short idt_48 - idt - 1
                    .quad idt

//////////////////////////////////////////////////////////////////////////////
/
/ void lock(void);
/ void unlock(void);

.globl _lock

_lock:              cli
                    incb U_LOCKS
                    ret

.globl _unlock

_unlock:            decb U_LOCKS
                    jnz unlock010
                    sti
unlock010:          ret

//////////////////////////////////////////////////////////////////////////////
/
/ void acquire(spinlock_t *lock);
/ void release(spinlock_t *lock);

.globl _acquire

acquire010:         call _unlock
acquire020:         pause
                    testl $1, (%rdi)
                    jnz acquire020
                    / fallthru /
_acquire:           call _lock
                    lock
                    btsl $0, (%rdi)
                    jc acquire010
                    ret

.globl _release

_release:           movl $0, (%rdi)
                    call _unlock
                    ret

/ vi: set ts=4 expandtab:
