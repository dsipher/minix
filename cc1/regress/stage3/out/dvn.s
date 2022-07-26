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
	decl %eax
	movslq %eax,%rax
	movq %rbx,(%rcx,%rax,8)
	jmp L11
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
L34:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L35:
	movq %rdi,-8(%rbp)
	movq %rsi,%r12
	movq %rdx,%r15
	xorl %r14d,%r14d
L37:
	cmpl _imms+4(%rip),%r14d
	jge L40
L38:
	movq _imms+8(%rip),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r13
	cmpq 24(%r13),%r15
	jnz L39
L43:
	movl 8(%r13),%eax
	testl $73726,%eax
	jz L39
L52:
	testq $73726,%r12
	jz L39
L48:
	movl %eax,%edi
	andl $131071,%edi
	cmpq %rdi,%r12
	jz L47
L56:
	testl $7168,%eax
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%r12
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L39
L60:
	call _t_size
	movl %eax,%ebx
	movq %r12,%rdi
	call _t_size
	cmpl %eax,%ebx
	jnz L39
L47:
	movl 8(%r13),%edi
	andl $131071,%edi
	leaq 16(%rbp),%rsi
	call _normalize_con
	movq 16(%r13),%rax
	cmpq 16(%rbp),%rax
	jnz L39
L65:
	movl 4(%r13),%eax
	jmp L36
L39:
	incl %r14d
	jmp L37
L40:
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
L36:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_assoc:
L70:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L71:
	movq %rdi,%r13
	movl %esi,%r12d
	movl %edx,%ebx
	xorl %r14d,%r14d
L73:
	cmpl 684(%r13),%r14d
	jge L76
L74:
	movq 688(%r13),%rdx
	movslq %r14d,%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl %eax,%r12d
	jz L77
L79:
	cmpl %eax,%r12d
	jb L76
L83:
	incl %r14d
	jmp L73
L77:
	movl %ebx,4(%rdx,%rcx,8)
	jmp L72
L76:
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
L72:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_reg_to_number:
L85:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L86:
	movq %rdi,%r14
	movl %esi,%r13d
	movq %rdx,%r12
	xorl %ebx,%ebx
L88:
	cmpl 684(%r14),%ebx
	jge L91
L89:
	movq 688(%r14),%rdx
	movslq %ebx,%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl %eax,%r13d
	jz L92
L94:
	cmpl %eax,%r13d
	jb L91
L98:
	incl %ebx
	jmp L88
L92:
	movl 4(%rdx,%rcx,8),%eax
	jmp L87
L91:
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
L87:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_number_to_reg:
L101:
L102:
	xorl %edx,%edx
L104:
	cmpl 684(%rdi),%edx
	jge L107
L105:
	movq 688(%rdi),%rcx
	movslq %edx,%rax
	cmpl 4(%rcx,%rax,8),%esi
	jz L108
L110:
	incl %edx
	jmp L104
L108:
	movl (%rcx,%rax,8),%eax
	ret
L107:
	xorl %eax,%eax
L103:
	ret 


_dissoc:
L113:
L114:
	movl %esi,%edx
	xorl %esi,%esi
L116:
	cmpl 684(%rdi),%esi
	jge L115
L117:
	movq 688(%rdi),%rcx
	movslq %esi,%rax
	movl (%rcx,%rax,8),%eax
	cmpl %eax,%edx
	jz L120
L122:
	cmpl %eax,%edx
	jb L115
L126:
	incl %esi
	jmp L116
L120:
	movl $8,%ecx
	movl $1,%edx
	addq $680,%rdi
	call _vector_delete
L115:
	ret 


_reload_precedes:
L128:
L129:
	movl 4(%rdi),%eax
	cmpl 4(%rsi),%eax
	jl L156
	jg L157
L137:
	movq 8(%rdi),%rax
	cmpq 8(%rsi),%rax
	jl L156
	jg L157
L145:
	movq 16(%rdi),%rax
	cmpq 16(%rsi),%rax
	jz L153
	jb L156
L157:
	xorl %eax,%eax
	ret
L156:
	movl $1,%eax
	ret
L153:
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
L130:
	ret 


_new_reload:
L158:
	pushq %rbx
	pushq %r12
	pushq %r13
L159:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L161:
	cmpl 708(%r13),%ebx
	jge L164
