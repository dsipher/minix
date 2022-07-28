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
	movl $1,%ebx
L350:
	cmpb $0,(%r13)
	jnz L356
L354:
	cmpl $55,%r12d
	jnz L358
L357:
	pushq $L360
	call _error
	addq $8,%rsp
	jmp L356
L358:
	pushq $L361
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
	jnz L372
L371:
	movl $1,%ebx
	jmp L350
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
	incq %r13
	jmp L461
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
	incq %r13
	jmp L461
L457:
	movl $536870951,%r12d
	leaq 2(%r15),%r13
	jmp L346
L434:
	cmpb $0,_cxx_mode(%rip)
	jz L436
L438:
	cmpb $58,1(%r15)
	jnz L436
L435:
	movl $536870960,%r12d
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
L494:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
L495:
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
	jz L498
L497:
	leaq -23(%rbp),%rdi
	jmp L499
L498:
	movq -8(%rbp),%rdi
L499:
	leaq -32(%rbp),%rsi
	call _token_scan
	movq %rax,%rbx
	movq -32(%rbp),%rax
	cmpb $0,(%rax)
	jnz L504
L503:
	testl $1073741824,(%rbx)
	jz L502
L504:
	testl $1,-24(%rbp)
	jz L509
L508:
	addq $-23,%rbp
	jmp L510
L509:
	movq -8(%rbp),%rbp
L510:
	pushq %rbp
	pushq $L507
	call _error
	addq $16,%rsp
L502:
	movq %rbx,%rax
L496:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_token_same:
L512:
L513:
	movl (%rdi),%eax
	cmpl (%rsi),%eax
	jz L515
L517:
	xorl %eax,%eax
	ret
L515:
	testl $536870912,%eax
	jnz L518
L520:
	testl $2147483648,%eax
	jnz L522
L524:
	addq $8,%rsi
	addq $8,%rdi
	call _vstring_same
	ret
L522:
	movq 8(%rdi),%rax
	cmpq 8(%rsi),%rax
	setz %al
	movzbl %al,%eax
	ret
L518:
	movl $1,%eax
L514:
	ret 


_token_copy:
L528:
	pushq %rbx
	pushq %r12
L529:
	movq %rdi,%r12
	movl (%r12),%edi
	call _alloc
	movq %rax,%rbx
	testl $2147483648,(%rbx)
	jz L532
L531:
	movq 8(%r12),%rax
	movq %rax,8(%rbx)
	jmp L533
L532:
	leaq 8(%r12),%rsi
	leaq 8(%rbx),%rdi
	call _vstring_concat
L533:
	movq %rbx,%rax
L530:
	popq %r12
	popq %rbx
	ret 


_token_text:
L535:
	pushq %rbx
	pushq %r12
L536:
	movq %rdi,%r12
	movq %rsi,%rbx
	testl $2147483648,(%r12)
	jz L540
L538:
	pushq $L541
	call _error
	addq $8,%rsp
L540:
	movl 8(%r12),%edx
	movl %edx,%eax
	andl $1,%eax
	jz L543
L542:
	leaq 9(%r12),%rsi
	jmp L544
L543:
	movq 24(%r12),%rsi
L544:
	testl %eax,%eax
	jz L546
L545:
	shll $24,%edx
	sarl $25,%edx
	movslq %edx,%rdx
	jmp L547
L546:
	movq 16(%r12),%rdx
L547:
	movq %rbx,%rdi
	call _vstring_put
L537:
	popq %r12
	popq %rbx
	ret 


_token_dequote:
L548:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L549:
	movq %rdi,%r14
	movq %rsi,%r13
	cmpl $55,(%r14)
	jz L553
L551:
	pushq $L554
	call _error
	addq $8,%rsp
L553:
	movl 8(%r14),%r12d
	movl %r12d,%eax
	andl $1,%eax
	jz L556
L555:
	shll $24,%r12d
	sarl $25,%r12d
	movslq %r12d,%r12
	jmp L557
L556:
	movq 16(%r14),%r12
L557:
	testl %eax,%eax
	jz L559
L558:
	addq $9,%r14
	jmp L560
L559:
	movq 24(%r14),%r14
L560:
	movl $1,%ebx
L561:
	movq %r12,%rax
	decq %rax
	cmpq %rax,%rbx
	jae L550
L562:
	leaq 1(%r14),%rax
	movb 1(%r14),%sil
	movq %rax,%r14
	movq %r13,%rdi
	call _vstring_putc
	incq %rbx
	jmp L561
L550:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_cut:
L565:
	pushq %rbx
	pushq %r12
