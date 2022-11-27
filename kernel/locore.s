//////////////////////////////////////////////////////////////////////////////
/
/  locore.s                                                   minix kernel
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

_u              = 0x00100000    / USER_ADDR from sys/page.h
KERNEL_STACK    = 0x00102000    / KERNEL_STACK ............

U_FXSAVE    =   _u + 0x0000
U_PROCP     =   _u + 0x0200
U_LOCKS     =   _u + 0x0208
U_ERRNO     =   _u + 0x0209
U_MASK      =   _u + 0x020C

U_SYS_RBX   =   _u + 0x0210
U_SYS_RBP   =   _u + 0x0218
U_SYS_RSP   =   _u + 0x0220
U_SYS_R12   =   _u + 0x0228
U_SYS_R13   =   _u + 0x0230
U_SYS_R14   =   _u + 0x0238
U_SYS_R15   =   _u + 0x0240
U_SYS_RIP   =   _u + 0x0248

U_CDIR      =   _u + 0x0250
U_SCANBP    =   _u + 0x0258
U_VACANCY   =   _u + 0x0260
U_NAMEIDP   =   _u + 0x0268

U_RIP       =   _u + 0x0270
U_RFLAGS    =   _u + 0x0278
U_RSP       =   _u + 0x0280
U_RAX       =   _u + 0x0288
U_RDI       =   _u + 0x0290
U_RSI       =   _u + 0x0298
U_RDX       =   _u + 0x02A0
U_R10       =   _u + 0x02A8
U_R8        =   _u + 0x02B0
U_R9        =   _u + 0x02B8

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
/ traps are processed nearly identically to irqs.
/
/ the differences are:  (a) interrupts are not disabled
/                       (b) the local APIC is not involved
/                       (c) an error code is on the stack
/                       (d) we dispatch to traps[], not isr[]
/
/ these are details. the main thrust of the logic is the same.

.globl _traphook
.globl _tsr

_traphook:          pushq %rax
                    pushq %rcx
                    pushq %rdx
                    pushq %rsi
                    pushq %rdi
                    pushq %r8
                    pushq %r9
                    pushq %r10
                    pushq %r11

                    movq 80(%rsp), %rsi         / error code
                    movq 72(%rsp), %rdi         / trap number
                    call *_tsr(,%rdi,8)         / call tsr(trapno, code)

                    popq %r11
                    popq %r10
                    popq %r9
                    popq %r8
                    popq %rdi
                    popq %rsi
                    popq %rdx
                    popq %rcx
                    popq %rax
                    addq $16, %rsp              / discard trapno and code
                    iret

//////////////////////////////////////////////////////////////////////////////
/
/ system call entry. boot trampolines SYSCALLs directly here, IF=0, DF=0.
/ we preserve the user state in the u. area and let sys() do the dispatch.
/ as usual we preserve only kernel-volatile regs; swtch() handles the rest.

.globl _sys
.globl _syshook

_syshook:           movq %rcx, U_RIP
                    movq %r11, U_RFLAGS
                    movq %rsp, U_RSP
                    movq %rax, U_RAX
                    movq %rdi, U_RDI
                    movq %rsi, U_RSI
                    movq %rdx, U_RDX
                    movq %r10, U_R10
                    movq %r8, U_R8
                    movq %r9, U_R9

                    xorl %eax, %eax             / user space shouldn't
                    movw %ax, %ds               / mess with these, and
                    movw %ax, %es               / their values should
                    movw %ax, %fs               / be ignored, but let's
                    movw %ax, %gs               / sanitize them anyway.

                    movq $KERNEL_STACK, %rsp    / switch to kernel stack
                    sti                         / now safe to re-enable
                    call _sys                   / dispatch system call

                    cli
                    movq U_R9, %r9
                    movq U_R8, %r8
                    movq U_R10, %r10
                    movq U_RDX, %rdx
                    movq U_RSI, %rsi
                    movq U_RDI, %rdi
                    movq U_RAX, %rax
                    movq U_RSP, %rsp
                    movq U_RFLAGS, %r11
                    movq U_RIP, %rcx

                    sysret

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
