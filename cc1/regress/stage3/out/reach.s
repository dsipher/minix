.text

_new_reach:
L1:
L2:
	movl $0,584(%rdi)
	movl $0,588(%rdi)
	movq $0,592(%rdi)
	movq $_func_arena,600(%rdi)
	movl $0,608(%rdi)
	movl $0,612(%rdi)
	movq $0,616(%rdi)
	movq $_func_arena,624(%rdi)
	movl $0,632(%rdi)
	movl $0,636(%rdi)
	movq $0,640(%rdi)
	movq $_func_arena,648(%rdi)
L3:
	ret 


_decorate0:
L13:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L14:
	movq %rdi,%r14
	xorl %r13d,%r13d
	jmp L16
L20:
	movq 16(%r14),%rax
	movq (%rax,%r13,8),%r12
	testq %r12,%r12
	jz L15
L21:
	cmpl $0,_decorate_regs(%rip)
	jl L28
L27:
	movl $0,_decorate_regs+4(%rip)
	jmp L29
L28:
	movl _decorate_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_decorate_regs,%edi
	call _vector_insert
L29:
	xorl %edx,%edx
	movl $_decorate_regs,%esi
	movq %r12,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L30:
	cmpl _decorate_regs+4(%rip),%ebx
	jge L36
L34:
	movq _decorate_regs+8(%rip),%rax
	movl (%rax,%rbx,4),%esi
	testl %esi,%esi
	jz L36
L35:
	movl %esi,%ecx
	andl $1073725440,%ecx
	sarl $14,%ecx
	cmpl $34,%ecx
	jl L32
L40:
	movq _subs+8(%rip),%rdx
	movl (%rdx,%rcx,4),%eax
	incl %eax
	movl %eax,(%rdx,%rcx,4)
	movl %esi,%edx
	andl $-16384,%edx
	orl %eax,%edx
	xorl %r8d,%r8d
	movl $1,%ecx
	movq %r12,%rdi
	call _insn_substitute_reg
L32:
	incl %ebx
	jmp L30
L36:
	incl %r13d
L16:
	cmpl 12(%r14),%r13d
	jl L20
L15:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_update:
L42:
	pushq %rbx
	pushq %r12
L43:
	movq %rdi,%rbx
	movq %rsi,%r12
	cmpl $0,_update_regs(%rip)
	jl L49
L48:
	movl $0,_update_regs+4(%rip)
	jmp L50
L49:
	movl _update_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_update_regs,%edi
	call _vector_insert
L50:
	xorl %edx,%edx
	movl $_update_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	xorl %ebx,%ebx
	jmp L51
L52:
	movq _update_regs+8(%rip),%rax
	movslq %ebx,%rbx
	movl (%rax,%rbx,4),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jge L57
L55:
	movl $4,%ecx
	movl $1,%edx
	movl %ebx,%esi
	movl $_update_regs,%edi
	call _vector_delete
	decl %ebx
L57:
	incl %ebx
L51:
	cmpl _update_regs+4(%rip),%ebx
	jl L52
L54:
	movl $_update_regs,%esi
	movq %r12,%rdi
	call _replace_indexed_regs
L44:
	popq %r12
	popq %rbx
	ret 


_reach:
L58:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L59:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%r12d
	movq %rcx,%rbx
	movl $4,%edx
	leaq 584(%r14),%rsi
	movl $_reach_regs,%edi
	call _dup_vector
	xorl %r15d,%r15d
	jmp L64
L68:
	movq 16(%r14),%rax
	movq (%rax,%r15,8),%rdi
	testq %rdi,%rdi
	jz L67
L69:
	cmpl %r15d,%r13d
	jz L67
L74:
	movl $_reach_regs,%esi
	call _update
	incl %r15d
L64:
	cmpl 12(%r14),%r15d
	jl L68
L67:
	movl %r12d,%edx
	movl $_reach_regs,%esi
	movq %rbx,%rdi
	call _select_indexed_regs
L60:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_gen0:
L76:
	pushq %rbx
	pushq %r12
L77:
	movq %rdi,%r12
	xorl %ebx,%ebx
	jmp L79
