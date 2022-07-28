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
	movslq %ebx,%rax
	testl $1,8(%r12)
	jz L15
L14:
	leaq 9(%r12),%rsi
	jmp L16
L15:
	movq 24(%r12),%rsi
L16:
	leaq _directives(,%rax,8),%rdi
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
	jnz L45
L44:
	call _state_push
	jmp L46
L45:
	testl %edi,%edi
	setz %dil
	movzbl %dil,%edi
	call _state_push
L46:
	movq -8(%rbp),%rdi
	call _token_free
L39:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_do_if:
L47:
L48:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L50
L53:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L51
L50:
	call _evaluate
	movl %eax,%edi
	call _state_push
	ret
L51:
	xorl %edi,%edi
	call _state_push
L49:
	ret 


_do_elif:
L56:
	pushq %rbx
L57:
	movq %rdi,%rbx
	cmpq $0,_state_stack(%rip)
	jnz L61
L59:
	pushq $L62
	call _error
	addq $8,%rsp
L61:
	movq _state_stack(%rip),%rax
	cmpb $0,2(%rax)
	jz L65
L63:
	pushq $L66
	call _error
	addq $8,%rsp
L65:
	movq _state_stack(%rip),%rax
	cmpb $0,1(%rax)
	jnz L58
L67:
	movq %rbx,%rdi
	call _evaluate
	movq _state_stack(%rip),%rcx
	movb %al,1(%rcx)
	movq _state_stack(%rip),%rcx
	movb 1(%rcx),%al
	movb %al,(%rcx)
L58:
	popq %rbx
	ret 


_do_else:
L70:
L71:
	cmpq $0,_state_stack(%rip)
	jnz L75
L73:
	pushq $L76
	call _error
	addq $8,%rsp
L75:
	movq _state_stack(%rip),%rax
	cmpb $0,2(%rax)
	jz L79
L77:
	pushq $L80
	call _error
	addq $8,%rsp
L79:
	movq _state_stack(%rip),%rcx
	cmpb $0,1(%rcx)
	setz %al
	movzbl %al,%eax
	movb %al,(%rcx)
	movq _state_stack(%rip),%rax
	movb $1,2(%rax)
L72:
	ret 


_do_endif:
L81:
L82:
	cmpq $0,_state_stack(%rip)
	jnz L86
L84:
	pushq $L87
	call _error
	addq $8,%rsp
L86:
	call _state_pop
L83:
	ret 


_do_line:
L88:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L89:
	movq %rdi,%rbx
	movq $0,-16(%rbp)
	movq %rbx,%rdi
	call _list_strip_all
	leaq -8(%rbp),%rdx
	movl $54,%esi
	movq %rbx,%rdi
	call _list_match
	cmpq $0,(%rbx)
	jz L93
L91:
	leaq -16(%rbp),%rdx
	movl $55,%esi
	movq %rbx,%rdi
	call _list_match
L93:
	movq -8(%rbp),%rdi
	call _token_convert_number
	movq -8(%rbp),%rax
	movq 8(%rax),%rcx
	movq _input_stack(%rip),%rax
	decl %ecx
	movl %ecx,32(%rax)
	cmpq $0,-16(%rbp)
	jz L96
L94:
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
L96:
	movq -8(%rbp),%rdi
	call _token_free
	movb $1,_need_resync(%rip)
L90:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_do_error:
L97:
L98:
	call _list_stringize
	testl $1,8(%rax)
	jz L102
L101:
	addq $9,%rax
	jmp L103
L102:
	movq 24(%rax),%rax
L103:
	pushq %rax
	pushq $L100
	call _error
	addq $16,%rsp
L99:
	ret 


_do_include:
L104:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L105:
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
	jz L116
L114:
	cmpl $55,(%rax)
	jz L109
L116:
	testq %rax,%rax
	jz L120
L118:
	cmpl $536871946,(%rax)
	jz L109
L120:
	movq %rbx,%rdi
	call _macro_replace_all
	movq %rbx,%rdi
	call _list_strip_ends
L109:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L127
L125:
	cmpl $55,(%rax)
	jnz L127
L126:
	leaq -32(%rbp),%rsi
	movq %rbx,%rdi
	call _list_pop
	leaq -24(%rbp),%rsi
	movq -32(%rbp),%rdi
	call _token_dequote
	movq -32(%rbp),%rdi
	call _token_free
	movl $2,%r12d
	jmp L124
L127:
	testq %rax,%rax
	jz L134
L132:
	cmpl $536871946,(%rax)
	jnz L134
L133:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_pop
L136:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L141
L143:
	cmpl $536871944,(%rax)
	jz L141
L145:
	leaq -32(%rbp),%rsi
	movq %rbx,%rdi
	call _list_pop
	leaq -24(%rbp),%rsi
	movq -32(%rbp),%rdi
	call _token_text
	movq -32(%rbp),%rdi
	call _token_free
	jmp L136
