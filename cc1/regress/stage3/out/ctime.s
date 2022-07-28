.data
_tzdstdef:
 .byte 49,46,49,46,52,58,45,49
 .byte 46,49,46,49,48,58,50,58
 .byte 54,48,46,46,46,46,46,46
 .byte 0
_daynames:
 .byte 83,117,110,77,111,110,84,117
 .byte 101,87,101,100,84,104,117,70
 .byte 114,105,83,97,116,0
_dpm:
	.byte 31
	.byte 28
	.byte 31
	.byte 30
	.byte 31
	.byte 30
	.byte 31
	.byte 31
	.byte 30
	.byte 31
	.byte 30
	.byte 31
.align 4
_dstadjust:
	.int 3600
_dsthour:
	.byte 2
_dsttimes:
	.byte 1
	.byte 0
	.byte 3
	.byte -1
	.byte 0
	.byte 9
_months:
 .byte 74,97,110,70,101,98,77,97
 .byte 114,65,112,114,77,97,121,74
 .byte 117,110,74,117,108,65,117,103
 .byte 83,101,112,79,99,116,78,111
 .byte 118,68,101,99,0
_timestr:
 .byte 65,65,65,32,65,65,65,32
 .byte 68,68,32,68,68,58,68,68
 .byte 58,68,68,32,68,68,68,68
 .byte 10,0
_tz0:
 .byte 71,77,84,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
_tz1:
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
.align 8
_tzname:
	.quad _tz0
	.quad _tz1
.text

_isleap:
L1:
L2:
	movl $4000,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jz L4
L6:
	movl $400,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jz L9
L8:
	movl $100,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jz L10
L12:
	movl $4,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jnz L10
L9:
	movl $1,%eax
	ret
L10:
	xorl %eax,%eax
	ret
L4:
	xorl %eax,%eax
L3:
	ret 


_nthday:
L17:
L18:
	movsbl (%rdi),%edx
	movsbl 1(%rdi),%eax
	testl %edx,%edx
	jz L19
L22:
	movl _tm+12(%rip),%ecx
	subl _tm+24(%rip),%ecx
	addl %ecx,%eax
	cmpl $0,%edx
	jle L33
L27:
	cmpl $0,%eax
	jg L28
L30:
	addl $7,%eax
	decl %edx
	cmpl $0,%edx
	jg L30
	ret
L28:
	subl $7,%eax
	jmp L27
L33:
	movslq _tm+16(%rip),%rcx
	movsbl _dpm(%rcx),%ecx
	cmpl %ecx,%eax
	jl L34
L36:
	subl $7,%eax
	incl %edx
	js L36
L19:
	ret 
L34:
	addl $7,%eax
	jmp L33


_isdaylight:
L40:
L41:
	movq _tzname+8(%rip),%rax
	cmpb $0,(%rax)
	jz L88
L45:
	movl _tm+16(%rip),%edx
	movsbl _dsttimes+2(%rip),%ecx
	movsbl _dsttimes+5(%rip),%eax
	cmpl %eax,%ecx
	jg L50
L54:
	cmpl %ecx,%edx
	jl L88
L58:
	cmpl %eax,%edx
	jg L88
L50:
	cmpl %eax,%ecx
	jle L48
L62:
	cmpl %ecx,%edx
	jge L48
L66:
	cmpl %eax,%edx
	jle L48
L88:
	xorl %eax,%eax
	ret
L48:
	cmpl %ecx,%edx
	jnz L72
L71:
	movl $_dsttimes,%edi
	call _nthday
	cmpl _tm+12(%rip),%eax
	jnz L74
L76:
	movsbl _dsthour(%rip),%eax
	cmpl %eax,_tm+8(%rip)
	setge %al
	movzbl %al,%eax
	ret
L74:
	setl %al
	movzbl %al,%eax
	ret
L72:
	cmpl %eax,%edx
	jnz L80
L79:
	movl $_dsttimes+3,%edi
	call _nthday
	cmpl _tm+12(%rip),%eax
	jnz L82
L84:
	movsbl _dsthour(%rip),%eax
	decl %eax
	cmpl %eax,_tm+8(%rip)
	setl %al
	movzbl %al,%eax
	ret
L82:
	setg %al
	movzbl %al,%eax
	ret
L80:
	movl $1,%eax
L42:
	ret 


_setdst:
L89:
	pushq %rbx
L90:
	movq %rdi,%rbx
	cmpb $0,(%rbx)
	jz L94
L92:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes(%rip)
L95:
	movb (%rbx),%al
	testb %al,%al
	jz L97
