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
	testq %rbx,%rbx
	jnz L16
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
L41:
	pushq %rbx
	pushq %r12
L42:
	movq %rdi,%r12
	movq %rsi,%rbx
	xorl %edx,%edx
L44:
	movl 20(%r12),%esi
	cmpl %esi,%edx
	jge L52
L45:
	movq 24(%r12),%rcx
	movslq %edx,%rax
	cmpq (%rcx,%rax,8),%rbx
	jz L43
L50:
	incl %edx
	jmp L44
L52:
	leal 1(%rsi),%eax
	cmpl 16(%r12),%eax
	jge L56
L55:
	movl %eax,20(%r12)
	jmp L57
L56:
	movl $8,%ecx
	movl $1,%edx
	leaq 16(%r12),%rdi
	call _vector_insert
L57:
	movq 24(%r12),%rcx
	movl 20(%r12),%eax
	decl %eax
	movslq %eax,%rax
	movq %rbx,(%rcx,%rax,8)
L43:
	popq %r12
	popq %rbx
	ret 


_remove_half:
L58:
L59:
	movq %rsi,%rdx
	xorl %esi,%esi
L61:
	cmpl 20(%rdi),%esi
	jge L60
L62:
	movq 24(%rdi),%rcx
	movslq %esi,%rax
	cmpq (%rcx,%rax,8),%rdx
	jz L65
L67:
	incl %esi
	jmp L61
L65:
	movl $8,%ecx
	movl $1,%edx
	addq $16,%rdi
	call _vector_delete
L60:
	ret 


_push:
L69:
	pushq %rbx
	pushq %r12
L70:
	movq %rdi,%r12
	xorl %ebx,%ebx
L72:
	cmpl 20(%r12),%ebx
	jge L75
L73:
	movq 24(%r12),%rcx
	movslq %ebx,%rax
	movq %r12,%rsi
	movq (%rcx,%rax,8),%rdi
	call _remove_half
	incl %ebx
	jmp L72
L75:
	movq %r12,%rdi
	call _get
	movq _stack(%rip),%rax
	movq %rax,48(%r12)
	movq %r12,_stack(%rip)
L71:
	popq %r12
	popq %rbx
	ret 


_pop:
L76:
	pushq %rbx
	pushq %r12
L77:
	movq _stack(%rip),%rbx
	movq 48(%rbx),%rax
	movq %rax,_stack(%rip)
L79:
	xorl %esi,%esi
L80:
	cmpl 20(%rbx),%esi
	jge L83
L81:
	movq 24(%rbx),%rcx
	movslq %esi,%rax
	movq (%rcx,%rax,8),%r12
	cmpq $0,40(%r12)
	jz L86
L87:
	movq 40(%r12),%rax
	testq %rax,%rax
	jz L89
L88:
	movq %rax,%r12
	jmp L87
L89:
	movl $8,%ecx
	movl $1,%edx
	leaq 16(%rbx),%rdi
	call _vector_delete
	movq %r12,%rsi
	movq %rbx,%rdi
	call _add_half
	jmp L79
L86:
	incl %esi
	jmp L80
L83:
	xorl %r12d,%r12d
L91:
	cmpl 20(%rbx),%r12d
	jge L94
L92:
	movq 24(%rbx),%rcx
	movslq %r12d,%rax
	movq %rbx,%rsi
	movq (%rcx,%rax,8),%rdi
	call _add_half
	incl %r12d
	jmp L91
L94:
	movq %rbx,%rdi
	call _put
	movq %rbx,%rax
L78:
	popq %r12
	popq %rbx
	ret 


_is_neighbor:
L96:
L97:
	xorl %edx,%edx
L99:
	cmpl 20(%rdi),%edx
	jge L102
L100:
	movq 24(%rdi),%rcx
	movslq %edx,%rax
	cmpq (%rcx,%rax,8),%rsi
	jz L103
L105:
	incl %edx
	jmp L99
L103:
	movl $1,%eax
	ret
L102:
	xorl %eax,%eax
