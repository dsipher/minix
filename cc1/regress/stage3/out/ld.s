.data
.align 8
_aout:
	.quad L1
.align 4
_outfd:
	.int -1
.align 4
_base:
	.int 1572864
.text

_error:
L2:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L3:
	movq 16(%rbp),%rax
	movq %rax,16(%rbp)
	pushq $L5
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	leaq 24(%rbp),%r12
	jmp L6
L7:
	cmpb $37,%dil
	jnz L38
L10:
	leaq 1(%rcx),%rax
	movq %rax,16(%rbp)
	movb 1(%rcx),%dil
	cmpb $115,%dil
	jz L15
L31:
	cmpb $69,%dil
	jz L18
L32:
	cmpb $79,%dil
	jz L20
L38:
	movsbl %dil,%edi
	movl $___stderr,%esi
	call _fputc
	jmp L11
L20:
	addq $8,%r12
	movq -8(%r12),%rbx
	pushq (%rbx)
	pushq $L21
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movq 8(%rbx),%rax
	testq %rax,%rax
	jz L11
L22:
	pushq %rax
	pushq $L25
	jmp L36
L18:
	movl _errno(%rip),%edi
	call _strerror
	pushq %rax
	jmp L37
L15:
	addq $8,%r12
	pushq -8(%r12)
L37:
	pushq $L16
L36:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L11:
	incq 16(%rbp)
L6:
	movq 16(%rbp),%rcx
	movb (%rcx),%dil
	testb %dil,%dil
	jnz L7
L8:
	movl $___stderr,%esi
	movl $10,%edi
	call _fputc
	cmpl $-1,_outfd(%rip)
	jz L29
L27:
	movq _aout(%rip),%rdi
	call _unlink
L29:
	movl $1,%edi
	call _exit
L4:
	popq %r12
	popq %rbx
	popq %rbp
	ret 


_alloc:
L39:
	pushq %rbx
	pushq %r12
	pushq %r13
L40:
	movq %rdi,%r13
	movl %esi,%r12d
	movq %r13,%rdi
	call _malloc
	movq %rax,%rbx
	testq %r13,%r13
	jz L44
L45:
	testq %rbx,%rbx
	jnz L44
L42:
	pushq $L49
	call _error
	addq $8,%rsp
L44:
	testl %r12d,%r12d
	jz L52
L50:
	movq %rbx,%rcx
	jmp L53
L54:
	movb $0,(%rcx)
	incq %rcx
L53:
	movq %r13,%rax
	decq %r13
	testq %rax,%rax
	jnz L54
L52:
	movq %rbx,%rax
L41:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
L61:
	.quad _objects
.text

_new_object:
L58:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L59:
	movq %rdi,%r14
	movq %rsi,%r13
	movq %rdx,%r12
	xorl %esi,%esi
	movl $88,%edi
	call _alloc
	movq %rax,%rbx
	movq %r14,(%rbx)
	movq %r13,8(%rbx)
	movl $0,16(%rbx)
	movq %r12,24(%rbx)
	cmpl $383131371,(%r12)
	jz L64
L62:
	pushq %rbx
	pushq $L65
	call _error
	addq $16,%rsp
L64:
	movq 24(%rbx),%rax
	cmpl $383131371,(%rax)
	movl $0,%ecx
	movl $32,%edx
	cmovnzq %rcx,%rdx
	addq %r12,%rdx
	movq %rdx,32(%rbx)
	movl (%rax),%edx
	cmpl $383131371,%edx
	movl $0,%ecx
	movl $32,%esi
	cmovnzq %rcx,%rsi
	addl 4(%rax),%esi
	cmpl $397942507,%edx
	jnz L74
L72:
	movl %esi,%edx
	andl $4095,%edx
	jz L74
L75:
	movl $4096,%ecx
	subl %edx,%ecx
	addl %ecx,%esi
L74:
	movl %esi,%ecx
	addq %r12,%rcx
	movq %rcx,40(%rbx)
	movl (%rax),%edi
	cmpl $383131371,%edi
	movl $0,%ecx
	movl $32,%esi
	cmovnzq %rcx,%rsi
	addl 4(%rax),%esi
	cmpl $397942507,%edi
	jnz L83
