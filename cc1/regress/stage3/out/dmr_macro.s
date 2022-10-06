.text

_dodefine:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%rbx
	movq (%rbx),%r12
	leaq 24(%r12),%rax
	cmpq 16(%rbx),%rax
	movq %rax,-24(%rbp)
	jae L8
L7:
	cmpb $2,24(%r12)
	jz L9
L8:
	pushq $L11
	jmp L93
L9:
	movl $1,%esi
	leaq 24(%r12),%rdi
	call _lookup
	testb $4,41(%rax)
	movq %rax,-40(%rbp)
	jnz L13
L15:
	leaq 48(%r12),%r15
	xorl %r14d,%r14d
	cmpq 16(%rbx),%r15
	jae L20
L25:
	cmpb $22,48(%r12)
	jnz L20
L26:
	cmpl $0,52(%r12)
	jnz L20
L22:
	xorl %r13d,%r13d
	leaq 72(%r12),%r15
	movl $32,%edi
	call _domalloc
	movq %rax,%r14
	movq %r14,%rsi
	movl $2,%edi
	call _maketokenrow
	cmpb $23,72(%r12)
	jnz L32
	jz L31
L38:
	cmpl 24(%r14),%r13d
	jl L42
L40:
	movq %r14,%rdi
	call _growtokenrow
L42:
	movq 8(%r14),%r12
L43:
	movq 16(%r14),%rcx
	cmpq %rcx,%r12
	jae L46
L44:
	movl 8(%r12),%eax
	movl 8(%r15),%edx
	cmpl %edx,%eax
	jnz L49
L50:
	movq 16(%r12),%rdi
	movq 16(%r15),%rsi
	call _strncmp
	testl %eax,%eax
	jnz L49
L51:
	pushq $L54
	pushq $1
	call _error
	addq $16,%rsp
L49:
	addq $24,%r12
	jmp L43
L46:
	leaq 24(%rcx),%rax
	movq %rax,16(%r14)
	movq (%r15),%rax
	movq %rax,(%rcx)
	movq 8(%r15),%rax
	movq %rax,8(%rcx)
	movq 16(%r15),%rax
	movq %rax,16(%rcx)
	incl %r13d
	addq $24,%r15
	movb (%r15),%al
	cmpb $23,%al
	jz L31
L57:
	cmpb $40,%al
	jnz L63
L61:
	addq $24,%r15
L32:
	cmpb $2,(%r15)
	jz L38
L63:
	pushq $L66
L93:
	pushq $1
	call _error
	addq $16,%rsp
	jmp L3
L31:
	addq $24,%r15
L20:
	movq %r15,(%rbx)
	movq 16(%rbx),%rcx
	movq %rcx,%rax
	subq $24,%rax
	cmpb $6,-24(%rcx)
	jnz L70
L68:
	movq %rax,16(%rbx)
L70:
	movq %rbx,%rdi
	call _normtokenrow
	movq %rax,-16(%rbp)
	movq -40(%rbp),%rax
	testb $1,41(%rax)
	jz L73
L71:
	movq -40(%rbp),%rax
	movq 24(%rax),%rsi
	movq -16(%rbp),%rdi
	call _comparetokens
	testl %eax,%eax
	jnz L78
L81:
	movq -40(%rbp),%rax
	movq 32(%rax),%rsi
	testq %rsi,%rsi
	setz %al
	movzbl %al,%eax
	movl %eax,-28(%rbp)
	testq %r14,%r14
	setz %al
	movzbl %al,%eax
	cmpl %eax,-28(%rbp)
	jnz L78
L83:
	testq %rsi,%rsi
	jz L73
L85:
	movq %r14,%rdi
	call _comparetokens
	testl %eax,%eax
	jz L73
L78:
	movq 8(%rbx),%rax
	addq $48,%rax
	pushq %rax
	pushq $L89
	pushq $1
	call _error
	addq $24,%rsp
