.text

_output_prefix:
L1:
L2:
	movq _symbol_prefix(%rip),%rcx
	testq %rcx,%rcx
	jnz L5
L4:
	movq $L7,_symbol_prefix(%rip)
	jmp L6
L5:
	incl _outline(%rip)
	pushq %rcx
	pushq $L8
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L9
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L10
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L11
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L12
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L13
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L14
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L15
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L16
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L17
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L18
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L19
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L20
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L21
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L22
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L23
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L24
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L25
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L26
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L27
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L28
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L29
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L30
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L31
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
L6:
	incl _outline(%rip)
	pushq _symbol_prefix(%rip)
	pushq $L32
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
L3:
	ret 


_output_rule_data:
L33:
	pushq %rbx
	pushq %r12
	pushq %r13
L34:
	movslq _start_symbol(%rip),%rcx
	movq _symbol_value(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L36
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $3,%ebx
L37:
	cmpl _nrules(%rip),%ebx
	jge L40
L38:
	cmpl $10,%r12d
	jl L42
L41:
	cmpb $0,_rflag(%rip)
	jnz L46
L44:
	incl _outline(%rip)
L46:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L48
L47:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L49
L48:
	movl $10,%edi
	call ___flushbuf
L49:
	movl $1,%r12d
	jmp L43
L42:
	incl %r12d
L43:
	movslq %ebx,%rcx
	movq _rlhs(%rip),%rax
	movswq (%rax,%rcx,2),%rax
	movq _symbol_value(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
	jmp L37
L40:
	cmpb $0,_rflag(%rip)
	jnz L53
L51:
	addl $2,_outline(%rip)
L53:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	pushq $2
	pushq _symbol_prefix(%rip)
	pushq $L55
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $3,%r13d
L56:
	cmpl _nrules(%rip),%r13d
	jge L59
L57:
	cmpl $10,%r12d
	jl L61
L60:
	cmpb $0,_rflag(%rip)
	jnz L65
L63:
	incl _outline(%rip)
L65:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L67
L66:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L68
L67:
	movl $10,%edi
	call ___flushbuf
L68:
	movl $1,%r12d
	jmp L62
L61:
	incl %r12d
L62:
	leal 1(%r13),%ebx
	movslq %ebx,%rax
	movq _rrhs(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	movslq %r13d,%r13
	movswl (%rcx,%r13,2),%ecx
	subl %ecx,%eax
	decl %eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl %ebx,%r13d
	jmp L56
L59:
	cmpb $0,_rflag(%rip)
	jnz L71
L69:
	addl $2,_outline(%rip)
L71:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
L35:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_output_yydefred:
L72:
	pushq %rbx
	pushq %r12
L73:
	movq _defred(%rip),%rax
	movw (%rax),%ax
	testw %ax,%ax
	jz L77
L76:
	movswl %ax,%eax
	subl $2,%eax
	jmp L78
L77:
	xorl %eax,%eax
L78:
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L75
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $1,%ebx
L79:
	cmpl _nstates(%rip),%ebx
	jge L82
L80:
	cmpl $10,%r12d
	jge L84
L83:
	incl %r12d
	jmp L85
L84:
	cmpb $0,_rflag(%rip)
	jnz L88
L86:
	incl _outline(%rip)
L88:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L90
L89:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L91
L90:
	movl $10,%edi
	call ___flushbuf
L91:
	movl $1,%r12d
L85:
	movslq %ebx,%rax
	movq _defred(%rip),%rcx
	movw (%rcx,%rax,2),%ax
	testw %ax,%ax
	jz L93
L92:
	movswl %ax,%eax
	subl $2,%eax
	jmp L94
L93:
	xorl %eax,%eax
L94:
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
	jmp L79
L82:
	cmpb $0,_rflag(%rip)
	jnz L97
L95:
	addl $2,_outline(%rip)
L97:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
L74:
	popq %r12
	popq %rbx
	ret 


_token_actions:
L98:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L99:
	movl _ntokens(%rip),%edi
	shll $2,%edi
	call _allocate
	movq %rax,%r15
	xorl %r14d,%r14d
L101:
	cmpl _nstates(%rip),%r14d
	jge L104
L102:
	movslq %r14d,%rcx
	movq _parser(%rip),%rax
	cmpq $0,(%rax,%rcx,8)
	jz L107
L105:
	xorl %ecx,%ecx
L108:
	movl _ntokens(%rip),%eax
	shll $1,%eax
	cmpl %eax,%ecx
	jge L111
L109:
	movslq %ecx,%rax
	movw $0,(%r15,%rax,2)
	incl %ecx
	jmp L108
L111:
	xorl %r13d,%r13d
	xorl %ebx,%ebx
	movslq %r14d,%rax
	movq _parser(%rip),%rcx
	movq (%rcx,%rax,8),%rsi
L112:
	testq %rsi,%rsi
	jz L115
L113:
	cmpb $0,16(%rsi)
	jnz L118
L116:
	movb 14(%rsi),%al
	cmpb $1,%al
	jnz L120
L119:
	incl %r13d
	movw 10(%rsi),%cx
	movswq 8(%rsi),%rax
	movw %cx,(%r15,%rax,2)
	jmp L118
L120:
	cmpb $2,%al
	jnz L118
L125:
	movw 10(%rsi),%dx
	movslq %r14d,%rcx
	movq _defred(%rip),%rax
	cmpw (%rax,%rcx,2),%dx
	jz L118
L122:
	incl %ebx
	movswl 8(%rsi),%eax
	addl _ntokens(%rip),%eax
	movslq %eax,%rax
	movw %dx,(%r15,%rax,2)
L118:
	movq (%rsi),%rsi
	jmp L112
L115:
	movslq %r14d,%rax
	movq %rax,-8(%rbp)
	movq _tally(%rip),%rcx
	movq -8(%rbp),%rax
	movw %r13w,(%rcx,%rax,2)
	movl _nstates(%rip),%eax
	addl %r14d,%eax
	movslq %eax,%rax
	movq _tally(%rip),%rcx
	movw %bx,(%rcx,%rax,2)
	movq _width(%rip),%rcx
	movq -8(%rbp),%rax
	movw $0,(%rcx,%rax,2)
	movl _nstates(%rip),%eax
	addl %r14d,%eax
	movslq %eax,%rax
	movq _width(%rip),%rcx
	movw $0,(%rcx,%rax,2)
	cmpl $0,%r13d
	jle L131
L129:
	shll $1,%r13d
	movq %r13,%rdi
	call _allocate
	movq %rax,%r12
	movq _froms(%rip),%rdx
	movq -8(%rbp),%rcx
	movq %rax,(%rdx,%rcx,8)
	movq %r13,%rdi
	call _allocate
	movq _tos(%rip),%rdx
	movq -8(%rbp),%rcx
	movq %rax,(%rdx,%rcx,8)
	movl $32767,%r8d
	xorl %edi,%edi
	xorl %r9d,%r9d
L132:
	cmpl %r9d,_ntokens(%rip)
	jle L135
L133:
	movslq %r9d,%rsi
	cmpw $0,(%r15,%rsi,2)
	jz L138
L136:
	movq _symbol_value(%rip),%rcx
	movw (%rcx,%rsi,2),%dx
	movswl %dx,%ecx
	cmpl %ecx,%r8d
	cmovgl %ecx,%r8d
	cmpl %ecx,%edi
	cmovll %ecx,%edi
	movw %dx,(%r12)
	addq $2,%r12
	movw (%r15,%rsi,2),%cx
	movw %cx,(%rax)
	addq $2,%rax
L138:
	incl %r9d
	jmp L132
L135:
	subw %r8w,%di
	incw %di
	movslq %r14d,%rax
	movq _width(%rip),%rcx
	movw %di,(%rcx,%rax,2)
L131:
	cmpl $0,%ebx
	jle L107
L145:
	shll $1,%ebx
	movq %rbx,%rdi
	call _allocate
	movl _nstates(%rip),%ecx
	movq %rax,%r12
	addl %r14d,%ecx
	movslq %ecx,%rcx
	movq _froms(%rip),%rdx
	movq %rax,(%rdx,%rcx,8)
	movq %rbx,%rdi
	call _allocate
	movl _nstates(%rip),%ecx
	addl %r14d,%ecx
	movslq %ecx,%rcx
	movq _tos(%rip),%rdx
	movq %rax,(%rdx,%rcx,8)
	movl $32767,%edx
	xorl %ecx,%ecx
	xorl %esi,%esi
L148:
	movl _ntokens(%rip),%edi
	cmpl %esi,%edi
	jle L151
L149:
	addl %esi,%edi
	movslq %edi,%rdi
	cmpw $0,(%r15,%rdi,2)
	jz L154
L152:
	movslq %esi,%rdi
	movq _symbol_value(%rip),%r8
	movw (%r8,%rdi,2),%r8w
	movswl %r8w,%edi
	cmpl %edi,%edx
	cmovgl %edi,%edx
	cmpl %edi,%ecx
	cmovll %edi,%ecx
	movw %r8w,(%r12)
	movl _ntokens(%rip),%edi
	addq $2,%r12
	addl %esi,%edi
	movslq %edi,%rdi
	movw (%r15,%rdi,2),%di
	subw $2,%di
	movw %di,(%rax)
	addq $2,%rax
L154:
	incl %esi
	jmp L148
L151:
	movl _nstates(%rip),%eax
	subw %dx,%cx
	incw %cx
	addl %r14d,%eax
	movslq %eax,%rax
	movq _width(%rip),%rdx
	movw %cx,(%rdx,%rax,2)
L107:
	incl %r14d
	jmp L101
L104:
	movq %r15,%rdi
	call _free
L100:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_default_goto:
L161:
L162:
	movslq %edi,%rcx
	movq _goto_map(%rip),%rax
	movswl (%rax,%rcx,2),%esi
	incl %edi
	movslq %edi,%rdi
	movswl (%rax,%rdi,2),%edi
	xorl %eax,%eax
	cmpl %edi,%esi
	jz L163
L168:
	cmpl _nstates(%rip),%eax
	jl L169
L172:
	cmpl %esi,%edi
	jle L175
L173:
	movslq %esi,%rcx
	movq _to_state(%rip),%rax
	movswq (%rax,%rcx,2),%rcx
	movq _state_count(%rip),%rdx
	incw (%rdx,%rcx,2)
	incl %esi
	jmp L172
L175:
	xorl %edx,%edx
	xorl %eax,%eax
	xorl %edi,%edi
L176:
	cmpl _nstates(%rip),%edi
	jge L163
L177:
	movslq %edi,%rcx
	movq _state_count(%rip),%rsi
	movswl (%rsi,%rcx,2),%ecx
	cmpl %ecx,%edx
	jge L182
L180:
	movl %ecx,%edx
	movl %edi,%eax
L182:
	incl %edi
	jmp L176
L169:
	movslq %eax,%rdx
	movq _state_count(%rip),%rcx
	movw $0,(%rcx,%rdx,2)
	incl %eax
	jmp L168
L163:
	ret 


_save_column:
L184:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L185:
	movl %esi,-4(%rbp)
	movslq %edi,%rax
	movq _goto_map(%rip),%rcx
	movswl (%rcx,%rax,2),%r14d
	leal 1(%rdi),%eax
	movslq %eax,%rax
	movswl (%rcx,%rax,2),%eax
	movl %eax,-20(%rbp)
	xorl %r15d,%r15d
	movl %r14d,%edx
L187:
	cmpl %edx,-20(%rbp)
	jle L190
L188:
	movslq %edx,%rcx
	movq _to_state(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	cmpl %eax,-4(%rbp)
	jz L193
L191:
	incl %r15d
L193:
	incl %edx
	jmp L187
L190:
	testl %r15d,%r15d
	jz L186
L196:
	movslq %edi,%rdi
	movq _symbol_value(%rip),%rax
	movswl (%rax,%rdi,2),%ecx
	movl _nstates(%rip),%eax
	leal (%rcx,%rax,2),%ebx
	movl %r15d,%r13d
	shll $1,%r13d
	movq %r13,%rdi
	call _allocate
	movq %rax,%r12
	movq %rax,-16(%rbp)
	movslq %ebx,%rax
	movq %rax,-32(%rbp)
	movq _froms(%rip),%rdx
	movq -16(%rbp),%rcx
	movq -32(%rbp),%rax
	movq %rcx,(%rdx,%rax,8)
	movq %r13,%rdi
	call _allocate
	movq _tos(%rip),%rdx
	movq -32(%rbp),%rcx
	movq %rax,(%rdx,%rcx,8)
L198:
	cmpl %r14d,-20(%rbp)
	jle L201
L199:
	movslq %r14d,%rdx
	movq _to_state(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,-4(%rbp)
	jz L204
L202:
	movq _from_state(%rip),%rcx
	movw (%rcx,%rdx,2),%cx
	movw %cx,(%r12)
	addq $2,%r12
	movq _to_state(%rip),%rcx
	movw (%rcx,%rdx,2),%cx
	movw %cx,(%rax)
	addq $2,%rax
L204:
	incl %r14d
	jmp L198
L201:
	movslq %ebx,%rbx
	movq _tally(%rip),%rax
	movw %r15w,(%rax,%rbx,2)
	movw -2(%r12),%cx
	movq -16(%rbp),%rax
	subw (%rax),%cx
	incw %cx
	movq _width(%rip),%rax
	movw %cx,(%rax,%rbx,2)
L186:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_goto_actions:
L205:
	pushq %rbx
	pushq %r12
	pushq %r13
L206:
	movl _nstates(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_state_count(%rip)
	movl _start_symbol(%rip),%edi
	incl %edi
	call _default_goto
	movl %eax,%ebx
	pushq %rbx
	pushq _symbol_prefix(%rip)
	pushq $L208
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl _start_symbol(%rip),%edi
	movl %ebx,%esi
	incl %edi
	call _save_column
	movl _start_symbol(%rip),%ebx
	movl $10,%r13d
	addl $2,%ebx
L209:
	cmpl _nsyms(%rip),%ebx
	jge L212
L210:
	cmpl $10,%r13d
	jl L214
L213:
	cmpb $0,_rflag(%rip)
	jnz L218
L216:
	incl _outline(%rip)
L218:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L220
L219:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L221
L220:
	movl $10,%edi
	call ___flushbuf
L221:
	movl $1,%r13d
	jmp L215
L214:
	incl %r13d
L215:
	movl %ebx,%edi
	call _default_goto
	movl %eax,%r12d
	pushq %r12
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl %r12d,%esi
	movl %ebx,%edi
	call _save_column
	incl %ebx
	jmp L209
L212:
	cmpb $0,_rflag(%rip)
	jnz L224
L222:
	addl $2,_outline(%rip)
L224:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _state_count(%rip),%rdi
	call _free
L207:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_sort_actions:
L225:
L226:
	movl _nvectors(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_order(%rip)
	movl $0,_nentries(%rip)
	xorl %eax,%eax
L228:
	cmpl %eax,_nvectors(%rip)
	jle L227
L229:
	movslq %eax,%rdx
	movq _tally(%rip),%rcx
	movw (%rcx,%rdx,2),%r8w
	cmpw $0,%r8w
	jle L234
L232:
	movswl %r8w,%r8d
	movq _width(%rip),%rcx
	movswl (%rcx,%rdx,2),%edi
	movl _nentries(%rip),%edx
	decl %edx
L235:
	cmpl $0,%edx
	jl L242
L238:
	movslq %edx,%rcx
	movq _order(%rip),%rsi
	movswq (%rsi,%rcx,2),%rcx
	movq _width(%rip),%rsi
	movswl (%rsi,%rcx,2),%ecx
	cmpl %ecx,%edi
	jg L239
L242:
	cmpl $0,%edx
	jl L247
L249:
	movslq %edx,%rcx
	movq _order(%rip),%rsi
	movswq (%rsi,%rcx,2),%rsi
	movq _width(%rip),%rcx
	movswl (%rcx,%rsi,2),%ecx
	cmpl %ecx,%edi
	jnz L247
L250:
	movq _tally(%rip),%rcx
	movswl (%rcx,%rsi,2),%ecx
	cmpl %ecx,%r8d
	jle L247
L246:
	decl %edx
	jmp L242
L247:
	movl _nentries(%rip),%r8d
	decl %r8d
L253:
	movq _order(%rip),%rcx
	cmpl %r8d,%edx
	jge L256
L254:
	movslq %r8d,%rsi
	movw (%rcx,%rsi,2),%di
	leal 1(%r8),%esi
	movslq %esi,%rsi
	movw %di,(%rcx,%rsi,2)
	decl %r8d
	jmp L253
L256:
	incl %edx
	movslq %edx,%rdx
	movw %ax,(%rcx,%rdx,2)
	incl _nentries(%rip)
L234:
	incl %eax
	jmp L228
L239:
	decl %edx
	jmp L235
L227:
	ret 


_matching_vector:
L257:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L258:
	movslq %edi,%rcx
	movq _order(%rip),%rax
	movswl (%rax,%rcx,2),%r11d
	movl _nstates(%rip),%eax
	shll $1,%eax
	cmpl %eax,%r11d
	jge L296
L262:
	movslq %r11d,%rcx
	movq _tally(%rip),%rax
	movswl (%rax,%rcx,2),%r10d
	movq _width(%rip),%rax
	movswl (%rax,%rcx,2),%r9d
	decl %edi
L264:
	cmpl $0,%edi
	jl L296
L265:
	movslq %edi,%rax
	movq _order(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	movslq %eax,%rdx
	movq _width(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,%r9d
	jnz L296
L271:
	movq _tally(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,%r10d
	jnz L296
L270:
	movl $1,%r8d
	xorl %esi,%esi
L280:
	cmpl %esi,%r10d
	jle L279
L277:
	movslq %eax,%rdx
	movq _tos(%rip),%r14
	movq (%r14,%rdx,8),%rbx
	movslq %esi,%rcx
	movw (%rbx,%rcx,2),%r12w
	movslq %r11d,%r13
	movq (%r14,%r13,8),%rbx
	cmpw (%rbx,%rcx,2),%r12w
	jnz L284
L287:
	movq _froms(%rip),%r12
	movq (%r12,%rdx,8),%rdx
	movw (%rdx,%rcx,2),%bx
	movq (%r12,%r13,8),%rdx
	cmpw (%rdx,%rcx,2),%bx
	jz L286
L284:
	xorl %r8d,%r8d
L286:
	incl %esi
	testl %r8d,%r8d
	jnz L280
L279:
	testl %r8d,%r8d
	jnz L259
L293:
	decl %edi
	jmp L264
L296:
	movl $-1,%eax
L259:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_pack_vector:
L297:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L298:
	movslq %edi,%rax
	movq %rax,-40(%rbp)
	movl %edi,-12(%rbp)
	movq _order(%rip),%rcx
	movq -40(%rbp),%rax
	movswl (%rcx,%rax,2),%eax
	movslq %eax,%rax
	movq %rax,-32(%rbp)
	movq _tally(%rip),%rcx
	movq -32(%rbp),%rax
	movswl (%rcx,%rax,2),%eax
	testl %eax,%eax
	movl %eax,-16(%rbp)
	jnz L302
L300:
	movl $472,%edx
	movl $L304,%esi
	movl $L303,%edi
	call ___assert
L302:
	movq _froms(%rip),%rcx
	movq -32(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-24(%rbp)
	movq _tos(%rip),%rcx
	movq -32(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-8(%rbp)
	movq -24(%rbp),%rax
	movswl (%rax),%ecx
	movl _lowzero(%rip),%eax
	subl %ecx,%eax
	movl %eax,-44(%rbp)
	movl $1,%edx
L305:
	cmpl %edx,-16(%rbp)
	jg L306
L312:
	cmpl $0,-44(%rbp)
	jz L314
L318:
	movl $1,%r14d
	xorl %r15d,%r15d
L324:
	cmpl %r15d,-16(%rbp)
	jle L323
L321:
	movslq %r15d,%rcx
	movq -24(%rbp),%rax
	movswl (%rax,%rcx,2),%ebx
	addl -44(%rbp),%ebx
	cmpl _maxtable(%rip),%ebx
	jl L330
L328:
	cmpl $32500,%ebx
	jl L333
L331:
	movl $L334,%edi
	call _fatal
L333:
	movl _maxtable(%rip),%r13d
L335:
	addl $200,%r13d
	cmpl %r13d,%ebx
	jge L335
L336:
	movl %r13d,%r12d
	shll $1,%r12d
	movq %r12,%rsi
	movq _table(%rip),%rdi
	call _realloc
	movq %rax,_table(%rip)
	testq %rax,%rax
	jnz L340
L338:
	call _no_space
L340:
	movq %r12,%rsi
	movq _check(%rip),%rdi
	call _realloc
	movq %rax,_check(%rip)
	testq %rax,%rax
	jnz L343
L341:
	call _no_space
L343:
	movl _maxtable(%rip),%ecx
L344:
	cmpl %ecx,%r13d
	jle L347
L345:
	movslq %ecx,%rax
	movq _table(%rip),%rdx
	movw $0,(%rdx,%rax,2)
	movq _check(%rip),%rdx
	movw $-1,(%rdx,%rax,2)
	incl %ecx
	jmp L344
L347:
	movl %r13d,_maxtable(%rip)
L330:
	movslq %ebx,%rbx
	movq _check(%rip),%rax
	cmpw $-1,(%rax,%rbx,2)
	movl $0,%eax
	cmovnzl %eax,%r14d
	incl %r15d
	testl %r14d,%r14d
	jnz L324
L323:
	xorl %edx,%edx
L351:
	testl %r14d,%r14d
	jz L354
L355:
	cmpl %edx,-12(%rbp)
	jle L354
L352:
	movslq %edx,%rcx
	movq _pos(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	cmpl %eax,-44(%rbp)
	movl $0,%eax
	cmovzl %eax,%r14d
	incl %edx
	jmp L351
L354:
	testl %r14d,%r14d
	jnz L362
L314:
	incl -44(%rbp)
	jmp L312
L362:
	xorl %r8d,%r8d
L365:
	cmpl %r8d,-16(%rbp)
	jg L366
L372:
	movl _lowzero(%rip),%edx
	movslq %edx,%rax
	movq _check(%rip),%rcx
	cmpw $-1,(%rcx,%rax,2)
	jz L374
L373:
	incl %edx
	movl %edx,_lowzero(%rip)
	jmp L372
L374:
	movl -44(%rbp),%eax
L299:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L366:
	movslq %r8d,%rsi
	movq -24(%rbp),%rax
	movswl (%rax,%rsi,2),%edx
	addl -44(%rbp),%edx
	movq -8(%rbp),%rax
	movw (%rax,%rsi,2),%ax
	movslq %edx,%rcx
	movq _table(%rip),%rdi
	movw %ax,(%rdi,%rcx,2)
	movq -24(%rbp),%rax
	movw (%rax,%rsi,2),%ax
	movq _check(%rip),%rsi
	movw %ax,(%rsi,%rcx,2)
	cmpl _high(%rip),%edx
	jle L371
L369:
	movl %edx,_high(%rip)
L371:
	incl %r8d
	jmp L365
L306:
	movslq %edx,%rcx
	movq -24(%rbp),%rax
	movswl (%rax,%rcx,2),%eax
	movl _lowzero(%rip),%ecx
	subl %eax,%ecx
	movl -44(%rbp),%eax
	cmpl %ecx,%eax
	cmovll %ecx,%eax
	movl %eax,-44(%rbp)
	incl %edx
	jmp L305


_pack_table:
L376:
	pushq %rbx
	pushq %r12
L377:
	movl _nvectors(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_base(%rip)
	movl _nentries(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_pos(%rip)
	movl $1000,_maxtable(%rip)
	movl $2000,%edi
	call _allocate
	movq %rax,_table(%rip)
	movl _maxtable(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_check(%rip)
	movl $0,_lowzero(%rip)
	movl $0,_high(%rip)
	xorl %ecx,%ecx
L379:
	cmpl %ecx,_maxtable(%rip)
	jle L382
L380:
	movslq %ecx,%rax
	movq _check(%rip),%rdx
	movw $-1,(%rdx,%rax,2)
	incl %ecx
	jmp L379
L382:
	xorl %ebx,%ebx
L383:
	cmpl %ebx,_nentries(%rip)
	jle L386
L384:
	movl %ebx,%edi
	call _matching_vector
	cmpl $0,%eax
	jge L388
L387:
	movl %ebx,%edi
	call _pack_vector
	jmp L389
L388:
	movslq %eax,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
L389:
	movslq %ebx,%rdx
	movq _pos(%rip),%rcx
	movw %ax,(%rcx,%rdx,2)
	movq _order(%rip),%rcx
	movswq (%rcx,%rdx,2),%rcx
	movq _base(%rip),%rdx
	movw %ax,(%rdx,%rcx,2)
	incl %ebx
	jmp L383
L386:
	xorl %r12d,%r12d
L390:
	movl _nvectors(%rip),%eax
	movq _froms(%rip),%rdi
	cmpl %r12d,%eax
	jle L393
L391:
	movslq %r12d,%rbx
	movq (%rdi,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L396
L394:
	call _free
L396:
	movq _tos(%rip),%rax
	movq (%rax,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L399
L397:
	call _free
L399:
	incl %r12d
	jmp L390
L393:
	call _free
	movq _tos(%rip),%rdi
	call _free
	movq _pos(%rip),%rdi
	call _free
L378:
	popq %r12
	popq %rbx
	ret 


_output_base:
L400:
	pushq %rbx
	pushq %r12
L401:
	movq _base(%rip),%rax
	movswl (%rax),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L403
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $1,%ebx
L404:
	movl _nstates(%rip),%eax
	cmpl %eax,%ebx
	jge L407
L405:
	cmpl $10,%r12d
	jl L409
L408:
	cmpb $0,_rflag(%rip)
	jnz L413
L411:
	incl _outline(%rip)
L413:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L415
L414:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L416
L415:
	movl $10,%edi
	call ___flushbuf
L416:
	movl $1,%r12d
	jmp L410
L409:
	incl %r12d
L410:
	movslq %ebx,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
	jmp L404
L407:
	cmpb $0,_rflag(%rip)
	jnz L419
L417:
	addl $2,_outline(%rip)
L419:
	movslq %eax,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L420
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl _nstates(%rip),%ebx
	movl $10,%r12d
L454:
	incl %ebx
	movl _nstates(%rip),%eax
	shll $1,%eax
	cmpl %eax,%ebx
	jge L424
L422:
	cmpl $10,%r12d
	jl L426
L425:
	cmpb $0,_rflag(%rip)
	jnz L430
L428:
	incl _outline(%rip)
L430:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L432
L431:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L433
L432:
	movl $10,%edi
	call ___flushbuf
L433:
	movl $1,%r12d
	jmp L427
L426:
	incl %r12d
L427:
	movslq %ebx,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	jmp L454
L424:
	cmpb $0,_rflag(%rip)
	jnz L436
L434:
	addl $2,_outline(%rip)
L436:
	movslq %eax,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L437
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl _nstates(%rip),%eax
	movl $10,%r12d
	leal 1(,%rax,2),%ebx
L438:
	movl _nvectors(%rip),%eax
	decl %eax
	cmpl %eax,%ebx
	jge L441
L439:
	cmpl $10,%r12d
	jl L443
L442:
	cmpb $0,_rflag(%rip)
	jnz L447
L445:
	incl _outline(%rip)
L447:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L449
L448:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L450
L449:
	movl $10,%edi
	call ___flushbuf
L450:
	movl $1,%r12d
	jmp L444
L443:
	incl %r12d
L444:
	movslq %ebx,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
	jmp L438
L441:
	cmpb $0,_rflag(%rip)
	jnz L453
L451:
	addl $2,_outline(%rip)
L453:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _base(%rip),%rdi
	call _free
L402:
	popq %r12
	popq %rbx
	ret 


_output_table:
L455:
	pushq %rbx
	pushq %r12
L456:
	incl _outline(%rip)
	movq _code_file(%rip),%rcx
	movl _high(%rip),%eax
	pushq %rax
	pushq $L458
	pushq %rcx
	call _fprintf
	addq $24,%rsp
	movq _table(%rip),%rax
	movswl (%rax),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L459
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $1,%ebx
L460:
	cmpl %ebx,_high(%rip)
	jl L463
L461:
	cmpl $10,%r12d
	jl L465
L464:
	cmpb $0,_rflag(%rip)
	jnz L469
L467:
	incl _outline(%rip)
L469:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L471
L470:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L472
L471:
	movl $10,%edi
	call ___flushbuf
L472:
	movl $1,%r12d
	jmp L466
L465:
	incl %r12d
L466:
	movslq %ebx,%rax
	movq _table(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
	jmp L460
L463:
	cmpb $0,_rflag(%rip)
	jnz L475
L473:
	addl $2,_outline(%rip)
L475:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _table(%rip),%rdi
	call _free
L457:
	popq %r12
	popq %rbx
	ret 


_output_check:
L476:
	pushq %rbx
	pushq %r12
L477:
	movq _check(%rip),%rax
	movswl (%rax),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L479
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $1,%ebx
L480:
	cmpl _high(%rip),%ebx
	jg L483
L481:
	cmpl $10,%r12d
	jl L485
L484:
	cmpb $0,_rflag(%rip)
	jnz L489
L487:
	incl _outline(%rip)
L489:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L491
L490:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L492
L491:
	movl $10,%edi
	call ___flushbuf
L492:
	movl $1,%r12d
	jmp L486
L485:
	incl %r12d
L486:
	movslq %ebx,%rax
	movq _check(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
	jmp L480
L483:
	cmpb $0,_rflag(%rip)
	jnz L495
L493:
	addl $2,_outline(%rip)
L495:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _check(%rip),%rdi
	call _free
L478:
	popq %r12
	popq %rbx
	ret 


_output_actions:
L496:
L497:
	movl _nstates(%rip),%ecx
	movl _nvars(%rip),%eax
	leal (%rax,%rcx,2),%edi
	movl %edi,_nvectors(%rip)
	shll $3,%edi
	call _allocate
	movq %rax,_froms(%rip)
	movl _nvectors(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_tos(%rip)
	movl _nvectors(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_tally(%rip)
	movl _nvectors(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_width(%rip)
	call _token_actions
	movq _lookaheads(%rip),%rdi
	call _free
	movq _LA(%rip),%rdi
	call _free
	movq _LAruleno(%rip),%rdi
	call _free
	movq _accessing_symbol(%rip),%rdi
	call _free
	call _goto_actions
	movslq _ntokens(%rip),%rcx
	movq _goto_map(%rip),%rax
	leaq (%rax,%rcx,2),%rdi
	call _free
	movq _from_state(%rip),%rdi
	call _free
	movq _to_state(%rip),%rdi
	call _free
	call _sort_actions
	call _pack_table
	call _output_base
	call _output_table
	call _output_check
L498:
	ret 


_is_C_identifier:
L499:
L500:
	movsbl (%rdi),%ecx
	cmpl $34,%ecx
	jz L502
L504:
	movslq %ecx,%rax
	testb $3,___ctype+1(%rax)
	jnz L545
L540:
	cmpl $95,%ecx
	jz L545
L536:
	cmpl $36,%ecx
	jnz L561
L545:
	leaq 1(%rdi),%rax
	movsbl 1(%rdi),%ecx
	movq %rax,%rdi
	testl %ecx,%ecx
	jz L562
L546:
	movslq %ecx,%rax
	testb $7,___ctype+1(%rax)
	jnz L545
L555:
	cmpl $95,%ecx
	jz L545
L551:
	cmpl $36,%ecx
	jz L545
	jnz L561
L502:
	leaq 1(%rdi),%rdx
	movsbl 1(%rdi),%ecx
	movslq %ecx,%rax
	testb $3,___ctype+1(%rax)
	jnz L517
L512:
	cmpl $95,%ecx
	jz L517
L508:
	cmpl $36,%ecx
	jnz L561
L517:
	leaq 1(%rdx),%rax
	movsbl 1(%rdx),%ecx
	movq %rax,%rdx
	cmpl $34,%ecx
	jz L562
L518:
	movslq %ecx,%rax
	testb $7,___ctype+1(%rax)
	jnz L517
L527:
	cmpl $95,%ecx
	jz L517
L523:
	cmpl $36,%ecx
	jz L517
	jnz L561
L562:
	movl $1,%eax
	ret
L561:
	xorl %eax,%eax
L501:
	ret 


_output_defines:
L563:
	pushq %rbx
	pushq %r12
	pushq %r13
L564:
	movl $2,%ebx
L566:
	cmpl _ntokens(%rip),%ebx
	jge L569
L567:
	movslq %ebx,%rcx
	movq _symbol_name(%rip),%rax
	movq (%rax,%rcx,8),%r13
	movq %r13,%rdi
	call _is_C_identifier
	testl %eax,%eax
	jz L572
L570:
	pushq $L573
	pushq _code_file(%rip)
	call _fprintf
	addq $16,%rsp
	cmpb $0,_dflag(%rip)
	jz L576
L574:
	pushq $L573
	pushq _defines_file(%rip)
	call _fprintf
	addq $16,%rsp
L576:
	movsbl (%r13),%r12d
	cmpl $34,%r12d
	jnz L592
L580:
	leaq 1(%r13),%rax
	movsbl 1(%r13),%r12d
	movq %rax,%r13
	cmpl $34,%r12d
	jz L579
L581:
	movq _code_file(%rip),%rcx
	decl (%rcx)
	movq _code_file(%rip),%rsi
	js L584
L583:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L585
L584:
	movl %r12d,%edi
	call ___flushbuf
L585:
	cmpb $0,_dflag(%rip)
	jz L580
L586:
	movq _defines_file(%rip),%rcx
	decl (%rcx)
	movq _defines_file(%rip),%rsi
	js L590
L589:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L580
L590:
	movl %r12d,%edi
	call ___flushbuf
	jmp L580
L592:
	movq _code_file(%rip),%rcx
	decl (%rcx)
	movq _code_file(%rip),%rsi
	js L596
L595:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L597
L596:
	movl %r12d,%edi
	call ___flushbuf
L597:
	cmpb $0,_dflag(%rip)
	jz L600
L598:
	movq _defines_file(%rip),%rcx
	decl (%rcx)
	movq _defines_file(%rip),%rsi
	js L602
L601:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L600
L602:
	movl %r12d,%edi
	call ___flushbuf
L600:
	leaq 1(%r13),%rax
	movsbl 1(%r13),%r12d
	movq %rax,%r13
	testl %r12d,%r12d
	jnz L592
L579:
	incl _outline(%rip)
	movslq %ebx,%r12
	movq _symbol_value(%rip),%rax
	movswl (%rax,%r12,2),%eax
	pushq %rax
	pushq $L604
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	cmpb $0,_dflag(%rip)
	jz L572
L605:
	movq _symbol_value(%rip),%rax
	movswl (%rax,%r12,2),%eax
	pushq %rax
	pushq $L604
	pushq _defines_file(%rip)
	call _fprintf
	addq $24,%rsp
L572:
	incl %ebx
	jmp L566
L569:
	incl _outline(%rip)
	movq _symbol_value(%rip),%rax
	movswl 2(%rax),%eax
	pushq %rax
	pushq $L608
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	cmpb $0,_dflag(%rip)
	jz L565
L612:
	cmpb $0,_unionized(%rip)
	jz L565
L609:
	movq _union_file(%rip),%rdi
	call _fclose
	movl $L616,%esi
	movq _union_file_name(%rip),%rdi
	call _fopen
	movq %rax,_union_file(%rip)
	testq %rax,%rax
	jnz L620
L617:
	movq _union_file_name(%rip),%rdi
	call _open_error
L620:
	movq _union_file(%rip),%rcx
	decl (%rcx)
	movq _union_file(%rip),%rdi
	js L624
L623:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%eax
	jmp L625
L624:
	call ___fillbuf
L625:
	movq _defines_file(%rip),%rcx
	cmpl $-1,%eax
	jz L622
L621:
	decl (%rcx)
	movq _defines_file(%rip),%rsi
	js L627
L626:
	movq 24(%rsi),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rsi)
	movb %al,(%rdx)
	jmp L620
L627:
	movl %eax,%edi
	call ___flushbuf
	jmp L620
L622:
	pushq _symbol_prefix(%rip)
	pushq $L629
	pushq %rcx
	call _fprintf
	addq $24,%rsp
L565:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_output_stored_text:
L630:
	pushq %rbx
	pushq %r12
L631:
	movq _text_file(%rip),%rdi
	call _fclose
	movl $L616,%esi
	movq _text_file_name(%rip),%rdi
	call _fopen
	movq %rax,_text_file(%rip)
	testq %rax,%rax
	jnz L635
L633:
	movq _text_file_name(%rip),%rdi
	call _open_error
L635:
	movq _text_file(%rip),%r12
	decl (%r12)
	js L640
L639:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%edi
	jmp L641
L640:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%edi
L641:
	cmpl $-1,%edi
	jz L632
L638:
	movq _code_file(%rip),%rbx
	cmpl $10,%edi
	jnz L645
L643:
	incl _outline(%rip)
L645:
	decl (%rbx)
	js L647
L646:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %dil,(%rcx)
	jmp L649
L647:
	movq %rbx,%rsi
L664:
	call ___flushbuf
L649:
	decl (%r12)
	js L653
L652:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%eax
	jmp L654
L653:
	movq %r12,%rdi
	call ___fillbuf
L654:
	cmpl $-1,%eax
	jz L651
L650:
	cmpl $10,%eax
	jnz L657
L655:
	incl _outline(%rip)
L657:
	decl (%rbx)
	js L659
L658:
	movq 24(%rbx),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rbx)
	movb %al,(%rdx)
	jmp L649
L659:
	movq %rbx,%rsi
	movl %eax,%edi
	jmp L664
L651:
	cmpb $0,_lflag(%rip)
	jnz L632
L661:
	movl _outline(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_outline(%rip)
	addl $2,%ecx
	pushq _code_file_name(%rip)
	pushq %rcx
	pushq $_line_format
	pushq %rbx
	call _fprintf
	addq $32,%rsp
L632:
	popq %r12
	popq %rbx
	ret 


_output_debug:
L665:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L666:
	incl _outline(%rip)
	movswl _final_state(%rip),%eax
	pushq %rax
	pushq $L668
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	addl $3,_outline(%rip)
	movsbl _tflag(%rip),%eax
	pushq %rax
	pushq $L669
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	cmpb $0,_rflag(%rip)
	jz L672
L670:
	movsbl _tflag(%rip),%eax
	pushq %rax
	pushq $L669
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
L672:
	movl $0,-4(%rbp)
	movl $2,%edx
L673:
	cmpl _ntokens(%rip),%edx
	jge L676
L674:
	movslq %edx,%rcx
	movq _symbol_value(%rip),%rax
	movswl (%rax,%rcx,2),%ecx
	movl -4(%rbp),%eax
	cmpl %ecx,%eax
	cmovll %ecx,%eax
	movl %eax,-4(%rbp)
	incl %edx
	jmp L673
L676:
	incl _outline(%rip)
	movl -4(%rbp),%eax
	pushq %rax
	pushq $L680
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl -4(%rbp),%eax
	incl %eax
	shll $3,%eax
	movq %rax,%rdi
	call _malloc
	movq %rax,%r14
	testq %r14,%r14
	jnz L683
L681:
	call _no_space
L683:
	xorl %ecx,%ecx
L684:
	cmpl %ecx,-4(%rbp)
	jle L687
L685:
	movslq %ecx,%rax
	movq $0,(%r14,%rax,8)
	incl %ecx
	jmp L684
L687:
	movl _ntokens(%rip),%esi
	decl %esi
L688:
	cmpl $2,%esi
	jl L691
L689:
	movslq %esi,%rdx
	movq _symbol_name(%rip),%rax
	movq (%rax,%rdx,8),%rcx
	movq _symbol_value(%rip),%rax
	movswq (%rax,%rdx,2),%rax
	movq %rcx,(%r14,%rax,8)
	decl %esi
	jmp L688
L691:
	movq $L692,(%r14)
	cmpb $0,_rflag(%rip)
	jnz L695
L693:
	incl _outline(%rip)
L695:
	pushq _symbol_prefix(%rip)
	pushq $L696
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl $80,%r13d
	xorl %r15d,%r15d
L697:
	cmpl %r15d,-4(%rbp)
	jl L700
L698:
	movslq %r15d,%rax
	movq (%r14,%rax,8),%rcx
	movq %rcx,%r12
	testq %rcx,%rcx
	jz L702
L701:
	movb (%rcx),%al
	cmpb $34,%al
	jnz L705
L704:
	movl $7,%ebx
L707:
	leaq 1(%r12),%rdx
	movb 1(%r12),%al
	movq %rdx,%r12
	cmpb $34,%al
	jz L709
L708:
	leal 1(%rbx),%ecx
	movl %ecx,%ebx
	cmpb $92,%al
	jnz L707
L710:
	leal 2(%rcx),%eax
	movl %eax,%ebx
	leaq 1(%rdx),%rax
	movq %rax,%r12
	cmpb $92,1(%rdx)
	jnz L707
L713:
	addl $3,%ecx
	movl %ecx,%ebx
	jmp L707
L709:
	leal (%rbx,%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L718
L716:
	cmpb $0,_rflag(%rip)
	jnz L721
L719:
	incl _outline(%rip)
L721:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L723
L722:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L724
L723:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L724:
	movl %ebx,%r13d
L718:
	pushq $L725
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movslq %r15d,%rax
	movq (%r14,%rax,8),%r12
L726:
	leaq 1(%r12),%rbx
	movb 1(%r12),%cl
	movq %rbx,%r12
	movq _output_file(%rip),%rax
	cmpb $34,%cl
	jz L728
L727:
	cmpb $92,%cl
	jnz L730
L729:
	pushq $L732
	pushq %rax
	call _fprintf
	addq $16,%rsp
	leaq 1(%rbx),%rax
	movb 1(%rbx),%cl
	movq %rax,%r12
	movq _output_file(%rip),%rax
	cmpb $92,%cl
	jnz L734
L733:
	pushq $L732
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L726
L734:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L737
L736:
	movb 1(%rbx),%sil
	jmp L904
L737:
	movsbl 1(%rbx),%ecx
	jmp L905
L730:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L740
L739:
	movb (%rbx),%sil
L904:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L726
L740:
	movsbl (%rbx),%ecx
L905:
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
	jmp L726
L728:
	pushq $L742
	jmp L901
L705:
	cmpb $39,%al
	jnz L744
L743:
	cmpb $34,1(%rcx)
	jnz L747
L746:
	leal 7(%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L751
L749:
	cmpb $0,_rflag(%rip)
	jnz L754
L752:
	incl _outline(%rip)
L754:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L756
L755:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L757
L756:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L757:
	movl $7,%r13d
L751:
	movq _output_file(%rip),%rax
	pushq $L758
	jmp L901
L747:
	movl $5,%ebx
L759:
	leaq 1(%r12),%rdx
	movb 1(%r12),%al
	movq %rdx,%r12
	cmpb $39,%al
	jz L761
L760:
	leal 1(%rbx),%ecx
	movl %ecx,%ebx
	cmpb $92,%al
	jnz L759
L762:
	leal 2(%rcx),%eax
	movl %eax,%ebx
	leaq 1(%rdx),%rax
	movq %rax,%r12
	cmpb $92,1(%rdx)
	jnz L759
L765:
	addl $3,%ecx
	movl %ecx,%ebx
	jmp L759
L761:
	leal (%rbx,%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L770
L768:
	cmpb $0,_rflag(%rip)
	jnz L773
L771:
	incl _outline(%rip)
L773:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L775
L774:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L776
L775:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L776:
	movl %ebx,%r13d
L770:
	pushq $L777
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movslq %r15d,%rax
	movq (%r14,%rax,8),%r12
L778:
	leaq 1(%r12),%rbx
	movb 1(%r12),%cl
	movq %rbx,%r12
	movq _output_file(%rip),%rax
	cmpb $39,%cl
	jz L780
L779:
	cmpb $92,%cl
	jnz L782
L781:
	pushq $L732
	pushq %rax
	call _fprintf
	addq $16,%rsp
	leaq 1(%rbx),%rax
	movb 1(%rbx),%cl
	movq %rax,%r12
	movq _output_file(%rip),%rax
	cmpb $92,%cl
	jnz L785
L784:
	pushq $L732
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L778
L785:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L788
L787:
	movb 1(%rbx),%sil
	jmp L902
L788:
	movsbl 1(%rbx),%ecx
	jmp L903
L782:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L791
L790:
	movb (%rbx),%sil
L902:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L778
L791:
	movsbl (%rbx),%ecx
L903:
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
	jmp L778
L780:
	pushq $L793
	jmp L901
L744:
	movq %rcx,%rdi
	call _strlen
	leal 3(%rax),%ebx
	leal 3(%rax,%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L796
L794:
	cmpb $0,_rflag(%rip)
	jnz L799
L797:
	incl _outline(%rip)
L799:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L801
L800:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L802
L801:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L802:
	movl %ebx,%r13d
L796:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L804
L803:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $34,(%rdx)
	jmp L806
L804:
	movq %rax,%rsi
	movl $34,%edi
	call ___flushbuf
L806:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L810
L809:
	movb (%r12),%sil
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L811
L810:
	movsbl (%r12),%ecx
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
L811:
	leaq 1(%r12),%rcx
	movb 1(%r12),%al
	movq %rcx,%r12
	testb %al,%al
	jnz L806
L807:
	movq _output_file(%rip),%rax
	pushq $L812
	jmp L901
L702:
	leal 2(%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L815
L813:
	cmpb $0,_rflag(%rip)
	jnz L818
L816:
	incl _outline(%rip)
L818:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L820
L819:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L821
L820:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L821:
	movl $2,%r13d
L815:
	movq _output_file(%rip),%rax
	pushq $L822
L901:
	pushq %rax
	call _fprintf
	addq $16,%rsp
	leal 1(%r15),%eax
	movl %eax,%r15d
	jmp L697
L700:
	cmpb $0,_rflag(%rip)
	jnz L825
L823:
	addl $2,_outline(%rip)
L825:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq %r14,%rdi
	call _free
	cmpb $0,_rflag(%rip)
	jnz L828
L826:
	incl _outline(%rip)
L828:
	pushq _symbol_prefix(%rip)
	pushq $L829
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl $2,%ebx
L830:
	cmpl _nrules(%rip),%ebx
	jge L833
L831:
	movslq %ebx,%r12
	movq _rlhs(%rip),%rax
	movswq (%rax,%r12,2),%rax
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rax,8)
	pushq $L834
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movq _rrhs(%rip),%rax
	movswl (%rax,%r12,2),%r14d
L835:
	movslq %r14d,%rcx
	movq _ritem(%rip),%rax
	movw (%rax,%rcx,2),%ax
	cmpw $0,%ax
	jle L838
L836:
	movswq %ax,%rax
	movq _symbol_name(%rip),%rcx
	movq (%rcx,%rax,8),%r12
	movb (%r12),%cl
	movq _output_file(%rip),%rax
	cmpb $34,%cl
	jnz L840
L839:
	pushq $L842
L900:
	pushq %rax
	call _fprintf
	addq $16,%rsp
L843:
	leaq 1(%r12),%rdx
	movb 1(%r12),%cl
	movq %rdx,%r12
	movq _output_file(%rip),%rax
	cmpb $34,%cl
	jz L845
L844:
	cmpb $92,%cl
	jnz L847
L846:
	leaq 1(%rdx),%r12
	movb 1(%rdx),%cl
	cmpb $92,%cl
	jz L849
L850:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L853
	pushq %rax
	call _fprintf
	addq $24,%rsp
	jmp L843
L849:
	pushq $L852
	jmp L900
L847:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L855
L854:
	movb (%rdx),%sil
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L843
L855:
	movsbl (%rdx),%ecx
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
	jmp L843
L845:
	pushq $L857
	jmp L899
L840:
	cmpb $39,%cl
	jnz L859
L858:
	movb 1(%r12),%cl
	cmpb $34,%cl
	jnz L862
L861:
	pushq $L864
L899:
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L841
L862:
	cmpb $92,%cl
	jnz L866
L865:
	leaq 2(%r12),%r13
	movb 2(%r12),%cl
	cmpb $92,%cl
	jnz L869
L868:
	pushq $L871
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L873
L869:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L872
	pushq %rax
	call _fprintf
	addq $24,%rsp
L873:
	leaq 1(%r13),%rsi
	movb 1(%r13),%dl
	movq %rsi,%r13
	movq _output_file(%rip),%rcx
	movl (%rcx),%eax
	decl %eax
	cmpb $39,%dl
	jz L875
L874:
	movl %eax,(%rcx)
	movq _output_file(%rip),%rcx
	cmpl $0,%eax
	jl L877
L876:
	movb (%rsi),%sil
	movq 24(%rcx),%rdx
	leaq 1(%rdx),%rax
	movq %rax,24(%rcx)
	movb %sil,(%rdx)
	jmp L873
L877:
	movsbl (%rsi),%eax
	movq %rcx,%rsi
	movl %eax,%edi
	call ___flushbuf
	jmp L873
L875:
	movl %eax,(%rcx)
	movq _output_file(%rip),%rcx
	cmpl $0,%eax
	jl L880
L879:
	movq 24(%rcx),%rdx
	leaq 1(%rdx),%rax
	movq %rax,24(%rcx)
	movb $39,(%rdx)
	jmp L841
L880:
	movq %rcx,%rsi
	movl $39,%edi
	call ___flushbuf
	jmp L841
L866:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L882
	jmp L893
L859:
	pushq %r12
	pushq $L883
L893:
	pushq %rax
	call _fprintf
	addq $24,%rsp
L841:
	incl %r14d
	jmp L835
L838:
	cmpb $0,_rflag(%rip)
	jnz L886
L884:
	incl _outline(%rip)
L886:
	pushq $L887
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	leal 1(%rbx),%eax
	movl %eax,%ebx
	jmp L830
L833:
	cmpb $0,_rflag(%rip)
	jnz L890
L888:
	addl $2,_outline(%rip)
L890:
	pushq $L891
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
L667:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_output_stype:
L906:
L907:
	cmpb $0,_unionized(%rip)
	jnz L908
L912:
	cmpl $0,_ntags(%rip)
	jnz L908
L909:
	addl $3,_outline(%rip)
	pushq $L916
	pushq _code_file(%rip)
	call _fprintf
	addq $16,%rsp
L908:
	ret 


_output_trailing_text:
L917:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L918:
	cmpq $0,_line(%rip)
	jz L919
L922:
	movq _input_file(%rip),%r12
	movq _code_file(%rip),%rbx
	movq _cptr(%rip),%rax
	movsbl (%rax),%r13d
	cmpl $10,%r13d
	jnz L925
L924:
	incl _lineno(%rip)
	decl (%r12)
	js L931
L930:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%r14d
	jmp L932
L931:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%r14d
L932:
	cmpl $-1,%r14d
	jz L919
L929:
	cmpb $0,_lflag(%rip)
	jnz L936
L934:
	incl _outline(%rip)
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq %rbx
	call _fprintf
	addq $32,%rsp
L936:
	cmpl $10,%r14d
	jnz L939
L937:
	incl _outline(%rip)
L939:
	decl (%rbx)
	js L941
L940:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %r14b,(%rcx)
	jmp L955
L941:
	movq %rbx,%rsi
	movl %r14d,%edi
	call ___flushbuf
	jmp L955
L925:
	cmpb $0,_lflag(%rip)
	jnz L946
L943:
	incl _outline(%rip)
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq %rbx
	call _fprintf
	addq $32,%rsp
L946:
	decl (%rbx)
	js L950
L949:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %r13b,(%rcx)
	jmp L951
L950:
	movq %rbx,%rsi
	movl %r13d,%edi
	call ___flushbuf
L951:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%r13d
	cmpl $10,%r13d
	jnz L946
L947:
	incl _outline(%rip)
	decl (%rbx)
	js L953
L952:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $10,(%rcx)
	jmp L954
L953:
	movq %rbx,%rsi
	movl $10,%edi
	call ___flushbuf
L954:
	movl $10,%r14d
L955:
	decl (%r12)
	js L959
L958:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%r13d
	jmp L960
L959:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%r13d
L960:
	cmpl $-1,%r13d
	jz L957
L956:
	cmpl $10,%r13d
	jnz L963
L961:
	incl _outline(%rip)
L963:
	decl (%rbx)
	js L965
L964:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %r13b,(%rcx)
	jmp L966
L965:
	movq %rbx,%rsi
	movl %r13d,%edi
	call ___flushbuf
L966:
	movl %r13d,%r14d
	jmp L955
L957:
	cmpl $10,%r14d
	jz L969
L967:
	incl _outline(%rip)
	decl (%rbx)
	js L971
L970:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $10,(%rcx)
	jmp L969
L971:
	movq %rbx,%rsi
	movl $10,%edi
	call ___flushbuf
L969:
	cmpb $0,_lflag(%rip)
	jnz L919
L973:
	movl _outline(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_outline(%rip)
	addl $2,%ecx
	pushq _code_file_name(%rip)
	pushq %rcx
	pushq $_line_format
	pushq %rbx
	call _fprintf
	addq $32,%rsp
L919:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_output_semantic_actions:
L976:
	pushq %rbx
	pushq %r12
	pushq %r13
L977:
	movq _action_file(%rip),%rdi
	call _fclose
	movl $L616,%esi
	movq _action_file_name(%rip),%rdi
	call _fopen
	movq %rax,_action_file(%rip)
	testq %rax,%rax
	jnz L981
L979:
	movq _action_file_name(%rip),%rdi
	call _open_error
L981:
	movq _action_file(%rip),%rcx
	decl (%rcx)
	movq _action_file(%rip),%rdi
	js L986
L985:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%edi
	jmp L987
L986:
	call ___fillbuf
	movl %eax,%edi
L987:
	cmpl $-1,%edi
	jz L978
L984:
	movq _code_file(%rip),%r13
	movl %edi,%r12d
	cmpl $10,%edi
	jnz L991
L989:
	incl _outline(%rip)
L991:
	decl (%r13)
	js L993
L992:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb %dil,(%rcx)
	jmp L995
L993:
	movq %r13,%rsi
	call ___flushbuf
L995:
	movq _action_file(%rip),%rcx
	decl (%rcx)
	movq _action_file(%rip),%rdi
	js L999
L998:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%ebx
	jmp L1000
L999:
	call ___fillbuf
	movl %eax,%ebx
L1000:
	cmpl $-1,%ebx
	jz L997
L996:
	cmpl $10,%ebx
	jnz L1003
L1001:
	incl _outline(%rip)
L1003:
	decl (%r13)
	js L1005
L1004:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb %bl,(%rcx)
	jmp L1006
L1005:
	movq %r13,%rsi
	movl %ebx,%edi
	call ___flushbuf
L1006:
	movl %ebx,%r12d
	jmp L995
L997:
	cmpl $10,%r12d
	jz L1009
L1007:
	incl _outline(%rip)
	decl (%r13)
	js L1011
L1010:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb $10,(%rcx)
	jmp L1009
L1011:
	movq %r13,%rsi
	movl $10,%edi
	call ___flushbuf
L1009:
	cmpb $0,_lflag(%rip)
	jnz L978
L1013:
	movl _outline(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_outline(%rip)
	addl $2,%ecx
	pushq _code_file_name(%rip)
	pushq %rcx
	pushq $_line_format
	pushq %r13
	call _fprintf
	addq $32,%rsp
L978:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_free_itemsets:
L1016:
	pushq %rbx
L1017:
	movq _state_table(%rip),%rdi
	call _free
	movq _first_state(%rip),%rdi
L1019:
	testq %rdi,%rdi
	jz L1018
L1020:
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rdi
	jmp L1019
L1018:
	popq %rbx
	ret 


_free_shifts:
L1023:
	pushq %rbx
L1024:
	movq _shift_table(%rip),%rdi
	call _free
	movq _first_shift(%rip),%rdi
L1026:
	testq %rdi,%rdi
	jz L1025
L1027:
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rdi
	jmp L1026
L1025:
	popq %rbx
	ret 


_free_reductions:
L1030:
	pushq %rbx
L1031:
	movq _reduction_table(%rip),%rdi
	call _free
	movq _first_reduction(%rip),%rdi
L1033:
	testq %rdi,%rdi
	jz L1032
L1034:
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rdi
	jmp L1033
L1032:
	popq %rbx
	ret 


_output:
L1037:
L1038:
	call _free_itemsets
	call _free_shifts
	call _free_reductions
	call _output_prefix
	call _output_stored_text
	call _output_defines
	call _output_rule_data
	call _output_yydefred
	call _output_actions
	call _free_parser
	call _output_debug
	call _output_stype
	cmpb $0,_rflag(%rip)
	jz L1042
L1040:
	movl $_tables,%edi
	call _write_section
L1042:
	movl $_header,%edi
	call _write_section
	call _output_trailing_text
	movl $_body,%edi
	call _write_section
	call _output_semantic_actions
	movl $_trailer,%edi
	call _write_section
L1039:
	ret 

L29:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,99,104,101,99,107,32
	.byte 37,115,99,104,101,99,107,10
	.byte 0
L608:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,69,82,82,67,79,68
	.byte 69,32,37,100,10,0
L479:
	.byte 115,104,111,114,116,32,37,115
	.byte 99,104,101,99,107,91,93,32
	.byte 61,32,123,37,52,48,100,44
	.byte 0
L629:
	.byte 32,89,89,83,84,89,80,69
	.byte 59,10,101,120,116,101,114,110
	.byte 32,89,89,83,84,89,80,69
	.byte 32,37,115,108,118,97,108,59
	.byte 10,0
L777:
	.byte 34,39,0
L25:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,115,105,110,100,101,120
	.byte 32,37,115,115,105,110,100,101
	.byte 120,10,0
L18:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,115,115,112,32,37,115
	.byte 115,115,112,10,0
L13:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,108,118,97,108,32,37
	.byte 115,108,118,97,108,10,0
L208:
	.byte 115,104,111,114,116,32,37,115
	.byte 100,103,111,116,111,91,93,32
	.byte 61,32,123,37,52,48,100,44
	.byte 0
L829:
	.byte 99,104,97,114,32,42,37,115
	.byte 114,117,108,101,91,93,32,61
	.byte 32,123,10,0
L857:
	.byte 92,34,0
L680:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,77,65,88,84,79,75
	.byte 69,78,32,37,100,10,0
L50:
	.byte 37,53,100,44,0
L573:
	.byte 35,100,101,102,105,110,101,32
	.byte 0
L36:
	.byte 115,104,111,114,116,32,37,115
	.byte 108,104,115,91,93,32,61,32
	.byte 123,37,52,50,100,44,0
L27:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,103,105,110,100,101,120
	.byte 32,37,115,103,105,110,100,101
	.byte 120,10,0
L812:
	.byte 34,44,0
L732:
	.byte 92,92,0
L668:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,70,73,78,65,76,32
	.byte 37,100,10,0
L26:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,114,105,110,100,101,120
	.byte 32,37,115,114,105,110,100,101
	.byte 120,10,0
L21:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,108,104,115,32,37,115
	.byte 108,104,115,10,0
L887:
	.byte 34,44,10,0
L334:
	.byte 109,97,120,105,109,117,109,32
	.byte 116,97,98,108,101,32,115,105
	.byte 122,101,32,101,120,99,101,101
	.byte 100,101,100,0
L883:
	.byte 32,37,115,0
L669:
	.byte 35,105,102,110,100,101,102,32
	.byte 89,89,68,69,66,85,71,10
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,68,69,66,85,71,32
	.byte 37,100,10,35,101,110,100,105
	.byte 102,10,0
L458:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,84,65,66,76,69,83
	.byte 73,90,69,32,37,100,10,0
L303:
	.byte 116,0
L834:
	.byte 34,37,115,32,58,0
L403:
	.byte 115,104,111,114,116,32,37,115
	.byte 115,105,110,100,101,120,91,93
	.byte 32,61,32,123,37,51,57,100
	.byte 44,0
L24:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,100,103,111,116,111,32
	.byte 37,115,100,103,111,116,111,10
	.byte 0
L692:
	.byte 101,110,100,45,111,102,45,102
	.byte 105,108,101,0
L7:
	.byte 121,121,0
L822:
	.byte 48,44,0
L20:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,118,115,112,32,37,115
	.byte 118,115,112,10,0
L852:
	.byte 92,92,92,92,0
L872:
	.byte 32,39,92,92,37,99,0
L31:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,114,117,108,101,32,37
	.byte 115,114,117,108,101,10,0
L864:
	.byte 32,39,92,34,39,0
L437:
	.byte 10,125,59,10,115,104,111,114
	.byte 116,32,37,115,103,105,110,100
	.byte 101,120,91,93,32,61,32,123
	.byte 37,51,57,100,44,0
L55:
	.byte 115,104,111,114,116,32,37,115
	.byte 108,101,110,91,93,32,61,32
	.byte 123,37,52,50,100,44,0
L420:
	.byte 10,125,59,10,115,104,111,114
	.byte 116,32,37,115,114,105,110,100
	.byte 101,120,91,93,32,61,32,123
	.byte 37,51,57,100,44,0
L842:
	.byte 32,92,34,0
L758:
	.byte 34,39,92,34,39,34,44,0
L16:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,101,114,114,102,108,97
	.byte 103,32,37,115,101,114,114,102
	.byte 108,97,103,10,0
L459:
	.byte 115,104,111,114,116,32,37,115
	.byte 116,97,98,108,101,91,93,32
	.byte 61,32,123,37,52,48,100,44
	.byte 0
L15:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,110,101,114,114,115,32
	.byte 37,115,110,101,114,114,115,10
	.byte 0
L616:
	.byte 114,0
L725:
	.byte 34,92,34,0
L75:
	.byte 115,104,111,114,116,32,37,115
	.byte 100,101,102,114,101,100,91,93
	.byte 32,61,32,123,37,51,57,100
	.byte 44,0
L28:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,116,97,98,108,101,32
	.byte 37,115,116,97,98,108,101,10
	.byte 0
L11:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,99,104,97,114,32,37
	.byte 115,99,104,97,114,10,0
L871:
	.byte 32,39,92,92,92,92,0
L23:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,100,101,102,114,101,100
	.byte 32,37,115,100,101,102,114,101
	.byte 100,10,0
L30:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,110,97,109,101,32,37
	.byte 115,110,97,109,101,10,0
L853:
	.byte 92,92,37,99,0
L12:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,118,97,108,32,37,115
	.byte 118,97,108,10,0
L19:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,118,115,32,37,115,118
	.byte 115,10,0
L22:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,108,101,110,32,37,115
	.byte 108,101,110,10,0
L891:
	.byte 125,59,10,35,101,110,100,105
	.byte 102,10,0
L8:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,112,97,114,115,101,32
	.byte 37,115,112,97,114,115,101,10
	.byte 0
L304:
	.byte 111,117,116,112,117,116,46,99
	.byte 0
L32:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,80,82,69,70,73,88
	.byte 32,34,37,115,34,10,0
L54:
	.byte 10,125,59,10,0
L604:
	.byte 32,37,100,10,0
L10:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,101,114,114,111,114,32
	.byte 37,115,101,114,114,111,114,10
	.byte 0
L793:
	.byte 39,34,44,0
L9:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,108,101,120,32,37,115
	.byte 108,101,120,10,0
L696:
	.byte 35,105,102,32,89,89,68,69
	.byte 66,85,71,10,99,104,97,114
	.byte 32,42,37,115,110,97,109,101
	.byte 91,93,32,61,32,123,0
L17:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,115,115,32,37,115,115
	.byte 115,10,0
L916:
	.byte 35,105,102,110,100,101,102,32
	.byte 89,89,83,84,89,80,69,10
	.byte 116,121,112,101,100,101,102,32
	.byte 105,110,116,32,89,89,83,84
	.byte 89,80,69,59,10,35,101,110
	.byte 100,105,102,10,0
L742:
	.byte 92,34,34,44,0
L882:
	.byte 32,39,37,99,39,0
L14:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,100,101,98,117,103,32
	.byte 37,115,100,101,98,117,103,10
	.byte 0
.local _nvectors
.comm _nvectors, 4, 4
.local _nentries
.comm _nentries, 4, 4
.local _froms
.comm _froms, 8, 8
.local _tos
.comm _tos, 8, 8
.local _tally
.comm _tally, 8, 8
.local _width
.comm _width, 8, 8
.local _state_count
.comm _state_count, 8, 8
.local _order
.comm _order, 8, 8
.local _base
.comm _base, 8, 8
.local _pos
.comm _pos, 8, 8
.local _maxtable
.comm _maxtable, 4, 4
.local _table
.comm _table, 8, 8
.local _check
.comm _check, 8, 8
.local _lowzero
.comm _lowzero, 4, 4
.local _high
.comm _high, 4, 4

.globl _free
.globl _rlhs
.globl _header
.globl _write_section
.globl _unionized
.globl ___fillbuf
.globl _state_table
.globl _free_parser
.globl _realloc
.globl _dflag
.globl _output_file
.globl _LAruleno
.globl _fopen
.globl _LA
.globl _nsyms
.globl _defines_file
.globl _code_file
.globl _symbol_prefix
.globl _malloc
.globl ___assert
.globl _shift_table
.globl _body
.globl _text_file_name
.globl _ntokens
.globl _input_file_name
.globl _line_format
.globl _lflag
.globl _reduction_table
.globl _rrhs
.globl _tables
.globl _lineno
.globl _tflag
.globl _first_state
.globl _text_file
.globl _goto_map
.globl _lookaheads
.globl _ntags
.globl _outline
.globl _allocate
.globl _union_file
.globl _trailer
.globl ___flushbuf
.globl _open_error
.globl _start_symbol
.globl ___ctype
.globl _union_file_name
.globl _final_state
.globl _to_state
.globl _accessing_symbol
.globl _first_reduction
.globl _symbol_name
.globl _nrules
.globl _action_file_name
.globl _fclose
.globl _fatal
.globl _first_shift
.globl _output
.globl _symbol_value
.globl _rflag
.globl _parser
.globl _from_state
.globl _ritem
.globl _cptr
.globl _nvars
.globl _strlen
.globl _input_file
.globl _defred
.globl _line
.globl _nstates
.globl _code_file_name
.globl _fprintf
.globl _action_file
.globl _no_space
