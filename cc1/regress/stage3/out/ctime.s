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
	movsbl (%rdi),%ecx
	movsbl 1(%rdi),%eax
	testl %ecx,%ecx
	jz L19
L22:
	movl _tm+12(%rip),%edx
	subl _tm+24(%rip),%edx
	addl %edx,%eax
	cmpl $0,%ecx
	jg L27
L33:
	movslq _tm+16(%rip),%rdx
	movsbl _dpm(%rdx),%edx
	cmpl %edx,%eax
	jl L34
L36:
	subl $7,%eax
	incl %ecx
	js L36
	ret
L34:
	addl $7,%eax
	jmp L33
L27:
	cmpl $0,%eax
	jle L30
L28:
	subl $7,%eax
	cmpl $0,%eax
	jg L28
L30:
	addl $7,%eax
	decl %ecx
	cmpl $0,%ecx
	jg L30
L19:
	ret 


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
	jnz L75
L77:
	movsbl _dsthour(%rip),%eax
	cmpl %eax,_tm+8(%rip)
	setge %al
	movzbl %al,%eax
	ret
L75:
	setl %al
	movzbl %al,%eax
	ret
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
	setl %al
	movzbl %al,%eax
	ret
L83:
	setg %al
	movzbl %al,%eax
	ret
L81:
	movl $1,%eax
L43:
	ret 


_setdst:
L90:
	pushq %rbx
L91:
	movq %rdi,%rbx
	cmpb $0,(%rbx)
	jz L95
L93:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes(%rip)
L96:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L98
L99:
	incq %rbx
	cmpb $46,%al
	jnz L96
L98:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+1(%rip)
L103:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L105
L106:
	incq %rbx
	cmpb $46,%al
	jnz L103
L105:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+2(%rip)
L110:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L95
L113:
	incq %rbx
	cmpb $58,%al
	jnz L110
L95:
	cmpb $0,(%rbx)
	jz L119
L117:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes+3(%rip)
L120:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L122
L123:
	incq %rbx
	cmpb $46,%al
	jnz L120
L122:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+4(%rip)
L127:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L129
L130:
	incq %rbx
	cmpb $46,%al
	jnz L127
L129:
	movq %rbx,%rdi
	call _atoi
	decb %al
	movb %al,_dsttimes+5(%rip)
L134:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L119
L137:
	incq %rbx
	cmpb $58,%al
	jnz L134
L119:
	cmpb $0,(%rbx)
	jz L143
L141:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsthour(%rip)
L144:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L143
L147:
	incq %rbx
	cmpb $58,%al
	jnz L144
L143:
	cmpb $0,(%rbx)
	jz L92
L151:
	movq %rbx,%rdi
	call _atoi
	imull $60,%eax,%eax
	movl %eax,_dstadjust(%rip)
L92:
	popq %rbx
	ret 

.data
.align 4
L157:
	.int 0
.text

_tzset:
L154:
	pushq %rbx
L155:
	cmpl $0,L157(%rip)
	jnz L156
L160:
	movl $1,L157(%rip)
	movl $L165,%edi
	call _getenv
	movq %rax,%rbx
	testq %rax,%rax
	jz L156
L164:
	movq $0,_timezone(%rip)
	movq _tzname(%rip),%rdx
L167:
	movzbl (%rbx),%ecx
	testb %cl,%cl
	jz L172
L174:
	cmpb $58,%cl
	jz L172
L175:
	movq _tzname(%rip),%rax
	addq $31,%rax
	cmpq %rax,%rdx
	jae L172
L171:
	incq %rbx
	movb %cl,(%rdx)
	incq %rdx
	jmp L167
L172:
	movb $0,(%rdx)
L178:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L183
L181:
	incq %rbx
	cmpb $58,%al
	jnz L178
L183:
	movq %rbx,%rdi
	call _atoi
	movslq %eax,%rax
	imulq $60,%rax,%rax
	movq %rax,_timezone(%rip)
L185:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L190
L188:
	incq %rbx
	cmpb $58,%al
	jnz L185
L190:
	movq _tzname+8(%rip),%rdx
L192:
	movzbl (%rbx),%ecx
	testb %cl,%cl
	jz L197
L199:
	cmpb $58,%cl
	jz L197
L200:
	movq _tzname+8(%rip),%rax
	addq $31,%rax
	cmpq %rax,%rdx
	jae L197
L196:
	incq %rbx
	movb %cl,(%rdx)
	incq %rdx
	jmp L192
L197:
	movb $0,(%rdx)
L203:
	movzbl (%rbx),%eax
	testb %al,%al
	jz L208
L206:
	incq %rbx
	cmpb $58,%al
	jnz L203
L208:
	movq _tzname+8(%rip),%rax
	cmpb $0,(%rax)
	jz L156
