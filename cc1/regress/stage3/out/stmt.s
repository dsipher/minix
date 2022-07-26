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
	jz L59
L57:
	movl %r12d,%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	jnz L54
L59:
	testq $7168,%rcx
	jz L52
L61:
	movl %r12d,%eax
	andl $3221225472,%eax
	cmpl $3221225472,%eax
	jz L52
L54:
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
	movl 4(%r14),%eax
	andl $-17,%eax
	orl $16,%eax
	movl %eax,4(%r14)
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
	andl $-9,%eax
	orl $8,%eax
	movl %eax,4(%r14)
	jmp L88
L81:
	andl $-5,%eax
	orl $4,%eax
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
L89:
	pushq %rbx
L90:
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
	jnz L97
L95:
	movq %rbx,%rsi
	xorl %edi,%edi
	call _asm0
L97:
	cmpl $486539286,_token(%rip)
	jnz L101
L98:
	movq %rbx,%rsi
	movl $1,%edi
	call _asm0
L101:
	movl $13,%edi
	call _expect
	call _lex
	movl $23,%edi
	call _expect
	call _lex
	movq _current_block(%rip),%rsi
	movq %rbx,%rdi
	call _append_insn
L91:
	popq %rbx
	ret 


_case_label:
L107:
	pushq %rbx
	pushq %r12
L110:
	cmpq $0,_control_block(%rip)
	jnz L115
L113:
	movl _token(%rip),%eax
	pushq %rax
	pushq $L116
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L115:
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
L109:
	popq %r12
	popq %rbx
	ret 


_default_label:
L120:
L123:
	cmpq $0,_control_block(%rip)
	jnz L128
L126:
	movl _token(%rip),%eax
	pushq %rax
	pushq $L116
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L128:
	cmpl $0,_saw_default(%rip)
	jz L131
L129:
	pushq $L132
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L131:
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
L122:
	ret 


_do_stmt:
L136:
	pushq %rbx
	pushq %r12
	pushq %r13
L137:
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
L138:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_for_stmt:
L145:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L146:
	movq _continue_block(%rip),%rax
	movq %rax,-8(%rbp)
	movq _break_block(%rip),%r15
	call _new_block
	movq %rax,%r14
	call _new_block
	movq %rax,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	call _new_block
	movq %rax,_continue_block(%rip)
	call _new_block
	movq %rax,_break_block(%rip)
	call _lex
	movl $12,%edi
	call _expect
	call _lex
	cmpl $23,_token(%rip)
	jz L154
L151:
	call _expression
	movq %rax,%rdi
	call _gen
L154:
	movl $23,%edi
	call _expect
	call _lex
	cmpl $23,_token(%rip)
	jz L160
L157:
	call _expression
	movq %rax,%r12
L160:
	movl $23,%edi
	call _expect
	call _lex
	cmpl $13,_token(%rip)
	jz L166
L163:
	call _expression
	movq %rax,%rbx
L166:
	movl $13,%edi
	call _expect
	call _lex
	movq %r14,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq %r14,_current_block(%rip)
	testq %r12,%r12
	jz L170
L169:
	movl $-2147483573,%edx
	movl $426770485,%esi
	movq %r12,%rdi
	call _test
	movq %rax,%rdi
	call _gen
	movq _break_block(%rip),%rdx
	movq %r13,%rsi
	movq %rax,%rdi
	call _branch
	jmp L171
L170:
	movq %r13,%rdx
	movl $12,%esi
	movq %r14,%rdi
	call _add_succ
L171:
	movq %r13,_current_block(%rip)
	call _stmt
	movq _continue_block(%rip),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq _continue_block(%rip),%rax
	movq %rax,_current_block(%rip)
	testq %rbx,%rbx
	jz L174
L172:
	movq %rbx,%rdi
	call _gen
L174:
	movq %r14,%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq _break_block(%rip),%rax
	movq %rax,_current_block(%rip)
	movq -8(%rbp),%rax
	movq %rax,_continue_block(%rip)
	movq %r15,_break_block(%rip)
L147:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_goto_stmt:
L175:
L176:
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
L177:
	ret 


_if_stmt:
L181:
	pushq %rbx
	pushq %r12
	pushq %r13
L182:
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
	jnz L186
L184:
	call _lex
	movq %r12,_current_block(%rip)
	call _stmt
	movq _current_block(%rip),%r12
L186:
	movq %rbx,%rdx
	movl $12,%esi
	movq %r12,%rdi
	call _add_succ
	movq %rbx,_current_block(%rip)
L183:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_return_stmt:
L187:
	pushq %rbx
L188:
	call _lex
	movq _func_ret_type(%rip),%rax
	testq $1,(%rax)
	jnz L192
L190:
	call _expression
	movq %rax,%rbx
	movq _func_ret_type(%rip),%rax
	testq $8192,(%rax)
	jz L195
L196:
	movq 8(%rbx),%rdx
	testq $8192,(%rdx)
	jz L195
L197:
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rbx
L195:
	movq _func_ret_sym(%rip),%rdi
	call _sym_tree
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1048636,%edi
	call _build_tree
	movq %rax,%rdi
	call _gen
L192:
	movq _current_block(%rip),%rdi
	movq _exit_block(%rip),%rdx
	movl $12,%esi
	call _add_succ
	call _new_block
	movq %rax,_current_block(%rip)
	movl $23,%edi
	call _expect
	call _lex
