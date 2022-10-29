.text

_doglob:
L1:
	pushq %rbx
L2:
	movq _inptr(%rip),%rbx
L4:
	movl $1,%edi
	call _getptr
	movl $1,%edx
	jmp L7
L8:
	testl $2,(%rax)
	jnz L10
L13:
	movq 16(%rax),%rax
	incl %edx
L7:
	movl _lastln(%rip),%ecx
	cmpl %ecx,%edx
	jle L8
L10:
	cmpl %ecx,%edx
	jg L6
L17:
	andl $-3,(%rax)
	movl %edx,_curln(%rip)
	movq %rbx,_inptr(%rip)
	call _getlst
	cmpl $0,%eax
	jl L3
L21:
	movl $1,%edi
	call _docmd
	cmpl $0,%eax
	jge L4
	jl L3
L6:
	movl _curln(%rip),%eax
L3:
	popq %rbx
	ret 


.globl _lastln
.globl _curln
.globl _getlst
.globl _getptr
.globl _docmd
.globl _doglob
.globl _inptr
