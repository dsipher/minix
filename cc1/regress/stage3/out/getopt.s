.data
.align 4
_opterr:
	.int 1
.align 4
_optind:
	.int 1
.align 4
L4:
	.int 1
.text

_getopt:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movl %edi,%r14d
	movq %rsi,%r13
	movq %rdx,%r12
	cmpl $1,L4(%rip)
	jnz L7
L5:
	movl _optind(%rip),%eax
	cmpl %eax,%r14d
	jle L58
L15:
	movslq %eax,%rax
	movq (%r13,%rax,8),%rdi
	cmpb $45,(%rdi)
	jnz L58
L17:
	cmpb $0,1(%rdi)
	jz L58
L13:
	movl $L23,%esi
	call _strcmp
	testl %eax,%eax
	jz L20
L7:
	movslq _optind(%rip),%rax
	movq (%r13,%rax,8),%rcx
	movslq L4(%rip),%rax
	movsbl (%rcx,%rax),%ebx
	movl %ebx,_optopt(%rip)
	cmpl $58,%ebx
	jz L29
L28:
	movl %ebx,%esi
	movq %r12,%rdi
	call _strchr
	testq %rax,%rax
	jnz L30
L29:
	cmpl $0,_opterr(%rip)
	jz L34
L32:
	pushq %rbx
	pushq (%r13)
	pushq $L35
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L34:
	movl _optind(%rip),%edx
	movslq %edx,%rax
	movq (%r13,%rax,8),%rcx
	movl L4(%rip),%eax
	incl %eax
	movl %eax,L4(%rip)
	movslq %eax,%rax
	cmpb $0,(%rcx,%rax)
	jnz L59
L36:
	incl %edx
	movl %edx,_optind(%rip)
	jmp L60
L30:
	movb 1(%rax),%r8b
	movl _optind(%rip),%edi
	movl L4(%rip),%esi
	movslq %edi,%rdx
	incl %esi
	movslq %esi,%rcx
	movq (%r13,%rdx,8),%rax
	cmpb $58,%r8b
	jnz L41
L40:
	cmpb $0,(%rcx,%rax)
	jz L44
L43:
	incl %edi
	movl %edi,_optind(%rip)
	addq (%r13,%rdx,8),%rcx
	movq %rcx,_optarg(%rip)
	jmp L45
L44:
	leal 1(%rdi),%eax
	movl %eax,_optind(%rip)
	cmpl %eax,%r14d
	jg L47
L46:
	cmpl $0,_opterr(%rip)
	jz L60
L49:
	pushq %rbx
	pushq (%r13)
	pushq $L52
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L60:
	movl $1,L4(%rip)
L59:
	movl $63,%eax
	jmp L3
L47:
	addl $2,%edi
	movl %edi,_optind(%rip)
	movslq %eax,%rax
	movq (%r13,%rax,8),%rax
	movq %rax,_optarg(%rip)
L45:
	movl $1,L4(%rip)
	jmp L42
L41:
	movl %esi,L4(%rip)
	cmpb $0,(%rcx,%rax)
	jnz L56
L54:
	movl $1,L4(%rip)
	incl %edi
	movl %edi,_optind(%rip)
L56:
	movq $0,_optarg(%rip)
L42:
	movl %ebx,%eax
	jmp L3
L20:
	incl _optind(%rip)
L58:
	movl $-1,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L35:
 .byte 37,115,58,32,105,108,108,101
 .byte 103,97,108,32,111,112,116,105
 .byte 111,110,32,45,45,32,37,99
 .byte 10,0
L23:
 .byte 45,45,0
L52:
 .byte 37,115,58,32,111,112,116,105
 .byte 111,110,32,114,101,113,117,105
 .byte 114,101,115,32,97,110,32,97
 .byte 114,103,117,109,101,110,116,32
 .byte 45,45,32,37,99,10,0
.comm _optarg, 8, 8
.comm _optopt, 4, 4

.globl _optarg
.globl _optind
.globl _optopt
.globl _strcmp
.globl ___stderr
.globl _opterr
.globl _getopt
.globl _strchr
.globl _fprintf
