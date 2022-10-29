.data
.align 4
_curln:
	.int 0
.align 4
_lastln:
	.int 0
.align 4
_version:
	.int 1
.align 4
_diag:
	.int 1
.text

_intr:
L1:
L2:
	pushq $L4
	call _printf
	addq $8,%rsp
	movl $1,%esi
	movl $_env,%edi
	call _longjmp
L3:
	ret 


_main:
L5:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L6:
	movl %edi,%r13d
	movq %rsi,%r12
	call _set_buf
	movl $1,%edi
	call _isatty
	movl %eax,%ebx
	cmpl $1,%r13d
	jle L10
L13:
	leaq 8(%r12),%r15
	movl $L11,%esi
	movq 8(%r12),%rdi
	call _strcmp
	testl %eax,%eax
	jz L18
L17:
	movl $L12,%esi
	movq 8(%r12),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L10
L18:
	movl $0,_diag(%rip)
	decl %r13d
	movq %r15,%r12
L10:
	cmpl $1,%r13d
	jle L32
L21:
	movl $1,%r15d
L24:
	cmpl %r15d,%r13d
	jle L32
L25:
	movq (%r12,%r15,8),%rsi
	xorl %edi,%edi
	call _doread
	testl %eax,%eax
	jz L28
L30:
	incl %r15d
	jmp L24
L28:
	movl $1,_curln(%rip)
	movq (%r12,%r15,8),%rsi
	movl $_fname,%edi
	call _strcpy
L32:
	movl $_env,%edi
	call ___setjmp
	movl $1,%esi
	movl $2,%edi
	call _signal
	cmpq $1,%rax
	jz L37
L35:
	movl $_intr,%esi
	movl $2,%edi
	call _signal
L37:
	testl %ebx,%ebx
	jz L40
L38:
	movl $___stdout,%edi
	call _fflush
L40:
	movl $___stdin,%edx
	movl $8192,%esi
	movl $_inlin,%edi
	call _fgets
	testq %rax,%rax
	jz L34
L45:
	xorl %esi,%esi
	movl $_inlin,%edi
	call _strchr
	movq %rax,_inptr(%rip)
	cmpq $_inlin+2,%rax
	jb L48
L56:
	cmpb $92,-2(%rax)
	jnz L48
L57:
	cmpb $10,-1(%rax)
	jnz L48
L53:
	movb $110,-1(%rax)
	movq _inptr(%rip),%rdi
	movq %rdi,%rax
	subq $_inlin,%rax
	movl $8192,%esi
	subl %eax,%esi
	movl $___stdin,%edx
	call _fgets
	testq %rax,%rax
	jnz L45
L48:
	cmpb $33,_inlin(%rip)
	jz L65
L67:
	movq $_inlin,_inptr(%rip)
	call _getlst
	cmpl $0,%eax
	jl L74
L72:
	call _ckglob
	movl %eax,%r14d
	cmpl $0,%eax
	jz L76
	jl L74
L81:
	call _doglob
	movl %eax,%r14d
	cmpl $0,%eax
	jl L74
L82:
	movl %eax,_curln(%rip)
	jmp L32
L76:
	xorl %edi,%edi
	call _docmd
	movl %eax,%r14d
	cmpl $0,%eax
	jge L86
L74:
	cmpl $-1,%r14d
	jnz L95
L93:
	xorl %edi,%edi
	call _exit
L95:
	cmpl $-3,%r14d
	jnz L98
L96:
	movl $___stderr,%esi
	movl $L99,%edi
	call _fputs
	movl $1,%edi
	call _exit
L98:
	pushq $L4
	call _printf
	addq $8,%rsp
	jmp L32
L86:
	cmpl $1,%eax
	jnz L32
L89:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _doprnt
	jmp L32
L65:
	movl $10,%esi
	movl $_inlin,%edi
	call _strchr
	movq %rax,_inptr(%rip)
	testq %rax,%rax
	jz L70
L68:
	movb $0,(%rax)
L70:
	movl $_inlin+1,%edi
	call _sys
	jmp L32
L34:
	xorl %eax,%eax
L7:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L99:
	.byte 70,65,84,65,76,32,69,82
	.byte 82,79,82,10,0
L12:
	.byte 45,115,0
L11:
	.byte 45,0
L4:
	.byte 63,10,0
.globl _line0
.comm _line0, 32, 8
.globl _line1
.comm _line1, 4, 4
.globl _line2
.comm _line2, 4, 4
.globl _nlines
.comm _nlines, 4, 4
.globl _nflg
.comm _nflg, 4, 4
.globl _lflg
.comm _lflg, 4, 4
.globl _inptr
.comm _inptr, 8, 8
.globl _env
.comm _env, 128, 8
.local _inlin
.comm _inlin, 8192, 1

.globl _doread
.globl _lastln
.globl _fname
.globl _longjmp
.globl _fgets
.globl _intr
.globl ___setjmp
.globl ___stdout
.globl _nflg
.globl _lflg
.globl _curln
.globl _set_buf
.globl _diag
.globl _version
.globl _getlst
.globl _line0
.globl _printf
.globl _line1
.globl _fflush
.globl _strcmp
.globl _nlines
.globl _isatty
.globl ___stderr
.globl _docmd
.globl _line2
.globl ___stdin
.globl _doglob
.globl _inptr
.globl _ckglob
.globl _doprnt
.globl _fputs
.globl _signal
.globl _strchr
.globl _main
.globl _exit
.globl _env
.globl _strcpy
.globl _sys