L98:
	ret 


_build0:
L108:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L109:
	movq _all_blocks(%rip),%r14
L111:
	testq %r14,%r14
	jz L110
L112:
	xorl %r13d,%r13d
L115:
	cmpl 292(%r14),%r13d
	jge L118
L116:
	movq 296(%r14),%rdx
	movslq %r13d,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $2,%rcx
	movl (%rdx,%rcx),%eax
	cmpl 8(%rdx,%rcx),%eax
	jnz L121
L119:
	movl $1,%esi
	movl 4(%rdx,%rcx),%edi
	call _find
	movq %rax,%r12
	cmpl $0,_tmp_regs(%rip)
	jl L126
L125:
	movl $0,_tmp_regs+4(%rip)
	jmp L127
L126:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L127:
	movl $_tmp_regs,%edx
	movl %r13d,%esi
	movq %r14,%rdi
	call _range_interf
	xorl %ebx,%ebx
L128:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L121
L132:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%edi
	testl %edi,%edi
	jz L121
L133:
	movl $1,%esi
	call _find
	movq %rax,%r15
	movq %r15,%rsi
	movq %r12,%rdi
	call _add_half
	movq %r12,%rsi
	movq %r15,%rdi
	call _add_half
	incl %ebx
	jmp L128
L121:
	incl %r13d
	jmp L115
L118:
	movq 112(%r14),%r14
	jmp L111
L110:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_merge0:
L136:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L137:
	movl %edi,%r14d
	movl %esi,%ebx
	xorl %esi,%esi
	movl %r14d,%edi
	call _find
	movq %rax,%r13
	movq %r13,%r12
	xorl %esi,%esi
	movl %ebx,%edi
	call _find
	movq %rax,%rbx
	andl $3221225472,%r14d
	cmpl $2147483648,%r14d
	jnz L140
L139:
	movl _gp_colors+4(%rip),%r15d
	jmp L141
L140:
	movl _xmm_colors+4(%rip),%r15d
L141:
	testq %r13,%r13
	jz L206
L145:
	testq %rbx,%rbx
	jz L206
L147:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _is_neighbor
	testl %eax,%eax
	jnz L206
L152:
	movl (%r13),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L159
L157:
	movl (%rbx),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L159
L206:
	xorl %eax,%eax
	jmp L138
L159:
	movl (%rbx),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L168
L165:
	movq %rbx,%r12
	movq %r13,%rbx
L168:
	cmpl $0,_dummy+16(%rip)
	jl L172
L171:
	movl $0,_dummy+20(%rip)
	jmp L173
