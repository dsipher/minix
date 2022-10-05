.text

_condition:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%r13
	movq %rsi,%r12
	movl %edx,%ebx
	movl $12,%edi
	call _expect
	call _lex
	call _expression
	movl %ebx,%edx
	movl $426770485,%esi
	movq %rax,%rdi
	call _test
	movq %rax,%rdi
	call _gen
	movq %r12,%rdx
	movq %r13,%rsi
	movq %rax,%rdi
	call _branch
	movl $13,%edi
	call _expect
	call _lex
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_control:
L10:
	pushq %rbx
L11:
	movq %rdi,%rbx
	testq %rbx,%rbx
	jnz L15
L13:
	movl _token(%rip),%eax
	pushq %rax
	pushq $L16
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L15:
	movq %rbx,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	call _new_block
	movq %rax,_current_block(%rip)
	call _lex
	movl $23,%edi
	call _expect
	call _lex
L12:
	popq %rbx
	ret 


_asm0:
L20:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L21:
	movl %edi,%r15d
	movq %rsi,%r14
	testl %r15d,%r15d
	jz L24
L23:
	leaq 40(%r14),%r13
	jmp L25
L24:
	leaq 16(%r14),%r13
L25:
	call _lex
	cmpl $1,_token(%rip)
	jnz L22
L29:
	movl $1,%edi
	call _expect
	movq _token+24(%rip),%rax
	movl 20(%rax),%eax
	testl $131072,%eax
	jz L34
L33:
	subl $131166,%eax
	movl %eax,%r12d
	shll $14,%r12d
	cmpl $16,%eax
	jge L37
L36:
	orl $2147483648,%r12d
	jmp L38
L37:
	orl $3221225472,%r12d
L38:
	call _lex
	cmpl $1048633,_token(%rip)
	jnz L40
L39:
	call _lex
	movl $1,%edi
	call _expect
	movq _token+24(%rip),%rdi
	movl $1,%ecx
	movl _current_scope(%rip),%edx
	movl $2040,%esi
	call _lookup
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L44
L42:
	pushq $L45
	pushq _token+24(%rip)
	pushq $4
	call _error
	addq $24,%rsp
L44:
	call _lex
	movq 32(%rbx),%rax
	testq $73726,(%rax)
	jnz L48
L46:
	pushq $L49
	pushq (%rbx)
	pushq $4
	call _error
	addq $24,%rsp
L48:
	movq 32(%rbx),%rax
	movq (%rax),%rcx
	testq $66558,%rcx
	jz L53
L57:
	movl %r12d,%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	jnz L50
L53:
	testq $7168,%rcx
	jz L52
L61:
	movl %r12d,%eax
	andl $3221225472,%eax
	cmpl $3221225472,%eax
	jz L52
L50:
	pushq $L65
	pushq (%rbx)
	pushq $4
	call _error
	addq $24,%rsp
L52:
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,%ebx
	jmp L41
L40:
	xorl %ebx,%ebx
	testl %r15d,%r15d
	jnz L41
L66:
	pushq $L69
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L41:
	movl %r12d,%edx
	movl %ebx,%esi
	movq %r13,%rdi
	call _add_regmap
	jmp L35
L34:
	cmpl $127,%eax
	jnz L71
L70:
	testl %r15d,%r15d
	jz L74
L73:
	orl $16,4(%r14)
	jmp L88
L74:
	pushq $L76
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
	jmp L88
L71:
	cmpl $126,%eax
	jnz L78
L77:
	movl 4(%r14),%eax
	testl %r15d,%r15d
	jz L81
L80:
	orl $8,%eax
	jmp L89
L81:
	orl $4,%eax
L89:
	movl %eax,4(%r14)
L88:
	call _lex
	jmp L35
L78:
	pushq $_token
	pushq $L83
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L35:
	cmpl $21,_token(%rip)
	jnz L22
L84:
	call _lex
	jmp L29
L22:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_asm_stmt:
L90:
	pushq %rbx
L91:
	xorl %esi,%esi
	movl $8388609,%edi
	call _new_insn
	movq %rax,%rbx
	call _lex
	movl $12,%edi
	call _expect
	call _lex
	movl $2,%edi
	call _expect
	movq _token+24(%rip),%rax
	movq %rax,8(%rbx)
	call _lex
	cmpl $486539286,_token(%rip)
	jnz L98
