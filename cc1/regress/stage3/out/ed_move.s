.text

_move:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movl _line1(%rip),%ecx
	movl %edi,%r13d
	cmpl $0,%ecx
	jle L4
L11:
	movl _line2(%rip),%eax
	cmpl %eax,%ecx
	jg L4
L7:
	cmpl %ecx,%r13d
	jl L6
L15:
	cmpl %eax,%r13d
	jg L6
L4:
	movl $-2,%eax
	jmp L3
L6:
	movl %ecx,%edi
	decl %edi
	jns L22
L20:
	movl _lastln(%rip),%edi
L22:
	call _getptr
	movq %rax,%r14
	movl _line1(%rip),%edi
	call _getptr
	movq %rax,%r12
	movl _line2(%rip),%edi
	call _getptr
	movq %rax,%rbx
	movl _line2(%rip),%eax
	incl %eax
	cmpl %eax,_lastln(%rip)
	movl $0,%edi
	cmovgel %eax,%edi
	call _getptr
	movq %rax,%rcx
	movq %r14,%rdx
	movq %rax,%rsi
	movq %r14,%rdi
	call _relink
	movl _line1(%rip),%edx
	movl _line2(%rip),%ecx
	subl %edx,%ecx
	leal 1(%rcx),%eax
	subl %eax,_lastln(%rip)
	cmpl %edx,%r13d
	jle L28
L26:
	subl %eax,%r13d
L28:
	leal 1(%rcx,%r13),%eax
	movl %eax,_curln(%rip)
	movl %r13d,%edi
	call _getptr
	movq %rax,%r14
	incl %r13d
	cmpl %r13d,_lastln(%rip)
	movl $0,%edi
	cmovgel %r13d,%edi
	call _getptr
	movq %rax,%r13
	movq %r13,%rcx
	movq %rbx,%rdx
	movq %r12,%rsi
	movq %r14,%rdi
	call _relink
	movq %r12,%rcx
	movq %r14,%rdx
	movq %r13,%rsi
	movq %rbx,%rdi
	call _relink
	movl _line1(%rip),%edx
	movl _line2(%rip),%eax
	movl _lastln(%rip),%ecx
	subl %edx,%eax
	leal 1(%rcx,%rax),%eax
	movl %eax,_lastln(%rip)
	movl $1,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_transfer:
L33:
	pushq %rbx
	pushq %r12
	pushq %r13
L34:
	movl _line1(%rip),%ebx
	cmpl $0,%ebx
	jle L36
L39:
	movl _line2(%rip),%eax
	cmpl %eax,%ebx
	jle L38
L36:
	movl $-2,%eax
	jmp L35
L38:
	cmpl %eax,%edi
	movl %edi,%r13d
	cmovgel %eax,%r13d
	movl %edi,_curln(%rip)
	xorl %r12d,%r12d
	jmp L47
L48:
	movl %ebx,%edi
	call _gettxt
	movq %rax,%rdi
	call _ins
	incl %r12d
	incl %ebx
L47:
	cmpl %ebx,%r13d
	jge L48
L50:
	addl %r12d,%ebx
	addl %r12d,_line2(%rip)
	jmp L51
L52:
	movl %ebx,%edi
	call _gettxt
	movq %rax,%rdi
	call _ins
	incl _line2(%rip)
	addl $2,%ebx
L51:
	cmpl %ebx,_line2(%rip)
	jge L52
L54:
	movl $1,%eax
L35:
	popq %r13
	popq %r12
	popq %rbx
	ret 


.globl _lastln
.globl _curln
.globl _transfer
.globl _line1
.globl _getptr
.globl _line2
.globl _move
.globl _relink
.globl _gettxt
.globl _ins
