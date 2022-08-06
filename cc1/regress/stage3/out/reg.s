.data
.align 4
_iargs:
	.int -2147418112
	.int -2147434496
	.int -2147450880
	.int -2147467264
	.int -2147401728
	.int -2147385344
.align 4
_fargs:
	.int -1073479680
	.int -1073463296
	.int -1073446912
	.int -1073430528
	.int -1073414144
	.int -1073397760
	.int -1073381376
	.int -1073364992
.align 4
_iscratch:
	.int -2147483648
	.int -2147418112
	.int -2147434496
	.int -2147450880
	.int -2147467264
	.int -2147401728
	.int -2147385344
	.int -2147368960
	.int -2147352576
.align 4
_fscratch:
	.int -1073479680
	.int -1073463296
	.int -1073446912
	.int -1073430528
	.int -1073414144
	.int -1073397760
	.int -1073381376
	.int -1073364992
.align 8
_gp_names:
	.quad L1
	.quad L2
	.quad L3
	.quad L4
	.quad L5
	.quad L6
	.quad L7
	.quad L8
	.quad L9
	.quad L10
	.quad L11
	.quad L12
	.quad L13
	.quad L14
	.quad L15
	.quad L16
	.quad L17
	.quad L18
	.quad L19
	.quad L20
	.quad L21
	.quad L22
	.quad L23
	.quad L24
	.quad L25
	.quad L26
	.quad L27
	.quad L28
	.quad L29
	.quad L30
	.quad L31
	.quad L32
	.quad L33
	.quad L34
	.quad L35
	.quad L36
	.quad L37
	.quad L38
	.quad L39
	.quad L40
	.quad L41
	.quad L42
	.quad L43
	.quad L44
	.quad L45
	.quad L46
	.quad L47
	.quad L48
	.quad L49
	.quad L50
	.quad L51
	.quad L52
	.quad L53
	.quad L54
	.quad L55
	.quad L56
	.quad L57
	.quad L58
	.quad L59
	.quad L60
	.quad L61
	.quad L62
	.quad L63
	.quad L64
.align 8
_other_names:
	.quad L65
	.quad L66
	.quad L67
	.quad L68
	.quad L69
	.quad L70
	.quad L71
	.quad L72
	.quad L73
	.quad L74
	.quad L75
	.quad L76
	.quad L77
	.quad L78
	.quad L79
	.quad L80
	.quad L81
	.quad L82
.text

_print_reg:
L83:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L84:
	movq %rdi,%r14
	movl %esi,%r12d
	movl $3,%ebx
	movl %r12d,%r13d
	andl $3221225472,%r13d
	cmpl $2147483648,%r13d
	jnz L88
L86:
	andl $131071,%edx
	cmpq $2,%rdx
	jz L94
	jl L88
L121:
	cmpq $128,%rdx
	jz L98
	jg L88
L122:
	cmpb $4,%dl
	jz L94
L123:
	cmpb $8,%dl
	jz L94
L124:
	cmpb $16,%dl
	jz L96
L125:
	cmpb $32,%dl
	jz L96
L126:
	cmpb $64,%dl
	jz L98
	jnz L88
L94:
	movl $2,%ebx
L96:
	decl %ebx
L98:
	decl %ebx
L88:
	movl %r12d,%edx
	andl $1073725440,%edx
	sarl $14,%edx
	cmpl $34,%edx
	jge L100
L99:
	cmpl $2147483648,%r13d
	jnz L103
L102:
	leal (%rbx,%rdx,4),%eax
	movslq %eax,%rax
	movq %r14,%rsi
	movq _gp_names(,%rax,8),%rdi
	jmp L129
L103:
	subl $16,%edx
	movslq %edx,%rdx
	movq %r14,%rsi
	movq _other_names(,%rdx,8),%rdi
L129:
	call _fputs
	jmp L85
