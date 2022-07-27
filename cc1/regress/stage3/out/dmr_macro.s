.text

_dodefine:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r15
	movq (%r15),%rbx
	leaq 24(%rbx),%rax
	movq %rax,-24(%rbp)
	movq -24(%rbp),%rax
	cmpq 16(%r15),%rax
	jae L8
L7:
	cmpb $2,24(%rbx)
	jz L9
L8:
	pushq $L11
	pushq $1
	call _error
	addq $16,%rsp
	jmp L3
L9:
	movl $1,%esi
	leaq 24(%rbx),%rdi
	call _lookup
	movq %rax,-32(%rbp)
	movq -32(%rbp),%rax
	testb $4,41(%rax)
	jnz L13
L15:
	leaq 48(%rbx),%r14
	xorl %r13d,%r13d
	cmpq 16(%r15),%r14
	jae L20
L25:
	cmpb $22,48(%rbx)
	jnz L20
L26:
	cmpl $0,52(%rbx)
	jnz L20
L22:
	xorl %r12d,%r12d
	leaq 72(%rbx),%r14
	movl $32,%edi
	call _domalloc
	movq %rax,%r13
	movq %r13,%rsi
	movl $2,%edi
	call _maketokenrow
	cmpb $23,72(%rbx)
	jz L31
L32:
	cmpb $2,(%r14)
	jnz L63
L38:
	cmpl 24(%r13),%r12d
	jl L42
L40:
	movq %r13,%rdi
	call _growtokenrow
L42:
	movq 8(%r13),%rbx
L43:
	movq 16(%r13),%rcx
	cmpq %rcx,%rbx
	jae L46
L44:
	movl 8(%rbx),%eax
	movl 8(%r14),%edx
	cmpl %edx,%eax
	jnz L49
L50:
	movq 16(%rbx),%rdi
	movq 16(%r14),%rsi
	call _strncmp
	testl %eax,%eax
	jnz L49
L51:
	pushq $L54
	pushq $1
	call _error
	addq $16,%rsp
L49:
	addq $24,%rbx
	jmp L43
L46:
	leaq 24(%rcx),%rax
	movq %rax,16(%r13)
	movq (%r14),%rax
	movq %rax,(%rcx)
	movq 8(%r14),%rax
	movq %rax,8(%rcx)
	movq 16(%r14),%rax
	movq %rax,16(%rcx)
	incl %r12d
	addq $24,%r14
	movzbl (%r14),%eax
	cmpb $23,%al
	jz L31
L57:
	cmpb $40,%al
	jnz L63
L61:
	addq $24,%r14
	jmp L32
L63:
	pushq $L66
	pushq $1
	call _error
	addq $16,%rsp
	jmp L3
L31:
	addq $24,%r14
L20:
	movq %r14,(%r15)
	movq 16(%r15),%rcx
	movq %rcx,%rax
	subq $24,%rax
	cmpb $6,-24(%rcx)
	jnz L70
L68:
	movq %rax,16(%r15)
L70:
	movq %r15,%rdi
	call _normtokenrow
	movq %rax,-16(%rbp)
	movq -32(%rbp),%rax
	testb $1,41(%rax)
	jz L73
L71:
	movq -32(%rbp),%rax
	movq 24(%rax),%rsi
	movq -16(%rbp),%rdi
	call _comparetokens
	testl %eax,%eax
	jnz L78
L81:
	movq -32(%rbp),%rax
	movq 32(%rax),%rsi
	testq %rsi,%rsi
	setz %cl
	movzbl %cl,%ecx
	testq %r13,%r13
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L78
L83:
	testq %rsi,%rsi
	jz L73
L85:
	movq %r13,%rdi
	call _comparetokens
	testl %eax,%eax
	jz L73
L78:
	movq 8(%r15),%rax
	addq $48,%rax
	pushq %rax
	pushq $L89
	pushq $1
	call _error
	addq $24,%rsp
L73:
	testq %r13,%r13
	jz L92
L90:
	movq %r13,%rdi
	call _normtokenrow
	movq %rax,-8(%rbp)
	movq 8(%r13),%rdi
	call _dofree
	movq -8(%rbp),%r13
L92:
	movq -32(%rbp),%rax
	movq %r13,32(%rax)
	movq -16(%rbp),%rcx
	movq -32(%rbp),%rax
	movq %rcx,24(%rax)
	movq -32(%rbp),%rax
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
L96:
 .byte 49,0
