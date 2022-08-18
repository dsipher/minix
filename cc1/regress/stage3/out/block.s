.text

_new_block:
L1:
	pushq %rbx
L4:
	movq _func_arena+8(%rip),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L9
L7:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,_func_arena+8(%rip)
L9:
	movq _func_arena+8(%rip),%rbx
	leaq 824(%rbx),%rax
	movq %rax,_func_arena+8(%rip)
	movl $824,%ecx
	movq %rbx,%rdi
	xorl %eax,%eax
	rep 
	stosb 
	movl _last_asmlab(%rip),%eax
	incl %eax
	movl %eax,_last_asmlab(%rip)
	movl %eax,(%rbx)
	movl $0,8(%rbx)
	movl $0,12(%rbx)
	movq $0,16(%rbx)
	movq $_func_arena,24(%rbx)
	movl $0,32(%rbx)
	movl $0,36(%rbx)
	movq $0,40(%rbx)
	movq $_func_arena,48(%rbx)
	movl $0,56(%rbx)
	movl $0,60(%rbx)
	movq $0,64(%rbx)
	movq $_func_arena,72(%rbx)
	movl $0,128(%rbx)
	movl $0,132(%rbx)
	movq $0,136(%rbx)
	movq $_func_arena,144(%rbx)
	movl $0,160(%rbx)
	movl $0,164(%rbx)
	movq $0,168(%rbx)
	movq $_func_arena,176(%rbx)
	movq $0,120(%rbx)
	movq _all_blocks(%rip),%rax
	testq %rax,%rax
	jz L30
L28:
	movq %rbx,120(%rax)
L30:
	movq _all_blocks(%rip),%rax
	movq %rax,112(%rbx)
	movq %rbx,_all_blocks(%rip)
	movq %rbx,%rdi
	call _new_live
	movq %rbx,%rdi
	call _new_reach
	movq %rbx,%rax
L3:
	popq %rbx
	ret 


_kill_block:
L32:
	pushq %rbx
L33:
	movq %rdi,%rbx
	movq %rbx,%rdi
	call _remove_succs
	movq 112(%rbx),%rcx
	testq %rcx,%rcx
	jz L40
L38:
	movq 120(%rbx),%rax
	movq %rax,120(%rcx)
L40:
	movq 120(%rbx),%rcx
	movq 112(%rbx),%rax
	testq %rcx,%rcx
	jz L42
L41:
	movq %rax,112(%rcx)
	jmp L34
L42:
	movq %rax,_all_blocks(%rip)
L34:
	popq %rbx
	ret 


_add_pred:
L44:
	pushq %rbx
	pushq %r12
L45:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl 36(%r12),%esi
	leal 1(%rsi),%eax
	cmpl 32(%r12),%eax
	jge L51
L50:
	movl %eax,36(%r12)
	jmp L52
L51:
	movl $8,%ecx
	movl $1,%edx
	leaq 32(%r12),%rdi
	call _vector_insert
L52:
	movq 40(%r12),%rcx
	movl 36(%r12),%eax
	decl %eax
	movslq %eax,%rax
	movq %rbx,(%rcx,%rax,8)
L46:
	popq %r12
	popq %rbx
	ret 


_remove_pred:
L53:
L54:
	movq %rsi,%rdx
	xorl %esi,%esi
L56:
	cmpl 36(%rdi),%esi
	jge L55
L57:
	movq 40(%rdi),%rcx
	movslq %esi,%rax
	cmpq (%rcx,%rax,8),%rdx
	jz L60
L62:
	incl %esi
	jmp L56
L60:
	movl $8,%ecx
	movl $1,%edx
	addq $32,%rdi
	call _vector_delete
L55:
	ret 


_is_pred:
L64:
L65:
	xorl %eax,%eax
L67:
	cmpl 36(%rsi),%eax
	jge L70
L68:
	movq 40(%rsi),%rcx
	movslq %eax,%rax
	cmpq (%rcx,%rax,8),%rdi
	jz L71
L73:
	incl %eax
	jmp L67
L71:
	movl $1,%eax
	ret
L70:
	xorl %eax,%eax
L66:
	ret 


_add_succ:
L76:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L77:
	movq %rdi,%r13
	movl %esi,%r12d
	movq %rdx,%rbx
	cmpl $13,%r12d
	jz L78
L79:
	xorl %r14d,%r14d
L82:
	cmpl 60(%r13),%r14d
	jge L90
L83:
	movq 64(%r13),%rcx
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rax
	shlq $3,%rax
	cmpq 16(%rcx,%rax),%rbx
	jz L86
