.text

_new_number:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl _values+4(%rip),%r12d
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rdx,%r13
	leal 1(%r12),%eax
	cmpl _values(%rip),%eax
	jge L8
L7:
	movl %eax,_values+4(%rip)
	jmp L9
L8:
	movl $32,%ecx
	movl $1,%edx
	movl %r12d,%esi
	movl $_values,%edi
	call _vector_insert
L9:
	movq _values+8(%rip),%rax
	movslq %r12d,%rbx
	shlq $5,%rbx
	movl %r14d,(%rax,%rbx)
	movq _values+8(%rip),%rax
	movl %r12d,4(%rbx,%rax)
	movq _values+8(%rip),%rcx
	andl $131071,%r13d
	movl 8(%rbx,%rcx),%eax
	andl $-131072,%eax
	orl %r13d,%eax
	movl %eax,8(%rbx,%rcx)
	cmpl $1,%r14d
	jz L14
L31:
	cmpl $2,%r14d
	jnz L11
L22:
	movl 660(%r15),%esi
	leal 1(%rsi),%eax
	cmpl 656(%r15),%eax
	jge L26
L25:
	movl %eax,660(%r15)
	jmp L27
L26:
	movl $8,%ecx
	movl $1,%edx
	leaq 656(%r15),%rdi
	call _vector_insert
L27:
	addq _values+8(%rip),%rbx
	movq 664(%r15),%rcx
	movl 660(%r15),%eax
	jmp L34
L14:
	movl _imms+4(%rip),%esi
	leal 1(%rsi),%eax
	cmpl _imms(%rip),%eax
	jge L18
L17:
	movl %eax,_imms+4(%rip)
	jmp L19
L18:
	movl $8,%ecx
	movl $1,%edx
	movl $_imms,%edi
	call _vector_insert
L19:
	movq _values+8(%rip),%rax
	movq _imms+8(%rip),%rcx
	addq %rax,%rbx
	movl _imms+4(%rip),%eax
L34:
	decl %eax
	movslq %eax,%rax
	movq %rbx,(%rcx,%rax,8)
L11:
	movl %r12d,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_imm:
L35:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L36:
	movq %rdi,-8(%rbp)
	movq %rsi,%r12
	movq %rdx,%r15
	xorl %r14d,%r14d
L38:
	cmpl _imms+4(%rip),%r14d
	jge L41
L39:
	movq _imms+8(%rip),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r13
	cmpq 24(%r13),%r15
	jnz L40
L44:
	movl 8(%r13),%eax
	testl $73726,%eax
	jz L40
L53:
	testq $73726,%r12
	jz L40
L49:
	movl %eax,%edi
	andl $131071,%edi
	cmpq %rdi,%r12
	jz L48
L57:
	testl $7168,%eax
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%r12
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L40
L61:
	call _t_size
	movl %eax,%ebx
	movq %r12,%rdi
	call _t_size
	cmpl %eax,%ebx
	jnz L40
L48:
	movl 8(%r13),%edi
	andl $131071,%edi
	leaq 16(%rbp),%rsi
	call _normalize_con
	movq 16(%r13),%rax
	cmpq 16(%rbp),%rax
	jnz L40
L66:
	movl 4(%r13),%eax
	jmp L37
L40:
	incl %r14d
	jmp L38
L41:
	leaq 16(%rbp),%rsi
	movq %r12,%rdi
	call _normalize_con
	movq %r12,%rdx
	movl $1,%esi
	movq -8(%rbp),%rdi
	call _new_number
	movq _values+8(%rip),%rsi
	movslq %eax,%rdx
	shlq $5,%rdx
	movq 16(%rbp),%rcx
	movq %rcx,16(%rsi,%rdx)
	movq _values+8(%rip),%rcx
	movq %r15,24(%rdx,%rcx)
L37:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_assoc:
L71:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L72:
	movq %rdi,%r13
	movl %esi,%r12d
	movl %edx,%ebx
	xorl %r14d,%r14d
L74:
	cmpl 684(%r13),%r14d
	jge L77
L75:
	movq 688(%r13),%rdx
	movslq %r14d,%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl %eax,%r12d
	jz L78
L80:
	cmpl %eax,%r12d
	jb L77
L84:
	incl %r14d
	jmp L74
L78:
	movl %ebx,4(%rdx,%rcx,8)
	jmp L73
L77:
	movl $8,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 680(%r13),%rdi
	call _vector_insert
	movq 688(%r13),%rax
	movslq %r14d,%r14
	movl %r12d,(%rax,%r14,8)
	movq 688(%r13),%rax
	movl %ebx,4(%rax,%r14,8)
L73:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reg_to_number:
L86:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L87:
	movq %rdi,%r14
	movl %esi,%r13d
	movq %rdx,%r12
	xorl %ebx,%ebx
L89:
	cmpl 684(%r14),%ebx
	jge L92
L90:
	movq 688(%r14),%rdx
	movslq %ebx,%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl %eax,%r13d
	jz L93
L95:
	cmpl %eax,%r13d
	jb L92
L99:
	incl %ebx
	jmp L89
