.text

_rewind:
L1:
	pushq %rbx
L2:
	movq %rdi,%rbx
	xorl %edx,%edx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _fseek
	andl $-49,8(%rbx)
L3:
	popq %rbx
	ret 


.globl _fseek
.globl _rewind
