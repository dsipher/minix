.data
_digits:
 .byte 48,49,50,51,52,53,54,55
 .byte 56,57,65,66,67,68,69,70
 .byte 0
.text
.align 1
L86:
	.byte 34
	.byte 39
	.byte 63
	.byte 92
	.byte 97
	.byte 98
	.byte 102
	.byte 110
	.byte 114
	.byte 116
	.byte 118
.align 2
L87:
	.short L78-_escape
	.short L78-_escape
	.short L78-_escape
	.short L78-_escape
	.short L61-_escape
	.short L63-_escape
	.short L65-_escape
	.short L67-_escape
	.short L69-_escape
	.short L71-_escape
	.short L73-_escape

_escape:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq %rdi,%r13
	movq (%r13),%r12
	movb (%r12),%r14b
	leaq 1(%r12),%rbx
	cmpb $92,%r14b
	jnz L5
L4:
	movb 1(%r12),%cl
	movsbl %cl,%edi
	movl %edi,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L8
L14:
	cmpb $56,%cl
	jz L8
L10:
	cmpb $57,%cl
	jz L8
L7:
	call _toupper
	movl %eax,%esi
	movl $_digits,%edi
	call _strchr
	subq $_digits,%rax
	movl %eax,%r14d
	leaq 2(%r12),%rbx
	movb 2(%r12),%cl
	movsbl %cl,%edi
	movl %edi,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L6
L25:
	cmpb $56,%cl
	jz L6
L21:
	cmpb $57,%cl
	jz L6
L18:
	call _toupper
	movl %eax,%esi
	movl $_digits,%edi
	call _strchr
	subq $_digits,%rax
	leal (%rax,%r14,8),%r14d
	leaq 3(%r12),%rbx
	movb 3(%r12),%cl
	movsbl %cl,%edi
	movl %edi,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L6
L36:
	cmpb $56,%cl
	jz L6
L32:
	cmpb $57,%cl
	jz L6
L29:
	call _toupper
	movl %eax,%esi
	movl $_digits,%edi
	call _strchr
	subq $_digits,%rax
	leal (%rax,%r14,8),%r14d
	leaq 4(%r12),%rbx
	cmpl $255,%r14d
	jle L6
	jg L82
L8:
	cmpb $120,%cl
	jnz L45
L44:
	leaq 2(%r12),%rbx
	movsbq 2(%r12),%rax
	testb $68,___ctype+1(%rax)
	jz L82
L49:
	xorl %r14d,%r14d
L51:
	movb (%rbx),%dil
	movsbq %dil,%rax
	testb $68,___ctype+1(%rax)
	jz L6
L52:
	testl $240,%r14d
	jnz L82
L56:
	movsbl %dil,%edi
	shll $4,%r14d
	call _toupper
	movl %eax,%esi
	movl $_digits,%edi
	call _strchr
	subq $_digits,%rax
	addl %eax,%r14d
	incq %rbx
	jmp L51
L45:
	xorl %eax,%eax
L83:
	cmpb L86(,%rax),%cl
	jz L84
L85:
	incl %eax
	cmpl $11,%eax
	jb L83
	jae L82
L84:
	movzwl L87(,%rax,2),%eax
	addl $_escape,%eax
	jmp *%rax
L73:
	movl $11,%r14d
	jmp L59
L71:
	movl $9,%r14d
	jmp L59
L69:
	movl $13,%r14d
	jmp L59
L67:
	movl $10,%r14d
	jmp L59
L65:
	movl $12,%r14d
	jmp L59
L63:
	movl $8,%r14d
	jmp L59
L61:
	movl $7,%r14d
	jmp L59
L78:
	movl %edi,%r14d
L59:
	leaq 2(%r12),%rbx
	jmp L6
L82:
	movl $-1,%eax
	jmp L3
L5:
	movzbl %r14b,%r14d
L6:
	movq %rbx,(%r13)
	movl %r14d,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
_pool:
	.quad 0
	.quad _pool
.text

_alloc:
L88:
	pushq %rbx
	pushq %r12
L89:
	movq _pool(%rip),%rbx
	movl %edi,%r12d
	testq %rbx,%rbx
	jnz L92
L91:
	movl $48,%edi
	call _safe_malloc
	movq %rax,%rbx
	jmp L93
L92:
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	testq %rcx,%rcx
	jz L98
L97:
	movq %rax,40(%rcx)
	jmp L99
L98:
	movq %rax,_pool+8(%rip)
L99:
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	movq %rcx,(%rax)
L93:
	movl %r12d,(%rbx)
	testl $2147483648,%r12d
	jnz L102
L100:
	leaq 8(%rbx),%rdi
	call _vstring_init
L102:
	movq %rbx,%rax
L90:
	popq %r12
	popq %rbx
	ret 


_token_number:
L104:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
L105:
	leaq -21(%rbp),%rax
	pushq %rdi
	pushq $L107
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movl $54,%edi
	call _alloc
	movq %rax,%rbx
	leaq -21(%rbp),%rsi
	leaq 8(%rbx),%rdi
	call _vstring_puts
	movq %rbx,%rax