L73:
	testq %r14,%r14
	jz L92
L90:
	movq %r14,%rdi
	call _normtokenrow
	movq %rax,-8(%rbp)
	movq 8(%r14),%rdi
	call _dofree
	movq -8(%rbp),%r14
L92:
	movq -40(%rbp),%rax
	movq %r14,32(%rax)
	movq -16(%rbp),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	orb $1,41(%rax)
	jmp L3
L13:
	pushq -24(%rbp)
	pushq $L16
	pushq $1
	call _error
	addq $24,%rsp
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
L97:
	.byte 49,0
.align 8
L98:
	.byte 3
	.byte 0
	.short 0
	.int 0
	.int 1
	.fill 4, 1, 0
	.quad L97
.align 8
L99:
	.quad L98
	.quad L98
	.quad L98+24
	.int 1
	.fill 4, 1, 0
.text

_doadefine:
L94:
	pushq %rbx
	pushq %r12
L95:
	movq %rdi,%r12
	movq 8(%r12),%rdi
	movq %rdi,(%r12)
	movq 16(%r12),%rax
	cmpl $85,%esi
	jz L100
L102:
	cmpq %rax,%rdi
	jae L110
L120:
	cmpb $2,(%rdi)
	jnz L110
L119:
	movl $1,%esi
	call _lookup
	movq %rax,%rbx
	orb $1,41(%rbx)
	movq (%r12),%rdx
	leaq 24(%rdx),%rax
	movq %rax,(%r12)
	movq 16(%r12),%rcx
	cmpq %rcx,%rax
	jae L125
L128:
	movb 24(%rdx),%al
	testb %al,%al
	jnz L127
L125:
	movq $L99,24(%rbx)
	jmp L96
L127:
	cmpb $39,%al
	jnz L110
L135:
	addq $48,%rdx
	movq %rdx,(%r12)
	movq %rcx,%rax
	subq $24,%rax
	cmpb $0,-24(%rcx)
	jnz L139
L137:
	movq %rax,16(%r12)
L139:
	movq %r12,%rdi
	call _normtokenrow
	movq %rax,24(%rbx)
	jmp L96
L100:
	subq %rdi,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq $2,%rax
	jnz L110
L106:
	cmpb $2,(%rdi)
	jz L105
L110:
	pushq %r12
	pushq $L141
	pushq $2
	call _error
	addq $24,%rsp
	jmp L96
L105:
	xorl %esi,%esi
	call _lookup
	testq %rax,%rax
	jz L96
L114:
	andb $-2,41(%rax)
L96:
	popq %r12
	popq %rbx
	ret 


_expandrow:
L142:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L143:
	movq %rdi,%r14
	movq %rsi,%r13
	testq %r13,%r13
	jz L213
L145:
	movl $L148,%edx
	xorl %esi,%esi
	movq %r13,%rdi
	call _setsource
L213:
	movq (%r14),%r12
L149:
	cmpq 16(%r14),%r12
	jae L152
L150:
	cmpb $2,(%r12)
	jnz L153
L168:
	movq 16(%r12),%rcx
	movb (%rcx),%al
	andb $63,%al
	movzbq %al,%rax
	movq _namebit(,%rax,8),%rdx
	cmpl $1,8(%r12)
	jbe L173
L172:
	movzbl 1(%rcx),%ecx
	jmp L174
L173:
	xorl %ecx,%ecx
L174:
	movl $1,%eax
	shll %cl,%eax
	testq %rdx,%rax
	jz L153
L164:
	xorl %esi,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L153
L160:
	testb $9,41(%rbx)
	jz L153
L156:
	movw 2(%r12),%di
	testw %di,%di
	jz L155
L175:
	movzwl %di,%edi
	movq %rbx,%rsi
	call _checkhideset
	testl %eax,%eax
	jz L155
L153:
	addq $24,%r12
	jmp L149
L155:
	movq %r12,(%r14)
	movb 40(%rbx),%sil
	cmpb $12,%sil
	jnz L182
