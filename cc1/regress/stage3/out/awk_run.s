.data
.align 8
_winner:
	.quad 0
.align 8
_truecell:
	.byte 2
	.byte 11
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x3ff0000000000000
	.int 1
	.fill 12, 1, 0
.align 8
_True:
	.quad _truecell
.align 8
_falsecell:
	.byte 2
	.byte 12
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x0
	.int 1
	.fill 12, 1, 0
.align 8
_False:
	.quad _falsecell
.align 8
_breakcell:
	.byte 3
	.byte 23
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x0
	.int 1
	.fill 12, 1, 0
.align 8
_jbreak:
	.quad _breakcell
.align 8
_contcell:
	.byte 3
	.byte 24
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x0
	.int 1
	.fill 12, 1, 0
.align 8
_jcont:
	.quad _contcell
.align 8
_nextcell:
	.byte 3
	.byte 22
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x0
	.int 1
	.fill 12, 1, 0
.align 8
_jnext:
	.quad _nextcell
.align 8
_nextfilecell:
	.byte 3
	.byte 26
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x0
	.int 1
	.fill 12, 1, 0
.align 8
_jnextfile:
	.quad _nextfilecell
.align 8
_exitcell:
	.byte 3
	.byte 21
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x0
	.int 1
	.fill 12, 1, 0
.align 8
_jexit:
	.quad _exitcell
.align 8
_retcell:
	.byte 3
	.byte 25
	.fill 6, 1, 0
	.quad 0
	.quad 0
	.quad 0x0
	.int 1
	.fill 12, 1, 0
.align 8
_jret:
	.quad _retcell
.align 8
_tempcell:
	.byte 1
	.byte 4
	.fill 6, 1, 0
	.quad 0
	.quad L1
	.quad 0x0
	.int 7
	.fill 12, 1, 0
.align 8
_curnode:
	.quad 0
.text

_adjbuf:
L2:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L3:
	movq %rdi,%r15
	movq %rsi,-16(%rbp) # spill
	movl %edx,%r14d
	movq %r8,%r13
	movq %r9,-24(%rbp) # spill
	movq -16(%rbp),%rax # spill
	cmpl (%rax),%r14d
	jle L7
L5:
	testl %ecx,%ecx
	jz L9
L8:
	movl %r14d,%eax
	cltd 
	idivl %ecx
	jmp L10
L9:
	xorl %edx,%edx
L10:
	testq %r13,%r13
	jz L12
L11:
	movq (%r13),%r12
	subq (%r15),%r12
	jmp L13
L12:
	xorl %r12d,%r12d
L13:
	testl %edx,%edx
	jz L16
L14:
	subl %edx,%ecx
	addl %ecx,%r14d
L16:
	movslq %r14d,%rsi
	movq (%r15),%rdi
	call _realloc
	movq %rax,%rbx
	cmpl $0,_dbg(%rip)
	jz L19
L17:
	movq -16(%rbp),%rax # spill
	movl (%rax),%eax
	movl %eax,-4(%rbp) # spill
	pushq %rbx
	pushq (%r15)
	pushq %r14
	movl -4(%rbp),%eax # spill
	pushq %rax
	pushq -24(%rbp) # spill
	pushq $L20
	call _printf
	addq $48,%rsp
L19:
	testq %rbx,%rbx
	jz L21
L23:
	movq %rbx,(%r15)
	movq -16(%rbp),%rax # spill
	movl %r14d,(%rax)
	testq %r13,%r13
	jz L7
L29:
	movslq %r12d,%rax
	addq %rax,%rbx
	movq %rbx,(%r13)
L7:
	movl $1,%eax
	jmp L4
L21:
	cmpq $0,-24(%rbp) # spill
	jz L26
L24:
	pushq -24(%rbp) # spill
	pushq $L27
	call _FATAL
	addq $16,%rsp
L26:
	xorl %eax,%eax
L4:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_run:
L33:
	pushq %rbx
L34:
	movq %rdi,%rbx
	call _stdinit
	movq %rbx,%rdi
	call _execute
	call _closeall
L35:
	popq %rbx
	ret 


_execute:
L36:
	pushq %rbx
	pushq %r12
L37:
	movq %rdi,%rbx
	testq %rbx,%rbx
	jz L39
L43:
	movq %rbx,_curnode(%rip)
	cmpl $1,(%rbx)
	jz L47
L49:
	movl 20(%rbx),%eax
	cmpl $257,%eax
	jle L65
L72:
	cmpl $349,%eax
	jge L65
L68:
	subl $257,%eax
	movslq %eax,%rax
	cmpq $_nullproc,_proctab(,%rax,8)
	jnz L67
L65:
	pushq $L76
	call _FATAL
	addq $8,%rsp
L67:
	movl 20(%rbx),%esi
	movl %esi,%eax
	subl $257,%eax
	movslq %eax,%rax
	movq _proctab(,%rax,8),%rax
	leaq 24(%rbx),%rdi
	call *%rax
	movq %rax,%r12
	movl 32(%r12),%eax
	testl $64,%eax
	jz L78
L80:
	cmpl $0,_donefld(%rip)
	jnz L78
L77:
	call _fldbld
	jmp L79
L78:
	testl $128,%eax
	jz L79
L87:
	cmpl $0,_donerec(%rip)
	jnz L79
L84:
	call _recbld
L79:
	cmpl $3,(%rbx)
	jz L106
L93:
	cmpb $3,(%r12)
	jz L106
L97:
	cmpq $0,8(%rbx)
	jz L106
L101:
	cmpb $4,1(%r12)
	jnz L105
L103:
	movq %r12,%rdi
	call _tfree
L105:
	movq 8(%rbx),%rbx
	jmp L43
L106:
	movq %r12,%rax
	jmp L38
L47:
	movq 24(%rbx),%rbx
	movl 32(%rbx),%eax
	testl $64,%eax
	jz L51
L53:
	cmpl $0,_donefld(%rip)
	jnz L51
L50:
	call _fldbld
	jmp L52
L51:
	testl $128,%eax
	jz L52
L60:
	cmpl $0,_donerec(%rip)
	jnz L52
L57:
	call _recbld
L52:
	movq %rbx,%rax
	jmp L38
L39:
	movq _True(%rip),%rax
L38:
	popq %r12
	popq %rbx
	ret 


_program:
L107:
	pushq %rbx
	pushq %r12
L108:
	movq %rdi,%r12
	movl $_env,%edi
	call ___setjmp
	testl %eax,%eax
	jnz L113
L112:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L117
L115:
	call _execute
	movq %rax,%rbx
	cmpb $21,1(%rbx)
	jz L174
L120:
	cmpb $3,(%rbx)
	jnz L124
L122:
	pushq $L125
	call _FATAL
	addq $8,%rsp
L124:
	cmpb $4,1(%rbx)
	jnz L117
L126:
	movq %rbx,%rdi
	call _tfree
L117:
	cmpq $0,8(%r12)
	jnz L136
L132:
	cmpq $0,16(%r12)
	jz L113
L136:
	movl $1,%edx
	movl $_recsize,%esi
	movl $_record,%edi
	call _getrec
	cmpl $0,%eax
	jle L113
L137:
	movq 8(%r12),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%al
	cmpb $21,%al
	jz L113
L141:
	cmpb $4,%al
	jnz L136
L143:
	call _tfree
	jmp L136
L113:
	movl $_env,%edi
	call ___setjmp
	testl %eax,%eax
	jnz L174
L148:
	movq 16(%r12),%rdi
	testq %rdi,%rdi
	jz L174
L151:
	call _execute
	movq %rax,%rbx
	movb 1(%rbx),%al
	cmpb $23,%al
	jz L154
L161:
	cmpb $22,%al
	jz L154
L165:
	cmpb $26,%al
	jz L154
L157:
	cmpb $24,%al
	jnz L156
L154:
	pushq $L169
	call _FATAL
	addq $8,%rsp
L156:
	cmpb $4,1(%rbx)
	jnz L174
L170:
	movq %rbx,%rdi
	call _tfree
L174:
	movq _True(%rip),%rax
L109:
	popq %r12
	popq %rbx
	ret 

.data
.align 8
_frame:
	.quad 0
.align 4
_nframe:
	.int 0
.align 8
_fp:
	.quad 0
.align 8
L178:
	.byte 1
	.byte 6
	.fill 6, 1, 0
	.quad 0
	.quad L1
	.quad 0x0
	.int 7
	.fill 12, 1, 0
.text

