.data
.align 4
L4:
	.int 0
.text
.align 4
L155:
	.int 34
	.int 36
	.int 60
	.int 62
	.int 63
	.int 91
	.int 92
	.int 93
	.int 94
	.int 123
	.int 124
	.int 125
.align 2
L156:
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
.align 2
L157:
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
	.short L107-_yylex
.align 4
L161:
	.int 0
	.int 10
	.int 34
	.int 36
	.int 60
	.int 62
	.int 63
	.int 91
	.int 92
	.int 93
	.int 94
	.int 123
	.int 124
	.int 125
.align 2
L162:
	.short L132-_yylex
	.short L56-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
.align 2
L163:
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
	.short L51-_yylex
.align 2
L164:
	.short L84-_yylex
	.short L123-_yylex
	.short L75-_yylex
	.short L64-_yylex
	.short L67-_yylex
	.short L70-_yylex
	.short L81-_yylex
	.short L126-_yylex
	.short L129-_yylex

_yylex:
L1:
	pushq %rbx
L2:
	cmpl $0,_eofseen(%rip)
	jnz L12
L6:
	call _flexscan
	movl %eax,%ebx
	cmpl $-1,%eax
	jz L12
L11:
	testl %eax,%eax
	jnz L10
L12:
	movl $1,_eofseen(%rip)
	movl _sectnum(%rip),%eax
	cmpl $1,%eax
	jnz L16
L15:
	movl $L18,%edi
	call _synerr
	movl $2,_sectnum(%rip)
	movl $259,%ebx
	jmp L10
L16:
	xorl %ebx,%ebx
	cmpl $2,%eax
	jnz L10
L19:
	movl $3,_sectnum(%rip)
L10:
	cmpl $0,_trace(%rip)
	jz L24
L22:
	cmpl $0,L4(%rip)
	jz L27
L25:
	movl _num_rules(%rip),%eax
	incl %eax
	pushq %rax
	pushq $L28
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $0,L4(%rip)
L27:
	cmpl $257,%ebx
	jl L145
L147:
	cmpl $265,%ebx
	jg L145
L144:
	leal -257(%rbx),%eax
	movzwl L164(,%rax,2),%eax
	addl $_yylex,%eax
	jmp *%rax
L129:
	pushq $L130
	jmp L165
L126:
	movl _yylval(%rip),%eax
	pushq %rax
	pushq $L127
	jmp L166
L81:
	pushq $_nmstr
	pushq $L82
	jmp L166
L70:
	decl ___stderr(%rip)
	js L72
L71:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $32,(%rcx)
	jmp L24
L72:
	movl $___stderr,%esi
	movl $32,%edi
	jmp L167
L67:
	movl $___stderr,%esi
	movl $L68,%edi
	jmp L168
L64:
	movl $___stderr,%esi
	movl $L65,%edi
L168:
	call _fputs
	jmp L24
L75:
	movl $___stderr,%esi
	movl $L76,%edi
	call _fputs
	cmpl $2,_sectnum(%rip)
	jnz L24
	jz L139
L123:
	movl _yylval(%rip),%eax
	pushq %rax
	pushq $L124
	jmp L166
L84:
	movl _yylval(%rip),%edi
	cmpl $40,%edi
	jl L141
L143:
	cmpl $47,%edi
	jg L141
L140:
	leal -40(%rdi),%eax
	movzwl L157(,%rax,2),%eax
	addl $_yylex,%eax
	jmp *%rax
L141:
	xorl %eax,%eax
L152:
	cmpl L155(,%rax,4),%edi
	jz L153
L154:
	incl %eax
	cmpl $12,%eax
	jb L152
	jae L85
L153:
	movzwl L156(,%rax,2),%eax
	addl $_yylex,%eax
	jmp *%rax
L107:
	pushq %rdi
	pushq $L108
	jmp L166
L85:
	cmpl $128,%edi
	jae L114
L113:
	movl %edi,%eax
	subl $32,%eax
	cmpl $95,%eax
	jb L115
L114:
	pushq %rdi
	pushq $L117
L166:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L24
L115:
	decl ___stderr(%rip)
	js L119
L118:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %dil,(%rcx)
	jmp L24
L119:
	movl $___stderr,%esi
	jmp L167
L145:
	cmpl $40,%ebx
	jl L149
L151:
	cmpl $47,%ebx
	jg L149
L148:
	leal -40(%rbx),%eax
	movzwl L163(,%rax,2),%eax
	addl $_yylex,%eax
	jmp *%rax
L149:
	xorl %eax,%eax
L158:
	cmpl L161(,%rax,4),%ebx
	jz L159
L160:
	incl %eax
	cmpl $14,%eax
	jb L158
	jae L29
L159:
	movzwl L162(,%rax,2),%eax
	addl $_yylex,%eax
	jmp *%rax
L51:
	decl ___stderr(%rip)
	js L53
L52:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %bl,(%rcx)
	jmp L24
L53:
	movl $___stderr,%esi
	movl %ebx,%edi
L167:
	call ___flushbuf
	jmp L24
L56:
	decl ___stderr(%rip)
	js L58
L57:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L59
L58:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
L59:
	cmpl $2,_sectnum(%rip)
	jnz L24
L139:
	movl $1,L4(%rip)
	jmp L24
L132:
	pushq $L133
L165:
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L24
L29:
	movl _yylval(%rip),%eax
	pushq %rax
	pushq %rbx
	pushq $L135
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L24:
	movl %ebx,%eax
L3:
	popq %rbx
	ret 

L124:
	.byte 37,100,0
L130:
	.byte 60,60,69,79,70,62,62,0
L28:
	.byte 37,100,9,0
L117:
	.byte 92,37,46,51,111,0
L133:
	.byte 69,110,100,32,77,97,114,107
	.byte 101,114,0
L127:
	.byte 91,37,100,93,0
L18:
	.byte 112,114,101,109,97,116,117,114
	.byte 101,32,69,79,70,0
L65:
	.byte 37,115,0
L76:
	.byte 37,37,10,0
L68:
	.byte 37,120,0
L108:
	.byte 92,37,99,0
L82:
	.byte 39,37,115,39,0
L135:
	.byte 42,83,111,109,101,116,104,105
	.byte 110,103,32,87,101,105,114,100
	.byte 42,32,45,32,116,111,107,58
	.byte 32,37,100,32,118,97,108,58
	.byte 32,37,100,10,0

.globl _num_rules
.globl _yylex
.globl _flexscan
.globl _synerr
.globl _eofseen
.globl _nmstr
.globl ___flushbuf
.globl _yylval
.globl ___stderr
.globl _trace
.globl _sectnum
.globl _fputs
.globl _fprintf