L180:
	movb $58,(%r12)
	leaq 24(%r12),%rbx
	movq 16(%r14),%rcx
	cmpq %rcx,%rbx
	jae L184
L186:
	cmpb $2,24(%r12)
	jnz L184
L183:
	movb $57,24(%r12)
	jmp L185
L184:
	leaq 72(%r12),%rax
	cmpq %rax,%rcx
	jbe L191
L201:
	cmpb $22,24(%r12)
	jnz L191
L197:
	cmpb $2,48(%r12)
	jnz L191
L193:
	cmpb $23,72(%r12)
	jnz L191
L190:
	movb $57,48(%r12)
	jmp L185
L191:
	pushq $L205
	pushq $1
	call _error
	addq $16,%rsp
L185:
	movq %rbx,%r12
	jmp L149
L182:
	testb $8,41(%rbx)
	jz L208
L207:
	movsbl %sil,%esi
	movq %r14,%rdi
	call _builtin
	jmp L213
L208:
	movq %rbx,%rsi
	movq %r14,%rdi
	call _expand
	jmp L213
L152:
	testq %r13,%r13
	jz L144
L210:
	call _unsetsource
L144:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_expand:
L214:
	pushq %rbp
	movq %rsp,%rbp
	subq $304,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L215:
	movq %rdi,%r13
	movq %rsi,%r12
	movq 24(%r12),%rsi
	leaq -32(%rbp),%rdi
	call _copytokenrow
	cmpq $0,32(%r12)
	jnz L218
L217:
	movl $1,%ebx
	jmp L219
L218:
	leaq -300(%rbp),%rdx
	leaq -296(%rbp),%rsi
	movq %r13,%rdi
	call _gatherargs
	movl %eax,%ebx
	movl -300(%rbp),%esi
	cmpl $0,%esi
	jl L216
L222:
	movslq %esi,%rsi
	movq 32(%r12),%rcx
	movq 16(%rcx),%rax
	subq 8(%rcx),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq %rax,%rsi
	jnz L224
L226:
	leaq -296(%rbp),%rdx
	leaq -32(%rbp),%rsi
	movq %r12,%rdi
	call _substargs
	xorl %r14d,%r14d
	jmp L229
L230:
	movq -296(%rbp,%r14,8),%rax
	movq 8(%rax),%rdi
	call _dofree
	movq -296(%rbp,%r14,8),%rdi
	call _dofree
	incl %r14d
L229:
	cmpl %r14d,-300(%rbp)
	jg L230
L219:
	leaq -32(%rbp),%rdi
	call _doconcat
	movq (%r13),%rax
	movzwl 2(%rax),%edi
	movq %r12,%rsi
	call _newhideset
	movl %eax,%r14d
	movq -24(%rbp),%r12
	jmp L233
L234:
	cmpb $2,(%r12)
	jnz L239
L237:
	movw 2(%r12),%di
	testw %di,%di
	jnz L241
L240:
	movw %r14w,2(%r12)
	jmp L239
L241:
	movzwl %di,%edi
	movl %r14d,%esi
	call _unionhideset
	movw %ax,2(%r12)
L239:
	addq $24,%r12
L233:
	cmpq -16(%rbp),%r12
	jb L234
L236:
	movq -24(%rbp),%rax
	movq %rax,-32(%rbp)
	leaq -32(%rbp),%rdx
	movl %ebx,%esi
	movq %r13,%rdi
	call _insertrow
	movq -16(%rbp),%rax
	subq -24(%rbp),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	subq %rax,(%r13)
	movq -24(%rbp),%rdi
	call _dofree
	jmp L216
L224:
	pushq $L227
	pushq $1
	call _error
	addq $16,%rsp
	movq (%r13),%rax
	movzwl 2(%rax),%edi
	movq %r12,%rsi
	call _newhideset
	movq (%r13),%rcx
	movw %ax,2(%rcx)
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rcx
	shlq $3,%rcx
	addq (%r13),%rcx
	movq %rcx,(%r13)
