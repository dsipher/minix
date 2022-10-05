.data
_line_format:
	.byte 35,108,105,110,101,32,37,100
	.byte 32,34,37,115,34,10,0
.text

_cachec:
L1:
	pushq %rbx
L2:
	movl %edi,%ebx
	cmpl $0,_cinc(%rip)
	jge L6
L4:
	movl $55,%edx
	movl $L8,%esi
	movl $L7,%edi
	call ___assert
L6:
	movl _cinc(%rip),%eax
	movl _cache_size(%rip),%esi
	cmpl %esi,%eax
	jl L11
L9:
	addl $256,%esi
	movl %esi,_cache_size(%rip)
	movq _cache(%rip),%rdi
	call _realloc
	movq %rax,_cache(%rip)
	testq %rax,%rax
	jnz L11
L12:
	call _no_space
L11:
	movslq _cinc(%rip),%rax
	movq _cache(%rip),%rcx
	movb %bl,(%rax,%rcx)
	incl _cinc(%rip)
L3:
	popq %rbx
	ret 


_get_line:
L15:
	pushq %rbx
	pushq %r12
	pushq %r13
L16:
	movq _input_file(%rip),%rbx
	cmpb $0,_saw_eof(%rip)
	jnz L22
L21:
	decl (%rbx)
	js L26
L25:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movzbl (%rcx),%r13d
	jmp L27
L26:
	movq %rbx,%rdi
	call ___fillbuf
	movl %eax,%r13d
L27:
	cmpl $-1,%r13d
	jnz L23
L22:
	movq _line(%rip),%rdi
	testq %rdi,%rdi
	jz L30
L28:
	call _free
	movq $0,_line(%rip)
L30:
	movq $0,_cptr(%rip)
	movb $1,_saw_eof(%rip)
	jmp L17
L23:
	movq _line(%rip),%rdi
	testq %rdi,%rdi
	jz L36
L35:
	cmpl $101,_linesize(%rip)
	jz L34
L36:
	testq %rdi,%rdi
	jz L41
L39:
	call _free
L41:
	movl $101,_linesize(%rip)
	movl $101,%edi
	call _malloc
	movq %rax,_line(%rip)
	testq %rax,%rax
	jnz L34
L42:
	call _no_space
L34:
	xorl %r12d,%r12d
	incl _lineno(%rip)
L45:
	movq _line(%rip),%rax
	movb %r13b,(%r12,%rax)
	cmpl $10,%r13d
	jz L66
L51:
	movl _linesize(%rip),%esi
	incl %r12d
	cmpl %r12d,%esi
	jg L55
L53:
	addl $100,%esi
	movl %esi,_linesize(%rip)
	movq _line(%rip),%rdi
	call _realloc
	movq %rax,_line(%rip)
	testq %rax,%rax
	jnz L55
L56:
	call _no_space
L55:
	decl (%rbx)
	js L60
L59:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movzbl (%rcx),%r13d
	jmp L61
L60:
	movq %rbx,%rdi
	call ___fillbuf
	movl %eax,%r13d
L61:
	cmpl $-1,%r13d
	jnz L45
L62:
	movl %r12d,%eax
	movq _line(%rip),%rcx
	movb $10,(%rax,%rcx)
	movb $1,_saw_eof(%rip)
L66:
	movq _line(%rip),%rax
	movq %rax,_cptr(%rip)
L17:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_dup_line:
L67:
	pushq %rbx
L68:
	movq _line(%rip),%rax
	testq %rax,%rax
	jnz L74
	jz L70
L75:
	incq %rax
L74:
	cmpb $10,(%rax)
	jnz L75
L76:
	subq _line(%rip),%rax
	incl %eax
	movl %eax,%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L79
L77:
	call _no_space
L79:
	movq _line(%rip),%rdx
	movq %rbx,%rcx
L80:
	movb (%rdx),%al
	incq %rdx
	movb %al,(%rcx)
	incq %rcx
	cmpb $10,%al
	jnz L80
L82:
	movq %rbx,%rax
	jmp L69
L70:
	xorl %eax,%eax
L69:
	popq %rbx
	ret 


_skip_comment:
L85:
	pushq %rbx
	pushq %r12
	pushq %r13
L86:
	movl _lineno(%rip),%r13d
	call _dup_line
	movq %rax,%r12
	movq _cptr(%rip),%rcx
	movq %rcx,%rbx
	subq _line(%rip),%rbx
	addq $2,%rcx
L88:
	movb (%rcx),%al
	cmpb $42,%al
	jnz L94
L95:
	cmpb $47,1(%rcx)
	jz L92
L94:
	cmpb $10,%al
	jnz L101
L100:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L105
L103:
	leaq (%rbx,%r12),%rdx
	movq %r12,%rsi
	movl %r13d,%edi
	call _unterminated_comment
L105:
	movq _cptr(%rip),%rcx
	jmp L88
L101:
	incq %rcx
	jmp L88
L92:
	addq $2,%rcx
	movq %rcx,_cptr(%rip)
	movq %r12,%rdi
	call _free
L87:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L166:
	.short L135-_nextc
	.short L123-_nextc
	.short L135-_nextc
	.short L135-_nextc
	.short L135-_nextc

_nextc:
L106:
L107:
	cmpq $0,_line(%rip)
	jnz L153
L109:
	call _get_line
	cmpq $0,_line(%rip)
	jz L154
L153:
	movq _cptr(%rip),%rcx
L116:
	movb (%rcx),%al
	cmpb $9,%al
	jl L156
L158:
	cmpb $13,%al
	jg L156
L155:
	addb $-9,%al
	movzbl %al,%eax
	movzwl L166(,%rax,2),%eax
	addl $_nextc,%eax
	jmp *%rax
L123:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L153
	jz L154
L156:
	cmpb $32,%al
	jz L135
L160:
	cmpb $44,%al
	jz L135
L161:
	cmpb $47,%al
	jz L139
L162:
	cmpb $59,%al
	jz L135
L163:
	cmpb $92,%al
	jnz L120
L137:
	movq %rcx,_cptr(%rip)
	movl $37,%eax
	ret
L139:
	movb 1(%rcx),%al
	cmpb $42,%al
	jnz L141
L140:
	movq %rcx,_cptr(%rip)
	call _skip_comment
	jmp L153
L141:
	cmpb $47,%al
	jnz L120
L144:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L153
	jz L154
L120:
	movq %rcx,_cptr(%rip)
	movsbl (%rcx),%eax
	ret
L135:
	incq %rcx
	jmp L116
L154:
	movl $-1,%eax
L108:
	ret 


_keyword:
L167:
	pushq %rbx
	pushq %r12
L168:
	movq _cptr(%rip),%rbx
	leaq 1(%rbx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rbx),%edi
	movslq %edi,%rax
	testb $3,___ctype+1(%rax)
	jz L171
L170:
	movl $0,_cinc(%rip)
L173:
	movslq %edi,%rax
	movb ___ctype+1(%rax),%al
	testb $3,%al
	jz L178
L177:
	testb $1,%al
	jz L277
L180:
	call _tolower
	movl %eax,%edi
	jmp L277
L178:
	testb $4,%al
	jnz L277
L194:
	cmpl $95,%edi
	jz L277
L196:
	cmpl $46,%edi
	jz L277
L192:
	cmpl $36,%edi
	jnz L188
L277:
	call _cachec
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%edi
	jmp L173
L188:
	xorl %edi,%edi
	call _cachec
	movl $L202,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L280
L204:
	movl $L203,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L280
L206:
	movl $L212,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L209
L211:
	movl $L217,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L278
L216:
	movl $L222,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L279
L221:
	movl $L227,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L281
L229:
	movl $L228,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L281
L231:
	movl $L237,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L234
L236:
	movl $L242,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L239
L241:
	movl $L247,%esi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L172
L244:
	movl $9,%r12d
	jmp L169
L239:
	movl $8,%r12d
	jmp L169
L234:
	movl $7,%r12d
	jmp L169
L209:
	movl $6,%r12d
	jmp L169
L171:
	leaq 2(%rbx),%rax
	movq %rax,_cptr(%rip)
	cmpl $123,%edi
	jz L249
L251:
	cmpl $37,%edi
	jz L257
L256:
	cmpl $92,%edi
	jnz L258
L257:
	movl $4,%r12d
	jmp L169
L258:
	cmpl $60,%edi
	jnz L263
L278:
	movl $1,%r12d
	jmp L169
L263:
	cmpl $62,%edi
	jnz L267
L279:
	movl $2,%r12d
	jmp L169
L267:
	cmpl $48,%edi
	jnz L271
L280:
	xorl %r12d,%r12d
	jmp L169
L271:
	cmpl $50,%edi
	jnz L172
L281:
	movl $3,%r12d
	jmp L169
L172:
	movl _lineno(%rip),%edi
	movq %rbx,%rdx
	movq _line(%rip),%rsi
	call _syntax_error
	jmp L169
L249:
	movl $5,%r12d
L169:
	movl %r12d,%eax
	popq %r12
	popq %rbx
	ret 


_copy_ident:
L282:
	pushq %rbx
	pushq %r12
L283:
	movq _output_file(%rip),%r12
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L287
L285:
	call _unexpected_EOF
L287:
	cmpl $34,%ebx
	jz L290
L288:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	movq _cptr(%rip),%rdx
	call _syntax_error
L290:
	incl _outline(%rip)
	pushq $L291
	pushq %r12
	call _fprintf
	addq $16,%rsp
L292:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%ebx
	cmpl $10,%ebx
	jz L296
L298:
	decl (%r12)
	js L302
L301:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movb %bl,(%rcx)
	jmp L303
L302:
	movq %r12,%rsi
	movl %ebx,%edi
	call ___flushbuf
L303:
	cmpl $34,%ebx
	jnz L292
L304:
	decl (%r12)
	js L308
L307:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movb $10,(%rcx)
	jmp L309
L308:
	movq %r12,%rsi
	movl $10,%edi
	call ___flushbuf
L309:
	incq _cptr(%rip)
	jmp L284
L296:
	pushq $L299
	pushq %r12
	call _fprintf
	addq $16,%rsp
L284:
	popq %r12
	popq %rbx
	ret 


_copy_text:
L311:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L312:
	movq _text_file(%rip),%r15
	movl _lineno(%rip),%eax
	movl %eax,-28(%rbp)
	movl $0,-36(%rbp)
	movl -28(%rbp),%eax
	movl %eax,-4(%rbp)
	call _dup_line
	movq %rax,-24(%rbp)
	movq _cptr(%rip),%rcx
	movq %rcx,%rax
	subq _line(%rip),%rax
	movq %rax,-16(%rbp)
	cmpb $10,(%rcx)
	jnz L316
L314:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L316
L317:
	movq -16(%rbp),%rax
	movq -24(%rbp),%rsi
	leaq -2(%rax,%rsi),%rdx
	movl -28(%rbp),%edi
	call _unterminated_text
L316:
	cmpb $0,_lflag(%rip)
	jnz L323
L320:
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq %r15
	call _fprintf
	addq $32,%rsp
L323:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%r12d
	cmpl $10,%r12d
	jz L328
	jl L324
L442:
	cmpl $92,%r12d
	jz L425
	jg L324
L443:
	cmpb $34,%r12b
	jz L337
L444:
	cmpb $37,%r12b
	jz L425
L445:
	cmpb $39,%r12b
	jz L337
L446:
	cmpb $47,%r12b
	jnz L324
L367:
	decl (%r15)
	js L369
L368:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %r12b,(%rcx)
	jmp L370
L369:
	movq %r15,%rsi
	movl %r12d,%edi
	call ___flushbuf
