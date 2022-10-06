.data
_flex_version:
	.byte 50,46,51,0
.align 8
_skelfile:
	.quad 0
.align 8
_infilename:
	.quad 0
.align 8
_xlation:
	.quad 0
.align 8
_action_file_name:
	.quad 0
.align 8
_outfile:
	.quad L1
.align 4
_outfile_created:
	.int 0
.align 8
_skelname:
	.quad 0
.text

_main:
L2:
	pushq %rbx
L3:
	call _flexinit
	call _readin
	cmpl $0,_syntaxerror(%rip)
	jz L7
L5:
	movl $1,%edi
	call _flexend
L7:
	movl _yymore_really_used(%rip),%eax
	cmpl $1,%eax
	jnz L9
L8:
	movl $1,_yymore_used(%rip)
	jmp L10
L9:
	cmpl $2,%eax
	jnz L10
L11:
	movl $0,_yymore_used(%rip)
L10:
	movl _reject_really_used(%rip),%eax
	cmpl $1,%eax
	jnz L15
L14:
	movl $1,_reject(%rip)
	jmp L16
L15:
	cmpl $2,%eax
	jnz L16
L17:
	movl $0,_reject(%rip)
L16:
	cmpl $0,_performance_report(%rip)
	jz L22
L20:
	cmpl $0,_interactive(%rip)
	jz L25
L23:
	pushq $L26
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L25:
	cmpl $0,_yymore_used(%rip)
	jz L29
L27:
	pushq $L30
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L29:
	cmpl $0,_reject(%rip)
	jz L33
L31:
	pushq $L34
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L33:
	cmpl $0,_variable_trailing_context_rules(%rip)
	jz L22
L35:
	pushq $L38
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L22:
	cmpl $0,_reject(%rip)
	jz L41
L39:
	movl $1,_real_reject(%rip)
L41:
	cmpl $0,_variable_trailing_context_rules(%rip)
	jz L44
L42:
	movl $1,_reject(%rip)
L44:
	cmpl $0,_fulltbl(%rip)
	jnz L53
L52:
	cmpl $0,_fullspd(%rip)
	jz L47
L53:
	cmpl $0,_reject(%rip)
	jz L47
L49:
	cmpl $0,_real_reject(%rip)
	movl $L60,%eax
	movl $L59,%edi
	cmovzq %rax,%rdi
	call _flexerror
L47:
	call _ntod
	call _make_tables
	xorl %edi,%edi
	call _flexend
L4:
	movl %ebx,%eax
	popq %rbx
	ret 


_flexend:
L62:
	pushq %rbx
	pushq %r12
L63:
	movq _skelfile(%rip),%rax
	movl %edi,%r12d
	testq %rax,%rax
	jz L67
L65:
	testl $32,8(%rax)
	jz L69
L68:
	movl $L71,%edi
	jmp L298
L69:
	movq %rax,%rdi
	call _fclose
	testl %eax,%eax
	jz L67
L72:
	movl $L75,%edi
L298:
	call _flexfatal
L67:
	movq _temp_action_file(%rip),%rdi
	testq %rdi,%rdi
	jz L78
L76:
	testl $32,8(%rdi)
	jz L80
L79:
	movl $L82,%edi
	jmp L297
L80:
	call _fclose
	testl %eax,%eax
	jz L84
L83:
	movl $L86,%edi
	jmp L297
L84:
	movq _action_file_name(%rip),%rdi
	call _unlink
	testl %eax,%eax
	jz L78
L87:
	movl $L90,%edi
L297:
	call _flexfatal
L78:
	testl %r12d,%r12d
	jz L93
L94:
	cmpl $0,_outfile_created(%rip)
	jz L93
L91:
	testl $32,___stdout+8(%rip)
	jz L99
L98:
	movl $L101,%edi
	jmp L296
L99:
	movl $___stdout,%edi
	call _fclose
	testl %eax,%eax
	jz L103
L102:
	movl $L105,%edi
	jmp L296
L103:
	movq _outfile(%rip),%rdi
	call _unlink
	testl %eax,%eax
	jz L93
L106:
	movl $L109,%edi
L296:
	call _flexfatal
L93:
	cmpl $0,_backtrack_report(%rip)
	jz L112
L113:
	movq _backtrack_file(%rip),%rcx
	testq %rcx,%rcx
	jz L112
L110:
	movl _num_backtracking(%rip),%eax
	testl %eax,%eax
	jnz L118
L117:
	pushq $L120
	jmp L295
L118:
	cmpl $0,_fullspd(%rip)
	jnz L121
L124:
	cmpl $0,_fulltbl(%rip)
	jz L122
L121:
	pushq %rax
	pushq $L128
	pushq %rcx
	call _fprintf
	addq $24,%rsp
	jmp L119
L122:
	pushq $L129
L295:
	pushq %rcx
	call _fprintf
	addq $16,%rsp
L119:
	movq _backtrack_file(%rip),%rdi
	testl $32,8(%rdi)
	jz L131
L130:
	movl $L133,%edi
	jmp L294
L131:
	call _fclose
	testl %eax,%eax
	jz L112
L134:
	movl $L137,%edi
L294:
	call _flexfatal
L112:
	cmpl $0,_printstats(%rip)
	jz L140
L138:
	call _flex_gettime
	movq %rax,_endtime(%rip)
	pushq $_flex_version
	pushq _program_name(%rip)
	pushq $L141
	pushq $___stderr
	call _fprintf
	pushq _endtime(%rip)
	pushq _starttime(%rip)
	pushq $L142
	pushq $___stderr
	call _fprintf
	pushq $L143
	pushq $___stderr
	call _fprintf
	addq $80,%rsp
	cmpl $0,_backtrack_report(%rip)
	jz L146
L144:
	decl ___stderr(%rip)
	js L148
L147:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $98,(%rcx)
	jmp L146
L148:
	movl $___stderr,%esi
	movl $98,%edi
	call ___flushbuf
L146:
	cmpl $0,_ddebug(%rip)
	jz L152
L150:
	decl ___stderr(%rip)
	js L154
L153:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $100,(%rcx)
	jmp L152
L154:
	movl $___stderr,%esi
	movl $100,%edi
	call ___flushbuf
L152:
	cmpl $0,_interactive(%rip)
	jz L158
L156:
	decl ___stderr(%rip)
	js L160
L159:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $73,(%rcx)
	jmp L158
L160:
	movl $___stderr,%esi
	movl $73,%edi
	call ___flushbuf
L158:
	cmpl $0,_caseins(%rip)
	jz L164
L162:
	decl ___stderr(%rip)
	js L166
L165:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $105,(%rcx)
	jmp L164
L166:
	movl $___stderr,%esi
	movl $105,%edi
	call ___flushbuf
L164:
	cmpl $0,_gen_line_dirs(%rip)
	jnz L170
L168:
	decl ___stderr(%rip)
	js L172
L171:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $76,(%rcx)
	jmp L170
L172:
	movl $___stderr,%esi
	movl $76,%edi
	call ___flushbuf
L170:
	cmpl $0,_performance_report(%rip)
	jz L176
L174:
	decl ___stderr(%rip)
	js L178
L177:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $112,(%rcx)
	jmp L176
L178:
	movl $___stderr,%esi
	movl $112,%edi
	call ___flushbuf