L216:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gatherargs:
L244:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L245:
	movq %rdi,%r14
	movq %rsi,-40(%rbp)
	movl $-1,(%rdx)
	movq %rdx,-48(%rbp)
	movl $1,%r13d
	xorl %r15d,%r15d
L247:
	movq (%r14),%rax
	addq $24,%rax
	movq %rax,(%r14)
	incl %r15d
	cmpq 16(%r14),%rax
	jb L253
L251:
	xorl %esi,%esi
	movq %r14,%rdi
	call _gettokens
	movq 16(%r14),%rcx
	movq %rcx,%rax
	subq $24,%rax
	cmpb $0,-24(%rcx)
	jz L254
L253:
	movq (%r14),%rax
	movb (%rax),%al
	cmpb $22,%al
	jz L258
L260:
	cmpb $6,%al
	jz L247
	jnz L324
L258:
	movq -48(%rbp),%rax
	movl $0,(%rax)
	incl %r15d
	movl %r15d,%r12d
	addq $24,(%r14)
	xorl %ebx,%ebx
L267:
	movq (%r14),%rax
	cmpq 16(%r14),%rax
	jb L271
L269:
	xorl %esi,%esi
	movq %r14,%rdi
	call _gettokens
L271:
	testl %ebx,%ebx
	jz L274
L272:
	xorl %ebx,%ebx
	movq %r14,%rdi
	call _makespace
L274:
	movq (%r14),%rax
	movb (%rax),%cl
	testb %cl,%cl
	jz L275
L277:
	cmpb $6,%cl
	jz L280
L282:
	cmpb $22,%cl
	jnz L285
L284:
	incl %r13d
	jmp L286
L285:
	cmpb $23,%cl
	jnz L286
L287:
	decl %r13d
L286:
	addq $24,%rax
	movq %rax,(%r14)
	incl %r12d
	jmp L266
L280:
	addq $24,%rax
	movq %rax,(%r14)
	movl $-1,%esi
	movq %r14,%rdi
	call _adjustrow
	subq $24,(%r14)
	movq %r14,%rdi
	call _makespace
	movl $1,%ebx
L266:
	cmpl $0,%r13d
	jg L267
L268:
	movl %r12d,%r12d
	leaq (%r12,%r12,2),%rax
	shlq $3,%rax
	movq (%r14),%rbx
	subq %rax,%rbx
	movq %rbx,(%r14)
	movl %r15d,%r15d
	leaq (%r15,%r15,2),%rax
	shlq $3,%rax
	addq %rax,%rbx
	movq %rbx,%r14
L290:
	cmpl $0,%r13d
	jl L325
L291:
	movb (%r14),%al
	cmpb $22,%al
	jz L294
L296:
	cmpb $23,%al
	jnz L300
L298:
	decl %r13d
L300:
	cmpb $8,%al
	jnz L303
L301:
	movb $56,(%r14)
L303:
	cmpb $40,(%r14)
	jnz L307
L311:
	testl %r13d,%r13d
	jz L304
L307:
	cmpl $0,%r13d
	jge L292
L315:
	cmpb $22,-24(%r14)
	jz L292
L304:
	movq -48(%rbp),%rax
	cmpl $31,(%rax)
	jl L321
L319:
	pushq $L322
	pushq $2
	call _error
	addq $16,%rsp
L321:
	movq %rbx,-32(%rbp)
	movq %rbx,-24(%rbp)
	movq %r14,-16(%rbp)
	leaq -32(%rbp),%rdi
	call _normtokenrow
	movq -48(%rbp),%rcx
	movl (%rcx),%edx
	leal 1(%rdx),%esi
	movq -48(%rbp),%rcx
	movl %esi,(%rcx)
	movslq %edx,%rdx
	movq -40(%rbp),%rcx
	movq %rax,(%rcx,%rdx,8)
	leaq 24(%r14),%rbx
	jmp L292
