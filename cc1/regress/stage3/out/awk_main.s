.data
.align 8
_version:
	.quad L1
.align 4
_dbg:
	.int 0
.align 8
_srand_seed:
	.quad 0x3ff0000000000000
.align 4
_compile_time:
	.int 2
.align 4
_npfile:
	.int 0
.align 4
_curpfile:
	.int 0
.align 4
_safe:
	.int 0
.text
L166:
	.quad 0x3ff0000000000000

_main:
L2:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L3:
	movl %edi,%r14d
	movq %rsi,%r13
	xorl %r12d,%r12d
	movq (%r13),%rax
	movq %rax,_cmdname(%rip)
	cmpl $1,%r14d
	jnz L7
L5:
	pushq %rax
	pushq $L8
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _exit
L7:
	movl $_fpecatch,%esi
	movl $8,%edi
	call _signal
	movsd L166(%rip),%xmm0
	movsd %xmm0,_srand_seed(%rip)
	movl $1,%edi
	call _srand
	movq $0,_yyin(%rip)
	movl $1,%edi
	call _makesymtab
	movq %rax,_symtab(%rip)
L9:
	cmpl $1,%r14d
	jle L11
L16:
	leaq 8(%r13),%rbx
	movq 8(%r13),%rdi
	cmpb $45,(%rdi)
	jnz L11
L17:
	cmpb $0,1(%rdi)
	jz L11
L13:
	movl $L23,%esi
	call _strcmp
	testl %eax,%eax
	jz L26
L25:
	movl $L24,%esi
	movq 8(%r13),%rdi
	call _strcmp
	testl %eax,%eax
	jz L26
L27:
	movl $2,%edx
	movl $L34,%esi
	movq 8(%r13),%rdi
	call _strncmp
	testl %eax,%eax
	jz L31
L33:
	movq 8(%r13),%rdi
	movb 1(%rdi),%al
	cmpb $70,%al
	jz L61
L160:
	cmpb $100,%al
	jz L119
L161:
	cmpb $102,%al
	jz L45
L162:
	cmpb $115,%al
	jz L39
L163:
	cmpb $118,%al
	jz L103
L164:
	pushq %rdi
	pushq $L124
	call _WARNING
	jmp L167
L103:
	cmpb $0,2(%rdi)
	jz L105
L104:
	addq $2,%rdi
	call _isclvar
	movq 8(%r13),%rdi
	leaq 2(%rdi),%rcx
	testl %eax,%eax
	jz L108
L107:
	addq $2,%rdi
	jmp L169
L108:
	pushq %rcx
	jmp L168
L105:
	decl %r14d
	movq %rbx,%r13
	cmpl $1,%r14d
	jg L113
L111:
	pushq $L114
	call _FATAL
	addq $8,%rsp
L113:
	movq 8(%rbx),%rdi
	call _isclvar
	movq 8(%rbx),%rdi
	testl %eax,%eax
	jz L116
L169:
	call _setclvar
	jmp L37
L116:
	pushq %rdi
L168:
	pushq $L110
	call _FATAL
	jmp L167
L39:
	movl $L43,%esi
	call _strcmp
	testl %eax,%eax
	jnz L37
L40:
	movl $1,_safe(%rip)
	jmp L37
L45:
	cmpb $0,2(%rdi)
	jz L47
L46:
	cmpl $19,_npfile(%rip)
	jl L51
L49:
	pushq $L52
	call _FATAL
	addq $8,%rsp
L51:
	movq 8(%r13),%rdx
	movl _npfile(%rip),%eax
	addq $2,%rdx
	jmp L170
L47:
	decl %r14d
	movq %rbx,%r13
	cmpl $1,%r14d
	jg L55
L53:
	pushq $L56
	call _FATAL
	addq $8,%rsp
L55:
	cmpl $19,_npfile(%rip)
	jl L59
L57:
	pushq $L52
	call _FATAL
	addq $8,%rsp
L59:
	movq 8(%rbx),%rdx
	movl _npfile(%rip),%eax
L170:
	leal 1(%rax),%ecx
	movl %ecx,_npfile(%rip)
	movslq %eax,%rax
	movq %rdx,_pfile(,%rax,8)
	jmp L37
L119:
	addq $2,%rdi
	call _atoi
	movl %eax,_dbg(%rip)
	testl %eax,%eax
	jnz L122
L120:
	movl $1,_dbg(%rip)
L122:
	pushq _version(%rip)
	pushq $L29
	call _printf
