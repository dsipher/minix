.text

_unary:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L6
L4:
	movl (%rdi),%eax
	cmpl $-2147483589,%eax
	jz L3
L36:
	cmpl $-2147483588,%eax
	jz L3
L37:
	cmpl $54,%eax
	jz L30
L38:
	cmpl $56,%eax
	jz L28
L39:
	cmpl $536870926,%eax
	jz L16
L40:
	cmpl $536870927,%eax
	jz L18
L41:
	cmpl $536870958,%eax
	jz L14
L42:
	cmpl $536871424,%eax
	jz L10
L43:
	cmpl $536871425,%eax
	jz L12
L6:
	pushq $L34
	call _error
	addq $8,%rsp
	jmp L3
L12:
	xorl %esi,%esi
	movq %r12,%rdi
	call _list_pop
	movq %r12,%rdi
	call _unary
	movq (%r12),%rax
	negq 8(%rax)
	jmp L3
L10:
	xorl %esi,%esi
	movq %r12,%rdi
	call _list_pop
	movq %r12,%rdi
	call _unary
	jmp L3
L14:
	xorl %esi,%esi
	movq %r12,%rdi
	call _list_pop
	movq %r12,%rdi
	call _unary
	movq (%r12),%rax
	notq 8(%rax)
	jmp L3
L18:
	xorl %esi,%esi
	movq %r12,%rdi
	call _list_pop
	movq %r12,%rdi
	call _expression
	movq (%r12),%rax
	movq 32(%rax),%rbx
	testq %rbx,%rbx
	jz L19
L22:
	cmpl $536870928,(%rbx)
	jz L21
L19:
	pushq $L26
	call _error
	addq $8,%rsp
L21:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _list_drop
	jmp L3
L16:
	xorl %esi,%esi
	movq %r12,%rdi
	call _list_pop
	movq %r12,%rdi
	call _unary
	movq (%r12),%rcx
	cmpq $0,8(%rcx)
	setz %al
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,8(%rcx)
	jmp L3
L28:
	call _token_convert_char
	jmp L3
L30:
	call _token_convert_number
L3:
	popq %r12
	popq %rbx
	ret 

.align 4
L159:
	.int 536871170
	.int 536871171
	.int 536871172
	.int 536871424
	.int 536871425
	.int 536871689
	.int 536871691
	.int 536871944
	.int 536871946
	.int 536871971
	.int 536871973
	.int 536872213
	.int 536872214
	.int 536872453
	.int 536872711
	.int 536872966
	.int 536873247
	.int 536873505
.align 2
L160:
	.short L79-_binary
	.short L103-_binary
	.short L94-_binary
	.short L75-_binary
	.short L77-_binary
	.short L89-_binary
	.short L87-_binary
	.short L117-_binary
	.short L122-_binary
	.short L112-_binary
	.short L127-_binary
	.short L132-_binary
	.short L134-_binary
	.short L81-_binary
	.short L85-_binary
	.short L83-_binary
	.short L136-_binary
	.short L142-_binary

_binary:
L46:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L47:
	movl %edi,%r13d
	movq %rsi,%r12
	testl %r13d,%r13d
	jz L49
L51:
	movq %r12,%rsi
	leal -256(%r13),%edi
	call _binary
L53:
	movq (%r12),%rax
	movq %rax,-8(%rbp)
	movq 32(%rax),%rax
	movq %rax,-16(%rbp)
	testq %rax,%rax
	jz L48
L60:
	movl (%rax),%eax
	andl $3840,%eax
	cmpl %eax,%r13d
	jnz L48
L62:
	leaq -8(%rbp),%rsi
	movq %r12,%rdi
	call _list_pop
	leaq -16(%rbp),%rsi
	movq %r12,%rdi
	call _list_pop
	movq %r12,%rsi
	leal -256(%r13),%edi
	call _binary
	leaq -24(%rbp),%rsi
	movq %r12,%rdi
	call _list_pop
	xorl %edi,%edi
	call _token_int
	movq %rax,%rbx
	movq -8(%rbp),%rax
	cmpl $2147483708,(%rax)
	jz L69
