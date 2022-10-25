.local L4
.comm L4, 8, 8
.local L5
.comm L5, 1, 1
.text

_getoldopt:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movl %edi,%r12d
	movq %rsi,%rbx
	movq %rdx,%rdi
	movq $0,_optarg(%rip)
	cmpq $0,L4(%rip)
	jnz L8
L6:
	cmpl $2,%r12d
	jl L42
L11:
	movq 8(%rbx),%rax
	movq %rax,L4(%rip)
	cmpb $45,(%rax)
	jnz L14
L13:
	incb L5(%rip)
	jmp L8
L14:
	movl $2,_optind(%rip)
L8:
	cmpb $0,L5(%rip)
	jnz L16
L18:
	movq L4(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,L4(%rip)
	movb (%rcx),%r13b
	testb %r13b,%r13b
	jz L20
L22:
	movsbl %r13b,%r13d
	movl %r13d,%esi
	call _strchr
	testq %rax,%rax
	jz L28
L27:
	cmpb $58,%r13b
	jnz L29
L28:
	pushq %r13
	pushq (%rbx)
	pushq $L31
	jmp L44
L29:
	cmpb $58,1(%rax)
	jnz L35
L33:
	movl _optind(%rip),%ecx
	cmpl %ecx,%r12d
	jle L37
L36:
	movslq %ecx,%rcx
	movq (%rbx,%rcx,8),%rax
	movq %rax,_optarg(%rip)
	incl %ecx
	movl %ecx,_optind(%rip)
L35:
	movl %r13d,%eax
	jmp L3
L37:
	pushq %r13
	pushq (%rbx)
	pushq $L39
L44:
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $63,%eax
	jmp L3
L20:
	movq %rcx,L4(%rip)
L42:
	movl $-1,%eax
	jmp L3
L16:
	movq %rdi,%rdx
	movq %rbx,%rsi
	movl %r12d,%edi
	call _getopt
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L31:
	.byte 37,115,58,32,117,110,107,110
	.byte 111,119,110,32,111,112,116,105
	.byte 111,110,32,37,99,10,0
L39:
	.byte 37,115,58,32,37,99,32,97
	.byte 114,103,117,109,101,110,116,32
	.byte 109,105,115,115,105,110,103,10
	.byte 0

.globl _optarg
.globl _optind
.globl ___stderr
.globl _getopt
.globl _strchr
.globl _getoldopt
.globl _fprintf
