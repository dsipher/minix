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
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,(%r12)
	movq 24(%rbx),%rdi
	call _symbol_to_reg
	movl %eax,8(%r12)
	movq 8(%rbx),%rax
	testq %rax,%rax
	jnz L45
	jz L3
L8:
	movl (%r12),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,(%r12)
	movq 16(%rbx),%rax
	movq %rax,16(%r12)
	movq 24(%rbx),%rax
	movq %rax,24(%r12)
	movq 8(%rbx),%rax
	testq %rax,%rax
	jz L3
L45:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl (%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,(%r12)
L3:
	popq %r12
	popq %rbx
	ret 


_frame_addr:
L46:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L47:
	movl %esi,%r15d
	movq %rdx,%r14
	movl %ecx,%r13d
	call _temp
	movq %rax,%r12
	xorl %esi,%esi
	movl $-1610612733,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L63
L55:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L63:
	movslq %r15d,%r15
	movq %r15,-8(%rbp)
	movl 40(%rbx),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,40(%rbx)
	movq -8(%rbp),%rax
	movq %rax,56(%rbx)
	movq $0,64(%rbx)
	movl $_long_type,%eax
	testq %rax,%rax
	jz L81
L73:
	movq _long_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L81:
	movl %r13d,%edx
	movq %r14,%rsi
	movq %rbx,%rdi
	call _insert_insn
	movq %r12,%rax
L48:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_loadstore:
L83:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L84:
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
	jnz L92
L89:
	movq %rbx,%r12
	movq %rax,%rbx
L92:
	movl (%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,(%r12)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,8(%r12)
	movq 32(%r14),%rax
	testq %rax,%rax
	jz L106
L98:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl (%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,(%r12)
L106:
	testl $448,12(%r14)
	jnz L107
L125:
	movl (%rbx),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,(%rbx)
	movq $0,16(%rbx)
	movq %r14,24(%rbx)
	movl $_ulong_type,%eax
	testq %rax,%rax
	jz L109
L131:
	movq _ulong_type(%rip),%rax
	andl $131071,%eax
	shll $5,%eax
	andl $4290773023,%ecx
	orl %eax,%ecx
	movl %ecx,(%rbx)
	jmp L109
L107:
	movq %r14,%rdi
	call _symbol_offset
	movl -16(%rbp),%edx
	movl %edx,%ecx
	incl %edx
	movl %edx,-16(%rbp)
	movq -8(%rbp),%rdx
	movl %eax,%esi
	movl $_ulong_type,%edi
	call _frame_addr
	movq %rax,%r12
	movl (%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,8(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L124
L116:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl (%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,(%rbx)
L124:
	movl $2,-12(%rbp)
L109:
	movq 32(%r14),%rax
	testq $262144,(%rax)
	jz L136
L134:
	movl 4(%r13),%eax
	andl $4294967294,%eax
	orl $1,%eax
	movl %eax,4(%r13)
L136:
	movl -16(%rbp),%edx
	movq -8(%rbp),%rsi
	movq %r13,%rdi
	call _insert_insn
	movl -12(%rbp),%eax
L85:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_branch:
L138:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L139:
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
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,40(%rbx)
	movq -8(%rbp),%rax
	movq %rax,56(%rbx)
	movq $0,64(%rbx)
	movl $_int_type,%eax
	testq %rax,%rax
	jz L158
L150:
	movq _int_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L158:
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
L140:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_binary:
L159:
	pushq %rbx
	pushq %r12
	pushq %r13
L160:
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
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L176
L168:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L176:
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
L161:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_unary:
L178:
	pushq %rbx
	pushq %r12
	pushq %r13
L179:
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
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L195
L187:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L195:
	movq 16(%r13),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r12,%rdi
	call _sym_tree
L180:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L609:
	.quad 0x43e0000000000000

_gen_cast:
L197:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L198:
	movq %rdi,%r12
	movq 16(%r12),%rdi
	call _gen0
	movq %rax,16(%r12)
	movq 8(%r12),%rdi
	call _temp
	movq %rax,%rbx
	movq 8(%r12),%rax
	movq (%rax),%rcx
	testq $512,%rcx
	jz L205
L203:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $7168,(%rax)
	jz L205
L204:
	call _new_block
	movq %rax,%r14
	call _new_block
	movq %rax,-64(%rbp)
	call _new_block
	movq %rax,-56(%rbp)
	movq 16(%r12),%rax
	movq 8(%rax),%rdi
	call _temp
	movq %rax,%r13
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L221
L213:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r15)
L221:
	movsd L609(%rip),%xmm0
	movsd %xmm0,-8(%rbp)
	movl 40(%r15),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,40(%r15)
	movq -8(%rbp),%rax
	movq %rax,56(%r15)
	movq $0,64(%r15)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L239
L231:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r15)
L239:
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $603979787,%edi
	call _new_insn
	movq %rax,%r15
	movq 16(%r12),%rsi
	leaq 8(%r15),%rdi
	call _leaf_operand
	movl 40(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r15)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,48(%r15)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L254
L246:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r15)
L254:
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
	call _append_insn
	movq %r14,%rdx
	movl $11,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq -64(%rbp),%rdx
	movl $10,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r14,_current_block(%rip)
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%r14
	movl 8(%r14),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r14)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r14)
	movl 8(%r14),%eax
	andl $4290773023,%eax
	orl $8192,%eax
	movl %eax,8(%r14)
	movq 16(%r12),%rsi
	leaq 40(%r14),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r14,%rdi
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
	movq %rax,%r14
	movl 8(%r14),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r14)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r14)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L284
