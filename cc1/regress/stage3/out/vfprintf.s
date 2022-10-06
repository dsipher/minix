.data
_digits:
	.byte 48
	.byte 49
	.byte 50
	.byte 51
	.byte 52
	.byte 53
	.byte 54
	.byte 55
	.byte 56
	.byte 57
	.byte 65
	.byte 66
	.byte 67
	.byte 68
	.byte 69
	.byte 70
_ldigits:
	.byte 48
	.byte 49
	.byte 50
	.byte 51
	.byte 52
	.byte 53
	.byte 54
	.byte 55
	.byte 56
	.byte 57
	.byte 97
	.byte 98
	.byte 99
	.byte 100
	.byte 101
	.byte 102
.text

_convert:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
L2:
	movl %edx,%r8d
	cmpl $120,%ecx
	movl $_digits,%eax
	movl $_ldigits,%r10d
	cmovnzq %rax,%r10
	leaq -1(%rbp),%r9
	movb $0,-1(%rbp)
L7:
	movl %r8d,%r8d
	movq %rsi,%rax
	xorl %edx,%edx
	divq %r8
	movb (%rdx,%r10),%cl
	leaq -1(%r9),%rax
	movb %cl,-1(%r9)
	movq %rax,%r9
	movq %rsi,%rax
	xorl %edx,%edx
	divq %r8
	movq %rax,%rsi
	testq %rsi,%rsi
	jnz L7
	jz L10
L11:
	incq %r9
	movb %al,(%rdi)
	incq %rdi
L10:
	movb (%r9),%al
	testb %al,%al
	jnz L11
L12:
	movq %rdi,%rax
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L311:
	.short L164-_vfprintf
	.short L103-_vfprintf
	.short L162-_vfprintf
	.short L162-_vfprintf
	.short L162-_vfprintf
	.short L99-_vfprintf
	.short L103-_vfprintf
	.short L99-_vfprintf
	.short L99-_vfprintf
	.short L99-_vfprintf
	.short L99-_vfprintf
	.short L185-_vfprintf
	.short L115-_vfprintf
	.short L183-_vfprintf
	.short L99-_vfprintf
	.short L99-_vfprintf
	.short L166-_vfprintf
	.short L99-_vfprintf
	.short L118-_vfprintf
	.short L99-_vfprintf
	.short L99-_vfprintf
	.short L121-_vfprintf

_vfprintf:
L14:
	pushq %rbp
	movq %rsp,%rbp
	subq $584,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L15:
	movq %rdi,%r15
	movq %rsi,-584(%rbp)
	movq %rdx,%r14
	movl $0,-536(%rbp)
L21:
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
	cmpl $37,%edi
	jz L23
L22:
	testl %edi,%edi
	jz L24
L26:
	incl -536(%rbp)
	decl (%r15)
	js L315
	jns L316
L24:
	movl -536(%rbp),%eax
L16:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L23:
	xorl %r8d,%r8d
	movl $0,-532(%rbp)
	movl $0,-540(%rbp)
	movl $0,-528(%rbp)
	movl $32,-572(%rbp)
L31:
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
	cmpl $32,%edi
	jz L42
	jl L36
L296:
	cmpl $48,%edi
	jz L46
	jg L36
L297:
	cmpb $35,%dil
	jz L44
L298:
	cmpb $43,%dil
	jz L40
L299:
	cmpb $45,%dil
	jnz L36
L38:
	incl -528(%rbp)
	jmp L31
L40:
	incl -540(%rbp)
	jmp L31
L44:
	incl %r8d
	jmp L31
L46:
	movl $48,-572(%rbp)
	jmp L31
L42:
	incl -532(%rbp)
	jmp L31
L36:
	cmpl $42,%edi
	jnz L51
L50:
	addq $8,%r14
	movl -8(%r14),%eax
	movl %eax,-564(%rbp)
	cmpl $0,%eax
	jge L55
L53:
	movl $1,-528(%rbp)
	negl %eax
	movl %eax,-564(%rbp)
L55:
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
	jmp L52
L51:
	movl $0,-564(%rbp)
	jmp L56
L60:
	cmpl $57,%edi
	jg L52
L61:
	imull $10,-564(%rbp),%eax
	addl %edi,%eax
	subl $48,%eax
	movl %eax,-564(%rbp)
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
L56:
	cmpl $48,%edi
	jge L60
L52:
	cmpl $46,%edi
	jnz L65
L64:
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
	cmpl $42,%edi
	jnz L68
L67:
	addq $8,%r14
	movl -8(%r14),%ebx
	cmpl $0,%ebx
	movl $-1,%eax
	cmovll %eax,%ebx
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
	jmp L66
L68:
	xorl %ebx,%ebx
L73:
	cmpl $48,%edi
	jl L66
L77:
	cmpl $57,%edi
	jg L66
L78:
	leal (%rbx,%rbx,4),%ebx
	addl %ebx,%ebx
	addl %edi,%ebx
	subl $48,%ebx
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
	jmp L73
