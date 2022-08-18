.text

_dom0:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	cmpq _entry_block(%rip),%r12
	jz L41
L8:
	cmpl $0,_tmp1(%rip)
	jl L12
L11:
	movl $0,_tmp1+4(%rip)
	jmp L13
L12:
	movl _tmp1+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movl $_tmp1,%edi
	call _vector_insert
L13:
	cmpl $0,_tmp2(%rip)
	jl L18
L17:
	movl $0,_tmp2+4(%rip)
	jmp L19
L18:
	movl _tmp2+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movl $_tmp2,%edi
	call _vector_insert
L19:
	xorl %ebx,%ebx
L20:
	cmpl 36(%r12),%ebx
	jge L23
L21:
	movslq %ebx,%rbx
	movq 40(%r12),%rax
	movq (%rax,%rbx,8),%rsi
	testl %ebx,%ebx
	jnz L25
L27:
	movl $8,%edx
	addq $128,%rsi
	movl $_tmp1,%edi
	call _dup_vector
	jmp L26
L25:
	leaq 128(%rsi),%rdx
	movl $_tmp1,%esi
	movl $_tmp2,%edi
	call _intersect_blocks
	movq _tmp1(%rip),%rax
	movq %rax,-24(%rbp)
	movq _tmp1+8(%rip),%rax
	movq %rax,-16(%rbp)
	movq _tmp1+16(%rip),%rax
	movq %rax,-8(%rbp)
	movq _tmp2(%rip),%rax
	movq %rax,_tmp1(%rip)
	movq _tmp2+8(%rip),%rax
	movq %rax,_tmp1+8(%rip)
	movq _tmp2+16(%rip),%rax
	movq %rax,_tmp1+16(%rip)
	movq -24(%rbp),%rax
	movq %rax,_tmp2(%rip)
	movq -16(%rbp),%rax
	movq %rax,_tmp2+8(%rip)
	movq -8(%rbp),%rax
	movq %rax,_tmp2+16(%rip)
L26:
	incl %ebx
	jmp L20
L23:
	movq %r12,%rsi
	movl $_tmp1,%edi
	call _add_block
	leaq 128(%r12),%rsi
	movl $_tmp1,%edi
	call _same_blocks
	testl %eax,%eax
	jz L37
L41:
	xorl %eax,%eax
	jmp L3
L37:
	movl $8,%edx
	movl $_tmp1,%esi
	leaq 128(%r12),%rdi
	call _dup_vector
	movl $1,%eax
L3:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_dom:
L42:
	pushq %rbx
L43:
	movq _all_blocks(%rip),%rbx
L45:
	testq %rbx,%rbx
	jz L48
L46:
	movq _entry_block(%rip),%rsi
	cmpq %rsi,%rbx
	jz L49
L52:
	movl $8,%edx
	movl $_all,%esi
	leaq 128(%rbx),%rdi
	call _dup_vector
	jmp L51
L49:
	leaq 128(%rbx),%rdi
	call _add_block
L51:
	movq 112(%rbx),%rbx
	jmp L45
L48:
	movl $_dom0,%edi
	call _iterate_blocks
L44:
	popq %rbx
	ret 


_dom_tree:
L55:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L56:
	movq _all_blocks(%rip),%rbx
L58:
	testq %rbx,%rbx
	jz L57
L59:
	xorl %r14d,%r14d
L62:
	cmpl 132(%rbx),%r14d
	jge L95
L66:
	movq 136(%rbx),%rax
	movslq %r14d,%r14
	movq (%rax,%r14,8),%r13
	testq %r13,%r13
	jz L95
L63:
	cmpq %r13,%rbx
	jz L73
L72:
	xorl %r12d,%r12d
L75:
	cmpl 132(%rbx),%r12d
	jge L78
L79:
	movq 136(%rbx),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rdi
	testq %rdi,%rdi
	jz L78
L76:
	cmpq %rdi,%r13
	jz L77
L86:
	cmpq %rdi,%rbx
	jz L77
L85:
	movq %r13,%rsi
	addq $128,%rdi
	call _contains_block
	testl %eax,%eax
	jnz L73
