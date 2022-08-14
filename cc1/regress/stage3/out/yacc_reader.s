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
	movq _input_file(%rip),%r12
	cmpb $0,_saw_eof(%rip)
	jnz L22
L21:
	decl (%r12)
	js L26
L25:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%ebx
	jmp L27
L26:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%ebx
L27:
	cmpl $-1,%ebx
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
	xorl %r13d,%r13d
	incl _lineno(%rip)
L45:
	movslq %r13d,%rax
	movq _line(%rip),%rcx
	movb %bl,(%rax,%rcx)
	cmpl $10,%ebx
	jz L66
L51:
	movl _linesize(%rip),%esi
	incl %r13d
	cmpl %r13d,%esi
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
	decl (%r12)
	js L60
L59:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%ebx
	jmp L61
L60:
	movq %r12,%rdi
	call ___fillbuf
	movl %eax,%ebx
L61:
	cmpl $-1,%ebx
	jnz L45
L62:
	movslq %r13d,%r13
	movq _line(%rip),%rax
	movb $10,(%r13,%rax)
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
	movq _line(%rip),%rdi
	testq %rdi,%rdi
	jz L70
L74:
	cmpb $10,(%rdi)
	jz L76
L75:
	incq %rdi
	jmp L74
L76:
	subq _line(%rip),%rdi
	incl %edi
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
	movq _cptr(%rip),%rax
	movq %rax,-16(%rbp)
	movq -16(%rbp),%rcx
	subq _line(%rip),%rcx
	movq %rcx,-16(%rbp)
	cmpb $10,(%rax)
	jnz L316
L314:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L316
L317:
	movq -16(%rbp),%rcx
	movq -24(%rbp),%rax
	leaq -2(%rcx,%rax),%rdx
	movq -24(%rbp),%rsi
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
	movq -16(%rbp),%rcx
	movq -24(%rbp),%rax
	leaq -2(%rcx,%rax),%rdx
	movq -24(%rbp),%rsi
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
	movq _cptr(%rip),%rax
	movq %rax,-16(%rbp)
	movq -16(%rbp),%rcx
	subq _line(%rip),%rcx
	movq %rcx,-16(%rbp)
	cmpb $0,_unionized(%rip)
	jz L456
L454:
	leaq -6(%rax),%rdi
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
	xorl %eax,%eax
L632:
	movl %eax,-28(%rbp)
L464:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%r14d
	movq _text_file(%rip),%rax
	decl (%rax)
	movq _text_file(%rip),%rax
	js L466
L465:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %r14b,(%rdx)
	jmp L467
L466:
	movq %rax,%rsi
	movl %r14d,%edi
	call ___flushbuf
L467:
	cmpb $0,_dflag(%rip)
	jz L470
L468:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L472
L471:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %r14b,(%rdx)
	jmp L470
L472:
	movq %rax,%rsi
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
	movl -28(%rbp),%eax
	incl %eax
	jmp L632
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
	movq _text_file(%rip),%rax
	js L576
L575:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $42,(%rdx)
	jmp L577
L576:
	movq %rax,%rsi
	movl $42,%edi
	call ___flushbuf
L577:
	cmpb $0,_dflag(%rip)
	jz L580
L578:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L582
L581:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $42,(%rdx)
	jmp L580
L582:
	movq %rax,%rsi
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
	movq _text_file(%rip),%rax
	js L589
L588:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L590
L589:
	movq %rax,%rsi
	movl %ebx,%edi
	call ___flushbuf
L590:
	cmpb $0,_dflag(%rip)
	jz L593
L591:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L595
L594:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L593
L595:
	movq %rax,%rsi
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
	movq _text_file(%rip),%rax
	js L605
L604:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $47,(%rdx)
	jmp L606
L605:
	movq %rax,%rsi
	movl $47,%edi
	call ___flushbuf
L606:
	cmpb $0,_dflag(%rip)
	jz L609
L607:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L611
L610:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $47,(%rdx)
	jmp L609
L611:
	movq %rax,%rsi
	movl $47,%edi
	call ___flushbuf
L609:
	incq _cptr(%rip)
	jmp L633
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
	movq _text_file(%rip),%rax
	js L537
L536:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $42,(%rdx)
	jmp L538
L537:
	movq %rax,%rsi
	movl $42,%edi
	call ___flushbuf
L538:
	cmpb $0,_dflag(%rip)
	jz L545
L539:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L543
L542:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb $42,(%rdx)
	jmp L545
L543:
	movq %rax,%rsi
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
	movq _text_file(%rip),%rax
	js L559
L558:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L560
L559:
	movq %rax,%rsi
	movl %ebx,%edi
	call ___flushbuf
L560:
	cmpb $0,_dflag(%rip)
	jz L545
L561:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L565
L564:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L545
L565:
	movq %rax,%rsi
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
	movq _text_file(%rip),%rax
	js L499
L498:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L500
L499:
	movq %rax,%rsi
	movl %ebx,%edi
	call ___flushbuf
L500:
	cmpb $0,_dflag(%rip)
	jz L503
L501:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L505
L504:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L503
L505:
	movq %rax,%rsi
	movl %ebx,%edi
	call ___flushbuf
L503:
	cmpl %ebx,%r14d
	jz L633
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
	movq _text_file(%rip),%rax
	js L518
L517:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L519
L518:
	movq %rax,%rsi
	movl %ebx,%edi
	call ___flushbuf
L519:
	cmpb $0,_dflag(%rip)
	jz L522
L520:
	movq _union_file(%rip),%rax
	decl (%rax)
	movq _union_file(%rip),%rax
	js L524
L523:
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%rax)
	movb %bl,(%rdx)
	jmp L522
L524:
	movq %rax,%rsi
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
L633:
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
	movq -16(%rbp),%rcx
	movq -24(%rbp),%rax
	leaq -6(%rcx,%rax),%rdx
	movq -24(%rbp),%rsi
	movl -4(%rbp),%edi
	call _unterminated_union
	jmp L464


_hexval:
L634:
L635:
	movl %edi,%eax
	cmpl $48,%eax
	jl L639
L640:
	cmpl $57,%eax
	jg L639
L637:
	subl $48,%eax
	ret
L639:
	cmpl $65,%eax
	jl L647
L648:
	cmpl $70,%eax
	jg L647
L645:
	subl $55,%eax
	ret
L647:
	cmpl $97,%eax
	jl L655
L656:
	cmpl $102,%eax
	jg L655
L653:
	subl $87,%eax
	ret
L655:
	movl $-1,%eax
L636:
	ret 

.align 2
L825:
	.short L778-_get_literal
	.short L780-_get_literal
	.short L788-_get_literal
	.short L784-_get_literal
	.short L790-_get_literal
	.short L782-_get_literal
	.short L786-_get_literal
.align 2
L826:
	.short L694-_get_literal
	.short L694-_get_literal
	.short L694-_get_literal
	.short L694-_get_literal
	.short L694-_get_literal
	.short L694-_get_literal
	.short L694-_get_literal
	.short L694-_get_literal

_get_literal:
L662:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L663:
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
L665:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%r12d
	cmpl %r12d,-4(%rbp)
	jz L669
L671:
	cmpl $10,%r12d
	jnz L675
L673:
	leaq (%r13,%r14),%rdx
	movq %r14,%rsi
	movl %r15d,%edi
	call _unterminated_string
L675:
	cmpl $92,%r12d
	jnz L678
L676:
	movq _cptr(%rip),%rdi
	movq %rdi,%rbx
	decq %rbx
	leaq 1(%rdi),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rdi),%r12d
	cmpl $48,%r12d
	jl L811
L813:
	cmpl $55,%r12d
	jg L811
L810:
	leal -48(%r12),%eax
	movzwl L826(,%rax,2),%eax
	addl $_get_literal,%eax
	jmp *%rax
L694:
	movsbl 1(%rdi),%eax
	subl $48,%r12d
	cmpl $48,%eax
	jl L697
L698:
	cmpl $55,%eax
	jg L697
L699:
	leal -48(%rax,%r12,8),%r12d
	leaq 2(%rdi),%rax
	movq %rax,_cptr(%rip)
	movsbl 2(%rdi),%eax
	cmpl $48,%eax
	jl L697
L705:
	cmpl $55,%eax
	jg L697
L706:
	leal -48(%rax,%r12,8),%r12d
	leaq 3(%rdi),%rax
	movq %rax,_cptr(%rip)
L697:
	cmpl $255,%r12d
	jle L678
