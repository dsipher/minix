.data
_priority:
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 11
	.byte 2
	.byte 1
	.byte 11
	.byte 2
	.byte 1
	.byte 12
	.byte 2
	.byte 1
	.byte 12
	.byte 2
	.byte 1
	.byte 13
	.byte 2
	.byte 5
	.byte 13
	.byte 2
	.byte 5
	.byte 7
	.byte 2
	.byte 3
	.byte 6
	.byte 2
	.byte 3
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 3
	.byte 0
	.byte 0
	.byte 3
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 10
	.byte 2
	.byte 2
	.byte 15
	.byte 2
	.byte 2
	.byte 14
	.byte 2
	.byte 2
	.byte 14
	.byte 2
	.byte 2
	.byte 16
	.byte 1
	.byte 6
	.byte 16
	.byte 1
	.byte 6
	.byte 15
	.byte 2
	.byte 2
	.byte 15
	.byte 2
	.byte 2
	.byte 12
	.byte 2
	.byte 1
	.byte 12
	.byte 2
	.byte 1
	.byte 9
	.byte 2
	.byte 2
	.byte 8
	.byte 2
	.byte 2
	.byte 5
	.byte 2
	.byte 4
	.byte 5
	.byte 2
	.byte 4
	.byte 0
	.byte 0
	.byte 0
	.byte 4
	.byte 2
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 16
	.byte 1
	.byte 6
	.byte 16
	.byte 0
	.byte 6
.text
.align 2
L160:
	.short L40-_eval
	.short L40-_eval
	.short L40-_eval
	.short L40-_eval
	.short L28-_eval
	.short L28-_eval
	.short L30-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L106-_eval
	.short L112-_eval
	.short L30-_eval
	.short L63-_eval
	.short L63-_eval
	.short L63-_eval
	.short L63-_eval
	.short L54-_eval
	.short L54-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L96-_eval
	.short L30-_eval
	.short L96-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L30-_eval
	.short L40-_eval
	.short L54-_eval

_eval:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq %rdi,%r13
	movl %esi,%ebx
	movq (%r13),%rdi
	leaq 24(%rdi),%rax
	movq %rax,(%r13)
	cmpl $1,%ebx
	jz L8
L7:
	cmpl $2,%ebx
	jnz L9
L8:
	movq 16(%r13),%rax
	subq 8(%r13),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq $4,%rax
	jnz L15
L14:
	cmpb $2,24(%rdi)
	jz L16
L15:
	pushq $L18
	pushq $1
	call _error
	addq $16,%rsp
	jmp L156
L16:
	xorl %esi,%esi
	addq $24,%rdi
	call _lookup
	cmpl $1,%ebx
	setz %cl
	movzbl %cl,%ecx
	testq %rax,%rax
	jz L22
L20:
	testb $9,41(%rax)
	jz L22
L21:
	movl $1,%eax
	jmp L23
L22:
	xorl %eax,%eax
L23:
	cmpl %eax,%ecx
	setz %al
	movzbl %al,%eax
	movslq %eax,%rax
	jmp L3
L9:
	subq 8(%r13),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r14d
	movq _kwdefined(%rip),%rax
	movb $12,40(%rax)
	movl $L25,%esi
	movq %r13,%rdi
	call _expandrow
	movq _kwdefined(%rip),%rax
	movb $2,40(%rax)
	movq $_vals,_vp(%rip)
	movq $_ops+4,_op(%rip)
	movl $0,_ops(%rip)
	xorl %r12d,%r12d
	movq 8(%r13),%rbx
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rax
	shlq $3,%rax
	addq %rax,%rbx
L26:
	cmpq 16(%r13),%rbx
	jae L29
L27:
	movb (%rbx),%cl
	cmpb $2,%cl
	jb L30
L159:
	cmpb $58,%cl
	ja L30
L157:
	leal -2(%rcx),%eax
	movzbl %al,%eax
	movzwl L160(,%rax,2),%eax
	addl $_eval,%eax
	jmp *%rax
