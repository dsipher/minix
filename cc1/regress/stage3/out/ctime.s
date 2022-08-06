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
	jz L17
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
	jz L17
L12:
	movl $4,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jz L9
L17:
	xorl %eax,%eax
	ret
L9:
	movl $1,%eax
L3:
	ret 


_nthday:
L18:
L19:
	movsbl (%rdi),%edx
	movsbl 1(%rdi),%eax
	testl %edx,%edx
	jz L20
L23:
	movl _tm+12(%rip),%ecx
	subl _tm+24(%rip),%ecx
	addl %ecx,%eax
	cmpl $0,%edx
	jle L34
L28:
	cmpl $0,%eax
	jg L29
L31:
	addl $7,%eax
	decl %edx
	cmpl $0,%edx
	jg L31
	ret
L29:
	subl $7,%eax
	jmp L28
L34:
	movslq _tm+16(%rip),%rcx
	movsbl _dpm(%rcx),%ecx
	cmpl %ecx,%eax
	jl L35
L37:
	subl $7,%eax
	incl %edx
	js L37
L20:
	ret 
L35:
	addl $7,%eax
	jmp L34


_isdaylight:
L41:
L42:
	movq _tzname+8(%rip),%rax
	cmpb $0,(%rax)
	jz L89
L46:
	movl _tm+16(%rip),%edx
	movsbl _dsttimes+2(%rip),%ecx
	movsbl _dsttimes+5(%rip),%eax
	cmpl %eax,%ecx
	jg L51
L55:
	cmpl %ecx,%edx
	jl L89
L59:
	cmpl %eax,%edx
	jg L89
L51:
	cmpl %eax,%ecx
	jle L49
L63:
	cmpl %ecx,%edx
	jge L49
L67:
	cmpl %eax,%edx
	jle L49
L89:
	xorl %eax,%eax
	ret
L49:
	cmpl %ecx,%edx
	jnz L73
L72:
	movl $_dsttimes,%edi
	call _nthday
	cmpl _tm+12(%rip),%eax
	jnz L91
L77:
	movsbl _dsthour(%rip),%eax
	cmpl %eax,_tm+8(%rip)
	setge %al
	jmp L90
L73:
	cmpl %eax,%edx
	jnz L81
L80:
	movl $_dsttimes+3,%edi
	call _nthday
	cmpl _tm+12(%rip),%eax
	jnz L83
L85:
	movsbl _dsthour(%rip),%eax
	decl %eax
	cmpl %eax,_tm+8(%rip)
L91:
	setl %al
	jmp L90
L83:
	setg %al
L90:
	movzbl %al,%eax
	ret
L81:
	movl $1,%eax
L43:
	ret 


_setdst:
L92:
	pushq %rbx
L93:
	movq %rdi,%rbx
	cmpb $0,(%rbx)
	jz L97
L95:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes(%rip)
L98:
	movb (%rbx),%al
	testb %al,%al
	jz L100
L101:
	incq %rbx
	cmpb $46,%al
	jnz L98
L100:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+1(%rip)
L105:
	movb (%rbx),%al
	testb %al,%al
	jz L107
L108:
	incq %rbx
	cmpb $46,%al
	jnz L105
L107:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+2(%rip)
L112:
	movb (%rbx),%al
	testb %al,%al
	jz L97
L115:
	incq %rbx
	cmpb $58,%al
	jnz L112
L97:
	cmpb $0,(%rbx)
	jz L121
L119:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes+3(%rip)
L122:
	movb (%rbx),%al
	testb %al,%al
	jz L124
L125:
	incq %rbx
	cmpb $46,%al
	jnz L122
L124:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+4(%rip)
L129:
	movb (%rbx),%al
	testb %al,%al
	jz L131
L132:
	incq %rbx
	cmpb $46,%al
	jnz L129
L131:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+5(%rip)
L136:
	movb (%rbx),%al
	testb %al,%al
	jz L121
L139:
	incq %rbx
	cmpb $58,%al
	jnz L136
L121:
	cmpb $0,(%rbx)
	jz L145
L143:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsthour(%rip)
L146:
	movb (%rbx),%al
	testb %al,%al
	jz L145
L149:
	incq %rbx
	cmpb $58,%al
	jnz L146
L145:
	cmpb $0,(%rbx)
	jz L94
L153:
	movq %rbx,%rdi
	call _atoi
	imull $60,%eax,%eax
	movl %eax,_dstadjust(%rip)
L94:
	popq %rbx
	ret 

.data
.align 4
L159:
	.int 0
.text

