.text

_ccl2ecl:
L1:
L2:
	movl $1,%eax
L4:
	cmpl _lastccl(%rip),%eax
	jg L3
L5:
	xorl %esi,%esi
	movslq %eax,%rax
	movq _cclmap(%rip),%rcx
	movl (%rcx,%rax,4),%edx
	xorl %ecx,%ecx
L8:
	movslq %eax,%rax
	movq _ccllen(%rip),%rdi
	cmpl (%rdi,%rax,4),%ecx
	jge L11
L9:
	leal (%rcx,%rdx),%edi
	movslq %edi,%rdi
	movq _ccltbl(%rip),%r8
	movzbl (%rdi,%r8),%edi
	movslq %edi,%rdi
	movl _ecgroup(,%rdi,4),%r10d
	cmpq $0,_xlation(%rip)
	jz L13
L15:
	cmpl $0,%r10d
	jge L13
L12:
	xorl %r9d,%r9d
L19:
	cmpl %r9d,%esi
	jle L22
L20:
	leal (%r9,%rdx),%edi
	movslq %edi,%rdi
	movq _ccltbl(%rip),%r8
	movzbl (%rdi,%r8),%r8d
	movl %r10d,%edi
	negl %edi
	cmpl %edi,%r8d
	jz L22
L25:
	incl %r9d
	jmp L19
L22:
	cmpl %r9d,%esi
	jg L14
L27:
	negb %r10b
	leal (%rsi,%rdx),%edi
	movslq %edi,%rdi
	movq _ccltbl(%rip),%r8
	movb %r10b,(%rdi,%r8)
	jmp L33
L13:
	cmpl $0,%r10d
	jle L14
L30:
	leal (%rdx,%rsi),%edi
	movslq %edi,%rdi
	movb %r10b,(%r8,%rdi)
L33:
	incl %esi
L14:
	incl %ecx
	jmp L8
L11:
	movl %esi,(%rdi,%rax,4)
	incl %eax
	jmp L4
L3:
	ret 


_cre8ecs:
L34:
L35:
	xorl %eax,%eax
	movl $1,%r9d
L37:
	cmpl %r9d,%edx
	jl L36
L38:
	movslq %r9d,%r9
	cmpl $0,(%rsi,%r9,4)
	jnz L43
L41:
	incl %eax
	movl %eax,(%rsi,%r9,4)
	movl (%rdi,%r9,4),%ecx
L44:
	testl %ecx,%ecx
	jz L43
L45:
	movl %eax,%r8d
	negl %r8d
	movslq %ecx,%rcx
	movl %r8d,(%rsi,%rcx,4)
	movl (%rdi,%rcx,4),%ecx
	jmp L44
L43:
	incl %r9d
	jmp L37
L36:
	ret 


_ecs_from_xlation:
L49:
L50:
	movq _xlation(%rip),%rdx
	xorl %ecx,%ecx
	xorl %eax,%eax
	cmpl $0,(%rdx)
	jz L54
L52:
	movl $1,%r9d
L55:
	cmpl _csize(%rip),%r9d
	jge L58
L56:
	movslq %r9d,%r9
	movq _xlation(%rip),%r10
	movl (%r10,%r9,4),%r8d
	movl (%r10),%esi
	movl %esi,%edx
	negl %edx
	cmpl %edx,%r8d
	jz L59
L61:
	incl %r9d
	jmp L55
L59:
	movl %esi,(%r10,%r9,4)
	movq _xlation(%rip),%rdx
	movl (%rdx),%edx
	negl %edx
	movl %edx,(%rdi)
L58:
	cmpl _csize(%rip),%r9d
	movl $1,%edx
	cmovgel %edx,%ecx
L54:
	movl $1,%esi
L66:
	cmpl _csize(%rip),%esi
	jge L69
L67:
	movslq %esi,%rsi
	movq _xlation(%rip),%rdx
	movl (%rdx,%rsi,4),%edx
	testl %edx,%edx
	jnz L84
L70:
	movl _num_xlations(%rip),%edx
	testl %eax,%eax
	jz L74
L73:
	negl %edx
L84:
	movl %edx,(%rdi,%rsi,4)
	jmp L72
L74:
	incl %edx
	movl %edx,_num_xlations(%rip)
	movl %edx,(%rdi,%rsi,4)
	movl $1,%eax
