.data
.align 8
_tbl:
	.quad L1
	.quad _nflg
	.int 1
	.fill 4, 1, 0
	.quad L2
	.quad _nflg
	.int 0
	.fill 4, 1, 0
	.quad L3
	.quad _lflg
	.int 1
	.fill 4, 1, 0
	.quad L4
	.quad _lflg
	.int 0
	.fill 4, 1, 0
	.quad L5
	.quad _eightbit
	.int 1
	.fill 4, 1, 0
	.quad L6
	.quad _eightbit
	.int 0
	.fill 4, 1, 0
	.quad 0
	.fill 16, 1, 0
.text

_set:
L7:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
L8:
	movq _inptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_inptr(%rip)
	movb 1(%rcx),%al
	cmpb $116,%al
	jz L11
L10:
	cmpb $32,%al
	jz L12
L20:
	cmpb $9,%al
	jz L12
L21:
	cmpb $10,%al
	jz L12
L17:
	movl $-2,%eax
	jmp L9
L11:
	addq $2,%rcx
	movq %rcx,_inptr(%rip)
L12:
	movq _inptr(%rip),%rax
	cmpb $10,(%rax)
	jz L25
L29:
	movq _inptr(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L33
L32:
	cmpb $9,%al
	jnz L34
L33:
	incq %rcx
	movq %rcx,_inptr(%rip)
	jmp L29
L34:
	xorl %eax,%eax
	jmp L36
L44:
	cmpb $9,%cl
	jz L42
L45:
	cmpb $10,%cl
	jz L42
L41:
	leaq 1(%rdx),%rcx
	movq %rcx,_inptr(%rip)
	movb (%rdx),%dl
	movl %eax,%ecx
	incl %eax
	movb %dl,-16(%rbp,%rcx)
L36:
	movq _inptr(%rip),%rdx
	movb (%rdx),%cl
	cmpb $32,%cl
	jnz L44
L42:
	movb $0,-16(%rbp,%rax)
	movq $_tbl,_t(%rip)
L48:
	movq _t(%rip),%rax
	movq (%rax),%rsi
	testq %rsi,%rsi
	jz L57
L49:
	leaq -16(%rbp),%rdi
	call _strcmp
	movq _t(%rip),%rcx
	testl %eax,%eax
	jz L52
L54:
	addq $24,%rcx
	movq %rcx,_t(%rip)
	jmp L48
L52:
	movl 16(%rcx),%edx
	movq 8(%rcx),%rax
	movl %edx,(%rax)
L57:
	xorl %eax,%eax
	jmp L9
L25:
	call _show
L9:
	movq %rbp,%rsp
	popq %rbp
	ret 


_show:
L58:
L59:
	movl _version(%rip),%esi
	movl $100,%ecx
	movl %esi,%eax
	cltd 
	idivl %ecx
	movl %eax,%edi
	movl $100,%ecx
	movl %esi,%eax
	cltd 
	idivl %ecx
	pushq %rdx
	pushq %rdi
	pushq $L61
	call _printf
	addq $24,%rsp
	cmpl $0,_nflg(%rip)
	movl $L64,%eax
	movl $L63,%edx
	cmovzq %rax,%rdx
	cmpl $0,_lflg(%rip)
	movl $L64,%eax
	movl $L63,%ecx
	cmovzq %rax,%rcx
	pushq %rcx
	pushq %rdx
	pushq $L62
	call _printf
	addq $24,%rsp
	xorl %eax,%eax
L60:
	ret 

L6:
	.byte 110,111,101,105,103,104,116,98
	.byte 105,116,0
L62:
	.byte 110,117,109,98,101,114,32,37
	.byte 115,44,32,108,105,115,116,32
	.byte 37,115,10,0
L1:
	.byte 110,117,109,98,101,114,0
L5:
	.byte 101,105,103,104,116,98,105,116
	.byte 0
L4:
	.byte 110,111,108,105,115,116,0
L2:
	.byte 110,111,110,117,109,98,101,114
	.byte 0
L64:
	.byte 79,70,70,0
L63:
	.byte 79,78,0
L3:
	.byte 108,105,115,116,0
L61:
	.byte 101,100,32,118,101,114,115,105
	.byte 111,110,32,37,100,46,37,100
	.byte 10,0
.globl _t
.comm _t, 8, 8

.globl _t
.globl _nflg
.globl _lflg
.globl _version
.globl _printf
.globl _strcmp
.globl _eightbit
.globl _inptr
.globl _set
.globl _show
.globl _tbl
