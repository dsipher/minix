.text
.align 4
L82:
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
.align 2
L83:
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
.align 2
L84:
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval
	.short L50-_eval

_eval:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq %rdi,%r14
	cmpl $0,_defd_regs(%rip)
	jl L8
L7:
	movl $0,_defd_regs+4(%rip)
	jmp L9
L8:
	movl _defd_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_defd_regs,%edi
	call _vector_insert
L9:
	xorl %r13d,%r13d
L10:
	cmpl 12(%r14),%r13d
	jge L3
L14:
	movq 16(%r14),%rax
	movslq %r13d,%r12
	movq (%rax,%r12,8),%rbx
	testq %rbx,%rbx
	jz L3
L15:
	movl 4(%rbx),%eax
	testl $1,%eax
	jnz L21
L20:
	testl $2,%eax
	jnz L21
L25:
	movl (%rbx),%eax
	cmpl $-1275068398,%eax
	jl L76
L78:
	cmpl $-1275068393,%eax
	jg L76
L75:
	addl $1275068398,%eax
	movzwl L84(,%rax,2),%eax
	addl $_eval,%eax
	jmp *%rax
L76:
	xorl %ecx,%ecx
L79:
	cmpl L82(,%rcx,4),%eax
	jz L80
L81:
	incl %ecx
	cmpl $12,%ecx
	jb L79
	jae L21
L80:
	movzwl L83(,%rcx,2),%eax
	addl $_eval,%eax
	jmp *%rax
L50:
	cmpl $0,_tmp_regs(%rip)
	jl L54
L53:
	movl $0,_tmp_regs+4(%rip)
	jmp L55
L54:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L55:
	cmpl $0,_tmp2_regs(%rip)
	jl L60
L59:
	movl $0,_tmp2_regs+4(%rip)
	jmp L61
L60:
	movl _tmp2_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp2_regs,%edi
	call _vector_insert
L61:
	movl $33554432,%edx
	movl $_tmp2_regs,%esi
	movq %rbx,%rdi
	call _insn_uses
	movl $_defd_regs,%edx
	movl $_tmp2_regs,%esi
	movl $_tmp_regs,%edi
	call _intersect_regs
	cmpl $0,_tmp_regs+4(%rip)
	jnz L21
L69:
	movl 556(%r14),%esi
	leal 1(%rsi),%eax
	cmpl 552(%r14),%eax
	jge L73
L72:
	movl %eax,556(%r14)
	jmp L74
L73:
	movl $8,%ecx
	movl $1,%edx
	leaq 552(%r14),%rdi
	call _vector_insert
L74:
	movq 16(%r14),%rax
	leaq (%rax,%r12,8),%rdx
	movq 560(%r14),%rcx
	movl 556(%r14),%eax
	decl %eax
	movslq %eax,%rax
	movq %rdx,(%rcx,%rax,8)
L21:
	movl $16777216,%edx
	movl $_defd_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	incl %r13d
	jmp L10
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_match:
L85:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L86:
	movq %rdi,%r15
	movq %rsi,%r14
	xorl %r13d,%r13d
L88:
	cmpl 556(%r15),%r13d
	jge L91