L54:
	testl %r12d,%r12d
	jnz L44
L57:
	movzbl %cl,%ecx
	movq _op(%rip),%rdx
	leaq 4(%rdx),%rax
	movq %rax,_op(%rip)
	movl %ecx,(%rdx)
	jmp L28
L63:
	testl %r12d,%r12d
	jnz L96
L64:
	cmpb $28,%cl
	jnz L69
L67:
	movq _op(%rip),%rcx
	leaq 4(%rcx),%rax
	movq %rax,_op(%rip)
	movl $59,(%rcx)
L69:
	movb (%rbx),%al
	cmpb $26,%al
	jz L74
L73:
	cmpb $25,%al
	jnz L28
L74:
	pushq $L77
	pushq $1
	call _error
	addq $16,%rsp
	jmp L156
L112:
	testl %r12d,%r12d
	jz L44
L115:
	subq $8,%rsp
	movw _priority+69(%rip),%ax
	movw %ax,(%rsp)
	movb _priority+71(%rip),%al
	movb %al,2(%rsp)
	call _evalop
	addq $8,%rsp
	testl %eax,%eax
	jnz L156
L119:
	movq _op(%rip),%rcx
	cmpq $_ops,%rcx
	jbe L44
L124:
	leaq -4(%rcx),%rax
	cmpl $22,-4(%rcx)
	jnz L44
L126:
	movq %rax,_op(%rip)
	jmp L28
L106:
	testl %r12d,%r12d
	jnz L44
L109:
	movq _op(%rip),%rcx
	leaq 4(%rcx),%rax
	movq %rax,_op(%rip)
	movl $22,(%rcx)
	jmp L28
L96:
	testl %r12d,%r12d
	jz L44
L99:
	movzbq %cl,%rcx
	leaq (%rcx,%rcx,2),%rcx
	addq $_priority,%rcx
	subq $8,%rsp
	movw (%rcx),%ax
	movw %ax,(%rsp)
	movb 2(%rcx),%al
	movb %al,2(%rsp)
	call _evalop
	addq $8,%rsp
	testl %eax,%eax
	jnz L156
L103:
	movzbl (%rbx),%ecx
	movq _op(%rip),%rdx
	leaq 4(%rdx),%rax
	movq %rax,_op(%rip)
	movl %ecx,(%rdx)
	xorl %r12d,%r12d
	jmp L28
L40:
	testl %r12d,%r12d
	jnz L44
L43:
	movq _vp(%rip),%rdi
	cmpq $_vals+512,%rdi
	jz L46
L48:
	leaq 16(%rdi),%rax
	movq %rax,_vp(%rip)
	movq %rbx,%rsi
	call _tokval
	movl $1,%r12d
L28:
	addq $24,%rbx
	jmp L26
L46:
	pushq $L49
	pushq $1
	call _error
	addq $16,%rsp
	jmp L156
L30:
	pushq %rbx
	pushq $L130
	pushq $1
	call _error
	addq $24,%rsp
	jmp L156
L29:
	testl %r12d,%r12d
	jnz L134
L44:
	pushq $L154
	pushq $1
	call _error
	addq $16,%rsp
	jmp L156
L134:
	subq $8,%rsp
	movw _priority(%rip),%ax
	movw %ax,(%rsp)
	movb _priority+2(%rip),%al
	movb %al,2(%rsp)
	call _evalop
	addq $8,%rsp
	testl %eax,%eax
	jnz L156
L138:
	cmpq $_ops+4,_op(%rip)
	jnz L144
L143:
	cmpq $_vals+16,_vp(%rip)
	jz L145
L144:
	pushq $L147
	pushq $1
	call _error
	addq $16,%rsp
L156:
	xorl %eax,%eax
	jmp L3
L145:
	cmpl $2,_vals+8(%rip)
	jnz L151
L149:
	pushq $L152
	pushq $1
	call _error
	addq $16,%rsp