L167:
	addq $16,%rsp
	jmp L37
L61:
	leaq 2(%rdi),%rcx
	movb 2(%rdi),%al
	testb %al,%al
	jz L63
L62:
	cmpb $116,%al
	jnz L70
L68:
	cmpb $0,3(%rdi)
	jz L158
L70:
	testb %al,%al
	cmovnzq %rcx,%r12
	jmp L64
L63:
	decl %r14d
	movq %rbx,%r13
	cmpl $1,%r14d
	jle L81
L83:
	movq 8(%rbx),%rax
	cmpb $116,(%rax)
	jnz L81
L84:
	cmpb $0,1(%rax)
	jnz L81
L158:
	movl $L72,%r12d
	jmp L64
L81:
	cmpl $1,%r14d
	jle L64
L90:
	movq 8(%rbx),%rax
	cmpb $0,(%rax)
	cmovnzq %rax,%r12
L64:
	testq %r12,%r12
	jz L98
L97:
	cmpb $0,(%r12)
	jnz L37
L98:
	pushq $L101
	call _WARNING
	addq $8,%rsp
L37:
	decl %r14d
	addq $8,%r13
	jmp L9
L31:
	decl %r14d
	movq %rbx,%r13
	jmp L11
L26:
	pushq _version(%rip)
	pushq $L29
	call _printf
	addq $16,%rsp
	xorl %edi,%edi
	call _exit
L11:
	cmpl $0,_npfile(%rip)
	jnz L128
L126:
	cmpl $1,%r14d
	jg L131
L129:
	cmpl $0,_dbg(%rip)
	jz L134
L132:
	xorl %edi,%edi
	call _exit
L134:
	pushq $L135
	call _FATAL
	addq $8,%rsp
L131:
	cmpl $0,_dbg(%rip)
	jz L138
L136:
	pushq 8(%r13)
	pushq $L139
	call _printf
	addq $16,%rsp
L138:
	leaq 8(%r13),%rcx
	movq 8(%r13),%rax
	movq %rax,_lexprog(%rip)
	decl %r14d
	movq %rcx,%r13
L128:
	movl _recsize(%rip),%edi
	call _recinit
	call _syminit
	movl $1,_compile_time(%rip)
	movq _cmdname(%rip),%rax
	movq %rax,(%r13)
	cmpl $0,_dbg(%rip)
	jz L142
L140:
	pushq %rax
	pushq %r14
	pushq $L143
	call _printf
	addq $24,%rsp
L142:
	movq %r13,%rsi
	movl %r14d,%edi
	call _arginit
	cmpl $0,_safe(%rip)
	jnz L146
L144:
	movq _environ(%rip),%rdi
	call _envinit
L146:
	call _yyparse
	testq %r12,%r12
	jz L149
L147:
	xorl %esi,%esi
	movq %r12,%rdi
	call _qstring
	movq _FS(%rip),%rcx
	movq %rax,(%rcx)
L149:
	cmpl $0,_dbg(%rip)
	jz L152
L150:
	movl _errorflag(%rip),%eax
	pushq %rax
	pushq $L153
	call _printf
	addq $16,%rsp
L152:
	cmpl $0,_errorflag(%rip)
	jnz L155
L154:
	movl $0,_compile_time(%rip)
	movq _winner(%rip),%rdi
	call _run
	jmp L156
L155:
	call _bracecheck
L156:
	movl _errorflag(%rip),%eax
L4:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_pgetc:
L171:
L174:
	cmpq $0,_yyin(%rip)
	jnz L180
L178:
	movl _curpfile(%rip),%eax
	cmpl _npfile(%rip),%eax
	jge L181
L183:
	movslq %eax,%rax
	movl $L188,%esi
	movq _pfile(,%rax,8),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L186
L185:
	movq $___stdin,_yyin(%rip)
	jmp L187
L186:
	movslq _curpfile(%rip),%rax
	movl $L192,%esi
	movq _pfile(,%rax,8),%rdi
	call _fopen
	movq %rax,_yyin(%rip)
	testq %rax,%rax
	jnz L187
L189:
	movslq _curpfile(%rip),%rax
	pushq _pfile(,%rax,8)
	pushq $L193
	call _FATAL
	addq $16,%rsp
L187:
	movl $1,_lineno(%rip)
L180:
	movq _yyin(%rip),%rcx
	decl (%rcx)
	movq _yyin(%rip),%rdi
	js L198
L197:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%eax
	jmp L199