L65:
	movl $-1,%ebx
L66:
	cmpl $108,%edi
	jz L85
L92:
	cmpl $104,%edi
	jz L85
L94:
	cmpl $76,%edi
	jz L85
L90:
	cmpl $122,%edi
	jnz L86
L85:
	cmpl $122,%edi
	movl -544(%rbp),%eax
	cmovnzl %edi,%eax
	movl %eax,-544(%rbp)
	movq -584(%rbp),%rax
	movsbl (%rax),%edi
	incq %rax
	movq %rax,-584(%rbp)
	jmp L83
L86:
	movl $0,-544(%rbp)
L83:
	leaq -512(%rbp),%r13
	movq %r13,-560(%rbp)
	movl $0,-548(%rbp)
	movl $0,-568(%rbp)
	xorl %r12d,%r12d
	movl $0,-524(%rbp)
	cmpl $99,%edi
	jl L303
L305:
	cmpl $120,%edi
	jg L303
L302:
	leal -99(%rdi),%eax
	movzwl L311(,%rax,2),%eax
	addl $_vfprintf,%eax
	jmp *%rax
L118:
	movl $10,%edx
	jmp L116
L166:
	addq $8,%r14
	movq -8(%r14),%r13
	testq %r13,%r13
	movl $L170,%eax
	cmovzq %rax,%r13
	movq %r13,%rcx
L171:
	movb (%rcx),%al
	incq %rcx
	testb %al,%al
	jz L173
L172:
	cmpl $0,%ebx
	jl L171
L177:
	movq %rcx,%rax
	subq %r13,%rax
	movslq %ebx,%rbx
	cmpq %rbx,%rax
	jle L171
L173:
	decq %rcx
	movq %rcx,-560(%rbp)
	jmp L100
L183:
	movl $108,-544(%rbp)
	movl $16,%ebx
	incl %r8d
	movl $88,%edi
	movl $16,%edx
	jmp L122
L115:
	movl $8,%edx
	jmp L116
L185:
	leaq 8(%r14),%rdx
	movq (%r14),%rcx
	cmpl $104,-544(%rbp)
	jnz L187
L186:
	movl -536(%rbp),%eax
	movq %rdx,%r14
	movw %ax,(%rcx)
	jmp L100
L187:
	cmpl $108,-544(%rbp)
	jnz L190
L189:
	movslq -536(%rbp),%rax
	movq %rdx,%r14
	movq %rax,(%rcx)
	jmp L100
L190:
	movq %rdx,%r14
	movl -536(%rbp),%eax
	movl %eax,(%rcx)
	jmp L100
L103:
	movl $10,%edx
	addq $8,%r14
	movq %r14,%rax
	subq $8,%rax
	cmpl $108,-544(%rbp)
	jnz L105
L104:
	movq (%rax),%rsi
	jmp L106
L105:
	movslq (%rax),%rsi
L106:
	cmpl $104,-544(%rbp)
	jnz L109
L107:
	movswq %si,%rsi
L109:
	cmpq $0,%rsi
	jge L111
L110:
	negq %rsi
	movl $-1,-524(%rbp)
	jmp L113
L111:
	movl $1,-524(%rbp)
	jmp L113
L164:
	addq $8,%r14
	movl -8(%r14),%eax
	movb %al,-512(%rbp)
	leaq -511(%rbp),%rax
	jmp L317
L303:
	cmpl $69,%edi
	jz L162
L307:
	cmpl $71,%edi
	jz L162
L308:
	cmpl $88,%edi
	jz L121
L99:
	incl -536(%rbp)
	decl (%r15)
	js L315
L316:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dil,(%rcx)
	jmp L21
L315:
	movq %r15,%rsi
	call ___flushbuf
	jmp L21
L121:
	movl $16,%edx
L116:
	cmpl $108,-544(%rbp)
	jnz L123
L122:
	addq $8,%r14
	movq -8(%r14),%rsi
	jmp L124
L123:
	addq $8,%r14
	movslq -8(%r14),%rsi
L124:
	cmpl $104,-544(%rbp)
	jnz L127
L125:
	movzwq %si,%rsi
L127:
	testl %r8d,%r8d
	jz L113
L131:
	testq %rsi,%rsi
	jz L141
L139:
	cmpl $8,%edx
	jz L136
L141:
	cmpl $16,%edx
	jnz L113
L136:
	movl %edi,-568(%rbp)
L113:
	testl %ebx,%ebx
	jnz L148
L146:
	testq %rsi,%rsi
	jz L100
L148:
	cmpl $-1,%ebx
	movl $32,%ecx
	movl -572(%rbp),%eax
	cmovnzl %ecx,%eax
	movl %eax,-572(%rbp)
	movl %edi,%ecx
	leaq -512(%rbp),%rdi
	call _convert
	movq %rax,-560(%rbp)
	subq %r13,%rax
	subl %eax,%ebx
	movl %ebx,%r12d
	movl $0,%eax
	cmovsl %eax,%r12d
	jmp L100
