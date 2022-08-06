.text

_func_size:
L1:
L2:
	xorl %eax,%eax
	movq _all_blocks(%rip),%rdx
L4:
	testq %rdx,%rdx
	jz L3
L5:
	addl 12(%rdx),%eax
	movq 112(%rdx),%rdx
	jmp L4
L3:
	ret 


_arg0:
L9:
	pushq %rbx
	pushq %r12
	pushq %r13
L10:
	movq %rdi,%r12
	xorl %ebx,%ebx
	cmpq $0,(%r12)
	jnz L14
L15:
	testl $1048576,12(%r12)
	jnz L14
L16:
	pushq $L19
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L14:
	cmpq $0,32(%r12)
	jnz L22
L20:
	movq $_int_type,32(%r12)
L22:
	movq 32(%r12),%rdi
	movq (%r12),%rsi
	call _size_of
	movl %eax,%r13d
	testl $16777216,12(%r12)
	jz L25
L23:
	movq %r12,%rbx
	movl $_double_type,%edi
	call _temp
	movq %rax,%r12
L25:
	movq _current_func(%rip),%rax
	movq 32(%rax),%rax
	movq (%rax),%rax
	testq $32768,%rax
	jz L43
L41:
	testq $1048576,%rax
	jnz L30
L43:
	movq 32(%r12),%rax
	movq (%rax),%rax
	testq $8192,%rax
	jnz L30
L39:
	testq $66558,%rax
	jz L47
L45:
	cmpl $6,_nr_iargs(%rip)
	jz L30
L47:
	testq $7168,%rax
	jz L51
L49:
	cmpl $8,_nr_fargs(%rip)
	jnz L51
L30:
	movl _next_stack_arg(%rip),%eax
	movl %eax,48(%r12)
	movl _next_stack_arg(%rip),%eax
	movl $8,%ecx
	leal 7(%rax,%r13),%eax
	cltd 
	idivl %ecx
	shll $3,%eax
	movl %eax,_next_stack_arg(%rip)
	movq 32(%r12),%rax
	movq (%rax),%rax
	testq $8192,%rax
	jnz L11
L56:
	testq $262144,%rax
	jnz L11
L58:
	movq _current_block(%rip),%rdx
	movl 12(%rdx),%ecx
	movq %r12,%rsi
	movl $-1577058300,%edi
	call _loadstore
	jmp L28
L51:
	xorl %esi,%esi
	movl $-1870659577,%edi
	call _new_insn
	movq %rax,%r13
	movl 8(%r13),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,8(%r13)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L75
L67:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L75:
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	movq 32(%r12),%rax
	testq $66558,(%rax)
	jz L77
L76:
	incl _nr_iargs(%rip)
	jmp L28
L77:
	incl _nr_fargs(%rip)
L28:
	testq %rbx,%rbx
	jz L81
L79:
	xorl %esi,%esi
	movl $-1610612726,%edi
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
	jz L96
L88:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,8(%r13)
L96:
	movl 40(%r13),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,40(%r13)
	movq %r12,%rdi
	call _symbol_to_reg
	movl %eax,48(%r13)
	movq 32(%r12),%rax
	testq %rax,%rax
	jz L111
L103:
	movq (%rax),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%r13),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,40(%r13)
L111:
	movq _current_block(%rip),%rsi
	movq %r13,%rdi
	call _append_insn
	movq %rbx,%r12
L81:
	movq 32(%r12),%rax
	testq $262144,(%rax)
	jz L11
L112:
	movq _current_block(%rip),%rdx
	movl 12(%rdx),%ecx
	movq %r12,%rsi
	movl $553648133,%edi
	call _loadstore
L11:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_enter_func:
L115:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L116:
	movq %rdi,%rbx
	movq %rbx,_current_func(%rip)
	testl $1073741824,12(%rbx)
	jz L122
L118:
	pushq %rbx
	pushq $L121
	pushq (%rbx)
	pushq $4
	call _error
	addq $32,%rsp
L122:
	movq _path(%rip),%rax
	movq %rax,24(%rbx)
	movl _line_no(%rip),%eax
	movl %eax,20(%rbx)
	orl $1073741824,12(%rbx)
	call _reset_blocks
	call _reset_regs
	call _reset_reach
	incl _reg_generation(%rip)
	movl $0,_frame_size(%rip)
	movl $0,_nr_iargs(%rip)
	movl $0,_nr_fargs(%rip)
	movl $16,_next_stack_arg(%rip)
	movq 32(%rbx),%rax
	movq 24(%rax),%rdi
	movq %rdi,_func_ret_type(%rip)
	testq $1,(%rdi)
	jnz L127
