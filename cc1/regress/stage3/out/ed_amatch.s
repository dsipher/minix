.text

_amatch:
L1:
L2:
	movl $0,_between(%rip)
	movl $0,_parnum(%rip)
	call _match
	cmpl $0,_between(%rip)
	jnz L4
L8:
	movl _parnum(%rip),%ecx
	cmpl $9,%ecx
	jge L3
L9:
	movslq %ecx,%rcx
	movq $L11,_parclose(,%rcx,8)
	movslq _parnum(%rip),%rcx
	movq $L11,_paropen(,%rcx,8)
	incl _parnum(%rip)
	jmp L8
L4:
	xorl %eax,%eax
L3:
	ret 


_match:
L13:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L14:
	movq %rdi,%r12
	movq %r12,-8(%rbp)
	movq %rsi,%r14
	movq %rdx,%r13
	testq %r14,%r14
	jz L74
L20:
	testq %r14,%r14
	jz L22
L21:
	movb (%r14),%al
	cmpb $42,%al
	jnz L28
L26:
	movq 16(%r14),%r15
	testq %r15,%r15
	jz L28
L27:
	movq -8(%rbp),%rbx
L30:
	movq -8(%rbp),%rax
	cmpb $0,(%rax)
	jz L35
L33:
	movq %r13,%rdx
	movq %r15,%rsi
	leaq -8(%rbp),%rdi
	call _omatch
	testl %eax,%eax
	jnz L30
L35:
	movq 16(%r15),%r14
	testq %r14,%r14
	jz L20
L37:
	movl _between(%rip),%r15d
	movl _parnum(%rip),%r12d
L40:
	movq -8(%rbp),%rdi
	cmpq %rbx,%rdi
	jb L74
L41:
	movq %r13,%rdx
	movq %r14,%rsi
	call _match
	testq %rax,%rax
	jnz L15
L44:
	decq -8(%rbp)
	movl %r15d,_between(%rip)
	movl %r12d,_parnum(%rip)
	jmp L40
L28:
	cmpb $40,%al
	jnz L49
L48:
	cmpl $0,_between(%rip)
	jnz L74
L54:
	movl _parnum(%rip),%eax
	cmpl $9,%eax
	jge L74
L56:
	movslq %eax,%rax
	movq -8(%rbp),%rcx
	movq %rcx,_paropen(,%rax,8)
	movl $1,_between(%rip)
	jmp L75
L49:
	cmpb $41,%al
	jnz L60
L59:
	cmpl $0,_between(%rip)
	jz L74
L64:
	movl _parnum(%rip),%eax
	leal 1(%rax),%ecx
	movl %ecx,_parnum(%rip)
	movslq %eax,%rax
	movq -8(%rbp),%rcx
	movq %rcx,_parclose(,%rax,8)
	movl $0,_between(%rip)
	jmp L75
L60:
	movq %r13,%rdx
	movq %r14,%rsi
	leaq -8(%rbp),%rdi
	call _omatch
	testl %eax,%eax
	jz L74
L75:
	movq 16(%r14),%r14
	jmp L20
L22:
	movq -8(%rbp),%rcx
	cmpq %r12,%rcx
	movq %r12,%rax
	cmovaeq %rcx,%rax
	jmp L15
L74:
	xorl %eax,%eax
L15:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L11:
	.byte 0
.globl _paropen
.comm _paropen, 72, 8
.globl _parclose
.comm _parclose, 72, 8
.globl _between
.comm _between, 4, 4
.globl _parnum
.comm _parnum, 4, 4

.globl _omatch
.globl _parnum
.globl _paropen
.globl _between
.globl _parclose
.globl _match
.globl _amatch