L100:
	cmpl $2147483648,%r13d
	movl $102,%eax
	movl $105,%ecx
	cmovnzl %eax,%ecx
	pushq %rdx
	pushq %rcx
	pushq $L105
	pushq %r14
	call _fprintf
	addq $32,%rsp
	cmpl $2147483648,%r13d
	jnz L111
L109:
	decl (%r14)
	movslq %ebx,%rbx
	js L114
L113:
	movb L112(%rbx),%dl
	movq 24(%r14),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r14)
	movb %dl,(%rcx)
	jmp L111
L114:
	movsbl L112(%rbx),%edi
	movq %r14,%rsi
	call ___flushbuf
L111:
	andl $16383,%r12d
	jz L85
L116:
	pushq %r12
	pushq $L119
	pushq %r14
	call _fprintf
	addq $24,%rsp
L85:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_add_regmap:
L130:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L131:
	movq %rdi,%rbx
	movq $0,-8(%rbp)
	movl %esi,-8(%rbp)
	movl %edx,-4(%rbp)
	xorl %r12d,%r12d
L133:
	cmpl 4(%rbx),%r12d
	jge L136
L134:
	movq 8(%rbx),%rdx
	movslq %r12d,%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl -8(%rbp),%eax
	jg L139
	jl L136
L144:
	movl 4(%rdx,%rcx,8),%eax
	cmpl -4(%rbp),%eax
	jl L136
L139:
	incl %r12d
	jmp L133
L136:
	movl $8,%ecx
	movl $1,%edx
	movl %r12d,%esi
	movq %rbx,%rdi
	call _vector_insert
	movq 8(%rbx),%rcx
	movslq %r12d,%r12
	movq -8(%rbp),%rax
	movq %rax,(%rcx,%r12,8)
L132:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_same_regmap:
L149:
L150:
	movl 4(%rdi),%ecx
	xorl %eax,%eax
	cmpl 4(%rsi),%ecx
	jnz L151
L156:
	cmpl 4(%rdi),%eax
	jge L159
L157:
	movq 8(%rdi),%r9
	movslq %eax,%r8
	movl (%r9,%r8,8),%ecx
	movq 8(%rsi),%rdx
	cmpl (%rdx,%r8,8),%ecx
	jnz L160
L163:
	movl 4(%r9,%r8,8),%ecx
	cmpl 4(%rdx,%r8,8),%ecx
	jnz L160
L162:
	incl %eax
	jmp L156
L160:
	xorl %eax,%eax
	ret
L159:
	movl $1,%eax
L151:
	ret 


_regmap_regs:
L169:
	pushq %rbx
	pushq %r12
	pushq %r13
L170:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L172:
	cmpl 4(%r13),%ebx
	jge L171
L173:
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,8),%esi
	testl %esi,%esi
	jz L178
L176:
	movq %r12,%rdi
	call _add_reg
L178:
	incl %ebx
	jmp L172
L171:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_sort_regmap:
L179:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L182:
	xorl %eax,%eax
	xorl %esi,%esi
L185:
	movl 4(%rdi),%ecx
	decl %ecx
	cmpl %ecx,%esi
	jge L188
L186:
	movq 8(%rdi),%rdx
	leal 1(%rsi),%r9d
	movslq %r9d,%r8
	movl (%rdx,%r8,8),%ecx
	movslq %esi,%rsi
	cmpl (%rdx,%rsi,8),%ecx
	jl L193
	jg L191
L196:
	movl 4(%rdx,%r8,8),%ecx
	cmpl 4(%rdx,%rsi,8),%ecx
	jge L191
L193:
	movq (%rdx,%r8,8),%rcx
	movq %rcx,-8(%rbp)
	movq 8(%rdi),%rdx
	movq (%rdx,%rsi,8),%rcx
	movq %rcx,(%rdx,%r8,8)
	movq 8(%rdi),%rdx
	movq -8(%rbp),%rcx
	movq %rcx,(%rdx,%rsi,8)
	incl %eax
L191:
	movl %r9d,%esi
	jmp L185
L188:
	testl %eax,%eax
	jnz L182
