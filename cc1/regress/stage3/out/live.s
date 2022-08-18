.text

_def0:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%r12d
	movl %ecx,%ebx
	movl 292(%r14),%esi
L4:
	movl %esi,%eax
	decl %esi
	testl %eax,%eax
	jz L7
L5:
	movq 296(%r14),%rcx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rax
	shlq $2,%rax
	cmpl (%rcx,%rax),%r12d
	jl L4
	jg L7
L14:
	cmpl 4(%rcx,%rax),%r13d
	jbe L4
L7:
	leal 1(%rsi),%r15d
	movl $12,%ecx
	movl $1,%edx
	incl %esi
	leaq 288(%r14),%rdi
	call _vector_insert
	movq 296(%r14),%rax
	movslq %r15d,%r15
	leaq (%r15,%r15,2),%rcx
	shlq $2,%rcx
	movl %r12d,(%rax,%rcx)
	movq 296(%r14),%rax
	movl %r13d,4(%rcx,%rax)
	movq 296(%r14),%rax
	movl %r12d,8(%rcx,%rax)
	movl %r13d,%esi
	leaq 216(%r14),%rdi
	call _contains_reg
	testl %eax,%eax
	jnz L3
L23:
	testl %ebx,%ebx
	jz L3
L20:
	movl %r13d,%esi
	leaq 192(%r14),%rdi
	call _add_reg
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_use0:
L27:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L28:
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%r13d
	movl %ecx,%r12d
L30:
	movl 292(%r15),%esi
L31:
	movl %esi,%eax
	decl %esi
	testl %eax,%eax
	jz L34
L32:
	movq 296(%r15),%rdx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $2,%rcx
	movl (%rdx,%rcx),%eax
	cmpl %eax,%r13d
	jle L31
L37:
	cmpl 4(%rdx,%rcx),%r14d
	jnz L31
L39:
	movl %eax,%ebx
L34:
	cmpl $0,%esi
	jge L44
L43:
	xorl %ecx,%ecx
	movl $-2,%edx
	movl %r14d,%esi
	movq %r15,%rdi
	call _def0
	testl %r12d,%r12d
	jz L30
L46:
	movl %r14d,%esi
	leaq 216(%r15),%rdi
	call _add_reg
	jmp L30
L44:
	leal 1(%rsi),%r12d
	movl $12,%ecx
	movl $1,%edx
	incl %esi
	leaq 288(%r15),%rdi
	call _vector_insert
	movq 296(%r15),%rax
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rcx
	shlq $2,%rcx
	movl %ebx,(%rax,%rcx)
	movq 296(%r15),%rax
	movl %r14d,4(%rcx,%rax)
	movq 296(%r15),%rax
	movl %r13d,8(%rcx,%rax)
L29:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_local0:
L50:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L51:
	movq %rdi,%r13
	movl %esi,%r14d
	cmpl $0,216(%r13)
	jl L57
L56:
	movl $0,220(%r13)
	jmp L58
L57:
	movl 220(%r13),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 216(%r13),%rdi
	call _vector_insert
L58:
	cmpl $0,192(%r13)
	jl L63
L62:
	movl $0,196(%r13)
	jmp L64
L63:
	movl 196(%r13),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 192(%r13),%rdi
	call _vector_insert
L64:
	cmpl $0,240(%r13)
	jl L69
L68:
	movl $0,244(%r13)
	jmp L70
L69:
	movl 244(%r13),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 240(%r13),%rdi
	call _vector_insert
L70:
	cmpl $0,264(%r13)
	jl L75
L74:
	movl $0,268(%r13)
	jmp L76
L75:
	movl 268(%r13),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq 264(%r13),%rdi
	call _vector_insert
L76:
	cmpl $0,288(%r13)
	jl L81
L80:
	movl $0,292(%r13)
	jmp L82
L81:
	movl 292(%r13),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $12,%ecx
	leaq 288(%r13),%rdi
	call _vector_insert
L82:
	xorl %r12d,%r12d
L83:
	cmpl 12(%r13),%r12d
	jge L89
L87:
	movq 16(%r13),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rbx
	testq %rbx,%rbx
	jz L89
L88:
	testl $2,%r14d
	jz L96
L94:
	testl $134217728,(%rbx)
	jz L99
L97:
	movl $1,%ecx
	movl %r12d,%edx
	movl $1074266112,%esi
	movq %r13,%rdi
	call _use0
L99:
	testl $67108864,(%rbx)
	jnz L104
