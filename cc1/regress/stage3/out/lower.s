.text

_combine:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq %rdi,%r14
	movq %rsi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	movl (%r14),%esi
	testl $229376,%esi
	jnz L128
L7:
	movl (%r13),%edx
	testl $229376,%edx
	jnz L128
L9:
	movl %esi,%eax
	andl $7,%eax
	cmpl $3,%eax
	jz L128
L15:
	movl %edx,%ecx
	andl $7,%ecx
	cmpl $3,%ecx
	jz L128
L17:
	cmpl $2,%eax
	jnz L29
L31:
	testl $2121728,%esi
	jz L29
L32:
	movq 16(%r14),%rax
	cmpq $-2147483648,%rax
	jl L128
L35:
	cmpq $2147483647,%rax
	jg L128
L29:
	cmpl $2,%ecx
	jnz L41
L43:
	testl $2121728,%edx
	jz L41
L44:
	movq 16(%r13),%rax
	cmpq $-2147483648,%rax
	jl L128
L47:
	cmpq $2147483647,%rax
	jg L128
L41:
	movq %r14,%rdi
	call _normalize_operand
	cmpl $0,8(%r14)
	movl $1,%eax
	cmovnzl %eax,%r12d
	cmpl $0,12(%r14)
	jz L60
L58:
	incl %r12d
L60:
	testl $24,(%r14)
	movl $1,%eax
	cmovnzl %eax,%ebx
	movq %r13,%rdi
	call _normalize_operand
	cmpl $0,8(%r13)
	jz L69
L67:
	incl %r12d
L69:
	cmpl $0,12(%r13)
	jz L72
L70:
	incl %r12d
L72:
	testl $24,(%r13)
	jz L75
L73:
	incl %ebx
L75:
	cmpl $2,%r12d
	jg L128
L78:
	cmpl $1,%ebx
	jg L128
L82:
	movq 24(%r14),%rcx
	testq %rcx,%rcx
	jz L89
L87:
	cmpq $0,24(%r13)
	jnz L128
L89:
	movq 16(%r14),%rdx
	addq 16(%r13),%rdx
	jz L97
L99:
	testl $2121728,(%r14)
	jz L97
L100:
	cmpq $-2147483648,%rdx
	jl L128
L103:
	cmpq $2147483647,%rdx
	jle L97
L128:
	xorl %eax,%eax
	jmp L3
L97:
	testq %rcx,%rcx
	jnz L110
L108:
	movq 24(%r13),%rax
	movq %rax,24(%r14)
L110:
	movl 8(%r14),%ecx
	testl %ecx,%ecx
	jz L116
L114:
	movl 8(%r13),%eax
	testl %eax,%eax
	jz L116
L115:
	movl %eax,12(%r14)
	jmp L113
L116:
	testl %ecx,%ecx
	jnz L120
L118:
	movl 8(%r13),%eax
	movl %eax,8(%r14)
L120:
	cmpl $0,12(%r14)
	jnz L123
L121:
	movl 12(%r13),%eax
	movl %eax,12(%r14)
L123:
	movl (%r14),%ecx
	testl $24,%ecx
	jnz L113
L124:
	movl (%r13),%eax
	shll $27,%eax
	shrl $30,%eax
	andl $3,%eax
	shll $3,%eax
	andl $-25,%ecx
	orl %eax,%ecx
	movl %ecx,(%r14)
L113:
	movl (%r14),%edi
	andl $-8,%edi
	orl $4,%edi
	movl %edi,(%r14)
	movq %rdx,16(%r14)
	shll $10,%edi
	shrl $15,%edi
	leaq 16(%r14),%rsi
	call _normalize_con
	movq %r14,%rdi
	call _normalize_operand
	movl $1,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_cache_expand:
L129:
L130:
	movq %rsi,%r9
	movl (%r9),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L131
L132:
	movl 8(%r9),%edx
	xorl %ecx,%ecx
L135:
	cmpl 756(%rdi),%ecx
	jge L131
L136:
	movq 760(%rdi),%r8
	movslq %ecx,%rax
	leaq (%rax,%rax,4),%rsi
	shlq $3,%rsi
	movl (%r8,%rsi),%eax
	cmpl %eax,%edx
	jz L142
L141:
	cmpl %eax,%edx
	jb L131
L148:
	incl %ecx
	jmp L135
L142:
	movl (%r9),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%r8,%rsi),%rsi
	movq %r9,%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl (%r9),%eax
	andl $-4194273,%eax
	orl %edx,%eax
	movl %eax,(%r9)
L131:
	ret 


_cache_add:
L150:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L151:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	movl $32,%ecx
	movq %r12,%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	leaq -32(%rbp),%rsi
	movq %r13,%rdi
	call _cache_expand
	movl $32,%ecx
	movq %rbx,%rsi
	leaq -64(%rbp),%rdi
	rep 
	movsb 
	leaq -64(%rbp),%rsi
	movq %r13,%rdi
	call _cache_expand
	leaq -64(%rbp),%rsi
	leaq -32(%rbp),%rdi
	call _combine
	testl %eax,%eax
	jnz L155
L153:
	movl $32,%ecx
	movq %r12,%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	movl $32,%ecx
	movq %rbx,%rsi
	leaq -64(%rbp),%rdi
	rep 
	movsb 
	leaq -64(%rbp),%rsi
	leaq -32(%rbp),%rdi
	call _combine
	testl %eax,%eax
	jz L156
L155:
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	movq %r12,%rdi
	rep 
	movsb 
	movl $1,%eax
	jmp L152
L156:
	xorl %eax,%eax
L152:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cache_invalidate:
L161:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L162:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%r12d
	movl %r13d,%eax
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	movq 736(%r14),%rcx
	sarl $20,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
	xorl %ebx,%ebx
L167:
	cmpl 756(%r14),%ebx
	jge L170
L168:
	movq 760(%r14),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,4),%rax
	shlq $3,%rax
	cmpl 16(%rcx,%rax),%r13d
	jz L175
L174:
	cmpl 20(%rcx,%rax),%r13d
	jnz L173
L175:
	movq 736(%r14),%rdx
	movl (%rcx,%rax),%esi
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L173
L178:
	movl $1,%edx
	movq %r14,%rdi
	call _cache_invalidate
L173:
	incl %ebx
	jmp L167
L170:
	testl %r12d,%r12d
	jnz L163
L181:
	xorl %ebx,%ebx
L184:
	cmpl 756(%r14),%ebx
	jge L163
L185:
	movq 736(%r14),%rdx
	movq 760(%r14),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,4),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jz L190
L188:
	movl $40,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 752(%r14),%rdi
	call _vector_delete
	decl %ebx
L190:
	incl %ebx
	jmp L184
L163:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_cache_set:
L191:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L192:
	movq %rdi,%r12
	movl %esi,%r13d
	movq %rdx,%rbx
	xorl %edx,%edx
	movl %r13d,%esi
	movq %r12,%rdi
	call _cache_invalidate
	movq %rbx,%rdi
	call _normalize_operand
	movl (%rbx),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L207
L209:
	testl $2121728,%eax
	jz L207
L210:
	movq 16(%rbx),%rax
	cmpq $-2147483648,%rax
	jl L193
L213:
	cmpq $2147483647,%rax
	jg L193
L207:
	cmpl 8(%rbx),%r13d
	jz L193
L202:
	cmpl 12(%rbx),%r13d
	jz L193
L198:
	xorl %r14d,%r14d
L217:
	cmpl 756(%r12),%r14d
	jge L220
L218:
	movq 760(%r12),%rcx
	movslq %r14d,%rax
	leaq (%rax,%rax,4),%rax
	shlq $3,%rax
	cmpl (%rcx,%rax),%r13d
	jb L220
L223:
	incl %r14d
	jmp L217
L220:
	movl $40,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 752(%r12),%rdi
	call _vector_insert
	movq 760(%r12),%rax
	movslq %r14d,%r14
	leaq (%r14,%r14,4),%rdx
	shlq $3,%rdx
	movl %r13d,(%rax,%rdx)
	movq 760(%r12),%rax
	movl $32,%ecx
	movq %rbx,%rsi
	leaq 8(%rdx,%rax),%rdi
	rep 
	movsb 
	andl $1073725440,%r13d
	movl %r13d,%ecx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq 736(%r12),%rax
	sarl $20,%r13d
	movslq %r13d,%r13
	andq %rdx,(%rax,%r13,8)
L193:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_cache_undef:
L228:
	pushq %rbx
	pushq %r12
L229:
	movq %rdi,%r12
	movl %esi,%ebx
	xorl %edx,%edx
	movl %ebx,%esi
	movq %r12,%rdi
	call _cache_invalidate
	andl $1073725440,%ebx
	movl %ebx,%ecx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq 736(%r12),%rax
	sarl $20,%ebx
	movslq %ebx,%rbx
	andq %rdx,(%rax,%rbx,8)
L230:
	popq %r12
	popq %rbx
	ret 


_cache_is_undef:
L234:
L235:
	movq 736(%rdi),%rdx
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	movl $0,%eax
	jnz L236
L241:
	cmpl 756(%rdi),%eax
	jge L244
L242:
	movq 760(%rdi),%rdx
	movslq %eax,%rcx
	leaq (%rcx,%rcx,4),%rcx
	shlq $3,%rcx
	movl (%rdx,%rcx),%ecx
	cmpl %ecx,%esi
	jz L245
L247:
	cmpl %ecx,%esi
	jb L244
L251:
	incl %eax
	jmp L241
L245:
	xorl %eax,%eax
	ret
L244:
	movl $1,%eax
L236:
	ret 


_cache_update:
L254:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L255:
	movq %rdi,%r12
	movq 16(%r12),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%rbx
	movl (%rbx),%eax
	cmpl $-1610612733,%eax
	jz L263
L374:
	cmpl $-1610612727,%eax
	jz L263
L375:
	cmpl $-1275068396,%eax
	jz L263
L376:
	cmpl $-1342177266,%eax
	jz L263
L377:
	cmpl $0,_tmp_regs(%rip)
	jl L297
L296:
	movl $0,_tmp_regs+4(%rip)
	jmp L298
