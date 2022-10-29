.local L4
.comm L4, 8192, 1
.text

_doread:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movl %edi,%r12d
	movq %rsi,%rbx
	movl $0,_truncated(%rip)
	movl $0,_nullchar(%rip)
	movl $0,_nonascii(%rip)
	cmpl $0,_diag(%rip)
	jz L7
L5:
	pushq %rbx
	pushq $L8
	call _printf
	addq $16,%rsp
L7:
	movl $L12,%esi
	movq %rbx,%rdi
	call _fopen
	movq %rax,%r14
	testq %r14,%r14
	jz L9
L11:
	movl %r12d,_curln(%rip)
	xorl %r13d,%r13d
	xorl %r12d,%r12d
L15:
	movq %r14,%rdx
	movl $8192,%esi
	movl $L4,%edi
	call _egets
	movl %eax,%ebx
	cmpl $0,%ebx
	jle L18
L16:
	movl $L4,%edi
	call _strlen
	addq %rax,%r12
	movl $L4,%edi
	call _ins
	cmpl $0,%eax
	jl L19
L21:
	incl %r13d
	jmp L15
L19:
	pushq $L22
	call _printf
	addq $8,%rsp
	incl %ebx
L18:
	movq %r14,%rdi
	call _fclose
	cmpl $0,%ebx
	jl L46
L26:
	cmpl $0,_diag(%rip)
	jz L46
L28:
	pushq %r12
	pushq %r13
	pushq $L31
	call _printf
	addq $24,%rsp
	movl _nonascii(%rip),%eax
	testl %eax,%eax
	jz L34
L32:
	pushq %rax
	pushq $L35
	call _printf
	addq $16,%rsp
L34:
	movl _nullchar(%rip),%eax
	testl %eax,%eax
	jz L38
L36:
	pushq %rax
	pushq $L39
	call _printf
	addq $16,%rsp
L38:
	movl _truncated(%rip),%eax
	testl %eax,%eax
	jz L42
L40:
	pushq %rax
	pushq $L43
	call _printf
	addq $16,%rsp
L42:
	pushq $L44
	call _printf
	addq $8,%rsp
L46:
	movl %ebx,%eax
	jmp L3
L9:
	pushq $L13
	call _printf
	addq $8,%rsp
	movl $-2,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L44:
	.byte 10,0
L31:
	.byte 37,100,32,108,105,110,101,115
	.byte 32,37,108,100,32,98,121,116
	.byte 101,115,0
L39:
	.byte 32,91,37,100,32,110,117,108
	.byte 93,0
L22:
	.byte 102,105,108,101,32,105,110,115
	.byte 101,114,116,32,101,114,114,111
	.byte 114,10,0
L35:
	.byte 32,91,37,100,32,110,111,110
	.byte 45,97,115,99,105,105,93,0
L12:
	.byte 114,0
L13:
	.byte 102,105,108,101,32,111,112,101
	.byte 110,32,101,114,114,10,0
L43:
	.byte 32,91,37,100,32,108,105,110
	.byte 101,115,32,116,114,117,110,99
	.byte 97,116,101,100,93,0
L8:
	.byte 34,37,115,34,32,0

.globl _doread
.globl _fopen
.globl _truncated
.globl _curln
.globl _diag
.globl _printf
.globl _nullchar
.globl _nonascii
.globl _fclose
.globl _strlen
.globl _ins
.globl _egets