L93:
	movl 4(%rdx,%rcx,8),%eax
	jmp L88
L92:
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 680(%r14),%rdi
	call _vector_insert
	movq 688(%r14),%rax
	movslq %ebx,%rbx
	movl %r13d,(%rax,%rbx,8)
	movq %r12,%rdx
	xorl %esi,%esi
	movq %r14,%rdi
	call _new_number
	movq 688(%r14),%rcx
	movl %eax,4(%rcx,%rbx,8)
	movq 688(%r14),%rax
	movl 4(%rax,%rbx,8),%eax
L88:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_number_to_reg:
L102:
L103:
	xorl %edx,%edx
L105:
	cmpl 684(%rdi),%edx
	jge L108
L106:
	movq 688(%rdi),%rcx
	movslq %edx,%rax
	cmpl 4(%rcx,%rax,8),%esi
	jz L109
L111:
	incl %edx
	jmp L105
L109:
	movl (%rcx,%rax,8),%eax
	ret
L108:
	xorl %eax,%eax
L104:
	ret 


_dissoc:
L114:
L115:
	movl %esi,%edx
	xorl %esi,%esi
L117:
	cmpl 684(%rdi),%esi
	jge L116
L118:
	movq 688(%rdi),%rcx
	movslq %esi,%rax
	movl (%rcx,%rax,8),%eax
	cmpl %eax,%edx
	jz L121
L123:
	cmpl %eax,%edx
	jb L116
L127:
	incl %esi
	jmp L117
L121:
	movl $8,%ecx
	movl $1,%edx
	addq $680,%rdi
	call _vector_delete
L116:
	ret 


_reload_precedes:
L129:
L130:
	movl 4(%rdi),%eax
	cmpl 4(%rsi),%eax
	jl L157
	jg L158
L138:
	movq 8(%rdi),%rax
	cmpq 8(%rsi),%rax
	jl L157
	jg L158
L146:
	movq 16(%rdi),%rax
	cmpq 16(%rsi),%rax
	jz L154
	jb L157
L158:
	xorl %eax,%eax
	ret
L157:
	movl $1,%eax
	ret
L154:
	movq _values+8(%rip),%rdx
	movslq (%rdi),%rax
	shlq $5,%rax
	movl 8(%rdx,%rax),%ecx
	andl $131071,%ecx
	movslq (%rsi),%rax
	shlq $5,%rax
	movl 8(%rdx,%rax),%eax
	andl $131071,%eax
	cmpl %eax,%ecx
	setb %al
	movzbl %al,%eax
L131:
	ret 


_new_reload:
L159:
	pushq %rbx
	pushq %r12
	pushq %r13
L160:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L162:
	cmpl 708(%r13),%ebx
	jge L165
L163:
	movq 712(%r13),%rsi
	movslq %ebx,%rax
	shlq $5,%rax
	addq %rax,%rsi
	movq %r12,%rdi
	call _reload_precedes
	testl %eax,%eax
	jnz L165
L168:
	incl %ebx
	jmp L162
L165:
	movl $32,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 704(%r13),%rdi
	call _vector_insert
	movq 712(%r13),%rdi
	movslq %ebx,%rax
	shlq $5,%rax
	movl $32,%ecx
	movq %r12,%rsi
	addq %rax,%rdi
	rep 
	movsb 
	addq 712(%r13),%rax
L161:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_label:
L171:
	pushq %rbx
	pushq %r12
L172:
	movq 16(%rdi),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%r12
	movslq %edx,%rbx
	shlq $5,%rbx
	movl 8(%r12,%rbx),%esi
	movl %esi,%eax
	andl $7,%eax
	shll $10,%esi
	shrl $15,%esi
	cmpl $1,%eax
	jnz L175
L174:
	movq %rsi,%rdx
	movl 16(%r12,%rbx),%esi
	call _reg_to_number
	jmp L177
L175:
	movq 32(%r12,%rbx),%rdx
	subq $8,%rsp
	movq 24(%r12,%rbx),%rax
	movq %rax,(%rsp)
	call _imm
	addq $8,%rsp
L177:
	movl %eax,20(%r12,%rbx)
L173:
	popq %r12
	popq %rbx
	ret 


_match:
L178:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L179:
	movq %rdi,%r15
	movq %rsi,%r14
	movl $0,-4(%rbp)
	movl (%r14),%eax
	cmpl $-1342177263,%eax
	jz L187
L252:
	cmpl $-1275068398,%eax
	jz L187
L253:
	cmpl $-1275068397,%eax
	jz L187
L254:
	cmpl $-1610612726,%eax
	jnz L182
L187:
	movl $1,-4(%rbp)
L182:
	xorl %r13d,%r13d
L189:
	cmpl 660(%r15),%r13d
	jge L192
L190:
	movq 664(%r15),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%r12
	movq 16(%r12),%rax
	movl (%rax),%ecx
	movl (%r14),%eax
	cmpl %eax,%ecx
	jnz L191
L195:
	testl $2147483648,%eax
	movl $0,%eax
	movl $1,%esi
	cmovzl %eax,%esi
L197:
	movl (%r14),%ecx
	movl %ecx,%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,%esi
	jge L200
