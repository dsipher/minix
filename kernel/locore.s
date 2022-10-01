//////////////////////////////////////////////////////////////////////////////
/
/  locore.s                                                jewel/os kernel
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

                    jmp _main

.globl _main

//////////////////////////////////////////////////////////////////////////////
/
/ definitions pertaining to struct proc; see sys/proc.h

P_PTL3      =   0x0000
P_FLAGS     =   0x0015

P_FLAG_SSE  =   0x02

//////////////////////////////////////////////////////////////////////////////
/
/ definitions pertaining to the u. area; see sys/user.h.

.globl _u
_u = 0x00100000                 / USER_ADDR from sys/page.h

U_FXSAVE    =   _u + 0x0000
U_PROCP     =   _u + 0x0200
U_LOCKS     =   _u + 0x0208
U_ERROR     =   _u + 0x0209

U_SYS_RBX   =   _u + 0x0210
U_SYS_RBP   =   _u + 0x0218
U_SYS_RSP   =   _u + 0x0220
U_SYS_R12   =   _u + 0x0228
U_SYS_R13   =   _u + 0x0230
U_SYS_R14   =   _u + 0x0238
U_SYS_R15   =   _u + 0x0240
U_SYS_RIP   =   _u + 0x0248

//////////////////////////////////////////////////////////////////////////////
/
/ data passed in from the boot block

.globl _e820_map
.globl _e820_count
.globl _boot_config

_boot_config    =   0x1160
_e820_count     =   0x7000
_e820_map       =   0x7008

//////////////////////////////////////////////////////////////////////////////
/
/ void swtch(struct proc *to);
/
/ called with the scheduler lock held and thus with interrupts disabled.
/ since this is invoked as a function, we need only honor the c calling
/ convention and save the callee-save registers. somewhat asymmetrically,
/ this is also where we save/restore SSE state, which is user-only state
/ (the kernel, deliberately, avoids SSE). we don't want to save/restore
/ on every interrupt or system call, so we do it here on context switch.

.globl _swtch

_swtch:             popq %rax
                    movq %rax, U_SYS_RIP
                    movq %rsp, U_SYS_RSP

                    movq %rbx, U_SYS_RBX
                    movq %rbp, U_SYS_RBP
                    movq %r12, U_SYS_R12
                    movq %r13, U_SYS_R13
                    movq %r14, U_SYS_R14
                    movq %r15, U_SYS_R15

                    movq U_PROCP, %rax                  / only save SSE
                    testb $P_FLAG_SSE, P_FLAGS(%rax)    / regs if the
                    jz swtch010                         / old process
                    fxsave U_FXSAVE                     / uses them.

swtch010:           movq $0x7FFFFFFFFF, %rbx
                    movq P_PTL3(%rdi), %rax             / new page tables
                    andq %rbx, %rax                     / (physical address)
                    movq %rax, %cr3

                    testb $P_FLAG_SSE, P_FLAGS(%rdi)    / and only restore
                    jz swtch020                         / SSE regs if the
                    fxrstor U_FXSAVE                    / new proc uses them.

swtch020:           movq U_SYS_R15, %r15
                    movq U_SYS_R14, %r14
                    movq U_SYS_R13, %r13
                    movq U_SYS_R12, %r12
                    movq U_SYS_RBP, %rbp
                    movq U_SYS_RBX, %rbx
                    movq U_SYS_RSP, %rsp
                    movq U_SYS_RIP, %rax

                    jmp *%rax

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