L276:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r14),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r14)
L284:
	movq 16(%r12),%rsi
	leaq 40(%r14),%rdi
	call _leaf_operand
	movl 72(%r14),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,72(%r14)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,80(%r14)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L299
L291:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r14),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%r14)
L299:
	movq _current_block(%rip),%rsi
	movq %r14,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movl 8(%r12),%eax
	andl $4290773023,%eax
	orl $8192,%eax
	movl %eax,8(%r12)
	movl 40(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r12)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,48(%r12)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L329
L321:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r12)
L329:
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068393,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movl 8(%r12),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,8(%r12)
	movl 40(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r12)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,48(%r12)
	movl 40(%r12),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,40(%r12)
	movq $-9223372036854775808,%rax
	movq %rax,-16(%rbp)
	movl 72(%r12),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r12)
	movq -16(%rbp),%rax
	movq %rax,88(%r12)
	movq $0,96(%r12)
	movl 72(%r12),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,72(%r12)
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	movq -56(%rbp),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq -56(%rbp),%rax
	jmp L610
L205:
	testq $7168,%rcx
	jz L383
L381:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $512,(%rax)
	jz L383
L382:
	call _new_block
	movq %rax,%r15
	call _new_block
	movq %rax,%r14
	call _new_block
	movq %rax,-48(%rbp)
	xorl %esi,%esi
	movl $603979787,%edi
	call _new_insn
	movq %rax,%r13
	movq 16(%r12),%rsi
	leaq 8(%r13),%rdi
	call _leaf_operand
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl $8192,%eax
	movl %eax,8(%r13)
	movq $0,-24(%rbp)
	movl 40(%r13),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,40(%r13)
	movq -24(%rbp),%rax
	movq %rax,56(%r13)
	movq $0,64(%r13)
	movl 40(%r13),%eax
	andl $4290773023,%eax
	orl $8192,%eax
	movl %eax,40(%r13)
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	movq %r15,%rdx
	movl $4,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r14,%rdx
	movl $5,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r15,_current_block(%rip)
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L417
L409:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L417:
	movq 16(%r12),%rsi
	leaq 40(%r13),%rdi
	call _leaf_operand
	movl 40(%r13),%eax
	andl $4290773023,%eax
	orl $8192,%eax
	movl %eax,40(%r13)
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	movq -48(%rbp),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r14,_current_block(%rip)
	movq 16(%r12),%rax
	movq 8(%rax),%rdi
	call _temp
	movq %rax,%r14
	movq 16(%r12),%rax
	movq 8(%rax),%rdi
	call _temp
	movq %rax,%r13
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,8(%r15)
	movq 16(%r12),%rsi
	leaq 40(%r15),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068397,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,8(%r15)
	movl $32,%ecx
	leaq 8(%r15),%rsi
	leaq 40(%r15),%rdi
	rep 
	movsb 
	movq $1,-32(%rbp)
	movl 72(%r15),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r15)
	movq -32(%rbp),%rax
	movq %rax,88(%r15)
	movq $0,96(%r15)
	movl 72(%r15),%eax
	andl $4290773023,%eax
	orl $64,%eax
	movl %eax,72(%r15)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,8(%r15)
	movq 16(%r12),%rsi
	leaq 40(%r15),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movl 8(%r12),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,8(%r12)
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 40(%r12),%rdi
	rep 
	movsb 
	movq $1,-40(%rbp)
	movl 72(%r12),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r12)
	movq -40(%rbp),%rax
	movq %rax,88(%r12)
	movq $0,96(%r12)
	movl 72(%r12),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,72(%r12)
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068394,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movl 8(%r12),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,8(%r12)
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 40(%r12),%rdi
	rep 
	movsb 
	movl 72(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,72(%r12)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,80(%r12)
	movl 72(%r12),%eax
	andl $4290773023,%eax
	orl $16384,%eax
	movl %eax,72(%r12)
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L558
L550:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L558:
	movl 40(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r12)
	movq %r14,%rdi
	call _symbol_to_reg
	movl %eax,48(%r12)
	movl 40(%r12),%eax
	andl $4290773023,%eax
	orl $8192,%eax
	movl %eax,40(%r12)
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1342177266,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L588
L580:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L588:
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 40(%r12),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 72(%r12),%rdi
	rep 
	movsb 
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	movq -48(%rbp),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq -48(%rbp),%rax
L610:
	movq %rax,_current_block(%rip)
	jmp L202
L383:
	testq $1,%rcx
	jz L590
L589:
	movl $_void_tree,%eax
	jmp L199
L590:
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L607
L599:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L607:
	movq 16(%r12),%rsi
	leaq 40(%r13),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
L202:
	movq %rbx,%rdi
	call _sym_tree
L199:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_addrof:
L611:
	pushq %rbx
L612:
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
	jz L616
L614:
	andl $-257,%eax
	movl %eax,12(%rcx)
	movq 16(%rbx),%rax
	movq 24(%rax),%rax
	orl $64,12(%rax)
L616:
	call _sym_tree
L613:
	popq %rbx
	ret 


_extract_field:
L618:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L619:
	movq %rdi,%r12
	movq %rsi,-40(%rbp)
	xorl %esi,%esi
	movq 32(%r12),%rdi
	call _size_of
	movl %eax,%r13d
	shll $3,%r13d
	movq -40(%rbp),%rax
	movq (%rax),%rax
	movq $545460846592,%rbx
	andq %rax,%rbx
	sarq $32,%rbx
	movq $69269232549888,%r15
	andq %rax,%r15
	sarq $40,%r15
	movq 32(%r12),%rdi
	call _temp
	movq %rax,-32(%rbp)
	movq -40(%rbp),%rax
	testq $680,(%rax)
	jz L626
L624:
	testl %r15d,%r15d
	jnz L626
L625:
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L642
L634:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L642:
	movl 40(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r13)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,48(%r13)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L657
L649:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r13)
L657:
	movb %bl,%cl
	movq $-1,%rax
	shlq %cl,%rax
	notq %rax
	movq %rax,-8(%rbp)
	movl 72(%r13),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r13)
	movq -8(%rbp),%rax
	movq %rax,88(%r13)
	movq $0,96(%r13)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L675