L83:
	movq 16(%r12),%rax
	movq (%rax,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L78
L80:
	leaq 632(%r12),%rsi
	call _update
	incl %ebx
L79:
	cmpl 12(%r12),%ebx
	jl L83
L78:
	popq %r12
	popq %rbx
	ret 


_compute0:
L87:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L88:
	movq %rdi,%r13
	xorl %r12d,%r12d
	jmp L90
L91:
	movq 40(%r13),%rax
	movq (%rax,%r12,8),%rdx
	addq $608,%rdx
	leaq 584(%r13),%rsi
	movl $_compute_regs,%edi
	call _union_regs
	movq _compute_regs(%rip),%rax
	movq %rax,-24(%rbp)
	movq _compute_regs+8(%rip),%rax
	movq %rax,-16(%rbp)
	movq _compute_regs+16(%rip),%rax
	movq %rax,-8(%rbp)
	movq (%rbx),%rax
	movq %rax,_compute_regs(%rip)
	movq 8(%rbx),%rax
	movq %rax,_compute_regs+8(%rip)
	movq 16(%rbx),%rax
	movq %rax,_compute_regs+16(%rip)
	movq -24(%rbp),%rax
	movq %rax,(%rbx)
	movq -16(%rbp),%rax
	movq %rax,8(%rbx)
	movq -8(%rbp),%rax
	movq %rax,16(%rbx)
	incl %r12d
L90:
	leaq 584(%r13),%rbx
	cmpl 36(%r13),%r12d
	jl L91
L97:
	movl $4,%edx
	leaq 584(%r13),%rsi
	movl $_compute_regs,%edi
	call _dup_vector
	leaq 632(%r13),%rsi
	movl $_compute_regs,%edi
	call _replace_indexed_regs
	leaq 608(%r13),%rbx
	leaq 608(%r13),%rsi
	movl $_compute_regs,%edi
	call _same_regs
	testl %eax,%eax
	jnz L100
L104:
	movq _compute_regs(%rip),%rax
	movq %rax,-48(%rbp)
	movq _compute_regs+8(%rip),%rax
	movq %rax,-40(%rbp)
	movq _compute_regs+16(%rip),%rax
	movq %rax,-32(%rbp)
	movq (%rbx),%rax
	movq %rax,_compute_regs(%rip)
	movq 8(%rbx),%rax
	movq %rax,_compute_regs+8(%rip)
	movq 16(%rbx),%rax
	movq %rax,_compute_regs+16(%rip)
	movq -48(%rbp),%rax
	movq %rax,(%rbx)
	movq -40(%rbp),%rax
	movq %rax,8(%rbx)
	movq -32(%rbp),%rax
	movq %rax,16(%rbx)
	movl $1,%eax
	jmp L89
L100:
	xorl %eax,%eax
L89:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_name:
L108:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L109:
	movl %edi,%ebx
	xorl %r13d,%r13d
L111:
	movq _webs+8(%rip),%rcx
	movl %ebx,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	leaq (%rax,%rax,2),%r14
	shlq $3,%r14
	cmpl 4(%rcx,%r14),%r13d
	jge L114
L112:
	movq 8(%rcx,%r14),%rdi
	leaq (%r13,%r13,2),%r12
	shlq $3,%r12
	movl %ebx,%esi
	addq %r12,%rdi
	call _contains_reg
	testl %eax,%eax
	jnz L115
L117:
	incl %r13d
	jmp L111
L115:
	movq _webs+8(%rip),%rax
	movq 8(%r14,%rax),%rax
	movq 8(%r12,%rax),%rax
	movl (%rax),%eax
	jmp L110
L114:
	movl %ebx,%eax
L110:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_merge0:
L120:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L121:
	movq 8(%rdi),%rax
	movq %rdi,-8(%rbp) # spill
	movl (%rax),%ebx
	xorl %eax,%eax
	jmp L160
L124:
	movq 8(%rcx,%r12),%rdx
	movl -32(%rbp),%eax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq %rax,-32(%rbp) # spill
	addq %rcx,%rdx
	movq -8(%rbp),%rsi # spill
	movl $_merge_regs,%edi
	call _intersect_regs
	cmpl $0,_merge_regs+4(%rip)
	jnz L126
L129:
	movq -32(%rbp),%rax # spill
	incl %eax
L160:
	movq %rax,-32(%rbp) # spill
	movq _webs+8(%rip),%rcx
	movl %ebx,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	leaq (%rax,%rax,2),%r12
	shlq $3,%r12
	movq -32(%rbp),%rax # spill
	cmpl 4(%rcx,%r12),%eax
	jl L124
L126:
	movq _webs+8(%rip),%rdi
	movl 4(%r12,%rdi),%esi
	cmpl %esi,-32(%rbp) # spill
	jnz L132
L134:
	leal 1(%rsi),%eax
	cmpl (%r12,%rdi),%eax
	jge L138
L137:
	movl %eax,4(%r12,%rdi)
	jmp L139
L138:
	movl $24,%ecx
	movl $1,%edx
	addq %r12,%rdi
	call _vector_insert
L139:
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rax
	movq %rax,-24(%rbp) # spill
	movl -32(%rbp),%eax
	leaq (%rax,%rax,2),%rdi
	shlq $3,%rdi
	movq -24(%rbp),%rax # spill
	movl $0,(%rax,%rdi)
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rax
	movl $0,4(%rdi,%rax)
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rax
	movq $0,8(%rdi,%rax)
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rax
	movq $_local_arena,16(%rdi,%rax)
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rax
	movl $4,%edx
	movq -8(%rbp),%rsi # spill
	addq %rax,%rdi
	call _dup_vector
	jmp L133
L132:
	movq 8(%r12,%rdi),%rdx
	movl -32(%rbp),%eax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq %rax,-16(%rbp) # spill
	movq -8(%rbp),%rsi # spill
	movl $_merge_regs,%edi
	call _union_regs
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rdi
	movl $4,%edx
	movl $_merge_regs,%esi
	addq -16(%rbp),%rdi # spill
	call _dup_vector
	movq -32(%rbp),%r15 # spill
	incl %r15d
	jmp L149
L150:
	movq 8(%rcx,%r14),%rdx
	movslq %r15d,%r15
	leaq (%r15,%r15,2),%r13
	shlq $3,%r13
	addq %r13,%rdx
	movq -8(%rbp),%rsi # spill
	movl $_merge_regs,%edi
	call _intersect_regs
	cmpl $0,_merge_regs+4(%rip)
	jz L155
L153:
	movq _webs+8(%rip),%rax
	movq 8(%r14,%rax),%rsi
	movl -32(%rbp),%eax
	leaq (%rax,%rax,2),%r12
	shlq $3,%r12
	leaq (%r13,%rsi),%rdx
	addq %r12,%rsi
	movl $_merge_regs,%edi
	call _union_regs
	movq _webs+8(%rip),%rax
	movq 8(%r14,%rax),%rdi
	movl $4,%edx
	movl $_merge_regs,%esi
	addq %r12,%rdi
	call _dup_vector
	movq _webs+8(%rip),%rdi
	movl $24,%ecx
	movl $1,%edx
	movl %r15d,%esi
	addq %r14,%rdi
	call _vector_delete
	decl %r15d
L155:
	incl %r15d
L149:
	movq _webs+8(%rip),%rcx
	movl %ebx,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	leaq (%rax,%rax,2),%r14
	shlq $3,%r14
	cmpl 4(%rcx,%r14),%r15d
	jl L150
L133:
	movq _webs+8(%rip),%rcx
	andl $1073725440,%ebx
	sarl $14,%ebx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 8(%rcx,%rax),%rcx
	movl -32(%rbp),%eax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 8(%rcx,%rax),%rax
	movl (%rax),%eax
L122:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_build1:
L161:
	pushq %rbx
	pushq %r12
L162:
	movl %edi,%ebx
	movq %rsi,%r12
	cmpl $0,_build_regs(%rip)
	jl L168
L167:
	movl $0,_build_regs+4(%rip)
	jmp L169
L168:
	movl _build_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_build_regs,%edi
	call _vector_insert
L169:
	movl %ebx,%edx
	movq %r12,%rsi
	movl $_build_regs,%edi
	call _select_indexed_regs
	testl $16383,%ebx
	jz L172
L170:
	movl %ebx,%esi
	movl $_build_regs,%edi
	call _add_reg
L172:
	cmpl $0,_build_regs+4(%rip)
	jnz L174
L173:
	movl %ebx,%eax
	jmp L163
L174:
	movl $_build_regs,%edi
	call _merge0
L163:
	popq %r12
	popq %rbx
	ret 


_build0:
L178:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L179:
	movq %rdi,%r15
	movl $4,%edx
	leaq 584(%r15),%rsi
	movl $_reach_regs,%edi
	call _dup_vector
	xorl %r14d,%r14d
	jmp L184
L188:
	movq 16(%r15),%rax
	movq (%rax,%r14,8),%r13
	testq %r13,%r13
	jz L190
L189:
	cmpl $0,_tmp_regs(%rip)
	jl L196
L195:
	movl $0,_tmp_regs+4(%rip)
	jmp L197
L196:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L197:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r13,%rdi
	call _insn_uses
	xorl %r12d,%r12d
L198:
	cmpl _tmp_regs+4(%rip),%r12d
	jge L204
L202:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax,%r12,4),%ebx
	testl %ebx,%ebx
	jz L204
