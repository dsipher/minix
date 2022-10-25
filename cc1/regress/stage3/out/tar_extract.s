.data
.align 8
_now:
	.quad 0
.align 4
_we_are_root:
	.int 0
.align 4
_notumask:
	.int -1
.text

_extr_init:
L1:
	pushq %rbx
L2:
	xorl %edi,%edi
	call _time
	movq %rax,_now(%rip)
	call _geteuid
	testl %eax,%eax
	jnz L6
L4:
	movl $1,_we_are_root(%rip)
L6:
	xorl %edi,%edi
	call _umask
	movl %eax,%ebx
	cmpb $0,_f_use_protection(%rip)
	jnz L3
L7:
	movl %ebx,%edi
	call _umask
	notl %ebx
	movl %ebx,_notumask(%rip)
L3:
	popq %rbx
	ret 

.data
.align 4
L19:
	.int 0
.text
.align 2
L166:
	.short L30-_extract_archive
	.short L97-_extract_archive
	.short L24-_extract_archive
	.short L108-_extract_archive
	.short L111-_extract_archive
	.short L123-_extract_archive
	.short L24-_extract_archive
	.short L30-_extract_archive

_extract_archive:
L10:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L11:
	movl $_head,%edi
	call _saverec
	movq _head(%rip),%rdi
	call _userec
	movl $1,%ecx
	movl $_head_standard,%edx
	movl $_hstat,%esi
	movq _head(%rip),%rdi
	call _decode_header
	cmpb $0,_f_verbose(%rip)
	jz L15
L13:
	movl $___stdout,%edi
	call _print_header
L15:
	xorl %eax,%eax
	movq %rax,-48(%rbp) # spill
L16:
	movq _head(%rip),%rdi
	movl -48(%rbp),%ebx
	cmpb $47,(%rdi,%rbx)
	jnz L18
L17:
	movl L19(%rip),%ecx
	movq -48(%rbp),%rax # spill
	incl %eax
	movq %rax,-48(%rbp) # spill
	leal 1(%rcx),%eax
	movl %eax,L19(%rip)
	testl %ecx,%ecx
	jnz L16
L20:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L23
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L16
L18:
	movb 156(%rdi),%al
	cmpb $48,%al
	jl L160
L162:
	cmpb $55,%al
	jg L160
L159:
	addb $-48,%al
	movzbl %al,%eax
	movzwl L166(,%rax,2),%eax
	addl $_extract_archive,%eax
	jmp *%rax
L97:
	movq _head(%rip),%rdi
	movl -48(%rbp),%ebx
	leaq (%rdi,%rbx),%rsi
	addq $157,%rdi
	call _link
	testl %eax,%eax
	jz L25
L100:
	movq _head(%rip),%rdi
	addq %rbx,%rdi
	call _make_dirs
	testl %eax,%eax
	jnz L97
L104:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	addq _head(%rip),%rbx
	pushq %rbx
	pushq $L106
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movq _head(%rip),%rdi
	addq $157,%rdi
	jmp L167
L123:
	addq %rbx,%rdi
	call _strlen
	decl %eax
	movl %eax,%r12d
	jmp L124
L111:
	orl $24576,_hstat+24(%rip)
	jmp L109
L108:
	orl $8192,_hstat+24(%rip)
L109:
	movq _head(%rip),%rdi
	movl -48(%rbp),%eax
	movq %rax,-48(%rbp) # spill
	movl _hstat+24(%rip),%esi
	movl _hstat+40(%rip),%edx
	addq -48(%rbp),%rdi # spill
	call _mknod
	testl %eax,%eax
	jz L72
L113:
	movq _head(%rip),%rdi
	addq -48(%rbp),%rdi # spill
	call _make_dirs
	testl %eax,%eax
	jnz L109
L118:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L120
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _head(%rip),%rdi
	addq -48(%rbp),%rdi # spill
	jmp L167
L160:
	testb %al,%al
	jz L30
L24:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	movq _head(%rip),%rcx
	movsbl 156(%rcx),%eax
	addq %rbx,%rcx
	pushq %rcx
	pushq %rax
	pushq $L27
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L30:
	movq _head(%rip),%rdi
	addq %rbx,%rdi
	call _strlen
	movq _head(%rip),%rdx
	movl %eax,%r12d
	decl %r12d
	movq -48(%rbp),%rcx # spill
	leal -1(%rcx,%rax),%eax
	movslq %eax,%rax
	cmpb $47,(%rdx,%rax)
	jnz L36
L124:
	testl %r12d,%r12d
	jz L131
L127:
	movq _head(%rip),%rcx
	movq -48(%rbp),%rax # spill
	addl %r12d,%eax
	movslq %eax,%rax
	cmpb $47,(%rcx,%rax)
	jz L128
L131:
	movq _head(%rip),%rdi
	movl -48(%rbp),%ebx
	movl _hstat+24(%rip),%esi
	orl $192,%esi
	addq %rbx,%rdi
	call _mkdir
	testl %eax,%eax
	jz L150