L103:
	movq %rbx,%rdi
	call _insn_defs_cc0
	testl %eax,%eax
	jz L96
L104:
	movl $1,%ecx
	movl %r12d,%edx
	movl $1074266112,%esi
	movq %r13,%rdi
	call _def0
L96:
	testl $4,%r14d
	jz L112
L110:
	testl $33554432,(%rbx)
	jnz L117
L116:
	movq %rbx,%rdi
	call _insn_uses_mem0
	testl %eax,%eax
	jz L115
L117:
	movl $1,%ecx
	movl %r12d,%edx
	movl $1074282496,%esi
	movq %r13,%rdi
	call _use0
L115:
	testl $16777216,(%rbx)
	jnz L124
L123:
	movq %rbx,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jz L112
L124:
	movl $1,%ecx
	movl %r12d,%edx
	movl $1074282496,%esi
	movq %r13,%rdi
	call _def0
L112:
	testl $1,%r14d
	jz L129
L133:
	cmpl $0,_tmp_regs(%rip)
	jl L137
L136:
	movl $0,_tmp_regs+4(%rip)
	jmp L138
L137:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L138:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_uses
	xorl %r15d,%r15d
L139:
	movl _tmp_regs+4(%rip),%edi
	cmpl %edi,%r15d
	jge L145
L143:
	movq _tmp_regs+8(%rip),%rax
	movslq %r15d,%r15
	movl (%rax,%r15,4),%esi
	testl %esi,%esi
	jz L145
L144:
	movl $1,%ecx
	movl %r12d,%edx
	movq %r13,%rdi
	call _use0
	incl %r15d
	jmp L139
L145:
	cmpl $0,_tmp_regs(%rip)
	jl L154
L153:
	movl $0,_tmp_regs+4(%rip)
	jmp L155
L154:
	xorl %edx,%edx
	subl %edi,%edx
	movl $4,%ecx
	movl %edi,%esi
	movl $_tmp_regs,%edi
	call _vector_insert
L155:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L156:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L129
L160:
	movq _tmp_regs+8(%rip),%rax
	movslq %ebx,%rbx
	movl (%rax,%rbx,4),%esi
	testl %esi,%esi
	jz L129
L161:
	movl $1,%ecx
	movl %r12d,%edx
	movq %r13,%rdi
	call _def0
	incl %ebx
	jmp L156
L129:
	incl %r12d
	jmp L83
L89:
	testl $1,%r14d
	jz L166
L171:
	testl $1,4(%r13)
	jz L166
L172:
	movl 80(%r13),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L166
L168:
	movl $1,%ecx
	movl $2147483646,%edx
	movl 88(%r13),%esi
	movq %r13,%rdi
	call _use0
L166:
	testl $2,%r14d
	jz L52
L178:
	movq %r13,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L52
L179:
	movl $1,%ecx
	movl $2147483646,%edx
	movl $1074266112,%esi
	movq %r13,%rdi
	call _use0
L52:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_global0:
L182:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L183:
	movq %rdi,%r12
	xorl %ebx,%ebx
	cmpl $0,_tmp_out(%rip)
	jl L189
L188:
	movl $0,_tmp_out+4(%rip)
	jmp L190
L189:
	movl _tmp_out+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_out,%edi
	call _vector_insert
L190:
	xorl %r14d,%r14d
L191:
	cmpl 60(%r12),%r14d
	jge L194
L192:
	movq 64(%r12),%rcx
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%r13
	movl $4,%edx
	movl $_tmp_out,%esi
	movl $_tmp_regs,%edi
	call _dup_vector
	leaq 240(%r13),%rdx
	movl $_tmp_regs,%esi
	movl $_tmp_out,%edi
	call _union_regs
	incl %r14d
	jmp L191
L194:
	leaq 264(%r12),%rsi
	movl $_tmp_out,%edi
	call _same_regs
	testl %eax,%eax
	jnz L200
L201:
	movl $4,%edx
	movl $_tmp_out,%esi
	leaq 264(%r12),%rdi
	call _dup_vector
	movl $1,%ebx
L200:
	leaq 192(%r12),%rdx
	leaq 264(%r12),%rsi
	movl $_tmp_regs,%edi
	call _diff_regs
	movl $_tmp_regs,%edx
	leaq 216(%r12),%rsi
	movl $_tmp_in,%edi
	call _union_regs
	leaq 240(%r12),%rsi
	movl $_tmp_in,%edi
	call _same_regs
	testl %eax,%eax
	jnz L206