L72:
	incl %esi
	jmp L66
L69:
	testl %ecx,%ecx
	jz L78
L76:
	movl _num_xlations(%rip),%eax
	incl %eax
	movl %eax,_num_xlations(%rip)
	movl %eax,(%rdi)
	movl _csize(%rip),%eax
	cmpl _num_xlations(%rip),%eax
	jge L78
L79:
	movl $L82,%edi
	call _flexfatal
L78:
	movl _num_xlations(%rip),%eax
L51:
	ret 

.local L88
.comm L88, 256, 1

_mkeccl:
L85:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L86:
	xorl %eax,%eax
L89:
	cmpl %eax,%esi
	jle L87
L90:
	movslq %eax,%rax
	movzbl (%rax,%rdi),%r11d
	testl %r9d,%r9d
	jz L94
L95:
	testl %r11d,%r11d
	cmovzl %r9d,%r11d
L94:
	movslq %r11d,%r10
	movl (%rcx,%r10,4),%ebx
	movl %r11d,%r12d
	leal 1(%rax),%r13d
L150:
	movl (%rdx,%r10,4),%r10d
	testl %r10d,%r10d
	jz L102
L103:
	cmpl %r10d,%r8d
	jl L102
L107:
	cmpl %r13d,%esi
	jle L110
L108:
	testl %r9d,%r9d
	jz L112
L114:
	movslq %r13d,%r13
	cmpb $0,(%r13,%rdi)
	jnz L112
L111:
	movl %r9d,%r14d
	jmp L113
L112:
	movslq %r13d,%r13
	movzbl (%r13,%rdi),%r14d
L113:
	cmpl %r14d,%r10d
	jg L124
	jl L110
L125:
	movslq %r13d,%r13
	cmpb $0,L88(%r13)
	jz L122
L124:
	incl %r13d
	jmp L107
L122:
	movslq %r10d,%r10
	movl %r12d,(%rcx,%r10,4)
	movslq %r12d,%r12
	movl %r10d,(%rdx,%r12,4)
	movl %r10d,%r12d
	movb $1,L88(%r13)
	jmp L129
L110:
	movslq %r10d,%r10
	movl %ebx,(%rcx,%r10,4)
	testl %ebx,%ebx
	jz L133
L131:
	movslq %ebx,%rbx
	movl %r10d,(%rdx,%rbx,4)
L133:
	movl %r10d,%ebx
L129:
	movslq %r10d,%r10
	jmp L150
L102:
	movslq %r11d,%r11
	movl (%rcx,%r11,4),%r10d
	testl %r10d,%r10d
	jnz L134
L137:
	cmpl %r10d,%ebx
	jz L136
L134:
	movl $0,(%rcx,%r11,4)
	movslq %ebx,%r10
	movl $0,(%rdx,%r10,4)
L136:
	movslq %r12d,%r10
	movl $0,(%rdx,%r10,4)
L149:
	incl %eax
	movslq %eax,%rax
	cmpb $0,L88(%rax)
	jz L89
L145:
	cmpl %eax,%esi
	jle L89
L142:
	movb $0,L88(%rax)
	jmp L149
L87:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_mkechar:
L151:
L152:
	movslq %edi,%rdi
	movl (%rsi,%rdi,4),%eax
	testl %eax,%eax
	jz L156
L154:
	movl (%rdx,%rdi,4),%ecx
	movslq %eax,%rax
	movl %ecx,(%rdx,%rax,4)
L156:
	movl (%rdx,%rdi,4),%eax
	testl %eax,%eax
	jz L159
L157:
	movl (%rsi,%rdi,4),%ecx
	movslq %eax,%rax
	movl %ecx,(%rsi,%rax,4)
L159:
	movl $0,(%rsi,%rdi,4)
	movl $0,(%rdx,%rdi,4)
L153:
	ret 

L82:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,37,116,32,99,108,97,115
	.byte 115,101,115,33,0

.globl _num_xlations
.globl _ccltbl
.globl _csize
.globl _cclmap
.globl _cre8ecs
.globl _ecs_from_xlation
.globl _flexfatal
.globl _ecgroup
.globl _ccl2ecl
.globl _xlation
.globl _mkechar
.globl _mkeccl
.globl _ccllen
.globl _lastccl