L151:
	movq _vals(%rip),%rax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L357:
	.short L170-_evalop
	.short L177-_evalop
	.short L177-_evalop
	.short L171-_evalop
	.short L171-_evalop
	.short L200-_evalop
	.short L212-_evalop
.align 2
L358:
	.short L221-_evalop
	.short L224-_evalop
	.short L234-_evalop
	.short L236-_evalop
	.short L244-_evalop
	.short L248-_evalop
.align 2
L359:
	.short L221-_evalop
	.short L224-_evalop
	.short L226-_evalop
	.short L228-_evalop
	.short L242-_evalop
	.short L246-_evalop
	.short L250-_evalop
	.short L263-_evalop
	.short L217-_evalop
	.short L217-_evalop
	.short L217-_evalop
	.short L217-_evalop
	.short L217-_evalop
	.short L217-_evalop
	.short L217-_evalop
	.short L217-_evalop
	.short L276-_evalop
	.short L278-_evalop
	.short L280-_evalop
	.short L282-_evalop
	.short L293-_evalop
	.short L295-_evalop
	.short L300-_evalop
	.short L309-_evalop
	.short L230-_evalop
	.short L232-_evalop
	.short L291-_evalop
	.short L289-_evalop
	.short L217-_evalop
	.short L318-_evalop

_evalop:
L161:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L162:
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L164:
	movb 16(%rbp),%sil
	movq _op(%rip),%rcx
	leaq -4(%rcx),%rdx
	movslq -4(%rcx),%rax
	leaq (%rax,%rax,2),%rax
	cmpb _priority(%rax),%sil
	jge L339
L165:
	movq %rdx,_op(%rip)
	movl -4(%rcx),%ecx
	movslq %ecx,%rax
	leaq (%rax,%rax,2),%rax
	cmpb $2,_priority+1(%rax)
	jnz L169
L167:
	movq _vp(%rip),%rsi
	leaq -16(%rsi),%rdx
	movq %rdx,_vp(%rip)
	movq -16(%rsi),%rdx
	movq %rdx,-16(%rbp)
	movq -8(%rsi),%rdx
	movq %rdx,-8(%rbp)
	movq -16(%rbp),%r12
L169:
	movq _vp(%rip),%rsi
	leaq -16(%rsi),%rdx
	movq %rdx,_vp(%rip)
	movq -16(%rsi),%rdx
	movq %rdx,-32(%rbp)
	movq -8(%rsi),%rdx
	movq %rdx,-24(%rbp)
	movq -32(%rbp),%r13
	movb _priority+2(%rax),%al
	cmpb $0,%al
	jl L170
L342:
	cmpb $6,%al
	jg L170
L340:
	movzbl %al,%edx
	movzwl L357(,%rdx,2),%edx
	addl $_evalop,%edx
	jmp *%rdx
L212:
	movl -24(%rbp),%ebx
	jmp L171
L200:
	movl -24(%rbp),%ebx
	cmpl $2,%ebx
	jz L201
L204:
	cmpl $2,-8(%rbp)
	jnz L202
L201:
	movl $2,%ebx
	jmp L171
L202:
	cmpl $1,%ebx
	jnz L171
L208:
	orl $4096,%ecx
	jmp L171
L177:
	movl -24(%rbp),%edx
	cmpl $1,%edx
	jz L178
L181:
	cmpl $1,-8(%rbp)
	jnz L179
L178:
	movl $1,%ebx
	jmp L180
L179:
	xorl %ebx,%ebx
L180:
	cmpl $2,%edx
	jz L185
L188:
	cmpl $2,-8(%rbp)
	jnz L187
L185:
	movl $2,%ebx
L187:
	cmpb $1,%al
	jnz L171
L195:
	cmpl $1,%ebx
	jnz L171
L192:
	orl $4096,%ecx
	xorl %ebx,%ebx
L171:
	cmpl $9,%ecx
	jl L344
L346:
	cmpl $38,%ecx
	jg L344
L343:
	addl $-9,%ecx
	movzwl L359(,%rcx,2),%eax
	addl $_evalop,%eax
	jmp *%rax