L106:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_backslash:
L109:
	pushq %rbx
	pushq %r12
L110:
	movq %rdi,%r12
	movl %esi,%ebx
	cmpl $92,%ebx
	jz L112
L115:
	cmpl $34,%ebx
	jnz L114
L112:
	movb $92,%sil
	movq %r12,%rdi
	call _vstring_putc
L114:
	movb %bl,%sil
	movq %r12,%rdi
	call _vstring_putc
L111:
	popq %r12
	popq %rbx
	ret 


_token_string:
L119:
	pushq %rbx
	pushq %r12
L120:
	movq %rdi,%r12
	movl $55,%edi
	call _alloc
	movq %rax,%rbx
	movb $34,%sil
	leaq 8(%rbx),%rdi
	call _vstring_putc
L122:
	movb (%r12),%sil
	testb %sil,%sil
	jz L124
L123:
	movsbl %sil,%esi
	incq %r12
	leaq 8(%rbx),%rdi
	call _backslash
	jmp L122
L124:
	movb $34,%sil
	leaq 8(%rbx),%rdi
	call _vstring_putc
	movq %rbx,%rax
L121:
	popq %r12
	popq %rbx
	ret 


_token_int:
L126:
	pushq %rbx
L127:
	movq %rdi,%rbx
	movl $-2147483589,%edi
	call _alloc
	movq %rbx,8(%rax)
L128:
	popq %rbx
	ret 


_token_convert_number:
L130:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L131:
	movq %rdi,%r13
	movl $-2147483589,%r12d
	movl $0,_errno(%rip)
	testl $1,8(%r13)
	jz L134
L133:
	leaq 9(%r13),%rdi
	jmp L135
L134:
	movq 24(%r13),%rdi
L135:
	xorl %edx,%edx
	leaq -8(%rbp),%rsi
	call _strtoul
	movq %rax,%rbx
	movq -8(%rbp),%rax
	movsbl (%rax),%edi
	call _toupper
	cmpl $76,%eax
	jnz L138
L136:
	incq -8(%rbp)
L138:
	movq -8(%rbp),%rax
	movsbl (%rax),%edi
	call _toupper
	cmpl $85,%eax
	movl $-2147483588,%eax
	cmovzl %eax,%r12d
	movq -8(%rbp),%rax
	movsbl (%rax),%edi
	call _toupper
	cmpl $76,%eax
	jnz L144
L142:
	incq -8(%rbp)
L144:
	movq -8(%rbp),%rax
	cmpb $0,(%rax)
	jnz L149
L148:
	cmpl $0,_errno(%rip)
	jz L147
L149:
	pushq $L152
	call _error
	addq $8,%rsp
L147:
	leaq 8(%r13),%rdi
	call _vstring_free
	movl %r12d,(%r13)
	movq %rbx,8(%r13)
L132:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_token_convert_char:
L153:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L154:
	movq %rdi,%rbx
	testl $1,8(%rbx)
	jz L157
L156:
	leaq 9(%rbx),%rax
	jmp L158
L157:
	movq 24(%rbx),%rax
L158:
	incq %rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _escape
	movl %eax,%r12d
	cmpl $-1,%r12d
	jnz L161
L159:
	pushq $L162
	call _error
	addq $8,%rsp
L161:
	movq -8(%rbp),%rax
	cmpb $39,(%rax)
	jz L165
L163:
	pushq $L166
	call _error
	addq $8,%rsp
L165:
	leaq 8(%rbx),%rdi
	call _vstring_free
	movl $-2147483589,(%rbx)
	movslq %r12d,%r12
	movq %r12,8(%rbx)
L155:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_token_free:
L167:
	pushq %rbx
L168:
	movq %rdi,%rbx
	testl $2147483648,(%rbx)
	jnz L173
L170:
	leaq 8(%rbx),%rdi
	call _vstring_free
L173:
	movq _pool(%rip),%rax
	leaq 32(%rbx),%rcx
	movq %rax,32(%rbx)
	testq %rax,%rax
	jz L177
L176:
	movq _pool(%rip),%rax
	movq %rcx,40(%rax)
	jmp L178
L177:
	movq %rcx,_pool+8(%rip)
L178:
	movq %rbx,_pool(%rip)
	movq $_pool,40(%rbx)
L169:
	popq %rbx
	ret 


_token_space:
L179:
	pushq %rbx
L180:
	movl $51,%edi
	call _alloc
	movq %rax,%rbx
	movb $32,%sil
	leaq 8(%rbx),%rdi
	call _vstring_putc
	movq %rbx,%rax
L181:
	popq %rbx
	ret 

.data
.align 4
_modifiers:
	.int 536870935
	.int 536870937
	.int 536870936
	.int 536870938
	.int 0
	.int 536870939
	.int 0
	.int 536870940
	.int 0
	.int 536870941
	.int 536873247
	.int 536870942
	.int 536873505
	.int 536870944
	.int 0
	.int 536870946
	.int 536871689
	.int 536871971
	.int 0
	.int 536870948
	.int 536871691
	.int 536871973
	.int 0
	.int 536870950
	.int 1610612778
	.int 0
	.int 0
	.int 536872213
	.int 0
	.int 536872214