L203:
	movl %ebx,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jl L200
L208:
	movl $_reach_regs,%esi
	movl %ebx,%edi
	call _build1
	xorl %r8d,%r8d
	movl $2,%ecx
	movl %eax,%edx
	movl %ebx,%esi
	movq %r13,%rdi
	call _insn_substitute_reg
L200:
	incl %r12d
	jmp L198
L204:
	movl $_reach_regs,%esi
	movq %r13,%rdi
	call _update
	incl %r14d
L184:
	cmpl 12(%r15),%r14d
	jl L188
L190:
	testl $1,4(%r15)
	jz L180
L213:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L180
L214:
	movl $_reach_regs,%esi
	movl 88(%r15),%edi
	call _build1
	movl %eax,88(%r15)
L180:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_redecorate0:
L217:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L218:
	movq %rdi,%r13
	xorl %r12d,%r12d
	jmp L220
L224:
	movq 16(%r13),%rax
	movq (%rax,%r12,8),%rbx
	testq %rbx,%rbx
	jz L226
L225:
	cmpl $0,_tmp_regs(%rip)
	jl L235
L234:
	movl $0,_tmp_regs+4(%rip)
	jmp L236
L235:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L236:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_uses
	xorl %r15d,%r15d
L237:
	movl _tmp_regs+4(%rip),%esi
	cmpl %esi,%r15d
	jge L243