L318:
	movq _op(%rip),%rcx
	leaq -4(%rcx),%rax
	cmpl $37,-4(%rcx)
	jz L320
L319:
	pushq $L322
	pushq $1
	call _error
	addq $16,%rsp
	jmp L218
L320:
	movq %rax,_op(%rip)
	movq _vp(%rip),%rcx
	leaq -16(%rcx),%rax
	movq %rax,_vp(%rip)
	cmpq $0,-16(%rcx)
	jnz L325
L323:
	movq -16(%rbp),%rax
	movq %rax,-32(%rbp)
	movq -8(%rbp),%rax
	movq %rax,-24(%rbp)
L325:
	movl -24(%rbp),%ebx
	movq -32(%rbp),%r13
	jmp L218
L289:
	orq %r12,%r13
	jmp L218
L291:
	xorq %r12,%r13
	jmp L218
L232:
	cmpq %r13,%r12
	setl %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L230:
	cmpq %r13,%r12
	setg %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L309:
	testq %r12,%r12
	jz L337
L312:
	cmpl $1,%ebx
	jnz L315
L314:
	movq %r13,%rax
	xorl %edx,%edx
	divq %r12
	movq %rdx,%r13
	jmp L218
L315:
	movq %r13,%rax
	cqto 
	idivq %r12
	movq %rdx,%r13
	jmp L218
L300:
	testq %r12,%r12
	jnz L303
L337:
	movl $2,%ebx
	jmp L218
L303:
	cmpl $1,%ebx
	jnz L306
L305:
	movq %r13,%rax
	xorl %edx,%edx
	divq %r12
	movq %rax,%r13
	jmp L218
L306:
	movq %r13,%rax
	cqto 
	idivq %r12
	movq %rax,%r13
	jmp L218
L295:
	testq %r13,%r13
	setz %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	cmpl $2,%ebx
	jz L218
	jnz L336
L293:
	notq %r13
	jmp L218
L282:
	subq %r12,%r13
	jmp L218
L280:
	addq %r12,%r13
	jmp L218
L278:
	imulq %r12,%r13
	jmp L218
L276:
	andq %r12,%r13
	jmp L218
L263:
	movl $2,%ebx
	cmpl $2,-24(%rbp)
	jz L218
L266:
	testq %r13,%r13
	jnz L269
L268:
	cmpl $2,-8(%rbp)
	jz L218
L273:
	testq %r12,%r12
	setnz %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L336
L269:
	movl $1,%r13d
	jmp L336
L250:
	movl $2,%ebx
	cmpl $2,-24(%rbp)
	jz L218
L253:
	testq %r13,%r13
	jz L256
L255:
	cmpl $2,-8(%rbp)
	jz L218
L260:
	testq %r12,%r12
	setnz %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L336
L256:
	xorl %r13d,%r13d
L336:
	xorl %ebx,%ebx
	jmp L218
L246:
	movb %r12b,%cl
	sarq %cl,%r13
	jmp L218
L242:
	movb %r12b,%cl
	shlq %cl,%r13
	jmp L218
L228:
	cmpq %r13,%r12
	setle %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L226:
	cmpq %r13,%r12
	setge %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L344:
	cmpl $4105,%ecx
	jl L348
L350:
	cmpl $4110,%ecx
	jg L348
L347:
	addl $-4105,%ecx
	movzwl L358(,%rcx,2),%eax
	addl $_evalop,%eax
	jmp *%rax
L248:
	movb %r12b,%cl
	shrq %cl,%r13
	jmp L218
L244:
	movb %r12b,%cl
	shlq %cl,%r13
	jmp L218
L236:
	cmpq %r13,%r12
	setbe %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L234:
	cmpq %r13,%r12
	setae %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L224:
	cmpq %r13,%r12
	setnz %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L221:
	cmpq %r13,%r12
	setz %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L348:
	cmpl $58,%ecx
	jz L218
L352:
	cmpl $59,%ecx
	jz L284