L96:
	movq %rbx,%rsi
	xorl %edi,%edi
	call _asm0
L98:
	cmpl $486539286,_token(%rip)
	jnz L102
L99:
	movq %rbx,%rsi
	movl $1,%edi
	call _asm0
L102:
	movl $13,%edi
	call _expect
	call _lex
	movl $23,%edi
	call _expect
	call _lex
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
L92:
	popq %rbx
	ret 


_case_label:
L108:
	pushq %rbx
	pushq %r12
L111:
	cmpq $0,_control_block(%rip)
	jnz L116
L114:
	movl _token(%rip),%eax
	pushq %rax
	pushq $L117
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L116:
	call _lex
	call _case_expr
	movq %rax,%r12
	movl $486539286,%edi
	call _expect
	call _lex
	call _new_block
	movq %rax,%rbx
	movq %rbx,%rdx
	leaq 16(%r12),%rsi
	movq _control_block(%rip),%rdi
	call _add_switch_succ
	movq %rbx,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %rbx,_current_block(%rip)
L110:
	popq %r12
	popq %rbx
	ret 


_default_label:
L121:
L124:
	cmpq $0,_control_block(%rip)
	jnz L129
L127:
	movl _token(%rip),%eax
	pushq %rax
	pushq $L117
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L129:
	cmpl $0,_saw_default(%rip)
	jz L132
L130:
	pushq $L133
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L132:
	call _lex
	movl $486539286,%edi
	call _expect
	call _lex
	movl $1,_saw_default(%rip)
	movq _current_block(%rip),%rdi
	movq _default_block(%rip),%rdx
	movl $12,%esi
	call _add_succ
	movq _default_block(%rip),%rax
	movq %rax,_current_block(%rip)
L123:
	ret 


_do_stmt:
L137:
	pushq %rbx
	pushq %r12
	pushq %r13
L138:
	movq _continue_block(%rip),%r13
	movq _break_block(%rip),%r12
	call _new_block
	movq %rax,%rbx
	call _new_block
	movq %rax,_break_block(%rip)
	call _new_block
	movq %rax,_continue_block(%rip)
	movq %rbx,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %rbx,_current_block(%rip)
	call _lex
	call _stmt
	movq _continue_block(%rip),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq _continue_block(%rip),%rax
	movq %rax,_current_block(%rip)
	movl $-2147483555,%edi
	call _expect
	call _lex
	movl $-2147483555,%edx
	movq _break_block(%rip),%rsi
	movq %rbx,%rdi
	call _condition
	movl $23,%edi
	call _expect
	call _lex
	movq _break_block(%rip),%rax
	movq %rax,_current_block(%rip)
	movq %r13,_continue_block(%rip)
	movq %r12,_break_block(%rip)
L139:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_for_stmt:
L146:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L147:
	movq _continue_block(%rip),%rax
	movq %rax,-8(%rbp)
	movq _break_block(%rip),%rbx
	call _new_block
	movq %rax,%r15
	call _new_block
	movq %rax,%r14
	xorl %r13d,%r13d
	xorl %r12d,%r12d
	call _new_block
	movq %rax,_continue_block(%rip)
	call _new_block
	movq %rax,_break_block(%rip)
	call _lex
	movl $12,%edi
	call _expect
	call _lex
	cmpl $23,_token(%rip)
	jz L155
L152:
	call _expression
	movq %rax,%rdi
	call _gen
L155:
	movl $23,%edi
	call _expect
	call _lex
	cmpl $23,_token(%rip)
	jz L161
L158:
	call _expression
	movq %rax,%r13
L161:
	movl $23,%edi
	call _expect
	call _lex
	cmpl $13,_token(%rip)
	jz L167
L164:
	call _expression
	movq %rax,%r12
L167:
	movl $13,%edi
	call _expect
	call _lex
	movq %r15,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r15,_current_block(%rip)
	testq %r13,%r13
	jz L171
L170:
	movl $-2147483573,%edx
	movl $426770485,%esi
	movq %r13,%rdi
	call _test
	movq %rax,%rdi
	call _gen
	movq _break_block(%rip),%rdx
	movq %r14,%rsi
	movq %rax,%rdi
	call _branch
	jmp L172
