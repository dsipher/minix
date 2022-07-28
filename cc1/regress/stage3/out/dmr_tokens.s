.data
.align 8
_wbp:
	.quad _wbuf
_wstab:
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 1
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 1
	.byte 1
	.byte 1
	.byte 1
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 1
	.byte 0
	.byte 1
	.byte 1
	.byte 1
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
.text

_maketokenrow:
L1:
	pushq %rbx
L2:
	movq %rsi,%rbx
	movl %edi,24(%rbx)
	cmpl $0,%edi
	jle L5
L4:
	leal (%rdi,%rdi,2),%edi
	shll $3,%edi
	call _domalloc
	movq %rax,8(%rbx)
	jmp L6
L5:
	movq $0,8(%rbx)
L6:
	movq 8(%rbx),%rax
	movq %rax,(%rbx)
	movq %rax,16(%rbx)
L3:
	popq %rbx
	ret 


_growtokenrow:
L7:
	pushq %rbx
	pushq %r12
	pushq %r13
L8:
	movq %rdi,%rbx
	movq (%rbx),%rax
	movq 8(%rbx),%rdi
	subq %rdi,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r12d
	movq 16(%rbx),%rax
	subq %rdi,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r13d
	imull $3,24(%rbx),%eax
	movl $2,%ecx
	cltd 
	idivl %ecx
	incl %eax
	movl %eax,24(%rbx)
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rsi
	shlq $3,%rsi
	call _realloc
	movslq %eax,%rax
	movq %rax,8(%rbx)
	testq %rax,%rax
	jnz L12
L10:
	pushq $L13
	pushq $2
	call _error
	addq $16,%rsp
L12:
	movq 8(%rbx),%rdx
	movslq %r13d,%r13
	leaq (%r13,%r13,2),%rax
	shlq $3,%rax
	addq %rdx,%rax
	movq %rax,16(%rbx)
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rcx
	shlq $3,%rcx
	addq %rcx,%rdx
	movq %rdx,(%rbx)
L9:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_comparetokens:
L15:
	pushq %rbx
	pushq %r12
	pushq %r13
L16:
	movq %rdi,%r13
	movq (%r13),%r12
	movq (%rsi),%rbx
	movq 16(%r13),%rax
	subq %r12,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movq %rax,%rdi
	movq 16(%rsi),%rax
	subq %rbx,%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq %rax,%rdi
	jnz L43
L22:
	cmpq 16(%r13),%r12
	jae L25
L23:
	movb (%r12),%al
	cmpb (%rbx),%al
	jnz L43
L37:
	cmpl $0,4(%r12)
	setz %cl
	movzbl %cl,%ecx
	cmpl $0,4(%rbx)
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L43
L33:
	movl 8(%r12),%edx
	cmpl 8(%rbx),%edx
	jnz L43
L29:
	movq 16(%r12),%rdi
	movq 16(%rbx),%rsi
	call _strncmp
	testl %eax,%eax
	jnz L43
L28:
	addq $24,%r12
	addq $24,%rbx
	jmp L22
L25:
	xorl %eax,%eax
	jmp L17
L43:
	movl $1,%eax
L17:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_insertrow:
L44:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L45:
	movq %rdi,%r13
	movq %rdx,%r12
	movq 16(%r12),%rax
	subq 8(%r12),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r14d
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rbx
	shlq $3,%rbx
	addq %rbx,(%r13)
	movl %r14d,%eax
	subl %esi,%eax
	movl %eax,%esi
	movq %r13,%rdi
	call _adjustrow
	subq %rbx,(%r13)
	movq %r12,%rsi
	movq %r13,%rdi
	call _movetokenrow
	movq %r13,%rdi
	call _makespace
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%rcx
	shlq $3,%rcx
	addq (%r13),%rcx
	movq %rcx,(%r13)
	movq %r13,%rdi
	call _makespace
L46:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_makespace:
L47:
	pushq %rbx
L48:
	movq (%rdi),%rbx
	cmpq 16(%rdi),%rbx
	jae L49
L52:
	cmpl $0,4(%rbx)
	jnz L54
L56:
	movzbq (%rbx),%rax
	cmpb $0,_wstab(%rax)
	jnz L49