L294:
	incl %r13d
L292:
	addq $24,%r14
	jmp L290
L275:
	subq $24,16(%r14)
	movl %r12d,%ecx
	leaq (%rcx,%rcx,2),%rcx
	shlq $3,%rcx
	subq %rcx,%rax
	movq %rax,(%r14)
	pushq $L278
	pushq $1
	call _error
	addq $16,%rsp
L325:
	movl %r12d,%eax
	jmp L246
L254:
	movq %rax,16(%r14)
	movl %r15d,%eax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	subq %rax,(%r14)
L324:
	movl %r15d,%eax
L246:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_substargs:
L326:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L327:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	movq 8(%r14),%rax
L367:
	movq %rax,(%r14)
L329:
	movq (%r14),%r12
	cmpq 16(%r14),%r12
	jae L328
L330:
	movb (%r12),%al
	cmpb $41,%al
	jz L333
L335:
	cmpb $2,%al
	jnz L344
L345:
	movq %r12,%rsi
	movq %r15,%rdi
	call _lookuparg
	cmpl $0,%eax
	jl L344
L342:
	movq (%r14),%rdx
	leaq 24(%rdx),%rcx
	cmpq 16(%r14),%rcx
	jae L352
L356:
	cmpb $8,24(%rdx)
	jz L349
L352:
	cmpq 8(%r14),%rdx
	jz L350
L360:
	cmpb $8,-24(%rdx)
	jnz L350
L349:
	movslq %eax,%rax
	movq (%r13,%rax,8),%rdx
	movl $1,%esi
	jmp L366
L350:
	movslq %eax,%rax
	movq (%r13,%rax,8),%rsi
	leaq -32(%rbp),%rdi
	call _copytokenrow
	movl $L364,%esi
	leaq -32(%rbp),%rdi
	call _expandrow
	leaq -32(%rbp),%rdx
	movl $1,%esi
	movq %r14,%rdi
	call _insertrow
	movq -24(%rbp),%rdi
	call _dofree
	jmp L329
L344:
	movq (%r14),%rax
	addq $24,%rax
	jmp L367
L333:
	leaq 24(%r12),%rax
	movq %rax,(%r14)
	leaq 24(%r12),%rsi
	movq %r15,%rdi
	call _lookuparg
	movl %eax,%esi
	cmpl $0,%esi
	jl L336
L338:
	movq (%r14),%rax
	subq %r12,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%ebx
	movq %r12,(%r14)
	movslq %esi,%rsi
	movq (%r13,%rsi,8),%rdi
	call _stringify
	movq %rax,%rdx
	leal 1(%rbx),%esi
L366:
	movq %r14,%rdi
	call _insertrow
	jmp L329
L336:
	pushq $L339
	pushq $1
	call _error
	addq $16,%rsp
	jmp L329
L328:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_doconcat:
L368:
	pushq %rbp
	movq %rsp,%rbp
	subq $160,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L369:
	movq %rdi,%r14
	movq 8(%r14),%rax
	jmp L399
L372:
	movb (%r12),%al
	cmpb $56,%al
	jnz L376
L375:
	movb $8,(%r12)
	jmp L373
L376:
	cmpb $8,%al
	jnz L373
L378:
	movq %r12,%r13
	subq $24,%r13
	leaq 24(%r12),%rbx
	cmpq 8(%r14),%r13
	jb L381
L384:
	cmpq %rbx,%rcx
	ja L383
L381:
	pushq $L388
	pushq $1
	call _error
	addq $16,%rsp
	jmp L373