L125:
	xorl %esi,%esi
	call _size_of
L127:
	movq _func_ret_type(%rip),%rdi
	testq $8192,(%rdi)
	jz L129
L128:
	movq %rdi,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rdi
	call _temp
	movq %rax,_func_hidden_arg(%rip)
	orl $135266304,12(%rax)
	movq _func_hidden_arg(%rip),%rdi
	call _arg0
	movq _func_ret_type(%rip),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rdi
	jmp L137
L129:
	movq $0,_func_hidden_arg(%rip)
	testq $1,(%rdi)
	jnz L131
L137:
	call _temp
	movq %rax,_func_ret_sym(%rip)
	jmp L130
L131:
	movq $0,_func_ret_sym(%rip)
L130:
	movl $_arg0,%edx
	movl $134217728,%esi
	movl $2,%edi
	call _walk_scope
	movq _func_ret_type(%rip),%rdi
	testq $8192,(%rdi)
	jz L136
L134:
	movq _current_block(%rip),%r13
	movq _exit_block(%rip),%rax
	movq %rax,_current_block(%rip)
	xorl %esi,%esi
	call _size_of
	movslq %eax,%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_ulong_type,%edi
	call _con_tree
	movq %rax,%r12
	movq _func_hidden_arg(%rip),%rdi
	call _sym_tree
	movq %rax,%rbx
	movq _func_ret_sym(%rip),%rdi
	call _sym_tree
	movq %r12,%rcx
	movq %rax,%rdx
	movq %rbx,%rsi
	movl $45,%edi
	call _blk_tree
	movq %rax,%rdi
	call _gen
	movq %r13,_current_block(%rip)
L136:
	xorl %esi,%esi
	movl $41943048,%edi
	call _new_insn
	movq _exit_block(%rip),%rsi
	movq %rax,%rdi
	call _append_insn
L117:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_out_func:
L138:
	pushq %rbx
	pushq %r12
L139:
	xorl %edi,%edi
	call _sequence_blocks
	movl $1,%edi
	call _seg
	pushq _current_func(%rip)
	pushq $L141
	call _out
	addq $16,%rsp
	movq _all_blocks(%rip),%r12
L142:
	testq %r12,%r12
	jz L145
L143:
	movq %r12,%rdi
	call _out_block
	testl $1,4(%r12)
	jnz L146
L148:
	xorl %ebx,%ebx
L154:
	cmpl 60(%r12),%ebx
	jge L144
L155:
	movq 64(%r12),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdx
	cmpq 112(%r12),%rdx
	jz L156
L160:
	movslq (%rcx,%rax),%rax
	movq _cc_text(,%rax,8),%rcx
	movl (%rdx),%eax
	pushq %rax
	pushq %rcx
	pushq $L162
	call _out
	addq $24,%rsp
L156:
	incl %ebx
	jmp L154
L146:
	pushq $L149
	call _out
	addq $8,%rsp
	movl $1,%esi
	leaq 80(%r12),%rdi
	call _out_operand
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L151
L150:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L144
L151:
	movl $10,%edi
	call ___flushbuf
L144:
	movq 112(%r12),%r12
	jmp L142
L145:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L164
L163:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L140
L164:
	movl $10,%edi
	call ___flushbuf
L140:
	popq %r12
	popq %rbx
	ret 


_logues:
L166:
	pushq %rbp
	movq %rsp,%rbp
	subq $144,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L169:
	movl $0,-24(%rbp)
	movl $0,-20(%rbp)
	movq $0,-16(%rbp)
	movq $_func_arena,-8(%rbp)
	xorl %ebx,%ebx
L173:
	movslq %ebx,%rax
	movl _iscratch(,%rax,4),%esi
	leaq -24(%rbp),%rdi
	call _add_reg
	incl %ebx
	cmpl $9,%ebx
	jl L173
L175:
	xorl %ebx,%ebx
L177:
	movslq %ebx,%rax
	movl _fscratch(,%rax,4),%esi
	leaq -24(%rbp),%rdi
	call _add_reg
	incl %ebx
	cmpl $8,%ebx
	jl L177
L180:
	movl $0,-48(%rbp)
	movl $0,-44(%rbp)
	movq $0,-40(%rbp)
	movq $_func_arena,-32(%rbp)
	movl $0,-72(%rbp)
	movl $0,-68(%rbp)
	movq $0,-64(%rbp)
	movq $_func_arena,-56(%rbp)
	leaq -48(%rbp),%rdi
	call _all_regs
	leaq -24(%rbp),%rdx
	leaq -48(%rbp),%rsi
	leaq -72(%rbp),%rdi
	call _diff_regs
	xorl %ecx,%ecx
	xorl %edi,%edi
	xorl %esi,%esi