L171:
	movq %r14,%rdx
	movl $12,%esi
	movq %r15,%rdi
	call _add_succ
L172:
	movq %r14,_current_block(%rip)
	call _stmt
	movq _continue_block(%rip),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq _continue_block(%rip),%rax
	movq %rax,_current_block(%rip)
	testq %r12,%r12
	jz L175
L173:
	movq %r12,%rdi
	call _gen
L175:
	movq %r15,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq _break_block(%rip),%rax
	movq %rax,_current_block(%rip)
	movq -8(%rbp),%rax
	movq %rax,_continue_block(%rip)
	movq %rbx,_break_block(%rip)
L148:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_goto_stmt:
L176:
L177:
	call _lex
	movl $1,%edi
	call _expect
	movq _token+24(%rip),%rdi
	call _lookup_label
	movq 48(%rax),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	call _new_block
	movq %rax,_current_block(%rip)
	call _lex
	movl $23,%edi
	call _expect
	call _lex
L178:
	ret 


_if_stmt:
L182:
	pushq %rbx
	pushq %r12
	pushq %r13
L183:
	call _new_block
	movq %rax,%r13
	call _new_block
	movq %rax,%r12
	call _new_block
	movq %rax,%rbx
	call _lex
	movl $-2147483571,%edx
	movq %r12,%rsi
	movq %r13,%rdi
	call _condition
	movq %r13,_current_block(%rip)
	call _stmt
	movq %rbx,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	cmpl $2147483719,_token(%rip)
	jnz L187
L185:
	call _lex
	movq %r12,_current_block(%rip)
	call _stmt
	movq _current_block(%rip),%r12
L187:
	movq %rbx,%rdx
	movl $12,%esi
	movq %r12,%rdi
	call _add_succ
	movq %rbx,_current_block(%rip)
L184:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_return_stmt:
L188:
	pushq %rbx
L189:
	call _lex
	movq _func_ret_type(%rip),%rax
	testq $1,(%rax)
	jnz L193
L191:
	call _expression
	movq %rax,%rbx
	movq _func_ret_type(%rip),%rax
	testq $8192,(%rax)
	jz L196
L197:
	movq 8(%rbx),%rdx
	testq $8192,(%rdx)
	jz L196
L198:
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rbx
L196:
	movq _func_ret_sym(%rip),%rdi
	call _sym_tree
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1048636,%edi
	call _build_tree
	movq %rax,%rdi
	call _gen
L193:
	movq _current_block(%rip),%rdi
	movq _exit_block(%rip),%rdx
	movl $12,%esi
	call _add_succ
	call _new_block
	movq %rax,_current_block(%rip)
	movl $23,%edi
	call _expect
	call _lex
L190:
	popq %rbx
	ret 


_switch_stmt:
L204:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L205:
	movq _control_block(%rip),%r15
	movq _default_block(%rip),%r14
	movq _break_block(%rip),%r13
	movl _saw_default(%rip),%r12d
	call _lex
	movl $12,%edi
	call _expect
	call _lex
	call _expression
	movq %rax,%rbx
	movl $13,%edi
	call _expect
	call _lex
	movq 8(%rbx),%rax
	testq $1022,(%rax)
	jnz L215
L213:
	pushq $L216
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L215:
	movq %rbx,%rdi
	call _gen
	movq %rax,%rsi
	leaq -32(%rbp),%rdi
	call _leaf_operand
	movq _current_block(%rip),%rax
	movq %rax,_control_block(%rip)
	movl $0,_saw_default(%rip)
	call _new_block
	movq %rax,_default_block(%rip)
	call _new_block
	movq %rax,_break_block(%rip)
	call _new_block
	movq %rax,%rbx
	movq _default_block(%rip),%rdx
	leaq -32(%rbp),%rsi
	movq _current_block(%rip),%rdi
	call _switch_block
	movq %rbx,_current_block(%rip)
	call _stmt
	movq _break_block(%rip),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	cmpl $0,_saw_default(%rip)
	jnz L219
L217:
	movq _default_block(%rip),%rdi
	movq _break_block(%rip),%rdx
	movl $12,%esi
	call _add_succ