L383:
	movl -16(%r12),%edx
	movl 32(%r12),%r15d
	addl %edx,%r15d
	movq -8(%r12),%rsi
	leaq -128(%rbp),%rdi
	call _strncpy
	movl -16(%r12),%eax
	movl 32(%r12),%edx
	movq 40(%r12),%rsi
	leaq -128(%rbp,%rax),%rdi
	call _strncpy
	movslq %r15d,%r15
	movb $0,-128(%rbp,%r15)
	leaq -128(%rbp),%rdx
	xorl %esi,%esi
	movl $L390,%edi
	call _setsource
	leaq -160(%rbp),%r12
	leaq -160(%rbp),%rsi
	movl $3,%edi
	call _maketokenrow
	movl $1,%esi
	leaq -160(%rbp),%rdi
	call _gettokens
	call _unsetsource
	movq -144(%rbp),%rax
	movq -152(%rbp),%rsi
	subq %rsi,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq $2,%rax
	jnz L391
L394:
	cmpb $1,(%rsi)
	jnz L393
L391:
	pushq %r12
	pushq $L398
	pushq $0
	call _error
	addq $24,%rsp
L393:
	movq -152(%rbp),%rax
	addq $24,%rax
	movq %rax,-144(%rbp)
	movq %r13,(%r14)
	leaq -160(%rbp),%rdi
	call _makespace
	subq %r13,%rbx
	movl $24,%ecx
	movq %rbx,%rax
	cqto 
	idivq %rcx
	leaq -160(%rbp),%rdx
	leal 1(%rax),%esi
	movq %r14,%rdi
	call _insertrow
	movq -152(%rbp),%rdi
	call _dofree
	addq $-24,(%r14)
L373:
	movq (%r14),%rax
	addq $24,%rax
L399:
	movq %rax,(%r14)
	movq (%r14),%r12
	movq 16(%r14),%rcx
	cmpq %rcx,%r12
	jb L372
L370:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lookuparg:
L400:
	pushq %rbx
	pushq %r12
	pushq %r13
L401:
	movq %rdi,%r13
	movq %rsi,%r12
	cmpb $2,(%r12)
	jnz L424
L406:
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L424
L405:
	movq 8(%rax),%rbx
L411:
	movq 32(%r13),%rax
	cmpq 16(%rax),%rbx
	jae L424
L412:
	movl 8(%rbx),%edx
	cmpl 8(%r12),%edx
	jnz L417
L418:
	movq 16(%rbx),%rdi
	movq 16(%r12),%rsi
	call _strncmp
	testl %eax,%eax
	jz L415
L417:
	addq $24,%rbx
	jmp L411
L415:
	movq 32(%r13),%rax
	subq 8(%rax),%rbx
	movl $24,%ecx
	movq %rbx,%rax
	cqto 
	idivq %rcx
	jmp L402
L424:
	movl $-1,%eax
L402:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
L428:
	.byte 4
	.fill 23, 1, 0
.align 8
L429:
	.quad L428
	.quad L428
	.quad L428+24
	.int 1
	.fill 4, 1, 0
.text

_stringify:
L425:
	pushq %rbp
	movq %rsp,%rbp
	subq $512,%rsp
	pushq %rbx
L426:
	movb $34,-512(%rbp)
	leaq -511(%rbp),%rbx
	movq 8(%rdi),%r8
L430:
	cmpq 16(%rdi),%r8
	jae L433
L431:
	movb (%r8),%al
	cmpb $4,%al
	jz L435
L434:
	cmpb $5,%al
	jnz L436
L435:
	movl $1,%esi
	jmp L437
L436:
	xorl %esi,%esi
L437:
	movl 8(%r8),%ecx
	shll $1,%ecx
	addq %rbx,%rcx
	leaq -10(%rbp),%rax
	cmpq %rax,%rcx
	jae L438
L440:
	cmpl $0,4(%r8)
	jz L445
L446:
	testb $1,1(%r8)
	jnz L445
L443:
	movb $32,(%rbx)
	incq %rbx
L445:
	xorl %edx,%edx
	movq 16(%r8),%rcx
	jmp L450
L451:
	testl %esi,%esi
	jz L456
