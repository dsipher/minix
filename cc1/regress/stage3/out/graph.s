.text

_put:
L1:
L2:
	movl (%rdi),%ecx
	movq _graph+8(%rip),%rax
	andl $1073725440,%ecx
	sarl $14,%ecx
	movslq %ecx,%rcx
	movq (%rax,%rcx,8),%rax
	movq %rax,48(%rdi)
	movq _graph+8(%rip),%rax
	movq %rdi,(%rax,%rcx,8)
L3:
	ret 


_get:
L4:
L5:
	movq _graph+8(%rip),%rcx
	movl (%rdi),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	leaq (%rcx,%rax,8),%rcx
L7:
	movq (%rcx),%rax
	cmpq %rax,%rdi
	jz L9
L8:
	leaq 48(%rax),%rcx
	jmp L7
L9:
	movq 48(%rdi),%rax
	movq %rax,(%rcx)
L6:
	ret 


_find:
L10:
	pushq %rbx
L11:
	movq _graph+8(%rip),%rcx
	movl %edi,%r8d
	movl %r8d,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rbx
L13:
	testq %rbx,%rbx
	jz L18
L16:
	cmpl (%rbx),%r8d
	jz L18
L17:
	movq 48(%rbx),%rbx
	jmp L13
L18:
	testq %rbx,%rbx
	jnz L22
L23:
	testl %esi,%esi
	jz L22
L24:
	movq _local_arena+8(%rip),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L32
L30:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,_local_arena+8(%rip)
L32:
	movq _local_arena+8(%rip),%rdi
	leaq 56(%rdi),%rax
	movq %rax,_local_arena+8(%rip)
	movq %rdi,%rbx
	xorl %eax,%eax
	movq %rax,(%rdi)
	movq %rax,8(%rdi)
	movq %rax,16(%rdi)
	movq %rax,24(%rdi)
	movq %rax,32(%rdi)
	movq %rax,40(%rdi)
	movq %rax,48(%rdi)
	movl $0,16(%rdi)
	movl $0,20(%rdi)
	movq $0,24(%rdi)
	movq $_local_arena,32(%rdi)
	movl %r8d,(%rdi)
	movl %r8d,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L38
L36:
	movl %r8d,4(%rdi)
L38:
	call _put
L22:
	movq %rbx,%rax
L12:
	popq %rbx
	ret 


_add_half:
L40:
	pushq %rbx
	pushq %r12
L41:
	movq %rdi,%r12
	movq %rsi,%rbx
	xorl %eax,%eax
L43:
	movl 20(%r12),%esi
	cmpl %esi,%eax
	jge L51
L44:
	movq 24(%r12),%rcx
	movslq %eax,%rax
	cmpq (%rcx,%rax,8),%rbx
	jz L42
L49:
	incl %eax
	jmp L43
L51:
	leal 1(%rsi),%eax
	cmpl 16(%r12),%eax
	jge L55
L54:
	movl %eax,20(%r12)
	jmp L56
L55:
	movl $8,%ecx
	movl $1,%edx
	leaq 16(%r12),%rdi
	call _vector_insert
L56:
	movq 24(%r12),%rcx
	movl 20(%r12),%eax
	decl %eax
	movslq %eax,%rax
	movq %rbx,(%rcx,%rax,8)
L42:
	popq %r12
	popq %rbx
	ret 


_remove_half:
L57:
L58:
	movq %rsi,%rdx
	xorl %esi,%esi
L60:
	cmpl 20(%rdi),%esi
	jge L59
L61:
	movq 24(%rdi),%rcx
	movslq %esi,%rax
	cmpq (%rcx,%rax,8),%rdx
	jz L64
L66:
	incl %esi
	jmp L60
L64:
	movl $8,%ecx
	movl $1,%edx
	addq $16,%rdi
	call _vector_delete
L59:
	ret 


_push:
L68:
	pushq %rbx
	pushq %r12
L69:
	movq %rdi,%r12
	xorl %ebx,%ebx
L71:
	cmpl 20(%r12),%ebx
	jge L74
L72:
	movq 24(%r12),%rax
	movslq %ebx,%rbx
	movq %r12,%rsi
	movq (%rax,%rbx,8),%rdi
	call _remove_half
	incl %ebx
	jmp L71
L74:
	movq %r12,%rdi
	call _get
	movq _stack(%rip),%rax
	movq %rax,48(%r12)
	movq %r12,_stack(%rip)