L162:
	movq 712(%r13),%rsi
	movslq %ebx,%rax
	shlq $5,%rax
	addq %rax,%rsi
	movq %r12,%rdi
	call _reload_precedes
	testl %eax,%eax
	jnz L164
L167:
	incl %ebx
	jmp L161
L164:
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
L160:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_label:
L170:
	pushq %rbx
	pushq %r12
L171:
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
	jnz L174
L173:
	movq %rsi,%rdx
	movl 16(%r12,%rbx),%esi
	call _reg_to_number
	movl %eax,20(%r12,%rbx)
	jmp L172
L174:
	movq 32(%r12,%rbx),%rdx
	subq $8,%rsp
	movq 24(%r12,%rbx),%rax
	movq %rax,(%rsp)
	call _imm
	addq $8,%rsp
	movl %eax,20(%r12,%rbx)
L172:
	popq %r12
	popq %rbx
	ret 


_match:
L176:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L177:
	movq %rdi,%r15
	movq %rsi,%r14
	movl $0,-8(%rbp)
	movl (%r14),%eax
	cmpl $-1342177263,%eax
	jz L185
L250:
	cmpl $-1275068398,%eax
	jz L185
L251:
	cmpl $-1275068397,%eax
	jz L185
L252:
	cmpl $-1610612726,%eax
	jnz L180
L185:
	movl $1,-8(%rbp)
L180:
	xorl %r13d,%r13d
L187:
	cmpl 660(%r15),%r13d
	jge L190
L188:
	movq 664(%r15),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%r12
	movq 16(%r12),%rax
	movl (%rax),%ecx
	movl (%r14),%eax
	cmpl %eax,%ecx
	jnz L189
L193:
	testl $2147483648,%eax
	movl $0,%eax
	movl $1,%esi
	cmovzl %eax,%esi
L195:
	movl (%r14),%ecx
	movl %ecx,%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,%esi
	jge L198
L196:
	movq 16(%r12),%rcx
	movslq %esi,%rdx
	shlq $5,%rdx
	movl 20(%rcx,%rdx),%eax
	cmpl 20(%rdx,%r14),%eax
	jnz L189
L204:
	cmpl $0,-8(%rbp)
	jz L209
L210:
	movl 8(%rdx,%rcx),%ecx
	andl $4194272,%ecx
	movl 8(%rdx,%r14),%eax
	andl $4194272,%eax
	cmpl %eax,%ecx
	jnz L189
L209:
	incl %esi
	jmp L195
L198:
	cmpl $2684354570,%ecx
	jnz L217
L218:
	movl 8(%r12),%ecx
	testl $73726,%ecx
	jz L189
L226:
	movl 8(%r14),%edx
	testl $2359232,%edx
	jz L189
L222:
	movl %ecx,%edi
	andl $131071,%edi
	movl %edx,%eax
	shll $10,%eax
	shrl $15,%eax
	cmpl %eax,%edi
	jz L217
L230:
	testl $7168,%ecx
	setz %cl
	movzbl %cl,%ecx
	testl $229376,%edx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L189
L234:
	call _t_size
	movl %eax,%ebx
	movl 8(%r14),%edi
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	cmpl %eax,%ebx
	jnz L189
L217:
	movq _values+8(%rip),%rcx
	movl 4(%r12),%esi
	movslq %esi,%rax
	shlq $5,%rax
	cmpl $1,(%rcx,%rax)
	jz L241
L242:
	movq %r15,%rdi
	call _number_to_reg
	testl %eax,%eax
	jnz L241
L239:
	movl $8,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 656(%r15),%rdi
	call _vector_delete
	decl %r13d
	jmp L189
L241:
	movl 4(%r12),%eax
	jmp L178
L189:
	incl %r13d
	jmp L187
L190:
	movl $-1,%eax
L178:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_replace:
L255:
	pushq %rbp
	movq %rsp,%rbp
	subq $56,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L256:
	movq _values+8(%rip),%r14
	movq %rdi,%r15
	movl %esi,-24(%rbp)
	movl %edx,-56(%rbp)
	movl %ecx,-16(%rbp)
	movslq -56(%rbp),%r13
	shlq $5,%r13
	movq 16(%r15),%rax
	movslq -24(%rbp),%rcx
	movq %rcx,-32(%rbp)
	movq -32(%rbp),%rcx
	movq (%rax,%rcx,8),%rax
	movl 16(%rax),%ecx
	movl %ecx,-40(%rbp)
	movl 8(%rax),%r12d
	shll $10,%r12d
	shrl $15,%r12d
	movq %r12,%rdi
	call _t_size
	movl %eax,%ebx
	movl 8(%r14,%r13),%edi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jz L259
