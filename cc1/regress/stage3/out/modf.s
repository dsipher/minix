.text
.align 8
_one:
	.quad 0x3ff0000000000000
L59:
	.quad 0x0

_modf:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $80,%rsp
L2:
	movsd %xmm0,-8(%rbp)
	movl -4(%rbp),%esi
	movl -8(%rbp),%edx
	movl %esi,%ecx
	sarl $20,%ecx
	andl $2047,%ecx
	subl $1023,%ecx
	cmpl $20,%ecx
	jge L8
L7:
	cmpl $0,%ecx
	jge L11
L13:
	andl $2147483648,%esi
	movl %esi,-12(%rbp)
	movl $0,-16(%rbp)
	movsd -16(%rbp),%xmm1
	movsd %xmm1,(%rdi)
	jmp L3
L11:
	movl $1048575,%eax
	sarl %cl,%eax
	movl %esi,%ecx
	andl %eax,%ecx
	orl %edx,%ecx
	jz L17
L27:
	notl %eax
	andl %esi,%eax
	movl %eax,-36(%rbp)
	movl $0,-40(%rbp)
	movsd -40(%rbp),%xmm1
	jmp L60
L17:
	movsd %xmm0,(%rdi)
	movsd %xmm0,-24(%rbp)
	movl -20(%rbp),%eax
	andl $2147483648,%eax
	movl %eax,-28(%rbp)
	movl $0,-32(%rbp)
	movsd -32(%rbp),%xmm0
	jmp L3
L8:
	cmpl $51,%ecx
	jle L32
L31:
	cmpl $1024,%ecx
	jz L34
L36:
	movsd _one(%rip),%xmm1
	mulsd %xmm0,%xmm1
	movsd %xmm1,(%rdi)
	movsd %xmm0,-48(%rbp)
	movl -44(%rbp),%eax
	andl $2147483648,%eax
	movl %eax,-52(%rbp)
	movl $0,-56(%rbp)
	movsd -56(%rbp),%xmm0
	jmp L3
L34:
	movsd %xmm0,(%rdi)
	movsd L59(%rip),%xmm1
	divsd %xmm0,%xmm1
	movsd %xmm1,%xmm0
	jmp L3
L32:
	subb $20,%cl
	movl $4294967295,%eax
	shrl %cl,%eax
	testl %eax,%edx
	jz L45
L55:
	movl %esi,-76(%rbp)
	notl %eax
	andl %edx,%eax
	movl %eax,-80(%rbp)
	movsd -80(%rbp),%xmm1
L60:
	movsd %xmm1,(%rdi)
	subsd %xmm1,%xmm0
	jmp L3
L45:
	movsd %xmm0,(%rdi)
	movsd %xmm0,-64(%rbp)
	movl -60(%rbp),%eax
	andl $2147483648,%eax
	movl %eax,-68(%rbp)
	movl $0,-72(%rbp)
	movsd -72(%rbp),%xmm0
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _modf