L89:
	movq 560(%r15),%rcx
	movslq %r13d,%rax
	movq %rax,-8(%rbp)
	movq -8(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq (%rax),%r12
	movl (%r12),%eax
	cmpl (%r14),%eax
	jnz L90
L94:
	movl 16(%r14),%ecx
	movl %ecx,-12(%rbp)
	movl 16(%r12),%ebx
	movl $0,16(%r14)
	movl $0,16(%r12)
	movq %r12,%rsi
	movq %r14,%rdi
	call _same_insn
	movl -12(%rbp),%ecx
	movl %ecx,16(%r14)
	movl %ebx,16(%r12)
	testl %eax,%eax
	jnz L96
L90:
	incl %r13d
	jmp L88
L96:
	movq 560(%r15),%rcx
	movq -8(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,576(%r15)
	movl $1,%eax
	jmp L87
L91:
	xorl %eax,%eax
L87:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_hoist0:
L101:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L102:
	movq %rdi,%r15
	cmpl $1,60(%r15)
	jle L107
L106:
	xorl %edx,%edx
L109:
	cmpl 60(%r15),%edx
	jge L112
L110:
	movq 64(%r15),%rcx
	movslq %edx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rax
	cmpl $1,36(%rax)
	jnz L107
L115:
	incl %edx
	jmp L109
L112:
	movl 12(%r15),%r13d
	cmpl $0,_defd_regs(%rip)
	jl L121
L120:
	movl $0,_defd_regs+4(%rip)
	jmp L122
L121:
	movl _defd_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_defd_regs,%edi
	call _vector_insert
L122:
	movq %r15,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L125
L126:
	testl %r13d,%r13d
	jz L107
L132:
	leal -1(%r13),%eax
	movl %eax,%r13d
	movq 16(%r15),%rcx
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rbx
	movl $16777216,%edx
	movl $_defd_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	cmpl $603979787,(%rbx)
	jnz L126
L125:
	movq 64(%r15),%rax
	movq 16(%rax),%rax
	movq %rax,-8(%rbp)
	movl $0,-12(%rbp)
L138:
	movq -8(%rbp),%rcx
	movl -12(%rbp),%eax
	cmpl 556(%rcx),%eax
	jge L107
L139:
	movq -8(%rbp),%rax
	movq 560(%rax),%rcx
	movslq -12(%rbp),%rax
	movq (%rcx,%rax,8),%rcx
	movq -8(%rbp),%rax
	movq %rcx,576(%rax)
	movq (%rcx),%rbx
	cmpl $0,_tmp_regs(%rip)
	jl L146
L145:
	movl $0,_tmp_regs+4(%rip)
	jmp L147
L146:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L147:
	cmpl $0,_tmp2_regs(%rip)
	jl L152
L151:
	movl $0,_tmp2_regs+4(%rip)
	jmp L153
L152:
	movl _tmp2_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp2_regs,%edi
	call _vector_insert
L153:
	movl $33554432,%edx
	movl $_tmp2_regs,%esi
	movq %rbx,%rdi
	call _insn_uses
	movl $_defd_regs,%edx
	movl $_tmp2_regs,%esi
	movl $_tmp_regs,%edi
	call _intersect_regs
	cmpl $0,_tmp_regs+4(%rip)
	jnz L157
L156:
	movl $1,%r12d
L159:
	cmpl 60(%r15),%r12d
	jge L162
L160:
	movq 64(%r15),%rcx
	movslq %r12d,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq %rbx,%rsi
	movq 16(%rcx,%rax),%rdi
	call _match
	testl %eax,%eax
	jz L157
L165:
	incl %r12d
	jmp L159
L162:
	movq %rbx,%rdi
	call _dup_insn
	movq %rax,%rbx
	movl 8(%rbx),%edi
	shll $10,%edi
	shrl $15,%edi
	call _temp_reg
	movl %eax,%r12d
	movl %r12d,16(%rbx)
	movl %r13d,%edx
	movq %r15,%rsi
	movq %rbx,%rdi
	call _insert_insn
	incl %r13d
	xorl %r14d,%r14d
L167:
	cmpl 60(%r15),%r14d
	jge L170
L168:
	movq 64(%r15),%rcx
	movslq %r14d,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rbx
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq 576(%rbx),%rcx
	movq (%rcx),%rsi
	movl $32,%ecx
	addq $8,%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 8(%rax),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	movl %r12d,48(%rax)
	movl 4(%rax),%ecx
	andl $-3,%ecx
	orl $2,%ecx
	movl %ecx,4(%rax)
	movq 576(%rbx),%rcx
	movq %rax,(%rcx)
	incl %r14d
	jmp L167
L170:
	orl $132,_opt_request(%rip)
L157:
	incl -12(%rbp)
	jmp L138
L107:
	movq %r15,%rdi
	call _eval
L103:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_opt_lir_hoist:
L171:
L174:
	movl $0,_defd_regs(%rip)
	movl $0,_defd_regs+4(%rip)
	movq $0,_defd_regs+8(%rip)
	movq $_local_arena,_defd_regs+16(%rip)
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movl $0,_tmp2_regs(%rip)
	movl $0,_tmp2_regs+4(%rip)
	movq $0,_tmp2_regs+8(%rip)
	movq $_local_arena,_tmp2_regs+16(%rip)
	movq _all_blocks(%rip),%rax
L183:
	testq %rax,%rax
	jz L186
L187:
	movl $0,552(%rax)
	movl $0,556(%rax)
	movq $0,560(%rax)
	movq $_local_arena,568(%rax)
	movq 112(%rax),%rax
	jmp L183
L186:
	movl $_hoist0,%edx
	xorl %esi,%esi
	xorl %edi,%edi
	call _walk_blocks
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L173:
	ret 

.local _defd_regs
.comm _defd_regs, 24, 8
.local _tmp_regs
.comm _tmp_regs, 24, 8
.local _tmp2_regs
.comm _tmp2_regs, 24, 8

.globl _temp_reg
.globl _all_blocks
.globl _opt_lir_hoist
.globl _opt_request
.globl _walk_blocks
.globl _conditional_block
.globl _local_arena
.globl _new_insn
.globl _vector_insert
.globl _same_insn
.globl _dup_insn
.globl _insn_defs
.globl _insn_uses
.globl _intersect_regs
.globl _insert_insn