L297:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L298:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L299:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L256
L303:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%esi
	testl %esi,%esi
	jz L256
L304:
	xorl %edx,%edx
	movq %r12,%rdi
	call _cache_invalidate
	incl %ebx
	jmp L299
L263:
	xorl %r14d,%r14d
L264:
	movl (%rbx),%eax
	movl %eax,%edx
	andl $805306368,%edx
	sarl $28,%edx
	movl 4(%rbx),%ecx
	shll $21,%ecx
	shrl $26,%ecx
	addl %ecx,%edx
	cmpl %edx,%r14d
	jae L258
L265:
	movslq %r14d,%rcx
	shlq $5,%rcx
	movl 16(%rbx,%rcx),%r13d
	movl 8(%rcx,%rbx),%ecx
	andl $7,%ecx
	cmpl $1,%ecx
	jnz L273
L275:
	testl %r14d,%r14d
	jnz L280
L287:
	testl $2147483648,%eax
	jz L280
L289:
	testl $1073741824,%eax
	jnz L280
L285:
	cmpl $1,%ecx
	jz L273
L280:
	movl %r13d,%esi
	movq %r12,%rdi
	call _cache_is_undef
	testl %eax,%eax
	jnz L272
L273:
	incl %r14d
	jmp L264
L272:
	movl %r13d,%esi
	movq %r12,%rdi
	call _cache_undef
	jmp L256
L258:
	movl 16(%rbx),%r13d
	cmpl $-1610612733,%eax
	jz L312
L380:
	cmpl $-1610612727,%eax
	jz L328
L381:
	cmpl $-1275068396,%eax
	jz L330
L382:
	cmpl $-1342177266,%eax
	jnz L309
L367:
	movl $32,%ecx
	leaq 40(%rbx),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 72(%rbx),%rsi
	leaq -64(%rbp),%rdi
	rep 
	movsb 
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	movq %r12,%rdi
	call _cache_add
	testl %eax,%eax
	jz L309
	jnz L385
L330:
	movl 40(%rbx),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L309
L342:
	movl 72(%rbx),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L309
L346:
	cmpq $0,96(%rbx)
	jnz L309
L347:
	movq 88(%rbx),%rax
	cmpq $1,%rax
	jl L309
L340:
	cmpq $3,%rax
	jle L336
L309:
	xorl %edx,%edx
	movl %r13d,%esi
	movq %r12,%rdi
	call _cache_invalidate
	jmp L256
L336:
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $4,%eax
	movl %eax,-32(%rbp)
	movl $0,-24(%rbp)
	movl 48(%rbx),%ecx
	movl %ecx,-20(%rbp)
	movq 88(%rbx),%rcx
	andl $3,%ecx
	shll $3,%ecx
	andl $-25,%eax
	orl %ecx,%eax
	movl %eax,-32(%rbp)
	movq $0,-16(%rbp)
	movq $0,-8(%rbp)
	movl 40(%rbx),%ecx
	testl $4194272,%ecx
	jz L385
L363:
	shll $10,%ecx
	shrl $15,%ecx
	andl $131071,%ecx
	shll $5,%ecx
	andl $-4194273,%eax
	orl %ecx,%eax
	jmp L386
L328:
	movl $32,%ecx
	leaq 40(%rbx),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	leaq -32(%rbp),%rsi
	movq %r12,%rdi
	call _cache_expand
	jmp L385
L312:
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $4,%eax
	movl $-2147303424,-24(%rbp)
	movl $0,-20(%rbp)
	andl $-25,%eax
	movl %eax,-32(%rbp)
	movq 56(%rbx),%rcx
	movq %rcx,-16(%rbp)
	movq $0,-8(%rbp)
	andl $-4194273,%eax
	orl $8192,%eax
L386:
	movl %eax,-32(%rbp)
L385:
	leaq -32(%rbp),%rdx
	movl %r13d,%esi
	movq %r12,%rdi
	call _cache_set
L256:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_same_cache:
L387:
	pushq %rbx
	pushq %r12
	pushq %r13
L388:
	movq %rdi,%r13
	movq %rsi,%r12
	movl 4(%r13),%edi
	xorl %esi,%esi
L393:
	cmpl %esi,%edi
	jle L396
