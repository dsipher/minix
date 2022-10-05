.text

_action_out:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $1024,%rsp
	jmp L4
L5:
	cmpb $37,-1024(%rbp)
	jnz L8
L10:
	cmpb $37,-1023(%rbp)
	jz L3
L8:
	movl $___stdout,%esi
	leaq -1024(%rbp),%rdi
	call _fputs
L4:
	movq _temp_action_file(%rip),%rdx
	movl $1024,%esi
	leaq -1024(%rbp),%rdi
	call _fgets
	testq %rax,%rax
	jnz L5
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


_allocate_array:
L15:
	pushq %rbx
L16:
	movl %esi,%ebx
	imull %edi,%ebx
	cmpl $0,%ebx
	jg L20
L18:
	movl $L21,%edi
	call _flexfatal
L20:
	movl %ebx,%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L24
L22:
	movl $L25,%edi
	call _flexfatal
L24:
	movq %rbx,%rax
L17:
	popq %rbx
	ret 


_all_lower:
L27:
L30:
	movb (%rdi),%al
	testb %al,%al
	jz L32
L31:
	cmpb $128,%al
	jae L33
L36:
	movzbq %al,%rax
	testb $2,___ctype+1(%rax)
	jz L33
L35:
	incq %rdi
	jmp L30
L33:
	xorl %eax,%eax
	ret
L32:
	movl $1,%eax
L29:
	ret 


_all_upper:
L42:
L45:
	movb (%rdi),%al
	testb %al,%al
	jz L47
L46:
	cmpb $128,%al
	jae L48
L51:
	movsbq %al,%rax
	testb $1,___ctype+1(%rax)
	jz L48
L50:
	incq %rdi
	jmp L45
L48:
	xorl %eax,%eax
	ret
L47:
	movl $1,%eax
L44:
	ret 


_bubble:
L57:
	jmp L60
L61:
	movl $1,%ecx
L64:
	cmpl %ecx,%esi
	jle L67
L65:
	movl %ecx,%r8d
	movl (%rdi,%r8,4),%edx
	incl %ecx
	movl (%rdi,%rcx,4),%eax
	cmpl %eax,%edx
	jle L64
L68:
	movl %eax,(%rdi,%r8,4)
	movl %edx,(%rdi,%rcx,4)
	jmp L64
L67:
	decl %esi
L60:
	cmpl $1,%esi
	jg L61
L59:
	ret 


_clower:
L71:
L72:
	movl %edi,%eax
	cmpl $128,%eax
	jae L73
L77:
	movslq %eax,%rax
	testb $1,___ctype+1(%rax)
	jz L73
L74:
	movl %eax,%edi
	call _tolower
L73:
	ret 


_copy_string:
L82:
	pushq %rbx
	pushq %r12
L83:
	movq %rdi,%r12
	movq %r12,%rax
	jmp L85
L86:
	incq %rax
L85:
	cmpb $0,(%rax)
	jnz L86
L88:
	subq %r12,%rax
	incl %eax
	movl %eax,%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L91
L89:
	movl $L92,%edi
	call _flexfatal
L91:
	movq %rbx,%rcx
L93:
	movb (%r12),%al
	incq %r12
	movb %al,(%rcx)
	incq %rcx
	testb %al,%al
	jnz L93
L96:
	movq %rbx,%rax
L84:
	popq %r12
	popq %rbx
	ret 


_copy_unsigned_string:
L98:
	pushq %rbx
	pushq %r12
L99:
	movq %rdi,%r12
	movq %r12,%rax
	jmp L101
L102:
	incq %rax
L101:
	cmpb $0,(%rax)
	jnz L102
L104:
	subq %r12,%rax
	incl %eax
	movl %eax,%edi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L107
L105:
	movl $L108,%edi
	call _flexfatal
L107:
	movq %rbx,%rcx
L109:
	movb (%r12),%al
	incq %r12
	movb %al,(%rcx)
	incq %rcx
	testb %al,%al
	jnz L109
L112:
	movq %rbx,%rax
L100:
	popq %r12
	popq %rbx
	ret 


_cshell:
L114:
L115:
	movl %edx,%ecx
	movl $2,%r8d
	movl %esi,%eax
	jmp L148