L258:
	movl 8(%r14,%r13),%edi
	andl $131071,%edi
	call _temp_reg
	movl %eax,%ebx
	jmp L260
L259:
	movl -40(%rbp),%ebx
L260:
	cmpl $1,(%r14,%r13)
	jnz L262
L261:
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
	jz L278
L276:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
L278:
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
	jmp L263
L262:
	movl -56(%rbp),%esi
	movq %r15,%rdi
	call _number_to_reg
	movl %eax,-48(%rbp)
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
	jz L308
L306:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
L308:
	movl 40(%rax),%edx
	andl $-8,%edx
	orl $1,%edx
	movl %edx,40(%rax)
	movl -48(%rbp),%ecx
	movl %ecx,48(%rax)
	movl 8(%r14,%r13),%ecx
	andl $131071,%ecx
	jz L323
L321:
	shll $5,%ecx
	andl $-4194273,%edx
	orl %ecx,%edx
	movl %edx,40(%rax)
L323:
	orl $36,_opt_request(%rip)
L263:
	movq 16(%r15),%rdx
	movq -32(%rbp),%rcx
	movq %rax,(%rdx,%rcx,8)
	movl -56(%rbp),%edx
	movl %ebx,%esi
	movq %r15,%rdi
	call _assoc
	cmpl %ebx,-40(%rbp)
	jz L326
L324:
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
	jz L341
L339:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,8(%rax)
L341:
	movl $32,%ecx
	leaq 8(%rax),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	movslq -16(%rbp),%rcx
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
	jz L359
L351:
	movq _char_type(%rip),%rdx
	andl $131071,%edx
	shll $5,%edx
	movl 72(%rax),%ecx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,72(%rax)
L359:
	movl -24(%rbp),%edx
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
	movl -40(%rbp),%ecx
	movl %ecx,16(%rax)
	testq %r12,%r12
	jz L374
L372:
	andl $131071,%r12d
	shll $5,%r12d
	andl $-4194273,%edx
	orl %r12d,%edx
	movl %edx,8(%rax)
L374:
	movl 40(%rax),%ecx
	andl $-8,%ecx
	orl $1,%ecx
	movl %ecx,40(%rax)
	movl %ebx,48(%rax)
	movl 8(%r14,%r13),%edx
	andl $131071,%edx
	jz L389
L387:
	shll $5,%edx
	andl $-4194273,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
L389:
	movl -24(%rbp),%edx
	addl $2,%edx
	movq %r15,%rsi
	movq %rax,%rdi
	call _insert_insn
	orl $84,_opt_request(%rip)
L326:
	orl $264,_opt_request(%rip)
L257:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_invalidate:
L390:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L391:
	movq %rdi,%r14
	movq %rsi,%rbx
	testq %rbx,%rbx
	jz L394
L393:
	testl $16777216,(%rbx)
	jnz L397
L396:
	movq %rbx,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jz L398
L397:
	movl $1,%r13d
	jmp L395
L398:
	xorl %r13d,%r13d
	jmp L395
L394:
	xorl %r13d,%r13d
L395:
	testq %rbx,%rbx
	jz L401
L400:
	testl $33554432,(%rbx)
	jnz L404
L403:
	movq %rbx,%rdi
	call _insn_uses_mem0
	testl %eax,%eax
	jz L405
L404:
	movl $1,%r12d
	jmp L402
L405:
	xorl %r12d,%r12d
	jmp L402
L401:
	movl $1,%r12d
L402:
	testq %rbx,%rbx
	jz L409
L410:
	cmpl $0,_tmp_regs(%rip)
	jl L414
L413:
	movl $0,_tmp_regs+4(%rip)
	jmp L415
L414:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L415:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L416:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L409
L420:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%esi
	testl %esi,%esi
	jz L409
L421:
	movq %r14,%rdi
	call _dissoc
	incl %ebx
	jmp L416
L409:
	testl %r13d,%r13d
	jz L426
L427:
	cmpl $0,704(%r14)
	jl L431