L353:
	cmpl $4129,%ecx
	jz L238
L354:
	cmpl $4130,%ecx
	jnz L217
L240:
	cmpq %r13,%r12
	setb %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L217:
	pushq $L329
	pushq $1
	call _error
	addq $16,%rsp
	jmp L338
L238:
	cmpq %r13,%r12
	seta %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L218
L284:
	cmpl $2,-24(%rbp)
	movl $2,%eax
	cmovzl %eax,%ebx
	negq %r13
L218:
	movq %r13,-32(%rbp)
	movl %ebx,-24(%rbp)
	movq _vp(%rip),%rcx
	cmpq $_vals+512,%rcx
	jz L331
L333:
	leaq 16(%rcx),%rax
	movq %rax,_vp(%rip)
	movq -32(%rbp),%rax
	movq %rax,(%rcx)
	movq -24(%rbp),%rax
	movq %rax,8(%rcx)
	jmp L164
L331:
	pushq $L49
	pushq $1
	call _error
	addq $16,%rsp
	jmp L339
L170:
	pushq $L174
	pushq $0
	call _error
	addq $16,%rsp
L338:
	movl $1,%eax
	jmp L163
L339:
	xorl %eax,%eax
L163:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
L467:
 .byte 98,8,102,12,110,10,114,13
 .byte 116,9,118,11,39,39,34,34
 .byte 63,63,92,92,0
.text

_tokval:
L360:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L361:
	movq %rdi,-24(%rbp)
	movq %rsi,%r15
	movl $0,-8(%rbp)
	movq $0,-16(%rbp)
	movb (%r15),%al
	cmpb $2,%al
	jz L366
L498:
	cmpb $3,%al
	jz L377
L499:
	cmpb $4,%al
	jz L493
L500:
	cmpb $5,%al
	jz L428
L501:
	cmpb $57,%al
	jnz L362
L368:
	xorl %esi,%esi
	movq %r15,%rdi
	call _lookup
	testq %rax,%rax
	jz L362
L372:
	testb $9,41(%rax)
	jz L362
L369:
	movq $1,-16(%rbp)
	jmp L362
L428:
	xorl %ebx,%ebx
	movq 16(%r15),%r13
	cmpb $76,(%r13)
	jnz L431
L429:
	incq %r13
	pushq $L432
	pushq $0
	call _error
	addq $16,%rsp
L431:
	incq %r13
	movq %r13,%r12
	movb (%r13),%al
	cmpb $92,%al
	jnz L434
L433:
	movzbl 1(%r13),%edi
	call _digit
	cmpl $0,%eax
	jl L437
L439:
	cmpl $7,%eax
	jg L437
L436:
	movslq %eax,%rbx
	leaq 2(%r13),%r12
	movzbl 2(%r13),%edi
	call _digit
	cmpl $0,%eax
	jl L435
L446:
	cmpl $7,%eax
	jg L435
L443:
	leaq 3(%r13),%r12
	movslq %eax,%rax
	movzbl 3(%r13),%edi
	leaq (%rax,%rbx,8),%rbx
	call _digit
	cmpl $0,%eax
	jl L435
L453:
	cmpl $7,%eax
	jg L435
L450:
	leaq 4(%r13),%r12
	movslq %eax,%rax
	leaq (%rax,%rbx,8),%rbx
	jmp L435
L437:
	cmpb $120,1(%r13)
	jnz L458
L457:
	leaq 2(%r13),%r12
L460:
	movzbl (%r12),%edi
	call _digit
	cmpl $0,%eax
	jl L435
L463:
	cmpl $15,%eax
	jg L435
L461:
	incq %r12
	shlq $4,%rbx
	movslq %eax,%rax
	addq %rax,%rbx
	jmp L460
L458:
	xorl %edx,%edx
L469:
	movzbl 1(%r13),%ecx
	movslq %edx,%rax
	movsbl L467(%rax),%eax
	cmpl %eax,%ecx
	jz L472