L667:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%r13)
L675:
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	jmp L773
L626:
	addl %ebx,%r15d
	movl %r13d,%r14d
	subl %r15d,%r14d
	subl %ebx,%r13d
	xorl %esi,%esi
	movl $-1275068396,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L690
L682:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L690:
	movl 40(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L705
L697:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L705:
	movslq %r14d,%r14
	movq %r14,-16(%rbp)
	movl 72(%rbx),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%rbx)
	movq -16(%rbp),%rax
	movq %rax,88(%rbx)
	movq $0,96(%rbx)
	movl $_char_type,%eax
	testq %rax,%rax
	jz L723
L715:
	movq _char_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%rbx)
L723:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068397,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	cmpq $0,-40(%rbp)
	jz L738
L730:
	movq -40(%rbp),%rax
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L738:
	movl 40(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	cmpq $0,-40(%rbp)
	jz L753
L745:
	movq -40(%rbp),%rax
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L753:
	movslq %r13d,%r13
	movq %r13,-24(%rbp)
	movl 72(%rbx),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%rbx)
	movq -24(%rbp),%rax
	movq %rax,88(%rbx)
	movq $0,96(%rbx)
	movl $_char_type,%eax
	testq %rax,%rax
	jz L771
L763:
	movq _char_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%rbx)
L771:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
L773:
	call _append_insn
	movq -32(%rbp),%rax
