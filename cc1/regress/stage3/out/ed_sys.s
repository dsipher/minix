.text

_sys:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	call _fork
	movl %eax,%ebx
	cmpl $-1,%ebx
	jz L7
L18:
	testl %ebx,%ebx
	jnz L13
L9:
	pushq $0
	pushq %r12
	pushq $L12
	pushq $L11
	pushq $L10
	call _execl
	addq $40,%rsp
	movl $-1,%edi
	call _exit
L13:
	leaq -4(%rbp),%rdi
	call _wait
	cmpl %eax,%ebx
	jnz L13
L15:
	movl -4(%rbp),%eax
	jmp L3
L7:
	movl $-1,%eax
L3:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L12:
	.byte 45,99,0
L11:
	.byte 115,104,0
L10:
	.byte 47,98,105,110,47,115,104,0

.globl _fork
.globl _execl
.globl _wait
.globl _exit
.globl _sys
