.text

_exit:
L1:
	pushq %rbx
L2:
	movq ___exit_cleanup(%rip),%rax
	movl %edi,%ebx
	testq %rax,%rax
	jz L6
L4:
	call *%rax
L6:
	movl %ebx,%edi
	call ___exit
L3:
	popq %rbx
	ret 

.comm ___exit_cleanup, 8, 8

.globl ___exit_cleanup
.globl _exit
.globl ___exit
