.text

_star:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	movq %rsi,%rbx
L4:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _wildmat
	testl %eax,%eax
	jnz L6
L5:
	leaq 1(%r12),%rcx
	movb 1(%r12),%al
	movq %rcx,%r12
	testb %al,%al
	jnz L4
L7:
	xorl %eax,%eax
	jmp L3
L6:
	movl $1,%eax
L3:
	popq %r12
	popq %rbx
	ret 


_wildmat:
L12:
	jmp L15
L16:
	cmpb $92,%al
	jz L22
L72:
	cmpb $63,%al
	jz L28
L73:
	cmpb $42,%al
	jz L34
L74:
	cmpb $91,%al
	jnz L19
L39:
	leaq 1(%rsi),%rcx
	cmpb $94,1(%rsi)
	setz %al
	movzbl %al,%r10d
	cmovzq %rcx,%rsi
	movl $256,%r9d
	xorl %r8d,%r8d
L43:
	leaq 1(%rsi),%rdx
	movb 1(%rsi),%cl
	movq %rdx,%rsi
	testb %cl,%cl
	jz L20
L47:
	cmpb $93,%cl
	jz L20
L44:
	movb (%rdi),%al
	cmpb $45,%cl
	jnz L55
L54:
	leaq 1(%rdx),%rsi
	cmpb %al,1(%rdx)
	jl L59
L57:
	movsbl %al,%eax
	cmpl %eax,%r9d
	jg L59
L58:
	movl $1,%eax
	jmp L56
L59:
	xorl %eax,%eax
	jmp L56
L55:
	cmpb %al,%cl
	setz %al
	movzbl %al,%eax
L56:
	testl %eax,%eax
	movl $1,%eax
	cmovnzl %eax,%r8d
	cmpl %r8d,%r10d
	jz L77
L63:
	movsbl (%rsi),%r9d
	jmp L43
L34:
	cmpb $0,1(%rsi)
	jz L78
L35:
	incq %rsi
	call _star
	ret
L28:
	cmpb $0,(%rdi)
	jnz L20
	jz L77
L22:
	incq %rsi
L19:
	movb (%rdi),%al
	cmpb (%rsi),%al
	jnz L77
L20:
	incq %rdi
	incq %rsi
L15:
	movb (%rsi),%al
	testb %al,%al
	jnz L16
L18:
	movb (%rdi),%al
	testb %al,%al
	jz L78
L65:
	cmpb $47,%al
	jnz L77
L78:
	movl $1,%eax
	ret
L77:
	xorl %eax,%eax
L14:
	ret 


.globl _wildmat
