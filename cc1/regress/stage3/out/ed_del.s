.text

_del:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl %edi,%r12d
	movl %esi,%r13d
	cmpl $1,%r12d
	movl $1,%eax
	cmovll %eax,%r12d
	movl %r12d,%edi
	decl %edi
	jns L9
L7:
	movl _lastln(%rip),%edi
L9:
	call _getptr
	movq %rax,%rbx
	leal 1(%r13),%eax
	cmpl %eax,_lastln(%rip)
	movl $0,%edi
	cmovgel %eax,%edi
	call _getptr
	movq %rax,%r15
	movq 16(%rbx),%rdi
	jmp L13
L16:
	cmpq $_line0,%rdi
	jz L15
L14:
	movq 16(%rdi),%r14
	call _free
	movq %r14,%rdi
L13:
	cmpq %rdi,%r15
	jnz L16
L15:
	movq %r15,%rcx
	movq %rbx,%rdx
	movq %r15,%rsi
	movq %rbx,%rdi
	call _relink
	subl %r12d,%r13d
	incl %r13d
	movl _lastln(%rip),%eax
	subl %r13d,%eax
	movl %eax,_lastln(%rip)
	decl %r12d
	cmovnsl %r12d,%eax
	movl %eax,_curln(%rip)
	xorl %eax,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


.globl _free
.globl _lastln
.globl _curln
.globl _line0
.globl _getptr
.globl _relink
.globl _del