L181:
	movq %rbp,%rsp
	popq %rbp
	ret 


_invert_regmap:
L203:
L204:
	xorl %r8d,%r8d
L206:
	cmpl 4(%rdi),%r8d
	jge L209
L210:
	movq 8(%rdi),%rsi
	movslq %r8d,%rdx
	movl (%rsi,%rdx,8),%ecx
	movl 4(%rsi,%rdx,8),%eax
	movl %eax,(%rsi,%rdx,8)
	movq 8(%rdi),%rax
	movl %ecx,4(%rax,%rdx,8)
	incl %r8d
	jmp L206
L209:
	call _sort_regmap
L205:
	ret 


_undecorate_regmap:
L213:
L214:
	xorl %edx,%edx
L216:
	cmpl 4(%rdi),%edx
	jge L215
L217:
	movq 8(%rdi),%rax
	movslq %edx,%rcx
	andl $-16384,4(%rax,%rcx,8)
	movq 8(%rdi),%rax
	andl $-16384,(%rax,%rcx,8)
	incl %edx
	jmp L216
L215:
	ret 


_regmap_substitute:
L220:
	pushq %rbx
L221:
	xorl %ebx,%ebx
	xorl %r8d,%r8d
L223:
	cmpl 4(%rdi),%r8d
	jge L226
L227:
	movq 8(%rdi),%rax
	movslq %r8d,%rcx
	cmpl (%rax,%rcx,8),%esi
	jnz L232
L230:
	incl %ebx
	movl %edx,(%rax,%rcx,8)
L232:
	movq 8(%rdi),%rax
	cmpl 4(%rax,%rcx,8),%esi
	jnz L238
L236:
	incl %ebx
	movl %edx,4(%rax,%rcx,8)
L238:
	incl %r8d
	jmp L223
L226:
	testl %ebx,%ebx
	jz L241
L239:
	call _sort_regmap
L241:
	movl %ebx,%eax
L222:
	popq %rbx
	ret 


_out_regmap:
L243:
	pushq %rbx
	pushq %r12
	pushq %r13
L244:
	movq _out_f(%rip),%rcx
	movq %rdi,%r13
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L247
L246:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $91,(%rcx)
	jmp L248
L247:
	movl $91,%edi
	call ___flushbuf
L248:
	xorl %r12d,%r12d
L249:
	cmpl 4(%r13),%r12d
	jge L252
L250:
	testl %r12d,%r12d
	jz L255
L253:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L257
L256:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $32,(%rcx)
	jmp L255
L257:
	movl $32,%edi
	call ___flushbuf
L255:
	movq 8(%r13),%rax
	movslq %r12d,%rbx
	movl (%rax,%rbx,8),%eax
	testl %eax,%eax
	jz L261
L259:
	pushq %rax
	pushq $L262
	call _out
	addq $16,%rsp
L261:
	movq 8(%r13),%rax
	movl 4(%rax,%rbx,8),%eax
	testl %eax,%eax
	jz L265
L263:
	pushq %rax
	pushq $L266
	call _out
	addq $16,%rsp
L265:
	incl %r12d
	jmp L249
L252:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L268
L267:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $93,(%rcx)
	jmp L245
L268:
	movl $93,%edi
	call ___flushbuf
L245:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reset_regs:
L270:
L271:
	movl $34,_nr_assigned_regs(%rip)
	movl $0,_reg_to_symbol(%rip)
	movl $0,_reg_to_symbol+4(%rip)
	movq $0,_reg_to_symbol+8(%rip)
	movq $_func_arena,_reg_to_symbol+16(%rip)
L272:
	ret 


_assign_reg:
L276:
	pushq %rbx
	pushq %r12
	pushq %r13
L277:
	movl _nr_assigned_regs(%rip),%ebx
	movq %rdi,%r13
	leal 1(%rbx),%eax
	movl %eax,_nr_assigned_regs(%rip)
	movl %ebx,%r12d
	subl $34,%r12d
	leal -33(%rbx),%edx
	cmpl _reg_to_symbol(%rip),%edx
	jg L283