L474:
	addl $2,%edx
	cmpl $21,%edx
	jl L469
	jge L471
L472:
	leal 1(%rdx),%eax
	movslq %eax,%rax
	movsbq L467(%rax),%rbx
L471:
	leaq 2(%r13),%r12
	cmpl $21,%edx
	jl L435
L476:
	pushq $L479
	pushq $0
	call _error
	addq $16,%rsp
	jmp L435
L434:
	cmpb $39,%al
	jnz L481
L480:
	pushq $L483
	pushq $1
	call _error
	addq $16,%rsp
	jmp L435
L481:
	movzbq %al,%rax
	leaq 1(%r13),%r12
	movq %rax,%rbx
L435:
	cmpb $39,(%r12)
	jz L485
L484:
	pushq $L487
	pushq $0
	call _error
	addq $16,%rsp
	jmp L486
L485:
	cmpq $127,%rbx
	jbe L486
L488:
	pushq $L491
	pushq $0
	call _error
	addq $16,%rsp
L486:
	movq %rbx,-16(%rbp)
	jmp L362
L493:
	pushq $L494
	pushq $1
	call _error
	addq $16,%rsp
	jmp L362
L377:
	xorl %r12d,%r12d
	movl $10,%r14d
	movq 16(%r15),%r13
	movl 8(%r15),%ecx
	movzbl (%r13,%rcx),%eax
	movl %eax,-28(%rbp)
	movb $0,(%r13,%rcx)
	cmpb $48,(%r13)
	jnz L388
L378:
	movl $8,%r14d
	leaq 1(%r13),%rcx
	movb 1(%r13),%al
	cmpb $120,%al
	jz L381
L384:
	cmpb $88,%al
	jnz L383
L381:
	movl $16,%r14d
	movq %rcx,%r13
L383:
	incq %r13
L388:
	movzbl (%r13),%edi
	call _digit
	movl %eax,%ebx
	cmpl $0,%ebx
	jl L392
L394:
	cmpl %ebx,%r14d
	jg L398
L396:
	pushq %r15
	pushq $L399
	pushq $0
	call _error
	addq $24,%rsp
L398:
	movslq %r14d,%rax
	imulq %rax,%r12
	movslq %ebx,%rbx
	addq %rbx,%r12
	incq %r13
	jmp L388
L392:
	movl $2147483648,%eax
	cmpq %rax,%r12
	jb L407
L403:
	cmpl $10,%r14d
	jz L407
L400:
	movl $1,-8(%rbp)
L407:
	movb (%r13),%al
	testb %al,%al
	jz L410
L408:
	cmpb $117,%al
	jz L411
L414:
	cmpb $85,%al
	jnz L412
L411:
	movl $1,-8(%rbp)
	jmp L413
L412:
	cmpb $108,%al
	jz L413
L421:
	cmpb $76,%al
	jnz L419
L413:
	incq %r13
	jmp L407
L419:
	pushq %r15
	pushq $L425
	pushq $1
	call _error
	addq $24,%rsp
L410:
	movq %r12,-16(%rbp)
	movq 16(%r15),%rdx
	movl 8(%r15),%ecx
	movl -28(%rbp),%eax
	movb %al,(%rdx,%rcx)
	jmp L362
L366:
	movq $0,-16(%rbp)
L362:
	movq -16(%rbp),%rcx
	movq -24(%rbp),%rax
	movq %rcx,(%rax)
	movq -8(%rbp),%rcx
	movq -24(%rbp),%rax
	movq %rcx,8(%rax)
	movq -24(%rbp),%rax
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_digit:
L504:
L505:
	movl %edi,%eax
	cmpl $48,%eax
	jl L508
L510:
	cmpl $57,%eax
	jg L508
L507:
	subl $48,%eax
	ret
L508:
	cmpl $97,%eax
	jl L515
L517:
	cmpl $102,%eax
	jg L515
L514:
	subl $87,%eax
	ret
L515:
	cmpl $65,%eax
	jl L522
