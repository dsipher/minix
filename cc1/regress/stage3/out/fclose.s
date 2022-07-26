.text

_fclose:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	xorl %ebx,%ebx
	xorl %eax,%eax
L5:
	movslq %eax,%rcx
	cmpq ___iotab(,%rcx,8),%r12
	jz L8
L10:
	incl %eax
	cmpl $20,%eax
	jl L5
	jge L7
L8:
	movq $0,___iotab(,%rcx,8)
L7:
	cmpl $20,%eax
	jge L12
L14:
	movq %r12,%rdi
	call _fflush
	testl %eax,%eax
	movl $-1,%eax
	cmovnzl %eax,%ebx
	movl 4(%r12),%edi
	call _close
	testl %eax,%eax
	movl $-1,%eax
	cmovnzl %eax,%ebx
	testl $8,8(%r12)
	jz L24
L25:
	movq 16(%r12),%rdi
	testq %rdi,%rdi
	jz L24
L22:
	call _free
L24:
	cmpq $___stdin,%r12
	jz L31
L36:
	cmpq $___stdout,%r12
	jz L31
L32:
	cmpq $___stderr,%r12
	jz L31
L29:
	movq %r12,%rdi
	call _free
L31:
	movl %ebx,%eax
	jmp L3
L12:
	movl $-1,%eax
L3:
	popq %r12
	popq %rbx
	ret 


.globl _close
.globl _free
.globl ___stdout
.globl _fflush
.globl ___stderr
.globl ___stdin
.globl _fclose
.globl ___iotab
