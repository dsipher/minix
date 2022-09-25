.text

_case_type:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%r12
	movl $4,%ebx
L4:
	movl $1,%r13d
L5:
	cmpl 60(%r12),%r13d
	jge L8
L6:
	movq 64(%r12),%rcx
	movslq %r13d,%r13
	leaq (%r13,%r13,2),%rax
	shlq $3,%rax
	leaq 8(%rcx,%rax),%rsi
	movq %rbx,%rdi
	call _con_in_range
	testl %eax,%eax
	jz L9
L11:
	incl %r13d
	jmp L5
L9:
	shlq $1,%rbx
	jmp L4
L8:
	testq $73726,%rbx
	jz L14
L20:
	movl 80(%r12),%edx
	testl $2359232,%edx
	jz L14
L16:
	movl %edx,%eax
	shll $10,%eax
	shrl $15,%eax
	cmpq %rax,%rbx
	jz L13
L24:
	testq $7168,%rbx
	setz %al
	movzbl %al,%ecx
	testl $229376,%edx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L14
L28:
	movq %rbx,%rdi
	call _t_size
	movl %eax,%r13d
	movl 80(%r12),%edi
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	cmpl %eax,%r13d
	jnz L14
L13:
	movl 80(%r12),%eax
	shll $10,%eax
	shrl $15,%eax
	jmp L3
L14:
	movq %rbx,%rax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_cmp0:
L34:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L35:
	movq %rdi,%r13
	movl (%r13),%r12d
	shll $10,%r12d
	shrl $15,%r12d
	movq %rsi,-8(%rbp)
	movl $2,-40(%rbp)
	movq -8(%rbp),%rax
	movq %rax,-24(%rbp)
	movq $0,-16(%rbp)
	xorl %esi,%esi
	movl $603979787,%edi
	call _new_insn
	movq %rax,%rbx
	movl $32,%ecx
	movq %r13,%rsi
	leaq 8(%rbx),%rdi
	rep 
	movsb 
	movl %r12d,%r13d
	movl %r13d,%ecx
	andl $131071,%ecx
	shll $5,%ecx
	movl 8(%rbx),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,8(%rbx)
	andl $7,%eax
	cmpl $2,%eax
	jnz L60
L58:
	leaq 24(%rbx),%rsi
	movq %r12,%rdi
	call _normalize_con
L60:
	movl $32,%ecx
	leaq -40(%rbp),%rsi
	leaq 40(%rbx),%rdi
	rep 
	movsb 
	andl $131071,%r13d
	shll $5,%r13d
	movl 40(%rbx),%eax
	andl $4290773023,%eax
	orl %r13d,%eax
	movl %eax,40(%rbx)
	andl $7,%eax
	cmpl $2,%eax
	jnz L66
L64:
	leaq 56(%rbx),%rsi
	movq %r12,%rdi
	call _normalize_con
L66:
	movq %rbx,%rax
L36:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_range0:
L68:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L69:
	movq %rdi,%r14
	movq %rsi,-8(%rbp)
	movq %rdx,%r15
	movq %rcx,-32(%rbp)
	movq %r8,-24(%rbp)
	movq %r9,-16(%rbp)
	call _new_block
	movq %rax,%r13
	call _new_block
	movq %rax,%r12
	movl 80(%r14),%ebx
	shll $10,%ebx
	shrl $15,%ebx
	movq 8(%r15),%rsi
	leaq 80(%r14),%rdi
	call _cmp0
	movq %r13,%rsi
	movq %rax,%rdi
	call _append_insn
	andl $680,%ebx
	movl $7,%eax
	movl $11,%esi
	cmovzl %eax,%esi
	movq -32(%rbp),%rdx
	movq %r13,%rdi
	call _add_succ
	testq %rbx,%rbx
	movl $6,%eax
	movl $10,%esi
	cmovzl %eax,%esi
	movq %r12,%rdx
	movq %r13,%rdi
	call _add_succ
	movq -24(%rbp),%rax
	movq 8(%rax),%rsi
	leaq 80(%r14),%rdi
	call _cmp0
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
	testq %rbx,%rbx
	movl $5,%eax
	movl $9,%esi
	cmovzl %eax,%esi
	movq -8(%rbp),%rdx
	movq %r12,%rdi
	call _add_succ
	testq %rbx,%rbx
	movl $4,%eax
	movl $8,%esi
	cmovzl %eax,%esi
	movq -16(%rbp),%rdx
	movq %r12,%rdi
	call _add_succ
	movq %r13,%rax
