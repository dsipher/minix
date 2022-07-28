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
	call _fputs
	jmp L85
L103:
	subl $16,%edx
	movslq %edx,%rdx
	movq %r14,%rsi
	movq _other_names(,%rdx,8),%rdi
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
L129:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L130:
	movq %rdi,%rbx
	movq $0,-8(%rbp)
	movl %esi,-8(%rbp)
	movl %edx,-4(%rbp)
	xorl %r12d,%r12d
L132:
	cmpl 4(%rbx),%r12d
	jge L135
L133:
	movq 8(%rbx),%rdx
	movslq %r12d,%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl -8(%rbp),%eax
	jg L138
	jl L135
L143:
	movl 4(%rdx,%rcx,8),%eax
	cmpl -4(%rbp),%eax
	jl L135
L138:
	incl %r12d
	jmp L132
L135:
	movl $8,%ecx
	movl $1,%edx
	movl %r12d,%esi
	movq %rbx,%rdi
	call _vector_insert
	movq 8(%rbx),%rcx
	movslq %r12d,%r12
	movq -8(%rbp),%rax
	movq %rax,(%rcx,%r12,8)
L131:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_same_regmap:
L148:
L149:
	movl 4(%rdi),%ecx
	xorl %eax,%eax
	cmpl 4(%rsi),%ecx
	jnz L150
L155:
	cmpl 4(%rdi),%eax
	jge L158
L156:
	movq 8(%rdi),%r9
	movslq %eax,%r8
	movl (%r9,%r8,8),%ecx
	movq 8(%rsi),%rdx
	cmpl (%rdx,%r8,8),%ecx
	jnz L159
L162:
	movl 4(%r9,%r8,8),%ecx
	cmpl 4(%rdx,%r8,8),%ecx
	jnz L159
L161:
	incl %eax
	jmp L155
L159:
	xorl %eax,%eax
	ret
L158:
	movl $1,%eax
L150:
	ret 


_regmap_regs:
L168:
	pushq %rbx
	pushq %r12
	pushq %r13
L169:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L171:
	cmpl 4(%r13),%ebx
	jge L170
L172:
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,8),%esi
	testl %esi,%esi
	jz L177
L175:
	movq %r12,%rdi
	call _add_reg
L177:
	incl %ebx
	jmp L171
L170:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_sort_regmap:
L178:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L181:
	xorl %eax,%eax
	xorl %esi,%esi
L184:
	movl 4(%rdi),%ecx
	decl %ecx
	cmpl %ecx,%esi
	jge L187
L185:
	movq 8(%rdi),%rdx
	leal 1(%rsi),%r9d
	movslq %r9d,%r8
	movl (%rdx,%r8,8),%ecx
	movslq %esi,%rsi
	cmpl (%rdx,%rsi,8),%ecx
	jl L192
	jg L190
L195:
	movl 4(%rdx,%r8,8),%ecx
	cmpl 4(%rdx,%rsi,8),%ecx
	jge L190
L192:
	movq (%rdx,%r8,8),%rcx
	movq %rcx,-8(%rbp)
	movq 8(%rdi),%rdx
	movq (%rdx,%rsi,8),%rcx
	movq %rcx,(%rdx,%r8,8)
	movq 8(%rdi),%rdx
	movq -8(%rbp),%rcx
	movq %rcx,(%rdx,%rsi,8)
	incl %eax
L190:
	movl %r9d,%esi
	jmp L184
L187:
	testl %eax,%eax
	jnz L181
L180:
	movq %rbp,%rsp
	popq %rbp
	ret 


_invert_regmap:
L202:
L203:
	xorl %r8d,%r8d
L205:
	cmpl 4(%rdi),%r8d
	jge L208
L209:
	movq 8(%rdi),%rsi
	movslq %r8d,%rdx
	movl (%rsi,%rdx,8),%ecx
	movl 4(%rsi,%rdx,8),%eax
	movl %eax,(%rsi,%rdx,8)
	movq 8(%rdi),%rax
	movl %ecx,4(%rax,%rdx,8)
	incl %r8d
	jmp L205
