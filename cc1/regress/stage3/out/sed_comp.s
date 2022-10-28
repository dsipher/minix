.data
.align 8
_pending:
	.quad 0
.align 2
_last_line_used:
	.short 0
.text

_die:
L1:
	pushq %rbx
L2:
	movq %rdi,%rbx
	pushq $L4
	pushq $___stderr
	call _fprintf
	pushq $_linebuf
	pushq %rbx
	pushq $___stderr
	call _fprintf
	pushq $L5
	pushq $___stderr
	call _fprintf
	addq $56,%rsp
	movl $2,%edi
	call _exit
L3:
	popq %rbx
	ret 

.data
_AGMSG:
	.byte 103,97,114,98,108,101,100,32
	.byte 97,100,100,114,101,115,115,32
	.byte 37,115,0
_CGMSG:
	.byte 103,97,114,98,108,101,100,32
	.byte 99,111,109,109,97,110,100,32
	.byte 37,115,0
_TMTXT:
	.byte 116,111,111,32,109,117,99,104
	.byte 32,116,101,120,116,58,32,37
	.byte 115,0
_AD1NG:
	.byte 110,111,32,97,100,100,114,101
	.byte 115,115,101,115,32,97,108,108
	.byte 111,119,101,100,32,102,111,114
	.byte 32,37,115,0
_AD2NG:
	.byte 111,110,108,121,32,111,110,101
	.byte 32,97,100,100,114,101,115,115
	.byte 32,97,108,108,111,119,101,100
	.byte 32,102,111,114,32,37,115,0
_TMCDS:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,99,111,109,109,97,110,100
	.byte 115,44,32,108,97,115,116,32
	.byte 119,97,115,32,37,115,0
_COCFI:
	.byte 99,97,110,110,111,116,32,111
	.byte 112,101,110,32,99,111,109,109
	.byte 97,110,100,45,102,105,108,101
	.byte 32,37,115,0
_UFLAG:
	.byte 117,110,107,110,111,119,110,32
	.byte 102,108,97,103,32,37,99,0
_CCOFI:
	.byte 99,97,110,110,111,116,32,99
	.byte 114,101,97,116,101,32,37,115
	.byte 10,0
_ULABL:
	.byte 117,110,100,101,102,105,110,101
	.byte 100,32,108,97,98,101,108,32
	.byte 37,115,10,0
_TMLBR:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,123,39,115,0
_FRENL:
	.byte 102,105,114,115,116,32,82,69
	.byte 32,109,117,115,116,32,98,101
	.byte 32,110,111,110,45,110,117,108
	.byte 108,0
_NSCAX:
	.byte 110,111,32,115,117,99,104,32
	.byte 99,111,109,109,97,110,100,32
	.byte 97,115,32,37,115,0
_TMRBR:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,125,39,115,0
_DLABL:
	.byte 100,117,112,108,105,99,97,116
	.byte 101,32,108,97,98,101,108,32
	.byte 37,115,0
_TMLAB:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,108,97,98,101,108,115,58
	.byte 32,37,115,0
_TMWFI:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,119,32,102,105,108,101,115
	.byte 0
_REITL:
	.byte 82,69,32,116,111,111,32,108
	.byte 111,110,103,58,32,37,115,0
_TMLNR:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,108,105,110,101,32,110,117
	.byte 109,98,101,114,115,0
_TRAIL:
	.byte 99,111,109,109,97,110,100,32
	.byte 34,37,115,34,32,104,97,115
	.byte 32,116,114,97,105,108,105,110
	.byte 103,32,103,97,114,98,97,103
	.byte 101,0
_RETER:
	.byte 82,69,32,110,111,116,32,116
	.byte 101,114,109,105,110,97,116,101
	.byte 100,58,32,37,115,0
_CCERR:
	.byte 117,110,107,110,111,119,110,32
	.byte 99,104,97,114,97,99,116,101
	.byte 114,32,99,108,97,115,115,58
	.byte 32,37,115,0
.align 8
_cclasses:
	.quad L6
	.quad L7
	.quad L8
	.quad L9
	.quad L10
	.quad L11
	.quad L12
	.quad L13
	.quad L14
	.quad L15
	.quad L16
	.quad L17
	.quad L18
	.quad L19
	.quad L20
	.quad L21
	.quad L22
	.quad L23
	.quad L24
	.quad L25
	.quad L26
	.quad L27
	.quad L28
	.quad L29
	.quad 0
.align 8
_lab:
	.quad _labels+24
.align 8
_lablst:
	.quad _labels
.align 8
_fp:
	.quad _pool
.align 8
_poolend:
	.quad _pool+10000
.align 8
_cmdf:
	.quad 0
.align 8
_cmdp:
	.quad _cmds
.align 8
_lastre:
	.quad 0
.align 4
_bdepth:
	.int 0
.align 4
_bcount:
	.int 0
.text

_main:
L30:
L31:
	movl %edi,_eargc(%rip)
	movq %rsi,_eargv(%rip)
	movq _cmdp(%rip),%rax
	movq $_pool,(%rax)
	cmpl $1,_eargc(%rip)
	jz L78
L37:
	movl _eargc(%rip),%esi
	leal -1(%rsi),%ecx
	movl %ecx,_eargc(%rip)
	cmpl $0,%ecx
	jle L42
L40:
	movq _eargv(%rip),%rdx
	leaq 8(%rdx),%rax
	movq %rax,_eargv(%rip)
	movq 8(%rdx),%rax
	cmpb $45,(%rax)
	jnz L42
L41:
	movb 1(%rax),%al
	cmpb $101,%al
	jz L47
L81:
	cmpb $102,%al
	jz L49
L82:
	cmpb $103,%al
	jz L60
L83:
	cmpb $110,%al
	jz L62
L84:
	movsbl %al,%eax
	pushq %rax
	pushq $_UFLAG
	pushq $___stdout
	call _fprintf
	addq $24,%rsp
	jmp L37
L62:
	movw $1,_nflag(%rip)
	jmp L37
L60:
	movw $1,_gflag(%rip)
	jmp L37
L49:
	addl $-2,%esi
	movl %esi,_eargc(%rip)
	cmpl $0,%ecx
	jle L79
L52:
	leaq 16(%rdx),%rax
	movq %rax,_eargv(%rip)
	movl $L57,%esi
	movq 16(%rdx),%rdi
	call _fopen
	movq %rax,_cmdf(%rip)
	testq %rax,%rax
	jz L54
L56:
	call _compile
	movq _cmdf(%rip),%rdi
	call _fclose
	jmp L37
