.text

_nodealloc:
L1:
	pushq %rbx
L2:
	decl %edi
	movslq %edi,%rax
	leaq 32(,%rax,8),%rdi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L6
L4:
	pushq $L7
	call _FATAL
	addq $8,%rsp
L6:
	movq $0,8(%rbx)
	movl _lineno(%rip),%eax
	movl %eax,16(%rbx)
	movq %rbx,%rax
L3:
	popq %rbx
	ret 


_exptostat:
L9:
L10:
	movl $2,(%rdi)
	movq %rdi,%rax
L11:
	ret 


_node1:
L13:
	pushq %rbx
	pushq %r12
L14:
	movl %edi,%r12d
	movq %rsi,%rbx
	movl $1,%edi
	call _nodealloc
	movl %r12d,20(%rax)
	movq %rbx,24(%rax)
L15:
	popq %r12
	popq %rbx
	ret 


_node2:
L17:
	pushq %rbx
	pushq %r12
	pushq %r13
L18:
	movl %edi,%r13d
	movq %rsi,%r12
	movq %rdx,%rbx
	movl $2,%edi
	call _nodealloc
	movl %r13d,20(%rax)
	movq %r12,24(%rax)
	movq %rbx,32(%rax)
L19:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_node3:
L21:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L22:
	movl %edi,%r14d
	movq %rsi,%r13
	movq %rdx,%r12
	movq %rcx,%rbx
	movl $3,%edi
	call _nodealloc
	movl %r14d,20(%rax)
	movq %r13,24(%rax)
	movq %r12,32(%rax)
	movq %rbx,40(%rax)
L23:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_node4:
L25:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L26:
	movl %edi,%r15d
	movq %rsi,%r14
	movq %rdx,%r13
	movq %rcx,%r12
	movq %r8,%rbx
	movl $4,%edi
	call _nodealloc
	movl %r15d,20(%rax)
	movq %r14,24(%rax)
	movq %r13,32(%rax)
	movq %r12,40(%rax)
	movq %rbx,48(%rax)
L27:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_stat1:
L29:
L30:
	call _node1
	movl $2,(%rax)
L31:
	ret 


_stat2:
L33:
L34:
	call _node2
	movl $2,(%rax)
L35:
	ret 


_stat3:
L37:
L38:
	call _node3
	movl $2,(%rax)
L39:
	ret 


_stat4:
L41:
L42:
	call _node4
	movl $2,(%rax)
L43:
	ret 


_op1:
L45:
L46:
	call _node1
	movl $3,(%rax)
L47:
	ret 


_op2:
L49:
L50:
	call _node2
	movl $3,(%rax)
L51:
	ret 


_op3:
L53:
L54:
	call _node3
	movl $3,(%rax)
L55:
	ret 


_op4:
L57:
L58:
	call _node4
	movl $3,(%rax)
L59:
	ret 


_celltonode:
L61:
L62:
	movb $1,(%rdi)
	movb %sil,1(%rdi)
	movq %rdi,%rsi
	xorl %edi,%edi
	call _node1
	movl $1,(%rax)
L63:
	ret 


_rectonode:
L65:
L66:
	xorl %esi,%esi
	movq _literal0(%rip),%rdi
	call _celltonode
	movq %rax,%rsi
	movl $348,%edi
	call _op1
L67:
	ret 


_makearr:
L69:
	pushq %rbx
	pushq %r12
L70:
	movq %rdi,%r12
	cmpl $1,(%r12)
	jnz L74
L72:
	movq 24(%r12),%rbx
	movl 32(%rbx),%eax
	testl $32,%eax
	jz L76
L75:
	pushq 8(%rbx)
	pushq $L78
	call _SYNTAX
	addq $16,%rsp
	jmp L74
L76:
	testl $16,%eax
	jnz L74
L79:
	movq 16(%rbx),%rdi
	testq %rdi,%rdi
	jz L84
L82:
	call _free
	movq $0,16(%rbx)
L84:
	movl $50,%edi
	call _makesymtab
	movq %rax,16(%rbx)
	movl $16,32(%rbx)
L74:
	movq %r12,%rax
L71:
	popq %r12
	popq %rbx
	ret 


_pa2stat:
L86:
	pushq %rbx
	pushq %r12
	pushq %r13
