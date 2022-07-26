.data
_flags:
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 25
	.byte 25
	.byte 25
	.byte 25
	.byte 25
	.byte 25
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 12
	.byte 12
	.byte 12
	.byte 12
	.byte 8
	.byte 8
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 8
	.byte 8
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 8
	.byte 8
	.byte 4
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 4
	.byte 4
	.byte 4
	.byte 4
	.byte 4
	.byte 4
	.byte 4
	.byte 4
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 2
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 10
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 16
	.byte 8
	.byte 8
	.byte 8
	.byte 8
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 8
	.byte 8
	.byte 4
	.byte 0
.text

_load0:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%r13
	movl %esi,%r12d
	movq 16(%r13),%rax
	movslq %r12d,%rbx
	movq (%rax,%rbx,8),%rdi
	movl 8(%rdi),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $1,%ecx
	jnz L21
L7:
	leaq 40(%rdi),%rdx
	movl 40(%rdi),%ecx
	andl $7,%ecx
	cmpl $3,%ecx
	jnz L21
L4:
	shll $10,%eax
	shrl $15,%eax
	movq %rax,_t(%rip)
	movl 16(%rdi),%eax
	movl %eax,_reg(%rip)
	movq %rdx,_mem(%rip)
	addq $40,%rdi
	call _normalize_operand
	movq _mem(%rip),%rcx
	movl 8(%rcx),%eax
	movl _reg(%rip),%esi
	cmpl %eax,%esi
	jz L21
L14:
	cmpl 12(%rcx),%esi
	jnz L13
L21:
	xorl %eax,%eax
	jmp L3
L13:
	movl %r12d,%edx
	movq %r13,%rdi
	call _range_by_def
	movl %eax,%esi
	movq %r13,%rdi
	call _range_span
	movl %eax,_span(%rip)
	movq 16(%r13),%rax
	leaq (%rax,%rbx,8),%rax
	movq %rax,_load(%rip)
	movl $1,%eax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_write0:
L22:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L23:
	movq %rdi,%r15
	movl %esi,-24(%rbp)
	movq 16(%r15),%rdx
	movslq -24(%rbp),%rax
	movq (%rdx,%rax,8),%r14
	movl -24(%rbp),%ebx
	incl %ebx
	cmpl 12(%r15),%ebx
	jz L105
L27:
	movl (%r14),%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl $2,%eax
	jnz L31
L29:
	movl 40(%r14),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $3,%ecx
	jz L105
L34:
	cmpl $2,%ecx
	jnz L31
L43:
	testl $2121728,%eax
	jz L31
L39:
	movq 56(%r14),%rax
	cmpq $-2147483648,%rax
	jl L105
L47:
	cmpq $2147483647,%rax
	jg L105
L31:
	movl 8(%r14),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L105
L54:
	movl 16(%r14),%r13d
	shll $10,%edi
	shrl $15,%edi
	movslq %ebx,%rax
	movq %rax,-8(%rbp)
	movq -8(%rbp),%rax
	movq (%rdx,%rax,8),%r12
	movl (%r12),%eax
	movzbq %al,%rax
	testb $1,_flags(%rax)
	jz L105
