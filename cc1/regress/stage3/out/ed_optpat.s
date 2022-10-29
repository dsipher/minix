.text

_optpat:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $256,%rsp
L2:
	movq _inptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_inptr(%rip)
	movb (%rcx),%dl
	leaq -256(%rbp),%rcx
	jmp L4
L7:
	cmpb $10,%al
	jz L6
L5:
	cmpb $92,%al
	jnz L13
L14:
	leaq 1(%rsi),%rax
	cmpb $10,1(%rsi)
	jz L13
L11:
	movq %rax,_inptr(%rip)
	movb (%rsi),%al
	movb %al,(%rcx)
	incq %rcx
L13:
	movq _inptr(%rip),%rsi
	leaq 1(%rsi),%rax
	movq %rax,_inptr(%rip)
	movb (%rsi),%al
	movb %al,(%rcx)
	incq %rcx
L4:
	movq _inptr(%rip),%rsi
	movb (%rsi),%al
	cmpb %al,%dl
	jnz L7
L6:
	movb $0,(%rcx)
	movb -256(%rbp),%al
	movq _oldpat(%rip),%rdi
	testb %al,%al
	jz L18
L20:
	testq %rdi,%rdi
	jz L24
L22:
	call _unmakepat
L24:
	leaq -256(%rbp),%rdi
	call _getpat
	movq %rax,_oldpat(%rip)
	jmp L3
L18:
	movq %rdi,%rax
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 

.globl _oldpat
.comm _oldpat, 8, 8

.globl _unmakepat
.globl _getpat
.globl _inptr
.globl _optpat
.globl _oldpat
