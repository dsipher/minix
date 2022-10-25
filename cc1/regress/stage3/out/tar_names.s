.data
.align 4
_saveuid:
	.int -993
.align 4
_my_uid:
	.int -993
.align 4
_savegid:
	.int -993
.align 4
_my_gid:
	.int -993
.text

_finduname:
L1:
	pushq %rbx
L2:
	movq %rdi,%rbx
	movl %esi,%edi
	cmpl _saveuid(%rip),%edi
	jz L6
L4:
	movl %edi,_saveuid(%rip)
	movb $0,_saveuname(%rip)
	call _getpwuid
	testq %rax,%rax
	jz L6
L7:
	movl $32,%edx
	movq (%rax),%rsi
	movl $_saveuname,%edi
	call _strncpy
L6:
	movl $32,%edx
	movl $_saveuname,%esi
	movq %rbx,%rdi
	call _strncpy
L3:
	popq %rbx
	ret 


_finduid:
L10:
	pushq %rbx
L11:
	movq %rdi,%rbx
	movb (%rbx),%al
	cmpb _saveuname(%rip),%al
	jnz L13
L16:
	movl $32,%edx
	movl $_saveuname,%esi
	movq %rbx,%rdi
	call _strncmp
	testl %eax,%eax
	jz L15
L13:
	movl $32,%edx
	movq %rbx,%rsi
	movl $_saveuname,%edi
	call _strncpy
	movq %rbx,%rdi
	call _getpwnam
	testq %rax,%rax
	jz L21
L20:
	movl 16(%rax),%eax
	jmp L27
L21:
	movl _my_uid(%rip),%eax
	cmpl $0,%eax
	jge L27
L23:
	call _getuid
	movl %eax,_my_uid(%rip)
L27:
	movl %eax,_saveuid(%rip)
L15:
	movl _saveuid(%rip),%eax
L12:
	popq %rbx
	ret 


_findgname:
L28:
	pushq %rbx
	pushq %r12
L29:
	movq %rdi,%r12
	movl %esi,%ebx
	cmpl _savegid(%rip),%ebx
	jz L33
L31:
	movl %ebx,_savegid(%rip)
	movb $0,_savegname(%rip)
	call _setgrent
	movl %ebx,%edi
	call _getgrgid
	testq %rax,%rax
	jz L33
L34:
	movl $32,%edx
	movq (%rax),%rsi
	movl $_savegname,%edi
	call _strncpy
L33:
	movl $32,%edx
	movl $_savegname,%esi
	movq %r12,%rdi
	call _strncpy
L30:
	popq %r12
	popq %rbx
	ret 


_findgid:
L37:
	pushq %rbx
L38:
	movq %rdi,%rbx
	movb (%rbx),%al
	cmpb _savegname(%rip),%al
	jnz L40
L43:
	movl $32,%edx
	movl $_savegname,%esi
	movq %rbx,%rdi
	call _strncmp
	testl %eax,%eax
	jz L42
L40:
	movl $32,%edx
	movq %rbx,%rsi
	movl $_savegname,%edi
	call _strncpy
	movq %rbx,%rdi
	call _getgrnam
	testq %rax,%rax
	jz L48
L47:
	movl 16(%rax),%eax
	jmp L54
L48:
	movl _my_gid(%rip),%eax
	cmpl $0,%eax
	jge L54
L50:
	call _getgid
	movl %eax,_my_gid(%rip)
L54:
	movl %eax,_savegid(%rip)
L42:
	movl _savegid(%rip),%eax
L39:
	popq %rbx
	ret 

.local _saveuname
.comm _saveuname, 32, 1
.local _savegname
.comm _savegname, 32, 1

.globl _finduid
.globl _findgid
.globl _finduname
.globl _strncpy
.globl _findgname
.globl _getuid
.globl _getgid
.globl _setgrent
.globl _strncmp
.globl _getgrnam
.globl _getgrgid
.globl _getpwuid
.globl _getpwnam