L71:
	movl 40(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L105
L67:
	cmpl 48(%r12),%r13d
	jnz L105
L63:
	movl 8(%r12),%edx
	movl %edx,%eax
	andl $7,%eax
	cmpl $3,%eax
	jnz L105
L59:
	testq $73726,%rdi
	jz L105
L79:
	testl $2359232,%edx
	jz L105
L75:
	movl %edx,%eax
	shll $10,%eax
	shrl $15,%eax
	cmpq %rax,%rdi
	jz L58
L83:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testl $229376,%edx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L105
L87:
	call _t_size
	movl %eax,-16(%rbp)
	movl 8(%r12),%edi
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	cmpl %eax,-16(%rbp)
	jnz L105
L58:
	movl -24(%rbp),%edx
	movl %r13d,%esi
	movq %r15,%rdi
	call _range_by_def
	movl %eax,%esi
	movq %r15,%rdi
	call _range_span
	cmpl %eax,%ebx
	jnz L105
L94:
	leaq 8(%r12),%rdi
	call _normalize_operand
	cmpl 16(%r12),%r13d
	jz L105
L99:
	cmpl 20(%r12),%r13d
	jnz L98
L105:
	xorl %eax,%eax
	jmp L24
L98:
	movl $32,%ecx
	leaq 8(%r12),%rsi
	leaq 8(%r14),%rdi
	rep 
	movsb 
	movq 16(%r15),%rcx
	movq -8(%rbp),%rax
	movq $_nop_insn,(%rcx,%rax,8)
	movl $1,%eax
L24:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_read0:
L106:
	pushq %rbx
	pushq %r12
L107:
	movq 16(%rdi),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%rbx
	movl (%rbx),%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl $2,%eax
	jnz L111
L109:
	movl 40(%rbx),%eax
	andl $7,%eax
	cmpl $3,%eax
	jz L153
L114:
	cmpl $1,%eax
	jnz L111
L119:
	movl 48(%rbx),%eax
	cmpl _reg(%rip),%eax
	jz L153
L111:
	movl 8(%rbx),%edx
	movl %edx,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L153
L131:
	movl 16(%rbx),%eax
	cmpl %eax,_reg(%rip)
	jnz L153
L127:
	movq _t(%rip),%rdi
	testq $73726,%rdi
	jz L153
L139:
	testl $2359232,%edx
	jz L153
L135:
	movl %edx,%eax
	shll $10,%eax
	shrl $15,%eax
	cmpq %rax,%rdi
	jz L124
L143:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testl $229376,%edx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L153
L147:
	call _t_size
	movl %eax,%r12d
	movl 8(%rbx),%edi
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	cmpl %eax,%r12d
	jz L124
L153:
	xorl %eax,%eax
	jmp L108
L124:
	movl $32,%ecx
	movq _mem(%rip),%rsi
	leaq 8(%rbx),%rdi
	rep 
	movsb 
	movq _load(%rip),%rax
	movq $_nop_insn,(%rax)
	movl $1,%eax
L108:
	popq %r12
	popq %rbx
	ret 


_read1:
L154:
	pushq %rbx
	pushq %r12
L155:
	movq 16(%rdi),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%rbx
	movl 8(%rbx),%ecx
	andl $7,%ecx
	cmpl $3,%ecx
	jz L205
L159:
	movl (%rbx),%eax
	testl $2147483648,%eax
	jz L161
L164:
	testl $1073741824,%eax
	jz L163
L161:
	cmpl $1,%ecx
	jnz L163
L171:
	movl 16(%rbx),%eax
	cmpl _reg(%rip),%eax
	jz L205
L163:
	movl 40(%rbx),%edx
	movl %edx,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L205
L183:
	movl 48(%rbx),%eax
	cmpl %eax,_reg(%rip)
	jnz L205
L179:
	movq _t(%rip),%rdi
	testq $73726,%rdi
	jz L205
L191:
	testl $2359232,%edx
	jz L205
L187:
	movl %edx,%eax
	shll $10,%eax
	shrl $15,%eax
	cmpq %rax,%rdi
	jz L176
L195:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testl $229376,%edx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L205
L199:
	call _t_size
	movl %eax,%r12d
	movl 40(%rbx),%edi
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	cmpl %eax,%r12d
	jz L176
L205:
	xorl %eax,%eax
	jmp L156
L176:
	movl $32,%ecx
	movq _mem(%rip),%rsi
	leaq 40(%rbx),%rdi
	rep 
	movsb 
	movq _load(%rip),%rax
	movq $_nop_insn,(%rax)
	movl $1,%eax
L156:
	popq %r12
	popq %rbx
	ret 


_update0:
L206:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L207:
	movq %rdi,%r15
	movl %esi,%r14d
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r13
	leal 1(%r14),%r12d
	cmpl 12(%r15),%r12d
	jz L277
L211:
	movslq %r12d,%rax
	movq %rax,-8(%rbp)
	movq -8(%rbp),%rax
	movq (%rcx,%rax,8),%rbx
	movl (%rbx),%ecx
	movq _load(%rip),%rax
	movq (%rax),%rax
	cmpl (%rax),%ecx
	jnz L277
L215:
	movq _mem(%rip),%rsi
	leaq 8(%rbx),%rdi
	call _same_operand
	testl %eax,%eax
	jz L277
L219:
	movl 40(%rbx),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L277
L223:
	movl 48(%rbx),%eax
	movl _reg(%rip),%esi
	cmpl %esi,%eax
	jnz L277
L227:
	movl %r14d,%edx
	movq %r15,%rdi
	call _range_by_def
	movl %eax,%esi
	movq %r15,%rdi
	call _range_span
	cmpl %eax,%r12d
	jnz L277
L231:
	movl (%r13),%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl $2,%eax
	jnz L235
L233:
	movl 40(%r13),%eax
	andl $7,%eax
	cmpl $3,%eax
	jz L277
L238:
	cmpl $1,%eax
	jnz L235
L243:
	movl 48(%r13),%eax
	cmpl %eax,_reg(%rip)
	jz L277
L235:
	movl 8(%r13),%edx
	movl %edx,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L277
L255:
	movl 16(%r13),%eax
	cmpl %eax,_reg(%rip)
	jnz L277
L251:
	movq _t(%rip),%rdi
	testq $73726,%rdi
	jz L277
L263:
	testl $2359232,%edx
	jz L277
L259:
	movl %edx,%eax
	shll $10,%eax
	shrl $15,%eax
	cmpq %rax,%rdi
	jz L248
L267:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testl $229376,%edx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L277
L271:
	call _t_size
	movl %eax,%ebx
	movl 8(%r13),%edi
	shll $10,%edi
	shrl $15,%edi
	call _t_size
	cmpl %eax,%ebx
	jz L248
L277:
	xorl %eax,%eax
	jmp L208
L248:
	movl $32,%ecx
	movq _mem(%rip),%rsi
	leaq 8(%r13),%rdi
	rep 
	movsb 
	movq _load(%rip),%rax
	movq $_nop_insn,(%rax)
	movq 16(%r15),%rcx
	movq -8(%rbp),%rax
	movq $_nop_insn,(%rcx,%rax,8)
	movl $1,%eax
L208:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_fuse0:
L278:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L279:
	movq %rdi,%r13
	movq $0,_load(%rip)
	xorl %r12d,%r12d
L281:
	cmpl 12(%r13),%r12d
	jge L287
L285:
	movq 16(%r13),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	testq %rbx,%rbx
	jz L287
L286:
	movl (%rbx),%eax
	movzbq %al,%rax
	movsbl _flags(%rax),%r14d
	testl $1,%r14d
	jz L294
L292:
	movl %r12d,%esi
	movq %r13,%rdi
	call _load0
	testl %eax,%eax
	jnz L283
L294:
	cmpq $0,_load(%rip)
	jz L299
L300:
	cmpl _span(%rip),%r12d
	jnz L299
L301:
	testl $2,%r14d
	jz L309
L307:
	movl %r12d,%esi
	movq %r13,%rdi
	call _update0
	testl %eax,%eax
	jnz L368
L309:
	testl $8,%r14d
	jz L317
L315:
	movl %r12d,%esi
	movq %r13,%rdi
	call _read1
	testl %eax,%eax
	jnz L368
L317:
	testl $4,%r14d
	jz L299
L323:
	movl %r12d,%esi
	movq %r13,%rdi
	call _read0
	testl %eax,%eax
	jnz L368
L299:
	testl $16,%r14d
	jz L333
L331:
	movl %r12d,%esi
	movq %r13,%rdi
	call _write0
	testl %eax,%eax
	jnz L368
L333:
	cmpq $0,_load(%rip)
	jz L283
L336:
	testl $16777216,(%rbx)
	jnz L346
L342:
	movq %rbx,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L346
L344:
	cmpl $0,_tmp_regs(%rip)
	jl L352
L351:
	movl $0,_tmp_regs+4(%rip)
	jmp L353
L352:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L353:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_defs
	movq _mem(%rip),%rax
	movl 8(%rax),%esi
	movl $_tmp_regs,%edi
	call _contains_reg
	testl %eax,%eax
	jnz L346
L357:
	movq _mem(%rip),%rax
	movl 12(%rax),%esi
	movl $_tmp_regs,%edi
	call _contains_reg
	testl %eax,%eax
	jnz L346
L359:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %rbx,%rdi
	call _insn_uses
	movl _reg(%rip),%esi
	movl $_tmp_regs,%edi
	call _contains_reg
	testl %eax,%eax
	jz L283
L346:
	movq $0,_load(%rip)
L283:
	incl %r12d
	jmp L281
L368:
	movl $1,%eax
	jmp L280
L287:
	xorl %eax,%eax
L280:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_opt_mch_fuse:
L369:
	pushq %rbx
L372:
	movl $1,%edi
	call _live_analyze
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movq _all_blocks(%rip),%rbx
L376:
	testq %rbx,%rbx
	jz L387
L377:
	movq %rbx,%rdi
	call _fuse0
	testl %eax,%eax
	jnz L383
L382:
	movq 112(%rbx),%rbx
	jmp L376
L383:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
	jmp L372
L387:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L371:
	popq %rbx
	ret 

.local _load
.comm _load, 8, 8
.local _t
.comm _t, 8, 8
.local _reg
.comm _reg, 4, 4
.local _span
.comm _span, 4, 4
.local _mem
.comm _mem, 8, 8
.local _tmp_regs
.comm _tmp_regs, 24, 8

.globl _nop_insn
.globl _all_blocks
.globl _insn_defs_mem0
.globl _range_span
.globl _opt_mch_fuse
.globl _range_by_def
.globl _contains_reg
.globl _live_analyze
.globl _same_operand
.globl _normalize_operand
.globl _local_arena
.globl _vector_insert
.globl _insn_defs
.globl _insn_uses
.globl _t_size
