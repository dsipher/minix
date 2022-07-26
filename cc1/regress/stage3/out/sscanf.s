.text

_sscanf:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
L2:
	movq 16(%rbp),%rdi
	movq 24(%rbp),%rax
	movq %rax,24(%rbp)
	movl $-1,-28(%rbp)
	movl $133,-24(%rbp)
	movq %rdi,-16(%rbp)
	movq %rdi,-8(%rbp)
	call _strlen
	movl %eax,-32(%rbp)
	leaq 32(%rbp),%rdx
	movq 24(%rbp),%rsi
	leaq -32(%rbp),%rdi
	call _vfscanf
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _vfscanf
.globl _sscanf
.globl _strlen