L370:
	movq _cptr(%rip),%rax
	movsbl (%rax),%eax
	movl $1,-36(%rbp)
	cmpl $47,%eax
	jz L371
L373:
	cmpl $42,%eax
	jnz L440
L393:
	movl _lineno(%rip),%eax
	movl %eax,-32(%rbp)
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%r12
	subq _line(%rip),%r12
	decl (%r15)
	js L397
L396:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $42,(%rcx)
	jmp L398
L397:
	movq %r15,%rsi
	movl $42,%edi
	call ___flushbuf
L398:
	incq _cptr(%rip)
L399:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	decl (%r15)
	js L404
L403:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %bl,(%rcx)
	jmp L405
L404:
	movq %r15,%rsi
	movl %ebx,%edi
	call ___flushbuf
L405:
	cmpl $42,%ebx
	jnz L408
L409:
	movq _cptr(%rip),%rax
	cmpb $47,(%rax)
	jz L406
L408:
	cmpl $10,%ebx
	jnz L399
L417:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L399
L420:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl -32(%rbp),%edi
	call _unterminated_comment
	jmp L399
L406:
	decl (%r15)
	js L414
L413:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $47,(%rcx)
	jmp L415
L414:
	movq %r15,%rsi
	movl $47,%edi
	call ___flushbuf
L415:
	incq _cptr(%rip)
	movq %r13,%rdi
	jmp L449
L371:
	decl (%r15)
	js L375
L374:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $42,(%rcx)
	jmp L377
L375:
	movq %r15,%rsi
	movl $42,%edi
L450:
	call ___flushbuf
L377:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%r12d
	cmpl $10,%r12d
	jz L379
L378:
	cmpl $42,%r12d
	jnz L381
L383:
	cmpb $47,2(%rcx)
	jnz L381
L380:
	pushq $L387
	pushq %r15
	call _fprintf
	addq $16,%rsp
	jmp L377
L381:
	decl (%r15)
	js L389
L388:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %r12b,(%rcx)
	jmp L377
L389:
	movq %r15,%rsi
	movl %r12d,%edi
	jmp L450
L379:
	pushq $L391
	pushq %r15
	call _fprintf
	addq $16,%rsp
	jmp L328
L425:
	cmpb $125,1(%rcx)
	jnz L324
L426:
	cmpl $0,-36(%rbp)
	jz L431
L429:
	decl (%r15)
	js L433
L432:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $10,(%rcx)
	jmp L431
L433:
	movq %r15,%rsi
	movl $10,%edi
	call ___flushbuf
L431:
	incq _cptr(%rip)
	movq -24(%rbp),%rdi
	call _free
L313:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L324:
	decl (%r15)
	js L437
L436:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %r12b,(%rcx)
	jmp L440
L437:
	movq %r15,%rsi
	movl %r12d,%edi
	call ___flushbuf
L440:
	movl $1,-36(%rbp)
	jmp L323
L328:
	decl (%r15)
	js L330
L329:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $10,(%rcx)
	jmp L331
L330:
	movq %r15,%rsi
	movl $10,%edi
	call ___flushbuf
L331:
	movl $0,-36(%rbp)
	call _get_line
	cmpq $0,_line(%rip)
	jnz L323
L334:
	movq -16(%rbp),%rax
	movq -24(%rbp),%rsi
	leaq -2(%rax,%rsi),%rdx
	movl -4(%rbp),%edi
	call _unterminated_text
L337:
	movl _lineno(%rip),%eax
	movl %eax,-40(%rbp)
	call _dup_line
	movq %rax,%r14
	movq _cptr(%rip),%r13
	subq _line(%rip),%r13
	decl (%r15)
	js L339
L338:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %r12b,(%rcx)
	jmp L341
L339:
	movq %r15,%rsi
	movl %r12d,%edi
	call ___flushbuf
L341:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	decl (%r15)
	js L346
L345:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %bl,(%rcx)
	jmp L347
L346:
	movq %r15,%rsi
	movl %ebx,%edi
	call ___flushbuf
L347:
	cmpl %ebx,%r12d
	jz L348
L350:
	cmpl $10,%ebx
	jnz L354
L352:
	leaq -1(%r13,%r14),%rdx
	movq %r14,%rsi
	movl -40(%rbp),%edi
	call _unterminated_string
L354:
	cmpl $92,%ebx
	jnz L341
L355:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	decl (%r15)
	js L359
L358:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %bl,(%rcx)
	jmp L360
L359:
	movq %r15,%rsi
	movl %ebx,%edi
	call ___flushbuf
L360:
	cmpl $10,%ebx
	jnz L341
L361:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L341
L364:
	leaq -1(%r13,%r14),%rdx
	movq %r14,%rsi
	movl -40(%rbp),%edi
	call _unterminated_string
	jmp L341
L348:
	movl $1,-36(%rbp)
	movq %r14,%rdi
L449:
	call _free
	jmp L323


_copy_union:
L451:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L452:
	movl _lineno(%rip),%eax
	movl %eax,-4(%rbp)
	call _dup_line
	movq %rax,-24(%rbp)
	movq _cptr(%rip),%rdi
	movq %rdi,%rax
	subq _line(%rip),%rax
	movq %rax,-16(%rbp)
	cmpb $0,_unionized(%rip)
	jz L456
L454:
	addq $-6,%rdi
	call _over_unionized
L456:
	movb $1,_unionized(%rip)
	cmpb $0,_lflag(%rip)
	jnz L459
L457:
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq _text_file(%rip)
	call _fprintf
	addq $32,%rsp
L459:
	pushq $L460
	pushq _text_file(%rip)
	call _fprintf
	addq $16,%rsp
	cmpb $0,_dflag(%rip)
	jz L463
L461:
	pushq $L460
	pushq _union_file(%rip)
	call _fprintf
	addq $16,%rsp
L463:
	movl $0,-28(%rbp)
L464:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%r14d
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L466
L465:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r14b,(%rcx)
	jmp L467
L466:
	movl %r14d,%edi
	call ___flushbuf
L467:
	cmpb $0,_dflag(%rip)
	jz L470
L468:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L472
L471:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %r14b,(%rcx)
	jmp L470
L472:
	movl %r14d,%edi
	call ___flushbuf
L470:
	cmpl $10,%r14d
	jz L478
	jl L464
L623:
	cmpl $125,%r14d
	jz L485
	jg L464
L624:
	cmpb $34,%r14b
	jz L493
L625:
	cmpb $39,%r14b
	jz L493
L626:
	cmpb $47,%r14b
	jz L532
L627:
	cmpb $123,%r14b
	jnz L464
L483:
	incl -28(%rbp)
	jmp L464
L532:
	movq _cptr(%rip),%rax
	movsbl (%rax),%eax
	cmpl $47,%eax
	jz L533
L535:
	cmpl $42,%eax
	jnz L464
L572:
	movl _lineno(%rip),%r14d
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%r12
	movq _line(%rip),%rcx
	movq _text_file(%rip),%rax
	subq %rcx,%r12
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L576
L575:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $42,(%rcx)
	jmp L577
L576:
	movl $42,%edi
	call ___flushbuf
L577:
	cmpb $0,_dflag(%rip)
	jz L580
L578:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L582
L581:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $42,(%rcx)
	jmp L580
L582:
	movl $42,%edi
	call ___flushbuf
L580:
	incq _cptr(%rip)
L584:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L589
L588:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L590
L589:
	movl %ebx,%edi
	call ___flushbuf
L590:
	cmpb $0,_dflag(%rip)
	jz L593
L591:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L595
L594:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L593
L595:
	movl %ebx,%edi
	call ___flushbuf
L593:
	cmpl $42,%ebx
	jnz L602
L600:
	movq _cptr(%rip),%rax
	cmpb $47,(%rax)
	jnz L602
L601:
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L605
L604:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $47,(%rcx)
	jmp L606
L605:
	movl $47,%edi
	call ___flushbuf
L606:
	cmpb $0,_dflag(%rip)
	jz L609
L607:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L611
L610:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $47,(%rcx)
	jmp L609
L611:
	movl $47,%edi
	call ___flushbuf
L609:
	incq _cptr(%rip)
	jmp L632
L602:
	cmpl $10,%ebx
	jnz L584
L614:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L584
L617:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r14d,%edi
	call _unterminated_comment
	jmp L584
L533:
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L537
L536:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $42,(%rcx)
	jmp L538
L537:
	movl $42,%edi
	call ___flushbuf
L538:
	cmpb $0,_dflag(%rip)
	jz L545
L539:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L543
L542:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $42,(%rcx)
	jmp L545
L543:
	movl $42,%edi
L631:
	call ___flushbuf
L545:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%ebx
	cmpl $10,%ebx
	jz L547
L546:
	cmpl $42,%ebx
	jnz L553
L551:
	cmpb $47,2(%rcx)
	jnz L553
L552:
	pushq $L387
	pushq _text_file(%rip)
	call _fprintf
	addq $16,%rsp
	cmpb $0,_dflag(%rip)
	jz L545
L555:
	pushq $L387
	pushq _union_file(%rip)
	call _fprintf
	addq $16,%rsp
	jmp L545
L553:
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L559
L558:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L560
L559:
	movl %ebx,%edi
	call ___flushbuf
L560:
	cmpb $0,_dflag(%rip)
	jz L545
L561:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L565
L564:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L545
L565:
	movl %ebx,%edi
	jmp L631
L547:
	pushq $L567
	pushq _text_file(%rip)
	call _fprintf
	addq $16,%rsp
	cmpb $0,_dflag(%rip)
	jz L478
L568:
	pushq $L567
	pushq _union_file(%rip)
	call _fprintf
	addq $16,%rsp
	jmp L478
L493:
	movl _lineno(%rip),%r15d
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%r12
	subq _line(%rip),%r12
L494:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L499
L498:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L500
L499:
	movl %ebx,%edi
	call ___flushbuf
L500:
	cmpb $0,_dflag(%rip)
	jz L503
L501:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L505
L504:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L503
L505:
	movl %ebx,%edi
	call ___flushbuf
L503:
	cmpl %ebx,%r14d
	jz L632
L509:
	cmpl $10,%ebx
	jnz L513
L511:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r15d,%edi
	call _unterminated_string
L513:
	cmpl $92,%ebx
	jnz L494
L514:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rsi
	js L518
L517:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L519
L518:
	movl %ebx,%edi
	call ___flushbuf
L519:
	cmpb $0,_dflag(%rip)
	jz L522
L520:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rsi
	js L524
L523:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %bl,(%rcx)
	jmp L522
L524:
	movl %ebx,%edi
	call ___flushbuf
L522:
	cmpl $10,%ebx
	jnz L494
L526:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L494
L529:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r15d,%edi
	call _unterminated_string
	jmp L494
L632:
	movq %r13,%rdi
	call _free
	jmp L464
L485:
	decl -28(%rbp)
	jnz L464
L486:
	pushq $L489
	pushq _text_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq -24(%rbp),%rdi
	call _free
L453:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L478:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L464
L479:
	movq -16(%rbp),%rax
	movq -24(%rbp),%rsi
	leaq -6(%rax,%rsi),%rdx
	movl -4(%rbp),%edi
	call _unterminated_union
	jmp L464


_hexval:
L633:
L634:
	movl %edi,%eax
	cmpl $48,%eax
	jl L638
L639:
	cmpl $57,%eax
	jg L638
L636:
	subl $48,%eax
	ret
L638:
	cmpl $65,%eax
	jl L646
L647:
	cmpl $70,%eax
	jg L646
L644:
	subl $55,%eax
	ret
L646:
	cmpl $97,%eax
	jl L654
L655:
	cmpl $102,%eax
	jg L654
L652:
	subl $87,%eax
	ret
L654:
	movl $-1,%eax
L635:
	ret 