L620:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_insert_field:
L774:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L775:
	movq %rdi,%r13
	movq %rsi,-32(%rbp)
	movq %rdx,%rbx
	xorl %esi,%esi
	movq -32(%rbp),%rax
	movq 32(%rax),%rdi
	call _size_of
	movq (%rbx),%rax
	movq $545460846592,%r14
	andq %rax,%r14
	sarq $32,%r14
	movq $69269232549888,%r12
	andq %rax,%r12
	sarq $40,%r12
	movq -32(%rbp),%rax
	movq 32(%rax),%rdi
	call _temp
	movq %rax,-40(%rbp)
	movq 8(%r13),%rdi
	call _temp
	movq %rax,%rbx
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L791
L783:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r15)
L791:
	movq %r13,%rsi
	leaq 40(%r15),%rdi
	call _leaf_operand
	movb %r14b,%cl
	movq $-1,%r14
	shlq %cl,%r14
	notq %r14
	movq %r14,-8(%rbp)
	movl 72(%r15),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r15)
	movq -8(%rbp),%rax
	movq %rax,88(%r15)
	movq $0,96(%r15)
	movq 8(%r13),%rax
	testq %rax,%rax
	jz L809
L801:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%r15)
L809:
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068396,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L824
L816:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L824:
	movl 40(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,48(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L839
L831:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r13)
L839:
	movslq %r12d,%rax
	movq %rax,-16(%rbp)
	movl 72(%r13),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r13)
	movq -16(%rbp),%rax
	movq %rax,88(%r13)
	movq $0,96(%r13)
	movl $_char_type,%eax
	testq %rax,%rax
	jz L857
L849:
	movq _char_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%r13)
L857:
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068395,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq -40(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq -40(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L872
L864:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L872:
	movl 40(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r13)
	movq -32(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%r13)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L887
L879:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r13)
L887:
	movb %r12b,%cl
	shlq %cl,%r14
	notq %r14
	movq %r14,-24(%rbp)
	movl 72(%r13),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r13)
	movq -24(%rbp),%rax
	movq %rax,88(%r13)
	movq $0,96(%r13)
	movq -32(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L905
L897:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%r13)
L905:
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-1275068394,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r12)
	movq -40(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r12)
	movq -40(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L920
L912:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r12)
L920:
	movl 40(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r12)
	movq -40(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%r12)
	movq -40(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L935
L927:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r12)
L935:
	movl 72(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,72(%r12)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,80(%r12)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L950
L942:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r12),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%r12)
L950:
	movq _current_block(%rip),%rsi
	movq %r12,%rdi
	call _append_insn
	movq -40(%rbp),%rax
L776:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_fetch:
L952:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L953:
	movq %rdi,%r14
	movq %rsi,%r13
	movq 16(%r14),%rdi
	call _gen0
	movq %rax,16(%r14)
	movq 8(%r14),%rdi
	testq $8192,(%rdi)
	jnz L955
L957:
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
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 8(%r14),%rax
	testq %rax,%rax
	jz L973
L965:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L973:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	testq $65536,(%rax)
	jz L976
L977:
	movq 24(%rax),%rax
	testq $262144,(%rax)
	jz L976
L978:
	movl 4(%rbx),%eax
	andl $4294967294,%eax
	orl $1,%eax
	movl %eax,4(%rbx)
L976:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movl (%r14),%eax
	cmpl $1342177283,%eax
	jz L989
L988:
	cmpl $1073741828,%eax
	jnz L983
L989:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L983
L985:
	testq %r13,%r13
	jz L994
L992:
	movq %r12,(%r13)
L994:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rsi
	movq %r12,%rdi
	call _extract_field
	movq %rax,%r12
L983:
	movq %r12,%rdi
	call _sym_tree
	jmp L954
L955:
	movq %r14,%rax
L954:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_assign:
L996:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L997:
	movq %rdi,%r13
	movq %rsi,%r12
	movq 24(%r13),%rdi
	call _gen0
	movq %rax,24(%r13)
	movq 16(%r13),%rax
	cmpl $2415919105,(%rax)
	jnz L1000
