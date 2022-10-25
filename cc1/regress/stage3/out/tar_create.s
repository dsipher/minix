.text

_write_eot:
L1:
	pushq %rbx
L2:
	call _findrec
	movq %rax,%rbx
	call _endofrecs
	subq %rbx,%rax
	movslq %eax,%rdx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _memset
	movq %rbx,%rdi
	call _userec
L3:
	popq %rbx
	ret 


_create_archive:
L4:
L5:
	xorl %edi,%edi
	call _open_archive
	jmp L7
L8:
	movl $-1,%esi
	movq %rax,%rdi
	call _dump_file
L7:
	call _name_next
	testq %rax,%rax
	jnz L8
L9:
	call _write_eot
	call _close_archive
	call _name_close
L6:
	ret 


_dump_file:
L10:
	pushq %rbp
	movq %rsp,%rbp
	subq $128,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L11:
	movq %rdi,%rbx
	movl %esi,-112(%rbp) # spill
	movl $_hstat,%esi
	movq %rbx,%rdi
	call _stat
	testl %eax,%eax
	jnz L19
L15:
	cmpb $0,_f_local_filesys(%rip)
	jz L27
L29:
	cmpl $0,-112(%rbp) # spill
	jl L27
L30:
	movl -112(%rbp),%eax # spill
	cmpl _hstat(%rip),%eax
	jz L27
L26:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq %rbx
	pushq $L33
	jmp L203
L27:
	cmpl $1,_hstat+16(%rip)
	jbe L37
L35:
	movl _hstat+24(%rip),%eax
	andl $61440,%eax
	cmpl $32768,%eax
	jz L43
L192:
	cmpl $8192,%eax
	jz L43
L193:
	cmpl $24576,%eax
	jnz L37
L43:
	movq _linklist(%rip),%r12
	jmp L44
L45:
	movl 12(%r12),%eax
	cmpl _hstat+8(%rip),%eax
	jnz L53
L51:
	movl 8(%r12),%eax
	cmpl _hstat(%rip),%eax
	jnz L53
L52:
	movq $0,_hstat+48(%rip)
	movl $_hstat,%esi
	movq %rbx,%rdi
	call _start_header
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L20
L57:
	leaq 18(%r12),%rsi
	leaq 157(%rbx),%rdi
	call _strcpy
	movb $49,156(%rbx)
	jmp L205
L53:
	movq (%r12),%r12
L44:
	testq %r12,%r12
	jnz L45
L47:
	movq %rbx,%rdi
	call _strlen
	addl $20,%eax
	movl %eax,%edi
	call _malloc
	movq %rax,%r12
	testq %r12,%r12
	jnz L62
L60:
	cmpl $0,_nolinks(%rip)
	jnz L62
L63:
	pushq $L66
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	incl _nolinks(%rip)
L62:
	movl _hstat+8(%rip),%eax
	movl %eax,12(%r12)
	movl _hstat(%rip),%eax
	movl %eax,8(%r12)
	movq %rbx,%rsi
	leaq 18(%r12),%rdi
	call _strcpy
	movq _linklist(%rip),%rax
	movq %rax,(%r12)
	movq %r12,_linklist(%rip)
L37:
	movl _hstat+24(%rip),%eax
	movl %eax,%ecx
	andl $61440,%ecx
	cmpl $32768,%ecx
	jz L70
L197:
	cmpl $16384,%ecx
	jz L111
L198:
	cmpl $8192,%ecx
	jz L171
L199:
	cmpl $24576,%ecx
	jnz L179
L174:
	movb $52,%r12b
	jmp L172
L171:
	movb $51,%r12b
L172:
	cmpb $0,_f_oldarch(%rip)
	jz L178
L179:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq %rbx
	pushq $L189
	jmp L203
L178:
	movq $0,_hstat+48(%rip)
	movl $_hstat,%esi
	movq %rbx,%rdi
	call _start_header
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L20
L183:
	movb %r12b,156(%rbx)
	cmpb $54,%r12b
	jz L205
L185:
	movl _hstat+40(%rip),%eax
	shrl $8,%eax
	movzbq %al,%rdi
	leaq 329(%rbx),%rdx
	movl $8,%esi
	call _to_oct
	movzbq _hstat+40(%rip),%rdi
	leaq 337(%rbx),%rdx
	movl $8,%esi
	call _to_oct