L457:
	movb (%rcx),%al
	cmpb $34,%al
	jz L454
L461:
	cmpb $92,%al
	jnz L456
L454:
	movb $92,(%rbx)
	incq %rbx
L456:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%rbx)
	incq %rbx
	incl %edx
L450:
	cmpl 8(%r8),%edx
	jb L451
L453:
	addq $24,%r8
	jmp L430
L438:
	pushq $L441
	pushq $1
	call _error
	addq $16,%rsp
L433:
	movb $34,(%rbx)
	movb $0,1(%rbx)
	leaq -512(%rbp),%rdi
	call _strlen
	movl %eax,L428+8(%rip)
	xorl %edx,%edx
	movl %eax,%esi
	leaq -512(%rbp),%rdi
	call _newstring
	movq %rax,L428+16(%rip)
	movl $L429,%eax
L427:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_builtin:
L466:
	pushq %rbx
	pushq %r12
L467:
	movq (%rdi),%rbx
	leaq 24(%rbx),%rax
	movq %rax,(%rdi)
	movq _cursource(%rip),%rdx
	jmp L469
L472:
	cmpq $0,40(%rdx)
	jnz L471
L470:
	movq 56(%rdx),%rdx
L469:
	testq %rdx,%rdx
	jnz L472
L471:
	testq %rdx,%rdx
	jnz L478
L476:
	movq _cursource(%rip),%rdx
L478:
	movb $4,(%rbx)
	cmpl $0,4(%rbx)
	jz L481
L479:
	movq _outp(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_outp(%rip)
	movb $32,(%rcx)
	movl $1,4(%rbx)
L481:
	movq _outp(%rip),%r12
	movb $34,(%r12)
	leaq 1(%r12),%rdi
	cmpl $13,%esi
	jz L485
L505:
	cmpl $14,%esi
	jz L487
L506:
	cmpl $15,%esi
	jz L495
L507:
	cmpl $16,%esi
	jz L497
L508:
	pushq $L499
	pushq $1
	call _error
	addq $16,%rsp
	jmp L468
L497:
	movq _curtime(%rip),%rsi
	movl $8,%edx
	addq $11,%rsi
	leaq 1(%r12),%rdi
	call _strncpy
	leaq 9(%r12),%rax
	jmp L483
L495:
	movq _curtime(%rip),%rsi
	movl $7,%edx
	addq $4,%rsi
	leaq 1(%r12),%rdi
	call _strncpy
	movq _curtime(%rip),%rsi
	movl $4,%edx
	addq $20,%rsi
	leaq 8(%r12),%rdi
	call _strncpy
	leaq 12(%r12),%rax
	jmp L483
L487:
	movq (%rdx),%rcx
L488:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%rdi)
	incq %rdi
	testb %al,%al
	jz L490
L489:
	cmpb $92,-1(%rcx)
	jnz L488
L491:
	movb $92,(%rdi)
	incq %rdi
	jmp L488
L490:
	leaq -1(%rdi),%rax
	jmp L483
L485:
	movb $3,(%rbx)
	decq %rdi
	movl 8(%rdx),%esi
	call _outnum
L483:
	cmpb $4,(%rbx)
	jnz L503
L501:
	movb $34,(%rax)
	incq %rax
L503:
	movq _outp(%rip),%rcx
	movq %rcx,16(%rbx)
	movq %rax,%rcx
	subq _outp(%rip),%rcx
	movl %ecx,8(%rbx)
	movq %rax,_outp(%rip)
L468:
	popq %r12
	popq %rbx
	ret 

L148:
	.byte 0
L499:
	.byte 99,112,112,32,98,111,116,99
	.byte 104,58,32,117,110,107,110,111
	.byte 119,110,32,105,110,116,101,114
	.byte 110,97,108,32,109,97,99,114
	.byte 111,0
L390:
	.byte 60,35,35,62,0