.align 8
L97:
	.byte 3
	.byte 0
	.short 0
	.int 0
	.int 1
	.fill 4, 1, 0
	.quad L96
.align 8
L98:
	.quad L97
	.quad L97
	.quad L97+24
	.int 1
	.fill 4, 1, 0
.text

_doadefine:
L93:
	pushq %rbx
	pushq %r12
L94:
	movq %rdi,%r12
	movq 8(%r12),%rdi
	movq %rdi,(%r12)
	movq 16(%r12),%rax
	cmpl $85,%esi
	jz L99
L101:
	cmpq %rax,%rdi
	jae L109
L119:
	cmpb $2,(%rdi)
	jnz L109
L118:
	movl $1,%esi
	call _lookup
	movq %rax,%rbx
	orb $1,41(%rbx)
	movq (%r12),%rdx
	leaq 24(%rdx),%rax
	movq %rax,(%r12)
	movq 16(%r12),%rcx
	cmpq %rcx,%rax
	jae L124
L127:
	movzbl 24(%rdx),%eax
	testb %al,%al
	jnz L126
L124:
	movq $L98,24(%rbx)
	jmp L95
L126:
	cmpb $39,%al
	jnz L109
L134:
	addq $48,%rdx
	movq %rdx,(%r12)
	movq %rcx,%rax
	subq $24,%rax
	cmpb $0,-24(%rcx)
	jnz L138
L136:
	movq %rax,16(%r12)
L138:
	movq %r12,%rdi
	call _normtokenrow
	movq %rax,24(%rbx)
	jmp L95
L99:
	subq %rdi,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq $2,%rax
	jnz L109
L105:
	cmpb $2,(%rdi)
	jz L104
L109:
	pushq %r12
	pushq $L140
	pushq $2
	call _error
	addq $24,%rsp
	jmp L95
L104:
	xorl %esi,%esi
	call _lookup
	testq %rax,%rax
	jz L95
L113:
	andb $-2,41(%rax)
L95:
	popq %r12
	popq %rbx
	ret 


_expandrow:
L141:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L142:
	movq %rdi,%r14
	movq %rsi,%r13
	testq %r13,%r13
	jz L146
L144:
	movl $L147,%edx
	xorl %esi,%esi
	movq %r13,%rdi
	call _setsource
L146:
	movq (%r14),%r12
L148:
	cmpq 16(%r14),%r12
	jae L151
L149:
	cmpb $2,(%r12)
	jnz L152
L167:
	movq 16(%r12),%rcx
	movzbl (%rcx),%eax
	andl $63,%eax
	movzbq %al,%rax
	movq _namebit(,%rax,8),%rdx
	cmpl $1,8(%r12)
	jbe L172
L171:
	movzbl 1(%rcx),%ecx
	jmp L173
L172:
	xorl %ecx,%ecx
L173:
	andl $31,%ecx
	movl $1,%eax
	shll %cl,%eax
	movslq %eax,%rax
	testq %rdx,%rax
	jz L152
L163:
	xorl %esi,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L152
L159:
	testb $9,41(%rbx)
	jz L152
L155:
	movzwl 2(%r12),%edi
	testw %di,%di
	jz L154
L174:
	movzwl %di,%edi
	movq %rbx,%rsi
	call _checkhideset
	testl %eax,%eax
	jz L154
L152:
	addq $24,%r12
	jmp L148
L154:
	movq %r12,(%r14)
	movzbl 40(%rbx),%esi
	cmpb $12,%sil
	jz L179
L181:
	testb $8,41(%rbx)
	jz L207
L206:
	movsbl %sil,%esi
	movq %r14,%rdi
	call _builtin
	jmp L208
L207:
	movq %rbx,%rsi
	movq %r14,%rdi
	call _expand
L208:
	movq (%r14),%r12
	jmp L148
L179:
	movb $58,(%r12)
	leaq 24(%r12),%rbx
	movq 16(%r14),%rcx
	cmpq %rcx,%rbx
	jae L183
L185:
	cmpb $2,24(%r12)
	jnz L183
L182:
	movb $57,24(%r12)
	jmp L184
L183:
	leaq 72(%r12),%rax
	cmpq %rax,%rcx
	jbe L190
L200:
	cmpb $22,24(%r12)
	jnz L190
L196:
	cmpb $2,48(%r12)
	jnz L190
L192:
	cmpb $23,72(%r12)
	jnz L190