L176:
	cmpl $0,_spprdflt(%rip)
	jz L182
L180:
	decl ___stderr(%rip)
	js L184
L183:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $115,(%rcx)
	jmp L182
L184:
	movl $___stderr,%esi
	movl $115,%edi
	call ___flushbuf
L182:
	cmpl $0,_use_stdout(%rip)
	jz L188
L186:
	decl ___stderr(%rip)
	js L190
L189:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $116,(%rcx)
	jmp L188
L190:
	movl $___stderr,%esi
	movl $116,%edi
	call ___flushbuf
L188:
	cmpl $0,_trace(%rip)
	jz L194
L192:
	decl ___stderr(%rip)
	js L196
L195:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $84,(%rcx)
	jmp L194
L196:
	movl $___stderr,%esi
	movl $84,%edi
	call ___flushbuf
L194:
	cmpl $0,_printstats(%rip)
	jz L200
L198:
	decl ___stderr(%rip)
	js L202
L201:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $118,(%rcx)
	jmp L200
L202:
	movl $___stderr,%esi
	movl $118,%edi
	call ___flushbuf
L200:
	cmpl $256,_csize(%rip)
	jnz L206
L204:
	decl ___stderr(%rip)
	js L208
L207:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $56,(%rcx)
	jmp L206
L208:
	movl $___stderr,%esi
	movl $56,%edi
	call ___flushbuf
L206:
	pushq $L210
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	cmpl $0,_fulltbl(%rip)
	jz L213
L211:
	decl ___stderr(%rip)
	js L215
L214:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $102,(%rcx)
	jmp L213
L215:
	movl $___stderr,%esi
	movl $102,%edi
	call ___flushbuf
L213:
	cmpl $0,_fullspd(%rip)
	jz L219
L217:
	decl ___stderr(%rip)
	js L221
L220:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $70,(%rcx)
	jmp L219
L221:
	movl $___stderr,%esi
	movl $70,%edi
	call ___flushbuf
L219:
	cmpl $0,_useecs(%rip)
	jz L225
L223:
	decl ___stderr(%rip)
	js L227
L226:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $101,(%rcx)
	jmp L225
L227:
	movl $___stderr,%esi
	movl $101,%edi
	call ___flushbuf
L225:
	cmpl $0,_usemecs(%rip)
	jz L231
L229:
	decl ___stderr(%rip)
	js L233
L232:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $109,(%rcx)
	jmp L231
L233:
	movl $___stderr,%esi
	movl $109,%edi
	call ___flushbuf