L999:
	movq 24(%rax),%rax
	movq %rax,-8(%rbp)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq -8(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq -8(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L1055
L1008:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
	jmp L1055
L1000:
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
	jz L1019
L1020:
	movq 24(%rax),%rax
	testq $262144,(%rax)
	jz L1019
L1021:
	movl 4(%rbx),%eax
	andl $4294967294,%eax
	orl $1,%eax
	movl %eax,4(%rbx)
L1019:
	movq 16(%r13),%rdi
	movl (%rdi),%eax
	cmpl $1342177283,%eax
	jz L1032
L1031:
	cmpl $1073741828,%eax
	jnz L1055
L1032:
	movq 16(%rdi),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jnz L1028
L1055:
	movq 24(%r13),%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	jmp L1001
L1028:
	testq %r12,%r12
	jz L1036
L1035:
	movq %r12,-8(%rbp)
	jmp L1037
L1036:
	leaq -8(%rbp),%rsi
	call _gen_fetch
L1037:
	movq 24(%r13),%rdi
	movq 16(%r13),%rax
	movq 16(%rax),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdx
	movq -8(%rbp),%rsi
	call _insert_field
	movq %rax,-8(%rbp)
	movl 40(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%rbx)
	movq -8(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,48(%rbx)
	movq -8(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L1052
L1044:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%rbx)
L1052:
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
L1001:
	movq %r13,%rdi
	call _chop_right
L998:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_compound:
L1056:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1057:
	movq %rdi,%r14
	movl %esi,-12(%rbp)
	xorl %r13d,%r13d
	movq $0,-8(%rbp)
	movq 8(%r14),%rdi
	call _temp
	movq %rax,%r12
	movq 24(%r14),%rdi
	call _gen0
	movq %rax,24(%r14)
	movq 16(%r14),%rdi
	cmpl $2415919105,(%rdi)
	jnz L1060
L1059:
	movq 24(%rdi),%rbx
	jmp L1061
L1060:
	leaq -8(%rbp),%rsi
	call _gen_fetch
	movq 24(%rax),%rbx
L1061:
	cmpl $22,(%r14)
	jnz L1064
L1062:
	movq 8(%r14),%rdi
	call _temp
	movq %rax,%r13
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L1079
L1071:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r15)
L1079:
	movl 40(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r15)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,48(%r15)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L1094
L1086:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r15)
L1094:
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
	call _append_insn
L1064:
	testl $134217728,(%r14)
	jz L1100
L1098:
	movq 16(%r14),%rax
	movq 8(%rax),%rdi
	movq 24(%r14),%rax
	movq 8(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jnz L1100
L1099:
	movq 24(%r14),%rax
	movq 8(%rax),%r15
	movq %rbx,%rdi
	call _sym_tree
	movq %rax,%rdx
	movq %r15,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,%rdi
	call _gen
	movq %rax,%rbx
	xorl %esi,%esi
	movl -12(%rbp),%edi
	call _new_insn
	movq %rax,%r15
	movq %rbx,%rsi
	leaq 8(%r15),%rdi
	call _leaf_operand
	movq %rbx,%rsi
	leaq 40(%r15),%rdi
	call _leaf_operand
	movq 24(%r14),%rsi
	leaq 72(%r15),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
	call _append_insn
	movq 16(%r14),%rax
	movq %rbx,%rdx
	movq 8(%rax),%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,%rdi
	call _gen
	movq %rax,%r15
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L1116
L1108:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1116:
	movq %r15,%rsi
	leaq 40(%rbx),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	jmp L1151
L1100:
	xorl %esi,%esi
	movl -12(%rbp),%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L1131
L1123:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r15)
L1131:
	movl 40(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,40(%r15)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,48(%r15)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L1146
L1138:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r15)
L1146:
	movq 24(%r14),%rsi
	leaq 72(%r15),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r15,%rdi
L1151:
	call _append_insn
	movq %r12,%rdi
	call _sym_tree
	movq %rax,24(%r14)
	movq -8(%rbp),%rsi
	movq %r14,%rdi
	call _gen_assign
	testq %r13,%r13
	jz L1058
L1147:
	movq %r13,%rdi
	call _sym_tree
L1058:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_rel:
L1152:
	pushq %rbx
	pushq %r12
	pushq %r13
L1153:
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
	jz L1162
L1199:
	cmpl $36,%eax
	jz L1172
L1200:
	cmpl $37,%eax
	jz L1177
L1201:
	cmpl $38,%eax
	jz L1167
L1202:
	cmpl $536870945,%eax
	jz L1158
L1203:
	cmpl $536870946,%eax
	movl $1,%eax
	jmp L1206
L1158:
	xorl %ebx,%ebx
	jmp L1156
L1167:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $11,%eax
	movl $7,%ebx
	jmp L1206
L1177:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $9,%eax
	movl $5,%ebx
	jmp L1206
L1172:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $10,%eax
	movl $6,%ebx
	jmp L1206
L1162:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	movl $8,%eax
	movl $4,%ebx
L1206:
	cmovzl %eax,%ebx
L1156:
	movq 8(%r12),%rdi
	call _temp
	movq %rax,%r12
	xorl %esi,%esi
	leal -1744830440(%rbx),%edi
	call _new_insn
	movq %rax,%rbx
	movl 8(%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%rbx)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%rbx)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L1196
