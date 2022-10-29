.text

_catsub:
L1:
L2:
	movq %rcx,%rax
	jmp L4
L8:
	cmpq %rax,%r8
	jbe L3
L5:
	cmpb $38,%cl
	jnz L13
L12:
	movq %rdi,%r9
L15:
	cmpq %r9,%rsi
	jbe L14
L16:
	movb (%r9),%cl
	incq %r9
	movb %cl,(%rax)
	incq %rax
	cmpq %rax,%r8
	ja L15
	jbe L14
L13:
	cmpb $92,%cl
	jnz L42
L23:
	incq %rdx
	movb (%rdx),%cl
	cmpb $49,%cl
	jl L42
L29:
	cmpb $57,%cl
	jle L26
L42:
	movb %cl,(%rax)
	incq %rax
	jmp L14
L26:
	movsbl %cl,%ecx
	subl $49,%ecx
	movslq %ecx,%rcx
	movq _parclose(,%rcx,8),%r9
	movq _paropen(,%rcx,8),%r10
L33:
	cmpq %r9,%r10
	jae L14
L34:
	movb (%r10),%cl
	incq %r10
	movb %cl,(%rax)
	incq %rax
	cmpq %rax,%r8
	ja L33
L14:
	incq %rdx
L4:
	movb (%rdx),%cl
	testb %cl,%cl
	jnz L8
L3:
	ret 


.globl _catsub
.globl _paropen
.globl _parclose
