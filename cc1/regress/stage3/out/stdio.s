.data
.align 8
___stdin:
	.int 0
	.int 0
	.int 1
	.int 0
	.quad 0
	.quad 0
.align 8
___stdout:
	.int 0
	.int 1
	.int 2
	.int 0
	.quad 0
	.quad 0
.align 8
___stderr:
	.int 0
	.int 2
	.int 66
	.int 0
	.quad 0
	.quad 0
.align 8
___iotab:
	.quad ___stdin
	.quad ___stdout
	.quad ___stderr
	.fill 136, 1, 0

.globl ___stdout
.globl ___stderr
.globl ___stdin
.globl ___iotab
