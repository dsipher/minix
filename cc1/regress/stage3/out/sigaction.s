.text

_sigaction:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
L2:
	movl %edi,%eax
	movl $32,%ecx
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	orq $67108864,-24(%rbp)
	movq $___sigreturn,-16(%rbp)
	leaq -32(%rbp),%rsi
	movl %eax,%edi
	call ___sigaction
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl ___sigaction
.globl ___sigreturn
.globl _sigaction