L98:
	incq %rbx
	cmpb $46,%al
	jnz L95
L97:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+1(%rip)
L102:
	movb (%rbx),%al
	testb %al,%al
	jz L104
L105:
	incq %rbx
	cmpb $46,%al
	jnz L102
L104:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+2(%rip)
L109:
	movb (%rbx),%al
	testb %al,%al
	jz L94
L112:
	incq %rbx
	cmpb $58,%al
	jnz L109
L94:
	cmpb $0,(%rbx)
	jz L118
L116:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes+3(%rip)
L119:
	movb (%rbx),%al
	testb %al,%al
	jz L121
L122:
	incq %rbx
	cmpb $46,%al
	jnz L119
L121:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+4(%rip)
L126:
	movb (%rbx),%al
	testb %al,%al
	jz L128
L129:
	incq %rbx
	cmpb $46,%al
	jnz L126
L128:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+5(%rip)
L133:
	movb (%rbx),%al
	testb %al,%al
	jz L118
L136:
	incq %rbx
	cmpb $58,%al
	jnz L133
L118:
	cmpb $0,(%rbx)
	jz L142
L140:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsthour(%rip)
L143:
	movb (%rbx),%al
	testb %al,%al
	jz L142
L146:
	incq %rbx
	cmpb $58,%al
	jnz L143
L142:
	cmpb $0,(%rbx)
	jz L91
L150:
	movq %rbx,%rdi
	call _atoi
	imull $60,%eax,%eax
	movl %eax,_dstadjust(%rip)
L91:
	popq %rbx
	ret 

.data
.align 4
L156:
	.int 0
.text

_tzset:
L153:
	pushq %rbx
L154:
	cmpl $0,L156(%rip)
	jnz L155
L159:
	movl $1,L156(%rip)
	movl $L164,%edi
	call _getenv
	movq %rax,%rbx
	testq %rax,%rax
	jz L155
L163:
	movq $0,_timezone(%rip)
	movq _tzname(%rip),%rdx
L166:
	movb (%rbx),%cl
	testb %cl,%cl
	jz L171
L173:
	cmpb $58,%cl
	jz L171
L174:
	movq _tzname(%rip),%rax
	addq $31,%rax
	cmpq %rax,%rdx
	jae L171
L170:
	incq %rbx
	movb %cl,(%rdx)
	incq %rdx
	jmp L166
L171:
	movb $0,(%rdx)
L177:
	movb (%rbx),%al
	testb %al,%al
	jz L182
L180:
	incq %rbx
	cmpb $58,%al
	jnz L177
L182:
	movq %rbx,%rdi
	call _atoi
	movslq %eax,%rax
	imulq $60,%rax,%rax
	movq %rax,_timezone(%rip)
L184:
	movb (%rbx),%al
	testb %al,%al
	jz L189
L187:
	incq %rbx
	cmpb $58,%al
	jnz L184
L189:
	movq _tzname+8(%rip),%rdx
L191:
	movb (%rbx),%cl
	testb %cl,%cl
	jz L196
L198:
	cmpb $58,%cl
	jz L196
L199:
	movq _tzname+8(%rip),%rax
	addq $31,%rax
	cmpq %rax,%rdx
	jae L196
L195:
	incq %rbx
	movb %cl,(%rdx)
	incq %rdx
	jmp L191
L196:
	movb $0,(%rdx)
L202:
	movb (%rbx),%al
	testb %al,%al
	jz L207
L205:
	incq %rbx
	cmpb $58,%al
	jnz L202
L207:
	movq _tzname+8(%rip),%rax
	cmpb $0,(%rax)
	jz L155
L211:
	movl $_tzdstdef,%edi
	call _setdst
	movq %rbx,%rdi
	call _setdst
L155:
	popq %rbx
	ret 


_gmtime:
L213:
	pushq %rbx
	pushq %r12
	pushq %r13
L214:
	movq (%rdi),%rsi
	cmpq $0,%rsi
	movl $0,%eax
	cmovlq %rax,%rsi
	movl $86400,%ecx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	movl %eax,%ebx
	movl $86400,%ecx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	movq %rdx,%rsi
	movl $3600,%ecx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	movl %eax,_tm+8(%rip)
	movl $3600,%ecx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	movq %rdx,%rsi
	movl $60,%ecx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	movl %eax,_tm+4(%rip)
	movl $60,%ecx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	movl %edx,_tm(%rip)
	movl $7,%ecx
	leal 4(%rbx),%eax
	xorl %edx,%edx
	divl %ecx
	movl %edx,%r13d
	movl $1970,%r12d
