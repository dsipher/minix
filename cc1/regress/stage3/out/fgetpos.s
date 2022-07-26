.text

_fgetpos:
L1:
	pushq %rbx
L2:
	movq %rsi,%rbx
	call _ftell
	movq %rax,(%rbx)
	cmpq $-1,%rax
	movl $0,%ecx
	movl $-1,%eax
	cmovnzl %ecx,%eax
L3:
	popq %rbx
	ret 


.globl _fgetpos
.globl _ftell
