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
	jmp L4
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
L4:
	cmpq %rdx,%rsi
	ja L5
L7:
	movl _nsyms(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_kernel_base(%rip)
	shll $1,%r12d
	movl %r12d,%edi
	call _allocate
	movq %rax,_kernel_items(%rip)
	xorl %edx,%edx
	xorl %esi,%esi
	xorl %ecx,%ecx
	jmp L11
L12:
	movslq %edx,%rdx
	movq _kernel_items(%rip),%rax
	leaq (%rax,%rdx,2),%rax
	movq _kernel_base(%rip),%rdi
	movq %rax,(%rdi,%rcx,8)
	movswl (%rbx,%rcx,2),%eax
	addl %eax,%edx
	cmpl %eax,%esi
	cmovll %eax,%esi
	incl %ecx
L11:
	movl _nsyms(%rip),%edi
	cmpl %ecx,%edi
	jg L12
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
L22:
	movl $1,%edi
	jmp L24
L25:
	movq _shift_symbol(%rip),%rax
	movswl (%rax,%rdi,2),%edx
	movl %edi,%eax
L28:
	cmpl $0,%eax
	jle L30
L31:
	movl %eax,%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _shift_symbol(%rip),%rsi
	movw (%rsi,%rcx,2),%cx
	movswl %cx,%ecx
	cmpl %ecx,%edx
	jge L30
L29:
	movslq %eax,%rax
	movw %cx,(%rsi,%rax,2)
	decl %eax
	jmp L28
L30:
	movslq %eax,%rax
	movq _shift_symbol(%rip),%rcx
	movw %dx,(%rcx,%rax,2)
	incl %edi
L24:
	cmpl _nshifts(%rip),%edi
	jl L25
L27:
	xorl %ebx,%ebx
	jmp L35
L36:
	movq _shift_symbol(%rip),%rax
	movswl (%rax,%rbx,2),%edi
	call _get_state
	movq _shiftset(%rip),%rcx
	movw %ax,(%rcx,%rbx,2)
	incl %ebx
L35:
	cmpl _nshifts(%rip),%ebx
	jl L36
L23:
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
	jmp L45
L47:
	incl %r13d
L45:
	cmpw $0,(%r12,%r13,2)
	jge L47
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
	xorl %edx,%edx
	jmp L53
L54:
	movswq %cx,%rcx
	movq _rrhs(%rip),%rax
	movw (%rax,%rcx,2),%ax
	movw %ax,22(%rbx,%rdx,2)
	incl %edx
L53:
	movw (%r12,%rdx,2),%cx
	cmpw $0,%cx
	jge L54
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
	xorl %ecx,%ecx
	jmp L60
L61:
	movq _kernel_end(%rip),%rax
	movq $0,(%rax,%rcx,8)
	incl %ecx
L60:
	cmpl _nsyms(%rip),%ecx
	jl L61
L63:
	xorl %r9d,%r9d
	movq _itemset(%rip),%r8
L64:
	cmpq _itemsetend(%rip),%r8
	jae L66
L65:
	movswl (%r8),%edi
	addq $2,%r8
	movslq %edi,%rdi
	movq _ritem(%rip),%rax
	movswl (%rax,%rdi,2),%esi
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
	jmp L76
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
	movq _redset(%rip),%rax
	movw %dx,(%rax,%rcx,2)
L82:
	addq $2,%rsi
L76:
	cmpq _itemsetend(%rip),%rsi
	jb L77
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
	movl %ebx,%ebx
	leaq (%rdi,%rbx,2),%rdx
	jmp L86
L87:
	movw (%rdi),%cx
	addq $2,%rdi
	movw %cx,(%rsi)
	addq $2,%rsi
L86:
	cmpq %rdx,%rdi
	jb L87
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
	movw _nshifts(%rip),%cx
	movw %cx,10(%rax)
	movq _shiftset(%rip),%rdi
	movslq _nshifts(%rip),%rcx
	leaq 12(%rax),%rsi
	leaq (%rdi,%rcx,2),%rdx
	jmp L96
L97:
	movw (%rdi),%cx
	addq $2,%rdi
	movw %cx,(%rsi)
	addq $2,%rsi
L96:
	cmpq %rdx,%rdi
	jb L97
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
	jmp L106
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
L106:
	movq _this_state(%rip),%rdi
	testq %rdi,%rdi
	jnz L107
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
	movl %edi,%ebx
	movslq %ebx,%rcx
	movq _kernel_base(%rip),%rax
	movq (%rax,%rcx,8),%rsi
	movq _kernel_end(%rip),%rax
	movq (%rax,%rcx,8),%r15
	movq %r15,%rax
	subq %rsi,%rax
	movl $2,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r14d
	movswl (%rsi),%r13d
	cmpl $0,%r13d
	jl L115
L118:
	cmpl _nitems(%rip),%r13d
	jl L117
L115:
	movl $338,%edx
	movl $L123,%esi
	movl $L122,%edi
	call ___assert
L117:
	movslq %r13d,%r13
	movq _state_set(%rip),%rax
	movq (%rax,%r13,8),%r12
	testq %r12,%r12
	jz L125
L124:
	xorl %esi,%esi
L128:
	movswl 20(%r12),%eax
	cmpl %eax,%r14d
	jnz L132
L130:
	movl $1,%esi
	movslq %ebx,%rbx
	movq _kernel_base(%rip),%rax
	movq (%rax,%rbx,8),%rdi
	leaq 22(%r12),%rdx
L136:
	cmpq %r15,%rdi
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
	movq 8(%r12),%rax
	testq %rax,%rax
	jz L147
L146:
	movq %rax,%r12
L127:
	testl %esi,%esi
	jz L128
	jnz L126
L147:
	movl %ebx,%edi
	call _new_state
	movq %rax,8(%r12)
	movq %rax,%r12
	jmp L126
L125:
	movl %ebx,%edi
	call _new_state
	movq %rax,%r12
	movq _state_set(%rip),%rcx
	movq %rax,(%rcx,%r13,8)
L126:
	movswl 16(%r12),%eax
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
	movl %edi,%r14d
	cmpl $32767,_nstates(%rip)
	jl L155
L153:
	movl $L156,%edi
	call _fatal
L155:
	movslq %r14d,%r14
	movq _kernel_base(%rip),%rax
	movq (%rax,%r14,8),%r13
	movq _kernel_end(%rip),%rax
	movq (%rax,%r14,8),%r12
	movq %r12,%rax
	subq %r13,%rax
	movl $2,%ecx
	cqto 
	idivq %rcx
	movl %eax,%ebx
	movl %ebx,%eax
	decl %eax
	leal 24(,%rax,2),%edi
	call _allocate
	movw %r14w,18(%rax)
	movw _nstates(%rip),%cx
	movw %cx,16(%rax)
	movw %bx,20(%rax)
	leaq 22(%rax),%rdx
	jmp L157
L158:
	movw (%r13),%cx
	addq $2,%r13
	movw %cx,(%rdx)
	addq $2,%rdx
L157:
	cmpq %r12,%r13
	jb L158
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
	xorl %r14d,%r14d
	movq _first_state(%rip),%r13
	jmp L164
L165:
	testl %r14d,%r14d
	jz L170
L168:
	pushq $L171
	call _printf
	addq $8,%rsp
L170:
	movswl 16(%r13),%edx
	movswq 18(%r13),%rcx
	movq _symbol_name(%rip),%rax
	pushq (%rax,%rcx,8)
	pushq %rdx
	pushq %r14
	pushq $L172
	call _printf
	addq $32,%rsp
	movswl 20(%r13),%eax
	movl %eax,-4(%rbp)
	xorl %r12d,%r12d
L173:
	cmpl %r12d,-4(%rbp)
	jle L176
L174:
	movswl 22(%r13,%r12,2),%ebx
	pushq %rbx
	pushq $L177
	call _printf
	addq $16,%rsp
	movl %ebx,%r15d
L178:
	movslq %r15d,%r15
	movq _ritem(%rip),%rax
	movw (%rax,%r15,2),%cx
	cmpw $0,%cx
	jl L180
L179:
	incl %r15d
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
	movswl (%rax,%r15,2),%ecx
	negl %ecx
	movslq %ecx,%rcx
	movq _rrhs(%rip),%rax
	movswl (%rax,%rcx,2),%r15d
L182:
	cmpl %r15d,%ebx
	jle L184
L183:
	movl %r15d,%eax
	incl %r15d
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
	movslq %r15d,%r15
	movq _ritem(%rip),%rax
	movw (%rax,%r15,2),%ax
	cmpw $0,%ax
	jl L189
L188:
	incl %r15d
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
	incl %r12d
	jmp L173
L176:
	incl %r14d
	movq (%r13),%r13
L164:
	testq %r13,%r13
	jnz L165
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
	jmp L193
L194:
	movq _ritem(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq %rbx
	pushq $L197
	call _printf
	addq $24,%rsp
	incl %ebx
L193:
	cmpl _nitems(%rip),%ebx
	jl L194
L192:
	popq %rbx
	ret 


_show_rrhs:
L198:
	pushq %rbx
L199:
	xorl %ebx,%ebx
	jmp L201
L202:
	movq _rrhs(%rip),%rax
	movswl (%rax,%rbx,2),%eax
	pushq %rax
	pushq %rbx
	pushq $L205
	call _printf
	addq $24,%rsp
	incl %ebx
L201:
	cmpl _nrules(%rip),%ebx
	jl L202
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
	xorl %r12d,%r12d
	movq _first_shift(%rip),%rbx
	jmp L209
L210:
	testl %r12d,%r12d
	jz L215
L213:
	pushq $L171
	call _printf
	addq $8,%rsp
L215:
	movswl 8(%rbx),%ecx
	movswl 10(%rbx),%eax
	pushq %rax
	pushq %rcx
	pushq %r12
	pushq $L216
	call _printf
	addq $32,%rsp
	movswl 10(%rbx),%r14d
	xorl %r13d,%r13d
L217:
	cmpl %r13d,%r14d
	jle L220
L218:
	movswl 12(%rbx,%r13,2),%eax
	pushq %rax
	pushq $L221
	call _printf
	addq $16,%rsp
	incl %r13d
	jmp L217
L220:
	incl %r12d
	movq (%rbx),%rbx
L209:
	testq %rbx,%rbx
	jnz L210
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
	xorl %ecx,%ecx
	movl _start_symbol(%rip),%edi
	jmp L225
L226:
	leaq (%rax,%rcx,2),%rdx
	movslq %edi,%rdi
	movq _derives(%rip),%rsi
	movq %rdx,(%rsi,%rdi,8)
	xorl %esi,%esi
L229:
	cmpl %esi,_nrules(%rip)
	jle L232
L230:
	movq _rlhs(%rip),%rdx
	movswl (%rdx,%rsi,2),%edx
	cmpl %edx,%edi
	jnz L235
L233:
	movl %ecx,%ecx
	movw %si,(%rax,%rcx,2)
	incl %ecx
L235:
	incl %esi
	jmp L229
L232:
	movl %ecx,%ecx
	movw $-1,(%rax,%rcx,2)
	incl %ecx
	incl %edi
L225:
	cmpl %edi,_nsyms(%rip)
	jg L226
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
	xorl %eax,%eax
L245:
	cmpl %eax,_nsyms(%rip)
	jg L246
L250:
	movl $1,%esi
	movl $1,%edx
	jmp L252
L253:
	movl $1,%ecx
L256:
	movq _ritem(%rip),%rax
	movswl (%rax,%rdx,2),%eax
	cmpl $0,%eax
	jl L258
L257:
	movslq %eax,%rax
	movq _nullable(%rip),%rdi
	cmpb $0,(%rax,%rdi)
	movl $0,%eax
	cmovzl %eax,%ecx
	incl %edx
	jmp L256
L258:
	testl %ecx,%ecx
	jz L264
L262:
	negl %eax
	movslq %eax,%rcx
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
	incl %edx
L252:
	cmpl _nitems(%rip),%edx
	jl L253
L249:
	testl %esi,%esi
	jz L250
L241:
	ret 
L246:
	movq _nullable(%rip),%rcx
	movb $0,(%rax,%rcx)
	incl %eax
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