L68:
	movq -24(%rbp),%rax
	cmpl $2147483708,(%rax)
	jnz L67
L69:
	movl $-2147483588,(%rbx)
L67:
	movq -16(%rbp),%rax
	movl (%rax),%ecx
	xorl %eax,%eax
L156:
	cmpl L159(,%rax,4),%ecx
	jz L157
L158:
	incl %eax
	cmpl $18,%eax
	jb L156
	jae L72
L157:
	movzwl L160(,%rax,2),%eax
	addl $_binary,%eax
	jmp *%rax
L142:
	movq -8(%rbp),%rax
	cmpq $0,8(%rax)
	jnz L144
L143:
	movq -24(%rbp),%rax
	cmpq $0,8(%rax)
	jz L145
L144:
	movl $1,%eax
	jmp L163
L145:
	xorl %eax,%eax
	jmp L163
L136:
	movq -8(%rbp),%rax
	cmpq $0,8(%rax)
	jz L139
L137:
	movq -24(%rbp),%rax
	cmpq $0,8(%rax)
	jz L139
L138:
	movl $1,%eax
	jmp L163
L139:
	xorl %eax,%eax
	jmp L163
L83:
	movq -8(%rbp),%rax
	movq 8(%rax),%rcx
	movq -24(%rbp),%rax
	movq 8(%rax),%rax
	orq %rcx,%rax
	jmp L161
L85:
	movq -8(%rbp),%rax
	movq 8(%rax),%rcx
	movq -24(%rbp),%rax
	movq 8(%rax),%rax
	xorq %rcx,%rax
	jmp L161
L81:
	movq -8(%rbp),%rax
	movq 8(%rax),%rcx
	movq -24(%rbp),%rax
	movq 8(%rax),%rax
	andq %rcx,%rax
	jmp L161
L134:
	movq -8(%rbp),%rax
	movq 8(%rax),%rax
	movq -24(%rbp),%rcx
	cmpq 8(%rcx),%rax
	setnz %al
	jmp L164
L132:
	movq -8(%rbp),%rax
	movq 8(%rax),%rax
	movq -24(%rbp),%rcx
	cmpq 8(%rcx),%rax
	setz %al
	jmp L164
L127:
	movl (%rbx),%edx
	movq -8(%rbp),%rcx
	movq -24(%rbp),%rax
	cmpl $2147483708,%edx
	jnz L129
L128:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	setbe %al
	jmp L164
L129:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	setle %al
	jmp L164
L112:
	movl (%rbx),%edx
	movq -8(%rbp),%rcx
	movq -24(%rbp),%rax
	cmpl $2147483708,%edx
	jnz L114
L113:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	setae %al
	jmp L164
L114:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	setge %al
	jmp L164
L122:
	movl (%rbx),%edx
	movq -8(%rbp),%rcx
	movq -24(%rbp),%rax
	cmpl $2147483708,%edx
	jnz L124
L123:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	setb %al
	jmp L164
L124:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	setl %al
	jmp L164
L117:
	movl (%rbx),%edx
	movq -8(%rbp),%rcx
	movq -24(%rbp),%rax
	cmpl $2147483708,%edx
	jnz L119
L118:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	seta %al
	jmp L164
L119:
	movq 8(%rcx),%rcx
	cmpq 8(%rax),%rcx
	setg %al
L164:
	movzbl %al,%eax
L163:
	movslq %eax,%rax
	movq %rax,8(%rbx)
	movl $-2147483589,(%rbx)
	jmp L149
L87:
	movq -8(%rbp),%rax
	movq 8(%rax),%rax
	movq -24(%rbp),%rcx
	movq 8(%rcx),%rcx
	shlq %cl,%rax
	jmp L161
