.data
.align 8
_printname:
	.quad L1
	.quad L2
	.quad L3
	.quad L4
	.quad L5
	.quad L6
	.quad L7
	.quad L8
	.quad L9
	.quad L10
	.quad L11
	.quad L12
	.quad L13
	.quad L14
	.quad L15
	.quad L16
	.quad L17
	.quad L18
	.quad L19
	.quad L20
	.quad L21
	.quad L22
	.quad L23
	.quad L24
	.quad L25
	.quad L26
	.quad L27
	.quad L28
	.quad L29
	.quad L30
	.quad L31
	.quad L32
	.quad L33
	.quad L34
	.quad L35
	.quad L36
	.quad L37
	.quad L38
	.quad L39
	.quad L40
	.quad L41
	.quad L42
	.quad L43
	.quad L44
	.quad L45
	.quad L46
	.quad L47
	.quad L48
	.quad L49
	.quad L50
	.quad L51
	.quad L52
	.quad L53
	.quad L54
	.quad L55
	.quad L56
	.quad L57
	.quad L58
	.quad L59
	.quad L60
	.quad L61
	.quad L62
	.quad L63
	.quad L64
	.quad L65
	.quad L66
	.quad L67
	.quad L68
	.quad L69
	.quad L70
	.quad L71
	.quad L72
	.quad L73
	.quad L74
	.quad L75
	.quad L76
	.quad L77
	.quad L78
	.quad L79
	.quad L80
	.quad L81
	.quad L82
	.quad L83
	.quad L84
	.quad L85
	.quad L86
	.quad L87
	.quad L88
	.quad L89
	.quad L90
	.quad L91
	.quad L92
	.quad L93
.align 8
_proctab:
	.quad _nullproc
	.quad _program
	.quad _pastat
	.quad _dopa2
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _array
	.quad _matchop
	.quad _matchop
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _boolop
	.quad _boolop
	.quad _nullproc
	.quad _relop
	.quad _relop
	.quad _relop
	.quad _relop
	.quad _relop
	.quad _relop
	.quad _instat
	.quad _arg
	.quad _bltin
	.quad _jump
	.quad _closefile
	.quad _jump
	.quad _awkdelete
	.quad _dostat
	.quad _jump
	.quad _forstat
	.quad _nullproc
	.quad _sub
	.quad _gsub
	.quad _ifstat
	.quad _sindex
	.quad _nullproc
	.quad _matchop
	.quad _jump
	.quad _jump
	.quad _arith
	.quad _arith
	.quad _arith
	.quad _arith
	.quad _arith
	.quad _assign
	.quad _nullproc
	.quad _assign
	.quad _assign
	.quad _assign
	.quad _assign
	.quad _assign
	.quad _assign
	.quad _printstat
	.quad _awkprintf
	.quad _awksprintf
	.quad _nullproc
	.quad _intest
	.quad _condexpr
	.quad _incrdecr
	.quad _incrdecr
	.quad _incrdecr
	.quad _incrdecr
	.quad _nullproc
	.quad _nullproc
	.quad _getnf
	.quad _call
	.quad _nullproc
	.quad _nullproc
	.quad _nullproc
	.quad _awkgetline
	.quad _jump
	.quad _split
	.quad _substr
	.quad _whilestat
	.quad _cat
	.quad _boolop
	.quad _arith
	.quad _arith
	.quad _nullproc
	.quad _nullproc
	.quad _indirect
	.quad _nullproc
.local L97
.comm L97, 100, 1
.text

_tokname:
L94:
L95:
	cmpl $257,%edi
	jl L98
L101:
	cmpl $349,%edi
	jle L100
L98:
	pushq %rdi
	pushq $L105
	pushq $L97
	call _sprintf
	addq $24,%rsp
	movl $L97,%eax
	ret
L100:
	subl $257,%edi
	movslq %edi,%rax
	movq _printname(,%rax,8),%rax
L96:
	ret 

L73:
	.byte 80,82,69,68,69,67,82,0
L18:
	.byte 79,82,0
L50:
	.byte 78,69,88,84,70,73,76,69
	.byte 0
L38:
	.byte 68,69,76,69,84,69,0
L29:
	.byte 76,69,0
L21:
	.byte 80,76,85,83,0
L53:
	.byte 77,85,76,84,0
L20:
	.byte 81,85,69,83,84,0
L71:
	.byte 80,82,69,73,78,67,82,0
L15:
	.byte 67,67,76,0
L1:
	.byte 70,73,82,83,84,84,79,75
	.byte 69,78,0
L34:
	.byte 66,76,84,73,78,0
L7:
	.byte 78,76,0
L89:
	.byte 80,79,87,69,82,0
L64:
	.byte 80,82,73,78,84,0
L27:
	.byte 71,69,0
L54:
	.byte 68,73,86,73,68,69,0
L19:
	.byte 83,84,65,82,0