L709:
	decq %rdi
	call _illegal_character
	jmp L678
L811:
	cmpl $10,%r12d
	jz L682
	jl L678
L815:
	cmpl $120,%r12d
	jz L713
	jg L678
L816:
	cmpb $97,%r12b
	jz L737
L817:
	cmpb $98,%r12b
	jz L739
L818:
	cmpb $102,%r12b
	jz L741
L819:
	cmpb $110,%r12b
	jz L743
L820:
	cmpb $114,%r12b
	jz L745
L821:
	cmpb $116,%r12b
	jz L747
L822:
	cmpb $118,%r12b
	movl $11,%eax
	cmovzl %eax,%r12d
	jmp L678
L747:
	movl $9,%r12d
	jmp L678
L745:
	movl $13,%r12d
	jmp L678
L743:
	movl $10,%r12d
	jmp L678
L741:
	movl $12,%r12d
	jmp L678
L739:
	movl $8,%r12d
	jmp L678
L737:
	movl $7,%r12d
	jmp L678
L713:
	leaq 2(%rdi),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rdi),%edi
	call _hexval
	movl %eax,%r12d
	cmpl $0,%eax
	jl L804
L717:
	cmpl $16,%eax
	jl L721
L804:
	movq %rbx,%rdi
	call _illegal_character
L721:
	movq _cptr(%rip),%rax
	movsbl (%rax),%edi
	call _hexval
	cmpl $0,%eax
	jl L678
L728:
	cmpl $16,%eax
	jge L678
L730:
	incq _cptr(%rip)
	shll $4,%r12d
	addl %eax,%r12d
	cmpl $255,%r12d
	jle L721
	jg L804
L678:
	movl %r12d,%edi
	call _cachec
	jmp L665
L682:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L665
L683:
	leaq (%r13,%r14),%rdx
	movq %r14,%rsi
	movl %r15d,%edi
	call _unterminated_string
	jmp L665
L669:
	movq %r14,%rdi
	call _free
	movl _cinc(%rip),%r14d
	movl %r14d,%edi
	call _malloc
	movq %rax,%r12
	testq %r12,%r12
	jnz L753
L751:
	call _no_space
L753:
	xorl %edx,%edx
L754:
	cmpl %edx,%r14d
	jle L757
L755:
	movslq %edx,%rcx
	movq _cache(%rip),%rax
	movb (%rcx,%rax),%al
	movb %al,(%rcx,%r12)
	incl %edx
	jmp L754
L757:
	movl $0,_cinc(%rip)
	cmpl $1,%r14d
	movl $34,%eax
	movl $39,%edi
	cmovnzl %eax,%edi
	call _cachec
	xorl %r13d,%r13d
L761:
	cmpl %r13d,%r14d
	jle L764
L762:
	movslq %r13d,%rax
	movzbl (%rax,%r12),%ebx
	cmpl $92,%ebx
	jz L769
L768:
	movq _cache(%rip),%rax
	movsbl (%rax),%eax
	cmpl %eax,%ebx
	jnz L770
L769:
	movl $92,%edi
	call _cachec
	jmp L806
L770:
	movl %ebx,%eax
	subl $32,%eax
	cmpl $95,%eax
	jae L773
L806:
	movl %ebx,%edi
	jmp L828
L773:
	movl $92,%edi
	call _cachec
	cmpl $7,%ebx
	jl L775
L809:
	cmpl $13,%ebx
	jg L775
L807:
	leal -7(%rbx),%eax
	movzwl L825(,%rax,2),%eax
	addl $_get_literal,%eax
	jmp *%rax
L786:
	movl $114,%edi
	jmp L828
L782:
	movl $102,%edi
	jmp L828
L790:
	movl $118,%edi
	jmp L828
L784:
	movl $110,%edi
	jmp L828
L788:
	movl $116,%edi
	jmp L828
L780:
	movl $98,%edi
	jmp L828
L778:
	movl $97,%edi
	jmp L828
L775:
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
L828:
	call _cachec
	incl %r13d
	jmp L761
L764:
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
	jnz L798
L799:
	cmpw $-1,32(%rbx)
	jnz L798
L800:
	movzbw (%r12),%ax
	movw %ax,32(%rbx)
L798:
	movq %r12,%rdi
	call _free
	movq %rbx,%rax
L664:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_is_reserved:
L830:
	pushq %rbx
L831:
	movq %rdi,%rbx
	movl $L836,%esi
	movq %rbx,%rdi
	call _strcmp
	testl %eax,%eax
	jz L867
L843:
	movl $L837,%esi
	movq %rbx,%rdi
	call _strcmp
	testl %eax,%eax
	jz L867
L839:
	movl $L838,%esi
	movq %rbx,%rdi
	call _strcmp
	testl %eax,%eax
	jz L867
L835:
	cmpb $36,(%rbx)
	jnz L850
L855:
	cmpb $36,1(%rbx)
	jnz L850
L851:
	movsbq 2(%rbx),%rax
	testb $4,___ctype+1(%rax)
	jz L850
L848:
	addq $3,%rbx
L859:
	movb (%rbx),%cl
	movsbq %cl,%rax
	testb $4,___ctype+1(%rax)
	jz L861
L860:
	incq %rbx
	jmp L859
L861:
	testb %cl,%cl
	jnz L850
L867:
	movl $1,%eax
	jmp L832
L850:
	xorl %eax,%eax
L832:
	popq %rbx
	ret 


_get_name:
L868:
L869:
	movl $0,_cinc(%rip)
	movq _cptr(%rip),%rax
	movsbl (%rax),%edi
L871:
	movslq %edi,%rax
	testb $7,___ctype+1(%rax)
	jnz L876
L883:
	cmpl $95,%edi
	jz L876
L885:
	cmpl $46,%edi
	jz L876
L881:
	cmpl $36,%edi
	jnz L877
L876:
	call _cachec
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%edi
	jmp L871
L877:
	xorl %edi,%edi
	call _cachec
	movq _cache(%rip),%rdi
	call _is_reserved
	testl %eax,%eax
	jz L889
L887:
	movq _cache(%rip),%rdi
	call _used_reserved
L889:
	movq _cache(%rip),%rdi
	call _lookup
L870:
	ret 


_get_number:
L891:
L892:
	movq _cptr(%rip),%rax
	movsbl (%rax),%edx
	xorl %eax,%eax
L894:
	movslq %edx,%rcx
	testb $4,___ctype+1(%rcx)
	jz L893
L895:
	leal (%rax,%rax,4),%eax
	addl %eax,%eax
	leal -48(%rax,%rdx),%eax
	movq _cptr(%rip),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,_cptr(%rip)
	movsbl 1(%rdx),%edx
	jmp L894
L893:
	ret 


_get_tag:
L899:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L900:
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
	jnz L904
L902:
	call _unexpected_EOF
L904:
	movslq %ebx,%rax
	testb $3,___ctype+1(%rax)
	jnz L907
L912:
	cmpl $95,%ebx
	jz L907
L913:
	cmpl $36,%ebx
	jz L907
