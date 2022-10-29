.text

_makebitmap:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movl %edi,%r13d
	movl %r13d,%r12d
	shrl $3,%r12d
	testl $7,%r13d
	movl $0,%eax
	movl $1,%ecx
	cmovzl %eax,%ecx
	addl %ecx,%r12d
	leaq 4(%r12),%rdi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L9
L7:
	movl %r13d,(%rbx)
	movq %r12,%rdx
	xorl %esi,%esi
	leaq 4(%rbx),%rdi
	call _memset
L9:
	movq %rbx,%rax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_setbit:
L11:
L12:
	movl %edi,%ecx
	cmpl (%rsi),%ecx
	jae L14
L16:
	movl %ecx,%eax
	shrl $3,%eax
	andb $7,%cl
	movb $1,%dil
	shlb %cl,%dil
	movb 4(%rsi,%rax),%cl
	testl %edx,%edx
	jz L19
L18:
	orb %dil,%cl
	movb %cl,4(%rsi,%rax)
	jmp L20
L19:
	notb %dil
	andb %cl,%dil
	movb %dil,4(%rsi,%rax)
L20:
	movl $1,%eax
	ret
L14:
	xorl %eax,%eax
L13:
	ret 


_testbit:
L22:
L23:
	movl %edi,%ecx
	cmpl (%rsi),%ecx
	jae L25
L27:
	movl %ecx,%eax
	shrl $3,%eax
	movsbl 4(%rsi,%rax),%edx
	andb $7,%cl
	movl $1,%eax
	shll %cl,%eax
	andl %edx,%eax
	ret
L25:
	xorl %eax,%eax
L24:
	ret 


.globl _malloc
.globl _setbit
.globl _testbit
.globl _makebitmap
.globl _memset
