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
	movl %edi,%r15d
	movq %rsi,%r14
	call _setup_kwtab
L4:
	movl $L7,%edx
	movq %r14,%rsi
	movl %r15d,%edi
	call _getopt
	movl %eax,%ebx
	cmpl $-1,%ebx
	jz L6
L5:
	cmpl $43,%ebx
	jz L45
	jl L4
L73:
	cmpl $118,%ebx
	jz L40
	jg L4
L74:
	cmpb $68,%bl
	jz L35
L75:
	cmpb $73,%bl
	jz L20
L76:
	cmpb $77,%bl
	jz L38
L77:
	cmpb $78,%bl
	jz L11
L78:
	cmpb $85,%bl
	jz L35
L79:
	cmpb $86,%bl
	jnz L4
L43:
	incl _verbose(%rip)
	jmp L4
L11:
	xorl %ecx,%ecx
L13:
	movl %ecx,%eax
	shlq $4,%rax
	cmpb $1,_includelist+1(%rax)
	jnz L18
L16:
	movb $1,_includelist(%rax)
L18:
	incl %ecx
	cmpl $32,%ecx
	jl L13
	jge L4
L38:
	incl _Mflag(%rip)
	jmp L4
L20:
	movl $30,%edx
L22:
	movslq %edx,%rcx
	shlq $4,%rcx
	cmpq $0,_includelist+8(%rcx)
	jz L25
L27:
	decl %edx
	jns L22
	js L24
L25:
	movb $1,_includelist+1(%rcx)
	movq _optarg(%rip),%rax
	movq %rax,_includelist+8(%rcx)
L24:
	cmpl $0,%edx
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
	movl %ebx,%esi
	leaq -32(%rbp),%rdi
	call _doadefine
	call _unsetsource
	jmp L4
L40:
	pushq $_rcsid
	pushq (%r14)
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
	movl $L48,%r13d
	movl $L49,%r12d
	movl $___stdin,%ebx
	cmpl %eax,%r15d
	jle L52
L50:
	movslq %eax,%rax
	movl $47,%esi
	movq (%r14,%rax,8),%rdi
	call _strrchr
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L55
L53:
	movslq _optind(%rip),%rax
	movq (%r14,%rax,8),%rdi
	subq %rdi,%rbx
	xorl %edx,%edx
	leal 1(%rbx),%esi
	call _newstring
	movq %rax,%r13
	movslq %ebx,%rcx
	movb $0,(%rax,%rcx)
L55:
	movslq _optind(%rip),%rax
	movq (%r14,%rax,8),%rbx
	movq %rbx,%rdi
	call _strlen
	xorl %edx,%edx
	movl %eax,%esi
	movq %rbx,%rdi
	call _newstring
	movq %rax,%r12
	movl $L59,%esi
	movq %r12,%rdi
	call _fopen
	movq %rax,%rbx
	testq %rax,%rax
	jnz L52
L56:
	pushq %r12
	pushq $L60
	pushq $2
	call _error
	addq $24,%rsp
L52:
	movl _optind(%rip),%eax
	incl %eax
	cmpl %eax,%r15d
	jle L63
L61:
	movslq %eax,%rax
	movl $___stdout,%edx
	movl $L64,%esi
	movq (%r14,%rax,8),%rdi
	call _freopen
	testq %rax,%rax
	jnz L63
L65:
	movl _optind(%rip),%eax
	incl %eax
	movslq %eax,%rax
	pushq (%r14,%rax,8)
	pushq $L68
	pushq $2
	call _error
	addq $24,%rsp
L63:
	cmpl $0,_Mflag(%rip)
	jz L71
L69:
	movq %r12,%rdi
	call _setobjname
L71:
	movb $0,_includelist+497(%rip)
	movq %r13,_includelist+504(%rip)
	xorl %edx,%edx
	movq %rbx,%rsi
	movq %r12,%rdi
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
	movb (%rsi),%al
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
	movb -1(%rsi),%cl
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
.globl _Mflag
.comm _Mflag, 4, 4
.globl _verbose
.comm _verbose, 4, 4
.globl _objname
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