L54:
	movq _eargv(%rip),%rax
	pushq (%rax)
	pushq $_COCFI
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L79:
	movl $2,%eax
	ret
L47:
	movw $1,_eflag(%rip)
	call _compile
	movw $0,_eflag(%rip)
	jmp L37
L42:
	cmpq $_cmds,_cmdp(%rip)
	jnz L67
L65:
	addq $-8,_eargv(%rip)
	movl %esi,_eargc(%rip)
	movw $1,_eflag(%rip)
	call _compile
	movw $0,_eflag(%rip)
	addq $8,_eargv(%rip)
	decl _eargc(%rip)
L67:
	cmpl $0,_bdepth(%rip)
	jz L70
L68:
	movl $_TMLBR,%edi
	call _die
L70:
	movq _lablst(%rip),%rax
	movq _cmdp(%rip),%rcx
	movq %rcx,16(%rax)
	call _resolve
	cmpl $0,_eargc(%rip)
	jle L71
L74:
	decl _eargc(%rip)
	js L78
L75:
	movq _eargv(%rip),%rcx
	leaq 8(%rcx),%rax
	movq %rax,_eargv(%rip)
	movq (%rcx),%rdi
	call _execute
	jmp L74
L71:
	xorl %edi,%edi
	call _execute
L78:
	xorl %eax,%eax
L32:
	ret 

.data
_cmdmask:
	.byte 0
	.byte 0
	.byte -128
	.byte 0
	.byte 0
	.byte -127
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte -122
	.byte 0
	.byte 0
	.byte 8
	.byte 10
	.byte 0
	.byte 0
	.byte 0
	.byte -96
	.byte 0
	.byte 14
	.byte 0
	.byte 16
	.byte 0
	.byte 0
	.byte 0
	.byte -107
	.byte 0
	.byte 0
	.byte -105
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte -126
	.byte -125
	.byte -124
	.byte 5
	.byte 0
	.byte 0
	.byte 7
	.byte 9
	.byte -117
	.byte 0
	.byte 0
	.byte -116
	.byte 0
	.byte 13
	.byte 0
	.byte 15
	.byte -111
	.byte -110
	.byte -109
	.byte -108
	.byte 0
	.byte 0
	.byte -106
	.byte 24
	.byte -103
	.byte 0
	.byte -125
	.byte 0
	.byte -128
	.byte 0
	.byte 0
.text

_compile:
L86:
	pushq %rbx
L87:
	movq $_linebuf,_cp(%rip)
	movl $_linebuf,%edi
	call _cmdline
	cmpl $0,%eax
	jl L88
L91:
	cmpq $_cmds,_cmdp(%rip)
	jnz L108
L100:
	movq _cp(%rip),%rax
	cmpb $35,(%rax)
	jnz L108
L101:
	cmpb $110,1(%rax)
	jnz L108
L97:
	movw $1,_nflag(%rip)
L108:
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L112
L111:
	cmpb $9,%al
	jnz L113
L112:
	incq %rcx
	movq %rcx,_cp(%rip)
	jmp L108
L113:
	cmpb $59,%al
	jnz L117
L249:
	incq %rcx
	movq %rcx,_cp(%rip)
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L249
L121:
	cmpb $9,%al
	jz L249
L117:
	movq _cp(%rip),%rax
	movb (%rax),%al
	testb %al,%al
	jz L129
L128:
	cmpb $35,%al
	jnz L136
L129:
	movq $_linebuf,_cp(%rip)
	movl $_linebuf,%edi
	call _cmdline
	cmpl $0,%eax
	jl L88
L136:
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L140
L139:
	cmpb $9,%al
	jnz L141
L140:
	incq %rcx
	movq %rcx,_cp(%rip)
	jmp L136
L141:
	testb %al,%al
	jz L108
L146:
	cmpb $35,%al
	jz L108
L148:
	movq _fp(%rip),%rax
	cmpq _poolend(%rip),%rax
	jbe L152
L151:
	movl $_TMTXT,%edi
	jmp L248
L152:
	movq _cmdp(%rip),%rcx
	movq %rax,(%rcx)
	movq _fp(%rip),%rdi
	call _address
	movq %rax,_fp(%rip)
	cmpq $-1,%rax
	jnz L153
L154:
	movl $_AGMSG,%edi
L248:
	call _die
L153:
	movq _cmdp(%rip),%rdx
	movq (%rdx),%rax
	movq _fp(%rip),%rcx
	cmpq %rax,%rcx
	jnz L158
L157:
	movq _lastre(%rip),%rax
	testq %rax,%rax
	jz L161
L160:
	movq %rax,(%rdx)
	jmp L159
L161:
	movl $_FRENL,%edi
	call _die
	jmp L159
L158:
	testq %rcx,%rcx
	jnz L164
L163:
	movq %rax,_fp(%rip)
	movq $0,(%rdx)
	jmp L159
L164:
	movq %rax,_lastre(%rip)
	movq _cp(%rip),%rsi
	movb (%rsi),%al
	cmpb $44,%al
	jz L170
L169:
	cmpb $59,%al
	jnz L171
L170:
	incq %rsi
	movq %rsi,_cp(%rip)
	cmpq _poolend(%rip),%rcx
	jbe L175
L173:
	movl $_TMTXT,%edi
	call _die
L175:
	movq _cmdp(%rip),%rcx
	movq _fp(%rip),%rax
	movq %rax,8(%rcx)
	movq _fp(%rip),%rdi
	call _address
	movq %rax,_fp(%rip)
	cmpq $-1,%rax
	jz L180
L179:
	testq %rax,%rax
	jnz L178
L180:
	movl $_AGMSG,%edi
	call _die
L178:
	movq _cmdp(%rip),%rcx
	movq 8(%rcx),%rax
	cmpq %rax,_fp(%rip)
	jnz L184
L183:
	movq _lastre(%rip),%rax
	movq %rax,8(%rcx)
	jmp L159
L184:
	movq %rax,_lastre(%rip)
	jmp L159
L171:
	movq $0,8(%rdx)
L159:
	movq _fp(%rip),%rax
	cmpq _poolend(%rip),%rax
	jbe L189
L186:
	movl $_TMTXT,%edi
	call _die
L189:
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L193
L192:
	cmpb $9,%al
	jnz L194
L193:
	incq %rcx
	movq %rcx,_cp(%rip)
	jmp L189
L194:
	cmpb $33,%al
	jnz L198
L196:
	movq _cmdp(%rip),%rax
	orl $1,48(%rax)
	incq _cp(%rip)
L199:
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L203
L202:
	cmpb $9,%al
	jnz L198
L203:
	incq %rcx
	movq %rcx,_cp(%rip)
	jmp L199