L70:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_chain0:
L84:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L85:
	movq %rdi,%r14
	movq %rsi,%r13
	movq $0,-8(%rbp)
	movq $0,-16(%rbp)
	movq 64(%r14),%rax
	movq 16(%rax),%rax
	movq %rax,-24(%rbp)
	movl 80(%r14),%r15d
	shll $10,%r15d
	shrl $15,%r15d
	call _new_block
	movq %rax,%r12
	movq %rax,-48(%rbp)
	call _new_block
	movq %rax,%rbx
	cmpq %r15,%r13
	jz L89
L87:
	movq 64(%r14),%rax
	leaq 24(%rax),%rcx
	movq %rax,-64(%rbp)
	movq %rcx,-8(%rbp)
	movl 60(%r14),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -64(%rbp),%rax
	addq %rcx,%rax
	movq %rax,-56(%rbp)
	movq %rcx,-40(%rbp)
	movq -56(%rbp),%rax
	movq %rax,-16(%rbp)
	movq -64(%rbp),%rax
	movq 32(%rax),%rsi
	leaq 80(%r14),%rdi
	call _cmp0
	movq -48(%rbp),%rsi
	movq %rax,%rdi
	call _append_insn
	movq -64(%rbp),%rax
	movq 40(%rax),%rdx
	xorl %esi,%esi
	movq -48(%rbp),%rdi
	call _add_succ
	andl $680,%r15d
	movl $7,%eax
	movl $11,%esi
	cmovzl %eax,%esi
	movq -24(%rbp),%rdx
	movq -48(%rbp),%rdi
	call _add_succ
	testq %r15,%r15
	movl $4,%eax
	movl $8,%esi
	cmovzl %eax,%esi
	movq %rbx,%rdx
	movq -48(%rbp),%rdi
	call _add_succ
	call _new_block
	movq %rax,%r12
	movq -40(%rbp),%rcx
	movq -64(%rbp),%rax
	movq 8(%rax,%rcx),%rsi
	leaq 80(%r14),%rdi
	call _cmp0
	movq %rbx,%rsi
	movq %rax,%rdi
	call _append_insn
	movq -40(%rbp),%rcx
	movq -64(%rbp),%rax
	movq 16(%rax,%rcx),%rdx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _add_succ
	testq %r15,%r15
	movl $4,%eax
	movl $8,%esi
	cmovzl %eax,%esi
	movq -24(%rbp),%rdx
	movq %rbx,%rdi
	call _add_succ
	testq %r15,%r15
	movl $7,%eax
	movl $11,%esi
	cmovzl %eax,%esi
	movq %r12,%rdx
	movq %rbx,%rdi
	call _add_succ
	call _new_block
	movq %rax,%rbx
	movq %r13,%rdi
	call _temp_reg
	movl %eax,-28(%rbp)
	xorl %esi,%esi
	movl $-1610612726,%edi
	call _new_insn
	movq %rax,%r15
	movl 8(%r15),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%r15)
	movl -28(%rbp),%eax
	movl %eax,16(%r15)
	testq %r13,%r13
	jz L116
L114:
	andl $131071,%r13d
	shll $5,%r13d
	andl $4290773023,%ecx
	orl %r13d,%ecx
	movl %ecx,8(%r15)