.text

_token_separate:
L183:
L184:
	cmpl $52,%edi
	jz L189
L327:
	cmpl $54,%edi
	jz L199
L328:
	cmpl $536870951,%edi
	jz L254
L329:
	cmpl $536870952,%edi
	jz L232
L330:
	cmpl $536870956,%edi
	jz L218
L331:
	cmpl $536870960,%edi
	jz L218
L332:
	cmpl $536871425,%edi
	jnz L186
L264:
	cmpl $536871944,%esi
	jz L325
L276:
	cmpl $536871971,%esi
	jz L325
L272:
	cmpl $536871689,%esi
	jz L325
L268:
	cmpl $536870948,%esi
	jz L325
L186:
	movzbl %dil,%eax
	cmpl $15,%eax
	jge L187
L283:
	movslq %eax,%rax
	movl _modifiers+4(,%rax,8),%ecx
	testl %ecx,%ecx
	jz L287
L288:
	cmpl $536870925,%esi
	jz L325
L292:
	cmpl $536872213,%esi
	jz L325
L287:
	movl _modifiers(,%rax,8),%eax
	testl %eax,%eax
	jz L187
L297:
	cmpl %esi,%edi
	jz L325
L307:
	cmpl %eax,%esi
	jz L325
L303:
	cmpl %ecx,%esi
	jz L325
L302:
	movzbl %al,%eax
	cmpl $15,%eax
	jge L187
L314:
	movslq %eax,%rax
	cmpl _modifiers(,%rax,8),%esi
	jz L325
L319:
	cmpl _modifiers+4(,%rax,8),%esi
	jnz L187
	jz L325
L218:
	cmpb $0,_cxx_mode(%rip)
	jz L187
L222:
	cmpl $536870956,%esi
	jz L325
L226:
	cmpl $536870960,%esi
	jnz L187
	jz L325
L232:
	cmpl $536870952,%esi
	jz L325
L244:
	cmpl $536870953,%esi
	jz L325
L240:
	cmpb $0,_cxx_mode(%rip)
	jz L236
L248:
	cmpl $536871170,%esi
	jz L325
L236:
	cmpl $54,%esi
	jnz L187
	jz L325
L254:
	cmpb $0,_cxx_mode(%rip)
	jz L187
L258:
	cmpl $536871170,%esi
	jnz L187
	jz L325
L199:
	cmpl $52,%esi
	jz L325
L211:
	cmpl $54,%esi
	jz L325
L207:
	cmpl $536870952,%esi
	jz L325
L203:
	cmpl $536870953,%esi
	jnz L187
	jz L325
L189:
	cmpl $52,%esi
	jz L325
L193:
	cmpl $54,%esi
	jnz L187
L325:
	movl $1,%eax
	ret
L187:
	xorl %eax,%eax
L185:
	ret 

.data
.align 4
_classes:
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 51
	.int 0
	.int 51
	.int 51
	.int 51
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 51
	.int 536870926
	.int 55
	.int 1610612748
	.int 1073741886
	.int 536871172
	.int 536872453
	.int 56
	.int 536870927
	.int 536870928
	.int 536871170
	.int 536871424
	.int 536870959
	.int 536871425
	.int 536870952
	.int 536871171
	.int 54
	.int 54
	.int 54
	.int 54
	.int 54
	.int 54
	.int 54
	.int 54
	.int 54
	.int 54
	.int 536870956
	.int 536870955
	.int 536871946
	.int 536870925
	.int 536871944
	.int 536870957
	.int 1073741886
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 536870931
	.int 1073741886
	.int 536870932
	.int 536872711
	.int 52
	.int 1073741886
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 52
	.int 536870929
	.int 536872966
	.int 536870930
	.int 536870958
	.int 0
.text
.align 2
L493:
	.short L421-_token_scan
	.short L426-_token_scan
	.short L345-_token_scan
	.short L397-_token_scan
	.short L349-_token_scan
	.short L349-_token_scan

_token_scan:
L335:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L336:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %r15,%r13
	movb (%r15),%al
	cmpb $0,%al
	jle L339
L341:
	movsbq %al,%rcx
	cmpq $128,%rcx
	jae L339
L338:
	movl _classes(,%rcx,4),%r12d
	jmp L340
L339:
	xorl %r12d,%r12d
L340:
	cmpl $51,%r12d
	jl L484
L486:
	cmpl $56,%r12d
	jg L484
L483:
	leal -51(%r12),%eax
	movzwl L493(,%rax,2),%eax
	addl $_token_scan,%eax
	jmp *%rax
L426:
	movb (%r13),%cl
	movsbq %cl,%rax
	testb $7,___ctype+1(%rax)
	jnz L427
L429:
	cmpb $95,%cl
	jnz L346
L427:
	incq %r13
	jmp L426
L421:
	movsbq (%r13),%rax
	testb $8,___ctype+1(%rax)
	jz L346