L241:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax,%r15,4),%r14d
	testl %r14d,%r14d
	jz L243
L242:
	movl %r14d,%edi
	call _name
	xorl %r8d,%r8d
	movl $2,%ecx
	movl %eax,%edx
	movl %r14d,%esi
	movq %rbx,%rdi
	call _insn_substitute_reg
	incl %r15d
	jmp L237
L243:
	cmpl $0,_tmp_regs(%rip)
	jl L252
L251:
	movl $0,_tmp_regs+4(%rip)
	jmp L253
L252:
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L253:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	xorl %r15d,%r15d
L254:
	cmpl _tmp_regs+4(%rip),%r15d
	jge L260
L258:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax,%r15,4),%r14d
	testl %r14d,%r14d
	jz L260
L259:
	movl %r14d,%edi
	call _name
	xorl %r8d,%r8d
	movl $1,%ecx
	movl %eax,%edx
	movl %r14d,%esi
	movq %rbx,%rdi
	call _insn_substitute_reg
	incl %r15d
	jmp L254
L260:
	incl %r12d
L220:
	cmpl 12(%r13),%r12d
	jl L224
L226:
	testl $1,4(%r13)
	jz L219
L265:
	movl 80(%r13),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L219
L266:
	movl 88(%r13),%edi
	call _name
	movl %eax,88(%r13)
L219:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reach_analyze:
L269:
	pushq %rbx
	pushq %r12
L270:
	movl %edi,%ebx
	movl $0,_decorate_regs(%rip)
	movl $0,_decorate_regs+4(%rip)
	movq $0,_decorate_regs+8(%rip)
	movq $_local_arena,_decorate_regs+16(%rip)
	movl $0,_merge_regs(%rip)
	movl $0,_merge_regs+4(%rip)
	movq $0,_merge_regs+8(%rip)
	movq $_local_arena,_merge_regs+16(%rip)
	movl $0,_build_regs(%rip)
	movl $0,_build_regs+4(%rip)
	movq $0,_build_regs+8(%rip)
	movq $_local_arena,_build_regs+16(%rip)
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movl $0,_subs(%rip)
	movl $0,_subs+4(%rip)
	movq $0,_subs+8(%rip)
	movq $_local_arena,_subs+16(%rip)
	movl _nr_assigned_regs(%rip),%edx
	cmpl $0,%edx
	jg L291
L290:
	movl %edx,_subs+4(%rip)
	jmp L292
L291:
	movl $4,%ecx
	xorl %esi,%esi
	movl $_subs,%edi
	call _vector_insert
L292:
	movslq _subs+4(%rip),%rdx
	shlq $2,%rdx
	xorl %esi,%esi
	movq _subs+8(%rip),%rdi
	call ___builtin_memset
	movq _all_blocks(%rip),%r12
	jmp L293
L297:
	cmpl $0,584(%r12)
	jl L301
L300:
	movl $0,588(%r12)
	jmp L302
