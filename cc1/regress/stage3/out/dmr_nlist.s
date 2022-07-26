.data
.align 8
_kwtab:
	.quad L1
	.int 0
	.int 2
	.quad L2
	.int 1
	.int 2
	.quad L3
	.int 2
	.int 2
	.quad L4
	.int 3
	.int 2
	.quad L5
	.int 4
	.int 2
	.quad L6
	.int 5
	.int 2
	.quad L7
	.int 6
	.int 2
	.quad L8
	.int 7
	.int 2
	.quad L9
	.int 8
	.int 2
	.quad L10
	.int 9
	.int 2
	.quad L11
	.int 10
	.int 2
	.quad L12
	.int 11
	.int 2
	.quad L13
	.int 18
	.int 2
	.quad L14
	.int 12
	.int 5
	.quad L15
	.int 11
	.int 2
	.quad L16
	.int 13
	.int 12
	.quad L17
	.int 14
	.int 12
	.quad L18
	.int 15
	.int 12
	.quad L19
	.int 16
	.int 12
	.quad L20
	.int 17
	.int 4
	.quad 0
	.fill 8, 1, 0
.align 8
L24:
	.byte 2
	.byte 0
	.short 0
	.int 0
	.int 7
	.fill 4, 1, 0
	.quad L14
.align 8
L25:
	.quad L24
	.quad L24
	.quad L24+24
	.int 1
	.fill 4, 1, 0
.text

_setup_kwtab:
L21:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
L22:
	movl $_kwtab,%ebx
L26:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L23
L27:
	movq %rax,-8(%rbp)
	movq (%rbx),%rdi
	call _strlen
	movl %eax,-16(%rbp)
	movl $1,%esi
	leaq -24(%rbp),%rdi
	call _lookup
	movl 12(%rbx),%ecx
	movb %cl,41(%rax)
	movl 8(%rbx),%ecx
	movb %cl,40(%rax)
	cmpb $12,%cl
	jnz L32
L30:
	movq %rax,_kwdefined(%rip)
	movb $2,40(%rax)
	movq $L25,24(%rax)
	movq $0,32(%rax)
L32:
	addq $16,%rbx
	jmp L26
L23:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lookup:
L33:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L34:
	movq %rdi,%r12
	movl %esi,%ebx
	xorl %r13d,%r13d
	movq 16(%r12),%rdx
	movl 8(%r12),%ecx
	addq %rdx,%rcx
L36:
	cmpq %rcx,%rdx
	jae L39
L37:
	movzbl (%rdx),%eax
	incq %rdx
	addl %eax,%r13d
	cmpq %rcx,%rdx
	jb L37
L39:
	andl $127,%r13d
	movq _nlist(,%r13,8),%r14
L40:
	testq %r14,%r14
	jz L42
L41:
	movq 16(%r12),%rdi
	movzbl (%rdi),%eax
	movq 8(%r14),%rsi
	cmpb (%rsi),%al
	jnz L45
L50:
	movl 8(%r12),%edx
	cmpl 16(%r14),%edx
	jnz L45
L46:
	call _strncmp
	testl %eax,%eax
	jz L43
L45:
	movq (%r14),%r14
	jmp L40
L43:
	movq %r14,%rax
	jmp L35
L42:
	testl %ebx,%ebx
	jnz L55
L57:
	xorl %eax,%eax
	jmp L35
L55:
	movl $48,%edi
	call _domalloc
	movq %rax,%rbx
	movq $0,24(%rbx)
	movq $0,32(%rbx)
	movb $0,41(%rbx)
	movb $0,40(%rbx)
	movl 8(%r12),%eax
	movl %eax,16(%rbx)
	movq 16(%r12),%rdi
	xorl %edx,%edx
	movl 8(%r12),%esi
	call _newstring
	movq %rax,8(%rbx)
	movl %r13d,%r13d
	movq _nlist(,%r13,8),%rax
	movq %rax,(%rbx)
	movq %rbx,_nlist(,%r13,8)
	cmpl $1,8(%r12)
	jbe L59
L58:
	movq 16(%r12),%rax
	movzbl 1(%rax),%ecx
	jmp L60
L59:
	xorl %ecx,%ecx
L60:
	andl $31,%ecx
	movl $1,%edx
	shll %cl,%edx
	movslq %edx,%rdx
	movq 16(%r12),%rax
	movzbl (%rax),%eax
	andl $63,%eax
	movzbq %al,%rax
	orq %rdx,_namebit(,%rax,8)
	movq %rbx,%rax
L35:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L9:
 .byte 117,110,100,101,102,0
L7:
 .byte 105,110,99,108,117,100,101,0
L2:
 .byte 105,102,100,101,102,0
L20:
 .byte 95,95,83,84,68,67,95,95
 .byte 0
L10:
 .byte 108,105,110,101,0
L11:
 .byte 101,114,114,111,114,0
L18:
 .byte 95,95,68,65,84,69,95,95
 .byte 0
L15:
 .byte 105,100,101,110,116,0
L13:
 .byte 101,118,97,108,0
L16:
 .byte 95,95,76,73,78,69,95,95
 .byte 0
L1:
 .byte 105,102,0
L5:
 .byte 101,108,115,101,0
L19:
 .byte 95,95,84,73,77,69,95,95
 .byte 0
L14:
 .byte 100,101,102,105,110,101,100,0
L12:
 .byte 112,114,97,103,109,97,0
L4:
 .byte 101,108,105,102,0
L6:
 .byte 101,110,100,105,102,0
L17:
 .byte 95,95,70,73,76,69,95,95
 .byte 0
L8:
 .byte 100,101,102,105,110,101,0
L3:
 .byte 105,102,110,100,101,102,0
.comm _namebit, 512, 8
.comm _kwdefined, 8, 8
.local _nlist
.comm _nlist, 1024, 8
.comm _np, 8, 8

.globl _kwdefined
.globl _kwtab
.globl _namebit
.globl _np
.globl _domalloc
.globl _strncmp
.globl _newstring
.globl _setup_kwtab
.globl _lookup
.globl _strlen