.align 2
L824:
	.short L777-_get_literal
	.short L779-_get_literal
	.short L787-_get_literal
	.short L783-_get_literal
	.short L789-_get_literal
	.short L781-_get_literal
	.short L785-_get_literal
.align 2
L825:
	.short L693-_get_literal
	.short L693-_get_literal
	.short L693-_get_literal
	.short L693-_get_literal
	.short L693-_get_literal
	.short L693-_get_literal
	.short L693-_get_literal
	.short L693-_get_literal

_get_literal:
L661:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L662:
	movl _lineno(%rip),%r15d
	call _dup_line
	movq %rax,%r14
	movq _cptr(%rip),%rcx
	movq %rcx,%r13
	subq _line(%rip),%r13
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%eax
	movl %eax,-4(%rbp)
	movl $0,_cinc(%rip)
L664:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%r12d
	cmpl %r12d,-4(%rbp)
	jz L668
L670:
	cmpl $10,%r12d
	jnz L674
L672:
	leaq (%r13,%r14),%rdx
	movq %r14,%rsi
	movl %r15d,%edi
	call _unterminated_string
L674:
	cmpl $92,%r12d
	jnz L677
L675:
	movq _cptr(%rip),%rdi
	movq %rdi,%rbx
	decq %rbx
	leaq 1(%rdi),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rdi),%r12d
	cmpl $48,%r12d
	jl L810
L812:
	cmpl $55,%r12d
	jg L810
L809:
	leal -48(%r12),%eax
	movzwl L825(,%rax,2),%eax
	addl $_get_literal,%eax
	jmp *%rax
L693:
	movsbl 1(%rdi),%eax
	subl $48,%r12d
	cmpl $48,%eax
	jl L696
L697:
	cmpl $55,%eax
	jg L696
L698:
	leal -48(%rax,%r12,8),%r12d
	leaq 2(%rdi),%rax
	movq %rax,_cptr(%rip)
	movsbl 2(%rdi),%eax
	cmpl $48,%eax
	jl L696
L704:
	cmpl $55,%eax
	jg L696
L705:
	leal -48(%rax,%r12,8),%r12d
	leaq 3(%rdi),%rax
	movq %rax,_cptr(%rip)
L696:
	cmpl $255,%r12d
	jle L677
L708:
	decq %rdi
	call _illegal_character
	jmp L677
L810:
	cmpl $10,%r12d
	jz L681
	jl L677
L814:
	cmpl $120,%r12d
	jz L712
	jg L677
L815:
	cmpb $97,%r12b
	jz L736
L816:
	cmpb $98,%r12b
	jz L738
L817:
	cmpb $102,%r12b
	jz L740
L818:
	cmpb $110,%r12b
	jz L742
L819:
	cmpb $114,%r12b
	jz L744
L820:
	cmpb $116,%r12b
	jz L746
L821:
	cmpb $118,%r12b
	movl $11,%eax
	cmovzl %eax,%r12d
	jmp L677
L746:
	movl $9,%r12d
	jmp L677
L744:
	movl $13,%r12d
	jmp L677
L742:
	movl $10,%r12d
	jmp L677
L740:
	movl $12,%r12d
	jmp L677
L738:
	movl $8,%r12d
	jmp L677
L736:
	movl $7,%r12d
	jmp L677
L712:
	leaq 2(%rdi),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rdi),%edi
	call _hexval
	movl %eax,%r12d
	cmpl $0,%eax
	jl L803
L716:
	cmpl $16,%eax
	jl L720
L803:
	movq %rbx,%rdi
	call _illegal_character
L720:
	movq _cptr(%rip),%rax
	movsbl (%rax),%edi
	call _hexval
	cmpl $0,%eax
	jl L677
L727:
	cmpl $16,%eax
	jge L677
L729:
	incq _cptr(%rip)
	shll $4,%r12d
	addl %eax,%r12d
	cmpl $255,%r12d
	jle L720
	jg L803
L677:
	movl %r12d,%edi
	call _cachec
	jmp L664
L681:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L664
L682:
	leaq (%r13,%r14),%rdx
	movq %r14,%rsi
	movl %r15d,%edi
	call _unterminated_string
	jmp L664
L668:
	movq %r14,%rdi
	call _free
	movl _cinc(%rip),%r14d
	movl %r14d,%edi
	call _malloc
	movq %rax,%r13
	testq %r13,%r13
	jnz L752
L750:
	call _no_space
L752:
	xorl %ecx,%ecx
	jmp L753
L754:
	movq _cache(%rip),%rax
	movb (%rcx,%rax),%al
	movb %al,(%rcx,%r13)
	incl %ecx
L753:
	cmpl %ecx,%r14d
	jg L754
L756:
	movl $0,_cinc(%rip)
	cmpl $1,%r14d
	movl $34,%eax
	movl $39,%edi
	cmovnzl %eax,%edi
	call _cachec
	xorl %r12d,%r12d
	jmp L760
L761:
	movzbl (%r12,%r13),%ebx
	cmpl $92,%ebx
	jz L768
L767:
	movq _cache(%rip),%rax
	movsbl (%rax),%eax
	cmpl %eax,%ebx
	jnz L769
L768:
	movl $92,%edi
	call _cachec
	jmp L805
L769:
	movl %ebx,%eax
	subl $32,%eax
	cmpl $95,%eax
	jae L772
L805:
	movl %ebx,%edi
	jmp L827
L772:
	movl $92,%edi
	call _cachec
	cmpl $7,%ebx
	jl L774
L808:
	cmpl $13,%ebx
	jg L774
L806:
	leal -7(%rbx),%eax
	movzwl L824(,%rax,2),%eax
	addl $_get_literal,%eax
	jmp *%rax
L785:
	movl $114,%edi
	jmp L827
L781:
	movl $102,%edi
	jmp L827
L789:
	movl $118,%edi
	jmp L827
L783:
	movl $110,%edi
	jmp L827
L787:
	movl $116,%edi
	jmp L827
L779:
	movl $98,%edi
	jmp L827
L777:
	movl $97,%edi
	jmp L827
L774:
	movl %ebx,%edi
	sarl $6,%edi
	andl $7,%edi
	addl $48,%edi
	call _cachec
	movl %ebx,%edi
	sarl $3,%edi
	andl $7,%edi
	addl $48,%edi
	call _cachec
	andl $7,%ebx
	leal 48(%rbx),%edi
L827:
	call _cachec
	incl %r12d
L760:
	cmpl %r12d,%r14d
	jg L761
L763:
	cmpl $1,%r14d
	movl $34,%eax
	movl $39,%edi
	cmovnzl %eax,%edi
	call _cachec
	xorl %edi,%edi
	call _cachec
	movq _cache(%rip),%rdi
	call _lookup
	movq %rax,%rbx
	movb $1,38(%rbx)
	cmpl $1,%r14d
	jnz L797
L798:
	cmpw $-1,32(%rbx)
	jnz L797
L799:
	movzbw (%r13),%ax
	movw %ax,32(%rbx)
L797:
	movq %r13,%rdi
	call _free
	movq %rbx,%rax
L663:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_is_reserved:
L829:
	pushq %rbx
L830:
	movq %rdi,%rbx
	movl $L835,%esi
	movq %rbx,%rdi
	call _strcmp
	testl %eax,%eax
	jz L866
L842:
	movl $L836,%esi
	movq %rbx,%rdi
	call _strcmp
	testl %eax,%eax
	jz L866
L838:
	movl $L837,%esi
	movq %rbx,%rdi
	call _strcmp
	testl %eax,%eax
	jz L866
L834:
	cmpb $36,(%rbx)
	jnz L849
L854:
	cmpb $36,1(%rbx)
	jnz L849
L850:
	movsbq 2(%rbx),%rax
	testb $4,___ctype+1(%rax)
	jz L849
L847:
	addq $3,%rbx
	jmp L858
L859:
	incq %rbx
L858:
	movsbq (%rbx),%rax
	testb $4,___ctype+1(%rax)
	jnz L859
L860:
	testb %al,%al
	jnz L849
L866:
	movl $1,%eax
	jmp L831
L849:
	xorl %eax,%eax
L831:
	popq %rbx
	ret 


_get_name:
L867:
L868:
	movl $0,_cinc(%rip)
	movq _cptr(%rip),%rax
	movsbl (%rax),%edi
L870:
	movslq %edi,%rax
	testb $7,___ctype+1(%rax)
	jnz L875
L882:
	cmpl $95,%edi
	jz L875
L884:
	cmpl $46,%edi
	jz L875
L880:
	cmpl $36,%edi
	jnz L876
L875:
	call _cachec
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%edi
	jmp L870
L876:
	xorl %edi,%edi
	call _cachec
	movq _cache(%rip),%rdi
	call _is_reserved
	testl %eax,%eax
	jz L888
L886:
	movq _cache(%rip),%rdi
	call _used_reserved
L888:
	movq _cache(%rip),%rdi
	call _lookup
L869:
	ret 


_get_number:
L890:
L891:
	movq _cptr(%rip),%rax
	movsbl (%rax),%ecx
	xorl %eax,%eax
	jmp L893
L894:
	leal (%rax,%rax,4),%eax
	addl %eax,%eax
	leal -48(%rax,%rcx),%eax
	movq _cptr(%rip),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,_cptr(%rip)
	movsbl 1(%rdx),%ecx
L893:
	movslq %ecx,%rcx
	testb $4,___ctype+1(%rcx)
	jnz L894
L892:
	ret 


_get_tag:
L898:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L899:
	movl _lineno(%rip),%r14d
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%rax
	movq %rax,%r12
	subq _line(%rip),%r12
	incq %rax
	movq %rax,_cptr(%rip)
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L903
L901:
	call _unexpected_EOF
L903:
	movslq %ebx,%rax
	testb $3,___ctype+1(%rax)
	jnz L906
L911:
	cmpl $95,%ebx
	jz L906
L912:
	cmpl $36,%ebx
	jz L906