L207:
	movl $4,%edx
	movl $_tmp_in,%esi
	leaq 240(%r12),%rdi
	call _dup_vector
	movl $1,%ebx
L206:
	movl %ebx,%eax
L184:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_live_analyze:
L211:
	pushq %rbx
	pushq %r12
L212:
	movl %edi,%r12d
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movl $0,_tmp_in(%rip)
	movl $0,_tmp_in+4(%rip)
	movq $0,_tmp_in+8(%rip)
	movq $_local_arena,_tmp_in+16(%rip)
	movl $0,_tmp_out(%rip)
	movl $0,_tmp_out+4(%rip)
	movq $0,_tmp_out+8(%rip)
	movq $_local_arena,_tmp_out+16(%rip)
	movq _all_blocks(%rip),%rbx
L223:
	testq %rbx,%rbx
	jz L226
L224:
	movl %r12d,%esi
	movq %rbx,%rdi
	call _local0
	movq 112(%rbx),%rbx
	jmp L223
L226:
	movl $1,%edi
	call _sequence_blocks
	movl $_global0,%edi
	call _iterate_blocks
	movq _all_blocks(%rip),%r12
L227:
	testq %r12,%r12
	jz L239
L228:
	xorl %ebx,%ebx
L231:
	cmpl 268(%r12),%ebx
	jge L237
L235:
	movq 272(%r12),%rax
	movslq %ebx,%rbx
	movl (%rax,%rbx,4),%esi
	testl %esi,%esi
	jz L237
L236:
	xorl %ecx,%ecx
	movl $2147483647,%edx
	movq %r12,%rdi
	call _use0
	incl %ebx
	jmp L231
L237:
	movq 112(%r12),%r12
	jmp L227
L239:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L213:
	popq %r12
	popq %rbx
	ret 


_range_by_use:
L242:
L243:
	xorl %r8d,%r8d
L245:
	cmpl 292(%rdi),%r8d
	jge L244
L246:
	movq 296(%rdi),%r9
	movslq %r8d,%r8
	leaq (%r8,%r8,2),%rcx
	shlq $2,%rcx
	cmpl 8(%r9,%rcx),%edx
	jnz L251
L252:
	cmpl 4(%r9,%rcx),%esi
	jz L249
L251:
	incl %r8d
	jmp L245
L249:
	movl %r8d,%eax
L244:
	ret 


_range_by_def:
L257:
L258:
	xorl %r8d,%r8d
L260:
	cmpl 292(%rdi),%r8d
	jge L259
L261:
	movq 296(%rdi),%r9
	movslq %r8d,%r8
	leaq (%r8,%r8,2),%rcx
	shlq $2,%rcx
	cmpl (%r9,%rcx),%edx
	jnz L266
L267:
	cmpl 4(%r9,%rcx),%esi
	jz L264
L266:
	incl %r8d
	jmp L260
L264:
	movl %r8d,%eax
L259:
	ret 


_range_span:
L272:
L275:
	leal 1(%rsi),%edx
	cmpl 292(%rdi),%edx
	jge L277
L282:
	movq 296(%rdi),%r9
	movslq %esi,%rax
	leaq (%rax,%rax,2),%r8
	shlq $2,%r8
	movl (%r9,%r8),%eax
	movslq %edx,%rdx
	leaq (%rdx,%rdx,2),%rcx
	shlq $2,%rcx
	cmpl (%r9,%rcx),%eax
	jnz L277
L278:
	movl 4(%r9,%r8),%eax
	cmpl 4(%r9,%rcx),%eax
	jnz L277
L276:
	movl %edx,%esi
	jmp L275
L277:
	movq 296(%rdi),%rcx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rax
	shlq $2,%rax
	movl 8(%rcx,%rax),%eax
L274:
	ret 


_range_doa:
L287:
	pushq %rbx
L288:
	movq %rdi,%rbx
	movq %rbx,%rdi
	call _range_by_def
	leal 1(%rax),%ecx
	cmpl 292(%rbx),%ecx
	jge L292
L294:
	movq 296(%rbx),%rsi
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $2,%rdx
	movl (%rsi,%rdx),%eax
	movslq %ecx,%rcx
	leaq (%rcx,%rcx,2),%rcx
	shlq $2,%rcx
	cmpl (%rsi,%rcx),%eax
	jnz L292
L290:
	movl 4(%rsi,%rdx),%eax
	cmpl 4(%rsi,%rcx),%eax
	jnz L292
L291:
	movl $1,%eax
	jmp L293
L292:
	xorl %eax,%eax