L186:
	cmpl -68(%rbp),%esi
	jge L192
L190:
	movq -64(%rbp),%rdx
	movslq %esi,%rax
	movl (%rdx,%rax,4),%edx
	testl %edx,%edx
	jz L192
L191:
	cmpl $2147647488,%edx
	jz L188
L196:
	movl %edx,%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	jnz L199
L198:
	cmpl $2147663872,%edx
	movl $1,%eax
	cmovzl %eax,%ecx
	jmp L188
L199:
	incl %edi
L188:
	incl %esi
	jmp L186
L192:
	movl _frame_size(%rip),%eax
	movl $8,%esi
	leal 7(%rax,%rdi,8),%eax
	cltd 
	idivl %esi
	shll $3,%eax
	movl %eax,_frame_size(%rip)
	movl $1,%eax
	cmovnzl %eax,%ecx
	movq _exit_block(%rip),%rax
	xorl %r13d,%r13d
	movl 12(%rax),%r12d
	testl %ecx,%ecx
	jz L209
L207:
	xorl %esi,%esi
	movl $276826304,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl $-2147303424,16(%rax)
	xorl %edx,%edx
	movq _entry_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $-1870657343,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl $-2147303424,16(%rax)
	leal -1(%r12),%edx
	movq _exit_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $-1610545081,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl $-2147303424,16(%rax)
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,40(%rax)
	movl $-2147319808,48(%rax)
	movl $2,%r13d
	movl $1,%edx
	movq _entry_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
	cmpl $0,_frame_size(%rip)
	jz L209