L132:
	movq _head(%rip),%rdi
	addq %rbx,%rdi
	call _make_dirs
	testl %eax,%eax
	jnz L131
L137:
	movq _head(%rip),%rdx
	movq -48(%rbp),%rax # spill
	addl %r12d,%eax
	movslq %eax,%rcx
	cmpb $46,(%rdx,%rcx)
	jnz L144
L142:
	testl %r12d,%r12d
	jz L150
L146:
	decl %eax
	movslq %eax,%rax
	cmpb $47,(%rdx,%rax)
	jz L150
L144:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L152
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _head(%rip),%rdi
	addq %rbx,%rdi
	jmp L167
L150:
	movl _hstat+24(%rip),%eax
	movl %eax,%ecx
	andl $192,%ecx
	cmpl $192,%ecx
	jz L72
L154:
	orl $192,%eax
	movl %eax,_hstat+24(%rip)
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	addq _head(%rip),%rbx
	pushq %rbx
	pushq $L157
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L72
L128:
	decl %r12d
	movb $0,(%rcx,%rax)
	jmp L124
L36:
	cmpb $0,_f_keep(%rip)
	movl $3649,%eax
	movl $3265,%ecx
	cmovzl %eax,%ecx
	movq _head(%rip),%rdx
	movl -48(%rbp),%ebx
	movl _hstat+24(%rip),%eax
	addq %rbx,%rdx
	pushq %rax
	pushq %rcx
	pushq %rdx
	call _open
	movl %eax,%r13d
	addq $24,%rsp
	cmpl $0,%r13d
	jge L42
L40:
	movq _head(%rip),%rdi
	addq %rbx,%rdi
	call _make_dirs
	testl %eax,%eax
	jnz L36
L45:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L47
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _head(%rip),%rdi
	addq %rbx,%rdi
	call _perror
	movq _hstat+48(%rip),%rdi
	call _skip_file
	jmp L25
L42:
	movq _hstat+48(%rip),%r12
L50:
	cmpq $0,%r12
	jle L53
L51:
	call _findrec
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L54
L56:
	call _endofrecs
	subq %rbx,%rax
	movl %eax,%r15d
	movslq %eax,%rax
	cmpq %rax,%r12
	jge L61
L59:
	movl %r12d,%r15d
L61:
	movl $0,_errno(%rip)
	movslq %r15d,%r15
	movq %r15,%rdx
	movq %rbx,%rsi
	movl %r13d,%edi
	call _write
	movl %eax,%r14d
	leaq -1(%rbx,%r15),%rdi
	call _userec
	subq %r15,%r12
	cmpl %r14d,%r15d
	jz L50
L64:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq %r14
	pushq %r15
	pushq $L66
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movq _head(%rip),%rdi
	movl -48(%rbp),%eax
	addq %rax,%rdi
	call _perror
	movq %r12,%rdi
	call _skip_file
	jmp L53
L54:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L57
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L53:
	movl %r13d,%edi
	call _close
	cmpl $0,%eax
	jge L72
L68:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L71
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _head(%rip),%rdi
	movl -48(%rbp),%eax
	addq %rax,%rdi
	call _perror
L72:
	cmpb $0,_f_modified(%rip)
	jnz L75
L73:
	movq _now(%rip),%rax
	movq %rax,-16(%rbp)
	movq _hstat+88(%rip),%rax
	movq %rax,-8(%rbp)
	movq _head(%rip),%rdi
	movl -48(%rbp),%eax
	movq %rax,-40(%rbp) # spill
	leaq -16(%rbp),%rsi
	addq -40(%rbp),%rdi # spill
	call _utime
	cmpl $0,%eax
	jge L75
L76:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	movq _head(%rip),%rdi
	addq -40(%rbp),%rdi # spill
	call _perror
L75:
	cmpl $0,_we_are_root(%rip)
	jz L81
L79:
	movq _head(%rip),%rdi
	movl -48(%rbp),%eax
	movq %rax,-24(%rbp) # spill
	movl _hstat+28(%rip),%esi
	movl _hstat+32(%rip),%edx
	addq -24(%rbp),%rdi # spill
	call _chown
	cmpl $0,%eax
	jge L81
L82:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	movq _head(%rip),%rax
	movq -24(%rbp),%rdi # spill
	addq %rax,%rdi
	call _perror
L81:
	cmpb $0,_f_keep(%rip)
	jz L89
L88:
	testl $3584,_hstat+24(%rip)
	jz L25
L89:
	movq _head(%rip),%rdi
	movl -48(%rbp),%eax
	movq %rax,-32(%rbp) # spill
	movl _hstat+24(%rip),%eax
	movl _notumask(%rip),%esi
	andl %eax,%esi
	addq -32(%rbp),%rdi # spill
	call _chmod
	cmpl $0,%eax
	jge L25
L92:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	movq _head(%rip),%rdi
	addq -32(%rbp),%rdi # spill
L167:
	call _perror
L25:
	xorl %edi,%edi
	call _saverec
L12:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_make_dirs:
L168:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L169:
	movl _errno(%rip),%r12d
	movq %rdi,%r14
	xorl %r13d,%r13d
	cmpl $2,%r12d
	jnz L171