L908:
	leaq (%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r14d,%edi
	call _illegal_tag
L906:
	movl $0,_cinc(%rip)
L915:
	movl %ebx,%edi
	call _cachec
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%ebx
	movslq %ebx,%rax
	testb $7,___ctype+1(%rax)
	jnz L915
L926:
	cmpl $95,%ebx
	jz L915
L928:
	cmpl $46,%ebx
	jz L915
L924:
	cmpl $36,%ebx
	jz L915
L920:
	xorl %edi,%edi
	call _cachec
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L932
L930:
	call _unexpected_EOF
L932:
	cmpl $62,%ebx
	jz L935
L933:
	leaq (%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r14d,%edi
	call _illegal_tag
L935:
	incq _cptr(%rip)
	xorl %ebx,%ebx
L936:
	movl _ntags(%rip),%eax
	cmpl %eax,%ebx
	jge L939
L937:
	movq _tag_table(%rip),%rax
	movq (%rax,%rbx,8),%rsi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L940
L942:
	incl %ebx
	jmp L936
L940:
	movq _tag_table(%rip),%rax
	movq (%rax,%rbx,8),%rax
	jmp L900
L939:
	movl _tagmax(%rip),%edi
	cmpl %edi,%eax
	jl L946
L944:
	addl $16,%edi
	movl %edi,_tagmax(%rip)
	movq _tag_table(%rip),%rax
	shll $3,%edi
	testq %rax,%rax
	jz L948
L947:
	movq %rdi,%rsi
	movq %rax,%rdi
	call _realloc
	jmp L949
L948:
	call _malloc
L949:
	movq %rax,_tag_table(%rip)
	testq %rax,%rax
	jnz L946
L950:
	call _no_space
L946:
	movl _cinc(%rip),%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L955
L953:
	call _no_space
L955:
	movq _cache(%rip),%rsi
	movq %rbx,%rdi
	call _strcpy
	movslq _ntags(%rip),%rax
	movq _tag_table(%rip),%rcx
	movq %rbx,(%rcx,%rax,8)
	incl _ntags(%rip)
	movq %r13,%rdi
	call _free
	movq %rbx,%rax
L900:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_declare_tokens:
L957:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L958:
	movl %edi,%r13d
	xorl %r12d,%r12d
	testl %r13d,%r13d
	jz L962
L960:
	incl _prec(%rip)
L962:
	call _nextc
	movl %eax,%r14d
	cmpl $-1,%r14d
	jnz L965
L963:
	call _unexpected_EOF
L965:
	cmpl $60,%r14d
	jnz L972
L966:
	call _get_tag
	movq %rax,%r12
	call _nextc
	movl %eax,%r14d
	cmpl $-1,%eax
	jnz L972
L1038:
	call _unexpected_EOF
L972:
	movslq %r14d,%r14
	testb $3,___ctype+1(%r14)
	jnz L976
L987:
	cmpl $95,%r14d
	jz L976
L983:
	cmpl $46,%r14d
	jz L976
L979:
	cmpl $36,%r14d
	jnz L977
L976:
	call _get_name
	jmp L1039
L977:
	cmpl $39,%r14d
	jz L991
L994:
	cmpl $34,%r14d
	jnz L959
L991:
	call _get_literal
L1039:
	movq %rax,%rbx
	cmpq _goal(%rip),%rbx
	jnz L1001
L999:
	movq 16(%rbx),%rdi
	call _tokenized_start
L1001:
	movb $1,38(%rbx)
	testq %r12,%r12
	jz L1004
L1002:
	movq 24(%rbx),%rax
	testq %rax,%rax
	jz L1007
L1008:
	cmpq %rax,%r12
	jz L1007
L1005:
	movq 16(%rbx),%rdi
	call _retyped_warning
L1007:
	movq %r12,24(%rbx)
L1004:
	testl %r13d,%r13d
	jz L1014
L1012:
	movw 36(%rbx),%ax
	testw %ax,%ax
	jz L1017
L1018:
	movswl %ax,%eax
	cmpl %eax,_prec(%rip)
	jz L1017
L1015:
	movq 16(%rbx),%rdi
	call _reprec_warning
L1017:
	movb %r13b,39(%rbx)
	movl _prec(%rip),%eax
	movw %ax,36(%rbx)
L1014:
	call _nextc
	movl %eax,%r14d
	cmpl $-1,%r14d
	jnz L1024
L1022:
	call _unexpected_EOF
L1024:
	movslq %r14d,%rax
	testb $4,___ctype+1(%rax)
	jz L972
L1025:
	call _get_number
	movl %eax,%r14d
	movw 32(%rbx),%ax
	cmpw $-1,%ax
	jz L1030
L1031:
	movswl %ax,%eax
	cmpl %eax,%r14d
	jz L1030
L1028:
	movq 16(%rbx),%rdi
	call _revalued_warning
L1030:
	movw %r14w,32(%rbx)
	call _nextc
	movl %eax,%r14d
	cmpl $-1,%eax
	jnz L972
	jz L1038
L959:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_declare_types:
L1040:
	pushq %rbx
	pushq %r12
L1041:
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1045
L1043:
	call _unexpected_EOF
L1045:
	cmpl $60,%ebx
	jz L1048
L1046:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	movq _cptr(%rip),%rdx
	call _syntax_error
L1048:
	call _get_tag
	movq %rax,%r12
L1049:
	call _nextc
	movslq %eax,%rax
	testb $3,___ctype+1(%rax)
	jnz L1053
L1064:
	cmpl $95,%eax
	jz L1053
L1060:
	cmpl $46,%eax
	jz L1053
L1056:
	cmpl $36,%eax
	jnz L1054
L1053:
	call _get_name
	jmp L1083
L1054:
	cmpl $39,%eax
	jz L1068
L1071:
	cmpl $34,%eax
	jnz L1042
L1068:
	call _get_literal
L1083:
	movq %rax,%rbx
	movq 24(%rbx),%rax
	testq %rax,%rax
	jz L1078
L1079:
	cmpq %rax,%r12
	jz L1078
L1076:
	movq 16(%rbx),%rdi
	call _retyped_warning
L1078:
	movq %r12,24(%rbx)
	jmp L1049
L1042:
	popq %r12
	popq %rbx
	ret 


_declare_start:
L1084:
	pushq %rbx
L1085:
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1089
L1087:
	call _unexpected_EOF
L1089:
	movslq %ebx,%rbx
	testb $3,___ctype+1(%rbx)
	jnz L1092
L1101:
	cmpl $95,%ebx
	jz L1092
L1097:
	cmpl $46,%ebx
	jz L1092
L1093:
	cmpl $36,%ebx
	jz L1092
L1090:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	movq _cptr(%rip),%rdx
	call _syntax_error
L1092:
	call _get_name
	movq %rax,%rbx
	cmpb $1,38(%rbx)
	jnz L1107
L1105:
	movq 16(%rbx),%rdi
	call _terminal_start
L1107:
	movq _goal(%rip),%rax
	testq %rax,%rax
	jz L1110
L1111:
	cmpq %rax,%rbx
	jz L1110
L1108:
	call _restarted_warning
L1110:
	movq %rbx,_goal(%rip)
L1086:
	popq %rbx
	ret 

.align 2
L1154:
	.short L1145-_read_declarations
	.short L1145-_read_declarations
	.short L1145-_read_declarations
	.short L1145-_read_declarations
	.short L1117-_read_declarations
	.short L1138-_read_declarations
	.short L1147-_read_declarations
	.short L1149-_read_declarations
	.short L1140-_read_declarations
	.short L1136-_read_declarations

_read_declarations:
L1115:
	pushq %rbx
L1116:
	movl $256,_cache_size(%rip)
	movl $256,%edi
	call _malloc
	movq %rax,_cache(%rip)
	testq %rax,%rax
	jnz L1121
L1118:
	call _no_space
L1121:
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1127
L1125:
	call _unexpected_EOF
L1127:
	cmpl $37,%ebx
	jz L1130
L1128:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	movq _cptr(%rip),%rdx
	call _syntax_error
L1130:
	call _keyword
	cmpl $0,%eax
	jl L1121
L1153:
	cmpl $9,%eax
	jg L1121
L1151:
	movzwl L1154(,%rax,2),%ecx
	addl $_read_declarations,%ecx
	jmp *%rcx
L1136:
	call _copy_ident
	jmp L1121
L1140:
	call _copy_union
	jmp L1121
L1149:
	call _declare_start
	jmp L1121
L1147:
	call _declare_types
	jmp L1121
L1138:
	call _copy_text
	jmp L1121
L1145:
	movl %eax,%edi
	call _declare_tokens
	jmp L1121
L1117:
	popq %rbx
	ret 


_initialize_grammar:
L1155:
L1156:
	movl $4,_nitems(%rip)
	movl $300,_maxitems(%rip)
	movl $2400,%edi
	call _malloc
	movq %rax,_pitem(%rip)
	testq %rax,%rax
	jnz L1160
L1158:
	call _no_space
L1160:
	movq _pitem(%rip),%rax
	movq $0,(%rax)
	movq _pitem(%rip),%rax
	movq $0,8(%rax)
	movq _pitem(%rip),%rax
	movq $0,16(%rax)
	movq _pitem(%rip),%rax
	movq $0,24(%rax)
	movl $3,_nrules(%rip)
	movl $100,_maxrules(%rip)
	movl $800,%edi
	call _malloc
	movq %rax,_plhs(%rip)
	testq %rax,%rax
	jnz L1163
L1161:
	call _no_space
L1163:
	movq _plhs(%rip),%rax
	movq $0,(%rax)
	movq _plhs(%rip),%rax
	movq $0,8(%rax)
	movq _plhs(%rip),%rax
	movq $0,16(%rax)
	movl _maxrules(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_rprec(%rip)
	testq %rax,%rax
	jnz L1166
L1164:
	call _no_space
L1166:
	movq _rprec(%rip),%rax
	movw $0,(%rax)
	movq _rprec(%rip),%rax
	movw $0,2(%rax)
	movq _rprec(%rip),%rax
	movw $0,4(%rax)
	movl _maxrules(%rip),%edi
	call _malloc
	movq %rax,_rassoc(%rip)
	testq %rax,%rax
	jnz L1169
L1167:
	call _no_space
L1169:
	movq _rassoc(%rip),%rax
	movb $0,(%rax)
	movq _rassoc(%rip),%rax
	movb $0,1(%rax)
	movq _rassoc(%rip),%rax
	movb $0,2(%rax)
L1157:
	ret 


_expand_items:
L1170:
L1171:
	movl _maxitems(%rip),%esi
	addl $300,%esi
	movl %esi,_maxitems(%rip)
	shll $3,%esi
	movq _pitem(%rip),%rdi
	call _realloc
	movq %rax,_pitem(%rip)
	testq %rax,%rax
	jnz L1172
L1173:
	call _no_space
L1172:
	ret 


_expand_rules:
L1176:
L1177:
	movl _maxrules(%rip),%esi
	addl $100,%esi
	movl %esi,_maxrules(%rip)
	shll $3,%esi
	movq _plhs(%rip),%rdi
	call _realloc
	movq %rax,_plhs(%rip)
	testq %rax,%rax
	jnz L1181
L1179:
	call _no_space
L1181:
	movl _maxrules(%rip),%esi
	shll $1,%esi
	movq _rprec(%rip),%rdi
	call _realloc
	movq %rax,_rprec(%rip)
	testq %rax,%rax
	jnz L1184
L1182:
	call _no_space
L1184:
	movl _maxrules(%rip),%esi
	movq _rassoc(%rip),%rdi
	call _realloc
	movq %rax,_rassoc(%rip)
	testq %rax,%rax
	jnz L1178
L1185:
	call _no_space
L1178:
	ret 


_start_rule:
L1188:
	pushq %rbx
L1189:
	movq %rdi,%rbx
	movl %esi,%edi
	cmpb $1,38(%rbx)
	jnz L1193
L1191:
	call _terminal_lhs
L1193:
	movb $2,38(%rbx)
	movl _nrules(%rip),%eax
	cmpl _maxrules(%rip),%eax
	jl L1196
L1194:
	call _expand_rules
L1196:
	movslq _nrules(%rip),%rcx
	movq _plhs(%rip),%rax
	movq %rbx,(%rax,%rcx,8)
	movslq _nrules(%rip),%rcx
	movq _rprec(%rip),%rax
	movw $-1,(%rax,%rcx,2)
	movslq _nrules(%rip),%rcx
	movq _rassoc(%rip),%rax
	movb $0,(%rcx,%rax)
L1190:
	popq %rbx
	ret 


_advance_to_start:
L1197:
	pushq %rbx
	pushq %r12
	pushq %r13
L1200:
	call _nextc
	cmpl $37,%eax
	jnz L1204
L1206:
	movq _cptr(%rip),%rbx
	call _keyword
	cmpl $4,%eax
	jz L1211
L1244:
	cmpl $5,%eax
	jz L1212
L1245:
	cmpl $7,%eax
	jz L1214
L1246:
	movl _lineno(%rip),%edi
	movq %rbx,%rdx
	movq _line(%rip),%rsi
	call _syntax_error
	jmp L1200
L1214:
	call _declare_start
	jmp L1200
L1211:
	call _no_grammar
L1212:
	call _copy_text
	jmp L1200
L1204:
	call _nextc
	movslq %eax,%rax
	testb $3,___ctype+1(%rax)
	jnz L1218
L1227:
	cmpl $95,%eax
	jz L1218
L1223:
	cmpl $46,%eax
	jz L1218
L1219:
	cmpl $95,%eax
	jz L1218
L1216:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1218:
	call _get_name
	movq %rax,%r13
	cmpq $0,_goal(%rip)
	jnz L1233
L1231:
	cmpb $1,38(%r13)
	jnz L1236
L1234:
	movq 16(%r13),%rdi
	call _terminal_start
L1236:
	movq %r13,_goal(%rip)
L1233:
	movl _lineno(%rip),%r12d
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1239
L1237:
	call _unexpected_EOF
L1239:
	cmpl $58,%ebx
	jz L1242
L1240:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1242:
	movl %r12d,%esi
	movq %r13,%rdi
	call _start_rule
	incq _cptr(%rip)
L1199:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_end_rule:
L1248:
L1249:
	cmpb $0,_last_was_action(%rip)
	jnz L1253
L1254:
	movslq _nrules(%rip),%rcx
	movq _plhs(%rip),%rax
	movq (%rax,%rcx,8),%rax
	cmpq $0,24(%rax)
	jz L1253
L1255:
	movl _nitems(%rip),%eax
	decl %eax
	jmp L1258
L1260:
	decl %eax
L1258:
	movslq %eax,%rax
	movq _pitem(%rip),%rcx
	cmpq $0,(%rcx,%rax,8)
	jnz L1260
L1261:
	incl %eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rax
	testq %rax,%rax
	jz L1267
L1266:
	movq 24(%rax),%rcx
	movslq _nrules(%rip),%rax
	movq _plhs(%rip),%rdx
	movq (%rdx,%rax,8),%rax
	cmpq 24(%rax),%rcx
	jz L1253
L1267:
	call _default_action_warning
L1253:
	movb $0,_last_was_action(%rip)
	movl _nitems(%rip),%eax
	cmpl _maxitems(%rip),%eax
	jl L1272
L1270:
	call _expand_items
L1272:
	movslq _nitems(%rip),%rax
	movq _pitem(%rip),%rcx
	movq $0,(%rcx,%rax,8)
	incl _nitems(%rip)
	incl _nrules(%rip)
L1250:
	ret 


_insert_empty_rule:
L1273:
	pushq %rbx
L1274:
	cmpq $0,_cache(%rip)
	jnz L1278
L1276:
	movl $1151,%edx
	movl $L8,%esi
	movl $L1279,%edi
	call ___assert
L1278:
	movl _gensym(%rip),%eax
	incl %eax
	movl %eax,_gensym(%rip)
	pushq %rax
	pushq $L1280
	pushq _cache(%rip)
	call _sprintf
	addq $24,%rsp
	movq _cache(%rip),%rdi
	call _make_bucket
	movq %rax,%rbx
	movq _last_symbol(%rip),%rax
	movq %rbx,8(%rax)
	movq %rbx,_last_symbol(%rip)
	movslq _nrules(%rip),%rcx
	movq _plhs(%rip),%rax
	movq (%rax,%rcx,8),%rax
	movq 24(%rax),%rax
	movq %rax,24(%rbx)
	movb $2,38(%rbx)
	movl _nitems(%rip),%eax
	addl $2,%eax
	movl %eax,_nitems(%rip)
	cmpl _maxitems(%rip),%eax
	jle L1283
L1281:
	call _expand_items
L1283:
	movslq _nitems(%rip),%rcx
	movq _pitem(%rip),%rax
	movq %rbx,-8(%rax,%rcx,8)
	leaq -16(%rax,%rcx,8),%rdx
	jmp L1284
L1285:
	movq %rcx,%rdx
L1284:
	leaq -8(%rdx),%rcx
	movq -8(%rdx),%rax
	movq %rax,(%rdx)
	testq %rax,%rax
	jnz L1285
L1286:
	movl _nrules(%rip),%eax
	incl %eax
	movl %eax,_nrules(%rip)
	cmpl _maxrules(%rip),%eax
	jl L1289
L1287:
	call _expand_rules
L1289:
	movl _nrules(%rip),%eax
	movl %eax,%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _plhs(%rip),%rdx
	movq (%rdx,%rcx,8),%rcx
	movslq %eax,%rax
	movq %rcx,(%rdx,%rax,8)
	movl _nrules(%rip),%eax
	decl %eax
	movslq %eax,%rax
	movq _plhs(%rip),%rcx
	movq %rbx,(%rcx,%rax,8)
	movl _nrules(%rip),%eax
	movl %eax,%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _rprec(%rip),%rdx
	movw (%rdx,%rcx,2),%cx
	movslq %eax,%rax
	movw %cx,(%rdx,%rax,2)
	movl _nrules(%rip),%eax
	decl %eax
	movslq %eax,%rax
	movq _rprec(%rip),%rcx
	movw $0,(%rcx,%rax,2)
	movl _nrules(%rip),%eax
	movl %eax,%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _rassoc(%rip),%rdx
	movb (%rcx,%rdx),%cl
	movslq %eax,%rax
	movb %cl,(%rdx,%rax)
	movl _nrules(%rip),%eax
	decl %eax
	movslq %eax,%rax
	movq _rassoc(%rip),%rcx
	movb $0,(%rax,%rcx)
L1275:
	popq %rbx
	ret 


_add_symbol:
L1290:
	pushq %rbx
	pushq %r12
L1291:
	movl _lineno(%rip),%r12d
	movq _cptr(%rip),%rax
	movsbl (%rax),%eax
	cmpl $39,%eax
	jz L1297
L1296:
	cmpl $34,%eax
	jnz L1298
L1297:
	call _get_literal
	jmp L1310
L1298:
	call _get_name
L1310:
	movq %rax,%rbx
	call _nextc
	cmpl $58,%eax
	jz L1300
L1302:
	cmpb $0,_last_was_action(%rip)
	jz L1306
L1304:
	call _insert_empty_rule
L1306:
	movb $0,_last_was_action(%rip)
	movl _nitems(%rip),%eax
	incl %eax
	movl %eax,_nitems(%rip)
	cmpl _maxitems(%rip),%eax
	jle L1309
L1307:
	call _expand_items
L1309:
	movl _nitems(%rip),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _pitem(%rip),%rax
	movq %rbx,(%rax,%rcx,8)
	jmp L1292
L1300:
	call _end_rule
	movl %r12d,%esi
	movq %rbx,%rdi
	call _start_rule
	incq _cptr(%rip)
L1292:
	popq %r12
	popq %rbx
	ret 


_copy_action:
L1311:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1312:
	movq _action_file(%rip),%r15
	movl _lineno(%rip),%eax
	movl %eax,-4(%rbp)
	call _dup_line
	movq %rax,-16(%rbp)
	movq _cptr(%rip),%rax
	subq _line(%rip),%rax
	movq %rax,-24(%rbp)
	cmpb $0,_last_was_action(%rip)
	jz L1316
L1314:
	call _insert_empty_rule
L1316:
	movb $1,_last_was_action(%rip)
	movl _nrules(%rip),%eax
	subl $2,%eax
	pushq %rax
	pushq $L1317
	pushq %r15
	call _fprintf
	addq $24,%rsp
	cmpb $0,_lflag(%rip)
	jnz L1320
L1318:
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq %r15
	call _fprintf
	addq $32,%rsp
L1320:
	movq _cptr(%rip),%rax
	cmpb $61,(%rax)
	jnz L1323
L1321:
	incq %rax
	movq %rax,_cptr(%rip)
L1323:
	movl $0,-36(%rbp)
	movl _nitems(%rip),%ecx
	decl %ecx
	jmp L1324
L1325:
	incl -36(%rbp)
	decl %ecx
L1324:
	movslq %ecx,%rcx
	movq _pitem(%rip),%rax
	cmpq $0,(%rax,%rcx,8)
	jnz L1325
L1327:
	movl $0,-28(%rbp)
L1328:
	movq _cptr(%rip),%rdx
	movsbl (%rdx),%eax
	movl %eax,%r14d
	cmpl $36,%eax
	jnz L1331
L1329:
	leaq 1(%rdx),%rcx
	movb 1(%rdx),%al
	cmpb $60,%al
	jnz L1333
L1332:
	movl _lineno(%rip),%eax
	movl %eax,-40(%rbp)
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%rax
	movq %rax,%r12
	subq _line(%rip),%r12
	incq %rax
	movq %rax,_cptr(%rip)
	call _get_tag
	movq %rax,%rbx
	movq _cptr(%rip),%rdx
	movsbl (%rdx),%eax
	movl %eax,%r14d
	cmpl $36,%eax
	jnz L1336
L1335:
	pushq %rbx
	pushq $L1338
	pushq %r15
	call _fprintf
	addq $24,%rsp
	incq _cptr(%rip)
	jmp L1544
L1336:
	movslq %eax,%rax
	testb $4,___ctype+1(%rax)
	jz L1341
L1340:
	call _get_number
	movl %eax,%r12d
	cmpl %r12d,-36(%rbp)
	jge L1345
L1343:
	movl %r12d,%esi
	movl -40(%rbp),%edi
	call _dollar_warning
L1345:
	subl -36(%rbp),%r12d
	pushq %rbx
	pushq %r12
	jmp L1543
L1341:
	cmpl $45,%eax
	jnz L1353
L1351:
	leaq 1(%rdx),%rcx
	movsbq 1(%rdx),%rax
	testb $4,___ctype+1(%rax)
	jz L1353
L1352:
	movq %rcx,_cptr(%rip)
	call _get_number
	negl %eax
	subl -36(%rbp),%eax
	pushq %rbx
	pushq %rax
L1543:
	pushq $L1346
	pushq %r15
	call _fprintf
	addq $32,%rsp
	jmp L1544
L1353:
	leaq (%r12,%r13),%rdx
	movq %r13,%rsi
	movl -40(%rbp),%edi
	call _dollar_error
	jmp L1331
L1333:
	cmpb $36,%al
	jnz L1357
L1356:
	cmpl $0,_ntags(%rip)
	jz L1360
L1359:
	movslq _nrules(%rip),%rcx
	movq _plhs(%rip),%rax
	movq (%rax,%rcx,8),%rax
	movq 24(%rax),%rbx
	testq %rbx,%rbx
	jnz L1364
L1362:
	call _untyped_lhs
L1364:
	pushq %rbx
	pushq $L1338
	pushq %r15
	call _fprintf
	addq $24,%rsp
	jmp L1361
L1360:
	pushq $L1365
	pushq %r15
	call _fprintf
	addq $16,%rsp
L1361:
	addq $2,_cptr(%rip)
	jmp L1328
L1357:
	movsbq %al,%rax
	testb $4,___ctype+1(%rax)
	jz L1368
L1367:
	movq %rcx,_cptr(%rip)
	call _get_number
	movl %eax,%ebx
	cmpl $0,_ntags(%rip)
	jz L1371
L1370:
	cmpl $0,%ebx
	jle L1377
L1376:
	cmpl %ebx,-36(%rbp)
	jge L1375
L1377:
	movl %ebx,%edi
	call _unknown_rhs
L1375:
	movl _nitems(%rip),%eax
	addl %ebx,%eax
	subl -36(%rbp),%eax
	decl %eax
	movslq %eax,%rax
	movq _pitem(%rip),%rcx
	movq (%rcx,%rax,8),%rax
	movq 24(%rax),%r12
	testq %r12,%r12
	jnz L1382
L1380:
	movq 16(%rax),%rsi
	movl %ebx,%edi
	call _untyped_rhs
L1382:
	subl -36(%rbp),%ebx
	pushq %r12
	pushq %rbx
	pushq $L1346
	pushq %r15
	call _fprintf
	addq $32,%rsp
	jmp L1328
L1371:
	cmpl %ebx,-36(%rbp)
	jge L1545
L1383:
	movl %ebx,%esi
	movl _lineno(%rip),%edi
	call _dollar_warning
	jmp L1545
L1368:
	cmpb $45,%al
	jz L1388
L1331:
	movslq %r14d,%rax
	testb $3,___ctype+1(%rax)
	jnz L1406
L1402:
	cmpl $95,%r14d
	jz L1406
L1404:
	cmpl $36,%r14d
	jnz L1400
L1406:
	decl (%r15)
	js L1410
L1409:
	movb %r14b,%dl
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L1411
L1410:
	movq %r15,%rsi
	movl %r14d,%edi
	call ___flushbuf
L1411:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%eax
	movl %eax,%r14d
	movslq %eax,%rax
	testb $7,___ctype+1(%rax)
	jnz L1406
L1416:
	cmpl $95,%eax
	jz L1406
L1418:
	cmpl $36,%eax
	jz L1406
	jnz L1328
L1400:
	decl (%r15)
	js L1422
L1421:
	movb %r14b,%dl
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L1423
L1422:
	movq %r15,%rsi
	movl %r14d,%edi
	call ___flushbuf
L1423:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	cmpl $10,%r14d
	jz L1428
	jl L1328
L1531:
	cmpl $125,%r14d
	jz L1442
	jg L1328
L1532:
	movb %r14b,%al
	cmpb $34,%al
	jz L1449
L1533:
	cmpb $39,%al
	jz L1449
L1534:
	cmpb $47,%al
	jz L1476
L1535:
	cmpb $59,%al
	jz L1433
L1536:
	cmpb $123,%al
	jnz L1328
L1440:
	incl -28(%rbp)
	jmp L1328
L1476:
	movsbl 1(%rcx),%eax
	cmpl $47,%eax
	jz L1477
L1479:
	cmpl $42,%eax
	jnz L1328
L1497:
	movl _lineno(%rip),%eax
	movl %eax,-32(%rbp)
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%r12
	subq _line(%rip),%r12
	decl (%r15)
	js L1501
L1500:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $42,(%rcx)
	jmp L1502
L1501:
	movq %r15,%rsi
	movl $42,%edi
	call ___flushbuf
L1502:
	incq _cptr(%rip)
L1503:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	decl (%r15)
	js L1508
L1507:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %bl,(%rcx)
	jmp L1509
L1508:
	movq %r15,%rsi
	movl %ebx,%edi
	call ___flushbuf
L1509:
	cmpl $42,%ebx
	jnz L1515
L1513:
	movq _cptr(%rip),%rax
	cmpb $47,(%rax)
	jnz L1515
L1514:
	decl (%r15)
	js L1518
L1517:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $47,(%rcx)
	jmp L1519
L1518:
	movq %r15,%rsi
	movl $47,%edi
	call ___flushbuf
L1519:
	incq _cptr(%rip)
	jmp L1544
L1515:
	cmpl $10,%ebx
	jnz L1503
L1521:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L1503
L1524:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl -32(%rbp),%edi
	call _unterminated_comment
	jmp L1503
L1477:
	decl (%r15)
	js L1481
L1480:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $42,(%rcx)
	jmp L1483
L1481:
	movq %r15,%rsi
	movl $42,%edi
L1540:
	call ___flushbuf
L1483:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%edx
	cmpl $10,%edx
	jz L1485
L1484:
	cmpl $42,%edx
	jnz L1491
L1489:
	cmpb $47,2(%rcx)
	jnz L1491
L1490:
	pushq $L387
	pushq %r15
	call _fprintf
	addq $16,%rsp
	jmp L1483
L1491:
	decl (%r15)
	js L1494
L1493:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L1483
L1494:
	movq %r15,%rsi
	movl %edx,%edi
	jmp L1540
L1485:
	pushq $L567
	pushq %r15
	call _fprintf
	addq $16,%rsp
	jmp L1428
L1449:
	movl _lineno(%rip),%eax
	movl %eax,-44(%rbp)
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%r12
	subq _line(%rip),%r12
L1450:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	decl (%r15)
	js L1455
L1454:
	movb %bl,%dl
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L1456
L1455:
	movq %r15,%rsi
	movl %ebx,%edi
	call ___flushbuf
L1456:
	cmpl %ebx,%r14d
	jz L1544
L1459:
	cmpl $10,%ebx
	jnz L1463
L1461:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl -44(%rbp),%edi
	call _unterminated_string
L1463:
	cmpl $92,%ebx
	jnz L1450
L1464:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	decl (%r15)
	js L1468
L1467:
	movb %bl,%dl
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L1469
L1468:
	movq %r15,%rsi
	movl %ebx,%edi
	call ___flushbuf
L1469:
	cmpl $10,%ebx
	jnz L1450
L1470:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L1450
L1473:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl -44(%rbp),%edi
	call _unterminated_string
	jmp L1450
L1544:
	movq %r13,%rdi
	call _free
	jmp L1328
L1442:
	movl -28(%rbp),%eax
	decl %eax
	movl %eax,-28(%rbp)
	cmpl $0,%eax
	jg L1328
	jle L1539
L1428:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L1328
L1431:
	movq -16(%rbp),%rcx
	movq -24(%rbp),%rax
	leaq (%rax,%rcx),%rdx
	movq %rcx,%rsi
	movl -4(%rbp),%edi
	call _unterminated_action
L1433:
	cmpl $0,-28(%rbp)
	jg L1328
L1539:
	pushq $L1438
	pushq %r15
	call _fprintf
	addq $16,%rsp
L1313:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L1388:
	addq $2,%rdx
	movq %rdx,_cptr(%rip)
	call _get_number
	movl %eax,%ebx
	cmpl $0,_ntags(%rip)
	jz L1393
L1391:
	movl %ebx,%eax
	negl %eax
	movl %eax,%edi
	call _unknown_rhs
L1393:
	negl %ebx
L1545:
	subl -36(%rbp),%ebx
	pushq %rbx
	pushq $L1386
	pushq %r15
	call _fprintf
	addq $24,%rsp
	jmp L1328


_mark_symbol:
L1546:
	pushq %rbx
L1547:
	movq _cptr(%rip),%rdx
	movsbl 1(%rdx),%eax
	cmpl $37,%eax
	jz L1549
L1552:
	cmpl $92,%eax
	jnz L1551
L1549:
	addq $2,%rdx
	movq %rdx,_cptr(%rip)
	movl $1,%eax
	jmp L1548
L1551:
	cmpl $61,%eax
	jnz L1558
L1557:
	addq $2,%rdx
	movq %rdx,_cptr(%rip)
	jmp L1559
L1558:
	cmpl $112,%eax
	jz L1575
L1579:
	cmpl $80,%eax
	jnz L1561
L1575:
	movsbl 2(%rdx),%eax
	cmpl $114,%eax
	jz L1571
L1583:
	cmpl $82,%eax
	jnz L1561
L1571:
	movsbl 3(%rdx),%eax
	cmpl $101,%eax
	jz L1567
L1587:
	cmpl $69,%eax
	jnz L1561
L1567:
	movsbl 4(%rdx),%eax
	cmpl $99,%eax
	jz L1563
L1591:
	cmpl $67,%eax
	jnz L1561
L1563:
	leaq 5(%rdx),%rcx
	movsbl 5(%rdx),%eax
	movslq %eax,%rax
	testb $7,___ctype+1(%rax)
	jnz L1561
L1603:
	cmpl $95,%eax
	jz L1561
L1599:
	cmpl $46,%eax
	jz L1561
L1595:
	cmpl $36,%eax
	jz L1561
L1560:
	movq %rcx,_cptr(%rip)
	jmp L1559
L1561:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1559:
	call _nextc
	movslq %eax,%rax
	testb $3,___ctype+1(%rax)
	jnz L1607
L1618:
	cmpl $95,%eax
	jz L1607
L1614:
	cmpl $46,%eax
	jz L1607
L1610:
	cmpl $36,%eax
	jnz L1608
L1607:
	call _get_name
	jmp L1637
L1608:
	cmpl $39,%eax
	jz L1622
L1625:
	cmpl $34,%eax
	jnz L1623
L1622:
	call _get_literal
L1637:
	movq %rax,%rbx
	jmp L1609
L1623:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1609:
	movslq _nrules(%rip),%rcx
	movq _rprec(%rip),%rax
	movw (%rax,%rcx,2),%ax
	cmpw $-1,%ax
	jz L1631
L1632:
	cmpw 36(%rbx),%ax
	jz L1631
L1629:
	call _prec_redeclared
L1631:
	movw 36(%rbx),%cx
	movslq _nrules(%rip),%rax
	movq _rprec(%rip),%rdx
	movw %cx,(%rdx,%rax,2)
	movb 39(%rbx),%dl
	movslq _nrules(%rip),%rcx
	movq _rassoc(%rip),%rax
	movb %dl,(%rcx,%rax)
	xorl %eax,%eax
L1548:
	popq %rbx
	ret 


_read_grammar:
L1638:
L1639:
	call _initialize_grammar
	call _advance_to_start
L1641:
	call _nextc
	cmpl $-1,%eax
	jz L1644
L1647:
	movslq %eax,%rax
	testb $3,___ctype+1(%rax)
	jnz L1649
L1668:
	cmpl $95,%eax
	jz L1649
L1664:
	cmpl $46,%eax
	jz L1649
L1660:
	cmpl $36,%eax
	jz L1649
L1656:
	cmpl $39,%eax
	jz L1649
L1652:
	cmpl $34,%eax
	jnz L1650
L1649:
	call _add_symbol
	jmp L1641
L1650:
	cmpl $123,%eax
	jz L1672
L1675:
	cmpl $61,%eax
	jnz L1673
L1672:
	call _copy_action
	jmp L1641
L1673:
	cmpl $124,%eax
	jnz L1680
L1679:
	call _end_rule
	movl _nrules(%rip),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _plhs(%rip),%rax
	xorl %esi,%esi
	movq (%rax,%rcx,8),%rdi
	call _start_rule
	incq _cptr(%rip)
	jmp L1641
L1680:
	cmpl $37,%eax
	jnz L1683
L1682:
	call _mark_symbol
	testl %eax,%eax
	jz L1641
	jnz L1644
L1683:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
	jmp L1641
L1644:
	call _end_rule
L1640:
	ret 


_free_tags:
L1689:
	pushq %rbx
L1690:
	cmpq $0,_tag_table(%rip)
	jz L1691
L1694:
	xorl %ebx,%ebx
	jmp L1696
L1697:
	cmpq $0,(%rdi,%rbx,8)
	jnz L1702
L1700:
	movl $1519,%edx
	movl $L8,%esi
	movl $L1703,%edi
	call ___assert
L1702:
	movq _tag_table(%rip),%rax
	movq (%rax,%rbx,8),%rdi
	call _free
	incl %ebx
L1696:
	movl _ntags(%rip),%eax
	movq _tag_table(%rip),%rdi
	cmpl %eax,%ebx
	jl L1697
L1699:
	call _free
L1691:
	popq %rbx
	ret 


_pack_names:
L1704:
	pushq %rbx
	pushq %r12
	pushq %r13
L1705:
	movl $13,_name_pool_size(%rip)
	movq _first_symbol(%rip),%rbx
	jmp L1707
L1708:
	movq 16(%rbx),%rdi
	call _strlen
	movl _name_pool_size(%rip),%ecx
	leal 1(%rcx,%rax),%eax
	movl %eax,_name_pool_size(%rip)
	movq 8(%rbx),%rbx
L1707:
	testq %rbx,%rbx
	jnz L1708
L1710:
	movl _name_pool_size(%rip),%edi
	call _malloc
	movq %rax,_name_pool(%rip)
	testq %rax,%rax
	jnz L1713
L1711:
	call _no_space
L1713:
	movl $L836,%esi
	movq _name_pool(%rip),%rdi
	call _strcpy
	movq _name_pool(%rip),%rdi
	movl $L837,%esi
	addq $8,%rdi
	call _strcpy
	movq _name_pool(%rip),%r12
	addq $13,%r12
	movq _first_symbol(%rip),%r13
	jmp L1714
L1715:
	movq %r12,%rbx
	movq 16(%r13),%rcx
L1718:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%r12)
	incq %r12
	testb %al,%al
	jnz L1718
L1720:
	movq 16(%r13),%rdi
	call _free
	movq %rbx,16(%r13)
	movq 8(%r13),%r13
L1714:
	testq %r13,%r13
	jnz L1715
L1706:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_check_symbols:
L1722:
	pushq %rbx
L1723:
	movq _goal(%rip),%rax
	cmpb $0,38(%rax)
	jnz L1727
L1725:
	movq 16(%rax),%rdi
	call _undefined_goal
L1727:
	movq _first_symbol(%rip),%rbx
	jmp L1728
L1729:
	cmpb $0,38(%rbx)
	jnz L1734
L1732:
	movq 16(%rbx),%rdi
	call _undefined_symbol_warning
	movb $1,38(%rbx)
L1734:
	movq 8(%rbx),%rbx
L1728:
	testq %rbx,%rbx
	jnz L1729
L1724:
	popq %rbx
	ret 


_pack_symbols:
L1735:
	pushq %rbx
L1736:
	movl $2,_nsyms(%rip)
	movl $1,_ntokens(%rip)
	movq _first_symbol(%rip),%rax
	jmp L1738
L1739:
	incl _nsyms(%rip)
	cmpb $1,38(%rax)
	jnz L1744
L1742:
	incl _ntokens(%rip)
L1744:
	movq 8(%rax),%rax
L1738:
	testq %rax,%rax
	jnz L1739
L1741:
	movl _ntokens(%rip),%ecx
	movl %ecx,_start_symbol(%rip)
	movl _nsyms(%rip),%edi
	movl %edi,%eax
	subl %ecx,%eax
	movl %eax,_nvars(%rip)
	shll $3,%edi
	call _malloc
	movq %rax,_symbol_name(%rip)
	testq %rax,%rax
	jnz L1747
L1745:
	call _no_space
L1747:
	movl _nsyms(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_symbol_value(%rip)
	testq %rax,%rax
	jnz L1750
L1748:
	call _no_space
L1750:
	movl _nsyms(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_symbol_prec(%rip)
	testq %rax,%rax
	jnz L1753
L1751:
	call _no_space
L1753:
	movl _nsyms(%rip),%edi
	call _malloc
	movq %rax,_symbol_assoc(%rip)
	testq %rax,%rax
	jnz L1756
L1754:
	call _no_space
L1756:
	movl _nsyms(%rip),%edi
	shll $3,%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L1759
L1757:
	call _no_space
L1759:
	movq $0,(%rbx)
	movslq _start_symbol(%rip),%rax
	movq $0,(%rbx,%rax,8)
	movl _start_symbol(%rip),%edx
	movl $1,%ecx
	incl %edx
	movq _first_symbol(%rip),%rsi
	jmp L1760
L1761:
	cmpb $1,38(%rsi)
	jnz L1765
L1764:
	movl %ecx,%eax
	incl %ecx
	jmp L1841
L1765:
	movl %edx,%eax
	incl %edx
	movslq %eax,%rax
L1841:
	movq %rsi,(%rbx,%rax,8)
	movq 8(%rsi),%rsi
L1760:
	testq %rsi,%rsi
	jnz L1761
L1763:
	cmpl %ecx,_ntokens(%rip)
	jnz L1772
L1770:
	cmpl %edx,_nsyms(%rip)
	jz L1769
L1772:
	movl $1612,%edx
	movl $L8,%esi
	movl $L1774,%edi
	call ___assert
L1769:
	movl $1,%edx
	jmp L1775
L1776:
	movl %edx,%eax
	movq (%rbx,%rax,8),%rax
	movw %dx,34(%rax)
	incl %edx
L1775:
	cmpl %edx,_ntokens(%rip)
	jg L1776
L1778:
	movl _start_symbol(%rip),%ecx
	movq _goal(%rip),%rax
	incw %cx
	movw %cx,34(%rax)
	movl _start_symbol(%rip),%esi
	addl $2,%esi
L1779:
	movl _nsyms(%rip),%ecx
	incl %edx
	movq _goal(%rip),%rax
	cmpl %edx,%ecx
	jle L1781
L1780:
	movl %edx,%ecx
	movq (%rbx,%rcx,8),%rcx
	cmpq %rax,%rcx
	jz L1779
L1782:
	movw %si,34(%rcx)
	incl %esi
	jmp L1779
L1781:
	movw $0,32(%rax)
	movl _start_symbol(%rip),%ecx
	movl $1,%edx
L1840:
	incl %ecx
	cmpl %ecx,_nsyms(%rip)
	jle L1788
L1786:
	movslq %ecx,%rcx
	movq (%rbx,%rcx,8),%rax
	cmpq %rax,_goal(%rip)
	jz L1840
L1789:
	movw %dx,32(%rax)
	incl %edx
	jmp L1840
L1788:
	xorl %eax,%eax
	movl $1,%edi
	jmp L1792
L1793:
	movq (%rbx,%rdi,8),%rcx
	movswl 32(%rcx),%esi
	cmpl $256,%esi
	jle L1798
L1796:
	movl %eax,%ecx
	incl %eax
L1799:
	cmpl $0,%ecx
	jle L1805
L1803:
	movl %ecx,%edx
	decl %edx
	movslq %edx,%rdx
	movq _symbol_value(%rip),%r8
	movw (%r8,%rdx,2),%dx
	movswl %dx,%edx
	cmpl %edx,%esi
	jge L1805
L1804:
	movslq %ecx,%rcx
	movw %dx,(%r8,%rcx,2)
	decl %ecx
	jmp L1799
L1805:
	movslq %ecx,%rcx
	movq _symbol_value(%rip),%rdx
	movw %si,(%rdx,%rcx,2)
L1798:
	incl %edi
L1792:
	cmpl %edi,_ntokens(%rip)
	jg L1793
L1795:
	movq 8(%rbx),%rcx
	cmpw $-1,32(%rcx)
	jnz L1809
L1807:
	movw $256,32(%rcx)
L1809:
	xorl %esi,%esi
	movl $257,%edi
	movl $2,%edx
	jmp L1810
L1811:
	movl %edx,%ecx
	movq (%rbx,%rcx,8),%rcx
	cmpw $-1,32(%rcx)
	jnz L1816
L1817:
	cmpl %eax,%esi
	jge L1822
L1820:
	movl %esi,%esi
	movq _symbol_value(%rip),%rcx
	movswl (%rcx,%rsi,2),%ecx
	cmpl %ecx,%edi
	jnz L1822
L1824:
	incl %esi
	cmpl %esi,%eax
	jle L1829
L1827:
	movl %esi,%ecx
	movq _symbol_value(%rip),%r8
	movswl (%r8,%rcx,2),%ecx
	cmpl %ecx,%edi
	jz L1824
L1829:
	incl %edi
	jmp L1817
L1822:
	movl %edx,%edx
	movq (%rbx,%rdx,8),%rcx
	movw %di,32(%rcx)
	incl %edi
L1816:
	incl %edx
L1810:
	cmpl %edx,_ntokens(%rip)
	jg L1811
L1813:
	movq _name_pool(%rip),%rax
	movq _symbol_name(%rip),%rcx
	addq $8,%rax
	movq %rax,(%rcx)
	movq _symbol_value(%rip),%rax
	movw $0,(%rax)
	movq _symbol_prec(%rip),%rax
	movw $0,(%rax)
	movq _symbol_assoc(%rip),%rax
	movb $0,(%rax)
	movl $1,%esi
	jmp L1832
L1833:
	movq (%rbx,%rsi,8),%rcx
	movq 16(%rcx),%rcx
	movq %rcx,(%rax,%rsi,8)
	movq (%rbx,%rsi,8),%rax
	movw 32(%rax),%ax
	movq _symbol_value(%rip),%rcx
	movw %ax,(%rcx,%rsi,2)
	movq (%rbx,%rsi,8),%rax
	movw 36(%rax),%ax
	movq _symbol_prec(%rip),%rcx
	movw %ax,(%rcx,%rsi,2)
	movq (%rbx,%rsi,8),%rax
	movb 39(%rax),%al
	movq _symbol_assoc(%rip),%rcx
	movb %al,(%rsi,%rcx)
	movl %edx,%esi
L1832:
	movl _ntokens(%rip),%ecx
	movq _symbol_name(%rip),%rax
	leal 1(%rsi),%edx
	cmpl %esi,%ecx
	jg L1833
L1835:
	movslq _start_symbol(%rip),%rcx
	movq _name_pool(%rip),%rsi
	movq %rsi,(%rax,%rcx,8)
	movslq _start_symbol(%rip),%rax
	movq _symbol_value(%rip),%rcx
	movw $-1,(%rcx,%rax,2)
	movslq _start_symbol(%rip),%rax
	movq _symbol_prec(%rip),%rcx
	movw $0,(%rcx,%rax,2)
	movslq _start_symbol(%rip),%rax
	movq _symbol_assoc(%rip),%rcx
	movb $0,(%rax,%rcx)
	jmp L1836
L1837:
	movq (%rbx,%rdx,8),%rax
	movswl 34(%rax),%ecx
	movq 16(%rax),%rax
	movslq %ecx,%rcx
	movq _symbol_name(%rip),%rsi
	movq %rax,(%rsi,%rcx,8)
	movq (%rbx,%rdx,8),%rax
	movw 32(%rax),%ax
	movq _symbol_value(%rip),%rsi
	movw %ax,(%rsi,%rcx,2)
	movq (%rbx,%rdx,8),%rax
	movw 36(%rax),%ax
	movq _symbol_prec(%rip),%rsi
	movw %ax,(%rsi,%rcx,2)
	movq (%rbx,%rdx,8),%rax
	movb 39(%rax),%al
	movq _symbol_assoc(%rip),%rsi
	movb %al,(%rcx,%rsi)
	incl %edx
L1836:
	cmpl %edx,_nsyms(%rip)
	jg L1837
L1839:
	movq %rbx,%rdi
	call _free
L1737:
	popq %rbx
	ret 


_pack_grammar:
L1842:
L1843:
	movl _nitems(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_ritem(%rip)
	testq %rax,%rax
	jnz L1847
L1845:
	call _no_space
L1847:
	movl _nrules(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_rlhs(%rip)
	testq %rax,%rax
	jnz L1850
L1848:
	call _no_space
L1850:
	movl _nrules(%rip),%edi
	incl %edi
	shll $1,%edi
	call _malloc
	movq %rax,_rrhs(%rip)
	testq %rax,%rax
	jnz L1853
L1851:
	call _no_space
L1853:
	movl _nrules(%rip),%esi
	shll $1,%esi
	movq _rprec(%rip),%rdi
	call _realloc
	movq %rax,_rprec(%rip)
	testq %rax,%rax
	jnz L1856
L1854:
	call _no_space
L1856:
	movl _nrules(%rip),%esi
	movq _rassoc(%rip),%rdi
	call _realloc
	movq %rax,_rassoc(%rip)
	testq %rax,%rax
	jnz L1859
L1857:
	call _no_space
L1859:
	movq _ritem(%rip),%rax
	movw $-1,(%rax)
	movq _goal(%rip),%rax
	movw 34(%rax),%ax
	movq _ritem(%rip),%rcx
	movw %ax,2(%rcx)
	movq _ritem(%rip),%rax
	movw $0,4(%rax)
	movq _ritem(%rip),%rax
	movw $-2,6(%rax)
	movq _rlhs(%rip),%rax
	movw $0,(%rax)
	movq _rlhs(%rip),%rax
	movw $0,2(%rax)
	movl _start_symbol(%rip),%eax
	movq _rlhs(%rip),%rcx
	movw %ax,4(%rcx)
	movq _rrhs(%rip),%rax
	movw $0,(%rax)
	movq _rrhs(%rip),%rax
	movw $0,2(%rax)
	movq _rrhs(%rip),%rax
	movw $1,4(%rax)
	movl $4,%esi
	movl $3,%eax
	jmp L1860
L1861:
	movq _plhs(%rip),%rcx
	movq (%rcx,%rax,8),%rcx
	movw 34(%rcx),%cx
	movq _rlhs(%rip),%rdx
	movw %cx,(%rdx,%rax,2)
	movq _rrhs(%rip),%rcx
	movw %si,(%rcx,%rax,2)
	xorl %r8d,%r8d
	xorl %edi,%edi
L1864:
	movq _pitem(%rip),%rcx
	movq (%rcx,%rsi,8),%rdx
	movq _ritem(%rip),%rcx
	testq %rdx,%rdx
	jz L1866
L1865:
	movw 34(%rdx),%dx
	movw %dx,(%rcx,%rsi,2)
	movq _pitem(%rip),%rcx
	movq (%rcx,%rsi,8),%rcx
	cmpb $1,38(%rcx)
	jnz L1869
L1867:
	movswl 36(%rcx),%edi
	movsbl 39(%rcx),%r8d
L1869:
	incl %esi
	jmp L1864
L1866:
	movw %ax,%dx
	negw %dx
	movw %dx,(%rcx,%rsi,2)
	incl %esi
	movl %eax,%eax
	movq _rprec(%rip),%rcx
	cmpw $-1,(%rcx,%rax,2)
	jnz L1872
L1870:
	movw %di,(%rcx,%rax,2)
	movq _rassoc(%rip),%rcx
	movb %r8b,(%rax,%rcx)
L1872:
	incl %eax
L1860:
	cmpl %eax,_nrules(%rip)
	jg L1861
L1863:
	movq _rrhs(%rip),%rcx
	movw %si,(%rcx,%rax,2)
	movq _plhs(%rip),%rdi
	call _free
	movq _pitem(%rip),%rdi
	call _free
L1844:
	ret 


_print_grammar:
L1873:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1874:
	movq _verbose_file(%rip),%r15
	cmpb $0,_vflag(%rip)
	jz L1875
L1878:
	movl $1,%ebx
	movl $2,%r14d
	jmp L1880
L1881:
	movq _rlhs(%rip),%rdx
	movw (%rdx,%r14,2),%cx
	movl %r14d,%eax
	decl %eax
	movslq %eax,%rax
	cmpw (%rdx,%rax,2),%cx
	jz L1885
L1884:
	cmpl $2,%r14d
	jz L1889
L1887:
	pushq $L1890
	pushq %r15
	call _fprintf
	addq $16,%rsp
L1889:
	movl %r14d,%edx
	subl $2,%edx
	movq _rlhs(%rip),%rax
	movswq (%rax,%r14,2),%rcx
	movq _symbol_name(%rip),%rax
	pushq (%rax,%rcx,8)
	pushq %rdx
	pushq $L1891
	pushq %r15
	call _fprintf
	addq $32,%rsp
	movq _rlhs(%rip),%rax
	movswq (%rax,%r14,2),%rax
	movq _symbol_name(%rip),%rcx
	movq (%rcx,%rax,8),%rdi
	call _strlen
	leal 1(%rax),%r13d
	jmp L1902
L1885:
	movl %r14d,%eax
	subl $2,%eax
	pushq %rax
	pushq $L1892
	pushq %r15
	call _fprintf
	addq $24,%rsp
	movl %r13d,%r12d
L1893:
	decl %r12d
	movl (%r15),%eax
	decl %eax
	cmpl $0,%r12d
	jl L1895
L1894:
	movl %eax,(%r15)
	cmpl $0,%eax
	jl L1897
L1896:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $32,(%rcx)
	jmp L1893
L1897:
	movq %r15,%rsi
	movl $32,%edi
	call ___flushbuf
	jmp L1893
L1895:
	movl %eax,(%r15)
	cmpl $0,%eax
	jl L1900
L1899:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $124,(%rcx)
	jmp L1902
L1900:
	movq %r15,%rsi
	movl $124,%edi
	call ___flushbuf
L1902:
	movl %ebx,%ebx
	movq _ritem(%rip),%rax
	movw (%rax,%rbx,2),%ax
	incl %ebx
	cmpw $0,%ax
	jl L1904
L1903:
	movswq %ax,%rax
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rax,8)
	pushq $L1905
	pushq %r15
	call _fprintf
	addq $24,%rsp
	jmp L1902
L1904:
	decl (%r15)
	js L1907
L1906:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $10,(%rcx)
	jmp L1908
L1907:
	movq %r15,%rsi
	movl $10,%edi
	call ___flushbuf
L1908:
	incl %r14d
L1880:
	cmpl _nrules(%rip),%r14d
	jl L1881
L1875:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reader:
L1909:
L1910:
	movl $_banner,%edi
	call _write_section
	call _create_symbol_table
	call _read_declarations
	call _read_grammar
	call _free_symbol_table
	call _free_tags
	call _pack_names
	call _check_symbols
	call _pack_symbols
	call _pack_grammar
	call _free_symbols
	call _print_grammar
L1911:
	ret 

L1438:
	.byte 10,98,114,101,97,107,59,10
	.byte 0
L299:
	.byte 34,10,0
L228:
	.byte 98,105,110,97,114,121,0
L203:
	.byte 116,101,114,109,0
L836:
	.byte 36,97,99,99,101,112,116,0
L1892:
	.byte 37,52,100,32,32,0
L217:
	.byte 108,101,102,116,0
L242:
	.byte 117,110,105,111,110,0
L1905:
	.byte 32,37,115,0
L8:
	.byte 114,101,97,100,101,114,46,99
	.byte 0
L1386:
	.byte 121,121,118,115,112,91,37,100
	.byte 93,0
L387:
	.byte 42,32,0
L247:
	.byte 105,100,101,110,116,0
L291:
	.byte 35,105,100,101,110,116,32,34
	.byte 0
L212:
	.byte 116,121,112,101,0
L567:
	.byte 42,47,10,0
L1280:
	.byte 36,36,37,100,0
L1890:
	.byte 10,0
L227:
	.byte 110,111,110,97,115,115,111,99
	.byte 0
L391:
	.byte 42,47,0
L202:
	.byte 116,111,107,101,110,0
L222:
	.byte 114,105,103,104,116,0
L7:
	.byte 99,105,110,99,32,62,61,32
	.byte 48,0
L237:
	.byte 115,116,97,114,116,0
L1279:
	.byte 99,97,99,104,101,0
L1891:
	.byte 37,52,100,32,32,37,115,32
	.byte 58,0
L835:
	.byte 46,0
L1317:
	.byte 99,97,115,101,32,37,100,58
	.byte 10,0
L1703:
	.byte 116,97,103,95,116,97,98,108
	.byte 101,91,105,93,0
L1346:
	.byte 121,121,118,115,112,91,37,100
	.byte 93,46,37,115,0
L1365:
	.byte 121,121,118,97,108,0
L1338:
	.byte 121,121,118,97,108,46,37,115
	.byte 0
L489:
	.byte 32,89,89,83,84,89,80,69
	.byte 59,10,0
L1774:
	.byte 105,32,61,61,32,110,116,111
	.byte 107,101,110,115,32,38,38,32
	.byte 106,32,61,61,32,110,115,121
	.byte 109,115,0
L837:
	.byte 36,101,110,100,0
L460:
	.byte 116,121,112,101,100,101,102,32
	.byte 117,110,105,111,110,0
.globl _cptr
.comm _cptr, 8, 8
.globl _line
.comm _line, 8, 8
.globl _ntags
.comm _ntags, 4, 4
.globl _unionized
.comm _unionized, 1, 1
.globl _cache
.comm _cache, 8, 8
.globl _cinc
.comm _cinc, 4, 4
.globl _cache_size
.comm _cache_size, 4, 4
.globl _tagmax
.comm _tagmax, 4, 4
.globl _tag_table
.comm _tag_table, 8, 8
.globl _saw_eof
.comm _saw_eof, 1, 1
.globl _linesize
.comm _linesize, 4, 4
.globl _goal
.comm _goal, 8, 8
.globl _prec
.comm _prec, 4, 4
.globl _gensym
.comm _gensym, 4, 4
.globl _last_was_action
.comm _last_was_action, 1, 1
.globl _maxitems
.comm _maxitems, 4, 4
.globl _pitem
.comm _pitem, 8, 8
.globl _maxrules
.comm _maxrules, 4, 4
.globl _plhs
.comm _plhs, 8, 8
.globl _name_pool_size
.comm _name_pool_size, 4, 4
.globl _name_pool
.comm _name_pool, 8, 8

.globl _free_symbol_table
.globl _free
.globl _symbol_assoc
.globl _make_bucket
.globl _no_grammar
.globl _rlhs
.globl _sprintf
.globl _plhs
.globl _goal
.globl _write_section
.globl _unionized
.globl _vflag
.globl _get_literal
.globl _last_was_action
.globl _retyped_warning
.globl ___fillbuf
.globl _syntax_error
.globl _last_symbol
.globl _realloc
.globl _dflag
.globl _tagmax
.globl _dollar_error
.globl _output_file
.globl _banner
.globl _tag_table
.globl _restarted_warning
.globl _is_reserved
.globl _dollar_warning
.globl _name_pool
.globl _first_symbol
.globl _nsyms
.globl _malloc
.globl ___assert
.globl _terminal_start
.globl _gensym
.globl _default_action_warning
.globl _cache_size
.globl _cache
.globl _verbose_file
.globl _linesize
.globl _unknown_rhs
.globl _ntokens
.globl _input_file_name
.globl _unterminated_union
.globl _line_format
.globl _prec_redeclared
.globl _maxrules
.globl _lflag
.globl _maxitems
.globl _rrhs
.globl _lineno
.globl _get_name
.globl _text_file
.globl _unterminated_action
.globl _tokenized_start
.globl _ntags
.globl _reader
.globl _terminal_lhs
.globl _outline
.globl _union_file
.globl _unterminated_text
.globl _nitems
.globl _strcmp
.globl ___flushbuf
.globl _untyped_lhs
.globl _revalued_warning
.globl _over_unionized
.globl _start_symbol
.globl ___ctype
.globl _name_pool_size
.globl _prec
.globl _free_symbols
.globl _rprec
.globl _tolower
.globl _symbol_prec
.globl _symbol_name
.globl _nrules
.globl _saw_eof
.globl _undefined_symbol_warning
.globl _unexpected_EOF
.globl _pitem
.globl _illegal_tag
.globl _unterminated_comment
.globl _reprec_warning
.globl _used_reserved
.globl _hexval
.globl _lookup
.globl _symbol_value
.globl _ritem
.globl _cptr
.globl _rassoc
.globl _nvars
.globl _strlen
.globl _undefined_goal
.globl _input_file
.globl _line
.globl _strcpy
.globl _create_symbol_table
.globl _fprintf
.globl _cinc
.globl _untyped_rhs
.globl _unterminated_string
.globl _action_file
.globl _illegal_character
.globl _no_space
