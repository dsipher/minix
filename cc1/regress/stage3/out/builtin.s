.text
.align 2
L21:
	.short L7-_seed_builtin
	.short L9-_seed_builtin
	.short L12-_seed_builtin
	.short L15-_seed_builtin
	.short L12-_seed_builtin
	.short L15-_seed_builtin

_seed_builtin:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%rbx
	xorl %edx,%edx
	xorl %esi,%esi
	movl $32768,%edi
	call _new_tnode
	movq %rax,%r13
	movl 20(%rbx),%eax
	cmpl $262272,%eax
	jl L5
L20:
	cmpl $262277,%eax
	jg L5
L18:
	addl $-262272,%eax
	movzwl L21(,%rax,2),%eax
	addl $_seed_builtin,%eax
	jmp *%rax
L15:
	movl $_int_type,%r12d
	movl $_long_type,%esi
	jmp L22
L12:
	movl $_int_type,%r12d
	movl $_int_type,%esi
	jmp L22
L9:
	movl $_void_type,%edx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%r12
	movl $_void_type,%edx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
	movq %r13,%rdi
	call _new_formal
	movl $_int_type,%esi
	jmp L23
L7:
	movl $_void_type,%edx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%r12
	movl $_void_type,%edx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
	movq %r13,%rdi
	call _new_formal
	movl $131072,%esi
	movl $_void_type,%edi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
L23:
	movq %r13,%rdi
	call _new_formal
	movl $_ulong_type,%esi
L22:
	movq %r13,%rdi
	call _new_formal
L5:
	movl $16,%esi
	movq %rbx,%rdi
	call _new_symbol
	movq %rax,%rbx
	movq %r12,%rsi
	movq %r13,%rdi
	call _graft
	movq %rax,32(%rbx)
	orl $-1073741824,12(%rbx)
	movl $1,%esi
	movq %rbx,%rdi
	call _insert
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L62:
	.short L52-_rewrite_builtin
	.short L52-_rewrite_builtin
	.short L43-_rewrite_builtin
	.short L43-_rewrite_builtin
	.short L49-_rewrite_builtin
	.short L49-_rewrite_builtin

_rewrite_builtin:
L24:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L25:
	movq %rdi,%rax
	movq 16(%rax),%rcx
	cmpl $1073741831,(%rcx)
	jnz L26
L34:
	movq 16(%rcx),%rcx
	cmpl $2415919105,(%rcx)
	jnz L26
L30:
	movq 24(%rcx),%rcx
	testl $2147483648,12(%rcx)
	jz L26
L29:
	movq (%rcx),%rcx
	movl 20(%rcx),%ebx
	cmpl $262272,%ebx
	jl L26
L61:
	cmpl $262277,%ebx
	jg L26
L59:
	leal -262272(%rbx),%ecx
	movzwl L62(,%rcx,2),%ecx
	addl $_rewrite_builtin,%ecx
	jmp *%rcx
L49:
	movq 24(%rax),%rax
	movq (%rax),%rdx
	movl $_int_type,%esi
	movl $1073741871,%edi
	call _unary_tree
	jmp L26
L43:
	movq 24(%rax),%rax
	movq (%rax),%rdx
	movl $_int_type,%esi
	movl $1073741872,%edi
	call _unary_tree
	movq %rax,%r13
	movq $31,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	movq %rax,%r12
	movq $63,-16(%rbp)
	leaq -16(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	cmpl $262274,%ebx
	movq %r12,%rcx
	cmovnzq %rax,%rcx
	movq %r13,%rdx
	movl $_int_type,%esi
	movl $536870942,%edi
	call _binary_tree
	jmp L26
L52:
	cmpl $262272,%ebx
	movl $46,%ecx
	movl $45,%edi
	cmovnzl %ecx,%edi
	movq 24(%rax),%rax
	movq (%rax),%rsi
	movq 8(%rax),%rdx
	movq 16(%rax),%rcx
	call _blk_tree
L26:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _unary_tree
.globl _new_symbol
.globl _con_tree
.globl _graft
.globl _insert
.globl _long_type
.globl _new_formal
.globl _blk_tree
.globl _get_tnode
.globl _new_tnode
.globl _qualify
.globl _int_type
.globl _void_type
.globl _seed_builtin
.globl _binary_tree
.globl _rewrite_builtin
.globl _ulong_type