L87:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	movl _paircnt(%rip),%edi
	call _itonp
	movq %rax,%r8
	movq %rbx,%rcx
	movq %r12,%rdx
	movq %r13,%rsi
	movl $260,%edi
	call _node4
	movq %rax,%rbx
	movl _paircnt(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_paircnt(%rip)
	cmpl $50,%ecx
	jl L91
L89:
	pushq $50
	pushq $L92
	call _SYNTAX
	addq $16,%rsp
L91:
	movl $2,(%rbx)
	movq %rbx,%rax
L88:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_linkum:
L94:
L95:
	movq %rdi,%rax
	cmpl $0,_errorflag(%rip)
	jnz L96
L99:
	testq %rax,%rax
	jnz L102
L101:
	movq %rsi,%rax
	ret
L102:
	testq %rsi,%rsi
	jz L96
L103:
	movq %rax,%rdx
	jmp L109
L110:
	movq %rcx,%rdx
L109:
	movq 8(%rdx),%rcx
	testq %rcx,%rcx
	jnz L110
L112:
	movq %rsi,8(%rdx)
L96:
	ret 


_defn:
L115:
	pushq %rbx
	pushq %r12
	pushq %r13
L116:
	movq %rdi,%r13
	movq %rsi,%rbx
	movq %rdx,%r12
	testl $16,32(%r13)
	movq 8(%r13),%rdi
	jnz L118
L120:
	call _isarg
	cmpl $-1,%eax
	jnz L123
L125:
	movl $32,32(%r13)
	movq %r12,16(%r13)
	xorl %eax,%eax
	jmp L128
L129:
	incl %eax
	movq 8(%rbx),%rbx
L128:
	testq %rbx,%rbx
	jnz L129
L131:
	cvtsi2sdl %eax,%xmm0
	movsd %xmm0,24(%r13)
	cmpl $0,_dbg(%rip)
	jz L117
L132:
	pushq %rax
	pushq 8(%r13)
	pushq $L135
	call _printf
	addq $24,%rsp
	jmp L117
L123:
	pushq 8(%r13)
	pushq $L126
	jmp L136
L118:
	pushq %rdi
	pushq $L121
L136:
	call _SYNTAX
	addq $16,%rsp
L117:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_isarg:
L137:
	pushq %rbx
	pushq %r12
	pushq %r13
L138:
	movq %rdi,%r13
	movq _arglist(%rip),%r12
	xorl %ebx,%ebx
L140:
	testq %r12,%r12
	jz L143
L141:
	movq 24(%r12),%rax
	movq %r13,%rsi
	movq 8(%rax),%rdi
	call _strcmp
	testl %eax,%eax
	jz L144
L146:
	movq 8(%r12),%r12
	incl %ebx
	jmp L140
L144:
	movl %ebx,%eax
	jmp L139
L143:
	movl $-1,%eax
L139:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_ptoi:
L149:
L150:
	movl %edi,%eax
L151:
	ret 


_itonp:
L153:
L154:
	movslq %edi,%rax
L155:
	ret 

L121:
	.byte 96,37,115,39,32,105,115,32
	.byte 97,110,32,97,114,114,97,121
	.byte 32,110,97,109,101,32,97,110
	.byte 100,32,97,32,102,117,110,99
	.byte 116,105,111,110,32,110,97,109
	.byte 101,0
L135:
	.byte 100,101,102,105,110,105,110,103
	.byte 32,102,117,110,99,32,37,115
	.byte 32,40,37,100,32,97,114,103
	.byte 115,41,10,0
L126:
	.byte 96,37,115,39,32,105,115,32
	.byte 98,111,116,104,32,102,117,110
	.byte 99,116,105,111,110,32,110,97
	.byte 109,101,32,97,110,100,32,97
	.byte 114,103,117,109,101,110,116,32
	.byte 110,97,109,101,0
L78:
	.byte 37,115,32,105,115,32,97,32
	.byte 102,117,110,99,116,105,111,110
	.byte 44,32,110,111,116,32,97,110
	.byte 32,97,114,114,97,121,0
L7:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 110,111,100,101,97,108,108,111
	.byte 99,0
L92:
	.byte 108,105,109,105,116,101,100,32
	.byte 116,111,32,37,100,32,112,97
	.byte 116,44,112,97,116,32,115,116
	.byte 97,116,101,109,101,110,116,115
	.byte 0
.globl _pairstack
.comm _pairstack, 200, 4
.globl _paircnt
.comm _paircnt, 4, 4

.globl _defn
.globl _free
.globl _celltonode
.globl _makearr
.globl _paircnt
.globl _arglist
.globl _node2
.globl _isarg
.globl _node3
.globl _makesymtab
.globl _dbg
.globl _pairstack
.globl _malloc
.globl _stat4
.globl _SYNTAX
.globl _stat1
.globl _op3
.globl _errorflag
.globl _op2
.globl _exptostat
.globl _lineno
.globl _printf
.globl _ptoi
.globl _linkum
.globl _node4
.globl _stat3
.globl _strcmp
.globl _stat2
.globl _nodealloc
.globl _rectonode
.globl _op1
.globl _literal0
.globl _op4
.globl _itonp
.globl _pa2stat
.globl _FATAL
.globl _node1
