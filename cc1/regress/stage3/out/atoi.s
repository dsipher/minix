.text

_atoi:
L1:
L2:
	xorl %esi,%esi
	xorl %eax,%eax
L4:
	movsbl (%rdi),%edx
	incq %rdi
	movslq %edx,%rcx
	testb $8,___ctype+1(%rcx)
	jnz L4
L6:
	cmpl $45,%edx
	jnz L8
L7:
	movl $1,%esi
	jmp L21
L8:
	cmpl $43,%edx
	jz L21
L13:
	movl %edx,%ecx
	subl $48,%ecx
	cmpl $10,%ecx
	jae L16
L14:
	leal (%rax,%rax,4),%eax
	addl %eax,%eax
	addl %edx,%eax
	subl $48,%eax
L21:
	movsbl (%rdi),%edx
	incq %rdi
	jmp L13
L16:
	testl %esi,%esi
	jz L3
L17:
	negl %eax
L3:
	ret 


.globl _atoi
.globl ___ctype