L77:
	incl %r12d
	jmp L75
L73:
	incl %r14d
	jmp L62
L78:
	movq %r13,152(%rbx)
L95:
	movq 112(%rbx),%rbx
	jmp L58
L57:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_insert0:
L97:
	pushq %rbx
	pushq %r12
L98:
	movq %rdi,%r12
	movq %rsi,%rbx
	movq %rbx,%rsi
	leaq 160(%r12),%rdi
	call _contains_block
	testl %eax,%eax
	jnz L99
L100:
	movq %rbx,%rsi
	leaq 160(%r12),%rdi
	call _add_block
	movl _stack+4(%rip),%esi
	leal 1(%rsi),%eax
	cmpl _stack(%rip),%eax
	jge L110
L109:
	movl %eax,_stack+4(%rip)
	jmp L111
L110:
	movl $8,%ecx
	movl $1,%edx
	movl $_stack,%edi
	call _vector_insert
L111:
	movq _stack+8(%rip),%rcx
	movl _stack+4(%rip),%eax
	decl %eax
	movslq %eax,%rax
	movq %rbx,(%rcx,%rax,8)
L99:
	popq %r12
	popq %rbx
	ret 


_loop0:
L112:
	pushq %rbx
	pushq %r12
	pushq %r13
L113:
	movq %rdi,%rbx
	movq %rsi,%r12
	cmpl $0,_stack(%rip)
	jl L119
L118:
	movl $0,_stack+4(%rip)
	jmp L120
L119:
	movl _stack+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movl $_stack,%edi
	call _vector_insert
L120:
	movq %rbx,%rsi
	leaq 160(%rbx),%rdi
	call _add_block
	movq %r12,%rsi
	movq %rbx,%rdi
	call _insert0
L121:
	movl _stack+4(%rip),%eax
	testl %eax,%eax
	jz L114
L122:
	movq _stack+8(%rip),%rcx
	decl %eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%r13
	movl %eax,_stack+4(%rip)
	xorl %r12d,%r12d
L124:
	cmpl 36(%r13),%r12d
	jge L121
L125:
	movq 40(%r13),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rsi
	movq %rbx,%rdi
	call _insert0
	incl %r12d
	jmp L124
L114:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_dom_loop:
L128:
	pushq %rbx
	pushq %r12
	pushq %r13
L129:
	movq _all_blocks(%rip),%r13
L131:
	testq %r13,%r13
	jz L134
L132:
	xorl %r12d,%r12d
L135:
	cmpl 60(%r13),%r12d
	jge L138
L136:
	movq 64(%r13),%rcx
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rbx
	movq %rbx,%rsi
	leaq 128(%r13),%rdi
	call _contains_block
	testl %eax,%eax
	jz L141
L139:
	movq %r13,%rsi
	movq %rbx,%rdi
	call _loop0
L141:
	incl %r12d
	jmp L135
L138:
	movq 112(%r13),%r13
	jmp L131
L134:
	movl $0,_max_depth(%rip)
	movq _all_blocks(%rip),%rsi
L142:
	testq %rsi,%rsi
	jz L130
L143:
	xorl %edx,%edx
L146:
	cmpl 164(%rsi),%edx
	jge L152
L150:
	movq 168(%rsi),%rax
	movslq %edx,%rdx
	movq (%rax,%rdx,8),%rcx
	testq %rcx,%rcx
	jz L152
L151:
	movl 184(%rcx),%eax
	incl %eax
	movl %eax,184(%rcx)
	movl _max_depth(%rip),%ecx
	cmpl %eax,%ecx
	cmovgel %ecx,%eax
	movl %eax,_max_depth(%rip)
	incl %edx
	jmp L146
L152:
	movq 112(%rsi),%rsi
	jmp L142
L130:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_dom_analyze:
L157:
	pushq %rbx
	pushq %r12
