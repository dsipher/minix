.text

_dodash:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl %edi,%r13d
	movq %rsi,-8(%rbp)
	movq %rdx,%r12
	movq %rsi,%rbx
	jmp L4
L7:
	movsbl %cl,%ecx
	cmpl %ecx,%r13d
	jz L3
L5:
	cmpb $45,%cl
	jz L12
L11:
	leaq -8(%rbp),%rdi
	call _esc
	movl $1,%edx
	movq %r12,%rsi
	movl %eax,%edi
	jmp L28
L12:
	cmpq %rbx,%rax
	jz L14
L17:
	leaq 1(%rax),%rdx
	movsbl 1(%rax),%ecx
	cmpl %ecx,%r13d
	jnz L15
L14:
	movl $1,%edx
	movq %r12,%rsi
	movl $45,%edi
L28:
	call _setbit
	jmp L13
L15:
	movq %rdx,-8(%rbp)
	movb 1(%rax),%cl
	movb -1(%rax),%r14b
	cmpb %r14b,%cl
	jge L22
L21:
	movsbl %cl,%r15d
	movsbl %r14b,%r14d
	jmp L24
L22:
	movsbl %r14b,%r15d
	movsbl %cl,%r14d
L24:
	incl %r15d
	cmpl %r15d,%r14d
	jl L13
L25:
	movl $1,%edx
	movq %r12,%rsi
	movl %r15d,%edi
	call _setbit
	jmp L24
L13:
	incq -8(%rbp)
L4:
	movq -8(%rbp),%rax
	movb (%rax),%cl
	testb %cl,%cl
	jnz L7
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _setbit
.globl _esc
.globl _dodash
