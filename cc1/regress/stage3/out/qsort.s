.text

_qexchange:
L1:
L4:
	movq %rdx,%rax
	decq %rdx
	testq %rax,%rax
	jz L3
L5:
	movsbl (%rdi),%ecx
	movb (%rsi),%al
	movb %al,(%rdi)
	incq %rdi
	movb %cl,(%rsi)
	incq %rsi
	jmp L4
L3:
	ret 


_q3exchange:
L7:
L10:
	movq %rcx,%rax
	decq %rcx
	testq %rax,%rax
	jz L9
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
	jmp L10
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
	movq %rdi,-16(%rbp)
	movq %rsi,-8(%rbp)
	movq %rdx,%r15
L16:
	movq -16(%rbp),%rax
	cmpq -8(%rbp),%rax
	jae L15
L22:
	movq -16(%rbp),%r14
	movq -8(%rbp),%r12
	movq %r12,%rax
	subq -16(%rbp),%rax
	movq %r15,%rcx
	shlq $1,%rcx
	addq %r15,%rax
	xorl %edx,%edx
	divq %rcx
	imulq %r15,%rax
	movq -16(%rbp),%rbx
	addq %rax,%rbx
	movq %rbx,%r13
L25:
	cmpq %r13,%r14
	jae L35
L28:
	movq _qcompar(%rip),%rax
	movq %r13,%rsi
	movq %r14,%rdi
	call *%rax
	cmpl $0,%eax
	jz L33
	jl L32
L35:
	cmpq %rbx,%r12
	jbe L37
L36:
	movq _qcompar(%rip),%rax
	movq %rbx,%rsi
	movq %r12,%rdi
	call *%rax
	cmpl $0,%eax
	jl L38
	jg L46
L45:
	addq %r15,%rbx
	movq %r15,%rdx
	movq %rbx,%rsi
	movq %r12,%rdi
	call _qexchange
	jmp L35
L46:
	subq %r15,%r12
	jmp L35
L38:
	cmpq %r13,%r14
	jb L41
L43:
	addq %r15,%rbx
	movq %r15,%rcx
	movq %r12,%rdx
	movq %rbx,%rsi
	movq %r14,%rdi
	call _q3exchange
	addq %r15,%r13
	movq %r13,%r14
	jmp L35
L41:
	movq %r15,%rdx
	movq %r12,%rsi
	movq %r14,%rdi
	call _qexchange
	addq %r15,%r14
	subq %r15,%r12
	jmp L25
L37:
	movq %r13,%rsi
	subq %r15,%rsi
	cmpq %r13,%r14
	jae L50
L48:
	movq %rsi,%r13
	movq %r15,%rcx
	movq %r14,%rdx
	movq %r12,%rdi
	call _q3exchange
	subq %r15,%rbx
	movq %rbx,%r12
	jmp L25
L50:
	movq %r15,%rdx
	movq -16(%rbp),%rdi
	call _qsort1
	addq %r15,%rbx
	movq %rbx,-16(%rbp)
	jmp L16
L32:
	addq %r15,%r14
	jmp L25
L33:
	subq %r15,%r13
	movq %r15,%rdx
	movq %r13,%rsi
	movq %r14,%rdi
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