L422:
	incq %r13
	jmp L421
L349:
L496:
	movl $1,%ebx
L350:
	cmpb $0,(%r13)
	jnz L356
L354:
	cmpl $55,%r12d
	jnz L358
L357:
	pushq $L360
	jmp L494
L358:
	pushq $L361
L494:
	call _error
	addq $8,%rsp
L356:
	movb (%r13),%al
	incq %r13
	cmpb (%r15),%al
	jnz L364
L365:
	testl %ebx,%ebx
	jz L346
L364:
	testl %ebx,%ebx
	jnz L372
L370:
	cmpb $92,%al
	jz L496
L372:
	xorl %ebx,%ebx
	jmp L350
L484:
	testl %r12d,%r12d
	jz L480
L488:
	cmpl $536870952,%r12d
	jz L375
L489:
	cmpl $536870956,%r12d
	jz L434
L490:
	cmpl $536871425,%r12d
	jnz L345
L444:
	cmpb $0,_cxx_mode(%rip)
	jz L446
L452:
	cmpb $62,1(%r15)
	jnz L446
L448:
	cmpb $42,2(%r15)
	jnz L446
L445:
	movl $536870962,%r12d
	leaq 3(%r15),%r13
	jmp L346
L446:
	cmpb $62,1(%r15)
	jz L457
L345:
	leaq 1(%r15),%r13
L461:
	movzbl %r12b,%eax
	cmpl $15,%eax
	jge L346
L462:
	movb (%r13),%dl
	cmpb (%r15),%dl
	jnz L465
L467:
	movslq %eax,%rcx
	movl _modifiers(,%rcx,8),%ecx
	testl %ecx,%ecx
	jz L465
L464:
	movl %ecx,%r12d
	jmp L497
L465:
	cmpb $61,%dl
	jnz L346
L474:
	movslq %eax,%rax
	movl _modifiers+4(,%rax,8),%eax
	testl %eax,%eax
	jz L346
L471:
	movl %eax,%r12d
L497:
	incq %r13
	jmp L461
L457:
	movl $536870951,%r12d
	jmp L495
L434:
	cmpb $0,_cxx_mode(%rip)
	jz L436
L438:
	cmpb $58,1(%r15)
	jnz L436
L435:
	movl $536870960,%r12d
L495:
	leaq 2(%r15),%r13
	jmp L346
L436:
	leaq 1(%r15),%r13
	jmp L346
L375:
	leaq 1(%r15),%rdx
	movb 1(%r15),%cl
	cmpb $46,%cl
	jnz L377
L379:
	cmpb $46,2(%r15)
	jnz L377
L376:
	leaq 3(%r15),%r13
	movl $536870953,%r12d
	jmp L346
L377:
	cmpb $0,_cxx_mode(%rip)
	jz L385
L387:
	cmpb $42,%cl
	jnz L385
L384:
	leaq 2(%r15),%r13
	movl $536870961,%r12d
	jmp L346
L385:
	movsbl %al,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L392
L397:
	movb (%r13),%dil
	movsbq %dil,%rax
	testb $7,___ctype+1(%rax)
	jnz L398
L404:
	cmpb $46,%dil
	jz L398
L400:
	cmpb $95,%dil
	jnz L346
L398:
	movsbl %dil,%edi
	call _toupper
	cmpl $69,%eax
	jnz L410
L411:
	leaq 1(%r13),%rcx
	movb 1(%r13),%al
	cmpb $45,%al
	jz L408
L415:
	cmpb $43,%al
	jnz L410
L408:
	movq %rcx,%r13
L410:
	incq %r13
	jmp L397
L392:
	movq %rdx,%r13
	jmp L346
L480:
	movzbl %al,%eax
	pushq %rax
	pushq $L481
	call _error
	addq $16,%rsp
L346:
	movl %r12d,%edi
	call _alloc
	movq %rax,%rbx
	movq %r13,%rdx
	subq %r15,%rdx
	movq %r15,%rsi
	leaq 8(%rbx),%rdi
	call _vstring_put
	movq %r13,(%r14)
	movq %rbx,%rax
L337:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_token_paste:
L498:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
L499:
	movq %rsi,%rbx
	xorl %eax,%eax
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl -24(%rbp),%eax
	andl $-2,%eax
	orl $1,%eax
	movl %eax,-24(%rbp)
	leaq -24(%rbp),%rsi
	call _token_text
	leaq -24(%rbp),%rsi
	movq %rbx,%rdi
	call _token_text
	testl $1,-24(%rbp)
	jz L502
L501:
	leaq -23(%rbp),%rdi
	jmp L503
L502:
	movq -8(%rbp),%rdi
L503:
	leaq -32(%rbp),%rsi
	call _token_scan
	movq %rax,%rbx
	movq -32(%rbp),%rax
	cmpb $0,(%rax)
	jnz L508
L507:
	testl $1073741824,(%rbx)
	jz L506
L508:
	testl $1,-24(%rbp)
	jz L513
L512:
	addq $-23,%rbp
	jmp L514