L198:
	movq _cp(%rip),%rax
	movb (%rax),%al
	cmpb $56,%al
	jl L210
L213:
	cmpb $126,%al
	jg L210
L215:
	movsbl %al,%eax
	subl $56,%eax
	movslq %eax,%rax
	movb _cmdmask(%rax),%bl
	testb %bl,%bl
	jnz L208
L210:
	movl $_NSCAX,%edi
	call _die
L208:
	movq _cmdp(%rip),%rcx
	movb %bl,%al
	andb $127,%al
	movb %al,24(%rcx)
	movsbl %bl,%eax
	testl $128,%eax
	movq _cp(%rip),%rax
	jnz L218
L217:
	incq %rax
	movq %rax,_cp(%rip)
	jmp L219
L218:
	leaq 1(%rax),%rcx
	movq %rcx,_cp(%rip)
	movb (%rax),%dil
	call _cmdcomp
	testl %eax,%eax
	jnz L108
L219:
	movq _cmdp(%rip),%rax
	addq $56,%rax
	movq %rax,_cmdp(%rip)
	cmpq $_cmds+11200,%rax
	jb L227
L224:
	movl $_TMCDS,%edi
	call _die
L227:
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L231
L230:
	cmpb $9,%al
	jnz L232
L231:
	incq %rcx
	movq %rcx,_cp(%rip)
	jmp L227
L232:
	testb %al,%al
	jz L108
L234:
	cmpb $59,%al
	jz L108
L238:
	cmpb $35,%al
	jz L108
L244:
	cmpb $125,%al
	jz L108
L245:
	movl $_TRAIL,%edi
	call _die
	jmp L108
L88:
	popq %rbx
	ret 

.local L253
.comm L253, 160, 8
.local L254
.comm L254, 80, 8
.local L255
.comm L255, 80, 8
.data
.align 4
L256:
	.int 2
.text
.align 1
L447:
	.byte 58
	.byte 61
	.byte 68
	.byte 76
	.byte 84
	.byte 87
	.byte 97
	.byte 98
	.byte 99
	.byte 105
	.byte 108
.align 2
L448:
	.short L284-_cmdcomp
	.short L279-_cmdcomp
	.short L346-_cmdcomp
	.short L405-_cmdcomp
	.short L301-_cmdcomp
	.short L411-_cmdcomp
	.short L333-_cmdcomp
	.short L301-_cmdcomp
	.short L337-_cmdcomp
	.short L333-_cmdcomp
	.short L405-_cmdcomp
.align 2
L449:
	.short L279-_cmdcomp
	.short L333-_cmdcomp
	.short L348-_cmdcomp
	.short L301-_cmdcomp
	.short L439-_cmdcomp
	.short L439-_cmdcomp
	.short L411-_cmdcomp
	.short L439-_cmdcomp
	.short L429-_cmdcomp
	.short L439-_cmdcomp
	.short L262-_cmdcomp
	.short L439-_cmdcomp
	.short L270-_cmdcomp

_cmdcomp:
L250:
	pushq %rbx
L251:
	movq $___stdout,L255(%rip)
	movq $___stderr,L255+8(%rip)
	movq $L257,L254(%rip)
	movq $L258,L254+8(%rip)
	cmpb $113,%dil
	jl L441
L443:
	cmpb $125,%dil
	jg L441
L440:
	addb $-113,%dil
	movzbl %dil,%eax
	movzwl L449(,%rax,2),%eax
	addl $_cmdcomp,%eax
	jmp *%rax
L270:
	movq _cmdp(%rip),%rax
	cmpq $0,(%rax)
	jz L273
L271:
	movl $_AD1NG,%edi
	call _die
L273:
	decl _bdepth(%rip)
	jns L276
L274:
	movl $_TMRBR,%edi
	call _die
L276:
	movslq _bdepth(%rip),%rax
	movq L253(,%rax,8),%rax
	movq _cmdp(%rip),%rcx
	movq %rcx,(%rax)
	jmp L438
L262:
	movq _cmdp(%rip),%rdx
	movl 48(%rdx),%eax
	testl $1,%eax
	setz %cl
	movzbl %cl,%ecx
	andl $1,%ecx
	andl $4294967294,%eax
	orl %ecx,%eax
	movl %eax,48(%rdx)
	movq _cmdp(%rip),%rdx
	movl _bdepth(%rip),%eax
	addq $16,%rdx
	leal 1(%rax),%ecx
	movl %ecx,_bdepth(%rip)
	movslq %eax,%rax
	movq %rdx,L253(,%rax,8)
	movq _cmdp(%rip),%rax
	addq $56,%rax
	movq %rax,_cmdp(%rip)
	cmpq $_cmds+11200,%rax
	jb L265
L263:
	movl $_TMCDS,%edi
	call _die
L265:
	movq _cp(%rip),%rcx
	cmpb $0,(%rcx)
	jnz L438
L266:
	leaq 1(%rcx),%rax
	movq %rax,_cp(%rip)
	movb $59,(%rcx)
	movq _cp(%rip),%rax
	movb $0,(%rax)
	jmp L438