L282:
	movl %edx,_reg_to_symbol+4(%rip)
	jmp L284
L283:
	movl _reg_to_symbol+4(%rip),%esi
	subl %esi,%edx
	movl $8,%ecx
	movl $_reg_to_symbol,%edi
	call _vector_insert
L284:
	movq _reg_to_symbol+8(%rip),%rax
	movslq %r12d,%r12
	movq %r13,(%rax,%r12,8)
	movq 32(%r13),%rax
	testq $7168,(%rax)
	movl $-2147483648,%eax
	movl $-1073741824,%ecx
	cmovzl %eax,%ecx
	andl $-1073725441,%ecx
	shll $14,%ebx
	orl %ecx,%ebx
	movl %ebx,%eax
L278:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_add_reg:
L289:
	pushq %rbx
	pushq %r12
	pushq %r13
L290:
	movq %rdi,%r12
	movl %esi,%ebx
	xorl %r13d,%r13d
L292:
	cmpl 4(%r12),%r13d
	jge L295
L293:
	movq 8(%r12),%rcx
	movslq %r13d,%rax
	movl (%rcx,%rax,4),%eax
	cmpl %eax,%ebx
	jz L291
L298:
	cmpl %eax,%ebx
	jb L295
L302:
	incl %r13d
	jmp L292
L295:
	movl $4,%ecx
	movl $1,%edx
	movl %r13d,%esi
	movq %r12,%rdi
	call _vector_insert
	movq 8(%r12),%rax
	movslq %r13d,%r13
	movl %ebx,(%rax,%r13,4)
L291:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_contains_reg:
L304:
L305:
	xorl %edx,%edx
L307:
	cmpl 4(%rdi),%edx
	jge L310
L308:
	movq 8(%rdi),%rcx
	movslq %edx,%rax
	movl (%rcx,%rax,4),%eax
	cmpl %eax,%esi
	jz L311
L313:
	cmpl %eax,%esi
	jb L310
L317:
	incl %edx
	jmp L307
L311:
	movl $1,%eax
	ret
L310:
	xorl %eax,%eax
L306:
	ret 


_same_regs:
L320:
L321:
	movl 4(%rdi),%ecx
	xorl %eax,%eax
	cmpl 4(%rsi),%ecx
	jnz L322
L327:
	cmpl 4(%rdi),%eax
	jge L330
L328:
	movq 8(%rdi),%rcx
	movslq %eax,%r8
	movl (%rcx,%r8,4),%edx
	movq 8(%rsi),%rcx
	cmpl (%rcx,%r8,4),%edx
	jnz L331
L333:
	incl %eax
	jmp L327
L331:
	xorl %eax,%eax
	ret
L330:
	movl $1,%eax
L322:
	ret 


_union_regs:
L336:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L337:
	movq %rdi,%r15
	movq %rsi,-16(%rbp)
	movq %rdx,%r14
	xorl %r13d,%r13d
	xorl %r12d,%r12d
	movq -16(%rbp),%rax
	movl 4(%rax),%eax
	movl %eax,-4(%rbp)
	movl 4(%r14),%eax
	movl %eax,-8(%rbp)
	cmpl $0,(%r15)
	jl L343
L342:
	movl $0,4(%r15)
	jmp L345
L343:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movq %r15,%rdi
	call _vector_insert
L345:
	cmpl -4(%rbp),%r13d
	jl L349
L348:
	cmpl -8(%rbp),%r12d
	jge L338
L349:
	movq -16(%rbp),%rax
	cmpl 4(%rax),%r13d
	jnz L353
L352:
	movq 8(%r14),%rcx
	movl %r12d,%eax
	incl %r12d
	movslq %eax,%rax
	movl (%rcx,%rax,4),%ebx
	jmp L364
L353:
	movl 4(%r14),%ecx
	movq -16(%rbp),%rax
	movq 8(%rax),%rax
	cmpl %ecx,%r12d
	jnz L356