L198:
	movq 16(%r12),%rcx
	movslq %esi,%rdx
	shlq $5,%rdx
	movl 20(%rcx,%rdx),%eax
	cmpl 20(%rdx,%r14),%eax
	jnz L191
L206:
	cmpl $0,-4(%rbp)
	jz L211
L212:
	movl 8(%rdx,%rcx),%ecx
	andl $4194272,%ecx
	movl 8(%rdx,%r14),%eax
	andl $4194272,%eax
	cmpl %eax,%ecx
	jnz L191
L211:
	incl %esi
	jmp L197
L200:
	cmpl $2684354570,%ecx
	jnz L219
L220:
	movl 8(%r12),%ecx
	testl $73726,%ecx
	jz L191
L228:
	movl 8(%r14),%edx
	testl $2359232,%edx
	jz L191
L224:
	movl %ecx,%edi
	andl $131071,%edi
	movl %edx,%eax
	shll $10,%eax
	shrl $15,%eax
	cmpl %eax,%edi
	jz L219
L232:
	testl $7168,%ecx
	setz %cl
	movzbl %cl,%ecx
	testl $229376,%edx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L191
L236:
	call _t_size
	movl %eax,%ebx
	movl 8(%r14),%edi
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	cmpl %eax,%ebx
	jnz L191
L219:
	movq _values+8(%rip),%rcx
	movl 4(%r12),%esi
	movslq %esi,%rax
	shlq $5,%rax
	cmpl $1,(%rcx,%rax)
	jz L243
L244:
	movq %r15,%rdi
	call _number_to_reg
	testl %eax,%eax
	jnz L243
L241:
	movl $8,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 656(%r15),%rdi
	call _vector_delete
	decl %r13d
	jmp L191
L243:
	movl 4(%r12),%eax
	jmp L180
L191:
	incl %r13d
	jmp L189
L192:
	movl $-1,%eax
L180:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_replace:
L257:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L258:
	movq _values+8(%rip),%r14
	movq %rdi,%r15
	movl %esi,-16(%rbp)
	movl %edx,-36(%rbp)
	movl %ecx,-12(%rbp)
	movslq -36(%rbp),%r13
	shlq $5,%r13
	movq 16(%r15),%rcx
	movslq -16(%rbp),%rax
	movq (%rcx,%rax,8),%rcx
	movq %rax,-24(%rbp)
	movl 16(%rcx),%eax
	movl %eax,-28(%rbp)
	movl 8(%rcx),%r12d
	shll $10,%r12d
	shrl $15,%r12d
	movq %r12,%rdi
	call _t_size
	movl %eax,%ebx
	movl 8(%r14,%r13),%edi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jz L261
L260:
	movl 8(%r14,%r13),%edi
	andl $131071,%edi
	call _temp_reg
	movl %eax,%ebx
	jmp L262
L261:
	movl -28(%rbp),%ebx
L262:
	cmpl $1,(%r14,%r13)
	jnz L264
L263:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 8(%r14,%r13),%edx
	andl $131071,%edx
	jz L280
L278:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
L280:
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq 16(%r14,%r13),%rcx
	movq %rcx,56(%rax)
	movq 24(%r14,%r13),%rcx
	movq %rcx,64(%rax)
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	orl $64,_opt_request(%rip)
	jmp L265
L264:
	movl -36(%rbp),%esi
	movq %r15,%rdi
	call _number_to_reg
	movl %eax,-32(%rbp)
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 8(%r14,%r13),%edx
	andl $131071,%edx
	jz L310
L308:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
L310:
	movl 40(%rax),%edx
	andl $-8,%edx
	orl $1,%edx
	movl %edx,40(%rax)
	movl -32(%rbp),%ecx
	movl %ecx,48(%rax)
	movl 8(%r14,%r13),%ecx
	andl $131071,%ecx
	jz L325
L323:
	shll $5,%ecx
	andl $-4194273,%edx
	orl %ecx,%edx
	movl %edx,40(%rax)
L325:
	orl $36,_opt_request(%rip)
L265:
	movq 16(%r15),%rdx
	movq -24(%rbp),%rcx
	movq %rax,(%rdx,%rcx,8)
	movl -36(%rbp),%edx
	movl %ebx,%esi
	movq %r15,%rdi
	call _assoc
	cmpl %ebx,-28(%rbp)
	jz L328
L326:
	xorl %esi,%esi
	movl $-1275068397,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 8(%r14,%r13),%edx
	andl $131071,%edx
	jz L343
