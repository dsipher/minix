.data
.align 4
_maxsetvec:
	.int 0
.align 4
_nfatab:
	.int 0
.align 4
L4:
	.int 1
.text

_makedfa:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%r13
	movl %esi,%r12d
	cmpq $0,_setvec(%rip)
	jnz L7
L5:
	movl $22,_maxsetvec(%rip)
	movl $88,%edi
	call _malloc
	movq %rax,_setvec(%rip)
	movslq _maxsetvec(%rip),%rdi
	shlq $2,%rdi
	call _malloc
	movq %rax,_tmpset(%rip)
	cmpq $0,_setvec(%rip)
	jz L12
L11:
	testq %rax,%rax
	jnz L7
L12:
	movl $L15,%edi
	call _overflo
L7:
	cmpl $0,_compile_time(%rip)
	jnz L16
L18:
	xorl %ebx,%ebx
	jmp L20
L21:
	movq _fatab(,%rbx,8),%rax
	cmpl 8584(%rax),%r12d
	jnz L29
L27:
	movq %r13,%rsi
	movq 8320(%rax),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L29
L28:
	movl L4(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,L4(%rip)
	movq _fatab(,%rbx,8),%rax
	movl %ecx,8588(%rax)
	movq _fatab(,%rbx,8),%rax
	jmp L3
L29:
	incl %ebx
L20:
	cmpl _nfatab(%rip),%ebx
	jl L21
L23:
	movl %r12d,%esi
	movq %r13,%rdi
	call _mkdfa
	movq %rax,%rbx
	movl _nfatab(%rip),%eax
	cmpl $20,%eax
	jl L32
L34:
	movq _fatab(%rip),%rax
	movl 8588(%rax),%edx
	xorl %r12d,%r12d
	movl $1,%ecx
	jmp L36
L37:
	movq _fatab(,%rcx,8),%rax
	movl 8588(%rax),%eax
	cmpl %eax,%edx
	jle L42
L40:
	movl %eax,%edx
	movl %ecx,%r12d
L42:
	incl %ecx
L36:
	cmpl _nfatab(%rip),%ecx
	jl L37
L39:
	movl %r12d,%r12d
	movq _fatab(,%r12,8),%rdi
	call _freefa
	movq %rbx,_fatab(,%r12,8)
	movl L4(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,L4(%rip)
	movl %ecx,8588(%rbx)
	jmp L44
L32:
	movslq %eax,%rax
	movq %rbx,_fatab(,%rax,8)
	movl L4(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,L4(%rip)
	movslq _nfatab(%rip),%rax
	movq _fatab(,%rax,8),%rax
	movl %ecx,8588(%rax)
	incl _nfatab(%rip)
L44:
	movq %rbx,%rax
	jmp L3
L16:
	movl %r12d,%esi
	movq %r13,%rdi
	call _mkdfa
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_mkdfa:
L45:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L46:
	movq %rdi,%r14
	movl %esi,%r13d
	movq %r14,%rdi
	call _reparse
	movq %rax,%rbx
	xorl %edx,%edx
	xorl %esi,%esi
	movl $270,%edi
	call _op2
	xorl %edx,%edx
	movq %rax,%rsi
	movl $275,%edi
	call _op2
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $342,%edi
	call _op2
	movq %rax,%rbx
	xorl %edx,%edx
	xorl %esi,%esi
	movl $268,%edi
	call _op2
	movq %rax,%rdx
	movq %rbx,%rsi
	movl $342,%edi
	call _op2
	movq %rax,%r12
	movl $0,_poscnt(%rip)
	movq %r12,%rdi
	call _penter
	movslq _poscnt(%rip),%rax
	leaq (%rax,%rax,2),%rsi
	shlq $3,%rsi
	addq $8632,%rsi
	movl $1,%edi
	call _calloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L50
L48:
	movl $L51,%edi
	call _overflo
L50:
	movl _poscnt(%rip),%eax
	decl %eax
	movl %eax,8600(%rbx)
	movq %r12,%rsi
	movq %rbx,%rdi
	call _cfoll
	movq %r12,%rdi
	call _freetr
	movq 8624(%rbx),%rax
	movslq (%rax),%rsi
	shlq $2,%rsi
	movl $1,%edi
	call _calloc
	movq %rax,8328(%rbx)
	testq %rax,%rax
	jnz L54
L52:
	movl $L55,%edi
	call _overflo
L54:
	movl $4,%esi
	movl $1,%edi
	call _calloc
	movq %rax,8336(%rbx)
	testq %rax,%rax
	jnz L58
L56:
	movl $L55,%edi
	call _overflo
L58:
	movq 8336(%rbx),%rax
	movl $0,(%rax)
	movl %r13d,%esi
	movq %rbx,%rdi
	call _makeinit
	movl %eax,8592(%rbx)
	movl %r13d,8584(%rbx)
	movq %r14,%rdi
	call _tostring
	movq %rax,8320(%rbx)
	movq %rbx,%rax
L47:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_makeinit:
L60:
	pushq %rbx
	pushq %r12
	pushq %r13
L61:
	movq %rdi,%r13
	movl %esi,%r12d
	movl $2,8596(%r13)
	movb $0,8290(%r13)
	movl $0,8604(%r13)
	movq 8624(%r13),%rax
	movl (%rax),%ebx
	movq 8344(%r13),%rdi
	testq %rdi,%rdi
	jz L65
L63:
	call _free
	movq $0,8344(%r13)
L65:
	leal 1(%rbx),%esi
	movslq %esi,%rsi
	shlq $2,%rsi
	movl $1,%edi
	call _calloc
	movq %rax,8344(%r13)
	testq %rax,%rax
	jnz L68
L66:
	movl $L69,%edi
	call _overflo
L68:
	xorl %edx,%edx
	jmp L70
L71:
	movq 8624(%r13),%rcx
	movl (%rcx,%rdx,4),%ecx
	movl %ecx,(%rax,%rdx,4)
	incl %edx
L70:
	movq 8344(%r13),%rax
	cmpl %edx,%ebx
	jge L71
L73:
	movl 4(%rax),%eax
	cmpl 8600(%r13),%eax
	jnz L76
L74:
	movb $1,8290(%r13)
L76:
	xorl %eax,%eax
L78:
	movb $0,518(%r13,%rax)
	incl %eax
	cmpl $259,%eax
	jl L78
L80:
	movl $261,%edx
	movl $2,%esi
	movq %r13,%rdi
	call _cgoto
	movl %eax,8596(%r13)
	testl %r12d,%r12d
	jz L83
L81:
	movl %ebx,%ecx
	decl %ecx
	movq 8344(%r13),%rax
	movl %ecx,(%rax)
	xorl %edx,%edx
	jmp L84
L85:
	movq 8344(%r13),%rax
	movl (%rax,%rdx,4),%ecx
	movq 8328(%r13),%rax
	movl %ecx,(%rax,%rdx,4)
	incl %edx
L84:
	cmpl %edx,%ebx
	jg L85
L87:
	movb 8290(%r13),%al
	movb %al,8288(%r13)
	movl 8596(%r13),%eax
	cmpl $2,%eax
	jz L83
L88:
	movslq %eax,%rax
	movq 8328(%r13,%rax,8),%rcx
	decl (%rcx)
L83:
	movl 8596(%r13),%eax
L62:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L122:
	.short L104-_penter
	.short L104-_penter
	.short L104-_penter
	.short L104-_penter
	.short L104-_penter
	.short L104-_penter
	.short L111-_penter
	.short L108-_penter
	.short L108-_penter
	.short L108-_penter
	.short L104-_penter

_penter:
L92:
	pushq %rbx
L93:
	movq %rdi,%rbx
	movl 20(%rbx),%ecx
	cmpl $268,%ecx
	jl L116
L118:
	cmpl $278,%ecx
	jg L116
L115:
	leal -268(%rcx),%eax
	movzwl L122(,%rax,2),%eax
	addl $_penter,%eax
	jmp *%rax
L108:
	movq 24(%rbx),%rdi
	call _penter
	movq 24(%rbx),%rax
	jmp L123
L104:
	movl _poscnt(%rip),%eax
	movl %eax,(%rbx)
	incl _poscnt(%rip)
	jmp L94
L116:
	cmpl $342,%ecx
	jz L111
L95:
	pushq %rcx
	pushq $L113
	call _FATAL
	addq $16,%rsp
	jmp L94
L111:
	movq 24(%rbx),%rdi
	call _penter
	movq 32(%rbx),%rdi
	call _penter
	movq 24(%rbx),%rax
	movq %rbx,8(%rax)
	movq 32(%rbx),%rax
L123:
	movq %rbx,8(%rax)
L94:
	popq %rbx
	ret 

.align 2
L164:
	.short L136-_freetr
	.short L136-_freetr
	.short L136-_freetr
	.short L136-_freetr
	.short L136-_freetr
	.short L136-_freetr
	.short L149-_freetr
	.short L143-_freetr
	.short L143-_freetr
	.short L143-_freetr
	.short L136-_freetr

_freetr:
L124:
	pushq %rbx
L125:
	movq %rdi,%rbx
	movl 20(%rbx),%ecx
	cmpl $268,%ecx
	jl L158
L160:
	cmpl $278,%ecx
	jg L158
L157:
	leal -268(%rcx),%eax
	movzwl L164(,%rax,2),%eax
	addl $_freetr,%eax
	jmp *%rax
L143:
	movq 24(%rbx),%rdi
	call _freetr
	testq %rbx,%rbx
	jnz L156
	jz L126
L136:
	testq %rbx,%rbx
	jnz L156
	jz L126
L158:
	cmpl $342,%ecx
	jz L149
L127:
	pushq %rcx
	pushq $L154
	call _FATAL
	addq $16,%rsp
	jmp L126
L149:
	movq 24(%rbx),%rdi
	call _freetr
	movq 32(%rbx),%rdi
	call _freetr
	testq %rbx,%rbx
	jz L126
L156:
	movq %rbx,%rdi
	call _free
L126:
	popq %rbx
	ret 


_hexstr:
L165:
L166:
	xorl %eax,%eax
	xorl %r8d,%r8d
	movq (%rdi),%rsi
L172:
	movzbq (%rsi),%rcx
	movb ___ctype+1(%rcx),%dl
	testb $68,%dl
	jz L171
L169:
	testb $4,%dl
	jz L177
L176:
	movzbl %cl,%ecx
	shll $4,%eax
	addl %ecx,%eax
	subl $48,%eax
	jmp L178
L177:
	cmpb $97,%cl
	jb L180
L182:
	cmpb $102,%cl
	ja L180
L179:
	movzbl %cl,%ecx
	shll $4,%eax
	addl %ecx,%eax
	subl $87,%eax
	jmp L178
L180:
	cmpb $65,%cl
	jb L178
L189:
	cmpb $70,%cl
	ja L178
L186:
	movzbl %cl,%ecx
	shll $4,%eax
	addl %ecx,%eax
	subl $55,%eax
L178:
	incl %r8d
	incq %rsi
	cmpl $2,%r8d
	jl L172
L171:
	movq %rsi,(%rdi)
L167:
	ret 


_quoted:
L194:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L195:
	movq %rdi,%rbx
	movq (%rbx),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-8(%rbp)
	movzbl (%rdx),%eax
	cmpl $116,%eax
	jnz L198
L197:
	movl $9,%eax
	jmp L199
L198:
	cmpl $110,%eax
	jnz L201
L200:
	movl $10,%eax
	jmp L199
L201:
	cmpl $102,%eax
	jnz L204
L203:
	movl $12,%eax
	jmp L199
L204:
	cmpl $114,%eax
	jnz L207
L206:
	movl $13,%eax
	jmp L199
L207:
	cmpl $98,%eax
	jnz L210
L209:
	movl $8,%eax
	jmp L199
L210:
	cmpl $92,%eax
	jnz L213
L212:
	movl $92,%eax
	jmp L199
L213:
	cmpl $120,%eax
	jnz L216
L215:
	leaq -8(%rbp),%rdi
	call _hexstr
	jmp L199
L216:
	cmpl $48,%eax
	jl L199
L221:
	cmpl $55,%eax
	jg L199
L218:
	subl $48,%eax
	movb 1(%rdx),%cl
	cmpb $48,%cl
	jb L199
L228:
	cmpb $55,%cl
	ja L199
L225:
	leaq 2(%rdx),%rcx
	movq %rcx,-8(%rbp)
	movzbl 1(%rdx),%ecx
	leal (%rcx,%rax,8),%eax
	subl $48,%eax
	movb 2(%rdx),%cl
	cmpb $48,%cl
	jb L199
L235:
	cmpb $55,%cl
	ja L199
L232:
	leaq 3(%rdx),%rcx
	movq %rcx,-8(%rbp)
	movzbl 2(%rdx),%ecx
	leal (%rcx,%rax,8),%eax
	subl $48,%eax
L199:
	movq -8(%rbp),%rcx
	movq %rcx,(%rbx)
L196:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
L243:
	.quad 0
.align 4
L244:
	.int 100
.text

_cclenter:
L240:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L241:
	movq %rdi,%r14
	movq %r14,-8(%rbp)
	cmpq $0,L243(%rip)
	jnz L247
L248:
	movslq L244(%rip),%rdi
	call _malloc
	movq %rax,L243(%rip)
	testq %rax,%rax
	jnz L247
L245:
	pushq -8(%rbp)
	pushq $L252
	call _FATAL
	addq $16,%rsp
L247:
	movq L243(%rip),%rax
	movq %rax,-16(%rbp)
	xorl %r13d,%r13d
L253:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movzbl (%rcx),%ebx
	testl %ebx,%ebx
	jz L256
L254:
	cmpl $92,%ebx
	jnz L258
L257:
	leaq -8(%rbp),%rdi
	call _quoted
	movl %eax,%ebx
	jmp L259
L258:
	cmpl $45,%ebx
	jnz L259
L267:
	cmpl $0,%r13d
	jle L259
L263:
	movq -16(%rbp),%rax
	movb -1(%rax),%r12b
	testb %r12b,%r12b
	jz L259
L260:
	cmpb $0,1(%rcx)
	jz L259
L271:
	movzbl %r12b,%r12d
	leaq 2(%rcx),%rax
	movq %rax,-8(%rbp)
	movzbl 1(%rcx),%ebx
	cmpl $92,%ebx
	jnz L276
L274:
	leaq -8(%rbp),%rdi
	call _quoted
	movl %eax,%ebx
L276:
	cmpl %ebx,%r12d
	jg L277
L281:
	cmpl %ebx,%r12d
	jge L253
L282:
	movq L243(%rip),%rax
	movq -16(%rbp),%rdx
	subq %rax,%rdx
	movl $L287,%r9d
	leaq -16(%rbp),%r8
	movl $100,%ecx
	addl $2,%edx
	movl $L244,%esi
	movl $L243,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L286
L284:
	pushq -8(%rbp)
	pushq $L288
	call _FATAL
	addq $16,%rsp
L286:
	incl %r12d
	movb %r12b,%cl
	movq -16(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-16(%rbp)
	movb %cl,(%rdx)
	incl %r13d
	jmp L281
L277:
	decq -16(%rbp)
	decl %r13d
	jmp L253
L259:
	movq L243(%rip),%rax
	movq -16(%rbp),%rdx
	subq %rax,%rdx
	movl $L293,%r9d
	leaq -16(%rbp),%r8
	movl $100,%ecx
	addl $2,%edx
	movl $L244,%esi
	movl $L243,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L292
L290:
	pushq -8(%rbp)
	pushq $L294
	call _FATAL
	addq $16,%rsp
L292:
	movq -16(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-16(%rbp)
	movb %bl,(%rcx)
	incl %r13d
	jmp L253
L256:
	movq -16(%rbp),%rax
	movb $0,(%rax)
	cmpl $0,_dbg(%rip)
	jz L297
L295:
	pushq L243(%rip)
	pushq %r14
	pushq $L298
	call _printf
	addq $24,%rsp
L297:
	testq %r14,%r14
	jz L301
L299:
	movq %r14,%rdi
	call _free
L301:
	movq L243(%rip),%rdi
	call _tostring
L242:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_overflo:
L303:
L304:
	pushq %rdi
	pushq $L306
	call _FATAL
	addq $16,%rsp
L305:
	ret 

.align 2
L362:
	.short L319-_cfoll
	.short L319-_cfoll
	.short L319-_cfoll
	.short L319-_cfoll
	.short L319-_cfoll
	.short L319-_cfoll
	.short L352-_cfoll
	.short L349-_cfoll
	.short L349-_cfoll
	.short L349-_cfoll
	.short L319-_cfoll

_cfoll:
L307:
	pushq %rbx
	pushq %r12
	pushq %r13
L308:
	movq %rdi,%r13
	movq %rsi,%r12
	movl 20(%r12),%ecx
	cmpl $268,%ecx
	jl L356
L358:
	cmpl $278,%ecx
	jg L356
L355:
	leal -268(%rcx),%eax
	movzwl L362(,%rax,2),%eax
	addl $_cfoll,%eax
	jmp *%rax
L349:
	movq 24(%r12),%rsi
	jmp L363
L319:
	movslq %ecx,%rcx
	movslq (%r12),%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %rcx,8608(%r13,%rax)
	movq 32(%r12),%rcx
	movslq (%r12),%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %rcx,8616(%r13,%rax)
L320:
	movl 8600(%r13),%eax
	movl _maxsetvec(%rip),%esi
	cmpl %esi,%eax
	jl L322
L321:
	shll $2,%esi
	movl %esi,_maxsetvec(%rip)
	movslq %esi,%rsi
	shlq $2,%rsi
	movq _setvec(%rip),%rdi
	call _realloc
	movq %rax,_setvec(%rip)
	movslq _maxsetvec(%rip),%rsi
	shlq $2,%rsi
	movq _tmpset(%rip),%rdi
	call _realloc
	movq %rax,_tmpset(%rip)
	cmpq $0,_setvec(%rip)
	jz L327
L326:
	testq %rax,%rax
	jnz L320
L327:
	movl $L330,%edi
	call _overflo
	jmp L320
L322:
	xorl %eax,%eax
	jmp L331
L332:
	movq _setvec(%rip),%rcx
	movl $0,(%rcx,%rax,4)
	incl %eax
L331:
	cmpl 8600(%r13),%eax
	jle L332
L334:
	movl $0,_setcnt(%rip)
	movq %r12,%rdi
	call _follow
	movl _setcnt(%rip),%esi
	incl %esi
	movslq %esi,%rsi
	shlq $2,%rsi
	movl $1,%edi
	call _calloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L337
L335:
	movl $L338,%edi
	call _overflo
L337:
	movslq (%r12),%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %rbx,8624(%r13,%rax)
	movl _setcnt(%rip),%eax
	movl %eax,(%rbx)
	movl 8600(%r13),%ecx
L339:
	cmpl $0,%ecx
	jl L309
L340:
	movslq %ecx,%rcx
	movq _setvec(%rip),%rax
	cmpl $1,(%rax,%rcx,4)
	jnz L345
L343:
	leaq 4(%rbx),%rax
	movl %ecx,4(%rbx)
	movq %rax,%rbx
L345:
	decl %ecx
	jmp L339
L356:
	cmpl $342,%ecx
	jz L352
L310:
	pushq %rcx
	pushq $L354
	call _FATAL
	addq $16,%rsp
	jmp L309
L352:
	movq 24(%r12),%rsi
	movq %r13,%rdi
	call _cfoll
	movq 32(%r12),%rsi
L363:
	movq %r13,%rdi
	call _cfoll
L309:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L448:
	.short L376-_first
	.short L376-_first
	.short L376-_first
	.short L376-_first
	.short L376-_first
	.short L376-_first
	.short L427-_first
	.short L415-_first
	.short L415-_first
	.short L408-_first
	.short L376-_first

_first:
L364:
	pushq %rbx
	pushq %r12
L365:
	movq %rdi,%rbx
	movl 20(%rbx),%ecx
	cmpl $268,%ecx
	jl L442
L444:
	cmpl $278,%ecx
	jg L442
L441:
	leal -268(%rcx),%eax
	movzwl L448(,%rax,2),%eax
	addl $_first,%eax
	jmp *%rax
L408:
	movq 24(%rbx),%rdi
	call _first
	testl %eax,%eax
	jz L439
	jnz L440
L415:
	movq 24(%rbx),%rdi
	call _first
	jmp L439
L427:
	movq 32(%rbx),%rdi
	call _first
	movl %eax,%r12d
	movq 24(%rbx),%rdi
	call _first
	testl %eax,%eax
	jz L439
L431:
	testl %r12d,%r12d
	jnz L440
	jz L439
L376:
	movl (%rbx),%r12d
L377:
	movl _setcnt(%rip),%eax
	movl _maxsetvec(%rip),%esi
	cmpl %esi,%eax
	jge L378
L380:
	cmpl %esi,%r12d
	jl L379
L378:
	shll $2,%esi
	movl %esi,_maxsetvec(%rip)
	movslq %esi,%rsi
	shlq $2,%rsi
	movq _setvec(%rip),%rdi
	call _realloc
	movq %rax,_setvec(%rip)
	movslq _maxsetvec(%rip),%rsi
	shlq $2,%rsi
	movq _tmpset(%rip),%rdi
	call _realloc
	movq %rax,_tmpset(%rip)
	cmpq $0,_setvec(%rip)
	jz L384
L387:
	testq %rax,%rax
	jnz L377
L384:
	movl $L391,%edi
	call _overflo
	jmp L377
L379:
	movl 20(%rbx),%ecx
	movq _setvec(%rip),%rax
	movslq %r12d,%r12
	cmpl $278,%ecx
	jz L392
L394:
	cmpl $1,(%rax,%r12,4)
	jz L398
L396:
	movl $1,(%rax,%r12,4)
	incl _setcnt(%rip)
L398:
	cmpl $271,20(%rbx)
	jnz L440
L402:
	movq 32(%rbx),%rax
	cmpb $0,(%rax)
	jnz L440
	jz L439
L392:
	movl $0,(%rax,%r12,4)
	jmp L439
L442:
	cmpl $342,%ecx
	jz L417
L368:
	pushq %rcx
	pushq $L437
	call _FATAL
	addq $16,%rsp
	movl $-1,%eax
	jmp L366
L417:
	movq 24(%rbx),%rdi
	call _first
	testl %eax,%eax
	jnz L440
L421:
	movq 32(%rbx),%rdi
	call _first
	testl %eax,%eax
	jnz L440
L439:
	xorl %eax,%eax
	jmp L366
L440:
	movl $1,%eax
L366:
	popq %r12
	popq %rbx
	ret 


_follow:
L449:
	pushq %rbx
L450:
	cmpl $268,20(%rdi)
	jz L451
L454:
	movq 8(%rdi),%rbx
	movl 20(%rbx),%eax
	cmpl $274,%eax
	jz L474
	jl L451
L476:
	cmpl $342,%eax
	jz L465
	jg L451
L477:
	cmpw $275,%ax
	jz L460
L478:
	cmpw $276,%ax
	jz L474
L479:
	cmpw $277,%ax
	jnz L451
L460:
	call _first
	jmp L474
L465:
	cmpq 24(%rbx),%rdi
	jnz L474
L466:
	movq 32(%rbx),%rdi
	call _first
	testl %eax,%eax
	jnz L451
L474:
	movq %rbx,%rdi
	call _follow
L451:
	popq %rbx
	ret 


_member:
L482:
L485:
	movb (%rsi),%al
	testb %al,%al
	jz L487
L486:
	movzbl %al,%eax
	incq %rsi
	cmpl %eax,%edi
	jnz L485
L488:
	movl $1,%eax
	ret
L487:
	xorl %eax,%eax
L484:
	ret 


_match:
L493:
	pushq %rbx
	pushq %r12
L494:
	movq %rdi,%r12
	movq %rsi,%rbx
	cmpl $0,8604(%r12)
	jz L497
L496:
	xorl %esi,%esi
	movq %r12,%rdi
	call _makeinit
	movl %eax,%esi
	jmp L498
L497:
	movl 8592(%r12),%esi
L498:
	movslq %esi,%rax
	cmpb $0,8288(%r12,%rax)
	jnz L514
L503:
	movslq %esi,%rcx
	movb (%rbx),%dl
	movzbq %dl,%rax
	imulq $259,%rcx,%rcx
	addq %r12,%rcx
	movzbl (%rax,%rcx),%eax
	testl %eax,%eax
	jnz L515
L507:
	movzbl %dl,%edx
	movq %r12,%rdi
	call _cgoto
L515:
	movl %eax,%esi
	movslq %esi,%rax
	cmpb $0,8288(%r12,%rax)
	jnz L514
L511:
	movb (%rbx),%al
	incq %rbx
	testb %al,%al
	jnz L503
L504:
	xorl %eax,%eax
	jmp L495
L514:
	movl $1,%eax
L495:
	popq %r12
	popq %rbx
	ret 


_pmatch:
L516:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L517:
	movq %rdi,%r14
	movq %rsi,%r13
	cmpl $0,8604(%r14)
	jz L520
L519:
	movl $1,%esi
	movq %r14,%rdi
	call _makeinit
	movl %eax,%r12d
	movl %eax,8592(%r14)
	jmp L521
L520:
	movl 8592(%r14),%r12d
L521:
	movq %r13,_patbeg(%rip)
	movl $-1,_patlen(%rip)
L522:
	movq %r13,%rbx
L525:
	movslq %r12d,%r12
	cmpb $0,8288(%r14,%r12)
	jz L530
L528:
	movq %rbx,%rax
	subq %r13,%rax
	movl %eax,_patlen(%rip)
L530:
	movb (%rbx),%dl
	movzbq %dl,%rax
	imulq $259,%r12,%rcx
	addq %r14,%rcx
	movzbl (%rax,%rcx),%eax
	testl %eax,%eax
	jnz L574
L532:
	movzbl %dl,%edx
	movl %r12d,%esi
	movq %r14,%rdi
	call _cgoto
L574:
	movl %eax,%r12d
	cmpl $1,%r12d
	jz L534
L536:
	movb (%rbx),%al
	incq %rbx
	testb %al,%al
	jnz L525
L526:
	movslq %r12d,%rax
	cmpb $0,8288(%r14,%rax)
	jz L545
L543:
	subq %r13,%rbx
	decl %ebx
	movl %ebx,_patlen(%rip)
L545:
	cmpl $0,_patlen(%rip)
	jl L541
	jge L573
L534:
	cmpl $0,_patlen(%rip)
	jge L573
L541:
	movl $2,%r12d
	cmpl $0,8604(%r14)
	jz L552
L550:
	movl $2,%ebx
	jmp L553
L554:
	movq 8328(%r14,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L559
L557:
	call _free
	movq $0,8328(%r14,%rbx,8)
L559:
	incl %ebx
L553:
	cmpl 8596(%r14),%ebx
	jle L554
L556:
	movq 8328(%r14),%rax
	movl (%rax),%ebx
	leal 1(%rbx),%esi
	movslq %esi,%rsi
	shlq $2,%rsi
	movl $1,%edi
	call _calloc
	movq %rax,8344(%r14)
	testq %rax,%rax
	jnz L562
L560:
	movl $L563,%edi
	call _overflo
L562:
	xorl %edx,%edx
	jmp L564
L565:
	movq 8328(%r14),%rax
	movl (%rax,%rdx,4),%ecx
	movq 8344(%r14),%rax
	movl %ecx,(%rax,%rdx,4)
	incl %edx
L564:
	cmpl %ebx,%edx
	jle L565
L567:
	movl $2,8596(%r14)
	movl $2,8592(%r14)
	movb 8288(%r14),%al
	movb %al,8290(%r14)
	xorl %eax,%eax
L569:
	movb $0,518(%r14,%rax)
	incl %eax
	cmpl $259,%eax
	jl L569
L552:
	movb (%r13),%al
	incq %r13
	testb %al,%al
	jnz L522
L523:
	xorl %eax,%eax
	jmp L518
L573:
	movq %r13,_patbeg(%rip)
	movl $1,%eax
L518:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_nematch:
L575:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L576:
	movq %rdi,%r14
	movq %rsi,%r13
	cmpl $0,8604(%r14)
	jz L579
L578:
	movl $1,%esi
	movq %r14,%rdi
	call _makeinit
	movl %eax,%r12d
	movl %eax,8592(%r14)
	jmp L580
L579:
	movl 8592(%r14),%r12d
L580:
	movl $-1,_patlen(%rip)
L581:
	cmpb $0,(%r13)
	jz L583
L582:
	movq %r13,%rbx
L584:
	movslq %r12d,%r12
	cmpb $0,8288(%r14,%r12)
	jz L589
L587:
	movq %rbx,%rax
	subq %r13,%rax
	movl %eax,_patlen(%rip)
L589:
	movb (%rbx),%dl
	movzbq %dl,%rax
	imulq $259,%r12,%rcx
	addq %r14,%rcx
	movzbl (%rax,%rcx),%eax
	testl %eax,%eax
	jnz L633
L591:
	movzbl %dl,%edx
	movl %r12d,%esi
	movq %r14,%rdi
	call _cgoto
L633:
	movl %eax,%r12d
	cmpl $1,%r12d
	jz L593
L595:
	movb (%rbx),%al
	incq %rbx
	testb %al,%al
	jnz L584
L585:
	movslq %r12d,%rax
	cmpb $0,8288(%r14,%rax)
	jz L604
L602:
	subq %r13,%rbx
	decl %ebx
	movl %ebx,_patlen(%rip)
L604:
	cmpl $0,_patlen(%rip)
	jle L600
	jg L632
L593:
	cmpl $0,_patlen(%rip)
	jg L632
L600:
	movl $2,%r12d
	cmpl $0,8604(%r14)
	jz L611
L609:
	movl $2,%ebx
	jmp L612
L613:
	movq 8328(%r14,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L618
L616:
	call _free
	movq $0,8328(%r14,%rbx,8)
L618:
	incl %ebx
L612:
	cmpl 8596(%r14),%ebx
	jle L613
L615:
	movq 8328(%r14),%rax
	movl (%rax),%ebx
	leal 1(%rbx),%esi
	movslq %esi,%rsi
	shlq $2,%rsi
	movl $1,%edi
	call _calloc
	movq %rax,8344(%r14)
	testq %rax,%rax
	jnz L621
L619:
	movl $L622,%edi
	call _overflo
L621:
	xorl %edx,%edx
	jmp L623
L624:
	movq 8328(%r14),%rax
	movl (%rax,%rdx,4),%ecx
	movq 8344(%r14),%rax
	movl %ecx,(%rax,%rdx,4)
	incl %edx
L623:
	cmpl %ebx,%edx
	jle L624
L626:
	movl $2,8596(%r14)
	movl $2,8592(%r14)
	movb 8288(%r14),%al
	movb %al,8290(%r14)
	xorl %eax,%eax
L628:
	movb $0,518(%r14,%rax)
	incl %eax
	cmpl $259,%eax
	jl L628
L611:
	incq %r13
	jmp L581
L632:
	movq %r13,_patbeg(%rip)
	movl $1,%eax
	jmp L577
L583:
	xorl %eax,%eax
L577:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reparse:
L634:
	pushq %rbx
L635:
	movq %rdi,%rbx
	cmpl $0,_dbg(%rip)
	jz L639
L637:
	pushq %rbx
	pushq $L640
	call _printf
	addq $16,%rsp
L639:
	movq %rbx,_prestr(%rip)
	movq %rbx,_lastre(%rip)
	call _relex
	movl %eax,_rtok(%rip)
	testl %eax,%eax
	jz L641
L643:
	call _regexp
	movq %rax,%rbx
	cmpl $0,_rtok(%rip)
	jz L647
L645:
	pushq _prestr(%rip)
	pushq _lastre(%rip)
	pushq $L648
	call _FATAL
	addq $24,%rsp
L647:
	movq %rbx,%rax
	jmp L636
L641:
	xorl %edx,%edx
	xorl %esi,%esi
	movl $278,%edi
	call _op2
L636:
	popq %rbx
	ret 


_regexp:
L650:
L651:
	call _primary
	movq %rax,%rdi
	call _concat
	movq %rax,%rdi
	call _alt
L652:
	ret 

.align 2
L697:
	.short L666-_primary
	.short L662-_primary
	.short L668-_primary
	.short L670-_primary
	.short L660-_primary
	.short L657-_primary
	.short L657-_primary
	.short L657-_primary
	.short L657-_primary
	.short L664-_primary

_primary:
L654:
	pushq %rbx
L655:
	movl _rtok(%rip),%eax
	cmpl $269,%eax
	jl L689
L691:
	cmpl $278,%eax
	jg L689
L688:
	addl $-269,%eax
	movzwl L697(,%rax,2),%eax
	addl $_primary,%eax
	jmp *%rax
L664:
	jmp L702
L660:
	movl _rlxval(%rip),%edi
	call _itonp
	movq %rax,%rdx
	xorl %esi,%esi
	movl $273,%edi
	jmp L700
L670:
	movq _rlxstr(%rip),%rdi
	call _cclenter
	movq %rax,%rdx
	xorl %esi,%esi
	movl $272,%edi
	jmp L700
L668:
	movq _rlxstr(%rip),%rdi
	call _cclenter
	movq %rax,%rdx
	xorl %esi,%esi
	movl $271,%edi
L700:
	call _op2
	movq %rax,%rbx
	jmp L699
L662:
L702:
	call _relex
	movl %eax,_rtok(%rip)
	xorl %edx,%edx
	xorl %esi,%esi
	movl $270,%edi
	jmp L701
L666:
	call _relex
	movl %eax,_rtok(%rip)
	xorl %edx,%edx
	xorl %esi,%esi
	movl $269,%edi
	jmp L701
L689:
	cmpl $36,%eax
	jz L674
L693:
	cmpl $40,%eax
	jz L676
L694:
	cmpl $94,%eax
	jnz L657
L672:
	call _relex
	movl %eax,_rtok(%rip)
	movl $261,%edi
	call _itonp
	movq %rax,%rdx
	jmp L703
L676:
	call _relex
	movl %eax,_rtok(%rip)
	cmpl $41,%eax
	jz L677
L679:
	call _regexp
	movq %rax,%rbx
	cmpl $41,_rtok(%rip)
	jnz L683
L699:
	call _relex
	movl %eax,_rtok(%rip)
	movq %rbx,%rdi
	jmp L698
L683:
	pushq _prestr(%rip)
	pushq _lastre(%rip)
	pushq $L648
	call _FATAL
	addq $24,%rsp
L657:
	pushq _prestr(%rip)
	pushq _lastre(%rip)
	pushq $L686
	call _FATAL
	addq $24,%rsp
	xorl %eax,%eax
	jmp L656
L677:
	call _relex
	movl %eax,_rtok(%rip)
	movl $L680,%edi
	call _tostring
	movq %rax,%rdx
	xorl %esi,%esi
	movl $271,%edi
	jmp L701
L674:
	call _relex
	movl %eax,_rtok(%rip)
	xorl %edx,%edx
L703:
	xorl %esi,%esi
	movl $273,%edi
L701:
	call _op2
	movq %rax,%rdi
L698:
	call _unary
L656:
	popq %rbx
	ret 

.align 2
L728:
	.short L717-_concat
	.short L717-_concat
	.short L717-_concat
	.short L717-_concat
	.short L717-_concat
	.short L708-_concat
	.short L708-_concat
	.short L708-_concat
	.short L708-_concat
	.short L717-_concat

_concat:
L704:
	pushq %rbx
L705:
	movl _rtok(%rip),%eax
	movq %rdi,%rbx
	cmpl $269,%eax
	jl L721
L723:
	cmpl $278,%eax
	jg L721
L720:
	addl $-269,%eax
	movzwl L728(,%rax,2),%eax
	addl $_concat,%eax
	jmp *%rax
L721:
	cmpl $36,%eax
	jz L717
L725:
	cmpl $40,%eax
	jz L717
L708:
	movq %rbx,%rax
	jmp L706
L717:
	call _primary
	movq %rax,%rdx
	movq %rbx,%rsi
	movl $342,%edi
	call _op2
	movq %rax,%rdi
	call _concat
L706:
	popq %rbx
	ret 


_alt:
L729:
	pushq %rbx
L730:
	movq %rdi,%rbx
	cmpl $274,_rtok(%rip)
	jz L732
L734:
	movq %rbx,%rax
	jmp L731
L732:
	call _relex
	movl %eax,_rtok(%rip)
	call _primary
	movq %rax,%rdi
	call _concat
	movq %rax,%rdx
	movq %rbx,%rsi
	movl $274,%edi
	call _op2
	movq %rax,%rdi
	call _alt
L731:
	popq %rbx
	ret 


_unary:
L737:
	pushq %rbx
L738:
	movl _rtok(%rip),%eax
	movq %rdi,%rbx
	cmpl $275,%eax
	jz L743
L751:
	cmpl $277,%eax
	jz L745
L752:
	cmpl $276,%eax
	jz L747
L753:
	movq %rbx,%rax
	jmp L739
L747:
	call _relex
	movl %eax,_rtok(%rip)
	xorl %edx,%edx
	movq %rbx,%rsi
	movl $276,%edi
	jmp L755
L745:
	call _relex
	movl %eax,_rtok(%rip)
	xorl %edx,%edx
	movq %rbx,%rsi
	movl $277,%edi
	jmp L755
L743:
	call _relex
	movl %eax,_rtok(%rip)
	xorl %edx,%edx
	movq %rbx,%rsi
	movl $275,%edi
L755:
	call _op2
	movq %rax,%rdi
	call _unary
L739:
	popq %rbx
	ret 


_xisblank:
L756:
L757:
	cmpl $32,%edi
	jz L760
L759:
	cmpl $9,%edi
	jnz L761
L760:
	movl $1,%eax
	ret
L761:
	xorl %eax,%eax
L758:
	ret 

.data
.align 8
_charclasses:
	.quad L764
	.int 5
	.fill 4, 1, 0
	.quad _isalnum
	.quad L765
	.int 5
	.fill 4, 1, 0
	.quad _isalpha
	.quad L766
	.int 5
	.fill 4, 1, 0
	.quad _isspace
	.quad L767
	.int 5
	.fill 4, 1, 0
	.quad _iscntrl
	.quad L768
	.int 5
	.fill 4, 1, 0
	.quad _isdigit
	.quad L769
	.int 5
	.fill 4, 1, 0
	.quad _isgraph
	.quad L770
	.int 5
	.fill 4, 1, 0
	.quad _islower
	.quad L771
	.int 5
	.fill 4, 1, 0
	.quad _isprint
	.quad L772
	.int 5
	.fill 4, 1, 0
	.quad _ispunct
	.quad L773
	.int 5
	.fill 4, 1, 0
	.quad _isspace
	.quad L774
	.int 5
	.fill 4, 1, 0
	.quad _isupper
	.quad L775
	.int 6
	.fill 4, 1, 0
	.quad _isxdigit
	.quad 0
	.int 0
	.fill 4, 1, 0
	.quad 0
.align 8
L779:
	.quad 0
.align 4
L780:
	.int 100
.text
.align 2
L898:
	.short L799-_relex
	.short L799-_relex
	.short L786-_relex
	.short L788-_relex
	.short L781-_relex
	.short L781-_relex
	.short L792-_relex

_relex:
L776:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L777:
	movq _prestr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_prestr(%rip)
	movzbl (%rcx),%eax
	cmpl $40,%eax
	jl L886
L888:
	cmpl $46,%eax
	jg L886
L885:
	leal -40(%rax),%ecx
	movzwl L898(,%rcx,2),%ecx
	addl $_relex,%ecx
	jmp *%rcx
L792:
	movl $269,%eax
	jmp L778
L788:
	movl $277,%eax
	jmp L778
L786:
	movl $275,%eax
	jmp L778
L886:
	cmpl $0,%eax
	jz L794
	jl L781
L890:
	cmpl $124,%eax
	jz L784
	jg L781
L891:
	cmpb $36,%al
	jz L799
L892:
	cmpb $63,%al
	jz L790
L893:
	cmpb $91,%al
	jz L804
L894:
	cmpb $92,%al
	jz L801
L895:
	cmpb $94,%al
	jz L799
	jnz L781
L801:
	movl $_prestr,%edi
	call _quoted
	jmp L902
L804:
	cmpq $0,L779(%rip)
	jnz L807
L808:
	movslq L780(%rip),%rdi
	call _malloc
	movq %rax,L779(%rip)
	testq %rax,%rax
	jnz L807
L805:
	pushq _lastre(%rip)
	pushq $L812
	call _FATAL
	addq $16,%rsp
L807:
	movq L779(%rip),%rax
	movq %rax,-8(%rbp)
	movq _prestr(%rip),%rax
	cmpb $94,(%rax)
	jnz L814
L813:
	movl $1,%r14d
	incq %rax
	movq %rax,_prestr(%rip)
	jmp L815
L814:
	xorl %r14d,%r14d
L815:
	movq _prestr(%rip),%rdi
	call _strlen
	leal 1(,%rax,2),%r13d
	movl $L819,%r9d
	leaq -8(%rbp),%r8
	leal 1(,%rax,2),%ecx
	leal 1(,%rax,2),%edx
	movl $L780,%esi
	movl $L779,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L821
L816:
	pushq _lastre(%rip)
	pushq $L820
L899:
	call _FATAL
	addq $16,%rsp
L821:
	movq _prestr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_prestr(%rip)
	movzbl (%rcx),%ebx
	cmpl $92,%ebx
	jnz L826
L825:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $92,(%rcx)
	movq _prestr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_prestr(%rip)
	movzbl (%rcx),%ebx
	testl %ebx,%ebx
	jnz L901
L828:
	pushq _lastre(%rip)
	pushq $L831
	call _FATAL
	addq $16,%rsp
	jmp L901
L826:
	cmpl $91,%ebx
	jnz L833
L835:
	cmpb $58,1(%rcx)
	jnz L833
L832:
	movl $_charclasses,%r12d
	jmp L839
L840:
	movq _prestr(%rip),%rdi
	movslq 8(%r12),%rdx
	incq %rdi
	call _strncmp
	testl %eax,%eax
	jz L842
L845:
	addq $24,%r12
L839:
	movq (%r12),%rsi
	testq %rsi,%rsi
	jnz L840
L842:
	cmpq $0,(%r12)
	jz L901
L854:
	movl 8(%r12),%eax
	leal 1(%rax),%ecx
	movslq %ecx,%rcx
	movq _prestr(%rip),%rdx
	cmpb $58,(%rcx,%rdx)
	jnz L901
L850:
	leal 2(%rax),%ecx
	movslq %ecx,%rcx
	cmpb $93,(%rdx,%rcx)
	jz L847
L901:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	jmp L900
L847:
	addl $3,%eax
	movslq %eax,%rax
	addq %rax,%rdx
	movq %rdx,_prestr(%rip)
	xorl %ebx,%ebx
L859:
	movq L779(%rip),%rax
	movq -8(%rbp),%rdx
	subq %rax,%rdx
	movl $L865,%r9d
	leaq -8(%rbp),%r8
	movl $100,%ecx
	incl %edx
	movl $L780,%esi
	movl $L779,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L864
L862:
	pushq _lastre(%rip)
	pushq $L820
	call _FATAL
	addq $16,%rsp
L864:
	movq 16(%r12),%rax
	movl %ebx,%edi
	call *%rax
	testl %eax,%eax
	jz L868
L866:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb %bl,(%rcx)
	incl %r13d
L868:
	incl %ebx
	cmpl $259,%ebx
	jl L859
	jge L821
L833:
	testl %ebx,%ebx
	jz L869
L870:
	movq L779(%rip),%rdx
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	cmpq %rcx,%rdx
	jz L900
L874:
	cmpl $93,%ebx
	jz L876
L900:
	movq %rax,-8(%rbp)
	movb %bl,(%rcx)
	jmp L821
L876:
	movq %rax,-8(%rbp)
	movb $0,(%rcx)
	movq L779(%rip),%rdi
	call _tostring
	movq %rax,_rlxstr(%rip)
	testl %r14d,%r14d
	movl $272,%ecx
	movl $271,%eax
	cmovnzl %ecx,%eax
	jmp L778
L869:
	pushq _lastre(%rip)
	pushq $L872
	jmp L899
L790:
	movl $276,%eax
	jmp L778
L799:
	jmp L778
L784:
	movl $274,%eax
	jmp L778
L781:
L902:
	movl %eax,_rlxval(%rip)
	movl $273,%eax
	jmp L778
L794:
	movq %rcx,_prestr(%rip)
	xorl %eax,%eax
L778:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cgoto:
L903:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L904:
	movq %rdi,-32(%rbp) # spill
	movq %rsi,-8(%rbp) # spill
	movl %edx,%r13d
	cmpl $261,%r13d
	jz L915
L909:
	cmpl $259,%r13d
	jl L915
L911:
	movl $864,%edx
	movl $L914,%esi
	movl $L913,%edi
	call ___assert
L915:
	movq -32(%rbp),%rax # spill
	movl 8600(%rax),%eax
	movl _maxsetvec(%rip),%esi
	cmpl %esi,%eax
	jl L917
L916:
	shll $2,%esi
	movl %esi,_maxsetvec(%rip)
	movslq %esi,%rsi
	shlq $2,%rsi
	movq _setvec(%rip),%rdi
	call _realloc
	movq %rax,_setvec(%rip)
	movslq _maxsetvec(%rip),%rsi
	shlq $2,%rsi
	movq _tmpset(%rip),%rdi
	call _realloc
	movq %rax,_tmpset(%rip)
	cmpq $0,_setvec(%rip)
	jz L922
L921:
	testq %rax,%rax
	jnz L915
L922:
	movl $L925,%edi
	call _overflo
	jmp L915
L917:
	xorl %ecx,%ecx
	jmp L926
L927:
	movq _setvec(%rip),%rax
	movl $0,(%rax,%rcx,4)
	incl %ecx
L926:
	movq -32(%rbp),%rax # spill
	cmpl 8600(%rax),%ecx
	jle L927
L929:
	movl $0,_setcnt(%rip)
	movslq -8(%rbp),%rcx # spill
	movq -32(%rbp),%rax # spill
	movq 8328(%rax,%rcx,8),%r12
	movl $1,%ebx
	jmp L930
L931:
	movslq (%r12,%rbx,4),%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -32(%rbp),%rax # spill
	movl 8608(%rax,%rcx),%r14d
	cmpl $268,%r14d
	jz L936
L934:
	cmpl $273,%r14d
	jnz L962
L960:
	movq -32(%rbp),%rax # spill
	movq 8616(%rcx,%rax),%rdi
	call _ptoi
	cmpl %eax,%r13d
	jz L941
L962:
	cmpl $269,%r14d
	jnz L966
L968:
	testl %r13d,%r13d
	jz L966
L969:
	cmpl $261,%r13d
	jnz L941
L966:
	cmpl $270,%r14d
	jnz L974
L972:
	testl %r13d,%r13d
	jnz L941
L974:
	cmpl $278,%r14d
	jnz L978
L976:
	testl %r13d,%r13d
	jnz L941
L978:
	cmpl $271,%r14d
	jnz L982
L980:
	movslq (%r12,%rbx,4),%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -32(%rbp),%rax # spill
	movq 8616(%rax,%rcx),%rsi
	movl %r13d,%edi
	call _member
	testl %eax,%eax
	jnz L941
L982:
	cmpl $272,%r14d
	jnz L936
L992:
	movslq (%r12,%rbx,4),%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -32(%rbp),%rax # spill
	movq 8616(%rax,%rcx),%rsi
	movl %r13d,%edi
	call _member
	testl %eax,%eax
	jnz L936
L993:
	testl %r13d,%r13d
	jz L936
L989:
	cmpl $261,%r13d
	jz L936
L941:
	movslq (%r12,%rbx,4),%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -32(%rbp),%rax # spill
	movq 8624(%rax,%rcx),%r15
	movl $1,%r14d
L996:
	cmpl (%r15),%r14d
	jg L936
L997:
	movl (%r15,%r14,4),%eax
	movl _maxsetvec(%rip),%esi
	cmpl %eax,%esi
	jg L1002
L1000:
	shll $2,%esi
	movl %esi,_maxsetvec(%rip)
	movslq %esi,%rsi
	shlq $2,%rsi
	movq _setvec(%rip),%rdi
	call _realloc
	movq %rax,_setvec(%rip)
	movslq _maxsetvec(%rip),%rsi
	shlq $2,%rsi
	movq _tmpset(%rip),%rdi
	call _realloc
	movq %rax,_tmpset(%rip)
	cmpq $0,_setvec(%rip)
	jz L1007
L1006:
	testq %rax,%rax
	jnz L1002
L1007:
	movl $L1010,%edi
	call _overflo
L1002:
	movslq (%r15,%r14,4),%rax
	movq _setvec(%rip),%rcx
	cmpl $0,(%rcx,%rax,4)
	jnz L1013
L1011:
	incl _setcnt(%rip)
	movslq (%r15,%r14,4),%rax
	movl $1,(%rcx,%rax,4)
L1013:
	incl %r14d
	jmp L996
L936:
	incl %ebx
L930:
	cmpl (%r12),%ebx
	jle L931
L933:
	movq _tmpset(%rip),%rcx
	movl _setcnt(%rip),%eax
	movl %eax,(%rcx)
	movl $1,%edx
	movq -32(%rbp),%rax # spill
	movl 8600(%rax),%ecx
	jmp L1014
L1015:
	movslq %ecx,%rcx
	movq _setvec(%rip),%rax
	cmpl $0,(%rax,%rcx,4)
	jz L1020
L1018:
	movl %edx,%eax
	incl %edx
	movq _tmpset(%rip),%rsi
	movl %ecx,(%rsi,%rax,4)
L1020:
	decl %ecx
L1014:
	cmpl $0,%ecx
	jge L1015
L1017:
	movl $1,%eax
L1021:
	movq -32(%rbp),%rcx # spill
	movl 8596(%rcx),%ecx
	cmpl %ecx,%eax
	jg L1024
L1022:
	movl %eax,%edx
	movq -32(%rbp),%rcx # spill
	movq 8328(%rcx,%rdx,8),%rdi
	movq _tmpset(%rip),%rcx
	movl (%rcx),%esi
	cmpl (%rdi),%esi
	jnz L1028
L1027:
	movl $1,%edx
L1030:
	cmpl %esi,%edx
	jg L1033
L1031:
	movq _tmpset(%rip),%rcx
	movl (%rcx,%rdx,4),%ecx
	cmpl (%rdi,%rdx,4),%ecx
	jnz L1028
L1036:
	incl %edx
	jmp L1030
L1028:
	incl %eax
	jmp L1021
L1033:
	movslq -8(%rbp),%rcx # spill
	imulq $259,%rcx,%rdx
	addq -32(%rbp),%rdx # spill
	movslq %r13d,%rcx
	movb %al,(%rdx,%rcx)
	jmp L905
L1024:
	cmpl $31,%ecx
	jl L1040
L1039:
	movq -32(%rbp),%rax # spill
	movl $2,8596(%rax)
	movl $1,8604(%rax)
	movl $2,%ebx
L1043:
	movq -32(%rbp),%rax # spill
	movq 8328(%rax,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L1048
L1046:
	call _free
	movq -32(%rbp),%rax # spill
	movq $0,8328(%rax,%rbx,8)
L1048:
	incl %ebx
	cmpl $32,%ebx
	jl L1043
	jge L1041
L1040:
	incl %ecx
	movq -32(%rbp),%rax # spill
	movl %ecx,8596(%rax)
L1041:
	xorl %ecx,%ecx
L1050:
	movq -32(%rbp),%rax # spill
	movslq 8596(%rax),%rax
	imulq $259,%rax,%rax
	addq -32(%rbp),%rax # spill
	movb $0,(%rax,%rcx)
	incl %ecx
	cmpl $259,%ecx
	jl L1050
L1052:
	movq -32(%rbp),%rax # spill
	movslq 8596(%rax),%rcx
	movq 8328(%rax,%rcx,8),%rdi
	testq %rdi,%rdi
	jz L1055
L1053:
	call _free
	movq -32(%rbp),%rax # spill
	movslq 8596(%rax),%rcx
	movq $0,8328(%rax,%rcx,8)
L1055:
	movl _setcnt(%rip),%esi
	incl %esi
	movslq %esi,%rsi
	shlq $2,%rsi
	movl $1,%edi
	call _calloc
	testq %rax,%rax
	movq %rax,-16(%rbp) # spill
	jnz L1058
L1056:
	movl $L1059,%edi
	call _overflo
L1058:
	movq -32(%rbp),%rax # spill
	movslq 8596(%rax),%rdx
	movq -16(%rbp),%rcx # spill
	movq -32(%rbp),%rax # spill
	movq %rcx,8328(%rax,%rdx,8)
	movb 8596(%rax),%al
	movb %al,-17(%rbp) # spill
	movslq -8(%rbp),%rax # spill
	imulq $259,%rax,%rcx
	movq %rax,-8(%rbp) # spill
	addq -32(%rbp),%rcx # spill
	movslq %r13d,%r13
	movb -17(%rbp),%al # spill
	movb %al,(%rcx,%r13)
	xorl %edx,%edx
	jmp L1060
L1061:
	movq _tmpset(%rip),%rax
	movl (%rax,%rdx,4),%ecx
	movq -16(%rbp),%rax # spill
	movl %ecx,(%rax,%rdx,4)
	incl %edx
L1060:
	cmpl _setcnt(%rip),%edx
	jle L1061
L1063:
	movq -32(%rbp),%rax # spill
	movslq 8600(%rax),%rdx
	movq _setvec(%rip),%rsi
	movq -32(%rbp),%rax # spill
	movslq 8596(%rax),%rcx
	cmpl $0,(%rsi,%rdx,4)
	jz L1065
L1064:
	movq -32(%rbp),%rax # spill
	movb $1,8288(%rax,%rcx)
	jmp L1066
L1065:
	movq -32(%rbp),%rax # spill
	movb $0,8288(%rax,%rcx)
L1066:
	movq -32(%rbp),%rax # spill
	movl 8596(%rax),%eax
L905:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_freefa:
L1068:
	pushq %rbx
	pushq %r12
	pushq %r13
L1069:
	movq %rdi,%r13
	testq %r13,%r13
	jz L1070
L1073:
	xorl %ebx,%ebx
	jmp L1075
L1076:
	movq 8328(%r13,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L1081
L1079:
	call _free
	movq $0,8328(%r13,%rbx,8)
L1081:
	incl %ebx
L1075:
	cmpl 8596(%r13),%ebx
	jle L1076
L1078:
	xorl %r12d,%r12d
	jmp L1082
L1083:
	leaq (%r12,%r12,2),%rbx
	shlq $3,%rbx
	movq 8624(%r13,%rbx),%rdi
	testq %rdi,%rdi
	jz L1088
L1086:
	call _free
	movq $0,8624(%r13,%rbx)
L1088:
	movq 8608(%rbx,%r13),%rax
	cmpq $271,%rax
	jz L1089
L1092:
	cmpq $272,%rax
	jnz L1091
L1089:
	movq 8616(%rbx,%r13),%rdi
	testq %rdi,%rdi
	jz L1091
L1096:
	call _free
	movq $0,8616(%rbx,%r13)
L1091:
	incl %r12d
L1082:
	cmpl 8600(%r13),%r12d
	jle L1083
L1085:
	movq 8320(%r13),%rdi
	testq %rdi,%rdi
	jz L1101
L1099:
	call _free
	movq $0,8320(%r13)
L1101:
	testq %r13,%r13
	jz L1070
L1102:
	movq %r13,%rdi
	call _free
L1070:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L680:
	.byte 0
L330:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 99,102,111,108,108,40,41,0
L831:
	.byte 110,111,110,116,101,114,109,105
	.byte 110,97,116,101,100,32,99,104
	.byte 97,114,97,99,116,101,114,32
	.byte 99,108,97,115,115,32,37,46
	.byte 50,48,115,46,46,46,0
L771:
	.byte 112,114,105,110,116,0
L622:
	.byte 111,117,116,32,111,102,32,115
	.byte 116,97,116,101,32,115,112,97
	.byte 99,101,0
L768:
	.byte 100,105,103,105,116,0
L648:
	.byte 115,121,110,116,97,120,32,101
	.byte 114,114,111,114,32,105,110,32
	.byte 114,101,103,117,108,97,114,32
	.byte 101,120,112,114,101,115,115,105
	.byte 111,110,32,37,115,32,97,116
	.byte 32,37,115,0
L686:
	.byte 105,108,108,101,103,97,108,32
	.byte 112,114,105,109,97,114,121,32
	.byte 105,110,32,114,101,103,117,108
	.byte 97,114,32,101,120,112,114,101
	.byte 115,115,105,111,110,32,37,115
	.byte 32,97,116,32,37,115,0
L69:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 109,97,107,101,105,110,105,116
	.byte 0
L294:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,99,104,97,114,97,99,116
	.byte 101,114,32,99,108,97,115,115
	.byte 32,91,37,46,49,48,115,46
	.byte 46,46,93,32,51,0
L288:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,99,104,97,114,97,99,116
	.byte 101,114,32,99,108,97,115,115
	.byte 32,91,37,46,49,48,115,46
	.byte 46,46,93,32,50,0
L774:
	.byte 117,112,112,101,114,0
L913:
	.byte 99,32,61,61,32,72,65,84
	.byte 32,124,124,32,99,32,60,32
	.byte 78,67,72,65,82,83,0
L767:
	.byte 99,110,116,114,108,0
L872:
	.byte 110,111,110,116,101,114,109,105
	.byte 110,97,116,101,100,32,99,104
	.byte 97,114,97,99,116,101,114,32
	.byte 99,108,97,115,115,32,37,46
	.byte 50,48,115,0
L1010:
	.byte 99,103,111,116,111,32,111,118
	.byte 101,114,102,108,111,119,0
L865:
	.byte 114,101,108,101,120,50,0
L563:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 112,109,97,116,99,104,0
L437:
	.byte 99,97,110,39,116,32,104,97
	.byte 112,112,101,110,58,32,117,110
	.byte 107,110,111,119,110,32,116,121
	.byte 112,101,32,37,100,32,105,110
	.byte 32,102,105,114,115,116,0
L287:
	.byte 99,99,108,101,110,116,101,114
	.byte 49,0
L15:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,105
	.byte 116,105,97,108,105,122,105,110
	.byte 103,32,109,97,107,101,100,102
	.byte 97,0
L113:
	.byte 99,97,110,39,116,32,104,97
	.byte 112,112,101,110,58,32,117,110
	.byte 107,110,111,119,110,32,116,121
	.byte 112,101,32,37,100,32,105,110
	.byte 32,112,101,110,116,101,114,0
L812:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 114,101,103,32,101,120,112,114
	.byte 32,37,46,49,48,115,46,46
	.byte 0
L55:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 109,97,107,101,100,102,97,0
L765:
	.byte 97,108,112,104,97,0
L766:
	.byte 98,108,97,110,107,0
L293:
	.byte 99,99,108,101,110,116,101,114
	.byte 50,0
L772:
	.byte 112,117,110,99,116,0
L338:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,98,117,105
	.byte 108,100,105,110,103,32,102,111
	.byte 108,108,111,119,32,115,101,116
	.byte 0
L764:
	.byte 97,108,110,117,109,0
L925:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 99,103,111,116,111,40,41,0
L914:
	.byte 98,46,99,0
L298:
	.byte 99,99,108,101,110,116,101,114
	.byte 58,32,105,110,32,61,32,124
	.byte 37,115,124,44,32,111,117,116
	.byte 32,61,32,124,37,115,124,10
	.byte 0
L640:
	.byte 114,101,112,97,114,115,101,32
	.byte 60,37,115,62,10,0
L354:
	.byte 99,97,110,39,116,32,104,97
	.byte 112,112,101,110,58,32,117,110
	.byte 107,110,111,119,110,32,116,121
	.byte 112,101,32,37,100,32,105,110
	.byte 32,99,102,111,108,108,0
L819:
	.byte 114,101,108,101,120,49,0
L154:
	.byte 99,97,110,39,116,32,104,97
	.byte 112,112,101,110,58,32,117,110
	.byte 107,110,111,119,110,32,116,121
	.byte 112,101,32,37,100,32,105,110
	.byte 32,102,114,101,101,116,114,0
L391:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 102,105,114,115,116,40,41,0
L769:
	.byte 103,114,97,112,104,0
L820:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,114,101,103,32,101,120,112
	.byte 114,32,37,46,49,48,115,46
	.byte 46,46,0
L775:
	.byte 120,100,105,103,105,116,0
L252:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,99,104,97,114,97,99,116
	.byte 101,114,32,99,108,97,115,115
	.byte 32,91,37,46,49,48,115,46
	.byte 46,46,93,32,49,0
L1059:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 99,103,111,116,111,0
L770:
	.byte 108,111,119,101,114,0
L773:
	.byte 115,112,97,99,101,0
L306:
	.byte 114,101,103,117,108,97,114,32
	.byte 101,120,112,114,101,115,115,105
	.byte 111,110,32,116,111,111,32,98
	.byte 105,103,58,32,37,46,51,48
	.byte 115,46,46,46,0
L51:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,102,97,0
.globl _patbeg
.comm _patbeg, 8, 8
.globl _patlen
.comm _patlen, 4, 4
.globl _setvec
.comm _setvec, 8, 8
.globl _tmpset
.comm _tmpset, 8, 8
.globl _rtok
.comm _rtok, 4, 4
.globl _rlxval
.comm _rlxval, 4, 4
.local _rlxstr
.comm _rlxstr, 8, 8
.local _prestr
.comm _prestr, 8, 8
.local _lastre
.comm _lastre, 8, 8
.local _setcnt
.comm _setcnt, 4, 4
.local _poscnt
.comm _poscnt, 4, 4
.globl _fatab
.comm _fatab, 160, 8

.globl _reparse
.globl _free
.globl _iscntrl
.globl _patbeg
.globl _follow
.globl _isupper
.globl _freetr
.globl _penter
.globl _realloc
.globl _isgraph
.globl _isalpha
.globl _fatab
.globl _primary
.globl _regexp
.globl _tmpset
.globl _dbg
.globl _cclenter
.globl _makeinit
.globl _malloc
.globl ___assert
.globl _first
.globl _adjbuf
.globl _ispunct
.globl _islower
.globl _cfoll
.globl _overflo
.globl _strncmp
.globl _op2
.globl _printf
.globl _relex
.globl _pmatch
.globl _isalnum
.globl _tostring
.globl _ptoi
.globl _patlen
.globl _unary
.globl _isprint
.globl _cgoto
.globl _setvec
.globl _strcmp
.globl _calloc
.globl _makedfa
.globl _isxdigit
.globl ___ctype
.globl _rtok
.globl _maxsetvec
.globl _rlxval
.globl _member
.globl _isspace
.globl _xisblank
.globl _compile_time
.globl _quoted
.globl _mkdfa
.globl _freefa
.globl _itonp
.globl _hexstr
.globl _isdigit
.globl _strlen
.globl _alt
.globl _FATAL
.globl _match
.globl _nfatab
.globl _charclasses
.globl _concat
.globl _nematch
