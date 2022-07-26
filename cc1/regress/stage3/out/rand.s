.data
.align 4
_next:
	.int 1
.text

_rand:
L1:
L2:
	imull $1103515245,_next(%rip),%eax
	addl $12345,%eax
	movl %eax,_next(%rip)
	movl $65536,%ecx
	cqto 
	idivq %rcx
	movl $32768,%ecx
	cqto 
	idivq %rcx
	movl %edx,%eax
L3:
	ret 


_srand:
L5:
L6:
	movl %edi,_next(%rip)
L7:
	ret 


.globl _rand
.globl _srand