_tzset:
L156:
	pushq %rbx
L157:
	cmpl $0,L159(%rip)
	jnz L158
L162:
	movl $1,L159(%rip)
	movl $L167,%edi
	call _getenv
	movq %rax,%rbx
	testq %rax,%rax
	jz L158
L166:
	movq $0,_timezone(%rip)
	movq _tzname(%rip),%rdx
L169:
	movb (%rbx),%cl
	testb %cl,%cl
	jz L174
L176:
	cmpb $58,%cl
	jz L174
L177:
	movq _tzname(%rip),%rax
	addq $31,%rax
	cmpq %rax,%rdx
	jae L174
L173:
	incq %rbx
	movb %cl,(%rdx)
	incq %rdx
	jmp L169
L174:
	movb $0,(%rdx)
L180:
	movb (%rbx),%al
	testb %al,%al
	jz L185
L183:
	incq %rbx
	cmpb $58,%al
	jnz L180
L185:
	movq %rbx,%rdi
	call _atoi
	movslq %eax,%rax
	imulq $60,%rax,%rax
	movq %rax,_timezone(%rip)
L187:
	movb (%rbx),%al
	testb %al,%al
	jz L192
L190:
	incq %rbx
	cmpb $58,%al
	jnz L187
L192:
	movq _tzname+8(%rip),%rdx
L194:
	movb (%rbx),%cl
	testb %cl,%cl
	jz L199
L201:
	cmpb $58,%cl
	jz L199
L202:
	movq _tzname+8(%rip),%rax
	addq $31,%rax
	cmpq %rax,%rdx
	jae L199
L198:
	incq %rbx
	movb %cl,(%rdx)
	incq %rdx
	jmp L194
L199:
	movb $0,(%rdx)
L205:
	movb (%rbx),%al
	testb %al,%al
	jz L210
L208:
	incq %rbx
	cmpb $58,%al
	jnz L205
L210:
	movq _tzname+8(%rip),%rax
	cmpb $0,(%rax)
	jz L158
L214:
	movl $_tzdstdef,%edi
	call _setdst
	movq %rbx,%rdi
	call _setdst
L158:
	popq %rbx
	ret 


_gmtime:
L216:
	pushq %rbx
	pushq %r12
	pushq %r13
L217:
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
L222:
	movl %r12d,%edi
	call _isleap
	testl %eax,%eax
	movl $365,%eax
	movl $366,%ecx
	cmovzl %eax,%ecx
	cmpl %ecx,%ebx
	jb L229
L231:
	incl %r12d
	subl %ecx,%ebx
	jmp L222
L229:
	movl %r12d,%eax
	subl $1900,%eax
	movl %eax,_tm+20(%rip)
	movl %ebx,_tm+28(%rip)
	movl %r13d,_tm+24(%rip)
	movl %r12d,%edi
	call _isleap
	testl %eax,%eax
	jz L234
L233:
	movb $29,_dpm+1(%rip)
	jmp L235
L234:
	movb $28,_dpm+1(%rip)
L235:
	movl $_dpm,%eax
L236:
	cmpq $_dpm+12,%rax
	jae L239
L240:
	movsbl (%rax),%ecx
	cmpl %ecx,%ebx
	jb L239
L237:
	subl %ecx,%ebx
	incq %rax
	jmp L236
L239:
	subq $_dpm,%rax
	movl %eax,_tm+16(%rip)
	incl %ebx
	movl %ebx,_tm+12(%rip)
	movl $_tm,%eax
L218:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_localtime:
L245:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L246:
	movq %rdi,%rbx
	call _tzset
	movq (%rbx),%rax
	subq _timezone(%rip),%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _gmtime
	call _isdaylight
	testl %eax,%eax
	jz L249
L248:
	movslq _dstadjust(%rip),%rax
	movq (%rbx),%rcx
	subq _timezone(%rip),%rcx
	addq %rcx,%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _gmtime
	movl $1,_tm+32(%rip)
	jmp L250
L249:
	movl $0,_tm+32(%rip)
L250:
	movl $_tm,%eax
L247:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_asctime:
L252:
L253:
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
	jb L262
L261:
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addb $48,%al
	movb %al,_timestr+8(%rip)
	jmp L263
L262:
	movb $32,_timestr+8(%rip)
L263:
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
L254:
	ret 


_ctime:
L265:
L266:
	call _localtime
	movq %rax,%rdi
	call _asctime
L267:
	ret 

L167:
 .byte 84,73,77,69,90,79,78,69
 .byte 0
.globl _timezone
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
