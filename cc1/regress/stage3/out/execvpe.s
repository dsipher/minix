.text

_execvpe:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $256,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	movl $L7,%edi
	call _getenv
	movq %rax,%r12
	testq %rax,%rax
	movl $L8,%eax
	cmovzq %rax,%r12
	movl $47,%esi
	movq %r15,%rdi
	call _strchr
	testq %rax,%rax
	setnz %bl
	movzbl %bl,%ebx
L9:
	leaq -256(%rbp),%rdx
	testl %ebx,%ebx
	jnz L13
L16:
	movb (%r12),%al
	testb %al,%al
	jz L19
L20:
	cmpb $58,%al
	jz L19
L17:
	incq %r12
	movb %al,(%rdx)
	incq %rdx
	jmp L16
L19:
	leaq -256(%rbp),%rax
	cmpq %rax,%rdx
	jz L26
L24:
	movb $47,(%rdx)
	incq %rdx
L26:
	movq %r15,%rcx
L27:
	movb (%rcx),%al
	testb %al,%al
	jz L30
L28:
	incq %rcx
	movb %al,(%rdx)
	incq %rdx
	jmp L27
L30:
	movb $0,(%rdx)
	jmp L15
L13:
	movq %r15,%rsi
	leaq -256(%rbp),%rdi
	call _strcpy
L15:
	movq %r13,%rdx
	movq %r14,%rsi
	leaq -256(%rbp),%rdi
	call _execve
	testl %ebx,%ebx
	jnz L12
L33:
	movb (%r12),%al
	testb %al,%al
	jz L12
L37:
	cmpb $58,%al
	jnz L9
L39:
	incq %r12
	jmp L9
L12:
	movl $-1,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L8:
 .byte 0
L7:
 .byte 80,65,84,72,0

.globl _getenv
.globl _execve
.globl _execvpe
.globl _strchr
.globl _strcpy