L270:
	xorl %esi,%esi
	movl $-469694343,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl $-2147319808,16(%rax)
	movslq _frame_size(%rip),%rcx
	movq %rcx,-80(%rbp)
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -80(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl $8192,%ecx
	movl %ecx,40(%rax)
	movl $3,%r13d
	movl $2,%edx
	movq _entry_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $-1610545081,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl $-2147319808,16(%rax)
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,40(%rax)
	movl $-2147303424,48(%rax)
	leal -1(%r12),%edx
	movq _exit_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
L209:
	movl _frame_size(%rip),%r14d
	negl %r14d
	xorl %ebx,%ebx
L336:
	cmpl -68(%rbp),%ebx
	jge L342
L340:
	movq -64(%rbp),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%ecx
	testl %ecx,%ecx
	jz L342
L341:
	movl %ecx,%eax
	andl $3221225472,%eax
	cmpl $3221225472,%eax
	jnz L346
L347:
	movl -112(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-112(%rbp)
	movl %ecx,-104(%rbp)
	movl -144(%rbp),%eax
	andl $-8,%eax
	orl $3,%eax
	movl $-2147303424,-136(%rbp)
	movl $0,-132(%rbp)
	andl $-25,%eax
	movl %eax,-144(%rbp)
	movslq %r14d,%rax
	movq %rax,-128(%rbp)
	movq $0,-120(%rbp)
	leaq -112(%rbp),%rdx
	leaq -144(%rbp),%rsi
	movl $2048,%edi
	call _move
	movl %r13d,%edx
	incl %r13d
	movq _entry_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
	leaq -144(%rbp),%rdx
	leaq -112(%rbp),%rsi
	movl $2048,%edi
	call _move
	leal -1(%r12),%edx
	movq _exit_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
	addl $8,%r14d
L346:
	incl %ebx
	jmp L336
L342:
	xorl %r14d,%r14d
L377:
	cmpl -68(%rbp),%r14d
	jge L168
L381:
	movq -64(%rbp),%rcx
	movslq %r14d,%rax
	movl (%rcx,%rax,4),%ebx
	testl %ebx,%ebx
	jz L168
L382:
	movl %ebx,%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	jnz L387
L388:
	cmpl $2147663872,%ebx
	setnz %al
	movzbl %al,%eax
	cmpl $2147647488,%ebx
	setnz %cl
	movzbl %cl,%ecx
	testl %ecx,%eax
	jz L387
L389:
	xorl %esi,%esi
	movl $276826304,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl %r13d,%edx
	incl %r13d
	movq _entry_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $-1870657343,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	leal -1(%r12),%edx
	movq _exit_block(%rip),%rsi
	movq %rax,%rdi
	call _insert_insn
L387:
	incl %r14d
	jmp L377
L168:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_exit_func:
L422:
L423:
	movq _current_block(%rip),%rdi
	movq _exit_block(%rip),%rdx
	movl $12,%esi
	call _add_succ
	movl $_func_chain,%edi
	call _registerize
	call _dealias
	movl $1024,%esi
	movl $1023,%edi
	call _opt
	call _lir_switch
	call _deconst
	testl %eax,%eax
	jz L427
L425:
	movl $1088,%esi
	movl $384,%edi
	call _opt
L427:
	call _lower
	call _mch_switch
	call _color
	call _logues
	call _out_func
	movl $_func_chain,%edi
	call _free_symbols
	movq _func_arena(%rip),%rax
	movq %rax,_func_arena+8(%rip)
	movq $0,_current_func(%rip)
L424:
	ret 


_frame_alloc:
L431:
	pushq %rbx
	pushq %r12
L432:
	movq %rdi,%r12
	xorl %esi,%esi
	movq %r12,%rdi
	call _size_of
	movl %eax,%ebx
	movq %r12,%rdi
	call _align_of
	movl %eax,%esi
	movl _frame_size(%rip),%eax
	addl %ebx,%eax
	movl %esi,%ecx
	decl %ecx
	addl %ecx,%eax
	cltd 
	idivl %esi
	imull %esi,%eax
	movl %eax,_frame_size(%rip)
	negl %eax
L433:
	popq %r12
	popq %rbx
	ret 


_temp:
L435:
	pushq %rbx
L436:
	movq %rdi,%rbx
	testq $73726,(%rbx)
	movl $64,%eax
	movl $128,%esi
	cmovzl %eax,%esi
	orl $2097152,%esi
	xorl %edi,%edi
	call _new_symbol
	movq %rbx,32(%rax)
	movq _func_chain(%rip),%rcx
	movq %rcx,56(%rax)
	movq %rax,_func_chain(%rip)
L437:
	popq %rbx
	ret 


_temp_reg:
L442:
L443:
	xorl %edx,%edx
	xorl %esi,%esi
	call _get_tnode
	movq %rax,%rdi
	call _temp
	movq %rax,%rdi
	call _symbol_to_reg
L444:
	ret 

L149:
 .byte 9,106,109,112,32,0
L19:
 .byte 97,114,103,117,109,101,110,116
 .byte 115,32,109,117,115,116,32,98
 .byte 101,32,110,97,109,101,100,0
L162:
 .byte 9,37,115,32,37,76,10,0
L141:
 .byte 10,37,103,58,10,0
L121:
 .byte 119,101,32,97,108,114,101,97
 .byte 100,121,32,100,105,100,32,116
 .byte 104,105,115,32,102,117,110,99
 .byte 116,105,111,110,32,37,76,0
.globl _current_func
.comm _current_func, 8, 8
.globl _func_chain
.comm _func_chain, 8, 8
.globl _func_ret_sym
.comm _func_ret_sym, 8, 8
.globl _func_ret_type
.comm _func_ret_type, 8, 8
.globl _func_hidden_arg
.comm _func_hidden_arg, 8, 8
.local _frame_size
.comm _frame_size, 4, 4
.local _nr_iargs
.comm _nr_iargs, 4, 4
.local _nr_fargs
.comm _nr_fargs, 4, 4
.local _next_stack_arg
.comm _next_stack_arg, 4, 4

.globl _func_hidden_arg
.globl _mch_switch
.globl _cc_text
.globl _sym_tree
.globl _temp_reg
.globl _all_blocks
.globl _func_chain
.globl _symbol_to_reg
.globl _diff_regs
.globl _new_symbol
.globl _current_func
.globl _con_tree
.globl _error
.globl _sequence_blocks
.globl _opt
.globl _fscratch
.globl _iscratch
.globl _exit_func
.globl _func_ret_type
.globl _path
.globl _temp
.globl _lower
.globl _loadstore
.globl _exit_block
.globl _registerize
.globl _line_no
.globl _blk_tree
.globl _current_block
.globl _get_tnode
.globl _enter_func
.globl _reset_blocks
.globl _entry_block
.globl _out_block
.globl _reg_generation
.globl _dealias
.globl _add_reg
.globl ___flushbuf
.globl _double_type
.globl _out
.globl _all_regs
.globl _out_func
.globl _func_size
.globl _free_symbols
.globl _align_of
.globl _int_type
.globl _walk_scope
.globl _seg
.globl _color
.globl _add_succ
.globl _move
.globl _out_f
.globl _func_ret_sym
.globl _deconst
.globl _new_insn
.globl _append_insn
.globl _func_arena
.globl _lir_switch
.globl _reset_regs
.globl _gen
.globl _out_operand
.globl _reset_reach
.globl _frame_alloc
.globl _ulong_type
.globl _size_of
.globl _insert_insn
