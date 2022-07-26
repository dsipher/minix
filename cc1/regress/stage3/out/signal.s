.text

_signal:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
L2:
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-32(%rbp)
	xorl %eax,%eax
	movq %rax,-64(%rbp)
	movq %rax,-56(%rbp)
	movq %rax,-48(%rbp)
	movq %rax,-40(%rbp)
	movq $0,-64(%rbp)
	movq %rsi,-32(%rbp)
	movl $-1073741824,%eax
	movq %rax,-24(%rbp)
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _sigaction
	cmpl $-1,%eax
	jnz L5
L4:
	movq $-1,%rax
	jmp L3
L5:
	movq -64(%rbp),%rax
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _sigaction
.globl _signal