L1188:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
L1196:
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
	movq %r12,%rdi
	call _sym_tree
L1154:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_log:
L1207:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1208:
	movq %rdi,%r14
	movq 8(%r14),%rdi
	call _temp
	movq %rax,%r13
	call _new_block
	movq %rax,-24(%rbp)
	call _new_block
	movq %rax,%r12
	call _new_block
	movq %rax,%rbx
	call _new_block
	movq %rax,-32(%rbp)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L1224
L1216:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r15)
L1224:
	movq $0,-8(%rbp)
	movl 40(%r15),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,40(%r15)
	movq -8(%rbp),%rax
	movq %rax,56(%r15)
	movq $0,64(%r15)
	movl $_int_type,%eax
	testq %rax,%rax
	jz L1242
L1234:
	movq _int_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r15)
L1242:
	movq %rbx,%rsi
	movq %r15,%rdi
	call _append_insn
	movq -32(%rbp),%rdx
	movl $12,%esi
	movq %rbx,%rdi
	call _add_succ
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r15)
	movq %r13,%rdi
	call _symbol_to_reg
	movl %eax,16(%r15)
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L1257
L1249:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r15)
L1257:
	movq $1,-16(%rbp)
	movl 40(%r15),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,40(%r15)
	movq -16(%rbp),%rax
	movq %rax,56(%r15)
	movq $0,64(%r15)
	movl $_int_type,%eax
	testq %rax,%rax
	jz L1275
L1267:
	movq _int_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r15),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%r15)
L1275:
	movq %r12,%rsi
	movq %r15,%rdi
	call _append_insn
	movq -32(%rbp),%rdx
	movl $12,%esi
	movq %r12,%rdi
	call _add_succ
	movq 16(%r14),%rdi
	call _gen0
	movq %rax,%rdi
	movq %rdi,16(%r14)
	cmpl $39,(%r14)
	jnz L1277
L1276:
	movq -24(%rbp),%rdx
	movq %r12,%rsi
	jmp L1280
L1277:
	movq %rbx,%rdx
	movq -24(%rbp),%rsi
L1280:
	call _branch
	movq -24(%rbp),%rax
	movq %rax,_current_block(%rip)
	movq 24(%r14),%rdi
	call _gen0
	movq %rax,24(%r14)
	movq %rbx,%rdx
	movq %r12,%rsi
	movq %rax,%rdi
	call _branch
	movq -32(%rbp),%rax
	movq %rax,_current_block(%rip)
	movq %r13,%rdi
	call _sym_tree
L1209:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen_ternary:
L1281:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1282:
	movq %rdi,%r12
	movq 8(%r12),%rdi
	testq $1,(%rdi)
	jz L1285
L1284:
	xorl %ebx,%ebx
	jmp L1286
L1285:
	call _temp
	movq %rax,%rbx
L1286:
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
	jz L1292
L1290:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L1307
L1299:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L1307:
	movq 24(%r12),%rax
	movq 16(%rax),%rsi
	leaq 40(%r13),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
L1292:
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
	jz L1313
L1311:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%rbx),%rax
	testq %rax,%rax
	jz L1328
L1320:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L1328:
	movq 24(%r12),%rax
	movq 24(%rax),%rsi
	leaq 40(%r13),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
L1313:
	movq %r14,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r14,_current_block(%rip)
	testq %rbx,%rbx
	jz L1330
L1329:
	movq %rbx,%rdi
	call _sym_tree
	jmp L1283
L1330:
	movl $_void_tree,%eax
L1283:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen_blk:
L1333:
	pushq %rbx
	pushq %r12
L1334:
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
L1335:
	popq %r12
	popq %rbx
	ret 


_gen_call:
L1337:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1338:
	movq %rdi,%r15
	movq 8(%r15),%rdi
	testq $1,(%rdi)
	jz L1341
L1340:
	movq $0,-8(%rbp)
	jmp L1342
L1341:
	call _temp
	movq %rax,-8(%rbp)
L1342:
	movl 4(%r15),%esi
	movl $-1493172218,%edi
	call _new_insn
	movq %rax,%r14
	xorl %r12d,%r12d
	jmp L1343
L1344:
	leal 2(%r12),%r13d
	movslq %r13d,%r13
	shlq $5,%r13
	movq 24(%r15),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rax
	movq 8(%rax),%rbx
	movq %rax,-16(%rbp)
	testq $8192,(%rbx)
	jz L1349
