.text

_frexp:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L2:
	movsd %xmm0,-8(%rbp)
	movl -4(%rbp),%ecx
	movl %ecx,%eax
	shll $1,%eax
	shrl $21,%eax
	jz L7
L17:
	cmpl $2047,%eax
	jz L5
L18:
	subl $1022,%eax
	jmp L20
L7:
	andl $1048575,%ecx
	orl -8(%rbp),%ecx
	jnz L9
L8:
	movl $0,(%rdi)
	jmp L5
L9:
	movsd ___frexp_adj(%rip),%xmm1
	mulsd %xmm0,%xmm1
	movsd %xmm1,-8(%rbp)
	movl -4(%rbp),%eax
	shll $1,%eax
	shrl $21,%eax
	subl $1536,%eax
L20:
	movl %eax,(%rdi)
	movl -4(%rbp),%eax
	andl $-2146435073,%eax
	orl $1071644672,%eax
	movl %eax,-4(%rbp)
L5:
	movsd -8(%rbp),%xmm0
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl ___frexp_adj
.globl _frexp