L208:
	call _sort_regmap
L204:
	ret 


_undecorate_regmap:
L212:
L213:
	xorl %edx,%edx
L215:
	cmpl 4(%rdi),%edx
	jge L214
L216:
	movq 8(%rdi),%rax
	movslq %edx,%rcx
	andl $-16384,4(%rax,%rcx,8)
	movq 8(%rdi),%rax
	andl $-16384,(%rax,%rcx,8)
	incl %edx
	jmp L215
L214:
	ret 


_regmap_substitute:
L219:
	pushq %rbx
L220:
	xorl %ebx,%ebx
	xorl %r8d,%r8d
L222:
	cmpl 4(%rdi),%r8d
	jge L225
L226:
	movq 8(%rdi),%rax
	movslq %r8d,%rcx
	cmpl (%rax,%rcx,8),%esi
	jnz L231
L229:
	incl %ebx
	movl %edx,(%rax,%rcx,8)
L231:
	movq 8(%rdi),%rax
	cmpl 4(%rax,%rcx,8),%esi
	jnz L237
L235:
	incl %ebx
	movl %edx,4(%rax,%rcx,8)
L237:
	incl %r8d
	jmp L222
L225:
	testl %ebx,%ebx
	jz L240
L238:
	call _sort_regmap
L240:
	movl %ebx,%eax
L221:
	popq %rbx
	ret 


_out_regmap:
L242:
	pushq %rbx
	pushq %r12
	pushq %r13
L243:
	movq _out_f(%rip),%rcx
	movq %rdi,%r13
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L246
L245:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $91,(%rcx)
	jmp L247
L246:
	movl $91,%edi
	call ___flushbuf
L247:
	xorl %r12d,%r12d
L248:
	cmpl 4(%r13),%r12d
	jge L251
L249:
	testl %r12d,%r12d
	jz L254
L252:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L256
L255:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $32,(%rcx)
	jmp L254
L256:
	movl $32,%edi
	call ___flushbuf
L254:
	movq 8(%r13),%rax
	movslq %r12d,%rbx
	movl (%rax,%rbx,8),%eax
	testl %eax,%eax
	jz L260
L258:
	pushq %rax
	pushq $L261
	call _out
	addq $16,%rsp
L260:
	movq 8(%r13),%rax
	movl 4(%rax,%rbx,8),%eax
	testl %eax,%eax
	jz L264
L262:
	pushq %rax
	pushq $L265
	call _out
	addq $16,%rsp
L264:
	incl %r12d
	jmp L248
L251:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L267
L266:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $93,(%rcx)
	jmp L244
L267:
	movl $93,%edi
	call ___flushbuf
L244:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reset_regs:
L269:
L270:
	movl $34,_nr_assigned_regs(%rip)
	movl $0,_reg_to_symbol(%rip)
	movl $0,_reg_to_symbol+4(%rip)
	movq $0,_reg_to_symbol+8(%rip)
	movq $_func_arena,_reg_to_symbol+16(%rip)
L271:
	ret 


_assign_reg:
L275:
	pushq %rbx
	pushq %r12
	pushq %r13
L276:
	movl _nr_assigned_regs(%rip),%ebx
	movq %rdi,%r13
	leal 1(%rbx),%eax
	movl %eax,_nr_assigned_regs(%rip)
	movl %ebx,%r12d
	subl $34,%r12d
	leal -33(%rbx),%edx
	cmpl _reg_to_symbol(%rip),%edx
	jg L282
L281:
	movl %edx,_reg_to_symbol+4(%rip)
	jmp L283
L282:
	movl _reg_to_symbol+4(%rip),%esi
	subl %esi,%edx
	movl $8,%ecx
	movl $_reg_to_symbol,%edi
	call _vector_insert
L283:
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
L277:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_add_reg:
L288:
	pushq %rbx
	pushq %r12
	pushq %r13