L118:
	movl %eax,%r11d
L121:
	cmpl %r11d,%esi
	jle L124
L122:
	movl %r11d,%r10d
L149:
	subl %eax,%r10d
	js L128
L126:
	leal (%r10,%rax),%r8d
	movslq %r8d,%r8
	movb (%r8,%rdi),%dl
	testl %ecx,%ecx
	jz L130
L129:
	testb %dl,%dl
	jz L128
L133:
	movslq %r10d,%r9
	movb (%rdi,%r9),%r9b
	testb %r9b,%r9b
	jz L131
L139:
	cmpb %dl,%r9b
	ja L131
	jbe L128
L130:
	movslq %r10d,%r9
	cmpb %dl,(%rdi,%r9)
	jbe L128
L131:
	movslq %r10d,%r10
	movb (%rdi,%r10),%r9b
	movb %dl,(%rdi,%r10)
	movb %r9b,(%r8,%rdi)
	jmp L149
L128:
	incl %r11d
	jmp L121
L124:
	movl $2,%r8d
L148:
	cltd 
	idivl %r8d
	cmpl $0,%eax
	jg L118
L116:
	ret 


_dataend:
L150:
L151:
	cmpl $0,_datapos(%rip)
	jle L155
L153:
	call _dataflush
L155:
	movl $L156,%edi
	call _puts
	movl $0,_dataline(%rip)
	movl $0,_datapos(%rip)
L152:
	ret 


_dataflush:
L157:
L158:
	decl ___stdout(%rip)
	js L161
L160:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L162
L161:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L162:
	movl _dataline(%rip),%eax
	incl %eax
	movl %eax,_dataline(%rip)
	cmpl $10,%eax
	jl L165
L163:
	decl ___stdout(%rip)
	js L167
L166:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L168
L167:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L168:
	movl $0,_dataline(%rip)
L165:
	movl $0,_datapos(%rip)
L159:
	ret 


_flexerror:
L169:
L170:
	pushq %rdi
	pushq _program_name(%rip)
	pushq $L172
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $1,%edi
	call _flexend
L171:
	ret 


_flexfatal:
L173:
L174:
	pushq %rdi
	pushq _program_name(%rip)
	pushq $L176
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $1,%edi
	call _flexend
L175:
	ret 


_flex_gettime:
L177:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L178:
	xorl %edi,%edi
	call _time
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _ctime
	movq %rax,%rdi
	call _copy_string
	movb $0,24(%rax)
L179:
	movq %rbp,%rsp
	popq %rbp
	ret 


_lerrif:
L181:
	pushq %rbp
	movq %rsp,%rbp
	subq $1024,%rsp
L182:
	leaq -1024(%rbp),%rax
	pushq %rsi
	pushq %rdi
	pushq %rax
	call _sprintf
	addq $24,%rsp
	leaq -1024(%rbp),%rdi
	call _flexerror
L183:
	movq %rbp,%rsp
	popq %rbp
	ret 


_lerrsf:
L184:
	pushq %rbp
	movq %rsp,%rbp
	subq $1024,%rsp
L185:
	leaq -1024(%rbp),%rax
	pushq %rsi
	pushq %rdi
	pushq %rax
	call _sprintf
	addq $24,%rsp
	leaq -1024(%rbp),%rdi
	call _flexerror
L186:
	movq %rbp,%rsp
	popq %rbp
	ret 


_htoi:
L187:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L188:
	leaq -4(%rbp),%rax
	pushq %rax
	pushq $L190
	pushq %rdi
	call _sscanf
	addq $24,%rsp
	movl -4(%rbp),%eax
L189:
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L214:
	.short L210-_is_hex_digit
	.short L210-_is_hex_digit
	.short L210-_is_hex_digit
	.short L210-_is_hex_digit
	.short L210-_is_hex_digit
	.short L210-_is_hex_digit

_is_hex_digit:
L192:
L193:
	movslq %edi,%rax
	testb $4,___ctype+1(%rax)
	jnz L210
L197:
	call _clower
	cmpb $97,%al
	jb L199
L213:
	cmpb $102,%al
	ja L199
L211:
	addb $-97,%al
	movzbl %al,%eax
	movzwl L214(,%rax,2),%eax
	addl $_is_hex_digit,%eax
	jmp *%rax