L81:
	movl %esi,%edx
	andl $4095,%edx
	jz L83
L84:
	movl $4096,%ecx
	subl %edx,%ecx
	addl %ecx,%esi
L83:
	movl 8(%rax),%ecx
	addl %esi,%ecx
	cmpl $397942507,%edi
	jnz L89
L87:
	movl %ecx,%esi
	andl $4095,%esi
	jz L89
L90:
	movl $4096,%edx
	subl %esi,%edx
	addl %edx,%ecx
L89:
	addq %r12,%rcx
	movq %rcx,56(%rbx)
	movl (%rax),%edi
	cmpl $383131371,%edi
	movl $0,%ecx
	movl $32,%esi
	cmovnzq %rcx,%rsi
	addl 4(%rax),%esi
	cmpl $397942507,%edi
	jnz L98
L96:
	movl %esi,%edx
	andl $4095,%edx
	jz L98
L99:
	movl $4096,%ecx
	subl %edx,%ecx
	addl %ecx,%esi
L98:
	movl 8(%rax),%edx
	addl %esi,%edx
	cmpl $397942507,%edi
	jnz L104
L102:
	movl %edx,%esi
	andl $4095,%esi
	jz L104
L105:
	movl $4096,%ecx
	subl %esi,%ecx
	addl %ecx,%edx
L104:
	movl 16(%rax),%ecx
	shlq $4,%rcx
	addq %rcx,%rdx
	addq %r12,%rdx
	movq %rdx,64(%rbx)
	movl (%rax),%edi
	cmpl $383131371,%edi
	movl $0,%ecx
	movl $32,%esi
	cmovnzq %rcx,%rsi
	addl 4(%rax),%esi
	cmpl $397942507,%edi
	jnz L113
L111:
	movl %esi,%edx
	andl $4095,%edx
	jz L113
L114:
	movl $4096,%ecx
	subl %edx,%ecx
	addl %ecx,%esi
L113:
	movl 8(%rax),%edx
	addl %esi,%edx
	cmpl $397942507,%edi
	jnz L119
L117:
	movl %edx,%esi
	andl $4095,%esi
	jz L119
L120:
	movl $4096,%ecx
	subl %esi,%ecx
	addl %ecx,%edx
L119:
	movl 16(%rax),%ecx
	shlq $4,%rcx
	addq %rcx,%rdx
	movl 20(%rax),%ecx
	shlq $3,%rcx
	addq %rcx,%rdx
	movl 24(%rax),%ecx
	addq %rcx,%rdx
	movl 28(%rax),%eax
	addq %rax,%rdx
	addq %rdx,%r12
	movq %r12,72(%rbx)
	leaq 80(%rbx),%rcx
	movq $0,80(%rbx)
	movq L61(%rip),%rax
	movq %rbx,(%rax)
	movq %rcx,L61(%rip)
L60:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_pass1:
L123:
	pushq %rbp
	movq %rsp,%rbp
	subq $144,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L124:
	movq %rdi,%r13
	jmp L126
L127:
	pushq $0
	pushq %r12
	call _open
	movl %eax,%r14d
	addq $16,%rsp
	cmpl $-1,%r14d
	jnz L132
L130:
	pushq %r12
	pushq $L133
	call _error
	addq $16,%rsp
L132:
	leaq -144(%rbp),%rsi
	movl %r14d,%edi
	call _fstat
	cmpl $-1,%eax
	jnz L136
L134:
	pushq %r12
	pushq $L137
	call _error
	addq $16,%rsp
L136:
	movl -120(%rbp),%eax
	andl $61440,%eax
	cmpl $32768,%eax
	jz L140
L138:
	pushq %r12
	pushq $L141
	call _error
	addq $16,%rsp
L140:
	xorl %esi,%esi
	movq -96(%rbp),%rdi
	call _alloc
	movq %rax,%rbx
	movq -96(%rbp),%rdx
	movq %rbx,%rsi
	movl %r14d,%edi
	call _read
	cmpq -96(%rbp),%rax
	jz L144
L142:
	pushq %r12
	pushq $L145
	call _error
	addq $16,%rsp
L144:
	movl %r14d,%edi
	call _close
	movq $4356213840513474878,%rax
	cmpq %rax,(%rbx)
	jnz L147