L1347:
	movq %rbx,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
	movq -16(%rbp),%rdi
	call _addrof
	movq 24(%r15),%rcx
	movq %rax,(%rcx,%r12,8)
L1349:
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
	jz L1352
L1350:
	movl 8(%r14,%r13),%eax
	andl $4290773023,%eax
	orl $262144,%eax
	movl %eax,8(%r14,%r13)
	xorl %esi,%esi
	movq %rbx,%rdi
	call _size_of
	andl $268435455,%eax
	movl 12(%r14,%r13),%ecx
	andl $4026531840,%ecx
	orl %eax,%ecx
	movl %ecx,12(%r14,%r13)
	movq %rbx,%rdi
	call _align_of
	andl $15,%eax
	shll $28,%eax
	movl 12(%r14,%r13),%ecx
	andl $268435455,%ecx
	orl %eax,%ecx
	movl %ecx,12(%r14,%r13)
L1352:
	incl %r12d
L1343:
	cmpl 4(%r15),%r12d
	jl L1344
L1346:
	movq 16(%r15),%rdi
	call _gen0
	movq %rax,16(%r15)
	movq %rax,%rsi
	leaq 40(%r14),%rdi
	call _leaf_operand
	movq 16(%r15),%rax
	movq 8(%rax),%rax
	testq $65536,(%rax)
	jz L1355
L1360:
	movq 24(%rax),%rax
	movq (%rax),%rax
	testq $32768,%rax
	jz L1355
L1364:
	testq $1048576,%rax
	jz L1355
L1365:
	movl 4(%r14),%eax
	andl $4294965247,%eax
	orl $2048,%eax
	movl %eax,4(%r14)
L1355:
	cmpq $0,-8(%rbp)
	jz L1370
L1371:
	movl 8(%r14),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r14)
	movq -8(%rbp),%rdi
	call _symbol_to_reg
	movl %eax,16(%r14)
	movq -8(%rbp),%rax
	movq 32(%rax),%rax
	testq %rax,%rax
	jz L1370
L1377:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r14),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%r14)
L1370:
	movq _current_block(%rip),%rsi
	movq %r14,%rdi
	call _append_insn
	cmpq $0,-8(%rbp)
	jz L1387
L1386:
	movq -8(%rbp),%rdi
	call _sym_tree
	jmp L1339
L1387:
	movl $_void_tree,%eax
L1339:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L1511:
	.short L1443-_gen0
	.short L1445-_gen0
	.short L1392-_gen0
	.short L1392-_gen0
	.short L1392-_gen0
	.short L1453-_gen0
	.short L1455-_gen0
	.short L1457-_gen0
	.short L1464-_gen0
	.short L1464-_gen0
.align 2
L1512:
	.short L1427-_gen0
	.short L1429-_gen0
	.short L1431-_gen0
	.short L1433-_gen0
	.short L1435-_gen0
	.short L1437-_gen0
	.short L1439-_gen0
	.short L1441-_gen0
	.short L1392-_gen0
	.short L1392-_gen0
	.short L1447-_gen0
	.short L1449-_gen0
	.short L1451-_gen0
	.short L1392-_gen0
	.short L1392-_gen0
	.short L1392-_gen0
	.short L1392-_gen0
	.short L1392-_gen0
	.short L1464-_gen0
	.short L1464-_gen0
	.short L1464-_gen0
	.short L1464-_gen0
	.short L1467-_gen0
	.short L1467-_gen0
	.short L1469-_gen0
	.short L1471-_gen0
	.short L1473-_gen0
	.short L1475-_gen0
	.short L1477-_gen0
	.short L1479-_gen0
.align 2
L1513:
	.short L1417-_gen0
	.short L1419-_gen0
	.short L1421-_gen0
	.short L1423-_gen0
	.short L1425-_gen0
.align 2
L1514:
	.short L1401-_gen0
	.short L1403-_gen0
	.short L1405-_gen0
	.short L1407-_gen0
	.short L1409-_gen0
	.short L1411-_gen0
	.short L1413-_gen0

_gen0:
L1390:
	pushq %rbx
L1391:
	movq %rdi,%rbx
	movl (%rbx),%ecx
	cmpl $17,%ecx
	jl L1487
L1489:
	cmpl $46,%ecx
	jg L1487
