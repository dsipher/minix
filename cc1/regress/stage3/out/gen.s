.text

_leaf_operand:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl (%rbx),%eax
	cmpl $-2147483646,%eax
	jz L8
L42:
	cmpl $-1879048191,%eax
	jnz L3
L25:
	movl (%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,(%r12)
	movq 24(%rbx),%rdi
	call _symbol_to_reg
	movl %eax,8(%r12)
	movq 8(%rbx),%rax
	testq %rax,%rax
	jz L3
L31:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl (%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,(%r12)
	jmp L3
L8:
	movl (%r12),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,(%r12)
	movq 16(%rbx),%rax
	movq %rax,16(%r12)
	movq 24(%rbx),%rax
	movq %rax,24(%r12)
	movq 8(%rbx),%rax
	testq %rax,%rax
	jz L3
L14:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl (%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,(%r12)
L3:
	popq %r12
	popq %rbx
	ret 


_frame_addr:
L45:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L46:
	movl %esi,%ebx
	movq %rdx,%r15
	movl %ecx,%r14d
	call _temp
	movq %rax,%r13
	xorl %esi,%esi
	movl $-1610612733,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L62
L54:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L62:
	movslq %ebx,%rbx
	movq %rbx,-8(%rbp)
	movl 40(%r12),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,40(%r12)
	movq -8(%rbp),%rax
	movq %rax,56(%r12)
	movq $0,64(%r12)
	movl $_long_type,%eax
	testq %rax,%rax
	jz L80
L72:
	movq _long_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%r12)
L80:
	movl %r14d,%edx
	movq %r15,%rsi
	movq %r12,%rdi
	call _insert_insn
	movq %r13,%rax
L47:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_loadstore:
L82:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L83:
	movl %edi,%r15d
	movq %rsi,%r14
	movq %rdx,-8(%rbp)
	movl %ecx,-16(%rbp)
	movl $1,-12(%rbp)
	xorl %esi,%esi
	movl %r15d,%edi
	call _new_insn
	movq %rax,%r13
	leaq 8(%r13),%rax
	movq %rax,%r12
	leaq 40(%r13),%rbx
	cmpl $553648133,%r15d
	jnz L91
L88:
	movq %rbx,%r12
	movq %rax,%rbx
L91:
	movl (%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,(%r12)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,8(%r12)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L105
L97:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl (%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,(%r12)
L105:
	testl $448,12(%r14)
	jnz L106
L124:
	movl (%rbx),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,(%rbx)
	movq $0,16(%rbx)
	movq %r14,24(%rbx)
	movl $_ulong_type,%eax
	testq %rax,%rax
	jz L108
L130:
	movq _ulong_type(%rip),%rax
	andl $131071,%eax
	shll $5,%eax
	andl $-4194273,%ecx
	orl %eax,%ecx
	movl %ecx,(%rbx)
	jmp L108
L106:
	movq %r14,%rdi
	call _symbol_offset
	movl -16(%rbp),%ecx
	incl -16(%rbp)
	movq -8(%rbp),%rdx
	movl %eax,%esi
	movl $_ulong_type,%edi
	call _frame_addr
	movq %rax,%r12
	movl (%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,8(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L123
L115:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl (%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,(%rbx)
L123:
	movl $2,-12(%rbp)
L108:
	movq 32(%r14),%rax
	testq $262144,(%rax)
	jz L135
L133:
	movl 4(%r13),%eax
	andl $-2,%eax
	orl $1,%eax
	movl %eax,4(%r13)
L135:
	movl -16(%rbp),%edx
	movq -8(%rbp),%rsi
	movq %r13,%rdi
	call _insert_insn
	movl -12(%rbp),%eax
L84:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_branch:
L137:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L138:
	movq %rdi,%r14
	movq %rsi,%r13
	movq %rdx,%r12
	xorl %esi,%esi
	movl $603979787,%edi
	call _new_insn
	movq %rax,%rbx
	movq %r14,%rsi
	leaq 8(%rbx),%rdi
	call _leaf_operand
	movq $0,-8(%rbp)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,40(%rbx)
	movq -8(%rbp),%rax
	movq %rax,56(%rbx)
	movq $0,64(%rbx)
	movl $_int_type,%eax
	testq %rax,%rax
	jz L157
L149:
	movq _int_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L157:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r12,%rdx
	xorl %esi,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r13,%rdx
	movl $1,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
L139:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_binary:
L158:
	pushq %rbx
	pushq %r12
	pushq %r13
L159:
	movq %rdi,%r13
	movl %esi,%ebx
	movq 8(%r13),%rdi
	call _temp
	movq %rax,%r12
	movq 16(%r13),%rdi
	call _gen0
	movq %rax,16(%r13)
	movq 24(%r13),%rdi
	call _gen0
	movq %rax,24(%r13)
	xorl %esi,%esi
	movl %ebx,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L175
L167:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L175:
	movq 16(%r13),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq 24(%r13),%rsi
	leaq 72(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r12,%rdi
	call _sym_tree
L160:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_unary:
L177:
	pushq %rbx
	pushq %r12
	pushq %r13
L178:
	movq %rdi,%r13
	movl %esi,%ebx
	movq 16(%r13),%rdi
	call _gen0
	movq %rax,16(%r13)
	movq 8(%r13),%rdi
	call _temp
	movq %rax,%r12
	xorl %esi,%esi
	movl %ebx,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L194
L186:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L194:
	movq 16(%r13),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r12,%rdi
	call _sym_tree
L179:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L608:
	.quad 0x43e0000000000000

_gen_cast:
L196:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L197:
	movq %rdi,%r15
	movq 16(%r15),%rdi
	call _gen0
	movq %rax,16(%r15)
	movq 8(%r15),%rdi
	call _temp
	movq %rax,%r14
	movq 8(%r15),%rax
	movq (%rax),%rcx
	testq $512,%rcx
	jz L204
L202:
	movq 16(%r15),%rax
	movq 8(%rax),%rax
	testq $7168,(%rax)
	jz L204
L203:
	call _new_block
	movq %rax,%r13
	call _new_block
	movq %rax,-64(%rbp)
	call _new_block
	movq %rax,-56(%rbp)
	movq 16(%r15),%rax
	movq 8(%rax),%rdi
	call _temp
	movq %rax,%r12
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L220
L212:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L220:
	movsd L608(%rip),%xmm0
	movsd %xmm0,-8(%rbp)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,40(%rbx)
	movq -8(%rbp),%rax
	movq %rax,56(%rbx)
	movq $0,64(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L238
L230:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L238:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $603979787,%edi
	call _new_insn
	movq %rax,%rbx
	movq 16(%r15),%rsi
	leaq 8(%rbx),%rdi
	call _leaf_operand
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L253
L245:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L253:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r13,%rdx
	movl $11,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq -64(%rbp),%rdx
	movl $10,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r13,_current_block(%rip)
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,8(%rbx)
	movq 16(%r15),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq -56(%rbp),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq -64(%rbp),%rax
	movq %rax,_current_block(%rip)
	xorl %esi,%esi
	movl $-1342177265,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L283
L275:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L283:
	movq 16(%r15),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movl 72(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,72(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,80(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L298
L290:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%rbx)
L298:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,8(%rbx)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L328
L320:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L328:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068393,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,8(%rbx)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,40(%rbx)
	movq $-9223372036854775808,%rax
	movq %rax,-16(%rbp)
	movl 72(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%rbx)
	movq -16(%rbp),%rax
	movq %rax,88(%rbx)
	movq $0,96(%rbx)
	movl 72(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,72(%rbx)
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq -56(%rbp),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq -56(%rbp),%rax
	movq %rax,_current_block(%rip)
	jmp L201
L204:
	testq $7168,%rcx
	jz L382
L380:
	movq 16(%r15),%rax
	movq 8(%rax),%rax
	testq $512,(%rax)
	jz L382
L381:
	call _new_block
	movq %rax,%r13
	call _new_block
	movq %rax,%r12
	call _new_block
	movq %rax,-48(%rbp)
	xorl %esi,%esi
	movl $603979787,%edi
	call _new_insn
	movq %rax,%rbx
	movq 16(%r15),%rsi
	leaq 8(%rbx),%rdi
	call _leaf_operand
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,8(%rbx)
	movq $0,-24(%rbp)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,40(%rbx)
	movq -24(%rbp),%rax
	movq %rax,56(%rbx)
	movq $0,64(%rbx)
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,40(%rbx)
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r13,%rdx
	movl $4,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r12,%rdx
	movl $5,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r13,_current_block(%rip)
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L416
L408:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L416:
	movq 16(%r15),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,40(%rbx)
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq -48(%rbp),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r12,_current_block(%rip)
	movq 16(%r15),%rax
	movq 8(%rax),%rdi
	call _temp
	movq %rax,%r13
	movq 16(%r15),%rax
	movq 8(%rax),%rdi
	call _temp
	movq %rax,%r12
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,8(%rbx)
	movq 16(%r15),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068397,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,8(%rbx)
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 40(%rbx),%rdi
	rep 
	movsb 
	movq $1,-32(%rbp)
	movl 72(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%rbx)
	movq -32(%rbp),%rax
	movq %rax,88(%rbx)
	movq $0,96(%rbx)
	movl 72(%rbx),%eax
	andl $-4194273,%eax
	orl $64,%eax
	movl %eax,72(%rbx)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,8(%rbx)
	movq 16(%r15),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,8(%rbx)
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 40(%rbx),%rdi
	rep 
	movsb 
	movq $1,-40(%rbp)
	movl 72(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%rbx)
	movq -40(%rbp),%rax
	movq %rax,88(%rbx)
	movq $0,96(%rbx)
	movl 72(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,72(%rbx)
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068394,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,8(%rbx)
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 40(%rbx),%rdi
	rep 
	movsb 
	movl 72(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,72(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,80(%rbx)
	movl 72(%rbx),%eax
	andl $-4194273,%eax
	orl $16384,%eax
	movl %eax,72(%rbx)
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L557
L549:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L557:
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,40(%rbx)
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1342177266,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L587
L579:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L587:
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 40(%rbx),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 72(%rbx),%rdi
	rep 
	movsb 
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq -48(%rbp),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq -48(%rbp),%rax
	movq %rax,_current_block(%rip)
	jmp L201
L382:
	testq $1,%rcx
	jz L589
L588:
	movl $_void_tree,%eax
	jmp L198
L589:
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L606
L598:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L606:
	movq 16(%r15),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
L201:
	movq %r14,%rdi
	call _sym_tree
L198:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_addrof:
L609:
	pushq %rbx
L610:
	movq %rdi,%rbx
	movq 16(%rbx),%rax
	movq 24(%rax),%rdi
	call _symbol_offset
	movq 8(%rbx),%rdi
	movq _current_block(%rip),%rdx
	movl 12(%rdx),%ecx
	movl %eax,%esi
	call _frame_addr
	movq %rax,%rdi
	movq 16(%rbx),%rax
	movq 24(%rax),%rcx
	movl 12(%rcx),%eax
	testl $256,%eax
	jz L614
L612:
	andl $-257,%eax
	movl %eax,12(%rcx)
	movq 16(%rbx),%rax
	movq 24(%rax),%rax
	orl $64,12(%rax)
L614:
	call _sym_tree
L611:
	popq %rbx
	ret 


_extract_field:
L616:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L617:
	movq %rdi,%r15
	movq %rsi,-40(%rbp)
	xorl %esi,%esi
	movq 32(%r15),%rdi
	call _size_of
	movl %eax,%ebx
	shll $3,%ebx
	movq -40(%rbp),%rax
	movq (%rax),%rax
	movq $545460846592,%r14
	andq %rax,%r14
	sarq $32,%r14
	movq $69269232549888,%r13
	andq %rax,%r13
	sarq $40,%r13
	movq 32(%r15),%rdi
	call _temp
	movq %rax,-32(%rbp)
	movq -40(%rbp),%rax
	testq $680,(%rax)
	jz L624
L622:
	testl %r13d,%r13d
	jnz L624
L623:
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L640
L632:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L640:
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r15,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq 32(%r15),%rax
	testq %rax,%rax
	jz L655
L647:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L655:
	movb %r14b,%cl
	movq $-1,%rax
	shlq %cl,%rax
	notq %rax
	movq %rax,-8(%rbp)
	movl 72(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%rbx)
	movq -8(%rbp),%rax
	movq %rax,88(%rbx)
	movq $0,96(%rbx)
	movq 32(%r15),%rax
	testq %rax,%rax
	jz L673
L665:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%rbx)
L673:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	jmp L621
L624:
	addl %r14d,%r13d
	movl %ebx,%r12d
	subl %r13d,%r12d
	subl %r14d,%ebx
	xorl %esi,%esi
	movl $-1275068396,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L688
L680:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L688:
	movl 40(%r13),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%r13)
	movq %r15,%rdi
	call _symbol_to_reg
	movl %eax,48(%r13)
	movq 32(%r15),%rax
	testq %rax,%rax
	jz L703
L695:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%r13)
L703:
	movslq %r12d,%r12
	movq %r12,-16(%rbp)
	movl 72(%r13),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%r13)
	movq -16(%rbp),%rax
	movq %rax,88(%r13)
	movq $0,96(%r13)
	movl $_char_type,%eax
	testq %rax,%rax
	jz L721
L713:
	movq _char_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%r13)
L721:
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068397,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	cmpq $0,-40(%rbp)
	jz L736
L728:
	movq -40(%rbp),%rax
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L736:
	movl 40(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%r12)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%r12)
	cmpq $0,-40(%rbp)
	jz L751
L743:
	movq -40(%rbp),%rax
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%r12)
L751:
	movslq %ebx,%rbx
	movq %rbx,-24(%rbp)
	movl 72(%r12),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%r12)
	movq -24(%rbp),%rax
	movq %rax,88(%r12)
	movq $0,96(%r12)
	movl $_char_type,%eax
	testq %rax,%rax
	jz L769
L761:
	movq _char_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%r12)
L769:
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
L621:
	movq -32(%rbp),%rax
L618:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_insert_field:
L771:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L772:
	movq %rdi,%r15
	movq %rsi,-32(%rbp)
	movq %rdx,%rbx
	xorl %esi,%esi
	movq -32(%rbp),%rax
	movq 32(%rax),%rdi
	call _size_of
	movq (%rbx),%rax
	movq $545460846592,%rbx
	andq %rax,%rbx
	sarq $32,%rbx
	movq $69269232549888,%r14
	andq %rax,%r14
	sarq $40,%r14
	movq -32(%rbp),%rax
	movq 32(%rax),%rdi
	call _temp
	movq %rax,-40(%rbp)
	movq 8(%r15),%rdi
	call _temp
	movq %rax,%r13
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L788
L780:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L788:
	movq %r15,%rsi
	leaq 40(%r12),%rdi
	call _leaf_operand
	movb %bl,%cl
	movq $-1,%rbx
	shlq %cl,%rbx
	notq %rbx
	movq %rbx,-8(%rbp)
	movl 72(%r12),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%r12)
	movq -8(%rbp),%rax
	movq %rax,88(%r12)
	movq $0,96(%r12)
	movq 8(%r15),%rax
	testq %rax,%rax
	jz L806
L798:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%r12)
L806:
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068396,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L821
L813:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L821:
	movl 40(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%r12)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,48(%r12)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L836
L828:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%r12)
L836:
	movslq %r14d,%rax
	movq %rax,-16(%rbp)
	movl 72(%r12),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%r12)
	movq -16(%rbp),%rax
	movq %rax,88(%r12)
	movq $0,96(%r12)
	movl $_char_type,%eax
	testq %rax,%rax
	jz L854
L846:
	movq _char_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%r12)
L854:
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq -40(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movq -40(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L869
L861:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L869:
	movl 40(%r12),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%r12)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%r12)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L884
L876:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%r12)
L884:
	movb %r14b,%cl
	shlq %cl,%rbx
	notq %rbx
	movq %rbx,-24(%rbp)
	movl 72(%r12),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,72(%r12)
	movq -24(%rbp),%rax
	movq %rax,88(%r12)
	movq $0,96(%r12)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L902