L146:
	addq $8,%rbx
	subq $8,-96(%rbp)
L149:
	cmpq $0,-96(%rbp)
	jz L148
L150:
	movl $1,%esi
	movl $29,%edi
	call _alloc
	movq %rax,%r14
	movl $28,%edx
	movq %rbx,%rsi
	movq %r14,%rdi
	call _strncpy
	subq $56,-96(%rbp)
	leaq 56(%rbx),%rdx
	movq %r14,%rsi
	movq %r12,%rdi
	call _new_object
	movq 48(%rbx),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L154
L152:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,48(%rbx)
L154:
	movq 48(%rbx),%rax
	leaq 56(%rbx,%rax),%rbx
	subq %rax,-96(%rbp)
	jmp L149
L147:
	movq %rbx,%rdx
	xorl %esi,%esi
	movq %r12,%rdi
	call _new_object
L148:
	addq $8,%r13
L126:
	movq (%r13),%r12
	testq %r12,%r12
	jnz L127
L125:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lookup:
L155:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L156:
	movq %rdi,%r13
	movq %r13,%rdi
	call _strlen
	movl %eax,%r12d
	movl %r12d,%edx
	movq _crc32c(%rip),%rax
	movq %r13,%rsi
	xorl %edi,%edi
	call *%rax
	movl %eax,%ebx
	movl %ebx,%r14d
	andl $511,%r14d
	movl %r14d,%eax
	movq _globls(,%rax,8),%r15
L158:
	testq %r15,%r15
	jz L161
L159:
	cmpl 12(%r15),%ebx
	jnz L164
L169:
	cmpl 8(%r15),%r12d
	jnz L164
L165:
	movl %r12d,%edx
	movq %r13,%rsi
	movq (%r15),%rdi
	call _memcmp
	testl %eax,%eax
	jz L162
L164:
	movq 32(%r15),%r15
	jmp L158
L162:
	movq %r15,%rax
	jmp L157
L161:
	xorl %esi,%esi
	movl $40,%edi
	call _alloc
	movq %r13,(%rax)
	movl %ebx,12(%rax)
	movl %r12d,8(%rax)
	movq $0,24(%rax)
	movq $0,16(%rax)
	movl %r14d,%r14d
	movq _globls(,%r14,8),%rcx
	movq %rcx,32(%rax)
	movq %rax,_globls(,%r14,8)
L157:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_pass2:
L175:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L176:
	movq _objects(%rip),%r12
	jmp L178
L179:
	xorl %ebx,%ebx
L182:
	movq 24(%r12),%rax
	cmpl 16(%rax),%ebx
	jae L185
L183:
	movq 56(%r12),%rcx
	movl %ebx,%eax
	shlq $4,%rax
	leaq (%rcx,%rax),%r14
	movl (%rcx,%rax),%eax
	testl $117440512,%eax
	jz L184
L189:
	testl $134217728,%eax
	jz L184
L188:
	movq 72(%r12),%rdi
	andl $16777215,%eax
	addq %rax,%rdi
	call _lookup
	movq %rax,%r13
	cmpq $0,24(%r13)
	jz L196
L194:
	pushq 16(%r13)
	pushq (%r13)
	pushq %r12
	pushq $L197
	call _error
	addq $32,%rsp
L196:
	movq %r12,16(%r13)
	movq %r14,24(%r13)
L184:
	incl %ebx
	jmp L182
L185:
	movq 80(%r12),%r12
L178:
	testq %r12,%r12
	jnz L179
L177:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_pass3:
L198:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L199:
	movq _objects(%rip),%rax
	orl $1,16(%rax)
L201:
	movl $0,-4(%rbp) # spill
	movq _objects(%rip),%r15
	jmp L204
L205:
	movl 16(%r15),%eax
	testl $1,%eax
	jz L206
L210:
	testl $2,%eax
	jnz L206
L214:
	xorl %r14d,%r14d
L216:
	movq 24(%r15),%rax
	cmpl 16(%rax),%r14d
	jae L219
L217:
	movq 56(%r15),%r13
	movl %r14d,%r12d
	shlq $4,%r12
	movl (%r13,%r12),%eax
	testl $117440512,%eax
	jnz L218
