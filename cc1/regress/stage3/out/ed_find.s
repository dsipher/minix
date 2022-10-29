.text

_find:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8192,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl _curln(%rip),%r13d
	movq %rdi,%r15
	movl %esi,%r14d
	movl %r13d,%edi
	call _getptr
	testl %r14d,%r14d
	jz L5
L4:
	leal 1(%r13),%ecx
	cmpl _lastln(%rip),%ecx
	movl $0,%r13d
	cmovlel %ecx,%r13d
	jmp L6
L5:
	decl %r13d
	jns L6
L10:
	movl _lastln(%rip),%r13d
L6:
	testl %r14d,%r14d
	jz L14
L13:
	movq 16(%rax),%r12
	jmp L15
L14:
	movq 8(%rax),%r12
L15:
	xorl %ebx,%ebx
L16:
	movl _lastln(%rip),%ecx
	cmpl %ebx,%ecx
	jle L19
L17:
	testl %r13d,%r13d
	jnz L22
L20:
	testl %r14d,%r14d
	jz L24
L23:
	leal 1(%r13),%eax
	cmpl %eax,%ecx
	movl $0,%r13d
	cmovgel %eax,%r13d
	jmp L25
L24:
	movl %r13d,%eax
	decl %eax
	movl %ecx,%r13d
	cmovnsl %eax,%r13d
L25:
	testl %r14d,%r14d
	jz L33
L32:
	movq 16(%r12),%r12
	jmp L22
L33:
	movq 8(%r12),%r12
L22:
	leaq 24(%r12),%rsi
	leaq -8192(%rbp),%rdi
	call _strcpy
	movl $L35,%esi
	leaq -8192(%rbp),%rdi
	call _strcat
	xorl %edx,%edx
	movq %r15,%rsi
	leaq -8192(%rbp),%rdi
	call _matchs
	testq %rax,%rax
	jnz L36
L38:
	testl %r14d,%r14d
	jz L41
L40:
	leal 1(%r13),%eax
	cmpl %eax,_lastln(%rip)
	movl $0,%r13d
	cmovgel %eax,%r13d
	jmp L42
L41:
	decl %r13d
	jns L42
L46:
	movl _lastln(%rip),%r13d
L42:
	testl %r14d,%r14d
	jz L50
L49:
	movq 16(%r12),%r12
	jmp L51
L50:
	movq 8(%r12),%r12
L51:
	incl %ebx
	jmp L16
L36:
	movl %r13d,%eax
	jmp L3
L19:
	movl $-2,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L35:
	.byte 10,0

.globl _lastln
.globl _curln
.globl _matchs
.globl _find
.globl _strcat
.globl _getptr
.globl _strcpy
