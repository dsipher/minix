.text

_allocate_itemsets:
L1:
	pushq %rbx
	pushq %r12
L2:
	xorl %r12d,%r12d
	movl _nsyms(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,%rbx
	movslq _nitems(%rip),%rax
	movq _ritem(%rip),%rdx
	leaq (%rdx,%rax,2),%rsi
L4:
	cmpq %rdx,%rsi
	jbe L7
L5:
	movswl (%rdx),%ecx
	cmpl $0,%ecx
	jl L10
L8:
	incl %r12d
	movslq %ecx,%rcx
	incw (%rbx,%rcx,2)
L10:
	addq $2,%rdx
	jmp L4
L7:
	movl _nsyms(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_kernel_base(%rip)
	shll $1,%r12d
	movl %r12d,%edi
	call _allocate
	movq %rax,_kernel_items(%rip)
	xorl %r8d,%r8d
	xorl %esi,%esi
	xorl %edx,%edx
L11:
	movl _nsyms(%rip),%edi
	cmpl %edx,%edi
	jle L14
L12:
	movslq %r8d,%rax
	movq _kernel_items(%rip),%rcx
	leaq (%rcx,%rax,2),%rcx
	movslq %edx,%rax
	movq _kernel_base(%rip),%rdi
	movq %rcx,(%rdi,%rax,8)
	movswl (%rbx,%rax,2),%eax
	addl %eax,%r8d
	cmpl %eax,%esi
	cmovll %eax,%esi
	incl %edx
	jmp L11
L14:
	movq %rbx,_shift_symbol(%rip)
	shll $3,%edi
	call _allocate
	movq %rax,_kernel_end(%rip)
L3:
	popq %r12
	popq %rbx
	ret 


_allocate_storage:
L18:
L19:
	call _allocate_itemsets
	movl _nsyms(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_shiftset(%rip)
	movl _nrules(%rip),%edi
	incl %edi
	shll $1,%edi
	call _allocate
	movq %rax,_redset(%rip)
	movl _nitems(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_state_set(%rip)
L20:
	ret 


_append_states:
L21:
	pushq %rbx
	pushq %r12
L22:
	movl $1,%r8d
L24:
	cmpl _nshifts(%rip),%r8d
	jge L27
L25:
	movslq %r8d,%rcx
	movq _shift_symbol(%rip),%rax
	movswl (%rax,%rcx,2),%esi
	movl %r8d,%eax
L28:
	cmpl $0,%eax
	jle L30
L31:
	movl %eax,%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _shift_symbol(%rip),%rdi
	movw (%rdi,%rcx,2),%dx
	movswl %dx,%ecx
	cmpl %ecx,%esi
	jge L30
L29:
	movslq %eax,%rcx
	movw %dx,(%rdi,%rcx,2)
	decl %eax
	jmp L28
L30:
	movslq %eax,%rax
	movq _shift_symbol(%rip),%rcx
	movw %si,(%rcx,%rax,2)
	incl %r8d
	jmp L24
L27:
	xorl %r12d,%r12d
L35:
	cmpl _nshifts(%rip),%r12d
	jge L23
L36:
	movslq %r12d,%rbx
	movq _shift_symbol(%rip),%rax
	movswl (%rax,%rbx,2),%edi
	call _get_state
	movq _shiftset(%rip),%rcx
	movw %ax,(%rcx,%rbx,2)
	incl %r12d
	jmp L35
L23:
	popq %r12
	popq %rbx
	ret 


_free_storage:
L39:
L40:
	movq _shift_symbol(%rip),%rdi
	call _free
	movq _redset(%rip),%rdi
	call _free
	movq _shiftset(%rip),%rdi
	call _free
	movq _kernel_base(%rip),%rdi
	call _free
	movq _kernel_end(%rip),%rdi
	call _free
	movq _kernel_items(%rip),%rdi
	call _free
	movq _state_set(%rip),%rdi
	call _free
L41:
	ret 


_initialize_states:
L42:
	pushq %rbx
	pushq %r12
	pushq %r13
L43:
	movslq _start_symbol(%rip),%rcx
	movq _derives(%rip),%rax
	movq (%rax,%rcx,8),%r12
	xorl %r13d,%r13d
L45:
	movslq %r13d,%rax
	cmpw $0,(%r12,%rax,2)
	jl L48
L47:
	incl %r13d
	jmp L45
L48:
	leal 24(,%r13,2),%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L52
L50:
	call _no_space
L52:
	movq $0,(%rbx)
	movq $0,8(%rbx)
	movw $0,16(%rbx)
	movw $0,18(%rbx)
	movw %r13w,20(%rbx)
	xorl %esi,%esi
L53:
	movslq %esi,%rdx
	movw (%r12,%rdx,2),%cx
	cmpw $0,%cx
	jl L56
L54:
	movswq %cx,%rcx
	movq _rrhs(%rip),%rax
	movw (%rax,%rcx,2),%ax
	movw %ax,22(%rbx,%rdx,2)
	incl %esi
	jmp L53
L56:
	movq %rbx,_this_state(%rip)
	movq %rbx,_last_state(%rip)
	movq %rbx,_first_state(%rip)
	movl $1,_nstates(%rip)
L44:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_new_itemsets:
L57:
L58:
	xorl %edx,%edx
L60:
	cmpl _nsyms(%rip),%edx
	jge L63
L61:
	movslq %edx,%rcx
	movq _kernel_end(%rip),%rax
	movq $0,(%rax,%rcx,8)
	incl %edx
	jmp L60
L63:
	xorl %r9d,%r9d
	movq _itemset(%rip),%r8
L64:
	cmpq _itemsetend(%rip),%r8
	jae L66
L65:
	movswl (%r8),%edi
	addq $2,%r8
	movslq %edi,%rcx
	movq _ritem(%rip),%rax
	movswl (%rax,%rcx,2),%esi
	cmpl $0,%esi
	jle L64
L67:
	movslq %esi,%rdx
	movq _kernel_end(%rip),%rax
	movq (%rax,%rdx,8),%rax
	testq %rax,%rax
	jnz L72
L70:
	movl %r9d,%ecx
	incl %r9d
	movslq %ecx,%rcx
	movq _shift_symbol(%rip),%rax
	movw %si,(%rax,%rcx,2)
	movq _kernel_base(%rip),%rax
	movq (%rax,%rdx,8),%rax
L72:
	incw %di
	movw %di,(%rax)
	addq $2,%rax
	movq _kernel_end(%rip),%rcx
	movq %rax,(%rcx,%rdx,8)
	jmp L64
L66:
	movl %r9d,_nshifts(%rip)
L59:
	ret 


_save_reductions:
L73:
	pushq %rbx
L74:
	xorl %ebx,%ebx
	movq _itemset(%rip),%rsi
L76:
	cmpq _itemsetend(%rip),%rsi
	jae L79
L77:
	movswq (%rsi),%rcx
	movq _ritem(%rip),%rax
	movswl (%rax,%rcx,2),%edx
	cmpl $0,%edx
	jge L82
L80:
	negw %dx
	movl %ebx,%ecx
	incl %ebx
	movslq %ecx,%rcx
	movq _redset(%rip),%rax
	movw %dx,(%rax,%rcx,2)
L82:
	addq $2,%rsi
	jmp L76
L79:
	testl %ebx,%ebx
	jz L75
L83:
	movl %ebx,%eax
	decl %eax
	leal 16(,%rax,2),%edi
	call _allocate
	movq _this_state(%rip),%rcx
	movw 16(%rcx),%cx
	movw %cx,8(%rax)
	movw %bx,10(%rax)
	movq _redset(%rip),%rdi
	leaq 12(%rax),%rsi
	movslq %ebx,%rbx
	leaq (%rdi,%rbx,2),%rdx
L86:
	cmpq %rdx,%rdi
	jae L88
L87:
	movw (%rdi),%cx
	addq $2,%rdi
	movw %cx,(%rsi)
	addq $2,%rsi
	jmp L86
L88:
	movq _last_reduction(%rip),%rcx
	testq %rcx,%rcx
	jz L90
L89:
	movq %rax,(%rcx)
	jmp L92
L90:
	movq %rax,_first_reduction(%rip)
L92:
	movq %rax,_last_reduction(%rip)
L75:
	popq %rbx
	ret 


_save_shifts:
L93:
L94:
	movl _nshifts(%rip),%eax
	decl %eax
	leal 16(,%rax,2),%edi
	call _allocate
	movq _this_state(%rip),%rcx
	movw 16(%rcx),%cx
	movw %cx,8(%rax)
	movl _nshifts(%rip),%ecx
	movw %cx,10(%rax)
	movq _shiftset(%rip),%rdi
	movslq _nshifts(%rip),%rcx
	leaq 12(%rax),%rsi
	leaq (%rdi,%rcx,2),%rdx
L96:
	cmpq %rdx,%rdi
	jae L98
L97:
	movw (%rdi),%cx
	addq $2,%rdi
	movw %cx,(%rsi)
	addq $2,%rsi
	jmp L96
L98:
	movq _last_shift(%rip),%rcx
	testq %rcx,%rcx
	jz L100
L99:
	movq %rax,(%rcx)
	jmp L102
L100:
	movq %rax,_first_shift(%rip)
L102:
	movq %rax,_last_shift(%rip)
L95:
	ret 


_generate_states:
L103:
L104:
	call _allocate_storage
	movl _nitems(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_itemset(%rip)
	movl _nrules(%rip),%eax
	movl $32,%ecx
	addl $31,%eax
	cltd 
	idivl %ecx
	shll $2,%eax
	movl %eax,%edi
	call _allocate
	movq %rax,_ruleset(%rip)
	call _set_first_derives
	call _initialize_states
L106:
	movq _this_state(%rip),%rdi
	testq %rdi,%rdi
	jz L108
L107:
	movswl 20(%rdi),%esi
	addq $22,%rdi
	call _closure
	call _save_reductions
	call _new_itemsets
	call _append_states
	cmpl $0,_nshifts(%rip)
	jle L111
L109:
	call _save_shifts
L111:
	movq _this_state(%rip),%rax
	movq (%rax),%rax
	movq %rax,_this_state(%rip)
	jmp L106
L108:
	call _finalize_closure
	call _free_storage
L105:
	ret 


_get_state:
L112:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L113:
	movl %edi,%r15d
	movslq %r15d,%rcx
	movq _kernel_base(%rip),%rax
	movq (%rax,%rcx,8),%rsi
	movq _kernel_end(%rip),%rax
	movq (%rax,%rcx,8),%r14
	movq %r14,%rax
	subq %rsi,%rax
	movl $2,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r13d
	movswl (%rsi),%r12d
	cmpl $0,%r12d
	jl L115
L118:
	cmpl _nitems(%rip),%r12d
	jl L117
L115:
	movl $338,%edx
	movl $L123,%esi
	movl $L122,%edi
	call ___assert
L117:
	movslq %r12d,%r12
	movq _state_set(%rip),%rax
	movq (%rax,%r12,8),%rbx
	testq %rbx,%rbx
	jz L125
L124:
	xorl %esi,%esi
L128:
	movswl 20(%rbx),%eax
	cmpl %eax,%r13d
	jnz L132
L130:
	movl $1,%esi
	movslq %r15d,%rax
	movq _kernel_base(%rip),%rcx
	movq (%rcx,%rax,8),%rdi
	leaq 22(%rbx),%rdx
L136:
	cmpq %r14,%rdi
	jae L132
L134:
	movw (%rdi),%cx
	addq $2,%rdi
	movw (%rdx),%ax
	addq $2,%rdx
	cmpw %ax,%cx
	jnz L140
L133:
	testl %esi,%esi
	jnz L136
	jz L132
L140:
	xorl %esi,%esi
L132:
	testl %esi,%esi
	jnz L127
L143:
	movq 8(%rbx),%rax
	testq %rax,%rax
	jz L147
L146:
	movq %rax,%rbx
L127:
	testl %esi,%esi
	jz L128
	jnz L126
L147:
	movl %r15d,%edi
	call _new_state
	movq %rax,8(%rbx)
	movq %rax,%rbx
	jmp L126
L125:
	movl %r15d,%edi
	call _new_state
	movq %rax,%rbx
	movq _state_set(%rip),%rcx
	movq %rax,(%rcx,%r12,8)
L126:
	movswl 16(%rbx),%eax
L114:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_new_state:
L150:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L151:
	movl %edi,%r13d
	cmpl $32767,_nstates(%rip)
	jl L155
L153:
	movl $L156,%edi
	call _fatal
L155:
	movslq %r13d,%rcx
	movq _kernel_base(%rip),%rax
	movq (%rax,%rcx,8),%r12
	movq _kernel_end(%rip),%rax
	movq (%rax,%rcx,8),%rbx
	movq %rbx,%rax
	subq %r12,%rax
	movl $2,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r14d
	movl %r14d,%eax
	decl %eax
	leal 24(,%rax,2),%edi
	call _allocate
	movw %r13w,18(%rax)
	movl _nstates(%rip),%ecx
	movw %cx,16(%rax)
	movw %r14w,20(%rax)
	leaq 22(%rax),%rdx
L157:
	cmpq %rbx,%r12
	jae L159
L158:
	movw (%r12),%cx
	addq $2,%r12
	movw %cx,(%rdx)
	addq $2,%rdx
	jmp L157
L159:
	movq _last_state(%rip),%rcx
	movq %rax,(%rcx)
	movq %rax,_last_state(%rip)
	incl _nstates(%rip)
L152:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_show_cores:
L161:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L162:
	xorl %r15d,%r15d
	movq _first_state(%rip),%r14
L164:
	testq %r14,%r14
	jz L163
L165:
	testl %r15d,%r15d
	jz L170
L168:
	pushq $L171
	call _printf
	addq $8,%rsp
L170:
	movswl 16(%r14),%edx
	movswq 18(%r14),%rcx
	movq _symbol_name(%rip),%rax
	pushq (%rax,%rcx,8)
	pushq %rdx
	pushq %r15
	pushq $L172
	call _printf
	addq $32,%rsp
	movswl 20(%r14),%eax
	movl %eax,-4(%rbp)
	xorl %r13d,%r13d
L173:
	cmpl %r13d,-4(%rbp)
	jle L176
L174:
	movslq %r13d,%rax
	movswl 22(%r14,%rax,2),%r12d
	pushq %r12
	pushq $L177
	call _printf
	addq $16,%rsp
	movl %r12d,%edx
L178:
	movslq %edx,%rbx
	movq _ritem(%rip),%rax
	movw (%rax,%rbx,2),%cx
	cmpw $0,%cx
	jl L180
L179:
	incl %edx
	jmp L178
L180:
	movswl %cx,%ecx
	negl %ecx
	movslq %ecx,%rcx
	movq _rlhs(%rip),%rax
	movswq (%rax,%rcx,2),%rax
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rax,8)
	pushq $L181
	call _printf
	addq $16,%rsp
	movq _ritem(%rip),%rax
	movswl (%rax,%rbx,2),%ecx
	negl %ecx
	movslq %ecx,%rcx
	movq _rrhs(%rip),%rax
	movswl (%rax,%rcx,2),%ebx
L182:
	cmpl %ebx,%r12d
	jle L184
L183:
	movl %ebx,%eax
	incl %ebx
	movslq %eax,%rax
	movq _ritem(%rip),%rcx
	movswq (%rcx,%rax,2),%rax
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rax,8)
	pushq $L185
	call _printf
	addq $16,%rsp
	jmp L182
L184:
	pushq $L186
	call _printf
	addq $8,%rsp
L187:
	movslq %ebx,%rax
	movq _ritem(%rip),%rcx
	movw (%rcx,%rax,2),%ax
	cmpw $0,%ax
	jl L189
L188:
	incl %ebx
	movswq %ax,%rax
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rax,8)
	pushq $L185
	call _printf
	addq $16,%rsp
	jmp L187
L189:
	pushq $L171
	call _printf
	addq $8,%rsp
	movl $___stdout,%edi
	call _fflush
	incl %r13d
	jmp L173
L176:
	incl %r15d
	movq (%r14),%r14
	jmp L164
L163:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_show_ritems:
L190:
	pushq %rbx
L191:
	xorl %ebx,%ebx
L193:
	cmpl _nitems(%rip),%ebx
	jge L192
L194:
	movslq %ebx,%rcx
	movq _ritem(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	pushq %rax
	pushq %rbx
	pushq $L197
	call _printf
	addq $24,%rsp
	incl %ebx
	jmp L193
L192:
	popq %rbx
	ret 


_show_rrhs:
L198:
	pushq %rbx
L199:
	xorl %ebx,%ebx
L201:
	cmpl _nrules(%rip),%ebx
	jge L200
L202:
	movslq %ebx,%rcx
	movq _rrhs(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	pushq %rax
	pushq %rbx
	pushq $L205
	call _printf
	addq $24,%rsp
	incl %ebx
	jmp L201
L200:
	popq %rbx
	ret 


_show_shifts:
L206:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L207:
	xorl %r14d,%r14d
	movq _first_shift(%rip),%r13
L209:
	testq %r13,%r13
	jz L208
L210:
	testl %r14d,%r14d
	jz L215
L213:
	pushq $L171
	call _printf
	addq $8,%rsp
L215:
	movswl 8(%r13),%ecx
	movswl 10(%r13),%eax
	pushq %rax
	pushq %rcx
	pushq %r14
	pushq $L216
	call _printf
	addq $32,%rsp
	movswl 10(%r13),%r12d
	xorl %ebx,%ebx
L217:
	cmpl %ebx,%r12d
	jle L220
L218:
	movslq %ebx,%rax
	movswl 12(%r13,%rax,2),%eax
	pushq %rax
	pushq $L221
	call _printf
	addq $16,%rsp
	incl %ebx
	jmp L217
L220:
	incl %r14d
	movq (%r13),%r13
	jmp L209
L208:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_set_derives:
L222:
L223:
	movl _nsyms(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_derives(%rip)
	movl _nvars(%rip),%edi
	addl _nrules(%rip),%edi
	shll $1,%edi
	call _allocate
	xorl %r8d,%r8d
	movl _start_symbol(%rip),%edi
L225:
	cmpl %edi,_nsyms(%rip)
	jle L224
L226:
	movslq %r8d,%rcx
	leaq (%rax,%rcx,2),%rdx
	movslq %edi,%rcx
	movq _derives(%rip),%rsi
	movq %rdx,(%rsi,%rcx,8)
	xorl %esi,%esi
L229:
	cmpl %esi,_nrules(%rip)
	jle L232
L230:
	movslq %esi,%rdx
	movq _rlhs(%rip),%rcx
	movswl (%rcx,%rdx,2),%ecx
	cmpl %ecx,%edi
	jnz L235
L233:
	movslq %r8d,%rcx
	movw %si,(%rax,%rcx,2)
	incl %r8d
L235:
	incl %esi
	jmp L229
L232:
	movslq %r8d,%rcx
	movw $-1,(%rax,%rcx,2)
	incl %r8d
	incl %edi
	jmp L225
L224:
	ret 


_free_derives:
L236:
L237:
	movslq _start_symbol(%rip),%rcx
	movq _derives(%rip),%rax
	movq (%rax,%rcx,8),%rdi
	call _free
	movq _derives(%rip),%rdi
	call _free
L238:
	ret 


_set_nullable:
L239:
L240:
	movl _nsyms(%rip),%edi
	call _malloc
	movq %rax,_nullable(%rip)
	testq %rax,%rax
	jnz L244
L242:
	call _no_space
L244:
	xorl %ecx,%ecx
L245:
	cmpl %ecx,_nsyms(%rip)
	jg L246
L250:
	movl $1,%esi
	movl $1,%edi
L252:
	cmpl _nitems(%rip),%edi
	jge L249
L253:
	movl $1,%edx
L256:
	movslq %edi,%rcx
	movq _ritem(%rip),%rax
	movswl (%rax,%rcx,2),%ecx
	cmpl $0,%ecx
	jl L258
L257:
	movslq %ecx,%rcx
	movq _nullable(%rip),%rax
	cmpb $0,(%rcx,%rax)
	movl $0,%eax
	cmovzl %eax,%edx
	incl %edi
	jmp L256
L258:
	testl %edx,%edx
	jz L264
L262:
	negl %ecx
	movslq %ecx,%rcx
	movq _rlhs(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	movslq %eax,%rax
	movq _nullable(%rip),%rcx
	cmpb $0,(%rax,%rcx)
	jnz L264
L265:
	movb $1,(%rax,%rcx)
	xorl %esi,%esi
L264:
	incl %edi
	jmp L252
L249:
	testl %esi,%esi
	jz L250
L241:
	ret 
L246:
	movslq %ecx,%rax
	movq _nullable(%rip),%rdx
	movb $0,(%rax,%rdx)
	incl %ecx
	jmp L245


_free_nullable:
L268:
L269:
	movq _nullable(%rip),%rdi
	call _free
L270:
	ret 


_lr0:
L271:
L272:
	call _set_derives
	call _set_nullable
	call _generate_states
L273:
	ret 

L221:
 .byte 9,37,100,10,0
L216:
 .byte 115,104,105,102,116,32,37,100
 .byte 44,32,110,117,109,98,101,114
 .byte 32,61,32,37,100,44,32,110
 .byte 115,104,105,102,116,115,32,61
 .byte 32,37,100,10,0
L186:
 .byte 32,46,0
L177:
 .byte 37,52,100,32,32,0
L185:
 .byte 32,37,115,0
L122:
 .byte 48,32,60,61,32,107,101,121
 .byte 32,38,38,32,107,101,121,32
 .byte 60,32,110,105,116,101,109,115
 .byte 0
L171:
 .byte 10,0
L181:
 .byte 37,115,32,58,0
L123:
 .byte 108,114,48,46,99,0
L197:
 .byte 114,105,116,101,109,91,37,100
 .byte 93,32,61,32,37,100,10,0
L156:
 .byte 116,111,111,32,109,97,110,121
 .byte 32,115,116,97,116,101,115,0
L172:
 .byte 115,116,97,116,101,32,37,100
 .byte 44,32,110,117,109,98,101,114
 .byte 32,61,32,37,100,44,32,97
 .byte 99,99,101,115,115,105,110,103
 .byte 32,115,121,109,98,111,108,32
 .byte 61,32,37,115,10,0
L205:
 .byte 114,114,104,115,91,37,100,93
 .byte 32,61,32,37,100,10,0
.globl _nstates
.comm _nstates, 4, 4
.globl _first_state
.comm _first_state, 8, 8
.globl _first_shift
.comm _first_shift, 8, 8
.globl _first_reduction
.comm _first_reduction, 8, 8
.local _state_set
.comm _state_set, 8, 8
.local _this_state
.comm _this_state, 8, 8
.local _last_state
.comm _last_state, 8, 8
.local _last_shift
.comm _last_shift, 8, 8
.local _last_reduction
.comm _last_reduction, 8, 8
.local _nshifts
.comm _nshifts, 4, 4
.local _shift_symbol
.comm _shift_symbol, 8, 8
.local _redset
.comm _redset, 8, 8
.local _shiftset
.comm _shiftset, 8, 8
.local _kernel_base
.comm _kernel_base, 8, 8
.local _kernel_end
.comm _kernel_end, 8, 8
.local _kernel_items
.comm _kernel_items, 8, 8

.globl _free
.globl _rlhs
.globl _set_first_derives
.globl _closure
.globl ___stdout
.globl _nsyms
.globl _malloc
.globl ___assert
.globl _new_state
.globl _finalize_closure
.globl _rrhs
.globl _first_state
.globl _printf
.globl _ruleset
.globl _fflush
.globl _allocate
.globl _nitems
.globl _start_symbol
.globl _first_reduction
.globl _symbol_name
.globl _nrules
.globl _fatal
.globl _lr0
.globl _itemset
.globl _first_shift
.globl _ritem
.globl _itemsetend
.globl _nvars
.globl _derives
.globl _nstates
.globl _nullable
.globl _no_space
