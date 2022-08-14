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
	jmp L161
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
	jmp L161
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
	jmp L161
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
	jmp L161
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
L161:
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
L358:
	.short L171-_evalop
	.short L178-_evalop
	.short L178-_evalop
	.short L172-_evalop
	.short L172-_evalop
	.short L201-_evalop
	.short L213-_evalop
.align 2
L359:
	.short L222-_evalop
	.short L225-_evalop
	.short L235-_evalop
	.short L237-_evalop
	.short L245-_evalop
	.short L249-_evalop
.align 2
L360:
	.short L222-_evalop
	.short L225-_evalop
	.short L227-_evalop
	.short L229-_evalop
	.short L243-_evalop
	.short L247-_evalop
	.short L251-_evalop
	.short L264-_evalop
	.short L218-_evalop
	.short L218-_evalop
	.short L218-_evalop
	.short L218-_evalop
	.short L218-_evalop
	.short L218-_evalop
	.short L218-_evalop
	.short L218-_evalop
	.short L277-_evalop
	.short L279-_evalop
	.short L281-_evalop
	.short L283-_evalop
	.short L294-_evalop
	.short L296-_evalop
	.short L301-_evalop
	.short L310-_evalop
	.short L231-_evalop
	.short L233-_evalop
	.short L292-_evalop
	.short L290-_evalop
	.short L218-_evalop
	.short L319-_evalop

_evalop:
L162:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L163:
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L165:
	movb 16(%rbp),%sil
	movq _op(%rip),%rcx
	leaq -4(%rcx),%rdx
	movslq -4(%rcx),%rax
	leaq (%rax,%rax,2),%rax
	cmpb _priority(%rax),%sil
	jge L340
L166:
	movq %rdx,_op(%rip)
	movl -4(%rcx),%edx
	movslq %edx,%rax
	leaq (%rax,%rax,2),%rcx
	cmpb $2,_priority+1(%rcx)
	jnz L170
L168:
	movq _vp(%rip),%rsi
	leaq -16(%rsi),%rax
	movq %rax,_vp(%rip)
	movq -16(%rsi),%rax
	movq %rax,-16(%rbp)
	movq -8(%rsi),%rax
	movq %rax,-8(%rbp)
	movq -16(%rbp),%r12
L170:
	movq _vp(%rip),%rsi
	leaq -16(%rsi),%rax
	movq %rax,_vp(%rip)
	movq -16(%rsi),%rax
	movq %rax,-32(%rbp)
	movq -8(%rsi),%rax
	movq %rax,-24(%rbp)
	movq -32(%rbp),%rax
	movq %rax,%r13
	movb _priority+2(%rcx),%cl
	cmpb $0,%cl
	jl L171
L343:
	cmpb $6,%cl
	jg L171
L341:
	movzbl %cl,%esi
	movzwl L358(,%rsi,2),%esi
	addl $_evalop,%esi
	jmp *%rsi
L213:
	movl -24(%rbp),%ebx
	jmp L172
L201:
	movl -24(%rbp),%ebx
	cmpl $2,%ebx
	jz L202
L205:
	cmpl $2,-8(%rbp)
	jnz L203
L202:
	movl $2,%ebx
	jmp L172
L203:
	cmpl $1,%ebx
	jnz L172
L209:
	orl $4096,%edx
	jmp L172
L178:
	movl -24(%rbp),%esi
	cmpl $1,%esi
	jz L179
L182:
	cmpl $1,-8(%rbp)
	jnz L180
L179:
	movl $1,%ebx
	jmp L181
L180:
	xorl %ebx,%ebx
L181:
	cmpl $2,%esi
	jz L186
L189:
	cmpl $2,-8(%rbp)
	jnz L188
L186:
	movl $2,%ebx
L188:
	cmpb $1,%cl
	jnz L172
L196:
	cmpl $1,%ebx
	jnz L172
L193:
	orl $4096,%edx
	xorl %ebx,%ebx
L172:
	cmpl $9,%edx
	jl L345
L347:
	cmpl $38,%edx
	jg L345
L344:
	addl $-9,%edx
	movzwl L360(,%rdx,2),%ecx
	addl $_evalop,%ecx
	jmp *%rcx
L319:
	movq _op(%rip),%rcx
	leaq -4(%rcx),%rax
	cmpl $37,-4(%rcx)
	jz L321
L320:
	pushq $L323
	pushq $1
	call _error
	addq $16,%rsp
	jmp L219