L205:
	movq %rbx,%rdi
	call _finish_header
	jmp L12
L70:
	movq _hstat+48(%rip),%r12
	cmpq $0,%r12
	jg L75
L74:
	andl $292,%eax
	cmpl $292,%eax
	jz L76
L75:
	pushq $0
	pushq %rbx
	call _open
	addq $16,%rsp
	movl %eax,-124(%rbp) # spill
	cmpl $0,%eax
	jge L73
L19:
	movq %rbx,%rdi
	call _perror
	jmp L20
L76:
	movl $-1,-124(%rbp) # spill
L73:
	movl $_hstat,%esi
	movq %rbx,%rdi
	call _start_header
	testq %rax,%rax
	jz L20
L84:
	movq %rax,%rdi
	call _finish_header
L86:
	cmpq $0,%r12
	jle L88
L87:
	call _findrec
	movq %rax,%r15
	call _endofrecs
	subq %r15,%rax
	movl %eax,%r14d
	movslq %eax,%rax
	cmpq %rax,%r12
	jge L91
L89:
	movl %r12d,%eax
	movl %eax,%r14d
	movl $512,%ecx
	cltd 
	idivl %ecx
	movl %edx,%eax
	testl %eax,%eax
	jz L91
L92:
	movl $512,%edx
	subl %eax,%edx
	movslq %edx,%rdx
	xorl %esi,%esi
	leaq (%r15,%r12),%rdi
	call _memset
L91:
	movslq %r14d,%rdx
	movq %r15,%rsi
	movl -124(%rbp),%edi # spill
	call _read
	movl %eax,%r13d
	cmpl $0,%r13d
	jl L95
L97:
	movslq %r13d,%r13
	subq %r13,%r12
	movl $512,%ecx
	leal -1(%r13),%eax
	cltd 
	idivl %ecx
	movslq %eax,%rdi
	shlq $9,%rdi
	addq %r15,%rdi
	call _userec
	cmpl %r13d,%r14d
	jz L86
L103:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq %r12
	pushq %rbx
	pushq $L105
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L99
L95:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	movq _hstat+48(%rip),%rax
	subq %r12,%rax
	pushq %r14
	pushq %rax
	pushq $L98
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movq %rbx,%rdi
	call _perror
L99:
	call _abort
L111:
	movl _hstat(%rip),%eax
	movl %eax,-108(%rbp) # spill
	movl $102,%edx
	movq %rbx,%rsi
	leaq -102(%rbp),%rdi
	call _strncpy
	leaq -102(%rbp),%rdi
	call _strlen
	jmp L112
L115:
	movl %eax,%ecx
	decl %ecx
	movslq %ecx,%rcx
	cmpb $47,-102(%rbp,%rcx)
	jnz L117
L116:
	decl %eax
L112:
	cmpl $1,%eax
	jge L115
L117:
	leal 1(%rax),%r13d
	movl %r13d,%r12d
	movslq %eax,%rax
	movb $47,-102(%rbp,%rax)
	movslq %r13d,%r13
	movb $0,-102(%rbp,%r13)
	cmpb $0,_f_oldarch(%rip)
	jnz L121
L119:
	movq $0,_hstat+48(%rip)
	movl $_hstat,%esi
	leaq -102(%rbp),%rdi
	call _start_header
	testq %rax,%rax
	jnz L124
L20:
	incl _errors(%rip)
	jmp L12
L124:
	cmpb $0,_f_oldarch(%rip)
	jnz L128
L126:
	movb $53,156(%rax)
L128:
	movq %rax,%rdi
	call _finish_header
L121:
	cmpl $2,%r13d
	jnz L131
L132:
	cmpb $46,-102(%rbp)
	movl $0,%eax
	cmovzl %eax,%r12d
L131:
	cmpb $0,_f_dironly(%rip)
	jnz L12
L138:
	movl $0,_errno(%rip)
	movq %rbx,%rdi
	call _opendir
	movq %rax,%r13
	testq %r13,%r13
	jz L140
L148:
	movq %r13,%rdi
	call _readdir
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L150
L149:
	leaq 18(%rbx),%rax
	movq %rax,-120(%rbp) # spill
	cmpb $46,18(%rbx)
	jnz L153