L116:
	movl $32,%ecx
	leaq 80(%r14),%rsi
	leaq 40(%r15),%rdi
	rep 
	movsb 
	movq %r12,%rsi
	movq %r15,%rdi
	call _append_insn
	movl $32,%ecx
	leaq 8(%r15),%rsi
	leaq 80(%r14),%rdi
	rep 
	movsb 
L89:
	movl $1,%r15d
	jmp L117
L118:
	movq 64(%r14),%rcx
	movslq %r15d,%r15
	leaq (%r15,%r15,2),%r13
	shlq $3,%r13
	leaq (%rcx,%r13),%rax
	cmpq %rax,-8(%rbp)
	jz L119
L123:
	cmpq %rax,-16(%rbp)
	jz L119
L127:
	movq 8(%rcx,%r13),%rsi
	leaq 80(%r14),%rdi
	call _cmp0
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
	movq 64(%r14),%rax
	movq 16(%r13,%rax),%rdx
	xorl %esi,%esi
	movq %r12,%rdi
	call _add_succ
	movq %rbx,%rdx
	movl $1,%esi
	movq %r12,%rdi
	call _add_succ
	movq %rbx,%r12
	call _new_block
	movq %rax,%rbx
L119:
	incl %r15d
L117:
	cmpl 60(%r14),%r15d
	jl L118
L120:
	movq -24(%rbp),%rdx
	movl $12,%esi
	movq %r12,%rdi
	call _add_succ
	movq %r14,%rdi
	call _remove_succs
	movq -48(%rbp),%rdx
	movl $12,%esi
	movq %r14,%rdi
	call _add_succ
L86:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_split1:
L129:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L130:
	movq %rdi,%r15
	movl %esi,%r13d
	movl %edx,%r12d
	movq 64(%r15),%rax
	movq 16(%rax),%rax
	movq %rax,-24(%rbp)
	call _new_block
	movq %rax,%r14
	movq -24(%rbp),%rdx
	leaq 80(%r15),%rsi
	movq %r14,%rdi
	call _switch_block
	call _new_block
	movq %rax,-32(%rbp)
	movq -24(%rbp),%rdx
	leaq 80(%r15),%rsi
	movq -32(%rbp),%rdi
	call _switch_block
	orl $8,4(%r14)
	addl %r13d,%r12d
	decl %r12d
	movq 64(%r15),%rdx
	movslq %r13d,%r13
	leaq (%r13,%r13,2),%rax
	shlq $3,%rax
	movq %rax,-16(%rbp)
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%r8
	shlq $3,%r8
	movq -32(%rbp),%r9
	addq %rdx,%r8
	movq -32(%rbp),%rcx
	addq -16(%rbp),%rdx
	movq %r14,%rsi
	movq %r15,%rdi
	call _range0
	movq %rax,-8(%rbp)
	movl %r13d,%ebx
	jmp L132
L133:
	movq 64(%r15),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdx
	leaq 8(%rcx,%rax),%rsi
	movq %r14,%rdi
	call _add_switch_succ
	incl %ebx
L132:
	cmpl %ebx,%r12d
	jge L133
L135:
	movl $1,%ebx
	jmp L136
L137:
	cmpl %ebx,%r13d
	jg L140
L143:
	cmpl %ebx,%r12d
	jge L142
L140:
	movq 64(%r15),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdx
	leaq 8(%rcx,%rax),%rsi
	movq -32(%rbp),%rdi
	call _add_switch_succ
L142:
	incl %ebx
L136:
	cmpl 60(%r15),%ebx
	jl L137
L139:
	movq %r15,%rdi
	call _remove_succs
	movq -8(%rbp),%rdx
	movl $12,%esi
	movq %r15,%rdi
	call _add_succ
L131:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L170:
	.quad 0x3ff0000000000000
L171:
	.quad 0x3fe0000000000000

_split0:
L147:
	pushq %rbx
	pushq %r12
L148:
	xorl %esi,%esi
	xorl %r12d,%r12d
	movl $1,%r9d
	jmp L150
L151:
	movl %r9d,%r11d