L301:
	movl 588(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 584(%r12),%rdi
	call _vector_insert
L302:
	cmpl $0,608(%r12)
	jl L307
L306:
	movl $0,612(%r12)
	jmp L308
L307:
	movl 612(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 608(%r12),%rdi
	call _vector_insert
L308:
	cmpl $0,632(%r12)
	jl L313
L312:
	movl $0,636(%r12)
	jmp L314
L313:
	movl 636(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 632(%r12),%rdi
	call _vector_insert
L314:
	movq 112(%r12),%r12
L293:
	testq %r12,%r12
	jnz L297
L296:
	movq _all_blocks(%rip),%r12
	jmp L315
L316:
	movq %r12,%rdi
	call _decorate0
	movq 112(%r12),%r12
L315:
	testq %r12,%r12
	jnz L316
L318:
	movq _all_blocks(%rip),%r12
	jmp L319
L320:
	movq %r12,%rdi
	call _gen0
	movq 112(%r12),%r12
L319:
	testq %r12,%r12
	jnz L320
L322:
	xorl %edi,%edi
	call _sequence_blocks
	movl $_compute0,%edi
	call _iterate_blocks
	testl $1,%ebx
	jz L350
L326:
	movl $0,_webs(%rip)
	movl $0,_webs+4(%rip)
	movq $0,_webs+8(%rip)
	movq $_local_arena,_webs+16(%rip)
	movl _nr_assigned_regs(%rip),%edx
	cmpl $0,%edx
	jg L333
L332:
	movl %edx,_webs+4(%rip)
	jmp L334
L333:
	movl $24,%ecx
	xorl %esi,%esi
	movl $_webs,%edi
	call _vector_insert
L334:
	xorl %edx,%edx
	jmp L335
L339:
	movq _webs+8(%rip),%rax
	leaq (%rdx,%rdx,2),%rcx
	shlq $3,%rcx
	movl $0,(%rax,%rcx)
	movq _webs+8(%rip),%rax
	movl $0,4(%rcx,%rax)
	movq _webs+8(%rip),%rax
	movq $0,8(%rcx,%rax)
	movq _webs+8(%rip),%rax
	movq $_local_arena,16(%rcx,%rax)
	incl %edx
L335:
	cmpl %edx,_nr_assigned_regs(%rip)
	jg L339
L338:
	movq _all_blocks(%rip),%rbx
	jmp L342
L343:
	movq %rbx,%rdi
	call _build0
	movq 112(%rbx),%rbx
L342:
	testq %rbx,%rbx
	jnz L343
L345:
	movq _all_blocks(%rip),%rbx
	jmp L346
L347:
	movq %rbx,%rdi
	call _redecorate0
	movq 112(%rbx),%rbx
L346:
	testq %rbx,%rbx
	jnz L347
L350:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L271:
	popq %r12
	popq %rbx
	ret 


_reset_reach:
L353:
L356:
	movl $0,_reach_regs(%rip)
	movl $0,_reach_regs+4(%rip)
	movq $0,_reach_regs+8(%rip)
	movq $_func_arena,_reach_regs+16(%rip)
	movl $0,_update_regs(%rip)
	movl $0,_update_regs+4(%rip)
	movq $0,_update_regs+8(%rip)
	movq $_func_arena,_update_regs+16(%rip)
	movl $0,_compute_regs(%rip)
	movl $0,_compute_regs+4(%rip)
	movq $0,_compute_regs+8(%rip)
	movq $_func_arena,_compute_regs+16(%rip)
L355:
	ret 

.local _tmp_regs
.comm _tmp_regs, 24, 8
.local _subs
.comm _subs, 24, 8
.local _decorate_regs
.comm _decorate_regs, 24, 8
.local _update_regs
.comm _update_regs, 24, 8
.local _reach_regs
.comm _reach_regs, 24, 8
.local _compute_regs
.comm _compute_regs, 24, 8
.local _webs
.comm _webs, 24, 8
.local _merge_regs
.comm _merge_regs, 24, 8
.local _build_regs
.comm _build_regs, 24, 8

.globl _same_regs
.globl _all_blocks
.globl _sequence_blocks
.globl _union_regs
.globl _contains_reg
.globl ___builtin_memset
.globl _insn_substitute_reg
.globl _reach
.globl _replace_indexed_regs
.globl _add_reg
.globl _select_indexed_regs
.globl _iterate_blocks
.globl _nr_assigned_regs
.globl _local_arena
.globl _new_reach
.globl _vector_insert
.globl _func_arena
.globl _vector_delete
.globl _dup_vector
.globl _insn_defs
.globl _reset_reach
.globl _insn_uses
.globl _intersect_regs
.globl _reach_analyze
