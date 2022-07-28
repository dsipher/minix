.text

_doinclude:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $520,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r15
	movq (%r15),%rcx
	leaq 24(%rcx),%rax
	movq %rax,(%r15)
	cmpq 16(%r15),%rax
	jae L7
L6:
	movb 24(%rcx),%cl
	cmpb $4,%cl
	jz L11
L12:
	cmpb $33,%cl
	jz L11
L9:
	subq 8(%r15),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%ebx
	movl $L16,%esi
	movq %r15,%rdi
	call _expandrow
	movq 8(%r15),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	addq %rax,%rcx
	movq %rcx,(%r15)
L11:
	movq (%r15),%rcx
	movb (%rcx),%al
	cmpb $4,%al
	jnz L18
L17:
	movl 8(%rcx),%ebx
	subl $2,%ebx
	cmpl $255,%ebx
	movl $255,%eax
	cmovgl %eax,%ebx
	movq 16(%rcx),%rsi
	movslq %ebx,%rdx
	incq %rsi
	leaq -256(%rbp),%rdi
	call _strncpy
	movl $0,-516(%rbp)
	jmp L19
L18:
	cmpb $33,%al
	jnz L7
L23:
	xorl %ebx,%ebx
	addq $24,%rcx
	movq %rcx,(%r15)
L26:
	movq (%r15),%rcx
	cmpb $34,(%rcx)
	jz L28
L27:
	cmpq 16(%r15),%rcx
	ja L7
L32:
	movl 8(%rcx),%edx
	leal 2(%rdx,%rbx),%eax
	cmpl $256,%eax
	jae L7
L31:
	movslq %ebx,%rax
	movq 16(%rcx),%rsi
	leaq -256(%rbp,%rax),%rdi
	call _strncpy
	movq (%r15),%rax
	addl 8(%rax),%ebx
	addq $24,%rax
	movq %rax,(%r15)
	jmp L26
L28:
	movl $1,-516(%rbp)
L19:
	movq (%r15),%rax
	addq $48,%rax
	movq %rax,(%r15)
	cmpq 16(%r15),%rax
	jb L7
L41:
	testl %ebx,%ebx
	jnz L40
L7:
	pushq $L100
	pushq $1
	call _error
	addq $16,%rsp
	jmp L3
L40:
	movslq %ebx,%rbx
	movb $0,-256(%rbp,%rbx)
	cmpb $47,-256(%rbp)
	jnz L47
L46:
	movl $L49,%esi
	leaq -256(%rbp),%rdi
	call _fopen
	movq %rax,%r14
	leaq -256(%rbp),%rsi
	leaq -512(%rbp),%rdi
	call _strcpy
	jmp L48
L47:
	xorl %r14d,%r14d
	movl $31,%r13d
L51:
	movslq %r13d,%r12
	shlq $4,%r12
	cmpq $0,_includelist+8(%r12)
	jz L52
L61:
	cmpb $0,_includelist(%r12)
	jnz L52
L57:
	cmpl $0,-516(%rbp)
	jz L56
L65:
	cmpb $0,_includelist+1(%r12)
	jz L52
L56:
	leaq -256(%rbp),%rdi
	call _strlen
	movq %rax,%rbx
	movq _includelist+8(%r12),%rdi
	call _strlen
	leaq 2(%rbx,%rax),%rax
	cmpq $256,%rax
	ja L52
L72:
	movq _includelist+8(%r12),%rsi
	leaq -512(%rbp),%rdi
	call _strcpy
	movl $L74,%esi
	leaq -512(%rbp),%rdi
	call _strcat
	leaq -256(%rbp),%rsi
	leaq -512(%rbp),%rdi
	call _strcat
	movl $L49,%esi
	leaq -512(%rbp),%rdi
	call _fopen
	movq %rax,%r14
	testq %rax,%rax
	jnz L48
L52:
	decl %r13d
	jns L51
L48:
	movl _Mflag(%rip),%eax
	cmpl $1,%eax
	jg L79
L82:
	cmpl $0,-516(%rbp)
	jnz L81
L86:
	cmpl $1,%eax
	jnz L81
L79:
	movq _objname(%rip),%rdi
	call _strlen
	movl $___stdout,%ecx
	movq %rax,%rdx
	movl $1,%esi
	movq _objname(%rip),%rdi
	call _fwrite
	leaq -512(%rbp),%rdi
	call _strlen
	movl $___stdout,%ecx
	movq %rax,%rdx
	movl $1,%esi
	leaq -512(%rbp),%rdi
	call _fwrite
	movl $___stdout,%ecx
	movl $1,%edx
	movl $1,%esi
	movl $L90,%edi
	call _fwrite
