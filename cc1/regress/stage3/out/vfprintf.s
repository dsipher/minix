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
	movl %edx,%r11d
	cmpl $120,%ecx
	movl $_digits,%eax
	movl $_ldigits,%r10d
	cmovnzq %rax,%r10
	leaq -1(%rbp),%r9
	movb $0,-1(%rbp)
L7:
	movl %r11d,%r8d
	movq %rsi,%rax
	xorl %edx,%edx
	divq %r8
	movzbl (%rdx,%r10),%ecx
	leaq -1(%r9),%rax
	movb %cl,-1(%r9)
	movq %rax,%r9
	movq %rsi,%rax
	xorl %edx,%edx
	divq %r8
	movq %rax,%rsi
	testq %rsi,%rsi
	jnz L7
L10:
	movzbl (%r9),%eax
	testb %al,%al
	jz L12
L11:
	incq %r9
	movb %al,(%rdi)
	incq %rdi
	jmp L10
L12:
	movq %rdi,%rax
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L313:
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
	subq $624,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L15:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	movl $0,-568(%rbp)
L21:
	movsbl (%r14),%edi
	incq %r14
	cmpl $37,%edi
	jz L23
L22:
	testl %edi,%edi
	jz L24
L26:
	incl -568(%rbp)
	decl (%r15)
	js L29
L28:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dil,(%rcx)
	jmp L21
L29:
	movq %r15,%rsi
	call ___flushbuf
	jmp L21
L24:
	movl -568(%rbp),%eax
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
	movl $0,-552(%rbp)
	movl $0,-560(%rbp)
	movl $0,-536(%rbp)
	movl $32,-616(%rbp)
L31:
	movsbl (%r14),%edi
	incq %r14
	cmpl $32,%edi
	jz L42
	jl L36
L298:
	cmpl $48,%edi
	jz L46
	jg L36
L299:
	cmpb $35,%dil
	jz L44
L300:
	cmpb $43,%dil
	jz L40
L301:
	cmpb $45,%dil
	jnz L36
L38:
	incl -536(%rbp)
	jmp L31
L40:
	incl -560(%rbp)
	jmp L31
L44:
	incl %r8d
	jmp L31
L46:
	movl $48,-616(%rbp)
	jmp L31
L42:
	incl -552(%rbp)
	jmp L31
L36:
	cmpl $42,%edi
	jnz L51
L50:
	addq $8,%r13
	movl -8(%r13),%eax
	movl %eax,-608(%rbp)
	cmpl $0,%eax
	jge L55
L53:
	movl $1,-536(%rbp)
	negl %eax
	movl %eax,-608(%rbp)
L55:
	movsbl (%r14),%edi
	incq %r14
	jmp L52
L51:
	movl $0,-608(%rbp)
L56:
	cmpl $48,%edi
	jl L52
L60:
	cmpl $57,%edi
	jg L52
L61:
	imull $10,-608(%rbp),%eax
	addl %edi,%eax
	subl $48,%eax
	movl %eax,-608(%rbp)
	movsbl (%r14),%edi
	incq %r14
	cmpl $48,%edi
	jge L60
L52:
	cmpl $46,%edi
	jnz L65
L64:
	movsbl (%r14),%edi
	incq %r14
	cmpl $42,%edi
	jnz L68
L67:
	addq $8,%r13
	movl -8(%r13),%ebx
	cmpl $0,%ebx
	movl $-1,%eax
	cmovll %eax,%ebx
	movsbl (%r14),%edi
	incq %r14
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
	movsbl (%r14),%edi
	incq %r14
	cmpl $48,%edi
	jge L77
	jl L66
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
	movl -576(%rbp),%eax
	cmovnzl %edi,%eax
	movl %eax,-576(%rbp)
	movsbl (%r14),%edi
	incq %r14
	jmp L83
L86:
	movl $0,-576(%rbp)
L83:
	leaq -512(%rbp),%rax
	movq %rax,-592(%rbp)
	movq -592(%rbp),%rax
	movq %rax,-624(%rbp)
	movq -592(%rbp),%rax
	movq %rax,-584(%rbp)
	movl $0,-544(%rbp)
	movl $0,-600(%rbp)
	xorl %r12d,%r12d
	movl $0,-524(%rbp)
	cmpl $99,%edi
	jl L305
L307:
	cmpl $120,%edi
	jg L305
L304:
	leal -99(%rdi),%eax
	movzwl L313(,%rax,2),%eax
	addl $_vfprintf,%eax
	jmp *%rax
L118:
	movl $10,%edx
	jmp L116
L166:
	addq $8,%r13
	movq -8(%r13),%rsi
	testq %rsi,%rsi
	movl $L170,%eax
	cmovzq %rax,%rsi
	movq %rsi,-624(%rbp)
	movq %rsi,%rdx
L171:
	movzbl (%rdx),%eax
	incq %rdx
	testb %al,%al
	jz L173
L172:
	cmpl $0,%ebx
	jl L171
L177:
	movq %rdx,%rcx
	subq %rsi,%rcx
	movslq %ebx,%rax
	cmpq %rax,%rcx
	jle L171
L173:
	decq %rdx
	movq %rdx,-584(%rbp)
	jmp L100
L183:
	movl $108,-576(%rbp)
	movl $16,%ebx
	incl %r8d
	movl $88,%edi
	movl $16,%edx
	jmp L122
L115:
	movl $8,%edx
	jmp L116