L189:
	popq %rbx
	ret 


_switch_stmt:
L203:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L204:
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
	jnz L214
L212:
	pushq $L215
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L214:
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
	jnz L218
L216:
	movq _default_block(%rip),%rdi
	movq _break_block(%rip),%rdx
	movl $12,%esi
	call _add_succ
L218:
	movq _control_block(%rip),%rdi
	call _trim_switch_block
	movq _break_block(%rip),%rax
	movq %rax,_current_block(%rip)
	movq %r15,_control_block(%rip)
	movq %r13,_break_block(%rip)
	movq %r14,_default_block(%rip)
	movl %r12d,_saw_default(%rip)
L205:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_while_stmt:
L219:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L220:
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
L221:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L293:
	.short L235-_stmt
	.short L232-_stmt
	.short L237-_stmt
	.short L239-_stmt
	.short L232-_stmt
	.short L232-_stmt
	.short L241-_stmt
	.short L243-_stmt
	.short L245-_stmt

_stmt:
L222:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L223:
	movl $_void_tree,%r12d
L226:
	cmpb $0,_g_flag(%rip)
	jz L231
L229:
	xorl %esi,%esi
	movl $58720258,%edi
	call _new_insn
	movq _current_block(%rip),%rsi
	movq %rax,%rdi
	call _append_insn
L231:
	movl _token(%rip),%eax
	cmpl $-2147483587,%eax
	jl L279
L281:
	cmpl $-2147483579,%eax
	jg L279
L278:
	addl $2147483587,%eax
	movzwl L293(,%rax,2),%eax
	addl $_stmt,%eax
	jmp *%rax
L243:
	call _default_label
	jmp L226
L239:
	call _case_label
	jmp L226
L245:
	call _do_stmt
	jmp L233
L241:
	movq _continue_block(%rip),%rdi
	call _control
	jmp L233
L237:
	movq _break_block(%rip),%rdi
	call _control
	jmp L233
L235:
	call _asm_stmt
	jmp L233
L279:
	cmpl $-2147483573,%eax
	jz L247
L283:
	cmpl $-2147483572,%eax
	jz L249
L284:
	cmpl $-2147483571,%eax
	jz L251
L285:
	cmpl $-2147483567,%eax
	jz L253
L286:
	cmpl $-2147483561,%eax
	jz L255
L287:
	cmpl $-2147483555,%eax
	jz L257
L288:
	cmpl $1,%eax
	jnz L289
L261:
	leaq -32(%rbp),%rdi
	call _lookahead
	cmpl $486539286,-32(%rbp)
	jnz L232
L262:
	movq _token+24(%rip),%rdi
	call _lookup_label
	movq %rax,%rbx
	testl $1073741824,12(%rbx)
	jz L269
L265:
	pushq %rbx
	pushq $L268
	pushq _token+24(%rip)
	pushq $4
	call _error
	addq $32,%rsp
L269:
	movq _path(%rip),%rax
	movq %rax,24(%rbx)
	movl _line_no(%rip),%eax
	movl %eax,20(%rbx)
	orl $1073741824,12(%rbx)
	call _lex
	call _lex
	movq 48(%rbx),%rdx
	movl $12,%esi
	movq _current_block(%rip),%rdi
	call _add_succ
	movq 48(%rbx),%rax
	movq %rax,_current_block(%rip)
	jmp L226
L289:
	cmpl $16,%eax
	jz L259
L290:
	cmpl $23,%eax
	jz L274
L232:
	call _expression
	movq %rax,%rdi
	call _gen
	movq %rax,%r12
L274:
	movl $23,%edi
	call _expect
	call _lex
	jmp L233
L259:
	xorl %edi,%edi
	call _enter_scope
	xorl %edi,%edi
	call _compound
	movl $_func_chain,%edi
	call _exit_scope
	jmp L233
L257:
	call _while_stmt
	jmp L233
L255:
	call _switch_stmt
	jmp L233
L253:
	call _return_stmt
	jmp L233
L251:
	call _if_stmt
	jmp L233
L249:
	call _goto_stmt
	jmp L233
L247:
	call _for_stmt
L233:
	movq %r12,_stmt_tree(%rip)
L224:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_compound:
L294:
	pushq %rbx
L295:
	movl %edi,%ebx
	movl $16,%edi
	call _expect
	call _lex
	call _locals
	movq $_void_tree,_stmt_tree(%rip)
L300:
	cmpl $17,_token(%rip)
	jz L302
L301:
	testl %ebx,%ebx
	jz L305
L306:
	movq _stmt_arena(%rip),%rax
	movq %rax,_stmt_arena+8(%rip)
L305:
	call _stmt
	jmp L300
L302:
	testl %ebx,%ebx
	jz L312
L309:
	call _check_labels
L312:
	movl $17,%edi
	call _expect
	call _lex
L296:
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
L215:
 .byte 99,111,110,116,114,111,108,108
 .byte 105,110,103,32,101,120,112,114
 .byte 101,115,115,105,111,110,32,109
 .byte 117,115,116,32,98,101,32,105
 .byte 110,116,101,103,114,97,108,0
L132:
 .byte 100,117,112,108,105,99,97,116
 .byte 101,32,100,101,102,97,117,108
 .byte 116,32,99,97,115,101,0
L116:
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
L268:
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