L88:
	incl %r14d
	jmp L82
L86:
	movl (%rcx,%rax),%esi
	movl %r12d,%edi
	call _union_cc
	movl %eax,%r12d
	movl %r14d,%esi
	movq %r13,%rdi
	call _remove_succ
L90:
	movl 60(%r13),%esi
	leal 1(%rsi),%eax
	cmpl 56(%r13),%eax
	jge L94
L93:
	movl %eax,60(%r13)
	jmp L95
L94:
	movl $24,%ecx
	movl $1,%edx
	leaq 56(%r13),%rdi
	call _vector_insert
L95:
	movq 64(%r13),%rcx
	movl 60(%r13),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl %r12d,(%rcx,%rax)
	movq 64(%r13),%rcx
	movl 60(%r13),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %rbx,16(%rcx,%rax)
	movq %r13,%rsi
	movq %rbx,%rdi
	call _add_pred
L78:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_replace_succ:
L96:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L97:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	testl $1,4(%r13)
	jnz L99
L109:
	xorl %esi,%esi
L110:
	cmpl 60(%r13),%esi
	jge L98
L111:
	movq 64(%r13),%rcx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq 16(%rcx,%rax),%r12
	jz L114
L116:
	incl %esi
	jmp L110
L114:
	movl (%rcx,%rax),%r14d
	movq %r13,%rdi
	call _remove_succ
	movq %rbx,%rdx
	movl %r14d,%esi
	movq %r13,%rdi
	call _add_succ
	jmp L109
L99:
	xorl %r14d,%r14d
L102:
	cmpl 60(%r13),%r14d
	jge L98
L103:
	movq 64(%r13),%rcx
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rax
	shlq $3,%rax
	cmpq 16(%rcx,%rax),%r12
	jnz L108
L106:
	movq %rbx,16(%rcx,%rax)
	movq %r13,%rsi
	movq %r12,%rdi
	call _remove_pred
	movq %r13,%rsi
	movq %rbx,%rdi
	call _add_pred
L108:
	incl %r14d
	jmp L102
L98:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_rewrite_znz_succs:
L118:
L119:
	xorl %eax,%eax
	xorl %r8d,%r8d
L121:
	cmpl 60(%rdi),%r8d
	jge L120
L122:
	movq 64(%rdi),%r9
	movslq %r8d,%r8
	leaq (%r8,%r8,2),%rdx
	shlq $3,%rdx
	movl (%r9,%rdx),%ecx
	testl %ecx,%ecx
	jz L128
L135:
	cmpl $1,%ecx
	jnz L126
L130:
	movl %esi,(%r9,%rdx)
	jmp L133
L128:
	movl %esi,%eax
	xorl $1,%eax
	movl %eax,(%r9,%rdx)
L133:
	movl $1,%eax
L126:
	incl %r8d
	jmp L121
L120:
	ret 


_commute_succs:
L138:
L139:
	xorl %edx,%edx
L141:
	cmpl 60(%rdi),%edx
	jge L140
L142:
	movq 64(%rdi),%rsi
	movslq %edx,%rdx
	leaq (%rdx,%rdx,2),%rcx
	shlq $3,%rcx
	movslq (%rsi,%rcx),%rax
	movsbl _commuted_cc(%rax),%eax
	movl %eax,(%rsi,%rcx)
	incl %edx
	jmp L141
L140:
	ret 


_remove_succ:
L145:
	pushq %rbx
	pushq %r12
L146:
	movq %rdi,%r12
	movl %esi,%ebx
	movq 64(%r12),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq %r12,%rsi
	movq 16(%rcx,%rax),%rdi
	call _remove_pred
	movl $24,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 56(%r12),%rdi
	call _vector_delete
L147:
	popq %r12
	popq %rbx
	ret 


_remove_succs:
L148:
	pushq %rbx
	pushq %r12
L149:
	movq %rdi,%r12
	xorl %ebx,%ebx
L151:
	movl 60(%r12),%esi
	cmpl %esi,%ebx
	jge L155
L152:
	movq 64(%r12),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq %r12,%rsi
	movq 16(%rcx,%rax),%rdi
	call _remove_pred
	incl %ebx
	jmp L151
L155:
	cmpl $0,56(%r12)
	jl L159
L158:
	movl $0,60(%r12)
	jmp L160
L159:
	xorl %edx,%edx
	subl %esi,%edx
	movl $24,%ecx
	leaq 56(%r12),%rdi
	call _vector_insert
L160:
	andl $-2,4(%r12)
L150:
	popq %r12
	popq %rbx
	ret 


_dup_succs:
L161:
	pushq %rbx
	pushq %r12