L355:
	movl %r13d,%ecx
	incl %r13d
	movslq %ecx,%rcx
	movl (%rax,%rcx,4),%ebx
	jmp L364
L356:
	movslq %r13d,%rcx
	movl (%rax,%rcx,4),%edx
	movq 8(%r14),%rcx
	movslq %r12d,%rax
	movl (%rcx,%rax,4),%ebx
	cmpl %ebx,%edx
	jae L359
L358:
	incl %r13d
	movl %edx,%ebx
	jmp L364
L359:
	incl %r12d
	cmpl %ebx,%edx
	ja L364
L362:
	incl %r13d
L364:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L368
L367:
	movl %eax,4(%r15)
	jmp L369
L368:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L369:
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movl %ebx,(%rcx,%rax,4)
	jmp L345
L338:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_intersect_regs:
L370:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L371:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,-16(%rbp)
	xorl %r13d,%r13d
	xorl %r12d,%r12d
	movl 4(%r14),%eax
	movl %eax,-4(%rbp)
	movq -16(%rbp),%rax
	movl 4(%rax),%eax
	movl %eax,-8(%rbp)
	cmpl $0,(%r15)
	jl L377
L376:
	movl $0,4(%r15)
	jmp L379
L377:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movq %r15,%rdi
	call _vector_insert
L379:
	cmpl -4(%rbp),%r13d
	jge L372
L382:
	cmpl -8(%rbp),%r12d
	jge L372
L383:
	movq 8(%r14),%rax
	movslq %r13d,%rbx
	movl (%rax,%rbx,4),%edx
	movq -16(%rbp),%rax
	movq 8(%rax),%rcx
	movslq %r12d,%rax
	cmpl (%rcx,%rax,4),%edx
	jb L386
	ja L398
L392:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L396
L395:
	movl %eax,4(%r15)
	jmp L397
L396:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L397:
	movq 8(%r14),%rax
	movl (%rax,%rbx,4),%edx
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movl %edx,(%rcx,%rax,4)
	incl %r13d
L398:
	incl %r12d
	jmp L379
L386:
	incl %r13d
	jmp L379
L372:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_diff_regs:
L399:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L400:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	movl 4(%r14),%eax
	movl %eax,-4(%rbp)
	movl 4(%r13),%eax
	movl %eax,-8(%rbp)
	cmpl $0,(%r15)
	jl L406
L405:
	movl $0,4(%r15)
	jmp L408
L406:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movq %r15,%rdi
	call _vector_insert
L408:
	cmpl -4(%rbp),%r12d
	jge L401
L409:
	cmpl -8(%rbp),%ebx
	jz L415
L414:
	movq 8(%r14),%rcx
	movslq %r12d,%rax
	movl (%rcx,%rax,4),%edx
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%eax
	cmpl %eax,%edx
	jae L416
L415:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L422
L421:
	movl %eax,4(%r15)
	jmp L423
L422:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L423:
	movq 8(%r14),%rcx
	movl %r12d,%eax
	incl %r12d
	movslq %eax,%rax
	movl (%rcx,%rax,4),%edx
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movl %edx,(%rcx,%rax,4)
	jmp L408
L416:
	incl %ebx
	cmpl %eax,%edx
	ja L408
L425:
	incl %r12d
	jmp L408
L401:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_replace_indexed_regs:
L428:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L429:
	movq %rdi,%r15
	movq %rsi,%r14
	xorl %r13d,%r13d
	xorl %r12d,%r12d
L431:
	cmpl 4(%r15),%r13d
	jge L444
L434:
	cmpl 4(%r14),%r12d
	jl L435
L444:
	cmpl 4(%r14),%r12d
	jge L430
L447:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L451
L450:
	movl %eax,4(%r15)
	jmp L452
L451:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L452:
	movq 8(%r14),%rcx
	movslq %r12d,%rax
	movl (%rcx,%rax,4),%edx
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movl %edx,(%rcx,%rax,4)
	incl %r12d
	jmp L444
