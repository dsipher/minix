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
L16:
	cmpl 12(%r14),%r13d
	jge L15
L20:
	movq 16(%r14),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%r12
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
	movq _decorate_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%esi
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
	movslq %ecx,%rcx
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
	jmp L16
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
L51:
	cmpl _update_regs+4(%rip),%ebx
	jge L54
L52:
	movq _update_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%eax
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
	jmp L51
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
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%r13d
	movq %rcx,%r12
	movl $4,%edx
	leaq 584(%r15),%rsi
	movl $_reach_regs,%edi
	call _dup_vector
	xorl %ebx,%ebx
L64:
	cmpl 12(%r15),%ebx
	jge L67
L68:
	movq 16(%r15),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rdi
	testq %rdi,%rdi
	jz L67
L69:
	cmpl %ebx,%r14d
	jz L67
L74:
	movl $_reach_regs,%esi
	call _update
	incl %ebx
	jmp L64
L67:
	movl %r13d,%edx
	movl $_reach_regs,%esi
	movq %r12,%rdi
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
L79:
	cmpl 12(%r12),%ebx
	jge L78
L83:
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rdi
	testq %rdi,%rdi
	jz L78
L80:
	leaq 632(%r12),%rsi
	call _update
	incl %ebx
	jmp L79
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
L90:
	leaq 584(%r13),%rbx
	cmpl 36(%r13),%r12d
	jge L97