L154:
	movl 60(%rdi),%eax
	decl %eax
	cmpl %eax,%r11d
	jg L157
L155:
	movq 64(%rdi),%rbx
	movslq %r11d,%r11
	leaq (%r11,%r11,2),%r10
	shlq $3,%r10
	leaq (%rbx,%r10),%rax
	movslq %r9d,%r9
	leaq (%r9,%r9,2),%r8
	shlq $3,%r8
	leaq (%rbx,%r8),%rcx
	subq %rcx,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cvtsi2sdq %rax,%xmm1
	movsd L170(%rip),%xmm0
	addsd %xmm0,%xmm1
	cvtsi2sdq 8(%rbx,%r10),%xmm2
	addsd %xmm0,%xmm2
	cvtsi2sdq 8(%rbx,%r8),%xmm0
	subsd %xmm0,%xmm2
	divsd %xmm2,%xmm1
	ucomisd L171(%rip),%xmm1
	jb L157
L160:
	incl %r11d
	jmp L154
L157:
	subl %r9d,%r11d
	cmpl %r11d,%r12d
	jge L164
L162:
	movl %r9d,%esi
	movl %r11d,%r12d
L164:
	incl %r9d
L150:
	movl 60(%rdi),%eax
	decl %eax
	cmpl %eax,%r9d
	jle L151
L153:
	cmpl $5,%r12d
	jge L166
L165:
	xorl %eax,%eax
	jmp L149
L166:
	movl %r12d,%edx
	call _split1
	movl $1,%eax
L149:
	popq %r12
	popq %rbx
	ret 


_dense0:
L172:
	pushq %rbx
	pushq %r12
	pushq %r13
L173:
	movq %rdi,%rbx
	movq 64(%rbx),%rax
	movq 16(%rax),%r13
	call _new_block
	movq %rax,%r12
	movq %rbx,%rsi
	movq %r12,%rdi
	call _dup_succs
	orl $8,4(%r12)
	movq 64(%r12),%rdx
	movl 60(%r12),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%r8
	shlq $3,%r8
	movq %r13,%r9
	addq %rdx,%r8
	movq %r13,%rcx
	addq $24,%rdx
	movq %r12,%rsi
	movq %rbx,%rdi
	call _range0
	movq %rax,%r12
	movq %rbx,%rdi
	call _remove_succs
	movq %r12,%rdx
	movl $12,%esi
	movq %rbx,%rdi
	call _add_succ
L174:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_compars0:
L175:
L176:
	movq 8(%rdi),%rax
	cmpq 8(%rsi),%rax
	jz L178
	jg L182
L186:
	movl $-1,%eax
	ret
L182:
	movl $1,%eax
	ret
L178:
	xorl %eax,%eax
L177:
	ret 


_comparu0:
L190:
L191:
	movq 8(%rdi),%rax
	cmpq 8(%rsi),%rax
	jz L193
	ja L197
L201:
	movl $-1,%eax
	ret
L197:
	movl $1,%eax
	ret
L193:
	xorl %eax,%eax
L192:
	ret 


_sort0:
L205:
L206:
	testl $21760,80(%rdi)
	movl $_compars0,%eax
	movl $_comparu0,%ecx
	cmovzq %rax,%rcx
	movq 64(%rdi),%rax
	movl 60(%rdi),%esi
	decl %esi
	movslq %esi,%rsi
	movl $24,%edx
	leaq 24(%rax),%rdi
	call _qsort
L207:
	ret 


_lir_switch:
L211:
	pushq %rbx
	pushq %r12
L214:
	movq _all_blocks(%rip),%r12
	jmp L215
L216:
	movl 4(%r12),%eax
	testl $1,%eax
	jz L217
L219:
	movl 60(%r12),%ebx
	decl %ebx
	jz L222
L224:
	testl $24,%eax
	jnz L217
L228:
	cmpl $4,%ebx
	jle L230
