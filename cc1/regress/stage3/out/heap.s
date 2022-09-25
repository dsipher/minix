.text

_init_arenas:
L1:
L2:
	movl $536870912,%esi
	movl $_global_arena,%edi
	call _init_arena
	movl $536870912,%esi
	movl $_func_arena,%edi
	call _init_arena
	movl $536870912,%esi
	movl $_stmt_arena,%edi
	call _init_arena
	movl $536870912,%esi
	movl $_local_arena,%edi
	call _init_arena
	movl $536870912,%esi
	movl $_string_arena,%edi
	call _init_arena
L3:
	ret 


_init_arena:
L4:
	pushq %rbx
	pushq %r12
L5:
	movq %rdi,%r12
	cmpq $0,(%r12)
	jnz L6
L7:
	xorl %r9d,%r9d
	movl $-1,%r8d
	movl $34,%ecx
	movl $3,%edx
	xorl %edi,%edi
	call _mmap
	movq %rax,%rbx
	cmpq $-1,%rbx
	jnz L12
L10:
	pushq $L13
	pushq $0
	pushq $2
	call _error
	addq $24,%rsp
L12:
	movq %rbx,8(%r12)
	movq %rbx,(%r12)
L6:
	popq %r12
	popq %rbx
	ret 


_refill_slab:
L14:
L15:
	movl (%rdi),%ecx
	movl 4(%rdi),%r8d
	movq _global_arena+8(%rip),%rsi
	movq %rsi,%rdx
	andl $7,%edx
	jz L22
L20:
	movl $8,%eax
	subq %rdx,%rax
	addq %rax,%rsi
	movq %rsi,_global_arena+8(%rip)
L22:
	movq _global_arena+8(%rip),%rax
	movl %ecx,%edx
	imull %r8d,%edx
	movslq %edx,%rdx
	addq %rax,%rdx
	movq %rdx,_global_arena+8(%rip)
	xorl %esi,%esi
	jmp L23
L24:
	movq 8(%rdi),%rdx
	movq %rdx,(%rax)
	movq %rax,8(%rdi)
	incl %esi
	movslq %ecx,%rcx
	addq %rcx,%rax
L23:
	movl %r8d,%edx
	decl %edx
	cmpl %edx,%esi
	jl L24
L26:
	addl %r8d,16(%rdi)
	addl 20(%rdi),%r8d
	movl %r8d,20(%rdi)
L16:
	ret 


_vector_insert:
L28:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L29:
	movq %rdi,%r13
	movl %esi,-8(%rbp)
	movl %edx,%r14d
	movl %ecx,%r12d
	movl 4(%r13),%edx
	leal (%rdx,%r14),%eax
	cmpl (%r13),%eax
	movl %eax,-4(%rbp)
	jle L32
L31:
	bsrl -4(%rbp),%eax
	xorb $31,%al
	movb $31,%cl
	subb %al,%cl
	movl $1,%eax
	shll %cl,%eax
	movl %eax,(%r13)
	cmpl %eax,-4(%rbp)
	jle L36
L34:
	shll $1,%eax
	movl %eax,(%r13)
L36:
	movl (%r13),%ecx
	cmpl $4,%ecx
	movl $4,%eax
	cmovgl %ecx,%eax
	movl %eax,(%r13)
	movq 16(%r13),%rsi
	movq 8(%rsi),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L45
L43:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,8(%rsi)
L45:
	movq 16(%r13),%rcx
	movq 8(%rcx),%rbx
	movl (%r13),%eax
	imull %r12d,%eax
	movslq %eax,%rax
	addq %rbx,%rax
	movq %rax,8(%rcx)
	movl %r12d,%r15d
	imull -8(%rbp),%r15d
	movslq %r15d,%r15
	movq %r15,%rdx
	movq 8(%r13),%rsi
	movq %rbx,%rdi
	call _memcpy
	addl -8(%rbp),%r14d
	imull %r12d,%r14d
	movslq %r14d,%rdi
	movq 8(%r13),%rsi
	movl 4(%r13),%edx
	subl -8(%rbp),%edx
	imull %r12d,%edx
	movslq %edx,%rdx
	addq %r15,%rsi
	addq %rbx,%rdi
	call _memcpy
	movq %rbx,8(%r13)
	jmp L33
L32:
	movq 8(%r13),%rdi
	addl -8(%rbp),%r14d
	imull %r12d,%r14d
	movslq %r14d,%r14
	movl -8(%rbp),%esi
	imull %r12d,%esi
	movslq %esi,%rsi
	subl -8(%rbp),%edx
	imull %r12d,%edx
	movslq %edx,%rdx
	addq %rdi,%rsi
	addq %r14,%rdi
	call _memmove
L33:
	movl -4(%rbp),%eax
	movl %eax,4(%r13)
L30:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_vector_delete:
L46:
	pushq %rbx
	pushq %r12
L47:
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
L48:
	popq %r12
	popq %rbx
	ret 


_dup_vector:
L49:
	pushq %rbx
	pushq %r12
	pushq %r13
L50:
	movq %rdi,%r13
	movq %rsi,%r12
	movl %edx,%ebx
	movl 4(%r12),%eax
	cmpl (%r13),%eax
	jle L53
L52:
	movl $0,4(%r13)
	movl %ebx,%ecx
	movl 4(%r12),%edx
	xorl %esi,%esi
	movq %r13,%rdi
	call _vector_insert
	jmp L54
L53:
	movl %eax,4(%r13)
L54:
	movq 8(%r13),%rdi
	imull 4(%r12),%ebx
	movl %ebx,%edx
	movq 8(%r12),%rsi
	call ___builtin_memcpy
L51:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L13:
	.byte 105,110,105,116,95,97,114,101
	.byte 110,97,58,32,109,109,97,112
	.byte 32,102,97,105,108,101,100,0
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
.globl _mmap
.globl ___builtin_memcpy
.globl _local_arena
.globl _init_arena
.globl _vector_insert
.globl _func_arena
.globl _vector_delete
.globl _memmove
.globl _dup_vector
.globl _global_arena
.globl _init_arenas