L162:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rdi
	call _remove_succs
	movl $24,%edx
	leaq 56(%r12),%rsi
	leaq 56(%rbx),%rdi
	call _dup_vector
	testl $1,4(%r12)
	jz L169
L167:
	movl 4(%rbx),%ecx
	orl $1,%ecx
	movl %ecx,4(%rbx)
	movl 4(%r12),%eax
	andl $24,%eax
	orl %ecx,%eax
	movl %eax,4(%rbx)
	movl $32,%ecx
	leaq 80(%r12),%rsi
	leaq 80(%rbx),%rdi
	rep 
	movsb 
L169:
	xorl %r12d,%r12d
L170:
	cmpl 60(%rbx),%r12d
	jge L163
L171:
	movq 64(%rbx),%rcx
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rax
	shlq $3,%rax
	movq %rbx,%rsi
	movq 16(%rcx,%rax),%rdi
	call _add_pred
	incl %r12d
	jmp L170
L163:
	popq %r12
	popq %rbx
	ret 


_fuse_block:
L174:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L175:
	movq %rdi,%r14
	xorl %r13d,%r13d
L177:
	cmpq _entry_block(%rip),%r14
	jz L182
L196:
	movq %r14,%rdi
	call _unconditional_succ
	movq %rax,%r12
	testq %r12,%r12
	jz L182
L197:
	cmpq _exit_block(%rip),%r12
	jz L182
L193:
	cmpq %r12,%r14
	jz L182
L189:
	cmpl $1,36(%r12)
	jnz L182
L185:
	testl $32,4(%r12)
	jnz L182
L181:
	movl 12(%r14),%r15d
	movl 12(%r12),%ebx
	testl %ebx,%ebx
	jz L202
L203:
	leal (%r15,%rbx),%eax
	cmpl 8(%r14),%eax
	jge L207
L206:
	movl %eax,12(%r14)
	jmp L208
L207:
	movl $8,%ecx
	movl %ebx,%edx
	movl %r15d,%esi
	leaq 8(%r14),%rdi
	call _vector_insert
L208:
	movq 16(%r14),%rax
	movslq %r15d,%r15
	movslq %ebx,%rcx
	shlq $3,%rcx
	movq 16(%r12),%rsi
	leaq (%rax,%r15,8),%rdi
	rep 
	movsb 
L202:
	movq %r12,%rsi
	movq %r14,%rdi
	call _dup_succs
	movq %r12,%rdi
	call _remove_succs
	movq 112(%r12),%rcx
	testq %rcx,%rcx
	jz L214
L212:
	movq 120(%r12),%rax
	movq %rax,120(%rcx)
L214:
	movq 120(%r12),%rcx
	movq 112(%r12),%rax
	testq %rcx,%rcx
	jz L216
L215:
	movq %rax,112(%rcx)
	jmp L217
L216:
	movq %rax,_all_blocks(%rip)
L217:
	incl %r13d
	jmp L177
L182:
	movl %r13d,%eax
L176:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_bypass_succ:
L219:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L220:
	movq %rdi,%rbx
	movl %esi,%r15d
	movq 64(%rbx),%rax
	movslq %r15d,%r15
	leaq (%r15,%r15,2),%r12
	shlq $3,%r12
	movq 16(%rax,%r12),%r14
	movq %r14,%rdi
	call _unconditional_succ
	cmpl $0,12(%r14)
	jnz L254
L224:
	movl 4(%r14),%eax
	testl $1,%eax
	jnz L254
L228:
	cmpq %r14,%rbx
	jz L254
L232:
	testl $32,%eax
	jnz L254
L236:
	movq %r14,%rdi
	call _unconditional_succ
	movq %rax,%rdi
	cmpq %rdi,%r14
	jz L254
L240:
	testl $1,4(%rbx)
	jz L243
L242:
	testq %rdi,%rdi
	jnz L247
L254:
	xorl %eax,%eax
	jmp L221
L247:
	movq 64(%rbx),%rax
	movq %rdi,16(%r12,%rax)
	movq %rbx,%rsi
	call _add_pred
	movq %rbx,%rsi
	movq %r14,%rdi
	call _remove_pred
	jmp L244
L243:
	movq 64(%rbx),%rax
	movl (%r12,%rax),%r13d
	movl %r15d,%esi
	movq %rbx,%rdi
	call _remove_succ
	xorl %r12d,%r12d
L249:
	cmpl 60(%r14),%r12d
	jge L244