L566:
	movq %rdi,%r12
	movq %rsi,%rbx
L568:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L567
L569:
	cmpq %rdi,%rbx
	jz L567
L575:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L579
L578:
	movq %rax,40(%rcx)
	jmp L580
L579:
	movq %rax,8(%r12)
L580:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L568
L567:
	popq %r12
	popq %rbx
	ret 


_list_skip_spaces:
L581:
L582:
	movq %rdi,%rax
L584:
	testq %rax,%rax
	jz L583
L587:
	cmpl $51,(%rax)
	jnz L583
L585:
	movq 32(%rax),%rax
	jmp L584
L583:
	ret 


_list_fold_spaces:
L592:
	pushq %rbx
	pushq %r12
L593:
	movq %rdi,%r12
	movq (%r12),%rbx
L595:
	testq %rbx,%rbx
	jz L594
L596:
	cmpl $51,(%rbx)
	jnz L601
L599:
	leaq 8(%rbx),%rdi
	call _vstring_free
	leaq 8(%rbx),%rdi
	call _vstring_init
	movb $32,%sil
	leaq 8(%rbx),%rdi
	call _vstring_putc
L602:
	movq 32(%rbx),%rdi
	testq %rdi,%rdi
	jz L601
L605:
	cmpl $51,(%rdi)
	jnz L601
L606:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L613
L612:
	movq %rax,40(%rcx)
	jmp L614
L613:
	movq %rax,8(%r12)
L614:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L602
L601:
	movq 32(%rbx),%rbx
	jmp L595
L594:
	popq %r12
	popq %rbx
	ret 


_list_strip_ends:
L615:
	pushq %rbx
L616:
	movq %rdi,%rbx
L618:
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L627
L625:
	cmpl $51,(%rdi)
	jz L622
L627:
	movq 8(%rbx),%rax
	movq 8(%rax),%rax
	movq (%rax),%rdi
	testq %rdi,%rdi
	jz L617
L629:
	cmpl $51,(%rdi)
	jnz L617
L622:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L637
L636:
	movq %rax,40(%rcx)
	jmp L638
L637:
	movq %rax,8(%rbx)
L638:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L618
L617:
	popq %rbx
	ret 


_list_strip_all:
L639:
	pushq %rbx
	pushq %r12
L640:
	movq %rdi,%r12
	movq (%r12),%rdi
L642:
	testq %rdi,%rdi
	jz L641
L643:
	movq 32(%rdi),%rbx
	movl (%rdi),%eax
	cmpl $51,%eax
	jz L649
L648:
	cmpl $1073741886,%eax
	jnz L647
L652:
	movl 8(%rdi),%eax
	testl $1,%eax
	jz L657
L656:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L658
L657:
	movq 16(%rdi),%rax
L658:
	testq %rax,%rax
	jnz L647
L649:
	movq 40(%rdi),%rax
	testq %rbx,%rbx
	jz L663
L662:
	movq %rax,40(%rbx)
	jmp L664
L663:
	movq %rax,8(%r12)
L664:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
L647:
	movq %rbx,%rdi
	jmp L642
L641:
	popq %r12
	popq %rbx
	ret 


_list_strip_around:
L665:
	pushq %rbx
	pushq %r12
L666:
	movq %rdi,%r12
	movq %rsi,%rbx
L668:
	movq 40(%rbx),%rax
	movq 8(%rax),%rax
	movq (%rax),%rsi
	testq %rsi,%rsi
	jz L675
L671:
	cmpl $51,(%rsi)
	jnz L675
L669:
	movq %r12,%rdi
	call _list_drop
	jmp L668
L675:
	movq 32(%rbx),%rsi
	testq %rsi,%rsi
	jz L667
L678:
	cmpl $51,(%rsi)
	jnz L667
L676:
	movq %r12,%rdi
	call _list_drop
	jmp L675
L667:
	popq %r12
	popq %rbx
	ret 


_list_pop:
L682:
L683:
	movq %rdi,%rdx
	movq (%rdx),%rdi
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L689
L688:
	movq %rax,40(%rcx)
	jmp L690
L689:
	movq %rax,8(%rdx)
L690:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	testq %rsi,%rsi
	jz L692
L691:
	movq %rdi,(%rsi)
	ret
L692:
	call _token_free
L684:
	ret 


_list_drop:
L694:
	pushq %rbx
L695:
	movq %rdi,%rcx
	movq %rsi,%rdi
	movq 32(%rdi),%rbx
	movq 40(%rdi),%rax
	testq %rbx,%rbx
	jz L701
L700:
	movq %rax,40(%rbx)
	jmp L702
L701:
	movq %rax,8(%rcx)
L702:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	movq %rbx,%rax
L696:
	popq %rbx
	ret 


_list_match:
L704:
L705:
	movl %esi,%ecx
	movq %rdx,%rsi
	movq (%rdi),%rax
	testq %rax,%rax
	jz L708
L710:
	cmpl (%rax),%ecx
	jnz L708
L707:
	call _list_pop
	ret
L708:
	pushq $L714
	call _error
	addq $8,%rsp
L706:
	ret 


_list_same:
L715:
	pushq %rbx
	pushq %r12
L716:
	movq (%rdi),%r12
	movq (%rsi),%rbx
L718:
	testq %r12,%r12
	jz L720
L725:
	testq %rbx,%rbx
	jz L720
L721:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _token_same
	testl %eax,%eax
	jz L720
L719:
	movq 32(%r12),%r12
	movq 32(%rbx),%rbx
	jmp L718
L720:
	testq %r12,%r12
	jnz L729
L732:
	testq %rbx,%rbx
	jz L730
L729:
	xorl %eax,%eax
	jmp L717
L730:
	movl $1,%eax
L717:
	popq %r12
	popq %rbx
	ret 


_list_normalize:
L738:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L739:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rdi
	call _list_strip_ends
	movq %rbx,%rdi
	call _list_fold_spaces
	movq (%rbx),%rax
L741:
	testq %rax,%rax
	jz L744
L742:
	cmpl $1610612748,(%rax)
	jnz L747
L745:
	movl $1610612793,(%rax)
L747:
	cmpl $1610612778,(%rax)
	jnz L750
L748:
	movl $1610612794,(%rax)
L750:
	movq 32(%rax),%rax
	jmp L741
L744:
	movq (%r12),%r14
	xorl %r13d,%r13d
L751:
	testq %r14,%r14
	jz L740
L752:
	movq (%rbx),%r12
L755:
	testq %r12,%r12
	jz L758
L756:
	movq %r12,%rsi
	movq %r14,%rdi
	call _token_same
	testl %eax,%eax
	jz L761
L759:
	leaq 8(%r12),%rdi
	call _vstring_free
	movl $-2147483587,(%r12)
	movslq %r13d,%rax
	movq %rax,8(%r12)
L761:
	movq 32(%r12),%r12
	jmp L755
L758:
	movq 32(%r14),%r14
	incl %r13d
	jmp L751
L740:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_stringize:
L762:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L763:
	movq %rdi,%r14
	movl $55,%edi
	call _alloc
	movq %rax,%r13
	movb $34,%sil
	leaq 8(%r13),%rdi
	call _vstring_putc
	movq (%r14),%r12
L765:
	testq %r12,%r12
	jz L768
L766:
	testl $2147483648,(%r12)
	jz L771
L769:
	pushq $L772
	call _error
	addq $8,%rsp
L771:
	cmpl $51,(%r12)
	jnz L775
L776:
	cmpq (%r14),%r12
	jz L767
L780:
	cmpq $0,32(%r12)
	jz L767
L775:
	testl $1,8(%r12)
	jz L786
L785:
	leaq 9(%r12),%rbx
	jmp L788
L786:
	movq 24(%r12),%rbx
L788:
	movb (%rbx),%sil
	testb %sil,%sil
	jz L767
L789:
	movl (%r12),%eax
	cmpl $55,%eax
	jz L791
L794:
	cmpl $56,%eax
	jnz L792
L791:
	movsbl %sil,%esi
	incq %rbx
	leaq 8(%r13),%rdi
	call _backslash
	jmp L788
L792:
	incq %rbx
	leaq 8(%r13),%rdi
	call _vstring_putc
	jmp L788
L767:
	movq 32(%r12),%r12
	jmp L765
L768:
	movb $34,%sil
	leaq 8(%r13),%rdi
	call _vstring_putc
	movq %r13,%rax
L764:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_ennervate:
L799:
	pushq %rbx
	pushq %r12
L800:
	movq %rsi,%r12
	movq (%rdi),%rbx
L802:
	testq %rbx,%rbx
	jz L801
L803:
	cmpl $52,(%rbx)
	jnz L808
L809:
	movq %r12,%rsi
	leaq 8(%rbx),%rdi
	call _vstring_same
	testl %eax,%eax
	jz L808
L806:
	movl $1073741886,(%rbx)
L808:
	movq 32(%rbx),%rbx
	jmp L802
L801:
	popq %r12
	popq %rbx
	ret 


_list_copy:
L813:
	pushq %rbx
	pushq %r12
L814:
	movq %rdi,%r12
	movq (%rsi),%rbx