L151:
	movb 19(%rbx),%al
	testb %al,%al
	jz L148
L156:
	cmpb $46,%al
	jnz L153
L158:
	cmpb $0,20(%rbx)
	jz L148
L153:
	leaq 18(%rbx),%rdi
	call _strlen
	movslq %r12d,%r12
	addq %r12,%rax
	leaq -102(%rbp),%r14
	cmpq $100,%rax
	jae L165
L167:
	leaq 18(%rbx),%rsi
	leaq -102(%r12,%rbp),%rdi
	call _strcpy
	movl -108(%rbp),%esi # spill
	leaq -102(%rbp),%rdi
	call _dump_file
	jmp L148
L165:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq -120(%rbp) # spill
	pushq %r14
	pushq $L168
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L148
L150:
	movq %r13,%rdi
	call _closedir
	jmp L12
L140:
	cmpl $0,_errno(%rip)
	jz L144
L143:
	movq %rbx,%rdi
	call _perror
	jmp L12
L144:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq %rbx
	pushq $L146
L203:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L12
L88:
	cmpl $0,-124(%rbp) # spill
	jl L12
L107:
	movl -124(%rbp),%edi # spill
	call _close
L12:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
L212:
	.int 0
.text

_start_header:
L206:
	pushq %rbx
	pushq %r12
	pushq %r13
L207:
	movq %rdi,%r13
	movq %rsi,%r12
	call _findrec
	movq %rax,%rbx
	movl $512,%edx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _memset
L209:
	cmpb $47,(%r13)
	jnz L211
L210:
	movl L212(%rip),%ecx
	incq %r13
	leal 1(%rcx),%eax
	movl %eax,L212(%rip)
	testl %ecx,%ecx
	jnz L209
L213:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L216
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L209
L211:
	movq %r13,%rsi
	movq %rbx,%rdi
	call _strcpy
	cmpb $0,99(%rbx)
	jnz L217
L219:
	movl 24(%r12),%edi
	andl $4294905855,%edi
	leaq 100(%rbx),%rdx
	movl $8,%esi
	call _to_oct
	movl 28(%r12),%edi
	leaq 108(%rbx),%rdx
	movl $8,%esi
	call _to_oct
	movl 32(%r12),%edi
	leaq 116(%rbx),%rdx
	movl $8,%esi
	call _to_oct
	leaq 124(%rbx),%rdx
	movl $13,%esi
	movq 48(%r12),%rdi
	call _to_oct
	leaq 136(%rbx),%rdx
	movl $13,%esi
	movq 88(%r12),%rdi
	call _to_oct
	cmpb $0,_f_oldarch(%rip)
	jnz L224
L222:
	movb $48,156(%rbx)
	movl $L225,%esi
	leaq 257(%rbx),%rdi
	call _strcpy
	movl 28(%r12),%esi
	leaq 265(%rbx),%rdi
	call _finduname
	movl 32(%r12),%esi
	leaq 297(%rbx),%rdi
	call _findgname
L224:
	movq %rbx,%rax
	jmp L208
L217:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq %r13
	pushq $L220
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	xorl %eax,%eax
L208:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_finish_header:
L227:
	pushq %rbx
L228:
	movq %rdi,%rbx
	movl $8,%edx
	movl $L230,%esi
	leaq 148(%rbx),%rdi
	call _memcpy
	xorl %edi,%edi
	movq %rbx,%rdx
	movl $512,%ecx
	jmp L231
L232:
	movzbl (%rdx),%eax
	incq %rdx
	addl %eax,%edi
L231:
	decl %ecx
	jns L232
L234:
	leaq 148(%rbx),%rdx
	movl $8,%esi
	call _to_oct
	movb $0,154(%rbx)
	movq %rbx,%rdi
	call _userec
	cmpb $0,_f_verbose(%rip)
	jz L229
L235:
	movq %rbx,_head(%rip)
	cmpb $0,_f_oldarch(%rip)
	setz %al
	movzbl %al,%eax
	movl %eax,_head_standard(%rip)
	movl $___stderr,%edi
	call _print_header
L229:
	popq %rbx
	ret 


_to_oct:
L239:
L240:
	addl $-2,%esi
	movslq %esi,%rax
	movb $32,(%rax,%rdx)