L189:
	movb $57,48(%r12)
	jmp L184
L190:
	pushq $L204
	pushq $1
	call _error
	addq $16,%rsp
L184:
	movq %rbx,%r12
	jmp L148
L151:
	testq %r13,%r13
	jz L143
L209:
	call _unsetsource
L143:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_expand:
L212:
	pushq %rbp
	movq %rsp,%rbp
	subq $304,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L213:
	movq %rdi,%r13
	movq %rsi,%r12
	movq 24(%r12),%rsi
	leaq -32(%rbp),%rdi
	call _copytokenrow
	cmpq $0,32(%r12)
	jnz L216
L215:
	movl $1,%ebx
	jmp L217
L216:
	leaq -300(%rbp),%rdx
	leaq -296(%rbp),%rsi
	movq %r13,%rdi
	call _gatherargs
	movl %eax,%ebx
	movl -300(%rbp),%esi
	cmpl $0,%esi
	jl L214
L220:
	movslq %esi,%rsi
	movq 32(%r12),%rcx
	movq 16(%rcx),%rax
	subq 8(%rcx),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq %rax,%rsi
	jnz L222
L224:
	leaq -296(%rbp),%rdx
	leaq -32(%rbp),%rsi
	movq %r12,%rdi
	call _substargs
	xorl %r15d,%r15d
L227:
	cmpl %r15d,-300(%rbp)
	jle L217
L228:
	movslq %r15d,%r14
	movq -296(%rbp,%r14,8),%rax
	movq 8(%rax),%rdi
	call _dofree
	movq -296(%rbp,%r14,8),%rdi
	call _dofree
	incl %r15d
	jmp L227
L217:
	leaq -32(%rbp),%rdi
	call _doconcat
	movq (%r13),%rax
	movzwl 2(%rax),%edi
	movq %r12,%rsi
	call _newhideset
	movl %eax,%r14d
	movq -24(%rbp),%r12
L231:
	cmpq -16(%rbp),%r12
	jae L234
L232:
	cmpb $2,(%r12)
	jnz L237
L235:
	movzwl 2(%r12),%edi
	testw %di,%di
	jnz L239
L238:
	movw %r14w,2(%r12)
	jmp L237
L239:
	movzwl %di,%edi
	movl %r14d,%esi
	call _unionhideset
	movw %ax,2(%r12)
L237:
	addq $24,%r12
	jmp L231
L234:
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
	jmp L214
L222:
	pushq $L225
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
L214:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gatherargs:
L242:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L243:
	movq %rdi,%r15
	movq %rsi,-40(%rbp)
	movq %rdx,-48(%rbp)
	movq -48(%rbp),%rcx
	movl $-1,(%rcx)
	movl $1,%r14d
	xorl %ebx,%ebx
L245:
	movq (%r15),%rax
	addq $24,%rax
	movq %rax,(%r15)
	incl %ebx
	cmpq 16(%r15),%rax
	jb L251
L249:
	xorl %esi,%esi
	movq %r15,%rdi
	call _gettokens
	movq 16(%r15),%rcx
	movq %rcx,%rax
	subq $24,%rax
	cmpb $0,-24(%rcx)
	jz L252
L251:
	movq (%r15),%rax
	movzbl (%rax),%eax
	cmpb $22,%al
	jz L256
L258:
	cmpb $6,%al
	jz L245
	jnz L322
L256:
	movq -48(%rbp),%rcx
	movl $0,(%rcx)
	incl %ebx
	movl %ebx,%r13d
	addq $24,(%r15)
	xorl %r12d,%r12d
L265:
	movq (%r15),%rax
	cmpq 16(%r15),%rax
	jb L269
L267:
	xorl %esi,%esi
	movq %r15,%rdi
	call _gettokens
L269:
	testl %r12d,%r12d
	jz L272
L270:
	xorl %r12d,%r12d
	movq %r15,%rdi
	call _makespace
L272:
	movq (%r15),%rax
	movzbl (%rax),%ecx
	testb %cl,%cl
	jz L273
L275:
	cmpb $6,%cl
	jz L278
L280:
	cmpb $22,%cl
	jnz L283
L282:
	incl %r14d
	jmp L284
L283:
	cmpb $23,%cl
	jnz L284
L285:
	decl %r14d
L284:
	addq $24,%rax
	movq %rax,(%r15)
	incl %r13d
	jmp L264
