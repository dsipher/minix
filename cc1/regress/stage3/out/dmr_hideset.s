.data
.align 4
_nhidesets:
	.int 0
.align 4
_maxhidesets:
	.int 3
.text

_checkhideset:
L1:
	pushq %rbx
	pushq %r12
L2:
	movl %edi,%ebx
	movq %rsi,%r12
	cmpl _nhidesets(%rip),%ebx
	jl L6
L4:
	call _abort
L6:
	movslq %ebx,%rbx
	movq _hidesets(%rip),%rax
	movq (%rax,%rbx,8),%rcx
L7:
	movq (%rcx),%rax
	testq %rax,%rax
	jz L10
L8:
	cmpq %rax,%r12
	jz L11
L13:
	addq $8,%rcx
	jmp L7
L11:
	movl $1,%eax
	jmp L3
L10:
	xorl %eax,%eax
L3:
	popq %r12
	popq %rbx
	ret 


_newhideset:
L16:
	pushq %rbp
	movq %rsp,%rbp
	subq $280,%rsp
	pushq %rbx
	pushq %r12
L17:
	movl %edi,%r12d
	movslq %r12d,%rcx
	movq _hidesets(%rip),%rax
	movq %rsi,%rdx
	movq (%rax,%rcx,8),%rsi
	leaq -280(%rbp),%rdi
	call _inserths
	movl %eax,%ebx
	xorl %eax,%eax
L19:
	movl _nhidesets(%rip),%ecx
	cmpl %ecx,%eax
	jge L22
L20:
	leaq -280(%rbp),%rsi
	movslq %eax,%rcx
	movq _hidesets(%rip),%rdx
	movq (%rdx,%rcx,8),%rdx
L23:
	movq (%rsi),%rcx
	cmpq (%rdx),%rcx
	jnz L26
L24:
	testq %rcx,%rcx
	jz L18
L29:
	addq $8,%rsi
	addq $8,%rdx
	jmp L23
L26:
	incl %eax
	jmp L19
L22:
	cmpl $32,%ebx
	jge L31
L33:
	movl _maxhidesets(%rip),%eax
	cmpl %eax,%ecx
	jl L37
L35:
	leal (%rax,%rax,2),%eax
	movl $2,%ecx
	cltd 
	idivl %ecx
	incl %eax
	movl %eax,_maxhidesets(%rip)
	movslq %eax,%rsi
	shlq $3,%rsi
	movq _hidesets(%rip),%rdi
	call _realloc
	movslq %eax,%rax
	movq %rax,_hidesets(%rip)
	testq %rax,%rax
	jnz L37
L38:
	pushq $L41
	pushq $2
	call _error
	addq $16,%rsp
L37:
	leal (,%rbx,8),%edi
	call _domalloc
	movq %rax,%r12
	movslq %ebx,%rdx
	shlq $3,%rdx
	leaq -280(%rbp),%rsi
	movq %r12,%rdi
	call _memmove
	movslq _nhidesets(%rip),%rax
	movq _hidesets(%rip),%rcx
	movq %r12,(%rcx,%rax,8)
	movl _nhidesets(%rip),%eax
	leal 1(%rax),%ecx
	movl %ecx,_nhidesets(%rip)
	jmp L18
L31:
	movl %r12d,%eax
L18:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_inserths:
L43:
L44:
	movq %rdi,%rax
	movq %rax,%rdi
L46:
	movq (%rsi),%rcx
	testq %rcx,%rcx
	jz L48
L49:
	cmpq %rcx,%rdx
	jbe L48
L47:
	addq $8,%rsi
	movq %rcx,(%rax)
	addq $8,%rax
	jmp L46
L48:
	cmpq %rcx,%rdx
	jz L56
L53:
	movq %rdx,(%rax)
	addq $8,%rax
L56:
	movq (%rsi),%rcx
	movq %rcx,(%rax)
	addq $8,%rax
	movq (%rsi),%rcx
	addq $8,%rsi
	testq %rcx,%rcx
	jnz L56
L57:
	subq %rdi,%rax
	movl $8,%ecx
	cqto 
	idivq %rcx
L45:
	ret 


_unionhideset:
L60:
	pushq %rbx
L61:
	movslq %esi,%rsi
	movq _hidesets(%rip),%rax
	movq (%rax,%rsi,8),%rbx
L63:
	movq (%rbx),%rsi
	testq %rsi,%rsi
	jz L66
L64:
	call _newhideset
	movl %eax,%edi
	addq $8,%rbx
	jmp L63
L66:
	movl %edi,%eax
L62:
	popq %rbx
	ret 


_iniths:
L68:
L69:
	movl _maxhidesets(%rip),%edi
	shll $3,%edi
	call _domalloc
	movq %rax,_hidesets(%rip)
	movl $8,%edi
	call _domalloc
	movq _hidesets(%rip),%rcx
	movq %rax,(%rcx)
	movq _hidesets(%rip),%rax
	movq (%rax),%rax
	movq $0,(%rax)
	incl _nhidesets(%rip)
L70:
	ret 


_prhideset:
L71:
	pushq %rbx
L72:
	movslq %edi,%rdi
	movq _hidesets(%rip),%rax
	movq (%rax,%rdi,8),%rbx
L74:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L73
L75:
	movq 8(%rax),%rcx
	movl 16(%rax),%eax
	pushq %rax
	pushq %rcx
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	pushq $L78
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	addq $8,%rbx
	jmp L74
L73:
	popq %rbx
	ret 

L41:
 .byte 79,117,116,32,111,102,32,109
 .byte 101,109,111,114,121,32,102,114
 .byte 111,109,32,114,101,97,108,108
 .byte 111,99,0
L78:
 .byte 32,0
.comm _hidesets, 8, 8

.globl _newhideset
.globl _iniths
.globl _checkhideset
.globl _unionhideset
.globl _realloc
.globl _error
.globl _prhideset
.globl _domalloc
.globl _abort
.globl _inserths
.globl ___stderr
.globl _maxhidesets
.globl _nhidesets
.globl _hidesets
.globl _memmove
.globl _fprintf