L70:
	popq %r12
	popq %rbx
	ret 


_pop:
L75:
	pushq %rbx
	pushq %r12
L76:
	movq _stack(%rip),%rbx
	movq 48(%rbx),%rax
	movq %rax,_stack(%rip)
L78:
	xorl %esi,%esi
L79:
	cmpl 20(%rbx),%esi
	jge L82
L80:
	movq 24(%rbx),%rcx
	movslq %esi,%rax
	movq (%rcx,%rax,8),%r12
	cmpq $0,40(%r12)
	jz L85
L86:
	movq 40(%r12),%rax
	testq %rax,%rax
	jz L88
L87:
	movq %rax,%r12
	jmp L86
L88:
	movl $8,%ecx
	movl $1,%edx
	leaq 16(%rbx),%rdi
	call _vector_delete
	movq %r12,%rsi
	movq %rbx,%rdi
	call _add_half
	jmp L78
L85:
	incl %esi
	jmp L79
L82:
	xorl %r12d,%r12d
L90:
	cmpl 20(%rbx),%r12d
	jge L93
L91:
	movq 24(%rbx),%rax
	movslq %r12d,%r12
	movq %rbx,%rsi
	movq (%rax,%r12,8),%rdi
	call _add_half
	incl %r12d
	jmp L90
L93:
	movq %rbx,%rdi
	call _put
	movq %rbx,%rax
L77:
	popq %r12
	popq %rbx
	ret 


_is_neighbor:
L95:
L96:
	xorl %eax,%eax
L98:
	cmpl 20(%rdi),%eax
	jge L101
L99:
	movq 24(%rdi),%rcx
	movslq %eax,%rax
	cmpq (%rcx,%rax,8),%rsi
	jz L102
L104:
	incl %eax
	jmp L98
L102:
	movl $1,%eax
	ret
L101:
	xorl %eax,%eax
L97:
	ret 


_build0:
L107:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L108:
	movq _all_blocks(%rip),%r13
L110:
	testq %r13,%r13
	jz L109
L111:
	xorl %r12d,%r12d
L114:
	cmpl 292(%r13),%r12d
	jge L117
L115:
	movq 296(%r13),%rdx
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rcx
	shlq $2,%rcx
	movl (%rdx,%rcx),%eax
	cmpl 8(%rdx,%rcx),%eax
	jnz L120
L118:
	movl $1,%esi
	movl 4(%rdx,%rcx),%edi
	call _find
	movq %rax,%rbx
	cmpl $0,_tmp_regs(%rip)
	jl L125
L124:
	movl $0,_tmp_regs+4(%rip)
	jmp L126
L125:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L126:
	movl $_tmp_regs,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _range_interf
	xorl %r15d,%r15d
L127:
	cmpl _tmp_regs+4(%rip),%r15d
	jge L120
L131:
	movq _tmp_regs+8(%rip),%rax
	movslq %r15d,%r15
	movl (%rax,%r15,4),%edi
	testl %edi,%edi
	jz L120
L132:
	movl $1,%esi
	call _find
	movq %rax,%r14
	movq %r14,%rsi
	movq %rbx,%rdi
	call _add_half
	movq %rbx,%rsi
	movq %r14,%rdi
	call _add_half
	incl %r15d
	jmp L127
L120:
	incl %r12d
	jmp L114
L117:
	movq 112(%r13),%r13
	jmp L110
L109:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_merge0:
L135:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L136:
	movl %edi,%r12d
	movl %esi,%r13d
	xorl %esi,%esi
	movl %r12d,%edi
	call _find
	movq %rax,%rbx
	movq %rbx,%r14
	xorl %esi,%esi
	movl %r13d,%edi
	call _find
	movq %rax,%r13
	andl $3221225472,%r12d
	cmpl $2147483648,%r12d
	jnz L139
L138:
	movl _gp_colors+4(%rip),%r12d
	jmp L140
L139:
	movl _xmm_colors+4(%rip),%r12d
L140:
	testq %rbx,%rbx
	jz L205
L144:
	testq %r13,%r13
	jz L205
L146:
	movq %r13,%rsi
	movq %rbx,%rdi
	call _is_neighbor
	testl %eax,%eax
	jnz L205
L151:
	movl (%rbx),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L158
L156:
	movl (%r13),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L158
L205:
	xorl %eax,%eax
	jmp L137
L158:
	movl (%r13),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L167
L164:
	movq %r13,%r14
	movq %rbx,%r13