L278:
	addq $24,%rax
	movq %rax,(%r15)
	movl $-1,%esi
	movq %r15,%rdi
	call _adjustrow
	subq $24,(%r15)
	movq %r15,%rdi
	call _makespace
	movl $1,%r12d
L264:
	cmpl $0,%r14d
	jg L265
L266:
	movslq %r13d,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq (%r15),%r12
	subq %rax,%r12
	movq %r12,(%r15)
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	addq %rax,%r12
	movq %r12,%rbx
L288:
	cmpl $0,%r14d
	jl L323
L289:
	movzbl (%rbx),%eax
	cmpb $22,%al
	jz L292
L294:
	cmpb $23,%al
	jnz L298
L296:
	decl %r14d
L298:
	cmpb $8,%al
	jnz L301
L299:
	movb $56,(%rbx)
L301:
	cmpb $40,(%rbx)
	jnz L305
L309:
	testl %r14d,%r14d
	jz L302
L305:
	cmpl $0,%r14d
	jge L290
L313:
	cmpb $22,-24(%rbx)
	jz L290
L302:
	movq -48(%rbp),%rcx
	cmpl $31,(%rcx)
	jl L319
L317:
	pushq $L320
	pushq $2
	call _error
	addq $16,%rsp
L319:
	movq %r12,-32(%rbp)
	movq %r12,-24(%rbp)
	movq %rbx,-16(%rbp)
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
	leaq 24(%rbx),%r12
	jmp L290
L292:
	incl %r14d
L290:
	addq $24,%rbx
	jmp L288
L273:
	subq $24,16(%r15)
	movslq %r13d,%rcx
	leaq (%rcx,%rcx,2),%rcx
	shlq $3,%rcx
	subq %rcx,%rax
	movq %rax,(%r15)
	pushq $L276
	pushq $1
	call _error
	addq $16,%rsp
L323:
	movl %r13d,%eax
	jmp L244
L252:
	movq %rax,16(%r15)
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	subq %rax,(%r15)
L322:
	movl %ebx,%eax
L244:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_substargs:
L324:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L325:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	movq 8(%r14),%rax
	movq %rax,(%r14)
L327:
	movq (%r14),%r12
	cmpq 16(%r14),%r12
	jae L326
L328:
	movzbl (%r12),%eax
	cmpb $41,%al
	jz L331
L333:
	cmpb $2,%al
	jnz L342
L343:
	movq %r12,%rsi
	movq %r15,%rdi
	call _lookuparg
	cmpl $0,%eax
	jl L342
L340:
	movq (%r14),%rdx
	leaq 24(%rdx),%rcx
	cmpq 16(%r14),%rcx
	jae L350
L354:
	cmpb $8,24(%rdx)
	jz L347
L350:
	cmpq 8(%r14),%rdx
	jz L348
L358:
	cmpb $8,-24(%rdx)
	jnz L348
L347:
	movslq %eax,%rax
	movq (%r13,%rax,8),%rdx
	movl $1,%esi
	movq %r14,%rdi
	call _insertrow
	jmp L327
L348:
	movslq %eax,%rax
	movq (%r13,%rax,8),%rsi
	leaq -32(%rbp),%rdi
	call _copytokenrow
	movl $L362,%esi
	leaq -32(%rbp),%rdi
	call _expandrow
	leaq -32(%rbp),%rdx
	movl $1,%esi
	movq %r14,%rdi
	call _insertrow
	movq -24(%rbp),%rdi
	call _dofree
	jmp L327
L342:
	addq $24,(%r14)
	jmp L327
L331:
	leaq 24(%r12),%rax
	movq %rax,(%r14)
	leaq 24(%r12),%rsi
	movq %r15,%rdi
	call _lookuparg
	movl %eax,%esi
	cmpl $0,%esi
	jl L334
L336:
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
	movq %r14,%rdi
	call _insertrow
	jmp L327
L334:
	pushq $L337
	pushq $1
	call _error
	addq $16,%rsp
	jmp L327
L326:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_doconcat:
L364:
	pushq %rbp
	movq %rsp,%rbp
	subq $160,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L365:
	movq %rdi,%r15
	movq 8(%r15),%rax
	movq %rax,(%r15)
L367:
	movq (%r15),%r14
	movq 16(%r15),%rcx
	cmpq %rcx,%r14
	jae L366
L368:
	movzbl (%r14),%eax
	cmpb $56,%al
	jnz L372
L371:
	movb $8,(%r14)
	jmp L369
L372:
	cmpb $8,%al
	jnz L369