L250:
	movq 64(%r14),%rcx
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%r15
	movl (%rcx,%rax),%esi
	movl %r13d,%edi
	call _intersect_cc
	movq %r15,%rdx
	movl %eax,%esi
	movq %rbx,%rdi
	call _add_succ
	incl %r12d
	jmp L249
L244:
	movl $1,%eax
L221:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_conditional_block:
L255:
L256:
	testl $1,4(%rdi)
	jnz L259
L265:
	cmpl $0,60(%rdi)
	jz L259
L261:
	movq 64(%rdi),%rax
	cmpl $11,(%rax)
	jg L259
L258:
	movl $1,%eax
	ret
L259:
	xorl %eax,%eax
L257:
	ret 


_predict_succ:
L271:
	pushq %rbx
	pushq %r12
L272:
	movq %rdi,%rbx
	xorl %r8d,%r8d
L274:
	cmpl 60(%rbx),%r8d
	jge L277
L275:
	movq 64(%rbx),%r9
	movslq %r8d,%r8
	leaq (%r8,%r8,2),%rdi
	shlq $3,%rdi
	movl (%r9,%rdi),%ecx
	movl $1,%eax
	shll %cl,%eax
	testl %esi,%eax
	jnz L278
L280:
	incl %r8d
	jmp L274
L278:
	movq 16(%r9,%rdi),%r12
L277:
	testl %edx,%edx
	jz L284
L282:
	movq %rbx,%rdi
	call _remove_succs
	movq %r12,%rdx
	movl $12,%esi
	movq %rbx,%rdi
	call _add_succ
L284:
	movq %r12,%rax
L273:
	popq %r12
	popq %rbx
	ret 


_unconditional_succ:
L286:
L287:
	testl $1,4(%rdi)
	jnz L290
L296:
	cmpl $0,60(%rdi)
	jz L290
L292:
	movq 64(%rdi),%rax
	cmpl $12,(%rax)
	jnz L290
L289:
	movq 16(%rax),%rax
	ret
L290:
	xorl %eax,%eax
L288:
	ret 


_switch_block:
L302:
L303:
	movq %rdi,%rax
	orl $1,4(%rax)
	movl $32,%ecx
	leaq 80(%rax),%rdi
	rep 
	movsb 
	movl $14,%esi
	movq %rax,%rdi
	call _add_succ
L304:
	ret 


_unswitch_block:
L305:
	pushq %rbx
	pushq %r12
L306:
	movq %rdi,%rbx
	movl 80(%rbx),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L309
L311:
	cmpq $0,104(%rbx)
	jnz L309
L308:
	subq $8,%rsp
	movq 96(%rbx),%rax
	movq %rax,(%rsp)
	movl $1,%esi
	movq %rbx,%rdi
	call _predict_switch_succ
	addq $8,%rsp
	jmp L310
L309:
	movq 64(%rbx),%rax
	movq 16(%rax),%r12
	movl $1,%ecx
L315:
	cmpl 60(%rbx),%ecx
	jge L318
L316:
	movq 64(%rbx),%rdx
	movslq %ecx,%rcx
	leaq (%rcx,%rcx,2),%rax
	shlq $3,%rax
	cmpq 16(%rdx,%rax),%r12
	jnz L319
L321:
	incl %ecx
	jmp L315
L319:
	xorl %eax,%eax
	jmp L307
L318:
	movq %rbx,%rdi
	call _remove_succs
	movq %r12,%rdx
	movl $12,%esi
	movq %rbx,%rdi
	call _add_succ
L310:
	movl $1,%eax
L307:
	popq %r12
	popq %rbx
	ret 


_add_switch_succ:
L324:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L325:
	movq %rdi,%r14
	movq %rsi,%r13
	movq %rdx,%r12
	movl 80(%r14),%edi
	shll $10,%edi
	shrl $15,%edi
	cmpl $64,%edi
	jbe L328
L327:
	jmp L329
L328:
	movl $64,%edi
L329:
	movq %r13,%rsi
	call _normalize_con
	movl $1,%ebx
L330:
	movl 60(%r14),%esi
	cmpl %esi,%ebx
	jge L338
L331:
	movq 64(%r14),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 8(%rcx,%rax),%rax
	cmpq (%r13),%rax
	jnz L336
L334:
	pushq $L337
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L336:
	incl %ebx
	jmp L330
L338:
	leal 1(%rsi),%eax
	cmpl 56(%r14),%eax
	jge L342
L341:
	movl %eax,60(%r14)
	jmp L343
L342:
	movl $24,%ecx
	movl $1,%edx
	leaq 56(%r14),%rdi
	call _vector_insert