L158:
	movl %edi,%ebx
	movl $0,_all(%rip)
	movl $0,_all+4(%rip)
	movq $0,_all+8(%rip)
	movq $_local_arena,_all+16(%rip)
	movl $0,_tmp1(%rip)
	movl $0,_tmp1+4(%rip)
	movq $0,_tmp1+8(%rip)
	movq $_local_arena,_tmp1+16(%rip)
	movl $0,_tmp2(%rip)
	movl $0,_tmp2+4(%rip)
	movq $0,_tmp2+8(%rip)
	movq $_local_arena,_tmp2+16(%rip)
	movl $0,_stack(%rip)
	movl $0,_stack+4(%rip)
	movq $0,_stack+8(%rip)
	movq $_local_arena,_stack+16(%rip)
	movq _all_blocks(%rip),%r12
L172:
	testq %r12,%r12
	jz L175
L173:
	movl $0,184(%r12)
	movq $0,152(%r12)
	cmpl $0,160(%r12)
	jl L180
L179:
	movl $0,164(%r12)
	jmp L181
L180:
	movl 164(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	leaq 160(%r12),%rdi
	call _vector_insert
L181:
	cmpl $0,128(%r12)
	jl L186
L185:
	movl $0,132(%r12)
	jmp L187
L186:
	movl 132(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	leaq 128(%r12),%rdi
	call _vector_insert
L187:
	movq %r12,%rsi
	movl $_all,%edi
	call _add_block
	movq 112(%r12),%r12
	jmp L172
L175:
	call _dom
	testl $1,%ebx
	jz L190
L188:
	call _dom_tree
L190:
	testl $2,%ebx
	jz L194
L191:
	call _dom_loop
L194:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L159:
	popq %r12
	popq %rbx
	ret 


_out_dom:
L197:
	pushq %rbx
	pushq %r12
	pushq %r13
L198:
	movq %rdi,%r12
	movq _out_f(%rip),%rsi
	movl $L200,%edi
	call _fputs
	xorl %ebx,%ebx
L201:
	cmpl 132(%r12),%ebx
	jge L204
L205:
	movq 136(%r12),%rax
	movslq %ebx,%rbx
	movq (%rax,%rbx,8),%r13
	testq %r13,%r13
	jz L204
L202:
	movl (%r13),%eax
	pushq %rax
	pushq $L209
	call _out
	addq $16,%rsp
	cmpq 152(%r12),%r13
	jnz L212
L210:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L214
L213:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $42,(%rcx)
	jmp L212
L214:
	movl $42,%edi
	call ___flushbuf
L212:
	incl %ebx
	jmp L201
L204:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L217
L216:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L218
L217:
	movl $10,%edi
	call ___flushbuf
L218:
	cmpl $0,164(%r12)
	jnz L219
L222:
	cmpl $0,184(%r12)
	jz L199
L219:
	movl 184(%r12),%eax
	pushq %rax
	pushq $L226
	call _out
	addq $16,%rsp
	xorl %ebx,%ebx
L227:
	cmpl 164(%r12),%ebx
	jge L230
L231:
	movq 168(%r12),%rax
	movslq %ebx,%rbx
	movq (%rax,%rbx,8),%rax
	testq %rax,%rax
	jz L230
L228:
	movl (%rax),%eax
	pushq %rax
	pushq $L209
	call _out
	addq $16,%rsp
	incl %ebx
	jmp L227
L230:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L236
L235:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L199
L236:
	movl $10,%edi
	call ___flushbuf
L199:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L200:
	.byte 59,32,68,79,77,58,0
L226:
	.byte 59,32,76,79,79,80,58,32
	.byte 91,100,101,112,116,104,61,37
	.byte 100,93,0
L209:
	.byte 32,37,76,0
.globl _max_depth
.comm _max_depth, 4, 4
.local _all
.comm _all, 24, 8
.local _tmp1
.comm _tmp1, 24, 8
.local _tmp2
.comm _tmp2, 24, 8
.local _stack
.comm _stack, 24, 8

.globl _all_blocks
.globl _contains_block
.globl _add_block
.globl _entry_block
.globl _intersect_blocks
.globl ___flushbuf
.globl _out
.globl _iterate_blocks
.globl _local_arena
.globl _out_f
.globl _dom_analyze
.globl _vector_insert
.globl _fputs
.globl _out_dom
.globl _dup_vector
.globl _max_depth
.globl _same_blocks