L219:
	movl %r12d,%edi
	call _isleap
	testl %eax,%eax
	movl $365,%eax
	movl $366,%ecx
	cmovzl %eax,%ecx
	cmpl %ecx,%ebx
	jb L226
L228:
	incl %r12d
	subl %ecx,%ebx
	jmp L219
L226:
	movl %r12d,%eax
	subl $1900,%eax
	movl %eax,_tm+20(%rip)
	movl %ebx,_tm+28(%rip)
	movl %r13d,_tm+24(%rip)
	movl %r12d,%edi
	call _isleap
	testl %eax,%eax
	jz L231
L230:
	movb $29,_dpm+1(%rip)
	jmp L232
L231:
	movb $28,_dpm+1(%rip)
L232:
	movl $_dpm,%eax
L233:
	cmpq $_dpm+12,%rax
	jae L236
L237:
	movsbl (%rax),%ecx
	cmpl %ecx,%ebx
	jb L236
L234:
	subl %ecx,%ebx
	incq %rax
	jmp L233
L236:
	subq $_dpm,%rax
	movl %eax,_tm+16(%rip)
	incl %ebx
	movl %ebx,_tm+12(%rip)
	movl $_tm,%eax
L215:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_localtime:
L242:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L243:
	movq %rdi,%rbx
	call _tzset
	movq (%rbx),%rax
	subq _timezone(%rip),%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _gmtime
	call _isdaylight
	testl %eax,%eax
	jz L246
L245:
	movslq _dstadjust(%rip),%rax
	movq (%rbx),%rcx
	subq _timezone(%rip),%rcx
	addq %rcx,%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _gmtime
	movl $1,_tm+32(%rip)
	jmp L247
L246:
	movl $0,_tm+32(%rip)
L247:
	movl $_tm,%eax
L244:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_asctime:
L249:
L250:
	movl 24(%rdi),%ecx
	cmpl $7,%ecx
	movl $0,%eax
	cmovael %eax,%ecx
	leal (%rcx,%rcx,2),%ecx
	movb _daynames(%rcx),%al
	movb %al,_timestr(%rip)
	movb _daynames+1(%rcx),%al
	movb %al,_timestr+1(%rip)
	movb _daynames+2(%rcx),%al
	movb %al,_timestr+2(%rip)
	movb $32,_timestr+3(%rip)
	movl 16(%rdi),%ecx
	cmpl $12,%ecx
	movl $0,%eax
	cmovael %eax,%ecx
	leal (%rcx,%rcx,2),%ecx
	movb _months(%rcx),%al
	movb %al,_timestr+4(%rip)
	movb _months+1(%rcx),%al
	movb %al,_timestr+5(%rip)
	movb _months+2(%rcx),%al
	movb %al,_timestr+6(%rip)
	movb $32,_timestr+7(%rip)
	movl 12(%rdi),%esi
	cmpl $10,%esi
	jb L259
L258:
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+8(%rip)
	jmp L260
L259:
	movb $32,_timestr+8(%rip)
L260:
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%dl
	movb %dl,_timestr+9(%rip)
	movb $32,_timestr+10(%rip)
	movl 8(%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+11(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%dl
	movb %dl,_timestr+12(%rip)
	movb $58,_timestr+13(%rip)
	movl 4(%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+14(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%dl
	movb %dl,_timestr+15(%rip)
	movb $58,_timestr+16(%rip)
	movl (%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+17(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%dl
	movb %dl,_timestr+18(%rip)
	movb $32,_timestr+19(%rip)
	movl 20(%rdi),%esi
	movl $1000,%ecx
	leal 1900(%rsi),%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+20(%rip)
	movl $1000,%ecx
	leal 1900(%rsi),%eax
	xorl %edx,%edx
	divl %ecx
	movl %edx,%esi
	movl $100,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+21(%rip)
	movl $100,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	movl %edx,%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+22(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%dl
	movb %dl,_timestr+23(%rip)
	movb $10,_timestr+24(%rip)
	movb $0,_timestr+25(%rip)
	movl $_timestr,%eax
L251:
	ret 


_ctime:
L262:
L263:
	call _localtime
	movq %rax,%rdi
	call _asctime
L264:
	ret 

L164:
 .byte 84,73,77,69,90,79,78,69
 .byte 0
.comm _timezone, 8, 8
.local _tm
.comm _tm, 36, 4

.globl _localtime
.globl _getenv
.globl _ctime
.globl _gmtime
.globl _tzset
.globl _asctime
.globl _atoi
.globl _tzname
.globl _timezone