L210:
	movl $1,%eax
	ret
L199:
	xorl %eax,%eax
L194:
	ret 


_line_directive_out:
L215:
L216:
	movq _infilename(%rip),%rcx
	testq %rcx,%rcx
	jz L217
L221:
	cmpl $0,_gen_line_dirs(%rip)
	jz L217
L218:
	movl _linenum(%rip),%eax
	pushq %rcx
	pushq %rax
	pushq $L225
	pushq %rdi
	call _fprintf
	addq $32,%rsp
L217:
	ret 


_mk2data:
L226:
	pushq %rbx
L227:
	movl %edi,%ebx
	cmpl $10,_datapos(%rip)
	jl L231
L229:
	decl ___stdout(%rip)
	js L233
L232:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $44,(%rcx)
	jmp L234
L233:
	movl $___stdout,%esi
	movl $44,%edi
	call ___flushbuf
L234:
	call _dataflush
L231:
	cmpl $0,_datapos(%rip)
	jnz L236
L235:
	movl $___stdout,%esi
	movl $L238,%edi
	call _fputs
	jmp L237
L236:
	decl ___stdout(%rip)
	js L240
L239:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $44,(%rcx)
	jmp L237
L240:
	movl $___stdout,%esi
	movl $44,%edi
	call ___flushbuf
L237:
	incl _datapos(%rip)
	pushq %rbx
	pushq $L242
	call _printf
	addq $16,%rsp
L228:
	popq %rbx
	ret 


_mkdata:
L243:
	pushq %rbx
L244:
	movl %edi,%ebx
	cmpl $10,_datapos(%rip)
	jl L248
L246:
	decl ___stdout(%rip)
	js L250
L249:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $44,(%rcx)
	jmp L251
L250:
	movl $___stdout,%esi
	movl $44,%edi
	call ___flushbuf
L251:
	call _dataflush
L248:
	cmpl $0,_datapos(%rip)
	jnz L253
L252:
	movl $___stdout,%esi
	movl $L238,%edi
	call _fputs
	jmp L254
L253:
	decl ___stdout(%rip)
	js L256
L255:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $44,(%rcx)
	jmp L254
L256:
	movl $___stdout,%esi
	movl $44,%edi
	call ___flushbuf
L254:
	incl _datapos(%rip)
	pushq %rbx
	pushq $L242
	call _printf
	addq $16,%rsp
L245:
	popq %rbx
	ret 


_myctoi:
L258:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L259:
	leaq -4(%rbp),%rax
	movl $0,-4(%rbp)
	pushq %rax
	pushq $L261
	pushq %rdi
	call _sscanf
	addq $24,%rsp
	movl -4(%rbp),%eax
L260:
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L325:
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc
	.short L292-_myesc

_myesc:
L263:
	pushq %rbx
	pushq %r12
	pushq %r13
L264:
	movq %rdi,%rbx
	movb 1(%rbx),%al
	cmpb $48,%al
	jb L312
L314:
	cmpb $57,%al
	ja L312
L311:
	leal -48(%rax),%ecx
	movzbl %cl,%ecx
	movzwl L325(,%rcx,2),%ecx
	addl $_myesc,%ecx
	jmp *%rcx
L292:
	movl $1,%r13d
	jmp L293
L296:
	movzbq %r12b,%r12
	testb $4,___ctype+1(%r12)
	jz L295
L294:
	incl %r13d
L293:
	movb (%r13,%rbx),%r12b
	cmpb $128,%r12b
	jb L296
L295:
	movb $0,(%r13,%rbx)
	leaq 1(%rbx),%rdi
	call _otoi
	jmp L326
L312:
	cmpb $97,%al
	jz L269
L316:
	cmpb $98,%al
	jz L271
L317:
	cmpb $102,%al
	jz L273
L318:
	cmpb $110,%al
	jz L275
L319:
	cmpb $114,%al
	jz L277
L320:
	cmpb $116,%al
	jz L279
L321:
	cmpb $118,%al
	jz L281
L322:
	cmpb $120,%al
	jnz L265
L301:
	movl $2,%r13d
	jmp L302
