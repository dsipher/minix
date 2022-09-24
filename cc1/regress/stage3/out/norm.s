.text

_shl1:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L2:
	movq %rdi,%rax
	movl $-1275068396,(%rax)
	movq $1,-8(%rbp)
	movl 72(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,72(%rax)
	movq -8(%rbp),%rcx
	movq %rcx,88(%rax)
	movq $0,96(%rax)
	movl $_char_type,%ecx
	testq %rcx,%rcx
	jz L3
L13:
	movq _char_type(%rip),%rdx
	andl $131071,%edx
	shll $5,%edx
	movl 72(%rax),%ecx
	andl $4290773023,%ecx
	orl %edx,%ecx
	movl %ecx,72(%rax)
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


_mod2:
L23:
L24:
	movl $-1275068395,(%rdi)
	decq 88(%rdi)
	movq %rdi,%rax
L25:
	ret 


_pow2:
L27:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L28:
	movq %rdi,%rax
	movl %esi,(%rax)
	bsrq 88(%rax),%rdx
	xorl $63,%edx
	movslq %edx,%rdx
	movl $63,%ecx
	subq %rdx,%rcx
	movq %rcx,-8(%rbp)
	movl 72(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,72(%rax)
	movq -8(%rbp),%rcx
	movq %rcx,88(%rax)
	movq $0,96(%rax)
	movl $_char_type,%ecx
	testq %rcx,%rcx
	jz L29
L39:
	movq _char_type(%rip),%rdx
	andl $131071,%edx
	shll $5,%edx
	movl 72(%rax),%ecx
	andl $4290773023,%ecx
	orl %edx,%ecx
	movl %ecx,72(%rax)
L29:
	movq %rbp,%rsp
	popq %rbp
	ret 


_move0:
L49:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
L50:
	movq %rdi,%r12
	movl %esi,%ebx
	orl $8,_opt_request(%rip)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 40(%r12),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	testl %ebx,%ebx
	jz L55
L103:
	cmpl $1,%ebx
	jz L58
L104:
	cmpl $2,%ebx
	jnz L53
L78:
	movq $1,-16(%rbp)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -16(%rbp),%rcx
	jmp L108
L58:
	movq $0,-8(%rbp)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -8(%rbp),%rcx
L108:
	movq %rcx,56(%rax)
	movq $0,64(%rax)
L53:
	testl $229376,8(%rax)
	jz L99
L97:
	cvtsi2sdq 56(%rax),%xmm0
	movsd %xmm0,56(%rax)
L99:
	orl $80,_opt_request(%rip)
	jmp L51
L55:
	orl $4,_opt_request(%rip)
L51:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_norms:
	.quad 131071
	.int -1342177266
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1342177266
	.byte 0
	.byte 0
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _shl1
	.quad 131071
	.int -1342177265
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 131071
	.int -1342177265
	.byte 0
	.byte 0
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 131071
	.int -1342177264
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 131071
	.int -1342177264
	.byte 0
	.byte 2
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1342177264
	.byte 0
	.byte 3
	.fill 2, 1, 0
	.int -1275068396
	.fill 4, 1, 0
	.quad _pow2
	.quad 1022
	.int -1275068398
	.byte 0
	.byte 2
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068398
	.byte 0
	.byte 0
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 680
	.int -1275068398
	.byte 0
	.byte 3
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _mod2
	.quad 131071
	.int -1342177263
	.byte 0
	.byte 2
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 131071
	.int -1342177263
	.byte 0
	.byte 0
	.fill 2, 1, 0
	.int 2
	.fill 4, 1, 0
	.quad _move0
	.quad 680
	.int -1342177263
	.byte 0
	.byte 3
	.fill 2, 1, 0
	.int -1275068397
	.fill 4, 1, 0
	.quad _pow2
	.quad 1022
	.int -1275068395
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068395
	.byte 0
	.byte 0
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068395
	.byte 0
	.byte 4
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068394
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068394
	.byte 0
	.byte 0
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068393
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068393
	.byte 0
	.byte 0
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068396
	.byte 1
	.byte 5
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068396
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068397
	.byte 1
	.byte 5
	.fill 2, 1, 0
	.int 1
	.fill 4, 1, 0
	.quad _move0
	.quad 1022
	.int -1275068397
	.byte 0
	.byte 1
	.fill 2, 1, 0
	.int 0
	.fill 4, 1, 0
	.quad _move0
.text
L375:
	.quad 0x3ff0000000000000
.align 2
L376:
	.short L189-_norm
	.short L199-_norm
	.short L221-_norm
	.short L251-_norm
	.short L269-_norm
	.short L187-_norm

_norm:
L109:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L110:
	movslq _norm_0s+4(%rip),%rcx
	movq %rdi,%r14
	shlq $3,%rcx
	movq _norm_0s+8(%rip),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	movslq _norm_1s+4(%rip),%rcx
	shlq $3,%rcx
	movq _norm_1s+8(%rip),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	xorl %r15d,%r15d
L112:
	cmpl 12(%r14),%r15d
	jge L111
L116:
	movq 16(%r14),%rcx
	movslq %r15d,%rax
	movq (%rcx,%rax,8),%r13
	testq %r13,%r13
	jz L111
L117:
	movl (%r13),%eax
	movl %eax,%ecx
	andl $805306368,%ecx
	sarl $28,%ecx
	cmpl $3,%ecx
	jnz L284
L127:
	testl $2147483648,%eax
	jz L284
L128:
	testl $1073741824,%eax
	jnz L284
L124:
	xorl %r12d,%r12d
L132:
	movslq %r12d,%rax
	shlq $5,%rax
	movl _norms+8(%rax),%eax
	cmpl (%r13),%eax
	jz L134
L137:
	incl %r12d
	cmpl $24,%r12d
	jl L132
L134:
	movl 72(%r13),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L142
L139:
	movq %r13,%rdi
	call _commute_insn
L142:
	cmpl $24,%r12d
	jge L284
L146:
	movslq %r12d,%rbx
	shlq $5,%rbx
	movl _norms+8(%rbx),%eax
	cmpl (%r13),%eax
	jnz L284
L147:
	movl 40(%r13),%edi
	movl %edi,%eax
	shll $10,%eax
	shrl $15,%eax
	testq %rax,_norms(%rbx)
	jz L144
L152:
	movb _norms+12(%rbx),%sil
	testb %sil,%sil
	jnz L159
L157:
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L144
L159:
	movq _norm_0s+8(%rip),%rdx
	movl 48(%r13),%eax
	movl %eax,%ecx
	andl $1073725440,%ecx
	movl %ecx,%r8d
	sarl $20,%r8d
	movslq %r8d,%r8
	movq (%rdx,%r8,8),%r9
	sarl $14,%ecx
	movl $1,%r8d
	shlq %cl,%r8
	testq %r9,%r8
	setnz %cl
	movzbl %cl,%ecx
	cmpb $1,%sil
	jnz L167
L169:
	andl $7,%edi
	cmpl $2,%edi
	jnz L175
L177:
	cmpq $0,64(%r13)
	jnz L175
L178:
	cmpq $0,56(%r13)
	jz L167
L175:
	cmpl $1,%edi
	jnz L144
L181:
	testl %ecx,%ecx
	jz L144
L167:
	movb _norms+13(%rbx),%cl
	cmpb $0,%cl
	jl L187
L374:
	cmpb $5,%cl
	jg L187
L372:
	movzbl %cl,%ecx
	movzwl L376(,%rcx,2),%ecx
	addl $_norm,%ecx
	jmp *%rcx
L269:
	movl 72(%r13),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L144
L273:
	cmpq $0,96(%r13)
	jnz L144
L274:
	movq $-1,-8(%rbp)
	movl 72(%r13),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -8(%rbp),%rsi
	call _normalize_con
	movq 88(%r13),%rax
	cmpq -8(%rbp),%rax
	jnz L144
	jz L187
L251:
	movl 72(%r13),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L144
L259:
	cmpq $0,96(%r13)
	jnz L144
L260:
	movq 88(%r13),%rcx
	testq %rcx,%rcx
	jz L144
L263:
	movq %rcx,%rax
	decq %rax
	testq %rcx,%rax
	jnz L144
	jz L187
L221:
	movq _norm_1s+8(%rip),%rdx
	movl 80(%r13),%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	setnz %al
	movzbl %al,%edx
	movl 72(%r13),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L231
L233:
	cmpq $0,96(%r13)
	jnz L231
L234:
	testl $229376,%eax
	jz L243
L241:
	movsd 88(%r13),%xmm0
	ucomisd L375(%rip),%xmm0
	jz L187
L243:
	cmpq $1,88(%r13)
	jz L187
L231:
	cmpl $1,%ecx
	jnz L144
L245:
	testl %edx,%edx
	jz L144
	jnz L187
L199:
	movl 80(%r13),%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	setnz %al
	movzbl %al,%ecx
	movl 72(%r13),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L209
L211:
	cmpq $0,96(%r13)
	jnz L209
L212:
	cmpq $0,88(%r13)
	jz L187
L209:
	cmpl $1,%eax
	jnz L144
L215:
	testl %ecx,%ecx
	jz L144
	jnz L187
L189:
	movl 72(%r13),%ecx
	andl $7,%ecx
	cmpl $1,%ecx
	jnz L144
L193:
	cmpl 80(%r13),%eax
	jnz L144
L187:
	movl _norms+16(%rbx),%esi
	movq _norms+24(%rbx),%rax
	movq %r13,%rdi
	call *%rax
	movq %rax,%r13
	movq 16(%r14),%rcx
	movslq %r15d,%r15
	movq %rax,(%rcx,%r15,8)
	jmp L284
L144:
	incl %r12d
	jmp L142
L284:
	leaq -16(%rbp),%rdx
	leaq -12(%rbp),%rsi
	movq %r13,%rdi
	call _insn_is_copy
	testl %eax,%eax
	jz L287
L286:
	movq _norm_0s+8(%rip),%rdi
	movl -16(%rbp),%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	sarl $14,%ecx
	movl $1,%esi
	shlq %cl,%rsi
	andq (%rdi,%rax,8),%rsi
	movl -12(%rbp),%eax
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	sarl $20,%eax
	movslq %eax,%rax
	movl $1,%edx
	shlq %cl,%rdx
	movq (%rdi,%rax,8),%rcx
	testq %rsi,%rsi
	jz L295
L292:
	orq %rdx,%rcx
	movq %rcx,(%rdi,%rax,8)
	jmp L291
L295:
	notq %rdx
	andq %rcx,%rdx
	movq %rdx,(%rdi,%rax,8)
L291:
	movq _norm_1s+8(%rip),%rdi
	movl -16(%rbp),%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	sarl $14,%ecx
	movl $1,%esi
	shlq %cl,%rsi
	andq (%rdi,%rax,8),%rsi
	movl -12(%rbp),%eax
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	sarl $20,%eax
	movslq %eax,%rax
	movl $1,%edx
	shlq %cl,%rdx
	movq (%rdi,%rax,8),%rcx
	testq %rsi,%rsi
	jz L304
L301:
	orq %rdx,%rcx
	movq %rcx,(%rdi,%rax,8)
	jmp L288
L304:
	notq %rdx
	andq %rcx,%rdx
	movq %rdx,(%rdi,%rax,8)
	jmp L288
L287:
	cmpl $2684354569,(%r13)
	jz L307
L352:
	cmpl $0,_norm_regs(%rip)
	jl L356
L355:
	movl $0,_norm_regs+4(%rip)
	jmp L357
L356:
	movl _norm_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_norm_regs,%edi
	call _vector_insert
L357:
	xorl %edx,%edx
	movl $_norm_regs,%esi
	movq %r13,%rdi
	call _insn_defs
	xorl %esi,%esi
L358:
	cmpl _norm_regs+4(%rip),%esi
	jge L288
L362:
	movq _norm_regs+8(%rip),%rax
	movslq %esi,%rsi
	movl (%rax,%rsi,4),%eax
	movl %eax,-12(%rbp)
	testl %eax,%eax
	jz L288
L363:
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq _norm_0s+8(%rip),%rcx
	sarl $20,%eax
	movslq %eax,%rax
	andq %rdx,(%rcx,%rax,8)
	movl -12(%rbp),%eax
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq _norm_1s+8(%rip),%rcx
	sarl $20,%eax
	movslq %eax,%rax
	andq %rdx,(%rcx,%rax,8)
	incl %esi
	jmp L358
L307:
	movl 16(%r13),%eax
	movl %eax,-12(%rbp)
	movl 40(%r13),%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L315
L317:
	cmpq $0,64(%r13)
	jnz L315
L318:
	cmpq $0,56(%r13)
	jnz L315
L314:
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	movq _norm_0s+8(%rip),%rcx
	sarl $20,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
	jmp L312
L315:
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq _norm_0s+8(%rip),%rcx
	sarl $20,%eax
	movslq %eax,%rax
	andq %rdx,(%rcx,%rax,8)
L312:
	movl 40(%r13),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L332
L334:
	cmpq $0,64(%r13)
	jnz L332
L335:
	testl $229376,%eax
	jz L344
L342:
	movsd 56(%r13),%xmm0
	ucomisd L375(%rip),%xmm0
	jz L339
L344:
	cmpq $1,56(%r13)
	jz L339
L332:
	movl -12(%rbp),%eax
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq _norm_1s+8(%rip),%rcx
	sarl $20,%eax
	movslq %eax,%rax
	andq %rdx,(%rcx,%rax,8)
	jmp L288
L339:
	movl -12(%rbp),%eax
	andl $1073725440,%eax
	movl %eax,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	movq _norm_1s+8(%rip),%rcx
	sarl $20,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
L288:
	incl %r15d
	jmp L112
L111:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cmp:
L377:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L378:
	movq %rdi,%r14
	xorl %r13d,%r13d
L380:
	cmpl 12(%r14),%r13d
	jge L379
L384:
	movq 16(%r14),%rax
	movslq %r13d,%r13
	movq (%rax,%r13,8),%r12
	testq %r12,%r12
	jz L379
L385:
	cmpl $603979787,(%r12)
	jnz L382
L390:
	movl %r13d,%edx
	movl $1074266112,%esi
	movq %r14,%rdi
	call _range_by_def
	movl %eax,%ebx
	movl %eax,%esi
	movq %r14,%rdi
	call _range_span
	cmpl $2147483646,%eax
	jg L382
L394:
	movl 8(%r12),%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L401
L399:
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $2,%eax
	jz L382
L401:
	cmpl $1,%ecx
	jnz L409
L411:
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L409
L412:
	movl 16(%r12),%eax
	cmpl 48(%r12),%eax
	jb L382
L409:
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $2,%eax
	jz L382
L420:
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 40(%r12),%rsi
	leaq 8(%r12),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 40(%r12),%rdi
	rep 
	movsb 
L423:
	incl %ebx
	movq 296(%r14),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $2,%rax
	cmpl (%rcx,%rax),%r13d
	jnz L382
L430:
	cmpl $1074266112,4(%rcx,%rax)
	jnz L382
L432:
	movl 8(%rcx,%rax),%eax
	cmpl $2147483646,%eax
	jnz L436
L435:
	movq %r14,%rdi
	call _commute_succs
	jmp L423
L436:
	movq 16(%r14),%rcx
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rcx
	movl (%rcx),%eax
	subl $2550136856,%eax
	movslq %eax,%rax
	movsbl _commuted_cc(%rax),%eax
	addl $2550136856,%eax
	movl %eax,(%rcx)
	jmp L423
L382:
	incl %r13d
	jmp L380
L379:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_opt_lir_norm:
L438:
	pushq %rbx
L439:
	movl $2,%edi
	call _live_analyze
	movl $0,_norm_regs(%rip)
	movl $0,_norm_regs+4(%rip)
	movq $0,_norm_regs+8(%rip)
	movq $_local_arena,_norm_regs+16(%rip)
	movl $0,_norm_0s(%rip)
	movl $0,_norm_0s+4(%rip)
	movq $0,_norm_0s+8(%rip)
	movq $_local_arena,_norm_0s+16(%rip)
	movl $0,_norm_1s(%rip)
	movl $0,_norm_1s+4(%rip)
	movq $0,_norm_1s+8(%rip)
	movq $_local_arena,_norm_1s+16(%rip)
	movl _nr_assigned_regs(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
	cmpl $0,%edx
	jg L463
L462:
	movl %edx,_norm_0s+4(%rip)
	jmp L464
L463:
	movl $8,%ecx
	xorl %esi,%esi
	movl $_norm_0s,%edi
	call _vector_insert
L464:
	movl _nr_assigned_regs(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
	cmpl _norm_1s(%rip),%edx
	jg L472
L471:
	movl %edx,_norm_1s+4(%rip)
	jmp L473
L472:
	movl _norm_1s+4(%rip),%esi
	subl %esi,%edx
	movl $8,%ecx
	movl $_norm_1s,%edi
	call _vector_insert
L473:
	movq _all_blocks(%rip),%rbx
L474:
	testq %rbx,%rbx
	jz L477
L475:
	movq %rbx,%rdi
	call _cmp
	movq 112(%rbx),%rbx
	jmp L474
L477:
	movq _all_blocks(%rip),%rbx
L478:
	testq %rbx,%rbx
	jz L482
L479:
	movq %rbx,%rdi
	call _norm
	movq 112(%rbx),%rbx
	jmp L478
L482:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L440:
	popq %rbx
	ret 

.local _norm_0s
.comm _norm_0s, 24, 8
.local _norm_1s
.comm _norm_1s, 24, 8
.local _norm_regs
.comm _norm_regs, 24, 8

.globl _all_blocks
.globl _range_span
.globl _commute_succs
.globl _range_by_def
.globl _norms
.globl _char_type
.globl _opt_lir_norm
.globl _live_analyze
.globl _insn_is_copy
.globl _commute_insn
.globl _normalize_con
.globl _opt_request
.globl _nr_assigned_regs
.globl _local_arena
.globl _new_insn
.globl _vector_insert
.globl _pow2
.globl _insn_defs
.globl _commuted_cc
