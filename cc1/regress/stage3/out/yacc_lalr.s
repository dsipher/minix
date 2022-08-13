.text

_set_state_table:
L1:
L2:
	movl _nstates(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_state_table(%rip)
	movq _first_state(%rip),%rcx
L4:
	testq %rcx,%rcx
	jz L3
L5:
	movswq 16(%rcx),%rax
	movq _state_table(%rip),%rdx
	movq %rcx,(%rdx,%rax,8)
	movq (%rcx),%rcx
	jmp L4
L3:
	ret 


_set_accessing_symbol:
L8:
L9:
	movl _nstates(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_accessing_symbol(%rip)
	movq _first_state(%rip),%rdx
L11:
	testq %rdx,%rdx
	jz L10
L12:
	movw 18(%rdx),%cx
	movswq 16(%rdx),%rax
	movq _accessing_symbol(%rip),%rsi
	movw %cx,(%rsi,%rax,2)
	movq (%rdx),%rdx
	jmp L11
L10:
	ret 


_set_shift_table:
L15:
L16:
	movl _nstates(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_shift_table(%rip)
	movq _first_shift(%rip),%rcx
L18:
	testq %rcx,%rcx
	jz L17
L19:
	movswq 8(%rcx),%rax
	movq _shift_table(%rip),%rdx
	movq %rcx,(%rdx,%rax,8)
	movq (%rcx),%rcx
	jmp L18
L17:
	ret 


_set_reduction_table:
L22:
L23:
	movl _nstates(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_reduction_table(%rip)
	movq _first_reduction(%rip),%rcx
L25:
	testq %rcx,%rcx
	jz L24
L26:
	movswq 8(%rcx),%rax
	movq _reduction_table(%rip),%rdx
	movq %rcx,(%rdx,%rax,8)
	movq (%rcx),%rcx
	jmp L25
L24:
	ret 


_set_maxrhs:
L29:
L30:
	movslq _nitems(%rip),%rcx
	movq _ritem(%rip),%rax
	xorl %esi,%esi
	xorl %edx,%edx
	leaq (%rax,%rcx,2),%rcx
L32:
	cmpq %rax,%rcx
	jbe L35
L33:
	cmpw $0,(%rax)
	jl L37
L36:
	incl %esi
	jmp L38
L37:
	cmpl %edx,%esi
	cmovgl %esi,%edx
	xorl %esi,%esi
L38:
	addq $2,%rax
	jmp L32
L35:
	movl %edx,_maxrhs(%rip)
L31:
	ret 


_initialize_LA:
L42:
	pushq %rbx
L43:
	movl _nstates(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movq %rax,_lookaheads(%rip)
	xorl %ebx,%ebx
	xorl %edx,%edx
L45:
	movl _nstates(%rip),%ecx
	movq _lookaheads(%rip),%rax
	cmpl %edx,%ecx
	jle L48
L46:
	movslq %edx,%rcx
	movw %bx,(%rax,%rcx,2)
	movq _reduction_table(%rip),%rax
	movq (%rax,%rcx,8),%rax
	testq %rax,%rax
	jz L51
L49:
	movswl 10(%rax),%eax
	addl %eax,%ebx
L51:
	incl %edx
	jmp L45
L48:
	movslq %ecx,%rcx
	movw %bx,(%rax,%rcx,2)
	movl _tokensetsize(%rip),%edi
	imull %ebx,%edi
	shll $2,%edi
	call _allocate
	movq %rax,_LA(%rip)
	movl %ebx,%edi
	shll $1,%edi
	call _allocate
	movq %rax,_LAruleno(%rip)
	shll $3,%ebx
	movl %ebx,%edi
	call _allocate
	movq %rax,_lookback(%rip)
	xorl %r9d,%r9d
	xorl %r8d,%r8d
L52:
	cmpl %r8d,_nstates(%rip)
	jle L44
L53:
	movslq %r8d,%rax
	movq _reduction_table(%rip),%rcx
	movq (%rcx,%rax,8),%rsi
	testq %rsi,%rsi
	jz L58
L56:
	xorl %edx,%edx
L59:
	movswl 10(%rsi),%eax
	cmpl %eax,%edx
	jge L58
L60:
	movslq %edx,%rax
	movw 12(%rsi,%rax,2),%cx
	movslq %r9d,%rax
	movq _LAruleno(%rip),%rdi
	movw %cx,(%rdi,%rax,2)
	incl %r9d
	incl %edx
	jmp L59
L58:
	incl %r8d
	jmp L52
L44:
	popq %rbx
	ret 


_set_goto_map:
L63:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L64:
	movl _nvars(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movslq _ntokens(%rip),%rcx
	shlq $1,%rcx
	subq %rcx,%rax
	movq %rax,_goto_map(%rip)
	movl _nvars(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movslq _ntokens(%rip),%rcx
	shlq $1,%rcx
	movq %rax,%r13
	subq %rcx,%r13
	movl $0,_ngotos(%rip)
	movq _first_shift(%rip),%r12
L66:
	testq %r12,%r12
	jz L69
L67:
	movswl 10(%r12),%ebx
	decl %ebx
L70:
	cmpl $0,%ebx
	jl L73
L71:
	movslq %ebx,%rax
	movswq 12(%r12,%rax,2),%rcx
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%rcx,2),%r14d
	cmpl _start_symbol(%rip),%r14d
	jl L73
L76:
	cmpl $32767,_ngotos(%rip)
	jnz L80
L78:
	movl $L81,%edi
	call _fatal
L80:
	incl _ngotos(%rip)
	movslq %r14d,%r14
	movq _goto_map(%rip),%rcx
	incw (%rcx,%r14,2)
	decl %ebx
	jmp L70
L73:
	movq (%r12),%r12
	jmp L66
L69:
	xorl %ecx,%ecx
	movl _ntokens(%rip),%edx
L82:
	cmpl _nsyms(%rip),%edx
	jge L85
L83:
	movslq %edx,%rax
	movw %cx,(%r13,%rax,2)
	movq _goto_map(%rip),%rsi
	movswl (%rsi,%rax,2),%eax
	addl %eax,%ecx
	incl %edx
	jmp L82
L85:
	movl _ntokens(%rip),%esi
L86:
	movl _nsyms(%rip),%ecx
	movq _goto_map(%rip),%rax
	cmpl %ecx,%esi
	jge L89
L87:
	movslq %esi,%rdx
	movw (%r13,%rdx,2),%cx
	movw %cx,(%rax,%rdx,2)
	incl %esi
	jmp L86
L89:
	movl _ngotos(%rip),%edx
	movslq %ecx,%rcx
	movw %dx,(%rax,%rcx,2)
	movl _ngotos(%rip),%ecx
	movslq _nsyms(%rip),%rax
	movw %cx,(%r13,%rax,2)
	movl _ngotos(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_from_state(%rip)
	movl _ngotos(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_to_state(%rip)
	movq _first_shift(%rip),%r9
L90:
	testq %r9,%r9
	jz L93
L91:
	movswl 8(%r9),%edi
	movswl 10(%r9),%r8d
	decl %r8d
L94:
	cmpl $0,%r8d
	jl L97
L95:
	movslq %r8d,%rax
	movswl 12(%r9,%rax,2),%esi
	movslq %esi,%rax
	movq _accessing_symbol(%rip),%rcx
	movswl (%rcx,%rax,2),%edx
	cmpl %edx,_start_symbol(%rip)
	jg L97
L100:
	movslq %edx,%rdx
	movw (%r13,%rdx,2),%ax
	leaw 1(%rax),%cx
	movw %cx,(%r13,%rdx,2)
	movswl %ax,%eax
	movslq %eax,%rax
	movq _from_state(%rip),%rcx
	movw %di,(%rcx,%rax,2)
	movq _to_state(%rip),%rcx
	movw %si,(%rcx,%rax,2)
	decl %r8d
	jmp L94
L97:
	movq (%r9),%r9
	jmp L90
L93:
	movslq _ntokens(%rip),%rax
	leaq (%r13,%rax,2),%rdi
	call _free
L65:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_map_goto:
L102:
	pushq %rbx
	pushq %r12
	pushq %r13
L103:
	movl %edi,%r13d
	movslq %esi,%rcx
	movq _goto_map(%rip),%rax
	movswl (%rax,%rcx,2),%r12d
	incl %esi
	movslq %esi,%rsi
	movswl (%rax,%rsi,2),%ebx
L105:
	cmpl %ebx,%r12d
	jle L111
L109:
	movl $245,%edx
	movl $L113,%esi
	movl $L112,%edi
	call ___assert
L111:
	leal (%rbx,%r12),%eax
	sarl $1,%eax
	movslq %eax,%rdx
	movq _from_state(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,%r13d
	jl L119
	jz L104
L118:
	leal 1(%rax),%r12d
	jmp L105
L119:
	decl %eax
	movl %eax,%ebx
	jmp L105
L104:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_traverse:
L121:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L122:
	movl %edi,%r15d
	movl _top(%rip),%ecx
	incl %ecx
	movl %ecx,_top(%rip)
	movslq %ecx,%rcx
	movq _VERTICES(%rip),%rax
	movw %r15w,(%rax,%rcx,2)
	movl _top(%rip),%eax
	movl %eax,-4(%rbp)
	movl -4(%rbp),%eax
	movslq %r15d,%rdx
	movq _INDEX(%rip),%rcx
	movw %ax,(%rcx,%rdx,2)
	movl _tokensetsize(%rip),%r14d
	movl %r15d,%ecx
	imull %r14d,%ecx
	movslq %ecx,%rcx
	movq _F(%rip),%rax
	movslq %r14d,%r14
	leaq (%rax,%rcx,4),%rax
	movq %rax,-16(%rbp)
	shlq $2,%r14
	addq -16(%rbp),%r14
	movq _R(%rip),%rax
	movq (%rax,%rdx,8),%r13
	testq %r13,%r13
	jz L126
L127:
	movswl (%r13),%r12d
	addq $2,%r13
	cmpl $0,%r12d
	jl L126
L128:
	movslq %r12d,%rbx
	movq _INDEX(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jnz L132
L130:
	movl %r12d,%edi
	call _traverse
L132:
	movslq %r15d,%rdx
	movq _INDEX(%rip),%rsi
	movw (%rsi,%rdx,2),%cx
	movw (%rsi,%rbx,2),%ax
	cmpw %ax,%cx
	jle L135
L133:
	movw %ax,(%rsi,%rdx,2)
L135:
	movq -16(%rbp),%rdi
	movl _tokensetsize(%rip),%eax
	imull %r12d,%eax
	movslq %eax,%rax
	movq _F(%rip),%rcx
	leaq (%rcx,%rax,4),%rsi
L136:
	cmpq %rdi,%r14
	jbe L127
L137:
	movl (%rsi),%edx
	addq $4,%rsi
	movq %rdi,%rcx
	movl (%rdi),%eax
	addq $4,%rdi
	orl %edx,%eax
	movl %eax,(%rcx)
	jmp L136
L126:
	movslq %r15d,%rax
	movq _INDEX(%rip),%rcx
	movswl (%rcx,%rax,2),%eax
	cmpl %eax,-4(%rbp)
	jnz L123
L142:
	movl _top(%rip),%eax
	leal -1(%rax),%ecx
	movl %ecx,_top(%rip)
	movslq %eax,%rax
	movq _VERTICES(%rip),%rcx
	movswl (%rcx,%rax,2),%edx
	movl _infinity(%rip),%ecx
	movslq %edx,%rax
	movq _INDEX(%rip),%rsi
	movw %cx,(%rsi,%rax,2)
	cmpl %edx,%r15d
	jz L123
L148:
	movq -16(%rbp),%rsi
	movl _tokensetsize(%rip),%eax
	imull %edx,%eax
	movslq %eax,%rax
	movq _F(%rip),%rcx
	leaq (%rcx,%rax,4),%rcx
L150:
	cmpq %rsi,%r14
	jbe L142
L151:
	movl (%rsi),%eax
	addq $4,%rsi
	movl %eax,(%rcx)
	addq $4,%rcx
	jmp L150
L123:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_digraph:
L153:
	pushq %rbx
L154:
	movl _ngotos(%rip),%eax
	movq %rdi,%rbx
	leal 2(%rax),%ecx
	movl %ecx,_infinity(%rip)
	incl %eax
	shll $1,%eax
	movl %eax,%edi
	call _allocate
	movq %rax,_INDEX(%rip)
	movl _ngotos(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movq %rax,_VERTICES(%rip)
	movl $0,_top(%rip)
	movq %rbx,_R(%rip)
	xorl %ecx,%ecx
L156:
	cmpl %ecx,_ngotos(%rip)
	jle L159
L157:
	movslq %ecx,%rax
	movq _INDEX(%rip),%rdx
	movw $0,(%rdx,%rax,2)
	incl %ecx
	jmp L156
L159:
	xorl %ebx,%ebx
L160:
	movl _ngotos(%rip),%eax
	movq _INDEX(%rip),%rdi
	cmpl %ebx,%eax
	jle L163
L161:
	movslq %ebx,%rax
	cmpw $0,(%rdi,%rax,2)
	jnz L166
L167:
	movq _R(%rip),%rcx
	cmpq $0,(%rcx,%rax,8)
	jz L166
L168:
	movl %ebx,%edi
	call _traverse
L166:
	incl %ebx
	jmp L160
L163:
	call _free
	movq _VERTICES(%rip),%rdi
	call _free
L155:
	popq %rbx
	ret 


_initialize_F:
L171:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L172:
	movl _ngotos(%rip),%eax
	movl _tokensetsize(%rip),%edi
	imull %eax,%edi
	shll $2,%edi
	call _allocate
	movq %rax,_F(%rip)
	movl _ngotos(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,-8(%rbp)
	movl _ngotos(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movq %rax,-24(%rbp)
	xorl %ebx,%ebx
	movq _F(%rip),%rax
	movq %rax,-16(%rbp)
	xorl %r15d,%r15d
L174:
	cmpl %r15d,_ngotos(%rip)
	jle L177
L175:
	movslq %r15d,%rcx
	movq _to_state(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	movl %eax,-28(%rbp)
	movslq -28(%rbp),%rcx
	movq _shift_table(%rip),%rax
	movq (%rax,%rcx,8),%r14
	testq %r14,%r14
	jz L180
L178:
	movswl 10(%r14),%r13d
	xorl %r12d,%r12d
L181:
	cmpl %r12d,%r13d
	jle L189
L182:
	movslq %r12d,%rax
	movswq 12(%r14,%rax,2),%rcx
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%rcx,2),%edx
	cmpl _start_symbol(%rip),%edx
	jl L187
L189:
	cmpl %r12d,%r13d
	jle L192
L190:
	movslq %r12d,%rax
	movswq 12(%r14,%rax,2),%rax
	movq _accessing_symbol(%rip),%rcx
	movswl (%rcx,%rax,2),%esi
	movslq %esi,%rcx
	movq _nullable(%rip),%rax
	cmpb $0,(%rcx,%rax)
	jz L195
L193:
	movl -28(%rbp),%edi
	call _map_goto
	movl %ebx,%edx
	incl %ebx
	movslq %edx,%rdx
	movq -24(%rbp),%rcx
	movw %ax,(%rcx,%rdx,2)
L195:
	incl %r12d
	jmp L189
L192:
	testl %ebx,%ebx
	jz L180
L196:
	leal 1(%rbx),%edi
	shll $1,%edi
	call _allocate
	movslq %r15d,%rdx
	movq -8(%rbp),%rcx
	movq %rax,(%rcx,%rdx,8)
	xorl %esi,%esi
L199:
	cmpl %esi,%ebx
	jle L202
L200:
	movslq %esi,%rdx
	movq -24(%rbp),%rcx
	movw (%rcx,%rdx,2),%cx
	movw %cx,(%rax,%rdx,2)
	incl %esi
	jmp L199
L202:
	movslq %ebx,%rbx
	movw $-1,(%rax,%rbx,2)
	xorl %ebx,%ebx
L180:
	movslq _tokensetsize(%rip),%rcx
	movq -16(%rbp),%rax
	leaq (%rax,%rcx,4),%rax
	movq %rax,-16(%rbp)
	incl %r15d
	jmp L174
L187:
	movb %dl,%cl
	andb $31,%cl
	movl $1,%esi
	shll %cl,%esi
	sarl $5,%edx
	movslq %edx,%rdx
	movq -16(%rbp),%rax
	orl %esi,(%rax,%rdx,4)
	incl %r12d
	jmp L181
L177:
	movq _F(%rip),%rax
	orl $1,(%rax)
	movq -8(%rbp),%rdi
	call _digraph
	xorl %ebx,%ebx
L203:
	cmpl %ebx,_ngotos(%rip)
	jle L206
L204:
	movslq %ebx,%rax
	movq -8(%rbp),%rcx
	movq (%rcx,%rax,8),%rdi
	testq %rdi,%rdi
	jz L209
L207:
	call _free
L209:
	incl %ebx
	jmp L203
L206:
	movq -8(%rbp),%rdi
	call _free
	movq -24(%rbp),%rdi
	call _free
L173:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_add_lookback_edge:
L210:
	pushq %rbx
	pushq %r12
L211:
	movl %edx,%ebx
	movslq %edi,%rcx
	movq _lookaheads(%rip),%rax
	movswl (%rax,%rcx,2),%r12d
	incl %edi
	movslq %edi,%rdi
	movswl (%rax,%rdi,2),%edi
	xorl %edx,%edx
L216:
	cmpl %edi,%r12d
	jge L215
L214:
	movslq %r12d,%rcx
	movq _LAruleno(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	cmpl %eax,%esi
	jz L220
L221:
	incl %r12d
	testl %edx,%edx
	jz L216
	jnz L215
L220:
	movl $1,%edx
L215:
	testl %edx,%edx
	jnz L225
L223:
	movl $435,%edx
	movl $L113,%esi
	movl $L226,%edi
	call ___assert
L225:
	movl $16,%edi
	call _allocate
	movslq %r12d,%r12
	movq _lookback(%rip),%rcx
	movq (%rcx,%r12,8),%rcx
	movq %rcx,(%rax)
	movw %bx,8(%rax)
	movq _lookback(%rip),%rcx
	movq %rax,(%rcx,%r12,8)
L212:
	popq %r12
	popq %rbx
	ret 


_build_relations:
L227:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L228:
	movl _ngotos(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_includes(%rip)
	movl _ngotos(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movq %rax,-24(%rbp)
	movl _maxrhs(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movq %rax,-40(%rbp)
	xorl %eax,%eax
L277:
	movl %eax,-28(%rbp)
	movl _ngotos(%rip),%esi
	xorl %ebx,%ebx
	cmpl -28(%rbp),%esi
	jle L233
L231:
	movslq -28(%rbp),%rdx
	movq _from_state(%rip),%rax
	movswl (%rax,%rdx,2),%ecx
	movl %ecx,-12(%rbp)
	movq _to_state(%rip),%rax
	movswq (%rax,%rdx,2),%rcx
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%rcx,2),%ecx
	movslq %ecx,%rcx
	movq _derives(%rip),%rax
	movq (%rax,%rcx,8),%r15
L234:
	cmpw $0,(%r15)
	jl L237
L235:
	movl $1,%r14d
	movl -12(%rbp),%ecx
	movq -40(%rbp),%rax
	movw %cx,(%rax)
	movswq (%r15),%rcx
	movq _rrhs(%rip),%rax
	movl -12(%rbp),%edi
	movswq (%rax,%rcx,2),%rcx
	movq _ritem(%rip),%rax
	leaq (%rax,%rcx,2),%r13
L238:
	movw (%r13),%ax
	cmpw $0,%ax
	jl L241
L239:
	movswl %ax,%eax
	movslq %edi,%rdx
	movq _shift_table(%rip),%rcx
	movq (%rcx,%rdx,8),%r8
	movswl 10(%r8),%esi
	xorl %edx,%edx
L242:
	cmpl %edx,%esi
	jle L245
L243:
	movslq %edx,%rcx
	movswl 12(%r8,%rcx,2),%ecx
	movl %ecx,%edi
	movslq %ecx,%rcx
	movq _accessing_symbol(%rip),%r9
	movswl (%r9,%rcx,2),%ecx
	cmpl %ecx,%eax
	jz L245
L248:
	incl %edx
	jmp L242
L245:
	movl %r14d,%ecx
	incl %r14d
	movslq %ecx,%rcx
	movq -40(%rbp),%rax
	movw %di,(%rax,%rcx,2)
	addq $2,%r13
	jmp L238
L241:
	movswl (%r15),%esi
	movl -28(%rbp),%edx
	call _add_lookback_edge
	decl %r14d
L251:
	movl $1,%r12d
	addq $-2,%r13
	movswl (%r13),%esi
	cmpl _start_symbol(%rip),%esi
	jl L250
L253:
	decl %r14d
	movslq %r14d,%rcx
	movq -40(%rbp),%rax
	movswl (%rax,%rcx,2),%edi
	call _map_goto
	movl %ebx,%edx
	incl %ebx
	movslq %edx,%rdx
	movq -24(%rbp),%rcx
	movw %ax,(%rcx,%rdx,2)
	movswq (%r13),%rcx
	movq _nullable(%rip),%rax
	cmpb $0,(%rcx,%rax)
	jz L250
L259:
	cmpl $0,%r14d
	jg L251
L250:
	testl %r12d,%r12d
	jz L251
L252:
	addq $2,%r15
	jmp L234
L237:
	testl %ebx,%ebx
	jz L265
L263:
	leal 1(%rbx),%edi
	shll $1,%edi
	call _allocate
	movslq -28(%rbp),%rcx
	movq _includes(%rip),%rdx
	movq %rax,(%rdx,%rcx,8)
	xorl %esi,%esi
L266:
	cmpl %esi,%ebx
	jle L269
L267:
	movslq %esi,%rdx
	movq -24(%rbp),%rcx
	movw (%rcx,%rdx,2),%cx
	movw %cx,(%rax,%rdx,2)
	incl %esi
	jmp L266
L269:
	movslq %ebx,%rbx
	movw $-1,(%rax,%rbx,2)
L265:
	movl -28(%rbp),%eax
	incl %eax
	jmp L277
L233:
	movq _includes(%rip),%rdi
	call _transpose
	movq %rax,-8(%rbp)
L270:
	movl _ngotos(%rip),%eax
	movq _includes(%rip),%rdi
	cmpl %ebx,%eax
	jle L273
L271:
	movslq %ebx,%rax
	movq (%rdi,%rax,8),%rdi
	testq %rdi,%rdi
	jz L276
L274:
	call _free
L276:
	incl %ebx
	jmp L270
L273:
	call _free
	movq -8(%rbp),%rax
	movq %rax,_includes(%rip)
	movq -24(%rbp),%rdi
	call _free
	movq -40(%rbp),%rdi
	call _free
L229:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_transpose:
L278:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L279:
	movq %rdi,-16(%rbp)
	movl %esi,-20(%rbp)
	movl -20(%rbp),%edi
	shll $1,%edi
	call _allocate
	movq %rax,%r15
	xorl %edx,%edx
L281:
	cmpl %edx,-20(%rbp)
	jle L284
L282:
	movslq %edx,%rcx
	movq -16(%rbp),%rax
	movq (%rax,%rcx,8),%rcx
	testq %rcx,%rcx
	jz L287
L288:
	movw (%rcx),%ax
	cmpw $0,%ax
	jl L287
L289:
	movswq %ax,%rax
	addq $2,%rcx
	incw (%r15,%rax,2)
	jmp L288
L287:
	incl %edx
	jmp L281
L284:
	movl -20(%rbp),%ebx
	shll $3,%ebx
	movq %rbx,%rdi
	call _allocate
	movq %rax,-8(%rbp)
	movq %rbx,%rdi
	call _allocate
	movq %rax,%r13
	xorl %r14d,%r14d
L291:
	cmpl %r14d,-20(%rbp)
	jle L294
L292:
	movslq %r14d,%r12
	movswl (%r15,%r12,2),%ebx
	cmpl $0,%ebx
	jle L297
L295:
	leal 1(%rbx),%edi
	shll $1,%edi
	call _allocate
	movq -8(%rbp),%rcx
	movq %rax,(%rcx,%r12,8)
	movq %rax,(%r13,%r12,8)
	movslq %ebx,%rbx
	movw $-1,(%rax,%rbx,2)
L297:
	incl %r14d
	jmp L291
L294:
	movq %r15,%rdi
	call _free
	xorl %edi,%edi
L298:
	cmpl %edi,-20(%rbp)
	jle L301
L299:
	movslq %edi,%rcx
	movq -16(%rbp),%rax
	movq (%rax,%rcx,8),%rsi
	testq %rsi,%rsi
	jz L304
L305:
	movw (%rsi),%dx
	cmpw $0,%dx
	jl L304
L306:
	movswq %dx,%rdx
	addq $2,%rsi
	movq (%r13,%rdx,8),%rcx
	leaq 2(%rcx),%rax
	movq %rax,(%r13,%rdx,8)
	movw %di,(%rcx)
	jmp L305
L304:
	incl %edi
	jmp L298
L301:
	movq %r13,%rdi
	call _free
	movq -8(%rbp),%rax
L280:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_compute_FOLLOWS:
L309:
L310:
	movq _includes(%rip),%rdi
	call _digraph
L311:
	ret 


_compute_lookaheads:
L312:
	pushq %rbx
	pushq %r12
	pushq %r13
L313:
	movq _LA(%rip),%rdx
	movslq _nstates(%rip),%rcx
	movq _lookaheads(%rip),%rax
	movswl (%rax,%rcx,2),%ebx
	xorl %ecx,%ecx
L315:
	cmpl %ecx,%ebx
	jle L318
L316:
	movslq _tokensetsize(%rip),%rax
	leaq (%rdx,%rax,4),%rax
	movslq %ecx,%rdi
	movq _lookback(%rip),%rsi
	movq (%rsi,%rdi,8),%r11
L319:
	testq %r11,%r11
	jz L322
L320:
	movq %rdx,%r10
	movswl 8(%r11),%esi
	movl _tokensetsize(%rip),%edi
	imull %esi,%edi
	movslq %edi,%rdi
	movq _F(%rip),%rsi
	leaq (%rsi,%rdi,4),%r9
L323:
	cmpq %r10,%rax
	jbe L325
L324:
	movl (%r9),%r8d
	addq $4,%r9
	movq %r10,%rdi
	movl (%r10),%esi
	addq $4,%r10
	orl %r8d,%esi
	movl %esi,(%rdi)
	jmp L323
L325:
	movq (%r11),%r11
	jmp L319
L322:
	movq %rax,%rdx
	incl %ecx
	jmp L315
L318:
	xorl %r13d,%r13d
L326:
	movq _lookback(%rip),%rdi
	cmpl %r13d,%ebx
	jle L329
L327:
	movslq %r13d,%rax
	movq (%rdi,%rax,8),%rdi
L330:
	testq %rdi,%rdi
	jz L333
L331:
	movq (%rdi),%r12
	call _free
	movq %r12,%rdi
	jmp L330
L333:
	incl %r13d
	jmp L326
L329:
	call _free
	movq _F(%rip),%rdi
	call _free
L314:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_lalr:
L334:
L335:
	movl _ntokens(%rip),%eax
	movl $32,%ecx
	addl $31,%eax
	cltd 
	idivl %ecx
	movl %eax,_tokensetsize(%rip)
	call _set_state_table
	call _set_accessing_symbol
	call _set_shift_table
	call _set_reduction_table
	call _set_maxrhs
	call _initialize_LA
	call _set_goto_map
	call _initialize_F
	call _build_relations
	call _compute_FOLLOWS
	call _compute_lookaheads
L336:
	ret 

L226:
 .byte 102,111,117,110,100,0
L112:
 .byte 108,111,119,32,60,61,32,104
 .byte 105,103,104,0
L81:
 .byte 116,111,111,32,109,97,110,121
 .byte 32,103,111,116,111,115,0
L113:
 .byte 108,97,108,114,46,99,0
.globl _accessing_symbol
.comm _accessing_symbol, 8, 8
.globl _state_table
.comm _state_table, 8, 8
.globl _shift_table
.comm _shift_table, 8, 8
.globl _reduction_table
.comm _reduction_table, 8, 8
.globl _LA
.comm _LA, 8, 8
.globl _LAruleno
.comm _LAruleno, 8, 8
.globl _lookaheads
.comm _lookaheads, 8, 8
.globl _goto_map
.comm _goto_map, 8, 8
.globl _from_state
.comm _from_state, 8, 8
.globl _to_state
.comm _to_state, 8, 8
.globl _tokensetsize
.comm _tokensetsize, 4, 4
.local _infinity
.comm _infinity, 4, 4
.local _maxrhs
.comm _maxrhs, 4, 4
.local _ngotos
.comm _ngotos, 4, 4
.local _F
.comm _F, 8, 8
.local _includes
.comm _includes, 8, 8
.local _lookback
.comm _lookback, 8, 8
.local _R
.comm _R, 8, 8
.local _INDEX
.comm _INDEX, 8, 8
.local _VERTICES
.comm _VERTICES, 8, 8
.local _top
.comm _top, 4, 4

.globl _free
.globl _state_table
.globl _LAruleno
.globl _LA
.globl _nsyms
.globl ___assert
.globl _shift_table
.globl _ntokens
.globl _lalr
.globl _reduction_table
.globl _rrhs
.globl _first_state
.globl _goto_map
.globl _lookaheads
.globl _allocate
.globl _nitems
.globl _start_symbol
.globl _to_state
.globl _accessing_symbol
.globl _first_reduction
.globl _fatal
.globl _tokensetsize
.globl _first_shift
.globl _from_state
.globl _ritem
.globl _nvars
.globl _derives
.globl _nstates
.globl _nullable