L89:
	movl (%rbx),%edx
	movq -8(%rbp),%rcx
	movq -24(%rbp),%rax
	cmpl $2147483708,%edx
	jnz L91
L90:
	movq 8(%rcx),%rdx
	movq 8(%rax),%rcx
	shrq %cl,%rdx
	jmp L162
L91:
	movq 8(%rcx),%rdx
	movq 8(%rax),%rcx
	sarq %cl,%rdx
	jmp L162
L77:
	movq -8(%rbp),%rax
	movq 8(%rax),%rax
	movq -24(%rbp),%rcx
	subq 8(%rcx),%rax
	jmp L161
L75:
	movq -8(%rbp),%rax
	movq 8(%rax),%rcx
	movq -24(%rbp),%rax
	movq 8(%rax),%rax
	addq %rax,%rcx
	movq %rcx,8(%rbx)
	jmp L149
L94:
	movq -24(%rbp),%rax
	cmpq $0,8(%rax)
	jnz L97
L95:
	pushq $L98
	call _error
	addq $8,%rsp
L97:
	movl (%rbx),%edx
	movq -8(%rbp),%rax
	movq -24(%rbp),%rcx
	cmpl $2147483708,%edx
	jnz L100
L99:
	movq 8(%rax),%rax
	xorl %edx,%edx
	divq 8(%rcx)
	jmp L162
L100:
	movq 8(%rax),%rax
	cqto 
	idivq 8(%rcx)
L162:
	movq %rdx,8(%rbx)
	jmp L149
L103:
	movq -24(%rbp),%rax
	cmpq $0,8(%rax)
	jnz L106
L104:
	pushq $L107
	call _error
	addq $8,%rsp
L106:
	movl (%rbx),%edx
	movq -8(%rbp),%rax
	movq -24(%rbp),%rcx
	cmpl $2147483708,%edx
	jnz L109
L108:
	movq 8(%rax),%rax
	xorl %edx,%edx
	divq 8(%rcx)
	jmp L161
L109:
	movq 8(%rax),%rax
	cqto 
	idivq 8(%rcx)
	jmp L161
L79:
	movq -8(%rbp),%rax
	movq 8(%rax),%rcx
	movq -24(%rbp),%rax
	movq 8(%rax),%rax
	imulq %rcx,%rax
L161:
	movq %rax,8(%rbx)
	jmp L149
L72:
	pushq $L148
	call _error
	addq $8,%rsp
L149:
	movq (%r12),%rax
	leaq 32(%rbx),%rcx
	movq %rax,32(%rbx)
	testq %rax,%rax
	jz L153
L152:
	movq (%r12),%rax
	movq %rcx,40(%rax)
	jmp L154
L153:
	movq %rcx,8(%r12)
L154:
	movq %rbx,(%r12)
	movq %r12,40(%rbx)
	movq -8(%rbp),%rdi
	call _token_free
	movq -16(%rbp),%rdi
	call _token_free
	movq -24(%rbp),%rdi
	call _token_free
	jmp L53
L49:
	movq %r12,%rdi
	call _unary
L48:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_ternary:
L165:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
L166:
	movq %rdi,%rbx
	movq %rbx,%rsi
	movl $2560,%edi
	call _binary
	movq (%rbx),%rsi
	movq %rsi,-8(%rbp)
	movl $536870957,%edx
	movq %rbx,%rdi
	call _list_next_is
	testl %eax,%eax
	jz L167
L168:
	leaq -8(%rbp),%rsi
	movq %rbx,%rdi
	call _list_pop
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_pop
	movq %rbx,%rdi
	call _expression
	leaq -16(%rbp),%rsi
	movq %rbx,%rdi
	call _list_pop
	movq (%rbx),%rax
	testq %rax,%rax
	jz L176
L174:
	cmpl $536870956,(%rax)
	jz L173
L176:
	pushq $L178
	call _error
	addq $8,%rsp