L513:
	movq -8(%rbp),%rbp
L514:
	pushq %rbp
	pushq $L511
	call _error
	addq $16,%rsp
L506:
	movq %rbx,%rax
L500:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_token_same:
L516:
L517:
	movl (%rdi),%eax
	cmpl (%rsi),%eax
	jz L519
L521:
	xorl %eax,%eax
	ret
L519:
	testl $536870912,%eax
	jnz L522
L524:
	testl $2147483648,%eax
	jnz L526
L528:
	addq $8,%rsi
	addq $8,%rdi
	call _vstring_same
	ret
L526:
	movq 8(%rdi),%rax
	cmpq 8(%rsi),%rax
	setz %al
	movzbl %al,%eax
	ret
L522:
	movl $1,%eax
L518:
	ret 


_token_copy:
L532:
	pushq %rbx
	pushq %r12
L533:
	movq %rdi,%r12
	movl (%r12),%edi
	call _alloc
	movq %rax,%rbx
	testl $2147483648,(%rbx)
	jz L536
L535:
	movq 8(%r12),%rax
	movq %rax,8(%rbx)
	jmp L537
L536:
	leaq 8(%r12),%rsi
	leaq 8(%rbx),%rdi
	call _vstring_concat
L537:
	movq %rbx,%rax
L534:
	popq %r12
	popq %rbx
	ret 


_token_text:
L539:
	pushq %rbx
	pushq %r12
L540:
	movq %rdi,%r12
	movq %rsi,%rbx
	testl $2147483648,(%r12)
	jz L544
L542:
	pushq $L545
	call _error
	addq $8,%rsp
L544:
	movl 8(%r12),%edx
	movl %edx,%eax
	andl $1,%eax
	jz L547
L546:
	leaq 9(%r12),%rsi
	jmp L548
L547:
	movq 24(%r12),%rsi
L548:
	testl %eax,%eax
	jz L550
L549:
	shll $24,%edx
	sarl $25,%edx
	movslq %edx,%rdx
	jmp L551
L550:
	movq 16(%r12),%rdx
L551:
	movq %rbx,%rdi
	call _vstring_put
L541:
	popq %r12
	popq %rbx
	ret 


_token_dequote:
L552:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L553:
	movq %rdi,%r14
	movq %rsi,%r13
	cmpl $55,(%r14)
	jz L557
L555:
	pushq $L558
	call _error
	addq $8,%rsp
L557:
	movl 8(%r14),%r12d
	movl %r12d,%eax
	andl $1,%eax
	jz L560
L559:
	shll $24,%r12d
	sarl $25,%r12d
	movslq %r12d,%r12
	jmp L561
L560:
	movq 16(%r14),%r12
L561:
	testl %eax,%eax
	jz L563
L562:
	addq $9,%r14
	jmp L564
L563:
	movq 24(%r14),%r14
L564:
	movl $1,%ebx
L565:
	movq %r12,%rax
	decq %rax
	cmpq %rax,%rbx
	jae L554
L566:
	leaq 1(%r14),%rax
	movb 1(%r14),%sil
	movq %rax,%r14
	movq %r13,%rdi
	call _vstring_putc
	incq %rbx
	jmp L565
L554:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_cut:
L569:
	pushq %rbx
	pushq %r12
L570:
	movq %rdi,%r12
	movq %rsi,%rbx
L572:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L571
L573:
	cmpq %rdi,%rbx
	jz L571
L579:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L583
L582:
	movq %rax,40(%rcx)
	jmp L584
L583:
	movq %rax,8(%r12)
L584:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L572
L571:
	popq %r12
	popq %rbx
	ret 


_list_skip_spaces:
L585:
L586:
	movq %rdi,%rax
L588:
	testq %rax,%rax
	jz L587
L591:
	cmpl $51,(%rax)
	jnz L587
L589:
	movq 32(%rax),%rax
	jmp L588
L587:
	ret 


_list_fold_spaces:
L596:
	pushq %rbx
	pushq %r12
L597:
	movq %rdi,%r12
	movq (%r12),%rbx
L599:
	testq %rbx,%rbx
	jz L598
L600:
	cmpl $51,(%rbx)
	jnz L605
L603:
	leaq 8(%rbx),%rdi
	call _vstring_free
	leaq 8(%rbx),%rdi
	call _vstring_init
	movb $32,%sil
	leaq 8(%rbx),%rdi
	call _vstring_putc
L606:
	movq 32(%rbx),%rdi
	testq %rdi,%rdi
	jz L605
L609:
	cmpl $51,(%rdi)
	jnz L605
L610:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L617
L616:
	movq %rax,40(%rcx)
	jmp L618
L617:
	movq %rax,8(%r12)
L618:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L606
L605:
	movq 32(%rbx),%rbx
	jmp L599
L598:
	popq %r12
	popq %rbx
	ret 


_list_strip_ends:
L619:
	pushq %rbx
L620:
	movq %rdi,%rbx
L622:
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L631
L629:
	cmpl $51,(%rdi)
	jz L626
