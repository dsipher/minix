.text

_atol:
L1:
L2:
	xorl %esi,%esi
	xorl %eax,%eax
L4:
	movsbl (%rdi),%ecx
	incq %rdi
	movslq %ecx,%rdx
	testb $8,___ctype+1(%rdx)
	jnz L4
L6:
	cmpl $45,%ecx
	jnz L8
L7:
	movl $1,%esi
	movsbl (%rdi),%ecx
	incq %rdi
	jmp L13
L8:
	cmpl $43,%ecx
	jnz L13
L10:
	movsbl (%rdi),%ecx
	incq %rdi
L13:
	movl %ecx,%edx
	subl $48,%edx
	cmpl $10,%edx
	jae L16
L14:
	leaq (%rax,%rax,4),%rax
	addq %rax,%rax
	movslq %ecx,%rcx
	addq %rcx,%rax
	subq $48,%rax
	movsbl (%rdi),%ecx
	incq %rdi
	jmp L13
L16:
	testl %esi,%esi
	jz L3
L17:
	negq %rax
L3:
	ret 


.globl _atol
.globl ___ctype