L343:
	movq 64(%r14),%rcx
	movl 60(%r14),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl $15,(%rcx,%rax)
	movq (%r13),%rdx
	movq 64(%r14),%rcx
	movl 60(%r14),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %rdx,8(%rcx,%rax)
	movq 64(%r14),%rcx
	movl 60(%r14),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %r12,16(%rcx,%rax)
	movq %r14,%rsi
	movq %r12,%rdi
	call _add_pred
L326:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_trim_switch_block:
L344:
	pushq %rbx
	pushq %r12
	pushq %r13
L345:
	movq %rdi,%r13
	movl $1,%r12d
L347:
	cmpl 60(%r13),%r12d
	jge L346
L348:
	movl 80(%r13),%edi
	shll $10,%edi
	shrl $15,%edi
	movq 64(%r13),%rax
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rbx
	shlq $3,%rbx
	leaq 8(%rax,%rbx),%rsi
	call _con_in_range
	testl %eax,%eax
	jnz L351
L350:
	movq 64(%r13),%rax
	movq %r13,%rsi
	movq 16(%rbx,%rax),%rdi
	call _remove_pred
	movl $24,%ecx
	movl $1,%edx
	movl %r12d,%esi
	leaq 56(%r13),%rdi
	call _vector_delete
	jmp L347
L351:
	incl %r12d
	jmp L347
L346:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_predict_switch_succ:
L353:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L354:
	movq %rdi,%r13
	movl %esi,%r12d
	movl 80(%r13),%edi
	shll $10,%edi
	shrl $15,%edi
	cmpl $64,%edi
	jbe L357
L356:
	jmp L358
L357:
	movl $64,%edi
L358:
	leaq 16(%rbp),%rsi
	call _normalize_con
	movq 64(%r13),%rax
	movq 16(%rax),%rbx
	movl $1,%edx
L359:
	cmpl 60(%r13),%edx
	jge L362
L360:
	movq 64(%r13),%rsi
	movslq %edx,%rdx
	leaq (%rdx,%rdx,2),%rcx
	shlq $3,%rcx
	movq 8(%rsi,%rcx),%rax
	cmpq 16(%rbp),%rax
	jz L363
L365:
	incl %edx
	jmp L359
L363:
	movq 16(%rsi,%rcx),%rbx
L362:
	testl %r12d,%r12d
	jz L369
L367:
	movq %r13,%rdi
	call _remove_succs
	movq %rbx,%rdx
	movl $12,%esi
	movq %r13,%rdi
	call _add_succ
L369:
	movq %rbx,%rax
L355:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret 


_reset_blocks:
L371:
L372:
	movq $0,_all_blocks(%rip)
	call _new_block
	movq %rax,_entry_block(%rip)
	call _new_block
	movq %rax,_current_block(%rip)
	movq %rax,%rdx
	movl $12,%esi
	movq _entry_block(%rip),%rdi
	call _add_succ
	call _new_block
	movq %rax,_exit_block(%rip)
L373:
	ret 


_undecorate_blocks:
L374:
	pushq %rbx
	pushq %r12
	pushq %r13
L375:
	movq _all_blocks(%rip),%r13
L377:
	testq %r13,%r13
	jz L376
L378:
	xorl %r12d,%r12d
L381:
	cmpl 12(%r13),%r12d
	jge L387
L385:
	movq 16(%r13),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rbx
	testq %rbx,%rbx
	jz L387
L386:
	cmpl $8388609,(%rbx)
	jnz L390
L389:
	leaq 16(%rbx),%rdi
	call _undecorate_regmap
	leaq 40(%rbx),%rdi
	call _undecorate_regmap
	jmp L391
L390:
	xorl %edx,%edx
L392:
	movl (%rbx),%ecx
	andl $805306368,%ecx
	sarl $28,%ecx
	movl 4(%rbx),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%ecx
	cmpl %ecx,%edx
	jae L391
L396:
	movslq %edx,%rax
	shlq $5,%rax
	andl $-16384,16(%rbx,%rax)
	andl $-16384,20(%rax,%rbx)
	incl %edx
	jmp L392
L391:
	incl %r12d
	jmp L381
L387:
	andl $-16384,88(%r13)
	andl $-16384,92(%r13)
	movq 112(%r13),%r13
	jmp L377
L376:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_substitute_reg:
L402:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L403:
	movl %edi,%r13d
	movl %esi,%r12d
	movq _all_blocks(%rip),%rbx
L405:
	testq %rbx,%rbx
	jz L404
L406:
	xorl %r14d,%r14d
L409:
	cmpl 12(%rbx),%r14d
	jge L412