L173:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_pop
	movq %rbx,%rdi
	call _ternary
	leaq -24(%rbp),%rsi
	movq %rbx,%rdi
	call _list_pop
	movq -8(%rbp),%rax
	movq 8(%rax),%rax
	movq (%rbx),%rcx
	testq %rax,%rax
	jz L188
L182:
	movq -16(%rbp),%rax
	movq %rcx,32(%rax)
	movq -16(%rbp),%rax
	addq $32,%rax
	testq %rcx,%rcx
	jz L186
L185:
	movq (%rbx),%rcx
	movq %rax,40(%rcx)
	jmp L187
L186:
	movq %rax,8(%rbx)
L187:
	movq -16(%rbp),%rax
	movq %rax,(%rbx)
	movq -16(%rbp),%rax
	movq %rbx,40(%rax)
	movq -24(%rbp),%rdi
	jmp L194
L188:
	movq -24(%rbp),%rax
	movq %rcx,32(%rax)
	movq -24(%rbp),%rax
	addq $32,%rax
	testq %rcx,%rcx
	jz L192
L191:
	movq (%rbx),%rcx
	movq %rax,40(%rcx)
	jmp L193
L192:
	movq %rax,8(%rbx)
L193:
	movq -24(%rbp),%rax
	movq %rax,(%rbx)
	movq -24(%rbp),%rax
	movq %rbx,40(%rax)
	movq -16(%rbp),%rdi
L194:
	call _token_free
	movq -8(%rbp),%rdi
	call _token_free
L167:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_expression:
L195:
	pushq %rbx
L196:
	movq %rdi,%rbx
L198:
	movq %rbx,%rdi
	call _ternary
	movl $536870959,%edx
	movq (%rbx),%rsi
	movq %rbx,%rdi
	call _list_next_is
	testl %eax,%eax
	jz L197
L202:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_pop
	xorl %esi,%esi
	movq %rbx,%rdi
	call _list_pop
	jmp L198
L197:
	popq %rbx
	ret 


_undefined:
L206:
	pushq %rbx
	pushq %r12
L207:
	movq %rdi,%r12
	movq (%r12),%rbx
L209:
	testq %rbx,%rbx
	jz L208
L210:
	cmpl $52,(%rbx)
	jnz L213
L212:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _list_drop
	movq %rax,%rbx
	xorl %edi,%edi
	call _token_int
	movq %rax,%rdx
	movq %rbx,%rsi
	movq %r12,%rdi
	call _list_insert
	jmp L209
L213:
	movq 32(%rbx),%rbx
	jmp L209
L208:
	popq %r12
	popq %rbx
	ret 


_defined:
L215:
	pushq %rbx
	pushq %r12
	pushq %r13
L216:
	movq %rdi,%r13
	movq (%r13),%r12
L218:
	testq %r12,%r12
	jz L217
L219:
	cmpl $52,(%r12)
	jnz L222
L228:
	leaq 8(%r12),%rdi
	call _macro_lookup
	testq %rax,%rax
	jz L222
L224:
	testl $1,24(%rax)
	jz L222
L221:
	movq %r12,%rsi
	movq %r13,%rdi
	call _list_drop
	movq %rax,%rsi
	movq %rsi,%r12
	testq %rsi,%rsi
	jz L233
L235:
	cmpl $536870927,(%rsi)
	jnz L233
L232:
	movq %r13,%rdi
	call _list_drop
	movq %rax,%r12
	movl $1,%ebx
	jmp L234
L233:
	xorl %ebx,%ebx
L234:
	testq %r12,%r12
	jz L239
L242:
	cmpl $52,(%r12)
	jz L241
L239:
	pushq $L246
	call _error
	addq $8,%rsp
L241:
	leaq 8(%r12),%rdi
	call _macro_lookup
	testq %rax,%rax
	jz L248
L250:
	testl $1,24(%rax)
	jnz L248
L247:
	movl $1,%edi
	jmp L266
L248:
	xorl %edi,%edi