L198:
	call ___fillbuf
L199:
	cmpl $-1,%eax
	jnz L173
L196:
	movq _yyin(%rip),%rdi
	cmpq $___stdin,%rdi
	jz L203
L201:
	call _fclose
L203:
	movq $0,_yyin(%rip)
	incl _curpfile(%rip)
	jmp L174
L181:
	movl $-1,%eax
L173:
	ret 


_cursource:
L204:
L205:
	cmpl $0,_npfile(%rip)
	jle L208
L207:
	movslq _curpfile(%rip),%rax
	movq _pfile(,%rax,8),%rax
	ret
L208:
	xorl %eax,%eax
L206:
	ret 

L24:
	.byte 45,45,118,101,114,115,105,111
	.byte 110,0
L56:
	.byte 110,111,32,112,114,111,103,114
	.byte 97,109,32,102,105,108,101,110
	.byte 97,109,101,0
L8:
	.byte 117,115,97,103,101,58,32,37
	.byte 115,32,91,45,70,32,102,115
	.byte 93,32,91,45,118,32,118,97
	.byte 114,61,118,97,108,117,101,93
	.byte 32,91,45,102,32,112,114,111
	.byte 103,102,105,108,101,32,124,32
	.byte 39,112,114,111,103,39,93,32
	.byte 91,102,105,108,101,32,46,46
	.byte 46,93,10,0
L188:
	.byte 45,0
L143:
	.byte 97,114,103,99,61,37,100,44
	.byte 32,97,114,103,118,91,48,93
	.byte 61,37,115,10,0
L23:
	.byte 45,118,101,114,115,105,111,110
	.byte 0
L43:
	.byte 45,115,97,102,101,0
L135:
	.byte 110,111,32,112,114,111,103,114
	.byte 97,109,32,103,105,118,101,110
	.byte 0
L110:
	.byte 105,110,118,97,108,105,100,32
	.byte 45,118,32,111,112,116,105,111
	.byte 110,32,97,114,103,117,109,101
	.byte 110,116,58,32,37,115,0
L1:
	.byte 118,101,114,115,105,111,110,32
	.byte 50,48,49,50,49,50,50,48
	.byte 0
L72:
	.byte 9,0
L124:
	.byte 117,110,107,110,111,119,110,32
	.byte 111,112,116,105,111,110,32,37
	.byte 115,32,105,103,110,111,114,101
	.byte 100,0
L192:
	.byte 114,0
L114:
	.byte 110,111,32,118,97,114,105,97
	.byte 98,108,101,32,110,97,109,101
	.byte 0
L101:
	.byte 102,105,101,108,100,32,115,101
	.byte 112,97,114,97,116,111,114,32
	.byte 70,83,32,105,115,32,101,109
	.byte 112,116,121,0
L34:
	.byte 45,45,0
L29:
	.byte 97,119,107,32,37,115,10,0
L153:
	.byte 101,114,114,111,114,102,108,97
	.byte 103,61,37,100,10,0
L193:
	.byte 99,97,110,39,116,32,111,112
	.byte 101,110,32,102,105,108,101,32
	.byte 37,115,0
L139:
	.byte 112,114,111,103,114,97,109,32
	.byte 61,32,124,37,115,124,10,0
L52:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,45,102,32,111,112,116,105
	.byte 111,110,115,0
.globl _cmdname
.comm _cmdname, 8, 8
.globl _lexprog
.comm _lexprog, 8, 8
.globl _pfile
.comm _pfile, 160, 8

.globl _cursource
.globl _FS
.globl ___fillbuf
.globl _syminit
.globl _envinit
.globl _winner
.globl _fopen
.globl _cmdname
.globl _makesymtab
.globl _dbg
.globl _srand_seed
.globl _safe
.globl _strncmp
.globl _version
.globl _npfile
.globl _run
.globl _errorflag
.globl _lineno
.globl _atoi
.globl _isclvar
.globl _printf
.globl _fpecatch
.globl _pgetc
.globl _yyparse
.globl _setclvar
.globl _strcmp
.globl _WARNING
.globl _symtab
.globl _recsize
.globl ___stderr
.globl _pfile
.globl ___stdin
.globl _fclose
.globl _recinit
.globl _compile_time
.globl _lexprog
.globl _arginit
.globl _curpfile
.globl _bracecheck
.globl _signal
.globl _yyin
.globl _main
.globl _srand
.globl _exit
.globl _environ
.globl _FATAL
.globl _fprintf
.globl _qstring
