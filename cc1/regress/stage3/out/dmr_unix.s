.data
.align 4
_Cplusplus:
	.int 1
.text

_setup:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl %edi,%r12d
	movq %rsi,%rbx
	call _setup_kwtab
L4:
	movl $L7,%edx
	movq %rbx,%rsi
	movl %r12d,%edi
	call _getopt
	movl %eax,%r13d
	cmpl $-1,%r13d
	jz L6
L5:
	cmpl $43,%r13d
	jz L45
	jl L4
L73:
	cmpl $118,%r13d
	jz L40
	jg L4
L74:
	cmpb $68,%r13b
	jz L35
L75:
	cmpb $73,%r13b
	jz L20
L76:
	cmpb $77,%r13b
	jz L38
L77:
	cmpb $78,%r13b
	jz L11
L78:
	cmpb $85,%r13b
	jz L35
L79:
	cmpb $86,%r13b
	jnz L4
L43:
	incl _verbose(%rip)
	jmp L4
L11:
	xorl %eax,%eax
L13:
	movslq %eax,%rcx
	shlq $4,%rcx
	cmpb $1,_includelist+1(%rcx)
	jnz L18
L16:
	movb $1,_includelist(%rcx)
L18:
	incl %eax
	cmpl $32,%eax
	jl L13
	jge L4
L38:
	incl _Mflag(%rip)
	jmp L4
L20:
	movl $30,%eax
L22:
	movslq %eax,%rdx
	shlq $4,%rdx
	cmpq $0,_includelist+8(%rdx)
	jz L25
L27:
	decl %eax
	jns L22
	js L24
L25:
	movb $1,_includelist+1(%rdx)
	movq _optarg(%rip),%rcx
	movq %rcx,_includelist+8(%rdx)
L24:
	cmpl $0,%eax
	jge L4
L29:
	pushq $L32
	pushq $2
	call _error
	addq $16,%rsp
	jmp L4
L35:
	movq _optarg(%rip),%rdx
	xorl %esi,%esi
	movl $L36,%edi
	call _setsource
	leaq -32(%rbp),%rsi
	movl $3,%edi
	call _maketokenrow
	movl $1,%esi
	leaq -32(%rbp),%rdi
	call _gettokens
	movl %r13d,%esi
	leaq -32(%rbp),%rdi
	call _doadefine
	call _unsetsource
	jmp L4
L40:
	pushq $_rcsid
	pushq (%rbx)
	pushq $L41
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L4
L45:
	incl _Cplusplus(%rip)
	jmp L4
L6:
	movl _optind(%rip),%eax
	movl $L48,%r15d
	movl $L49,%r14d
	movl $___stdin,%r13d
	cmpl %eax,%r12d
	jle L52
L50:
	movslq %eax,%rax
	movl $47,%esi
	movq (%rbx,%rax,8),%rdi
	call _strrchr
	movq %rax,%r13
	testq %r13,%r13
	jz L55
L53:
	movslq _optind(%rip),%rax
	movq (%rbx,%rax,8),%rdi
	subq %rdi,%r13
	xorl %edx,%edx
	leal 1(%r13),%esi
	call _newstring
	movq %rax,%r15
	movslq %r13d,%r13
	movb $0,(%rax,%r13)
L55:
	movslq _optind(%rip),%rax
	movq (%rbx,%rax,8),%r13
	movq %r13,%rdi
	call _strlen
	xorl %edx,%edx
	movl %eax,%esi
	movq %r13,%rdi
	call _newstring
	movq %rax,%r14
	movl $L59,%esi
	movq %r14,%rdi
	call _fopen
	movq %rax,%r13
	testq %rax,%rax
	jnz L52
L56:
	pushq %r14
	pushq $L60
	pushq $2
	call _error
	addq $24,%rsp
L52:
	movl _optind(%rip),%eax
	incl %eax
	cmpl %eax,%r12d
	jle L63
L61:
	movslq %eax,%rax
	movl $___stdout,%edx
	movl $L64,%esi
	movq (%rbx,%rax,8),%rdi
	call _freopen
	testq %rax,%rax
	jnz L63
L65:
	movl _optind(%rip),%eax
	incl %eax
	movslq %eax,%rax
	pushq (%rbx,%rax,8)
	pushq $L68
	pushq $2
	call _error
	addq $24,%rsp
L63:
	cmpl $0,_Mflag(%rip)
	jz L71
L69:
	movq %r14,%rdi
	call _setobjname
L71:
	movb $0,_includelist+497(%rip)
	movq %r15,_includelist+504(%rip)
	xorl %edx,%edx
	movq %r13,%rsi
	movq %r14,%rdi
	call _setsource
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_memmove:
L82:
L83:
	testq %rdx,%rdx
	jz L99
L87:
	cmpq %rsi,%rdi
	jae L90
L92:
	movzbl (%rsi),%eax
	incq %rsi
	movb %al,(%rdi)
	incq %rdi
	decq %rdx
	jnz L92
	jz L99
L90:
	addq %rdx,%rdi
	addq %rdx,%rsi
L95:
	leaq -1(%rsi),%rax
	movzbl -1(%rsi),%ecx
	movq %rax,%rsi
	leaq -1(%rdi),%rax
	movb %cl,-1(%rdi)
	movq %rax,%rdi
	decq %rdx
	jnz L95
L99:
	xorl %eax,%eax
L84:
	ret 

L49:
 .byte 60,115,116,100,105,110,62,0
L7:
 .byte 77,78,79,86,118,43,73,58
 .byte 68,58,85,58,70,58,108,103
 .byte 0
L60:
 .byte 67,97,110,39,116,32,111,112
 .byte 101,110,32,105,110,112,117,116
 .byte 32,102,105,108,101,32,37,115
 .byte 0
L41:
 .byte 37,115,32,37,115,10,0
L68:
 .byte 67,97,110,39,116,32,111,112
 .byte 101,110,32,111,117,116,112,117
 .byte 116,32,102,105,108,101,32,37
 .byte 115,0
L36:
 .byte 60,99,109,100,97,114,103,62
 .byte 0
L48:
 .byte 46,0
L59:
 .byte 114,0
L64:
 .byte 119,0
L32:
 .byte 84,111,111,32,109,97,110,121
 .byte 32,45,73,32,100,105,114,101
 .byte 99,116,105,118,101,115,0
.comm _Mflag, 4, 4
.comm _verbose, 4, 4
.comm _objname, 8, 8

.globl _objname
.globl _optarg
.globl _error
.globl _fopen
.globl ___stdout
.globl _optind
.globl _rcsid
.globl _includelist
.globl _unsetsource
.globl _verbose
.globl _setobjname
.globl _Mflag
.globl _Cplusplus
.globl _strrchr
.globl _newstring
.globl _setsource
.globl ___stderr
.globl ___stdin
.globl _setup_kwtab
.globl _setup
.globl _getopt
.globl _maketokenrow
.globl _doadefine
.globl _gettokens
.globl _memmove
.globl _strlen
.globl _freopen
.globl _fprintf