L81:
	testq %r14,%r14
	jz L92
L91:
	movl _incdepth(%rip),%eax
	incl %eax
	movl %eax,_incdepth(%rip)
	cmpl $10,%eax
	jle L96
L94:
	pushq $L97
	pushq $2
	call _error
	addq $16,%rsp
L96:
	leaq -512(%rbp),%rdi
	call _strlen
	xorl %edx,%edx
	movl %eax,%esi
	leaq -512(%rbp),%rdi
	call _newstring
	xorl %edx,%edx
	movq %r14,%rsi
	movq %rax,%rdi
	call _setsource
	call _genline
	jmp L3
L92:
	movq 8(%r15),%rax
	addq $48,%rax
	movq %rax,(%r15)
	pushq %r15
	pushq $L98
	pushq $1
	call _error
	addq $24,%rsp
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
L105:
	.byte 1
	.fill 23, 1, 0
.align 8
L106:
	.quad L105
	.quad L105
	.quad L105+24
	.int 1
	.fill 4, 1, 0
.text

_genline:
L102:
	pushq %rbx
L103:
	movq _outp(%rip),%rbx
	movq %rbx,L105+16(%rip)
	movl $L107,%esi
	movq %rbx,%rdi
	call _strcpy
	movq _cursource(%rip),%rax
	movl 8(%rax),%esi
	leaq 6(%rbx),%rdi
	call _outnum
	movq %rax,%rbx
	movb $32,(%rbx)
	movb $34,1(%rbx)
	movq _cursource(%rip),%rax
	movq (%rax),%rsi
	leaq 2(%rbx),%rdi
	call _strcpy
	leaq 2(%rbx),%rdi
	call _strlen
	movb $34,2(%rbx,%rax)
	movb $10,3(%rbx,%rax)
	leaq 4(%rbx,%rax),%rcx
	movq %rcx,%rax
	subq _outp(%rip),%rax
	movl %eax,L105+8(%rip)
	movq %rcx,_outp(%rip)
	movq L106+8(%rip),%rax
	movq %rax,L106(%rip)
	movl $L106,%edi
	call _puttokens
L104:
	popq %rbx
	ret 


_setobjname:
L108:
	pushq %rbx
	pushq %r12
L109:
	movq %rdi,%r12
	movq %r12,%rdi
	call _strlen
	movl %eax,%ebx
	leal 5(%rbx),%edi
	call _domalloc
	movq %rax,_objname(%rip)
	movq %r12,%rsi
	movq %rax,%rdi
	call _strcpy
	movl %ebx,%eax
	subl $2,%eax
	movslq %eax,%rax
	movq _objname(%rip),%rdi
	movslq %ebx,%rbx
	cmpb $46,(%rax,%rdi)
	jnz L112
L111:
	movl $L114,%esi
	leaq -1(%rdi,%rbx),%rdi
	call _strcpy
	jmp L110
L112:
	movl $L114,%esi
	addq %rbx,%rdi
	call _strcpy
L110:
	popq %r12
	popq %rbx
	ret 

L98:
 .byte 67,111,117,108,100,32,110,111
 .byte 116,32,102,105,110,100,32,105
 .byte 110,99,108,117,100,101,32,102
 .byte 105,108,101,32,37,114,0
L107:
 .byte 35,108,105,110,101,32,0
L90:
 .byte 10,0
L16:
 .byte 60,105,110,99,108,117,100,101
 .byte 62,0
L97:
 .byte 35,105,110,99,108,117,100,101
 .byte 32,116,111,111,32,100,101,101
 .byte 112,108,121,32,110,101,115,116
 .byte 101,100,0
L49:
 .byte 114,0
L74:
 .byte 47,0
L114:
 .byte 36,79,58,32,0
L100:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,105,110,99,108,117,100,101
 .byte 0
.comm _includelist, 512, 8

.globl _cursource
.globl _objname
.globl _puttokens
.globl _outnum
.globl _strncpy
.globl _error
.globl _fopen
.globl ___stdout
.globl _includelist
.globl _domalloc
.globl _genline
.globl _strcat
.globl _setobjname
.globl _Mflag
.globl _newstring
.globl _setsource
.globl _incdepth
.globl _outp
.globl _doinclude
.globl _fwrite
.globl _expandrow
.globl _strlen
.globl _strcpy