L232:
	movq %r12,%rdi
	call _sort0
	movq 64(%r12),%rdi
	movl 60(%r12),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rsi
	shlq $3,%rsi
	leaq (%rdi,%rsi),%rax
	leaq 24(%rdi),%rcx
	subq %rcx,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cvtsi2sdq %rax,%xmm1
	movsd L170(%rip),%xmm0
	addsd %xmm0,%xmm1
	cvtsi2sdq 8(%rdi,%rsi),%xmm2
	addsd %xmm0,%xmm2
	cvtsi2sdq 32(%rdi),%xmm0
	subsd %xmm0,%xmm2
	divsd %xmm2,%xmm1
	ucomisd L171(%rip),%xmm1
	jae L234
L236:
	movq %r12,%rdi
	call _split0
	testl %eax,%eax
	jnz L214
L240:
	cmpl $10,%ebx
	jg L244
L242:
	movq %r12,%rdi
	call _case_type
	movq %rax,%rsi
	cmpq $256,%rsi
	jl L249
L244:
	orl $16,4(%r12)
	jmp L217
L234:
	movq %r12,%rdi
	call _dense0
	jmp L217
L230:
	movl 80(%r12),%esi
	shll $10,%esi
	shrl $15,%esi
L249:
	movq %r12,%rdi
	call _chain0
	jmp L217
L222:
	movq %r12,%rdi
	call _unswitch_block
L217:
	movq 112(%r12),%r12
L215:
	testq %r12,%r12
	jnz L216
L213:
	popq %r12
	popq %rbx
	ret 


_target0:
L250:
	pushq %rbx
L251:
	movq %rdi,%rbx
	movl (%rbx),%eax
	testl %esi,%esi
	jz L254
L253:
	pushq %rax
	pushq $L256
	call _out
	addq $16,%rsp
	jmp L255
L254:
	pushq _current_func(%rip)
	pushq %rax
	pushq $L257
	call _out
	addq $24,%rsp
L255:
	orl $32,4(%rbx)
L252:
	popq %rbx
	ret 


_control0:
L258:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L259:
	movq %rdi,%r13
	movl 80(%r13),%r12d
	movl %r12d,%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L262
L261:
	shll $10,%r12d
	shrl $15,%r12d
	movq %r12,%rdi
	call _temp_reg
	movl %eax,%ebx
	movl -32(%rbp),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,-32(%rbp)
	movl %ebx,-24(%rbp)
	leaq 80(%r13),%rdx
	leaq -32(%rbp),%rsi
	movq %r12,%rdi
	call _move
	movq %r13,%rsi
	movq %rax,%rdi
	call _append_insn
	movl %ebx,%eax
	jmp L260
L262:
	movl 88(%r13),%eax
L260:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
L284:
	.int -1610561948
	.int -1610561947
	.int -1610561946
	.int -1610545049
.align 4
L285:
	.int -1610602933
	.int -1610578352
	.int 0
	.int 0
.text

_dense1:
L281:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L282:
	movq %rdi,%r12
	movl %esi,-24(%rbp)
	movl 80(%r12),%r13d
	shll $10,%r13d
	shrl $15,%r13d
	movl _last_asmlab(%rip),%esi
	leal 1(%rsi),%eax
	movl %eax,_last_asmlab(%rip)
	incl %esi
	movl $_void_type,%edi
	call _anon_static
	movq %rax,-16(%rbp)
	movl $256,%edi
	call _temp_reg
	movl %eax,%ebx
	movl $1,%edi
	call _seg
	cmpl $0,-24(%rbp)
	movl $2,%eax
	movl $4,%ecx
	cmovzl %eax,%ecx
	pushq %rcx
	pushq $L286
	call _out
	addq $16,%rsp
	pushq -16(%rbp)
	pushq $L290
	call _out
	addq $16,%rsp
	movl $1,%r14d
	movq 64(%r12),%rax
	movq 32(%rax),%r15
	jmp L291
L292:
	movq 64(%r12),%rcx
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rax
	shlq $3,%rax
	cmpq 8(%rcx,%rax),%r15
	jz L296