L413:
	movq 16(%rbx),%rax
	movslq %r14d,%r14
	movq (%rax,%r14,8),%rdi
	testq %rdi,%rdi
	jz L412
L410:
	xorl %r8d,%r8d
	movl $3,%ecx
	movl %r12d,%edx
	movl %r13d,%esi
	call _insn_substitute_reg
	incl %r14d
	jmp L409
L412:
	testl $1,4(%rbx)
	jz L419
L424:
	movl 80(%rbx),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L419
L420:
	cmpl 88(%rbx),%r13d
	jnz L419
L417:
	movl %r12d,88(%rbx)
L419:
	movq 112(%rbx),%rbx
	jmp L405
L404:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_all_regs:
L428:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L429:
	movq %rdi,%r12
	cmpl $0,(%r12)
	jl L435
L434:
	movl $0,4(%r12)
	jmp L436
L435:
	movl 4(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movq %r12,%rdi
	call _vector_insert
L436:
	movq _all_blocks(%rip),%rbx
L437:
	testq %rbx,%rbx
	jz L430
L438:
	xorl %r14d,%r14d
L441:
	cmpl 12(%rbx),%r14d
	jge L447
L445:
	movq 16(%rbx),%rax
	movslq %r14d,%r14
	movq (%rax,%r14,8),%r13
	testq %r13,%r13
	jz L447
L446:
	xorl %edx,%edx
	movq %r12,%rsi
	movq %r13,%rdi
	call _insn_defs
	xorl %edx,%edx
	movq %r12,%rsi
	movq %r13,%rdi
	call _insn_uses
	incl %r14d
	jmp L441
L447:
	testl $1,4(%rbx)
	jz L451
L452:
	movl 80(%rbx),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L451
L453:
	movl 88(%rbx),%esi
	movq %r12,%rdi
	call _add_reg
L451:
	movq 112(%rbx),%rbx
	jmp L437
L430:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_iterate_blocks:
L456:
	pushq %rbx
	pushq %r12
	pushq %r13
L457:
	movq %rdi,%r13
L459:
	xorl %r12d,%r12d
	movq _all_blocks(%rip),%rbx
L462:
	testq %rbx,%rbx
	jz L465
L463:
	movq %rbx,%rdi
	call *%r13
	cmpl $1,%eax
	movl $1,%eax
	cmovzl %eax,%r12d
	movq 112(%rbx),%rbx
	jmp L462
L465:
	testl %r12d,%r12d
	jnz L459
L458:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_walk0:
L469:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L470:
	movl %edi,%r15d
	movq %rsi,%r14
	movq %rdx,%r13
	movq %rcx,%r12
	movl 4(%r14),%eax
	testl $2,%eax
	jnz L471
L472:
	orl $2,%eax
	movl %eax,4(%r14)
	testq %r13,%r13
	jz L477
L475:
	movq %r14,%rdi
	call *%r13
L477:
	xorl %ebx,%ebx
	testl %r15d,%r15d
	jnz L485
L481:
	cmpl 60(%r14),%ebx
	jge L480
L482:
	movq 64(%r14),%rsi
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq %r12,%rcx
	movq %r13,%rdx
	movq 16(%rsi,%rax),%rsi
	xorl %edi,%edi
	call _walk0
	incl %ebx
	jmp L481
L485:
	cmpl 36(%r14),%ebx
	jge L480
L486:
	movq 40(%r14),%rsi
	movslq %ebx,%rax
	movq %r12,%rcx
	movq %r13,%rdx
	movq (%rsi,%rax,8),%rsi
	movl $1,%edi
	call _walk0
	incl %ebx
	jmp L485
L480:
	testq %r12,%r12
	jz L471
L489:
	movq %r14,%rdi
	call *%r12
L471:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_walk_blocks:
L492:
L493:
	movq %rsi,%r8
	movq %rdx,%rcx
	movq _all_blocks(%rip),%rax
L495:
	testq %rax,%rax
	jz L498
L496:
	andl $-3,4(%rax)
	movq 112(%rax),%rax
	jmp L495
L498:
	testl %edi,%edi
	jz L500
L499:
	movq _exit_block(%rip),%rsi
	jmp L501
L500:
	movq _entry_block(%rip),%rsi
L501:
	movq %r8,%rdx
	call _walk0
L494:
	ret 


_sequence0:
L502:
L503:
	movq 112(%rdi),%rcx
	testq %rcx,%rcx
	jz L510
L508:
	movq 120(%rdi),%rax
	movq %rax,120(%rcx)
L510:
	movq 120(%rdi),%rcx
	movq 112(%rdi),%rax
	testq %rcx,%rcx
	jz L512
L511:
	movq %rax,112(%rcx)
	jmp L513
L512:
	movq %rax,_all_blocks(%rip)
L513:
	movq $0,120(%rdi)
	movq _all_blocks(%rip),%rax
	testq %rax,%rax
	jz L519
L517:
	movq %rdi,120(%rax)
L519:
	movq _all_blocks(%rip),%rax
	movq %rax,112(%rdi)
	movq %rdi,_all_blocks(%rip)
L504:
	ret 


_sequence_blocks:
L520:
L521:
	movl $_sequence0,%edx
	xorl %esi,%esi
	call _walk_blocks
L522:
	ret 


_out_block:
L523:
	pushq %rbx
	pushq %r12
L524:
	movq %rdi,%rbx
	movl (%rbx),%eax
	pushq %rax
	pushq $L526
	call _out
	addq $16,%rsp
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L528
L527:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L529
L528:
	movl $10,%edi
	call ___flushbuf
L529:
	xorl %r12d,%r12d
L530:
	cmpl 12(%rbx),%r12d
	jge L525
L531:
	movq 16(%rbx),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rdi
	call _out_insn
	incl %r12d
	jmp L530
L525:
	popq %r12
	popq %rbx
	ret 


_append_insn:
L534:
	pushq %rbx
	pushq %r12
L535:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl 12(%rbx),%esi
	leal 1(%rsi),%eax
	cmpl 8(%rbx),%eax
	jge L541
L540:
	movl %eax,12(%rbx)
	jmp L542
L541:
	movl $8,%ecx
	movl $1,%edx
	leaq 8(%rbx),%rdi
	call _vector_insert
L542:
	movl 12(%rbx),%eax
	decl %eax
	movq 16(%rbx),%rcx
	movslq %eax,%rax
	movq %r12,(%rcx,%rax,8)
L536:
	popq %r12
	popq %rbx
	ret 


_insert_insn:
L544:
	pushq %rbx
	pushq %r12
	pushq %r13
L545:
	movq %rdi,%r13
	movq %rsi,%r12
	movl %edx,%ebx
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 8(%r12),%rdi
	call _vector_insert
	movq 16(%r12),%rax
	movslq %ebx,%rbx
	movq %r13,(%rax,%rbx,8)
L546:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_delete_insn:
L547:
L548:
	movl $8,%ecx
	movl $1,%edx
	addq $8,%rdi
	call _vector_delete
L549:
	ret 


_add_block:
L550:
	pushq %rbx
	pushq %r12
	pushq %r13
L551:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L553:
	cmpl 4(%r13),%ebx
	jge L556
L554:
	movq 8(%r13),%rax
	movslq %ebx,%rbx
	cmpq (%rax,%rbx,8),%r12
	jb L556
	jz L552
L563:
	incl %ebx
	jmp L553
L556:
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	movq %r13,%rdi
	call _vector_insert
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movq %r12,(%rcx,%rax,8)
L552:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_contains_block:
L565:
L566:
	xorl %eax,%eax
L568:
	cmpl 4(%rdi),%eax
	jge L571
L569:
	movq 8(%rdi),%rcx
	movslq %eax,%rax
	cmpq (%rcx,%rax,8),%rsi
	jz L572
	jb L571
L578:
	incl %eax
	jmp L568
L572:
	movl $1,%eax
	ret
L571:
	xorl %eax,%eax
L567:
	ret 


_same_blocks:
L581:
L582:
	movl 4(%rdi),%ecx
	xorl %eax,%eax
	cmpl 4(%rsi),%ecx
	jnz L583
L588:
	cmpl 4(%rdi),%eax
	jge L591
L589:
	movq 8(%rdi),%rcx
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rdx
	movq 8(%rsi),%rcx
	cmpq (%rcx,%rax,8),%rdx
	jnz L592
L594:
	incl %eax
	jmp L588
L592:
	xorl %eax,%eax
	ret
L591:
	movl $1,%eax
L583:
	ret 


_union_blocks:
L597:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L598:
	movq %rdi,%r15
	movq %rsi,-16(%rbp)
	movq %rdx,%r14
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	movq -16(%rbp),%rax
	movl 4(%rax),%eax
	movl %eax,-4(%rbp)
	movl 4(%r14),%eax
	movl %eax,-8(%rbp)
	cmpl $0,(%r15)
	jl L604
L603:
	movl $0,4(%r15)
	jmp L606
L604:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movq %r15,%rdi
	call _vector_insert
L606:
	cmpl -4(%rbp),%r12d
	jl L610
L609:
	cmpl -8(%rbp),%ebx
	jge L599
L610:
	movq -16(%rbp),%rax
	cmpl 4(%rax),%r12d
	jnz L614
L613:
	movq 8(%r14),%rcx
	movl %ebx,%eax
	incl %ebx
	movslq %eax,%rax
	movq (%rcx,%rax,8),%r13
	jmp L625
L614:
	movl 4(%r14),%ecx
	movq -16(%rbp),%rax
	movq 8(%rax),%rax
	cmpl %ecx,%ebx
	jnz L617
L616:
	movl %r12d,%ecx
	incl %r12d
	movslq %ecx,%rcx
	movq (%rax,%rcx,8),%r13
	jmp L625
L617:
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rcx
	movq 8(%r14),%rax
	movslq %ebx,%rbx
	movq (%rax,%rbx,8),%r13
	cmpq %r13,%rcx
	jae L620
L619:
	incl %r12d
	movq %rcx,%r13
	jmp L625
L620:
	incl %ebx
	cmpq %r13,%rcx
	ja L625
L623:
	incl %r12d
L625:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L629
L628:
	movl %eax,4(%r15)
	jmp L630
L629:
	movl $8,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L630:
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movq %r13,(%rcx,%rax,8)
	jmp L606
L599:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_intersect_blocks:
L631:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L632:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	movl 4(%r14),%eax
	movl %eax,-4(%rbp)
	movl 4(%r13),%eax
	movl %eax,-8(%rbp)
	cmpl $0,(%r15)
	jl L638
L637:
	movl $0,4(%r15)
	jmp L640
L638:
	movl 4(%r15),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movq %r15,%rdi
	call _vector_insert
L640:
	cmpl -4(%rbp),%r12d
	jge L633
L643:
	cmpl -8(%rbp),%ebx
	jge L633
L644:
	movq 8(%r14),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rcx
	movq 8(%r13),%rax
	movslq %ebx,%rbx
	cmpq (%rax,%rbx,8),%rcx
	jb L647
	ja L659
L653:
	movl 4(%r15),%esi
	leal 1(%rsi),%eax
	cmpl (%r15),%eax
	jge L657
L656:
	movl %eax,4(%r15)
	jmp L658
L657:
	movl $8,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _vector_insert
L658:
	movq 8(%r14),%rax
	movq (%rax,%r12,8),%rdx
	movq 8(%r15),%rcx
	movl 4(%r15),%eax
	decl %eax
	movslq %eax,%rax
	movq %rdx,(%rcx,%rax,8)
	incl %r12d
L659:
	incl %ebx
	jmp L640
L647:
	incl %r12d
	jmp L640
L633:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L337:
	.byte 100,117,112,108,105,99,97,116
	.byte 101,32,99,97,115,101,32,108
	.byte 97,98,101,108,0
L526:
	.byte 37,76,58,0
.globl _all_blocks
.comm _all_blocks, 8, 8
.globl _entry_block
.comm _entry_block, 8, 8
.globl _exit_block
.comm _exit_block, 8, 8
.globl _current_block
.comm _current_block, 8, 8

.globl _add_switch_succ
.globl _new_block
.globl _replace_succ
.globl _all_blocks
.globl _union_cc
.globl _error
.globl _sequence_blocks
.globl _predict_succ
.globl _last_asmlab
.globl _union_blocks
.globl _rewrite_znz_succs
.globl _kill_block
.globl _contains_block
.globl _add_block
.globl _is_pred
.globl _bypass_succ
.globl _commute_succs
.globl _predict_switch_succ
.globl _exit_block
.globl _intersect_cc
.globl _current_block
.globl _reset_blocks
.globl _entry_block
.globl _insn_substitute_reg
.globl _intersect_blocks
.globl _trim_switch_block
.globl _new_live
.globl _out_block
.globl _add_reg
.globl _normalize_con
.globl ___flushbuf
.globl _out
.globl _all_regs
.globl _walk_blocks
.globl _conditional_block
.globl _iterate_blocks
.globl _fuse_block
.globl _add_succ
.globl _dup_succs
.globl _undecorate_regmap
.globl _out_f
.globl _append_insn
.globl _con_in_range
.globl _unconditional_succ
.globl _switch_block
.globl _new_reach
.globl _vector_insert
.globl _delete_insn
.globl _func_arena
.globl _remove_succs
.globl _remove_succ
.globl _vector_delete
.globl _out_insn
.globl _undecorate_blocks
.globl _dup_vector
.globl _insn_defs
.globl _substitute_reg
.globl _unswitch_block
.globl _insn_uses
.globl _commuted_cc
.globl _same_blocks
.globl _insert_insn