L430:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L435:
	movq 8(%r15),%rcx
	movslq %r13d,%rax
	movq %rax,-8(%rbp)
	movq -8(%rbp),%rax
	movl (%rcx,%rax,4),%ecx
	andl $-16384,%ecx
	movq 8(%r14),%rax
	movslq %r12d,%rbx
	movl (%rax,%rbx,4),%eax
	andl $-16384,%eax
	cmpl %eax,%ecx
	jae L439
L438:
	incl %r13d
	jmp L431
L439:
	cmpl %eax,%ecx
	jnz L442
L441:
	movl $4,%ecx
	movl $1,%edx
	movl %r13d,%esi
	movq %r15,%rdi
	call _vector_delete
	jmp L431
L442:
	movl $4,%ecx
	movl $1,%edx
	movl %r13d,%esi
	movq %r15,%rdi
	call _vector_insert
	movq 8(%r14),%rax
	movl (%rax,%rbx,4),%edx
	movq 8(%r15),%rcx
	movq -8(%rbp),%rax
	movl %edx,(%rcx,%rax,4)
	incl %r13d
	incl %r12d
	jmp L431


_select_indexed_regs:
L453:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L454:
	movq %rdi,%r14
	movq %rsi,%r13
	movl %edx,%r12d
	xorl %ebx,%ebx
L456:
	cmpl 4(%r13),%ebx
	jge L455
L457:
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%esi
	movl %esi,%ecx
	andl $-16384,%ecx
	movl %r12d,%eax
	andl $-16384,%eax
	cmpl %eax,%ecx
	jnz L462
L460:
	movq %r14,%rdi
	call _add_reg
L462:
	incl %ebx
	jmp L456
L455:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_out_regs:
L463:
	pushq %rbx
	pushq %r12
L464:
	movq _out_f(%rip),%rcx
	movq %rdi,%r12
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L467
L466:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $91,(%rcx)
	jmp L468
L467:
	movl $91,%edi
	call ___flushbuf
L468:
	xorl %ebx,%ebx
L469:
	cmpl 4(%r12),%ebx
	jge L472
L470:
	cmpl $0,%ebx
	jle L475
L473:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L477
L476:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $32,(%rcx)
	jmp L475
L477:
	movl $32,%edi
	call ___flushbuf
L475:
	movq 8(%r12),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%eax
	pushq %rax
	pushq $L262
	call _out
	addq $16,%rsp
	incl %ebx
	jmp L469
L472:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L480
L479:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $93,(%rcx)
	jmp L465
L480:
	movl $93,%edi
	call ___flushbuf
L465:
	popq %r12
	popq %rbx
	ret 

L65:
 .byte 37,120,109,109,48,0
L66:
 .byte 37,120,109,109,49,0
L81:
 .byte 37,99,99,0
L41:
 .byte 37,115,112,108,0
L32:
 .byte 37,114,49,48,0
L36:
 .byte 37,114,49,49,0
L23:
 .byte 37,114,56,100,0
L8:
 .byte 37,114,99,120,0
L10:
 .byte 37,100,120,0
L64:
 .byte 37,114,49,53,0
L60:
 .byte 37,114,49,52,0
L42:
 .byte 37,115,112,0
L63:
 .byte 37,114,49,53,100,0
L70:
 .byte 37,120,109,109,53,0
L24:
 .byte 37,114,56,0
L3:
 .byte 37,101,97,120,0
L69:
 .byte 37,120,109,109,52,0
L28:
 .byte 37,114,57,0
L15:
 .byte 37,101,115,105,0
L38:
 .byte 37,98,120,0
L79:
 .byte 37,120,109,109,49,52,0
L80:
 .byte 37,120,109,109,49,53,0
L5:
 .byte 37,99,108,0
L55:
 .byte 37,114,49,51,100,0
L30:
 .byte 37,114,49,48,119,0
L33:
 .byte 37,114,49,49,98,0
L76:
 .byte 37,120,109,109,49,49,0
