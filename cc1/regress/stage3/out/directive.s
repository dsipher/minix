.data
_directives:
	.byte 100,101,102,105,110,101,0,0
	.byte 101,108,105,102,0,0,0,0
	.byte 101,108,115,101,0,0,0,0
	.byte 101,110,100,105,102,0,0,0
	.byte 101,114,114,111,114,0,0,0
	.byte 105,102,0,0,0,0,0,0
	.byte 105,102,100,101,102,0,0,0
	.byte 105,102,110,100,101,102,0,0
	.byte 105,110,99,108,117,100,101,0
	.byte 108,105,110,101,0,0,0,0
	.byte 112,114,97,103,109,97,0,0
	.byte 117,110,100,101,102,0,0,0
.text

_lookup:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	cmpl $52,(%r12)
	jnz L6
L4:
	xorl %ebx,%ebx
L8:
	movslq %ebx,%rbx
	testl $1,8(%r12)
	jz L15
L14:
	leaq 9(%r12),%rsi
	jmp L16
L15:
	movq 24(%r12),%rsi
L16:
	leaq _directives(,%rbx,8),%rdi
	call _strcmp
	testl %eax,%eax
	jz L11
L13:
	incl %ebx
	cmpl $12,%ebx
	jl L8
L6:
	movl $-1,%eax
	jmp L3
L11:
	movl %ebx,%eax
L3:
	popq %r12
	popq %rbx
	ret 


_state_push:
L19:
	pushq %rbx
L20:
	movl %edi,%ebx
	movl $16,%edi
	call _safe_malloc
	movq _state_stack(%rip),%rcx
	testq %rcx,%rcx
	jz L22
L25:
	movsbl (%rcx),%ecx
	testl %ecx,%ecx
	jz L23
L22:
	movb %bl,1(%rax)
	movb %bl,(%rax)
	jmp L24
L23:
	movb $0,(%rax)
	movb $1,1(%rax)
L24:
	movb $0,2(%rax)
	movq _state_stack(%rip),%rcx
	movq %rcx,8(%rax)
	movq %rax,_state_stack(%rip)
L21:
	popq %rbx
	ret 


_state_pop:
L31:
L32:
	movq _state_stack(%rip),%rdi
	movq 8(%rdi),%rax
	movq %rax,_state_stack(%rip)
	call _free
L33:
	ret 


_do_ifdef:
L37:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L38:
	movl %edi,%ebx
	movq %rsi,%rdi
	leaq -8(%rbp),%rdx
	movl $52,%esi
	call _list_match
	movq -8(%rbp),%rdi
	addq $8,%rdi
	call _macro_lookup
	testq %rax,%rax
	jz L42
L40:
	testl $1,24(%rax)
	jnz L42
L41:
	movl $1,%edi
	jmp L43
L42:
	xorl %edi,%edi
L43:
	cmpl $6,%ebx
	jz L47
L45:
	testl %edi,%edi
	setz %al
	movzbl %al,%edi
L47:
	call _state_push
	movq -8(%rbp),%rdi
	call _token_free
L39:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_do_if:
L48:
L49:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L51
L54:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L52
L51:
	call _evaluate
	movl %eax,%edi
	jmp L57
L52:
	xorl %edi,%edi
L57:
	call _state_push
L50:
	ret 


_do_elif:
L58:
	pushq %rbx
L59:
	movq %rdi,%rbx
	cmpq $0,_state_stack(%rip)
	jnz L63
L61:
	pushq $L64
	call _error
	addq $8,%rsp
L63:
	movq _state_stack(%rip),%rax
	cmpb $0,2(%rax)
	jz L67
L65:
	pushq $L68
	call _error
	addq $8,%rsp
L67:
	movq _state_stack(%rip),%rax
	cmpb $0,1(%rax)
	jnz L60
L69:
	movq %rbx,%rdi
	call _evaluate
	movq _state_stack(%rip),%rcx
	movb %al,1(%rcx)
	movq _state_stack(%rip),%rcx
	movb 1(%rcx),%al
	movb %al,(%rcx)
L60:
	popq %rbx
	ret 


_do_else:
L72:
L73:
	cmpq $0,_state_stack(%rip)
	jnz L77
L75:
	pushq $L78
	call _error
	addq $8,%rsp
L77:
	movq _state_stack(%rip),%rax
	cmpb $0,2(%rax)
	jz L81
L79:
	pushq $L82
	call _error
	addq $8,%rsp
L81:
	movq _state_stack(%rip),%rcx
	cmpb $0,1(%rcx)
	setz %al
	movzbl %al,%eax
	movb %al,(%rcx)
	movq _state_stack(%rip),%rax
	movb $1,2(%rax)