L305:
	movzbl %dil,%edi
	call _is_hex_digit
	testl %eax,%eax
	jz L304
L303:
	incl %r13d
L302:
	movb (%r13,%rbx),%dil
	cmpb $128,%dil
	jb L305
L304:
	movb (%r13,%rbx),%r12b
	movb $0,(%r13,%rbx)
	leaq 2(%rbx),%rdi
	call _htoi
L326:
	movb %r12b,(%r13,%rbx)
	jmp L265
L281:
	movb $11,%al
	jmp L265
L279:
	movb $9,%al
	jmp L265
L277:
	movb $13,%al
	jmp L265
L275:
	movb $10,%al
	jmp L265
L273:
	movb $12,%al
	jmp L265
L271:
	movb $8,%al
	jmp L265
L269:
	movb $7,%al
L265:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_otoi:
L327:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L328:
	leaq -4(%rbp),%rax
	pushq %rax
	pushq $L330
	pushq %rdi
	call _sscanf
	addq $24,%rsp
	movl -4(%rbp),%eax
L329:
	movq %rbp,%rsp
	popq %rbp
	ret 

.local L335
.comm L335, 10, 1
.align 2
L377:
	.short L362-_readable_form
	.short L353-_readable_form
	.short L350-_readable_form
	.short L347-_readable_form
	.short L356-_readable_form
	.short L359-_readable_form

_readable_form:
L332:
L333:
	cmpl $0,%edi
	jl L339
L343:
	cmpl $32,%edi
	jl L336
L339:
	cmpl $127,%edi
	jl L337
L336:
	cmpl $8,%edi
	jl L347
L376:
	cmpl $13,%edi
	jg L347
L374:
	leal -8(%rdi),%eax
	movzwl L377(,%rax,2),%eax
	addl $_readable_form,%eax
	jmp *%rax
L359:
	movl $L360,%eax
	ret
L356:
	movl $L357,%eax
	ret
L350:
	movl $L351,%eax
	ret
L353:
	movl $L354,%eax
	ret
L362:
	movl $L363,%eax
	ret
L347:
	pushq %rdi
	pushq $L365
	pushq $L335
	call _sprintf
	addq $24,%rsp
	jmp L373
L337:
	cmpl $32,%edi
	jnz L368
L367:
	movl $L370,%eax
	ret
L368:
	movb %dil,L335(%rip)
	movb $0,L335+1(%rip)
L373:
	movl $L335,%eax
L334:
	ret 


_reallocate_array:
L378:
	pushq %rbx
	pushq %r12
L379:
	movq %rdi,%r12
	movl %esi,%ebx
	imull %edx,%ebx
	cmpl $0,%ebx
	jg L383
L381:
	movl $L384,%edi
	call _flexfatal
L383:
	movl %ebx,%esi
	movq %r12,%rdi
	call _realloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L387
L385:
	movl $L388,%edi
	call _flexfatal
L387:
	movq %rbx,%rax
L380:
	popq %r12
	popq %rbx
	ret 


_skelout:
L390:
	pushq %rbp
	movq %rsp,%rbp
	subq $1024,%rsp
	jmp L393
L394:
	cmpb $37,-1024(%rbp)
	jnz L397
L399:
	cmpb $37,-1023(%rbp)
	jz L392
L397:
	movl $___stdout,%esi
	leaq -1024(%rbp),%rdi
	call _fputs
L393:
	movq _skelfile(%rip),%rdx
	movl $1024,%esi
	leaq -1024(%rbp),%rdi
	call _fgets
	testq %rax,%rax
	jnz L394
L392:
	movq %rbp,%rsp
	popq %rbp
	ret 


_transition_struct_out:
L404:
L405:
	pushq %rsi
	pushq %rdi
	pushq $L407
	call _printf
	addq $24,%rsp
	movl _datapos(%rip),%eax
	addl $15,%eax
	movl %eax,_datapos(%rip)
	cmpl $75,%eax
	jl L406
L408:
	decl ___stdout(%rip)
	js L412
L411:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L413
L412:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L413:
	movl _dataline(%rip),%eax
	leal 1(%rax),%ecx
	movl %ecx,_dataline(%rip)
	movl $10,%ecx
	incl %eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jnz L416
L414:
	decl ___stdout(%rip)
	js L418