L293:
	testl %eax,%eax
	setz %al
	movzbl %al,%eax
L289:
	popq %rbx
	ret 


_range_use_count:
L299:
L300:
	xorl %eax,%eax
L302:
	cmpl $0,%esi
	jle L313
L309:
	movq 296(%rdi),%r10
	movslq %esi,%rcx
	leaq (%rcx,%rcx,2),%r9
	shlq $2,%r9
	movl (%r10,%r9),%r8d
	movl %esi,%ecx
	decl %ecx
	movslq %ecx,%rcx
	leaq (%rcx,%rcx,2),%rdx
	shlq $2,%rdx
	cmpl (%r10,%rdx),%r8d
	jnz L313
L305:
	movl 4(%r10,%r9),%ecx
	cmpl 4(%r10,%rdx),%ecx
	jnz L313
L303:
	decl %esi
	jmp L302
L313:
	movq 296(%rdi),%r10
	movslq %esi,%rcx
	leaq (%rcx,%rcx,2),%r9
	shlq $2,%r9
	movl (%r10,%r9),%r8d
	cmpl 8(%r10,%r9),%r8d
	jz L319
L317:
	incl %eax
L319:
	incl %esi
	cmpl 292(%rdi),%esi
	jge L301
L327:
	movslq %esi,%rcx
	leaq (%rcx,%rcx,2),%rdx
	shlq $2,%rdx
	cmpl (%r10,%rdx),%r8d
	jnz L301
L323:
	movl 4(%r10,%r9),%ecx
	cmpl 4(%r10,%rdx),%ecx
	jz L313
L301:
	ret 


_range_interf:
L332:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L333:
	movq %rdi,%r15
	movq %rdx,-16(%rbp)
	movq 296(%r15),%rcx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rax
	shlq $2,%rax
	movl 4(%rcx,%rax),%r14d
	movl (%rcx,%rax),%eax
	movl %eax,-20(%rbp)
L335:
	leal 1(%rsi),%r13d
	cmpl 292(%r15),%r13d
	jge L337
L342:
	movq 296(%r15),%r8
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rdi
	shlq $2,%rdi
	movl (%r8,%rdi),%edx
	movslq %r13d,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $2,%rcx
	cmpl (%r8,%rcx),%edx
	jnz L337
L338:
	movl 4(%r8,%rdi),%eax
	cmpl 4(%r8,%rcx),%eax
	jnz L337
L336:
	movl %r13d,%esi
	jmp L335
L337:
	movq 296(%r15),%rcx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rax
	shlq $2,%rax
	movl 8(%rcx,%rax),%eax
	movl %eax,-24(%rbp)
L346:
	cmpl 292(%r15),%r13d
	jge L334
L349:
	movq 296(%r15),%rcx
	movslq %r13d,%r13
	leaq (%r13,%r13,2),%rax
	shlq $2,%rax
	movl (%rcx,%rax),%ebx
	cmpl %ebx,-24(%rbp)
	jle L334
L347:
	cmpl 8(%rcx,%rax),%ebx
	jnz L355
L353:
	movl 4(%rcx,%rax),%r12d
	cmpl $0,%ebx
	jl L357
L367:
	cmpl $2147483645,%ebx
	jg L357
L363:
	movq 16(%r15),%rax
	movslq %ebx,%rbx
	leaq -8(%rbp),%rdx
	leaq -4(%rbp),%rsi
	movq (%rax,%rbx,8),%rdi
	call _insn_is_copy
	testl %eax,%eax
	jz L357
L359:
	movl -4(%rbp),%eax
	cmpl %eax,%r14d
	jnz L371
L375:
	cmpl -8(%rbp),%r12d
	jz L355
L371:
	cmpl %eax,%r12d
	jnz L357
L379:
	cmpl -8(%rbp),%r14d
	jz L355
L357:
	cmpl %ebx,-20(%rbp)
	jz L355
L386:
	movl %r14d,%ecx
	andl $3221225472,%ecx
	movl %r12d,%eax
	andl $3221225472,%eax
	cmpl %eax,%ecx
	jnz L355
L383:
	movl %r12d,%esi
	movq -16(%rbp),%rdi
	call _add_reg
L355:
	incl %r13d
	jmp L346
L334:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_live_ccs:
L390:
	pushq %rbx
	pushq %r12
	pushq %r13
L391:
	movq %rdi,%rbx
	movl %esi,%r13d
	xorl %r12d,%r12d
	movq 16(%rbx),%rax
	movslq %r13d,%r13
	movq (%rax,%r13,8),%rdi
	testl $67108864,(%rdi)
	jnz L393