L74:
	ret 


_do_endif:
L83:
L84:
	cmpq $0,_state_stack(%rip)
	jnz L88
L86:
	pushq $L89
	call _error
	addq $8,%rsp
L88:
	call _state_pop
L85:
	ret 


_do_line:
L90:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L91:
	movq %rdi,%rbx
	movq $0,-16(%rbp)
	movq %rbx,%rdi
	call _list_strip_all
	leaq -8(%rbp),%rdx
	movl $54,%esi
	movq %rbx,%rdi
	call _list_match
	cmpq $0,(%rbx)
	jz L95
L93:
	leaq -16(%rbp),%rdx
	movl $55,%esi
	movq %rbx,%rdi
	call _list_match
L95:
	movq -8(%rbp),%rdi
	call _token_convert_number
	movq -8(%rbp),%rax
	movq 8(%rax),%rcx
	movq _input_stack(%rip),%rax
	decl %ecx
	movl %ecx,32(%rax)
	cmpq $0,-16(%rbp)
	jz L98
L96:
	movq _input_stack(%rip),%rdi
	addq $8,%rdi
	call _vstring_clear
	movq _input_stack(%rip),%rdi
	movq -16(%rbp),%rsi
	addq $8,%rsi
	addq $8,%rdi
	call _vstring_concat
	movq -16(%rbp),%rdi
	call _token_free
L98:
	movq -8(%rbp),%rdi
	call _token_free
	movb $1,_need_resync(%rip)
L92:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_do_error:
L99:
L100:
	call _list_stringize
	testl $1,8(%rax)
	jz L104
L103:
	addq $9,%rax
	jmp L105
L104:
	movq 24(%rax),%rax
L105:
	pushq %rax
	pushq $L102
	call _error
	addq $16,%rsp
L101:
	ret 


_do_include:
L106:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L107:
	movq %rdi,%rbx
	xorl %eax,%eax
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl -24(%rbp),%eax
	andl $-2,%eax
	orl $1,%eax
	movl %eax,-24(%rbp)
	movq (%rbx),%rax
	testq %rax,%rax
	jz L118
L116:
	cmpl $55,(%rax)
	jz L111
L118:
	testq %rax,%rax
	jz L122
L120:
	cmpl $536871946,(%rax)
	jz L111
L122:
	movq %rbx,%rdi
	call _macro_replace_all
	movq %rbx,%rdi
	call _list_strip_ends
L111:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L129
L127:
	cmpl $55,(%rax)
	jnz L129
L128:
	leaq -32(%rbp),%rsi
	movq %rbx,%rdi
	call _list_pop
	leaq -24(%rbp),%rsi
	movq -32(%rbp),%rdi
	call _token_dequote
	movq -32(%rbp),%rdi
	call _token_free
	movl $2,%r12d
	jmp L126
L129:
	testq %rax,%rax
	jz L136
L134:
	cmpl $536871946,(%rax)
	jnz L136
L135:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_pop
L138:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L143
L145:
	cmpl $536871944,(%rax)
	jz L143
L147:
	leaq -32(%rbp),%rsi
	movq %rbx,%rdi
	call _list_pop
	leaq -24(%rbp),%rsi
	movq -32(%rbp),%rdi
	call _token_text
	movq -32(%rbp),%rdi
	call _token_free
	jmp L138
L143:
	xorl %edx,%edx
	movl $536871944,%esi
	movq %rbx,%rdi
	call _list_match
	movl $1,%r12d
	jmp L126
L136:
	pushq $L149
	call _error
	addq $8,%rsp
L126:
	testl $1,-24(%rbp)
	jz L151
L150:
	leaq -23(%rbp),%rdi
	jmp L152
L151:
	movq -8(%rbp),%rdi
L152:
	movl %r12d,%esi
	call _input_open
	leaq -24(%rbp),%rdi
	call _vstring_free
L108:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L244:
	.short L203-_directive
	.short L187-_directive
	.short L181-_directive
	.short L183-_directive
	.short L185-_directive
	.short L214-_directive
	.short L179-_directive
	.short L177-_directive
	.short L177-_directive
	.short L174-_directive
	.short L212-_directive
	.short L172-_directive
	.short L195-_directive
	.short L172-_directive

_directive:
L153:
	pushq %rbx
	pushq %r12
	pushq %r13
L154:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	call _list_skip_spaces
	testq %rax,%rax
	jz L169
L159:
	cmpl $1610612748,(%rax)
	jnz L169