L222:
	movq 72(%r15),%rdi
	andl $16777215,%eax
	addq %rax,%rdi
	call _lookup
	movq %rax,%rbx
	cmpq $0,24(%rbx)
	jnz L226
L224:
	movq 72(%r15),%rcx
	movl (%r13,%r12),%eax
	andl $16777215,%eax
	addq %rax,%rcx
	pushq %rcx
	pushq %r15
	pushq $L227
	call _error
	addq $24,%rsp
L226:
	movq 16(%rbx),%rcx
	movl 16(%rcx),%eax
	testl $1,%eax
	jnz L218
L228:
	orl $1,%eax
	movl %eax,16(%rcx)
	incl -4(%rbp) # spill
L218:
	incl %r14d
	jmp L216
L219:
	orl $2,16(%r15)
L206:
	movq 80(%r15),%r15
L204:
	testq %r15,%r15
	jnz L205
L207:
	cmpl $0,-4(%rbp) # spill
	jnz L201
L200:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_pass4:
L231:
L236:
	movq _objects(%rip),%r8
	jmp L240
L241:
	testl $1,16(%r8)
	jz L242
L246:
	xorl %edi,%edi
L248:
	movq 24(%r8),%rax
	cmpl 16(%rax),%edi
	jae L251
L249:
	movq 56(%r8),%rsi
	movl %edi,%edx
	shlq $4,%rdx
	movl (%rsi,%rdx),%eax
	andl $117440512,%eax
	cmpl $33554432,%eax
	jnz L250
L254:
	movl _address(%rip),%ecx
	addq 8(%rsi,%rdx),%rcx
	movq %rcx,8(%rsi,%rdx)
L250:
	incl %edi
	jmp L248
L251:
	movl _address(%rip),%ecx
	movl %ecx,48(%r8)
	movl 4(%rax),%eax
	addl _address(%rip),%eax
	movl %eax,_address(%rip)
	movq 24(%r8),%rax
	movl 4(%rax),%ecx
	addl _exec+4(%rip),%ecx
	movl %ecx,_exec+4(%rip)
L242:
	movq 80(%r8),%r8
L240:
	testq %r8,%r8
	jnz L241
L233:
	ret 


_pass5:
L256:
L257:
	movl _address(%rip),%edx
	movl %edx,%ecx
	andl $4095,%ecx
	jz L264
L262:
	movl $4096,%eax
	subl %ecx,%eax
	addl %eax,%edx
L264:
	movl %edx,_address(%rip)
	movq _objects(%rip),%r8
	jmp L265
L266:
	testl $1,16(%r8)
	jz L267
L271:
	xorl %edi,%edi
L273:
	movq 24(%r8),%rax
	cmpl 16(%rax),%edi
	jae L276
L274:
	movq 56(%r8),%rsi
	movl %edi,%edx
	shlq $4,%rdx
	movl (%rsi,%rdx),%eax
	andl $117440512,%eax
	cmpl $50331648,%eax
	jnz L275
L279:
	movl _address(%rip),%ecx
	addq 8(%rsi,%rdx),%rcx
	movq %rcx,8(%rsi,%rdx)
L275:
	incl %edi
	jmp L273
L276:
	movl _address(%rip),%ecx
	movl %ecx,52(%r8)
	movl 8(%rax),%eax
	addl _address(%rip),%eax
	movl %eax,_address(%rip)
	movq 24(%r8),%rax
	movl 8(%rax),%ecx
	addl _exec+8(%rip),%ecx
	movl %ecx,_exec+8(%rip)
L267:
	movq 80(%r8),%r8
L265:
	testq %r8,%r8
	jnz L266
L258:
	ret 


_pass6:
L281:
L282:
	movq _objects(%rip),%rdx
	jmp L284
L285:
	testl $1,16(%rdx)
	jz L286
L290:
	xorl %eax,%eax
L292:
	movq 24(%rdx),%rcx
	cmpl 16(%rcx),%eax
	jae L286
L293:
	movq 56(%rdx),%r10
	movl %eax,%r9d
	shlq $4,%r9
	movl (%r10,%r9),%ecx
	movl %ecx,%esi
	andl $117440512,%esi
	cmpl $67108864,%esi
	jnz L294
