//////////////////////////////////////////////////////////////////////////////
/
/  locore.s                                                   ux/64 kernel
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
U_ERRNO     =   _u + 0x0209

U_SYS_RBX   =   _u + 0x0210
U_SYS_RBP   =   _u + 0x0218
U_SYS_RSP   =   _u + 0x0220
U_SYS_R12   =   _u + 0x0228
U_SYS_R13   =   _u + 0x0230
U_SYS_R14   =   _u + 0x0238
U_SYS_R15   =   _u + 0x0240
U_SYS_RIP   =   _u + 0x0248

U_CDIR      =   _u + 0x0250

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
/ irqs are sent here from the idt stubs in boot.
/ the interrupt frame has been left on the stack
/ undisturbed, with the irq number pushed on top.

.globl _irqhook
.globl _isr
.globl _preempt
.globl _lapic

LAPIC_EOI       =   0x0B0

_irqhook:           pushq %rax              / save volatile GP regs:
                    pushq %rcx              / c calling conventions
                    pushq %rdx              / will preserve the others.
                    pushq %rsi              / no need to save the SSE
                    pushq %rdi              / state, since the kernel
                    pushq %r8               / will not touch it unless
                    pushq %r9               / we preempt(), in which
                    pushq %r10              / case swtch() will deal
                    pushq %r11              / with it (if necessary).
                    incb U_LOCKS            / interrupt gate locked IRQs

                    movq 72(%rsp), %rdi         / buried irq #
                    call *_isr(,%rdi,8)         / call isr(irq)

                    movq _lapic(%rip), %rax     / tell local APIC
                    movl $0, LAPIC_EOI(%rax)    / we serviced it

                    call _preempt           / maybe it's someone else's turn

                    decb U_LOCKS
                    popq %r11
                    popq %r10
                    popq %r9
                    popq %r8
                    popq %rdi
                    popq %rsi
                    popq %rdx
                    popq %rcx
                    popq %rax
                    addq $8, %rsp           / discard irq number
                    iret

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
                    fxsave U_FXSAVE                     / uses them,
                    movq %cr0, %rax                     / then disable SSE
                    orq $8, %rax                        / by setting TS bit
                    movq %rax, %cr0                     / (there is no `stts')

swtch010:           movq $0x7FFFFFFFFF, %rbx
                    movq P_PTL3(%rdi), %rax             / new page tables
                    andq %rbx, %rax                     / (physical address)
                    movq %rax, %cr3

                    testb $P_FLAG_SSE, P_FLAGS(%rdi)    / and only re-enable
                    jz swtch020                         / SSE and restore
                    clts                                / the SSE state if
                    fxrstor U_FXSAVE                    / the proc uses them

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
