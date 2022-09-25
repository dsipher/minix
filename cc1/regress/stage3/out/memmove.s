.text

_memmove:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%r8
	testq %rdx,%rdx
	jz L3
L4:
	cmpq %rsi,%rax
	jb L8
L10:
	leaq (%rsi,%rdx),%rdi
	cmpq %rdi,%rax
	jae L8
L7:
	leaq (%rax,%rdx),%r8
	incq %rdx
L14:
	decq %rdx
	jz L3
L15:
	leaq -1(%rdi),%rcx
	movb -1(%rdi),%sil
	movq %rcx,%rdi
	leaq -1(%r8),%rcx
	movb %sil,-1(%r8)
	movq %rcx,%r8
	jmp L14
L8:
	incq %rdx
	jmp L17
L18:
	movb (%rsi),%cl
	incq %rsi
	movb %cl,(%r8)
	incq %r8
L17:
	decq %rdx
	jnz L18
L3:
	ret 


.globl _memmove
