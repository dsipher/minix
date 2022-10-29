.text

_dowrite:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl %edi,%r13d
	movl %esi,-8(%rbp) # spill
	movq %rdx,%r14
	movl %ecx,-4(%rbp) # spill
	movl $0,-12(%rbp) # spill
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	cmpl $0,_diag(%rip)
	jz L6
L4:
	pushq %r14
	pushq $L7
	call _printf
	addq $16,%rsp
L6:
	cmpl $0,-4(%rbp) # spill
	movl $L12,%eax
	movl $L11,%esi
	cmovzq %rax,%rsi
	movq %r14,%rdi
	call _fopen
	movq %rax,%r15
	testq %rax,%rax
	jz L8
L10:
	movl %r13d,%edi
	call _getptr
	movq %rax,%r14
L18:
	cmpl %r13d,-8(%rbp) # spill
	jl L21
L19:
	incl %ebx
	leaq 24(%r14),%rdi
	call _strlen
	leaq 1(%rax,%r12),%r12
	movq %r15,%rsi
	leaq 24(%r14),%rdi
	call _fputs
	cmpl $-1,%eax
	jz L22
L24:
	movq %r15,%rsi
	movl $10,%edi
	call _fputc
	movq 16(%r14),%r14
	incl %r13d
	jmp L18
L22:
	pushq $L25
	call _printf
	addq $8,%rsp
	movl $1,-12(%rbp) # spill
L21:
	cmpl $0,_diag(%rip)
	jz L29
L27:
	pushq %r12
	pushq %rbx
	pushq $L30
	call _printf
	addq $24,%rsp
L29:
	movq %r15,%rdi
	call _fclose
	movl -12(%rbp),%eax # spill
	jmp L3
L8:
	pushq $L16
	call _printf
	addq $8,%rsp
	movl $-2,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L11:
	.byte 97,0
L12:
	.byte 119,0
L30:
	.byte 37,100,32,108,105,110,101,115
	.byte 32,37,108,100,32,98,121,116
	.byte 101,115,10,0
L16:
	.byte 102,105,108,101,32,111,112,101
	.byte 110,32,101,114,114,111,114,10
	.byte 0
L25:
	.byte 102,105,108,101,32,119,114,105
	.byte 116,101,32,101,114,114,111,114
	.byte 10,0
L7:
	.byte 34,37,115,34,32,0

.globl _dowrite
.globl _fopen
.globl _diag
.globl _fputc
.globl _printf
.globl _getptr
.globl _fclose
.globl _fputs
.globl _strlen