L341:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
L343:
	movl $32,%ecx
	leaq 8(%rax),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	movslq -12(%rbp),%rcx
	movq %rcx,-8(%rbp)
	movl 72(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,72(%rax)
	movq -8(%rbp),%rcx
	movq %rcx,88(%rax)
	movq $0,96(%rax)
	movl $_char_type,%ecx
	testq %rcx,%rcx
	jz L361
L353:
	movq _char_type(%rip),%rdx
	andl $131071,%edx
	shll $5,%edx
	movl 72(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,72(%rax)
L361:
	movl -16(%rbp),%edx
	incl %edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movl 8(%rax),%edx
	andl $-8,%edx
	orl $1,%edx
	movl %edx,8(%rax)
	movl -28(%rbp),%ecx
	movl %ecx,16(%rax)
	testq %r12,%r12
	jz L376
L374:
	andl $131071,%r12d
	shll $5,%r12d
	andl $-4194273,%edx
	orl %r12d,%edx
	movl %edx,8(%rax)
L376:
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,40(%rax)
	movl %ebx,48(%rax)
	movl 8(%r14,%r13),%edx
	andl $131071,%edx
	jz L391
L389:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
L391:
	movl -16(%rbp),%edx
	addl $2,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	orl $84,_opt_request(%rip)
L328:
	orl $264,_opt_request(%rip)
L259:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_invalidate:
L392:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L393:
	movq %rdi,%r14
	movq %rsi,%rbx
	testq %rbx,%rbx
	jz L443
L395:
	testl $16777216,(%rbx)
	jnz L399
L398:
	movq %rbx,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L399
L443:
	xorl %r13d,%r13d
	jmp L397
L399:
	movl $1,%r13d
L397:
	testq %rbx,%rbx
	jz L442
L402:
	testl $33554432,(%rbx)
	jnz L442
L405:
	movq %rbx,%rdi
	call _insn_uses_mem0
	testl %eax,%eax
	jz L407
L442:
	movl $1,%r12d
	jmp L404
L407:
	xorl %r12d,%r12d
L404:
	testq %rbx,%rbx
	jz L411
L412:
	cmpl $0,_tmp_regs(%rip)
	jl L416
L415:
	movl $0,_tmp_regs+4(%rip)
	jmp L417
L416:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L417:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L418:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L411
L422:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%esi
	testl %esi,%esi
	jz L411
L423:
	movq %r14,%rdi
	call _dissoc
	incl %ebx
	jmp L418
L411:
	testl %r13d,%r13d
	jz L428
L429:
	cmpl $0,704(%r14)
	jl L433
L432:
	movl $0,708(%r14)
	jmp L428
L433:
	movl 708(%r14),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $32,%ecx
	leaq 704(%r14),%rdi
	call _vector_insert
L428:
	testl %r12d,%r12d
	jz L394
L435:
	xorl %edx,%edx
L438:
	cmpl 708(%r14),%edx
	jge L394
L439:
	movq 712(%r14),%rcx
	movslq %edx,%rax
	shlq $5,%rax
	movq $0,24(%rcx,%rax)
	incl %edx
	jmp L438
L394:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_address:
L444:
L445:
	xorl %eax,%eax
	movq %rax,(%rdx)
	movq %rax,8(%rdx)
	movq %rax,16(%rdx)
	movq %rax,24(%rdx)
	movl %esi,4(%rdx)
L447:
	movl 4(%rdx),%esi
	cmpl $0,%esi
	jl L446
L448:
	movq _values+8(%rip),%rdi
	movslq %esi,%rsi
	shlq $5,%rsi
	movl (%rdi,%rsi),%eax
	cmpl $2,%eax
	jnz L451
L450:
	movl $-1,%ecx
	movq 16(%rdi,%rsi),%r9
	leaq 40(%r9),%r8
	movq %r8,%rdi
	leaq 72(%r9),%rsi
	movl (%r9),%eax
	cmpl $-1342177266,%eax
	jz L456
L485:
	cmpl $-1342177265,%eax
	jz L467
L486:
	cmpl $-1610612733,%eax
	jnz L446
L477:
	movq 56(%r9),%rcx
	addq 8(%rdx),%rcx
	movq %rcx,8(%rdx)
	movl $-2,4(%rdx)
	ret
L456:
	movl $1,%ecx
	movl 40(%r9),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L467
L460:
	cmpq $0,64(%r9)
	jnz L467
L461:
	movq %rsi,%rdi
	movq %r8,%rsi
L467:
	movl (%rsi),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L446
L471:
	cmpq $0,24(%rsi)
	jnz L446
L472:
	movslq %ecx,%rcx
	imulq 16(%rsi),%rcx
	addq 8(%rdx),%rcx
	movq %rcx,8(%rdx)
	movl 12(%rdi),%eax
	movl %eax,4(%rdx)
	jmp L447
L451:
	cmpl $1,%eax
	jnz L446
L479:
	movq 16(%rdi,%rsi),%rcx
	addq 8(%rdx),%rcx
	movq %rcx,8(%rdx)
	movq 24(%rdi,%rsi),%rax
	movq %rax,16(%rdx)
	movl $-3,4(%rdx)
L446:
	ret 


_overlaps:
L489:
	pushq %rbx
	pushq %r12
	pushq %r13
L490:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl 4(%r12),%ecx
	cmpl $-3,%ecx
	jnz L494
L499:
	cmpl $-3,4(%rbx)
	jnz L494
L495:
	movq 16(%r12),%rax
	cmpq 16(%rbx),%rax
	jnz L557
L494:
	cmpl $-3,%ecx
	jnz L507
L511:
	cmpl $-2,4(%rbx)
	jz L557
L507:
	movl 4(%rbx),%eax
	cmpl $-3,%eax
	jnz L506
L515:
	cmpl $-2,%ecx
	jz L557
L506:
	cmpl %eax,%ecx
	jnz L558
L522:
	movq 16(%r12),%rax
	cmpq 16(%rbx),%rax
	jnz L558
L526:
	movq _values+8(%rip),%rcx
	movslq (%r12),%rax
	shlq $5,%rax
	movl 8(%rcx,%rax),%edi
	andl $131071,%edi
	call _t_size
	movl %eax,%r13d
	movq _values+8(%rip),%rcx
	movslq (%rbx),%rax
	shlq $5,%rax
	movl 8(%rcx,%rax),%edi
	andl $131071,%edi
	call _t_size
	movq 8(%r12),%rdx
	movq 8(%rbx),%rcx
	cmpq %rcx,%rdx
	jnz L530
L531:
	cmpl %eax,%r13d
	jnz L530
L528:
	movl $2,%eax
	jmp L491
L530:
	cmpq %rcx,%rdx
	jl L538
L539:
	movslq %eax,%rax
	addq %rcx,%rax
	cmpq %rax,%rdx
	jge L538
L536:
	movslq %r13d,%r13
	addq %r13,%rdx
	cmpq %rdx,%rax
	jl L558
L543:
	movl $3,%eax
	jmp L491
L538:
	cmpq %rcx,%rdx
	jg L557
L551:
	movslq %r13d,%r13
	addq %r13,%rdx
	cmpq %rdx,%rcx
	jge L557
L558:
	movl $1,%eax
	jmp L491
L557:
	xorl %eax,%eax
L491:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_load:
L559:
	pushq %rbp
	movq %rsp,%rbp
	subq $72,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L560:
	movq %rdi,%r15
	movl %esi,-36(%rbp)
	movq 16(%r15),%rcx
	movslq -36(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	testl $1,4(%rax)
	movq %rax,-56(%rbp)
	jnz L562
L564:
	movl $1,%edx
	movl -36(%rbp),%esi
	movq %r15,%rdi
	call _label
	leaq -32(%rbp),%rdx
	movq -56(%rbp),%rax
	movl 52(%rax),%esi
	movq %r15,%rdi
	call _address
	movq -56(%rbp),%rax
	movl 8(%rax),%edx
	shll $10,%edx
	shrl $15,%edx
	xorl %esi,%esi
	movq %r15,%rdi
	call _new_number
	movl %eax,-32(%rbp)
	movq $0,-72(%rbp)
	xorl %r14d,%r14d
L566:
	cmpl 708(%r15),%r14d
	jge L586
L567:
	movq 712(%r15),%r13
	movslq %r14d,%r12
	movq _values+8(%rip),%rcx
	shlq $5,%r12
	leaq (%r13,%r12),%rax
	movq %rax,-64(%rbp)
	movl (%r13,%r12),%esi
	movslq %esi,%rax
	shlq $5,%rax
	cmpl $1,(%rcx,%rax)
	jz L572
L573:
	movq %r15,%rdi
	call _number_to_reg
	testl %eax,%eax
	jz L570
L572:
	movq _values+8(%rip),%rdx
	movslq (%r13,%r12),%rax
	shlq $5,%rax
	testl $7168,8(%rdx,%rax)
	setz %cl
	movzbl %cl,%ecx
	movslq -32(%rbp),%rax
	shlq $5,%rax
	testl $7168,8(%rdx,%rax)
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L568
L580:
	leaq (%r13,%r12),%rsi
	leaq -32(%rbp),%rdi
	call _overlaps
	cmpl $2,%eax
	jz L585
L597:
	cmpl $3,%eax
	jnz L568
L588:
	movq _values+8(%rip),%rcx
	movslq -32(%rbp),%rax
	shlq $5,%rax
	testl $7168,8(%rcx,%rax)
	jnz L568
L589:
	movq -64(%rbp),%rax
	movq %rax,-72(%rbp)
	movq -24(%rbp),%rbx
	movq 8(%r13,%r12),%rax
	subl %eax,%ebx
	shll $3,%ebx
	jmp L568
L585:
	movq -64(%rbp),%rax
	movq %rax,-72(%rbp)
	xorl %ebx,%ebx
	jmp L586
L570:
	movl $32,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 704(%r15),%rdi
	call _vector_delete
	decl %r14d
L568:
	incl %r14d
	jmp L566
L586:
	cmpq $0,-72(%rbp)
	jz L594
L593:
	movl %ebx,%ecx
	movq -72(%rbp),%rax
	movl (%rax),%edx
	movl -36(%rbp),%esi
	movq %r15,%rdi
	call _replace
	jmp L561
L594:
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _new_reload
	movq %rax,-48(%rbp)
	xorl %esi,%esi
	movq %r15,%rdi
	call _invalidate
	movq -56(%rbp),%rax
	movl 16(%rax),%esi
	movq -48(%rbp),%rax
	movl (%rax),%edx
	movq %r15,%rdi
	call _assoc
	jmp L561
L562:
	xorl %esi,%esi
	movq %r15,%rdi
	call _invalidate
L561:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_overwrite:
L600:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L601:
	movq _values+8(%rip),%r13
	movq %rdi,-16(%rbp)
	movq %rsi,%r15
	movq %rdx,%r14
	movslq (%r15),%r12
	shlq $5,%r12
	movslq (%r14),%rbx
	shlq $5,%rbx
	movl 8(%r13,%r12),%edi
	testl $66558,%edi
	jz L603
L614:
	cmpl $1,(%r13,%r12)
	jnz L603
L610:
	cmpq $0,24(%r13,%r12)
	jnz L603
L606:
	testl $66558,8(%r13,%rbx)
	jz L603
L622:
	cmpl $1,(%r13,%rbx)
	jnz L603
L618:
	cmpq $0,24(%r13,%rbx)
	jnz L603
L605:
	andl $131071,%edi
	call _t_size
	shll $3,%eax
	movq 8(%r15),%rdi
	movq 8(%r14),%rcx
	subl %ecx,%edi
	shll $3,%edi
	movb %al,%cl
	movq $-1,%rsi
	shlq %cl,%rsi
	notq %rsi
	movb %dil,%cl
	movq %rsi,%rdx
	shlq %cl,%rdx
	notq %rdx
	andq 16(%r13,%rbx),%rdx
	movq %rdx,-8(%rbp)
	movq 16(%r13,%r12),%rax
	andq %rsi,%rax
	movb %dil,%cl
	shlq %cl,%rax
	orq %rdx,%rax
	movq %rax,-8(%rbp)
	movl 8(%r13,%rbx),%esi
	andl $131071,%esi
	subq $8,%rsp
	movq -8(%rbp),%rax
	movq %rax,(%rsp)
	xorl %edx,%edx
	movq -16(%rbp),%rdi
	call _imm
	addq $8,%rsp
	jmp L602
L603:
	movl $-1,%eax
L602:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_store:
L628:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L629:
	movq %rdi,%r15
	movl %esi,%ebx
	movq 16(%r15),%rax
	movslq %ebx,%rcx
	movq (%rax,%rcx,8),%rax
	movq %rax,-48(%rbp)
	movq %rcx,-40(%rbp)
	xorl %edx,%edx
	movl %ebx,%esi
	movq %r15,%rdi
	call _label
	movl $1,%edx
	movl %ebx,%esi
	movq %r15,%rdi
	call _label
	leaq -32(%rbp),%rdx
	movq -48(%rbp),%rax
	movl 20(%rax),%esi
	movq %r15,%rdi
	call _address
	movq -48(%rbp),%rax
	movl 52(%rax),%eax
	movl %eax,-32(%rbp)
	movq -48(%rbp),%rax
	testl $1,4(%rax)
	jz L632
L631:
	xorl %eax,%eax
	jmp L633
L632:
	movq 16(%r15),%rcx
	movq -40(%rbp),%rax
	leaq (%rcx,%rax,8),%rax
L633:
	movq %rax,-8(%rbp)
	xorl %r14d,%r14d
L634:
	cmpl 708(%r15),%r14d
	jge L637
L635:
	movq 712(%r15),%r13
	movslq %r14d,%r12
	shlq $5,%r12
	leaq -32(%rbp),%rsi
	leaq (%r13,%r12),%rdi
	call _overlaps
	cmpl $2,%eax
	jz L642
L686:
	cmpl $3,%eax
	jz L642
L687:
	leaq (%r13,%r12),%rsi
	leaq -32(%rbp),%rdi
	call _overlaps
	cmpl $3,%eax
	jz L651
L690:
	cmpl $1,%eax
	jz L646
	jnz L636
L651:
	leaq (%r13,%r12),%rdx
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _overwrite
	movl %eax,(%r13,%r12)
	cmpl $-1,%eax
	jz L646
L653:
	cmpq $0,24(%r13,%r12)
	jz L636
L659:
	movq -48(%rbp),%rax
	testl $1,4(%rax)
	jnz L636
L660:
	xorl %esi,%esi
	movl $553648133,%edi
	call _new_insn
	movq 24(%r13,%r12),%rcx
	movq (%rcx),%rsi
	movl $32,%ecx
	addq $8,%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq _values+8(%rip),%rdx
	movslq (%r13,%r12),%rcx
	shlq $5,%rcx
	movq 16(%rdx,%rcx),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movq _values+8(%rip),%rdx
	movslq (%r13,%r12),%rcx
	shlq $5,%rcx
	movl 8(%rdx,%rcx),%edx
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
	movq 24(%r13,%r12),%rcx
	movq %rax,(%rcx)
	movq $0,-8(%rbp)
	movq 16(%r15),%rcx
	movslq %ebx,%rax
	movq $_nop_insn,(%rcx,%rax,8)
	orl $8,_opt_request(%rip)
	jmp L636
L642:
	movq 24(%r13,%r12),%rax
	testq %rax,%rax
	jz L646
L643:
	movq $_nop_insn,(%rax)
	orl $264,_opt_request(%rip)
L646:
	movl $32,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 704(%r15),%rdi
	call _vector_delete
	decl %r14d
L636:
	incl %r14d
	jmp L634
L637:
	movq 16(%r15),%rax
	movslq %ebx,%rbx
	cmpq $_nop_insn,(%rax,%rbx,8)
	jz L630
L682:
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _new_reload
L630:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_meet0:
L693:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L694:
	movq %rdi,%r15
	movq %rsi,-8(%rbp)
	xorl %ebx,%ebx
	movl $0,-12(%rbp)
L696:
	movl 660(%r15),%esi
	cmpl %esi,%ebx
	jge L701
L699:
	movq -8(%rbp),%rcx
	movl -12(%rbp),%eax
	cmpl 660(%rcx),%eax
	jge L701
L700:
	movq 664(%r15),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-32(%rbp)
	movq -8(%rbp),%rax
	movq 664(%rax),%rcx
	movslq -12(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movl 4(%rax),%ecx
	movq -32(%rbp),%rax
	cmpl 4(%rax),%ecx
	jl L703
	jz L707
L706:
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 656(%r15),%rdi
	call _vector_delete
	jmp L696
L707:
	incl %ebx
	jmp L696
L703:
	incl -12(%rbp)
	jmp L696
L701:
	cmpl 656(%r15),%ebx
	jg L713
L712:
	movl %ebx,660(%r15)
	jmp L714
L713:
	subl %esi,%ebx
	movl $8,%ecx
	movl %ebx,%edx
	leaq 656(%r15),%rdi
	call _vector_insert
L714:
	xorl %ebx,%ebx
	movl $0,-16(%rbp)
L715:
	movl 684(%r15),%esi
	cmpl %esi,%ebx
	jge L720
L718:
	movq -8(%rbp),%rcx
	movl -16(%rbp),%eax
	cmpl 684(%rcx),%eax
	jge L720
L719:
	movq 688(%r15),%rdi
	movslq %ebx,%rsi
	movq -8(%rbp),%rax
	movq 688(%rax),%rdx
	movslq -16(%rbp),%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl (%rdi,%rsi,8),%eax
	jb L722
	ja L729
L728:
	movl 4(%rdi,%rsi,8),%eax
	cmpl 4(%rdx,%rcx,8),%eax
	jz L730
L729:
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 680(%r15),%rdi
	call _vector_delete
	jmp L715
L730:
	incl %ebx
	jmp L715
L722:
	incl -16(%rbp)
	jmp L715
L720:
	cmpl 680(%r15),%ebx
	jg L736
L735:
	movl %ebx,684(%r15)
	jmp L737
L736:
	subl %esi,%ebx
	movl $8,%ecx
	movl %ebx,%edx
	leaq 680(%r15),%rdi
	call _vector_insert
L737:
	xorl %ebx,%ebx
	movl $0,-20(%rbp)
L738:
	movl 708(%r15),%esi
	cmpl %esi,%ebx
	jge L743
L741:
	movq -8(%rbp),%rcx
	movl -20(%rbp),%eax
	cmpl 708(%rcx),%eax
	jge L743
L742:
	movq 712(%r15),%rax
	movq %rax,-40(%rbp)
	movslq %ebx,%r14
	shlq $5,%r14
	movq -8(%rbp),%rax
	movq 712(%rax),%r13
	movslq -20(%rbp),%r12
	shlq $5,%r12
	movq -40(%rbp),%rsi
	addq %r14,%rsi
	leaq (%r13,%r12),%rdi
	call _reload_precedes
	testl %eax,%eax
	jz L746
L745:
	incl -20(%rbp)
	jmp L738
L746:
	leaq (%r13,%r12),%rsi
	movq -40(%rbp),%rdi
	addq %r14,%rdi
	call _reload_precedes
	testl %eax,%eax
	jnz L752
L751:
	movq -40(%rbp),%rax
	movl (%rax,%r14),%eax
	cmpl (%r13,%r12),%eax
	jz L753
L752:
	movl $32,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 704(%r15),%rdi
	call _vector_delete
	jmp L738
L753:
	incl %ebx
	jmp L738
L743:
	cmpl 704(%r15),%ebx
	jg L759
L758:
	movl %ebx,708(%r15)
	jmp L695
L759:
	subl %esi,%ebx
	movl $32,%ecx
	movl %ebx,%edx
	leaq 704(%r15),%rdi
	call _vector_insert
L695:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_inherit0:
L761:
	pushq %rbx
	pushq %r12
	pushq %r13
L762:
	movq %rdi,%r13
	movq %r13,%rsi
	movq %r13,%rdi
	call _is_pred
	testl %eax,%eax
	jnz L763
L764:
	xorl %r12d,%r12d
L767:
	cmpl 36(%r13),%r12d
	jge L763
L768:
	movq 40(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	testl %r12d,%r12d
	jnz L772
L774:
	movl $8,%edx
	leaq 656(%rbx),%rsi
	leaq 656(%r13),%rdi
	call _dup_vector
	movl $8,%edx
	leaq 680(%rbx),%rsi
	leaq 680(%r13),%rdi
	call _dup_vector
	movl $32,%edx
	leaq 704(%rbx),%rsi
	leaq 704(%r13),%rdi
	call _dup_vector
	jmp L773
L772:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _meet0
L773:
	incl %r12d
	jmp L767
L763:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L839:
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
.align 4
L843:
	.int -1610612733
	.int -1610612727
	.int -1610612726
	.int -1610612724
	.int -1577058300
	.int -1543503859
	.int -1543503836
	.int -1543503835
	.int -1342177266
	.int -1342177265
	.int -1342177264
	.int -1342177263
	.int 553648133
.align 2
L844:
	.short L795-_dvn0
	.short L814-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L816-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L795-_dvn0
	.short L818-_dvn0

_dvn0:
L783:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L784:
	movq %rdi,%r13
	movq %r13,%rdi
	call _inherit0
	xorl %esi,%esi
	movq %r13,%rdi
	call _invalidate
	xorl %r12d,%r12d
L786:
	cmpl 12(%r13),%r12d
	jge L785
L790:
	movq 16(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	testq %rbx,%rbx
	jz L785
L787:
	movl (%rbx),%ecx
	cmpl $-1275068398,%ecx
	jl L836
L838:
	cmpl $-1275068393,%ecx
	jg L836
L835:
	addl $1275068398,%ecx
	movzwl L839(,%rcx,2),%eax
	addl $_dvn0,%eax
	jmp *%rax
L836:
	xorl %eax,%eax
L840:
	cmpl L843(,%rax,4),%ecx
	jz L841
L842:
	incl %eax
	cmpl $13,%eax
	jb L840
	jae L794
L841:
	movzwl L844(,%rax,2),%eax
	addl $_dvn0,%eax
	jmp *%rax
L818:
	movl %r12d,%esi
	movq %r13,%rdi
	call _store
	jmp L788
L816:
	movl %r12d,%esi
	movq %r13,%rdi
	call _load
	jmp L788
L814:
	movl $1,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _label
	movl 16(%rbx),%esi
	movl 52(%rbx),%edx
	jmp L845
L795:
	movl $1,%r14d
L821:
	movl (%rbx),%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,%r14d
	jge L824
L822:
	movl %r14d,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _label
	incl %r14d
	jmp L821
L824:
	cmpl $3,%eax
	jnz L827
L828:
	movl 52(%rbx),%eax
	cmpl 84(%rbx),%eax
	jge L827
L825:
	movq %rbx,%rdi
	call _commute_insn
L827:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _match
	movl %eax,%edx
	cmpl $-1,%edx
	jnz L833
L832:
	movl 8(%rbx),%edx
	shll $10,%edx
	shrl $15,%edx
	movl $2,%esi
	movq %r13,%rdi
	call _new_number
	movq _values+8(%rip),%rdx
	movslq %eax,%rcx
	shlq $5,%rcx
	movq %rbx,16(%rdx,%rcx)
	movl %eax,%edx
	movl 16(%rbx),%esi
L845:
	movq %r13,%rdi
	call _assoc
	jmp L788
L833:
	xorl %ecx,%ecx
	movl %r12d,%esi
	movq %r13,%rdi
	call _replace
	jmp L788
L794:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _invalidate
L788:
	incl %r12d
	jmp L786
L785:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_opt_lir_dvn:
L846:
	pushq %rbx
L849:
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movl $0,_values(%rip)
	movl $0,_values+4(%rip)
	movq $0,_values+8(%rip)
	movq $_local_arena,_values+16(%rip)
	movl $0,_imms(%rip)
	movl $0,_imms+4(%rip)
	movq $0,_imms+8(%rip)
	movq $_local_arena,_imms+16(%rip)
	movq _all_blocks(%rip),%rax
L858:
	testq %rax,%rax
	jz L861
L862:
	movl $0,656(%rax)
	movl $0,660(%rax)
	movq $0,664(%rax)
	movq $_local_arena,672(%rax)
	movl $0,680(%rax)
	movl $0,684(%rax)
	movq $0,688(%rax)
	movq $_local_arena,696(%rax)
	movl $0,704(%rax)
	movl $0,708(%rax)
	movq $0,712(%rax)
	movq $_local_arena,720(%rax)
	movq 112(%rax),%rax
	jmp L858
L861:
	xorl %edi,%edi
	call _sequence_blocks
	movq _all_blocks(%rip),%rbx
L871:
	testq %rbx,%rbx
	jz L875
L872:
	movq %rbx,%rdi
	call _dvn0
	movq 112(%rbx),%rbx
	jmp L871
L875:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
	orl $2,_opt_request(%rip)
L848:
	popq %rbx
	ret 

.local _values
.comm _values, 24, 8
.local _imms
.comm _imms, 24, 8
.local _tmp_regs
.comm _tmp_regs, 24, 8

.globl _temp_reg
.globl _nop_insn
.globl _all_blocks
.globl _insn_defs_mem0
.globl _sequence_blocks
.globl _is_pred
.globl _insn_uses_mem0
.globl _char_type
.globl _opt_lir_dvn
.globl _commute_insn
.globl _normalize_con
.globl _opt_request
.globl _local_arena
.globl _new_insn
.globl _vector_insert
.globl _vector_delete
.globl _dup_vector
.globl _insn_defs
.globl _t_size
.globl _insert_insn