L156:
	movq 32(%rax),%rdi
	call _list_skip_spaces
	movq %rax,%r13
	movq %r13,%rdi
	testq %r13,%r13
	jz L164
L163:
	movq %r13,%rdi
	call _lookup
	movl %eax,%r12d
	movq 32(%r13),%rdi
	cmpl $10,%eax
	jnz L168
	jz L169
L164:
	movl $12,%r12d
L168:
	call _list_skip_spaces
	movq %rax,%rsi
	movq %rbx,%rdi
	call _list_cut
	cmpl $-1,%r12d
	jl L172
L243:
	cmpl $12,%r12d
	jg L172
L241:
	leal 1(%r12),%eax
	movzwl L244(,%rax,2),%eax
	addl $_directive,%eax
	jmp *%rax
L195:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L196
L199:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L172
L196:
	movq %rbx,%rdi
	call _macro_undef
	jmp L172
L212:
	movq %rbx,%rdi
	call _do_line
	jmp L172
L174:
	movq %rbx,%rdi
	call _do_include
	jmp L172
L177:
	movq %rbx,%rsi
	movl %r12d,%edi
	call _do_ifdef
	jmp L172
L179:
	movq %rbx,%rdi
	call _do_if
	jmp L172
L214:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L215
L218:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L172
L215:
	movq %rbx,%rdi
	call _do_error
	jmp L172
L185:
	call _do_endif
	jmp L172
L183:
	movq %rbx,%rdi
	call _do_else
	jmp L172
L181:
	movq %rbx,%rdi
	call _do_elif
	jmp L172
L187:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L188
L191:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L172
L188:
	movq %rbx,%rdi
	call _macro_define
	jmp L172
L203:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L204
L207:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L172
L204:
	pushq $L210
	call _error
	addq $8,%rsp
L172:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L227
L231:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L169
L227:
	cmpq $0,(%rbx)
	jz L169
L224:
	pushq $L234
	call _error
	addq $8,%rsp
L169:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L155
L238:
	movsbl (%rax),%eax
	testl %eax,%eax
	jnz L155
L235:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_cut
L155:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_directive_check:
L245:
L246:
	cmpq $0,_state_stack(%rip)
	jz L247
L248:
	pushq $L251
	call _error
	addq $8,%rsp
L247:
	ret 

L89:
	.byte 35,101,110,100,105,102,32,119
	.byte 105,116,104,111,117,116,32,35
	.byte 105,102,0
L210:
	.byte 117,110,107,110,111,119,110,32
	.byte 100,105,114,101,99,116,105,118
	.byte 101,0
L82:
	.byte 100,117,112,108,105,99,97,116
	.byte 101,32,35,101,108,115,101,0
L102:
	.byte 35,101,114,114,111,114,32,100
	.byte 105,114,101,99,116,105,118,101
	.byte 58,32,37,115,0
L149:
	.byte 101,120,112,101,99,116,101,100
	.byte 32,102,105,108,101,32,110,97
	.byte 109,101,32,97,102,116,101,114
	.byte 32,35,105,110,99,108,117,100
	.byte 101,0
L78:
	.byte 35,101,108,115,101,32,119,105
	.byte 116,104,111,117,116,32,35,105
	.byte 102,0
L234:
	.byte 116,114,97,105,108,105,110,103
	.byte 32,103,97,114,98,97,103,101
	.byte 32,97,102,116,101,114,32,100
	.byte 105,114,101,99,116,105,118,101
	.byte 0
L68:
	.byte 35,101,108,105,102,32,97,102
	.byte 116,101,114,32,35,101,108,115
	.byte 101,0
L64:
	.byte 35,101,108,105,102,32,119,105
	.byte 116,104,111,117,116,32,35,105
	.byte 102,0
L251:
	.byte 101,110,100,45,111,102,45,102
	.byte 105,108,101,32,105,110,32,35
	.byte 105,102,47,105,102,100,101,102
	.byte 47,105,102,110,100,101,102,0
.local _state_stack
.comm _state_stack, 8, 8

.globl _free
.globl _token_convert_number
.globl _error
.globl _token_text
.globl _list_stringize
.globl _list_strip_all
.globl _list_pop
.globl _directive_check
.globl _vstring_concat
.globl _safe_malloc
.globl _token_dequote
.globl _directive
.globl _evaluate
.globl _input_open
.globl _list_cut
.globl _strcmp
.globl _macro_undef
.globl _macro_define
.globl _need_resync
.globl _vstring_clear
.globl _macro_replace_all
.globl _token_free
.globl _vstring_free
.globl _macro_lookup
.globl _list_strip_ends
.globl _list_match
.globl _input_stack
.globl _list_skip_spaces