L417:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L416
L418:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L416:
	movl $0,_datapos(%rip)
L406:
	ret 

L407:
	.byte 37,55,100,44,32,37,53,100
	.byte 44,0
L261:
	.byte 37,100,0
L156:
	.byte 32,32,32,32,125,32,59,10
	.byte 0
L354:
	.byte 92,116,0
L370:
	.byte 39,32,39,0
L25:
	.byte 109,101,109,111,114,121,32,97
	.byte 108,108,111,99,97,116,105,111
	.byte 110,32,102,97,105,108,101,100
	.byte 32,105,110,32,97,108,108,111
	.byte 99,97,116,101,95,97,114,114
	.byte 97,121,40,41,0
L365:
	.byte 92,37,46,51,111,0
L330:
	.byte 37,111,0
L92:
	.byte 100,121,110,97,109,105,99,32
	.byte 109,101,109,111,114,121,32,102
	.byte 97,105,108,117,114,101,32,105
	.byte 110,32,99,111,112,121,95,115
	.byte 116,114,105,110,103,40,41,0
L225:
	.byte 35,32,108,105,110,101,32,37
	.byte 100,32,34,37,115,34,10,0
L21:
	.byte 114,101,113,117,101,115,116,32
	.byte 102,111,114,32,60,32,49,32
	.byte 98,121,116,101,32,105,110,32
	.byte 97,108,108,111,99,97,116,101
	.byte 95,97,114,114,97,121,40,41
	.byte 0
L384:
	.byte 97,116,116,101,109,112,116,32
	.byte 116,111,32,105,110,99,114,101
	.byte 97,115,101,32,97,114,114,97
	.byte 121,32,115,105,122,101,32,98
	.byte 121,32,108,101,115,115,32,116
	.byte 104,97,110,32,49,32,98,121
	.byte 116,101,0
L242:
	.byte 37,53,100,0
L351:
	.byte 92,110,0
L238:
	.byte 32,32,32,32,0
L108:
	.byte 100,121,110,97,109,105,99,32
	.byte 109,101,109,111,114,121,32,102
	.byte 97,105,108,117,114,101,32,105
	.byte 110,32,99,111,112,121,95,117
	.byte 110,115,105,103,110,101,100,95
	.byte 115,116,114,105,110,103,40,41
	.byte 0
L363:
	.byte 92,98,0
L176:
	.byte 37,115,58,32,102,97,116,97
	.byte 108,32,105,110,116,101,114,110
	.byte 97,108,32,101,114,114,111,114
	.byte 44,32,37,115,10,0
L357:
	.byte 92,102,0
L190:
	.byte 37,120,0
L360:
	.byte 92,114,0
L388:
	.byte 97,116,116,101,109,112,116,32
	.byte 116,111,32,105,110,99,114,101
	.byte 97,115,101,32,97,114,114,97
	.byte 121,32,115,105,122,101,32,102
	.byte 97,105,108,101,100,0
L172:
	.byte 37,115,58,32,37,115,10,0

.globl _sprintf
.globl _flex_gettime
.globl _dataline
.globl _htoi
.globl _gen_line_dirs
.globl _all_lower
.globl _realloc
.globl _ctime
.globl _copy_unsigned_string
.globl _mk2data
.globl _fgets
.globl ___stdout
.globl _temp_action_file
.globl _malloc
.globl _otoi
.globl _datapos
.globl _all_upper
.globl _transition_struct_out
.globl _dataend
.globl _skelfile
.globl _clower
.globl _myctoi
.globl _mkdata
.globl _puts
.globl _dataflush
.globl _cshell
.globl _flexfatal
.globl _action_out
.globl _printf
.globl _line_directive_out
.globl _program_name
.globl ___flushbuf
.globl ___ctype
.globl _is_hex_digit
.globl _bubble
.globl _tolower
.globl ___stderr
.globl _reallocate_array
.globl _linenum
.globl _myesc
.globl _lerrsf
.globl _flexend
.globl _allocate_array
.globl _copy_string
.globl _infilename
.globl _skelout
.globl _fputs
.globl _sscanf
.globl _lerrif
.globl _time
.globl _flexerror
.globl _readable_form
.globl _fprintf