L185:
	leaq 8(%r13),%rax
	movq (%r13),%rcx
	cmpl $104,-576(%rbp)
	jnz L187
L186:
	movzwl -568(%rbp),%edx
	movq %rax,%r13
	movw %dx,(%rcx)
	jmp L100
L187:
	cmpl $108,-576(%rbp)
	jnz L190
L189:
	movslq -568(%rbp),%rdx
	movq %rax,%r13
	movq %rdx,(%rcx)
	jmp L100
L190:
	movq %rax,%r13
	movl -568(%rbp),%eax
	movl %eax,(%rcx)
	jmp L100
L103:
	movl $10,%edx
	addq $8,%r13
	movq %r13,%rax
	subq $8,%rax
	cmpl $108,-576(%rbp)
	jnz L105
L104:
	movq (%rax),%rsi
	jmp L106
L105:
	movslq (%rax),%rsi
L106:
	cmpl $104,-576(%rbp)
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
	addq $8,%r13
	movl -8(%r13),%eax
	movb %al,-512(%rbp)
	leaq -511(%rbp),%rax
	movq %rax,-584(%rbp)
	jmp L100
L305:
	cmpl $69,%edi
	jz L162
L309:
	cmpl $71,%edi
	jz L162
L310:
	cmpl $88,%edi
	jz L121
L99:
	incl -568(%rbp)
	decl (%r15)
	js L194
L193:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dil,(%rcx)
	jmp L21
L194:
	movq %r15,%rsi
	call ___flushbuf
	jmp L21
L121:
	movl $16,%edx
L116:
	cmpl $108,-576(%rbp)
	jnz L123
L122:
	addq $8,%r13
	movq -8(%r13),%rsi
	jmp L124
L123:
	addq $8,%r13
	movslq -8(%r13),%rsi
L124:
	cmpl $104,-576(%rbp)
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
	movl %edi,-600(%rbp)
L113:
	testl %ebx,%ebx
	jnz L148
L146:
	testq %rsi,%rsi
	jz L100
L148:
	cmpl $-1,%ebx
	movl $32,%ecx
	movl -616(%rbp),%eax
	cmovnzl %ecx,%eax
	movl %eax,-616(%rbp)
	movl %edi,%ecx
	leaq -512(%rbp),%rdi
	call _convert
	movq %rax,-584(%rbp)
	subq -592(%rbp),%rax
	subl %eax,%ebx
	movl %ebx,%r12d
	movl $0,%eax
	cmovsl %eax,%r12d
	jmp L100
L162:
	addq $8,%r13
	movsd -8(%r13),%xmm0
	movsd %xmm0,-520(%rbp)
	leaq -524(%rbp),%r9
	movl %ebx,%ecx
	movl %edi,%edx
	leaq -520(%rbp),%rsi
	leaq -512(%rbp),%rdi
	call ___dtefg
	movq %rax,-584(%rbp)
L100:
	movq -584(%rbp),%rcx
	subq -624(%rbp),%rcx
	movl -524(%rbp),%eax
	testl %eax,%eax
	jz L199
L200:
	cmpl $-1,%eax
	jz L205
L208:
	cmpl $0,-560(%rbp)
	jnz L205
L210:
	cmpl $0,-552(%rbp)
	jz L199
L205:
	incl %ecx
	movl $1,-544(%rbp)
L199:
	cmpl $0,-600(%rbp)
	jz L214
L212:
	incl %ecx
	incl -544(%rbp)
	cmpl $111,-600(%rbp)
	jz L214
L215:
	incl %ecx
L214:
	movl -608(%rbp),%ebx
	subl %r12d,%ebx
	subl %ecx,%ebx
	movl $0,%eax
	cmovsl %eax,%ebx
	addl %ebx,%ecx
	addl %r12d,%ecx
	addl -568(%rbp),%ecx
	movl %ecx,-568(%rbp)
	cmpl $0,-536(%rbp)
	jnz L223
L224:
	cmpl $0,%ebx
	jle L223
L225:
	cmpl $0,-544(%rbp)
	jz L235
L231:
	cmpl $48,-616(%rbp)
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
	movzbl -616(%rbp),%edx
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L235
L239:
	movq %r15,%rsi
	movl -616(%rbp),%edi
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
	call ___flushbuf
	jmp L243
L245:
	cmpl $0,-560(%rbp)
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
	call ___flushbuf
	jmp L243
L251:
	cmpl $0,-552(%rbp)
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
	call ___flushbuf
L243:
	cmpl $0,-600(%rbp)
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
	cmpl $111,-600(%rbp)
	jz L274
L268:
	decl (%r15)
	js L272
L271:
	movzbl -600(%rbp),%edx
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L274
L272:
	movq %r15,%rsi
	movl -600(%rbp),%edi
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
	call ___flushbuf
	jmp L274
L276:
	movq -584(%rbp),%r12
	subq -624(%rbp),%r12
L280:
	movl %r12d,%eax
	decl %r12d
	cmpl $0,%eax
	jle L282
L281:
	decl (%r15)
	movq -624(%rbp),%rax
	leaq 1(%rax),%rcx
	js L284
L283:
	movq -624(%rbp),%rax
	movzbl (%rax),%edx
	movq %rcx,-624(%rbp)
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb %dl,(%rcx)
	jmp L280
L284:
	movq -624(%rbp),%rax
	movsbl (%rax),%edi
	movq %rcx,-624(%rbp)
	movq %r15,%rsi
	call ___flushbuf
	jmp L280
L282:
	cmpl $0,-536(%rbp)
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
