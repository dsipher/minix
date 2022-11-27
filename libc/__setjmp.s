##############################################################################
#
#  __setjmp.s                                       minix standard library
#
##############################################################################
#
#  Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
#  "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
#  LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
#  FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
#  COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
#  BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
#  OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
#  TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
#  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
##############################################################################

.text

# offsets into the jmp_buf

RIP     =   0
RSP     =   8
RBP     =   16
RBX     =   24
R12     =   32
R13     =   40
R14     =   48
R15     =   56
XMM8    =   64
XMM9    =   72
XMM10   =   80
XMM11   =   88
XMM12   =   96
XMM13   =   104
XMM14   =   112
XMM15   =   120

# int __setjmp(jmp_buf env);

.globl ___setjmp

___setjmp:              popq %rcx
                        movq %rcx, RIP(%rdi)
                        movq %rsp, RSP(%rdi)
                        movq %rbp, RBP(%rdi)
                        movq %rbx, RBX(%rdi)
                        movq %r12, R12(%rdi)
                        movq %r13, R13(%rdi)
                        movq %r14, R14(%rdi)
                        movq %r15, R15(%rdi)
                        movsd %xmm8, XMM8(%rdi)
                        movsd %xmm9, XMM9(%rdi)
                        movsd %xmm10, XMM10(%rdi)
                        movsd %xmm11, XMM11(%rdi)
                        movsd %xmm12, XMM12(%rdi)
                        movsd %xmm13, XMM13(%rdi)
                        movsd %xmm14, XMM14(%rdi)
                        movsd %xmm15, XMM15(%rdi)

                        xorl %eax, %eax
                        jmp *%rcx

# void longjmp(jmp_buf env, int val);

.globl _longjmp

_longjmp:               movl $1, %eax           # why? because the
                        testl %esi, %esi        # standard says so.
                        cmovnzl %esi, %eax

                        movq RIP(%rdi), %rcx
                        movq RSP(%rdi), %rsp
                        movq RBP(%rdi), %rbp
                        movq RBX(%rdi), %rbx
                        movq R12(%rdi), %r12
                        movq R13(%rdi), %r13
                        movq R14(%rdi), %r14
                        movq R15(%rdi), %r15

                        movsd XMM8(%rdi), %xmm8
                        movsd XMM9(%rdi), %xmm9
                        movsd XMM10(%rdi), %xmm10
                        movsd XMM11(%rdi), %xmm11
                        movsd XMM12(%rdi), %xmm12
                        movsd XMM13(%rdi), %xmm13
                        movsd XMM14(%rdi), %xmm14
                        movsd XMM15(%rdi), %xmm15

                        jmp *%rcx

# vi: set ts=4 expandtab:
