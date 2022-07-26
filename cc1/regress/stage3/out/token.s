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
	movzbl (%r12),%r14d
	leaq 1(%r12),%rbx
	cmpb $92,%r14b
	jnz L5
L4:
	movzbl 1(%r12),%ecx
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
	movzbl 2(%r12),%ecx
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
	movzbl 3(%r12),%ecx
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
	movzbl (%rbx),%edi
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
	movl $92,%esi
	movq %r12,%rdi
	call _vstring_putc
L114:
	movl %ebx,%esi
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
	movl $34,%esi
	leaq 8(%rbx),%rdi
	call _vstring_putc
L122:
	movzbl (%r12),%esi
	testb %sil,%sil
	jz L124
L123:
	movsbl %sil,%esi
	incq %r12
	leaq 8(%rbx),%rdi
	call _backslash
	jmp L122
L124:
	movl $34,%esi
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
	movl $32,%esi
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
	movzbl (%r15),%eax
	cmpb $0,%al
	jle L339
L341:
	movsbq %al,%rcx
	cmpq $128,%rcx
	jae L339
L338:
	movl _classes(,%rcx,4),%ebx
	jmp L340
L339:
	xorl %ebx,%ebx
L340:
	cmpl $51,%ebx
	jl L484
L486:
	cmpl $56,%ebx
	jg L484
L483:
	leal -51(%rbx),%eax
	movzwl L493(,%rax,2),%eax
	addl $_token_scan,%eax
	jmp *%rax
L426:
	movzbl (%r13),%ecx
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
	movl $1,%r12d
L350:
	cmpb $0,(%r13)
	jnz L356
L354:
	cmpl $55,%ebx
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
	movzbl (%r13),%eax
	incq %r13
	cmpb (%r15),%al
	jnz L364
L365:
	testl %r12d,%r12d
	jz L346
L364:
	testl %r12d,%r12d
	jnz L372
L370:
	cmpb $92,%al
	jnz L372
L371:
	movl $1,%r12d
	jmp L350
L372:
	xorl %r12d,%r12d
	jmp L350
L484:
	testl %ebx,%ebx
	jz L480
L488:
	cmpl $536870952,%ebx
	jz L375
L489:
	cmpl $536870956,%ebx
	jz L434
L490:
	cmpl $536871425,%ebx
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
	movl $536870962,%ebx
	leaq 3(%r15),%r13
	jmp L346
L446:
	cmpb $62,1(%r15)
	jz L457
L345:
	leaq 1(%r15),%r13
L461:
	movzbl %bl,%eax
	cmpl $15,%eax
	jge L346
L462:
	movzbl (%r13),%edx
	cmpb (%r15),%dl
	jnz L465
L467:
	movslq %eax,%rcx
	movl _modifiers(,%rcx,8),%ecx
	testl %ecx,%ecx
	jz L465
L464:
	movl %ecx,%ebx
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
	movl %eax,%ebx
	incq %r13
	jmp L461
L457:
	movl $536870951,%ebx
	leaq 2(%r15),%r13
	jmp L346
L434:
	cmpb $0,_cxx_mode(%rip)
	jz L436
L438:
	cmpb $58,1(%r15)
	jnz L436
L435:
	movl $536870960,%ebx
	leaq 2(%r15),%r13
	jmp L346
L436:
	leaq 1(%r15),%r13
	jmp L346
L375:
	leaq 1(%r15),%rdx
	movzbl 1(%r15),%ecx
	cmpb $46,%cl
	jnz L377
L379:
	cmpb $46,2(%r15)
	jnz L377
L376:
	leaq 3(%r15),%r13
	movl $536870953,%ebx
	jmp L346
L377:
	cmpb $0,_cxx_mode(%rip)
	jz L385
L387:
	cmpb $42,%cl
	jnz L385
L384:
	leaq 2(%r15),%r13
	movl $536870961,%ebx
	jmp L346
L385:
	movsbl %al,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L392
L397:
	movzbl (%r13),%edi
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
	movzbl 1(%r13),%eax
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
	movl %ebx,%edi
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
	movzbl 1(%r14),%esi
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
	testq %rax,%rax
	jnz L587
L583:
	ret 


_list_fold_spaces:
L593:
	pushq %rbx
	pushq %r12
L594:
	movq %rdi,%r12
	movq (%r12),%rbx
L596:
	testq %rbx,%rbx
	jz L595
L597:
	cmpl $51,(%rbx)
	jnz L602
L600:
	leaq 8(%rbx),%rdi
	call _vstring_free
	leaq 8(%rbx),%rdi
	call _vstring_init
	movl $32,%esi
	leaq 8(%rbx),%rdi
	call _vstring_putc
L603:
	movq 32(%rbx),%rdi
	testq %rdi,%rdi
	jz L602
L606:
	cmpl $51,(%rdi)
	jnz L602
L607:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L614
L613:
	movq %rax,40(%rcx)
	jmp L615
L614:
	movq %rax,8(%r12)
L615:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L603
L602:
	movq 32(%rbx),%rbx
	jmp L596
L595:
	popq %r12
	popq %rbx
	ret 


_list_strip_ends:
L616:
	pushq %rbx
L617:
	movq %rdi,%rbx
L619:
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L628
L626:
	cmpl $51,(%rdi)
	jz L623
L628:
	movq 8(%rbx),%rax
	movq 8(%rax),%rax
	movq (%rax),%rdi
	testq %rdi,%rdi
	jz L618
L630:
	cmpl $51,(%rdi)
	jnz L618
L623:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L638
L637:
	movq %rax,40(%rcx)
	jmp L639
L638:
	movq %rax,8(%rbx)
L639:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	jmp L619
L618:
	popq %rbx
	ret 


_list_strip_all:
L640:
	pushq %rbx
	pushq %r12
L641:
	movq %rdi,%r12
	movq (%r12),%rdi
L643:
	testq %rdi,%rdi
	jz L642
L644:
	movq 32(%rdi),%rbx
	movl (%rdi),%eax
	cmpl $51,%eax
	jz L650
L649:
	cmpl $1073741886,%eax
	jnz L648
L653:
	movl 8(%rdi),%eax
	testl $1,%eax
	jz L658
L657:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L659
L658:
	movq 16(%rdi),%rax
L659:
	testq %rax,%rax
	jnz L648
L650:
	movq 40(%rdi),%rax
	testq %rbx,%rbx
	jz L664
L663:
	movq %rax,40(%rbx)
	jmp L665
L664:
	movq %rax,8(%r12)
L665:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
L648:
	movq %rbx,%rdi
	jmp L643
L642:
	popq %r12
	popq %rbx
	ret 


_list_strip_around:
L666:
	pushq %rbx
	pushq %r12
L667:
	movq %rdi,%r12
	movq %rsi,%rbx
L669:
	movq 40(%rbx),%rax
	movq 8(%rax),%rax
	movq (%rax),%rsi
	testq %rsi,%rsi
	jz L676
L672:
	cmpl $51,(%rsi)
	jnz L676
L670:
	movq %r12,%rdi
	call _list_drop
	jmp L669
L676:
	movq 32(%rbx),%rsi
	testq %rsi,%rsi
	jz L668
L679:
	cmpl $51,(%rsi)
	jnz L668
L677:
	movq %r12,%rdi
	call _list_drop
	jmp L676
L668:
	popq %r12
	popq %rbx
	ret 


_list_pop:
L683:
L684:
	movq %rdi,%rdx
	movq (%rdx),%rdi
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	testq %rcx,%rcx
	jz L690
L689:
	movq %rax,40(%rcx)
	jmp L691
L690:
	movq %rax,8(%rdx)
L691:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	testq %rsi,%rsi
	jz L693
L692:
	movq %rdi,(%rsi)
	ret
L693:
	call _token_free
L685:
	ret 


_list_drop:
L695:
	pushq %rbx
L696:
	movq %rdi,%rcx
	movq %rsi,%rdi
	movq 32(%rdi),%rbx
	movq 40(%rdi),%rax
	testq %rbx,%rbx
	jz L702
L701:
	movq %rax,40(%rbx)
	jmp L703
L702:
	movq %rax,8(%rcx)
L703:
	movq 32(%rdi),%rcx
	movq 40(%rdi),%rax
	movq %rcx,(%rax)
	call _token_free
	movq %rbx,%rax
L697:
	popq %rbx
	ret 


_list_match:
L705:
L706:
	movl %esi,%ecx
	movq %rdx,%rsi
	movq (%rdi),%rax
	testq %rax,%rax
	jz L709
L711:
	cmpl (%rax),%ecx
	jnz L709
L708:
	call _list_pop
	ret
L709:
	pushq $L715
	call _error
	addq $8,%rsp
L707:
	ret 


_list_same:
L716:
	pushq %rbx
	pushq %r12
L717:
	movq (%rdi),%r12
	movq (%rsi),%rbx
L719:
	testq %r12,%r12
	jz L721
L726:
	testq %rbx,%rbx
	jz L721
L722:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _token_same
	testl %eax,%eax
	jz L721
L720:
	movq 32(%r12),%r12
	movq 32(%rbx),%rbx
	jmp L719
L721:
	testq %r12,%r12
	jnz L730
L733:
	testq %rbx,%rbx
	jz L731
L730:
	xorl %eax,%eax
	jmp L718
L731:
	movl $1,%eax
L718:
	popq %r12
	popq %rbx
	ret 


_list_normalize:
L739:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L740:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rdi
	call _list_strip_ends
	movq %rbx,%rdi
	call _list_fold_spaces
	movq (%rbx),%rax
L742:
	testq %rax,%rax
	jz L745
L743:
	cmpl $1610612748,(%rax)
	jnz L748
L746:
	movl $1610612793,(%rax)
L748:
	cmpl $1610612778,(%rax)
	jnz L751
L749:
	movl $1610612794,(%rax)
L751:
	movq 32(%rax),%rax
	testq %rax,%rax
	jnz L743
L745:
	movq (%r12),%r14
	xorl %r13d,%r13d
L752:
	testq %r14,%r14
	jz L741
L753:
	movq (%rbx),%r12
L756:
	testq %r12,%r12
	jz L759
L757:
	movq %r12,%rsi
	movq %r14,%rdi
	call _token_same
	testl %eax,%eax
	jz L762
L760:
	leaq 8(%r12),%rdi
	call _vstring_free
	movl $-2147483587,(%r12)
	movslq %r13d,%rax
	movq %rax,8(%r12)
L762:
	movq 32(%r12),%r12
	jmp L756
L759:
	movq 32(%r14),%r14
	incl %r13d
	jmp L752
L741:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_stringize:
L764:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L765:
	movq %rdi,%r14
	movl $55,%edi
	call _alloc
	movq %rax,%r13
	movl $34,%esi
	leaq 8(%r13),%rdi
	call _vstring_putc
	movq (%r14),%r12
L767:
	testq %r12,%r12
	jz L770
L768:
	testl $2147483648,(%r12)
	jz L773
L771:
	pushq $L774
	call _error
	addq $8,%rsp
L773:
	cmpl $51,(%r12)
	jnz L777
L778:
	cmpq (%r14),%r12
	jz L769
L782:
	cmpq $0,32(%r12)
	jz L769
L777:
	testl $1,8(%r12)
	jz L788
L787:
	leaq 9(%r12),%rbx
	jmp L790
L788:
	movq 24(%r12),%rbx
L790:
	movzbl (%rbx),%esi
	testb %sil,%sil
	jz L769
L791:
	movl (%r12),%eax
	cmpl $55,%eax
	jz L793
L796:
	cmpl $56,%eax
	jnz L794
L793:
	movsbl %sil,%esi
	incq %rbx
	leaq 8(%r13),%rdi
	call _backslash
	jmp L790
L794:
	incq %rbx
	leaq 8(%r13),%rdi
	call _vstring_putc
	jmp L790
L769:
	movq 32(%r12),%r12
	jmp L767
L770:
	movl $34,%esi
	leaq 8(%r13),%rdi
	call _vstring_putc
	movq %r13,%rax
L766:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_ennervate:
L801:
	pushq %rbx
	pushq %r12
L802:
	movq %rsi,%r12
	movq (%rdi),%rbx
L804:
	testq %rbx,%rbx
	jz L803
L805:
	cmpl $52,(%rbx)
	jnz L810
L811:
	movq %r12,%rsi
	leaq 8(%rbx),%rdi
	call _vstring_same
	testl %eax,%eax
	jz L810