L141:
	.byte 73,108,108,101,103,97,108,32
	.byte 45,68,32,111,114,32,45,85
	.byte 32,97,114,103,117,109,101,110
	.byte 116,32,37,114,0
L278:
	.byte 69,79,70,32,105,110,32,109
	.byte 97,99,114,111,32,97,114,103
	.byte 108,105,115,116,0
L205:
	.byte 73,110,99,111,114,114,101,99
	.byte 116,32,115,121,110,116,97,120
	.byte 32,102,111,114,32,96,100,101
	.byte 102,105,110,101,100,39,0
L388:
	.byte 35,35,32,111,99,99,117,114
	.byte 115,32,97,116,32,98,111,114
	.byte 100,101,114,32,111,102,32,114
	.byte 101,112,108,97,99,101,109,101
	.byte 110,116,0
L322:
	.byte 83,111,114,114,121,44,32,116
	.byte 111,111,32,109,97,110,121,32
	.byte 109,97,99,114,111,32,97,114
	.byte 103,117,109,101,110,116,115,0
L16:
	.byte 35,100,101,102,105,110,101,100
	.byte 32,116,111,107,101,110,32,37
	.byte 116,32,99,97,110,39,116,32
	.byte 98,101,32,114,101,100,101,102
	.byte 105,110,101,100,0
L227:
	.byte 68,105,115,97,103,114,101,101
	.byte 109,101,110,116,32,105,110,32
	.byte 110,117,109,98,101,114,32,111
	.byte 102,32,109,97,99,114,111,32
	.byte 97,114,103,117,109,101,110,116
	.byte 115,0
L89:
	.byte 77,97,99,114,111,32,114,101
	.byte 100,101,102,105,110,105,116,105
	.byte 111,110,32,111,102,32,37,116
	.byte 0
L441:
	.byte 83,116,114,105,110,103,105,102
	.byte 105,101,100,32,109,97,99,114
	.byte 111,32,97,114,103,32,105,115
	.byte 32,116,111,111,32,108,111,110
	.byte 103,0
L66:
	.byte 83,121,110,116,97,120,32,101
	.byte 114,114,111,114,32,105,110,32
	.byte 109,97,99,114,111,32,112,97
	.byte 114,97,109,101,116,101,114,115
	.byte 0
L364:
	.byte 60,109,97,99,114,111,62,0
L54:
	.byte 68,117,112,108,105,99,97,116
	.byte 101,32,109,97,99,114,111,32
	.byte 97,114,103,117,109,101,110,116
	.byte 0
L339:
	.byte 35,32,110,111,116,32,102,111
	.byte 108,108,111,119,101,100,32,98
	.byte 121,32,109,97,99,114,111,32
	.byte 112,97,114,97,109,101,116,101
	.byte 114,0
L11:
	.byte 35,100,101,102,105,110,101,100
	.byte 32,116,111,107,101,110,32,105
	.byte 115,32,110,111,116,32,97,32
	.byte 110,97,109,101,0
L398:
	.byte 66,97,100,32,116,111,107,101
	.byte 110,32,37,114,32,112,114,111
	.byte 100,117,99,101,100,32,98,121
	.byte 32,35,35,0

.globl _newhideset
.globl _cursource
.globl _checkhideset
.globl _growtokenrow
.globl _unionhideset
.globl _adjustrow
.globl _outnum
.globl _curtime
.globl _strncpy
.globl _copytokenrow
.globl _lookuparg
.globl _error
.globl _namebit
.globl _unsetsource
.globl _domalloc
.globl _strncmp
.globl _substargs
.globl _normtokenrow
.globl _stringify
.globl _builtin
.globl _doconcat
.globl _newstring
.globl _setsource
.globl _makespace
.globl _gatherargs
.globl _expand
.globl _insertrow
.globl _dofree
.globl _outp
.globl _lookup
.globl _maketokenrow
.globl _doadefine
.globl _gettokens
.globl _expandrow
.globl _strlen
.globl _comparetokens
.globl _dodefine