L430:
	movl $0,708(%r14)
	jmp L426
L431:
	movl 708(%r14),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $32,%ecx
	leaq 704(%r14),%rdi
	call _vector_insert
L426:
	testl %r12d,%r12d
	jz L392
L433:
	xorl %edx,%edx
L436:
	cmpl 708(%r14),%edx
	jge L392
L437:
	movq 712(%r14),%rcx
	movslq %edx,%rax
	shlq $5,%rax
	movq $0,24(%rcx,%rax)
	incl %edx
	jmp L436
L392:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_address:
L440:
L441:
	xorl %eax,%eax
	movq %rax,(%rdx)
	movq %rax,8(%rdx)
	movq %rax,16(%rdx)
	movq %rax,24(%rdx)
	movl %esi,4(%rdx)
L443:
	movl 4(%rdx),%esi
	cmpl $0,%esi
	jl L442
L444:
	movq _values+8(%rip),%rdi
	movslq %esi,%rsi
	shlq $5,%rsi
	movl (%rdi,%rsi),%eax
	cmpl $2,%eax
	jnz L447
L446:
	movl $-1,%ecx
	movq 16(%rdi,%rsi),%r9
	leaq 40(%r9),%r8
	movq %r8,%rdi
	leaq 72(%r9),%rsi
	movl (%r9),%eax
	cmpl $-1342177266,%eax
	jz L452
L481:
	cmpl $-1342177265,%eax
	jz L463
L482:
	cmpl $-1610612733,%eax
	jnz L442
L473:
	movq 56(%r9),%rcx
	addq 8(%rdx),%rcx
	movq %rcx,8(%rdx)
	movl $-2,4(%rdx)
	ret
L452:
	movl $1,%ecx
	movl 40(%r9),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L463
L456:
	cmpq $0,64(%r9)
	jnz L463
L457:
	movq %rsi,%rdi
	movq %r8,%rsi
L463:
	movl (%rsi),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L442
L467:
	cmpq $0,24(%rsi)
	jnz L442
L468:
	movslq %ecx,%rcx
	imulq 16(%rsi),%rcx
	addq 8(%rdx),%rcx
	movq %rcx,8(%rdx)
	movl 12(%rdi),%eax
	movl %eax,4(%rdx)
	jmp L443
L447:
	cmpl $1,%eax
	jnz L442
L475:
	movq 16(%rdi,%rsi),%rcx
	addq 8(%rdx),%rcx
	movq %rcx,8(%rdx)
	movq 24(%rdi,%rsi),%rax
	movq %rax,16(%rdx)
	movl $-3,4(%rdx)
L442:
	ret 


_overlaps:
L485:
	pushq %rbx
	pushq %r12
	pushq %r13
L486:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl 4(%r12),%ecx
	cmpl $-3,%ecx
	jnz L490
L495:
	cmpl $-3,4(%rbx)
	jnz L490
L491:
	movq 16(%r12),%rax
	cmpq 16(%rbx),%rax
	jnz L553
L490:
	cmpl $-3,%ecx
	jnz L503
L507:
	cmpl $-2,4(%rbx)
	jz L553
L503:
	movl 4(%rbx),%eax
	cmpl $-3,%eax
	jnz L502
L511:
	cmpl $-2,%ecx
	jz L553
L502:
	cmpl %eax,%ecx
	jnz L554
L518:
	movq 16(%r12),%rax
	cmpq 16(%rbx),%rax
	jnz L554
L522:
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
	jnz L526
L527:
	cmpl %eax,%r13d
	jnz L526
L524:
	movl $2,%eax
	jmp L487
L526:
	cmpq %rcx,%rdx
	jl L534
L535:
	movslq %eax,%rax
	addq %rcx,%rax
	cmpq %rax,%rdx
	jge L534
L532:
	movslq %r13d,%r13
	addq %r13,%rdx
	cmpq %rdx,%rax
	jl L554
L539:
	movl $3,%eax
	jmp L487
L534:
	cmpq %rcx,%rdx
	jg L553
L547:
	movslq %r13d,%r13
	addq %r13,%rdx
	cmpq %rdx,%rcx
	jge L553
L554:
	movl $1,%eax
	jmp L487
L553:
	xorl %eax,%eax