L212:
	movl $_tzdstdef,%edi
	call _setdst
	movq %rbx,%rdi
	call _setdst
L156:
	popq %rbx
	ret 


_gmtime:
L214:
	pushq %rbx
	pushq %r12
	pushq %r13
L215:
	movq (%rdi),%rsi
	cmpq $0,%rsi
	movl $0,%eax
	cmovlq %rax,%rsi
	movl $86400,%ecx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	movl %eax,%r13d
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
	leal 4(%r13),%eax
	xorl %edx,%edx
	divl %ecx
	movl %edx,%r12d
	movl $1970,%ebx
L220:
	movl %ebx,%edi
	call _isleap
	testl %eax,%eax
	movl $365,%eax
	movl $366,%ecx
	cmovzl %eax,%ecx
	cmpl %ecx,%r13d
	jb L227
L229:
	incl %ebx
	subl %ecx,%r13d
	jmp L220
L227:
	movl %ebx,%eax
	subl $1900,%eax
	movl %eax,_tm+20(%rip)
	movl %r13d,_tm+28(%rip)
	movl %r12d,_tm+24(%rip)
	movl %ebx,%edi
	call _isleap
	testl %eax,%eax
	jz L232
L231:
	movb $29,_dpm+1(%rip)
	jmp L233
L232:
	movb $28,_dpm+1(%rip)
L233:
	movl $_dpm,%eax
L234:
	cmpq $_dpm+12,%rax
	jae L237
L238:
	movsbl (%rax),%ecx
	cmpl %ecx,%r13d
	jb L237
L235:
	subl %ecx,%r13d
	incq %rax
	cmpq $_dpm+12,%rax
	jb L238
L237:
	subq $_dpm,%rax
	movl %eax,_tm+16(%rip)
	incl %r13d
	movl %r13d,_tm+12(%rip)
	movl $_tm,%eax
L216:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_localtime:
L244:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L245:
	movq %rdi,%rbx
	call _tzset
	movq (%rbx),%rax
	subq _timezone(%rip),%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _gmtime
	call _isdaylight
	testl %eax,%eax
	jz L248
L247:
	movslq _dstadjust(%rip),%rax
	movq (%rbx),%rcx
	subq _timezone(%rip),%rcx
	addq %rcx,%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rdi
	call _gmtime
	movl $1,_tm+32(%rip)
	jmp L249
L248:
	movl $0,_tm+32(%rip)
L249:
	movl $_tm,%eax
L246:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_asctime:
L251:
L252:
	movl 24(%rdi),%ecx
	cmpl $7,%ecx
	movl $0,%eax
	cmovael %eax,%ecx
	leal (%rcx,%rcx,2),%ecx
	movzbl _daynames(%rcx),%eax
	movb %al,_timestr(%rip)
	movzbl _daynames+1(%rcx),%eax
	movb %al,_timestr+1(%rip)
	movzbl _daynames+2(%rcx),%eax
	movb %al,_timestr+2(%rip)
	movb $32,_timestr+3(%rip)
	movl 16(%rdi),%ecx
	cmpl $12,%ecx
	movl $0,%eax
	cmovael %eax,%ecx
	leal (%rcx,%rcx,2),%ecx
	movzbl _months(%rcx),%eax
	movb %al,_timestr+4(%rip)
	movzbl _months+1(%rcx),%eax
	movb %al,_timestr+5(%rip)
	movzbl _months+2(%rcx),%eax
	movb %al,_timestr+6(%rip)
	movb $32,_timestr+7(%rip)
	movl 12(%rdi),%esi
	cmpl $10,%esi
	jb L261
L260:
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+8(%rip)
	jmp L262
L261:
	movb $32,_timestr+8(%rip)
L262:
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%edx
	movb %dl,_timestr+9(%rip)
	movb $32,_timestr+10(%rip)
	movl 8(%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+11(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%edx
	movb %dl,_timestr+12(%rip)
	movb $58,_timestr+13(%rip)
	movl 4(%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+14(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%edx
	movb %dl,_timestr+15(%rip)
	movb $58,_timestr+16(%rip)
	movl (%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+17(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%edx
	movb %dl,_timestr+18(%rip)
	movb $32,_timestr+19(%rip)
	movl 20(%rdi),%esi
	movl $1000,%ecx
	leal 1900(%rsi),%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
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
	addl $48,%eax
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
	addl $48,%eax
	movb %al,_timestr+22(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%edx
	movb %dl,_timestr+23(%rip)
	movb $10,_timestr+24(%rip)
	movb $0,_timestr+25(%rip)
	movl $_timestr,%eax
L253:
	ret 


_ctime:
L264:
L265:
	call _localtime
	movq %rax,%rdi
	call _asctime
L266:
	ret 

L165:
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
