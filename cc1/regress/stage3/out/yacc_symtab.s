.text

_hash:
L1:
	pushq %rbx
L2:
	movq %rdi,%rbx
	testq %rbx,%rbx
	jz L4
L7:
	cmpb $0,(%rbx)
	jnz L6
L4:
	movl $36,%edx
	movl $L12,%esi
	movl $L11,%edi
	call ___assert
L6:
	movsbl (%rbx),%eax
L13:
	leaq 1(%rbx),%rdx
	movsbl 1(%rbx),%ecx
	movq %rdx,%rbx
	testl %ecx,%ecx
	jz L3
L14:
	imull $31,%eax,%eax
	addl %ecx,%eax
	andl $1023,%eax
	jmp L13
L3:
	popq %rbx
	ret 


_make_bucket:
L17:
	pushq %rbx
	pushq %r12
L18:
	movq %rdi,%r12
	testq %r12,%r12
	jnz L22
L20:
	movl $51,%edx
	movl $L12,%esi
	movl $L23,%edi
	call ___assert
L22:
	movl $40,%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L26
L24:
	call _no_space
L26:
	movq $0,(%rbx)
	movq $0,8(%rbx)
	movq %r12,%rdi
	call _strlen
	incl %eax
	movl %eax,%edi
	call _malloc
	movq %rax,16(%rbx)
	testq %rax,%rax
	jnz L29
L27:
	call _no_space
L29:
	movq $0,24(%rbx)
	movw $-1,32(%rbx)
	movw $0,34(%rbx)
	movw $0,36(%rbx)
	movb $0,38(%rbx)
	movb $0,39(%rbx)
	cmpq $0,16(%rbx)
	jnz L32
L30:
	call _no_space
L32:
	movq %r12,%rsi
	movq 16(%rbx),%rdi
	call _strcpy
	movq %rbx,%rax
L19:
	popq %r12
	popq %rbx
	ret 


_lookup:
L34:
	pushq %rbx
	pushq %r12
	pushq %r13
L35:
	movq %rdi,%r13
	movq %r13,%rdi
	call _hash
	movslq %eax,%rcx
	movq _symbol_table(%rip),%rax
	leaq (%rax,%rcx,8),%r12
	movq (%rax,%rcx,8),%rbx
L37:
	testq %rbx,%rbx
	jz L39
L38:
	movq 16(%rbx),%rsi
	movq %r13,%rdi
	call _strcmp
	testl %eax,%eax
	jz L40
L42:
	movq %rbx,%r12
	movq (%rbx),%rbx
	jmp L37
L40:
	movq %rbx,%rax
	jmp L36
L39:
	movq %r13,%rdi
	call _make_bucket
	movq %rax,(%r12)
	movq _last_symbol(%rip),%rcx
	movq %rax,8(%rcx)
	movq %rax,_last_symbol(%rip)
L36:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_create_symbol_table:
L45:
	pushq %rbx
L46:
	movl $8192,%edi
	call _malloc
	movq %rax,_symbol_table(%rip)
	testq %rax,%rax
	jnz L50
L48:
	call _no_space
L50:
	xorl %eax,%eax
L52:
	movslq %eax,%rax
	movq _symbol_table(%rip),%rcx
	movq $0,(%rcx,%rax,8)
	incl %eax
	cmpl $1024,%eax
	jl L52
L54:
	movl $L55,%edi
	call _make_bucket
	movq %rax,%rbx
	movw $1,34(%rbx)
	movb $1,38(%rbx)
	movq %rbx,_first_symbol(%rip)
	movq %rbx,_last_symbol(%rip)
	movl $L55,%edi
	call _hash
	movslq %eax,%rax
	movq _symbol_table(%rip),%rcx
	movq %rbx,(%rcx,%rax,8)
L47:
	popq %rbx
	ret 


_free_symbol_table:
L56:
L57:
	movq _symbol_table(%rip),%rdi
	call _free
	movq $0,_symbol_table(%rip)
L58:
	ret 


_free_symbols:
L59:
	pushq %rbx
L60:
	movq _first_symbol(%rip),%rdi
L62:
	testq %rdi,%rdi
	jz L61
L63:
	movq 8(%rdi),%rbx
	call _free
	movq %rbx,%rdi
	jmp L62
L61:
	popq %rbx
	ret 

L55:
	.byte 101,114,114,111,114,0
L11:
	.byte 110,97,109,101,32,38,38,32
	.byte 42,110,97,109,101,0
L12:
	.byte 115,121,109,116,97,98,46,99
	.byte 0
L23:
	.byte 110,97,109,101,0
.globl _first_symbol
.comm _first_symbol, 8, 8
.globl _last_symbol
.comm _last_symbol, 8, 8
.globl _symbol_table
.comm _symbol_table, 8, 8

.globl _free_symbol_table
.globl _free
.globl _make_bucket
.globl _last_symbol
.globl _first_symbol
.globl _malloc
.globl ___assert
.globl _strcmp
.globl _free_symbols
.globl _lookup
.globl _symbol_table
.globl _strlen
.globl _strcpy
.globl _create_symbol_table
.globl _no_space