L321:
	movq %rax,_op(%rip)
	movq _vp(%rip),%rcx
	leaq -16(%rcx),%rax
	movq %rax,_vp(%rip)
	cmpq $0,-16(%rcx)
	jnz L326
L324:
	movq -16(%rbp),%rax
	movq %rax,-32(%rbp)
	movq -8(%rbp),%rax
	movq %rax,-24(%rbp)
L326:
	movl -24(%rbp),%ebx
	movq -32(%rbp),%r13
	jmp L219
L290:
	orq %r12,%rax
	jmp L365
L292:
	xorq %r12,%rax
	jmp L365
L233:
	cmpq %rax,%r12
	setl %r13b
	jmp L364
L231:
	cmpq %rax,%r12
	setg %r13b
	jmp L364
L310:
	testq %r12,%r12
	jz L338
L313:
	cmpl $1,%ebx
	jnz L316
L315:
	xorl %edx,%edx
	divq %r12
	jmp L362
L316:
	cqto 
	idivq %r12
L362:
	movq %rdx,%r13
	jmp L219
L301:
	testq %r12,%r12
	jnz L304
L338:
	movl $2,%ebx
	jmp L219
L304:
	cmpl $1,%ebx
	jnz L307
L306:
	xorl %edx,%edx
	divq %r12
	jmp L365
L307:
	cqto 
	idivq %r12
	jmp L365
L296:
	testq %rax,%rax
	setz %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	cmpl $2,%ebx
	jz L219
	jnz L337
L294:
	notq %rax
	jmp L365
L283:
	subq %r12,%rax
	jmp L365
L281:
	leaq (%rax,%r12),%r13
	jmp L219
L279:
	imulq %r12,%rax
	jmp L365
L277:
	andq %r12,%rax
	jmp L365
L264:
	movl $2,%ebx
	cmpl $2,-24(%rbp)
	jz L219
L267:
	testq %rax,%rax
	jnz L270
L269:
	cmpl $2,-8(%rbp)
	jz L219
	jnz L367
L270:
	movl $1,%r13d
	jmp L337
L251:
	movl $2,%ebx
	cmpl $2,-24(%rbp)
	jz L219
L254:
	testq %rax,%rax
	jz L257
L256:
	cmpl $2,-8(%rbp)
	jz L219
L367:
	testq %r12,%r12
	setnz %r13b
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L337
L257:
	xorl %r13d,%r13d
L337:
	xorl %ebx,%ebx
	jmp L219
L247:
	movb %r12b,%cl
	sarq %cl,%rax
	jmp L365
L243:
	jmp L366
L229:
	cmpq %rax,%r12
	setle %r13b
	jmp L364
L227:
	cmpq %rax,%r12
	setge %r13b
	jmp L364
L345:
	cmpl $4105,%edx
	jl L349
L351:
	cmpl $4110,%edx
	jg L349
L348:
	addl $-4105,%edx
	movzwl L359(,%rdx,2),%ecx
	addl $_evalop,%ecx
	jmp *%rcx
L249:
	movb %r12b,%cl
	shrq %cl,%rax
	jmp L365
L245:
L366:
	movb %r12b,%cl
	shlq %cl,%rax
	jmp L365
L237:
	cmpq %rax,%r12
	setbe %r13b
	jmp L364
L235:
	cmpq %rax,%r12
	setae %r13b
	jmp L364
L225:
	cmpq %rax,%r12
	setnz %r13b
	jmp L364
L222:
	cmpq %rax,%r12
	setz %r13b
	jmp L364
L349:
	cmpl $58,%edx
	jz L219
L353:
	cmpl $59,%edx
	jz L285
L354:
	cmpl $4129,%edx
	jz L239
L355:
	cmpl $4130,%edx
	jnz L218
L241:
	cmpq %rax,%r12
	setb %r13b
	jmp L364
L218:
	pushq $L330
	pushq $1
	jmp L361
L239:
	cmpq %rax,%r12
	seta %r13b
L364:
	movzbl %r13b,%r13d
	movslq %r13d,%r13
	jmp L219
L285:
	cmpl $2,-24(%rbp)
	movl $2,%ecx
	cmovzl %ecx,%ebx
	negq %rax
L365:
	movq %rax,%r13
L219:
	movq %r13,-32(%rbp)
	movl %ebx,-24(%rbp)
	movq _vp(%rip),%rcx
	cmpq $_vals+512,%rcx
	jz L332
L334:
	leaq 16(%rcx),%rax
	movq %rax,_vp(%rip)
	movq -32(%rbp),%rax
	movq %rax,(%rcx)
	movq -24(%rbp),%rax
	movq %rax,8(%rcx)
	jmp L165