L173:
	movl $47,%esi
	movq %r14,%rdi
	jmp L215
L176:
	cmpq %rbx,%r14
	jz L177
L182:
	movb -1(%rbx),%al
	cmpb $47,%al
	jz L177
L181:
	cmpb $46,%al
	jnz L189
L190:
	leaq 1(%r14),%rax
	cmpq %rax,%rbx
	jz L177
L194:
	cmpb $47,-2(%rbx)
	jz L177
L189:
	movb $0,(%rbx)
	movl $511,%esi
	movq %r14,%rdi
	call _mkdir
	testl %eax,%eax
	jz L199
L201:
	movb $47,(%rbx)
	cmpl $17,_errno(%rip)
	jz L177
	jnz L178
L199:
	cmpl $0,_we_are_root(%rip)
	jz L204
L202:
	movl _hstat+28(%rip),%esi
	movl _hstat+32(%rip),%edx
	movq %r14,%rdi
	call _chown
	cmpl $0,%eax
	jge L204
L205:
	movl $1,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	movq %r14,%rdi
	call _perror
L204:
	movq %rbx,%rsi
	subq %r14,%rsi
	movl _notumask(%rip),%edx
	andl $511,%edx
	movl $___stdout,%ecx
	movq %r14,%rdi
	call _pr_mkdir
	movb $47,(%rbx)
	incl %r13d
L177:
	movl $47,%esi
	leaq 1(%rbx),%rdi
L215:
	call _strchr
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L176
L178:
	movl %r12d,_errno(%rip)
	movl %r13d,%eax
	jmp L170
L171:
	xorl %eax,%eax
L170:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L152:
	.byte 67,111,117,108,100,32,110,111
	.byte 116,32,109,97,107,101,32,100
	.byte 105,114,101,99,116,111,114,121
	.byte 32,0
L57:
	.byte 85,110,101,120,112,101,99,116
	.byte 101,100,32,69,79,70,32,111
	.byte 110,32,97,114,99,104,105,118
	.byte 101,32,102,105,108,101,10,0
L23:
	.byte 82,101,109,111,118,105,110,103
	.byte 32,108,101,97,100,105,110,103
	.byte 32,47,32,102,114,111,109,32
	.byte 97,98,115,111,108,117,116,101
	.byte 32,112,97,116,104,32,110,97
	.byte 109,101,115,32,105,110,32,116
	.byte 104,101,32,97,114,99,104,105
	.byte 118,101,46,10,0
L106:
	.byte 67,111,117,108,100,32,110,111
	.byte 116,32,108,105,110,107,32,37
	.byte 115,32,116,111,32,0
L71:
	.byte 69,114,114,111,114,32,119,104
	.byte 105,108,101,32,99,108,111,115
	.byte 105,110,103,32,0
L66:
	.byte 84,114,105,101,100,32,116,111
	.byte 32,119,114,105,116,101,32,37
	.byte 100,32,98,121,116,101,115,32
	.byte 116,111,32,102,105,108,101,44
	.byte 32,99,111,117,108,100,32,111
	.byte 110,108,121,32,119,114,105,116
	.byte 101,32,37,100,58,10,0
L120:
	.byte 67,111,117,108,100,32,110,111
	.byte 116,32,109,97,107,101,32,0
L157:
	.byte 65,100,100,101,100,32,119,114
	.byte 105,116,101,32,38,32,101,120
	.byte 101,99,117,116,101,32,112,101
	.byte 114,109,105,115,115,105,111,110
	.byte 32,116,111,32,100,105,114,101
	.byte 99,116,111,114,121,32,37,115
	.byte 10,0
L27:
	.byte 85,110,107,110,111,119,110,32
	.byte 102,105,108,101,32,116,121,112
	.byte 101,32,39,37,99,39,32,102
	.byte 111,114,32,37,115,44,32,101
	.byte 120,116,114,97,99,116,101,100
	.byte 32,97,115,32,110,111,114,109
	.byte 97,108,32,102,105,108,101,10
	.byte 0
L47:
	.byte 67,111,117,108,100,32,110,111
	.byte 116,32,109,97,107,101,32,102
	.byte 105,108,101,32,0

.globl _errno
.globl _close
.globl _geteuid
.globl _print_header
.globl _anno
.globl _extract_archive
.globl _f_keep
.globl _hstat
.globl ___stdout
.globl _chown
.globl _mkdir
.globl _f_modified
.globl _chmod
.globl _write
.globl _extr_init
.globl _link
.globl _pr_mkdir
.globl _make_dirs
.globl _findrec
.globl _skip_file
.globl _head
.globl _open
.globl _head_standard
.globl ___stderr
.globl _mknod
.globl _f_verbose
.globl _tar
.globl _perror
.globl _f_use_protection
.globl _userec
.globl _endofrecs
.globl _decode_header
.globl _umask
.globl _time
.globl _strlen
.globl _strchr
.globl _utime
.globl _fprintf
.globl _saverec