L219:
	movq _control_block(%rip),%rdi
	call _trim_switch_block
	movq _break_block(%rip),%rax
	movq %rax,_current_block(%rip)
	movq %r15,_control_block(%rip)
	movq %r13,_break_block(%rip)
	movq %r14,_default_block(%rip)
	movl %r12d,_saw_default(%rip)
L206:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_while_stmt:
L220:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L221:
	movq _break_block(%rip),%r14
	movq _continue_block(%rip),%r13
	call _new_block
	movq %rax,%r12
	call _new_block
	movq %rax,%rbx
	call _new_block
	movq %rax,_break_block(%rip)
	movq %r12,_continue_block(%rip)
	movq %r12,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r12,_current_block(%rip)
	call _lex
	movl $-2147483555,%edx
	movq _break_block(%rip),%rsi
	movq %rbx,%rdi
	call _condition
	movq %rbx,_current_block(%rip)
	call _stmt
	movq %r12,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq _break_block(%rip),%rax
	movq %rax,_current_block(%rip)
	movq %r13,_continue_block(%rip)
	movq %r14,_break_block(%rip)
L222:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L294:
	.short L236-_stmt
	.short L233-_stmt
	.short L238-_stmt
	.short L240-_stmt
	.short L233-_stmt
	.short L233-_stmt
	.short L242-_stmt
	.short L244-_stmt
	.short L246-_stmt

_stmt:
L223:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L224:
	movl $_void_tree,%ebx
L227:
	cmpb $0,_g_flag(%rip)
	jz L232
L230:
	xorl %esi,%esi
	movl $58720258,%edi
	call _new_insn
	movq _current_block(%rip),%rsi
	movq %rax,%rdi
	call _append_insn
L232:
	movl _token(%rip),%eax
	cmpl $-2147483587,%eax
	jl L280
L282:
	cmpl $-2147483579,%eax
	jg L280
L279:
	addl $2147483587,%eax
	movzwl L294(,%rax,2),%eax
	addl $_stmt,%eax
	jmp *%rax
L244:
	call _default_label
	jmp L227
L240:
	call _case_label
	jmp L227
L246:
	call _do_stmt
	jmp L234
L242:
	movq _continue_block(%rip),%rdi
	jmp L295
L238:
	movq _break_block(%rip),%rdi
L295:
	call _control
	jmp L234
L236:
	call _asm_stmt
	jmp L234
L280:
	cmpl $-2147483573,%eax
	jz L248
L284:
	cmpl $-2147483572,%eax
	jz L250
L285:
	cmpl $-2147483571,%eax
	jz L252
L286:
	cmpl $-2147483567,%eax
	jz L254
L287:
	cmpl $-2147483561,%eax
	jz L256
L288:
	cmpl $-2147483555,%eax
	jz L258
L289:
	cmpl $1,%eax
	jnz L290
L262:
	leaq -32(%rbp),%rdi
	call _lookahead
	cmpl $486539286,-32(%rbp)
	jnz L233
L263:
	movq _token+24(%rip),%rdi
	call _lookup_label
	movq %rax,%r12
	testl $1073741824,12(%r12)
	jz L270
L266:
	pushq %r12
	pushq $L269
	pushq _token+24(%rip)
	pushq $4
	call _error
	addq $32,%rsp
L270:
	movq _path(%rip),%rax
	movq %rax,24(%r12)
	movl _line_no(%rip),%eax
	movl %eax,20(%r12)
	orl $1073741824,12(%r12)
	call _lex
	call _lex
	movq 48(%r12),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq 48(%r12),%rax
	movq %rax,_current_block(%rip)
	jmp L227
L290:
	cmpl $16,%eax
	jz L260
L291:
	cmpl $23,%eax
	jz L275
L233:
	call _expression
	movq %rax,%rdi
	call _gen
	movq %rax,%rbx
L275:
	movl $23,%edi
	call _expect
	call _lex
	jmp L234
L260:
	xorl %edi,%edi
	call _enter_scope
	xorl %edi,%edi
	call _compound
	movl $_func_chain,%edi
	call _exit_scope
	jmp L234
L258:
	call _while_stmt
	jmp L234
L256:
	call _switch_stmt
	jmp L234