L266:
	call _token_int
	movq %rax,%rdx
	movq %r12,%rsi
	movq %r13,%rdi
	call _list_insert
	movq %r12,%rsi
	movq %r13,%rdi
	call _list_drop
	movq %rax,%r12
	testl %ebx,%ebx
	jz L218
L254:
	testq %r12,%r12
	jz L257
L260:
	cmpl $536870928,(%r12)
	jz L259
L257:
	pushq $L264
	call _error
	addq $8,%rsp
L259:
	movq %r12,%rsi
	movq %r13,%rdi
	call _list_drop
	movq %rax,%r12
	jmp L218
L222:
	movq 32(%r12),%r12
	jmp L218
L217:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_evaluate:
L267:
	pushq %rbx
	pushq %r12
L268:
	movq %rdi,%r12
	movq %r12,%rdi
	call _list_strip_all
	movq %r12,%rdi
	call _defined
	movq %r12,%rdi
	call _macro_replace_all
	movq %r12,%rdi
	call _undefined
	movq %r12,%rdi
	call _list_strip_all
	movq %r12,%rdi
	call _expression
	movq (%r12),%rax
	testq %rax,%rax
	jz L273
L277:
	cmpl $2147483707,(%rax)
	jz L272
L273:
	testq %rax,%rax
	jz L270
L281:
	cmpl $2147483708,(%rax)
	jz L272
L270:
	pushq $L285
	call _error
	addq $8,%rsp
L272:
	movq (%r12),%rsi
	cmpq $0,8(%rsi)
	setnz %bl
	movzbl %bl,%ebx
	movq %r12,%rdi
	call _list_drop
	movl %ebx,%eax
L269:
	popq %r12
	popq %rbx
	ret 

L264:
	.byte 109,105,115,115,105,110,103,32
	.byte 99,108,111,115,105,110,103,32
	.byte 112,97,114,101,110,116,104,101
	.byte 115,105,115,32,97,102,116,101
	.byte 114,32,39,100,101,102,105,110
	.byte 101,100,39,0
L107:
	.byte 100,105,118,105,115,105,111,110
	.byte 32,98,121,32,122,101,114,111
	.byte 0
L34:
	.byte 109,97,108,102,111,114,109,101
	.byte 100,32,101,120,112,114,101,115
	.byte 115,105,111,110,0
L285:
	.byte 67,80,80,32,73,78,84,69
	.byte 82,78,65,76,58,32,98,111
	.byte 116,99,104,101,100,32,101,120
	.byte 112,114,101,115,115,105,111,110
	.byte 32,101,118,97,108,117,97,116
	.byte 105,111,110,0
L148:
	.byte 67,80,80,32,73,78,84,69
	.byte 82,78,65,76,58,32,117,110
	.byte 107,110,111,119,110,32,98,105
	.byte 110,97,114,121,32,111,112,101
	.byte 114,97,116,111,114,0
L178:
	.byte 109,105,115,115,105,110,103,32
	.byte 39,58,39,32,97,102,116,101
	.byte 114,32,39,63,39,0
L26:
	.byte 117,110,109,97,116,99,104,101
	.byte 100,32,112,97,114,101,110,116
	.byte 104,101,115,101,115,32,105,110
	.byte 32,101,120,112,114,101,115,115
	.byte 105,111,110,0
L98:
	.byte 109,111,100,117,108,117,115,32
	.byte 122,101,114,111,0
L246:
	.byte 109,105,115,115,105,110,103,32
	.byte 105,100,101,110,116,105,102,105
	.byte 101,114,32,97,102,116,101,114
	.byte 32,39,100,101,102,105,110,101
	.byte 100,39,0

.globl _token_convert_number
.globl _error
.globl _list_insert
.globl _list_strip_all
.globl _token_int
.globl _list_pop
.globl _list_next_is
.globl _evaluate
.globl _macro_replace_all
.globl _token_convert_char
.globl _token_free
.globl _macro_lookup
.globl _list_drop
