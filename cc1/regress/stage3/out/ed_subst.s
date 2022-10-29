.text

_subst:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8240,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl _line1(%rip),%r14d
	movq %rdi,-8208(%rbp) # spill
	movq %rsi,-8216(%rbp) # spill
	movl %edx,-8220(%rbp) # spill
	movl %ecx,-8196(%rbp) # spill
	cmpl $0,%r14d
	jle L55
L6:
	movl $0,-8224(%rbp) # spill
	jmp L8
L9:
	movl %r14d,%edi
	call _gettxt
	movq %rax,%r13
	movq %rax,-8232(%rbp) # spill
	leaq -8192(%rbp),%r12
	xorl %ebx,%ebx
	movq $0,-8240(%rbp) # spill
L12:
	cmpb $0,(%r13)
	jz L14
L13:
	cmpl $0,-8220(%rbp) # spill
	jnz L15
L18:
	testl %ebx,%ebx
	jnz L16
L15:
	movq -8232(%rbp),%rdx # spill
	movq -8208(%rbp),%rsi # spill
	movq %r13,%rdi
	call _amatch
	movq %rax,%r15
	testq %r15,%r15
	jz L24
L25:
	cmpq %r15,-8240(%rbp) # spill
	jz L24
L22:
	incl %ebx
	movq %rbp,%r8
	movq %r12,%rcx
	movq -8216(%rbp),%rdx # spill
	movq %r15,%rsi
	movq %r13,%rdi
	call _catsub
	movq %rax,%r12
	movq %r15,-8240(%rbp) # spill
	jmp L24
L16:
	xorl %r15d,%r15d
L24:
	testq %r15,%r15
	jz L29
L32:
	cmpq %r15,%r13
	jnz L30
L29:
	movb (%r13),%al
	incq %r13
	movb %al,(%r12)
	incq %r12
	jmp L12
L30:
	movq %r15,%r13
	jmp L12
L14:
	testl %ebx,%ebx
	jz L38
L36:
	cmpq %rbp,%r12
	jae L55
L41:
	movb $0,(%r12)
	movl %r14d,%esi
	movl %r14d,%edi
	call _del
	leaq -8192(%rbp),%rdi
	call _ins
	incl -8224(%rbp) # spill
	cmpl $0,-8196(%rbp) # spill
	jz L38
L43:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _doprnt
L38:
	incl %r14d
L8:
	cmpl _line2(%rip),%r14d
	jle L9
L11:
	cmpl $0,-8224(%rbp) # spill
	jnz L48
L49:
	cmpl $0,-8220(%rbp) # spill
	jnz L48
L55:
	movl $-2,%eax
	jmp L3
L48:
	movl -8224(%rbp),%eax # spill
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _catsub
.globl _curln
.globl _line1
.globl _line2
.globl _doprnt
.globl _del
.globl _gettxt
.globl _ins
.globl _amatch
.globl _subst
