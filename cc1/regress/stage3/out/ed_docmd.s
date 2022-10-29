.local L4
.comm L4, 256, 1
.text
.align 2
L448:
	.short L31-_docmd
	.short L425-_docmd
	.short L45-_docmd
	.short L63-_docmd
	.short L86-_docmd
	.short L121-_docmd
	.short L425-_docmd
	.short L425-_docmd
	.short L147-_docmd
	.short L164-_docmd
	.short L179-_docmd
	.short L207-_docmd
	.short L221-_docmd
	.short L425-_docmd
	.short L425-_docmd
	.short L236-_docmd
	.short L250-_docmd
	.short L269-_docmd
	.short L298-_docmd
	.short L333-_docmd
	.short L425-_docmd
	.short L425-_docmd
	.short L348-_docmd
	.short L374-_docmd
	.short L425-_docmd
	.short L395-_docmd

_docmd:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movl %edi,%r12d
	xorl %ebx,%ebx
	jmp L5
L8:
	cmpb $9,%al
	jnz L10
L9:
	incq %rdx
	movq %rdx,_inptr(%rip)
L5:
	movq _inptr(%rip),%rdx
	movb (%rdx),%al
	cmpb $32,%al
	jz L8
L10:
	leaq 1(%rdx),%rax
	movq %rax,_inptr(%rip)
	movsbl (%rdx),%ecx
	cmpl $97,%ecx
	jl L437
L439:
	cmpl $122,%ecx
	jg L437
L436:
	leal -97(%rcx),%eax
	movzwl L448(,%rax,2),%eax
	addl $_docmd,%eax
	jmp *%rax