L141:
	xorl %edx,%edx
	movl $536871944,%esi
	movq %rbx,%rdi
	call _list_match
	movl $1,%r12d
	jmp L124
L134:
	pushq $L147
	call _error
	addq $8,%rsp
L124:
	testl $1,-24(%rbp)
	jz L149
L148:
	leaq -23(%rbp),%rdi
	jmp L150
L149:
	movq -8(%rbp),%rdi
L150:
	movl %r12d,%esi
	call _input_open
	leaq -24(%rbp),%rdi
	call _vstring_free
L106:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L242:
	.short L201-_directive
	.short L185-_directive
	.short L179-_directive
	.short L181-_directive
	.short L183-_directive
	.short L212-_directive
	.short L177-_directive
	.short L175-_directive
	.short L175-_directive
	.short L172-_directive
	.short L210-_directive
	.short L170-_directive
	.short L193-_directive
	.short L170-_directive

_directive:
L151:
	pushq %rbx
	pushq %r12
	pushq %r13
L152:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	call _list_skip_spaces
	testq %rax,%rax
	jz L167
L157:
	cmpl $1610612748,(%rax)
	jnz L167
L154:
	movq 32(%rax),%rdi
	call _list_skip_spaces
	movq %rax,%r13
	movq %r13,%rdi
	testq %r13,%r13
	jz L162
L161:
	movq %r13,%rdi
	call _lookup
	movl %eax,%r12d
	movq 32(%r13),%rdi
	cmpl $10,%eax
	jnz L166
	jz L167
L162:
	movl $12,%r12d
L166:
	call _list_skip_spaces
	movq %rax,%rsi
	movq %rbx,%rdi
	call _list_cut
	cmpl $-1,%r12d
	jl L170
L241:
	cmpl $12,%r12d
	jg L170
L239:
	leal 1(%r12),%eax
	movzwl L242(,%rax,2),%eax
	addl $_directive,%eax
	jmp *%rax
L193:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L194
L197:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L170
L194:
	movq %rbx,%rdi
	call _macro_undef
	jmp L170
L210:
	movq %rbx,%rdi
	call _do_line
	jmp L170
L172:
	movq %rbx,%rdi
	call _do_include
	jmp L170
L175:
	movq %rbx,%rsi
	movl %r12d,%edi
	call _do_ifdef
	jmp L170
L177:
	movq %rbx,%rdi
	call _do_if
	jmp L170
L212:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L213
L216:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L170
L213:
	movq %rbx,%rdi
	call _do_error
	jmp L170
L183:
	call _do_endif
	jmp L170
L181:
	movq %rbx,%rdi
	call _do_else
	jmp L170
L179:
	movq %rbx,%rdi
	call _do_elif
	jmp L170
L185:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L186
L189:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L170
L186:
	movq %rbx,%rdi
	call _macro_define
	jmp L170
L201:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L202
L205:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L170
L202:
	pushq $L208
	call _error
	addq $8,%rsp
L170:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L225
L229:
	movsbl (%rax),%eax
	testl %eax,%eax
	jz L167
L225:
	cmpq $0,(%rbx)
	jz L167
L222:
	pushq $L232
	call _error
	addq $8,%rsp
L167:
	movq _state_stack(%rip),%rax
	testq %rax,%rax
	jz L153
L236:
	movsbl (%rax),%eax
	testl %eax,%eax
	jnz L153
L233:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_cut
L153:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_directive_check:
L243:
L244:
	cmpq $0,_state_stack(%rip)
	jz L245
L246:
	pushq $L249
	call _error
	addq $8,%rsp
L245:
	ret 

L87:
 .byte 35,101,110,100,105,102,32,119
 .byte 105,116,104,111,117,116,32,35
 .byte 105,102,0
L208:
 .byte 117,110,107,110,111,119,110,32
 .byte 100,105,114,101,99,116,105,118
 .byte 101,0
L80:
 .byte 100,117,112,108,105,99,97,116
 .byte 101,32,35,101,108,115,101,0
L100:
 .byte 35,101,114,114,111,114,32,100
 .byte 105,114,101,99,116,105,118,101
 .byte 58,32,37,115,0
L147:
 .byte 101,120,112,101,99,116,101,100
 .byte 32,102,105,108,101,32,110,97
 .byte 109,101,32,97,102,116,101,114
 .byte 32,35,105,110,99,108,117,100
 .byte 101,0
L76:
 .byte 35,101,108,115,101,32,119,105
 .byte 116,104,111,117,116,32,35,105
 .byte 102,0
L232:
 .byte 116,114,97,105,108,105,110,103
 .byte 32,103,97,114,98,97,103,101
 .byte 32,97,102,116,101,114,32,100
 .byte 105,114,101,99,116,105,118,101
 .byte 0
L66:
 .byte 35,101,108,105,102,32,97,102
 .byte 116,101,114,32,35,101,108,115
 .byte 101,0
L62:
 .byte 35,101,108,105,102,32,119,105
 .byte 116,104,111,117,116,32,35,105
 .byte 102,0
L249:
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