L172:
	movl _dummy+20(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movl $_dummy+16,%edi
	call _vector_insert
L173:
	movl $8,%edx
	leaq 16(%r12),%rsi
	movl $_dummy+16,%edi
	call _dup_vector
	xorl %r13d,%r13d
L177:
	cmpl 20(%rbx),%r13d
	jge L180
L178:
	movq 24(%rbx),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%rsi
	movl $_dummy,%edi
	call _add_half
	incl %r13d
	jmp L177
L180:
	xorl %edx,%edx
	xorl %esi,%esi
L181:
	cmpl _dummy+20(%rip),%esi
	jge L184
L182:
	movq _dummy+24(%rip),%rcx
	movslq %esi,%rax
	movq (%rcx,%rax,8),%rax
	cmpl 20(%rax),%r15d
	jge L187
L185:
	incl %edx
L187:
	incl %esi
	jmp L181
L184:
	xorl %r14d,%r14d
	cmpl %edx,%r15d
	jle L188
L192:
	cmpl 20(%rbx),%r14d
	jge L195
L193:
	movq 24(%rbx),%rax
	movslq %r14d,%r13
	movq %rbx,%rsi
	movq (%rax,%r13,8),%rdi
	call _remove_half
	movq 24(%rbx),%rax
	movq (%rax,%r13,8),%rsi
	cmpq %rsi,%r12
	jz L198
L196:
	movq %r12,%rdi
	call _add_half
	movq 24(%rbx),%rax
	movq %r12,%rsi
	movq (%rax,%r13,8),%rdi
	call _add_half
L198:
	incl %r14d
	jmp L192
L195:
	movl (%rbx),%edi
	movl (%r12),%esi
	call _substitute_reg
	movq %r12,40(%rbx)
	cmpl $0,16(%rbx)
	jl L203
L202:
	movl $0,20(%rbx)
	jmp L204
L203:
	movl 20(%rbx),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	leaq 16(%rbx),%rdi
	call _vector_insert
L204:
	movq %rbx,%rdi
	call _get
	movl $1,%eax
	jmp L138
L188:
	movl %r14d,%eax
L138:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_coalesce0:
L207:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L208:
	xorl %r15d,%r15d
L210:
	movl _max_depth(%rip),%r14d
L211:
	cmpl $0,%r14d
	jl L214
L212:
	movq _all_blocks(%rip),%r13
L215:
	testq %r13,%r13
	jz L218
L216:
	cmpl 184(%r13),%r14d
	jnz L217
L221:
	xorl %r12d,%r12d
L223:
	cmpl 12(%r13),%r12d
	jge L217
L227:
	movq 16(%r13),%rax
	movslq %r12d,%rbx
	movq (%rax,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L217
L224:
	leaq -8(%rbp),%rdx
	leaq -4(%rbp),%rsi
	call _insn_is_copy
	testl %eax,%eax
	jz L233
L231:
	movl -4(%rbp),%edi
	movl -8(%rbp),%esi
	cmpl %esi,%edi
	jnz L235
L234:
	movq 16(%r13),%rax
	movq $_nop_insn,(%rax,%rbx,8)
	jmp L233
L235:
	call _merge0
	testl %eax,%eax
	jnz L237
L233:
	incl %r12d
	jmp L223
L237:
	incl %r15d
	movq 16(%r13),%rax
	movq $_nop_insn,(%rax,%rbx,8)
	jmp L210
L217:
	movq 112(%r13),%r13
	jmp L215
L218:
	decl %r14d
	jmp L211
L214:
	movl %r15d,%eax
L209:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cost0:
L242:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L243:
	movq _all_blocks(%rip),%r14
L245:
	testq %r14,%r14
	jz L248
L246:
	xorl %r13d,%r13d
L249:
	cmpl 12(%r14),%r13d
	jge L255
L253:
	movq 16(%r14),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%r12
	testq %r12,%r12
	jz L255
L254:
	cmpl $0,_tmp_regs(%rip)
	jl L264
L263:
	movl $0,_tmp_regs+4(%rip)
	jmp L265
L264:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L265:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_uses
	xorl %ebx,%ebx
L266:
	movl _tmp_regs+4(%rip),%esi
	cmpl %esi,%ebx
	jge L272
L270:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%edi
	testl %edi,%edi
	jz L272
L271:
	movl %edi,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jl L268
L276:
	xorl %esi,%esi
	call _find
	movl 184(%r14),%ecx
	movl $64,%edx
	shll %cl,%edx
	addl 8(%rax),%edx
	movl %edx,8(%rax)
L268:
	incl %ebx
	jmp L266
L272:
	cmpl $0,_tmp_regs(%rip)
	jl L285
L284:
	movl $0,_tmp_regs+4(%rip)
	jmp L286
L285:
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L286:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L287:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L293
L291:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%edi
	testl %edi,%edi
	jz L293
L292:
	movl %edi,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jl L289
L297:
	xorl %esi,%esi
	call _find
	movl 184(%r14),%ecx
	movl $64,%edx
	shll %cl,%edx
	addl 8(%rax),%edx
	movl %edx,8(%rax)
L289:
	incl %ebx
	jmp L287
L293:
	incl %r13d
	jmp L249
L255:
	movq 112(%r14),%r14
	jmp L245
L248:
	xorl %esi,%esi
	movl $34,%r8d
L299:
	cmpl _nr_assigned_regs(%rip),%r8d
	jge L302
L300:
	movq _graph+8(%rip),%rcx
	movslq %r8d,%rax
	movq (%rcx,%rax,8),%rdi
L303:
	testq %rdi,%rdi
	jz L306
L304:
	movl 20(%rdi),%ecx
	incl %ecx
	movl 8(%rdi),%eax
	cltd 
	idivl %ecx
	movl %eax,8(%rdi)
	testq %rsi,%rsi
	jz L311
L310:
	cmpl 8(%rsi),%eax
	jge L309
L311:
	movq %rdi,%rsi
L309:
	movq 48(%rdi),%rdi
	jmp L303
L306:
	incl %r8d
	jmp L299
L302:
	movq %rsi,%rax
L244:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_spill0:
L315:
	pushq %rbp
	movq %rsp,%rbp
	subq $80,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L316:
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
L351:
	testq %r13,%r13
	jz L317
L352:
	xorl %r12d,%r12d
L355:
	cmpl 12(%r13),%r12d
	jge L361
L359:
	movq 16(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	testq %rbx,%rbx
	jz L361
L360:
	cmpl $0,_tmp_regs(%rip)
	jl L367
L366:
	movl $0,_tmp_regs+4(%rip)
	jmp L368
L367:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L368:
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
	jz L371
L369:
	leaq -32(%rbp),%rdx
	leaq -64(%rbp),%rsi
	call _move
	leal 1(%r12),%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
L371:
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
	jz L374
L372:
	movq -80(%rbp),%rdi
	testq %rdi,%rdi
	jnz L377
L376:
	movq -72(%rbp),%rdi
L377:
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movl %r12d,%edx
	movq %r13,%rsi
	movq %rax,%rdi
	call _insert_insn
	incl %r12d
L374:
	incl %r12d
	jmp L355
L361:
	testl $1,4(%r13)
	jz L380
L385:
	movl 80(%r13),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L380
L386:
	cmpl 88(%r13),%r15d
	jnz L380
L382:
	shll $10,%edi
	shrl $15,%edi
	leaq -64(%rbp),%rdx
	leaq -32(%rbp),%rsi
	call _move
	movq %r13,%rsi
	movq %rax,%rdi
	call _append_insn
	movl %r14d,88(%r13)
L380:
	movq 112(%r13),%r13
	jmp L351
L317:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_simplify0:
L389:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L392:
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	movl $34,%r12d
L395:
	cmpl _nr_assigned_regs(%rip),%r12d
	jge L398
L396:
	movq _graph+8(%rip),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rdi
L399:
	testq %rdi,%rdi
	jz L402
L400:
	movq 48(%rdi),%rbx
	movl 20(%rdi),%ecx
	movl (%rdi),%eax
	andl $3221225472,%eax
	cmpl $2147483648,%eax
	jnz L407
L406:
	movl _gp_colors+4(%rip),%eax
	jmp L408
L407:
	movl _xmm_colors+4(%rip),%eax
L408:
	cmpl %eax,%ecx
	jge L404
L403:
	call _push
	incl %r14d
	jmp L405
L404:
	incl %r13d
L405:
	movq %rbx,%rdi
	jmp L399
L402:
	incl %r12d
	jmp L395
L398:
	testl %r14d,%r14d
	jnz L392
L393:
	testl %r13d,%r13d
	setz %al
	movzbl %al,%eax
L391:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_optimist0:
L410:
L411:
	xorl %edi,%edi
	movl $34,%edx
L413:
	cmpl _nr_assigned_regs(%rip),%edx
	jge L416
L414:
	movq _graph+8(%rip),%rcx
	movslq %edx,%rax
	movq (%rcx,%rax,8),%rcx
L417:
	testq %rcx,%rcx
	jz L420
L418:
	testq %rdi,%rdi
	jz L421
L424:
	movl 20(%rdi),%eax
	cmpl 20(%rcx),%eax
	jle L423
L421:
	movq %rcx,%rdi
L423:
	movq 48(%rcx),%rcx
	testq %rcx,%rcx
	jnz L418
L420:
	incl %edx
	jmp L413
L416:
	call _push
L412:
	ret 


_select0:
L429:
	pushq %rbx
	pushq %r12
L432:
	cmpq $0,_stack(%rip)
	jz L434
L433:
	call _pop
	movq %rax,%rbx
	cmpl $0,_tmp_regs(%rip)
	jl L439
L438:
	movl $0,_tmp_regs+4(%rip)
	jmp L440
L439:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L440:
	xorl %r12d,%r12d
L441:
	cmpl 20(%rbx),%r12d
	jge L444
L442:
	movq 24(%rbx),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rax
	movl 4(%rax),%esi
	movl $_tmp_regs,%edi
	call _add_reg
	incl %r12d
	jmp L441
L444:
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
	jz L448
L450:
	movq _tmp2_regs+8(%rip),%rax
	movl (%rax),%eax
	movl %eax,4(%rbx)
	jmp L432
L448:
	xorl %eax,%eax
	jmp L431
L434:
	movl $1,%eax
L431:
	popq %r12
	popq %rbx
	ret 


_marker0:
L453:
	pushq %rbx
	pushq %r12
L454:
	movl $34,%r12d
L456:
	cmpl _nr_assigned_regs(%rip),%r12d
	jge L455
L457:
	movq _graph+8(%rip),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
L460:
	testq %rbx,%rbx
	jz L463
L461:
	movl (%rbx),%edi
	movl 4(%rbx),%esi
	call _substitute_reg
	movq 48(%rbx),%rbx
	jmp L460
L463:
	incl %r12d
	jmp L456
L455:
	popq %r12
	popq %rbx
	ret 


_color:
L464:
	pushq %rbx
L465:
	movl $1,%edi
	call _reach_analyze
L467:
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
L485:
	movl %ebx,%eax
	shll $14,%eax
	orl $2147483648,%eax
	cmpl $2147647488,%eax
	jz L480
L481:
	movl %ebx,%esi
	shll $14,%esi
	cmpl $16,%ebx
	jge L489
L488:
	movl %esi,%eax
	orl $2147483648,%eax
	jmp L490
L489:
	movl %esi,%eax
	orl $3221225472,%eax
L490:
	cmpl $2147663872,%eax
	jz L480
L482:
	cmpl $16,%ebx
	jge L492
L491:
	orl $2147483648,%esi
	jmp L493
L492:
	orl $3221225472,%esi
L493:
	movl $_gp_colors,%edi
	call _add_reg
L480:
	incl %ebx
	cmpl $16,%ebx
	jl L485
L477:
	xorl %ebx,%ebx
L495:
	leal 16(%rbx),%eax
	movl %eax,%esi
	shll $14,%esi
	cmpl $16,%eax
	jge L499
L498:
	orl $2147483648,%esi
	jmp L500
L499:
	orl $3221225472,%esi
L500:
	movl $_xmm_colors,%edi
	call _add_reg
	incl %ebx
	cmpl $16,%ebx
	jl L495
L497:
	movq $0,_stack(%rip)
	movl $0,_graph(%rip)
	movl $0,_graph+4(%rip)
	movq $0,_graph+8(%rip)
	movq $_local_arena,_graph+16(%rip)
	movl _nr_assigned_regs(%rip),%edx
	cmpl $0,%edx
	jg L508
L507:
	movl %edx,_graph+4(%rip)
	jmp L509
L508:
	movl $8,%ecx
	xorl %esi,%esi
	movl $_graph,%edi
	call _vector_insert
L509:
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
L519:
	call _simplify0
	testl %eax,%eax
	jnz L521
L520:
	call _coalesce0
	testl %eax,%eax
	jnz L519
L524:
	call _optimist0
	jmp L519
L521:
	call _select0
	testl %eax,%eax
	jnz L528
L529:
	cmpq $0,_stack(%rip)
	jz L531
L530:
	call _pop
	jmp L529
L531:
	call _spill0
	jmp L467
L528:
	call _marker0
	call _opt_prune
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L466:
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
