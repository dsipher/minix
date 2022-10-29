.text

_matchs:
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
	movq %rdi,%r15
	movq %rsi,%r14
	movl %edx,-4(%rbp) # spill
	movq %r15,%r13
L4:
	cmpb $0,(%r15)
	jz L3
L5:
	testq %r14,%r14
	jz L8
L10:
	cmpb $76,(%r14)
	jnz L8
L14:
	movb (%r15),%al
	testb %al,%al
	jz L16
L15:
	movq %r14,%r12
	movq %r15,%rbx
	movb 1(%r14),%cl
	cmpb %cl,%al
	jnz L20
	jz L19
L23:
	cmpb %al,%cl
	jz L22
L21:
	incq %rbx
L20:
	movb (%rbx),%al
	testb %al,%al
	jnz L23
L22:
	movq %rbx,%r15
	testb %al,%al
	jz L16
L19:
	movw $1,%cx
	incq %rbx
	movq 16(%r14),%r12
L31:
	testq %r12,%r12
	jz L33
L34:
	cmpb $76,(%r12)
	jnz L33
L32:
	movb (%rbx),%al
	cmpb 1(%r12),%al
	jnz L38
L40:
	incq %rbx
	movq 16(%r12),%r12
	jmp L31
L38:
	xorl %ecx,%ecx
L33:
	testq %r12,%r12
	jz L42
L43:
	testw %cx,%cx
	jnz L16
L44:
	incq %r15
	jmp L14
L42:
	cmpl $0,-4(%rbp) # spill
	jz L46
L45:
	leaq -1(%rbx),%rax
	jmp L3
L46:
	movq %r15,%rax
	jmp L3
L16:
	cmpb $0,(%r15)
	jnz L9
L54:
	xorl %eax,%eax
	jmp L3
L8:
	movq %r15,%rbx
	movq %r14,%r12
L9:
	movq %r13,%rdx
	movq %r12,%rsi
	movq %rbx,%rdi
	call _amatch
	testq %rax,%rax
	jnz L59
L58:
	testq %r14,%r14
	jz L63
L64:
	cmpb $94,(%r14)
	jz L3
L63:
	incq %r15
	jmp L4
L59:
	cmpq %rax,%r13
	jae L71
L72:
	cmpq %rax,%r15
	jae L71
L69:
	decq %rax
L71:
	cmpl $0,-4(%rbp) # spill
	cmovzq %r15,%rax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _matchs
.globl _amatch
