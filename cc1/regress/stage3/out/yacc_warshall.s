.text

_transitive_closure:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movl $32,%ecx
	leal 31(%rsi),%eax
	cltd 
	idivl %ecx
	imull %eax,%esi
	movslq %esi,%rcx
	leaq (%rdi,%rcx,4),%r11
	movq %rdi,%r10
	xorl %r9d,%r9d
	movq %rdi,%r8
L4:
	cmpq %r8,%r11
	jbe L3
L5:
	movq %r10,%rsi
	movq %rdi,%rdx
L7:
	cmpq %rdx,%r11
	jbe L9
L8:
	movl (%rsi),%r12d
	movb %r9b,%cl
	movl $1,%ebx
	shll %cl,%ebx
	testl %r12d,%ebx
	movslq %eax,%rax
	leaq (%rdx,%rax,4),%rcx
	jz L11
L10:
	movq %r8,%r14
L13:
	cmpq %rcx,%rdx
	jae L12
L14:
	movl (%r14),%r13d
	addq $4,%r14
	movq %rdx,%r12
	movl (%rdx),%ebx
	addq $4,%rdx
	orl %r13d,%ebx
	movl %ebx,(%r12)
	jmp L13
L11:
	movq %rcx,%rdx
L12:
	movslq %eax,%rax
	leaq (%rsi,%rax,4),%rsi
	jmp L7
L9:
	incl %r9d
	cmpl $32,%r9d
	jb L18
L16:
	xorl %r9d,%r9d
	addq $4,%r10
L18:
	movslq %eax,%rax
	leaq (%r8,%rax,4),%r8
	jmp L4
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reflexive_transitive_closure:
L19:
	pushq %rbx
	pushq %r12
L20:
	movq %rdi,%rbx
	movl %esi,%r12d
	movl %r12d,%esi
	movq %rbx,%rdi
	call _transitive_closure
	movl $32,%ecx
	leal 31(%r12),%eax
	cltd 
	idivl %ecx
	imull %eax,%r12d
	movslq %r12d,%r12
	leaq (%rbx,%r12,4),%rdi
	xorl %esi,%esi
L22:
	cmpq %rbx,%rdi
	jbe L21
L23:
	movb %sil,%cl
	movl $1,%edx
	shll %cl,%edx
	orl (%rbx),%edx
	movl %edx,(%rbx)
	incl %esi
	cmpl $32,%esi
	jb L27
L25:
	xorl %esi,%esi
	addq $4,%rbx
L27:
	movslq %eax,%rax
	leaq (%rbx,%rax,4),%rbx
	jmp L22
L21:
	popq %r12
	popq %rbx
	ret 


.globl _reflexive_transitive_closure