L298:
	movl 8(%r10,%r9),%r8d
	shll $2,%ecx
	shrl $30,%ecx
	movl _address(%rip),%edi
	movl $1,%esi
	shll %cl,%esi
	movl %esi,%ecx
	decl %ecx
	andl %edi,%ecx
	jz L302
L300:
	subl %ecx,%esi
	addl %esi,%edi
	movl %edi,_address(%rip)
	addl _exec+12(%rip),%esi
	movl %esi,_exec+12(%rip)
L302:
	movl (%r10,%r9),%ecx
	andl $4177526783,%ecx
	orl $50331648,%ecx
	movl %ecx,(%r10,%r9)
	movl _address(%rip),%esi
	movq %rsi,8(%r10,%r9)
	andl $3489660927,%ecx
	movl %ecx,(%r10,%r9)
	addl %r8d,_address(%rip)
	addl _exec+12(%rip),%r8d
	movl %r8d,_exec+12(%rip)
L294:
	incl %eax
	jmp L292
L286:
	movq 80(%rdx),%rdx
L284:
	testq %rdx,%rdx
	jnz L285
L287:
	movl _exec+12(%rip),%edx
	movl %edx,%ecx
	andl $7,%ecx
	jz L305
L303:
	movl $8,%eax
	subl %ecx,%eax
	addl %eax,%edx
L305:
	movl %edx,_exec+12(%rip)
L283:
	ret 


_pass7:
L306:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L307:
	movq _objects(%rip),%r15
	jmp L309
L310:
	testl $1,16(%r15)
	jz L311
L315:
	xorl %r14d,%r14d
L317:
	movq 24(%r15),%rax
	cmpl 20(%rax),%r14d
	jae L311
L318:
	movq 64(%r15),%rax
	movq %rax,-16(%rbp) # spill
	movq -16(%rbp),%rax # spill
	movl (%rax,%r14,8),%edx
	testl $536870912,%edx
	jz L322
L321:
	movq 32(%r15),%r13
	jmp L323
L322:
	movq 40(%r15),%r13
L323:
	movq -16(%rbp),%rax # spill
	movl 4(%rax,%r14,8),%r12d
	movl %edx,%ecx
	shrl $30,%ecx
	movl $1,%ebx
	shll %cl,%ebx
	cmpl $1,%ebx
	jz L327
L356:
	cmpl $2,%ebx
	jz L329
L357:
	cmpl $4,%ebx
	jz L331
L358:
	cmpl $8,%ebx
	jnz L325
L333:
	movq (%r12,%r13),%rax
	jmp L367
L331:
	movslq (%r12,%r13),%rax
	jmp L367
L329:
	movswq (%r12,%r13),%rax
	jmp L367
L327:
	movsbq (%r12,%r13),%rax
L367:
	movq %rax,-8(%rbp) # spill
L325:
	movq 56(%r15),%rax
	andl $268435455,%edx
	shlq $4,%rdx
	leaq (%rax,%rdx),%rcx
	movl (%rax,%rdx),%eax
	testl $117440512,%eax
	jnz L337
L335:
	movq 72(%r15),%rdi
	andl $16777215,%eax
	addq %rax,%rdi
	call _lookup
	movq 24(%rax),%rcx
L337:
	movq 8(%rcx),%rdx
	movq -16(%rbp),%rax # spill
	movl (%rax,%r14,8),%eax
	testl $268435456,%eax
	jz L340
L338:
	testl $536870912,%eax
	jz L342
L341:
	movl 48(%r15),%ecx
	jmp L343
L342:
	movl 52(%r15),%ecx
L343:
	movq -16(%rbp),%rax # spill
	movl 4(%rax,%r14,8),%eax
	addl %ecx,%eax
	addl %ebx,%eax
	subq %rax,%rdx
L340:
	addq -8(%rbp),%rdx # spill
	cmpl $1,%ebx
	jz L347
L362:
	cmpl $2,%ebx
	jz L349
L363:
	cmpl $4,%ebx
	jz L351
L364:
	cmpl $8,%ebx
	jnz L345
L353:
	movq %rdx,(%r12,%r13)
	jmp L345
L351:
	movl %edx,(%r12,%r13)
	jmp L345
