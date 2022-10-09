.text

_qexchange:
L1:
	jmp L4
L5:
	movsbl (%rdi),%ecx
	movb (%rsi),%al
	movb %al,(%rdi)
	incq %rdi
	movb %cl,(%rsi)
	incq %rsi
L4:
	movq %rdx,%rax
	decq %rdx
	testq %rax,%rax
	jnz L5
L3:
	ret 


_q3exchange:
L7:
	jmp L10
L11:
	movsbl (%rdi),%r8d
	movb (%rdx),%al
	movb %al,(%rdi)
	movb (%rsi),%al
	incq %rdi
	movb %al,(%rdx)
	incq %rdx
	movb %r8b,(%rsi)
	incq %rsi
L10:
	movq %rcx,%rax
	decq %rcx
	testq %rax,%rax
	jnz L11
L9:
	ret 


_qsort1:
L13:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L14:
	movq %rdi,-16(%rbp) # spill
	movq %rsi,-8(%rbp) # spill
	movq %rdx,%r12
L16:
	movq -16(%rbp),%rax # spill
	cmpq -8(%rbp),%rax # spill
	jae L15
L22:
	movq -16(%rbp),%rbx # spill
	movq -8(%rbp),%r14 # spill
	movq %r14,%rax
	subq -16(%rbp),%rax # spill
	movq %r12,%rcx
	shlq $1,%rcx
	addq %r12,%rax
	xorl %edx,%edx
	divq %rcx
	imulq %r12,%rax
	movq -16(%rbp),%r13 # spill
	addq %rax,%r13
	movq %r13,%r15
L25:
	cmpq %r15,%rbx
	jae L35
L28:
	movq _qcompar(%rip),%rax
	movq %r15,%rsi
	movq %rbx,%rdi
	call *%rax
	cmpl $0,%eax
	jz L33
	jl L32
L35:
	cmpq %r13,%r14
	jbe L37
L36:
	movq _qcompar(%rip),%rax
	movq %r13,%rsi
	movq %r14,%rdi
	call *%rax
	cmpl $0,%eax
	jl L38
	jg L46
L45:
	addq %r12,%r13
	movq %r12,%rdx
	movq %r13,%rsi
	movq %r14,%rdi
	call _qexchange
	jmp L35
L46:
	subq %r12,%r14
	jmp L35
L38:
	cmpq %r15,%rbx
	jb L41
L43:
	addq %r12,%r13
	movq %r12,%rcx
	movq %r14,%rdx
	movq %r13,%rsi
	movq %rbx,%rdi
	call _q3exchange
	addq %r12,%r15
	movq %r15,%rbx
	jmp L35
L41:
	movq %r12,%rdx
	movq %r14,%rsi
	movq %rbx,%rdi
	call _qexchange
	addq %r12,%rbx
	subq %r12,%r14
	jmp L25
L37:
	movq %r15,%rsi
	subq %r12,%rsi
	cmpq %r15,%rbx
	jae L50
L48:
	movq %rsi,%r15
	movq %r12,%rcx
	movq %rbx,%rdx
	movq %r14,%rdi
	call _q3exchange
	subq %r12,%r13
	movq %r13,%r14
	jmp L25
L50:
	movq %r12,%rdx
	movq -16(%rbp),%rdi # spill
	call _qsort1
	addq %r12,%r13
	movq %r13,-16(%rbp) # spill
	jmp L16
L32:
	addq %r12,%rbx
	jmp L25
L33:
	subq %r12,%r15
	movq %r12,%rdx
	movq %r15,%rsi
	movq %rbx,%rdi
	call _qexchange
	jmp L25
L15:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_qsort:
L52:
L53:
	testq %rsi,%rsi
	jz L54
L57:
	movq %rcx,_qcompar(%rip)
	decq %rsi
	imulq %rdx,%rsi
	addq %rdi,%rsi
	call _qsort1
L54:
	ret 

.local _qcompar
.comm _qcompar, 8, 8

.globl _qsort