L332:
	pushq $L49
	pushq $1
	call _error
	addq $16,%rsp
	jmp L340
L171:
	pushq $L175
	pushq $0
L361:
	call _error
	addq $16,%rsp
	movl $1,%eax
	jmp L164
L340:
	xorl %eax,%eax
L164:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
L475:
	.byte 98,8,102,12,110,10,114,13
	.byte 116,9,118,11,39,39,34,34
	.byte 63,63,92,92,0
.text

_tokval:
L368:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L369:
	movq %rdi,-24(%rbp)
	movq %rsi,%r15
	movl $0,-8(%rbp)
	movq $0,-16(%rbp)
	movb (%r15),%al
	cmpb $2,%al
	jz L374
L506:
	cmpb $3,%al
	jz L385
L507:
	cmpb $4,%al
	jz L501
L508:
	cmpb $5,%al
	jz L436
L509:
	cmpb $57,%al
	jnz L370
L376:
	xorl %esi,%esi
	movq %r15,%rdi
	call _lookup
	testq %rax,%rax
	jz L370
L380:
	testb $9,41(%rax)
	jz L370
L377:
	movq $1,-16(%rbp)
	jmp L370
L436:
	xorl %ebx,%ebx
	movq 16(%r15),%r13
	cmpb $76,(%r13)
	jnz L439
L437:
	incq %r13
	pushq $L440
	pushq $0
	call _error
	addq $16,%rsp
L439:
	incq %r13
	movq %r13,%r12
	movb (%r13),%al
	cmpb $92,%al
	jnz L442
L441:
	movzbl 1(%r13),%edi
	call _digit
	cmpl $0,%eax
	jl L445
L447:
	cmpl $7,%eax
	jg L445
L444:
	movslq %eax,%rbx
	leaq 2(%r13),%r12
	movzbl 2(%r13),%edi
	call _digit
	cmpl $0,%eax
	jl L443
L454:
	cmpl $7,%eax
	jg L443
L451:
	leaq 3(%r13),%r12
	movslq %eax,%rax
	movzbl 3(%r13),%edi
	leaq (%rax,%rbx,8),%rbx
	call _digit
	cmpl $0,%eax
	jl L443
L461:
	cmpl $7,%eax
	jg L443
L458:
	leaq 4(%r13),%r12
	movslq %eax,%rax
	leaq (%rax,%rbx,8),%rbx
	jmp L443
L445:
	cmpb $120,1(%r13)
	jnz L466
L465:
	leaq 2(%r13),%r12
L468:
	movzbl (%r12),%edi
	call _digit
	cmpl $0,%eax
	jl L443
L471:
	cmpl $15,%eax
	jg L443
L469:
	incq %r12
	shlq $4,%rbx
	movslq %eax,%rax
	addq %rax,%rbx
	jmp L468
L466:
	xorl %edx,%edx
L477:
	movzbl 1(%r13),%ecx
	movslq %edx,%rax
	movsbl L475(%rax),%eax
	cmpl %eax,%ecx
	jz L480
L482:
	addl $2,%edx
	cmpl $21,%edx
	jl L477
	jge L479
L480:
	leal 1(%rdx),%eax
	movslq %eax,%rax
	movsbq L475(%rax),%rbx
L479:
	leaq 2(%r13),%r12
	cmpl $21,%edx
	jl L443
L484:
	pushq $L487
	pushq $0
	jmp L513
L442:
	cmpb $39,%al
	jnz L489
L488:
	pushq $L491
	pushq $1
L513:
	call _error
	addq $16,%rsp
	jmp L443
L489:
	movzbq %al,%rax
	leaq 1(%r13),%r12
	movq %rax,%rbx
L443:
	cmpb $39,(%r12)
	jz L493
L492:
	pushq $L495
	jmp L512
L493:
	cmpq $127,%rbx
	jbe L494
L496:
	pushq $L499
L512:
	pushq $0
	call _error
	addq $16,%rsp
L494:
	movq %rbx,-16(%rbp)
	jmp L370
L501:
	pushq $L502
	pushq $1
	call _error
	addq $16,%rsp
	jmp L370
L385:
	xorl %r12d,%r12d
	movl $10,%r14d
	movq 16(%r15),%r13
	movl 8(%r15),%ecx
	movzbl (%r13,%rcx),%eax
	movl %eax,-28(%rbp)
	movb $0,(%r13,%rcx)
	cmpb $48,(%r13)
	jnz L396