L349:
	movw %dx,(%r12,%r13)
	jmp L345
L347:
	movb %dl,(%r12,%r13)
L345:
	incl %r14d
	jmp L317
L311:
	movq 80(%r15),%r15
L309:
	testq %r15,%r15
	jnz L310
L308:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_pass8:
L368:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L369:
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	movq _objects(%rip),%r12
	jmp L371
L372:
	testl $1,16(%r12)
	jz L373
L377:
	xorl %ebx,%ebx
L379:
	movq 24(%r12),%rax
	cmpl 16(%rax),%ebx
	jae L373
L380:
	movq 56(%r12),%rcx
	movl %ebx,%eax
	shlq $4,%rax
	movl (%rcx,%rax),%eax
	testl $117440512,%eax
	jz L381
L386:
	testl $134217728,%eax
	jz L381
L385:
	incl %r14d
	movq 72(%r12),%rdi
	andl $16777215,%eax
	addq %rax,%rdi
	call _strlen
	leaq 1(%rax,%r13),%r13
L381:
	incl %ebx
	jmp L379
L373:
	movq 80(%r12),%r12
L371:
	testq %r12,%r12
	jnz L372
L374:
	movl %r14d,%edi
	shlq $4,%rdi
	xorl %esi,%esi
	call _alloc
	movq %rax,_syms(%rip)
	xorl %esi,%esi
	movq %r13,%rdi
	call _alloc
	movq %rax,_strtab(%rip)
	movq _objects(%rip),%r14
	jmp L391
L392:
	testl $1,16(%r14)
	jz L393
L397:
	xorl %r13d,%r13d
L399:
	movq 24(%r14),%rax
	cmpl 16(%rax),%r13d
	jae L393
L400:
	movq 56(%r14),%r12
	movl %r13d,%ebx
	shlq $4,%rbx
	movl (%r12,%rbx),%eax
	testl $117440512,%eax
	jz L401
L406:
	testl $134217728,%eax
	jz L401