L254:
	call _return_stmt
	jmp L234
L252:
	call _if_stmt
	jmp L234
L250:
	call _goto_stmt
	jmp L234
L248:
	call _for_stmt
L234:
	movq %rbx,_stmt_tree(%rip)
L225:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_compound:
L296:
	pushq %rbx
L297:
	movl %edi,%ebx
	movl $16,%edi
	call _expect
	call _lex
	call _locals
	movq $_void_tree,_stmt_tree(%rip)
	jmp L302
L303:
	testl %ebx,%ebx
	jz L307
L308:
	movq _stmt_arena(%rip),%rax
	movq %rax,_stmt_arena+8(%rip)
L307:
	call _stmt
L302:
	cmpl $17,_token(%rip)
	jnz L303
L304:
	testl %ebx,%ebx
	jz L314
L311:
	call _check_labels
L314:
	movl $17,%edi
	call _expect
	call _lex
L298:
	popq %rbx
	ret 

L16:
	.byte 109,105,115,112,108,97,99,101
	.byte 100,32,37,107,32,115,116,97
	.byte 116,101,109,101,110,116,0
L76:
	.byte 98,111,103,117,115,32,37,37
	.byte 99,99,32,100,101,112,101,110
	.byte 100,101,110,99,121,0
L216:
	.byte 99,111,110,116,114,111,108,108
	.byte 105,110,103,32,101,120,112,114
	.byte 101,115,115,105,111,110,32,109
	.byte 117,115,116,32,98,101,32,105
	.byte 110,116,101,103,114,97,108,0
L133:
	.byte 100,117,112,108,105,99,97,116
	.byte 101,32,100,101,102,97,117,108
	.byte 116,32,99,97,115,101,0
L117:
	.byte 109,105,115,112,108,97,99,101
	.byte 100,32,37,107,32,40,110,111
	.byte 116,32,105,110,32,115,119,105
	.byte 116,99,104,41,0
L83:
	.byte 101,120,112,101,99,116,101,100
	.byte 32,114,101,103,105,115,116,101
	.byte 114,32,40,103,111,116,32,37
	.byte 75,41,0
L65:
	.byte 105,110,118,97,108,105,100,32
	.byte 114,101,103,105,115,116,101,114
	.byte 32,99,108,97,115,115,0
L269:
	.byte 100,117,112,108,105,99,97,116
	.byte 101,32,108,97,98,101,108,32
	.byte 37,76,0
L69:
	.byte 98,111,103,117,115,32,114,101
	.byte 103,105,115,116,101,114,32,100
	.byte 101,112,101,110,100,101,110,99
	.byte 121,0
L45:
	.byte 117,110,107,110,111,119,110,32
	.byte 118,97,114,105,97,98,108,101
	.byte 0
L49:
	.byte 109,117,115,116,32,98,101,32
	.byte 97,32,115,99,97,108,97,114
	.byte 0
.globl _stmt_tree
.comm _stmt_tree, 8, 8
.local _break_block
.comm _break_block, 8, 8
.local _continue_block
.comm _continue_block, 8, 8
.local _control_block
.comm _control_block, 8, 8
.local _default_block
.comm _default_block, 8, 8
.local _saw_default
.comm _saw_default, 4, 4

.globl _test
.globl _stmt_arena
.globl _add_switch_succ
.globl _sym_tree
.globl _new_block
.globl _lookahead
.globl _lex
.globl _unary_tree
.globl _symbol_to_reg
.globl _func_chain
.globl _enter_scope
.globl _error
.globl _expect
.globl _build_tree
.globl _func_ret_type
.globl _leaf_operand
.globl _path
.globl _check_labels
.globl _locals
.globl _exit_block
.globl _lookup_label
.globl _line_no
.globl _current_block
.globl _get_tnode
.globl _add_regmap
.globl _g_flag
.globl _trim_switch_block
.globl _branch
.globl _stmt_tree
.globl _add_succ
.globl _new_insn
.globl _func_ret_sym
.globl _append_insn
.globl _switch_block
.globl _expression
.globl _lookup
.globl _case_expr
.globl _gen
.globl _void_tree
.globl _current_scope
.globl _compound
.globl _exit_scope
.globl _token