L487:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_load:
L555:
	pushq %rbp
	movq %rsp,%rbp
	subq $72,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L556:
	movq %rdi,%r15
	movl %esi,-40(%rbp)
	movq 16(%r15),%rcx
	movslq -40(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-56(%rbp)
	movq -56(%rbp),%rax
	testl $1,4(%rax)
	jnz L558
L560:
	movl $1,%edx
	movl -40(%rbp),%esi
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
L562:
	cmpl 708(%r15),%r14d
	jge L582
L563:
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
	jz L568
L569:
	movq %r15,%rdi
	call _number_to_reg
	testl %eax,%eax
	jz L566
L568:
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
	jnz L564
L576:
	leaq (%r13,%r12),%rsi
	leaq -32(%rbp),%rdi
	call _overlaps
	cmpl $2,%eax
	jz L581
L593:
	cmpl $3,%eax
	jnz L564
L584:
	movq _values+8(%rip),%rcx
	movslq -32(%rbp),%rax
	shlq $5,%rax
	testl $7168,8(%rcx,%rax)
	jnz L564
L585:
	movq -64(%rbp),%rax
	movq %rax,-72(%rbp)
	movq -24(%rbp),%rbx
	movq 8(%r13,%r12),%rax
	subl %eax,%ebx
	shll $3,%ebx
	jmp L564
L581:
	movq -64(%rbp),%rax
	movq %rax,-72(%rbp)
	xorl %ebx,%ebx
	jmp L582
L566:
	movl $32,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 704(%r15),%rdi
	call _vector_delete
	decl %r14d
L564:
	incl %r14d
	jmp L562
L582:
	cmpq $0,-72(%rbp)
	jz L590
L589:
	movl %ebx,%ecx
	movq -72(%rbp),%rax
	movl (%rax),%edx
	movl -40(%rbp),%esi
	movq %r15,%rdi
	call _replace
	jmp L557
L590:
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
	jmp L557
L558:
	xorl %esi,%esi
	movq %r15,%rdi
	call _invalidate
L557:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_overwrite:
L596:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L597:
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
	jz L599
L610:
	cmpl $1,(%r13,%r12)
	jnz L599
L606:
	cmpq $0,24(%r13,%r12)
	jnz L599
L602:
	testl $66558,8(%r13,%rbx)
	jz L599
L618:
	cmpl $1,(%r13,%rbx)
	jnz L599
L614:
	cmpq $0,24(%r13,%rbx)
	jnz L599
L601:
	andl $131071,%edi
	call _t_size
	shll $3,%eax
	movq 8(%r15),%rdi
	movq 8(%r14),%rcx
	subl %ecx,%edi
	shll $3,%edi
	movl %eax,%ecx
	movq $-1,%rsi
	shlq %cl,%rsi
	notq %rsi
	movl %edi,%ecx
	movq %rsi,%rdx
	shlq %cl,%rdx
	notq %rdx
	andq 16(%r13,%rbx),%rdx
	movq %rdx,-8(%rbp)
	movq 16(%r13,%r12),%rax
	andq %rsi,%rax
	movl %edi,%ecx
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
	jmp L598
L599:
	movl $-1,%eax
L598:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_store:
L624:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L625:
	movq %rdi,%r15
	movl %esi,%ebx
	movq 16(%r15),%rcx
	movslq %ebx,%rax
	movq %rax,-40(%rbp)
	movq -40(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-48(%rbp)
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
	jz L628
L627:
	xorl %eax,%eax
	jmp L629
L628:
	movq 16(%r15),%rcx
	movq -40(%rbp),%rax
	leaq (%rcx,%rax,8),%rax
L629:
	movq %rax,-8(%rbp)
	xorl %r14d,%r14d
L630:
	cmpl 708(%r15),%r14d
	jge L633
L631:
	movq 712(%r15),%r13
	movslq %r14d,%r12
	shlq $5,%r12
	leaq -32(%rbp),%rsi
	leaq (%r13,%r12),%rdi
	call _overlaps
	cmpl $2,%eax
	jz L638
L682:
	cmpl $3,%eax
	jz L638
L683:
	leaq (%r13,%r12),%rsi
	leaq -32(%rbp),%rdi
	call _overlaps
	cmpl $3,%eax
	jz L647
L686:
	cmpl $1,%eax
	jz L642
	jnz L632
L647:
	leaq (%r13,%r12),%rdx
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _overwrite
	movl %eax,(%r13,%r12)
	cmpl $-1,%eax
	jz L642
L649:
	cmpq $0,24(%r13,%r12)
	jz L632
L655:
	movq -48(%rbp),%rax
	testl $1,4(%rax)
	jnz L632
L656:
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
	jmp L632
L638:
	movq 24(%r13,%r12),%rax
	testq %rax,%rax
	jz L642
L639:
	movq $_nop_insn,(%rax)
	orl $264,_opt_request(%rip)
L642:
	movl $32,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 704(%r15),%rdi
	call _vector_delete
	decl %r14d
L632:
	incl %r14d
	jmp L630
L633:
	movq 16(%r15),%rax
	movslq %ebx,%rbx
	cmpq $_nop_insn,(%rax,%rbx,8)
	jz L626
L678:
	leaq -32(%rbp),%rsi
	movq %r15,%rdi
	call _new_reload
L626:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_meet0:
L689:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L690:
	movq %rdi,%r15
	movq %rsi,-8(%rbp)
	xorl %ebx,%ebx
	movl $0,-24(%rbp)
L692:
	movl 660(%r15),%esi
	cmpl %esi,%ebx
	jge L697
L695:
	movq -8(%rbp),%rcx
	movl -24(%rbp),%eax
	cmpl 660(%rcx),%eax
	jge L697
L696:
	movq 664(%r15),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-16(%rbp)
	movq -8(%rbp),%rcx
	movq 664(%rcx),%rcx
	movslq -24(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movl 4(%rax),%ecx
	movq -16(%rbp),%rax
	cmpl 4(%rax),%ecx
	jl L699
	jz L703
L702:
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 656(%r15),%rdi
	call _vector_delete
	jmp L692
L703:
	incl %ebx
	jmp L692
L699:
	incl -24(%rbp)
	jmp L692
L697:
	cmpl 656(%r15),%ebx
	jg L709
L708:
	movl %ebx,660(%r15)
	jmp L710
L709:
	subl %esi,%ebx
	movl $8,%ecx
	movl %ebx,%edx
	leaq 656(%r15),%rdi
	call _vector_insert
L710:
	xorl %ebx,%ebx
	movl $0,-32(%rbp)
L711:
	movl 684(%r15),%esi
	cmpl %esi,%ebx
	jge L716
L714:
	movq -8(%rbp),%rcx
	movl -32(%rbp),%eax
	cmpl 684(%rcx),%eax
	jge L716
L715:
	movq 688(%r15),%rdi
	movslq %ebx,%rsi
	movq -8(%rbp),%rcx
	movq 688(%rcx),%rdx
	movslq -32(%rbp),%rcx
	movl (%rdx,%rcx,8),%eax
	cmpl (%rdi,%rsi,8),%eax
	jb L718
	ja L725
L724:
	movl 4(%rdi,%rsi,8),%eax
	cmpl 4(%rdx,%rcx,8),%eax
	jz L726
L725:
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 680(%r15),%rdi
	call _vector_delete
	jmp L711
L726:
	incl %ebx
	jmp L711
L718:
	incl -32(%rbp)
	jmp L711
L716:
	cmpl 680(%r15),%ebx
	jg L732
L731:
	movl %ebx,684(%r15)
	jmp L733
L732:
	subl %esi,%ebx
	movl $8,%ecx
	movl %ebx,%edx
	leaq 680(%r15),%rdi
	call _vector_insert
L733:
	xorl %ebx,%ebx
	xorl %r14d,%r14d
L734:
	movl 708(%r15),%esi
	cmpl %esi,%ebx
	jge L739
L737:
	movq -8(%rbp),%rcx
	cmpl 708(%rcx),%r14d
	jge L739
L738:
	movq 712(%r15),%rdi
	movq %rdi,-40(%rbp)
	movslq %ebx,%r13
	shlq $5,%r13
	movq -8(%rbp),%rcx
	movq 712(%rcx),%rdi
	movq %rdi,-48(%rbp)
	movslq %r14d,%r12
	shlq $5,%r12
	movq -40(%rbp),%rdi
	leaq (%rdi,%r13),%rsi
	movq -48(%rbp),%rdi
	addq %r12,%rdi
	call _reload_precedes
	testl %eax,%eax
	jz L742
L741:
	incl %r14d
	jmp L734
L742:
	movq -48(%rbp),%rdi
	leaq (%rdi,%r12),%rsi
	movq -40(%rbp),%rdi
	addq %r13,%rdi
	call _reload_precedes
	testl %eax,%eax
	jnz L748
L747:
	movq -40(%rbp),%rdi
	movl (%rdi,%r13),%eax
	movq -48(%rbp),%rdi
	cmpl (%rdi,%r12),%eax
	jz L749
L748:
	movl $32,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 704(%r15),%rdi
	call _vector_delete
	jmp L734
L749:
	incl %ebx
	jmp L734
L739:
	cmpl 704(%r15),%ebx
	jg L755
L754:
	movl %ebx,708(%r15)
	jmp L691
L755:
	subl %esi,%ebx
	movl $32,%ecx
	movl %ebx,%edx
	leaq 704(%r15),%rdi
	call _vector_insert
L691:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_inherit0:
L757:
	pushq %rbx
	pushq %r12
	pushq %r13
L758:
	movq %rdi,%r13
	movq %r13,%rsi
	movq %r13,%rdi
	call _is_pred
	testl %eax,%eax
	jnz L759
L760:
	xorl %r12d,%r12d
L763:
	cmpl 36(%r13),%r12d
	jge L759
L764:
	movq 40(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	testl %r12d,%r12d
	jnz L768
L770:
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
	jmp L769
L768:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _meet0
L769:
	incl %r12d
	jmp L763
L759:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L835:
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
.align 4
L839:
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
L840:
	.short L791-_dvn0
	.short L810-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L812-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L791-_dvn0
	.short L814-_dvn0

_dvn0:
L779:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L780:
	movq %rdi,%r13
	movq %r13,%rdi
	call _inherit0
	xorl %esi,%esi
	movq %r13,%rdi
	call _invalidate
	xorl %r12d,%r12d
L782:
	cmpl 12(%r13),%r12d
	jge L781
L786:
	movq 16(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	testq %rbx,%rbx
	jz L781
L783:
	movl (%rbx),%ecx
	cmpl $-1275068398,%ecx
	jl L832
L834:
	cmpl $-1275068393,%ecx
	jg L832
L831:
	addl $1275068398,%ecx
	movzwl L835(,%rcx,2),%eax
	addl $_dvn0,%eax
	jmp *%rax
L832:
	xorl %eax,%eax
L836:
	cmpl L839(,%rax,4),%ecx
	jz L837
L838:
	incl %eax
	cmpl $13,%eax
	jb L836
	jae L790
L837:
	movzwl L840(,%rax,2),%eax
	addl $_dvn0,%eax
	jmp *%rax
L814:
	movl %r12d,%esi
	movq %r13,%rdi
	call _store
	jmp L784
L812:
	movl %r12d,%esi
	movq %r13,%rdi
	call _load
	jmp L784
L810:
	movl $1,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _label
	movl 16(%rbx),%esi
	movl 52(%rbx),%edx
	movq %r13,%rdi
	call _assoc
	jmp L784
L791:
	movl $1,%r14d
L817:
	movl (%rbx),%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,%r14d
	jge L820
L818:
	movl %r14d,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _label
	incl %r14d
	jmp L817
L820:
	cmpl $3,%eax
	jnz L823
L824:
	movl 52(%rbx),%eax
	cmpl 84(%rbx),%eax
	jge L823
L821:
	movq %rbx,%rdi
	call _commute_insn
L823:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _match
	movl %eax,%edx
	cmpl $-1,%edx
	jnz L829
L828:
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
	movq %r13,%rdi
	call _assoc
	jmp L784
L829:
	xorl %ecx,%ecx
	movl %r12d,%esi
	movq %r13,%rdi
	call _replace
	jmp L784
L790:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _invalidate
L784:
	incl %r12d
	jmp L782
L781:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_opt_lir_dvn:
L841:
	pushq %rbx
L844:
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
L853:
	testq %rax,%rax
	jz L856
L857:
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
	jmp L853
L856:
	xorl %edi,%edi
	call _sequence_blocks
	movq _all_blocks(%rip),%rbx
L866:
	testq %rbx,%rbx
	jz L870
L867:
	movq %rbx,%rdi
	call _dvn0
	movq 112(%rbx),%rbx
	jmp L866
L870:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
	orl $2,_opt_request(%rip)
L843:
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