L808:
	movl $1073741886,(%rbx)
L810:
	movq 32(%rbx),%rbx
	jmp L804
L803:
	popq %r12
	popq %rbx
	ret 


_list_copy:
L815:
	pushq %rbx
	pushq %r12
L816:
	movq %rdi,%r12
	movq (%rsi),%rbx
L818:
	testq %rbx,%rbx
	jz L817
L819:
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
	jmp L818
L817:
	popq %r12
	popq %rbx
	ret 


_list_move:
L825:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L826:
	movq %rdi,%r14
	movq %rsi,%r13
	movl %edx,%r12d
L828:
	movl %r12d,%eax
	decl %r12d
	testl %eax,%eax
	jz L827
L829:
	movq (%r13),%rbx
	testq %rbx,%rbx
	jnz L835
L831:
	pushq $L834
	call _error
	addq $8,%rsp
L835:
	leaq 32(%rbx),%rdx
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	testq %rcx,%rcx
	jz L839
L838:
	movq %rax,40(%rcx)
	jmp L840
L839:
	movq %rax,8(%r13)
L840:
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	movq %rcx,(%rax)
	movq $0,32(%rbx)
	movq 8(%r14),%rax
	movq %rax,40(%rbx)
	movq 8(%r14),%rax
	movq %rbx,(%rax)
	movq %rdx,8(%r14)
	jmp L828
L827:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_next_is:
L844:
L845:
	movq 32(%rsi),%rax
L847:
	testq %rax,%rax
	jz L849
L850:
	cmpl $51,(%rax)
	jnz L849
L848:
	movq 32(%rax),%rax
	testq %rax,%rax
	jnz L850
L849:
	testq %rax,%rax
	jz L855
L857:
	cmpl (%rax),%edx
	jnz L855
L854:
	movl $1,%eax
	ret
L855:
	xorl %eax,%eax
L846:
	ret 


_list_prev_is:
L864:
L865:
	movq 40(%rsi),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
L867:
	testq %rax,%rax
	jz L869
L870:
	cmpl $51,(%rax)
	jnz L869
L868:
	movq 40(%rax),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	testq %rax,%rax
	jnz L870
L869:
	testq %rax,%rax
	jz L875
L877:
	cmpl (%rax),%edx
	jnz L875
L874:
	movl $1,%eax
	ret
L875:
	xorl %eax,%eax
L866:
	ret 


_list_insert:
L884:
L885:
	leaq 32(%rdx),%rax
	testq %rsi,%rsi
	jz L893
L890:
	movq 40(%rsi),%rcx
	movq %rcx,40(%rdx)
	movq %rsi,32(%rdx)
	movq 40(%rsi),%rcx
	movq %rdx,(%rcx)
	movq %rax,40(%rsi)
	ret
L893:
	movq $0,32(%rdx)
	movq 8(%rdi),%rcx
	movq %rcx,40(%rdx)
	movq 8(%rdi),%rcx
	movq %rdx,(%rcx)
	movq %rax,8(%rdi)
L886:
	ret 


_list_insert_list:
L896:
	pushq %rbx
	pushq %r12
	pushq %r13
L897:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
L899:
	movq (%rbx),%rdx
	testq %rdx,%rdx
	jz L898
L902:
	movq 32(%rdx),%rcx
	movq 40(%rdx),%rax
	testq %rcx,%rcx
	jz L906
L905:
	movq %rax,40(%rcx)
	jmp L907
L906:
	movq %rax,8(%rbx)
L907:
	movq 32(%rdx),%rcx
	movq 40(%rdx),%rax
	movq %rcx,(%rax)
	movq %r12,%rsi
	movq %r13,%rdi
	call _list_insert
	jmp L899
L898:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_list_placeholder:
L908:
	pushq %rbx
L909:
	movq %rdi,%rbx
	cmpq $0,(%rbx)
	jnz L910
L911:
	movl $1073741886,%edi
	call _alloc
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 8(%rbx),%rcx
	movq %rcx,40(%rax)
	movq 8(%rbx),%rcx
	movq %rax,(%rcx)
	movq %rdx,8(%rbx)
L910:
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
L715:
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
L834:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,108,105
 .byte 115,116,95,109,111,118,101,0
L774:
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
