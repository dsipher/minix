.text

_getone:
L1:
	pushq %rbx
	pushq %r12
L2:
	movl $1,%edi
	call _getnum
	movl %eax,%ebx
	cmpl $0,%eax
	jl L6
L10:
	movq _inptr(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L14
L13:
	cmpb $9,%al
	jnz L15
L14:
	incq %rcx
	movq %rcx,_inptr(%rip)
	jmp L10
L15:
	cmpb $43,%al
	jz L22
L20:
	cmpb $45,%al
	jnz L6
L22:
	leaq 1(%rcx),%rax
	movq %rax,_inptr(%rip)
	movsbl (%rcx),%r12d
	xorl %edi,%edi
	call _getnum
	cmpl $0,%eax
	jl L3
L27:
	cmpl $43,%r12d
	jnz L30
L29:
	addl %eax,%ebx
	jmp L10
L30:
	subl %eax,%ebx
	jmp L10
L6:
	cmpl _lastln(%rip),%ebx
	movl $-2,%eax
	cmovlel %ebx,%eax
L3:
	popq %r12
	popq %rbx
	ret 


.globl _lastln
.globl _getnum
.globl _getone
.globl _inptr