L167:
	cmpl $0,_dummy+16(%rip)
	jl L171
L170:
	movl $0,_dummy+20(%rip)
	jmp L172
L171:
	movl _dummy+20(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movl $_dummy+16,%edi
	call _vector_insert
L172:
	movl $8,%edx
	leaq 16(%r14),%rsi
	movl $_dummy+16,%edi
	call _dup_vector
	xorl %ebx,%ebx
L176:
	cmpl 20(%r13),%ebx
	jge L179
L177:
	movq 24(%r13),%rax
	movslq %ebx,%rbx
	movq (%rax,%rbx,8),%rsi
	movl $_dummy,%edi
	call _add_half
	incl %ebx
	jmp L176
L179:
	xorl %edx,%edx
	xorl %ecx,%ecx
L180:
	cmpl _dummy+20(%rip),%ecx
	jge L183
L181:
	movq _dummy+24(%rip),%rax
	movslq %ecx,%rcx
	movq (%rax,%rcx,8),%rax
	cmpl 20(%rax),%r12d
	jge L186
L184:
	incl %edx
L186:
	incl %ecx
	jmp L180
L183:
	xorl %ebx,%ebx
	cmpl %edx,%r12d
	jle L187
L191:
	cmpl 20(%r13),%ebx
	jge L194
L192:
	movq 24(%r13),%rax
	movslq %ebx,%rbx
	movq %r13,%rsi
	movq (%rax,%rbx,8),%rdi
	call _remove_half
	movq 24(%r13),%rax
	movq (%rax,%rbx,8),%rsi
	cmpq %rsi,%r14
	jz L197
L195:
	movq %r14,%rdi
	call _add_half
	movq 24(%r13),%rax
	movq %r14,%rsi
	movq (%rax,%rbx,8),%rdi
	call _add_half
L197:
	incl %ebx
	jmp L191
L194:
	movl (%r13),%edi
	movl (%r14),%esi
	call _substitute_reg
	movq %r14,40(%r13)
	cmpl $0,16(%r13)
	jl L202
L201:
	movl $0,20(%r13)
	jmp L203
L202:
	movl 20(%r13),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	leaq 16(%r13),%rdi
	call _vector_insert
L203:
	movq %r13,%rdi
	call _get
	movl $1,%eax
	jmp L137
L187:
	movl %ebx,%eax
L137:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_coalesce0:
L206:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L207:
	xorl %r14d,%r14d
L209:
	movl _max_depth(%rip),%r13d
L210:
	cmpl $0,%r13d
	jl L213
L211:
	movq _all_blocks(%rip),%r12
L214:
	testq %r12,%r12
	jz L217
L215:
	cmpl 184(%r12),%r13d
	jnz L216
L220:
	xorl %ebx,%ebx
L222:
	cmpl 12(%r12),%ebx
	jge L216
L226:
	movq 16(%r12),%rax
	movslq %ebx,%rbx
	movq (%rax,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L216
L223:
	leaq -8(%rbp),%rdx
	leaq -4(%rbp),%rsi
	call _insn_is_copy
	testl %eax,%eax
	jz L232
L230:
	movl -4(%rbp),%edi
	movl -8(%rbp),%esi
	cmpl %esi,%edi
	jnz L234
L233:
	movq 16(%r12),%rax
	movq $_nop_insn,(%rax,%rbx,8)
	jmp L232
L234:
	call _merge0
	testl %eax,%eax
	jnz L236
L232:
	incl %ebx
	jmp L222
L236:
	incl %r14d
	movq 16(%r12),%rax
	movq $_nop_insn,(%rax,%rbx,8)
	jmp L209
L216:
	movq 112(%r12),%r12
	jmp L214
L217:
	decl %r13d
	jmp L210
L213:
	movl %r14d,%eax
L208:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cost0:
L241:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L242:
	movq _all_blocks(%rip),%r14
L244:
	testq %r14,%r14
	jz L247
L245:
	xorl %r13d,%r13d
L248:
	cmpl 12(%r14),%r13d
	jge L254
L252:
	movq 16(%r14),%rax
	movslq %r13d,%r13
	movq (%rax,%r13,8),%r12
	testq %r12,%r12
	jz L254
L253:
	cmpl $0,_tmp_regs(%rip)
	jl L263
L262:
	movl $0,_tmp_regs+4(%rip)
	jmp L264
L263:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L264:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_uses
	xorl %ebx,%ebx
L265:
	movl _tmp_regs+4(%rip),%esi
	cmpl %esi,%ebx
	jge L271
L269:
	movq _tmp_regs+8(%rip),%rax
	movslq %ebx,%rbx
	movl (%rax,%rbx,4),%edi
	testl %edi,%edi
	jz L271
L270:
	movl %edi,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jl L267
L275:
	xorl %esi,%esi
	call _find
	movl 184(%r14),%ecx
	movl $64,%edx
	shll %cl,%edx
	addl 8(%rax),%edx
	movl %edx,8(%rax)
L267:
	incl %ebx
	jmp L265
L271:
	cmpl $0,_tmp_regs(%rip)
	jl L284
L283:
	movl $0,_tmp_regs+4(%rip)
	jmp L285
L284:
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L285:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L286:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L292
L290:
	movq _tmp_regs+8(%rip),%rax
	movslq %ebx,%rbx
	movl (%rax,%rbx,4),%edi
	testl %edi,%edi
	jz L292
L291:
	movl %edi,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jl L288
L296:
	xorl %esi,%esi
	call _find
	movl 184(%r14),%ecx
	movl $64,%edx
	shll %cl,%edx
	addl 8(%rax),%edx
	movl %edx,8(%rax)
L288:
	incl %ebx
	jmp L286
L292:
	incl %r13d
	jmp L248
L254:
	movq 112(%r14),%r14
	jmp L244
L247:
	xorl %edi,%edi
	movl $34,%esi
L298:
	cmpl _nr_assigned_regs(%rip),%esi
	jge L301
L299:
	movq _graph+8(%rip),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%r8
L302:
	testq %r8,%r8
	jz L305
L303:
	movl 20(%r8),%ecx
	incl %ecx
	movl 8(%r8),%eax
	cltd 
	idivl %ecx
	movl %eax,8(%r8)
	testq %rdi,%rdi
	jz L310
L309:
	cmpl 8(%rdi),%eax
	jge L308
L310:
	movq %r8,%rdi
L308:
	movq 48(%r8),%r8
	jmp L302
L305:
	incl %esi
	jmp L298
L301:
	movq %rdi,%rax
L243:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_spill0:
L314:
	pushq %rbp
	movq %rsp,%rbp
	subq $80,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L315:
	call _cost0
	movl (%rax),%r15d
	movl %r15d,%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	movl $_double_type,%eax
	movl $_long_type,%edi
	cmovnzq %rax,%rdi
	call _temp
	movq %rax,%rbx
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,%r14d
	movl -32(%rbp),%eax
	andl $-8,%eax
	orl $1,%eax
	movl %eax,-32(%rbp)
	movl %r14d,-24(%rbp)
	movl -64(%rbp),%eax
	andl $-8,%eax
	orl $3,%eax
	movl $-2147303424,-56(%rbp)
	movl $0,-52(%rbp)
	andl $-25,%eax
	movl %eax,-64(%rbp)
	movq %rbx,%rdi
	call _symbol_offset
	movslq %eax,%rax
	movq %rax,-48(%rbp)
	movq $0,-40(%rbp)
	movq _all_blocks(%rip),%r13
L350:
	testq %r13,%r13
	jz L316
L351:
	xorl %r12d,%r12d
L354:
	cmpl 12(%r13),%r12d
	jge L360
L358:
	movq 16(%r13),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rbx
	testq %rbx,%rbx
	jz L360
L359:
	cmpl $0,_tmp_regs(%rip)
	jl L366
L365:
	movl $0,_tmp_regs+4(%rip)
	jmp L367
L366:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L367:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_uses
	leaq -72(%rbp),%r8
	movl $1,%ecx
	movl %r14d,%edx
	movl %r15d,%esi
	movq %rbx,%rdi
	call _insn_substitute_reg
	movq -72(%rbp),%rdi
	testq %rdi,%rdi
	jz L370
L368:
	leaq -32(%rbp),%rdx
	leaq -64(%rbp),%rsi
	call _move
	leal 1(%r12),%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
L370:
	leaq -80(%rbp),%r8
	movl $2,%ecx
	movl %r14d,%edx
	movl %r15d,%esi
	movq %rbx,%rdi
	call _insn_substitute_reg
	movl %r15d,%esi
	movl $_tmp_regs,%edi
	call _contains_reg
	testl %eax,%eax
	jz L373
L371:
	movq -80(%rbp),%rdi
	testq %rdi,%rdi
	jnz L376
L375:
	movq -72(%rbp),%rdi
L376:
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movl %r12d,%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %r12d
L373:
	incl %r12d
	jmp L354
L360:
	testl $1,4(%r13)
	jz L379
L384:
	movl 80(%r13),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L379
L385:
	cmpl 88(%r13),%r15d
	jnz L379
L381:
	shll $10,%edi
	shrl $15,%edi
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movq %r13,%rsi
	movq %rax,%rdi
	call _append_insn
	movl %r14d,88(%r13)
L379:
	movq 112(%r13),%r13
	jmp L350
L316:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_simplify0:
L388:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L391:
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	movl $34,%r12d
L394:
	cmpl _nr_assigned_regs(%rip),%r12d
	jge L397
L395:
	movq _graph+8(%rip),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rdi
L398:
	testq %rdi,%rdi
	jz L401
L399:
	movq 48(%rdi),%rbx
	movl 20(%rdi),%ecx
	movl (%rdi),%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	jnz L406
L405:
	movl _gp_colors+4(%rip),%eax
	jmp L407
L406:
	movl _xmm_colors+4(%rip),%eax
L407:
	cmpl %eax,%ecx
	jge L403
L402:
	call _push
	incl %r14d
	jmp L404
L403:
	incl %r13d
L404:
	movq %rbx,%rdi
	jmp L398
L401:
	incl %r12d
	jmp L394
L397:
	testl %r14d,%r14d
	jnz L391
L392:
	testl %r13d,%r13d
	setz %al
	movzbl %al,%eax
L390:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_optimist0:
L409:
L410:
	xorl %edi,%edi
	movl $34,%edx
L412:
	cmpl _nr_assigned_regs(%rip),%edx
	jge L415
L413:
	movq _graph+8(%rip),%rax
	movslq %edx,%rdx
	movq (%rax,%rdx,8),%rcx
L416:
	testq %rcx,%rcx
	jz L419
L417:
	testq %rdi,%rdi
	jz L420
L423:
	movl 20(%rdi),%eax
	cmpl 20(%rcx),%eax
	jle L422
L420:
	movq %rcx,%rdi
L422:
	movq 48(%rcx),%rcx
	jmp L416
L419:
	incl %edx
	jmp L412
L415:
	call _push
L411:
	ret 


_select0:
L427:
	pushq %rbx
	pushq %r12
L430:
	cmpq $0,_stack(%rip)
	jz L432
L431:
	call _pop
	movq %rax,%rbx
	cmpl $0,_tmp_regs(%rip)
	jl L437
L436:
	movl $0,_tmp_regs+4(%rip)
	jmp L438
L437:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L438:
	xorl %r12d,%r12d
L439:
	cmpl 20(%rbx),%r12d
	jge L442
L440:
	movq 24(%rbx),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rax
	movl 4(%rax),%esi
	movl $_tmp_regs,%edi
	call _add_reg
	incl %r12d
	jmp L439
L442:
	movl (%rbx),%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	movl $_xmm_colors,%eax
	movl $_gp_colors,%esi
	cmovnzq %rax,%rsi
	movl $_tmp_regs,%edx
	movl $_tmp2_regs,%edi
	call _diff_regs
	cmpl $0,_tmp2_regs+4(%rip)
	jz L446
L448:
	movq _tmp2_regs+8(%rip),%rax
	movl (%rax),%eax
	movl %eax,4(%rbx)
	jmp L430
L446:
	xorl %eax,%eax
	jmp L429
L432:
	movl $1,%eax
L429:
	popq %r12
	popq %rbx
	ret 


_marker0:
L451:
	pushq %rbx
	pushq %r12
L452:
	movl $34,%r12d
L454:
	cmpl _nr_assigned_regs(%rip),%r12d
	jge L453
L455:
	movq _graph+8(%rip),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rbx
L458:
	testq %rbx,%rbx
	jz L461
L459:
	movl (%rbx),%edi
	movl 4(%rbx),%esi
	call _substitute_reg
	movq 48(%rbx),%rbx
	jmp L458
L461:
	incl %r12d
	jmp L454
L453:
	popq %r12
	popq %rbx
	ret 


_color:
L462:
	pushq %rbx
L463:
	movl $1,%edi
	call _reach_analyze
L465:
	movl $983,%esi
	movl $1064,%edi
	call _opt
	movl $2,%edi
	call _dom_analyze
	movl $1,%edi
	call _live_analyze
	movl $0,_gp_colors(%rip)
	movl $0,_gp_colors+4(%rip)
	movq $0,_gp_colors+8(%rip)
	movq $_local_arena,_gp_colors+16(%rip)
	movl $0,_xmm_colors(%rip)
	movl $0,_xmm_colors+4(%rip)
	movq $0,_xmm_colors+8(%rip)
	movq $_local_arena,_xmm_colors+16(%rip)
	xorl %ebx,%ebx
L483:
	movl %ebx,%eax
	shll $14,%eax
	orl $2147483648,%eax
	cmpl $2147647488,%eax
	jz L478
L479:
	movl %ebx,%esi
	shll $14,%esi
	cmpl $16,%ebx
	jge L487
L486:
	movl %esi,%eax
	orl $2147483648,%eax
	jmp L488
L487:
	movl %esi,%eax
	orl $3221225472,%eax
L488:
	cmpl $2147663872,%eax
	jz L478
L480:
	cmpl $16,%ebx
	jge L490
L489:
	orl $2147483648,%esi
	jmp L491
L490:
	orl $3221225472,%esi
L491:
	movl $_gp_colors,%edi
	call _add_reg
L478:
	incl %ebx
	cmpl $16,%ebx
	jl L483
L475:
	xorl %ebx,%ebx
L493:
	leal 16(%rbx),%eax
	movl %eax,%esi
	shll $14,%esi
	cmpl $16,%eax
	jge L497
L496:
	orl $2147483648,%esi
	jmp L498
L497:
	orl $3221225472,%esi
L498:
	movl $_xmm_colors,%edi
	call _add_reg
	incl %ebx
	cmpl $16,%ebx
	jl L493
L495:
	movq $0,_stack(%rip)
	movl $0,_graph(%rip)
	movl $0,_graph+4(%rip)
	movq $0,_graph+8(%rip)
	movq $_local_arena,_graph+16(%rip)
	movl _nr_assigned_regs(%rip),%edx
	cmpl $0,%edx
	jg L506
L505:
	movl %edx,_graph+4(%rip)
	jmp L507
L506:
	movl $8,%ecx
	xorl %esi,%esi
	movl $_graph,%edi
	call _vector_insert
L507:
	movslq _graph+4(%rip),%rcx
	shlq $3,%rcx
	movq _graph+8(%rip),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movl $0,_tmp2_regs(%rip)
	movl $0,_tmp2_regs+4(%rip)
	movq $0,_tmp2_regs+8(%rip)
	movq $_local_arena,_tmp2_regs+16(%rip)
	movl $0,_dummy+16(%rip)
	movl $0,_dummy+20(%rip)
	movq $0,_dummy+24(%rip)
	movq $_local_arena,_dummy+32(%rip)
	call _build0
	call _coalesce0
L517:
	call _simplify0
	testl %eax,%eax
	jnz L519
L518:
	call _coalesce0
	testl %eax,%eax
	jnz L517
L522:
	call _optimist0
	jmp L517
L519:
	call _select0
	testl %eax,%eax
	jnz L526
L527:
	cmpq $0,_stack(%rip)
	jz L529
L528:
	call _pop
	jmp L527
L529:
	call _spill0
	jmp L465
L526:
	call _marker0
	call _opt_prune
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L464:
	popq %rbx
	ret 

.local _tmp_regs
.comm _tmp_regs, 24, 8
.local _tmp2_regs
.comm _tmp2_regs, 24, 8
.local _graph
.comm _graph, 24, 8
.local _stack
.comm _stack, 8, 8
.local _gp_colors
.comm _gp_colors, 24, 8
.local _xmm_colors
.comm _xmm_colors, 24, 8
.local _dummy
.comm _dummy, 56, 8

.globl _symbol_offset
.globl _nop_insn
.globl _all_blocks
.globl _symbol_to_reg
.globl _diff_regs
.globl _opt
.globl _long_type
.globl _temp
.globl _contains_reg
.globl _live_analyze
.globl _insn_is_copy
.globl _insn_substitute_reg
.globl _add_reg
.globl _double_type
.globl _color
.globl _move
.globl _nr_assigned_regs
.globl _local_arena
.globl _range_interf
.globl _append_insn
.globl _dom_analyze
.globl _vector_insert
.globl _vector_delete
.globl _dup_vector
.globl _max_depth
.globl _insn_defs
.globl _substitute_reg
.globl _insn_uses
.globl _opt_prune
.globl _insert_insn
.globl _reach_analyze
