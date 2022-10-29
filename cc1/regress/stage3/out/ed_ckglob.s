.text

_ckglob:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8192,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq _inptr(%rip),%rax
	movb (%rax),%bl
	cmpb $103,%bl
	jz L6
L7:
	cmpb $118,%bl
	jz L6
L4:
	xorl %eax,%eax
	jmp L3
L6:
	movl _lastln(%rip),%esi
	movl $1,%edi
	call _deflt
	cmpl $0,%eax
	jl L45
L14:
	movq _inptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_inptr(%rip)
	movb 1(%rcx),%r12b
	cmpb $32,%r12b
	jg L18
L45:
	movl $-2,%eax
	jmp L3
L18:
	call _optpat
	movq %rax,%r14
	movq _inptr(%rip),%rax
	cmpb (%rax),%r12b
	jnz L22
L20:
	incq %rax
	movq %rax,_inptr(%rip)
L22:
	movl $1,%edi
	call _getptr
	movq %rax,%r13
	movl $1,%r12d
	jmp L23
L24:
	andl $-3,(%r13)
	cmpl _line1(%rip),%r12d
	jl L29
L30:
	cmpl _line2(%rip),%r12d
	jg L29
L27:
	leaq 24(%r13),%rsi
	leaq -8192(%rbp),%rdi
	call _strcpy
	movl $L34,%esi
	leaq -8192(%rbp),%rdi
	call _strcat
	xorl %edx,%edx
	movq %r14,%rsi
	leaq -8192(%rbp),%rdi
	call _matchs
	testq %rax,%rax
	jz L36
L35:
	cmpb $103,%bl
	jnz L29
	jz L46
L36:
	cmpb $118,%bl
	jnz L29
L46:
	orl $2,(%r13)
L29:
	movq 16(%r13),%r13
	incl %r12d
L23:
	cmpl %r12d,_lastln(%rip)
	jge L24
L26:
	movl $1,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L34:
	.byte 10,0

.globl _lastln
.globl _matchs
.globl _line1
.globl _strcat
.globl _getptr
.globl _line2
.globl _inptr
.globl _ckglob
.globl _deflt
.globl _optpat
.globl _strcpy