L894:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r12),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%r12)
L902:
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068394,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq -40(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq -40(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L917
L909:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L917:
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq -40(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq -40(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L932
L924:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L932:
	movl 72(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,72(%rbx)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,80(%rbx)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L947
L939:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,72(%rbx)
L947:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq -40(%rbp),%rax
L773:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_fetch:
L949:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L950:
	movq %rdi,%r14
	movq %rsi,%r13
	movq 16(%r14),%rdi
	call _gen0
	movq %rax,16(%r14)
	movq 8(%r14),%rdi
	testq $8192,(%rdi)
	jnz L952
L954:
	call _temp
	movq %rax,%r12
	xorl %esi,%esi
	movl $-1577058300,%edi
	call _new_insn
	movq %rax,%rbx
	movq 16(%r14),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 8(%r14),%rax
	testq %rax,%rax
	jz L970
L962:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L970:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	testq $65536,(%rax)
	jz L973
L974:
	movq 24(%rax),%rax
	testq $262144,(%rax)
	jz L973
L975:
	movl 4(%rbx),%eax
	andl $-2,%eax
	orl $1,%eax
	movl %eax,4(%rbx)
L973:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movl (%r14),%eax
	cmpl $1342177283,%eax
	jz L986
L985:
	cmpl $1073741828,%eax
	jnz L980
L986:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L980
L982:
	testq %r13,%r13
	jz L991
L989:
	movq %r12,(%r13)
L991:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rsi
	movq %r12,%rdi
	call _extract_field
	movq %rax,%r12
L980:
	movq %r12,%rdi
	call _sym_tree
	jmp L951
L952:
	movq %r14,%rax
L951:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_assign:
L993:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L994:
	movq %rdi,%r13
	movq %rsi,%r12
	movq 24(%r13),%rdi
	call _gen0
	movq %rax,24(%r13)
	movq 16(%r13),%rax
	cmpl $2415919105,(%rax)
	jnz L997
L996:
	movq 24(%rax),%rax
	movq %rax,-8(%rbp)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq -8(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq -8(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L1013
L1005:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1013:
	movq 24(%r13),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	jmp L998
L997:
	movq 16(%rax),%rdi
	call _gen0
	movq 16(%r13),%rcx
	movq %rax,16(%rcx)
	xorl %esi,%esi
	movl $553648133,%edi
	call _new_insn
	movq %rax,%rbx
	movq 16(%r13),%rax
	movq 16(%rax),%rsi
	leaq 8(%rbx),%rdi
	call _leaf_operand
	movq 16(%r13),%rax
	movq 16(%rax),%rax
	movq 8(%rax),%rax
	testq $65536,(%rax)
	jz L1016
L1017:
	movq 24(%rax),%rax
	testq $262144,(%rax)
	jz L1016
L1018:
	movl 4(%rbx),%eax
	andl $-2,%eax
	orl $1,%eax
	movl %eax,4(%rbx)
L1016:
	movq 16(%r13),%rdi
	movl (%rdi),%eax
	cmpl $1342177283,%eax
	jz L1029
L1028:
	cmpl $1073741828,%eax
	jnz L1026
L1029:
	movq 16(%rdi),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L1026
L1025:
	testq %r12,%r12
	jz L1033
L1032:
	movq %r12,-8(%rbp)
	jmp L1034
L1033:
	leaq -8(%rbp),%rsi
	call _gen_fetch
L1034:
	movq 24(%r13),%rdi
	movq 16(%r13),%rax
	movq 16(%rax),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdx
	movq -8(%rbp),%rsi
	call _insert_field
	movq %rax,-8(%rbp)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq -8(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq -8(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L1049
L1041:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L1049:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq 16(%r13),%rax
	movq 16(%rax),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rsi
	movq -8(%rbp),%rdi
	call _extract_field
	movq %rax,-8(%rbp)
	movq %rax,%rdi
	call _sym_tree
	movq %rax,24(%r13)
	jmp L998
L1026:
	movq 24(%r13),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
L998:
	movq %r13,%rdi
	call _chop_right
L995:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_compound:
L1051:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1052:
	movq %rdi,%r15
	movl %esi,-12(%rbp)
	xorl %r14d,%r14d
	movq $0,-8(%rbp)
	movq 8(%r15),%rdi
	call _temp
	movq %rax,%r13
	movq 24(%r15),%rdi
	call _gen0
	movq %rax,24(%r15)
	movq 16(%r15),%rdi
	cmpl $2415919105,(%rdi)
	jnz L1055
L1054:
	movq 24(%rdi),%r12
	jmp L1056
L1055:
	leaq -8(%rbp),%rsi
	call _gen_fetch
	movq 24(%rax),%r12
L1056:
	cmpl $22,(%r15)
	jnz L1059
L1057:
	movq 8(%r15),%rdi
	call _temp
	movq %rax,%r14
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L1074
L1066:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1074:
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L1089
L1081:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L1089:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
L1059:
	testl $134217728,(%r15)
	jz L1095
L1093:
	movq 16(%r15),%rax
	movq 8(%rax),%rdi
	movq 24(%r15),%rax
	movq 8(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jnz L1095
L1094:
	movq 24(%r15),%rax
	movq 8(%rax),%rbx
	movq %r12,%rdi
	call _sym_tree
	movq %rax,%rdx
	movq %rbx,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,%rdi
	call _gen
	movq %rax,%r12
	xorl %esi,%esi
	movl -12(%rbp),%edi
	call _new_insn
	movq %rax,%rbx
	movq %r12,%rsi
	leaq 8(%rbx),%rdi
	call _leaf_operand
	movq %r12,%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq 24(%r15),%rsi
	leaq 72(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq 16(%r15),%rax
	movq %r12,%rdx
	movq 8(%rax),%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,%rdi
	call _gen
	movq %rax,%r12
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L1111
L1103:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1111:
	movq %r12,%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	jmp L1092
L1095:
	xorl %esi,%esi
	movl -12(%rbp),%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L1126
L1118:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1126:
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L1141
L1133:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L1141:
	movq 24(%r15),%rsi
	leaq 72(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
L1092:
	movq %r13,%rdi
	call _sym_tree
	movq %rax,24(%r15)
	movq -8(%rbp),%rsi
	movq %r15,%rdi
	call _gen_assign
	testq %r14,%r14
	jz L1053
L1142:
	movq %r14,%rdi
	call _sym_tree
L1053:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_rel:
L1146:
	pushq %rbx
	pushq %r12
	pushq %r13
L1147:
	movq %rdi,%r12
	movq 16(%r12),%rdi
	call _gen0
	movq %rax,16(%r12)
	movq 24(%r12),%rdi
	call _gen0
	movq %rax,24(%r12)
	xorl %esi,%esi
	movl $603979787,%edi
	call _new_insn
	movq %rax,%r13
	movq 16(%r12),%rsi
	leaq 8(%r13),%rdi
	call _leaf_operand
	movq 24(%r12),%rsi
	leaq 40(%r13),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	movl (%r12),%eax
	cmpl $35,%eax
	jz L1156
L1193:
	cmpl $36,%eax
	jz L1166
L1194:
	cmpl $37,%eax
	jz L1171
L1195:
	cmpl $38,%eax
	jz L1161
L1196:
	cmpl $536870945,%eax
	jz L1152
L1197:
	cmpl $536870946,%eax
	movl $1,%eax
	cmovzl %eax,%ebx
	jmp L1150
L1152:
	xorl %ebx,%ebx
	jmp L1150
L1161:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $11,%eax
	movl $7,%ebx
	cmovzl %eax,%ebx
	jmp L1150
L1171:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $9,%eax
	movl $5,%ebx
	cmovzl %eax,%ebx
	jmp L1150
L1166:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $10,%eax
	movl $6,%ebx
	cmovzl %eax,%ebx
	jmp L1150
L1156:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $8,%eax
	movl $4,%ebx
	cmovzl %eax,%ebx
L1150:
	movq 8(%r12),%rdi
	call _temp
	movq %rax,%r12
	xorl %esi,%esi
	leal -1744830440(%rbx),%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L1190
L1182:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1190:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r12,%rdi
	call _sym_tree
L1148:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_log:
L1200:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1201:
	movq %rdi,%r15
	movq 8(%r15),%rdi
	call _temp
	movq %rax,%r14
	call _new_block
	movq %rax,-24(%rbp)
	call _new_block
	movq %rax,%r13
	call _new_block
	movq %rax,%r12
	call _new_block
	movq %rax,-32(%rbp)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L1217
L1209:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1217:
	movq $0,-8(%rbp)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,40(%rbx)
	movq -8(%rbp),%rax
	movq %rax,56(%rbx)
	movq $0,64(%rbx)
	movl $_int_type,%eax
	testq %rax,%rax
	jz L1235
L1227:
	movq _int_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L1235:
	movq %r12,%rsi
	movq %rbx,%rdi
	call _append_insn
	movq -32(%rbp),%rdx
	movl $12,%esi
	movq %r12,%rdi
	call _add_succ
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L1250
L1242:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1250:
	movq $1,-16(%rbp)
	movl 40(%rbx),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,40(%rbx)
	movq -16(%rbp),%rax
	movq %rax,56(%rbx)
	movq $0,64(%rbx)
	movl $_int_type,%eax
	testq %rax,%rax
	jz L1268
L1260:
	movq _int_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L1268:
	movq %r13,%rsi
	movq %rbx,%rdi
	call _append_insn
	movq -32(%rbp),%rdx
	movl $12,%esi
	movq %r13,%rdi
	call _add_succ
	movq 16(%r15),%rdi
	call _gen0
	movq %rax,%rdi
	movq %rdi,16(%r15)
	cmpl $39,(%r15)
	jnz L1270
L1269:
	movq -24(%rbp),%rdx
	movq %r13,%rsi
	call _branch
	jmp L1271
L1270:
	movq %r12,%rdx
	movq -24(%rbp),%rsi
	call _branch
L1271:
	movq -24(%rbp),%rax
	movq %rax,_current_block(%rip)
	movq 24(%r15),%rdi
	call _gen0
	movq %rax,24(%r15)
	movq %r12,%rdx
	movq %r13,%rsi
	movq %rax,%rdi
	call _branch
	movq -32(%rbp),%rax
	movq %rax,_current_block(%rip)
	movq %r14,%rdi
	call _sym_tree
L1202:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_ternary:
L1273:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1274:
	movq %rdi,%r12
	movq 8(%r12),%rdi
	testq $1,(%rdi)
	jz L1277
L1276:
	xorl %ebx,%ebx
	jmp L1278
L1277:
	call _temp
	movq %rax,%rbx
L1278:
	call _new_block
	movq %rax,%r13
	call _new_block
	movq %rax,%r15
	call _new_block
	movq %rax,%r14
	movq 16(%r12),%rdi
	call _gen0
	movq %rax,16(%r12)
	movq %r15,%rdx
	movq %r13,%rsi
	movq %rax,%rdi
	call _branch
	movq %r13,_current_block(%rip)
	movq 24(%r12),%rax
	movq 16(%rax),%rdi
	call _gen0
	movq 24(%r12),%rcx
	movq %rax,16(%rcx)
	testq %rbx,%rbx
	jz L1284
L1282:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L1299
L1291:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L1299:
	movq 24(%r12),%rax
	movq 16(%rax),%rsi
	leaq 40(%r13),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
L1284:
	movq %r14,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r15,_current_block(%rip)
	movq 24(%r12),%rax
	movq 24(%rax),%rdi
	call _gen0
	movq 24(%r12),%rcx
	movq %rax,24(%rcx)
	testq %rbx,%rbx
	jz L1305
L1303:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L1320
L1312:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L1320:
	movq 24(%r12),%rax
	movq 24(%rax),%rsi
	leaq 40(%r13),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
L1305:
	movq %r14,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r14,_current_block(%rip)
	testq %rbx,%rbx
	jz L1322
L1321:
	movq %rbx,%rdi
	call _sym_tree
	jmp L1275
L1322:
	movl $_void_tree,%eax
L1275:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_blk:
L1325:
	pushq %rbx
	pushq %r12
L1326:
	movq %rdi,%r12
	movl %esi,%ebx
	movq 16(%r12),%rdi
	call _gen0
	movq %rax,16(%r12)
	movq 24(%r12),%rdi
	call _gen0
	movq %rax,24(%r12)
	xorl %esi,%esi
	movl %ebx,%edi
	call _new_insn
	movq %rax,%rbx
	movq 16(%r12),%rax
	movq 16(%rax),%rsi
	leaq 8(%rbx),%rdi
	call _leaf_operand
	movq 16(%r12),%rax
	movq 24(%rax),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq 24(%r12),%rsi
	leaq 72(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r12,%rdi
	call _chop_left
	movq %rax,%rdi
	call _chop_left
L1327:
	popq %r12
	popq %rbx
	ret 


_gen_call:
L1329:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1330:
	movq %rdi,%r15
	movq 8(%r15),%rdi
	testq $1,(%rdi)
	jz L1333
L1332:
	movq $0,-8(%rbp)
	jmp L1334
L1333:
	call _temp
	movq %rax,-8(%rbp)
L1334:
	movl 4(%r15),%esi
	movl $-1493172218,%edi
	call _new_insn
	movq %rax,%r14
	movl $0,-20(%rbp)
L1335:
	movl -20(%rbp),%r13d
	cmpl 4(%r15),%r13d
	jge L1338
L1336:
	movl -20(%rbp),%r13d
	addl $2,%r13d
	movslq %r13d,%r13
	shlq $5,%r13
	movq 24(%r15),%rax
	movslq -20(%rbp),%r12
	movq (%rax,%r12,8),%rax
	movq %rax,-16(%rbp)
	movq -16(%rbp),%rax
	movq 8(%rax),%rbx
	testq $8192,(%rbx)
	jz L1341
L1339:
	movq %rbx,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
	movq -16(%rbp),%rdi
	call _addrof
	movq 24(%r15),%rcx
	movq %rax,(%rcx,%r12,8)
L1341:
	movq 24(%r15),%rax
	movq (%rax,%r12,8),%rdi
	call _gen0
	movq 24(%r15),%rcx
	movq %rax,(%rcx,%r12,8)
	movq 24(%r15),%rax
	movq (%rax,%r12,8),%rsi
	leaq 8(%r14,%r13),%rdi
	call _leaf_operand
	testq $8192,(%rbx)
	jz L1344
L1342:
	movl 8(%r14,%r13),%eax
	andl $-4194273,%eax
	orl $262144,%eax
	movl %eax,8(%r14,%r13)
	xorl %esi,%esi
	movq %rbx,%rdi
	call _size_of
	andl $268435455,%eax
	movl 12(%r14,%r13),%ecx
	andl $-268435456,%ecx
	orl %eax,%ecx
	movl %ecx,12(%r14,%r13)
	movq %rbx,%rdi
	call _align_of
	andl $15,%eax
	shll $28,%eax
	movl 12(%r14,%r13),%ecx
	andl $-4026531841,%ecx
	orl %eax,%ecx
	movl %ecx,12(%r14,%r13)
L1344:
	incl -20(%rbp)
	jmp L1335
L1338:
	movq 16(%r15),%rdi
	call _gen0
	movq %rax,16(%r15)
	movq %rax,%rsi
	leaq 40(%r14),%rdi
	call _leaf_operand
	movq 16(%r15),%rax
	movq 8(%rax),%rax
	testq $65536,(%rax)
	jz L1347
L1352:
	movq 24(%rax),%rax
	movq (%rax),%rax
	testq $32768,%rax
	jz L1347
L1356:
	testq $1048576,%rax
	jz L1347
L1357:
	movl 4(%r14),%eax
	andl $-2049,%eax
	orl $2048,%eax
	movl %eax,4(%r14)
L1347:
	cmpq $0,-8(%rbp)
	jz L1362
L1363:
	movl 8(%r14),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r14)
	movq -8(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r14)
	movq -8(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L1362
L1369:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r14),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r14)
L1362:
	movq _current_block(%rip),%rsi
	movq %r14,%rdi
	call _append_insn
	cmpq $0,-8(%rbp)
	jz L1379
L1378:
	movq -8(%rbp),%rdi
	call _sym_tree
	jmp L1331
L1379:
	movl $_void_tree,%eax
L1331:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L1503:
	.short L1435-_gen0
	.short L1437-_gen0
	.short L1384-_gen0
	.short L1384-_gen0
	.short L1384-_gen0
	.short L1445-_gen0
	.short L1447-_gen0
	.short L1449-_gen0
	.short L1456-_gen0
	.short L1456-_gen0
.align 2
L1504:
	.short L1419-_gen0
	.short L1421-_gen0
	.short L1423-_gen0
	.short L1425-_gen0
	.short L1427-_gen0
	.short L1429-_gen0
	.short L1431-_gen0
	.short L1433-_gen0
	.short L1384-_gen0
	.short L1384-_gen0
	.short L1439-_gen0
	.short L1441-_gen0
	.short L1443-_gen0
	.short L1384-_gen0
	.short L1384-_gen0
	.short L1384-_gen0
	.short L1384-_gen0
	.short L1384-_gen0
	.short L1456-_gen0
	.short L1456-_gen0
	.short L1456-_gen0
	.short L1456-_gen0
	.short L1459-_gen0
	.short L1459-_gen0
	.short L1461-_gen0
	.short L1463-_gen0
	.short L1465-_gen0
	.short L1467-_gen0
	.short L1469-_gen0
	.short L1471-_gen0
.align 2
L1505:
	.short L1409-_gen0
	.short L1411-_gen0
	.short L1413-_gen0
	.short L1415-_gen0
	.short L1417-_gen0
.align 2
L1506:
	.short L1393-_gen0
	.short L1395-_gen0
	.short L1397-_gen0
	.short L1399-_gen0
	.short L1401-_gen0
	.short L1403-_gen0
	.short L1405-_gen0

_gen0:
L1382:
	pushq %rbx
L1383:
	movq %rdi,%rbx
	movl (%rbx),%ecx
	cmpl $17,%ecx
	jl L1479
L1481:
	cmpl $46,%ecx
	jg L1479
L1478:
	addl $-17,%ecx
	movzwl L1504(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1471:
	movl $822083623,%esi
	movq %rbx,%rdi
	call _gen_blk
	jmp L1384
L1469:
	movl $855638054,%esi
	movq %rbx,%rdi
	call _gen_blk
	jmp L1384
L1467:
	movq 16(%rbx),%rdi
	call _gen0
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _gen0
	movq %rax,24(%rbx)
	movl $_void_tree,%eax
	jmp L1384
L1465:
	movq 16(%rbx),%rdi
	call _gen0
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _gen0
	movq %rax,24(%rbx)
	movq %rbx,%rdi
	call _chop_right
	jmp L1384
L1463:
	movq 16(%rbx),%rdi
	call _gen0
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _gen0
	movq %rax,24(%rbx)
	jmp L1477
L1461:
	movq %rbx,%rdi
	call _gen_ternary
	jmp L1384
L1459:
	movq %rbx,%rdi
	call _gen_log
	jmp L1384
L1443:
	movl $-1275068396,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1441:
	movl $-1275068397,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1439:
	movl $-1342177265,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1433:
	movl $-1275068398,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1431:
	movl $-1342177263,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1429:
	movl $-1342177266,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1427:
	movl $-1275068393,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1425:
	movl $-1275068394,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1423:
	movl $-1275068395,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1421:
	movl $-1275068397,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1419:
	movl $-1275068396,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1479:
	cmpl $536870937,%ecx
	jl L1483
L1485:
	cmpl $536870946,%ecx
	jg L1483
L1482:
	addl $-536870937,%ecx
	movzwl L1503(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1456:
	movq %rbx,%rdi
	call _gen_rel
	jmp L1384
L1449:
	movl $-1275068394,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1447:
	movl $-1275068395,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1445:
	movl $-1275068393,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1437:
	movl $-1342177266,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1435:
	movl $-1342177264,%esi
	movq %rbx,%rdi
	call _gen_binary
	jmp L1384
L1483:
	cmpl $1073741828,%ecx
	jl L1487
L1489:
	cmpl $1073741834,%ecx
	jg L1487
L1486:
	addl $-1073741828,%ecx
	movzwl L1506(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1405:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rdi
	call _gen0
	jmp L1384
L1403:
	movl $-1543503859,%esi
	movq %rbx,%rdi
	call _gen_unary
	jmp L1384
L1401:
	movl $-1610612724,%esi
	movq %rbx,%rdi
	call _gen_unary
	jmp L1384
L1399:
	movq %rbx,%rdi
	call _gen_addrof
	jmp L1384
L1397:
	movq %rbx,%rdi
	call _gen_cast
	jmp L1384
L1395:
	movq %rbx,%rdi
	call _gen_call
	jmp L1384
L1487:
	cmpl $134217740,%ecx
	jl L1491
L1493:
	cmpl $134217744,%ecx
	jg L1491
L1490:
	addl $-134217740,%ecx
	movzwl L1505(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1417:
	movl $-1342177265,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1415:
	movl $-1342177266,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1413:
	movl $-1275068398,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1411:
	movl $-1342177263,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1409:
	movl $-1342177264,%esi
	movq %rbx,%rdi
	call _gen_compound
	jmp L1384
L1491:
	cmpl $-2147483648,%ecx
	jz L1477
L1495:
	cmpl $-2147483646,%ecx
	jz L1477
L1496:
	cmpl $-1879048191,%ecx
	jz L1477
L1497:
	cmpl $11,%ecx
	jz L1407
L1498:
	cmpl $1073741871,%ecx
	jz L1473
L1499:
	cmpl $1073741872,%ecx
	jz L1475
L1500:
	cmpl $1342177283,%ecx
	jnz L1384
L1393:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _gen_fetch
	jmp L1384
L1475:
	movl $-1543503835,%esi
	movq %rbx,%rdi
	call _gen_unary
	jmp L1384
L1473:
	movl $-1543503836,%esi
	movq %rbx,%rdi
	call _gen_unary
	jmp L1384
L1407:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _gen_assign
	jmp L1384
L1477:
	movq %rbx,%rax
L1384:
	popq %rbx
	ret 


_gen:
L1507:
L1508:
	call _simplify
	movq %rax,%rdi
	call _rewrite_volatiles
	movq %rax,%rdi
	call _gen0
L1509:
	ret 


.globl _sym_tree
.globl _symbol_offset
.globl _rewrite_volatiles
.globl _new_block
.globl _unary_tree
.globl _symbol_to_reg
.globl _long_type
.globl _leaf_operand
.globl _chop_left
.globl _char_type
.globl _temp
.globl _loadstore
.globl _addrof
.globl _current_block
.globl _get_tnode
.globl _branch
.globl _simplify
.globl _align_of
.globl _int_type
.globl _add_succ
.globl _chop
.globl _new_insn
.globl _append_insn
.globl _chop_right
.globl _gen
.globl _void_tree
.globl _simpatico
.globl _ulong_type
.globl _size_of
.globl _insert_insn
