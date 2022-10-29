.text

_getptr:
L1:
L2:
	movl _lastln(%rip),%ecx
	movl %edi,%eax
	shll $1,%eax
	cmpl %ecx,%eax
	jle L5
L7:
	cmpl %ecx,%edi
	jg L5
L4:
	movq _line0+8(%rip),%rax
L11:
	cmpl %ecx,%edi
	jge L3
L12:
	movq 8(%rax),%rax
	decl %ecx
	jmp L11
L5:
	movl $_line0,%eax
	xorl %ecx,%ecx
	jmp L15
L16:
	movq 16(%rax),%rax
	incl %ecx
L15:
	cmpl %ecx,%edi
	jg L16
L3:
	ret 


.globl _lastln
.globl _line0
.globl _getptr