L289:
	movq %rdi,%r12
	movl %esi,%ebx
	xorl %r13d,%r13d
L291:
	cmpl 4(%r12),%r13d
	jge L294
L292:
	movq 8(%r12),%rcx
	movslq %r13d,%rax
	movl (%rcx,%rax,4),%eax
	cmpl %eax,%ebx
	jz L290
L297:
	cmpl %eax,%ebx
	jb L294
L301:
	incl %r13d
	jmp L291
L294:
	movl $4,%ecx
	movl $1,%edx
	movl %r13d,%esi
	movq %r12,%rdi
	call _vector_insert
	movq 8(%r12),%rax
	movslq %r13d,%r13
	movl %ebx,(%rax,%r13,4)
L290:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_contains_reg:
L303:
L304:
	xorl %edx,%edx
L306:
	cmpl 4(%rdi),%edx
	jge L309
L307:
	movq 8(%rdi),%rcx
	movslq %edx,%rax
	movl (%rcx,%rax,4),%eax
	cmpl %eax,%esi
	jz L310
L312:
	cmpl %eax,%esi
	jb L309
L316:
	incl %edx
	jmp L306
L310:
	movl $1,%eax
	ret
L309:
	xorl %eax,%eax
L305:
	ret 


_same_regs:
L319:
L320:
	movl 4(%rdi),%ecx
	xorl %eax,%eax
	cmpl 4(%rsi),%ecx
	jnz L321
L326:
	cmpl 4(%rdi),%eax
	jge L329
L327:
	movq 8(%rdi),%rcx
	movslq %eax,%r8
	movl (%rcx,%r8,4),%edx
	movq 8(%rsi),%rcx
	cmpl (%rcx,%r8,4),%edx
	jnz L330
L332:
	incl %eax
	jmp L326
L330:
	xorl %eax,%eax
	ret
L329:
	movl $1,%eax
L321:
	ret 


_union_regs:
L335:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L336:
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
	jl L342
L341:
	movl $0,4(%r15)
	jmp L344
L342:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movq %r15,%rdi
	call _vector_insert
L344:
	cmpl -4(%rbp),%r13d
	jl L348
L347:
	cmpl -8(%rbp),%r12d
	jge L337
L348:
	movq -16(%rbp),%rax
	cmpl 4(%rax),%r13d
	jnz L352
L351:
	movq 8(%r14),%rcx
	movl %r12d,%eax
	incl %r12d
	movslq %eax,%rax
	movl (%rcx,%rax,4),%ebx
	jmp L363
L352:
	movl 4(%r14),%ecx
	movq -16(%rbp),%rax
	movq 8(%rax),%rax
	cmpl %ecx,%r12d
	jnz L355
L354:
	movl %r13d,%ecx
	incl %r13d
	movslq %ecx,%rcx
	movl (%rax,%rcx,4),%ebx
	jmp L363
L355:
	movslq %r13d,%rcx
	movl (%rax,%rcx,4),%edx
	movq 8(%r14),%rcx
	movslq %r12d,%rax
	movl (%rcx,%rax,4),%ebx
	cmpl %ebx,%edx
	jae L358
L357:
	incl %r13d
	movl %edx,%ebx
	jmp L363
L358:
	incl %r12d
	cmpl %ebx,%edx
	ja L363
L361:
	incl %r13d
L363:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L367
L366:
	movl %eax,4(%r15)
	jmp L368
L367:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L368:
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movl %ebx,(%rcx,%rax,4)
	jmp L344
L337:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_intersect_regs:
L369:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L370:
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
	jl L376
L375:
	movl $0,4(%r15)
	jmp L378
L376:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movq %r15,%rdi
	call _vector_insert
L378:
	cmpl -4(%rbp),%r13d
	jge L371
L381:
	cmpl -8(%rbp),%r12d
	jge L371
L382:
	movq 8(%r14),%rax
	movslq %r13d,%rbx
	movl (%rax,%rbx,4),%edx
	movq -16(%rbp),%rax
	movq 8(%rax),%rcx
	movslq %r12d,%rax
	cmpl (%rcx,%rax,4),%edx
	jb L385
	ja L388