L242:
	movb %dil,%cl
	andb $7,%cl
	addb $48,%cl
	decl %esi
	movslq %esi,%rax
	movb %cl,(%rax,%rdx)
	sarq $3,%rdi
	cmpl $0,%esi
	jle L249
L245:
	testq %rdi,%rdi
	jz L249
	jnz L242
L250:
	decl %esi
	movslq %esi,%rax
	movb $32,(%rax,%rdx)
L249:
	cmpl $0,%esi
	jg L250
L241:
	ret 

L105:
	.byte 37,115,58,32,102,105,108,101
	.byte 32,115,104,114,117,110,107,32
	.byte 98,121,32,37,100,32,98,121
	.byte 116,101,115,44,32,112,97,100
	.byte 100,105,110,103,32,119,105,116
	.byte 104,32,122,101,114,111,115,46
	.byte 10,0
L216:
	.byte 82,101,109,111,118,105,110,103
	.byte 32,108,101,97,100,105,110,103
	.byte 32,47,32,102,114,111,109,32
	.byte 97,98,115,111,108,117,116,101
	.byte 32,112,97,116,104,32,110,97
	.byte 109,101,115,32,105,110,32,116
	.byte 104,101,32,97,114,99,104,105
	.byte 118,101,46,10,0
L230:
	.byte 32,32,32,32,32,32,32,32
	.byte 0
L225:
	.byte 117,115,116,97,114,32,32,0
L33:
	.byte 37,115,58,32,105,115,32,111
	.byte 110,32,97,32,100,105,102,102
	.byte 101,114,101,110,116,32,102,105
	.byte 108,101,115,121,115,116,101,109
	.byte 59,32,110,111,116,32,100,117
	.byte 109,112,101,100,10,0
L98:
	.byte 114,101,97,100,32,101,114,114
	.byte 111,114,32,97,116,32,98,121
	.byte 116,101,32,37,108,100,44,32
	.byte 114,101,97,100,105,110,103,32
	.byte 37,100,32,98,121,116,101,115
	.byte 44,32,105,110,32,102,105,108
	.byte 101,32,0
L66:
	.byte 116,97,114,58,32,110,111,32
	.byte 109,101,109,111,114,121,32,102
	.byte 111,114,32,108,105,110,107,115
	.byte 44,32,116,104,101,121,32,119
	.byte 105,108,108,32,98,101,32,100
	.byte 117,109,112,101,100,32,97,115
	.byte 32,115,101,112,97,114,97,116
	.byte 101,32,102,105,108,101,115,10
	.byte 0
L168:
	.byte 37,115,37,115,58,32,110,97
	.byte 109,101,32,116,111,111,32,108
	.byte 111,110,103,10,0
L189:
	.byte 37,115,58,32,85,110,107,110
	.byte 111,119,110,32,102,105,108,101
	.byte 32,116,121,112,101,59,32,102
	.byte 105,108,101,32,105,103,110,111
	.byte 114,101,100,46,10,0
L146:
	.byte 37,115,58,32,101,114,114,111
	.byte 114,32,111,112,101,110,105,110
	.byte 103,32,100,105,114,101,99,116
	.byte 111,114,121,0
L220:
	.byte 37,115,58,32,110,97,109,101
	.byte 32,116,111,111,32,108,111,110
	.byte 103,10,0
.local _nolinks
.comm _nolinks, 4, 4

.globl _errno
.globl _close
.globl _open_archive
.globl _memcpy
.globl _print_header
.globl _closedir
.globl _finduname
.globl _anno
.globl _name_next
.globl _strncpy
.globl _hstat
.globl _findgname
.globl _name_close
.globl _malloc
.globl _finish_header
.globl _errors
.globl _stat
.globl _opendir
.globl _to_oct
.globl _create_archive
.globl _abort
.globl _linklist
.globl _close_archive
.globl _f_dironly
.globl _findrec
.globl _head
.globl _open
.globl _head_standard
.globl ___stderr
.globl _f_verbose
.globl _f_oldarch
.globl _tar
.globl _perror
.globl _memset
.globl _read
.globl _start_header
.globl _userec
.globl _endofrecs
.globl _f_local_filesys
.globl _f_follow_links
.globl _strlen
.globl _readdir
.globl _strcpy
.globl _fprintf
.globl _dump_file