L374:
	movq %r14,%r13
	subq $24,%r13
	leaq 24(%r14),%rbx
	cmpq 8(%r15),%r13
	jb L377
L380:
	cmpq %rbx,%rcx
	ja L379
L377:
	pushq $L384
	pushq $1
	call _error
	addq $16,%rsp
	jmp L369
L379:
	movl -16(%r14),%edx
	movl 32(%r14),%r12d
	addl %edx,%r12d
	movq -8(%r14),%rsi
	leaq -128(%rbp),%rdi
	call _strncpy
	movl -16(%r14),%eax
	movl 32(%r14),%edx
	movq 40(%r14),%rsi
	leaq -128(%rbp,%rax),%rdi
	call _strncpy
	movslq %r12d,%r12
	movb $0,-128(%rbp,%r12)
	leaq -128(%rbp),%rdx
	xorl %esi,%esi
	movl $L386,%edi
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
	jnz L387
L390:
	cmpb $1,(%rsi)
	jnz L389
L387:
	pushq %r12
	pushq $L394
	pushq $0
	call _error
	addq $24,%rsp
L389:
	movq -152(%rbp),%rax
	addq $24,%rax
	movq %rax,-144(%rbp)
	movq %r13,(%r15)
	leaq -160(%rbp),%rdi
	call _makespace
	subq %r13,%rbx
	movl $24,%ecx
	movq %rbx,%rax
	cqto 
	idivq %rcx
	leaq -160(%rbp),%rdx
	leal 1(%rax),%esi
	movq %r15,%rdi
	call _insertrow
	movq -152(%rbp),%rdi
	call _dofree
	addq $-24,(%r15)
L369:
	addq $24,(%r15)
	jmp L367
L366:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lookuparg:
L395:
	pushq %rbx
	pushq %r12
	pushq %r13
L396:
	movq %rdi,%r13
	movq %rsi,%r12
	cmpb $2,(%r12)
	jnz L419
L401:
	movq 32(%r13),%rax
	testq %rax,%rax
	jz L419
L400:
	movq 8(%rax),%rbx
L406:
	movq 32(%r13),%rax
	cmpq 16(%rax),%rbx
	jae L419
L407:
	movl 8(%rbx),%edx
	cmpl 8(%r12),%edx
	jnz L412
L413:
	movq 16(%rbx),%rdi
	movq 16(%r12),%rsi
	call _strncmp
	testl %eax,%eax
	jz L410
L412:
	addq $24,%rbx
	jmp L406
L410:
	movq 32(%r13),%rax
	subq 8(%rax),%rbx
	movl $24,%ecx
	movq %rbx,%rax
	cqto 
	idivq %rcx
	jmp L397
L419:
	movl $-1,%eax
L397:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
L423:
	.byte 4
	.fill 23, 1, 0
.align 8
L424:
	.quad L423
	.quad L423
	.quad L423+24
	.int 1
	.fill 4, 1, 0
.text

_stringify:
L420:
	pushq %rbp
	movq %rsp,%rbp
	subq $512,%rsp
	pushq %rbx
L421:
	movb $34,-512(%rbp)
	leaq -511(%rbp),%rbx
	movq 8(%rdi),%r8
L425:
	cmpq 16(%rdi),%r8
	jae L428
L426:
	movzbl (%r8),%eax
	cmpb $4,%al
	jz L430
L429:
	cmpb $5,%al
	jnz L431
L430:
	movl $1,%esi
	jmp L432
L431:
	xorl %esi,%esi
L432:
	movl 8(%r8),%ecx
	shll $1,%ecx
	addq %rbx,%rcx
	leaq -10(%rbp),%rax
	cmpq %rax,%rcx
	jae L433
L435:
	cmpl $0,4(%r8)
	jz L440
L441:
	testb $1,1(%r8)
	jnz L440
L438:
	movb $32,(%rbx)
	incq %rbx
L440:
	xorl %edx,%edx
	movq 16(%r8),%rcx
L445:
	cmpl 8(%r8),%edx
	jae L448
L446:
	testl %esi,%esi
	jz L451
L452:
	movzbl (%rcx),%eax
	cmpb $34,%al
	jz L449
L456:
	cmpb $92,%al
	jnz L451
L449:
	movb $92,(%rbx)
	incq %rbx
L451:
	movzbl (%rcx),%eax
	incq %rcx
	movb %al,(%rbx)
	incq %rbx
	incl %edx
	jmp L445