L179:
	movq _inptr(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L183
L182:
	cmpb $9,%al
	jnz L184
L183:
	incq %rcx
	movq %rcx,_inptr(%rip)
	jmp L179
L184:
	cmpb $97,%al
	jl L425
L189:
	cmpb $122,%al
	jg L425
L191:
	leaq 1(%rcx),%rax
	movq %rax,_inptr(%rip)
	movsbl (%rcx),%eax
	movb 1(%rcx),%cl
	cmpb $32,%cl
	jz L199
L201:
	cmpb $9,%cl
	jz L199
L202:
	cmpb $10,%cl
	jnz L425
L199:
	subl $97,%eax
	movslq %eax,%rax
	movl _line1(%rip),%ecx
	movl %ecx,_mark(,%rax,4)
	jmp L13
L395:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L398:
	movq _inptr(%rip),%rax
	movb (%rax),%al
	cmpb $45,%al
	jz L403
L431:
	cmpb $46,%al
	jz L409
L432:
	cmpb $43,%al
	jz L416
L433:
	cmpb $10,%al
	jnz L13
L416:
	movl _line1(%rip),%edi
	leal 21(%rdi),%esi
	call _doprnt
	cmpl $0,%eax
	jge L13
	jl L425
L409:
	movl _line1(%rip),%edi
	leal 10(%rdi),%esi
	addl $-11,%edi
	call _doprnt
	cmpl $0,%eax
	jge L13
	jl L425
L403:
	movl _line1(%rip),%esi
	leal -21(%rsi),%edi
	call _doprnt
	cmpl $0,%eax
	jge L13
	jl L425
L374:
	cmpb $10,1(%rdx)
	jnz L425
L382:
	cmpl $0,_nlines(%rip)
	jnz L425
L383:
	testl %r12d,%r12d
	jnz L425
L379:
	call _getfn
	movq %rax,%rdx
	testq %rdx,%rdx
	jz L425
L388:
	xorl %ecx,%ecx
	movl _lastln(%rip),%esi
	movl $1,%edi
	call _dowrite
	cmpl $0,%eax
	jge L427
	jl L425
L333:
	call _getone
	movl %eax,%ebx
	cmpl $0,%ebx
	jl L425
L336:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L340:
	movl %ebx,%edi
	call _transfer
	cmpl $0,%eax
	jl L425
	jge L428
L298:
	cmpb $101,1(%rdx)
	jz L299
L303:
	movq _inptr(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L307
L306:
	cmpb $9,%al
	jnz L308
L307:
	incq %rcx
	movq %rcx,_inptr(%rip)
	jmp L303
L308:
	call _optpat
	movq %rax,%r13
	testq %r13,%r13
	jz L425
L312:
	movl $L4,%edi
	call _getrhs
	movl %eax,%r12d
	cmpl $0,%r12d
	jl L425
L316:
	movq _inptr(%rip),%rax
	cmpb $112,(%rax)
	movl $1,%eax
	cmovzl %eax,%ebx
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L323:
	movl %ebx,%ecx
	movl %r12d,%edx
	movl $L4,%esi
	movq %r13,%rdi
	call _subst
	cmpl $0,%eax
	jz L13
	jl L425
	jg L428
L299:
	call _set
	jmp L3
L269:
	movl _nlines(%rip),%eax
	cmpl $1,%eax
	jg L425
L272:
	testl %eax,%eax
	jnz L276
L274:
	movl _lastln(%rip),%eax
	movl %eax,_line2(%rip)
L276:
	movb 1(%rdx),%al
	cmpb $32,%al
	jz L282
L284:
	cmpb $9,%al
	jz L282
L285:
	cmpb $10,%al
	jnz L425
L282:
	call _getfn
	movq %rax,%rsi
	testq %rsi,%rsi
	jz L425
L291:
	movl _line2(%rip),%edi
	call _doread
	cmpl $0,%eax
	jge L428
	jl L3
L250:
	cmpl $0,_fchanged(%rip)
	jz L255
	jnz L426
L221:
	call _getone
	movl %eax,%ebx
	cmpl $0,%ebx
	jl L425
L224:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L228:
	movl %ebx,%edi
	call _move
	cmpl $0,%eax
	jl L425
	jge L428
L207:
	cmpb $10,1(%rdx)
	jnz L425
L210:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L214:
	movl _line2(%rip),%esi
	movl _line1(%rip),%edi
	call _dolst
	cmpl $0,%eax
	jge L13
	jl L425
L164:
	cmpb $10,1(%rdx)
	jnz L425
L168:
	movl _curln(%rip),%edi
	leal 1(%rdi),%esi
	call _deflt
	cmpl $0,%eax
	jl L425
L170:
	movl _line2(%rip),%esi
	movl _line1(%rip),%edi
	call _join
	cmpl $0,%eax
	jge L13
	jl L425
L147:
	cmpb $10,1(%rdx)
	jnz L425
L151:
	cmpl $1,_nlines(%rip)
	jg L425
L153:
	movl _line1(%rip),%edi
	decl %edi
	jns L161
L159:
	movl _lastln(%rip),%edi
L161:
	movl %r12d,%esi
	call _append
	cmpl $0,%eax
	jl L425
	jge L428
L121:
	cmpl $0,_nlines(%rip)
	jg L425
L124:
	movb 1(%rdx),%al
	cmpb $32,%al
	jz L131
L133:
	cmpb $9,%al
	jz L131
L134:
	cmpb $10,%al
	jnz L425
L131:
	call _getfn
	movq %rax,%rsi
	testq %rsi,%rsi
	jz L425
L140:
	cmpl $0,_nofname(%rip)
	jz L143
L142:
	pushq $_fname
	pushq $L145
	jmp L449
L143:
	movl $_fname,%edi
	call _strcpy
	jmp L13
L86:
	cmpl $0,_nlines(%rip)
	jg L425
L89:
	cmpl $0,_fchanged(%rip)
	jz L95
L426:
	movl $0,_fchanged(%rip)
	jmp L425
L63:
	cmpb $10,1(%rdx)
	jnz L425
L66:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L70:
	movl _line2(%rip),%esi
	movl _line1(%rip),%edi
	call _del
	cmpl $0,%eax
	jl L425
L74:
	movl _curln(%rip),%ecx
	movl _lastln(%rip),%eax
	incl %ecx
	cmpl %ecx,%eax
	jl L428
L80:
	testl %ecx,%ecx
	jz L428
L76:
	cmpl %ecx,%eax
	movl $0,%eax
	cmovgel %ecx,%eax
	movl %eax,_curln(%rip)
	jmp L428
L45:
	cmpb $10,1(%rdx)
	jnz L425
L48:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L52:
	movl _line2(%rip),%esi
	movl _line1(%rip),%edi
	call _del
	cmpl $0,%eax
	jl L425
L56:
	movl %r12d,%esi
	movl _curln(%rip),%edi
	call _append
	cmpl $0,%eax
	jl L425
	jge L428
L31:
	cmpb $10,1(%rdx)
	jnz L425
L35:
	cmpl $1,_nlines(%rip)
	jg L425
L37:
	movl %r12d,%esi
	movl _line1(%rip),%edi
	call _append
	cmpl $0,%eax
	jl L425
L428:
	movl $1,_fchanged(%rip)
	jmp L13
L437:
	cmpl $10,%ecx
	jz L15
	jl L425
L441:
	cmpl $87,%ecx
	jz L348
	jg L425
L442:
	cmpb $61,%cl
	jz L28
L443:
	cmpb $69,%cl
	jz L95
L444:
	cmpb $80,%cl
	jz L236
L445:
	cmpb $81,%cl
	jnz L425
L255:
	cmpb $10,1(%rdx)
	jnz L425
L263:
	cmpl $0,_nlines(%rip)
	jnz L425
L264:
	testl %r12d,%r12d
	jnz L425
L427:
	movl $-1,%eax
	jmp L3
L236:
	cmpb $10,1(%rdx)
	jnz L425
L239:
	movl _curln(%rip),%esi
	movl %esi,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L243:
	movl _line2(%rip),%esi
	movl _line1(%rip),%edi
	call _doprnt
	cmpl $0,%eax
	jge L13
	jl L425
L95:
	cmpl $0,_nlines(%rip)
	jg L425
L98:
	movb 1(%rdx),%al
	cmpb $32,%al
	jz L105
L107:
	cmpb $9,%al
	jz L105
L108:
	cmpb $10,%al
	jnz L425
L105:
	call _getfn
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L425
L114:
	call _clrbuf
	movq %rbx,%rsi
	xorl %edi,%edi
	call _doread
	cmpl $0,%eax
	jl L3
L118:
	movq %rbx,%rsi
	movl $_fname,%edi
	call _strcpy
	jmp L429
L28:
	movl _line2(%rip),%eax
	pushq %rax
	pushq $L29
L449:
	call _printf
	addq $16,%rsp
	jmp L13
L348:
	movb 1(%rdx),%al
	cmpl $87,%ecx
	setz %cl
	movzbl %cl,%r12d
	cmpb $32,%al
	jz L354
L356:
	cmpb $9,%al
	jz L354
L357:
	cmpb $10,%al
	jnz L425
L354:
	call _getfn
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L425
L363:
	movl _lastln(%rip),%esi
	movl $1,%edi
	call _deflt
	cmpl $0,%eax
	jl L425
L367:
	movl %r12d,%ecx
	movq %rbx,%rdx
	movl _line2(%rip),%esi
	movl _line1(%rip),%edi
	call _dowrite
	cmpl $0,%eax
	jl L425
L429:
	movl $0,_fchanged(%rip)
L13:
	xorl %eax,%eax
	jmp L3
L15:
	cmpl $0,_nlines(%rip)
	jnz L18
L16:
	movl _curln(%rip),%ecx
	incl %ecx
	cmpl _lastln(%rip),%ecx
	movl $0,%eax
	cmovlel %ecx,%eax
	movl %eax,_line2(%rip)
	testl %eax,%eax
	jnz L18
L425:
	movl $-2,%eax
	jmp L3
L18:
	movl _line2(%rip),%eax
	movl %eax,_curln(%rip)
	movl $1,%eax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_dolst:
L450:
	pushq %rbx
L451:
	movl _lflg(%rip),%ebx
	movl $1,_lflg(%rip)
	call _doprnt
	movl %ebx,_lflg(%rip)
L452:
	popq %rbx
	ret 

L145:
	.byte 37,115,10,0
L29:
	.byte 37,100,10,0
.globl _fchanged
.comm _fchanged, 4, 4
.globl _fname
.comm _fname, 1024, 1

.globl _dowrite
.globl _doread
.globl _getfn
.globl _lastln
.globl _fname
.globl _mark
.globl _getrhs
.globl _lflg
.globl _curln
.globl _transfer
.globl _getone
.globl _append
.globl _clrbuf
.globl _printf
.globl _nofname
.globl _line1
.globl _join
.globl _dolst
.globl _nlines
.globl _docmd
.globl _line2
.globl _move
.globl _inptr
.globl _set
.globl _deflt
.globl _optpat
.globl _doprnt
.globl _del
.globl _strcpy
.globl _subst
.globl _fchanged