L77:
	cmpq 8(%rdi),%rbx
	jbe L76
L81:
	movzbq -24(%rbx),%rax
	cmpb $0,_wstab(%rax)
	jnz L49
L76:
	movq 16(%rbx),%rdi
	movl $1,%edx
	movl 8(%rbx),%esi
	call _newstring
	movb $32,(%rax)
	incq %rax
	movq %rax,16(%rbx)
	movl $1,4(%rbx)
	orb $1,1(%rbx)
	jmp L49
L54:
	testb $1,1(%rbx)
	jz L59
L60:
	movzbq (%rbx),%rax
	cmpb $0,_wstab(%rax)
	jnz L57
L64:
	cmpq 8(%rdi),%rbx
	jbe L59
L68:
	movzbq -24(%rbx),%rax
	cmpb $0,_wstab(%rax)
	jz L59
L57:
	movl $0,4(%rbx)
	jmp L49
L59:
	movq 16(%rbx),%rax
	movb $32,-1(%rax)
L49:
	popq %rbx
	ret 


_movetokenrow:
L86:
L87:
	movq 16(%rsi),%rdx
	movq 8(%rsi),%rsi
	subq %rsi,%rdx
	movslq %edx,%rdx
	movq (%rdi),%rdi
	call _memmove
L88:
	ret 


_adjustrow:
L89:
	pushq %rbx
	pushq %r12
	pushq %r13
L90:
	movq %rdi,%rbx
	movl %esi,%r12d
	testl %r12d,%r12d
	jz L91
L94:
	movq 16(%rbx),%rax
	subq 8(%rbx),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	leal (%rax,%r12),%r13d
L96:
	cmpl 24(%rbx),%r13d
	jle L98
L97:
	movq %rbx,%rdi
	call _growtokenrow
	jmp L96
L98:
	movq 16(%rbx),%rdx
	movq (%rbx),%rsi
	subq %rsi,%rdx
	testl %edx,%edx
	jz L101
L99:
	movslq %r12d,%rax
	leaq (%rax,%rax,2),%rdi
	shlq $3,%rdi
	movslq %edx,%rdx
	addq %rsi,%rdi
	call _memmove
L101:
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rcx
	shlq $3,%rcx
	addq 16(%rbx),%rcx
	movq %rcx,16(%rbx)
L91:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_copytokenrow:
L102:
	pushq %rbx
	pushq %r12
	pushq %r13
L103:
	movq %rdi,%rbx
	movq %rsi,%r13
	movq 16(%r13),%rax
	subq 8(%r13),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%r12d
	movq %rbx,%rsi
	movl %r12d,%edi
	call _maketokenrow
	movq %r13,%rsi
	movq %rbx,%rdi
	call _movetokenrow
	movslq %r12d,%r12
	leaq (%r12,%r12,2),%rcx
	shlq $3,%rcx
	addq 16(%rbx),%rcx
	movq %rcx,16(%rbx)
	movq %rbx,%rax
L104:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_normtokenrow:
L106:
	pushq %rbx
	pushq %r12
	pushq %r13
L107:
	movq %rdi,%r13
	movl $32,%edi
	call _domalloc
	movq %rax,%r12
	movq 16(%r13),%rax
	subq (%r13),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	movl %eax,%edi
	cmpl $0,%eax
	movl $1,%eax
	cmovlel %eax,%edi
	movq %r12,%rsi
	call _maketokenrow
	movq (%r13),%rbx
L112:
	movq 16(%r13),%rax
	movq 16(%r12),%rcx
	cmpq %rax,%rbx
	jae L115
L113:
	movq (%rbx),%rax
	movq %rax,(%rcx)
	movq 8(%rbx),%rax
	movq %rax,8(%rcx)
	movq 16(%rbx),%rax
	movq %rax,16(%rcx)
	movl 8(%rbx),%esi
	testl %esi,%esi
	jz L118