L43:
	.byte 83,85,66,0
L87:
	.byte 78,79,84,0
L3:
	.byte 80,65,83,84,65,84,0
L45:
	.byte 73,70,0
L25:
	.byte 65,80,80,69,78,68,0
L17:
	.byte 67,72,65,82,0
L36:
	.byte 67,76,79,83,69,0
L55:
	.byte 77,79,68,0
L4:
	.byte 80,65,83,84,65,84,50,0
L8:
	.byte 65,82,82,65,89,0
L28:
	.byte 71,84,0
L62:
	.byte 77,79,68,69,81,0
L70:
	.byte 80,79,83,84,73,78,67,82
	.byte 0
L83:
	.byte 83,80,76,73,84,0
L81:
	.byte 71,69,84,76,73,78,69,0
L74:
	.byte 86,65,82,0
L41:
	.byte 70,79,82,0
L6:
	.byte 88,69,78,68,0
L75:
	.byte 73,86,65,82,0
L86:
	.byte 67,65,84,0
L24:
	.byte 66,79,82,0
L76:
	.byte 86,65,82,78,70,0
L72:
	.byte 80,79,83,84,68,69,67,82
	.byte 0
L30:
	.byte 76,84,0
L32:
	.byte 73,78,0
L59:
	.byte 83,85,66,69,81,0
L11:
	.byte 77,65,84,67,72,79,80,0
L13:
	.byte 68,79,84,0
L39:
	.byte 68,79,0
L92:
	.byte 73,78,68,73,82,69,67,84
	.byte 0
L10:
	.byte 78,79,84,77,65,84,67,72
	.byte 0
L105:
	.byte 116,111,107,101,110,32,37,100
	.byte 0
L58:
	.byte 65,68,68,69,81,0
L42:
	.byte 70,85,78,67,0
L46:
	.byte 73,78,68,69,88,0
L66:
	.byte 83,80,82,73,78,84,70,0
L51:
	.byte 65,68,68,0
L79:
	.byte 83,84,82,73,78,71,0
L88:
	.byte 85,77,73,78,85,83,0
L61:
	.byte 68,73,86,69,81,0
L56:
	.byte 65,83,83,73,71,78,0
L48:
	.byte 77,65,84,67,72,70,67,78
	.byte 0
L52:
	.byte 77,73,78,85,83,0
L26:
	.byte 69,81,0
L85:
	.byte 87,72,73,76,69,0
L44:
	.byte 71,83,85,66,0
L77:
	.byte 67,65,76,76,0
L2:
	.byte 80,82,79,71,82,65,77,0
L69:
	.byte 67,79,78,68,69,88,80,82
	.byte 0
L60:
	.byte 77,85,76,84,69,81,0
L78:
	.byte 78,85,77,66,69,82,0
L82:
	.byte 82,69,84,85,82,78,0
L47:
	.byte 76,83,85,66,83,84,82,0
L37:
	.byte 67,79,78,84,73,78,85,69
	.byte 0
L65:
	.byte 80,82,73,78,84,70,0
L63:
	.byte 80,79,87,69,81,0
L91:
	.byte 73,78,67,82,0
L67:
	.byte 69,76,83,69,0
L35:
	.byte 66,82,69,65,75,0
L14:
	.byte 65,76,76,0
L80:
	.byte 82,69,71,69,88,80,82,0
L90:
	.byte 68,69,67,82,0
L12:
	.byte 70,73,78,65,76,0
L84:
	.byte 83,85,66,83,84,82,0
L33:
	.byte 65,82,71,0
L22:
	.byte 69,77,80,84,89,82,69,0
L93:
	.byte 76,65,83,84,84,79,75,69
	.byte 78,0
L9:
	.byte 77,65,84,67,72,0
L16:
	.byte 78,67,67,76,0
L23:
	.byte 65,78,68,0
L68:
	.byte 73,78,84,69,83,84,0
L49:
	.byte 78,69,88,84,0
L40:
	.byte 69,88,73,84,0
L5:
	.byte 88,66,69,71,73,78,0
L31:
	.byte 78,69,0
L57:
	.byte 65,83,71,78,79,80,0

.globl _nullproc
.globl _sprintf
.globl _printstat
.globl _relop
.globl _whilestat
.globl _substr
.globl _condexpr
.globl _array
.globl _dopa2
.globl _sindex
.globl _awkdelete
.globl _pastat
.globl _incrdecr
.globl _awksprintf
.globl _program
.globl _proctab
.globl _awkprintf
.globl _awkgetline
.globl _forstat
.globl _dostat
.globl _cat
.globl _boolop
.globl _indirect
.globl _arg
.globl _closefile
.globl _gsub
.globl _ifstat
.globl _intest
.globl _matchop
.globl _arith
.globl _call
.globl _split
.globl _assign
.globl _getnf
.globl _tokname
.globl _sub
.globl _jump
.globl _bltin
.globl _instat