L429:
	movq _cmdp(%rip),%rcx
	movq _fp(%rip),%rax
	movq %rax,16(%rcx)
	movq _cp(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_cp(%rip)
	movb (%rcx),%sil
	movq _fp(%rip),%rdi
	call _ycomp
	movq %rax,_fp(%rip)
	cmpq $-1,%rax
	jnz L432
L430:
	movl $_CGMSG,%edi
	call _die
L432:
	movq _fp(%rip),%rax
	cmpq _poolend(%rip),%rax
	jbe L439
L433:
	movl $_TMTXT,%edi
	jmp L450
L348:
	movq _cp(%rip),%rcx
	cmpb $0,(%rcx)
	jnz L350
L349:
	movl $_RETER,%edi
	call _die
	jmp L351
L350:
	leaq 1(%rcx),%rax
	movq %rax,_cp(%rip)
	movb (%rcx),%bl
L351:
	movq _cmdp(%rip),%rcx
	movq _fp(%rip),%rax
	movq %rax,16(%rcx)
	movb %bl,%sil
	movq _fp(%rip),%rdi
	call _recomp
	movq %rax,_fp(%rip)
	cmpq $-1,%rax
	jnz L354
L352:
	movl $_CGMSG,%edi
	call _die
L354:
	movq _cmdp(%rip),%rcx
	movq 16(%rcx),%rax
	cmpq %rax,_fp(%rip)
	jnz L356
L355:
	movq _lastre(%rip),%rax
	testq %rax,%rax
	jz L359
L358:
	movq %rax,16(%rcx)
	incq _cp(%rip)
	jmp L357
L359:
	movl $_FRENL,%edi
	call _die
	jmp L357
L356:
	movq %rax,_lastre(%rip)
L357:
	movq _cmdp(%rip),%rcx
	movq _fp(%rip),%rax
	movq %rax,32(%rcx)
	movq _fp(%rip),%rax
	cmpq _poolend(%rip),%rax
	jbe L363
L361:
	movl $_TMTXT,%edi
	call _die
L363:
	movq _cmdp(%rip),%rax
	movb %bl,%sil
	movq 32(%rax),%rdi
	call _rhscomp
	movq %rax,_fp(%rip)
	cmpq $-1,%rax
	jnz L366
L364:
	movl $_CGMSG,%edi
	call _die
L366:
	cmpw $0,_gflag(%rip)
	jz L370
L367:
	movq _cmdp(%rip),%rdx
	movl 48(%rdx),%eax
	movl %eax,%ecx
	shll $30,%ecx
	shrl $31,%ecx
	incl %ecx
	andl $1,%ecx
	shll $1,%ecx
	andl $4294967293,%eax
	orl %ecx,%eax
	movl %eax,48(%rdx)
L370:
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $103,%al
	jz L374
L381:
	cmpb $112,%al
	jz L374
L383:
	cmpb $80,%al
	jz L374
L379:
	movsbq %al,%rax
	testb $4,___ctype+1(%rax)
	jz L405
L374:
	cmpb $103,%al
	jnz L387
L385:
	incq %rcx
	movq %rcx,_cp(%rip)
	movq _cmdp(%rip),%rdx
	movl 48(%rdx),%eax
	movl %eax,%ecx
	shll $30,%ecx
	shrl $31,%ecx
	incl %ecx
	andl $1,%ecx
	shll $1,%ecx
	andl $4294967293,%eax
	orl %ecx,%eax
	movl %eax,48(%rdx)
L387:
	movq _cp(%rip),%rax
	cmpb $112,(%rax)
	jnz L390
L388:
	incq %rax
	movq %rax,_cp(%rip)
	movq _cmdp(%rip),%rcx
	movl 48(%rcx),%eax
	andl $4294967283,%eax
	orl $4,%eax
	movl %eax,48(%rcx)
L390:
	movq _cp(%rip),%rax
	cmpb $80,(%rax)
	jnz L393
L391:
	incq %rax
	movq %rax,_cp(%rip)
	movq _cmdp(%rip),%rcx
	movl 48(%rcx),%eax
	andl $4294967283,%eax
	orl $8,%eax
	movl %eax,48(%rcx)
L393:
	movq _cp(%rip),%rdi
	movsbq (%rdi),%rax
	testb $4,___ctype+1(%rax)
	jz L370
L394:
	movq _cmdp(%rip),%rax
	cmpl $0,52(%rax)
	jnz L405
L399:
	call _atoi
	movq _cmdp(%rip),%rcx
	movl %eax,52(%rcx)
L401:
	movq _cp(%rip),%rcx
	movsbq (%rcx),%rax
	testb $4,___ctype+1(%rax)
	jz L370
L402:
	incq %rcx
	movq %rcx,_cp(%rip)
	jmp L401
L441:
	xorl %eax,%eax
L444:
	cmpb L447(,%rax),%dil
	jz L445
L446:
	incl %eax
	cmpl $11,%eax
	jb L444
	jae L439
L445:
	movzwl L448(,%rax,2),%eax
	addl $_cmdcomp,%eax
	jmp *%rax
L301:
	movq _cp(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L305
L304:
	cmpb $9,%al
	jnz L306
L305:
	incq %rcx
	movq %rcx,_cp(%rip)
	jmp L301
L306:
	testb %al,%al
	jz L308
L310:
	movq _lab(%rip),%rcx
	movq _fp(%rip),%rax
	movq %rax,(%rcx)
	movq _fp(%rip),%rdi
	call _gettext
	movq %rax,_fp(%rip)
	movq _lab(%rip),%rdi
	call _search
	testq %rax,%rax
	jz L319
L318:
	movq 16(%rax),%rcx
	testq %rcx,%rcx
	jz L322
L321:
	movq _cmdp(%rip),%rax
	movq %rcx,16(%rax)
	jmp L439
L322:
	movq 8(%rax),%rcx
L324:
	movq 16(%rcx),%rax
	testq %rax,%rax
	jz L451
L325:
	movq %rax,%rcx
	jmp L324
L319:
	movq _lab(%rip),%rax
	movq _cmdp(%rip),%rcx
	movq %rcx,8(%rax)
	movq _lab(%rip),%rax
	movq $0,16(%rax)
	movq _lab(%rip),%rax
	addq $24,%rax
	movq %rax,_lab(%rip)
	cmpq $_labels+1200,%rax
	jb L439
L327:
	movl $_TMLAB,%edi
	jmp L450
L308:
	movq _lablst(%rip),%rax
	movq 8(%rax),%rcx
	testq %rcx,%rcx
	jnz L314
	jz L312
L315:
	movq %rax,%rcx
L314:
	movq 16(%rcx),%rax
	testq %rax,%rax
	jnz L315
L451:
	movq _cmdp(%rip),%rax
	movq %rax,16(%rcx)
	jmp L439
L312:
	movq _cmdp(%rip),%rcx
	movq %rcx,8(%rax)
	jmp L439
L333:
	movq _cmdp(%rip),%rax
	cmpq $0,8(%rax)
	jz L337
L334:
	movl $_AD2NG,%edi
	call _die
L337:
	movq _cp(%rip),%rcx
	cmpb $92,(%rcx)
	jnz L340
L341:
	leaq 1(%rcx),%rax
	movq %rax,_cp(%rip)
	cmpb $10,1(%rcx)
	jnz L340
L342:
	addq $2,%rcx
	movq %rcx,_cp(%rip)
L340:
	movq _cmdp(%rip),%rcx
	movq _fp(%rip),%rax
	movq %rax,16(%rcx)
	movq _fp(%rip),%rdi
	call _gettext
	movq %rax,_fp(%rip)
	jmp L439
L405:
	movq _cp(%rip),%rax
	cmpb $119,(%rax)
	jnz L439
L406:
	incq %rax
	movq %rax,_cp(%rip)
L411:
	cmpl $10,L256(%rip)
	jl L414
L412:
	movl $_TMWFI,%edi
	call _die
L414:
	movslq L256(%rip),%rax
	movq _fp(%rip),%rcx
	movq %rcx,L254(,%rax,8)
	movslq L256(%rip),%rax
	movq _fp(%rip),%rcx
	movq %rcx,L254(,%rax,8)
	movq _fp(%rip),%rdi
	call _gettext
	movq %rax,_fp(%rip)
	movl L256(%rip),%ebx
	decl %ebx
L415:
	movslq L256(%rip),%rax
	movq L254(,%rax,8),%rdi
	cmpl $0,%ebx
	jl L418
L416:
	movslq %ebx,%rbx
	movq L254(,%rbx,8),%rsi
	call _strcmp
	testl %eax,%eax
	jz L419
L421:
	decl %ebx
	jmp L415
L419:
	movq L255(,%rbx,8),%rax
	movq _cmdp(%rip),%rcx
	movq %rax,40(%rcx)
	jmp L439
L418:
	movl $L426,%esi
	call _fopen
	movq _cmdp(%rip),%rcx
	movq %rax,40(%rcx)
	movl L256(%rip),%edx
	movslq %edx,%rcx
	testq %rax,%rax
	jz L423
L425:
	movq _cmdp(%rip),%rax
	movq 40(%rax),%rax
	incl %edx
	movl %edx,L256(%rip)
	movq %rax,L255(,%rcx,8)
	jmp L439
L423:
	pushq L254(,%rcx,8)
	pushq $_CCOFI
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $2,%eax
	jmp L252
L346:
	movq _cmdp(%rip),%rax
	movq $_cmds,16(%rax)
	jmp L439
L279:
	movq _cmdp(%rip),%rax
	cmpq $0,8(%rax)
	jz L439
L280:
	movl $_AD2NG,%edi
L450:
	call _die
	jmp L439
L284:
	movq _cmdp(%rip),%rax
	cmpq $0,(%rax)
	jz L287
L285:
	movl $_AD1NG,%edi
	call _die
L287:
	movq _lab(%rip),%rcx
	movq _fp(%rip),%rax
	movq %rax,(%rcx)
	movq _fp(%rip),%rdi
	call _gettext
	movq %rax,_fp(%rip)
	movq _lab(%rip),%rdi
	call _search
	movq %rax,%rbx
	testq %rax,%rax
	jz L289
L288:
	cmpq $0,16(%rax)
	jz L290
L291:
	movl $_DLABL,%edi
	jmp L452
L289:
	movq _lab(%rip),%rax
	movq $0,8(%rax)
	movq _lab(%rip),%rbx
	leaq 24(%rbx),%rax
	movq %rax,_lab(%rip)
	cmpq $_labels+1200,%rax
	jb L290
L294:
	movl $_TMLAB,%edi
L452:
	call _die
L290:
	movq _cmdp(%rip),%rax
	movq %rax,16(%rbx)
L438:
	movl $1,%eax
	jmp L252
L439:
	xorl %eax,%eax
L252:
	popq %rbx
	ret 


_rhscomp:
L453:
L454:
	movq _cp(%rip),%rdx
L456:
	movb (%rdx),%al
	movb %al,(%rdi)
	incq %rdx
	cmpb $92,%al
	jnz L461
L460:
	movb (%rdx),%al
	cmpb $48,%al
	jl L464
L466:
	cmpb $57,%al
	jle L470
L464:
	cmpb $110,%al
	jz L478
L498:
	cmpb $114,%al
	jz L480
L499:
	cmpb $116,%al
	jz L482
L500:
	movb %al,(%rdi)
	jmp L476
L482:
	movb $9,(%rdi)
	jmp L476
L480:
	movb $13,(%rdi)
	jmp L476
L478:
	movb $10,(%rdi)
L476:
	incq %rdi
	incq %rdx
	jmp L456
L461:
	cmpb %al,%sil
	jz L484
L485:
	cmpb $38,%al
	jnz L489
L488:
	leaq -1(%rdx),%rax
	movb $48,-1(%rdx)
	movq %rax,%rdx
L470:
	movb (%rdx),%cl
	movb %cl,(%rdi)
	movsbl %cl,%ecx
	movl _bcount(%rip),%eax
	incq %rdx
	addl $48,%eax
	cmpl %eax,%ecx
	jg L496
L473:
	movq %rdi,%rax
	incq %rdi
	orb $-128,%cl
	movb %cl,(%rax)
	jmp L456
L489:
	incq %rdi
	testb %al,%al
	jnz L456
L496:
	movq $-1,%rax
	ret
L484:
	movb $0,(%rdi)
	leaq 1(%rdi),%rax
	movq %rdx,_cp(%rip)
L455:
	ret 


_recomp:
L502:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L503:
	movq _cp(%rip),%r12
	movq %rdi,-32(%rbp) # spill
	movb %sil,-33(%rbp) # spill
	movb -33(%rbp),%al # spill
	cmpb (%r12),%al
	jz L505
L507:
	xorl %ebx,%ebx
	leaq -9(%rbp),%rax
	movq %rax,-64(%rbp) # spill
	movl $0,_bcount(%rip)
	movl $0,-40(%rbp) # spill
	cmpb $94,(%r12)
	setz %al
	movzbl %al,%eax
	movq -32(%rbp),%r15 # spill
	movb %al,(%r15)
	incq %r15
	testb %al,%al
	jz L512
L509:
	incq %r12
L512:
	cmpb $0,(%r12)
	jnz L518
L516:
	movl $_RETER,%edi
	call _die
L518:
	movq -32(%rbp),%rax # spill
	addq $256,%rax
	cmpq %rax,%r15
	jae L519
L521:
	movsbl (%r12),%edx
	leaq 1(%r12),%r14
	movq %r14,%r12
	movsbl -33(%rbp),%ecx # spill
	cmpl %ecx,%edx
	jz L523
L525:
	movq %rbx,%rsi
	movq %r15,%rbx
	cmpl $0,%edx
	jz L512
	jl L531
L725:
	cmpl $92,%edx
	jz L534
	jg L531
L726:
	cmpb $10,%dl
	jz L736
L727:
	cmpb $36,%dl
	jz L609
L728:
	cmpb $42,%dl
	jz L603
L729:
	cmpb $46,%dl
	jz L601
L730:
	cmpb $91,%dl
	jnz L531
L615:
	leaq 33(%r15),%rcx
	cmpq %rcx,%rax
	ja L618
L616:
	movl $_REITL,%edi
	call _die
L618:
	movb $6,(%r15)
	incq %r15
	movsbl (%r14),%r13d
	leaq 1(%r14),%r12
	cmpl $94,%r13d
	setz %al
	movzbl %al,%eax
	testb %al,%al
	movl %eax,-44(%rbp) # spill
	jz L621
L619:
	movsbl 1(%r14),%r13d
	addq $2,%r14
	movq %r14,%r12
L621:
	movq %r12,-56(%rbp) # spill
L622:
	testl %r13d,%r13d
	jnz L627
L625:
	movl $_CGMSG,%edi
	call _die
L627:
	cmpl $91,%r13d
	jnz L630
L631:
	cmpb $58,(%r12)
	jnz L630
L632:
	leaq 3(%r12),%r14
L635:
	movb (%r14),%al
	testb %al,%al
	jz L630
L636:
	cmpb $93,%al
	jnz L644
L646:
	cmpb $93,-1(%r14)
	jnz L644
L647:
	cmpb $58,-2(%r14)
	jz L643
L644:
	incq %r14
	jmp L635
L643:
	leaq 1(%r12),%rax
	jmp L650
L654:
	movq %rax,%rdx
	subq %r12,%rdx
	movq %rdx,%rcx
	decq %rcx
	cmpq $7,%rcx
	jae L656
L655:
	movb (%rax),%cl
	movb %cl,-18(%rdx,%rbp)
	incq %rax
L650:
	movq %r14,%rcx
	subq $2,%rcx
	cmpq %rcx,%rax
	jb L654
L656:
	subq %r12,%rax
	movb $0,-18(%rbp,%rax)
	movl $_cclasses,%r12d
	jmp L658
L661:
	leaq -17(%rbp),%rsi
	call _strcmp
	testl %eax,%eax
	jz L663
L662:
	addq $16,%r12
L658:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jnz L661
L663:
	cmpq $0,(%r12)
	jnz L667
L665:
	movl $_CCERR,%edi
	call _die
L667:
	movq 8(%r12),%rsi
L668:
	movb (%rsi),%al
	testb %al,%al
	jz L670
L669:
	leaq 1(%rsi),%rcx
	cmpb $45,1(%rsi)
	jnz L676
L674:
	cmpb $0,2(%rsi)
	jz L676
L675:
	movsbl %al,%edi
	jmp L678
L679:
	movb %dil,%cl
	andb $7,%cl
	movb $1,%dl
	shlb %cl,%dl
	movl %edi,%eax
	sarl $3,%eax
	movslq %eax,%rax
	orb %dl,(%rax,%r15)
	incl %edi
L678:
	movsbl 2(%rsi),%eax
	cmpl %eax,%edi
	jle L679
L681:
	addq $3,%rsi
	jmp L668
L676:
	movsbl %al,%eax
	movq %rcx,%rsi
	movb %al,%cl
	andb $7,%cl
	movb $1,%dl
	shlb %cl,%dl
	sarl $3,%eax
	movslq %eax,%rax
	orb %dl,(%rax,%r15)
	jmp L668
L670:
	movq %r14,%r12
	xorl %r13d,%r13d
	jmp L685
L630:
	cmpl $45,%r13d
	jnz L685
L690:
	cmpq -56(%rbp),%r12 # spill
	jbe L685
L691:
	cmpb $93,(%r12)
	jz L685
L687:
	movsbl -2(%r12),%r13d
	jmp L694
L695:
	movb %r13b,%cl
	andb $7,%cl
	movb $1,%dl
	shlb %cl,%dl
	movl %r13d,%eax
	sarl $3,%eax
	movslq %eax,%rax
	orb %dl,(%rax,%r15)
	incl %r13d
L694:
	movsbl (%r12),%eax
	cmpl %eax,%r13d
	jl L695
L685:
	cmpl $92,%r13d
	jnz L700
L698:
	movsbl (%r12),%r13d
	incq %r12
	cmpl $110,%r13d
	jnz L702
L701:
	movl $10,%r13d
	jmp L710
L702:
	cmpl $116,%r13d
	jnz L705
L704:
	movl $9,%r13d
	jmp L710
L705:
	cmpl $114,%r13d
	jz L707
L700:
	testl %r13d,%r13d
	jnz L710
	jz L712
L707:
	movl $13,%r13d
L710:
	movb %r13b,%cl
	andb $7,%cl
	movb $1,%al
	shlb %cl,%al
	movzbl %r13b,%r13d
	sarl $3,%r13d
	orb %al,(%r13,%r15)
L712:
	movsbl (%r12),%r13d
	incq %r12
	cmpl $93,%r13d
	jnz L622
L623:
	cmpb $0,-44(%rbp) # spill
	jz L715
L713:
	xorl %eax,%eax
L717:
	xorb $-1,(%rax,%r15)
	incl %eax
	cmpl $32,%eax
	jl L717
L715:
	andb $-2,(%r15)
	addq $32,%r15
	jmp L512
L601:
	movb $4,(%r15)
	jmp L734
L603:
	testq %rsi,%rsi
	jz L531
L606:
	orb $1,(%rsi)
	jmp L721
L609:
	movb -33(%rbp),%al # spill
	cmpb (%r14),%al
	jnz L531
L612:
	movb $10,(%r15)
L734:
	incq %r15
	jmp L512
L534:
	movsbl (%r14),%edx
	incq %r14
	movq %r14,%r12
	cmpl $40,%edx
	jnz L536
L535:
	movl _bcount(%rip),%ecx
	cmpl $9,%ecx
	jge L736
L540:
	movq -64(%rbp),%rax # spill
	movb %cl,(%rax)
	incq %rax
	movq %rax,-64(%rbp) # spill
	movb $12,(%r15)
	movl _bcount(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_bcount(%rip)
	movb %cl,1(%r15)
	addq $2,%r15
	xorl %ebx,%ebx
	jmp L512
L536:
	cmpl $41,%edx
	jnz L544
L543:
	leaq -9(%rbp),%rax
	cmpq %rax,-64(%rbp) # spill
	jbe L736
L548:
	movb $14,(%r15)
	movq -64(%rbp),%rax # spill
	leaq -1(%rax),%rcx
	movb -1(%rax),%al
	movq %rcx,-64(%rbp) # spill
	movb %al,1(%r15)
	addq $2,%r15
	incl -40(%rbp) # spill
	movq %r15,%rbx
	decq %rbx
L550:
	cmpb $12,(%rbx)
	jz L512
L551:
	decq %rbx
	jmp L550
L544:
	cmpl $49,%edx
	jl L560
L562:
	cmpl $57,%edx
	jg L560
L563:
	cmpl %edx,%ecx
	jz L560
L559:
	subl $49,%edx
	cmpl %edx,-40(%rbp) # spill
	jle L722
L568:
	movb $16,(%r15)
	jmp L733
L560:
	cmpl $10,%edx
	jz L736
L572:
	cmpl $110,%edx
	jnz L576
L575:
	movl $10,%edx
	jmp L531
L576:
	cmpl $116,%edx
	jnz L579
L578:
	movl $9,%edx
	jmp L531
L579:
	cmpl $114,%edx
	jnz L582
L581:
	movl $13,%edx
	jmp L531
L582:
	cmpl $43,%edx
	jnz L531
L584:
	testq %rsi,%rsi
	jz L531
L589:
	movq %r15,%rcx
	movb (%rsi),%al
	incq %rsi
	orb $1,%al
	jmp L737
L593:
	movb (%rsi),%al
	incq %rsi
L737:
	movb %al,(%r15)
	incq %r15
	cmpq %rcx,%rsi
	jb L593
L721:
	movq %rsi,%rbx
	jmp L512
L736:
	movq %r14,_cp(%rip)
	jmp L722
L531:
	movb $2,(%r15)
L733:
	movb %dl,1(%r15)
	addq $2,%r15
	jmp L512
L523:
	movq %r14,_cp(%rip)
	leaq -9(%rbp),%rax
	cmpq %rax,-64(%rbp) # spill
	jnz L722
L528:
	movb $22,(%r15)
	incq %r15
	jmp L504
L519:
	movq %r12,_cp(%rip)
L722:
	movq $-1,%r15
	jmp L504
L505:
	movq -32(%rbp),%r15 # spill
L504:
	movq %r15,%rax
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.local L744
.comm L744, 8, 8

_cmdline:
L738:
	pushq %rbx
	pushq %r12
L739:
	leaq -1(%rdi),%rbx
	cmpw $0,_eflag(%rip)
	jg L745
	jl L747
L787:
	movq _cmdf(%rip),%rcx
	decl (%rcx)
	movq _cmdf(%rip),%rdi
	js L791
L790:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%eax
	jmp L792
L791:
	call ___fillbuf
L792:
	leaq 1(%rbx),%r12
	cmpl $-1,%eax
	jz L789
L788:
	movb %al,1(%rbx)
	movq %r12,%rbx
	cmpb $92,%al
	jnz L794
L793:
	movq _cmdf(%rip),%rcx
	decl (%rcx)
	movq _cmdf(%rip),%rdi
	js L797
L796:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%eax
	jmp L798
L797:
	call ___fillbuf
L798:
	leaq 1(%r12),%rbx
	movb %al,1(%r12)
	jmp L787
L794:
	cmpb $10,%al
	jnz L787
L799:
	movb $0,(%r12)
	jmp L806
L789:
	movb $0,1(%rbx)
	jmp L804
L747:
	movq L744(%rip),%rdx
	testq %rdx,%rdx
	jz L804
L771:
	movb (%rdx),%al
	incq %rdx
	leaq 1(%rbx),%rcx
	movb %al,1(%rbx)
	movq %rcx,%rbx
	testb %al,%al
	jz L807
L772:
	cmpb $92,%al
	jnz L775
L774:
	movb (%rdx),%al
	incq %rdx
	leaq 1(%rcx),%rbx
	movb %al,1(%rcx)
	cmpb $48,%al
	jnz L771
	jz L805
L775:
	cmpb $10,%al
	jnz L771
	jz L808
L745:
	movw $-1,_eflag(%rip)
	movl _eargc(%rip),%ecx
	leal -1(%rcx),%eax
	movl %eax,_eargc(%rip)
	cmpl $0,%ecx
	jg L750
L748:
	movl $2,%edi
	call _exit
L750:
	movq _eargv(%rip),%rax
	leaq 8(%rax),%rcx
	movq %rcx,_eargv(%rip)
	movq 8(%rax),%rdx
L751:
	movb (%rdx),%al
	incq %rdx
	leaq 1(%rbx),%rcx
	movb %al,1(%rbx)
	movq %rcx,%rbx
	testb %al,%al
	jz L807
L752:
	cmpb $92,%al
	jnz L755
L754:
	movb (%rdx),%al
	incq %rdx
	leaq 1(%rcx),%rbx
	movb %al,1(%rcx)
	cmpb $48,%al
	jnz L751
L805:
	movq $0,L744(%rip)
L804:
	movl $-1,%eax
	jmp L740
L755:
	cmpb $10,%al
	jnz L751
L808:
	movb $0,(%rcx)
	movq %rdx,L744(%rip)
	jmp L806
L807:
	movq $0,L744(%rip)
L806:
	movl $1,%eax
L740:
	popq %r12
	popq %rbx
	ret 

.data
.align 4
L812:
	.int 0
.text

_address:
L809:
	pushq %rbx
	pushq %r12
L810:
	movq _cp(%rip),%rbx
	movb (%rbx),%al
	movq %rdi,%r12
	cmpb $36,%al
	jz L813
L815:
	cmpb $47,%al
	jz L817
L819:
	xorl %edx,%edx
	jmp L821
L824:
	cmpb $57,%al
	jg L826
L825:
	leaq (%rdx,%rdx,4),%rdx
	addq %rdx,%rdx
	movsbq %al,%rax
	incq %rbx
	addq %rax,%rdx
	subq $48,%rdx
L821:
	movb (%rbx),%al
	cmpb $48,%al
	jge L824
L826:
	cmpq %rbx,_cp(%rip)
	jb L828
L830:
	xorl %eax,%eax
	jmp L811
L828:
	movb $18,(%r12)
	movb L812(%rip),%al
	movb %al,1(%r12)
	movl L812(%rip),%eax
	leal 1(%rax),%ecx
	movl %ecx,L812(%rip)
	movslq %eax,%rax
	movq %rdx,_linenum(,%rax,8)
	cmpl $256,L812(%rip)
	jl L833
L831:
	movl $_TMLNR,%edi
	call _die
L833:
	movb $22,2(%r12)
	leaq 3(%r12),%rax
	movq %rbx,_cp(%rip)
	jmp L811
L817:
	leaq 1(%rbx),%rax
	movq %rax,_cp(%rip)
	movb (%rbx),%sil
	movq %r12,%rdi
	call _recomp
	jmp L811
L813:
	movb $20,(%r12)
	movb $22,1(%r12)
	leaq 2(%r12),%rax
	incq _cp(%rip)
	movw $1,_last_line_used(%rip)
L811:
	popq %r12
	popq %rbx
	ret 


_gettext:
L836:
L837:
	movq %rdi,%rax
	movq _cp(%rip),%rdx
L839:
	movb (%rdx),%cl
	cmpb $32,%cl
	jz L840
L842:
	cmpb $9,%cl
	jnz L846
L840:
	incq %rdx
	jmp L839
L846:
	movb (%rdx),%cl
	movb %cl,(%rax)
	incq %rdx
	cmpb $92,%cl
	jnz L851
L849:
	movb (%rdx),%cl
	movb %cl,(%rax)
	incq %rdx
L851:
	movb (%rax),%cl
	testb %cl,%cl
	jz L852
L853:
	cmpb $10,%cl
	jnz L854
L859:
	movb (%rdx),%cl
	cmpb $32,%cl
	jz L860
L862:
	cmpb $9,%cl
	jnz L854
L860:
	incq %rdx
	jmp L859
L854:
	movq %rax,%rcx
	incq %rax
	testq %rcx,%rcx
	jnz L846
	ret
L852:
	decq %rdx
	movq %rdx,_cp(%rip)
	incq %rax
L838:
	ret 


_search:
L867:
	pushq %rbx
	pushq %r12
L868:
	movq %rdi,%r12
	movq _lablst(%rip),%rbx
L870:
	cmpq %rbx,%r12
	jbe L873
L871:
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L876
L877:
	movq (%r12),%rsi
	call _strcmp
	testl %eax,%eax
	jz L874
L876:
	addq $24,%rbx
	jmp L870
L874:
	movq %rbx,%rax
	jmp L869
L873:
	xorl %eax,%eax
L869:
	popq %r12
	popq %rbx
	ret 


_resolve:
L883:
	pushq %rbx
L884:
	movq _lablst(%rip),%rbx
	jmp L886
L887:
	cmpq $0,16(%rbx)
	jnz L891
L890:
	pushq (%rbx)
	pushq $_ULABL
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $2,%edi
	call _exit
	jmp L892
L891:
	movq 8(%rbx),%rdx
	testq %rdx,%rdx
	jz L892
L896:
	movq 16(%rdx),%rcx
	movq 16(%rbx),%rax
	testq %rcx,%rcx
	jz L898
L897:
	movq %rax,16(%rdx)
	movq %rcx,%rdx
	jmp L896
L898:
	movq %rax,16(%rdx)
L892:
	addq $24,%rbx
L886:
	cmpq _lab(%rip),%rbx
	jb L887
L885:
	popq %rbx
	ret 


_ycomp:
L899:
L900:
	movq _cp(%rip),%r8
	movq %r8,%rdx
	jmp L902
L903:
	cmpb $92,%al
	jnz L908
L906:
	incq %r8
L908:
	movb (%r8),%al
	cmpb $10,%al
	jz L954
L912:
	testb %al,%al
	jz L954
L911:
	incq %r8
L902:
	movb (%r8),%al
	cmpb %al,%sil
	jnz L903
L905:
	incq %r8
L917:
	movb (%rdx),%al
	incq %rdx
	andb $127,%al
	movzbl %al,%eax
	movsbl %sil,%ecx
	cmpl %ecx,%eax
	jz L919
L918:
	cmpl $92,%eax
	jnz L922
L923:
	cmpb $110,(%rdx)
	jnz L922
L920:
	incq %rdx
	movl $10,%eax
L922:
	movb (%r8),%cl
	incq %r8
	movb %cl,(%rax,%rdi)
	cmpb $92,%cl
	jnz L929
L930:
	cmpb $110,(%r8)
	jnz L929
L927:
	movb $10,(%rax,%rdi)
	incq %r8
L929:
	movb (%rax,%rdi),%al
	cmpb %al,%sil
	jz L954
L937:
	testb %al,%al
	jnz L917
	jz L954
L919:
	cmpb (%r8),%sil
	jz L944
L954:
	movq $-1,%rax
	ret
L944:
	incq %r8
	movq %r8,_cp(%rip)
	xorl %eax,%eax
L947:
	cmpb $0,(%rax,%rdi)
	jnz L952
L950:
	movb %al,(%rax,%rdi)
L952:
	incl %eax
	cmpl $128,%eax
	jl L947
L949:
	leaq 128(%rdi),%rax
L901:
	ret 

L4:
	.byte 115,101,100,58,32,0
L11:
	.byte 32,12,10,13,9,11,0
L7:
	.byte 97,45,122,65,45,90,48,45
	.byte 57,0
L19:
	.byte 32,9,0
L24:
	.byte 112,114,105,110,116,0
L17:
	.byte 65,45,90,0
L27:
	.byte 33,45,126,0
L14:
	.byte 100,105,103,105,116,0
L16:
	.byte 117,112,112,101,114,0
L13:
	.byte 97,45,122,65,45,90,0
L22:
	.byte 99,110,116,114,108,0
L25:
	.byte 32,45,126,0
L5:
	.byte 10,0
L12:
	.byte 97,108,112,104,97,0
L15:
	.byte 48,45,57,0
L18:
	.byte 98,108,97,110,107,0
L28:
	.byte 112,117,110,99,116,0
L6:
	.byte 97,108,110,117,109,0
L23:
	.byte 1,45,31,126,0
L29:
	.byte 33,45,47,58,45,64,91,45
	.byte 96,123,45,126,0
L257:
	.byte 47,100,101,118,47,115,116,100
	.byte 111,117,116,0
L57:
	.byte 114,0
L426:
	.byte 119,0
L258:
	.byte 47,100,101,118,47,115,116,100
	.byte 101,114,114,0
L26:
	.byte 103,114,97,112,104,0
L20:
	.byte 120,100,105,103,105,116,0
L8:
	.byte 108,111,119,101,114,0
L21:
	.byte 48,45,57,65,45,70,97,45
	.byte 102,0
L10:
	.byte 115,112,97,99,101,0
L9:
	.byte 97,45,122,0
.globl _linebuf
.comm _linebuf, 4001, 1
.globl _cmds
.comm _cmds, 11256, 8
.globl _linenum
.comm _linenum, 2048, 8
.globl _nflag
.comm _nflag, 2, 2
.globl _eargc
.comm _eargc, 4, 4
.local _labels
.comm _labels, 1200, 8
.local _pool
.comm _pool, 10000, 1
.local _cp
.comm _cp, 8, 8
.local _eargv
.comm _eargv, 8, 8
.local _eflag
.comm _eflag, 2, 2
.local _gflag
.comm _gflag, 2, 2

.globl _nflag
.globl _execute
.globl ___fillbuf
.globl _linebuf
.globl _fopen
.globl ___stdout
.globl _last_line_used
.globl _die
.globl _eargc
.globl _atoi
.globl _cmds
.globl _strcmp
.globl ___ctype
.globl _pending
.globl ___stderr
.globl _linenum
.globl _fclose
.globl _main
.globl _exit
.globl _fprintf