L20:
 .byte 37,114,100,105,0
L75:
 .byte 37,120,109,109,49,48,0
L13:
 .byte 37,115,105,108,0
L47:
 .byte 37,101,98,112,0
L37:
 .byte 37,98,108,0
L12:
 .byte 37,114,100,120,0
L6:
 .byte 37,99,120,0
L29:
 .byte 37,114,49,48,98,0
L34:
 .byte 37,114,49,49,119,0
L51:
 .byte 37,114,49,50,100,0
L44:
 .byte 37,114,115,112,0
L9:
 .byte 37,100,108,0
L40:
 .byte 37,114,98,120,0
L119:
 .byte 46,37,100,0
L59:
 .byte 37,114,49,52,100,0
L82:
 .byte 37,109,101,109,0
L27:
 .byte 37,114,57,100,0
L18:
 .byte 37,100,105,0
L266:
 .byte 58,37,114,0
L62:
 .byte 37,114,49,53,119,0
L262:
 .byte 37,114,0
L57:
 .byte 37,114,49,52,98,0
L39:
 .byte 37,101,98,120,0
L105:
 .byte 37,37,37,99,37,100,0
L22:
 .byte 37,114,56,119,0
L25:
 .byte 37,114,57,98,0
L48:
 .byte 37,114,98,112,0
L17:
 .byte 37,100,105,108,0
L31:
 .byte 37,114,49,48,100,0
L54:
 .byte 37,114,49,51,119,0
L49:
 .byte 37,114,49,50,98,0
L11:
 .byte 37,101,100,120,0
L2:
 .byte 37,97,120,0
L14:
 .byte 37,115,105,0
L43:
 .byte 37,101,115,112,0
L53:
 .byte 37,114,49,51,98,0
L50:
 .byte 37,114,49,50,119,0
L35:
 .byte 37,114,49,49,100,0
L1:
 .byte 37,97,108,0
L77:
 .byte 37,120,109,109,49,50,0
L74:
 .byte 37,120,109,109,57,0
L78:
 .byte 37,120,109,109,49,51,0
L73:
 .byte 37,120,109,109,56,0
L112:
 .byte 98,119,100,113,0
L19:
 .byte 37,101,100,105,0
L21:
 .byte 37,114,56,98,0
L26:
 .byte 37,114,57,119,0
L71:
 .byte 37,120,109,109,54,0
L72:
 .byte 37,120,109,109,55,0
L46:
 .byte 37,98,112,0
L45:
 .byte 37,98,112,108,0
L61:
 .byte 37,114,49,53,98,0
L7:
 .byte 37,101,99,120,0
L68:
 .byte 37,120,109,109,51,0
L67:
 .byte 37,120,109,109,50,0
L58:
 .byte 37,114,49,52,119,0
L56:
 .byte 37,114,49,51,0
L16:
 .byte 37,114,115,105,0
L4:
 .byte 37,114,97,120,0
L52:
 .byte 37,114,49,50,0
.globl _nr_assigned_regs
.comm _nr_assigned_regs, 4, 4
.globl _reg_to_symbol
.comm _reg_to_symbol, 24, 8

.globl _fargs
.globl _out_regs
.globl _same_regs
.globl _reg_to_symbol
.globl _diff_regs
.globl _out_regmap
.globl _print_reg
.globl _fscratch
.globl _iscratch
.globl _union_regs
.globl _contains_reg
.globl _iargs
.globl _regmap_substitute
.globl _invert_regmap
.globl _add_regmap
.globl _replace_indexed_regs
.globl _add_reg
.globl ___flushbuf
.globl _out
.globl _select_indexed_regs
.globl _assign_reg
.globl _same_regmap
.globl _nr_assigned_regs
.globl _undecorate_regmap
.globl _out_f
.globl _vector_insert
.globl _func_arena
.globl _regmap_regs
.globl _reset_regs
.globl _vector_delete
.globl _fputs
.globl _intersect_regs
.globl _fprintf
