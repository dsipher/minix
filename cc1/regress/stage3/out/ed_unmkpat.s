.text

_unmakepat:
L1:
	pushq %rbx
L2:
	movq %rdi,%rbx
	jmp L4
L5:
	movb (%rbx),%al
	cmpb $91,%al
	jz L11
L13:
	cmpb $33,%al
	jnz L7
L11:
	movq 8(%rbx),%rdi
	call _free
L7:
	movq %rbx,%rdi
	movq 16(%rbx),%rbx
	call _free
L4:
	testq %rbx,%rbx
	jnz L5
L3:
	popq %rbx
	ret 


.globl _free
.globl _unmakepat