L295:
	movl -24(%rbp),%esi
	movq 16(%rcx),%rdi
	call _target0
	jmp L297
L296:
	movl -24(%rbp),%esi
	movq 16(%rcx,%rax),%rdi
	call _target0
	incl %r14d
L297:
	incq %r15
L291:
	cmpl 60(%r12),%r14d
	jl L292
L294:
	movq %r12,%rdi
	call _control0
	movl %eax,-20(%rbp)
	movq 64(%r12),%rax
	movq 32(%rax),%r14
	testq $768,%r13
	jz L303
L301:
	cmpq $-2147483648,%r14
	jl L306
L305:
	cmpq $2147483647,%r14
	jle L303
L306:
	xorl %esi,%esi
	movl $-1610545081,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	negq %r14
	movq %r14,-8(%rbp)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -8(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-469694349,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,40(%rax)
	movl -20(%rbp),%ecx
	movl %ecx,48(%rax)
	jmp L540
L303:
	movq %r13,%rdi
	call _t_size
	bsrl %eax,%ecx
	xorl $31,%ecx
	movslq %ecx,%rcx
	movl $31,%eax
	subq %rcx,%rax
	xorl %esi,%esi
	movl L284(,%rax,4),%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 40(%rax),%edx
	andl $4294967288,%edx
	orl $4,%edx
	movl -20(%rbp),%ecx
	movl %ecx,48(%rax)
	movl $0,52(%rax)
	andl $4294967271,%edx
	movl %edx,40(%rax)
	negq %r14
	movq %r14,56(%rax)
	movq $0,64(%rax)
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
	movq %r13,%rdi
	call _t_size
	bsrl %eax,%ecx
	xorl $31,%ecx
	movslq %ecx,%rcx
	movl $31,%eax
	subq %rcx,%rax
	cmpl $0,L285(,%rax,4)
	jz L300
L402:
	movq %r13,%rdi
	call _t_size
	bsrl %eax,%ecx
	xorl $31,%ecx
	movslq %ecx,%rcx
	movl $31,%eax
	subq %rcx,%rax
	xorl %esi,%esi
	movl L285(,%rax,4),%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,40(%rax)
	movl %ebx,48(%rax)
L540:
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
L300:
	cmpl $0,-24(%rbp)
	jz L436
L435:
	xorl %esi,%esi
	movl $-1610561978,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $3,%ecx
	movl $0,48(%rax)
	movl %ebx,52(%rax)
	andl $4294967271,%ecx
	orl $16,%ecx
	movl %ecx,40(%rax)
	movq $0,56(%rax)
	movq -16(%rbp),%rcx
	jmp L541
L436:
	xorl %esi,%esi
	movl $-1610578352,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $3,%ecx
	movl $0,48(%rax)
	movl %ebx,52(%rax)
	andl $4294967271,%ecx
	orl $8,%ecx
	movl %ecx,40(%rax)
	movq $0,56(%rax)
	movq -16(%rbp),%rcx
	movq %rcx,64(%rax)
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-469711246,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %ebx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq $0,56(%rax)
	movq _current_func(%rip),%rcx
L541:
	movq %rcx,64(%rax)
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
	movl 80(%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %ebx,88(%r12)
	andl $4290773023,%eax
	orl $8192,%eax
	movl %eax,80(%r12)
L283:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
L545:
	.int 603988318
	.int 604013663
	.int 604030560
	.int 604047457
.text

_table0:
L542:
	pushq %rbp
	movq %rsp,%rbp
	subq $72,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L543:
	movq %rdi,%r13
	movl %esi,-48(%rbp)
	movl 80(%r13),%r12d
	shll $10,%r12d
	shrl $15,%r12d
	call _new_block
	movq %rax,-56(%rbp)
	call _new_block
	movq %rax,%rbx
	call _new_block
	movq %rax,-72(%rbp)
	movl $1,%edi
	call _seg
	movl _last_asmlab(%rip),%esi
	leal 1(%rsi),%eax
	movl %eax,_last_asmlab(%rip)
	incl %esi
	movl $_void_type,%edi
	call _anon_static
	movq %rax,-32(%rbp)
	movq %r12,%rdi
	call _t_size
	pushq %rax
	pushq $L286
	call _out
	addq $16,%rsp
	pushq -32(%rbp)
	pushq $L290
	call _out
	addq $16,%rsp
	movl $1,%r14d
	jmp L546
L547:
	movq 64(%r13),%rcx
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rax
	shlq $3,%rax
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r12,%rdi
	call _out_word
	addq $8,%rsp
	incl %r14d
L546:
	movl 60(%r13),%eax
	decl %eax
	cmpl %eax,%r14d
	jle L547
L549:
	movl _last_asmlab(%rip),%esi
	leal 1(%rsi),%eax
	movl %eax,_last_asmlab(%rip)
	incl %esi
	movl $_void_type,%edi
	call _anon_static
	movq %rax,-40(%rbp)
	cmpl $0,-48(%rbp)
	movl $2,%eax
	movl $4,%ecx
	cmovzl %eax,%ecx
	pushq %rcx
	pushq $L286
	call _out
	addq $16,%rsp
	pushq -40(%rbp)
	pushq $L290
	call _out
	addq $16,%rsp
	movl $1,%r14d
	jmp L553
L554:
	movq 64(%r13),%rcx
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rax
	shlq $3,%rax
	movl -48(%rbp),%esi
	movq 16(%rcx,%rax),%rdi
	call _target0
	incl %r14d
L553:
	movl 60(%r13),%eax
	decl %eax
	cmpl %eax,%r14d
	jle L554
L556:
	movq %r13,%rdi
	call _control0
	movl %eax,-44(%rbp)
	movl $256,%edi
	call _temp_reg
	movl %eax,-60(%rbp)
	movl $64,%edi
	call _temp_reg
	movl %eax,%r15d
	xorl %esi,%esi
	movl $-1610561978,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %r15d,16(%rax)
	movq $0,-8(%rbp)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -8(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movq %r13,%rsi
	movq %rax,%rdi
	call _append_insn
	movq %r12,%rdi
	call _t_size
	bsrl %eax,%ecx
	xorl $31,%ecx
	movslq %ecx,%rcx
	movl $31,%eax
	subq %rcx,%rax
	xorl %esi,%esi
	movl L545(,%rax,4),%edi
	call _new_insn
	movq %rax,%r14
	movl 8(%r14),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r14)
	movl -44(%rbp),%eax
	movl %eax,16(%r14)
	movl 40(%r14),%eax
	andl $4294967288,%eax
	orl $3,%eax
	movl %eax,40(%r14)
	movl $0,48(%r14)
	movl %r15d,52(%r14)
	movq %r12,%rdi
	call _t_size
	bsrl %eax,%eax
	xorl $31,%eax
	movl $31,%ecx
	subl %eax,%ecx
	andl $3,%ecx
	shll $3,%ecx
	movl 40(%r14),%eax
	andl $4294967271,%eax
	orl %ecx,%eax
	movl %eax,40(%r14)
	movq $0,56(%r14)
	movq -32(%rbp),%rax
	movq %rax,64(%r14)
	movq -56(%rbp),%rsi
	movq %r14,%rdi
	call _append_insn
	movq %rbx,%rdx
	xorl %esi,%esi
	movq -56(%rbp),%rdi
	call _add_succ
	movq -72(%rbp),%rdx
	movl $1,%esi
	movq -56(%rbp),%rdi
	call _add_succ
	xorl %esi,%esi
	movl $-469711246,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %r15d,16(%rax)
	movq $1,-16(%rbp)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -16(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movq -72(%rbp),%rsi
	movq %rax,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $604030560,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl %r15d,16(%rax)
	movl 60(%r13),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq %rcx,-24(%rbp)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq -24(%rbp),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movq -72(%rbp),%rsi
	movq %rax,%rdi
	call _append_insn
	movq -56(%rbp),%rdx
	movl $11,%esi
	movq -72(%rbp),%rdi
	call _add_succ
	movq 64(%r13),%rax
	movq 16(%rax),%rdx
	movl $10,%esi
	movq -72(%rbp),%rdi
	call _add_succ
	cmpl $0,-48(%rbp)
	jz L687
L686:
	xorl %esi,%esi
	movl $-1610561978,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl -60(%rbp),%ecx
	movl %ecx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $3,%ecx
	movl $0,48(%rax)
	movl %r15d,52(%rax)
	andl $4294967271,%ecx
	orl $16,%ecx
	movl %ecx,40(%rax)
	movq $0,56(%rax)
	movq -40(%rbp),%rcx
	jmp L790
L687:
	xorl %esi,%esi
	movl $-1610578352,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl -60(%rbp),%ecx
	movl %ecx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $3,%ecx
	movl $0,48(%rax)
	movl %r15d,52(%rax)
	andl $4294967271,%ecx
	orl $8,%ecx
	movl %ecx,40(%rax)
	movq $0,56(%rax)
	movq -40(%rbp),%rcx
	movq %rcx,64(%rax)
	movq %rbx,%rsi
	movq %rax,%rdi
	call _append_insn
	xorl %esi,%esi
	movl $-469711246,%edi
	call _new_insn
	movl 8(%rax),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rax)
	movl -60(%rbp),%ecx
	movl %ecx,16(%rax)
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq $0,56(%rax)
	movq _current_func(%rip),%rcx
L790:
	movq %rcx,64(%rax)
	movq %rbx,%rsi
	movq %rax,%rdi
	call _append_insn
	movq %r13,%rsi
	movq %rbx,%rdi
	call _dup_succs
	movl 80(%rbx),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl -60(%rbp),%eax
	movl %eax,88(%rbx)
	andl $4290773023,%ecx
	orl $8192,%ecx
	movl %ecx,80(%rbx)
	movq %r13,%rdi
	call _remove_succs
	movq -56(%rbp),%rdx
	movl $12,%esi
	movq %r13,%rdi
	call _add_succ
L544:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_mch_switch:
L791:
	pushq %rbx
	pushq %r12
L792:
	call _func_size
	cmpl $2048,%eax
	setg %al
	movzbl %al,%r12d
	movq _all_blocks(%rip),%rbx
	jmp L794
L795:
	movl 4(%rbx),%eax
	testl $1,%eax
	jz L800
L798:
	testl $8,%eax
	jz L802
L801:
	movl %r12d,%esi
	movq %rbx,%rdi
	call _dense1
	jmp L800
L802:
	testl $16,%eax
	jz L800
L804:
	movl %r12d,%esi
	movq %rbx,%rdi
	call _table0
L800:
	movq 112(%rbx),%rbx
L794:
	testq %rbx,%rbx
	jnz L795
L793:
	popq %r12
	popq %rbx
	ret 

L290:
	.byte 37,103,58,10,0
L256:
	.byte 9,46,105,110,116,32,37,76
	.byte 10,0
L257:
	.byte 9,46,115,104,111,114,116,32
	.byte 37,76,45,37,103,10,0
L286:
	.byte 46,97,108,105,103,110,32,37
	.byte 100,10,0

.globl _mch_switch
.globl _qsort
.globl _add_switch_succ
.globl _temp_reg
.globl _new_block
.globl _all_blocks
.globl _case_type
.globl _current_func
.globl _last_asmlab
.globl _normalize_con
.globl _out
.globl _func_size
.globl _void_type
.globl _seg
.globl _add_succ
.globl _dup_succs
.globl _move
.globl _new_insn
.globl _out_word
.globl _append_insn
.globl _con_in_range
.globl _switch_block
.globl _lir_switch
.globl _anon_static
.globl _remove_succs
.globl _unswitch_block
.globl _t_size