L816:
	testq %rbx,%rbx
	jz L815
L817:
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
	jmp L816
L815:
	popq %r12
	popq %rbx
	ret 


_list_move:
L823:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L824:
	movq %rdi,%r14
	movq %rsi,%r13
	movl %edx,%r12d
L826:
	movl %r12d,%eax
	decl %r12d
	testl %eax,%eax
	jz L825
L827:
	movq (%r13),%rbx
	testq %rbx,%rbx
	jnz L833
L829:
	pushq $L832
	call _error
	addq $8,%rsp
L833:
	leaq 32(%rbx),%rdx
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	testq %rcx,%rcx
	jz L837
L836:
	movq %rax,40(%rcx)
	jmp L838
L837:
	movq %rax,8(%r13)
L838:
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	movq %rcx,(%rax)
	movq $0,32(%rbx)
	movq 8(%r14),%rax
	movq %rax,40(%rbx)
	movq 8(%r14),%rax
	movq %rbx,(%rax)
	movq %rdx,8(%r14)
	jmp L826
L825:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_next_is:
L842:
L843:
	movq 32(%rsi),%rax
L845:
	testq %rax,%rax
	jz L847
L848:
	cmpl $51,(%rax)
	jnz L847
L846:
	movq 32(%rax),%rax
	jmp L845
L847:
	testq %rax,%rax
	jz L853
L855:
	cmpl (%rax),%edx
	jnz L853
L852:
	movl $1,%eax
	ret
L853:
	xorl %eax,%eax
L844:
	ret 


_list_prev_is:
L861:
L862:
	movq 40(%rsi),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
L864:
	testq %rax,%rax
	jz L866
L867:
	cmpl $51,(%rax)
	jnz L866
L865:
	movq 40(%rax),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	jmp L864
L866:
	testq %rax,%rax
	jz L872
L874:
	cmpl (%rax),%edx
	jnz L872
L871:
	movl $1,%eax
	ret
L872:
	xorl %eax,%eax
L863:
	ret 


_list_insert:
L880:
L881:
	leaq 32(%rdx),%rax
	testq %rsi,%rsi
	jz L889
L886:
	movq 40(%rsi),%rcx
	movq %rcx,40(%rdx)
	movq %rsi,32(%rdx)
	movq 40(%rsi),%rcx
	movq %rdx,(%rcx)
	movq %rax,40(%rsi)
	ret
L889:
	movq $0,32(%rdx)
	movq 8(%rdi),%rcx
	movq %rcx,40(%rdx)
	movq 8(%rdi),%rcx
	movq %rdx,(%rcx)
	movq %rax,8(%rdi)
L882:
	ret 


_list_insert_list:
L892:
	pushq %rbx
	pushq %r12
	pushq %r13
L893:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
L895:
	movq (%rbx),%rdx
	testq %rdx,%rdx
	jz L894
L898:
	movq 32(%rdx),%rcx
	movq 40(%rdx),%rax
	testq %rcx,%rcx
	jz L902
L901:
	movq %rax,40(%rcx)
	jmp L903
L902:
	movq %rax,8(%rbx)
L903:
	movq 32(%rdx),%rcx
	movq 40(%rdx),%rax
	movq %rcx,(%rax)
	movq %r12,%rsi
	movq %r13,%rdi
	call _list_insert
	jmp L895
L894:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_placeholder:
L904:
	pushq %rbx
L905:
	movq %rdi,%rbx
	cmpq $0,(%rbx)
	jnz L906
L907:
	movl $1073741886,%edi
	call _alloc
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 8(%rbx),%rcx
	movq %rcx,40(%rax)
	movq 8(%rbx),%rcx
	movq %rax,(%rcx)
	movq %rdx,8(%rbx)
L906:
	popq %rbx
	ret 

L361:
 .byte 117,110,116,101,114,109,105,110
 .byte 97,116,101,100,32,99,104,97
 .byte 114,32,99,111,110,115,116,97
 .byte 110,116,0
L107:
 .byte 37,100,0
L554:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,99,97
 .byte 110,39,116,32,100,101,113,117
 .byte 111,116,101,32,110,111,110,45
 .byte 115,116,114,105,110,103,32,116
 .byte 111,107,101,110,0
L714:
 .byte 115,121,110,116,97,120,0
L360:
 .byte 117,110,116,101,114,109,105,110
 .byte 97,116,101,100,32,115,116,114
 .byte 105,110,103,32,108,105,116,101
 .byte 114,97,108,0
L541:
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
L832:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,108,105
 .byte 115,116,95,109,111,118,101,0
L772:
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
L507:
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