L631:
	movq 8(%rbx),%rax
	movq 8(%rax),%rax
	movq (%rax),%rdi
	testq %rdi,%rdi
	jz L621
L633:
	cmpl $51,(%rdi)
	jnz L621
L626:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L641
L640:
	movq %rax,40(%rcx)
	jmp L642
L641:
	movq %rax,8(%rbx)
L642:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L622
L621:
	popq %rbx
	ret 


_list_strip_all:
L643:
	pushq %rbx
	pushq %r12
L644:
	movq %rdi,%r12
	movq (%r12),%rdi
L646:
	testq %rdi,%rdi
	jz L645
L647:
	movq 32(%rdi),%rbx
	movl (%rdi),%eax
	cmpl $51,%eax
	jz L653
L652:
	cmpl $1073741886,%eax
	jnz L651
L656:
	movl 8(%rdi),%eax
	testl $1,%eax
	jz L661
L660:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L662
L661:
	movq 16(%rdi),%rax
L662:
	testq %rax,%rax
	jnz L651
L653:
	movq 40(%rdi),%rax
	testq %rbx,%rbx
	jz L667
L666:
	movq %rax,40(%rbx)
	jmp L668
L667:
	movq %rax,8(%r12)
L668:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
L651:
	movq %rbx,%rdi
	jmp L646
L645:
	popq %r12
	popq %rbx
	ret 


_list_strip_around:
L669:
	pushq %rbx
	pushq %r12
L670:
	movq %rdi,%r12
	movq %rsi,%rbx
L672:
	movq 40(%rbx),%rax
	movq 8(%rax),%rax
	movq (%rax),%rsi
	testq %rsi,%rsi
	jz L679
L675:
	cmpl $51,(%rsi)
	jnz L679
L673:
	movq %r12,%rdi
	call _list_drop
	jmp L672
L679:
	movq 32(%rbx),%rsi
	testq %rsi,%rsi
	jz L671
L682:
	cmpl $51,(%rsi)
	jnz L671
L680:
	movq %r12,%rdi
	call _list_drop
	jmp L679
L671:
	popq %r12
	popq %rbx
	ret 


_list_pop:
L686:
L687:
	movq %rdi,%rdx
	movq (%rdx),%rdi
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L693
L692:
	movq %rax,40(%rcx)
	jmp L694
L693:
	movq %rax,8(%rdx)
L694:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	testq %rsi,%rsi
	jz L696
L695:
	movq %rdi,(%rsi)
	ret
L696:
	call _token_free
L688:
	ret 


_list_drop:
L698:
	pushq %rbx
L699:
	movq %rdi,%rcx
	movq %rsi,%rdi
	movq 32(%rdi),%rbx
	movq 40(%rdi),%rax
	testq %rbx,%rbx
	jz L705
L704:
	movq %rax,40(%rbx)
	jmp L706
L705:
	movq %rax,8(%rcx)
L706:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	movq %rbx,%rax
L700:
	popq %rbx
	ret 


_list_match:
L708:
L709:
	movl %esi,%ecx
	movq %rdx,%rsi
	movq (%rdi),%rax
	testq %rax,%rax
	jz L712
L714:
	cmpl (%rax),%ecx
	jnz L712
L711:
	call _list_pop
	ret
L712:
	pushq $L718
	call _error
	addq $8,%rsp
L710:
	ret 


_list_same:
L719:
	pushq %rbx
	pushq %r12
L720:
	movq (%rdi),%r12
	movq (%rsi),%rbx
L722:
	testq %r12,%r12
	jz L724
L729:
	testq %rbx,%rbx
	jz L724
L725:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _token_same
	testl %eax,%eax
	jz L724
L723:
	movq 32(%r12),%r12
	movq 32(%rbx),%rbx
	jmp L722
L724:
	testq %r12,%r12
	jnz L733
L736:
	testq %rbx,%rbx
	jz L734
L733:
	xorl %eax,%eax
	jmp L721
L734:
	movl $1,%eax
L721:
	popq %r12
	popq %rbx
	ret 


_list_normalize:
L742:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L743:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rdi
	call _list_strip_ends
	movq %rbx,%rdi
	call _list_fold_spaces
	movq (%rbx),%rax
L745:
	testq %rax,%rax
	jz L748
L746:
	cmpl $1610612748,(%rax)
	jnz L751
L749:
	movl $1610612793,(%rax)
L751:
	cmpl $1610612778,(%rax)
	jnz L754
L752:
	movl $1610612794,(%rax)
L754:
	movq 32(%rax),%rax
	jmp L745
L748:
	movq (%r12),%r14
	xorl %r13d,%r13d
L755:
	testq %r14,%r14
	jz L744
L756:
	movq (%rbx),%r12
L759:
	testq %r12,%r12
	jz L762
L760:
	movq %r12,%rsi
	movq %r14,%rdi
	call _token_same
	testl %eax,%eax
	jz L765
L763:
	leaq 8(%r12),%rdi
	call _vstring_free
	movl $-2147483587,(%r12)
	movslq %r13d,%rax
	movq %rax,8(%r12)