L405:
	movq _a_strsz(%rip),%rdi
	movq _strtab(%rip),%rcx
	movq 72(%r14),%rsi
	andl $16777215,%eax
	addq %rax,%rsi
	addq %rcx,%rdi
	call _strcpy
	movl _a_strsz(%rip),%ecx
	andl $16777215,%ecx
	movl (%r12,%rbx),%eax
	andl $4278190080,%eax
	orl %ecx,%eax
	movl %eax,(%r12,%rbx)
	movq _a_strsz(%rip),%rdi
	addq _strtab(%rip),%rdi
	call _strlen
	movq _a_strsz(%rip),%rcx
	leaq 1(%rcx,%rax),%rax
	movq %rax,_a_strsz(%rip)
	movl _exec+16(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_exec+16(%rip)
	movq _syms(%rip),%rdx
	shlq $4,%rcx
	movq (%r12,%rbx),%rax
	movq %rax,(%rdx,%rcx)
	movq 8(%r12,%rbx),%rax
	movq %rax,8(%rdx,%rcx)
L401:
	incl %r13d
	jmp L399
L393:
	movq 80(%r14),%r14
L391:
	testq %r14,%r14
	jnz L392
L370:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_out:
L411:
	pushq %rbx
	pushq %r12
	pushq %r13
L412:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	xorl %edx,%edx
	movq %r13,%rsi
	movl _outfd(%rip),%edi
	call _lseek
	cmpq %rax,%r13
	jz L416
L414:
	pushq _aout(%rip)
	pushq $L417
	call _error
	addq $16,%rsp
L416:
	movq %rbx,%rdx
	movq %r12,%rsi
	movl _outfd(%rip),%edi
	call _write
	cmpq %rax,%rbx
	jz L413
L418:
	pushq _aout(%rip)
	pushq $L421
	call _error
	addq $16,%rsp
L413:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_pass9:
L422:
	pushq %rbx
L423:
	pushq $511
	pushq $577
	pushq _aout(%rip)
	call _open
	addq $24,%rsp
	movl %eax,_outfd(%rip)
	cmpl $-1,%eax
	jnz L427
L425:
	pushq _aout(%rip)
	pushq $L428
	call _error
	addq $16,%rsp
L427:
	movl $32,%edx
	movl $_exec,%esi
	xorl %edi,%edi
	call _out
	movq _objects(%rip),%rbx
	jmp L429
L430:
	testl $1,16(%rbx)
	jz L431
L435:
	movl 48(%rbx),%edi
	subl _base(%rip),%edi
	movq 32(%rbx),%rsi
	movq 24(%rbx),%rax
	movl 4(%rax),%edx
	call _out
	movl 52(%rbx),%edi
	subl _base(%rip),%edi
	movq 40(%rbx),%rsi
	movq 24(%rbx),%rax
	movl 8(%rax),%edx
	call _out
L431:
	movq 80(%rbx),%rbx
L429:
	testq %rbx,%rbx
	jnz L430
L432:
	movl _exec(%rip),%esi
	cmpl $383131371,%esi
	movl $0,%eax
	movl $32,%edx
	cmovnzq %rax,%rdx
	addl _exec+4(%rip),%edx
	cmpl $397942507,%esi
	jnz L442
L440:
	movl %edx,%ecx
	andl $4095,%ecx
	jz L442
L443:
	movl $4096,%eax
	subl %ecx,%eax
	addl %eax,%edx
L442:
	movl _exec+8(%rip),%edi
	addl %edx,%edi
	cmpl $397942507,%esi
	jnz L448
L446:
	movl %edi,%ecx
	andl $4095,%ecx
	jz L448
L449:
	movl $4096,%eax
	subl %ecx,%eax
	addl %eax,%edi
L448:
	movl _exec+16(%rip),%edx
	shlq $4,%rdx
	movq _syms(%rip),%rsi
	call _out
	movl _exec(%rip),%esi
	cmpl $383131371,%esi
	movl $0,%eax
	movl $32,%edx
	cmovnzq %rax,%rdx
	addl _exec+4(%rip),%edx
	cmpl $397942507,%esi
	jnz L457
L455:
	movl %edx,%ecx
	andl $4095,%ecx
	jz L457
L458:
	movl $4096,%eax
	subl %ecx,%eax
	addl %eax,%edx
L457:
	movl _exec+8(%rip),%r8d
	addl %edx,%r8d
	cmpl $397942507,%esi
	jnz L463
L461:
	movl %r8d,%ecx
	andl $4095,%ecx
	jz L463
L464:
	movl $4096,%eax
	subl %ecx,%eax
	addl %eax,%r8d
L463:
	movl _exec+16(%rip),%edx
	movl _exec+20(%rip),%ecx
	movl _exec+24(%rip),%eax
	movl _exec+28(%rip),%edi
	movq _strtab(%rip),%rsi
	shlq $4,%rdx
	addq %rdx,%r8
	shlq $3,%rcx
	addq %rcx,%r8
	addq %r8,%rax
	movq _a_strsz(%rip),%rdx
	addq %rax,%rdi
	call _out
	movl _outfd(%rip),%edi
	call _close
L424:
	popq %rbx
	ret 


_main:
L467:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L468:
	movl %edi,%r12d
	movq %rsi,%rbx
L470:
	movl $L473,%edx
	movq %rbx,%rsi
	movl %r12d,%edi
	call _getopt
	cmpl $-1,%eax
	jz L472
L471:
	cmpl $98,%eax
	jz L477
L500:
	cmpl $101,%eax
	jz L470
L501:
	cmpl $111,%eax
	jz L486
L502:
	cmpl $115,%eax
	jnz L481
L488:
	incb _s_flag(%rip)
	jmp L470
L486:
	movq _optarg(%rip),%rax
	movq %rax,_aout(%rip)
	jmp L470
L477:
	xorl %edx,%edx
	leaq -8(%rbp),%rsi
	movq _optarg(%rip),%rdi
	call _strtol
	movl %eax,_base(%rip)
	movq -8(%rbp),%rax
	cmpb $0,(%rax)
	jz L470
	jnz L481
L472:
	movslq _optind(%rip),%rax
	cmpq $0,(%rbx,%rax,8)
	jz L481
L493:
	movl $397942507,_exec(%rip)
	movl _base(%rip),%ecx
	movl $32,_exec+4(%rip)
	addl $32,%ecx
	movl %ecx,_address(%rip)
	leaq (%rbx,%rax,8),%rdi
	call _pass1
	call _pass2
	call _pass3
	call _pass4
	call _pass5
	call _pass6
	call _pass7
	cmpb $0,_s_flag(%rip)
	jnz L497
L495:
	call _pass8
L497:
	call _pass9
	xorl %edi,%edi
	call _exit
L481:
	pushq $L498
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _exit
L469:
	movl %r13d,%eax
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L25:
	.byte 32,91,37,115,93,0
L133:
	.byte 96,37,115,39,58,32,99,97
	.byte 110,39,116,32,111,112,101,110
	.byte 32,40,37,69,41,0
L141:
	.byte 96,37,115,39,58,32,110,111
	.byte 116,32,97,32,114,101,103,117
	.byte 108,97,114,32,102,105,108,101
	.byte 0
L1:
	.byte 97,46,111,117,116,0
L473:
	.byte 98,58,101,58,111,58,115,0
L137:
	.byte 96,37,115,39,58,32,99,97
	.byte 110,39,116,32,115,116,97,116
	.byte 32,40,37,69,41,0
L498:
	.byte 117,115,97,103,101,58,32,108
	.byte 100,32,91,45,98,32,97,100
	.byte 100,114,93,32,91,45,115,93
	.byte 32,91,45,111,32,97,46,111
	.byte 117,116,93,32,105,110,112,117
	.byte 116,46,46,46,10,0
L421:
	.byte 96,37,115,39,58,32,119,114
	.byte 105,116,101,32,101,114,114,111
	.byte 114,32,40,37,69,41,0
L16:
	.byte 37,115,0
L197:
	.byte 37,79,58,32,96,37,115,39
	.byte 32,114,101,100,101,102,105,110
	.byte 101,100,32,40,112,114,101,118
	.byte 105,111,117,115,108,121,32,105
	.byte 110,32,37,79,41,0
L49:
	.byte 97,108,108,111,99,97,116,105
	.byte 111,110,32,102,97,105,108,101
	.byte 100,32,40,37,69,41,0
L428:
	.byte 96,37,115,39,58,32,99,97
	.byte 110,39,116,32,99,114,101,97
	.byte 116,101,32,40,37,69,41,0
L145:
	.byte 96,37,115,39,58,32,114,101
	.byte 97,100,32,101,114,114,111,114
	.byte 32,40,37,69,41,0
L5:
	.byte 91,108,100,93,32,69,82,82
	.byte 79,82,58,32,0
L417:
	.byte 96,37,115,39,58,32,115,101
	.byte 101,107,32,101,114,114,111,114
	.byte 32,40,37,69,41,0
L227:
	.byte 37,79,58,32,117,110,114,101
	.byte 115,111,108,118,101,100,32,114
	.byte 101,102,101,114,101,110,99,101
	.byte 32,116,111,32,96,37,115,39
	.byte 0
L65:
	.byte 37,79,32,105,115,32,110,111
	.byte 116,32,97,110,32,111,98,106
	.byte 101,99,116,0
L21:
	.byte 96,37,115,39,0
.globl _exec
.comm _exec, 32, 4
.globl _syms
.comm _syms, 8, 8
.globl _strtab
.comm _strtab, 8, 8
.globl _a_strsz
.comm _a_strsz, 8, 8
.globl _objects
.comm _objects, 8, 8
.globl _globls
.comm _globls, 4096, 8
.globl _address
.comm _address, 4, 4
.globl _s_flag
.comm _s_flag, 1, 1

.globl _errno
.globl _close
.globl _globls
.globl _optarg
.globl _crc32c
.globl _strncpy
.globl _aout
.globl _malloc
.globl _optind
.globl _s_flag
.globl _strtol
.globl _outfd
.globl _a_strsz
.globl _write
.globl _lseek
.globl _exec
.globl _fputc
.globl _objects
.globl _memcmp
.globl _address
.globl _unlink
.globl _open
.globl _strerror
.globl ___stderr
.globl _fstat
.globl _getopt
.globl _read
.globl _strlen
.globl _main
.globl _base
.globl _exit
.globl _strcpy
.globl _strtab
.globl _fprintf
.globl _syms