L448:
	addq $24,%r8
	jmp L425
L433:
	pushq $L436
	pushq $1
	call _error
	addq $16,%rsp
L428:
	movb $34,(%rbx)
	movb $0,1(%rbx)
	leaq -512(%rbp),%rdi
	call _strlen
	movl %eax,L423+8(%rip)
	xorl %edx,%edx
	movl %eax,%esi
	leaq -512(%rbp),%rdi
	call _newstring
	movq %rax,L423+16(%rip)
	movl $L424,%eax
L422:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_builtin:
L461:
	pushq %rbx
	pushq %r12
L462:
	movq (%rdi),%rbx
	leaq 24(%rbx),%rax
	movq %rax,(%rdi)
	movq _cursource(%rip),%rdx
L464:
	testq %rdx,%rdx
	jz L466
L467:
	cmpq $0,40(%rdx)
	jnz L466
L465:
	movq 56(%rdx),%rdx
	jmp L464
L466:
	testq %rdx,%rdx
	jnz L473
L471:
	movq _cursource(%rip),%rdx
L473:
	movb $4,(%rbx)
	cmpl $0,4(%rbx)
	jz L476
L474:
	movq _outp(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_outp(%rip)
	movb $32,(%rcx)
	movl $1,4(%rbx)
L476:
	movq _outp(%rip),%r12
	movb $34,(%r12)
	leaq 1(%r12),%rdi
	cmpl $13,%esi
	jz L480
L500:
	cmpl $14,%esi
	jz L482
L501:
	cmpl $15,%esi
	jz L490
L502:
	cmpl $16,%esi
	jz L492
L503:
	pushq $L494
	pushq $1
	call _error
	addq $16,%rsp
	jmp L463
L492:
	movq _curtime(%rip),%rsi
	movl $8,%edx
	addq $11,%rsi
	leaq 1(%r12),%rdi
	call _strncpy
	leaq 9(%r12),%rax
	jmp L478
L490:
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
	jmp L478
L482:
	movq (%rdx),%rcx
L483:
	movzbl (%rcx),%eax
	incq %rcx
	movb %al,(%rdi)
	incq %rdi
	testb %al,%al
	jz L485
L484:
	cmpb $92,-1(%rcx)
	jnz L483
L486:
	movb $92,(%rdi)
	incq %rdi
	jmp L483
L485:
	leaq -1(%rdi),%rax
	jmp L478
L480:
	movb $3,(%rbx)
	decq %rdi
	movl 8(%rdx),%esi
	call _outnum
L478:
	cmpb $4,(%rbx)
	jnz L498
L496:
	movb $34,(%rax)
	incq %rax
L498:
	movq _outp(%rip),%rcx
	movq %rcx,16(%rbx)
	movq %rax,%rcx
	subq _outp(%rip),%rcx
	movl %ecx,8(%rbx)
	movq %rax,_outp(%rip)
L463:
	popq %r12
	popq %rbx
	ret 

L147:
 .byte 0
L494:
 .byte 99,112,112,32,98,111,116,99
 .byte 104,58,32,117,110,107,110,111
 .byte 119,110,32,105,110,116,101,114
 .byte 110,97,108,32,109,97,99,114
 .byte 111,0
L386:
 .byte 60,35,35,62,0
L140:
 .byte 73,108,108,101,103,97,108,32
 .byte 45,68,32,111,114,32,45,85
 .byte 32,97,114,103,117,109,101,110
 .byte 116,32,37,114,0
L276:
 .byte 69,79,70,32,105,110,32,109
 .byte 97,99,114,111,32,97,114,103
 .byte 108,105,115,116,0
L204:
 .byte 73,110,99,111,114,114,101,99
 .byte 116,32,115,121,110,116,97,120
 .byte 32,102,111,114,32,96,100,101
 .byte 102,105,110,101,100,39,0
L384:
 .byte 35,35,32,111,99,99,117,114
 .byte 115,32,97,116,32,98,111,114
 .byte 100,101,114,32,111,102,32,114
 .byte 101,112,108,97,99,101,109,101
 .byte 110,116,0
L320:
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
L225:
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
L436:
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
L362:
 .byte 60,109,97,99,114,111,62,0
L54:
 .byte 68,117,112,108,105,99,97,116
 .byte 101,32,109,97,99,114,111,32
 .byte 97,114,103,117,109,101,110,116
 .byte 0
L337:
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
L394:
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