L162:
	addq $8,%r14
	movsd -8(%r14),%xmm0
	movsd %xmm0,-520(%rbp)
	leaq -524(%rbp),%r9
	movl %ebx,%ecx
	movl %edi,%edx
	leaq -520(%rbp),%rsi
	leaq -512(%rbp),%rdi
	call ___dtefg
L317:
	movq %rax,-560(%rbp)
L100:
	movq -560(%rbp),%rcx
	subq %r13,%rcx
	movl -524(%rbp),%eax
	testl %eax,%eax
	jz L199
L200:
	cmpl $-1,%eax
	jz L205
L208:
	cmpl $0,-540(%rbp)
	jnz L205
L210:
	cmpl $0,-532(%rbp)
	jz L199
L205:
	incl %ecx
	movl $1,-548(%rbp)
L199:
	cmpl $0,-568(%rbp)
	jz L214
L212:
	incl %ecx
	incl -548(%rbp)
	cmpl $111,-568(%rbp)
	jz L214
L215:
	incl %ecx
L214:
	movl -564(%rbp),%ebx
	subl %r12d,%ebx
	subl %ecx,%ebx
	movl $0,%eax
	cmovsl %eax,%ebx
	addl %ebx,%ecx
	addl %r12d,%ecx
	addl -536(%rbp),%ecx
	movl %ecx,-536(%rbp)
	cmpl $0,-528(%rbp)
	jnz L223
L224:
	cmpl $0,%ebx
	jle L223
L225:
	cmpl $0,-548(%rbp)
	jz L235
L231:
	cmpl $48,-572(%rbp)
	jz L232
L235:
	movl %ebx,%eax
	decl %ebx
	cmpl $0,%eax
	jle L223
L236:
	decl (%r15)
	js L239
L238:
	movl -572(%rbp),%eax
	movq 24(%r15),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%r15)
	movb %al,(%rdx)
	jmp L235
L239:
	movq %r15,%rsi
	movl -572(%rbp),%edi
	call ___flushbuf
	jmp L235
L232:
	addl %ebx,%r12d
L223:
	movl -524(%rbp),%eax
	testl %eax,%eax
	jz L243
L241:
	cmpl $-1,%eax
	jnz L245
L244:
	decl (%r15)
	js L248
L247:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $45,(%rcx)
	jmp L243
L248:
	movq %r15,%rsi
	movl $45,%edi
	jmp L314
L245:
	cmpl $0,-540(%rbp)
	jz L251
L250:
	decl (%r15)
	js L254
L253:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $43,(%rcx)
	jmp L243
L254:
	movq %r15,%rsi
	movl $43,%edi
	jmp L314
L251:
	cmpl $0,-532(%rbp)
	jz L243
L256:
	decl (%r15)
	js L260
L259:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $32,(%rcx)
	jmp L243
L260:
	movq %r15,%rsi
	movl $32,%edi
L314:
	call ___flushbuf
L243:
	cmpl $0,-568(%rbp)
	jz L274
L262:
	decl (%r15)
	js L266
L265:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $48,(%rcx)
	jmp L267
L266:
	movq %r15,%rsi
	movl $48,%edi
	call ___flushbuf
L267:
	cmpl $111,-568(%rbp)
	jz L274
L268:
	decl (%r15)
	js L272
L271:
	movl -568(%rbp),%eax
	movq 24(%r15),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%r15)
	movb %al,(%rdx)
	jmp L274
L272:
	movq %r15,%rsi
	movl -568(%rbp),%edi
L313:
	call ___flushbuf
L274:
	movl %r12d,%eax
	decl %r12d
	cmpl $0,%eax
	jle L276
L275:
	decl (%r15)
	js L278
L277:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $48,(%rcx)
	jmp L274
L278:
	movq %r15,%rsi
	movl $48,%edi
	jmp L313
L276:
	movq -560(%rbp),%r12
	subq %r13,%r12
L280:
	movl %r12d,%eax
	decl %r12d
	cmpl $0,%eax
	jle L282
L281:
	decl (%r15)
	leaq 1(%r13),%rax
	js L284
L283:
	movb (%r13),%dl
	movq %rax,%r13
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L280
L284:
	movsbl (%r13),%edi
	movq %rax,%r13
	movq %r15,%rsi
	call ___flushbuf
	jmp L280
L282:
	cmpl $0,-528(%rbp)
	jz L21
L289:
	movl %ebx,%eax
	decl %ebx
	cmpl $0,%eax
	jle L21
L290:
	decl (%r15)
	js L293
L292:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $32,(%rcx)
	jmp L289
L293:
	movq %r15,%rsi
	movl $32,%edi
	call ___flushbuf
	jmp L289

L170:
	.byte 123,78,85,76,76,125,0

.globl ___flushbuf
.globl _vfprintf
.globl ___dtefg
