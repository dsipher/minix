.text

_append:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8192,%rsp
L2:
	testl %esi,%esi
	jnz L31
L6:
	movl %edi,_curln(%rip)
L8:
	cmpl $0,_nflg(%rip)
	jz L13
L11:
	movl _curln(%rip),%eax
	incl %eax
	pushq %rax
	pushq $L14
	call _printf
	addq $16,%rsp
L13:
	movl $___stdin,%edx
	movl $8192,%esi
	leaq -8192(%rbp),%rdi
	call _fgets
	testq %rax,%rax
	jz L15
L17:
	cmpb $46,-8192(%rbp)
	jnz L24
L22:
	cmpb $10,-8191(%rbp)
	jnz L24
L23:
	xorl %eax,%eax
	jmp L3
L24:
	leaq -8192(%rbp),%rdi
	call _ins
	cmpl $0,%eax
	jge L8
L31:
	movl $-2,%eax
	jmp L3
L15:
	movl $-1,%eax
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 

L14:
	.byte 37,54,100,46,32,0

.globl _fgets
.globl _nflg
.globl _curln
.globl _append
.globl _printf
.globl ___stdin
.globl _ins