L91:
	movq 40(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rdx
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
	jmp L90
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
	movl %edi,%r14d
	xorl %r13d,%r13d
L111:
	movq _webs+8(%rip),%rcx
	movl %r14d,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%r12
	shlq $3,%r12
	cmpl 4(%rcx,%r12),%r13d
	jge L114
L112:
	movq 8(%rcx,%r12),%rdi
	movslq %r13d,%rax
	leaq (%rax,%rax,2),%rbx
	shlq $3,%rbx
	movl %r14d,%esi
	addq %rbx,%rdi
	call _contains_reg
	testl %eax,%eax
	jnz L115
L117:
	incl %r13d
	jmp L111
L115:
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rax
	movq 8(%rbx,%rax),%rax
	movl (%rax),%eax
	jmp L110
L114:
	movl %r14d,%eax
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
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L121:
	movq %rdi,-8(%rbp)
	movq -8(%rbp),%rax
	movq 8(%rax),%rax
	movl (%rax),%eax
	movq %rax,-24(%rbp)
	xorl %ebx,%ebx
L123:
	movq _webs+8(%rip),%rcx
	movq -24(%rbp),%rax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%r12
	shlq $3,%r12
	cmpl 4(%rcx,%r12),%ebx
	jge L126
L124:
	movq 8(%rcx,%r12),%rdx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	addq %rax,%rdx
	movq -8(%rbp),%rsi
	movl $_merge_regs,%edi
	call _intersect_regs
	cmpl $0,_merge_regs+4(%rip)
	jnz L126
L129:
	incl %ebx
	jmp L123
L126:
	movq _webs+8(%rip),%rdi
	movl 4(%r12,%rdi),%esi
	cmpl %esi,%ebx
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
	movq 8(%r12,%rax),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rdi
	shlq $3,%rdi
	movl $0,(%rcx,%rdi)
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
	movq -8(%rbp),%rsi
	addq %rax,%rdi
	call _dup_vector
	jmp L133
L132:
	movq 8(%r12,%rdi),%rdx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %rax,-16(%rbp)
	addq -16(%rbp),%rdx
	movq -8(%rbp),%rsi
	movl $_merge_regs,%edi
	call _union_regs
	movq _webs+8(%rip),%rax
	movq 8(%r12,%rax),%rdi
	movl $4,%edx
	movl $_merge_regs,%esi
	addq -16(%rbp),%rdi
	call _dup_vector
	leal 1(%rbx),%r15d
L149:
	movq _webs+8(%rip),%rcx
	movq -24(%rbp),%rax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%r14
	shlq $3,%r14
	cmpl 4(%rcx,%r14),%r15d
	jge L133
L150:
	movq 8(%rcx,%r14),%rdx
	movslq %r15d,%rax
	leaq (%rax,%rax,2),%r13
	shlq $3,%r13
	addq %r13,%rdx
	movq -8(%rbp),%rsi
	movl $_merge_regs,%edi
	call _intersect_regs
	cmpl $0,_merge_regs+4(%rip)
	jz L155
L153:
	movq _webs+8(%rip),%rax
	movq 8(%r14,%rax),%rsi
	movslq %ebx,%rax
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
	jmp L149
L133:
	movq _webs+8(%rip),%rcx
	movq -24(%rbp),%rax
	andl $1073725440,%eax
	movq %rax,-24(%rbp)
	movq -24(%rbp),%rax
	sarl $14,%eax
	movq %rax,-24(%rbp)
	movq -24(%rbp),%rax
	movslq %eax,%rax
	movq %rax,-24(%rbp)
	imulq $24,-24(%rbp),%rax
	movq 8(%rcx,%rax),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
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
L160:
	pushq %rbx
	pushq %r12
L161:
	movl %edi,%ebx
	movq %rsi,%r12
	cmpl $0,_build_regs(%rip)
	jl L167
L166:
	movl $0,_build_regs+4(%rip)
	jmp L168
L167:
	movl _build_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_build_regs,%edi
	call _vector_insert
L168:
	movl %ebx,%edx
	movq %r12,%rsi
	movl $_build_regs,%edi
	call _select_indexed_regs
	testl $16383,%ebx
	jz L171
L169:
	movl %ebx,%esi
	movl $_build_regs,%edi
	call _add_reg
L171:
	cmpl $0,_build_regs+4(%rip)
	jnz L173
L172:
	movl %ebx,%eax
	jmp L162
L173:
	movl $_build_regs,%edi
	call _merge0
L162:
	popq %r12
	popq %rbx
	ret 


_build0:
L177:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L178:
	movq %rdi,%r15
	movl $4,%edx
	leaq 584(%r15),%rsi
	movl $_reach_regs,%edi
	call _dup_vector
	xorl %r14d,%r14d
L183:
	cmpl 12(%r15),%r14d
	jge L189
L187:
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r13
	testq %r13,%r13
	jz L189
L188:
	cmpl $0,_tmp_regs(%rip)
	jl L195
L194:
	movl $0,_tmp_regs+4(%rip)
	jmp L196
L195:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L196:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r13,%rdi
	call _insn_uses
	xorl %r12d,%r12d
L197:
	cmpl _tmp_regs+4(%rip),%r12d
	jge L203
L201:
	movq _tmp_regs+8(%rip),%rcx
	movslq %r12d,%rax
	movl (%rcx,%rax,4),%ebx
	testl %ebx,%ebx
	jz L203
L202:
	movl %ebx,%eax
	andl $1073725440,%eax
	sarl $14,%eax
	cmpl $34,%eax
	jl L199
L207:
	movl $_reach_regs,%esi
	movl %ebx,%edi
	call _build1
	xorl %r8d,%r8d
	movl $2,%ecx
	movl %eax,%edx
	movl %ebx,%esi
	movq %r13,%rdi
	call _insn_substitute_reg
L199:
	incl %r12d
	jmp L197
L203:
	movl $_reach_regs,%esi
	movq %r13,%rdi
	call _update
	incl %r14d
	jmp L183
L189:
	testl $1,4(%r15)
	jz L179
L212:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L179
L213:
	movl $_reach_regs,%esi
	movl 88(%r15),%edi
	call _build1
	movl %eax,88(%r15)
L179:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_redecorate0:
L216:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L217:
	movq %rdi,%r14
	xorl %r13d,%r13d
L219:
	cmpl 12(%r14),%r13d
	jge L225
L223:
	movq 16(%r14),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%r12
	testq %r12,%r12
	jz L225
L224:
	cmpl $0,_tmp_regs(%rip)
	jl L234
L233:
	movl $0,_tmp_regs+4(%rip)
	jmp L235
L234:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L235:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_uses
	xorl %ebx,%ebx
L236:
	movl _tmp_regs+4(%rip),%esi
	cmpl %esi,%ebx
	jge L242
L240:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%r15d
	testl %r15d,%r15d
	jz L242
L241:
	movl %r15d,%edi
	call _name
	xorl %r8d,%r8d
	movl $2,%ecx
	movl %eax,%edx
	movl %r15d,%esi
	movq %r12,%rdi
	call _insn_substitute_reg
	incl %ebx
	jmp L236
L242:
	cmpl $0,_tmp_regs(%rip)
	jl L251
L250:
	movl $0,_tmp_regs+4(%rip)
	jmp L252
L251:
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L252:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L253:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L259
L257:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%r15d
	testl %r15d,%r15d
	jz L259
L258:
	movl %r15d,%edi
	call _name
	xorl %r8d,%r8d
	movl $1,%ecx
	movl %eax,%edx
	movl %r15d,%esi
	movq %r12,%rdi
	call _insn_substitute_reg
	incl %ebx
	jmp L253
L259:
	incl %r13d
	jmp L219
L225:
	testl $1,4(%r14)
	jz L218
L264:
	movl 80(%r14),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L218
L265:
	movl 88(%r14),%edi
	call _name
	movl %eax,88(%r14)
L218:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reach_analyze:
L268:
	pushq %rbx
	pushq %r12
L269:
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
	jg L290
L289:
	movl %edx,_subs+4(%rip)
	jmp L291
L290:
	movl $4,%ecx
	xorl %esi,%esi
	movl $_subs,%edi
	call _vector_insert
L291:
	movslq _subs+4(%rip),%rcx
	shlq $2,%rcx
	movq _subs+8(%rip),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	movq _all_blocks(%rip),%r12
L292:
	testq %r12,%r12
	jz L295
L296:
	cmpl $0,584(%r12)
	jl L300
L299:
	movl $0,588(%r12)
	jmp L301
L300:
	movl 588(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 584(%r12),%rdi
	call _vector_insert
L301:
	cmpl $0,608(%r12)
	jl L306
L305:
	movl $0,612(%r12)
	jmp L307
L306:
	movl 612(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 608(%r12),%rdi
	call _vector_insert
L307:
	cmpl $0,632(%r12)
	jl L312
L311:
	movl $0,636(%r12)
	jmp L313
L312:
	movl 636(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 632(%r12),%rdi
	call _vector_insert
L313:
	movq 112(%r12),%r12
	jmp L292
L295:
	movq _all_blocks(%rip),%r12
L314:
	testq %r12,%r12
	jz L317
L315:
	movq %r12,%rdi
	call _decorate0
	movq 112(%r12),%r12
	jmp L314
L317:
	movq _all_blocks(%rip),%r12
L318:
	testq %r12,%r12
	jz L321
L319:
	movq %r12,%rdi
	call _gen0
	movq 112(%r12),%r12
	jmp L318
L321:
	xorl %edi,%edi
	call _sequence_blocks
	movl $_compute0,%edi
	call _iterate_blocks
	testl $1,%ebx
	jz L349
L325:
	movl $0,_webs(%rip)
	movl $0,_webs+4(%rip)
	movq $0,_webs+8(%rip)
	movq $_local_arena,_webs+16(%rip)
	movl _nr_assigned_regs(%rip),%edx
	cmpl $0,%edx
	jg L332
L331:
	movl %edx,_webs+4(%rip)
	jmp L333
L332:
	movl $24,%ecx
	xorl %esi,%esi
	movl $_webs,%edi
	call _vector_insert
L333:
	xorl %esi,%esi
L334:
	cmpl %esi,_nr_assigned_regs(%rip)
	jle L337
L338:
	movq _webs+8(%rip),%rdx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movl $0,(%rdx,%rcx)
	movq _webs+8(%rip),%rax
	movl $0,4(%rcx,%rax)
	movq _webs+8(%rip),%rax
	movq $0,8(%rcx,%rax)
	movq _webs+8(%rip),%rax
	movq $_local_arena,16(%rcx,%rax)
	incl %esi
	jmp L334
L337:
	movq _all_blocks(%rip),%rbx
L341:
	testq %rbx,%rbx
	jz L344
L342:
	movq %rbx,%rdi
	call _build0
	movq 112(%rbx),%rbx
	jmp L341
L344:
	movq _all_blocks(%rip),%rbx
L345:
	testq %rbx,%rbx
	jz L349
L346:
	movq %rbx,%rdi
	call _redecorate0
	movq 112(%rbx),%rbx
	jmp L345
L349:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L270:
	popq %r12
	popq %rbx
	ret 


_reset_reach:
L352:
L355:
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
L354:
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