L765:
	movq 32(%r12),%r12
	jmp L759
L762:
	movq 32(%r14),%r14
	incl %r13d
	jmp L755
L744:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_stringize:
L766:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L767:
	movq %rdi,%r14
	movl $55,%edi
	call _alloc
	movq %rax,%r13
	movb $34,%sil
	leaq 8(%r13),%rdi
	call _vstring_putc
	movq (%r14),%r12
L769:
	testq %r12,%r12
	jz L772
L770:
	testl $2147483648,(%r12)
	jz L775
L773:
	pushq $L776
	call _error
	addq $8,%rsp
L775:
	cmpl $51,(%r12)
	jnz L779
L780:
	cmpq (%r14),%r12
	jz L771
L784:
	cmpq $0,32(%r12)
	jz L771
L779:
	testl $1,8(%r12)
	jz L790
L789:
	leaq 9(%r12),%rbx
	jmp L792
L790:
	movq 24(%r12),%rbx
L792:
	movb (%rbx),%sil
	testb %sil,%sil
	jz L771
L793:
	movl (%r12),%eax
	cmpl $55,%eax
	jz L795
L798:
	cmpl $56,%eax
	jnz L796
L795:
	movsbl %sil,%esi
	incq %rbx
	leaq 8(%r13),%rdi
	call _backslash
	jmp L792
L796:
	incq %rbx
	leaq 8(%r13),%rdi
	call _vstring_putc
	jmp L792
L771:
	movq 32(%r12),%r12
	jmp L769
L772:
	movb $34,%sil
	leaq 8(%r13),%rdi
	call _vstring_putc
	movq %r13,%rax
L768:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_ennervate:
L803:
	pushq %rbx
	pushq %r12
L804:
	movq %rsi,%r12
	movq (%rdi),%rbx
L806:
	testq %rbx,%rbx
	jz L805
L807:
	cmpl $52,(%rbx)
	jnz L812
L813:
	movq %r12,%rsi
	leaq 8(%rbx),%rdi
	call _vstring_same
	testl %eax,%eax
	jz L812
L810:
	movl $1073741886,(%rbx)
L812:
	movq 32(%rbx),%rbx
	jmp L806
L805:
	popq %r12
	popq %rbx
	ret 


_list_copy:
L817:
	pushq %rbx
	pushq %r12
L818:
	movq %rdi,%r12
	movq (%rsi),%rbx
L820:
	testq %rbx,%rbx
	jz L819
L821:
	movq %rbx,%rdi
	call _token_copy
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 8(%r12),%rcx
	movq %rcx,40(%rax)
	movq 8(%r12),%rcx
	movq %rax,(%rcx)
	movq %rdx,8(%r12)
	movq 32(%rbx),%rbx
	jmp L820
L819:
	popq %r12
	popq %rbx
	ret 


_list_move:
L827:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L828:
	movq %rdi,%r14
	movq %rsi,%r13
	movl %edx,%r12d
L830:
	movl %r12d,%eax
	decl %r12d
	testl %eax,%eax
	jz L829
L831:
	movq (%r13),%rbx
	testq %rbx,%rbx
	jnz L837
L833:
	pushq $L836
	call _error
	addq $8,%rsp
L837:
	leaq 32(%rbx),%rdx
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	testq %rcx,%rcx
	jz L841
L840:
	movq %rax,40(%rcx)
	jmp L842
L841:
	movq %rax,8(%r13)
L842:
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	movq %rcx,(%rax)
	movq $0,32(%rbx)
	movq 8(%r14),%rax
	movq %rax,40(%rbx)
	movq 8(%r14),%rax
	movq %rbx,(%rax)
	movq %rdx,8(%r14)
	jmp L830
L829:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_next_is:
L846:
L847:
	movq 32(%rsi),%rax
L849:
	testq %rax,%rax
	jz L851
L852:
	cmpl $51,(%rax)
	jnz L851
L850:
	movq 32(%rax),%rax
	jmp L849
L851:
	testq %rax,%rax
	jz L857
L859:
	cmpl (%rax),%edx
	jnz L857
L856:
	movl $1,%eax
	ret
L857:
	xorl %eax,%eax
L848:
	ret 


_list_prev_is:
L865:
L866:
	movq 40(%rsi),%rax
L884:
	movq 8(%rax),%rax
	movq (%rax),%rax
	testq %rax,%rax
	jz L870
L871:
	cmpl $51,(%rax)
	jnz L870
L869:
	movq 40(%rax),%rax
	jmp L884
L870:
	testq %rax,%rax
	jz L876
L878:
	cmpl (%rax),%edx
	jnz L876
L875:
	movl $1,%eax
	ret
L876:
	xorl %eax,%eax
L867:
	ret 


_list_insert:
L885:
L886:
	leaq 32(%rdx),%rax
	testq %rsi,%rsi
	jz L894
L891:
	movq 40(%rsi),%rcx
	movq %rcx,40(%rdx)
	movq %rsi,32(%rdx)
	movq 40(%rsi),%rcx
	movq %rdx,(%rcx)
	movq %rax,40(%rsi)
	ret