L231:
	movl $L238,%esi
	movq _skelname(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L237
L235:
	pushq _skelname(%rip)
	pushq $L239
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L237:
	decl ___stderr(%rip)
	js L241
L240:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L242
L241:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
L242:
	movl _lastnfa(%rip),%ecx
	movl _current_mns(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L243
	pushq $___stderr
	call _fprintf
	movl _lastdfa(%rip),%edx
	movl _current_max_dfas(%rip),%ecx
	movl _totnst(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq $L244
	pushq $___stderr
	call _fprintf
	movl _num_rules(%rip),%eax
	decl %eax
	pushq %rax
	pushq $L245
	pushq $___stderr
	call _fprintf
	addq $96,%rsp
	movl _num_backtracking(%rip),%eax
	testl %eax,%eax
	jnz L247
L246:
	pushq $L249
	jmp L293
L247:
	cmpl $0,_fullspd(%rip)
	jnz L250
L253:
	cmpl $0,_fulltbl(%rip)
	jz L251
L250:
	pushq %rax
	pushq $L257
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L248
L251:
	pushq $L258
L293:
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L248:
	cmpl $0,_bol_needed(%rip)
	jz L261
L259:
	pushq $L262
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L261:
	movl _lastsc(%rip),%ecx
	movl _current_max_scs(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L263
	pushq $___stderr
	call _fprintf
	movl _numeps(%rip),%ecx
	movl _eps2(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L264
	pushq $___stderr
	call _fprintf
	addq $64,%rsp
	movl _lastccl(%rip),%edi
	testl %edi,%edi
	jnz L266
L265:
	pushq $L268
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L267
L266:
	movslq %edi,%rdi
	movq _cclmap(%rip),%rax
	movl (%rax,%rdi,4),%esi
	movq _ccllen(%rip),%rax
	movl (%rax,%rdi,4),%edx
	movl _current_maxccls(%rip),%r8d
	movl _current_max_ccl_tbl_size(%rip),%ecx
	movl _cclreuse(%rip),%eax
	addl %edx,%esi
	pushq %rax
	pushq %rcx
	pushq %rsi
	pushq %r8
	pushq %rdi
	pushq $L269
	pushq $___stderr
	call _fprintf
	addq $56,%rsp
L267:
	movl _numsnpairs(%rip),%eax
	pushq %rax
	pushq $L270
	pushq $___stderr
	call _fprintf
	movl _numuniq(%rip),%ecx
	movl _numdup(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L271
	pushq $___stderr
	call _fprintf
	addq $56,%rsp
	movl _fulltbl(%rip),%ecx
	movl _lastdfa(%rip),%eax
	testl %ecx,%ecx
	jz L273
L272:
	movl _numecs(%rip),%ebx
	imull %eax,%ebx
	pushq %rbx
	pushq $L275
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L274
L273:
	movl _numtemps(%rip),%edx
	movl _tblend(%rip),%ecx
	addl %edx,%eax
	movl _current_max_dfas(%rip),%edx
	movl %eax,%ebx
	shll $1,%ebx
	shll $1,%ecx
	addl %ecx,%ebx
	pushq %rdx
	pushq %rax
	pushq $L276
	pushq $___stderr
	call _fprintf
	movl _tblend(%rip),%edx
	movl _current_max_xpairs(%rip),%ecx
	movl _peakpairs(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq $L277
	pushq $___stderr
	call _fprintf
	movl _numtemps(%rip),%esi
	movl _nummecs(%rip),%edx
	movl _numecs(%rip),%eax
	imull %esi,%edx
	movl _current_max_template_xpairs(%rip),%ecx
	imull %esi,%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq $L278
	pushq $___stderr
	call _fprintf
	movl _nummt(%rip),%eax
	pushq %rax
	pushq $L279
	pushq $___stderr
	call _fprintf
	movl _numprots(%rip),%eax
	pushq %rax
	pushq $L280
	pushq $___stderr
	call _fprintf
	movl _numtemps(%rip),%ecx
	movl _tmpuses(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L281
	pushq $___stderr
	call _fprintf
	addq $192,%rsp
L274:
	cmpl $0,_useecs(%rip)
	jz L284
L282:
	movl _csize(%rip),%ecx
	addl %ecx,%ebx
	movl _numecs(%rip),%eax
	pushq %rcx
	pushq %rax
	pushq $L285
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L284:
	cmpl $0,_usemecs(%rip)
	jz L288
L286:
	movl _numecs(%rip),%ecx
	movl _csize(%rip),%edx
	movl _nummecs(%rip),%eax
	addl %ecx,%ebx
	pushq %rdx
	pushq %rax
	pushq $L289
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L288:
	movl _hshcol(%rip),%edx
	movl _hshsave(%rip),%ecx
	movl _dfaeql(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq $L290
	pushq $___stderr
	call _fprintf
	movl _num_reallocs(%rip),%eax
	pushq %rax
	pushq $L291
	pushq $___stderr
	call _fprintf
	pushq %rbx
	pushq $L292
	pushq $___stderr
	call _fprintf
	addq $88,%rsp
L140:
	movl %r12d,%edi
	call _exit
L64:
	popq %r12
	popq %rbx
	ret 

.local L421
.comm L421, 400, 1
.local L449
.comm L449, 32, 1
.align 2
L489:
	.short L319-_flexinit
	.short L318-_flexinit
	.short L366-_flexinit
	.short L318-_flexinit
	.short L318-_flexinit
	.short L374-_flexinit
	.short L376-_flexinit
	.short L318-_flexinit
	.short L380-_flexinit
.align 2
L490:
	.short L321-_flexinit
	.short L323-_flexinit
	.short L352-_flexinit
	.short L318-_flexinit
	.short L354-_flexinit
	.short L318-_flexinit
	.short L318-_flexinit
	.short L360-_flexinit

_flexinit:
L299:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L300:
	movl $0,_caseins(%rip)
	movl $0,_interactive(%rip)
	movl $0,_spprdflt(%rip)
	movl $0,_trace(%rip)
	movl $0,_syntaxerror(%rip)
	movl $0,_printstats(%rip)
	movl $0,_fullspd(%rip)
	movl $0,_fulltbl(%rip)
	movl $0,_ddebug(%rip)
	movl $0,_performance_report(%rip)
	movl $0,_backtrack_report(%rip)
	movl $0,_reject(%rip)
	movl $0,_continued_action(%rip)
	movl $0,_yymore_used(%rip)
	movl $0,_reject_really_used(%rip)
	movl $0,_yymore_really_used(%rip)
	movl $1,_useecs(%rip)
	movl $1,_usemecs(%rip)
	movl $1,_gen_line_dirs(%rip)
	xorl %r13d,%r13d
	movl $0,_use_stdout(%rip)
	movl $128,_csize(%rip)
	movq (%rsi),%rax
	movq %rax,_program_name(%rip)
	leal -1(%rdi),%r15d
	leaq 8(%rsi),%r14
	jmp L302
L303:
	movq (%r14),%r12
	cmpb $45,(%r12)
	jnz L305
L309:
	cmpb $0,1(%r12)
	jz L305
L311:
	movl $1,%ebx
L314:
	movb (%rbx,%r12),%sil
	testb %sil,%sil
	jz L350
L315:
	cmpb $98,%sil
	jl L467
L469:
	cmpb $105,%sil
	jg L467
L466:
	leal -98(%rsi),%eax
	movzbl %al,%eax
	movzwl L490(,%rax,2),%eax
	addl $_flexinit,%eax
	jmp *%rax
L360:
	movl $1,_caseins(%rip)
	jmp L319
L354:
	movl $0,_usemecs(%rip)
	movl $0,_useecs(%rip)
	movl $1,_fulltbl(%rip)
	jmp L319
L352:
	movl $1,_ddebug(%rip)
	jmp L319
L321:
	movl $1,_backtrack_report(%rip)
	jmp L319
L323:
	pushq _program_name(%rip)
	pushq $L324
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L325
L467:
	cmpb $110,%sil
	jl L471
L473:
	cmpb $118,%sil
	jg L471
L470:
	leal -110(%rsi),%eax
	movzbl %al,%eax
	movzwl L489(,%rax,2),%eax
	addl $_flexinit,%eax
	jmp *%rax
L380:
	movl $1,_printstats(%rip)
	jmp L319
L376:
	movl $1,_use_stdout(%rip)
	jmp L319
L374:
	movl $1,_spprdflt(%rip)
	jmp L319
L366:
	movl $1,_performance_report(%rip)
	jmp L319
L471:
	cmpb $56,%sil
	jz L382
L475:
	cmpb $67,%sil
	jz L325
L476:
	cmpb $70,%sil
	jz L356
L477:
	cmpb $73,%sil
	jz L358
L478:
	cmpb $76,%sil
	jz L362
L479:
	cmpb $83,%sil
	jz L368
L480:
	cmpb $84,%sil
	jz L378
L318:
	movsbl %sil,%esi
	movl $L384,%edi
	call _lerrif
	jmp L319
L378:
	movl $1,_trace(%rip)
	jmp L319
L368:
	cmpl $1,%ebx
	jz L371
L369:
	movl $L372,%edi
	call _flexerror
L371:
	leaq 1(%rbx,%r12),%rax
	movq %rax,_skelname(%rip)
	jmp L350
L362:
	movl $0,_gen_line_dirs(%rip)
	jmp L319
L358:
	movl $1,_interactive(%rip)
	jmp L319
L356:
	movl $0,_usemecs(%rip)
	movl $0,_useecs(%rip)
	movl $1,_fullspd(%rip)
	jmp L319
L325:
	cmpl $1,%ebx
	jz L328
L326:
	movl $L329,%edi
	call _flexerror
L328:
	testl %r13d,%r13d
	jnz L491
L330:
	movl $0,_useecs(%rip)
	movl $0,_usemecs(%rip)
	movl $0,_fulltbl(%rip)
	movl $1,%r13d
L491:
	incl %ebx
	movb (%rbx,%r12),%sil
	testb %sil,%sil
	jz L350
L334:
	cmpb $101,%sil
	jz L340
L484:
	cmpb $70,%sil
	jz L342
L485:
	cmpb $102,%sil
	jz L344
L486:
	cmpb $109,%sil
	jz L346
L487:
	movsbl %sil,%esi
	movl $L348,%edi
	call _lerrif
	jmp L491
L346:
	movl $1,_usemecs(%rip)
	jmp L491
L344:
	movl $1,_fulltbl(%rip)
	jmp L491
L342:
	movl $1,_fullspd(%rip)
	jmp L491
L340:
	movl $1,_useecs(%rip)
	jmp L491
L382:
	movl $256,_csize(%rip)
L319:
	incl %ebx
	jmp L314
L350:
	decl %r15d
	addq $8,%r14
L302:
	testl %r15d,%r15d
	jnz L303
L305:
	cmpl $0,_fulltbl(%rip)
	jnz L394
L393:
	cmpl $0,_fullspd(%rip)
	jz L388
L394:
	cmpl $0,_usemecs(%rip)
	jz L388
L390:
	movl $L397,%edi
	call _flexerror
L388:
	cmpl $0,_fulltbl(%rip)
	jnz L406
L405:
	cmpl $0,_fullspd(%rip)
	jz L400
L406:
	cmpl $0,_interactive(%rip)
	jz L400
L402:
	movl $L409,%edi
	call _flexerror
L400:
	cmpl $0,_fulltbl(%rip)
	jz L412
L413:
	cmpl $0,_fullspd(%rip)
	jz L412
L414:
	movl $L417,%edi
	call _flexerror
L412:
	cmpq $0,_skelname(%rip)
	jnz L420
L418:
	movq $L421,_skelname(%rip)
	movl $L238,%esi
	movl $L421,%edi
	call _strcpy
L420:
	cmpl $0,_use_stdout(%rip)
	jnz L424
L422:
	movl $___stdout,%edx
	movl $L425,%esi
	movq _outfile(%rip),%rdi
	call _freopen
	testq %rax,%rax
	jnz L428
L426:
	movq _outfile(%rip),%rsi
	movl $L429,%edi
	call _lerrsf
L428:
	movl $1,_outfile_created(%rip)
L424:
	movl %r15d,_num_input_files(%rip)
	movq %r14,_input_files(%rip)
	cmpl $0,%r15d
	jle L431
L430:
	movq (%r14),%rdi
	jmp L432
L431:
	xorl %edi,%edi
L432:
	call _set_input_file
	cmpl $0,_backtrack_report(%rip)
	jz L434
L433:
	movl $L425,%esi
	movl $L436,%edi
	call _fopen
	movq %rax,_backtrack_file(%rip)
	testq %rax,%rax
	jnz L435
L437:
	movl $L440,%edi
	call _flexerror
	jmp L435
L434:
	movq $0,_backtrack_file(%rip)
L435:
	movl $0,_lastccl(%rip)
	movl $0,_lastsc(%rip)
	call _flex_gettime
	movq %rax,_starttime(%rip)
	movl $L444,%esi
	movq _skelname(%rip),%rdi
	call _fopen
	movq %rax,_skelfile(%rip)
	testq %rax,%rax
	jnz L443
L441:
	movq _skelname(%rip),%rsi
	movl $L445,%edi
	call _lerrsf
L443:
	xorl %edi,%edi
	call _tmpnam
	movq %rax,_action_file_name(%rip)
	testq %rax,%rax
	jnz L448
L446:
	movl $L450,%esi
	movl $L449,%edi
	call _strcpy
	movl $L449,%edi
	call _mktemp
	movq $L449,_action_file_name(%rip)
L448:
	movl $L425,%esi
	movq _action_file_name(%rip),%rdi
	call _fopen
	movq %rax,_temp_action_file(%rip)
	testq %rax,%rax
	jnz L453
L451:
	movq _action_file_name(%rip),%rsi
	movl $L454,%edi
	call _lerrsf
L453:
	movl $0,_tmpuses(%rip)
	movl $0,_numsnpairs(%rip)
	movl $0,_numas(%rip)
	movl $0,_num_rules(%rip)
	movl $0,_lastnfa(%rip)
	movl $0,_lastdfa(%rip)
	movl $0,_totnst(%rip)
	movl $0,_dfaeql(%rip)
	movl $0,_hshcol(%rip)
	movl $0,_num_reallocs(%rip)
	movl $0,_eps2(%rip)
	movl $0,_numeps(%rip)
	movl $0,_numecs(%rip)
	movl $0,_dataline(%rip)
	movl $0,_datapos(%rip)
	movl $0,_eofseen(%rip)
	movl $0,_hshsave(%rip)
	movl $0,_numdup(%rip)
	movl $0,_numuniq(%rip)
	movl $0,_numprots(%rip)
	movl $0,_onesp(%rip)
	movl $0,_num_backtracking(%rip)
	movl $0,_bol_needed(%rip)
	movl $0,_variable_trailing_context_rules(%rip)
	movl $1,_sectnum(%rip)
	movl $1,_linenum(%rip)
	movl $0,_firstprot(%rip)
	movl $1,_lastprot(%rip)
	cmpl $0,_useecs(%rip)
	jz L456
L455:
	movl $0,_ecgroup+4(%rip)
	movl $2,%ecx
	jmp L458
L459:
	movl %ecx,%eax
	decl %eax
	movl %eax,_ecgroup(,%rcx,4)
	movslq %eax,%rax
	movl %ecx,_nextecm(,%rax,4)
	incl %ecx
L458:
	movl _csize(%rip),%eax
	cmpl %ecx,%eax
	jge L459
L461:
	movslq %eax,%rax
	movl $0,_nextecm(,%rax,4)
	jmp L457
L456:
	movl $1,%eax
	jmp L462
L463:
	movl %eax,_ecgroup(,%rax,4)
	movl $-32767,_nextecm(,%rax,4)
	incl %eax
L462:
	cmpl %eax,_csize(%rip)
	jge L463
L457:
	call _set_up_initial_allocations
L301:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_readin:
L492:
L493:
	call _skelout
	cmpl $0,_ddebug(%rip)
	jz L497
L495:
	movl $L498,%edi
	call _puts
L497:
	cmpl $256,_csize(%rip)
	movl $L503,%eax
	movl $L502,%edi
	cmovnzq %rax,%rdi
	call _puts
	movl $___stdout,%edi
	call _line_directive_out
	call _yyparse
	testl %eax,%eax
	jz L506
L504:
	movl $L507,%edi
	call _pinpoint_message
	movl $1,%edi
	call _flexend
L506:
	cmpq $0,_xlation(%rip)
	jz L509
L508:
	movl $_ecgroup,%edi
	call _ecs_from_xlation
	movl %eax,_numecs(%rip)
	movl $1,_useecs(%rip)
	jmp L510
L509:
	movl _useecs(%rip),%eax
	movl _csize(%rip),%edx
	testl %eax,%eax
	jz L512
L511:
	movl $_ecgroup,%esi
	movl $_nextecm,%edi
	call _cre8ecs
	movl %eax,_numecs(%rip)
	jmp L510
L512:
	movl %edx,_numecs(%rip)
L510:
	movslq _csize(%rip),%rax
	movl _ecgroup(,%rax,4),%edi
	movl %edi,_ecgroup(%rip)
	call _abs
	movl %eax,_NUL_ec(%rip)
	cmpl $0,_useecs(%rip)
	jz L494
L514:
	call _ccl2ecl
L494:
	ret 


_set_up_initial_allocations:
L518:
L519:
	movl $2000,_current_mns(%rip)
	movl $4,%esi
	movl $2000,%edi
	call _allocate_array
	movq %rax,_firstst(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_lastst(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_finalst(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_transchar(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_trans1(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_trans2(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_accptnum(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_assoc_rule(%rip)
	movl $4,%esi
	movl _current_mns(%rip),%edi
	call _allocate_array
	movq %rax,_state_type(%rip)
	movl $100,_current_max_rules(%rip)
	movl $4,%esi
	movl $100,%edi
	call _allocate_array
	movq %rax,_rule_type(%rip)
	movl $4,%esi
	movl _current_max_rules(%rip),%edi
	call _allocate_array
	movq %rax,_rule_linenum(%rip)
	movl $40,_current_max_scs(%rip)
	movl $4,%esi
	movl $40,%edi
	call _allocate_array
	movq %rax,_scset(%rip)
	movl $4,%esi
	movl _current_max_scs(%rip),%edi
	call _allocate_array
	movq %rax,_scbol(%rip)
	movl $4,%esi
	movl _current_max_scs(%rip),%edi
	call _allocate_array
	movq %rax,_scxclu(%rip)
	movl $4,%esi
	movl _current_max_scs(%rip),%edi
	call _allocate_array
	movq %rax,_sceof(%rip)
	movl $8,%esi
	movl _current_max_scs(%rip),%edi
	call _allocate_array
	movq %rax,_scname(%rip)
	movl $4,%esi
	movl _current_max_scs(%rip),%edi
	call _allocate_array
	movq %rax,_actvsc(%rip)
	movl $100,_current_maxccls(%rip)
	movl $4,%esi
	movl $100,%edi
	call _allocate_array
	movq %rax,_cclmap(%rip)
	movl $4,%esi
	movl _current_maxccls(%rip),%edi
	call _allocate_array
	movq %rax,_ccllen(%rip)
	movl $4,%esi
	movl _current_maxccls(%rip),%edi
	call _allocate_array
	movq %rax,_cclng(%rip)
	movl $500,_current_max_ccl_tbl_size(%rip)
	movl $1,%esi
	movl $500,%edi
	call _allocate_array
	movq %rax,_ccltbl(%rip)
	movl $750,_current_max_dfa_size(%rip)
	movl $2000,_current_max_xpairs(%rip)
	movl $4,%esi
	movl $2000,%edi
	call _allocate_array
	movq %rax,_nxt(%rip)
	movl $4,%esi
	movl _current_max_xpairs(%rip),%edi
	call _allocate_array
	movq %rax,_chk(%rip)
	movl $2500,_current_max_template_xpairs(%rip)
	movl $4,%esi
	movl $2500,%edi
	call _allocate_array
	movq %rax,_tnxt(%rip)
	movl $1000,_current_max_dfas(%rip)
	movl $4,%esi
	movl $1000,%edi
	call _allocate_array
	movq %rax,_base(%rip)
	movl $4,%esi
	movl _current_max_dfas(%rip),%edi
	call _allocate_array
	movq %rax,_def(%rip)
	movl $4,%esi
	movl _current_max_dfas(%rip),%edi
	call _allocate_array
	movq %rax,_dfasiz(%rip)
	movl $4,%esi
	movl _current_max_dfas(%rip),%edi
	call _allocate_array
	movq %rax,_accsiz(%rip)
	movl $4,%esi
	movl _current_max_dfas(%rip),%edi
	call _allocate_array
	movq %rax,_dhash(%rip)
	movl $8,%esi
	movl _current_max_dfas(%rip),%edi
	call _allocate_array
	movq %rax,_dss(%rip)
	movl $8,%esi
	movl _current_max_dfas(%rip),%edi
	call _allocate_array
	movq %rax,_dfaacc(%rip)
	movq $0,_nultrans(%rip)
L520:
	ret 

L409:
	.byte 102,117,108,108,32,116,97,98
	.byte 108,101,32,97,110,100,32,45
	.byte 73,32,97,114,101,32,40,99
	.byte 117,114,114,101,110,116,108,121
	.byte 41,32,105,110,99,111,109,112
	.byte 97,116,105,98,108,101,0
L440:
	.byte 99,111,117,108,100,32,110,111
	.byte 116,32,99,114,101,97,116,101
	.byte 32,108,101,120,46,98,97,99
	.byte 107,116,114,97,99,107,0
L245:
	.byte 32,32,37,100,32,114,117,108
	.byte 101,115,10,0
L243:
	.byte 32,32,37,100,47,37,100,32
	.byte 78,70,65,32,115,116,97,116
	.byte 101,115,10,0
L290:
	.byte 32,32,37,100,32,40,37,100
	.byte 32,115,97,118,101,100,41,32
	.byte 104,97,115,104,32,99,111,108
	.byte 108,105,115,105,111,110,115,44
	.byte 32,37,100,32,68,70,65,115
	.byte 32,101,113,117,97,108,10,0
L280:
	.byte 32,32,37,100,32,112,114,111
	.byte 116,111,115,32,99,114,101,97
	.byte 116,101,100,10,0
L454:
	.byte 99,97,110,39,116,32,111,112
	.byte 101,110,32,116,101,109,112,111
	.byte 114,97,114,121,32,97,99,116
	.byte 105,111,110,32,102,105,108,101
	.byte 32,37,115,0
L445:
	.byte 99,97,110,39,116,32,111,112
	.byte 101,110,32,115,107,101,108,101
	.byte 116,111,110,32,102,105,108,101
	.byte 32,37,115,0
L329:
	.byte 45,67,32,102,108,97,103,32
	.byte 109,117,115,116,32,98,101,32
	.byte 103,105,118,101,110,32,115,101
	.byte 112,97,114,97,116,101,108,121
	.byte 0
L30:
	.byte 121,121,109,111,114,101,40,41
	.byte 32,101,110,116,97,105,108,115
	.byte 32,97,32,109,105,110,111,114
	.byte 32,112,101,114,102,111,114,109
	.byte 97,110,99,101,32,112,101,110
	.byte 97,108,116,121,10,0
L372:
	.byte 45,83,32,102,108,97,103,32
	.byte 109,117,115,116,32,98,101,32
	.byte 103,105,118,101,110,32,115,101
	.byte 112,97,114,97,116,101,108,121
	.byte 0
L417:
	.byte 102,117,108,108,32,116,97,98
	.byte 108,101,32,97,110,100,32,45
	.byte 70,32,97,114,101,32,109,117
	.byte 116,117,97,108,108,121,32,101
	.byte 120,99,108,117,115,105,118,101
	.byte 0
L141:
	.byte 37,115,32,118,101,114,115,105
	.byte 111,110,32,37,115,32,117,115
	.byte 97,103,101,32,115,116,97,116
	.byte 105,115,116,105,99,115,58,10
	.byte 0
L26:
	.byte 45,73,32,40,105,110,116,101
	.byte 114,97,99,116,105,118,101,41
	.byte 32,101,110,116,97,105,108,115
	.byte 32,97,32,109,105,110,111,114
	.byte 32,112,101,114,102,111,114,109
	.byte 97,110,99,101,32,112,101,110
	.byte 97,108,116,121,10,0
L238:
	.byte 47,108,105,98,47,102,108,101
	.byte 120,46,115,107,101,108,0
L271:
	.byte 32,32,37,100,47,37,100,32
	.byte 117,110,105,113,117,101,47,100
	.byte 117,112,108,105,99,97,116,101
	.byte 32,116,114,97,110,115,105,116
	.byte 105,111,110,115,10,0
L109:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,100,101,108,101
	.byte 116,105,110,103,32,111,117,116
	.byte 112,117,116,32,102,105,108,101
	.byte 0
L82:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,119,114,105,116
	.byte 105,110,103,32,116,101,109,112
	.byte 111,114,97,114,121,32,97,99
	.byte 116,105,111,110,32,102,105,108
	.byte 101,0
L507:
	.byte 102,97,116,97,108,32,112,97
	.byte 114,115,101,32,101,114,114,111
	.byte 114,0
L348:
	.byte 117,110,107,110,111,119,110,32
	.byte 45,67,32,111,112,116,105,111
	.byte 110,32,39,37,99,39,0
L239:
	.byte 32,45,83,37,115,0
L264:
	.byte 32,32,37,100,32,101,112,115
	.byte 105,108,111,110,32,115,116,97
	.byte 116,101,115,44,32,37,100,32
	.byte 100,111,117,98,108,101,32,101
	.byte 112,115,105,108,111,110,32,115
	.byte 116,97,116,101,115,10,0
L210:
	.byte 32,45,67,0
L291:
	.byte 32,32,37,100,32,115,101,116
	.byte 115,32,111,102,32,114,101,97
	.byte 108,108,111,99,97,116,105,111
	.byte 110,115,32,110,101,101,100,101
	.byte 100,10,0
L143:
	.byte 32,32,115,99,97,110,110,101
	.byte 114,32,111,112,116,105,111,110
	.byte 115,58,32,45,0
L450:
	.byte 47,116,109,112,47,102,108,101
	.byte 120,88,88,88,88,88,88,0
L429:
	.byte 99,111,117,108,100,32,110,111
	.byte 116,32,99,114,101,97,116,101
	.byte 32,37,115,0
L257:
	.byte 32,32,37,100,32,98,97,99
	.byte 107,116,114,97,99,107,105,110
	.byte 103,32,40,110,111,110,45,97
	.byte 99,99,101,112,116,105,110,103
	.byte 41,32,115,116,97,116,101,115
	.byte 10,0
L244:
	.byte 32,32,37,100,47,37,100,32
	.byte 68,70,65,32,115,116,97,116
	.byte 101,115,32,40,37,100,32,119
	.byte 111,114,100,115,41,10,0
L279:
	.byte 32,32,37,100,32,101,109,112
	.byte 116,121,32,116,97,98,108,101
	.byte 32,101,110,116,114,105,101,115
	.byte 10,0
L502:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,95,67,72,65,82,32
	.byte 117,110,115,105,103,110,101,100
	.byte 32,99,104,97,114,0
L276:
	.byte 32,32,37,100,47,37,100,32
	.byte 98,97,115,101,45,100,101,102
	.byte 32,101,110,116,114,105,101,115
	.byte 32,99,114,101,97,116,101,100
	.byte 10,0
L258:
	.byte 32,32,99,111,109,112,114,101
	.byte 115,115,101,100,32,116,97,98
	.byte 108,101,115,32,97,108,119,97
	.byte 121,115,32,98,97,99,107,116
	.byte 114,97,99,107,10,0
L101:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,119,114,105,116
	.byte 105,110,103,32,111,117,116,112
	.byte 117,116,32,102,105,108,101,0
L71:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,119,114,105,116
	.byte 105,110,103,32,115,107,101,108
	.byte 101,116,111,110,32,102,105,108
	.byte 101,0
L249:
	.byte 32,32,78,111,32,98,97,99
	.byte 107,116,114,97,99,107,105,110
	.byte 103,10,0
L60:
	.byte 118,97,114,105,97,98,108,101
	.byte 32,116,114,97,105,108,105,110
	.byte 103,32,99,111,110,116,101,120
	.byte 116,32,114,117,108,101,115,32
	.byte 99,97,110,110,111,116,32,98
	.byte 101,32,117,115,101,100,32,119
	.byte 105,116,104,32,45,102,32,111
	.byte 114,32,45,70,0
L503:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,95,67,72,65,82,32
	.byte 99,104,97,114,0
L137:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,99,108,111,115
	.byte 105,110,103,32,98,97,99,107
	.byte 116,114,97,99,107,105,110,103
	.byte 32,102,105,108,101,0
L120:
	.byte 78,111,32,98,97,99,107,116
	.byte 114,97,99,107,105,110,103,46
	.byte 10,0
L285:
	.byte 32,32,37,100,47,37,100,32
	.byte 101,113,117,105,118,97,108,101
	.byte 110,99,101,32,99,108,97,115
	.byte 115,101,115,32,99,114,101,97
	.byte 116,101,100,10,0
L129:
	.byte 67,111,109,112,114,101,115,115
	.byte 101,100,32,116,97,98,108,101
	.byte 115,32,97,108,119,97,121,115
	.byte 32,98,97,99,107,116,114,97
	.byte 99,107,46,10,0
L324:
	.byte 37,115,58,32,65,115,115,117
	.byte 109,105,110,103,32,117,115,101
	.byte 32,111,102,32,100,101,112,114
	.byte 101,99,97,116,101,100,32,45
	.byte 99,32,102,108,97,103,32,105
	.byte 115,32,114,101,97,108,108,121
	.byte 32,105,110,116,101,110,100,101
	.byte 100,32,116,111,32,98,101,32
	.byte 45,67,10,0
L34:
	.byte 82,69,74,69,67,84,32,101
	.byte 110,116,97,105,108,115,32,97
	.byte 32,108,97,114,103,101,32,112
	.byte 101,114,102,111,114,109,97,110
	.byte 99,101,32,112,101,110,97,108
	.byte 116,121,10,0
L268:
	.byte 32,32,110,111,32,99,104,97
	.byte 114,97,99,116,101,114,32,99
	.byte 108,97,115,115,101,115,10,0
L278:
	.byte 32,32,37,100,47,37,100,32
	.byte 40,112,101,97,107,32,37,100
	.byte 41,32,116,101,109,112,108,97
	.byte 116,101,32,110,120,116,45,99
	.byte 104,107,32,101,110,116,114,105
	.byte 101,115,32,99,114,101,97,116
	.byte 101,100,10,0
L90:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,100,101,108,101
	.byte 116,105,110,103,32,116,101,109
	.byte 112,111,114,97,114,121,32,97
	.byte 99,116,105,111,110,32,102,105
	.byte 108,101,0
L269:
	.byte 32,32,37,100,47,37,100,32
	.byte 99,104,97,114,97,99,116,101
	.byte 114,32,99,108,97,115,115,101
	.byte 115,32,110,101,101,100,101,100
	.byte 32,37,100,47,37,100,32,119
	.byte 111,114,100,115,32,111,102,32
	.byte 115,116,111,114,97,103,101,44
	.byte 32,37,100,32,114,101,117,115
	.byte 101,100,10,0
L262:
	.byte 32,32,66,101,103,105,110,110
	.byte 105,110,103,45,111,102,45,108
	.byte 105,110,101,32,112,97,116,116
	.byte 101,114,110,115,32,117,115,101
	.byte 100,10,0
L128:
	.byte 37,100,32,98,97,99,107,116
	.byte 114,97,99,107,105,110,103,32
	.byte 40,110,111,110,45,97,99,99
	.byte 101,112,116,105,110,103,41,32
	.byte 115,116,97,116,101,115,46,10
	.byte 0
L397:
	.byte 102,117,108,108,32,116,97,98
	.byte 108,101,32,97,110,100,32,45
	.byte 67,109,32,100,111,110,39,116
	.byte 32,109,97,107,101,32,115,101
	.byte 110,115,101,32,116,111,103,101
	.byte 116,104,101,114,0
L444:
	.byte 114,0
L275:
	.byte 32,32,37,100,32,116,97,98
	.byte 108,101,32,101,110,116,114,105
	.byte 101,115,10,0
L86:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,99,108,111,115
	.byte 105,110,103,32,116,101,109,112
	.byte 111,114,97,114,121,32,97,99
	.byte 116,105,111,110,32,102,105,108
	.byte 101,0
L59:
	.byte 82,69,74,69,67,84,32,99
	.byte 97,110,110,111,116,32,98,101
	.byte 32,117,115,101,100,32,119,105
	.byte 116,104,32,45,102,32,111,114
	.byte 32,45,70,0
L425:
	.byte 119,0
L133:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,119,114,105,116
	.byte 105,110,103,32,98,97,99,107
	.byte 116,114,97,99,107,105,110,103
	.byte 32,102,105,108,101,0
L436:
	.byte 108,101,120,46,98,97,99,107
	.byte 116,114,97,99,107,0
L281:
	.byte 32,32,37,100,32,116,101,109
	.byte 112,108,97,116,101,115,32,99
	.byte 114,101,97,116,101,100,44,32
	.byte 37,100,32,117,115,101,115,10
	.byte 0
L384:
	.byte 117,110,107,110,111,119,110,32
	.byte 102,108,97,103,32,39,37,99
	.byte 39,0
L142:
	.byte 32,32,115,116,97,114,116,101
	.byte 100,32,97,116,32,37,115,44
	.byte 32,102,105,110,105,115,104,101
	.byte 100,32,97,116,32,37,115,10
	.byte 0
L498:
	.byte 35,100,101,102,105,110,101,32
	.byte 70,76,69,88,95,68,69,66
	.byte 85,71,0
L1:
	.byte 108,101,120,46,121,121,46,99
	.byte 0
L270:
	.byte 32,32,37,100,32,115,116,97
	.byte 116,101,47,110,101,120,116,115
	.byte 116,97,116,101,32,112,97,105
	.byte 114,115,32,99,114,101,97,116
	.byte 101,100,10,0
L277:
	.byte 32,32,37,100,47,37,100,32
	.byte 40,112,101,97,107,32,37,100
	.byte 41,32,110,120,116,45,99,104
	.byte 107,32,101,110,116,114,105,101
	.byte 115,32,99,114,101,97,116,101
	.byte 100,10,0
L289:
	.byte 32,32,37,100,47,37,100,32
	.byte 109,101,116,97,45,101,113,117
	.byte 105,118,97,108,101,110,99,101
	.byte 32,99,108,97,115,115,101,115
	.byte 32,99,114,101,97,116,101,100
	.byte 10,0
L38:
	.byte 86,97,114,105,97,98,108,101
	.byte 32,116,114,97,105,108,105,110
	.byte 103,32,99,111,110,116,101,120
	.byte 116,32,114,117,108,101,115,32
	.byte 101,110,116,97,105,108,32,97
	.byte 32,108,97,114,103,101,32,112
	.byte 101,114,102,111,114,109,97,110
	.byte 99,101,32,112,101,110,97,108
	.byte 116,121,10,0
L105:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,99,108,111,115
	.byte 105,110,103,32,111,117,116,112
	.byte 117,116,32,102,105,108,101,0
L292:
	.byte 32,32,37,100,32,116,111,116
	.byte 97,108,32,116,97,98,108,101
	.byte 32,101,110,116,114,105,101,115
	.byte 32,110,101,101,100,101,100,10
	.byte 0
L263:
	.byte 32,32,37,100,47,37,100,32
	.byte 115,116,97,114,116,32,99,111
	.byte 110,100,105,116,105,111,110,115
	.byte 10,0
L75:
	.byte 101,114,114,111,114,32,111,99
	.byte 99,117,114,114,101,100,32,119
	.byte 104,101,110,32,99,108,111,115
	.byte 105,110,103,32,115,107,101,108
	.byte 101,116,111,110,32,102,105,108
	.byte 101,0
.globl _printstats
.comm _printstats, 4, 4
.globl _syntaxerror
.comm _syntaxerror, 4, 4
.globl _eofseen
.comm _eofseen, 4, 4
.globl _ddebug
.comm _ddebug, 4, 4
.globl _trace
.comm _trace, 4, 4
.globl _spprdflt
.comm _spprdflt, 4, 4
.globl _interactive
.comm _interactive, 4, 4
.globl _caseins
.comm _caseins, 4, 4
.globl _useecs
.comm _useecs, 4, 4
.globl _fulltbl
.comm _fulltbl, 4, 4
.globl _usemecs
.comm _usemecs, 4, 4
.globl _fullspd
.comm _fullspd, 4, 4
.globl _gen_line_dirs
.comm _gen_line_dirs, 4, 4
.globl _performance_report
.comm _performance_report, 4, 4
.globl _backtrack_report
.comm _backtrack_report, 4, 4
.globl _csize
.comm _csize, 4, 4
.globl _yymore_used
.comm _yymore_used, 4, 4
.globl _reject
.comm _reject, 4, 4
.globl _real_reject
.comm _real_reject, 4, 4
.globl _continued_action
.comm _continued_action, 4, 4
.globl _yymore_really_used
.comm _yymore_really_used, 4, 4
.globl _reject_really_used
.comm _reject_really_used, 4, 4
.globl _datapos
.comm _datapos, 4, 4
.globl _dataline
.comm _dataline, 4, 4
.globl _linenum
.comm _linenum, 4, 4
.globl _temp_action_file
.comm _temp_action_file, 8, 8
.globl _backtrack_file
.comm _backtrack_file, 8, 8
.globl _input_files
.comm _input_files, 8, 8
.globl _num_input_files
.comm _num_input_files, 4, 4
.globl _program_name
.comm _program_name, 8, 8
.globl _onestate
.comm _onestate, 2000, 4
.globl _onesym
.comm _onesym, 2000, 4
.globl _onenext
.comm _onenext, 2000, 4
.globl _onedef
.comm _onedef, 2000, 4
.globl _onesp
.comm _onesp, 4, 4
.globl _current_mns
.comm _current_mns, 4, 4
.globl _num_rules
.comm _num_rules, 4, 4
.globl _current_max_rules
.comm _current_max_rules, 4, 4
.globl _lastnfa
.comm _lastnfa, 4, 4
.globl _firstst
.comm _firstst, 8, 8
.globl _lastst
.comm _lastst, 8, 8
.globl _finalst
.comm _finalst, 8, 8
.globl _transchar
.comm _transchar, 8, 8
.globl _trans1
.comm _trans1, 8, 8
.globl _trans2
.comm _trans2, 8, 8
.globl _accptnum
.comm _accptnum, 8, 8
.globl _assoc_rule
.comm _assoc_rule, 8, 8
.globl _state_type
.comm _state_type, 8, 8
.globl _rule_type
.comm _rule_type, 8, 8
.globl _rule_linenum
.comm _rule_linenum, 8, 8
.globl _current_state_type
.comm _current_state_type, 4, 4
.globl _variable_trailing_context_rules
.comm _variable_trailing_context_rules, 4, 4
.globl _numtemps
.comm _numtemps, 4, 4
.globl _numprots
.comm _numprots, 4, 4
.globl _protprev
.comm _protprev, 200, 4
.globl _protnext
.comm _protnext, 200, 4
.globl _prottbl
.comm _prottbl, 200, 4
.globl _protcomst
.comm _protcomst, 200, 4
.globl _firstprot
.comm _firstprot, 4, 4
.globl _lastprot
.comm _lastprot, 4, 4
.globl _protsave
.comm _protsave, 8000, 4
.globl _numecs
.comm _numecs, 4, 4
.globl _nextecm
.comm _nextecm, 1028, 4
.globl _ecgroup
.comm _ecgroup, 1028, 4
.globl _nummecs
.comm _nummecs, 4, 4
.globl _tecfwd
.comm _tecfwd, 1028, 4
.globl _tecbck
.comm _tecbck, 1028, 4
.globl _num_xlations
.comm _num_xlations, 4, 4
.globl _lastsc
.comm _lastsc, 4, 4
.globl _current_max_scs
.comm _current_max_scs, 4, 4
.globl _scset
.comm _scset, 8, 8
.globl _scbol
.comm _scbol, 8, 8
.globl _scxclu
.comm _scxclu, 8, 8
.globl _sceof
.comm _sceof, 8, 8
.globl _actvsc
.comm _actvsc, 8, 8
.globl _scname
.comm _scname, 8, 8
.globl _current_max_dfa_size
.comm _current_max_dfa_size, 4, 4
.globl _current_max_xpairs
.comm _current_max_xpairs, 4, 4
.globl _current_max_template_xpairs
.comm _current_max_template_xpairs, 4, 4
.globl _current_max_dfas
.comm _current_max_dfas, 4, 4
.globl _lastdfa
.comm _lastdfa, 4, 4
.globl _nxt
.comm _nxt, 8, 8
.globl _chk
.comm _chk, 8, 8
.globl _tnxt
.comm _tnxt, 8, 8
.globl _base
.comm _base, 8, 8
.globl _def
.comm _def, 8, 8
.globl _nultrans
.comm _nultrans, 8, 8
.globl _NUL_ec
.comm _NUL_ec, 4, 4
.globl _tblend
.comm _tblend, 4, 4
.globl _firstfree
.comm _firstfree, 4, 4
.globl _dss
.comm _dss, 8, 8
.globl _dfasiz
.comm _dfasiz, 8, 8
.globl _dfaacc
.comm _dfaacc, 8, 8
.globl _accsiz
.comm _accsiz, 8, 8
.globl _dhash
.comm _dhash, 8, 8
.globl _numas
.comm _numas, 4, 4
.globl _numsnpairs
.comm _numsnpairs, 4, 4
.globl _jambase
.comm _jambase, 4, 4
.globl _jamstate
.comm _jamstate, 4, 4
.globl _end_of_buffer_state
.comm _end_of_buffer_state, 4, 4
.globl _lastccl
.comm _lastccl, 4, 4
.globl _current_maxccls
.comm _current_maxccls, 4, 4
.globl _cclmap
.comm _cclmap, 8, 8
.globl _ccllen
.comm _ccllen, 8, 8
.globl _cclng
.comm _cclng, 8, 8
.globl _cclreuse
.comm _cclreuse, 4, 4
.globl _current_max_ccl_tbl_size
.comm _current_max_ccl_tbl_size, 4, 4
.globl _ccltbl
.comm _ccltbl, 8, 8
.globl _starttime
.comm _starttime, 8, 8
.globl _endtime
.comm _endtime, 8, 8
.globl _nmstr
.comm _nmstr, 1024, 1
.globl _sectnum
.comm _sectnum, 4, 4
.globl _nummt
.comm _nummt, 4, 4
.globl _hshcol
.comm _hshcol, 4, 4
.globl _dfaeql
.comm _dfaeql, 4, 4
.globl _numeps
.comm _numeps, 4, 4
.globl _eps2
.comm _eps2, 4, 4
.globl _num_reallocs
.comm _num_reallocs, 4, 4
.globl _tmpuses
.comm _tmpuses, 4, 4
.globl _totnst
.comm _totnst, 4, 4
.globl _peakpairs
.comm _peakpairs, 4, 4
.globl _numuniq
.comm _numuniq, 4, 4
.globl _numdup
.comm _numdup, 4, 4
.globl _hshsave
.comm _hshsave, 4, 4
.globl _num_backtracking
.comm _num_backtracking, 4, 4
.globl _bol_needed
.comm _bol_needed, 4, 4
.local _use_stdout
.comm _use_stdout, 4, 4

.globl _assoc_rule
.globl _firstst
.globl _protcomst
.globl _finalst
.globl _flexinit
.globl _numsnpairs
.globl _actvsc
.globl _current_max_rules
.globl _spprdflt
.globl _hshsave
.globl _flex_gettime
.globl _num_backtracking
.globl _nummt
.globl _current_max_dfas
.globl _num_xlations
.globl _trans2
.globl _num_rules
.globl _dataline
.globl _ccltbl
.globl _gen_line_dirs
.globl _numdup
.globl _jamstate
.globl _current_max_dfa_size
.globl _endtime
.globl _nxt
.globl _onestate
.globl _onedef
.globl _csize
.globl _dss
.globl _def
.globl _useecs
.globl _numas
.globl _variable_trailing_context_rules
.globl _performance_report
.globl _fopen
.globl ___stdout
.globl _current_maxccls
.globl _numprots
.globl _temp_action_file
.globl _cclreuse
.globl _firstprot
.globl _rule_linenum
.globl _datapos
.globl _hshcol
.globl _input_files
.globl _ddebug
.globl _make_tables
.globl _num_reallocs
.globl _current_max_xpairs
.globl _cclmap
.globl _current_mns
.globl _mktemp
.globl _cre8ecs
.globl _tecbck
.globl _skelfile
.globl _set_input_file
.globl _dfasiz
.globl _protnext
.globl _state_type
.globl _continued_action
.globl _set_up_initial_allocations
.globl _tnxt
.globl _puts
.globl _numtemps
.globl _abs
.globl _ecs_from_xlation
.globl _peakpairs
.globl _tmpuses
.globl _current_max_scs
.globl _onesp
.globl _reject
.globl _flexfatal
.globl _jambase
.globl _yymore_really_used
.globl _yyparse
.globl _line_directive_out
.globl _NUL_ec
.globl _program_name
.globl _prottbl
.globl _reject_really_used
.globl _eofseen
.globl _tmpnam
.globl _printstats
.globl _nmstr
.globl _lastnfa
.globl _nultrans
.globl _ecgroup
.globl _chk
.globl _ntod
.globl _dfaacc
.globl _onenext
.globl _strcmp
.globl ___flushbuf
.globl _ccl2ecl
.globl _starttime
.globl _accsiz
.globl _tblend
.globl _scname
.globl _unlink
.globl _sceof
.globl _bol_needed
.globl _numeps
.globl _transchar
.globl _lastst
.globl _lastdfa
.globl ___stderr
.globl _pinpoint_message
.globl _action_file_name
.globl _current_max_ccl_tbl_size
.globl _lastsc
.globl _real_reject
.globl _linenum
.globl _trace
.globl _fclose
.globl _xlation
.globl _nextecm
.globl _lerrsf
.globl _flexend
.globl _accptnum
.globl _current_max_template_xpairs
.globl _tecfwd
.globl _trans1
.globl _allocate_array
.globl _sectnum
.globl _infilename
.globl _yymore_used
.globl _fullspd
.globl _lastprot
.globl _backtrack_report
.globl _skelout
.globl _nummecs
.globl _onesym
.globl _dfaeql
.globl _scset
.globl _dhash
.globl _end_of_buffer_state
.globl _scbol
.globl _caseins
.globl _lerrif
.globl _numuniq
.globl _totnst
.globl _ccllen
.globl _lastccl
.globl _num_input_files
.globl _main
.globl _flexerror
.globl _base
.globl _protprev
.globl _rule_type
.globl _interactive
.globl _exit
.globl _cclng
.globl _firstfree
.globl _protsave
.globl _syntaxerror
.globl _strcpy
.globl _freopen
.globl _readin
.globl _fulltbl
.globl _current_state_type
.globl _usemecs
.globl _fprintf
.globl _eps2
.globl _scxclu
.globl _numecs
.globl _backtrack_file