_call:
L175:
	pushq %rbp
	movq %rsp,%rbp
	subq $832,%rsp
	movsd %xmm8,-832(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L176:
	movq %rdi,%r14
	movl $0,-804(%rbp) # spill
	movq (%r14),%rdi
	call _execute
	movq 8(%rax),%r12
	testl $32,32(%rax)
	movq %rax,-816(%rbp) # spill
	jnz L181
L179:
	pushq %r12
	pushq $L182
	call _FATAL
	addq $16,%rsp
L181:
	cmpq $0,_frame(%rip)
	jnz L185
L183:
	movl _nframe(%rip),%edi
	addl $100,%edi
	movl %edi,_nframe(%rip)
	movslq %edi,%rdi
	movl $32,%esi
	call _calloc
	movq %rax,_frame(%rip)
	movq %rax,_fp(%rip)
	testq %rax,%rax
	jnz L185
L186:
	pushq %r12
	pushq $L189
	call _FATAL
	addq $16,%rsp
L185:
	xorl %ebx,%ebx
	movq 8(%r14),%rax
	jmp L190
L191:
	incl %ebx
	movq 8(%rax),%rax
L190:
	testq %rax,%rax
	jnz L191
L193:
	movq -816(%rbp),%rax # spill
	cvttsd2sil 24(%rax),%eax
	movl %eax,-820(%rbp) # spill
	cmpl $0,_dbg(%rip)
	jz L196
L194:
	movq _frame(%rip),%rcx
	movq _fp(%rip),%rax
	subq %rcx,%rax
	movl $32,%ecx
	cqto 
	idivq %rcx
	pushq %rax
	movl -820(%rbp),%eax # spill
	pushq %rax
	pushq %rbx
	pushq %r12
	pushq $L197
	call _printf
	addq $40,%rsp
L196:
	cmpl -820(%rbp),%ebx # spill
	jle L200
L198:
	movl -820(%rbp),%eax # spill
	pushq %rax
	pushq %rbx
	pushq %r12
	pushq $L201
	call _WARNING
	addq $32,%rsp
L200:
	movl -820(%rbp),%eax # spill
	addl %ebx,%eax
	cmpl $50,%eax
	jle L204
L202:
	pushq $50
	pushq %rax
	pushq %r12
	pushq $L205
	call _FATAL
	addq $32,%rsp
L204:
	xorl %r13d,%r13d
	movq 8(%r14),%r15
L206:
	testq %r15,%r15
	jnz L207
	jz L239
L240:
	call _gettemp
	movl %r13d,%ecx
	movq %rax,-800(%rbp,%rcx,8)
	movl $48,%ecx
	movl $L178,%esi
	movq %rax,%rdi
	rep 
	movsb 
	incl %r13d
L239:
	cmpl %r13d,-820(%rbp) # spill
	jg L240
L242:
	movq _fp(%rip),%rax
	addq $32,%rax
	movq %rax,_fp(%rip)
	movl _nframe(%rip),%esi
	movslq %esi,%rcx
	movq _frame(%rip),%rdi
	shlq $5,%rcx
	addq %rdi,%rcx
	cmpq %rcx,%rax
	jb L245
L243:
	subq %rdi,%rax
	movl $32,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r13d
	addl $100,%esi
	movl %esi,_nframe(%rip)
	movslq %esi,%rsi
	shlq $5,%rsi
	call _realloc
	movq %rax,_frame(%rip)
	testq %rax,%rax
	jnz L248
L246:
	pushq %r12
	pushq $L249
	call _FATAL
	addq $16,%rsp
L248:
	movslq %r13d,%r13
	movq _frame(%rip),%rax
	shlq $5,%r13
	addq %r13,%rax
	movq %rax,_fp(%rip)
L245:
	movq _fp(%rip),%rcx
	movq -816(%rbp),%rax # spill
	movq %rax,8(%rcx)
	movq _fp(%rip),%rcx
	leaq -800(%rbp),%rax
	movq %rax,16(%rcx)
	movq _fp(%rip),%rcx
	movl -820(%rbp),%eax # spill
	movl %eax,(%rcx)
	call _gettemp
	movq _fp(%rip),%rcx
	movq %rax,24(%rcx)
	cmpl $0,_dbg(%rip)
	jz L252
L250:
	movq _frame(%rip),%rcx
	movq _fp(%rip),%rax
	subq %rcx,%rax
	movl $32,%ecx
	cqto 
	idivq %rcx
	pushq %rax
	pushq %r12
	pushq $L253
	call _printf
	addq $24,%rsp
L252:
	movq -816(%rbp),%rax # spill
	movq 16(%rax),%rdi
	call _execute
	movq %rax,%r13
	cmpl $0,_dbg(%rip)
	jz L256
L254:
	movq _frame(%rip),%rcx
	movq _fp(%rip),%rax
	subq %rcx,%rax
	movl $32,%ecx
	cqto 
	idivq %rcx
	pushq %rax
	pushq %r12
	pushq $L257
	call _printf
	addq $24,%rsp
L256:
	xorl %r15d,%r15d
	jmp L258
L259:
	movq _fp(%rip),%rax
	movq 16(%rax),%rax
	movq (%rax,%r15,8),%r14
	movl 32(%r14),%ecx
	testl $16,%ecx
	jz L263
L262:
	cmpb $6,1(%r14)
	jnz L264
L265:
	cmpl %r15d,%ebx
	jg L269
L268:
	movq %r14,%rdi
	call _freesymtab
	jmp L320
L269:
	movq -400(%rbp,%r15,8),%rax
	movl %ecx,32(%rax)
	movq -400(%rbp,%r15,8),%rax
	andl $-8,32(%rax)
	movq 16(%r14),%rcx
	movq -400(%rbp,%r15,8),%rax
	movq %rcx,16(%rax)
	cmpb $4,1(%r14)
	jnz L264
	jz L319
L263:
	cmpq %r14,%r13
	jz L286
L320:
	movb $4,1(%r14)
L319:
	movq %r14,%rdi
	call _tfree
	jmp L264
L286:
	cmpb $6,1(%r14)
	jnz L264
L283:
	movb $4,1(%r14)
	movq %r14,%rdi
	call _tfree
	movl $1,-804(%rbp) # spill
L264:
	incl %r15d
L258:
	cmpl %r15d,-820(%rbp) # spill
	jg L259
L261:
	movq -816(%rbp),%rax # spill
	cmpb $4,1(%rax)
	jnz L295
L293:
	movq -816(%rbp),%rdi # spill
	call _tfree
L295:
	movb 1(%r13),%al
	cmpb $21,%al
	jz L177
L299:
	cmpb $22,%al
	jz L177
L303:
	cmpb $26,%al
	jz L177
L298:
	cmpl $0,-804(%rbp) # spill
	jnz L310
L308:
	cmpb $4,%al
	jnz L310
L311:
	movq %r13,%rdi
	call _tfree
L310:
	movq _fp(%rip),%rax
	movq 24(%rax),%r13
	cmpl $0,_dbg(%rip)
	jz L316
L314:
	movq %r13,%rdi
	call _getfval
	movsd %xmm0,%xmm8
	movq %r13,%rdi
	call _getsval
	movl 32(%r13),%ecx
	subq $40,%rsp
	movl %ecx,32(%rsp)
	movq %rax,24(%rsp)
	movsd %xmm8,16(%rsp)
	movq %r12,8(%rsp)
	movq $L317,(%rsp)
	call _printf
	addq $40,%rsp
L316:
	addq $-32,_fp(%rip)
L177:
	movq %r13,%rax
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movsd -832(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 
L207:
	cmpl $0,_dbg(%rip)
	jz L212
L210:
	movq _frame(%rip),%rcx
	movq _fp(%rip),%rax
	subq %rcx,%rax
	movl $32,%ecx
	cqto 
	idivq %rcx
	pushq %rax
	pushq %r13
	pushq $L213
	call _printf
	addq $24,%rsp
L212:
	movq %r15,%rdi
	call _execute
	movq %rax,%r14
	movq %r14,-400(%rbp,%r13,8)
	cmpl $0,_dbg(%rip)
	jz L216
L214:
	movq 8(%r14),%rax
	testq %rax,%rax
	movl $L218,%esi
	cmovnzq %rax,%rsi
	movsd 24(%r14),%xmm0
	movl 32(%r14),%edx
	testl $16,%edx
	jz L224
L223:
	movl $L219,%ecx
	jmp L225
L224:
	movq 16(%r14),%rax
	testq %rax,%rax
	movl $L218,%ecx
	cmovnzq %rax,%rcx
L225:
	subq $48,%rsp
	movl %edx,40(%rsp)
	movq %rcx,32(%rsp)
	movsd %xmm0,24(%rsp)
	movq %rsi,16(%rsp)
	movl %r13d,8(%rsp)
	movq $L217,(%rsp)
	call _printf
	addq $48,%rsp
L216:
	testl $32,32(%r14)
	jz L231
L229:
	pushq %r12
	pushq 8(%r14)
	pushq $L232
	call _FATAL
	addq $24,%rsp
L231:
	testl $16,32(%r14)
	jz L234
L233:
	movq %r14,-800(%rbp,%r13,8)
	jmp L235
L234:
	movq %r14,%rdi
	call _copycell
	movq %rax,-800(%rbp,%r13,8)
L235:
	cmpb $4,1(%r14)
	jnz L238
L236:
	movq %r14,%rdi
	call _tfree
L238:
	incl %r13d
	movq 8(%r15),%r15
	jmp L206


_copycell:
L321:
	pushq %rbx
	pushq %r12
L322:
	movq %rdi,%r12
	call _gettemp
	movq %rax,%rbx
	movb $6,1(%rbx)
	movq 8(%r12),%rax
	movq %rax,8(%rbx)
	testl $2,32(%r12)
	jz L326
L324:
	movq 16(%r12),%rdi
	call _tostring
	movq %rax,16(%rbx)
L326:
	movsd 24(%r12),%xmm0
	movsd %xmm0,24(%rbx)
	movl 32(%r12),%eax
	andl $-205,%eax
	movl %eax,32(%rbx)
	movq %rbx,%rax
L323:
	popq %r12
	popq %rbx
	ret 


_arg:
L328:
	pushq %rbx
L329:
	movq (%rdi),%rdi
	call _ptoi
	movl %eax,%ebx
	cmpl $0,_dbg(%rip)
	jz L333
L331:
	movq _fp(%rip),%rax
	movl (%rax),%eax
	pushq %rax
	pushq %rbx
	pushq $L334
	call _printf
	addq $24,%rsp
L333:
	movq _fp(%rip),%rax
	leal 1(%rbx),%ecx
	cmpl (%rax),%ecx
	jle L337
L335:
	movq 8(%rax),%rax
	pushq 8(%rax)
	pushq %rcx
	pushq $L338
	call _FATAL
	addq $24,%rsp
L337:
	movq _fp(%rip),%rax
	movq 16(%rax),%rax
	movslq %ebx,%rbx
	movq (%rax,%rbx,8),%rax
L330:
	popq %rbx
	ret 


_jump:
L340:
	pushq %rbx
	pushq %r12
L341:
	movq %rdi,%r12
	cmpl $291,%esi
	jz L375
	jl L343
L382:
	cmpl $338,%esi
	jz L353
	jg L343
L383:
	cmpw $293,%si
	jz L377
L384:
	cmpw $296,%si
	jz L346
L385:
	cmpw $305,%si
	jz L371
L386:
	cmpw $306,%si
	jnz L343
L373:
	call _nextfile
	movq _jnextfile(%rip),%rax
	jmp L342
L371:
	movq _jnext(%rip),%rax
	jmp L342
L346:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L349
L347:
	call _execute
	movq %rax,%rbx
	movq %rbx,%rdi
	call _getfval
	cvttsd2sil %xmm0,%eax
	movl %eax,_errorflag(%rip)
	cmpb $4,1(%rbx)
	jnz L349
L350:
	movq %rbx,%rdi
	call _tfree
L349:
	movl $1,%esi
	movl $_env,%edi
	call _longjmp
	jmp L353
L377:
	movq _jcont(%rip),%rax
	jmp L342
L353:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L356
L354:
	call _execute
	movq %rax,%rbx
	movl 32(%rbx),%eax
	movl %eax,%ecx
	andl $3,%ecx
	cmpl $3,%ecx
	jnz L358
L357:
	movq _fp(%rip),%rax
	movq 24(%rax),%r12
	movq %rbx,%rdi
	call _getsval
	movq %rax,%rsi
	movq %r12,%rdi
	call _setsval
	movq %rbx,%rdi
	call _getfval
	movq _fp(%rip),%rax
	movq 24(%rax),%rax
	movsd %xmm0,24(%rax)
	movq _fp(%rip),%rax
	movq 24(%rax),%rax
	orl $1,32(%rax)
	jmp L359
L358:
	testl $2,%eax
	jz L361
L360:
	movq _fp(%rip),%rax
	movq 24(%rax),%r12
	movq %rbx,%rdi
	call _getsval
	movq %rax,%rsi
	movq %r12,%rdi
	call _setsval
	jmp L359
L361:
	testl $1,%eax
	jz L364
L363:
	movq _fp(%rip),%rax
	movq 24(%rax),%r12
	movq %rbx,%rdi
	call _getfval
	movq %r12,%rdi
	call _setfval
	jmp L359
L364:
	pushq %rax
	pushq $L366
	call _FATAL
	addq $16,%rsp
L359:
	cmpb $4,1(%rbx)
	jnz L356
L367:
	movq %rbx,%rdi
	call _tfree
L356:
	movq _jret(%rip),%rax
	jmp L342
L343:
	pushq %rsi
	pushq $L379
	call _FATAL
	addq $16,%rsp
	xorl %eax,%eax
	jmp L342
L375:
	movq _jbreak(%rip),%rax
L342:
	popq %r12
	popq %rbx
	ret 


_awkgetline:
L389:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L390:
	movl _recsize(%rip),%eax
	movq %rdi,%r13
	movl %eax,-12(%rbp)
	movslq %eax,%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L394
L392:
	pushq $L395
	call _FATAL
	addq $8,%rsp
L394:
	movl $___stdout,%edi
	call _fflush
	call _gettemp
	movq %rax,%r12
	cmpq $0,8(%r13)
	jz L397
L396:
	movq 16(%r13),%rdi
	call _execute
	movq %rax,%rbx
	movq 8(%r13),%rdi
	call _ptoi
	movl %eax,%r14d
	cmpl $124,%eax
	movl $285,%eax
	cmovzl %eax,%r14d
	movq %rbx,%rdi
	call _getsval
	movq %rax,%rsi
	movl %r14d,%edi
	call _openfile
	movq %rax,%r14
	cmpb $4,1(%rbx)
	jnz L404
L402:
	movq %rbx,%rdi
	call _tfree
L404:
	testq %r14,%r14
	jnz L406
L405:
	movl $-1,%ebx
	jmp L398
L406:
	movq %r14,%rdx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _readrec
	movl %eax,%ebx
	cmpl $0,%eax
	jle L398
L409:
	movq (%r13),%rdi
	testq %rdi,%rdi
	jz L412
L411:
	call _execute
	movq %rax,%r13
	movq -8(%rbp),%rsi
	movq %r13,%rdi
	call _setsval
	cmpb $4,1(%r13)
	jnz L398
	jz L428
L412:
	movq _fldtab(%rip),%rax
	movq (%rax),%rdi
	movq -8(%rbp),%rsi
	call _setsval
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq 16(%rax),%rdi
	call _is_number
	testl %eax,%eax
	jz L398
L417:
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq 16(%rax),%rdi
	call _atof
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movsd %xmm0,24(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	orl $1,32(%rax)
	jmp L398
L397:
	cmpq $0,(%r13)
	jnz L421
L420:
	movl $1,%edx
	movl $_recsize,%esi
	movl $_record,%edi
	call _getrec
	movl %eax,%ebx
	jmp L398
L421:
	xorl %edx,%edx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _getrec
	movl %eax,%ebx
	movq (%r13),%rdi
	call _execute
	movq %rax,%r13
	movq -8(%rbp),%rsi
	movq %r13,%rdi
	call _setsval
	cmpb $4,1(%r13)
	jnz L398
L428:
	movq %r13,%rdi
	call _tfree
L398:
	cvtsi2sdl %ebx,%xmm0
	movq %r12,%rdi
	call _setfval
	movq -8(%rbp),%rdi
	call _free
	movq %r12,%rax
L391:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_getnf:
L429:
	pushq %rbx
L430:
	movq %rdi,%rbx
	cmpl $0,_donefld(%rip)
	jnz L434
L432:
	call _fldbld
L434:
	movq (%rbx),%rax
L431:
	popq %rbx
	ret 

L478:
	.quad 0x0

_array:
L436:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L437:
	movl _recsize(%rip),%eax
	movq %rdi,%rbx
	movl %eax,-12(%rbp)
	movq _SUBSEP(%rip),%rax
	movq (%rax),%rdi
	call _strlen
	movl %eax,-16(%rbp) # spill
	movslq -12(%rbp),%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L441
L439:
	pushq $L442
	call _FATAL
	addq $8,%rsp
L441:
	movq (%rbx),%rdi
	call _execute
	movq %rax,%r15
	movq -8(%rbp),%rax
	movb $0,(%rax)
	movq 8(%rbx),%r14
	jmp L443
L444:
	movq %r14,%rdi
	call _execute
	movq %rax,%r13
	movq %r13,%rdi
	call _getsval
	movq %rax,%r12
	movq -8(%rbp),%rdi
	call _strlen
	movl %eax,%ebx
	movq %r12,%rdi
	call _strlen
	addl %eax,%ebx
	movl $L450,%r9d
	xorl %r8d,%r8d
	movl _recsize(%rip),%ecx
	movl -16(%rbp),%eax # spill
	leal 1(%rbx,%rax),%edx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L449
L447:
	pushq -8(%rbp)
	pushq 8(%r15)
	pushq $L451
	call _FATAL
	addq $24,%rsp
L449:
	movq %r12,%rsi
	movq -8(%rbp),%rdi
	call _strcat
	cmpq $0,8(%r14)
	jz L454
L452:
	movq _SUBSEP(%rip),%rax
	movq (%rax),%rsi
	movq -8(%rbp),%rdi
	call _strcat
L454:
	cmpb $4,1(%r13)
	jnz L457
L455:
	movq %r13,%rdi
	call _tfree
L457:
	movq 8(%r14),%r14
L443:
	testq %r14,%r14
	jnz L444
L446:
	testl $16,32(%r15)
	jnz L460
L458:
	cmpl $0,_dbg(%rip)
	jz L463
L461:
	movq 8(%r15),%rcx
	testq %rcx,%rcx
	movl $L218,%eax
	cmovnzq %rcx,%rax
	pushq %rax
	pushq $L464
	call _printf
	addq $16,%rsp
L463:
	movl 32(%r15),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L470
L468:
	movq 16(%r15),%rdi
	testq %rdi,%rdi
	jz L470
L471:
	call _free
	movq $0,16(%r15)
L470:
	movl 32(%r15),%eax
	andl $-8,%eax
	orl $16,%eax
	movl %eax,32(%r15)
	movl $50,%edi
	call _makesymtab
	movq %rax,16(%r15)
L460:
	movq 16(%r15),%rcx
	movq -8(%rbp),%rdi
	movl $3,%edx
	movsd L478(%rip),%xmm0
	movl $L1,%esi
	call _setsymtab
	movq %rax,%rbx
	movb $1,(%rbx)
	movb $2,1(%rbx)
	cmpb $4,1(%r15)
	jnz L476
L474:
	movq %r15,%rdi
	call _tfree
L476:
	movq -8(%rbp),%rdi
	call _free
	movq %rbx,%rax
L438:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_awkdelete:
L479:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L480:
	movq _SUBSEP(%rip),%rax
	movq %rdi,%rbx
	movq (%rax),%rdi
	call _strlen
	movl %eax,-16(%rbp) # spill
	movq (%rbx),%rdi
	call _execute
	movq %rax,%r15
	testl $16,32(%r15)
	jz L512
L484:
	cmpq $0,8(%rbx)
	jnz L487
L486:
	movq %r15,%rdi
	call _freesymtab
	movl 32(%r15),%eax
	andl $-3,%eax
	orl $16,%eax
	movl %eax,32(%r15)
	movl $50,%edi
	call _makesymtab
	movq %rax,16(%r15)
	jmp L488
L487:
	movl _recsize(%rip),%edi
	movl %edi,-12(%rbp)
	movslq %edi,%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L491
L489:
	pushq $L492
	call _FATAL
	addq $8,%rsp
L491:
	movq -8(%rbp),%rax
	movb $0,(%rax)
	movq 8(%rbx),%r14
	jmp L493
L494:
	movq %r14,%rdi
	call _execute
	movq %rax,%r13
	movq %r13,%rdi
	call _getsval
	movq %rax,%r12
	movq -8(%rbp),%rdi
	call _strlen
	movl %eax,%ebx
	movq %r12,%rdi
	call _strlen
	addl %eax,%ebx
	movl $L500,%r9d
	xorl %r8d,%r8d
	movl _recsize(%rip),%ecx
	movl -16(%rbp),%eax # spill
	leal 1(%rbx,%rax),%edx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L499
L497:
	pushq -8(%rbp)
	pushq 8(%r15)
	pushq $L501
	call _FATAL
	addq $24,%rsp
L499:
	movq %r12,%rsi
	movq -8(%rbp),%rdi
	call _strcat
	cmpq $0,8(%r14)
	jz L504
L502:
	movq _SUBSEP(%rip),%rax
	movq (%rax),%rsi
	movq -8(%rbp),%rdi
	call _strcat
L504:
	cmpb $4,1(%r13)
	jnz L507
L505:
	movq %r13,%rdi
	call _tfree
L507:
	movq 8(%r14),%r14
L493:
	testq %r14,%r14
	jnz L494
L496:
	movq -8(%rbp),%rsi
	movq %r15,%rdi
	call _freeelem
	movq -8(%rbp),%rdi
	call _free
L488:
	cmpb $4,1(%r15)
	jnz L512
L508:
	movq %r15,%rdi
	call _tfree
L512:
	movq _True(%rip),%rax
L481:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_intest:
L513:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L514:
	movl _recsize(%rip),%eax
	movq %rdi,%rbx
	movl %eax,-12(%rbp)
	movq _SUBSEP(%rip),%rax
	movq (%rax),%rdi
	call _strlen
	movl %eax,-16(%rbp) # spill
	movq 8(%rbx),%rdi
	call _execute
	movq %rax,%r15
	testl $16,32(%r15)
	jnz L518
L516:
	cmpl $0,_dbg(%rip)
	jz L521
L519:
	pushq 8(%r15)
	pushq $L464
	call _printf
	addq $16,%rsp
L521:
	movl 32(%r15),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L524
L522:
	movq 16(%r15),%rdi
	testq %rdi,%rdi
	jz L524
L525:
	call _free
	movq $0,16(%r15)
L524:
	movl 32(%r15),%eax
	andl $-8,%eax
	orl $16,%eax
	movl %eax,32(%r15)
	movl $50,%edi
	call _makesymtab
	movq %rax,16(%r15)
L518:
	movslq -12(%rbp),%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L530
L528:
	pushq $L531
	call _FATAL
	addq $8,%rsp
L530:
	movq -8(%rbp),%rax
	movb $0,(%rax)
	movq (%rbx),%r14
	jmp L532
L533:
	movq %r14,%rdi
	call _execute
	movq %rax,%r13
	movq %r13,%rdi
	call _getsval
	movq %rax,%r12
	movq -8(%rbp),%rdi
	call _strlen
	movl %eax,%ebx
	movq %r12,%rdi
	call _strlen
	addl %eax,%ebx
	movl $L539,%r9d
	xorl %r8d,%r8d
	movl _recsize(%rip),%ecx
	movl -16(%rbp),%eax # spill
	leal 1(%rbx,%rax),%edx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L538
L536:
	pushq -8(%rbp)
	pushq 8(%r13)
	pushq $L501
	call _FATAL
	addq $24,%rsp
L538:
	movq %r12,%rsi
	movq -8(%rbp),%rdi
	call _strcat
	cmpb $4,1(%r13)
	jnz L542
L540:
	movq %r13,%rdi
	call _tfree
L542:
	cmpq $0,8(%r14)
	jz L545
L543:
	movq _SUBSEP(%rip),%rax
	movq (%rax),%rsi
	movq -8(%rbp),%rdi
	call _strcat
L545:
	movq 8(%r14),%r14
L532:
	testq %r14,%r14
	jnz L533
L535:
	movq 16(%r15),%rsi
	movq -8(%rbp),%rdi
	call _lookup
	movq %rax,%rbx
	cmpb $4,1(%r15)
	jnz L548
L546:
	movq %r15,%rdi
	call _tfree
L548:
	movq -8(%rbp),%rdi
	call _free
	testq %rbx,%rbx
	jnz L550
L549:
	movq _False(%rip),%rax
	jmp L515
L550:
	movq _True(%rip),%rax
L515:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_matchop:
L554:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movsd %xmm8,-16(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L555:
	movq %rdi,%r15
	movl %esi,%r14d
	movl $_match,%r13d
	movl $0,-4(%rbp) # spill
	cmpl $304,%r14d
	jnz L559
L557:
	movl $_pmatch,%r13d
	movl $1,-4(%rbp) # spill
L559:
	movq 8(%r15),%rdi
	call _execute
	movq %rax,%r12
	movq %r12,%rdi
	call _getsval
	movq %rax,%rbx
	movq (%r15),%rax
	movq 16(%r15),%rdi
	testq %rax,%rax
	jnz L561
L560:
	movq %rbx,%rsi
	call *%r13
	movl %eax,%r13d
	jmp L562
L561:
	call _execute
	movq %rax,%r15
	movq %r15,%rdi
	call _getsval
	movl -4(%rbp),%esi # spill
	movq %rax,%rdi
	call _makedfa
	movq %rbx,%rsi
	movq %rax,%rdi
	call *%r13
	movl %eax,%r13d
	cmpb $4,1(%r15)
	jnz L562
L563:
	movq %r15,%rdi
	call _tfree
L562:
	cmpb $4,1(%r12)
	jnz L568
L566:
	movq %r12,%rdi
	call _tfree
L568:
	cmpl $304,%r14d
	jnz L570
L569:
	movq _patbeg(%rip),%rcx
	subq %rbx,%rcx
	incl %ecx
	cmpl $0,_patlen(%rip)
	movl $0,%eax
	cmovll %eax,%ecx
	cvtsi2sdl %ecx,%xmm8
	movsd %xmm8,%xmm0
	movq _rstartloc(%rip),%rdi
	call _setfval
	cvtsi2sdl _patlen(%rip),%xmm0
	movq _rlengthloc(%rip),%rdi
	call _setfval
	call _gettemp
	movl $1,32(%rax)
	movsd %xmm8,24(%rax)
	jmp L556
L570:
	cmpl $265,%r14d
	jnz L579
L583:
	cmpl $1,%r13d
	jz L576
L579:
	cmpl $266,%r14d
	jnz L577
L587:
	testl %r13d,%r13d
	jnz L577
L576:
	movq _True(%rip),%rax
	jmp L556
L577:
	movq _False(%rip),%rax
L556:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movsd -16(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


_boolop:
L593:
	pushq %rbx
	pushq %r12
	pushq %r13
L594:
	movq %rdi,%r13
	movl %esi,%r12d
	movq (%r13),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%cl
	cmpb $11,%cl
	setz %al
	movzbl %al,%ebx
	cmpb $4,%cl
	jnz L598
L596:
	call _tfree
L598:
	cmpl $280,%r12d
	jz L602
L639:
	cmpl $279,%r12d
	jz L615
L640:
	cmpl $343,%r12d
	jz L628
L641:
	pushq %r12
	pushq $L634
	call _FATAL
	addq $16,%rsp
	xorl %eax,%eax
	jmp L595
L628:
	testl %ebx,%ebx
	jz L636
	jnz L637
L615:
	testl %ebx,%ebx
	jz L637
L618:
	movq 8(%r13),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%cl
	cmpb $11,%cl
	setz %al
	movzbl %al,%ebx
	cmpb $4,%cl
	jnz L622
L620:
	call _tfree
L622:
	testl %ebx,%ebx
	jz L637
	jnz L636
L602:
	testl %ebx,%ebx
	jnz L636
L605:
	movq 8(%r13),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%cl
	cmpb $11,%cl
	setz %al
	movzbl %al,%ebx
	cmpb $4,%cl
	jnz L609
L607:
	call _tfree
L609:
	testl %ebx,%ebx
	jz L637
L636:
	movq _True(%rip),%rax
	jmp L595
L637:
	movq _False(%rip),%rax
L595:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L711:
	.short L686-_relop
	.short L692-_relop
	.short L698-_relop
	.short L674-_relop
	.short L668-_relop
	.short L680-_relop

_relop:
L643:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L644:
	movq %rdi,%r12
	movl %esi,%ebx
	movq (%r12),%rdi
	call _execute
	movq %rax,%r14
	movq 8(%r12),%rdi
	call _execute
	movq %rax,%r13
	testl $1,32(%r14)
	jz L647
L649:
	testl $1,32(%r13)
	jz L647
L646:
	movsd 24(%r14),%xmm0
	subsd 24(%r13),%xmm0
	ucomisd L478(%rip),%xmm0
	jb L653
	jz L657
L656:
	movl $1,%r12d
	jmp L648
L657:
	xorl %r12d,%r12d
	jmp L648
L653:
	movl $-1,%r12d
	jmp L648
L647:
	movq %r14,%rdi
	call _getsval
	movq %rax,%r12
	movq %r13,%rdi
	call _getsval
	movq %rax,%rsi
	movq %r12,%rdi
	call _strcmp
	movl %eax,%r12d
L648:
	cmpb $4,1(%r14)
	jnz L661
L659:
	movq %r14,%rdi
	call _tfree
L661:
	cmpb $4,1(%r13)
	jnz L664
L662:
	movq %r13,%rdi
	call _tfree
L664:
	cmpl $282,%ebx
	jl L665
L710:
	cmpl $287,%ebx
	jg L665
L708:
	leal -282(%rbx),%eax
	movzwl L711(,%rax,2),%eax
	addl $_relop,%eax
	jmp *%rax
L680:
	testl %r12d,%r12d
	jz L707
	jnz L706
L668:
	cmpl $0,%r12d
	jge L707
	jl L706
L674:
	cmpl $0,%r12d
	jg L707
	jle L706
L698:
	cmpl $0,%r12d
	jle L707
	jg L706
L692:
	cmpl $0,%r12d
	jl L707
	jge L706
L686:
	testl %r12d,%r12d
	jnz L707
L706:
	movq _True(%rip),%rax
	jmp L645
L707:
	movq _False(%rip),%rax
	jmp L645
L665:
	pushq %rbx
	pushq $L704
	call _FATAL
	addq $16,%rsp
	xorl %eax,%eax
L645:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_tfree:
L712:
	pushq %rbx
L713:
	movq %rdi,%rbx
	movl 32(%rbx),%esi
	movl %esi,%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L717
L715:
	cmpl $0,_dbg(%rip)
	jz L720
L718:
	movq 8(%rbx),%rax
	testq %rax,%rax
	movl $L218,%edx
	cmovnzq %rax,%rdx
	movq 16(%rbx),%rcx
	testq %rcx,%rcx
	movl $L218,%eax
	cmovnzq %rcx,%rax
	pushq %rsi
	pushq %rax
	pushq %rdx
	pushq $L721
	call _printf
	addq $32,%rsp
L720:
	movq 16(%rbx),%rdi
	testq %rdi,%rdi
	jz L717
L728:
	call _free
	movq $0,16(%rbx)
L717:
	cmpq _tmps(%rip),%rbx
	jnz L733
L731:
	pushq $L734
	call _FATAL
	addq $8,%rsp
L733:
	movq _tmps(%rip),%rax
	movq %rax,40(%rbx)
	movq %rbx,_tmps(%rip)
L714:
	popq %rbx
	ret 


_gettemp:
L735:
L736:
	cmpq $0,_tmps(%rip)
	jnz L740
L738:
	movl $48,%esi
	movl $100,%edi
	call _calloc
	movq %rax,_tmps(%rip)
	testq %rax,%rax
	jnz L743
L741:
	pushq $L744
	call _FATAL
	addq $8,%rsp
L743:
	movl $1,%edx
L746:
	movq _tmps(%rip),%rsi
	imulq $48,%rdx,%rcx
	addq %rsi,%rcx
	movl %edx,%eax
	decl %eax
	movslq %eax,%rax
	imulq $48,%rax,%rax
	movq %rcx,40(%rsi,%rax)
	incl %edx
	cmpl $100,%edx
	jl L746
L748:
	decl %edx
	movslq %edx,%rax
	movq _tmps(%rip),%rcx
	imulq $48,%rax,%rax
	movq $0,40(%rcx,%rax)
L740:
	movq _tmps(%rip),%rax
	movq 40(%rax),%rcx
	movq %rcx,_tmps(%rip)
	movl $48,%ecx
	movl $_tempcell,%esi
	movq %rax,%rdi
	rep 
	movsb 
L737:
	ret 

L769:
	.quad 0x41dfffffffc00000

_indirect:
L750:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
L751:
	movq (%rdi),%rdi
	call _execute
	movq %rax,%r13
	movq %r13,%rdi
	call _getfval
	movsd %xmm0,%xmm8
	ucomisd L769(%rip),%xmm8
	jbe L755
L753:
	pushq 8(%r13)
	pushq $L756
	call _FATAL
	addq $16,%rsp
L755:
	cvttsd2sil %xmm8,%r12d
	testl %r12d,%r12d
	jnz L759
L760:
	movq %r13,%rdi
	call _getsval
	movq %rax,%rbx
	movq %rax,%rdi
	call _is_number
	testl %eax,%eax
	jnz L759
L757:
	pushq 8(%r13)
	pushq %rbx
	pushq $L764
	call _FATAL
	addq $24,%rsp
L759:
	cmpb $4,1(%r13)
	jnz L767
L765:
	movq %r13,%rdi
	call _tfree
L767:
	movl %r12d,%edi
	call _fieldadr
	movb $1,(%rax)
	movb $1,1(%rax)
L752:
	popq %r13
	popq %r12
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


_substr:
L770:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L771:
	movq %rdi,-40(%rbp) # spill
	xorl %ebx,%ebx
	movq -40(%rbp),%rax # spill
	movq (%rax),%rdi
	call _execute
	movq %rax,-32(%rbp) # spill
	movq -40(%rbp),%rax # spill
	movq 8(%rax),%rdi
	call _execute
	movq %rax,%r13
	movq -40(%rbp),%rax # spill
	movq 16(%rax),%rdi
	testq %rdi,%rdi
	jz L775
L773:
	call _execute
	movq %rax,%rbx
L775:
	movq -32(%rbp),%rdi # spill
	call _getsval
	movq %rax,%r15
	movq %r15,%rdi
	call _strlen
	leal 1(%rax),%r14d
	cmpl $1,%r14d
	jle L776
L778:
	movq %r13,%rdi
	call _getfval
	cvttsd2sil %xmm0,%r12d
	cmpl $0,%r12d
	jg L793
L792:
	movl $1,%r12d
	jmp L794
L793:
	cmpl %r12d,%r14d
	cmovll %r14d,%r12d
L794:
	cmpb $4,1(%r13)
	jnz L800
L798:
	movq %r13,%rdi
	call _tfree
L800:
	movq -40(%rbp),%rax # spill
	cmpq $0,16(%rax)
	jz L802
L801:
	movq %rbx,%rdi
	call _getfval
	cvttsd2sil %xmm0,%r13d
	cmpb $4,1(%rbx)
	jnz L803
L804:
	movq %rbx,%rdi
	call _tfree
	jmp L803
L802:
	movl %r14d,%r13d
	decl %r13d
L803:
	cmpl $0,%r13d
	jge L808
L807:
	xorl %r13d,%r13d
	jmp L809
L808:
	subl %r12d,%r14d
	cmpl %r14d,%r13d
	cmovgl %r14d,%r13d
L809:
	cmpl $0,_dbg(%rip)
	jz L815
L813:
	pushq %r15
	pushq %r13
	pushq %r12
	pushq $L816
	call _printf
	addq $32,%rsp
L815:
	call _gettemp
	movq %rax,-16(%rbp) # spill
	addl %r12d,%r13d
	decl %r13d
	movslq %r13d,%r13
	movsbl (%r13,%r15),%eax
	movl %eax,-4(%rbp) # spill
	movb $0,(%r13,%r15)
	movslq %r12d,%r12
	leaq -1(%r15,%r12),%rsi
	movq -16(%rbp),%rdi # spill
	call _setsval
	movl -4(%rbp),%eax # spill
	movb %al,(%r13,%r15)
	movq -32(%rbp),%rax # spill
	cmpb $4,1(%rax)
	jnz L819
L817:
	movq -32(%rbp),%rdi # spill
	call _tfree
L819:
	movq -16(%rbp),%rax # spill
	jmp L772
L776:
	movq -32(%rbp),%rax # spill
	cmpb $4,1(%rax)
	jnz L781
L779:
	movq -32(%rbp),%rdi # spill
	call _tfree
L781:
	cmpb $4,1(%r13)
	jnz L784
L782:
	movq %r13,%rdi
	call _tfree
L784:
	movq -40(%rbp),%rax # spill
	cmpq $0,16(%rax)
	jz L787
L785:
	cmpb $4,1(%rbx)
	jnz L787
L788:
	movq %rbx,%rdi
	call _tfree
L787:
	call _gettemp
	movq %rax,-24(%rbp) # spill
	movl $L1,%esi
	movq -24(%rbp),%rdi # spill
	call _setsval
	movq -24(%rbp),%rax # spill
L772:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_sindex:
L821:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L822:
	movq %rdi,%rbx
	movsd L478(%rip),%xmm8
	movq (%rbx),%rdi
	call _execute
	movq %rax,%r15
	movq %r15,%rdi
	call _getsval
	movq %rax,%r14
	movq 8(%rbx),%rdi
	call _execute
	movq %rax,%r13
	movq %r13,%rdi
	call _getsval
	movq %rax,%r12
	call _gettemp
	movq %rax,%rbx
	movq %r14,%rax
L824:
	cmpb $0,(%rax)
	jz L827
L825:
	movq %rax,%rsi
	movq %r12,%rdx
	jmp L828
L832:
	cmpb (%rsi),%cl
	jnz L831
L829:
	incq %rsi
	incq %rdx
L828:
	movb (%rdx),%cl
	testb %cl,%cl
	jnz L832
L831:
	testb %cl,%cl
	jz L836
L838:
	incq %rax
	jmp L824
L836:
	subq %r14,%rax
	incq %rax
	cvtsi2sdq %rax,%xmm8
L827:
	cmpb $4,1(%r15)
	jnz L842
L840:
	movq %r15,%rdi
	call _tfree
L842:
	cmpb $4,1(%r13)
	jnz L845
L843:
	movq %r13,%rdi
	call _tfree
L845:
	movsd %xmm8,%xmm0
	movq %rbx,%rdi
	call _setfval
	movq %rbx,%rax
L823:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L1011:
	.short L936-_format
	.short L920-_format
	.short L917-_format
	.short L917-_format
	.short L917-_format
	.short L910-_format
	.short L920-_format
	.short L910-_format
	.short L910-_format
	.short L910-_format
	.short L910-_format
	.short L910-_format
	.short L929-_format

_format:
L847:
	pushq %rbp
	movq %rsp,%rbp
	subq $72,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L848:
	movl _recsize(%rip),%r8d
	movq %rdi,-56(%rbp) # spill
	movq %rsi,-64(%rbp) # spill
	movq %rdx,%r15
	movq %rcx,%r14
	movl %r8d,-36(%rbp)
	movq -56(%rbp),%rax # spill
	movq (%rax),%rcx
	movq %rcx,-8(%rbp)
	movq -64(%rbp),%rax # spill
	movl (%rax),%eax
	movl %eax,-12(%rbp)
	movq %r15,-72(%rbp) # spill
	movq %rcx,-24(%rbp)
	movslq %r8d,%r8
	movq %r8,%rdi
	call _malloc
	movq %rax,-32(%rbp)
	testq %rax,%rax
	jnz L854
L850:
	pushq $L853
	call _FATAL
	addq $8,%rsp
L854:
	movb (%r15),%al
	movq -24(%rbp),%rdx
	testb %al,%al
	jz L856
L855:
	addq $51,%rdx
	subq -8(%rbp),%rdx
	movl $L857,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movb (%r15),%cl
	leaq 1(%r15),%rax
	cmpb $37,%cl
	jnz L858
L860:
	cmpb $37,1(%r15)
	jz L862
L864:
	leaq 1(%r15),%rdi
	call _atoi
	movl %eax,%r12d
	cmpl $0,%eax
	jge L868
L866:
	negl %eax
	movl %eax,%r12d
L868:
	leal 1(%r12),%edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L869,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq -32(%rbp),%rax
	movq %rax,-48(%rbp)
	jmp L870
L871:
	movq -48(%rbp),%rdx
	addq $51,%rdx
	subq -32(%rbp),%rdx
	movl $L877,%r9d
	leaq -48(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -36(%rbp),%rsi
	leaq -32(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L876
L874:
	pushq -72(%rbp) # spill
	pushq $L878
	call _FATAL
	addq $16,%rsp
L876:
	movzbq (%r15),%rax
	testb $3,___ctype+1(%rax)
	jz L881
L890:
	cmpb $108,%al
	jz L881
L886:
	cmpb $104,%al
	jz L881
L882:
	cmpb $76,%al
	jnz L873
L881:
	cmpb $42,%al
	jnz L897
L895:
	movq %r14,%rdi
	call _execute
	movq %rax,%r13
	movq 8(%r14),%r14
	movq -48(%rbp),%rbx
	decq %rbx
	movq %r13,%rdi
	call _getfval
	cvttsd2sil %xmm0,%r12d
	pushq %r12
	pushq $L898
	pushq %rbx
	call _sprintf
	addq $24,%rsp
	cmpl $0,%r12d
	jge L901
L899:
	negl %r12d
L901:
	leal 1(%r12),%edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L902,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq -32(%rbp),%rdi
	call _strlen
	movq -32(%rbp),%rcx
	addq %rax,%rcx
	movq %rcx,-48(%rbp)
	cmpb $4,1(%r13)
	jnz L897
L903:
	movq %r13,%rdi
	call _tfree
L897:
	incq %r15
L870:
	movb (%r15),%cl
	movq -48(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-48(%rbp)
	movb %cl,(%rdx)
	testb %cl,%cl
	jnz L871
L873:
	movq -48(%rbp),%rax
	movb $0,(%rax)
	cmpl $0,%r12d
	jge L908
L906:
	negl %r12d
L908:
	leal 1(%r12),%edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L909,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movb (%r15),%al
	cmpb $99,%al
	jl L992
L994:
	cmpb $111,%al
	jg L992
L991:
	addb $-99,%al
	movzbl %al,%eax
	movzwl L1011(,%rax,2),%eax
	addl $_format,%eax
	jmp *%rax
L920:
	movl $100,%r13d
	cmpb $108,-1(%r15)
	jz L911
L923:
	movq -48(%rbp),%rax
	movb $108,-1(%rax)
	movq -48(%rbp),%rax
	movb $100,(%rax)
	movq -48(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-48(%rbp)
	movb $0,1(%rcx)
	jmp L911
L936:
	movl $99,%r13d
	jmp L911
L992:
	cmpb $69,%al
	jz L917
L996:
	cmpb $71,%al
	jz L917
L997:
	cmpb $88,%al
	jz L929
L998:
	cmpb $115,%al
	jz L934
L999:
	cmpb $117,%al
	jz L929
L1000:
	cmpb $120,%al
	jz L929
L910:
	pushq -32(%rbp)
	pushq $L938
	call _WARNING
	addq $16,%rsp
	movl $63,%r13d
	jmp L911
L934:
	movl $115,%r13d
	jmp L911
L929:
	cmpb $108,-1(%r15)
	movl $117,%eax
	movl $100,%r13d
	cmovnzl %eax,%r13d
	jmp L911
L917:
	movl $102,%r13d
L911:
	testq %r14,%r14
	jnz L942
L940:
	pushq -72(%rbp) # spill
	pushq $L943
	call _FATAL
	addq $16,%rsp
L942:
	movq %r14,%rdi
	call _execute
	movq %rax,%rbx
	movq 8(%r14),%r14
	movl $50,%edx
	cmpl $50,%r12d
	cmovgl %r12d,%edx
	incl %edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L947,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	cmpl $63,%r13d
	jz L951
	jl L948
L1004:
	cmpl $117,%r13d
	jg L948
	jz L1015
L1005:
	cmpb $99,%r13b
	jz L974
L1006:
	cmpb $100,%r13b
	jz L960
L1007:
	cmpb $102,%r13b
	jz L958
L1008:
	cmpb $115,%r13b
	jnz L948
L964:
	movq %rbx,%rdi
	call _getsval
	movq %rax,-48(%rbp)
	movq %rax,%rdi
	call _strlen
	movl %eax,%r13d
	cmpl %eax,%r12d
	cmovgl %r12d,%r13d
	leal 1(%r13),%edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L971,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L970
L968:
	pushq -48(%rbp)
	pushq %r13
	pushq $L972
	call _FATAL
	addq $24,%rsp
L970:
	movq -24(%rbp),%rdx
	movq -32(%rbp),%rcx
	pushq -48(%rbp)
	jmp L1013
L958:
	movq %rbx,%rdi
	call _getfval
	movq -24(%rbp),%rcx
	movq -32(%rbp),%rax
	subq $24,%rsp
	movsd %xmm0,16(%rsp)
	movq %rax,8(%rsp)
	movq %rcx,(%rsp)
	jmp L1012
L960:
	movq %rbx,%rdi
	call _getfval
	cvttsd2siq %xmm0,%rax
	jmp L1014
L974:
	testl $1,32(%rbx)
	jz L976
L975:
	movq %rbx,%rdi
	call _getfval
	ucomisd L478(%rip),%xmm0
	jz L979
L1015:
	movq %rbx,%rdi
	call _getfval
	cvttsd2sil %xmm0,%eax
	jmp L1014
L979:
	movq -24(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-24(%rbp)
	movb $0,(%rcx)
	movq -24(%rbp),%rax
	movb $0,(%rax)
	jmp L949
L976:
	movq %rbx,%rdi
	call _getsval
	movsbl (%rax),%eax
L1014:
	movq -24(%rbp),%rdx
	movq -32(%rbp),%rcx
	pushq %rax
L1013:
	pushq %rcx
	pushq %rdx
	jmp L1012
L948:
	pushq %r13
	pushq $L982
	call _FATAL
	addq $16,%rsp
	jmp L949
L951:
	pushq -32(%rbp)
	pushq $L952
	pushq -24(%rbp)
	call _sprintf
	addq $24,%rsp
	movq %rbx,%rdi
	call _getsval
	movq %rax,-48(%rbp)
	movq %rax,%rdi
	call _strlen
	movl %eax,%r13d
	cmpl %eax,%r12d
	cmovgl %r12d,%r13d
	movq -24(%rbp),%rdi
	call _strlen
	movslq %r13d,%r13
	leaq 1(%rax,%r13),%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L956,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq -24(%rbp),%rdi
	call _strlen
	movq -24(%rbp),%rcx
	addq %rax,%rcx
	movq %rcx,-24(%rbp)
	pushq -48(%rbp)
	pushq $L952
	pushq %rcx
L1012:
	call _sprintf
	addq $24,%rsp
L949:
	cmpb $4,1(%rbx)
	jnz L985
L983:
	movq %rbx,%rdi
	call _tfree
L985:
	movq -24(%rbp),%rdi
	call _strlen
	addq %rax,-24(%rbp)
	incq %r15
	jmp L854
L862:
	movq -24(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-24(%rbp)
	movb $37,(%rcx)
	addq $2,%r15
	jmp L854
L858:
	movq %rax,%r15
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
	jmp L854
L856:
	movb $0,(%rdx)
	movq -32(%rbp),%rdi
	call _free
	jmp L986
L987:
	movq %r14,%rdi
	call _execute
	movq 8(%r14),%r14
L986:
	testq %r14,%r14
	jnz L987
L989:
	movq -8(%rbp),%rcx
	movq -56(%rbp),%rax # spill
	movq %rcx,(%rax)
	movl -12(%rbp),%ecx
	movq -64(%rbp),%rax # spill
	movl %ecx,(%rax)
	movq -8(%rbp),%rcx
	movq -24(%rbp),%rax
	subq %rcx,%rax
L849:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_awksprintf:
L1016:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
L1017:
	movq %rdi,%rbx
	imull $3,_recsize(%rip),%edi
	movl %edi,-12(%rbp)
	movslq %edi,%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L1021
L1019:
	pushq $L1022
	call _FATAL
	addq $8,%rsp
L1021:
	movq (%rbx),%rdi
	movq 8(%rdi),%r12
	call _execute
	movq %rax,%rbx
	movq %rbx,%rdi
	call _getsval
	movq %r12,%rcx
	movq %rax,%rdx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _format
	cmpl $-1,%eax
	jnz L1025
L1023:
	pushq -8(%rbp)
	pushq $L1026
	call _FATAL
	addq $16,%rsp
L1025:
	cmpb $4,1(%rbx)
	jnz L1029
L1027:
	movq %rbx,%rdi
	call _tfree
L1029:
	call _gettemp
	movq -8(%rbp),%rcx
	movq %rcx,16(%rax)
	movl $2,32(%rax)
L1018:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_awkprintf:
L1031:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L1032:
	movq %rdi,%r13
	imull $3,_recsize(%rip),%edi
	movl %edi,-12(%rbp)
	movslq %edi,%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L1036
L1034:
	pushq $L1037
	call _FATAL
	addq $8,%rsp
L1036:
	movq (%r13),%rdi
	movq 8(%rdi),%rbx
	call _execute
	movq %rax,%r12
	movq %r12,%rdi
	call _getsval
	movq %rbx,%rcx
	movq %rax,%rdx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _format
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L1040
L1038:
	pushq -8(%rbp)
	pushq $L1041
	call _FATAL
	addq $16,%rsp
L1040:
	cmpb $4,1(%r12)
	jnz L1044
L1042:
	movq %r12,%rdi
	call _tfree
L1044:
	movq 8(%r13),%rdi
	movslq %ebx,%rbx
	testq %rdi,%rdi
	jnz L1046
L1045:
	movl $___stdout,%ecx
	movl $1,%edx
	movq %rbx,%rsi
	movq -8(%rbp),%rdi
	call _fwrite
	testl $32,___stdout+8(%rip)
	jz L1047
L1048:
	pushq $L1051
	call _FATAL
	addq $8,%rsp
	jmp L1047
L1046:
	call _ptoi
	movq 16(%r13),%rsi
	movl %eax,%edi
	call _redirect
	movq %rax,%r12
	movq %r12,%rcx
	movl $1,%edx
	movq %rbx,%rsi
	movq -8(%rbp),%rdi
	call _fwrite
	movq %r12,%rdi
	call _fflush
	testl $32,8(%r12)
	jz L1047
L1052:
	movq %r12,%rdi
	call _filename
	pushq %rax
	pushq $L1055
	call _FATAL
	addq $16,%rsp
L1047:
	movq -8(%rbp),%rdi
	call _free
	movq _True(%rip),%rax
L1033:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L1112:
	.quad 0xbff0000000000000
.align 2
L1113:
	.short L1072-_arith
	.short L1074-_arith
	.short L1076-_arith
	.short L1078-_arith
	.short L1084-_arith

_arith:
L1057:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	movsd %xmm8,-32(%rbp)
	movsd %xmm9,-24(%rbp)
	movsd %xmm10,-16(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
L1058:
	movq %rdi,%r13
	movl %esi,%ebx
	movsd L478(%rip),%xmm9
	movq (%r13),%rdi
	call _execute
	movq %rax,%r12
	movq %r12,%rdi
	call _getfval
	movsd %xmm0,%xmm8
	movsd %xmm8,%xmm10
	cmpb $4,1(%r12)
	jnz L1062
L1060:
	movq %r12,%rdi
	call _tfree
L1062:
	cmpl $344,%ebx
	jz L1065
L1063:
	movq 8(%r13),%rdi
	call _execute
	movq %rax,%r12
	movq %r12,%rdi
	call _getfval
	movsd %xmm0,%xmm9
	cmpb $4,1(%r12)
	jnz L1065
L1066:
	movq %r12,%rdi
	call _tfree
L1065:
	call _gettemp
	movq %rax,%r12
	cmpl $307,%ebx
	jl L1105
L1107:
	cmpl $311,%ebx
	jg L1105
L1104:
	leal -307(%rbx),%eax
	movzwl L1113(,%rax,2),%eax
	addl $_arith,%eax
	jmp *%rax
L1084:
	ucomisd L478(%rip),%xmm9
	jnz L1087
L1085:
	pushq $L1088
	call _FATAL
	addq $8,%rsp
L1087:
	movsd %xmm8,%xmm0
	divsd %xmm9,%xmm0
	leaq -8(%rbp),%rdi
	call _modf
	movsd -8(%rbp),%xmm0
	mulsd %xmm9,%xmm0
	subsd %xmm0,%xmm8
	jmp L1115
L1078:
	ucomisd L478(%rip),%xmm9
	jnz L1081
L1079:
	pushq $L1082
	call _FATAL
	addq $8,%rsp
L1081:
	movsd %xmm8,%xmm10
	divsd %xmm9,%xmm10
	jmp L1070
L1076:
	mulsd %xmm8,%xmm9
	jmp L1114
L1074:
	subsd %xmm9,%xmm8
L1115:
	movsd %xmm8,%xmm10
	jmp L1070
L1072:
	addsd %xmm8,%xmm9
L1114:
	movsd %xmm9,%xmm10
	jmp L1070
L1105:
	cmpl $344,%ebx
	jz L1090
L1109:
	cmpl $345,%ebx
	jz L1092
L1069:
	pushq %rbx
	pushq $L1102
	call _FATAL
	addq $16,%rsp
	jmp L1070
L1092:
	ucomisd L478(%rip),%xmm9
	jb L1094
L1096:
	leaq -8(%rbp),%rdi
	movsd %xmm9,%xmm0
	call _modf
	ucomisd L478(%rip),%xmm0
	jnz L1094
L1093:
	cvttsd2sil %xmm9,%edi
	movsd %xmm8,%xmm0
	call _ipow
	jmp L1116
L1094:
	movsd %xmm9,%xmm1
	movsd %xmm8,%xmm0
	call _pow
	movl $L1100,%edi
	call _errcheck
L1116:
	movsd %xmm0,%xmm10
	jmp L1070
L1090:
	movsd L1112(%rip),%xmm10
	mulsd %xmm8,%xmm10
L1070:
	movsd %xmm10,%xmm0
	movq %r12,%rdi
	call _setfval
	movq %r12,%rax
L1059:
	popq %r13
	popq %r12
	popq %rbx
	movsd -16(%rbp),%xmm10
	movsd -24(%rbp),%xmm9
	movsd -32(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 

L1129:
	.quad 0x3ff0000000000000

_ipow:
L1117:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
L1118:
	movsd %xmm0,%xmm8
	movl %edi,%ebx
	cmpl $0,%ebx
	jle L1120
L1122:
	movl $2,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	movl %eax,%edi
	movsd %xmm8,%xmm0
	call _ipow
	movl $2,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jnz L1125
L1124:
	mulsd %xmm0,%xmm0
	jmp L1119
L1125:
	mulsd %xmm0,%xmm8
	mulsd %xmm0,%xmm8
	movsd %xmm8,%xmm0
	jmp L1119
L1120:
	movsd L1129(%rip),%xmm0
L1119:
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


_incrdecr:
L1130:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
L1131:
	movl %esi,%ebx
	movq (%rdi),%rdi
	call _execute
	movq %rax,%r13
	movq %r13,%rdi
	call _getfval
	movsd %xmm0,%xmm8
	cmpl $327,%ebx
	jz L1133
L1136:
	cmpl $326,%ebx
	jnz L1134
L1133:
	movl $1,%r12d
	jmp L1135
L1134:
	movl $-1,%r12d
L1135:
	cmpl $327,%ebx
	jz L1140
L1143:
	cmpl $329,%ebx
	jnz L1142
L1140:
	cvtsi2sdl %r12d,%xmm0
	addsd %xmm8,%xmm0
	movq %r13,%rdi
	call _setfval
	movq %r13,%rax
	jmp L1132
L1142:
	call _gettemp
	movq %rax,%rbx
	movsd %xmm8,%xmm0
	movq %rbx,%rdi
	call _setfval
	cvtsi2sdl %r12d,%xmm0
	addsd %xmm8,%xmm0
	movq %r13,%rdi
	call _setfval
	cmpb $4,1(%r13)
	jnz L1150
L1148:
	movq %r13,%rdi
	call _tfree
L1150:
	movq %rbx,%rax
L1132:
	popq %r13
	popq %r12
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L1219:
	.short L1182-_assign
	.short L1184-_assign
	.short L1186-_assign
	.short L1188-_assign
	.short L1194-_assign
	.short L1200-_assign

_assign:
L1152:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	movsd %xmm8,-24(%rbp)
	movsd %xmm9,-16(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
L1153:
	movq %rdi,%rbx
	movl %esi,%r13d
	movq 8(%rbx),%rdi
	call _execute
	movq %rax,%r12
	movq (%rbx),%rdi
	call _execute
	movq %rax,%rbx
	cmpl $312,%r13d
	jz L1155
L1157:
	movq %rbx,%rdi
	call _getfval
	movsd %xmm0,%xmm8
	movq %r12,%rdi
	call _getfval
	movsd %xmm0,%xmm9
	cmpl $314,%r13d
	jl L1179
L1218:
	cmpl $319,%r13d
	jg L1179
L1216:
	leal -314(%r13),%eax
	movzwl L1219(,%rax,2),%eax
	addl $_assign,%eax
	jmp *%rax
L1200:
	ucomisd L478(%rip),%xmm9
	jb L1202
L1204:
	leaq -8(%rbp),%rdi
	movsd %xmm9,%xmm0
	call _modf
	ucomisd L478(%rip),%xmm0
	jnz L1202
L1201:
	cvttsd2sil %xmm9,%edi
	movsd %xmm8,%xmm0
	call _ipow
	jmp L1221
L1202:
	movsd %xmm9,%xmm1
	movsd %xmm8,%xmm0
	call _pow
	movl $L1100,%edi
	call _errcheck
L1221:
	movsd %xmm0,%xmm8
	jmp L1180
L1194:
	ucomisd L478(%rip),%xmm9
	jnz L1197
L1195:
	pushq $L1198
	call _FATAL
	addq $8,%rsp
L1197:
	movsd %xmm8,%xmm0
	divsd %xmm9,%xmm0
	leaq -8(%rbp),%rdi
	call _modf
	movsd -8(%rbp),%xmm0
	mulsd %xmm9,%xmm0
	subsd %xmm0,%xmm8
	jmp L1180
L1188:
	ucomisd L478(%rip),%xmm9
	jnz L1191
L1189:
	pushq $L1192
	call _FATAL
	addq $8,%rsp
L1191:
	divsd %xmm9,%xmm8
	jmp L1180
L1186:
	mulsd %xmm8,%xmm9
	jmp L1220
L1184:
	subsd %xmm9,%xmm8
	jmp L1180
L1182:
	addsd %xmm8,%xmm9
L1220:
	movsd %xmm9,%xmm8
	jmp L1180
L1179:
	pushq %r13
	pushq $L1209
	call _FATAL
	addq $16,%rsp
L1180:
	cmpb $4,1(%r12)
	jnz L1213
L1211:
	movq %r12,%rdi
	call _tfree
L1213:
	movsd %xmm8,%xmm0
	movq %rbx,%rdi
	call _setfval
	jmp L1215
L1155:
	cmpq %rbx,%r12
	jnz L1159
L1161:
	testl $192,32(%rbx)
	jz L1160
L1159:
	movl 32(%r12),%eax
	movl %eax,%ecx
	andl $3,%ecx
	cmpl $3,%ecx
	jnz L1166
L1165:
	movq %r12,%rdi
	call _getsval
	movq %rax,%rsi
	movq %rbx,%rdi
	call _setsval
	movq %r12,%rdi
	call _getfval
	movsd %xmm0,24(%rbx)
	orl $1,32(%rbx)
	jmp L1160
L1166:
	testl $2,%eax
	jz L1169
L1168:
	movq %r12,%rdi
	call _getsval
	movq %rax,%rsi
	movq %rbx,%rdi
	call _setsval
	jmp L1160
L1169:
	testl $1,%eax
	jz L1172
L1171:
	movq %r12,%rdi
	call _getfval
	movq %rbx,%rdi
	call _setfval
	jmp L1160
L1172:
	movl $L1174,%esi
	movq %r12,%rdi
	call _funnyvar
L1160:
	cmpb $4,1(%r12)
	jnz L1215
L1175:
	movq %r12,%rdi
	call _tfree
L1215:
	movq %rbx,%rax
L1154:
	popq %r13
	popq %r12
	popq %rbx
	movsd -16(%rbp),%xmm9
	movsd -24(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


_cat:
L1222:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1223:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	call _execute
	movq %rax,%r14
	movq 8(%rbx),%rdi
	call _execute
	movq %rax,%r13
	movq %r14,%rdi
	call _getsval
	movq %r13,%rdi
	call _getsval
	movq 16(%r14),%rdi
	call _strlen
	movl %eax,%r12d
	movq 16(%r13),%rdi
	call _strlen
	leal 1(%r12,%rax),%edi
	movslq %edi,%rdi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L1227
L1225:
	pushq 16(%r13)
	pushq 16(%r14)
	pushq $L1228
	call _FATAL
	addq $24,%rsp
L1227:
	movq 16(%r14),%rsi
	movq %rbx,%rdi
	call _strcpy
	movslq %r12d,%rdi
	movq 16(%r13),%rsi
	addq %rbx,%rdi
	call _strcpy
	cmpb $4,1(%r14)
	jnz L1231
L1229:
	movq %r14,%rdi
	call _tfree
L1231:
	cmpb $4,1(%r13)
	jnz L1234
L1232:
	movq %r13,%rdi
	call _tfree
L1234:
	call _gettemp
	movq %rbx,16(%rax)
	movl $2,32(%rax)
L1224:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_pastat:
L1236:
	pushq %rbx
L1237:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L1249
L1240:
	call _execute
	movq %rax,%rdi
	movq %rdi,%rax
	movb 1(%rdi),%cl
	cmpb $11,%cl
	jnz L1238
L1242:
	cmpb $4,%cl
	jnz L1249
L1245:
	call _tfree
L1249:
	movq 8(%rbx),%rdi
	call _execute
L1238:
	popq %rbx
	ret 


_dopa2:
L1250:
	pushq %rbx
	pushq %r12
L1251:
	movq %rdi,%r12
	movq 24(%r12),%rdi
	call _ptoi
	movslq %eax,%rbx
	cmpl $0,_pairstack(,%rbx,4)
	jnz L1255
L1253:
	movq (%r12),%rdi
	call _execute
	movq %rax,%rdi
	cmpb $11,1(%rdi)
	jnz L1258
L1256:
	movl $1,_pairstack(,%rbx,4)
L1258:
	cmpb $4,1(%rdi)
	jnz L1255
L1259:
	call _tfree
L1255:
	cmpl $1,_pairstack(,%rbx,4)
	jz L1262
L1264:
	movq _False(%rip),%rax
	jmp L1252
L1262:
	movq 8(%r12),%rdi
	call _execute
	movq %rax,%rdi
	cmpb $11,1(%rdi)
	jnz L1267
L1265:
	movl $0,_pairstack(,%rbx,4)
L1267:
	cmpb $4,1(%rdi)
	jnz L1270
L1268:
	call _tfree
L1270:
	movq 16(%r12),%rdi
	call _execute
L1252:
	popq %r12
	popq %rbx
	ret 


_split:
L1273:
	pushq %rbp
	movq %rsp,%rbp
	subq $136,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1274:
	movq %rdi,-96(%rbp) # spill
	movq $0,-64(%rbp) # spill
	movq $0,-128(%rbp) # spill
	movq -96(%rbp),%rax # spill
	movq (%rax),%rdi
	call _execute
	movq %rax,%rdi
	movq %rax,-72(%rbp) # spill
	call _getsval
	movq %rax,%rdi
	call _strdup
	movq %rax,%r13
	movq %rax,-88(%rbp) # spill
	movq -96(%rbp),%rax # spill
	movq 24(%rax),%rdi
	call _ptoi
	movl %eax,-76(%rbp) # spill
	movl %eax,-104(%rbp) # spill
	movq -96(%rbp),%rax # spill
	movq 16(%rax),%rdi
	testq %rdi,%rdi
	jnz L1277
L1276:
	movq _FS(%rip),%rax
	movq (%rax),%rax
	jmp L1437
L1277:
	cmpl $335,-104(%rbp) # spill
	jnz L1280
L1279:
	call _execute
	movq %rax,-64(%rbp) # spill
	movq %rax,%rdi
	call _getsval
L1437:
	movq %rax,-128(%rbp) # spill
	jmp L1278
L1280:
	cmpl $336,-104(%rbp) # spill
	jnz L1283
L1282:
	movq $L1285,-128(%rbp) # spill
	jmp L1278
L1283:
	pushq $L1286
	call _FATAL
	addq $8,%rsp
L1278:
	movq -128(%rbp),%rax # spill
	movsbl (%rax),%eax
	movl %eax,-132(%rbp) # spill
	movq -96(%rbp),%rax # spill
	movq 8(%rax),%rdi
	call _execute
	movq %rax,%r12
	movq %r12,%rdi
	call _freesymtab
	cmpl $0,_dbg(%rip)
	jz L1289
L1287:
	movq 8(%r12),%rcx
	testq %rcx,%rcx
	movl $L218,%eax
	cmovnzq %rcx,%rax
	pushq -128(%rbp) # spill
	pushq %rax
	pushq -88(%rbp) # spill
	pushq $L1290
	call _printf
	addq $32,%rsp
L1289:
	movl 32(%r12),%eax
	andl $-3,%eax
	orl $16,%eax
	movl %eax,32(%r12)
	movl $50,%edi
	call _makesymtab
	movq %rax,16(%r12)
	xorl %ebx,%ebx
	cmpl $336,-104(%rbp) # spill
	jnz L1296
L1297:
	movq -96(%rbp),%rax # spill
	movq 16(%rax),%rax
	movq 8320(%rax),%rdi
	call _strlen
	testq %rax,%rax
	jnz L1296
L1294:
	movl $0,-76(%rbp) # spill
	movq $L1,-128(%rbp) # spill
	movl $0,-132(%rbp) # spill
L1296:
	movq -88(%rbp),%rax # spill
	cmpb $0,(%rax)
	jz L1302
L1304:
	movq -128(%rbp),%rdi # spill
	call _strlen
	cmpq $1,%rax
	ja L1301
L1308:
	cmpl $336,-76(%rbp) # spill
	jnz L1302
L1301:
	cmpl $336,-76(%rbp) # spill
	jnz L1313
L1312:
	movq -96(%rbp),%rax # spill
	movq 16(%rax),%r14
	jmp L1314
L1313:
	movl $1,%esi
	movq -128(%rbp),%rdi # spill
	call _makedfa
	movq %rax,%r14
L1314:
	movq -88(%rbp),%rsi # spill
	movq %r14,%rdi
	call _nematch
	testl %eax,%eax
	jz L1317
L1315:
	movl 8592(%r14),%eax
	movl %eax,-100(%rbp) # spill
	movl $2,8592(%r14)
L1318:
	incl %ebx
	leaq -50(%rbp),%rax
	movq %rax,-112(%rbp) # spill
	pushq %rbx
	pushq $L898
	pushq -112(%rbp) # spill
	call _sprintf
	addq $24,%rsp
	movq _patbeg(%rip),%rcx
	movb (%rcx),%al
	movb %al,-113(%rbp) # spill
	movb $0,(%rcx)
	movq %r13,%rdi
	call _is_number
	testl %eax,%eax
	jz L1322
L1321:
	movq %r13,%rdi
	call _atof
	movq 16(%r12),%rcx
	movl $3,%edx
	jmp L1432
L1322:
	movq 16(%r12),%rcx
	movl $2,%edx
	movsd L478(%rip),%xmm0
L1432:
	movq %r13,%rsi
	leaq -50(%rbp),%rdi
	call _setsymtab
	movq _patbeg(%rip),%rcx
	movb -113(%rbp),%al # spill
	movb %al,(%rcx)
	movslq _patlen(%rip),%rsi
	movq _patbeg(%rip),%rax
	leaq (%rsi,%rax),%r13
	cmpb $0,-1(%rsi,%rax)
	jz L1324
L1327:
	cmpb $0,(%rsi,%rax)
	jz L1324
L1326:
	addq %rax,%rsi
	movq %r14,%rdi
	call _nematch
	testl %eax,%eax
	jnz L1318
L1319:
	movl -100(%rbp),%eax # spill
	movl %eax,8592(%r14)
L1317:
	incl %ebx
	leaq -50(%rbp),%rax
	pushq %rbx
	pushq $L898
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movq %r13,%rdi
	call _is_number
	testl %eax,%eax
	jz L1334
L1333:
	movq %r13,%rdi
	call _atof
	movq 16(%r12),%rcx
	movl $3,%edx
	jmp L1431
L1334:
	movq 16(%r12),%rcx
	movl $2,%edx
	movsd L478(%rip),%xmm0
L1431:
	movq %r13,%rsi
	leaq -50(%rbp),%rdi
	call _setsymtab
	jmp L1303
L1324:
	incl %ebx
	pushq %rbx
	pushq $L898
	pushq -112(%rbp) # spill
	call _sprintf
	addq $24,%rsp
	movq 16(%r12),%rcx
	movl $2,%edx
	movsd L478(%rip),%xmm0
	movl $L1,%esi
	leaq -50(%rbp),%rdi
	call _setsymtab
	movl -100(%rbp),%eax # spill
	movl %eax,8592(%r14)
	jmp L1303
L1302:
	cmpl $32,-132(%rbp) # spill
	jnz L1337
L1336:
	xorl %ebx,%ebx
L1343:
	movb (%r13),%al
	cmpb $32,%al
	jz L1436
L1350:
	cmpb $9,%al
	jz L1436
L1346:
	cmpb $10,%al
	jz L1436
L1345:
	testb %al,%al
	jz L1303
L1356:
	incl %ebx
	movq %r13,%r15
L1358:
	incq %r13
	movb (%r13),%r14b
	cmpb $32,%r14b
	jz L1359
L1369:
	cmpb $9,%r14b
	jz L1359
L1365:
	cmpb $10,%r14b
	jz L1359
L1361:
	testb %r14b,%r14b
	jnz L1358
L1359:
	movb $0,(%r13)
	leaq -50(%rbp),%rax
	pushq %rbx
	pushq $L898
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movq %r15,%rdi
	call _is_number
	testl %eax,%eax
	jz L1374
L1373:
	movq %r15,%rdi
	call _atof
	movq 16(%r12),%rcx
	movl $3,%edx
	jmp L1433
L1374:
	movq 16(%r12),%rcx
	movl $2,%edx
	movsd L478(%rip),%xmm0
L1433:
	movq %r15,%rsi
	leaq -50(%rbp),%rdi
	call _setsymtab
	movb %r14b,(%r13)
	testb %r14b,%r14b
	jz L1343
L1436:
	incq %r13
	jmp L1343
L1337:
	cmpl $0,-132(%rbp) # spill
	jnz L1380
L1379:
	xorl %ebx,%ebx
L1382:
	cmpb $0,(%r13)
	jz L1303
L1383:
	incl %ebx
	leaq -50(%rbp),%rax
	pushq %rbx
	pushq $L898
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movb (%r13),%al
	movb %al,-52(%rbp)
	movb $0,-51(%rbp)
	movzbq %al,%rax
	testb $4,___ctype+1(%rax)
	jz L1387
L1386:
	leaq -52(%rbp),%rdi
	call _atof
	movq 16(%r12),%rcx
	movl $3,%edx
	jmp L1434
L1387:
	movq 16(%r12),%rcx
	movl $2,%edx
	movsd L478(%rip),%xmm0
L1434:
	leaq -52(%rbp),%rsi
	leaq -50(%rbp),%rdi
	call _setsymtab
	incq %r13
	jmp L1382
L1380:
	movq -88(%rbp),%rax # spill
	cmpb $0,(%rax)
	jz L1303
L1392:
	incl %ebx
	movq %r13,%r15
	jmp L1396
L1403:
	cmpb $10,%r14b
	jz L1398
L1399:
	testb %r14b,%r14b
	jz L1398
L1397:
	incq %r13
L1396:
	movsbl (%r13),%r14d
	cmpl %r14d,-132(%rbp) # spill
	jnz L1403
L1398:
	movb $0,(%r13)
	leaq -50(%rbp),%rax
	pushq %rbx
	pushq $L898
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movq %r15,%rdi
	call _is_number
	testl %eax,%eax
	jz L1408
L1407:
	movq %r15,%rdi
	call _atof
	movq 16(%r12),%rcx
	movl $3,%edx
	jmp L1435
L1408:
	movq 16(%r12),%rcx
	movl $2,%edx
	movsd L478(%rip),%xmm0
L1435:
	movq %r15,%rsi
	leaq -50(%rbp),%rdi
	call _setsymtab
	movb %r14b,(%r13)
	incq %r13
	testb %r14b,%r14b
	jnz L1392
L1303:
	cmpb $4,1(%r12)
	jnz L1416
L1414:
	movq %r12,%rdi
	call _tfree
L1416:
	movq -72(%rbp),%rax # spill
	cmpb $4,1(%rax)
	jnz L1419
L1417:
	movq -72(%rbp),%rdi # spill
	call _tfree
L1419:
	movq -88(%rbp),%rdi # spill
	call _free
	movq -96(%rbp),%rax # spill
	cmpq $0,16(%rax)
	jz L1422
L1423:
	cmpl $335,-76(%rbp) # spill
	jnz L1422
L1420:
	movq -64(%rbp),%rax # spill
	cmpb $4,1(%rax)
	jnz L1422
L1427:
	movq -64(%rbp),%rdi # spill
	call _tfree
L1422:
	call _gettemp
	movl $1,32(%rax)
	cvtsi2sdl %ebx,%xmm0
	movsd %xmm0,24(%rax)
L1275:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_condexpr:
L1438:
	pushq %rbx
L1439:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%al
	cmpb $11,%al
	jnz L1442
L1441:
	cmpb $4,%al
	jnz L1446
L1444:
	call _tfree
L1446:
	movq 8(%rbx),%rdi
	jmp L1451
L1442:
	cmpb $4,%al
	jnz L1449
L1447:
	call _tfree
L1449:
	movq 16(%rbx),%rdi
L1451:
	call _execute
L1440:
	popq %rbx
	ret 


_ifstat:
L1452:
	pushq %rbx
L1453:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	call _execute
	movq %rax,%rdi
	movq %rdi,%rax
	movb 1(%rdi),%cl
	cmpb $11,%cl
	jnz L1456
L1455:
	cmpb $4,%cl
	jnz L1460
L1458:
	call _tfree
L1460:
	movq 8(%rbx),%rdi
	jmp L1468
L1456:
	cmpq $0,16(%rbx)
	jz L1454
L1461:
	cmpb $4,%cl
	jnz L1466
L1464:
	call _tfree
L1466:
	movq 16(%rbx),%rdi
L1468:
	call _execute
L1454:
	popq %rbx
	ret 


_whilestat:
L1469:
	pushq %rbx
L1470:
	movq %rdi,%rbx
L1472:
	movq (%rbx),%rdi
	call _execute
	movb 1(%rax),%cl
	cmpb $11,%cl
	jnz L1471
L1478:
	cmpb $4,%cl
	jnz L1482
L1480:
	movq %rax,%rdi
	call _tfree
L1482:
	movq 8(%rbx),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%al
	cmpb $23,%al
	jz L1483
L1485:
	cmpb $22,%al
	jz L1487
L1498:
	cmpb $26,%al
	jz L1487
L1494:
	cmpb $21,%al
	jz L1487
L1490:
	cmpb $25,%al
	jz L1487
L1489:
	cmpb $4,%al
	jnz L1472
L1503:
	call _tfree
	jmp L1472
L1487:
	movq %rdi,%rax
	jmp L1471
L1483:
	movq _True(%rip),%rax
L1471:
	popq %rbx
	ret 


_dostat:
L1506:
	pushq %rbx
L1507:
	movq %rdi,%rbx
L1509:
	movq (%rbx),%rdi
	call _execute
	movb 1(%rax),%cl
	cmpb $23,%cl
	jz L1513
L1515:
	cmpb $22,%cl
	jz L1508
L1528:
	cmpb $26,%cl
	jz L1508
L1524:
	cmpb $21,%cl
	jz L1508
L1520:
	cmpb $25,%cl
	jz L1508
L1519:
	cmpb $4,%cl
	jnz L1535
L1533:
	movq %rax,%rdi
	call _tfree
L1535:
	movq 8(%rbx),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%al
	cmpb $11,%al
	jnz L1536
L1538:
	cmpb $4,%al
	jnz L1509
L1540:
	call _tfree
	jmp L1509
L1536:
	movq %rdi,%rax
	jmp L1508
L1513:
	movq _True(%rip),%rax
L1508:
	popq %rbx
	ret 


_forstat:
L1543:
	pushq %rbx
L1544:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	call _execute
	movq %rax,%rdi
	cmpb $4,1(%rdi)
	jnz L1549
L1589:
	call _tfree
L1549:
	movq 8(%rbx),%rdi
	testq %rdi,%rdi
	jz L1555
L1553:
	call _execute
	movb 1(%rax),%cl
	cmpb $11,%cl
	jnz L1545
L1557:
	cmpb $4,%cl
	jnz L1555
L1560:
	movq %rax,%rdi
	call _tfree
L1555:
	movq 24(%rbx),%rdi
	call _execute
	movq %rax,%rdi
	movb 1(%rdi),%al
	cmpb $23,%al
	jz L1563
L1565:
	cmpb $22,%al
	jz L1567
L1578:
	cmpb $26,%al
	jz L1567
L1574:
	cmpb $21,%al
	jz L1567
L1570:
	cmpb $25,%al
	jz L1567
L1569:
	cmpb $4,%al
	jnz L1585
L1583:
	call _tfree
L1585:
	movq 16(%rbx),%rdi
	call _execute
	cmpb $4,1(%rax)
	jnz L1549
L1586:
	movq %rax,%rdi
	jmp L1589
L1567:
	movq %rdi,%rax
	jmp L1545
L1563:
	movq _True(%rip),%rax
L1545:
	popq %rbx
	ret 


_instat:
L1590:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1591:
	movq %rdi,%r15
	movq (%r15),%rdi
	call _execute
	movq %rax,%r14
	movq 8(%r15),%rdi
	call _execute
	movq %rax,%rdi
	testl $16,32(%rdi)
	jz L1638
L1595:
	movq 16(%rdi),%rax
	movq %rax,-8(%rbp) # spill
	cmpb $4,1(%rdi)
	jnz L1599
L1597:
	call _tfree
L1599:
	xorl %r13d,%r13d
	jmp L1600
L1601:
	movq -8(%rbp),%rax # spill
	movq 8(%rax),%rax
	movq (%rax,%r13,8),%r12
L1604:
	testq %r12,%r12
	jz L1607
L1605:
	movq 8(%r12),%rsi
	movq %r14,%rdi
	call _setsval
	movq 40(%r12),%r12
	movq 16(%r15),%rdi
	call _execute
	movq %rax,%rbx
	movb 1(%rbx),%al
	cmpb $23,%al
	jz L1608
L1610:
	cmpb $22,%al
	jz L1615
L1626:
	cmpb $26,%al
	jz L1615
L1622:
	cmpb $21,%al
	jz L1615
L1618:
	cmpb $25,%al
	jz L1615
L1617:
	cmpb $4,%al
	jnz L1604
L1634:
	movq %rbx,%rdi
	call _tfree
	jmp L1604
L1615:
	cmpb $4,1(%r14)
	jnz L1632
L1630:
	movq %r14,%rdi
	call _tfree
L1632:
	movq %rbx,%rax
	jmp L1592
L1608:
	cmpb $4,1(%r14)
	jnz L1638
L1611:
	movq %r14,%rdi
	call _tfree
	jmp L1638
L1607:
	incl %r13d
L1600:
	movq -8(%rbp),%rax # spill
	cmpl 4(%rax),%r13d
	jl L1601
L1638:
	movq _True(%rip),%rax
L1592:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L1738:
	.quad 0x40dfffc000000000
L1739:
	.quad 0x4070000000000000
.align 2
L1740:
	.short L1645-_bltin
	.short L1661-_bltin
	.short L1658-_bltin
	.short L1653-_bltin
	.short L1656-_bltin
	.short L1677-_bltin
	.short L1679-_bltin
	.short L1681-_bltin
	.short L1664-_bltin
	.short L1666-_bltin
	.short L1668-_bltin
	.short L1687-_bltin
	.short L1687-_bltin
	.short L1709-_bltin

_bltin:
L1639:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	movsd %xmm8,-16(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
L1640:
	movq %rdi,%rbx
	movq (%rbx),%rdi
	call _ptoi
	movl %eax,%r13d
	movq 8(%rbx),%rdi
	call _execute
	movq %rax,%r12
	movq 8(%rbx),%rax
	movq 8(%rax),%rbx
	cmpl $1,%r13d
	jl L1642
L1737:
	cmpl $14,%r13d
	jg L1642
L1735:
	leal -1(%r13),%eax
	movzwl L1740(,%rax,2),%eax
	addl $_bltin,%eax
	jmp *%rax
L1709:
	testl $128,32(%r12)
	jnz L1714
L1713:
	movq %r12,%rdi
	call _getsval
	movq %rax,%rdi
	call _strlen
	testq %rax,%rax
	jnz L1715
L1714:
	call _flush_all
	movsd L478(%rip),%xmm0
	jmp L1742
L1715:
	movq %r12,%rdi
	call _getsval
	movq %rax,%rsi
	movl $14,%edi
	call _openfile
	movq %rax,%rdi
	testq %rdi,%rdi
	jnz L1718
L1717:
	movsd L1112(%rip),%xmm0
	jmp L1742
L1718:
	call _fflush
	cvtsi2sdl %eax,%xmm0
	jmp L1742
L1687:
	movq %r12,%rdi
	call _getsval
	movq %rax,%rdi
	call _tostring
	movq %rax,%rbx
	cmpl $12,%r13d
	jnz L1689
L1688:
	movq %rbx,%r13
L1691:
	movb (%r13),%dil
	testb %dil,%dil
	jz L1690
L1692:
	movzbq %dil,%rax
	testb $2,___ctype+1(%rax)
	jz L1697
L1695:
	movzbl %dil,%edi
	call _toupper
	movb %al,(%r13)
L1697:
	incq %r13
	jmp L1691
L1689:
	movq %rbx,%r13
	jmp L1698
L1699:
	movzbq %dil,%rax
	testb $1,___ctype+1(%rax)
	jz L1704
L1702:
	movzbl %dil,%edi
	call _tolower
	movb %al,(%r13)
L1704:
	incq %r13
L1698:
	movb (%r13),%dil
	testb %dil,%dil
	jnz L1699
L1690:
	cmpb $4,1(%r12)
	jnz L1707
L1705:
	movq %r12,%rdi
	call _tfree
L1707:
	call _gettemp
	movq %rax,%r12
	movq %rbx,%rsi
	movq %r12,%rdi
	call _setsval
	movq %rbx,%rdi
	call _free
	jmp L1741
L1668:
	testq %rbx,%rbx
	jnz L1670
L1669:
	pushq $L1672
	call _WARNING
	addq $8,%rsp
	movsd L1129(%rip),%xmm0
	jmp L1742
L1670:
	movq %rbx,%rdi
	call _execute
	movq %rax,%r13
	movq %r12,%rdi
	call _getfval
	movsd %xmm0,%xmm8
	movq %r13,%rdi
	call _getfval
	movsd %xmm0,%xmm1
	movsd %xmm8,%xmm0
	call _atan2
	movsd %xmm0,-8(%rbp)
	cmpb $4,1(%r13)
	jnz L1675
L1673:
	movq %r13,%rdi
	call _tfree
L1675:
	movq 8(%rbx),%rbx
	jmp L1643
L1666:
	movq %r12,%rdi
	call _getfval
	call _cos
	jmp L1742
L1664:
	movq %r12,%rdi
	call _getfval
	call _sin
	jmp L1742
L1681:
	testl $128,32(%r12)
	jz L1683
L1682:
	xorl %edi,%edi
	call _time
	cvtsi2sdq %rax,%xmm0
	jmp L1744
L1683:
	movq %r12,%rdi
	call _getfval
L1744:
	movsd %xmm0,-8(%rbp)
	movsd -8(%rbp),%xmm8
	cvttsd2siq %xmm8,%rdi
	call _srand
	movsd _srand_seed(%rip),%xmm0
	movsd %xmm0,-8(%rbp)
	movsd %xmm8,_srand_seed(%rip)
	jmp L1643
L1679:
	call _rand
	movl $32767,%ecx
	cltd 
	idivl %ecx
	cvtsi2sdl %edx,%xmm0
	divsd L1738(%rip),%xmm0
	jmp L1742
L1677:
	movl $___stdout,%edi
	call _fflush
	movq %r12,%rdi
	call _getsval
	movq %rax,%rdi
	call _system
	cvtsi2sdl %eax,%xmm0
	divsd L1739(%rip),%xmm0
	jmp L1742
L1656:
	movq %r12,%rdi
	call _getfval
	leaq -8(%rbp),%rdi
	call _modf
	jmp L1643
L1653:
	movq %r12,%rdi
	call _getfval
	call _log
	movl $L1654,%edi
	jmp L1743
L1658:
	movq %r12,%rdi
	call _getfval
	call _exp
	movl $L1659,%edi
	jmp L1743
L1661:
	movq %r12,%rdi
	call _getfval
	call _sqrt
	movl $L1662,%edi
L1743:
	call _errcheck
	jmp L1742
L1645:
	testl $16,32(%r12)
	jz L1647
L1646:
	movq 16(%r12),%rax
	cvtsi2sdl (%rax),%xmm0
	jmp L1742
L1647:
	movq %r12,%rdi
	call _getsval
	movq %rax,%rdi
	call _strlen
	cmpq $0,%rax
	jg L1649
L1650:
	movq %rax,%rcx
	andl $1,%ecx
	orq %rax,%rcx
	cvtsi2sdq %rcx,%xmm0
	addsd %xmm0,%xmm0
	jmp L1742
L1649:
	cvtsi2sdq %rax,%xmm0
L1742:
	movsd %xmm0,-8(%rbp)
	jmp L1643
L1642:
	pushq %r13
	pushq $L1721
	call _FATAL
	addq $16,%rsp
L1643:
	cmpb $4,1(%r12)
	jnz L1725
L1723:
	movq %r12,%rdi
	call _tfree
L1725:
	call _gettemp
	movq %rax,%r12
	movsd -8(%rbp),%xmm0
	movq %r12,%rdi
	call _setfval
	testq %rbx,%rbx
	jz L1741
L1726:
	pushq $L1729
	call _WARNING
	addq $8,%rsp
	jmp L1730
L1731:
	movq %rbx,%rdi
	call _execute
	movq 8(%rbx),%rbx
L1730:
	testq %rbx,%rbx
	jnz L1731
L1741:
	movq %r12,%rax
L1641:
	popq %r13
	popq %r12
	popq %rbx
	movsd -16(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


_printstat:
L1745:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1746:
	movq %rdi,%r13
	movq 8(%r13),%rdi
	testq %rdi,%rdi
	jnz L1749
L1748:
	movl $___stdout,%r12d
	jmp L1750
L1749:
	call _ptoi
	movq 16(%r13),%rsi
	movl %eax,%edi
	call _redirect
	movq %rax,%r12
L1750:
	movq (%r13),%rbx
	jmp L1751
L1752:
	movq %rbx,%rdi
	call _execute
	movq %rax,%r14
	movq %r14,%rdi
	call _getpssval
	movq %r12,%rsi
	movq %rax,%rdi
	call _fputs
	cmpb $4,1(%r14)
	jnz L1757
L1755:
	movq %r14,%rdi
	call _tfree
L1757:
	cmpq $0,8(%rbx)
	jnz L1759
L1758:
	movq _ORS(%rip),%rax
	jmp L1769
L1759:
	movq _OFS(%rip),%rax
L1769:
	movq %r12,%rsi
	movq (%rax),%rdi
	call _fputs
	movq 8(%rbx),%rbx
L1751:
	testq %rbx,%rbx
	jnz L1752
L1754:
	cmpq $0,8(%r13)
	jz L1763
L1761:
	movq %r12,%rdi
	call _fflush
L1763:
	testl $32,8(%r12)
	jz L1766
L1764:
	movq %r12,%rdi
	call _filename
	pushq %rax
	pushq $L1055
	call _FATAL
	addq $16,%rsp
L1766:
	movq _True(%rip),%rax
L1747:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_nullproc:
L1770:
L1771:
	xorl %eax,%eax
L1772:
	ret 


_redirect:
L1774:
	pushq %rbx
	pushq %r12
	pushq %r13
L1775:
	movl %edi,%ebx
	movq %rsi,%rdi
	call _execute
	movq %rax,%r13
	movq %r13,%rdi
	call _getsval
	movq %rax,%r12
	movq %r12,%rsi
	movl %ebx,%edi
	call _openfile
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L1779
L1777:
	pushq %r12
	pushq $L1780
	call _FATAL
	addq $16,%rsp
L1779:
	cmpb $4,1(%r13)
	jnz L1783
L1781:
	movq %r13,%rdi
	call _tfree
L1783:
	movq %rbx,%rax
L1776:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_stdinit:
L1785:
L1786:
	movl $16,_nfiles(%rip)
	movl $24,%esi
	movl $16,%edi
	call _calloc
	movq %rax,_files(%rip)
	testq %rax,%rax
	jnz L1790
L1788:
	movl _nfiles(%rip),%eax
	pushq %rax
	pushq $L1791
	call _FATAL
	addq $16,%rsp
L1790:
	movq _files(%rip),%rax
	movq $___stdin,(%rax)
	movq _files(%rip),%rax
	movq $L1792,8(%rax)
	movq _files(%rip),%rax
	movl $286,16(%rax)
	movq _files(%rip),%rax
	movq $___stdout,24(%rax)
	movq _files(%rip),%rax
	movq $L1793,32(%rax)
	movq _files(%rip),%rax
	movl $284,40(%rax)
	movq _files(%rip),%rax
	movq $___stderr,48(%rax)
	movq _files(%rip),%rax
	movq $L1794,56(%rax)
	movq _files(%rip),%rax
	movl $284,64(%rax)
L1787:
	ret 


_openfile:
L1795:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1796:
	movl %edi,%r13d
	movq %rsi,%r12
	xorl %ebx,%ebx
	cmpb $0,(%r12)
	jnz L1800
L1798:
	pushq $L1801
	call _FATAL
	addq $8,%rsp
L1800:
	xorl %r15d,%r15d
	jmp L1802
L1803:
	movq _files(%rip),%rax
	leaq (%r15,%r15,2),%r14
	shlq $3,%r14
	movq 8(%rax,%r14),%rsi
	testq %rsi,%rsi
	jz L1808
L1809:
	movq %r12,%rdi
	call _strcmp
	testl %eax,%eax
	jnz L1808
L1806:
	movq _files(%rip),%rcx
	movl 16(%r14,%rcx),%eax
	cmpl %eax,%r13d
	jz L1875
L1816:
	cmpl $281,%r13d
	jnz L1815
L1820:
	cmpl $284,%eax
	jz L1875
L1815:
	cmpl $14,%r13d
	jnz L1808
L1875:
	movq (%r14,%rcx),%rax
	jmp L1797
L1808:
	incl %r15d
L1802:
	cmpl _nfiles(%rip),%r15d
	jl L1803
L1805:
	cmpl $14,%r13d
	jz L1829
L1831:
	xorl %r15d,%r15d
	jmp L1833
L1834:
	movq _files(%rip),%rcx
	leaq (%r15,%r15,2),%rax
	shlq $3,%rax
	cmpq $0,(%rcx,%rax)
	jz L1836
L1839:
	incl %r15d
L1833:
	movl _nfiles(%rip),%r14d
	cmpl %r14d,%r15d
	jl L1834
L1836:
	cmpl %r14d,%r15d
	jl L1843
L1841:
	addl $16,%r14d
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rsi
	shlq $3,%rsi
	movq _files(%rip),%rdi
	call _realloc
	testq %rax,%rax
	movq %rax,-8(%rbp) # spill
	jnz L1846
L1844:
	pushq %r14
	pushq %r12
	pushq $L1847
	call _FATAL
	addq $24,%rsp
L1846:
	movslq _nfiles(%rip),%rax
	leaq (%rax,%rax,2),%rdi
	shlq $3,%rdi
	movl $384,%edx
	xorl %esi,%esi
	addq -8(%rbp),%rdi # spill
	call _memset
	movl %r14d,_nfiles(%rip)
	movq -8(%rbp),%rax # spill
	movq %rax,_files(%rip)
L1843:
	movl $___stdout,%edi
	call _fflush
	cmpl $284,%r13d
	jnz L1849
L1848:
	movl $L1851,%esi
	jmp L1877
L1849:
	cmpl $281,%r13d
	jnz L1853
L1852:
	movl $L1855,%esi
	movq %r12,%rdi
	call _fopen
	movq %rax,%rbx
	movl $284,%r13d
	jmp L1850
L1853:
	cmpl $124,%r13d
	jnz L1857
L1856:
	movl $L1851,%esi
	jmp L1878
L1857:
	cmpl $285,%r13d
	jnz L1860
L1859:
	movl $L1862,%esi
L1878:
	movq %r12,%rdi
	call _popen
	jmp L1876
L1860:
	cmpl $286,%r13d
	jnz L1864
L1863:
	movl $L1866,%esi
	movq %r12,%rdi
	call _strcmp
	testl %eax,%eax
	jnz L1868
L1867:
	movl $___stdin,%ebx
	jmp L1850
L1868:
	movl $L1862,%esi
L1877:
	movq %r12,%rdi
	call _fopen
L1876:
	movq %rax,%rbx
L1850:
	testq %rbx,%rbx
	jz L1873
L1871:
	movq %r12,%rdi
	call _tostring
	movl %r15d,%ecx
	movq _files(%rip),%rdx
	leaq (%rcx,%rcx,2),%rcx
	shlq $3,%rcx
	movq %rax,8(%rdx,%rcx)
	movq _files(%rip),%rax
	movq %rbx,(%rcx,%rax)
	movq _files(%rip),%rax
	movl %r13d,16(%rcx,%rax)
	jmp L1873
L1864:
	pushq %r13
	pushq $L1870
	call _FATAL
	addq $16,%rsp
L1873:
	movq %rbx,%rax
	jmp L1797
L1829:
	xorl %eax,%eax
L1797:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_filename:
L1879:
L1880:
	xorl %edx,%edx
L1882:
	cmpl _nfiles(%rip),%edx
	jge L1885
L1883:
	movq _files(%rip),%rax
	leaq (%rdx,%rdx,2),%rcx
	shlq $3,%rcx
	cmpq (%rax,%rcx),%rdi
	jz L1886
L1888:
	incl %edx
	jmp L1882
L1886:
	movq 8(%rax,%rcx),%rax
	ret
L1885:
	movl $L1890,%eax
L1881:
	ret 


_closefile:
L1892:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1893:
	movq (%rdi),%rdi
	call _execute
	movq %rax,%r14
	movq %r14,%rdi
	call _getsval
	movl $-1,%r13d
	xorl %r12d,%r12d
	jmp L1895
L1896:
	movq _files(%rip),%rax
	leaq (%r12,%r12,2),%rbx
	shlq $3,%rbx
	movq 8(%rax,%rbx),%rsi
	testq %rsi,%rsi
	jz L1901
L1902:
	movq 16(%r14),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L1901
L1899:
	movq _files(%rip),%rcx
	movq (%rbx,%rcx),%rax
	testl $32,8(%rax)
	jz L1908
L1906:
	pushq 8(%rbx,%rcx)
	pushq $L1909
	call _WARNING
	addq $16,%rsp
L1908:
	movq _files(%rip),%rcx
	movl 16(%rbx,%rcx),%eax
	cmpl $124,%eax
	jz L1910
L1913:
	cmpl $285,%eax
	jnz L1911
L1910:
	movq (%rbx,%rcx),%rdi
	call _pclose
	jmp L1931
L1911:
	movq (%rbx,%rcx),%rdi
	call _fclose
L1931:
	movl %eax,%r13d
	cmpl $-1,%r13d
	jnz L1919
L1917:
	movq _files(%rip),%rax
	pushq 8(%rbx,%rax)
	pushq $L1920
	call _WARNING
	addq $16,%rsp
L1919:
	cmpl $2,%r12d
	jle L1923
L1921:
	movq _files(%rip),%rax
	movq 8(%rbx,%rax),%rdi
	testq %rdi,%rdi
	jz L1923
L1924:
	call _free
	movq _files(%rip),%rax
	movq $0,8(%rbx,%rax)
L1923:
	movq _files(%rip),%rax
	movq $0,8(%rbx,%rax)
	movq _files(%rip),%rax
	movq $0,(%rbx,%rax)
L1901:
	incl %r12d
L1895:
	cmpl _nfiles(%rip),%r12d
	jl L1896
L1898:
	cmpb $4,1(%r14)
	jnz L1929
L1927:
	movq %r14,%rdi
	call _tfree
L1929:
	call _gettemp
	movq %rax,%rbx
	cvtsi2sdl %r13d,%xmm0
	movq %rbx,%rdi
	call _setfval
	movq %rbx,%rax
L1894:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_closeall:
L1932:
	pushq %rbx
	pushq %r12
L1933:
	xorl %r12d,%r12d
L1936:
	movq _files(%rip),%rcx
	leaq (%r12,%r12,2),%rbx
	shlq $3,%rbx
	movq (%rcx,%rbx),%rax
	testq %rax,%rax
	jz L1941
L1939:
	testl $32,8(%rax)
	jz L1944
L1942:
	pushq 8(%rcx,%rbx)
	pushq $L1909
	call _WARNING
	addq $16,%rsp
L1944:
	movq _files(%rip),%rcx
	movl 16(%rbx,%rcx),%eax
	cmpl $124,%eax
	jz L1945
L1948:
	cmpl $285,%eax
	jnz L1946
L1945:
	movq (%rbx,%rcx),%rdi
	call _pclose
	jmp L1947
L1946:
	movq (%rbx,%rcx),%rdi
	call _fclose
L1947:
	cmpl $-1,%eax
	jnz L1941
L1952:
	movq _files(%rip),%rax
	pushq 8(%rbx,%rax)
	pushq $L1955
	call _WARNING
	addq $16,%rsp
L1941:
	incl %r12d
	cmpl $16,%r12d
	jl L1936
L1934:
	popq %r12
	popq %rbx
	ret 


_flush_all:
L1956:
	pushq %rbx
L1957:
	xorl %ebx,%ebx
	jmp L1959
L1960:
	movq _files(%rip),%rax
	leaq (%rbx,%rbx,2),%rcx
	shlq $3,%rcx
	movq (%rax,%rcx),%rdi
	testq %rdi,%rdi
	jz L1965
L1963:
	call _fflush
L1965:
	incl %ebx
L1959:
	cmpl _nfiles(%rip),%ebx
	jl L1960
L1958:
	popq %rbx
	ret 


_sub:
L1966:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1967:
	movl _recsize(%rip),%eax
	movq %rdi,%rbx
	movl %eax,-12(%rbp)
	movslq %eax,%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L1971
L1969:
	pushq $L1972
	call _FATAL
	addq $8,%rsp
L1971:
	movq 24(%rbx),%rdi
	call _execute
	movq %rax,%r14
	movq %r14,%rdi
	call _getsval
	movq %rax,%r13
	movq (%rbx),%rax
	movq 8(%rbx),%rdi
	testq %rax,%rax
	jnz L1974
L1973:
	movq %rdi,%r12
	jmp L1975
L1974:
	call _execute
	movq %rax,%r15
	movq %r15,%rdi
	call _getsval
	movl $1,%esi
	movq %rax,%rdi
	call _makedfa
	movq %rax,%r12
	cmpb $4,1(%r15)
	jnz L1975
L1976:
	movq %r15,%rdi
	call _tfree
L1975:
	movq 16(%rbx),%rdi
	call _execute
	movq %rax,%rbx
	movq _False(%rip),%r15
	movq %r13,%rsi
	movq %r12,%rdi
	call _pmatch
	testl %eax,%eax
	jz L1981
L1979:
	movq %r13,-32(%rbp)
	movq _patbeg(%rip),%rdx
	incq %rdx
	subq %r13,%rdx
	movl $L1982,%r9d
	xorl %r8d,%r8d
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq -8(%rbp),%rax
	movq %rax,-24(%rbp)
	jmp L1983
L1984:
	leaq 1(%rcx),%rax
	movq %rax,-32(%rbp)
	movb (%rcx),%cl
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
L1983:
	movq -32(%rbp),%rcx
	cmpq _patbeg(%rip),%rcx
	jb L1984
L1985:
	movq %rbx,%rdi
	call _getsval
	movq %rax,-32(%rbp)
L1986:
	movq -32(%rbp),%rax
	movb (%rax),%al
	movq -24(%rbp),%rdx
	testb %al,%al
	jz L1988
L1987:
	addq $5,%rdx
	subq -8(%rbp),%rdx
	movl $L1982,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq -32(%rbp),%rcx
	movb (%rcx),%al
	cmpb $92,%al
	jnz L1990
L1989:
	leaq -32(%rbp),%rsi
	leaq -24(%rbp),%rdi
	call _backsub
	jmp L1986
L1990:
	cmpb $38,%al
	jnz L1993
L1992:
	incq %rcx
	movq %rcx,-32(%rbp)
	movl _patlen(%rip),%edx
	incl %edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L1982,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq _patbeg(%rip),%rdx
L1995:
	movslq _patlen(%rip),%rax
	addq _patbeg(%rip),%rax
	cmpq %rax,%rdx
	jae L1986
L1996:
	movb (%rdx),%cl
	incq %rdx
	movq -24(%rbp),%rsi
	leaq 1(%rsi),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rsi)
	jmp L1995
L1993:
	leaq 1(%rcx),%rax
	movq %rax,-32(%rbp)
	movb (%rcx),%cl
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
	jmp L1986
L1988:
	movb $0,(%rdx)
	movslq -12(%rbp),%rax
	movq -8(%rbp),%rcx
	addq %rcx,%rax
	cmpq %rax,-24(%rbp)
	jbe L2001
L1999:
	pushq %rcx
	pushq $L2002
	call _FATAL
	addq $16,%rsp
L2001:
	movslq _patlen(%rip),%rdi
	movq _patbeg(%rip),%rcx
	leaq (%rdi,%rcx),%rax
	movq %rax,-32(%rbp)
	testl %edi,%edi
	jnz L2006
L2010:
	cmpb $0,(%rcx)
	jnz L2003
L2006:
	testl %edi,%edi
	jz L2005
L2014:
	cmpb $0,-1(%rdi,%rcx)
	jz L2005
L2003:
	addq %rcx,%rdi
	call _strlen
	movq -24(%rbp),%rcx
	leaq 1(%rax,%rcx),%rdx
	subq -8(%rbp),%rdx
	movl $L1982,%r9d
	leaq -24(%rbp),%r8
	xorl %ecx,%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
L2018:
	movq -32(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-32(%rbp)
	movb (%rcx),%cl
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
	testb %cl,%cl
	jnz L2018
L2005:
	movslq -12(%rbp),%rax
	movq -8(%rbp),%rcx
	addq %rcx,%rax
	cmpq %rax,-24(%rbp)
	jbe L2023
L2021:
	pushq %rcx
	pushq $L2024
	call _FATAL
	addq $16,%rsp
L2023:
	movq -8(%rbp),%rsi
	movq %r14,%rdi
	call _setsval
	movq _True(%rip),%r15
L1981:
	cmpb $4,1(%r14)
	jnz L2027
L2025:
	movq %r14,%rdi
	call _tfree
L2027:
	cmpb $4,1(%rbx)
	jnz L2030
L2028:
	movq %rbx,%rdi
	call _tfree
L2030:
	movq -8(%rbp),%rdi
	call _free
	movq %r15,%rax
L1968:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gsub:
L2032:
	pushq %rbp
	movq %rsp,%rbp
	subq $72,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2033:
	movl _recsize(%rip),%eax
	movq %rdi,%r14
	movl %eax,-12(%rbp)
	movslq %eax,%rax
	movq %rax,%rdi
	call _malloc
	movq %rax,-8(%rbp)
	testq %rax,%rax
	jnz L2037
L2035:
	pushq $L2038
	call _FATAL
	addq $8,%rsp
L2037:
	xorl %r13d,%r13d
	xorl %r12d,%r12d
	movq 24(%r14),%rdi
	call _execute
	movq %rax,%rdi
	movq %rax,-48(%rbp) # spill
	call _getsval
	movq %rax,%rbx
	movq (%r14),%rax
	movq 8(%r14),%rdi
	testq %rax,%rax
	jnz L2040
L2039:
	movq %rdi,-72(%rbp) # spill
	jmp L2041
L2040:
	call _execute
	movq %rax,%r15
	movq %r15,%rdi
	call _getsval
	movl $1,%esi
	movq %rax,%rdi
	call _makedfa
	movq %rax,-72(%rbp) # spill
	cmpb $4,1(%r15)
	jnz L2041
L2042:
	movq %r15,%rdi
	call _tfree
L2041:
	movq 16(%r14),%rdi
	call _execute
	movq %rax,-56(%rbp) # spill
	movq %rbx,%rsi
	movq -72(%rbp),%rdi # spill
	call _pmatch
	testl %eax,%eax
	jz L2047
L2045:
	movq -72(%rbp),%rax # spill
	movl 8592(%rax),%eax
	movl %eax,-36(%rbp) # spill
	movq -72(%rbp),%rax # spill
	movl $2,8592(%rax)
	movq -8(%rbp),%rax
	movq %rax,-24(%rbp)
	movq -56(%rbp),%rdi # spill
	call _getsval
	movq %rax,-64(%rbp) # spill
L2048:
	cmpl $0,_patlen(%rip)
	jnz L2052
L2054:
	movq _patbeg(%rip),%rax
	cmpb $0,(%rax)
	jz L2052
L2051:
	testl %r13d,%r13d
	jnz L2060
L2058:
	incl %r12d
	movq -64(%rbp),%rax # spill
	movq %rax,-32(%rbp)
L2061:
	movq -32(%rbp),%rax
	cmpb $0,(%rax)
	jz L2060
L2062:
	movq -24(%rbp),%rdx
	addq $5,%rdx
	subq -8(%rbp),%rdx
	movl $L2064,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq -32(%rbp),%rcx
	movb (%rcx),%al
	cmpb $92,%al
	jnz L2066
L2065:
	leaq -32(%rbp),%rsi
	leaq -24(%rbp),%rdi
	call _backsub
	jmp L2061
L2066:
	cmpb $38,%al
	jnz L2069
L2068:
	incq %rcx
	movq %rcx,-32(%rbp)
	movl _patlen(%rip),%edx
	incl %edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L2064,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq _patbeg(%rip),%rdx
L2071:
	movslq _patlen(%rip),%rax
	addq _patbeg(%rip),%rax
	cmpq %rax,%rdx
	jae L2061
L2072:
	movb (%rdx),%cl
	incq %rdx
	movq -24(%rbp),%rsi
	leaq 1(%rsi),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rsi)
	jmp L2071
L2069:
	leaq 1(%rcx),%rax
	movq %rax,-32(%rbp)
	movb (%rcx),%cl
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
	jmp L2061
L2060:
	cmpb $0,(%rbx)
	jz L2078
L2077:
	movq -24(%rbp),%rdx
	addq $2,%rdx
	subq -8(%rbp),%rdx
	movl $L2064,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movb (%rbx),%cl
	incq %rbx
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
	movslq -12(%rbp),%rax
	movq -8(%rbp),%rcx
	addq %rcx,%rax
	cmpq %rax,-24(%rbp)
	jbe L2082
L2080:
	pushq %rcx
	pushq $L2083
	call _FATAL
	addq $16,%rsp
L2082:
	xorl %r13d,%r13d
	jmp L2053
L2052:
	incl %r12d
	movq %rbx,-32(%rbp)
	movq _patbeg(%rip),%rax
	subq %rbx,%rax
	movq -24(%rbp),%rcx
	leaq 1(%rax,%rcx),%rdx
	subq -8(%rbp),%rdx
	movl $L2064,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	jmp L2084
L2085:
	leaq 1(%rcx),%rax
	movq %rax,-32(%rbp)
	movb (%rcx),%cl
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
L2084:
	movq _patbeg(%rip),%rax
	movq -32(%rbp),%rcx
	cmpq %rcx,%rax
	ja L2085
L2086:
	movq -64(%rbp),%rax # spill
	movq %rax,-32(%rbp)
L2087:
	movq -32(%rbp),%rax
	cmpb $0,(%rax)
	jz L2089
L2088:
	movq -24(%rbp),%rdx
	addq $5,%rdx
	subq -8(%rbp),%rdx
	movl $L2064,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq -32(%rbp),%rcx
	movb (%rcx),%al
	cmpb $92,%al
	jnz L2091
L2090:
	leaq -32(%rbp),%rsi
	leaq -24(%rbp),%rdi
	call _backsub
	jmp L2087
L2091:
	cmpb $38,%al
	jnz L2094
L2093:
	incq %rcx
	movq %rcx,-32(%rbp)
	movl _patlen(%rip),%edx
	incl %edx
	movslq %edx,%rdx
	addq -24(%rbp),%rdx
	subq -8(%rbp),%rdx
	movl $L2064,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	movq _patbeg(%rip),%rdx
L2096:
	movslq _patlen(%rip),%rax
	addq _patbeg(%rip),%rax
	cmpq %rax,%rdx
	jae L2087
L2097:
	movb (%rdx),%cl
	incq %rdx
	movq -24(%rbp),%rsi
	leaq 1(%rsi),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rsi)
	jmp L2096
L2094:
	leaq 1(%rcx),%rax
	movq %rax,-32(%rbp)
	movb (%rcx),%cl
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
	jmp L2087
L2089:
	movslq _patlen(%rip),%rax
	movq _patbeg(%rip),%rcx
	leaq (%rax,%rcx),%rbx
	testl %eax,%eax
	jz L2078
L2107:
	cmpb $0,(%rax,%rcx)
	jz L2078
L2103:
	cmpb $0,-1(%rax,%rcx)
	jz L2078
L2102:
	movslq -12(%rbp),%rax
	movq -8(%rbp),%rcx
	addq %rcx,%rax
	cmpq %rax,-24(%rbp)
	jbe L2114
L2112:
	pushq %rcx
	pushq $L2115
	call _FATAL
	addq $16,%rsp
L2114:
	movl $1,%r13d
L2053:
	movq %rbx,%rsi
	movq -72(%rbp),%rdi # spill
	call _pmatch
	testl %eax,%eax
	jnz L2048
L2049:
	movq %rbx,-32(%rbp)
	movq %rbx,%rdi
	call _strlen
	movq -24(%rbp),%rcx
	leaq 1(%rax,%rcx),%rdx
	subq -8(%rbp),%rdx
	movl $L2064,%r9d
	leaq -24(%rbp),%r8
	xorl %ecx,%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
L2116:
	movq -32(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-32(%rbp)
	movb (%rcx),%cl
	movq -24(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-24(%rbp)
	movb %cl,(%rdx)
	testb %cl,%cl
	jnz L2116
L2078:
	movslq -12(%rbp),%rax
	movq -8(%rbp),%rdx
	addq %rdx,%rax
	movq -24(%rbp),%rcx
	cmpq %rax,%rcx
	jae L2120
L2119:
	movb $0,(%rcx)
	jmp L2121
L2120:
	cmpb $0,-1(%rcx)
	jz L2121
L2122:
	pushq %rdx
	pushq $L2125
	call _FATAL
	addq $16,%rsp
L2121:
	movq -8(%rbp),%rsi
	movq -48(%rbp),%rdi # spill
	call _setsval
	movl -36(%rbp),%ecx # spill
	movq -72(%rbp),%rax # spill
	movl %ecx,8592(%rax)
L2047:
	movq -48(%rbp),%rax # spill
	cmpb $4,1(%rax)
	jnz L2128
L2126:
	movq -48(%rbp),%rdi # spill
	call _tfree
L2128:
	movq -56(%rbp),%rax # spill
	cmpb $4,1(%rax)
	jnz L2131
L2129:
	movq -56(%rbp),%rdi # spill
	call _tfree
L2131:
	call _gettemp
	movq %rax,%rbx
	movl $1,32(%rbx)
	cvtsi2sdl %r12d,%xmm0
	movsd %xmm0,24(%rbx)
	movq -8(%rbp),%rdi
	call _free
	movq %rbx,%rax
L2034:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_backsub:
L2133:
L2134:
	movq (%rdi),%r9
	movq (%rsi),%rdx
	leaq 1(%rdx),%rcx
	movb 1(%rdx),%al
	cmpb $92,%al
	jnz L2137
L2136:
	leaq 2(%rdx),%rcx
	movb 2(%rdx),%al
	cmpb $92,%al
	jnz L2140
L2142:
	cmpb $38,3(%rdx)
	jnz L2140
L2139:
	movb $92,(%r9)
	movb $38,1(%r9)
	leaq 2(%r9),%r8
	leaq 4(%rdx),%rcx
	jmp L2138
L2140:
	leaq 1(%r9),%r8
	cmpb $38,%al
	jnz L2147
L2146:
	movb $92,(%r9)
	jmp L2138
L2147:
	movb (%rdx),%al
	movb %al,(%r9)
	movb 1(%rdx),%al
	leaq 2(%rdx),%rcx
	movb %al,1(%r9)
	leaq 2(%r9),%r8
	jmp L2138
L2137:
	leaq 1(%r9),%r8
	cmpb $38,%al
	jnz L2150
L2149:
	leaq 2(%rdx),%rcx
	jmp L2153
L2150:
	movb (%rdx),%al
L2153:
	movb %al,(%r9)
L2138:
	movq %r8,(%rdi)
	movq %rcx,(%rsi)
L2135:
	ret 

L1:
	.byte 0
L898:
	.byte 37,100,0
L1102:
	.byte 105,108,108,101,103,97,108,32
	.byte 97,114,105,116,104,109,101,116
	.byte 105,99,32,111,112,101,114,97
	.byte 116,111,114,32,37,100,0
L1847:
	.byte 99,97,110,110,111,116,32,103
	.byte 114,111,119,32,102,105,108,101
	.byte 115,32,102,111,114,32,37,115
	.byte 32,97,110,100,32,37,100,32
	.byte 102,105,108,101,115,0
L704:
	.byte 117,110,107,110,111,119,110,32
	.byte 114,101,108,97,116,105,111,110
	.byte 97,108,32,111,112,101,114,97
	.byte 116,111,114,32,37,100,0
L451:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,102,111
	.byte 114,32,37,115,91,37,115,46
	.byte 46,46,93,0
L500:
	.byte 97,119,107,100,101,108,101,116
	.byte 101,0
L169:
	.byte 105,108,108,101,103,97,108,32
	.byte 98,114,101,97,107,44,32,99
	.byte 111,110,116,105,110,117,101,44
	.byte 32,110,101,120,116,32,111,114
	.byte 32,110,101,120,116,102,105,108
	.byte 101,32,102,114,111,109,32,69
	.byte 78,68,0
L1174:
	.byte 114,101,97,100,32,118,97,108
	.byte 117,101,32,111,102,0
L253:
	.byte 115,116,97,114,116,32,101,120
	.byte 101,99,32,111,102,32,37,115
	.byte 44,32,102,112,61,37,100,10
	.byte 0
L317:
	.byte 37,115,32,114,101,116,117,114
	.byte 110,115,32,37,103,32,124,37
	.byte 115,124,32,37,111,10,0
L338:
	.byte 97,114,103,117,109,101,110,116
	.byte 32,35,37,100,32,111,102,32
	.byte 102,117,110,99,116,105,111,110
	.byte 32,37,115,32,119,97,115,32
	.byte 110,111,116,32,115,117,112,112
	.byte 108,105,101,100,0
L213:
	.byte 101,118,97,108,117,97,116,101
	.byte 32,97,114,103,115,91,37,100
	.byte 93,44,32,102,112,61,37,100
	.byte 58,10,0
L1920:
	.byte 105,47,111,32,101,114,114,111
	.byte 114,32,111,99,99,117,114,114
	.byte 101,100,32,99,108,111,115,105
	.byte 110,103,32,37,115,0
L1209:
	.byte 105,108,108,101,103,97,108,32
	.byte 97,115,115,105,103,110,109,101
	.byte 110,116,32,111,112,101,114,97
	.byte 116,111,114,32,37,100,0
L257:
	.byte 102,105,110,105,115,104,101,100
	.byte 32,101,120,101,99,32,111,102
	.byte 32,37,115,44,32,102,112,61
	.byte 37,100,10,0
L1870:
	.byte 105,108,108,101,103,97,108,32
	.byte 114,101,100,105,114,101,99,116
	.byte 105,111,110,32,37,100,0
L1654:
	.byte 108,111,103,0
L721:
	.byte 102,114,101,101,105,110,103,32
	.byte 37,115,32,37,115,32,37,111
	.byte 10,0
L379:
	.byte 105,108,108,101,103,97,108,32
	.byte 106,117,109,112,32,116,121,112
	.byte 101,32,37,100,0
L1100:
	.byte 112,111,119,0
L877:
	.byte 102,111,114,109,97,116,51,0
L1801:
	.byte 110,117,108,108,32,102,105,108
	.byte 101,32,110,97,109,101,32,105
	.byte 110,32,112,114,105,110,116,32
	.byte 111,114,32,103,101,116,108,105
	.byte 110,101,0
L869:
	.byte 102,111,114,109,97,116,50,0
L1290:
	.byte 115,112,108,105,116,58,32,115
	.byte 61,124,37,115,124,44,32,97
	.byte 61,37,115,44,32,115,101,112
	.byte 61,124,37,115,124,10,0
L182:
	.byte 99,97,108,108,105,110,103,32
	.byte 117,110,100,101,102,105,110,101
	.byte 100,32,102,117,110,99,116,105
	.byte 111,110,32,37,115,0
L334:
	.byte 97,114,103,40,37,100,41,44
	.byte 32,102,112,45,62,110,97,114
	.byte 103,115,61,37,100,10,0
L1855:
	.byte 97,0
L2002:
	.byte 115,117,98,32,114,101,115,117
	.byte 108,116,49,32,37,46,51,48
	.byte 115,32,116,111,111,32,98,105
	.byte 103,59,32,99,97,110,39,116
	.byte 32,104,97,112,112,101,110,0
L27:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,37,115,0
L1672:
	.byte 97,116,97,110,50,32,114,101
	.byte 113,117,105,114,101,115,32,116
	.byte 119,111,32,97,114,103,117,109
	.byte 101,110,116,115,59,32,114,101
	.byte 116,117,114,110,105,110,103,32
	.byte 49,46,48,0
L1082:
	.byte 100,105,118,105,115,105,111,110
	.byte 32,98,121,32,122,101,114,111
	.byte 0
L1051:
	.byte 119,114,105,116,101,32,101,114
	.byte 114,111,114,32,111,110,32,115
	.byte 116,100,111,117,116,0
L956:
	.byte 102,111,114,109,97,116,54,0
L971:
	.byte 102,111,114,109,97,116,55,0
L1286:
	.byte 105,108,108,101,103,97,108,32
	.byte 116,121,112,101,32,111,102,32
	.byte 115,112,108,105,116,0
L450:
	.byte 97,114,114,97,121,0
L1026:
	.byte 115,112,114,105,110,116,102,32
	.byte 115,116,114,105,110,103,32,37
	.byte 46,51,48,115,46,46,46,32
	.byte 116,111,111,32,108,111,110,103
	.byte 46,32,32,99,97,110,39,116
	.byte 32,104,97,112,112,101,110,46
	.byte 0
L1791:
	.byte 99,97,110,39,116,32,97,108
	.byte 108,111,99,97,116,101,32,102
	.byte 105,108,101,32,109,101,109,111
	.byte 114,121,32,102,111,114,32,37
	.byte 117,32,102,105,108,101,115,0
L366:
	.byte 98,97,100,32,116,121,112,101
	.byte 32,118,97,114,105,97,98,108
	.byte 101,32,37,100,0
L1972:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,115,117,98,0
L492:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,97,100,101,108,101,116,101
	.byte 0
L744:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,116,101,109,112,111,114,97
	.byte 114,105,101,115,0
L1866:
	.byte 45,0
L816:
	.byte 115,117,98,115,116,114,58,32
	.byte 109,61,37,100,44,32,110,61
	.byte 37,100,44,32,115,61,37,115
	.byte 10,0
L197:
	.byte 99,97,108,108,105,110,103,32
	.byte 37,115,44,32,37,100,32,97
	.byte 114,103,115,32,40,37,100,32
	.byte 105,110,32,100,101,102,110,41
	.byte 44,32,102,112,61,37,100,10
	.byte 0
L201:
	.byte 102,117,110,99,116,105,111,110
	.byte 32,37,115,32,99,97,108,108
	.byte 101,100,32,119,105,116,104,32
	.byte 37,100,32,97,114,103,115,44
	.byte 32,117,115,101,115,32,111,110
	.byte 108,121,32,37,100,0
L756:
	.byte 116,114,121,105,110,103,32,116
	.byte 111,32,97,99,99,101,115,115
	.byte 32,111,117,116,32,111,102,32
	.byte 114,97,110,103,101,32,102,105
	.byte 101,108,100,32,37,115,0
L634:
	.byte 117,110,107,110,111,119,110,32
	.byte 98,111,111,108,101,97,110,32
	.byte 111,112,101,114,97,116,111,114
	.byte 32,37,100,0
L125:
	.byte 105,108,108,101,103,97,108,32
	.byte 98,114,101,97,107,44,32,99
	.byte 111,110,116,105,110,117,101,44
	.byte 32,110,101,120,116,32,111,114
	.byte 32,110,101,120,116,102,105,108
	.byte 101,32,102,114,111,109,32,66
	.byte 69,71,73,78,0
L539:
	.byte 105,110,116,101,115,116,0
L501:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,100,101
	.byte 108,101,116,105,110,103,32,37
	.byte 115,91,37,115,46,46,46,93
	.byte 0
L1955:
	.byte 105,47,111,32,101,114,114,111
	.byte 114,32,111,99,99,117,114,114
	.byte 101,100,32,119,104,105,108,101
	.byte 32,99,108,111,115,105,110,103
	.byte 32,37,115,0
L395:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,103,101,116,108,105,110,101
	.byte 0
L20:
	.byte 97,100,106,98,117,102,32,37
	.byte 115,58,32,37,100,32,37,100
	.byte 32,40,112,98,117,102,61,37
	.byte 112,44,32,116,98,117,102,61
	.byte 37,112,41,10,0
L531:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,105,110,116,101,115,116,0
L205:
	.byte 102,117,110,99,116,105,111,110
	.byte 32,37,115,32,104,97,115,32
	.byte 37,100,32,97,114,103,117,109
	.byte 101,110,116,115,44,32,108,105
	.byte 109,105,116,32,37,100,0
L1729:
	.byte 119,97,114,110,105,110,103,58
	.byte 32,102,117,110,99,116,105,111
	.byte 110,32,104,97,115,32,116,111
	.byte 111,32,109,97,110,121,32,97
	.byte 114,103,117,109,101,110,116,115
	.byte 0
L952:
	.byte 37,115,0
L1192:
	.byte 100,105,118,105,115,105,111,110
	.byte 32,98,121,32,122,101,114,111
	.byte 32,105,110,32,47,61,0
L2115:
	.byte 103,115,117,98,32,114,101,115
	.byte 117,108,116,49,32,37,46,51
	.byte 48,115,32,116,111,111,32,98
	.byte 105,103,59,32,99,97,110,39
	.byte 116,32,104,97,112,112,101,110
	.byte 0
L1228:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,99,111,110
	.byte 99,97,116,101,110,97,116,105
	.byte 110,103,32,37,46,49,53,115
	.byte 46,46,46,32,97,110,100,32
	.byte 37,46,49,53,115,46,46,46
	.byte 0
L189:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,115,116,97,99,107,32,102
	.byte 114,97,109,101,115,32,99,97
	.byte 108,108,105,110,103,32,37,115
	.byte 0
L1198:
	.byte 100,105,118,105,115,105,111,110
	.byte 32,98,121,32,122,101,114,111
	.byte 32,105,110,32,37,37,61,0
L76:
	.byte 105,108,108,101,103,97,108,32
	.byte 115,116,97,116,101,109,101,110
	.byte 116,0
L2038:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,103,115,117,98,0
L1285:
	.byte 40,114,101,103,101,120,112,114
	.byte 41,0
L1890:
	.byte 63,63,63,0
L764:
	.byte 105,108,108,101,103,97,108,32
	.byte 102,105,101,108,100,32,36,40
	.byte 37,115,41,44,32,110,97,109
	.byte 101,32,34,37,115,34,0
L1793:
	.byte 47,100,101,118,47,115,116,100
	.byte 111,117,116,0
L943:
	.byte 110,111,116,32,101,110,111,117
	.byte 103,104,32,97,114,103,115,32
	.byte 105,110,32,112,114,105,110,116
	.byte 102,40,37,115,41,0
L1022:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,97,119,107,115,112,114,105
	.byte 110,116,102,0
L878:
	.byte 102,111,114,109,97,116,32,105
	.byte 116,101,109,32,37,46,51,48
	.byte 115,46,46,46,32,114,97,110
	.byte 32,102,111,114,109,97,116,40
	.byte 41,32,111,117,116,32,111,102
	.byte 32,109,101,109,111,114,121,0
L1862:
	.byte 114,0
L902:
	.byte 102,111,114,109,97,116,0
L249:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,115,116,97,99,107,32,102
	.byte 114,97,109,101,115,32,105,110
	.byte 32,37,115,0
L2083:
	.byte 103,115,117,98,32,114,101,115
	.byte 117,108,116,48,32,37,46,51
	.byte 48,115,32,116,111,111,32,98
	.byte 105,103,59,32,99,97,110,39
	.byte 116,32,104,97,112,112,101,110
	.byte 0
L2024:
	.byte 115,117,98,32,114,101,115,117
	.byte 108,116,50,32,37,46,51,48
	.byte 115,32,116,111,111,32,98,105
	.byte 103,59,32,99,97,110,39,116
	.byte 32,104,97,112,112,101,110,0
L2125:
	.byte 103,115,117,98,32,114,101,115
	.byte 117,108,116,50,32,37,46,51
	.byte 48,115,32,116,114,117,110,99
	.byte 97,116,101,100,59,32,99,97
	.byte 110,39,116,32,104,97,112,112
	.byte 101,110,0
L232:
	.byte 99,97,110,39,116,32,117,115
	.byte 101,32,102,117,110,99,116,105
	.byte 111,110,32,37,115,32,97,115
	.byte 32,97,114,103,117,109,101,110
	.byte 116,32,105,110,32,37,115,0
L1851:
	.byte 119,0
L219:
	.byte 40,97,114,114,97,121,41,0
L938:
	.byte 119,101,105,114,100,32,112,114
	.byte 105,110,116,102,32,99,111,110
	.byte 118,101,114,115,105,111,110,32
	.byte 37,115,0
L1794:
	.byte 47,100,101,118,47,115,116,100
	.byte 101,114,114,0
L442:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,97,114,114,97,121,0
L464:
	.byte 109,97,107,105,110,103,32,37
	.byte 115,32,105,110,116,111,32,97
	.byte 110,32,97,114,114,97,121,10
	.byte 0
L947:
	.byte 102,111,114,109,97,116,53,0
L909:
	.byte 102,111,114,109,97,116,52,0
L217:
	.byte 97,114,103,115,91,37,100,93
	.byte 58,32,37,115,32,37,102,32
	.byte 60,37,115,62,44,32,116,61
	.byte 37,111,10,0
L1088:
	.byte 100,105,118,105,115,105,111,110
	.byte 32,98,121,32,122,101,114,111
	.byte 32,105,110,32,109,111,100,0
L734:
	.byte 116,101,109,112,99,101,108,108
	.byte 32,108,105,115,116,32,105,115
	.byte 32,99,117,114,100,108,101,100
	.byte 0
L1721:
	.byte 105,108,108,101,103,97,108,32
	.byte 102,117,110,99,116,105,111,110
	.byte 32,116,121,112,101,32,37,100
	.byte 0
L972:
	.byte 104,117,103,101,32,115,116,114
	.byte 105,110,103,47,102,111,114,109
	.byte 97,116,32,40,37,100,32,99
	.byte 104,97,114,115,41,32,105,110
	.byte 32,112,114,105,110,116,102,32
	.byte 37,46,51,48,115,46,46,46
	.byte 32,114,97,110,32,102,111,114
	.byte 109,97,116,40,41,32,111,117
	.byte 116,32,111,102,32,109,101,109
	.byte 111,114,121,0
L857:
	.byte 102,111,114,109,97,116,49,0
L218:
	.byte 40,110,117,108,108,41,0
L982:
	.byte 99,97,110,39,116,32,104,97
	.byte 112,112,101,110,58,32,98,97
	.byte 100,32,99,111,110,118,101,114
	.byte 115,105,111,110,32,37,99,32
	.byte 105,110,32,102,111,114,109,97
	.byte 116,40,41,0
L1659:
	.byte 101,120,112,0
L1037:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,97,119,107,112,114,105,110
	.byte 116,102,0
L2064:
	.byte 103,115,117,98,0
L1792:
	.byte 47,100,101,118,47,115,116,100
	.byte 105,110,0
L1662:
	.byte 115,113,114,116,0
L853:
	.byte 111,117,116,32,111,102,32,109
	.byte 101,109,111,114,121,32,105,110
	.byte 32,102,111,114,109,97,116,40
	.byte 41,0
L1909:
	.byte 105,47,111,32,101,114,114,111
	.byte 114,32,111,99,99,117,114,114
	.byte 101,100,32,111,110,32,37,115
	.byte 0
L1055:
	.byte 119,114,105,116,101,32,101,114
	.byte 114,111,114,32,111,110,32,37
	.byte 115,0
L1982:
	.byte 115,117,98,0
L1780:
	.byte 99,97,110,39,116,32,111,112
	.byte 101,110,32,102,105,108,101,32
	.byte 37,115,0
L1041:
	.byte 112,114,105,110,116,102,32,115
	.byte 116,114,105,110,103,32,37,46
	.byte 51,48,115,46,46,46,32,116
	.byte 111,111,32,108,111,110,103,46
	.byte 32,32,99,97,110,39,116,32
	.byte 104,97,112,112,101,110,46,0
.globl _env
.comm _env, 128, 8
.globl _tmps
.comm _tmps, 8, 8
.globl _files
.comm _files, 8, 8
.globl _nfiles
.comm _nfiles, 4, 4

.globl _jbreak
.globl _nullproc
.globl _fldbld
.globl _free
.globl _patbeg
.globl _execute
.globl _fieldadr
.globl _sin
.globl _sprintf
.globl _jnextfile
.globl _closeall
.globl _printstat
.globl _ORS
.globl _FS
.globl _stdinit
.globl _relop
.globl _whilestat
.globl _substr
.globl _cos
.globl _realloc
.globl _longjmp
.globl _condexpr
.globl _array
.globl _getsval
.globl _curnode
.globl _setfval
.globl _winner
.globl _fopen
.globl _dopa2
.globl _sindex
.globl _makesymtab
.globl _dbg
.globl ___setjmp
.globl ___stdout
.globl _pairstack
.globl _donefld
.globl _srand_seed
.globl _awkdelete
.globl _malloc
.globl _files
.globl _rlengthloc
.globl _pastat
.globl _adjbuf
.globl _is_number
.globl _freesymtab
.globl _incrdecr
.globl _awksprintf
.globl _record
.globl _False
.globl _filename
.globl _rand
.globl _program
.globl _proctab
.globl _flush_all
.globl _awkprintf
.globl _run
.globl _errorflag
.globl _awkgetline
.globl _setsymtab
.globl _log
.globl _forstat
.globl _atoi
.globl _printf
.globl _pmatch
.globl _nframe
.globl _tostring
.globl _ptoi
.globl _SUBSEP
.globl _OFS
.globl _patlen
.globl _strcat
.globl _pow
.globl _fflush
.globl _dostat
.globl _exp
.globl _nfiles
.globl _openfile
.globl _gettemp
.globl _funnyvar
.globl _redirect
.globl _strcmp
.globl _calloc
.globl _getpssval
.globl _makedfa
.globl ___ctype
.globl _fldtab
.globl _cat
.globl _boolop
.globl _WARNING
.globl _pclose
.globl _indirect
.globl _tfree
.globl _recsize
.globl _tolower
.globl _arg
.globl _errcheck
.globl ___stderr
.globl _fp
.globl _closefile
.globl _format
.globl ___stdin
.globl _frame
.globl _gsub
.globl _ifstat
.globl _intest
.globl _sqrt
.globl _fclose
.globl _matchop
.globl _jcont
.globl _ipow
.globl _readrec
.globl _nextfile
.globl _arith
.globl _popen
.globl _call
.globl _lookup
.globl _memset
.globl _split
.globl _assign
.globl _getnf
.globl _strdup
.globl _fputs
.globl _fwrite
.globl _backsub
.globl _True
.globl _copycell
.globl _system
.globl _tmps
.globl _sub
.globl _jump
.globl _getrec
.globl _freeelem
.globl _modf
.globl _rstartloc
.globl _time
.globl _strlen
.globl _jret
.globl _jnext
.globl _donerec
.globl _srand
.globl _env
.globl _FATAL
.globl _match
.globl _strcpy
.globl _jexit
.globl _atan2
.globl _bltin
.globl _instat
.globl _getfval
.globl _setsval
.globl _recbld
.globl _toupper
.globl _nematch
.globl _atof