L386:
	movl $8,%r14d
	leaq 1(%r13),%rcx
	movb 1(%r13),%al
	cmpb $120,%al
	jz L389
L392:
	cmpb $88,%al
	jnz L514
L389:
	movl $16,%r14d
	movq %rcx,%r13
L514:
	incq %r13
L396:
	movzbl (%r13),%edi
	call _digit
	movl %eax,%ebx
	cmpl $0,%ebx
	jl L400
L402:
	cmpl %ebx,%r14d
	jg L406
L404:
	pushq %r15
	pushq $L407
	pushq $0
	call _error
	addq $24,%rsp
L406:
	movslq %r14d,%rax
	imulq %rax,%r12
	movslq %ebx,%rbx
	addq %rbx,%r12
	jmp L514
L400:
	movl $2147483648,%eax
	cmpq %rax,%r12
	jb L415
L411:
	cmpl $10,%r14d
	jz L415
L408:
	movl $1,-8(%rbp)
L415:
	movb (%r13),%al
	testb %al,%al
	jz L418
L416:
	cmpb $117,%al
	jz L419
L422:
	cmpb $85,%al
	jnz L420
L419:
	movl $1,-8(%rbp)
	jmp L421
L420:
	cmpb $108,%al
	jz L421
L429:
	cmpb $76,%al
	jnz L427
L421:
	incq %r13
	jmp L415
L427:
	pushq %r15
	pushq $L433
	pushq $1
	call _error
	addq $24,%rsp
L418:
	movq %r12,-16(%rbp)
	movq 16(%r15),%rdx
	movl 8(%r15),%ecx
	movl -28(%rbp),%eax
	movb %al,(%rdx,%rcx)
	jmp L370
L374:
	movq $0,-16(%rbp)
L370:
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
L515:
L516:
	movl %edi,%eax
	cmpl $48,%eax
	jl L519
L521:
	cmpl $57,%eax
	jg L519
L518:
	subl $48,%eax
	ret
L519:
	cmpl $97,%eax
	jl L526
L528:
	cmpl $102,%eax
	jg L526
L525:
	subl $87,%eax
	ret
L526:
	cmpl $65,%eax
	jl L533
L535:
	cmpl $70,%eax
	jg L533
L532:
	subl $55,%eax
	ret
L533:
	movl $-1,%eax
L517:
	ret 

L487:
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
L175:
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
L495:
	.byte 77,117,108,116,105,98,121,116
	.byte 101,32,99,104,97,114,97,99
	.byte 116,101,114,32,99,111,110,115
	.byte 116,97,110,116,32,117,110,100
	.byte 101,102,105,110,101,100,0
L330:
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
L323:
	.byte 66,97,100,32,63,58,32,105
	.byte 110,32,35,105,102,47,101,110
	.byte 100,105,102,0
L491:
	.byte 69,109,112,116,121,32,99,104
	.byte 97,114,97,99,116,101,114,32
	.byte 99,111,110,115,116,97,110,116
	.byte 0
L440:
	.byte 87,105,100,101,32,99,104,97
	.byte 114,32,99,111,110,115,116,97
	.byte 110,116,32,118,97,108,117,101
	.byte 32,117,110,100,101,102,105,110
	.byte 101,100,0
L433:
	.byte 66,97,100,32,110,117,109,98
	.byte 101,114,32,37,116,32,105,110
	.byte 32,35,105,102,47,35,101,108
	.byte 115,105,102,0
L25:
	.byte 60,105,102,62,0
L499:
	.byte 67,104,97,114,97,99,116,101
	.byte 114,32,99,111,110,115,116,97
	.byte 110,116,32,116,97,107,101,110
	.byte 32,97,115,32,110,111,116,32
	.byte 115,105,103,110,101,100,0
L407:
	.byte 66,97,100,32,100,105,103,105
	.byte 116,32,105,110,32,110,117,109
	.byte 98,101,114,32,37,116,0
L502:
	.byte 83,116,114,105,110,103,32,105
	.byte 110,32,35,105,102,47,35,101
	.byte 108,115,105,102,0
L77:
	.byte 73,108,108,101,103,97,108,32
	.byte 111,112,101,114,97,116,111,114
	.byte 32,42,32,111,114,32,38,32
	.byte 105,110,32,35,105,102,47,35
	.byte 101,108,115,105,102,0
.globl _vals
.comm _vals, 512, 8
.globl _vp
.comm _vp, 8, 8
.globl _ops
.comm _ops, 128, 4
.globl _op
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