L394:
	movq 8(%r13),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 8(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L419
L399:
	incl %esi
	jmp L393
L396:
	movl 28(%r13),%eax
	xorl %ebx,%ebx
	cmpl 28(%r12),%eax
	jnz L402
L406:
	cmpl 28(%r13),%ebx
	jge L409
L407:
	movq 32(%r13),%rdi
	movslq %ebx,%rax
	leaq (%rax,%rax,4),%rdx
	shlq $3,%rdx
	movl (%rdi,%rdx),%ecx
	movq 32(%r12),%rax
	cmpl (%rdx,%rax),%ecx
	jnz L419
L412:
	leaq 8(%rdx,%rax),%rsi
	leaq 8(%rdi,%rdx),%rdi
	call _same_operand
	testl %eax,%eax
	jz L419
L416:
	incl %ebx
	jmp L406
L419:
	xorl %eax,%eax
	jmp L389
L409:
	movl $1,%eax
	jmp L389
L402:
	movl %ebx,%eax
L389:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_meet0:
L420:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L421:
	movq %rdi,%r15
	movslq 732(%r15),%rcx
	shlq $3,%rcx
	movq 736(%r15),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	cmpl $0,752(%r15)
	jl L427
L426:
	movl $0,756(%r15)
	jmp L428
L427:
	movl 756(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $40,%ecx
	leaq 752(%r15),%rdi
	call _vector_insert
L428:
	xorl %eax,%eax
L484:
	movl %eax,-4(%rbp)
	movl -4(%rbp),%eax
	cmpl 36(%r15),%eax
	jge L422
L430:
	movq 40(%r15),%rcx
	movslq -4(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-32(%rbp)
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	movl 732(%r15),%eax
	movl %eax,-44(%rbp)
	xorl %esi,%esi
L436:
	cmpl %esi,-44(%rbp)
	jg L437
L440:
	cmpl 756(%r15),%r13d
	jge L465
L443:
	movq -32(%rbp),%rax
	cmpl 804(%rax),%r14d
	jl L444
L465:
	cmpl 756(%r15),%r13d
	jl L466
L471:
	movq -32(%rbp),%rax
	cmpl 804(%rax),%r14d
	jge L473
L472:
	movq -32(%rbp),%rax
	movq 808(%rax),%rcx
	movslq %r14d,%rax
	leaq (%rax,%rax,4),%rax
	shlq $3,%rax
	movq %rax,-40(%rbp)
	movq -40(%rbp),%rax
	movl (%rcx,%rax),%ecx
	movq 736(%r15),%rdx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L476
L477:
	movl 756(%r15),%esi
	leal 1(%rsi),%eax
	cmpl 752(%r15),%eax
	jge L481
L480:
	movl %eax,756(%r15)
	jmp L482
L481:
	movl $40,%ecx
	movl $1,%edx
	leaq 752(%r15),%rdi
	call _vector_insert
L482:
	movq 760(%r15),%rdi
	movl 756(%r15),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,4),%rdx
	shlq $3,%rdx
	movq -32(%rbp),%rax
	movq 808(%rax),%rsi
	movl $40,%ecx
	addq -40(%rbp),%rsi
	addq %rdx,%rdi
	rep 
	movsb 
L476:
	incl %r14d
	jmp L471
L473:
	movl -4(%rbp),%eax
	incl %eax
	jmp L484
L466:
	movq 760(%r15),%rcx
	movslq %r13d,%rax
	leaq (%rax,%rax,4),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%ecx
	movq 736(%r15),%rdx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jz L469
L468:
	movl $40,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 752(%r15),%rdi
	call _vector_delete
	jmp L465
L469:
	incl %r13d
	jmp L465
L444:
	movq 760(%r15),%rcx
	movq %rcx,-56(%rbp)
	movslq %r13d,%rax
	leaq (%rax,%rax,4),%rax
	shlq $3,%rax
	movq %rax,-64(%rbp)
	movq -56(%rbp),%rcx
	movq -64(%rbp),%rax
	movl (%rcx,%rax),%esi
	movq -32(%rbp),%rax
	movq 808(%rax),%rdx
	movslq %r14d,%rax
	leaq (%rax,%rax,4),%r12
	shlq $3,%r12
	movl (%rdx,%r12),%eax
	movq 736(%r15),%r8
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq %rdi,-16(%rbp)
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%ebx
	shlq %cl,%rbx
	movq -16(%rbp),%rdi
	testq %rbx,(%r8,%rdi,8)
	jz L448
L447:
	movl $40,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 752(%r15),%rdi
	call _vector_delete
	jmp L440
L448:
	movl %eax,%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq (%r8,%rdi,8),%rdi
	movq %rdi,-24(%rbp)
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%r8d
	shlq %cl,%r8
	movq -24(%rbp),%rdi
	testq %rdi,%r8
	jz L451
L450:
	incl %r14d
	jmp L440
L451:
	cmpl %eax,%esi
	jb L485
L454:
	incl %r14d
	cmpl %eax,%esi
	jbe L457
L456:
	movl $40,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 752(%r15),%rdi
	call _vector_insert
	movq 760(%r15),%rdi
	movq -32(%rbp),%rax
	movq 808(%rax),%rsi
	movl $40,%ecx
	addq %r12,%rsi
	addq -64(%rbp),%rdi
	rep 
	movsb 
	jmp L485
L457:
	leaq 8(%rdx,%r12),%rsi
	movq -56(%rbp),%rcx
	movq -64(%rbp),%rax
	leaq 8(%rcx,%rax),%rdi
	call _same_operand
	testl %eax,%eax
	jz L459
L485:
	incl %r13d
	jmp L440
L459:
	movl $40,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 752(%r15),%rdi
	call _vector_delete
	movq 736(%r15),%rax
	movq -16(%rbp),%rdi
	orq %rbx,(%rax,%rdi,8)
	jmp L440
L437:
	movq -32(%rbp),%rax
	movq 784(%rax),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 736(%r15),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %esi
	jmp L436
L422:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cache0:
L486:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
L487:
	movq %rdi,%r12
	movq %r12,%rdi
	call _meet0
	xorl %ebx,%ebx
L489:
	cmpl 12(%r12),%ebx
	jge L493
L490:
	movl %ebx,%esi
	movq %r12,%rdi
	call _cache_update
	incl %ebx
	jmp L489
L493:
	movl $48,%ecx
	leaq 728(%r12),%rsi
	leaq -48(%rbp),%rdi
	rep 
	movsb 
	movl $48,%ecx
	leaq 776(%r12),%rsi
	leaq 728(%r12),%rdi
	rep 
	movsb 
	movl $48,%ecx
	leaq -48(%rbp),%rsi
	leaq 776(%r12),%rdi
	rep 
	movsb 
	leaq 776(%r12),%rsi
	leaq 728(%r12),%rdi
	call _same_cache
	testl %eax,%eax
	movl $1,%ecx
	movl $0,%eax
	cmovzl %ecx,%eax
L488:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_alloc0:
L501:
	pushq %rbx
L502:
	movq %rdi,%rbx
	movl $0,(%rbx)
	movl $0,4(%rbx)
	movq $0,8(%rbx)
	movq $_local_arena,16(%rbx)
	movl _nr_assigned_regs(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
	cmpl $0,%edx
	jg L517
L516:
	movl %edx,4(%rbx)
	jmp L518
L517:
	movl $8,%ecx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _vector_insert
L518:
	movl $0,24(%rbx)
	movl $0,28(%rbx)
	movq $0,32(%rbx)
	movq $_local_arena,40(%rbx)
L503:
	popq %rbx
	ret 

.align 8
L557:
	.quad 2
	.quad 4
	.quad 8
	.quad 16
	.quad 32
	.quad 64
	.quad 128
	.quad 256
	.quad 512
	.quad 1024
	.quad 2048
	.quad 4096
	.quad 65536
.align 2
L558:
	.short L530-_move
	.short L530-_move
	.short L530-_move
	.short L533-_move
	.short L533-_move
	.short L536-_move
	.short L536-_move
	.short L540-_move
	.short L540-_move
	.short L542-_move
	.short L545-_move
	.short L545-_move
	.short L540-_move

_move:
L522:
	pushq %rbx
	pushq %r12
L523:
	movq %rdi,%rcx
	movq %rsi,%r12
	movq %rdx,%rbx
	andl $131071,%ecx
	xorl %eax,%eax
L554:
	cmpq L557(,%rax,8),%rcx
	jz L555
L556:
	incl %eax
	cmpl $13,%eax
	jb L554
	jae L526
L555:
	movzwl L558(,%rax,2),%eax
	addl $_move,%eax
	jmp *%rax
L545:
	movl $-1610519735,%edi
	jmp L526
L542:
	movl $-1610528184,%edi
	jmp L526
L540:
	movl $-1610545081,%edi
	jmp L526
L536:
	movl $-1610561978,%edi
	jmp L526
L533:
	movl $-1610578875,%edi
	jmp L526
L530:
	movl $-1610604220,%edi
L526:
	xorl %esi,%esi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	movq %r12,%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	movq %rbx,%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
L524:
	popq %r12
	popq %rbx
	ret 


_remat:
L559:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L560:
	movq %rdi,%r8
	movq %rsi,%r12
	movq %rdx,%r14
	movq %rcx,%r13
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl $32,%ecx
	movq %r13,%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	leaq -32(%rbp),%rsi
	movq %r8,%rdi
	call _cache_expand
	movl -32(%rbp),%eax
	andl $7,%eax
	cmpl $4,%eax
	jnz L563
L562:
	andl $131071,%r12d
	cmpq $2,%r12
	jz L570
	jl L566
L590:
	cmpq $65536,%r12
	jz L580
	jg L566
L591:
	cmpl $4,%r12d
	jz L570
L592:
	cmpl $8,%r12d
	jz L570
L593:
	cmpl $16,%r12d
	jz L573
L594:
	cmpl $32,%r12d
	jz L573
L595:
	cmpl $64,%r12d
	jz L576
L596:
	cmpl $128,%r12d
	jz L576
L597:
	cmpl $256,%r12d
	jz L580
L598:
	cmpl $512,%r12d
	jz L580
	jnz L566
L576:
	movl $-1610561946,%ebx
	jmp L566
L573:
	movl $-1610561947,%ebx
	jmp L566
L580:
	movl $-1610545049,%ebx
	jmp L566
L570:
	movl $-1610561948,%ebx
L566:
	xorl %esi,%esi
	movl %ebx,%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	movq %r14,%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	jmp L561
L563:
	movq %r13,%rdx
	movq %r14,%rsi
	movq %r12,%rdi
	call _move
L561:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_choose:
L601:
	pushq %rbx
L602:
	movq 16(%rdi),%r8
	movslq %esi,%rax
	movq (%r8,%rax,8),%r11
	movl (%r11),%r10d
	andl $805306368,%r10d
	sarl $28,%r10d
	movl 4(%r11),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%r10d
L604:
	cmpq $0,32(%rcx)
	jz L606
L605:
	xorl %r9d,%r9d
L607:
	cmpl %r9d,%r10d
	jle L610
L608:
	movslq %r9d,%r8
	movq %r8,%rax
	shlq $5,%rax
	movl 8(%r11,%rax),%eax
	shll $10,%eax
	shrl $15,%eax
	testq %rax,(%rcx,%r8,8)
	jz L610
L613:
	incl %r9d
	jmp L607
L610:
	cmpl %r9d,%r10d
	jz L615
L617:
	addq $40,%rcx
	jmp L604
L615:
	movq 32(%rcx),%rax
	call *%rax
	movl %eax,%ebx
	jmp L603
L606:
	movl (%rdi),%eax
	pushq %rdx
	pushq %rax
	pushq $L619
	pushq $0
	pushq $3
	call _error
	addq $40,%rsp
L603:
	movl %ebx,%eax
	popq %rbx
	ret 


_deimm:
L620:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L621:
	movq %rdi,%r13
	movl %esi,%r12d
	movq %rdx,%rbx
	movl (%rbx),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L624
L623:
	shll $10,%edi
	shrl $15,%edi
	call _temp_reg
	movl -32(%rbp),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,-32(%rbp)
	movl %eax,-24(%rbp)
	movl (%rbx),%eax
	testl $4194272,%eax
	jz L640
L638:
	shll $10,%eax
	shrl $15,%eax
	andl $131071,%eax
	shll $5,%eax
	andl $-4194273,%ecx
	orl %eax,%ecx
	movl %ecx,-32(%rbp)
L640:
	movl (%rbx),%edi
	shll $10,%edi
	shrl $15,%edi
	movq %rbx,%rdx
	leaq -32(%rbp),%rsi
	call _move
	movl %r12d,%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	movq %rbx,%rdi
	rep 
	movsb 
	movl $1,%eax
	jmp L622
L624:
	xorl %eax,%eax
L622:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_cmp:
L643:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L644:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rcx,%r13
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	leaq -32(%rbp),%rdx
	movl %r14d,%esi
	movq %r15,%rdi
	call _deimm
	movl %eax,%ebx
	xorl %esi,%esi
	movl 24(%r13),%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 40(%r12),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	leal (%r14,%rbx),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leal 1(%rbx),%eax
L645:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_cmp_choices:
	.quad 14
	.quad 14
	.quad 0
	.int 603988318
	.int 0
	.quad _lower_cmp
	.quad 48
	.quad 48
	.quad 0
	.int 604013663
	.int 0
	.quad _lower_cmp
	.quad 192
	.quad 192
	.quad 0
	.int 604030560
	.int 0
	.quad _lower_cmp
	.quad 66304
	.quad 66304
	.quad 0
	.int 604047457
	.int 0
	.quad _lower_cmp
	.quad 192
	.quad 192
	.quad 0
	.int 604030560
	.int 0
	.quad _lower_cmp
	.quad 1024
	.quad 1024
	.quad 0
	.int 604064354
	.int 0
	.quad _lower_cmp
	.quad 6144
	.quad 6144
	.quad 0
	.int 604072803
	.int 0
	.quad _lower_cmp
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.text

_lower_unary2:
L653:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L654:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rcx,%r13
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl $32,%ecx
	leaq 40(%r12),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	xorl %ebx,%ebx
	testl $2,28(%r13)
	jz L658
L656:
	leaq -32(%rbp),%rdx
	movl %r14d,%esi
	movq %r15,%rdi
	call _deimm
	movl %eax,%ebx
	addl %eax,%r14d
L658:
	xorl %esi,%esi
	movl 24(%r13),%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leal 1(%rbx),%eax
L655:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_bsf_choices:
	.quad 131071
	.quad 192
	.quad 0
	.int -1543453005
	.int 2
	.quad _lower_unary2
	.quad 131071
	.quad 66304
	.quad 0
	.int -1543436108
	.int 2
	.quad _lower_unary2
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_bsr_choices:
	.quad 131071
	.quad 192
	.quad 0
	.int -1543453003
	.int 2
	.quad _lower_unary2
	.quad 131071
	.quad 66304
	.quad 0
	.int -1543436106
	.int 2
	.quad _lower_unary2
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_cast_choices:
	.quad 14
	.quad 66558
	.quad 0
	.int -1610604220
	.int 0
	.quad _lower_unary2
	.quad 48
	.quad 8
	.quad 0
	.int -1610603446
	.int 2
	.quad _lower_unary2
	.quad 48
	.quad 6
	.quad 0
	.int -1610603443
	.int 2
	.quad _lower_unary2
	.quad 48
	.quad 66558
	.quad 0
	.int -1610578875
	.int 0
	.quad _lower_unary2
	.quad 192
	.quad 8
	.quad 0
	.int -1610602933
	.int 2
	.quad _lower_unary2
	.quad 192
	.quad 6
	.quad 0
	.int -1610602930
	.int 2
	.quad _lower_unary2
	.quad 192
	.quad 32
	.quad 0
	.int -1610578352
	.int 2
	.quad _lower_unary2
	.quad 192
	.quad 16
	.quad 0
	.int -1610578350
	.int 2
	.quad _lower_unary2
	.quad 192
	.quad 66558
	.quad 0
	.int -1610561978
	.int 0
	.quad _lower_unary2
	.quad 66304
	.quad 8
	.quad 0
	.int -1610602420
	.int 2
	.quad _lower_unary2
	.quad 66304
	.quad 6
	.quad 0
	.int -1610602417
	.int 2
	.quad _lower_unary2
	.quad 66304
	.quad 32
	.quad 0
	.int -1610577839
	.int 2
	.quad _lower_unary2
	.quad 66304
	.quad 16
	.quad 0
	.int -1610577837
	.int 2
	.quad _lower_unary2
	.quad 66304
	.quad 128
	.quad 0
	.int -1610561964
	.int 2
	.quad _lower_unary2
	.quad 66304
	.quad 64
	.quad 0
	.int -1610561451
	.int 2
	.quad _lower_unary2
	.quad 66304
	.quad 66558
	.quad 0
	.int -1610545081
	.int 0
	.quad _lower_unary2
	.quad 126
	.quad 1024
	.quad 0
	.int -1610529190
	.int 2
	.quad _lower_unary2
	.quad 384
	.quad 1024
	.quad 0
	.int -1610528677
	.int 2
	.quad _lower_unary2
	.quad 1024
	.quad 64
	.quad 0
	.int -1610560938
	.int 2
	.quad _lower_unary2
	.quad 1024
	.quad 256
	.quad 0
	.int -1610544553
	.int 2
	.quad _lower_unary2
	.quad 1024
	.quad 6144
	.quad 0
	.int -1610519873
	.int 0
	.quad _lower_unary2
	.quad 1024
	.quad 1024
	.quad 0
	.int -1610528184
	.int 0
	.quad _lower_unary2
	.quad 126
	.quad 6144
	.quad 0
	.int -1610520996
	.int 2
	.quad _lower_unary2
	.quad 384
	.quad 6144
	.quad 0
	.int -1610520483
	.int 2
	.quad _lower_unary2
	.quad 6144
	.quad 64
	.quad 0
	.int -1610560680
	.int 2
	.quad _lower_unary2
	.quad 6144
	.quad 256
	.quad 0
	.int -1610544295
	.int 2
	.quad _lower_unary2
	.quad 6144
	.quad 1024
	.quad 0
	.int -1610527810
	.int 0
	.quad _lower_unary2
	.quad 6144
	.quad 6144
	.quad 0
	.int -1610519735
	.int 0
	.quad _lower_unary2
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.text

_lower_unary:
L666:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L667:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rcx,%r13
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	xorl %ebx,%ebx
	movl 8(%r12),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L674
L676:
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L674
L677:
	movl 16(%r12),%eax
	cmpl 48(%r12),%eax
	jz L671
L674:
	shll $10,%edi
	shrl $15,%edi
	leaq 40(%r12),%rdx
	leaq 8(%r12),%rsi
	call _move
	movl %r14d,%edx
	incl %r14d
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $1,%ebx
L671:
	xorl %esi,%esi
	movl 24(%r13),%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leal 1(%rbx),%eax
L668:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
_neg_choices:
	.quad 131071
	.quad 14
	.quad 0
	.int -738197140
	.int 0
	.quad _lower_unary
	.quad 131071
	.quad 48
	.quad 0
	.int -738196371
	.int 0
	.quad _lower_unary
	.quad 131071
	.quad 192
	.quad 0
	.int -738195858
	.int 0
	.quad _lower_unary
	.quad 131071
	.quad 66304
	.quad 0
	.int -738195345
	.int 0
	.quad _lower_unary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_com_choices:
	.quad 131071
	.quad 14
	.quad 0
	.int -805306008
	.int 0
	.quad _lower_unary
	.quad 131071
	.quad 48
	.quad 0
	.int -805305239
	.int 0
	.quad _lower_unary
	.quad 131071
	.quad 192
	.quad 0
	.int -805304726
	.int 0
	.quad _lower_unary
	.quad 131071
	.quad 66304
	.quad 0
	.int -805304213
	.int 0
	.quad _lower_unary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.text

_lower_binary:
L684:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L685:
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%r13d
	movq %rcx,-40(%rbp)
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	xorl %ebx,%ebx
	movl 8(%r12),%ecx
	andl $7,%ecx
	cmpl $1,%ecx
	jnz L692
L694:
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L692
L695:
	movl 16(%r12),%eax
	cmpl 48(%r12),%eax
	jz L689
L692:
	cmpl $1,%ecx
	jnz L703
L705:
	movl 72(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L703
L706:
	movl 16(%r12),%eax
	cmpl 80(%r12),%eax
	jz L773
L703:
	movl 72(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L689
L709:
	movl %r13d,%edx
	movl 80(%r12),%esi
	movq %r15,%rdi
	call _range_by_use
	movl %eax,%esi
	movq %r15,%rdi
	call _range_span
	cmpl %eax,%r13d
	jnz L689
L773:
	movq %r12,%rdi
	call _commute_insn
L689:
	movl $32,%ecx
	leaq 72(%r12),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	xorl %eax,%eax
	movq -40(%rbp),%rcx
	testl $1,28(%rcx)
	jz L717
L718:
	movl -32(%rbp),%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L724
L722:
	cmpq $0,-8(%rbp)
	jz L717
L724:
	movl $-2147467264,%eax
L717:
	movl 8(%r12),%ecx
	andl $7,%ecx
	cmpl $1,%ecx
	jnz L728
L733:
	movl -32(%rbp),%edi
	movl %edi,%ecx
	andl $7,%ecx
	cmpl $1,%ecx
	jnz L728
L734:
	movl 16(%r12),%ecx
	cmpl -24(%rbp),%ecx
	jnz L728
L730:
	shll $10,%edi
	shrl $15,%edi
	call _temp_reg
L728:
	testl %eax,%eax
	jz L739
L740:
	movl -32(%rbp),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,-32(%rbp)
	movl %eax,-24(%rbp)
	testl $4194272,%ecx
	jz L754
L752:
	movl %ecx,%eax
	shll $10,%eax
	shrl $15,%eax
	andl $131071,%eax
	shll $5,%eax
	andl $-4194273,%ecx
	orl %eax,%ecx
	movl %ecx,-32(%rbp)
L754:
	movl -32(%rbp),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq 72(%r12),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movl %r14d,%edx
	incl %r14d
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $1,%ebx
L739:
	movl 8(%r12),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L760
L762:
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L760
L763:
	movl 16(%r12),%eax
	cmpl 48(%r12),%eax
	jz L757
L760:
	shll $10,%edi
	shrl $15,%edi
	leaq 40(%r12),%rdx
	leaq 8(%r12),%rsi
	call _move
	movl %r14d,%edx
	incl %r14d
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %ebx
L757:
	xorl %esi,%esi
	movq -40(%rbp),%rcx
	movl 24(%rcx),%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leal 1(%rbx),%eax
L686:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_add_choices:
	.quad 131071
	.quad 14
	.quad 14
	.int -469753488
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 48
	.quad 48
	.int -469728143
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 192
	.quad 192
	.int -469711246
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 66304
	.quad 66304
	.int -469694349
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_sub_choices:
	.quad 131071
	.quad 14
	.quad 14
	.int -469753482
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 48
	.quad 48
	.int -469728137
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 192
	.quad 192
	.int -469711240
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 66304
	.quad 66304
	.int -469694343
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 1024
	.quad 1024
	.int -536786310
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 6144
	.quad 6144
	.int -536777861
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_mul2_choices:
	.quad 131071
	.quad 48
	.quad 48
	.int -469728131
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 192
	.quad 192
	.int -469711234
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 66304
	.quad 66304
	.int -469694337
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_and_choices:
	.quad 131071
	.quad 14
	.quad 14
	.int -469753445
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 48
	.quad 48
	.int -469728100
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 192
	.quad 192
	.int -469711203
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 66304
	.quad 66304
	.int -469694306
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_or_choices:
	.quad 131071
	.quad 14
	.quad 14
	.int -469753441
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 48
	.quad 48
	.int -469728096
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 192
	.quad 192
	.int -469711199
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 66304
	.quad 66304
	.int -469694302
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_xor_choices:
	.quad 131071
	.quad 14
	.quad 14
	.int -469753437
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 48
	.quad 48
	.int -469728092
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 192
	.quad 192
	.int -469711195
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 66304
	.quad 66304
	.int -469694298
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_shl_choices:
	.quad 131071
	.quad 14
	.quad 2
	.int -469753449
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 48
	.quad 2
	.int -469752680
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 192
	.quad 2
	.int -469752167
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 66304
	.quad 2
	.int -469751654
	.int 1
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_shr_choices:
	.quad 131071
	.quad 8
	.quad 2
	.int -469753457
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 6
	.quad 2
	.int -469753453
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 32
	.quad 2
	.int -469752688
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 16
	.quad 2
	.int -469752684
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 128
	.quad 2
	.int -469752175
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 64
	.quad 2
	.int -469752171
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 66048
	.quad 2
	.int -469751662
	.int 1
	.quad _lower_binary
	.quad 131071
	.quad 256
	.quad 2
	.int -469751658
	.int 1
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.text

_lower_mul8:
L774:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L775:
	movq %rdi,%r14
	movl %esi,%r13d
	movq 16(%r14),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%r12
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl $-2147483648,-24(%rbp)
	andl $-4194273,%eax
	orl $64,%eax
	movl %eax,-32(%rbp)
	movl 72(%r12),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L794
L792:
	movq %r12,%rdi
	call _commute_insn
L794:
	movl $32,%ecx
	leaq 72(%r12),%rsi
	leaq -64(%rbp),%rdi
	rep 
	movsb 
	leaq -64(%rbp),%rdx
	movl %r13d,%esi
	movq %r14,%rdi
	call _deimm
	movl %eax,%ebx
	leaq 40(%r12),%rcx
	leaq -32(%rbp),%rdx
	movl $2,%esi
	movq %r14,%rdi
	call _remat
	leal (%r13,%rbx),%edx
	movq %r14,%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $335544700,%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -64(%rbp),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	leal 1(%r13,%rbx),%edx
	movq %r14,%rsi
	movq %rax,%rdi
	call _insert_insn
	leaq -32(%rbp),%rdx
	leaq 8(%r12),%rsi
	movl $2,%edi
	call _move
	leal 2(%r13,%rbx),%edx
	movq %r14,%rsi
	movq %rax,%rdi
	call _insert_insn
	leal 3(%rbx),%eax
L776:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_mul3:
L799:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L800:
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%ebx
	movq %rcx,%r13
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L804
L802:
	movq %r12,%rdi
	call _commute_insn
L804:
	movl 72(%r12),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L805
L807:
	movl $32,%ecx
	leaq 40(%r12),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	leaq -32(%rbp),%rdx
	movl %r14d,%esi
	movq %r15,%rdi
	call _deimm
	movl %eax,%ebx
	xorl %esi,%esi
	movl 24(%r13),%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	movl 72(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 72(%r12),%rsi
	leaq 72(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 72(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,72(%rax)
	leal (%r14,%rbx),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leal 1(%rbx),%eax
	jmp L801
L805:
	movl $_mul2_choices,%ecx
	movl %ebx,%edx
	movl %r14d,%esi
	movq %r15,%rdi
	call _choose
L801:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_mul_choices:
	.quad 131071
	.quad 14
	.quad 14
	.int 335544700
	.int 0
	.quad _lower_mul8
	.quad 131071
	.quad 48
	.quad 48
	.int -1273985920
	.int 0
	.quad _lower_mul3
	.quad 131071
	.quad 192
	.quad 192
	.int -1273444735
	.int 0
	.quad _lower_mul3
	.quad 131071
	.quad 66304
	.quad 66304
	.int -1272903550
	.int 0
	.quad _lower_mul3
	.quad 131071
	.quad 1024
	.quad 1024
	.int -536786301
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 6144
	.quad 6144
	.int -536777852
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.text

_lower_divmod:
L819:
	pushq %rbp
	movq %rsp,%rbp
	subq $128,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L820:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rdx,%r13
	movl %ecx,-116(%rbp)
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl $32,%ecx
	leaq 72(%r12),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	movl -64(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-64(%rbp)
	movl $-2147483648,-56(%rbp)
	movl 8(%r12),%ecx
	testl $4194272,%ecx
	jz L836
L834:
	shll $10,%ecx
	shrl $15,%ecx
	andl $131071,%ecx
	shll $5,%ecx
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,-64(%rbp)
L836:
	movl -96(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-96(%rbp)
	movl $-2147450880,-88(%rbp)
	movl 8(%r12),%ecx
	testl $4194272,%ecx
	jz L851
L849:
	shll $10,%ecx
	shrl $15,%ecx
	andl $131071,%ecx
	shll $5,%ecx
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,-96(%rbp)
L851:
	testl $448,8(%r12)
	setnz %al
	movzbl %al,%eax
	movl %eax,-120(%rbp)
	leaq -32(%rbp),%rdx
	movl %r14d,%esi
	movq %r15,%rdi
	call _deimm
	movl %eax,%ebx
	leal (%r14,%rbx),%eax
	movl %eax,-124(%rbp)
	cmpl $0,-120(%rbp)
	jz L853
L852:
	cmpl $0,28(%r13)
	movl $-1610602933,%eax
	movl $-1610602930,%edi
	cmovzl %eax,%edi
	xorl %esi,%esi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl $-2147483648,16(%rax)
	andl $-4194273,%ecx
	orl $2048,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 40(%r12),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	leal 1(%r14,%rbx),%r14d
	movl -124(%rbp),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %ebx
	jmp L854
L853:
	movl 8(%r12),%esi
	shll $10,%esi
	shrl $15,%esi
	leaq 40(%r12),%rcx
	leaq -64(%rbp),%rdx
	movq %r15,%rdi
	call _remat
	leal 1(%r14,%rbx),%ecx
	movl %ecx,-128(%rbp)
	leal (%r14,%rbx),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl 28(%r13),%edi
	leal 2(%r14,%rbx),%r14d
	testl %edi,%edi
	jz L877
L876:
	xorl %esi,%esi
	call _new_insn
	jmp L962
L877:
	xorl %esi,%esi
	movl $-1610561978,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl $-2147450880,16(%rax)
	andl $-4194273,%ecx
	orl $2048,%ecx
	movl %ecx,8(%rax)
	movq $0,-104(%rbp)
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -104(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl $2048,%ecx
	movl %ecx,40(%rax)
L962:
	movl -128(%rbp),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	addl $2,%ebx
L854:
	xorl %esi,%esi
	movl 24(%r13),%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl %r14d,%edx
	incl %r14d
	movl %r14d,%r13d
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %ebx
	cmpl $0,-116(%rbp)
	jz L920
L918:
	cmpl $0,-120(%rbp)
	jz L920
L919:
	xorl %esi,%esi
	movl $-469752175,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl $-2147483648,16(%rax)
	andl $-4194273,%ecx
	orl $2048,%ecx
	movl %ecx,8(%rax)
	movq $8,-112(%rbp)
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -112(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl $64,%ecx
	movl %ecx,40(%rax)
	leal 1(%r14),%r13d
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %ebx
	jmp L956
L920:
	cmpl $0,-116(%rbp)
	jz L956
L955:
	movl 8(%r12),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -96(%rbp),%rdx
	leaq 8(%r12),%rsi
	call _move
	movl %r14d,%edx
	jmp L961
L956:
	movl 8(%r12),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -64(%rbp),%rdx
	leaq 8(%r12),%rsi
	call _move
	movl %r13d,%edx
L961:
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leal 1(%rbx),%eax
L821:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_div:
L963:
L964:
	movq %rcx,%rdx
	xorl %ecx,%ecx
	call _lower_divmod
L965:
	ret 


_lower_mod:
L967:
L968:
	movq %rcx,%rdx
	movl $1,%ecx
	call _lower_divmod
L969:
	ret 

.data
.align 8
_mod_choices:
	.quad 131071
	.quad 8
	.quad 8
	.int 335544715
	.int 0
	.quad _lower_mod
	.quad 131071
	.quad 6
	.quad 6
	.int 335544711
	.int 186
	.quad _lower_mod
	.quad 131071
	.quad 32
	.quad 32
	.int 335545484
	.int 0
	.quad _lower_mod
	.quad 131071
	.quad 16
	.quad 16
	.int 335545480
	.int 187
	.quad _lower_mod
	.quad 131071
	.quad 128
	.quad 128
	.int 335545997
	.int 0
	.quad _lower_mod
	.quad 131071
	.quad 64
	.quad 64
	.int 335545993
	.int 188
	.quad _lower_mod
	.quad 131071
	.quad 66048
	.quad 66048
	.int 335546510
	.int 0
	.quad _lower_mod
	.quad 131071
	.quad 256
	.quad 256
	.int 335546506
	.int 189
	.quad _lower_mod
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.align 8
_div_choices:
	.quad 131071
	.quad 8
	.quad 8
	.int 335544715
	.int 0
	.quad _lower_div
	.quad 131071
	.quad 6
	.quad 6
	.int 335544711
	.int 186
	.quad _lower_div
	.quad 131071
	.quad 32
	.quad 32
	.int 335545484
	.int 0
	.quad _lower_div
	.quad 131071
	.quad 16
	.quad 16
	.int 335545480
	.int 187
	.quad _lower_div
	.quad 131071
	.quad 128
	.quad 128
	.int 335545997
	.int 0
	.quad _lower_div
	.quad 131071
	.quad 64
	.quad 64
	.int 335545993
	.int 188
	.quad _lower_div
	.quad 131071
	.quad 66048
	.quad 66048
	.int 335546510
	.int 0
	.quad _lower_div
	.quad 131071
	.quad 256
	.quad 256
	.int 335546506
	.int 189
	.quad _lower_div
	.quad 131071
	.quad 1024
	.quad 1024
	.int -536786299
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 6144
	.quad 6144
	.int -536777850
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.text

_lower_lea:
L971:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L972:
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%r13d
	movq %rcx,%r12
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%rbx
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl $32,%ecx
	leaq 40(%rbx),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	xorl %eax,%eax
	movq %rax,-64(%rbp)
	movq %rax,-56(%rbp)
	movq %rax,-48(%rbp)
	movq %rax,-40(%rbp)
	movl $32,%ecx
	leaq 72(%rbx),%rsi
	leaq -64(%rbp),%rdi
	rep 
	movsb 
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _cache_add
	testl %eax,%eax
	jz L975
L974:
	movl -32(%rbp),%eax
	andl $7,%eax
	cmpl $4,%eax
	jnz L978
L977:
	xorl %esi,%esi
	movl 24(%r12),%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	jmp L979
L978:
	movl 8(%rbx),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -32(%rbp),%rdx
	leaq 8(%rbx),%rsi
	call _move
L979:
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $1,%eax
	jmp L973
L975:
	movl $_add_choices,%ecx
	movl %r13d,%edx
	movl %r14d,%esi
	movq %r15,%rdi
	call _choose
L973:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_lea_choices:
	.quad 131071
	.quad 14
	.quad 14
	.int -1610561948
	.int 0
	.quad _lower_lea
	.quad 131071
	.quad 48
	.quad 48
	.int -1610561947
	.int 0
	.quad _lower_lea
	.quad 131071
	.quad 192
	.quad 192
	.int -1610561946
	.int 0
	.quad _lower_lea
	.quad 131071
	.quad 66304
	.quad 66304
	.int -1610545049
	.int 0
	.quad _lower_lea
	.quad 131071
	.quad 1024
	.quad 1024
	.int -536786316
	.int 0
	.quad _lower_binary
	.quad 131071
	.quad 6144
	.quad 6144
	.int -536777867
	.int 0
	.quad _lower_binary
	.quad 0
	.fill 16, 1, 0
	.fill 16, 1, 0
.text

_lower_return:
L988:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L989:
	movq _func_ret_type(%rip),%rcx
	movq %rdi,%r14
	movl %esi,%r13d
	movl $41943105,%r12d
	movl $1,%ebx
	testq $1,(%rcx)
	jnz L993
L991:
	movl $41943106,%r12d
	movl $2,%ebx
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-32(%rbp)
	movl $-2147483648,-24(%rbp)
	testq %rcx,%rcx
	jz L1008
L1000:
	movq (%rcx),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,-32(%rbp)
L1008:
	movl -64(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-64(%rbp)
	movq _func_ret_sym(%rip),%rdi
	call _symbol_to_reg
	movl %eax,-56(%rbp)
	movq _func_ret_type(%rip),%rdx
	testq %rdx,%rdx
	jz L1023
L1015:
	movq (%rdx),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	movl -64(%rbp),%eax
	andl $-4194273,%eax
	orl %ecx,%eax
	movl %eax,-64(%rbp)
L1023:
	testq $7168,(%rdx)
	jz L1026
L1024:
	movl $41943107,%r12d
	movl $-1073479680,-24(%rbp)
L1026:
	testq $8192,(%rdx)
	jz L1029
L1027:
	movl -64(%rbp),%eax
	andl $-4194273,%eax
	orl $2097152,%eax
	movl %eax,-64(%rbp)
	movl -32(%rbp),%eax
	andl $-4194273,%eax
	orl $2097152,%eax
	movl %eax,-32(%rbp)
	movq _func_hidden_arg(%rip),%rdi
	call _symbol_to_reg
	movl %eax,-56(%rbp)
L1029:
	movl -32(%rbp),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movl %r13d,%edx
	incl %r13d
	movq %r14,%rsi
	movq %rax,%rdi
	call _insert_insn
L993:
	xorl %esi,%esi
	movl %r12d,%edi
	call _new_insn
	movl %r13d,%edx
	movq %r14,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl %ebx,%eax
L990:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_arg:
L1031:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L1032:
	movq %rdi,%r12
	movl %esi,%ebx
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rsi
	testl $229376,8(%rsi)
	jz L1035
L1034:
	movl _nr_fargs(%rip),%eax
	leal 1(%rax),%ecx
	movl %ecx,_nr_fargs(%rip)
	movslq %eax,%rax
	movl _fargs(,%rax,4),%ecx
	jmp L1037
L1035:
	movl _nr_iargs(%rip),%eax
	leal 1(%rax),%ecx
	movl %ecx,_nr_iargs(%rip)
	movslq %eax,%rax
	movl _iargs(,%rax,4),%ecx
L1037:
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-32(%rbp)
	movl %ecx,-24(%rbp)
	movl 8(%rsi),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -32(%rbp),%rdx
	addq $8,%rsi
	call _move
	movl %ebx,%edx
	movq %r12,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $1,%eax
L1033:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_mem:
L1053:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1054:
	movq %rdi,%r13
	movl %esi,%r12d
	movq 16(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	cmpl $2717908996,(%rbx)
	setz %r14b
	movzbl %r14b,%r14d
	movslq %r14d,%rax
	shlq $5,%rax
	movl $32,%ecx
	leaq 8(%rbx,%rax),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	leaq -32(%rbp),%rsi
	movq %r13,%rdi
	call _cache_expand
	leaq -32(%rbp),%rdi
	call _normalize_operand
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $3,%eax
	movl %eax,-32(%rbp)
	xorl $1,%r14d
	movslq %r14d,%r14
	shlq $5,%r14
	movl 8(%rbx,%r14),%edi
	shll $10,%edi
	shrl $15,%edi
	cmpl $2717908996,(%rbx)
	jnz L1057
L1056:
	leaq -32(%rbp),%rdx
	leaq 8(%rbx,%r14),%rsi
	jmp L1060
L1057:
	leaq 8(%rbx,%r14),%rdx
	leaq -32(%rbp),%rsi
L1060:
	call _move
	movq %rax,%rdi
	movl %r12d,%edx
	movq %r13,%rsi
	call _insert_insn
	movl $1,%eax
L1055:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_frame:
L1061:
	pushq %rbx
	pushq %r12
	pushq %r13
L1062:
	movq %rdi,%r13
	movl %esi,%r12d
	movq 16(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	xorl %esi,%esi
	movl $-1610545049,%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $4,%ecx
	movl $-2147303424,48(%rax)
	movl $0,52(%rax)
	andl $-25,%ecx
	movl %ecx,40(%rax)
	movq 56(%rbx),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movl %r12d,%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $1,%eax
L1063:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_asm0:
L1083:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1084:
	movq %rdi,%r14
	movl %esi,%r13d
	movq %rdx,%r12
	xorl %ebx,%ebx
L1086:
	cmpl 4(%r12),%ebx
	jge L1089
L1087:
	movq 8(%r12),%rdx
	movslq %ebx,%rcx
	movl (%rdx,%rcx,8),%eax
	movl 4(%rdx,%rcx,8),%edi
	movl %edi,%edx
	andl $1073725440,%edx
	sarl $14,%edx
	movq _reg_to_symbol+8(%rip),%rcx
	cmpl $34,%edx
	jge L1124
L1091:
	movl %eax,%edx
	andl $1073725440,%edx
	sarl $14,%edx
L1124:
	subl $34,%edx
	movslq %edx,%rdx
	movq (%rcx,%rdx,8),%rsi
	movl -32(%rbp),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,-32(%rbp)
	movl %edi,-24(%rbp)
	movq 32(%rsi),%rdx
	testq %rdx,%rdx
	jz L1107
L1099:
	movq (%rdx),%rdx
	andl $131071,%edx
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,-32(%rbp)
L1107:
	movl -64(%rbp),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,-64(%rbp)
	movl %eax,-56(%rbp)
	movq 32(%rsi),%rax
	testq %rax,%rax
	jz L1122
L1114:
	movq (%rax),%rax
	andl $131071,%eax
	shll $5,%eax
	andl $-4194273,%ecx
	orl %eax,%ecx
	movl %ecx,-64(%rbp)
L1122:
	movl -32(%rbp),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movl %r13d,%edx
	incl %r13d
	movq %r14,%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %ebx
	jmp L1086
L1089:
	movl %ebx,%eax
L1085:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_asm:
L1125:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1126:
	movq %rdi,%r12
	movl %esi,%ebx
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rdi
	call _dup_insn
	movq %rax,%r14
	leaq 16(%r14),%rdx
	movl %ebx,%esi
	movq %r12,%rdi
	call _asm0
	movl %eax,%r13d
	leaq 16(%r14),%rdi
	call _invert_regmap
	leaq 40(%r14),%rdi
	call _invert_regmap
	leal (%rbx,%r13),%edx
	movq %r12,%rsi
	movq %r14,%rdi
	call _insert_insn
	leaq 40(%r14),%rdx
	leal 1(%rbx,%r13),%esi
	movq %r12,%rdi
	call _asm0
	leal 1(%r13,%rax),%eax
L1127:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_lower_setcc:
L1129:
	pushq %rbx
	pushq %r12
	pushq %r13
L1130:
	movq %rdi,%r13
	movl %esi,%r12d
	movq 16(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	movl (%rbx),%edi
	xorl %esi,%esi
	addl $399,%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl %r12d,%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $-1610602933,%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	leal 1(%r12),%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $2,%eax
L1131:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_lower_move:
L1142:
	pushq %rbx
	pushq %r12
L1143:
	movq %rdi,%r12
	movl %esi,%ebx
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rdx
	movl 8(%rdx),%esi
	shll $10,%esi
	shrl $15,%esi
	leaq 40(%rdx),%rcx
	addq $8,%rdx
	movq %r12,%rdi
	call _remat
	movl %ebx,%edx
	movq %r12,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $1,%eax
L1144:
	popq %r12
	popq %rbx
	ret 


_words:
L1146:
L1147:
	movq 16(%rdi),%rdx
	movq %rdx,%rax
	sarq $3,%rax
	andl $7,%edx
	movl (%rdi),%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L1149
L1152:
	cmpq $0,24(%rdi)
	jnz L1149
L1151:
	testl $4,%edx
	jz L1159
L1157:
	incl %eax
L1159:
	testl $2,%edx
	jz L1162
L1160:
	incl %eax
L1162:
	testl $1,%edx
	jz L1148
L1163:
	incl %eax
	ret
L1149:
	movl $2147483647,%eax
L1148:
	ret 


_blkaddr:
L1167:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L1168:
	movq %rdi,%rax
	movq %rsi,%rbx
	movl %edx,%r12d
	movl $32,%ecx
	movq %rbx,%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	leaq -32(%rbp),%rsi
	movq %rax,%rdi
	call _cache_expand
	cmpl $8,%r12d
	jz L1180
L1210:
	cmpl $4,%r12d
	jz L1180
L1211:
	cmpl $2,%r12d
	jz L1180
L1212:
	cmpl $1,%r12d
	jz L1180
L1213:
	movl -32(%rbp),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L1178
L1176:
	cmpl $127,%r12d
	jle L1180
L1178:
	cmpl $4,%eax
	jnz L1202
L1197:
	cmpl $0,-24(%rbp)
	jz L1202
L1198:
	cmpq $0,-8(%rbp)
	jnz L1202
L1194:
	movq -16(%rbp),%rax
	cmpq $-128,%rax
	jl L1202
L1190:
	movslq %r12d,%r12
	addq %r12,%rax
	cmpq $127,%rax
	jg L1202
L1180:
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	movq %rbx,%rdi
	rep 
	movsb 
L1202:
	movq %rbx,%rdi
	call _normalize_operand
	movl (%rbx),%eax
	andl $-8,%eax
	orl $3,%eax
	movl %eax,(%rbx)
L1169:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_copy:
L1215:
	pushq %rbp
	movq %rsp,%rbp
	subq $224,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1216:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rdx,-200(%rbp)
	movq %rcx,-208(%rbp)
	movq %r8,-216(%rbp)
	movl $0,-224(%rbp)
	movq -216(%rbp),%rdi
	call _words
	cmpl $3,%eax
	jle L1218
L1248:
	movl -128(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-128(%rbp)
	movl $-2147467264,-120(%rbp)
	movl -160(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-160(%rbp)
	movl $-2147434496,-152(%rbp)
	movl -192(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-192(%rbp)
	movl $-2147418112,-184(%rbp)
	movq -216(%rbp),%rdx
	leaq -128(%rbp),%rsi
	movl $256,%edi
	call _move
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movq -208(%rbp),%rdx
	leaq -160(%rbp),%rsi
	movl $256,%edi
	call _move
	leal 1(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movq -200(%rbp),%rdx
	leaq -192(%rbp),%rsi
	movl $256,%edi
	call _move
	leal 2(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $8388793,%edi
	call _new_insn
	leal 3(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $50331831,%edi
	call _new_insn
	leal 4(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $5,-224(%rbp)
	jmp L1220
L1218:
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl $32,%ecx
	movq -208(%rbp),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	xorl %eax,%eax
	movq %rax,-64(%rbp)
	movq %rax,-56(%rbp)
	movq %rax,-48(%rbp)
	movq %rax,-40(%rbp)
	movl $32,%ecx
	movq -200(%rbp),%rsi
	leaq -64(%rbp),%rdi
	rep 
	movsb 
	movq -216(%rbp),%rax
	movq 16(%rax),%r13
	movl -96(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-96(%rbp)
	movl $256,%edi
	call _temp_reg
	movl %eax,-88(%rbp)
	movl -96(%rbp),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,-96(%rbp)
	movl %r13d,%edx
	leaq -64(%rbp),%rsi
	movq %r15,%rdi
	call _blkaddr
	movl %r13d,%edx
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _blkaddr
L1236:
	testl %r13d,%r13d
	jz L1220
L1237:
	cmpl $8,%r13d
	jl L1240
L1239:
	movl $256,%r12d
	movl $8,%ebx
	jmp L1241
L1240:
	cmpl $4,%r13d
	jl L1243
L1242:
	movl $64,%r12d
	movl $4,%ebx
	jmp L1241
L1243:
	cmpl $2,%r13d
	jl L1246
L1245:
	movl $16,%r12d
	movl $2,%ebx
	jmp L1241
L1246:
	movl $2,%r12d
	movl $1,%ebx
L1241:
	leaq -32(%rbp),%rdx
	leaq -96(%rbp),%rsi
	movq %r12,%rdi
	call _move
	leal 1(%r14),%ecx
	movl %ecx,-220(%rbp)
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leaq -96(%rbp),%rdx
	leaq -64(%rbp),%rsi
	movq %r12,%rdi
	call _move
	addl $2,%r14d
	movl -220(%rbp),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movslq %ebx,%rax
	addq %rax,-48(%rbp)
	addq -16(%rbp),%rax
	movq %rax,-16(%rbp)
	subl %ebx,%r13d
	addl $2,-224(%rbp)
	jmp L1236
L1220:
	movl -224(%rbp),%eax
L1217:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_blkcpy:
L1294:
L1295:
	movq 16(%rdi),%rcx
	movslq %esi,%rax
	movq (%rcx,%rax,8),%rdx
	leaq 72(%rdx),%r8
	leaq 40(%rdx),%rcx
	addq $8,%rdx
	call _copy
L1296:
	ret 


_lower_blkset:
L1298:
	pushq %rbp
	movq %rsp,%rbp
	subq $176,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1299:
	movq %rdi,%r15
	movl %esi,%r14d
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%rbx
	xorl %r13d,%r13d
	leaq 72(%rbx),%rdi
	call _words
	movl %eax,-172(%rbp)
	cmpl $7,-172(%rbp)
	jg L1306
L1304:
	movl 40(%rbx),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L1306
L1312:
	cmpq $0,64(%rbx)
	jnz L1306
L1313:
	cmpq $0,56(%rbx)
	jnz L1306
L1309:
	movq 88(%rbx),%r12
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	movl %r12d,%edx
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _blkaddr
	movq $0,-40(%rbp)
	movl -72(%rbp),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,-72(%rbp)
	movq -40(%rbp),%rax
	movq %rax,-56(%rbp)
	movq $0,-48(%rbp)
	cmpl $1,-172(%rbp)
	jle L1370
L1334:
	movl $256,%edi
	call _temp_reg
	movl %eax,%ebx
	xorl %esi,%esi
	movl $-1610545081,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 40(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq -72(%rbp),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	movl %r14d,%edx
	incl %r14d
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $1,%r13d
	movl -72(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-72(%rbp)
	movl %ebx,-64(%rbp)
L1370:
	testl %r12d,%r12d
	jz L1303
L1371:
	cmpl $8,%r12d
	jl L1374
L1373:
	movl $256,%edi
	movl $8,%ebx
	jmp L1375
L1374:
	cmpl $4,%r12d
	jl L1377
L1376:
	movl $64,%edi
	movl $4,%ebx
	jmp L1375
L1377:
	cmpl $2,%r12d
	jl L1380
L1379:
	movl $16,%edi
	movl $2,%ebx
	jmp L1375
L1380:
	movl $2,%edi
	movl $1,%ebx
L1375:
	leaq -72(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movl %r14d,%edx
	incl %r14d
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movslq %ebx,%rax
	addq -16(%rbp),%rax
	movq %rax,-16(%rbp)
	subl %ebx,%r12d
	incl %r13d
	jmp L1370
L1306:
	movl -104(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-104(%rbp)
	movl $-2147467264,-96(%rbp)
	movl -136(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-136(%rbp)
	movl $-2147418112,-128(%rbp)
	movl -168(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-168(%rbp)
	movl $-2147483648,-160(%rbp)
	leaq 72(%rbx),%rdx
	leaq -104(%rbp),%rsi
	movl $256,%edi
	call _move
	movl %r14d,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leaq 8(%rbx),%rdx
	leaq -136(%rbp),%rsi
	movl $256,%edi
	call _move
	leal 1(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	leaq 40(%rbx),%rdx
	leaq -168(%rbp),%rsi
	movl $2,%edi
	call _move
	leal 2(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $8388793,%edi
	call _new_insn
	leal 3(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $16777400,%edi
	call _new_insn
	leal 4(%r14),%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $5,%r13d
L1303:
	movl %r13d,%eax
L1300:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lower_call:
L1428:
	pushq %rbp
	movq %rsp,%rbp
	subq $232,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1429:
	movq %rdi,-216(%rbp)
	movl %esi,-224(%rbp)
	movq -216(%rbp),%rax
	movq 16(%rax),%rcx
	movslq -224(%rbp),%rax
	movq (%rcx,%rax,8),%r15
	movl -224(%rbp),%ecx
	movl %ecx,-188(%rbp)
	xorl %esi,%esi
	movl $385878080,%edi
	call _new_insn
	movq %rax,%r12
	movl 8(%r12),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 40(%r15),%rsi
	leaq 8(%r12),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%r12),%eax
	andl $-4194273,%eax
	orl %edx,%eax
	movl %eax,8(%r12)
	movl -224(%rbp),%ecx
	incl %ecx
	movl %ecx,-220(%rbp)
	movl -220(%rbp),%ecx
	movl %ecx,-196(%rbp)
	movl -224(%rbp),%edx
	movq -216(%rbp),%rsi
	movq %r12,%rdi
	call _insert_insn
	movl $1,-200(%rbp)
	movl 8(%r15),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L1436
L1434:
	shll $10,%edi
	shrl $15,%edi
	movq %rdi,%rcx
	andl $66558,%ecx
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	testq %rcx,%rcx
	jz L1455
L1440:
	movl %eax,-32(%rbp)
	movl $-2147483648,-24(%rbp)
	jmp L1439
L1455:
	movl %eax,-32(%rbp)
	movl $-1073479680,-24(%rbp)
L1439:
	leaq -32(%rbp),%rdx
	leaq 8(%r15),%rsi
	call _move
	movl -220(%rbp),%ecx
	incl %ecx
	movl %ecx,-196(%rbp)
	movl -220(%rbp),%edx
	movq -216(%rbp),%rsi
	movq %rax,%rdi
	call _insert_insn
	movl $2,-200(%rbp)
L1436:
	xorl %esi,%esi
	movl $-469694349,%edi
	call _new_insn
	movq %rax,-208(%rbp)
	movq -208(%rbp),%rax
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movq -208(%rbp),%rax
	movl %ecx,8(%rax)
	movq -208(%rbp),%rax
	movl $-2147319808,16(%rax)
	movq -208(%rbp),%rax
	movl 4(%rax),%ecx
	andl $-2,%ecx
	orl $1,%ecx
	movq -208(%rbp),%rax
	movl %ecx,4(%rax)
	movl -196(%rbp),%edx
	movq -216(%rbp),%rsi
	movq -208(%rbp),%rdi
	call _insert_insn
	movl -200(%rbp),%r14d
	incl %r14d
	testl $2048,4(%r15)
	jnz L1487
L1485:
	movl $2,%eax
L1682:
	movl %eax,-228(%rbp)
	movl 4(%r15),%eax
	shll $21,%eax
	shrl $26,%eax
	addl $2,%eax
	cmpl %eax,-228(%rbp)
	jae L1487
L1489:
	movslq -228(%rbp),%rbx
	shlq $5,%rbx
	movl 8(%r15,%rbx),%eax
	shll $10,%eax
	shrl $15,%eax
	testq $8192,%rax
	jnz L1490
L1494:
	testq $66558,%rax
	movl 4(%r12),%ecx
	jz L1497
L1496:
	andl $28672,%ecx
	cmpl $24576,%ecx
	jz L1490
L1503:
	movl -64(%rbp),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,-64(%rbp)
	movl 4(%r12),%ecx
	shll $17,%ecx
	shrl $29,%ecx
	movl _iargs(,%rcx,4),%ecx
	movl %ecx,-56(%rbp)
	movl 4(%r12),%ecx
	movl %ecx,%edx
	shll $17,%edx
	shrl $29,%edx
	incl %edx
	andl $7,%edx
	shll $12,%edx
	andl $-28673,%ecx
	jmp L1685
L1497:
	andl $491520,%ecx
	cmpl $262144,%ecx
	jz L1490
L1522:
	movl -64(%rbp),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,-64(%rbp)
	movl 4(%r12),%ecx
	shll $13,%ecx
	shrl $28,%ecx
	movl _fargs(,%rcx,4),%ecx
	movl %ecx,-56(%rbp)
	movl 4(%r12),%ecx
	movl %ecx,%edx
	shll $13,%edx
	shrl $28,%edx
	incl %edx
	andl $15,%edx
	shll $15,%edx
	andl $-491521,%ecx
L1685:
	orl %edx,%ecx
	movl %ecx,4(%r12)
	movl -96(%rbp),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%r15,%rbx),%rsi
	leaq -96(%rbp),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl -96(%rbp),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,-96(%rbp)
	leaq -96(%rbp),%rcx
	leaq -64(%rbp),%rdx
	movq %rax,%rsi
	movq -216(%rbp),%rdi
	call _remat
	movl -188(%rbp),%edx
	movq -216(%rbp),%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %r14d
	andl $-8,8(%r15,%rbx)
L1490:
	movl -228(%rbp),%eax
	incl %eax
	jmp L1682
L1487:
	movl $1,-192(%rbp)
	movl $2,%ecx
L1540:
	movl 4(%r15),%eax
	shll $21,%eax
	shrl $26,%eax
	addl $2,%eax
	cmpl %eax,%ecx
	jae L1543
L1541:
	movslq %ecx,%rax
	shlq $5,%rax
	movl 8(%r15,%rax),%eax
	testl $7,%eax
	jz L1542
L1546:
	testl $2129856,%eax
	jz L1548
L1542:
	incl %ecx
	jmp L1540
L1548:
	movl $0,-192(%rbp)
L1543:
	xorl %ebx,%ebx
	movl $2,%eax
L1683:
	movl %eax,-232(%rbp)
	movl 4(%r15),%eax
	shll $21,%eax
	shrl $26,%eax
	addl $2,%eax
	cmpl %eax,-232(%rbp)
	jae L1555
L1553:
	movslq -232(%rbp),%r13
	shlq $5,%r13
	movl 8(%r15,%r13),%edi
	testl $262144,%edi
	jz L1557
L1556:
	movl 12(%r15,%r13),%r12d
	andl $268435455,%r12d
	jmp L1558
L1557:
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	movl %eax,%r12d
L1558:
	movl 8(%r15,%r13),%edx
	testl $7,%edx
	jz L1554
L1561:
	cmpl $0,-192(%rbp)
	jz L1564
L1563:
	xorl %esi,%esi
	movl $276826304,%edi
	call _new_insn
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $32,%ecx
	leaq 8(%r15,%r13),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	andl $131071,%edx
	shll $5,%edx
	movl 8(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
	jmp L1684
L1564:
	andl $262144,%edx
	movslq %ebx,%rax
	movl -128(%rbp),%ecx
	andl $-8,%ecx
	testl %edx,%edx
	jz L1605
L1572:
	orl $4,%ecx
	movl $-2147319808,-120(%rbp)
	movl $0,-116(%rbp)
	andl $-25,%ecx
	movl %ecx,-128(%rbp)
	movq %rax,-112(%rbp)
	movq $0,-104(%rbp)
	movslq %r12d,%rax
	movq %rax,-136(%rbp)
	movl -168(%rbp),%eax
	andl $-8,%eax
	orl $2,%eax
	movl %eax,-168(%rbp)
	movq -136(%rbp),%rax
	movq %rax,-152(%rbp)
	movq $0,-144(%rbp)
	movl -168(%rbp),%eax
	andl $-4194273,%eax
	orl $8192,%eax
	movl %eax,-168(%rbp)
	leaq -168(%rbp),%r8
	leaq 8(%r15,%r13),%rcx
	leaq -128(%rbp),%rdx
	movl -188(%rbp),%esi
	movq -216(%rbp),%rdi
	call _copy
	addl %r14d,%eax
	movl %eax,%r14d
	jmp L1565
L1605:
	orl $3,%ecx
	movl $-2147319808,-120(%rbp)
	movl $0,-116(%rbp)
	andl $-25,%ecx
	movl %ecx,-128(%rbp)
	movq %rax,-112(%rbp)
	movq $0,-104(%rbp)
	movl 8(%r15,%r13),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq 8(%r15,%r13),%rdx
	leaq -128(%rbp),%rsi
	call _move
L1684:
	movl -188(%rbp),%edx
	movq -216(%rbp),%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %r14d
L1565:
	movl $8,%ecx
	leal 7(%r12,%rbx),%eax
	cltd 
	idivl %ecx
	shll $3,%eax
	movl %eax,%ebx
L1554:
	movl -232(%rbp),%eax
	incl %eax
	jmp L1683
L1555:
	testl %ebx,%ebx
	jz L1622
L1623:
	cmpl $0,-192(%rbp)
	jnz L1622
L1624:
	xorl %esi,%esi
	movl $-469694343,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl $-2147319808,16(%rax)
	movslq %ebx,%rcx
	movq %rcx,-176(%rbp)
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -176(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl $8192,%ecx
	movl %ecx,40(%rax)
	movl 4(%rax),%ecx
	andl $-2,%ecx
	orl $1,%ecx
	movl %ecx,4(%rax)
	movl -188(%rbp),%edx
	movq -216(%rbp),%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %r14d
L1622:
	testl %ebx,%ebx
	jz L1661
L1663:
	movslq %ebx,%rbx
	movq %rbx,-184(%rbp)
	movq -208(%rbp),%rax
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movq -208(%rbp),%rax
	movl %ecx,40(%rax)
	movq -184(%rbp),%rcx
	movq -208(%rbp),%rax
	movq %rcx,56(%rax)
	movq -208(%rbp),%rax
	movq $0,64(%rax)
	movq -208(%rbp),%rax
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl $8192,%ecx
	movq -208(%rbp),%rax
	movl %ecx,40(%rax)
	jmp L1662
L1661:
	movq -208(%rbp),%rax
	movl $0,(%rax)
L1662:
	movl %r14d,%eax
L1430:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_sel:
	.quad 0
	.fill 8, 1, 0
	.quad 0
	.quad _lower_asm
	.quad 0
	.fill 8, 1, 0
	.quad 0
	.quad _lower_frame
	.quad 0
	.quad _lower_mem
	.quad 0
	.quad _lower_mem
	.quad 0
	.quad _lower_call
	.quad 0
	.quad _lower_arg
	.quad 0
	.quad _lower_return
	.quad 0
	.quad _lower_move
	.quad _cast_choices
	.quad _choose
	.quad _cmp_choices
	.quad _choose
	.quad _neg_choices
	.quad _choose
	.quad _com_choices
	.quad _choose
	.quad _lea_choices
	.quad _choose
	.quad _sub_choices
	.quad _choose
	.quad _mul_choices
	.quad _choose
	.quad _div_choices
	.quad _choose
	.quad _mod_choices
	.quad _choose
	.quad _shr_choices
	.quad _choose
	.quad _shl_choices
	.quad _choose
	.quad _and_choices
	.quad _choose
	.quad _or_choices
	.quad _choose
	.quad _xor_choices
	.quad _choose
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad 0
	.quad _lower_setcc
	.quad _bsf_choices
	.quad _choose
	.quad _bsr_choices
	.quad _choose
	.quad 0
	.quad _lower_blkcpy
	.quad 0
	.quad _lower_blkset
.text

_lower:
L1686:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1689:
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movq _all_blocks(%rip),%rbx
L1692:
	testq %rbx,%rbx
	jz L1695
L1693:
	leaq 728(%rbx),%rdi
	call _alloc0
	leaq 776(%rbx),%rdi
	call _alloc0
	movslq 780(%rbx),%rcx
	shlq $3,%rcx
	movq 784(%rbx),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	movq 112(%rbx),%rbx
	jmp L1692
L1695:
	xorl %edi,%edi
	call _sequence_blocks
	movl $_cache0,%edi
	call _iterate_blocks
	movl $1,%edi
	call _live_analyze
	movl $0,_nr_iargs(%rip)
	movl $0,_nr_fargs(%rip)
	movq _all_blocks(%rip),%r13
L1696:
	testq %r13,%r13
	jz L1711
L1697:
	movq %r13,%rdi
	call _meet0
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L1700:
	cmpl 12(%r13),%ebx
	jge L1706
L1704:
	movq 16(%r13),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rax
	testq %rax,%rax
	jz L1706
L1705:
	movl (%rax),%ecx
	movzbq %cl,%rcx
	shlq $4,%rcx
	movq _sel+8(%rcx),%rax
	testq %rax,%rax
	jnz L1709
L1708:
	movl %ebx,%esi
	movq %r13,%rdi
	call _cache_update
	jmp L1710
L1709:
	movq _sel(%rcx),%rcx
	movl %r12d,%edx
	movl %ebx,%esi
	movq %r13,%rdi
	call *%rax
	movl %eax,%r14d
	leal (%rbx,%r14),%esi
	movq %r13,%rdi
	call _cache_update
	movl $8,%ecx
	movl $1,%edx
	leal (%rbx,%r14),%esi
	leaq 8(%r13),%rdi
	call _vector_delete
	leal -1(%rbx,%r14),%ebx
L1710:
	incl %r12d
	incl %ebx
	jmp L1700
L1706:
	movq 112(%r13),%r13
	jmp L1696
L1711:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L1688:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L619:
 .byte 99,104,111,111,115,101,40,41
 .byte 32,37,100,32,37,100,0
.local _tmp_regs
.comm _tmp_regs, 24, 8
.local _nr_iargs
.comm _nr_iargs, 4, 4
.local _nr_fargs
.comm _nr_fargs, 4, 4

.globl _func_hidden_arg
.globl _fargs
.globl _temp_reg
.globl _all_blocks
.globl _reg_to_symbol
.globl _symbol_to_reg
.globl _range_span
.globl _error
.globl _sequence_blocks
.globl _func_ret_type
.globl _lower
.globl _iargs
.globl _live_analyze
.globl _invert_regmap
.globl _range_by_use
.globl _commute_insn
.globl _normalize_con
.globl _same_operand
.globl _iterate_blocks
.globl _move
.globl _normalize_operand
.globl _nr_assigned_regs
.globl _local_arena
.globl _func_ret_sym
.globl _new_insn
.globl _vector_insert
.globl _dup_insn
.globl _vector_delete
.globl _insn_defs
.globl _t_size
.globl _insert_insn