L391:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L395
L394:
	movl %eax,4(%r15)
	jmp L396
L395:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L396:
	movq 8(%r14),%rax
	movl (%rax,%rbx,4),%edx
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movl %edx,(%rcx,%rax,4)
	incl %r13d
	incl %r12d
	jmp L378
L388:
	incl %r12d
	jmp L378
L385:
	incl %r13d
	jmp L378
L371:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_diff_regs:
L397:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L398:
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
	jl L404
L403:
	movl $0,4(%r15)
	jmp L406
L404:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movq %r15,%rdi
	call _vector_insert
L406:
	cmpl -4(%rbp),%r12d
	jge L399
L407:
	cmpl -8(%rbp),%ebx
	jz L413
L412:
	movq 8(%r14),%rcx
	movslq %r12d,%rax
	movl (%rcx,%rax,4),%edx
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%eax
	cmpl %eax,%edx
	jae L414
L413:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L420
L419:
	movl %eax,4(%r15)
	jmp L421
L420:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L421:
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
	jmp L406
L414:
	incl %ebx
	cmpl %eax,%edx
	ja L406
L423:
	incl %r12d
	jmp L406
L399:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_replace_indexed_regs:
L426:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L427:
	movq %rdi,%r15
	movq %rsi,%r14
	xorl %r13d,%r13d
	xorl %r12d,%r12d
L429:
	cmpl 4(%r15),%r13d
	jge L442
L432:
	cmpl 4(%r14),%r12d
	jl L433
L442:
	cmpl 4(%r14),%r12d
	jge L428
L445:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L449
L448:
	movl %eax,4(%r15)
	jmp L450
L449:
	movl $4,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L450:
	movq 8(%r14),%rcx
	movslq %r12d,%rax
	movl (%rcx,%rax,4),%edx
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movl %edx,(%rcx,%rax,4)
	incl %r12d
	jmp L442
L428:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L433:
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
	jae L437
L436:
	incl %r13d
	jmp L429
L437:
	cmpl %eax,%ecx
	jnz L440
L439:
	movl $4,%ecx
	movl $1,%edx
	movl %r13d,%esi
	movq %r15,%rdi
	call _vector_delete
	jmp L429
L440:
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
	jmp L429


_select_indexed_regs:
L451:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L452:
	movq %rdi,%r14
	movq %rsi,%r13
	movl %edx,%r12d
	xorl %ebx,%ebx
L454:
	cmpl 4(%r13),%ebx
	jge L453
L455:
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%esi
	movl %esi,%ecx
	andl $-16384,%ecx
	movl %r12d,%eax
	andl $-16384,%eax
	cmpl %eax,%ecx
	jnz L460
L458:
	movq %r14,%rdi
	call _add_reg
L460:
	incl %ebx
	jmp L454
L453:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_out_regs:
L461:
	pushq %rbx
	pushq %r12
L462:
	movq _out_f(%rip),%rcx
	movq %rdi,%r12
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L465
L464:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $91,(%rcx)
	jmp L466
L465:
	movl $91,%edi
	call ___flushbuf
L466:
	xorl %ebx,%ebx
L467:
	cmpl 4(%r12),%ebx
	jge L470
L468:
	cmpl $0,%ebx
	jle L473
L471:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L475
L474:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $32,(%rcx)
	jmp L473
L475:
	movl $32,%edi
	call ___flushbuf
L473:
	movq 8(%r12),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%eax
	pushq %rax
	pushq $L261
	call _out
	addq $16,%rsp
	incl %ebx
	jmp L467
L470:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L478
L477:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $93,(%rcx)
	jmp L463
L478:
	movl $93,%edi
	call ___flushbuf
L463:
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
L265:
 .byte 58,37,114,0
L62:
 .byte 37,114,49,53,119,0
L261:
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
.comm _nr_assigned_regs, 4, 4
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