L894:
	movq $0,32(%rdx)
	movq 8(%rdi),%rcx
	movq %rcx,40(%rdx)
	movq 8(%rdi),%rcx
	movq %rdx,(%rcx)
	movq %rax,8(%rdi)
L887:
	ret 


_list_insert_list:
L897:
	pushq %rbx
	pushq %r12
	pushq %r13
L898:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
L900:
	movq (%rbx),%rdx
	testq %rdx,%rdx
	jz L899
L903:
	movq 32(%rdx),%rcx
	movq 40(%rdx),%rax
	testq %rcx,%rcx
	jz L907
L906:
	movq %rax,40(%rcx)
	jmp L908
L907:
	movq %rax,8(%rbx)
L908:
	movq 32(%rdx),%rcx
	movq 40(%rdx),%rax
	movq %rcx,(%rax)
	movq %r12,%rsi
	movq %r13,%rdi
	call _list_insert
	jmp L900
L899:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_placeholder:
L909:
	pushq %rbx
L910:
	movq %rdi,%rbx
	cmpq $0,(%rbx)
	jnz L911
L912:
	movl $1073741886,%edi
	call _alloc
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 8(%rbx),%rcx
	movq %rcx,40(%rax)
	movq 8(%rbx),%rcx
	movq %rax,(%rcx)
	movq %rdx,8(%rbx)
L911:
	popq %rbx
	ret 

L361:
 .byte 117,110,116,101,114,109,105,110
 .byte 97,116,101,100,32,99,104,97
 .byte 114,32,99,111,110,115,116,97
 .byte 110,116,0
L107:
 .byte 37,100,0
L558:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,99,97
 .byte 110,39,116,32,100,101,113,117
 .byte 111,116,101,32,110,111,110,45
 .byte 115,116,114,105,110,103,32,116
 .byte 111,107,101,110,0
L718:
 .byte 115,121,110,116,97,120,0
L360:
 .byte 117,110,116,101,114,109,105,110
 .byte 97,116,101,100,32,115,116,114
 .byte 105,110,103,32,108,105,116,101
 .byte 114,97,108,0
L545:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,99,97
 .byte 110,39,116,32,103,101,116,32
 .byte 116,101,120,116,32,111,102,32
 .byte 110,111,110,45,116,101,120,116
 .byte 32,116,111,107,101,110,0
L162:
 .byte 105,110,118,97,108,105,100,32
 .byte 101,115,99,97,112,101,32,115
 .byte 101,113,117,101,110,99,101,0
L166:
 .byte 109,117,108,116,105,45,99,104
 .byte 97,114,97,99,116,101,114,32
 .byte 99,111,110,115,116,97,110,116
 .byte 115,32,117,110,115,117,112,112
 .byte 111,114,116,101,100,0
L836:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,108,105
 .byte 115,116,95,109,111,118,101,0
L776:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,99,97
 .byte 110,39,116,32,115,116,114,105
 .byte 110,103,105,122,101,32,97,32
 .byte 116,101,120,116,108,101,115,115
 .byte 32,116,111,107,101,110,0
L481:
 .byte 105,110,118,97,108,105,100,32
 .byte 99,104,97,114,97,99,116,101
 .byte 114,32,40,65,83,67,73,73
 .byte 32,37,100,41,32,105,110,32
 .byte 105,110,112,117,116,0
L152:
 .byte 109,97,108,102,111,114,109,101
 .byte 100,32,105,110,116,101,103,101
 .byte 114,32,99,111,110,115,116,97
 .byte 110,116,0
L511:
 .byte 114,101,115,117,108,116,32,111
 .byte 102,32,112,97,115,116,101,32
 .byte 40,35,35,41,32,39,37,115
 .byte 39,32,105,115,32,110,111,116
 .byte 32,97,32,116,111,107,101,110
 .byte 0

.globl _list_strip_around
.globl _errno
.globl _token_number
.globl _sprintf
.globl _vstring_init
.globl _token_copy
.globl _vstring_same
.globl _token_same
.globl _token_convert_number
.globl _vstring_putc
.globl _list_ennervate
.globl _error
.globl _token_paste
.globl _list_insert
.globl _token_text
.globl _cxx_mode
.globl _list_stringize
.globl _list_strip_all
.globl _token_int
.globl _token_separate
.globl _token_scan
.globl _strtoul
.globl _list_pop
.globl _vstring_concat
.globl _list_fold_spaces
.globl _token_string
.globl _safe_malloc
.globl _list_next_is
.globl _token_dequote
.globl _list_normalize
.globl _list_prev_is
.globl _list_cut
.globl _vstring_puts
.globl ___ctype
.globl _list_same
.globl _list_copy
.globl _token_convert_char
.globl _token_free
.globl _vstring_free
.globl _list_move
.globl _vstring_put
.globl _strchr
.globl _list_insert_list
.globl _list_strip_ends
.globl _list_match
.globl _list_skip_spaces
.globl _toupper
.globl _list_placeholder
.globl _list_drop
.globl _token_space
