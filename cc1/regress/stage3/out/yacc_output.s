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
	jmp L37
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
	movq _rlhs(%rip),%rax
	movswq (%rax,%rbx,2),%rax
	movq _symbol_value(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
L37:
	cmpl _nrules(%rip),%ebx
	jl L38
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
	jmp L56
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
	movq _rrhs(%rip),%rcx
	movswl (%rcx,%rbx,2),%eax
	movswl (%rcx,%r13,2),%ecx
	subl %ecx,%eax
	decl %eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl %ebx,%r13d
L56:
	cmpl _nrules(%rip),%r13d
	jl L57
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
	jmp L79
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
	movq _defred(%rip),%rax
	movw (%rax,%rbx,2),%ax
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
L79:
	cmpl _nstates(%rip),%ebx
	jl L80
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
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L99:
	movl _ntokens(%rip),%edi
	shll $2,%edi
	call _allocate
	movq %rax,%r12
	xorl %ebx,%ebx
	jmp L101
L102:
	movl %ebx,%ecx
	movq _parser(%rip),%rax
	cmpq $0,(%rax,%rcx,8)
	jz L107
L105:
	xorl %eax,%eax
L108:
	movl _ntokens(%rip),%ecx
	shll $1,%ecx
	cmpl %ecx,%eax
	jge L111
L109:
	movw $0,(%r12,%rax,2)
	incl %eax
	jmp L108
L111:
	xorl %r15d,%r15d
	xorl %r13d,%r13d
	movl %ebx,%eax
	movq _parser(%rip),%rcx
	movq (%rcx,%rax,8),%rdx
L112:
	testq %rdx,%rdx
	jz L115
L113:
	cmpb $0,16(%rdx)
	jnz L118
L116:
	movb 14(%rdx),%al
	cmpb $1,%al
	jnz L120
L119:
	incl %r15d
	movw 10(%rdx),%cx
	movswq 8(%rdx),%rax
	jmp L161
L120:
	cmpb $2,%al
	jnz L118
L125:
	movw 10(%rdx),%cx
	movl %ebx,%ebx
	movq _defred(%rip),%rax
	cmpw (%rax,%rbx,2),%cx
	jz L118
L122:
	incl %r13d
	movswl 8(%rdx),%eax
	addl _ntokens(%rip),%eax
	movslq %eax,%rax
L161:
	movw %cx,(%r12,%rax,2)
L118:
	movq (%rdx),%rdx
	jmp L112
L115:
	movl %ebx,%ebx
	movq _tally(%rip),%rax
	movw %r15w,(%rax,%rbx,2)
	movl _nstates(%rip),%eax
	addl %ebx,%eax
	movslq %eax,%rax
	movq _tally(%rip),%rcx
	movw %r13w,(%rcx,%rax,2)
	movq _width(%rip),%rax
	movw $0,(%rax,%rbx,2)
	movl _nstates(%rip),%eax
	addl %ebx,%eax
	movslq %eax,%rax
	movq _width(%rip),%rcx
	movw $0,(%rcx,%rax,2)
	cmpl $0,%r15d
	jle L131
L129:
	shll $1,%r15d
	movq %r15,%rdi
	call _allocate
	movq %rax,%r14
	movq _froms(%rip),%rcx
	movq %rax,(%rcx,%rbx,8)
	movq %r15,%rdi
	call _allocate
	movq _tos(%rip),%rcx
	movq %rax,(%rcx,%rbx,8)
	movl $32767,%edi
	xorl %esi,%esi
	xorl %edx,%edx
L132:
	cmpl %edx,_ntokens(%rip)
	jle L135
L133:
	cmpw $0,(%r12,%rdx,2)
	jz L138
L136:
	movq _symbol_value(%rip),%rcx
	movw (%rcx,%rdx,2),%cx
	movswl %cx,%ecx
	cmpl %ecx,%edi
	cmovgl %ecx,%edi
	cmpl %ecx,%esi
	cmovll %ecx,%esi
	movw %cx,(%r14)
	addq $2,%r14
	movw (%r12,%rdx,2),%cx
	movw %cx,(%rax)
	addq $2,%rax
L138:
	incl %edx
	jmp L132
L135:
	subw %di,%si
	incw %si
	movl %ebx,%eax
	movq _width(%rip),%rcx
	movw %si,(%rcx,%rax,2)
L131:
	cmpl $0,%r13d
	jle L107
L145:
	shll $1,%r13d
	movq %r13,%rdi
	call _allocate
	movl _nstates(%rip),%ecx
	movq %rax,%r14
	addl %ebx,%ecx
	movslq %ecx,%rcx
	movq _froms(%rip),%rdx
	movq %rax,(%rdx,%rcx,8)
	movq %r13,%rdi
	call _allocate
	movl _nstates(%rip),%ecx
	addl %ebx,%ecx
	movslq %ecx,%rcx
	movq _tos(%rip),%rdx
	movq %rax,(%rdx,%rcx,8)
	movl $32767,%edi
	xorl %esi,%esi
	xorl %edx,%edx
L148:
	movl _ntokens(%rip),%ecx
	cmpl %edx,%ecx
	jle L151
L149:
	addl %edx,%ecx
	movslq %ecx,%rcx
	cmpw $0,(%r12,%rcx,2)
	jz L154
L152:
	movq _symbol_value(%rip),%rcx
	movw (%rcx,%rdx,2),%cx
	movswl %cx,%ecx
	cmpl %ecx,%edi
	cmovgl %ecx,%edi
	cmpl %ecx,%esi
	cmovll %ecx,%esi
	movw %cx,(%r14)
	movl _ntokens(%rip),%ecx
	addq $2,%r14
	addl %edx,%ecx
	movslq %ecx,%rcx
	movw (%r12,%rcx,2),%cx
	subw $2,%cx
	movw %cx,(%rax)
	addq $2,%rax
L154:
	incl %edx
	jmp L148
L151:
	movl _nstates(%rip),%eax
	subw %di,%si
	incw %si
	addl %ebx,%eax
	movslq %eax,%rax
	movq _width(%rip),%rcx
	movw %si,(%rcx,%rax,2)
L107:
	incl %ebx
L101:
	cmpl _nstates(%rip),%ebx
	jl L102
L104:
	movq %r12,%rdi
	call _free
L100:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_default_goto:
L162:
L163:
	movslq %edi,%rax
	movq _goto_map(%rip),%rcx
	movswl (%rcx,%rax,2),%edx
	incl %edi
	movslq %edi,%rax
	movswl (%rcx,%rax,2),%edi
	xorl %eax,%eax
	cmpl %edi,%edx
	jz L164
L169:
	cmpl _nstates(%rip),%eax
	jl L170
	jge L173
L174:
	movslq %edx,%rdx
	movq _to_state(%rip),%rax
	movswq (%rax,%rdx,2),%rcx
	movq _state_count(%rip),%rsi
	incw (%rsi,%rcx,2)
	incl %edx
L173:
	cmpl %edx,%edi
	jg L174
L176:
	xorl %esi,%esi
	xorl %eax,%eax
	xorl %edx,%edx
L177:
	cmpl _nstates(%rip),%edx
	jge L164
L178:
	movq _state_count(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,%esi
	jge L183
L181:
	movl %ecx,%esi
	movl %edx,%eax
L183:
	incl %edx
	jmp L177
L170:
	movq _state_count(%rip),%rcx
	movw $0,(%rcx,%rax,2)
	incl %eax
	jmp L169
L164:
	ret 


_save_column:
L185:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L186:
	movl %esi,-4(%rbp)
	movslq %edi,%rax
	movq _goto_map(%rip),%rcx
	movswl (%rcx,%rax,2),%r12d
	leal 1(%rdi),%eax
	movslq %eax,%rax
	movswl (%rcx,%rax,2),%eax
	movl %eax,-8(%rbp)
	xorl %r15d,%r15d
	movl %r12d,%ecx
	jmp L188
L189:
	movslq %ecx,%rcx
	movq _to_state(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	cmpl %eax,-4(%rbp)
	jz L194
L192:
	incl %r15d
L194:
	incl %ecx
L188:
	cmpl %ecx,-8(%rbp)
	jg L189
L191:
	testl %r15d,%r15d
	jz L187
L197:
	movslq %edi,%rcx
	movq _symbol_value(%rip),%rax
	movswl (%rax,%rcx,2),%ecx
	movl _nstates(%rip),%eax
	leal (%rcx,%rax,2),%ebx
	movl %r15d,%r14d
	shll $1,%r14d
	movq %r14,%rdi
	call _allocate
	movq %rax,%r13
	movq %rax,-16(%rbp)
	movslq %ebx,%rax
	movq %rax,-24(%rbp)
	movq _froms(%rip),%rdx
	movq -16(%rbp),%rcx
	movq -24(%rbp),%rax
	movq %rcx,(%rdx,%rax,8)
	movq %r14,%rdi
	call _allocate
	movq _tos(%rip),%rdx
	movq -24(%rbp),%rcx
	movq %rax,(%rdx,%rcx,8)
	jmp L199
L200:
	movslq %r12d,%r12
	movq _to_state(%rip),%rcx
	movswl (%rcx,%r12,2),%ecx
	cmpl %ecx,-4(%rbp)
	jz L205
L203:
	movq _from_state(%rip),%rcx
	movw (%rcx,%r12,2),%cx
	movw %cx,(%r13)
	addq $2,%r13
	movq _to_state(%rip),%rcx
	movw (%rcx,%r12,2),%cx
	movw %cx,(%rax)
	addq $2,%rax
L205:
	incl %r12d
L199:
	cmpl %r12d,-8(%rbp)
	jg L200
L202:
	movslq %ebx,%rbx
	movq _tally(%rip),%rax
	movw %r15w,(%rax,%rbx,2)
	movw -2(%r13),%cx
	movq -16(%rbp),%rax
	subw (%rax),%cx
	incw %cx
	movq _width(%rip),%rax
	movw %cx,(%rax,%rbx,2)
L187:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_goto_actions:
L206:
	pushq %rbx
	pushq %r12
	pushq %r13
L207:
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
	pushq $L209
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
	jmp L210
L211:
	cmpl $10,%r13d
	jl L215
L214:
	cmpb $0,_rflag(%rip)
	jnz L219
L217:
	incl _outline(%rip)
L219:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L221
L220:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L222
L221:
	movl $10,%edi
	call ___flushbuf
L222:
	movl $1,%r13d
	jmp L216
L215:
	incl %r13d
L216:
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
L210:
	cmpl _nsyms(%rip),%ebx
	jl L211
L213:
	cmpb $0,_rflag(%rip)
	jnz L225
L223:
	addl $2,_outline(%rip)
L225:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _state_count(%rip),%rdi
	call _free
L208:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_sort_actions:
L226:
L227:
	movl _nvectors(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_order(%rip)
	movl $0,_nentries(%rip)
	xorl %eax,%eax
L229:
	cmpl %eax,_nvectors(%rip)
	jle L228
L230:
	movq _tally(%rip),%rcx
	movw (%rcx,%rax,2),%di
	cmpw $0,%di
	jle L235
L233:
	movswl %di,%edi
	movq _width(%rip),%rcx
	movswl (%rcx,%rax,2),%esi
	movl _nentries(%rip),%r8d
	decl %r8d
L236:
	cmpl $0,%r8d
	jl L243
L239:
	movslq %r8d,%rcx
	movq _order(%rip),%rdx
	movswq (%rdx,%rcx,2),%rcx
	movq _width(%rip),%rdx
	movswl (%rdx,%rcx,2),%ecx
	cmpl %ecx,%esi
	jg L240
	jle L243
L250:
	movslq %r8d,%r8
	movq _order(%rip),%rcx
	movswq (%rcx,%r8,2),%rdx
	movq _width(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,%esi
	jnz L248
L251:
	movq _tally(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,%edi
	jle L248
L247:
	decl %r8d
L243:
	cmpl $0,%r8d
	jge L250
L248:
	movl _nentries(%rip),%edi
	decl %edi
	jmp L254
L255:
	movslq %edi,%rdi
	movw (%rcx,%rdi,2),%si
	leal 1(%rdi),%edx
	movslq %edx,%rdx
	movw %si,(%rcx,%rdx,2)
	decl %edi
L254:
	movq _order(%rip),%rcx
	cmpl %edi,%r8d
	jl L255
L257:
	incl %r8d
	movslq %r8d,%rdx
	movw %ax,(%rcx,%rdx,2)
	incl _nentries(%rip)
L235:
	incl %eax
	jmp L229
L240:
	decl %r8d
	jmp L236
L228:
	ret 


_matching_vector:
L258:
	pushq %rbx
L259:
	movslq %edi,%rcx
	movq _order(%rip),%rax
	movswl (%rax,%rcx,2),%r11d
	movl _nstates(%rip),%eax
	shll $1,%eax
	cmpl %eax,%r11d
	jge L297
L263:
	movslq %r11d,%rcx
	movq _tally(%rip),%rax
	movswl (%rax,%rcx,2),%esi
	movq _width(%rip),%rax
	movswl (%rax,%rcx,2),%edx
	decl %edi
	jmp L265
L266:
	movslq %edi,%rax
	movq _order(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	movslq %eax,%rax
	movq _width(%rip),%rcx
	movswl (%rcx,%rax,2),%ecx
	cmpl %ecx,%edx
	jnz L297
L272:
	movq _tally(%rip),%rcx
	movswl (%rcx,%rax,2),%ecx
	cmpl %ecx,%esi
	jnz L297
L271:
	movl $1,%ecx
	xorl %ebx,%ebx
L281:
	cmpl %ebx,%esi
	jle L280
L278:
	movslq %eax,%rax
	movq _tos(%rip),%r10
	movq (%r10,%rax,8),%r8
	movw (%r8,%rbx,2),%r9w
	movslq %r11d,%r11
	movq (%r10,%r11,8),%r8
	cmpw (%r8,%rbx,2),%r9w
	jnz L285
L288:
	movq _froms(%rip),%r10
	movq (%r10,%rax,8),%r8
	movw (%r8,%rbx,2),%r9w
	movq (%r10,%r11,8),%r8
	cmpw (%r8,%rbx,2),%r9w
	jz L287
L285:
	xorl %ecx,%ecx
L287:
	incl %ebx
	testl %ecx,%ecx
	jnz L281
L280:
	testl %ecx,%ecx
	jnz L260
L294:
	decl %edi
L265:
	cmpl $0,%edi
	jge L266
L297:
	movl $-1,%eax
L260:
	popq %rbx
	ret 


_pack_vector:
L298:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L299:
	movslq %edi,%rdi
	movq %rdi,-16(%rbp)
	movq _order(%rip),%rcx
	movq -16(%rbp),%rax
	movswl (%rcx,%rax,2),%eax
	movslq %eax,%rax
	movq %rax,-40(%rbp)
	movq _tally(%rip),%rcx
	movq -40(%rbp),%rax
	movswl (%rcx,%rax,2),%eax
	testl %eax,%eax
	movl %eax,-20(%rbp)
	jnz L303
L301:
	movl $472,%edx
	movl $L305,%esi
	movl $L304,%edi
	call ___assert
L303:
	movq _froms(%rip),%rcx
	movq -40(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-32(%rbp)
	movq _tos(%rip),%rcx
	movq -40(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-8(%rbp)
	movq -32(%rbp),%rax
	movswl (%rax),%ecx
	movl _lowzero(%rip),%eax
	subl %ecx,%eax
	movl %eax,-44(%rbp)
	movl $1,%edx
L306:
	cmpl %edx,-20(%rbp)
	jg L307
L313:
	cmpl $0,-44(%rbp)
	jz L315
L319:
	movl $1,%r13d
	xorl %r12d,%r12d
L325:
	cmpl %r12d,-20(%rbp)
	jle L324
L322:
	movq -32(%rbp),%rax
	movswl (%rax,%r12,2),%r14d
	addl -44(%rbp),%r14d
	cmpl _maxtable(%rip),%r14d
	jl L331
L329:
	cmpl $32500,%r14d
	jl L334
L332:
	movl $L335,%edi
	call _fatal
L334:
	movl _maxtable(%rip),%ebx
L336:
	addl $200,%ebx
	cmpl %ebx,%r14d
	jge L336
L337:
	movl %ebx,%r15d
	shll $1,%r15d
	movq %r15,%rsi
	movq _table(%rip),%rdi
	call _realloc
	movq %rax,_table(%rip)
	testq %rax,%rax
	jnz L341
L339:
	call _no_space
L341:
	movq %r15,%rsi
	movq _check(%rip),%rdi
	call _realloc
	movq %rax,_check(%rip)
	testq %rax,%rax
	jnz L344
L342:
	call _no_space
L344:
	movl _maxtable(%rip),%eax
	jmp L345
L346:
	movslq %eax,%rax
	movq _table(%rip),%rcx
	movw $0,(%rcx,%rax,2)
	movq _check(%rip),%rcx
	movw $-1,(%rcx,%rax,2)
	incl %eax
L345:
	cmpl %eax,%ebx
	jg L346
L348:
	movl %ebx,_maxtable(%rip)
L331:
	movslq %r14d,%r14
	movq _check(%rip),%rax
	cmpw $-1,(%rax,%r14,2)
	movl $0,%eax
	cmovnzl %eax,%r13d
	incl %r12d
	testl %r13d,%r13d
	jnz L325
L324:
	xorl %ecx,%ecx
	jmp L352
L356:
	movq -16(%rbp),%rax
	cmpl %ecx,%eax
	jle L355
L353:
	movq _pos(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	cmpl %eax,-44(%rbp)
	movl $0,%eax
	cmovzl %eax,%r13d
	incl %ecx
L352:
	testl %r13d,%r13d
	jnz L356
L355:
	testl %r13d,%r13d
	jnz L363
L315:
	incl -44(%rbp)
	jmp L313
L363:
	xorl %edx,%edx
L366:
	cmpl %edx,-20(%rbp)
	jg L367
	jle L373
L374:
	incl %eax
	movl %eax,_lowzero(%rip)
L373:
	movslq _lowzero(%rip),%rax
	movq _check(%rip),%rcx
	cmpw $-1,(%rcx,%rax,2)
	jnz L374
L375:
	movl -44(%rbp),%eax
L300:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L367:
	movq -32(%rbp),%rax
	movswl (%rax,%rdx,2),%ecx
	addl -44(%rbp),%ecx
	movq -8(%rbp),%rax
	movw (%rax,%rdx,2),%ax
	movslq %ecx,%rcx
	movq _table(%rip),%rsi
	movw %ax,(%rsi,%rcx,2)
	movq -32(%rbp),%rax
	movw (%rax,%rdx,2),%ax
	movq _check(%rip),%rsi
	movw %ax,(%rsi,%rcx,2)
	cmpl _high(%rip),%ecx
	jle L372
L370:
	movl %ecx,_high(%rip)
L372:
	incl %edx
	jmp L366
L307:
	movq -32(%rbp),%rax
	movswl (%rax,%rdx,2),%eax
	movl _lowzero(%rip),%ecx
	subl %eax,%ecx
	movl -44(%rbp),%eax
	cmpl %ecx,%eax
	cmovll %ecx,%eax
	movl %eax,-44(%rbp)
	incl %edx
	jmp L306


_pack_table:
L377:
	pushq %rbx
L378:
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
	xorl %eax,%eax
	jmp L380
L381:
	movq _check(%rip),%rcx
	movw $-1,(%rcx,%rax,2)
	incl %eax
L380:
	cmpl %eax,_maxtable(%rip)
	jg L381
L383:
	xorl %ebx,%ebx
	jmp L384
L385:
	movl %ebx,%edi
	call _matching_vector
	cmpl $0,%eax
	jge L389
L388:
	movl %ebx,%edi
	call _pack_vector
	jmp L390
L389:
	movslq %eax,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
L390:
	movq _pos(%rip),%rcx
	movw %ax,(%rcx,%rbx,2)
	movq _order(%rip),%rcx
	movswq (%rcx,%rbx,2),%rcx
	movq _base(%rip),%rdx
	movw %ax,(%rdx,%rcx,2)
	incl %ebx
L384:
	cmpl %ebx,_nentries(%rip)
	jg L385
L387:
	xorl %ebx,%ebx
	jmp L391
L392:
	movq (%rdi,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L397
L395:
	call _free
L397:
	movq _tos(%rip),%rax
	movq (%rax,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L400
L398:
	call _free
L400:
	incl %ebx
L391:
	movl _nvectors(%rip),%eax
	movq _froms(%rip),%rdi
	cmpl %ebx,%eax
	jg L392
L394:
	call _free
	movq _tos(%rip),%rdi
	call _free
	movq _pos(%rip),%rdi
	call _free
L379:
	popq %rbx
	ret 


_output_base:
L401:
	pushq %rbx
	pushq %r12
L402:
	movq _base(%rip),%rax
	movswl (%rax),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L404
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $1,%ebx
	jmp L405
L406:
	cmpl $10,%r12d
	jl L410
L409:
	cmpb $0,_rflag(%rip)
	jnz L414
L412:
	incl _outline(%rip)
L414:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L416
L415:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L417
L416:
	movl $10,%edi
	call ___flushbuf
L417:
	movl $1,%r12d
	jmp L411
L410:
	incl %r12d
L411:
	movq _base(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
L405:
	movl _nstates(%rip),%eax
	cmpl %eax,%ebx
	jl L406
L408:
	cmpb $0,_rflag(%rip)
	jnz L420
L418:
	addl $2,_outline(%rip)
L420:
	movslq %eax,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L421
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl _nstates(%rip),%ebx
	movl $10,%r12d
	jmp L455
L423:
	cmpl $10,%r12d
	jl L427
L426:
	cmpb $0,_rflag(%rip)
	jnz L431
L429:
	incl _outline(%rip)
L431:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L433
L432:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L434
L433:
	movl $10,%edi
	call ___flushbuf
L434:
	movl $1,%r12d
	jmp L428
L427:
	incl %r12d
L428:
	movslq %ebx,%rbx
	movq _base(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
L455:
	incl %ebx
	movl _nstates(%rip),%eax
	shll $1,%eax
	cmpl %eax,%ebx
	jl L423
L425:
	cmpb $0,_rflag(%rip)
	jnz L437
L435:
	addl $2,_outline(%rip)
L437:
	movslq %eax,%rax
	movq _base(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L438
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl _nstates(%rip),%eax
	movl $10,%ebx
	leal 1(,%rax,2),%r12d
	jmp L439
L440:
	cmpl $10,%ebx
	jl L444
L443:
	cmpb $0,_rflag(%rip)
	jnz L448
L446:
	incl _outline(%rip)
L448:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L450
L449:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L451
L450:
	movl $10,%edi
	call ___flushbuf
L451:
	movl $1,%ebx
	jmp L445
L444:
	incl %ebx
L445:
	movslq %r12d,%r12
	movq _base(%rip),%rax
	movswl (%rax,%r12,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %r12d
L439:
	movl _nvectors(%rip),%eax
	decl %eax
	cmpl %eax,%r12d
	jl L440
L442:
	cmpb $0,_rflag(%rip)
	jnz L454
L452:
	addl $2,_outline(%rip)
L454:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _base(%rip),%rdi
	call _free
L403:
	popq %r12
	popq %rbx
	ret 


_output_table:
L456:
	pushq %rbx
	pushq %r12
L457:
	incl _outline(%rip)
	movq _code_file(%rip),%rcx
	movl _high(%rip),%eax
	pushq %rax
	pushq $L459
	pushq %rcx
	call _fprintf
	addq $24,%rsp
	movq _table(%rip),%rax
	movswl (%rax),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L460
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $1,%ebx
	jmp L461
L462:
	cmpl $10,%r12d
	jl L466
L465:
	cmpb $0,_rflag(%rip)
	jnz L470
L468:
	incl _outline(%rip)
L470:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L472
L471:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L473
L472:
	movl $10,%edi
	call ___flushbuf
L473:
	movl $1,%r12d
	jmp L467
L466:
	incl %r12d
L467:
	movq _table(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
L461:
	cmpl %ebx,_high(%rip)
	jge L462
L464:
	cmpb $0,_rflag(%rip)
	jnz L476
L474:
	addl $2,_outline(%rip)
L476:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _table(%rip),%rdi
	call _free
L458:
	popq %r12
	popq %rbx
	ret 


_output_check:
L477:
	pushq %rbx
	pushq %r12
L478:
	movq _check(%rip),%rax
	movswl (%rax),%eax
	pushq %rax
	pushq _symbol_prefix(%rip)
	pushq $L480
	pushq _output_file(%rip)
	call _fprintf
	addq $32,%rsp
	movl $10,%r12d
	movl $1,%ebx
	jmp L481
L482:
	cmpl $10,%r12d
	jl L486
L485:
	cmpb $0,_rflag(%rip)
	jnz L490
L488:
	incl _outline(%rip)
L490:
	movq _output_file(%rip),%rcx
	decl (%rcx)
	movq _output_file(%rip),%rsi
	js L492
L491:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L493
L492:
	movl $10,%edi
	call ___flushbuf
L493:
	movl $1,%r12d
	jmp L487
L486:
	incl %r12d
L487:
	movq _check(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq $L50
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	incl %ebx
L481:
	cmpl _high(%rip),%ebx
	jle L482
L484:
	cmpb $0,_rflag(%rip)
	jnz L496
L494:
	addl $2,_outline(%rip)
L496:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _check(%rip),%rdi
	call _free
L479:
	popq %r12
	popq %rbx
	ret 


_output_actions:
L497:
L498:
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
L499:
	ret 


_is_C_identifier:
L500:
L501:
	movsbl (%rdi),%eax
	cmpl $34,%eax
	jz L503
L505:
	movslq %eax,%rax
	testb $3,___ctype+1(%rax)
	jnz L546
L541:
	cmpl $95,%eax
	jz L546
L537:
	cmpl $36,%eax
	jnz L562
L546:
	leaq 1(%rdi),%rcx
	movsbl 1(%rdi),%eax
	movq %rcx,%rdi
	testl %eax,%eax
	jz L563
L547:
	movslq %eax,%rax
	testb $7,___ctype+1(%rax)
	jnz L546
L556:
	cmpl $95,%eax
	jz L546
L552:
	cmpl $36,%eax
	jz L546
	jnz L562
L503:
	leaq 1(%rdi),%rdx
	movsbl 1(%rdi),%eax
	movslq %eax,%rax
	testb $3,___ctype+1(%rax)
	jnz L518
L513:
	cmpl $95,%eax
	jz L518
L509:
	cmpl $36,%eax
	jnz L562
L518:
	leaq 1(%rdx),%rcx
	movsbl 1(%rdx),%eax
	movq %rcx,%rdx
	cmpl $34,%eax
	jz L563
L519:
	movslq %eax,%rax
	testb $7,___ctype+1(%rax)
	jnz L518
L528:
	cmpl $95,%eax
	jz L518
L524:
	cmpl $36,%eax
	jz L518
	jnz L562
L563:
	movl $1,%eax
	ret
L562:
	xorl %eax,%eax
L502:
	ret 


_output_defines:
L564:
	pushq %rbx
	pushq %r12
	pushq %r13
L565:
	movl $2,%ebx
	jmp L567
L568:
	movl %ebx,%ecx
	movq _symbol_name(%rip),%rax
	movq (%rax,%rcx,8),%r13
	movq %r13,%rdi
	call _is_C_identifier
	testl %eax,%eax
	jz L573
L571:
	pushq $L574
	pushq _code_file(%rip)
	call _fprintf
	addq $16,%rsp
	cmpb $0,_dflag(%rip)
	jz L577
L575:
	pushq $L574
	pushq _defines_file(%rip)
	call _fprintf
	addq $16,%rsp
L577:
	movsbl (%r13),%r12d
	cmpl $34,%r12d
	jnz L593
L581:
	leaq 1(%r13),%rax
	movsbl 1(%r13),%r12d
	movq %rax,%r13
	cmpl $34,%r12d
	jz L580
L582:
	movq _code_file(%rip),%rcx
	decl (%rcx)
	movq _code_file(%rip),%rsi
	js L585
L584:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L586
L585:
	movl %r12d,%edi
	call ___flushbuf
L586:
	cmpb $0,_dflag(%rip)
	jz L581
L587:
	movq _defines_file(%rip),%rcx
	decl (%rcx)
	movq _defines_file(%rip),%rsi
	js L591
L590:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L581
L591:
	movl %r12d,%edi
	call ___flushbuf
	jmp L581
L593:
	movq _code_file(%rip),%rcx
	decl (%rcx)
	movq _code_file(%rip),%rsi
	js L597
L596:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L598
L597:
	movl %r12d,%edi
	call ___flushbuf
L598:
	cmpb $0,_dflag(%rip)
	jz L601
L599:
	movq _defines_file(%rip),%rcx
	decl (%rcx)
	movq _defines_file(%rip),%rsi
	js L603
L602:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r12b,(%rcx)
	jmp L601
L603:
	movl %r12d,%edi
	call ___flushbuf
L601:
	leaq 1(%r13),%rax
	movsbl 1(%r13),%r12d
	movq %rax,%r13
	testl %r12d,%r12d
	jnz L593
L580:
	incl _outline(%rip)
	movl %ebx,%ebx
	movq _symbol_value(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq $L605
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	cmpb $0,_dflag(%rip)
	jz L573
L606:
	movq _symbol_value(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq $L605
	pushq _defines_file(%rip)
	call _fprintf
	addq $24,%rsp
L573:
	incl %ebx
L567:
	cmpl _ntokens(%rip),%ebx
	jl L568
L570:
	incl _outline(%rip)
	movq _symbol_value(%rip),%rax
	movswl 2(%rax),%eax
	pushq %rax
	pushq $L609
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	cmpb $0,_dflag(%rip)
	jz L566
L613:
	cmpb $0,_unionized(%rip)
	jz L566
L610:
	movq _union_file(%rip),%rdi
	call _fclose
	movl $L617,%esi
	movq _union_file_name(%rip),%rdi
	call _fopen
	movq %rax,_union_file(%rip)
	testq %rax,%rax
	jnz L621
L618:
	movq _union_file_name(%rip),%rdi
	call _open_error
L621:
	movq _union_file(%rip),%rcx
	decl (%rcx)
	movq _union_file(%rip),%rdi
	js L625
L624:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%eax
	jmp L626
L625:
	call ___fillbuf
L626:
	movq _defines_file(%rip),%rcx
	cmpl $-1,%eax
	jz L623
L622:
	decl (%rcx)
	movq _defines_file(%rip),%rsi
	js L628
L627:
	movq 24(%rsi),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rsi)
	movb %al,(%rdx)
	jmp L621
L628:
	movl %eax,%edi
	call ___flushbuf
	jmp L621
L623:
	pushq _symbol_prefix(%rip)
	pushq $L630
	pushq %rcx
	call _fprintf
	addq $24,%rsp
L566:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_output_stored_text:
L631:
	pushq %rbx
	pushq %r12
L632:
	movq _text_file(%rip),%rdi
	call _fclose
	movl $L617,%esi
	movq _text_file_name(%rip),%rdi
	call _fopen
	movq %rax,_text_file(%rip)
	testq %rax,%rax
	jnz L636
L634:
	movq _text_file_name(%rip),%rdi
	call _open_error
L636:
	movq _text_file(%rip),%r12
	decl (%r12)
	js L641
L640:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%edi
	jmp L642
L641:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%edi
L642:
	cmpl $-1,%edi
	jz L633
L639:
	movq _code_file(%rip),%rbx
	cmpl $10,%edi
	jnz L646
L644:
	incl _outline(%rip)
L646:
	decl (%rbx)
	js L648
L647:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %dil,(%rcx)
	jmp L650
L648:
	movq %rbx,%rsi
L665:
	call ___flushbuf
L650:
	decl (%r12)
	js L654
L653:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%eax
	jmp L655
L654:
	movq %r12,%rdi
	call ___fillbuf
L655:
	cmpl $-1,%eax
	jz L652
L651:
	cmpl $10,%eax
	jnz L658
L656:
	incl _outline(%rip)
L658:
	decl (%rbx)
	js L660
L659:
	movq 24(%rbx),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rbx)
	movb %al,(%rdx)
	jmp L650
L660:
	movq %rbx,%rsi
	movl %eax,%edi
	jmp L665
L652:
	cmpb $0,_lflag(%rip)
	jnz L633
L662:
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
L633:
	popq %r12
	popq %rbx
	ret 


_output_debug:
L666:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L667:
	incl _outline(%rip)
	movswl _final_state(%rip),%eax
	pushq %rax
	pushq $L669
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	addl $3,_outline(%rip)
	movsbl _tflag(%rip),%eax
	pushq %rax
	pushq $L670
	pushq _code_file(%rip)
	call _fprintf
	addq $24,%rsp
	cmpb $0,_rflag(%rip)
	jz L673
L671:
	movsbl _tflag(%rip),%eax
	pushq %rax
	pushq $L670
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
L673:
	movl $0,-4(%rbp)
	movl $2,%edx
	jmp L674
L675:
	movq _symbol_value(%rip),%rax
	movswl (%rax,%rdx,2),%ecx
	movl -4(%rbp),%eax
	cmpl %ecx,%eax
	cmovll %ecx,%eax
	movl %eax,-4(%rbp)
	incl %edx
L674:
	cmpl _ntokens(%rip),%edx
	jl L675
L677:
	incl _outline(%rip)
	movl -4(%rbp),%eax
	pushq %rax
	pushq $L681
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
	jnz L684
L682:
	call _no_space
L684:
	xorl %eax,%eax
	jmp L685
L686:
	movq $0,(%r14,%rax,8)
	incl %eax
L685:
	cmpl %eax,-4(%rbp)
	jg L686
L688:
	movl _ntokens(%rip),%edx
	decl %edx
	jmp L689
L690:
	movslq %edx,%rdx
	movq _symbol_name(%rip),%rax
	movq (%rax,%rdx,8),%rcx
	movq _symbol_value(%rip),%rax
	movswq (%rax,%rdx,2),%rax
	movq %rcx,(%r14,%rax,8)
	decl %edx
L689:
	cmpl $2,%edx
	jge L690
L692:
	movq $L693,(%r14)
	cmpb $0,_rflag(%rip)
	jnz L696
L694:
	incl _outline(%rip)
L696:
	pushq _symbol_prefix(%rip)
	pushq $L697
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl $80,%r13d
	xorl %r15d,%r15d
	jmp L698
L699:
	movl %r15d,%eax
	movq (%r14,%rax,8),%rcx
	movq %rcx,%r12
	testq %rcx,%rcx
	jz L703
L702:
	movb (%rcx),%al
	cmpb $34,%al
	jnz L706
L705:
	movl $7,%ebx
L708:
	leaq 1(%r12),%rdx
	movb 1(%r12),%al
	movq %rdx,%r12
	cmpb $34,%al
	jz L710
L709:
	leal 1(%rbx),%ecx
	movl %ecx,%ebx
	cmpb $92,%al
	jnz L708
L711:
	leal 2(%rcx),%eax
	movl %eax,%ebx
	leaq 1(%rdx),%rax
	movq %rax,%r12
	cmpb $92,1(%rdx)
	jnz L708
L714:
	addl $3,%ecx
	movl %ecx,%ebx
	jmp L708
L710:
	leal (%rbx,%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L719
L717:
	cmpb $0,_rflag(%rip)
	jnz L722
L720:
	incl _outline(%rip)
L722:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L724
L723:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L725
L724:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L725:
	movl %ebx,%r13d
L719:
	pushq $L726
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movl %r15d,%eax
	movq (%r14,%rax,8),%r12
L727:
	leaq 1(%r12),%rbx
	movb 1(%r12),%cl
	movq %rbx,%r12
	movq _output_file(%rip),%rax
	cmpb $34,%cl
	jz L729
L728:
	cmpb $92,%cl
	jnz L731
L730:
	pushq $L733
	pushq %rax
	call _fprintf
	addq $16,%rsp
	leaq 1(%rbx),%rax
	movb 1(%rbx),%cl
	movq %rax,%r12
	movq _output_file(%rip),%rax
	cmpb $92,%cl
	jnz L735
L734:
	pushq $L733
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L727
L735:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L738
L737:
	movb 1(%rbx),%sil
	jmp L905
L738:
	movsbl 1(%rbx),%ecx
	jmp L906
L731:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L741
L740:
	movb (%rbx),%sil
L905:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L727
L741:
	movsbl (%rbx),%ecx
L906:
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
	jmp L727
L729:
	pushq $L743
	jmp L902
L706:
	cmpb $39,%al
	jnz L745
L744:
	cmpb $34,1(%rcx)
	jnz L748
L747:
	leal 7(%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L752
L750:
	cmpb $0,_rflag(%rip)
	jnz L755
L753:
	incl _outline(%rip)
L755:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L757
L756:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L758
L757:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L758:
	movl $7,%r13d
L752:
	movq _output_file(%rip),%rax
	pushq $L759
	jmp L902
L748:
	movl $5,%ebx
L760:
	leaq 1(%r12),%rdx
	movb 1(%r12),%al
	movq %rdx,%r12
	cmpb $39,%al
	jz L762
L761:
	leal 1(%rbx),%ecx
	movl %ecx,%ebx
	cmpb $92,%al
	jnz L760
L763:
	leal 2(%rcx),%eax
	movl %eax,%ebx
	leaq 1(%rdx),%rax
	movq %rax,%r12
	cmpb $92,1(%rdx)
	jnz L760
L766:
	addl $3,%ecx
	movl %ecx,%ebx
	jmp L760
L762:
	leal (%rbx,%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L771
L769:
	cmpb $0,_rflag(%rip)
	jnz L774
L772:
	incl _outline(%rip)
L774:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L776
L775:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L777
L776:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L777:
	movl %ebx,%r13d
L771:
	pushq $L778
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movl %r15d,%eax
	movq (%r14,%rax,8),%r12
L779:
	leaq 1(%r12),%rbx
	movb 1(%r12),%cl
	movq %rbx,%r12
	movq _output_file(%rip),%rax
	cmpb $39,%cl
	jz L781
L780:
	cmpb $92,%cl
	jnz L783
L782:
	pushq $L733
	pushq %rax
	call _fprintf
	addq $16,%rsp
	leaq 1(%rbx),%rax
	movb 1(%rbx),%cl
	movq %rax,%r12
	movq _output_file(%rip),%rax
	cmpb $92,%cl
	jnz L786
L785:
	pushq $L733
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L779
L786:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L789
L788:
	movb 1(%rbx),%sil
	jmp L903
L789:
	movsbl 1(%rbx),%ecx
	jmp L904
L783:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L792
L791:
	movb (%rbx),%sil
L903:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L779
L792:
	movsbl (%rbx),%ecx
L904:
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
	jmp L779
L781:
	pushq $L794
	jmp L902
L745:
	movq %rcx,%rdi
	call _strlen
	leal 3(%rax),%ebx
	leal 3(%rax,%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L797
L795:
	cmpb $0,_rflag(%rip)
	jnz L800
L798:
	incl _outline(%rip)
L800:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L802
L801:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L803
L802:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L803:
	movl %ebx,%r13d
L797:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L805
L804:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $34,(%rdx)
	jmp L807
L805:
	movq %rax,%rsi
	movl $34,%edi
	call ___flushbuf
L807:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L811
L810:
	movb (%r12),%sil
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L812
L811:
	movsbl (%r12),%ecx
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
L812:
	leaq 1(%r12),%rcx
	movb 1(%r12),%al
	movq %rcx,%r12
	testb %al,%al
	jnz L807
L808:
	movq _output_file(%rip),%rax
	pushq $L813
	jmp L902
L703:
	leal 2(%r13),%eax
	movl %eax,%r13d
	cmpl $80,%eax
	jle L816
L814:
	cmpb $0,_rflag(%rip)
	jnz L819
L817:
	incl _outline(%rip)
L819:
	movq _output_file(%rip),%rax
	decl (%rax)
	movq _output_file(%rip),%rax
	js L821
L820:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $10,(%rdx)
	jmp L822
L821:
	movq %rax,%rsi
	movl $10,%edi
	call ___flushbuf
L822:
	movl $2,%r13d
L816:
	movq _output_file(%rip),%rax
	pushq $L823
L902:
	pushq %rax
	call _fprintf
	addq $16,%rsp
	leal 1(%r15),%eax
	movl %eax,%r15d
L698:
	cmpl %r15d,-4(%rbp)
	jge L699
L701:
	cmpb $0,_rflag(%rip)
	jnz L826
L824:
	addl $2,_outline(%rip)
L826:
	pushq $L54
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq %r14,%rdi
	call _free
	cmpb $0,_rflag(%rip)
	jnz L829
L827:
	incl _outline(%rip)
L829:
	pushq _symbol_prefix(%rip)
	pushq $L830
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl $2,%r12d
	jmp L831
L832:
	movq _rlhs(%rip),%rax
	movswq (%rax,%r12,2),%rax
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rax,8)
	pushq $L835
	pushq _output_file(%rip)
	call _fprintf
	addq $24,%rsp
	movq _rrhs(%rip),%rax
	movswl (%rax,%r12,2),%ebx
L836:
	movslq %ebx,%rbx
	movq _ritem(%rip),%rax
	movw (%rax,%rbx,2),%ax
	cmpw $0,%ax
	jle L839
L837:
	movswq %ax,%rax
	movq _symbol_name(%rip),%rcx
	movq (%rcx,%rax,8),%r13
	movb (%r13),%cl
	movq _output_file(%rip),%rax
	cmpb $34,%cl
	jnz L841
L840:
	pushq $L843
L901:
	pushq %rax
	call _fprintf
	addq $16,%rsp
L844:
	leaq 1(%r13),%rdx
	movb 1(%r13),%cl
	movq %rdx,%r13
	movq _output_file(%rip),%rax
	cmpb $34,%cl
	jz L846
L845:
	cmpb $92,%cl
	jnz L848
L847:
	leaq 1(%rdx),%r13
	movb 1(%rdx),%cl
	cmpb $92,%cl
	jz L850
L851:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L854
	pushq %rax
	call _fprintf
	addq $24,%rsp
	jmp L844
L850:
	pushq $L853
	jmp L901
L848:
	decl (%rax)
	movq _output_file(%rip),%rax
	js L856
L855:
	movb (%rdx),%sil
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L844
L856:
	movsbl (%rdx),%ecx
	movq %rax,%rsi
	movl %ecx,%edi
	call ___flushbuf
	jmp L844
L846:
	pushq $L858
	jmp L900
L841:
	cmpb $39,%cl
	jnz L860
L859:
	movb 1(%r13),%cl
	cmpb $34,%cl
	jnz L863
L862:
	pushq $L865
L900:
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L842
L863:
	cmpb $92,%cl
	jnz L867
L866:
	leaq 2(%r13),%r14
	movb 2(%r13),%cl
	cmpb $92,%cl
	jnz L870
L869:
	pushq $L872
	pushq %rax
	call _fprintf
	addq $16,%rsp
	jmp L874
L870:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L873
	pushq %rax
	call _fprintf
	addq $24,%rsp
L874:
	leaq 1(%r14),%rsi
	movb 1(%r14),%dl
	movq %rsi,%r14
	movq _output_file(%rip),%rcx
	movl (%rcx),%eax
	decl %eax
	cmpb $39,%dl
	jz L876
L875:
	movl %eax,(%rcx)
	movq _output_file(%rip),%rcx
	cmpl $0,%eax
	jl L878
L877:
	movb (%rsi),%sil
	movq 24(%rcx),%rdx
	leaq 1(%rdx),%rax
	movq %rax,24(%rcx)
	movb %sil,(%rdx)
	jmp L874
L878:
	movsbl (%rsi),%eax
	movq %rcx,%rsi
	movl %eax,%edi
	call ___flushbuf
	jmp L874
L876:
	movl %eax,(%rcx)
	movq _output_file(%rip),%rcx
	cmpl $0,%eax
	jl L881
L880:
	movq 24(%rcx),%rdx
	leaq 1(%rdx),%rax
	movq %rax,24(%rcx)
	movb $39,(%rdx)
	jmp L842
L881:
	movq %rcx,%rsi
	movl $39,%edi
	call ___flushbuf
	jmp L842
L867:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L883
	jmp L894
L860:
	pushq %r13
	pushq $L884
L894:
	pushq %rax
	call _fprintf
	addq $24,%rsp
L842:
	incl %ebx
	jmp L836
L839:
	cmpb $0,_rflag(%rip)
	jnz L887
L885:
	incl _outline(%rip)
L887:
	pushq $L888
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
	incl %r12d
L831:
	cmpl _nrules(%rip),%r12d
	jl L832
L834:
	cmpb $0,_rflag(%rip)
	jnz L891
L889:
	addl $2,_outline(%rip)
L891:
	pushq $L892
	pushq _output_file(%rip)
	call _fprintf
	addq $16,%rsp
L668:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_output_stype:
L907:
L908:
	cmpb $0,_unionized(%rip)
	jnz L909
L913:
	cmpl $0,_ntags(%rip)
	jnz L909
L910:
	addl $3,_outline(%rip)
	pushq $L917
	pushq _code_file(%rip)
	call _fprintf
	addq $16,%rsp
L909:
	ret 


_output_trailing_text:
L918:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L919:
	cmpq $0,_line(%rip)
	jz L920
L923:
	movq _input_file(%rip),%r12
	movq _code_file(%rip),%rbx
	movq _cptr(%rip),%rax
	movsbl (%rax),%r13d
	cmpl $10,%r13d
	jnz L926
L925:
	incl _lineno(%rip)
	decl (%r12)
	js L932
L931:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%r14d
	jmp L933
L932:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%r14d
L933:
	cmpl $-1,%r14d
	jz L920
L930:
	cmpb $0,_lflag(%rip)
	jnz L937
L935:
	incl _outline(%rip)
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq %rbx
	call _fprintf
	addq $32,%rsp
L937:
	cmpl $10,%r14d
	jnz L940
L938:
	incl _outline(%rip)
L940:
	decl (%rbx)
	js L942
L941:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %r14b,(%rcx)
	jmp L956
L942:
	movq %rbx,%rsi
	movl %r14d,%edi
	call ___flushbuf
	jmp L956
L926:
	cmpb $0,_lflag(%rip)
	jnz L947
L944:
	incl _outline(%rip)
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq %rbx
	call _fprintf
	addq $32,%rsp
L947:
	decl (%rbx)
	js L951
L950:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %r13b,(%rcx)
	jmp L952
L951:
	movq %rbx,%rsi
	movl %r13d,%edi
	call ___flushbuf
L952:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%r13d
	cmpl $10,%r13d
	jnz L947
L948:
	incl _outline(%rip)
	decl (%rbx)
	js L954
L953:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $10,(%rcx)
	jmp L955
L954:
	movq %rbx,%rsi
	movl $10,%edi
	call ___flushbuf
L955:
	movl $10,%r14d
L956:
	decl (%r12)
	js L960
L959:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%r13d
	jmp L961
L960:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%r13d
L961:
	cmpl $-1,%r13d
	jz L958
L957:
	cmpl $10,%r13d
	jnz L964
L962:
	incl _outline(%rip)
L964:
	decl (%rbx)
	js L966
L965:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %r13b,(%rcx)
	jmp L967
L966:
	movq %rbx,%rsi
	movl %r13d,%edi
	call ___flushbuf
L967:
	movl %r13d,%r14d
	jmp L956
L958:
	cmpl $10,%r14d
	jz L970
L968:
	incl _outline(%rip)
	decl (%rbx)
	js L972
L971:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $10,(%rcx)
	jmp L970
L972:
	movq %rbx,%rsi
	movl $10,%edi
	call ___flushbuf
L970:
	cmpb $0,_lflag(%rip)
	jnz L920
L974:
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
L920:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_output_semantic_actions:
L977:
	pushq %rbx
	pushq %r12
	pushq %r13
L978:
	movq _action_file(%rip),%rdi
	call _fclose
	movl $L617,%esi
	movq _action_file_name(%rip),%rdi
	call _fopen
	movq %rax,_action_file(%rip)
	testq %rax,%rax
	jnz L982
L980:
	movq _action_file_name(%rip),%rdi
	call _open_error
L982:
	movq _action_file(%rip),%rcx
	decl (%rcx)
	movq _action_file(%rip),%rdi
	js L987
L986:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%edi
	jmp L988
L987:
	call ___fillbuf
	movl %eax,%edi
L988:
	cmpl $-1,%edi
	jz L979
L985:
	movq _code_file(%rip),%r13
	movl %edi,%r12d
	cmpl $10,%edi
	jnz L992
L990:
	incl _outline(%rip)
L992:
	decl (%r13)
	js L994
L993:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb %dil,(%rcx)
	jmp L996
L994:
	movq %r13,%rsi
	call ___flushbuf
L996:
	movq _action_file(%rip),%rcx
	decl (%rcx)
	movq _action_file(%rip),%rdi
	js L1000
L999:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%ebx
	jmp L1001
L1000:
	call ___fillbuf
	movl %eax,%ebx
L1001:
	cmpl $-1,%ebx
	jz L998
L997:
	cmpl $10,%ebx
	jnz L1004
L1002:
	incl _outline(%rip)
L1004:
	decl (%r13)
	js L1006
L1005:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb %bl,(%rcx)
	jmp L1007
L1006:
	movq %r13,%rsi
	movl %ebx,%edi
	call ___flushbuf
L1007:
	movl %ebx,%r12d
	jmp L996
L998:
	cmpl $10,%r12d
	jz L1010
L1008:
	incl _outline(%rip)
	decl (%r13)
	js L1012
L1011:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb $10,(%rcx)
	jmp L1010
L1012:
	movq %r13,%rsi
	movl $10,%edi
	call ___flushbuf
L1010:
	cmpb $0,_lflag(%rip)
	jnz L979
L1014:
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
L979:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_free_itemsets:
L1017:
	pushq %rbx
L1018:
	movq _state_table(%rip),%rdi
	call _free
	movq _first_state(%rip),%rdi
	jmp L1020
L1021:
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rdi
L1020:
	testq %rdi,%rdi
	jnz L1021
L1019:
	popq %rbx
	ret 


_free_shifts:
L1024:
	pushq %rbx
L1025:
	movq _shift_table(%rip),%rdi
	call _free
	movq _first_shift(%rip),%rdi
	jmp L1027
L1028:
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rdi
L1027:
	testq %rdi,%rdi
	jnz L1028
L1026:
	popq %rbx
	ret 


_free_reductions:
L1031:
	pushq %rbx
L1032:
	movq _reduction_table(%rip),%rdi
	call _free
	movq _first_reduction(%rip),%rdi
	jmp L1034
L1035:
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rdi
L1034:
	testq %rdi,%rdi
	jnz L1035
L1033:
	popq %rbx
	ret 


_output:
L1038:
L1039:
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
	jz L1043
L1041:
	movl $_tables,%edi
	call _write_section
L1043:
	movl $_header,%edi
	call _write_section
	call _output_trailing_text
	movl $_body,%edi
	call _write_section
	call _output_semantic_actions
	movl $_trailer,%edi
	call _write_section
L1040:
	ret 

L29:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,99,104,101,99,107,32
	.byte 37,115,99,104,101,99,107,10
	.byte 0
L609:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,69,82,82,67,79,68
	.byte 69,32,37,100,10,0
L480:
	.byte 115,104,111,114,116,32,37,115
	.byte 99,104,101,99,107,91,93,32
	.byte 61,32,123,37,52,48,100,44
	.byte 0
L630:
	.byte 32,89,89,83,84,89,80,69
	.byte 59,10,101,120,116,101,114,110
	.byte 32,89,89,83,84,89,80,69
	.byte 32,37,115,108,118,97,108,59
	.byte 10,0
L778:
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
L209:
	.byte 115,104,111,114,116,32,37,115
	.byte 100,103,111,116,111,91,93,32
	.byte 61,32,123,37,52,48,100,44
	.byte 0
L830:
	.byte 99,104,97,114,32,42,37,115
	.byte 114,117,108,101,91,93,32,61
	.byte 32,123,10,0
L858:
	.byte 92,34,0
L681:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,77,65,88,84,79,75
	.byte 69,78,32,37,100,10,0
L50:
	.byte 37,53,100,44,0
L574:
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
L813:
	.byte 34,44,0
L733:
	.byte 92,92,0
L669:
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
L888:
	.byte 34,44,10,0
L335:
	.byte 109,97,120,105,109,117,109,32
	.byte 116,97,98,108,101,32,115,105
	.byte 122,101,32,101,120,99,101,101
	.byte 100,101,100,0
L884:
	.byte 32,37,115,0
L670:
	.byte 35,105,102,110,100,101,102,32
	.byte 89,89,68,69,66,85,71,10
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,68,69,66,85,71,32
	.byte 37,100,10,35,101,110,100,105
	.byte 102,10,0
L459:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,84,65,66,76,69,83
	.byte 73,90,69,32,37,100,10,0
L304:
	.byte 116,0
L835:
	.byte 34,37,115,32,58,0
L404:
	.byte 115,104,111,114,116,32,37,115
	.byte 115,105,110,100,101,120,91,93
	.byte 32,61,32,123,37,51,57,100
	.byte 44,0
L24:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,100,103,111,116,111,32
	.byte 37,115,100,103,111,116,111,10
	.byte 0
L693:
	.byte 101,110,100,45,111,102,45,102
	.byte 105,108,101,0
L7:
	.byte 121,121,0
L823:
	.byte 48,44,0
L20:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,118,115,112,32,37,115
	.byte 118,115,112,10,0
L853:
	.byte 92,92,92,92,0
L873:
	.byte 32,39,92,92,37,99,0
L31:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,114,117,108,101,32,37
	.byte 115,114,117,108,101,10,0
L865:
	.byte 32,39,92,34,39,0
L438:
	.byte 10,125,59,10,115,104,111,114
	.byte 116,32,37,115,103,105,110,100
	.byte 101,120,91,93,32,61,32,123
	.byte 37,51,57,100,44,0
L55:
	.byte 115,104,111,114,116,32,37,115
	.byte 108,101,110,91,93,32,61,32
	.byte 123,37,52,50,100,44,0
L421:
	.byte 10,125,59,10,115,104,111,114
	.byte 116,32,37,115,114,105,110,100
	.byte 101,120,91,93,32,61,32,123
	.byte 37,51,57,100,44,0
L843:
	.byte 32,92,34,0
L759:
	.byte 34,39,92,34,39,34,44,0
L16:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,101,114,114,102,108,97
	.byte 103,32,37,115,101,114,114,102
	.byte 108,97,103,10,0
L460:
	.byte 115,104,111,114,116,32,37,115
	.byte 116,97,98,108,101,91,93,32
	.byte 61,32,123,37,52,48,100,44
	.byte 0
L15:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,110,101,114,114,115,32
	.byte 37,115,110,101,114,114,115,10
	.byte 0
L617:
	.byte 114,0
L726:
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
L872:
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
L854:
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
L892:
	.byte 125,59,10,35,101,110,100,105
	.byte 102,10,0
L8:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,112,97,114,115,101,32
	.byte 37,115,112,97,114,115,101,10
	.byte 0
L305:
	.byte 111,117,116,112,117,116,46,99
	.byte 0
L32:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,80,82,69,70,73,88
	.byte 32,34,37,115,34,10,0
L54:
	.byte 10,125,59,10,0
L605:
	.byte 32,37,100,10,0
L10:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,101,114,114,111,114,32
	.byte 37,115,101,114,114,111,114,10
	.byte 0
L794:
	.byte 39,34,44,0
L9:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,108,101,120,32,37,115
	.byte 108,101,120,10,0
L697:
	.byte 35,105,102,32,89,89,68,69
	.byte 66,85,71,10,99,104,97,114
	.byte 32,42,37,115,110,97,109,101
	.byte 91,93,32,61,32,123,0
L17:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,115,115,32,37,115,115
	.byte 115,10,0
L917:
	.byte 35,105,102,110,100,101,102,32
	.byte 89,89,83,84,89,80,69,10
	.byte 116,121,112,101,100,101,102,32
	.byte 105,110,116,32,89,89,83,84
	.byte 89,80,69,59,10,35,101,110
	.byte 100,105,102,10,0
L743:
	.byte 92,34,34,44,0
L883:
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