L909:
	leaq (%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r14d,%edi
	call _illegal_tag
L907:
	movl $0,_cinc(%rip)
L916:
	movl %ebx,%edi
	call _cachec
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%ebx
	movslq %ebx,%rax
	testb $7,___ctype+1(%rax)
	jnz L916
L927:
	cmpl $95,%ebx
	jz L916
L929:
	cmpl $46,%ebx
	jz L916
L925:
	cmpl $36,%ebx
	jz L916
L921:
	xorl %edi,%edi
	call _cachec
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L933
L931:
	call _unexpected_EOF
L933:
	cmpl $62,%ebx
	jz L936
L934:
	leaq (%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r14d,%edi
	call _illegal_tag
L936:
	incq _cptr(%rip)
	xorl %r12d,%r12d
L937:
	movl _ntags(%rip),%eax
	cmpl %eax,%r12d
	jge L940
L938:
	movslq %r12d,%rbx
	movq _tag_table(%rip),%rax
	movq (%rax,%rbx,8),%rsi
	movq _cache(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L941
L943:
	incl %r12d
	jmp L937
L941:
	movq _tag_table(%rip),%rax
	movq (%rax,%rbx,8),%rax
	jmp L901
L940:
	movl _tagmax(%rip),%edi
	cmpl %edi,%eax
	jl L947
L945:
	addl $16,%edi
	movl %edi,_tagmax(%rip)
	movq _tag_table(%rip),%rax
	shll $3,%edi
	testq %rax,%rax
	jz L949
L948:
	movq %rdi,%rsi
	movq %rax,%rdi
	call _realloc
	jmp L950
L949:
	call _malloc
L950:
	movq %rax,_tag_table(%rip)
	testq %rax,%rax
	jnz L947
L951:
	call _no_space
L947:
	movl _cinc(%rip),%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L956
L954:
	call _no_space
L956:
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
L901:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_declare_tokens:
L958:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L959:
	movl %edi,%r14d
	xorl %r13d,%r13d
	testl %r14d,%r14d
	jz L963
L961:
	incl _prec(%rip)
L963:
	call _nextc
	movl %eax,%r12d
	cmpl $-1,%r12d
	jnz L966
L964:
	call _unexpected_EOF
L966:
	cmpl $60,%r12d
	jnz L973
L967:
	call _get_tag
	movq %rax,%r13
	call _nextc
	movl %eax,%r12d
	cmpl $-1,%eax
	jnz L973
L1039:
	call _unexpected_EOF
L973:
	movslq %r12d,%rax
	testb $3,___ctype+1(%rax)
	jnz L977
L988:
	cmpl $95,%r12d
	jz L977
L984:
	cmpl $46,%r12d
	jz L977
L980:
	cmpl $36,%r12d
	jnz L978
L977:
	call _get_name
	jmp L1040
L978:
	cmpl $39,%r12d
	jz L992
L995:
	cmpl $34,%r12d
	jnz L960
L992:
	call _get_literal
L1040:
	movq %rax,%rbx
	cmpq _goal(%rip),%rbx
	jnz L1002
L1000:
	movq 16(%rbx),%rdi
	call _tokenized_start
L1002:
	movb $1,38(%rbx)
	testq %r13,%r13
	jz L1005
L1003:
	movq 24(%rbx),%rax
	testq %rax,%rax
	jz L1008
L1009:
	cmpq %rax,%r13
	jz L1008
L1006:
	movq 16(%rbx),%rdi
	call _retyped_warning
L1008:
	movq %r13,24(%rbx)
L1005:
	testl %r14d,%r14d
	jz L1015
L1013:
	movw 36(%rbx),%ax
	testw %ax,%ax
	jz L1018
L1019:
	movswl %ax,%eax
	cmpl %eax,_prec(%rip)
	jz L1018
L1016:
	movq 16(%rbx),%rdi
	call _reprec_warning
L1018:
	movb %r14b,39(%rbx)
	movl _prec(%rip),%eax
	movw %ax,36(%rbx)
L1015:
	call _nextc
	movl %eax,%r12d
	cmpl $-1,%r12d
	jnz L1025
L1023:
	call _unexpected_EOF
L1025:
	movslq %r12d,%rax
	testb $4,___ctype+1(%rax)
	jz L973
L1026:
	call _get_number
	movl %eax,%r12d
	movw 32(%rbx),%ax
	cmpw $-1,%ax
	jz L1031
L1032:
	movswl %ax,%eax
	cmpl %eax,%r12d
	jz L1031
L1029:
	movq 16(%rbx),%rdi
	call _revalued_warning
L1031:
	movw %r12w,32(%rbx)
	call _nextc
	movl %eax,%r12d
	cmpl $-1,%eax
	jnz L973
	jz L1039
L960:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_declare_types:
L1041:
	pushq %rbx
	pushq %r12
L1042:
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1046
L1044:
	call _unexpected_EOF
L1046:
	cmpl $60,%ebx
	jz L1049
L1047:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	movq _cptr(%rip),%rdx
	call _syntax_error
L1049:
	call _get_tag
	movq %rax,%r12
L1050:
	call _nextc
	movslq %eax,%rcx
	testb $3,___ctype+1(%rcx)
	jnz L1054
L1065:
	cmpl $95,%eax
	jz L1054
L1061:
	cmpl $46,%eax
	jz L1054
L1057:
	cmpl $36,%eax
	jnz L1055
L1054:
	call _get_name
	jmp L1084
L1055:
	cmpl $39,%eax
	jz L1069
L1072:
	cmpl $34,%eax
	jnz L1043
L1069:
	call _get_literal
L1084:
	movq %rax,%rbx
	movq 24(%rbx),%rax
	testq %rax,%rax
	jz L1079
L1080:
	cmpq %rax,%r12
	jz L1079
L1077:
	movq 16(%rbx),%rdi
	call _retyped_warning
L1079:
	movq %r12,24(%rbx)
	jmp L1050
L1043:
	popq %r12
	popq %rbx
	ret 


_declare_start:
L1085:
	pushq %rbx
L1086:
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1090
L1088:
	call _unexpected_EOF
L1090:
	movslq %ebx,%rax
	testb $3,___ctype+1(%rax)
	jnz L1093
L1102:
	cmpl $95,%ebx
	jz L1093
L1098:
	cmpl $46,%ebx
	jz L1093
L1094:
	cmpl $36,%ebx
	jz L1093
L1091:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	movq _cptr(%rip),%rdx
	call _syntax_error
L1093:
	call _get_name
	movq %rax,%rbx
	cmpb $1,38(%rbx)
	jnz L1108
L1106:
	movq 16(%rbx),%rdi
	call _terminal_start
L1108:
	movq _goal(%rip),%rax
	testq %rax,%rax
	jz L1111
L1112:
	cmpq %rax,%rbx
	jz L1111
L1109:
	call _restarted_warning
L1111:
	movq %rbx,_goal(%rip)
L1087:
	popq %rbx
	ret 

.align 2
L1155:
	.short L1146-_read_declarations
	.short L1146-_read_declarations
	.short L1146-_read_declarations
	.short L1146-_read_declarations
	.short L1118-_read_declarations
	.short L1139-_read_declarations
	.short L1148-_read_declarations
	.short L1150-_read_declarations
	.short L1141-_read_declarations
	.short L1137-_read_declarations

_read_declarations:
L1116:
	pushq %rbx
L1117:
	movl $256,_cache_size(%rip)
	movl $256,%edi
	call _malloc
	movq %rax,_cache(%rip)
	testq %rax,%rax
	jnz L1122
L1119:
	call _no_space
L1122:
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1128
L1126:
	call _unexpected_EOF
L1128:
	cmpl $37,%ebx
	jz L1131
L1129:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	movq _cptr(%rip),%rdx
	call _syntax_error
L1131:
	call _keyword
	cmpl $0,%eax
	jl L1122
L1154:
	cmpl $9,%eax
	jg L1122
L1152:
	movzwl L1155(,%rax,2),%ecx
	addl $_read_declarations,%ecx
	jmp *%rcx
L1137:
	call _copy_ident
	jmp L1122
L1141:
	call _copy_union
	jmp L1122
L1150:
	call _declare_start
	jmp L1122
L1148:
	call _declare_types
	jmp L1122
L1139:
	call _copy_text
	jmp L1122
L1146:
	movl %eax,%edi
	call _declare_tokens
	jmp L1122
L1118:
	popq %rbx
	ret 


_initialize_grammar:
L1156:
L1157:
	movl $4,_nitems(%rip)
	movl $300,_maxitems(%rip)
	movl $2400,%edi
	call _malloc
	movq %rax,_pitem(%rip)
	testq %rax,%rax
	jnz L1161
L1159:
	call _no_space
L1161:
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
	jnz L1164
L1162:
	call _no_space
L1164:
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
	jnz L1167
L1165:
	call _no_space
L1167:
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
	jnz L1170
L1168:
	call _no_space
L1170:
	movq _rassoc(%rip),%rax
	movb $0,(%rax)
	movq _rassoc(%rip),%rax
	movb $0,1(%rax)
	movq _rassoc(%rip),%rax
	movb $0,2(%rax)
L1158:
	ret 


_expand_items:
L1171:
L1172:
	movl _maxitems(%rip),%esi
	addl $300,%esi
	movl %esi,_maxitems(%rip)
	shll $3,%esi
	movq _pitem(%rip),%rdi
	call _realloc
	movq %rax,_pitem(%rip)
	testq %rax,%rax
	jnz L1173
L1174:
	call _no_space
L1173:
	ret 


_expand_rules:
L1177:
L1178:
	movl _maxrules(%rip),%esi
	addl $100,%esi
	movl %esi,_maxrules(%rip)
	shll $3,%esi
	movq _plhs(%rip),%rdi
	call _realloc
	movq %rax,_plhs(%rip)
	testq %rax,%rax
	jnz L1182
L1180:
	call _no_space
L1182:
	movl _maxrules(%rip),%esi
	shll $1,%esi
	movq _rprec(%rip),%rdi
	call _realloc
	movq %rax,_rprec(%rip)
	testq %rax,%rax
	jnz L1185
L1183:
	call _no_space
L1185:
	movl _maxrules(%rip),%esi
	movq _rassoc(%rip),%rdi
	call _realloc
	movq %rax,_rassoc(%rip)
	testq %rax,%rax
	jnz L1179
L1186:
	call _no_space
L1179:
	ret 


_start_rule:
L1189:
	pushq %rbx
L1190:
	movq %rdi,%rbx
	movl %esi,%edi
	cmpb $1,38(%rbx)
	jnz L1194
L1192:
	call _terminal_lhs
L1194:
	movb $2,38(%rbx)
	movl _nrules(%rip),%eax
	cmpl _maxrules(%rip),%eax
	jl L1197
L1195:
	call _expand_rules
L1197:
	movslq _nrules(%rip),%rcx
	movq _plhs(%rip),%rax
	movq %rbx,(%rax,%rcx,8)
	movslq _nrules(%rip),%rcx
	movq _rprec(%rip),%rax
	movw $-1,(%rax,%rcx,2)
	movslq _nrules(%rip),%rcx
	movq _rassoc(%rip),%rax
	movb $0,(%rcx,%rax)
L1191:
	popq %rbx
	ret 


_advance_to_start:
L1198:
	pushq %rbx
	pushq %r12
	pushq %r13
L1201:
	call _nextc
	cmpl $37,%eax
	jnz L1205
L1207:
	movq _cptr(%rip),%rbx
	call _keyword
	cmpl $4,%eax
	jz L1212
L1245:
	cmpl $5,%eax
	jz L1213
L1246:
	cmpl $7,%eax
	jz L1215
L1247:
	movl _lineno(%rip),%edi
	movq %rbx,%rdx
	movq _line(%rip),%rsi
	call _syntax_error
	jmp L1201
L1215:
	call _declare_start
	jmp L1201
L1212:
	call _no_grammar
L1213:
	call _copy_text
	jmp L1201
L1205:
	call _nextc
	movslq %eax,%rcx
	testb $3,___ctype+1(%rcx)
	jnz L1219
L1228:
	cmpl $95,%eax
	jz L1219
L1224:
	cmpl $46,%eax
	jz L1219
L1220:
	cmpl $95,%eax
	jz L1219
L1217:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1219:
	call _get_name
	movq %rax,%r13
	cmpq $0,_goal(%rip)
	jnz L1234
L1232:
	cmpb $1,38(%r13)
	jnz L1237
L1235:
	movq 16(%r13),%rdi
	call _terminal_start
L1237:
	movq %r13,_goal(%rip)
L1234:
	movl _lineno(%rip),%r12d
	call _nextc
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1240
L1238:
	call _unexpected_EOF
L1240:
	cmpl $58,%ebx
	jz L1243
L1241:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1243:
	movl %r12d,%esi
	movq %r13,%rdi
	call _start_rule
	incq _cptr(%rip)
L1200:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_end_rule:
L1249:
L1250:
	cmpb $0,_last_was_action(%rip)
	jnz L1254
L1255:
	movslq _nrules(%rip),%rcx
	movq _plhs(%rip),%rax
	movq (%rax,%rcx,8),%rax
	cmpq $0,24(%rax)
	jz L1254
L1256:
	movl _nitems(%rip),%eax
	decl %eax
L1259:
	movslq %eax,%rdx
	movq _pitem(%rip),%rcx
	cmpq $0,(%rcx,%rdx,8)
	jz L1262
L1261:
	decl %eax
	jmp L1259
L1262:
	incl %eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rax
	testq %rax,%rax
	jz L1268
L1267:
	movq 24(%rax),%rcx
	movslq _nrules(%rip),%rax
	movq _plhs(%rip),%rdx
	movq (%rdx,%rax,8),%rax
	cmpq 24(%rax),%rcx
	jz L1254
L1268:
	call _default_action_warning
L1254:
	movb $0,_last_was_action(%rip)
	movl _nitems(%rip),%eax
	cmpl _maxitems(%rip),%eax
	jl L1273
L1271:
	call _expand_items
L1273:
	movslq _nitems(%rip),%rax
	movq _pitem(%rip),%rcx
	movq $0,(%rcx,%rax,8)
	incl _nitems(%rip)
	incl _nrules(%rip)
L1251:
	ret 


_insert_empty_rule:
L1274:
	pushq %rbx
L1275:
	cmpq $0,_cache(%rip)
	jnz L1279
L1277:
	movl $1151,%edx
	movl $L8,%esi
	movl $L1280,%edi
	call ___assert
L1279:
	movl _gensym(%rip),%eax
	incl %eax
	movl %eax,_gensym(%rip)
	pushq %rax
	pushq $L1281
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
	jle L1284
L1282:
	call _expand_items
L1284:
	movslq _nitems(%rip),%rcx
	movq _pitem(%rip),%rax
	movq %rbx,-8(%rax,%rcx,8)
	leaq -16(%rax,%rcx,8),%rdx
L1285:
	leaq -8(%rdx),%rcx
	movq -8(%rdx),%rax
	movq %rax,(%rdx)
	testq %rax,%rax
	jz L1287
L1286:
	movq %rcx,%rdx
	jmp L1285
L1287:
	movl _nrules(%rip),%eax
	incl %eax
	movl %eax,_nrules(%rip)
	cmpl _maxrules(%rip),%eax
	jl L1290
L1288:
	call _expand_rules
L1290:
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
L1276:
	popq %rbx
	ret 


_add_symbol:
L1291:
	pushq %rbx
	pushq %r12
L1292:
	movl _lineno(%rip),%r12d
	movq _cptr(%rip),%rax
	movsbl (%rax),%eax
	cmpl $39,%eax
	jz L1298
L1297:
	cmpl $34,%eax
	jnz L1299
L1298:
	call _get_literal
	jmp L1311
L1299:
	call _get_name
L1311:
	movq %rax,%rbx
	call _nextc
	cmpl $58,%eax
	jz L1301
L1303:
	cmpb $0,_last_was_action(%rip)
	jz L1307
L1305:
	call _insert_empty_rule
L1307:
	movb $0,_last_was_action(%rip)
	movl _nitems(%rip),%eax
	incl %eax
	movl %eax,_nitems(%rip)
	cmpl _maxitems(%rip),%eax
	jle L1310
L1308:
	call _expand_items
L1310:
	movl _nitems(%rip),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _pitem(%rip),%rax
	movq %rbx,(%rax,%rcx,8)
	jmp L1293
L1301:
	call _end_rule
	movl %r12d,%esi
	movq %rbx,%rdi
	call _start_rule
	incq _cptr(%rip)
L1293:
	popq %r12
	popq %rbx
	ret 


_copy_action:
L1312:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1313:
	movq _action_file(%rip),%rax
	movq %rax,-40(%rbp)
	movl _lineno(%rip),%eax
	movl %eax,-4(%rbp)
	call _dup_line
	movq %rax,-16(%rbp)
	movq _cptr(%rip),%rax
	movq %rax,-24(%rbp)
	movq -24(%rbp),%rax
	subq _line(%rip),%rax
	movq %rax,-24(%rbp)
	cmpb $0,_last_was_action(%rip)
	jz L1317
L1315:
	call _insert_empty_rule
L1317:
	movb $1,_last_was_action(%rip)
	movl _nrules(%rip),%eax
	subl $2,%eax
	pushq %rax
	pushq $L1318
	pushq -40(%rbp)
	call _fprintf
	addq $24,%rsp
	cmpb $0,_lflag(%rip)
	jnz L1321
L1319:
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq $_line_format
	pushq -40(%rbp)
	call _fprintf
	addq $32,%rsp
L1321:
	movq _cptr(%rip),%rax
	cmpb $61,(%rax)
	jnz L1324
L1322:
	incq %rax
	movq %rax,_cptr(%rip)
L1324:
	movl $0,-32(%rbp)
	movl _nitems(%rip),%edx
	decl %edx
L1325:
	movslq %edx,%rcx
	movq _pitem(%rip),%rax
	cmpq $0,(%rax,%rcx,8)
	jz L1328
L1326:
	incl -32(%rbp)
	decl %edx
	jmp L1325
L1328:
	xorl %eax,%eax
L1545:
	movl %eax,-28(%rbp)
L1329:
	movq _cptr(%rip),%rsi
	movsbl (%rsi),%eax
	movl %eax,%r14d
	cmpl $36,%eax
	jnz L1332
L1330:
	leaq 1(%rsi),%rdx
	movb 1(%rsi),%cl
	cmpb $60,%cl
	jnz L1334
L1333:
	movl _lineno(%rip),%r15d
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
	movsbl (%rdx),%ecx
	movl %ecx,%r14d
	cmpl $36,%ecx
	jnz L1337
L1336:
	pushq %rbx
	pushq $L1339
	pushq -40(%rbp)
	call _fprintf
	addq $24,%rsp
	incq _cptr(%rip)
	jmp L1546
L1337:
	movslq %ecx,%rax
	testb $4,___ctype+1(%rax)
	jz L1342
L1341:
	call _get_number
	movl %eax,%r12d
	cmpl %r12d,-32(%rbp)
	jge L1346
L1344:
	movl %r12d,%esi
	movl %r15d,%edi
	call _dollar_warning
L1346:
	movl %r12d,%eax
	jmp L1547
L1342:
	cmpl $45,%ecx
	jnz L1354
L1352:
	leaq 1(%rdx),%rcx
	movsbq 1(%rdx),%rax
	testb $4,___ctype+1(%rax)
	jz L1354
L1353:
	movq %rcx,_cptr(%rip)
	call _get_number
	negl %eax
L1547:
	subl -32(%rbp),%eax
	pushq %rbx
	pushq %rax
	pushq $L1347
	pushq -40(%rbp)
	call _fprintf
	addq $32,%rsp
	jmp L1546
L1354:
	leaq (%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r15d,%edi
	call _dollar_error
	jmp L1332
L1334:
	cmpb $36,%cl
	jnz L1358
L1357:
	cmpl $0,_ntags(%rip)
	jz L1361
L1360:
	movslq _nrules(%rip),%rcx
	movq _plhs(%rip),%rax
	movq (%rax,%rcx,8),%rax
	movq 24(%rax),%rbx
	testq %rbx,%rbx
	jnz L1365
L1363:
	call _untyped_lhs
L1365:
	pushq %rbx
	pushq $L1339
	pushq -40(%rbp)
	call _fprintf
	addq $24,%rsp
	jmp L1362
L1361:
	pushq $L1366
	pushq -40(%rbp)
	call _fprintf
	addq $16,%rsp
L1362:
	addq $2,_cptr(%rip)
	jmp L1329
L1358:
	movsbq %cl,%rax
	testb $4,___ctype+1(%rax)
	jz L1369
L1368:
	movq %rdx,_cptr(%rip)
	call _get_number
	movl %eax,%ebx
	cmpl $0,_ntags(%rip)
	jz L1372
L1371:
	cmpl $0,%ebx
	jle L1378
L1377:
	cmpl %ebx,-32(%rbp)
	jge L1376
L1378:
	movl %ebx,%edi
	call _unknown_rhs
L1376:
	movl _nitems(%rip),%eax
	addl %ebx,%eax
	subl -32(%rbp),%eax
	decl %eax
	movslq %eax,%rax
	movq _pitem(%rip),%rcx
	movq (%rcx,%rax,8),%rax
	movq 24(%rax),%r12
	testq %r12,%r12
	jnz L1383
L1381:
	movq 16(%rax),%rsi
	movl %ebx,%edi
	call _untyped_rhs
L1383:
	subl -32(%rbp),%ebx
	pushq %r12
	pushq %rbx
	pushq $L1347
	pushq -40(%rbp)
	call _fprintf
	addq $32,%rsp
	jmp L1329
L1372:
	cmpl %ebx,-32(%rbp)
	jge L1548
L1384:
	movl %ebx,%esi
	movl _lineno(%rip),%edi
	call _dollar_warning
	jmp L1548
L1369:
	cmpb $45,%cl
	jz L1389
L1332:
	movslq %r14d,%rax
	testb $3,___ctype+1(%rax)
	jnz L1407
L1403:
	cmpl $95,%r14d
	jz L1407
L1405:
	cmpl $36,%r14d
	jnz L1401
L1407:
	movq -40(%rbp),%rax
	decl (%rax)
	js L1411
L1410:
	movb %r14b,%sil
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L1412
L1411:
	movq -40(%rbp),%rsi
	movl %r14d,%edi
	call ___flushbuf
L1412:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%ecx
	movl %ecx,%r14d
	movslq %ecx,%rax
	testb $7,___ctype+1(%rax)
	jnz L1407
L1417:
	cmpl $95,%ecx
	jz L1407
L1419:
	cmpl $36,%ecx
	jz L1407
	jnz L1329
L1401:
	movq -40(%rbp),%rax
	decl (%rax)
	js L1423
L1422:
	movb %r14b,%sil
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L1424
L1423:
	movq -40(%rbp),%rsi
	movl %r14d,%edi
	call ___flushbuf
L1424:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	cmpl $10,%r14d
	jz L1429
	jl L1329
L1532:
	cmpl $125,%r14d
	jz L1443
	jg L1329
L1533:
	movb %r14b,%al
	cmpb $34,%al
	jz L1450
L1534:
	cmpb $39,%al
	jz L1450
L1535:
	cmpb $47,%al
	jz L1477
L1536:
	cmpb $59,%al
	jz L1434
L1537:
	cmpb $123,%al
	jnz L1329
L1441:
	movl -28(%rbp),%eax
	incl %eax
	jmp L1545
L1477:
	movsbl 1(%rcx),%eax
	cmpl $47,%eax
	jz L1478
L1480:
	cmpl $42,%eax
	jnz L1329
L1498:
	movl _lineno(%rip),%r14d
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%r12
	subq _line(%rip),%r12
	movq -40(%rbp),%rax
	decl (%rax)
	js L1502
L1501:
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb $42,(%rdx)
	jmp L1503
L1502:
	movq -40(%rbp),%rsi
	movl $42,%edi
	call ___flushbuf
L1503:
	incq _cptr(%rip)
L1504:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	movq -40(%rbp),%rax
	decl (%rax)
	js L1509
L1508:
	movb %bl,%sil
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L1510
L1509:
	movq -40(%rbp),%rsi
	movl %ebx,%edi
	call ___flushbuf
L1510:
	cmpl $42,%ebx
	jnz L1516
L1514:
	movq _cptr(%rip),%rax
	cmpb $47,(%rax)
	jnz L1516
L1515:
	movq -40(%rbp),%rax
	decl (%rax)
	js L1519
L1518:
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb $47,(%rdx)
	jmp L1520
L1519:
	movq -40(%rbp),%rsi
	movl $47,%edi
	call ___flushbuf
L1520:
	incq _cptr(%rip)
	jmp L1546
L1516:
	cmpl $10,%ebx
	jnz L1504
L1522:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L1504
L1525:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r14d,%edi
	call _unterminated_comment
	jmp L1504
L1478:
	movq -40(%rbp),%rax
	decl (%rax)
	js L1482
L1481:
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb $42,(%rdx)
	jmp L1484
L1482:
	movq -40(%rbp),%rsi
	movl $42,%edi
L1541:
	call ___flushbuf
L1484:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl 1(%rcx),%edi
	cmpl $10,%edi
	jz L1486
L1485:
	cmpl $42,%edi
	jnz L1492
L1490:
	cmpb $47,2(%rcx)
	jnz L1492
L1491:
	pushq $L387
	pushq -40(%rbp)
	call _fprintf
	addq $16,%rsp
	jmp L1484
L1492:
	movq -40(%rbp),%rax
	decl (%rax)
	js L1495
L1494:
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb %dil,(%rdx)
	jmp L1484
L1495:
	movq -40(%rbp),%rsi
	jmp L1541
L1486:
	pushq $L567
	pushq -40(%rbp)
	call _fprintf
	addq $16,%rsp
	jmp L1429
L1450:
	movl _lineno(%rip),%r15d
	call _dup_line
	movq %rax,%r13
	movq _cptr(%rip),%r12
	subq _line(%rip),%r12
L1451:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	movq -40(%rbp),%rax
	decl (%rax)
	js L1456
L1455:
	movb %bl,%sil
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L1457
L1456:
	movq -40(%rbp),%rsi
	movl %ebx,%edi
	call ___flushbuf
L1457:
	cmpl %ebx,%r14d
	jz L1546
L1460:
	cmpl $10,%ebx
	jnz L1464
L1462:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r15d,%edi
	call _unterminated_string
L1464:
	cmpl $92,%ebx
	jnz L1451
L1465:
	movq _cptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cptr(%rip)
	movsbl (%rcx),%ebx
	movq -40(%rbp),%rax
	decl (%rax)
	js L1469
L1468:
	movb %bl,%sil
	movq -40(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq -40(%rbp),%rax
	movq %rcx,24(%rax)
	movb %sil,(%rdx)
	jmp L1470
L1469:
	movq -40(%rbp),%rsi
	movl %ebx,%edi
	call ___flushbuf
L1470:
	cmpl $10,%ebx
	jnz L1451
L1471:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L1451
L1474:
	leaq -1(%r12,%r13),%rdx
	movq %r13,%rsi
	movl %r15d,%edi
	call _unterminated_string
	jmp L1451
L1546:
	movq %r13,%rdi
	call _free
	jmp L1329
L1443:
	movl -28(%rbp),%eax
	decl %eax
	movl %eax,-28(%rbp)
	cmpl $0,%eax
	jg L1329
	jle L1540
L1429:
	call _get_line
	cmpq $0,_line(%rip)
	jnz L1329
L1432:
	movq -16(%rbp),%rcx
	movq -24(%rbp),%rax
	leaq (%rax,%rcx),%rdx
	movq -16(%rbp),%rsi
	movl -4(%rbp),%edi
	call _unterminated_action
L1434:
	cmpl $0,-28(%rbp)
	jg L1329
L1540:
	pushq $L1439
	pushq -40(%rbp)
	call _fprintf
	addq $16,%rsp
L1314:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L1389:
	addq $2,%rsi
	movq %rsi,_cptr(%rip)
	call _get_number
	movl %eax,%ebx
	cmpl $0,_ntags(%rip)
	jz L1394
L1392:
	movl %ebx,%eax
	negl %eax
	movl %eax,%edi
	call _unknown_rhs
L1394:
	negl %ebx
L1548:
	subl -32(%rbp),%ebx
	pushq %rbx
	pushq $L1387
	pushq -40(%rbp)
	call _fprintf
	addq $24,%rsp
	jmp L1329


_mark_symbol:
L1549:
	pushq %rbx
L1550:
	movq _cptr(%rip),%rdx
	movsbl 1(%rdx),%eax
	cmpl $37,%eax
	jz L1552
L1555:
	cmpl $92,%eax
	jnz L1554
L1552:
	addq $2,%rdx
	movq %rdx,_cptr(%rip)
	movl $1,%eax
	jmp L1551
L1554:
	cmpl $61,%eax
	jnz L1561
L1560:
	addq $2,%rdx
	movq %rdx,_cptr(%rip)
	jmp L1562
L1561:
	cmpl $112,%eax
	jz L1578
L1582:
	cmpl $80,%eax
	jnz L1564
L1578:
	movsbl 2(%rdx),%eax
	cmpl $114,%eax
	jz L1574
L1586:
	cmpl $82,%eax
	jnz L1564
L1574:
	movsbl 3(%rdx),%eax
	cmpl $101,%eax
	jz L1570
L1590:
	cmpl $69,%eax
	jnz L1564
L1570:
	movsbl 4(%rdx),%eax
	cmpl $99,%eax
	jz L1566
L1594:
	cmpl $67,%eax
	jnz L1564
L1566:
	leaq 5(%rdx),%rsi
	movsbl 5(%rdx),%ecx
	movslq %ecx,%rax
	testb $7,___ctype+1(%rax)
	jnz L1564
L1606:
	cmpl $95,%ecx
	jz L1564
L1602:
	cmpl $46,%ecx
	jz L1564
L1598:
	cmpl $36,%ecx
	jz L1564
L1563:
	movq %rsi,_cptr(%rip)
	jmp L1562
L1564:
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1562:
	call _nextc
	movslq %eax,%rcx
	testb $3,___ctype+1(%rcx)
	jnz L1610
L1621:
	cmpl $95,%eax
	jz L1610
L1617:
	cmpl $46,%eax
	jz L1610
L1613:
	cmpl $36,%eax
	jnz L1611
L1610:
	call _get_name
	jmp L1640
L1611:
	cmpl $39,%eax
	jz L1625
L1628:
	cmpl $34,%eax
	jnz L1626
L1625:
	call _get_literal
L1640:
	movq %rax,%rbx
	jmp L1612
L1626:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
L1612:
	movslq _nrules(%rip),%rcx
	movq _rprec(%rip),%rax
	movw (%rax,%rcx,2),%ax
	cmpw $-1,%ax
	jz L1634
L1635:
	cmpw 36(%rbx),%ax
	jz L1634
L1632:
	call _prec_redeclared
L1634:
	movw 36(%rbx),%cx
	movslq _nrules(%rip),%rax
	movq _rprec(%rip),%rdx
	movw %cx,(%rdx,%rax,2)
	movb 39(%rbx),%dl
	movslq _nrules(%rip),%rcx
	movq _rassoc(%rip),%rax
	movb %dl,(%rcx,%rax)
	xorl %eax,%eax
L1551:
	popq %rbx
	ret 


_read_grammar:
L1641:
L1642:
	call _initialize_grammar
	call _advance_to_start
L1644:
	call _nextc
	cmpl $-1,%eax
	jz L1647
L1650:
	movslq %eax,%rcx
	testb $3,___ctype+1(%rcx)
	jnz L1652
L1671:
	cmpl $95,%eax
	jz L1652
L1667:
	cmpl $46,%eax
	jz L1652
L1663:
	cmpl $36,%eax
	jz L1652
L1659:
	cmpl $39,%eax
	jz L1652
L1655:
	cmpl $34,%eax
	jnz L1653
L1652:
	call _add_symbol
	jmp L1644
L1653:
	cmpl $123,%eax
	jz L1675
L1678:
	cmpl $61,%eax
	jnz L1676
L1675:
	call _copy_action
	jmp L1644
L1676:
	cmpl $124,%eax
	jnz L1683
L1682:
	call _end_rule
	movl _nrules(%rip),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _plhs(%rip),%rax
	xorl %esi,%esi
	movq (%rax,%rcx,8),%rdi
	call _start_rule
	incq _cptr(%rip)
	jmp L1644
L1683:
	cmpl $37,%eax
	jnz L1686
L1685:
	call _mark_symbol
	testl %eax,%eax
	jz L1644
	jnz L1647
L1686:
	movq _cptr(%rip),%rdx
	movl _lineno(%rip),%edi
	movq _line(%rip),%rsi
	call _syntax_error
	jmp L1644
L1647:
	call _end_rule
L1643:
	ret 


_free_tags:
L1692:
	pushq %rbx
	pushq %r12
L1693:
	cmpq $0,_tag_table(%rip)
	jz L1694
L1697:
	xorl %r12d,%r12d
L1699:
	movl _ntags(%rip),%eax
	movq _tag_table(%rip),%rdi
	cmpl %eax,%r12d
	jge L1702
L1700:
	movslq %r12d,%rbx
	cmpq $0,(%rdi,%rbx,8)
	jnz L1705
L1703:
	movl $1519,%edx
	movl $L8,%esi
	movl $L1706,%edi
	call ___assert
L1705:
	movq _tag_table(%rip),%rax
	movq (%rax,%rbx,8),%rdi
	call _free
	incl %r12d
	jmp L1699
L1702:
	call _free
L1694:
	popq %r12
	popq %rbx
	ret 


_pack_names:
L1707:
	pushq %rbx
	pushq %r12
	pushq %r13
L1708:
	movl $13,_name_pool_size(%rip)
	movq _first_symbol(%rip),%rbx
L1710:
	testq %rbx,%rbx
	jz L1713
L1711:
	movq 16(%rbx),%rdi
	call _strlen
	movl _name_pool_size(%rip),%ecx
	leal 1(%rcx,%rax),%eax
	movl %eax,_name_pool_size(%rip)
	movq 8(%rbx),%rbx
	jmp L1710
L1713:
	movl _name_pool_size(%rip),%edi
	call _malloc
	movq %rax,_name_pool(%rip)
	testq %rax,%rax
	jnz L1716
L1714:
	call _no_space
L1716:
	movl $L837,%esi
	movq _name_pool(%rip),%rdi
	call _strcpy
	movq _name_pool(%rip),%rdi
	movl $L838,%esi
	addq $8,%rdi
	call _strcpy
	movq _name_pool(%rip),%r12
	addq $13,%r12
	movq _first_symbol(%rip),%r13
L1717:
	testq %r13,%r13
	jz L1709
L1718:
	movq %r12,%rbx
	movq 16(%r13),%rcx
L1721:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%r12)
	incq %r12
	testb %al,%al
	jnz L1721
L1723:
	movq 16(%r13),%rdi
	call _free
	movq %rbx,16(%r13)
	movq 8(%r13),%r13
	jmp L1717
L1709:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_check_symbols:
L1725:
	pushq %rbx
L1726:
	movq _goal(%rip),%rax
	cmpb $0,38(%rax)
	jnz L1730
L1728:
	movq 16(%rax),%rdi
	call _undefined_goal
L1730:
	movq _first_symbol(%rip),%rbx
L1731:
	testq %rbx,%rbx
	jz L1727
L1732:
	cmpb $0,38(%rbx)
	jnz L1737
L1735:
	movq 16(%rbx),%rdi
	call _undefined_symbol_warning
	movb $1,38(%rbx)
L1737:
	movq 8(%rbx),%rbx
	jmp L1731
L1727:
	popq %rbx
	ret 


_pack_symbols:
L1738:
	pushq %rbx
L1739:
	movl $2,_nsyms(%rip)
	movl $1,_ntokens(%rip)
	movq _first_symbol(%rip),%rax
L1741:
	testq %rax,%rax
	jz L1744
L1742:
	incl _nsyms(%rip)
	cmpb $1,38(%rax)
	jnz L1747
L1745:
	incl _ntokens(%rip)
L1747:
	movq 8(%rax),%rax
	jmp L1741
L1744:
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
	jnz L1750
L1748:
	call _no_space
L1750:
	movl _nsyms(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_symbol_value(%rip)
	testq %rax,%rax
	jnz L1753
L1751:
	call _no_space
L1753:
	movl _nsyms(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_symbol_prec(%rip)
	testq %rax,%rax
	jnz L1756
L1754:
	call _no_space
L1756:
	movl _nsyms(%rip),%edi
	call _malloc
	movq %rax,_symbol_assoc(%rip)
	testq %rax,%rax
	jnz L1759
L1757:
	call _no_space
L1759:
	movl _nsyms(%rip),%edi
	shll $3,%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L1762
L1760:
	call _no_space
L1762:
	movq $0,(%rbx)
	movslq _start_symbol(%rip),%rax
	movq $0,(%rbx,%rax,8)
	movl _start_symbol(%rip),%edx
	movl $1,%ecx
	incl %edx
	movq _first_symbol(%rip),%rsi
L1763:
	testq %rsi,%rsi
	jz L1766
L1764:
	cmpb $1,38(%rsi)
	jnz L1768
L1767:
	movl %ecx,%eax
	incl %ecx
	jmp L1844
L1768:
	movl %edx,%eax
	incl %edx
L1844:
	movslq %eax,%rax
	movq %rsi,(%rbx,%rax,8)
	movq 8(%rsi),%rsi
	jmp L1763
L1766:
	cmpl %ecx,_ntokens(%rip)
	jnz L1775
L1773:
	cmpl %edx,_nsyms(%rip)
	jz L1772
L1775:
	movl $1612,%edx
	movl $L8,%esi
	movl $L1777,%edi
	call ___assert
L1772:
	movl $1,%edx
L1778:
	cmpl %edx,_ntokens(%rip)
	jle L1781
L1779:
	movslq %edx,%rax
	movq (%rbx,%rax,8),%rax
	movw %dx,34(%rax)
	incl %edx
	jmp L1778
L1781:
	movl _start_symbol(%rip),%ecx
	movq _goal(%rip),%rax
	incw %cx
	movw %cx,34(%rax)
	movl _start_symbol(%rip),%esi
	addl $2,%esi
L1782:
	movl _nsyms(%rip),%ecx
	incl %edx
	movq _goal(%rip),%rax
	cmpl %edx,%ecx
	jle L1784
L1783:
	movslq %edx,%rcx
	movq (%rbx,%rcx,8),%rcx
	cmpq %rax,%rcx
	jz L1782
L1785:
	movw %si,34(%rcx)
	incl %esi
	jmp L1782
L1784:
	movw $0,32(%rax)
	movl _start_symbol(%rip),%edx
	movl $1,%ecx
L1843:
	incl %edx
	cmpl %edx,_nsyms(%rip)
	jle L1791
L1789:
	movslq %edx,%rax
	movq (%rbx,%rax,8),%rax
	cmpq %rax,_goal(%rip)
	jz L1843
L1792:
	movw %cx,32(%rax)
	incl %ecx
	jmp L1843
L1791:
	xorl %eax,%eax
	movl $1,%r8d
L1795:
	cmpl %r8d,_ntokens(%rip)
	jle L1798
L1796:
	movslq %r8d,%rcx
	movq (%rbx,%rcx,8),%rcx
	movswl 32(%rcx),%edi
	cmpl $256,%edi
	jle L1801
L1799:
	movl %eax,%ecx
	incl %eax
L1802:
	cmpl $0,%ecx
	jle L1808
L1806:
	movl %ecx,%edx
	decl %edx
	movslq %edx,%rdx
	movq _symbol_value(%rip),%r9
	movw (%r9,%rdx,2),%si
	movswl %si,%edx
	cmpl %edx,%edi
	jge L1808
L1807:
	movslq %ecx,%rdx
	movw %si,(%r9,%rdx,2)
	decl %ecx
	jmp L1802
L1808:
	movslq %ecx,%rcx
	movq _symbol_value(%rip),%rdx
	movw %di,(%rdx,%rcx,2)
L1801:
	incl %r8d
	jmp L1795
L1798:
	movq 8(%rbx),%rcx
	cmpw $-1,32(%rcx)
	jnz L1812
L1810:
	movw $256,32(%rcx)
L1812:
	xorl %esi,%esi
	movl $257,%edx
	movl $2,%edi
L1813:
	cmpl %edi,_ntokens(%rip)
	jle L1816
L1814:
	movslq %edi,%rcx
	movq (%rbx,%rcx,8),%rcx
	cmpw $-1,32(%rcx)
	jnz L1819
L1820:
	cmpl %eax,%esi
	jge L1825
L1823:
	movslq %esi,%rcx
	movq _symbol_value(%rip),%r8
	movswl (%r8,%rcx,2),%ecx
	cmpl %ecx,%edx
	jnz L1825
L1827:
	incl %esi
	cmpl %esi,%eax
	jle L1832
L1830:
	movslq %esi,%rcx
	movq _symbol_value(%rip),%r8
	movswl (%r8,%rcx,2),%ecx
	cmpl %ecx,%edx
	jz L1827
L1832:
	incl %edx
	jmp L1820
L1825:
	movslq %edi,%rcx
	movq (%rbx,%rcx,8),%rcx
	movw %dx,32(%rcx)
	incl %edx
L1819:
	incl %edi
	jmp L1813
L1816:
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
L1835:
	movl _ntokens(%rip),%edx
	movq _symbol_name(%rip),%rcx
	leal 1(%rsi),%eax
	cmpl %esi,%edx
	jle L1838
L1836:
	movslq %esi,%rsi
	movq (%rbx,%rsi,8),%rdx
	movq 16(%rdx),%rdx
	movq %rdx,(%rcx,%rsi,8)
	movq (%rbx,%rsi,8),%rcx
	movw 32(%rcx),%cx
	movq _symbol_value(%rip),%rdx
	movw %cx,(%rdx,%rsi,2)
	movq (%rbx,%rsi,8),%rcx
	movw 36(%rcx),%cx
	movq _symbol_prec(%rip),%rdx
	movw %cx,(%rdx,%rsi,2)
	movq (%rbx,%rsi,8),%rcx
	movb 39(%rcx),%cl
	movq _symbol_assoc(%rip),%rdx
	movb %cl,(%rsi,%rdx)
	movl %eax,%esi
	jmp L1835
L1838:
	movslq _start_symbol(%rip),%rdx
	movq _name_pool(%rip),%rsi
	movq %rsi,(%rcx,%rdx,8)
	movslq _start_symbol(%rip),%rcx
	movq _symbol_value(%rip),%rdx
	movw $-1,(%rdx,%rcx,2)
	movslq _start_symbol(%rip),%rcx
	movq _symbol_prec(%rip),%rdx
	movw $0,(%rdx,%rcx,2)
	movslq _start_symbol(%rip),%rcx
	movq _symbol_assoc(%rip),%rdx
	movb $0,(%rcx,%rdx)
L1839:
	cmpl %eax,_nsyms(%rip)
	jle L1842
L1840:
	movslq %eax,%rsi
	movq (%rbx,%rsi,8),%rcx
	movswl 34(%rcx),%edx
	movq 16(%rcx),%rcx
	movslq %edx,%rdx
	movq _symbol_name(%rip),%rdi
	movq %rcx,(%rdi,%rdx,8)
	movq (%rbx,%rsi,8),%rcx
	movw 32(%rcx),%cx
	movq _symbol_value(%rip),%rdi
	movw %cx,(%rdi,%rdx,2)
	movq (%rbx,%rsi,8),%rcx
	movw 36(%rcx),%cx
	movq _symbol_prec(%rip),%rdi
	movw %cx,(%rdi,%rdx,2)
	movq (%rbx,%rsi,8),%rcx
	movb 39(%rcx),%cl
	movq _symbol_assoc(%rip),%rsi
	movb %cl,(%rdx,%rsi)
	incl %eax
	jmp L1839
L1842:
	movq %rbx,%rdi
	call _free
L1740:
	popq %rbx
	ret 


_pack_grammar:
L1845:
L1846:
	movl _nitems(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_ritem(%rip)
	testq %rax,%rax
	jnz L1850
L1848:
	call _no_space
L1850:
	movl _nrules(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_rlhs(%rip)
	testq %rax,%rax
	jnz L1853
L1851:
	call _no_space
L1853:
	movl _nrules(%rip),%edi
	incl %edi
	shll $1,%edi
	call _malloc
	movq %rax,_rrhs(%rip)
	testq %rax,%rax
	jnz L1856
L1854:
	call _no_space
L1856:
	movl _nrules(%rip),%esi
	shll $1,%esi
	movq _rprec(%rip),%rdi
	call _realloc
	movq %rax,_rprec(%rip)
	testq %rax,%rax
	jnz L1859
L1857:
	call _no_space
L1859:
	movl _nrules(%rip),%esi
	movq _rassoc(%rip),%rdi
	call _realloc
	movq %rax,_rassoc(%rip)
	testq %rax,%rax
	jnz L1862
L1860:
	call _no_space
L1862:
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
	movl $4,%ecx
	movl $3,%eax
L1863:
	movslq %eax,%rdx
	cmpl %eax,_nrules(%rip)
	jle L1866
L1864:
	movq _plhs(%rip),%rsi
	movq (%rsi,%rdx,8),%rsi
	movw 34(%rsi),%si
	movq _rlhs(%rip),%rdi
	movw %si,(%rdi,%rdx,2)
	movq _rrhs(%rip),%rsi
	movw %cx,(%rsi,%rdx,2)
	xorl %r9d,%r9d
	xorl %r8d,%r8d
L1867:
	movslq %ecx,%rdi
	movq _pitem(%rip),%rdx
	movq (%rdx,%rdi,8),%rsi
	movq _ritem(%rip),%rdx
	testq %rsi,%rsi
	jz L1869
L1868:
	movw 34(%rsi),%si
	movw %si,(%rdx,%rdi,2)
	movq _pitem(%rip),%rdx
	movq (%rdx,%rdi,8),%rdx
	cmpb $1,38(%rdx)
	jnz L1872
L1870:
	movswl 36(%rdx),%r8d
	movsbl 39(%rdx),%r9d
L1872:
	incl %ecx
	jmp L1867
L1869:
	movw %ax,%si
	negw %si
	movw %si,(%rdx,%rdi,2)
	incl %ecx
	movslq %eax,%rdx
	movq _rprec(%rip),%rsi
	cmpw $-1,(%rsi,%rdx,2)
	jnz L1875
L1873:
	movw %r8w,(%rsi,%rdx,2)
	movq _rassoc(%rip),%rsi
	movb %r9b,(%rdx,%rsi)
L1875:
	incl %eax
	jmp L1863
L1866:
	movq _rrhs(%rip),%rax
	movw %cx,(%rax,%rdx,2)
	movq _plhs(%rip),%rdi
	call _free
	movq _pitem(%rip),%rdi
	call _free
L1847:
	ret 


_print_grammar:
L1876:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1877:
	movq _verbose_file(%rip),%r15
	cmpb $0,_vflag(%rip)
	jz L1878
L1881:
	movl $1,%r14d
	movl $2,%r13d
L1883:
	cmpl _nrules(%rip),%r13d
	jge L1878
L1884:
	movslq %r13d,%rbx
	movq _rlhs(%rip),%rdx
	movw (%rdx,%rbx,2),%cx
	movl %r13d,%eax
	decl %eax
	movslq %eax,%rax
	cmpw (%rdx,%rax,2),%cx
	jz L1888
L1887:
	cmpl $2,%r13d
	jz L1892
L1890:
	pushq $L1893
	pushq %r15
	call _fprintf
	addq $16,%rsp
L1892:
	movl %r13d,%edx
	subl $2,%edx
	movq _rlhs(%rip),%rax
	movswq (%rax,%rbx,2),%rcx
	movq _symbol_name(%rip),%rax
	pushq (%rax,%rcx,8)
	pushq %rdx
	pushq $L1894
	pushq %r15
	call _fprintf
	addq $32,%rsp
	movq _rlhs(%rip),%rax
	movswq (%rax,%rbx,2),%rax
	movq _symbol_name(%rip),%rcx
	movq (%rcx,%rax,8),%rdi
	call _strlen
	leal 1(%rax),%r12d
	jmp L1905
L1888:
	movl %r13d,%eax
	subl $2,%eax
	pushq %rax
	pushq $L1895
	pushq %r15
	call _fprintf
	addq $24,%rsp
	movl %r12d,%ebx
L1896:
	decl %ebx
	movl (%r15),%eax
	decl %eax
	cmpl $0,%ebx
	jl L1898
L1897:
	movl %eax,(%r15)
	cmpl $0,%eax
	jl L1900
L1899:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $32,(%rcx)
	jmp L1896
L1900:
	movq %r15,%rsi
	movl $32,%edi
	call ___flushbuf
	jmp L1896
L1898:
	movl %eax,(%r15)
	cmpl $0,%eax
	jl L1903
L1902:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $124,(%rcx)
	jmp L1905
L1903:
	movq %r15,%rsi
	movl $124,%edi
	call ___flushbuf
L1905:
	movslq %r14d,%rcx
	movq _ritem(%rip),%rax
	movw (%rax,%rcx,2),%ax
	incl %r14d
	cmpw $0,%ax
	jl L1907
L1906:
	movswq %ax,%rax
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rax,8)
	pushq $L1908
	pushq %r15
	call _fprintf
	addq $24,%rsp
	jmp L1905
L1907:
	decl (%r15)
	js L1910
L1909:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $10,(%rcx)
	jmp L1911
L1910:
	movq %r15,%rsi
	movl $10,%edi
	call ___flushbuf
L1911:
	incl %r13d
	jmp L1883
L1878:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reader:
L1912:
L1913:
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
L1914:
	ret 

L1439:
	.byte 10,98,114,101,97,107,59,10
	.byte 0
L299:
	.byte 34,10,0
L228:
	.byte 98,105,110,97,114,121,0
L203:
	.byte 116,101,114,109,0
L837:
	.byte 36,97,99,99,101,112,116,0
L1895:
	.byte 37,52,100,32,32,0
L217:
	.byte 108,101,102,116,0
L242:
	.byte 117,110,105,111,110,0
L1908:
	.byte 32,37,115,0
L8:
	.byte 114,101,97,100,101,114,46,99
	.byte 0
L1387:
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
L1281:
	.byte 36,36,37,100,0
L1893:
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
L1280:
	.byte 99,97,99,104,101,0
L1894:
	.byte 37,52,100,32,32,37,115,32
	.byte 58,0
L836:
	.byte 46,0
L1318:
	.byte 99,97,115,101,32,37,100,58
	.byte 10,0
L1706:
	.byte 116,97,103,95,116,97,98,108
	.byte 101,91,105,93,0
L1347:
	.byte 121,121,118,115,112,91,37,100
	.byte 93,46,37,115,0
L1366:
	.byte 121,121,118,97,108,0
L1339:
	.byte 121,121,118,97,108,46,37,115
	.byte 0
L489:
	.byte 32,89,89,83,84,89,80,69
	.byte 59,10,0
L1777:
	.byte 105,32,61,61,32,110,116,111
	.byte 107,101,110,115,32,38,38,32
	.byte 106,32,61,61,32,110,115,121
	.byte 109,115,0
L838:
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