L116:
	movl $1,%edx
	movq 16(%rbx),%rdi
	call _newstring
	movq 16(%r12),%rcx
	movq %rax,16(%rcx)
	movq 16(%r12),%rdx
	movq 16(%rdx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,16(%rdx)
	movb $32,(%rcx)
	cmpl $0,4(%rbx)
	jz L118
L119:
	movq 16(%r12),%rax
	movl $1,4(%rax)
L118:
	addq $24,16(%r12)
	addq $24,%rbx
	jmp L112
L115:
	movq 8(%r12),%rax
	cmpq %rcx,%rax
	jae L124
L122:
	movl $0,4(%rax)
L124:
	movq %r12,%rax
L108:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_peektokens:
L126:
	pushq %rbx
	pushq %r12
	pushq %r13
L127:
	movq %rdi,%r13
	movq %rsi,%r12
	movq (%r13),%rbx
	call _flushout
	testq %r12,%r12
	jz L131
L129:
	pushq %r12
	pushq $L132
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L131:
	movq 8(%r13),%rax
	cmpq %rax,%rbx
	jb L133
L136:
	cmpq 16(%r13),%rbx
	jbe L135
L133:
	subq %rax,%rbx
	movl $24,%ecx
	movq %rbx,%rax
	cqto 
	idivq %rcx
	pushq %rax
	pushq $L140
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L135:
	movq 8(%r13),%r12
L141:
	cmpq 16(%r13),%r12
	jae L144
L145:
	movq 8(%r13),%rax
	addq $768,%rax
	cmpq %rax,%r12
	jae L144
L142:
	cmpb $6,(%r12)
	jz L151
L149:
	movq 16(%r12),%rcx
	movl 8(%r12),%eax
	movzbl (%rcx,%rax),%ebx
	movb $0,(%rcx,%rax)
	pushq 16(%r12)
	pushq $L152
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movq 16(%r12),%rcx
	movl 8(%r12),%eax
	movb %bl,(%rcx,%rax)
L151:
	movb (%r12),%cl
	movq (%r13),%rax
	cmpb $2,%cl
	jnz L154
L153:
	cmpq %rax,%r12
	movl $L157,%eax
	movl $L156,%ecx
	cmovnzq %rax,%rcx
	pushq %rcx
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movzwl 2(%r12),%edi
	call _prhideset
	pushq $L161
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L155
L154:
	cmpq %rax,%r12
	movl $L163,%eax
	movl $L162,%edx
	cmovnzq %rax,%rdx
	movzbl %cl,%ecx
	pushq %rcx
	pushq %rdx
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L155:
	addq $24,%r12
	jmp L141
L144:
	pushq $L167
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $___stderr,%edi
	call _fflush
L128:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_puttokens:
L168:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L169:
	movq %rdi,%r13
	cmpl $0,_verbose(%rip)
	jz L173
L171:
	movl $L174,%esi
	movq %r13,%rdi
	call _peektokens
L173:
	movq 8(%r13),%r12
L175:
	cmpq 16(%r13),%r12
	jae L178
L176:
	movl 8(%r12),%r14d
	movl 4(%r12),%eax
	addl %eax,%r14d
	movq 16(%r12),%rbx
	subq %rax,%rbx
L179:
	movq 16(%r13),%rax
	subq $24,%rax
	cmpq %rax,%r12
	jae L184
L182:
	movslq %r14d,%rsi
	addq %rbx,%rsi
	movq 40(%r12),%rax
	movl 28(%r12),%edx
	movl %edx,%ecx
	subq %rcx,%rax
	cmpq %rax,%rsi
	jnz L184
L183:
	addq $24,%r12
	addl 8(%r12),%edx
	addl %edx,%r14d
	jmp L179
L184:
	movq _wbp(%rip),%rdi
	cmpl $2048,%r14d
	jle L187
L186:
	cmpq $_wbuf,%rdi
	jbe L191
L189:
	subq $_wbuf,%rdi
	movl $___stdout,%ecx
	movq %rdi,%rdx
	movl $1,%esi
	movl $_wbuf,%edi
	call _fwrite
L191:
	movslq %r14d,%rdx
	movl $___stdout,%ecx
	movl $1,%esi
	movq %rbx,%rdi
	call _fwrite
	movq $_wbuf,_wbp(%rip)
	jmp L188
L187:
	movslq %r14d,%r14
	movq %r14,%rdx
	movq %rbx,%rsi
	call _memcpy
	addq _wbp(%rip),%r14
	movq %r14,_wbp(%rip)
L188:
	cmpq $_wbuf+4096,_wbp(%rip)
	jb L194
L192:
	movl $___stdout,%ecx
	movl $4096,%edx
	movl $1,%esi
	movl $_wbuf,%edi
	call _fwrite
	movq _wbp(%rip),%rdx
	cmpq $_wbuf+4096,%rdx
	jbe L197
L195:
	subq $_wbuf+4096,%rdx
	movl $_wbuf+4096,%esi
	movl $_wbuf,%edi
	call _memcpy
L197:
	subq $4096,_wbp(%rip)
L194:
	addq $24,%r12
	jmp L175
L178:
	movq %r12,(%r13)
	movq _cursource(%rip),%rax
	cmpq $___stdin,40(%rax)
	jnz L170
L198:
	call _flushout
L170:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_flushout:
L201:
L202:
	movq _wbp(%rip),%rdx
	cmpq $_wbuf,%rdx
	jbe L203
L204:
	subq $_wbuf,%rdx
	movl $___stdout,%ecx
	movl $1,%esi
	movl $_wbuf,%edi
	call _fwrite
	movl $___stdout,%edi
	call _fflush
	movq $_wbuf,_wbp(%rip)
L203:
	ret 


_setempty:
L207:
L208:
	movq 8(%rdi),%rcx
	movq %rcx,(%rdi)
	leaq 24(%rcx),%rax
	movq %rax,16(%rdi)
	movq _nltoken(%rip),%rax
	movq %rax,(%rcx)
	movq _nltoken+8(%rip),%rax
	movq %rax,8(%rcx)
	movq _nltoken+16(%rip),%rax
	movq %rax,16(%rcx)
L209:
	ret 


_outnum:
L210:
	pushq %rbx
L211:
	movl %esi,%ebx
	cmpl $10,%ebx
	jl L215
L213:
	movl $10,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	movl %eax,%esi
	call _outnum
	movq %rax,%rdi
L215:
	movl $10,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	addb $48,%dl
	movb %dl,(%rdi)
	leaq 1(%rdi),%rax
L212:
	popq %rbx
	ret 


_newstring:
L217:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L218:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%ebx
	leal (%rbx,%r13),%r12d
	leal 1(%rbx,%r13),%edi
	call _domalloc
	movslq %r12d,%r12
	movb $0,(%r12,%rax)
	movslq %ebx,%rbx
	movslq %r13d,%rdx
	movq %r14,%rsi
	leaq (%rax,%rbx),%rdi
	call _strncpy
	subq %rbx,%rax
L219:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L174:
 .byte 0
L13:
 .byte 79,117,116,32,111,102,32,109
 .byte 101,109,111,114,121,32,102,114
 .byte 111,109,32,114,101,97,108,108
 .byte 111,99,0
L157:
 .byte 123,0
L167:
 .byte 10,0
L163:
 .byte 123,37,120,125,32,0
L162:
 .byte 123,37,120,42,125,32,0
L152:
 .byte 37,115,0
L156:
 .byte 123,42,0
L161:
 .byte 125,32,0
L132:
 .byte 37,115,32,0
L140:
 .byte 40,116,112,32,111,102,102,115
 .byte 101,116,32,37,100,41,32,0
.local _wbuf
.comm _wbuf, 8192, 1

.globl _memcpy
.globl _cursource
.globl _growtokenrow
.globl _puttokens
.globl _adjustrow
.globl _realloc
.globl _outnum
.globl _strncpy
.globl _copytokenrow
.globl _error
.globl ___stdout
.globl _prhideset
.globl _domalloc
.globl _strncmp
.globl _verbose
.globl _movetokenrow
.globl _normtokenrow
.globl _fflush
.globl _peektokens
.globl _newstring
.globl _makespace
.globl ___stderr
.globl _insertrow
.globl ___stdin
.globl _setempty
.globl _maketokenrow
.globl _fwrite
.globl _memmove
.globl _comparetokens
.globl _flushout
.globl _fprintf
.globl _nltoken
