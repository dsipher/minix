.text

_init_arenas:
L1:
	pushq %rbx
L2:
	xorl %edi,%edi
	call _sbrk
	andl $7,%eax
	jz L6
L4:
	movl $8,%edi
	subq %rax,%rdi
	call _sbrk
L6:
	movl $671088640,%edi
	call _sbrk
	movq %rax,%rbx
	cmpq $-1,%rbx
	jnz L9
L7:
	pushq $L10
	pushq $0
	pushq $2
	call _error
	addq $24,%rsp
L9:
	movq %rbx,_global_arena(%rip)
	movq %rbx,_global_arena+8(%rip)
	leaq 134217728(%rbx),%rax
	movq %rax,_func_arena(%rip)
	movq %rax,_func_arena+8(%rip)
	leaq 268435456(%rbx),%rax
	movq %rax,_stmt_arena(%rip)
	movq %rax,_stmt_arena+8(%rip)
	leaq 402653184(%rbx),%rax
	movq %rax,_local_arena(%rip)
	movq %rax,_local_arena+8(%rip)
	addq $536870912,%rbx
	movq %rbx,_string_arena(%rip)
	movq %rbx,_string_arena+8(%rip)
L3:
	popq %rbx
	ret 


_refill_slab:
L11:
	pushq %rbx
	pushq %r12
	pushq %r13
L12:
	movq %rdi,%r12
	movl (%r12),%r13d
	movl 4(%r12),%ebx
	movl %r13d,%esi
	imull %ebx,%esi
	movslq %esi,%rsi
	xorl %edx,%edx
	movl $_global_arena,%edi
	call _arena_alloc
	xorl %edx,%edx
	jmp L14
L15:
	movq 8(%r12),%rcx
	movq %rcx,(%rax)
	movq %rax,8(%r12)
	incl %edx
	movslq %r13d,%r13
	addq %r13,%rax
L14:
	movl %ebx,%ecx
	decl %ecx
	cmpl %ecx,%edx
	jl L15
L17:
	addl %ebx,16(%r12)
	addl 20(%r12),%ebx
	movl %ebx,20(%r12)
L13:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_vector_insert:
L19:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L20:
	movq %rdi,%r13
	movl %esi,%r12d
	movl %edx,%r14d
	movl %ecx,%ebx
	movl 4(%r13),%edx
	leal (%rdx,%r14),%eax
	movl %eax,-12(%rbp)
	movl (%r13),%ecx
	cmpl %ecx,-12(%rbp)
	jle L23
L22:
	cmpl $8,%ecx
	movl $8,%eax
	cmovgl %ecx,%eax
	movl %eax,(%r13)
	jmp L28
L29:
	shll $1,%esi
	movl %esi,(%r13)
L28:
	movl (%r13),%esi
	cmpl %esi,-12(%rbp)
	jg L29
L30:
	imull %ebx,%esi
	movslq %esi,%rsi
	xorl %edx,%edx
	movq 16(%r13),%rdi
	call _arena_alloc
	movq %rax,-8(%rbp)
	movl %ebx,%r15d
	imull %r12d,%r15d
	movslq %r15d,%r15
	movq %r15,%rdx
	movq 8(%r13),%rsi
	movq -8(%rbp),%rdi
	call _memcpy
	addl %r12d,%r14d
	imull %ebx,%r14d
	movslq %r14d,%rdi
	movq 8(%r13),%rsi
	movl 4(%r13),%edx
	subl %r12d,%edx
	imull %ebx,%edx
	movslq %edx,%rdx
	addq %r15,%rsi
	addq -8(%rbp),%rdi
	call _memcpy
	movq -8(%rbp),%rax
	movq %rax,8(%r13)
	jmp L24
L23:
	movq 8(%r13),%rdi
	addl %r12d,%r14d
	imull %ebx,%r14d
	movslq %r14d,%r14
	movl %r12d,%esi
	imull %ebx,%esi
	movslq %esi,%rsi
	subl %r12d,%edx
	imull %ebx,%edx
	movslq %edx,%rdx
	addq %rdi,%rsi
	addq %r14,%rdi
	call _memmove
L24:
	movl -12(%rbp),%eax
	movl %eax,4(%r13)
L21:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_vector_delete:
L31:
	pushq %rbx
	pushq %r12
L32:
	movq %rdi,%r12
	movl %edx,%ebx
	movq 8(%r12),%rdi
	movl %ecx,%r8d
	imull %esi,%r8d
	movslq %r8d,%r8
	addl %ebx,%esi
	movl %ecx,%eax
	imull %esi,%eax
	movslq %eax,%rax
	movl 4(%r12),%edx
	subl %esi,%edx
	imull %ecx,%edx
	movslq %edx,%rdx
	leaq (%rdi,%rax),%rsi
	addq %r8,%rdi
	call _memmove
	subl %ebx,4(%r12)
L33:
	popq %r12
	popq %rbx
	ret 


_dup_vector:
L34:
	pushq %rbx
	pushq %r12
	pushq %r13
L35:
	movq %rdi,%r13
	movq %rsi,%r12
	movl %edx,%ebx
	movl 4(%r12),%eax
	cmpl (%r13),%eax
	jle L38
L37:
	movl $0,4(%r13)
	movl %ebx,%ecx
	movl 4(%r12),%edx
	xorl %esi,%esi
	movq %r13,%rdi
	call _vector_insert
	jmp L39
L38:
	movl %eax,4(%r13)
L39:
	movq 8(%r13),%rdi
	imull 4(%r12),%ebx
	movslq %ebx,%rdx
	movq 8(%r12),%rsi
	call _memcpy
L36:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_arena_alloc:
L40:
	pushq %rbx
L41:
	movq 8(%rdi),%r8
	movq %r8,%rcx
	andl $7,%ecx
	jz L48
L46:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%r8
	movq %r8,8(%rdi)
L48:
	movq 8(%rdi),%rbx
	leaq (%rbx,%rsi),%rax
	movq %rax,8(%rdi)
	testl %edx,%edx
	jz L51
L49:
	movq %rsi,%rdx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _memset
L51:
	movq %rbx,%rax
L42:
	popq %rbx
	ret 

L10:
	.byte 97,114,101,110,97,32,97,108
	.byte 108,111,99,97,116,105,111,110
	.byte 115,32,102,97,105,108,101,100
	.byte 0
.globl _global_arena
.comm _global_arena, 16, 8
.globl _func_arena
.comm _func_arena, 16, 8
.globl _stmt_arena
.comm _stmt_arena, 16, 8
.globl _local_arena
.comm _local_arena, 16, 8
.globl _string_arena
.comm _string_arena, 16, 8

.globl _stmt_arena
.globl _memcpy
.globl _error
.globl _refill_slab
.globl _string_arena
.globl _sbrk
.globl _arena_alloc
.globl _local_arena
.globl _vector_insert
.globl _func_arena
.globl _memset
.globl _vector_delete
.globl _memmove
.globl _dup_vector
.globl _global_arena
.globl _init_arenas