L524:
	cmpl $70,%eax
	jg L522
L521:
	subl $55,%eax
	ret
L522:
	movl $-1,%eax
L506:
	ret 

L479:
 .byte 85,110,100,101,102,105,110,101
 .byte 100,32,101,115,99,97,112,101
 .byte 32,105,110,32,99,104,97,114
 .byte 97,99,116,101,114,32,99,111
 .byte 110,115,116,97,110,116,0
L152:
 .byte 85,110,100,101,102,105,110,101
 .byte 100,32,101,120,112,114,101,115
 .byte 115,105,111,110,32,118,97,108
 .byte 117,101,0
L174:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,105,102,47,35,101,110,100
 .byte 105,102,0
L154:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,105,102,47,35,101,108,115
 .byte 105,102,0
L147:
 .byte 66,111,116,99,104,32,105,110
 .byte 32,35,105,102,47,35,101,108
 .byte 115,105,102,0
L487:
 .byte 77,117,108,116,105,98,121,116
 .byte 101,32,99,104,97,114,97,99
 .byte 116,101,114,32,99,111,110,115
 .byte 116,97,110,116,32,117,110,100
 .byte 101,102,105,110,101,100,0
L329:
 .byte 69,118,97,108,32,98,111,116
 .byte 99,104,32,40,117,110,107,110
 .byte 111,119,110,32,111,112,101,114
 .byte 97,116,111,114,41,0
L130:
 .byte 66,97,100,32,111,112,101,114
 .byte 97,116,111,114,32,40,37,116
 .byte 41,32,105,110,32,35,105,102
 .byte 47,35,101,108,115,105,102,0
L18:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,105,102,100,101,102,47,35
 .byte 105,102,110,100,101,102,0
L49:
 .byte 69,118,97,108,32,98,111,116
 .byte 99,104,32,40,115,116,97,99
 .byte 107,32,111,118,101,114,102,108
 .byte 111,119,41,0
L322:
 .byte 66,97,100,32,63,58,32,105
 .byte 110,32,35,105,102,47,101,110
 .byte 100,105,102,0
L483:
 .byte 69,109,112,116,121,32,99,104
 .byte 97,114,97,99,116,101,114,32
 .byte 99,111,110,115,116,97,110,116
 .byte 0
L432:
 .byte 87,105,100,101,32,99,104,97
 .byte 114,32,99,111,110,115,116,97
 .byte 110,116,32,118,97,108,117,101
 .byte 32,117,110,100,101,102,105,110
 .byte 101,100,0
L425:
 .byte 66,97,100,32,110,117,109,98
 .byte 101,114,32,37,116,32,105,110
 .byte 32,35,105,102,47,35,101,108
 .byte 115,105,102,0
L25:
 .byte 60,105,102,62,0
L491:
 .byte 67,104,97,114,97,99,116,101
 .byte 114,32,99,111,110,115,116,97
 .byte 110,116,32,116,97,107,101,110
 .byte 32,97,115,32,110,111,116,32
 .byte 115,105,103,110,101,100,0
L399:
 .byte 66,97,100,32,100,105,103,105
 .byte 116,32,105,110,32,110,117,109
 .byte 98,101,114,32,37,116,0
L494:
 .byte 83,116,114,105,110,103,32,105
 .byte 110,32,35,105,102,47,35,101
 .byte 108,115,105,102,0
L77:
 .byte 73,108,108,101,103,97,108,32
 .byte 111,112,101,114,97,116,111,114
 .byte 32,42,32,111,114,32,38,32
 .byte 105,110,32,35,105,102,47,35
 .byte 101,108,115,105,102,0
.comm _vals, 512, 8
.comm _vp, 8, 8
.comm _ops, 128, 4
.comm _op, 8, 8

.globl _kwdefined
.globl _error
.globl _vals
.globl _priority
.globl _op
.globl _ops
.globl _tokval
.globl _vp
.globl _evalop
.globl _digit
.globl _lookup
.globl _eval
.globl _expandrow