L1486:
	addl $-17,%ecx
	movzwl L1512(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1479:
	movl $822083623,%esi
	jmp L1519
L1477:
	movl $855638054,%esi
L1519:
	movq %rbx,%rdi
	call _gen_blk
	jmp L1392
L1475:
	movq 16(%rbx),%rdi
	call _gen0
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _gen0
	movq %rax,24(%rbx)
	movl $_void_tree,%eax
	jmp L1392
L1473:
	movq 16(%rbx),%rdi
	call _gen0
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _gen0
	movq %rax,24(%rbx)
	movq %rbx,%rdi
	call _chop_right
	jmp L1392
L1471:
	movq 16(%rbx),%rdi
	call _gen0
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _gen0
	movq %rax,24(%rbx)
	jmp L1485
L1469:
	movq %rbx,%rdi
	call _gen_ternary
	jmp L1392
L1467:
	movq %rbx,%rdi
	call _gen_log
	jmp L1392
L1451:
	movl $-1275068396,%esi
	jmp L1518
L1449:
	movl $-1275068397,%esi
	jmp L1518
L1447:
	movl $-1342177265,%esi
	jmp L1518
L1441:
	movl $-1275068398,%esi
	jmp L1518
L1439:
	movl $-1342177263,%esi
	jmp L1518
L1437:
	jmp L1517
L1435:
	movl $-1275068393,%esi
	jmp L1516
L1433:
	movl $-1275068394,%esi
	jmp L1516
L1431:
	movl $-1275068395,%esi
	jmp L1516
L1429:
	movl $-1275068397,%esi
	jmp L1516
L1427:
	movl $-1275068396,%esi
	jmp L1516
L1487:
	cmpl $536870937,%ecx
	jl L1491
L1493:
	cmpl $536870946,%ecx
	jg L1491
L1490:
	addl $-536870937,%ecx
	movzwl L1511(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1464:
	movq %rbx,%rdi
	call _gen_rel
	jmp L1392
L1457:
	movl $-1275068394,%esi
	jmp L1518
L1455:
	movl $-1275068395,%esi
	jmp L1518
L1453:
	movl $-1275068393,%esi
	jmp L1518
L1445:
	movl $-1342177266,%esi
	jmp L1518
L1443:
	movl $-1342177264,%esi
L1518:
	movq %rbx,%rdi
	call _gen_binary
	jmp L1392
L1491:
	cmpl $1073741828,%ecx
	jl L1495
L1497:
	cmpl $1073741834,%ecx
	jg L1495
L1494:
	addl $-1073741828,%ecx
	movzwl L1514(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1413:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rdi
	call _gen0
	jmp L1392
L1411:
	movl $-1543503859,%esi
	jmp L1515
L1409:
	movl $-1610612724,%esi
	jmp L1515
L1407:
	movq %rbx,%rdi
	call _gen_addrof
	jmp L1392
L1405:
	movq %rbx,%rdi
	call _gen_cast
	jmp L1392
L1403:
	movq %rbx,%rdi
	call _gen_call
	jmp L1392
L1495:
	cmpl $134217740,%ecx
	jl L1499
L1501:
	cmpl $134217744,%ecx
	jg L1499
L1498:
	addl $-134217740,%ecx
	movzwl L1513(,%rcx,2),%ecx
	addl $_gen0,%ecx
	jmp *%rcx
L1425:
	movl $-1342177265,%esi
	jmp L1516
L1423:
L1517:
	movl $-1342177266,%esi
	jmp L1516
L1421:
	movl $-1275068398,%esi
	jmp L1516
L1419:
	movl $-1342177263,%esi
	jmp L1516
L1417:
	movl $-1342177264,%esi
L1516:
	movq %rbx,%rdi
	call _gen_compound
	jmp L1392
L1499:
	cmpl $-2147483648,%ecx
	jz L1485
L1503:
	cmpl $-2147483646,%ecx
	jz L1485
L1504:
	cmpl $-1879048191,%ecx
	jz L1485
L1505:
	cmpl $11,%ecx
	jz L1415
L1506:
	cmpl $1073741871,%ecx
	jz L1481
L1507:
	cmpl $1073741872,%ecx
	jz L1483
L1508:
	cmpl $1342177283,%ecx
	jnz L1392
L1401:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _gen_fetch
	jmp L1392
L1483:
	movl $-1543503835,%esi
	jmp L1515
L1481:
	movl $-1543503836,%esi
L1515:
	movq %rbx,%rdi
	call _gen_unary
	jmp L1392
L1415:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _gen_assign
	jmp L1392
L1485:
	movq %rbx,%rax
L1392:
	popq %rbx
	ret 


_gen:
L1520:
L1521:
	call _simplify
	movq %rax,%rdi
	call _rewrite_volatiles
	movq %rax,%rdi
	call _gen0
L1522:
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