L396:
	call _insn_defs_cc0
	testl %eax,%eax
	jz L395
L393:
	movl %r13d,%edx
	movl $1074266112,%esi
	movq %rbx,%rdi
	call _range_by_def
L400:
	leal 1(%rax),%edx
	cmpl 292(%rbx),%edx
	jge L395
L407:
	movq 296(%rbx),%rdi
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rsi
	shlq $2,%rsi
	movl (%rdi,%rsi),%eax
	movslq %edx,%rdx
	leaq (%rdx,%rdx,2),%rcx
	shlq $2,%rcx
	cmpl (%rdi,%rcx),%eax
	jnz L395
L403:
	movl 4(%rdi,%rsi),%eax
	cmpl 4(%rdi,%rcx),%eax
	jnz L395
L401:
	movl %edx,%eax
	movl 8(%rdi,%rcx),%ecx
	cmpl $2147483647,%ecx
	jz L411
L412:
	cmpl $2147483646,%ecx
	jnz L416
L415:
	xorl %esi,%esi
L418:
	cmpl 60(%rbx),%esi
	jge L400
L419:
	movq 64(%rbx),%rdx
	movslq %esi,%rsi
	leaq (%rsi,%rsi,2),%rcx
	shlq $3,%rcx
	movl (%rdx,%rcx),%ecx
	movl $1,%edx
	shll %cl,%edx
	orl %edx,%r12d
	incl %esi
	jmp L418
L416:
	movq 16(%rbx),%rdx
	movslq %ecx,%rcx
	movq (%rdx,%rcx,8),%rcx
	movl (%rcx),%ecx
	cmpb $64,%cl
	jae L423
L422:
	subl $2550136856,%ecx
	jmp L424
L423:
	subl $2550137255,%ecx
L424:
	movl $1,%edx
	shll %cl,%edx
	orl %edx,%r12d
	jmp L400
L411:
	movl $4095,%r12d
L395:
	movl %r12d,%eax
L392:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_live_kill_dead:
L426:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L427:
	movq %rdi,%r14
	movl %esi,%r13d
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L429:
	cmpl 292(%r14),%ebx
	jge L432
L430:
	movq 296(%r14),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $2,%rax
	cmpl 8(%rcx,%rax),%r13d
	jnz L435
L433:
	cmpl $-2,(%rcx,%rax)
	movl $1,%eax
	cmovzl %eax,%r12d
	movl $12,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 288(%r14),%rdi
	call _vector_delete
	decl %ebx
L435:
	incl %ebx
	jmp L429
L432:
	movl %r12d,%eax
L428:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_new_live:
L440:
L441:
	movl $0,192(%rdi)
	movl $0,196(%rdi)
	movq $0,200(%rdi)
	movq $_func_arena,208(%rdi)
	movl $0,216(%rdi)
	movl $0,220(%rdi)
	movq $0,224(%rdi)
	movq $_func_arena,232(%rdi)
	movl $0,240(%rdi)
	movl $0,244(%rdi)
	movq $0,248(%rdi)
	movq $_func_arena,256(%rdi)
	movl $0,264(%rdi)
	movl $0,268(%rdi)
	movq $0,272(%rdi)
	movq $_func_arena,280(%rdi)
	movl $0,288(%rdi)
	movl $0,292(%rdi)
	movq $0,296(%rdi)
	movq $_func_arena,304(%rdi)
L442:
	ret 

.local _tmp_regs
.comm _tmp_regs, 24, 8
.local _tmp_in
.comm _tmp_in, 24, 8
.local _tmp_out
.comm _tmp_out, 24, 8

.globl _same_regs
.globl _all_blocks
.globl _insn_defs_mem0
.globl _diff_regs
.globl _range_span
.globl _sequence_blocks
.globl _range_use_count
.globl _insn_uses_mem0
.globl _live_kill_dead
.globl _range_by_def
.globl _union_regs
.globl _contains_reg
.globl _live_analyze
.globl _insn_is_copy
.globl _new_live
.globl _range_doa
.globl _range_by_use
.globl _add_reg
.globl _conditional_block
.globl _iterate_blocks
.globl _local_arena
.globl _live_ccs
.globl _range_interf
.globl _vector_insert
.globl _func_arena
.globl _insn_defs_cc0
.globl _vector_delete
.globl _dup_vector
.globl _insn_defs
.globl _insn_uses
