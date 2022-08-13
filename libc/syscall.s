##############################################################################
#
#  syscall.s                                     tahoe/64 standard library
#
##############################################################################
#
#  Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
#  "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
#  LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
#  FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
#  COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
#  BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
#  OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
#  TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
#  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
##############################################################################

.comm _errno, 4, 4

.text

# void __exit(int status);

.global ___exit

___exit:        movl $60, %eax

                # fall though to syscall, which doesn't return. this
                # is an unnecessary trick to save a couple of bytes...

# common syscall code. invoke the syscall, then extract
# errno and set the return value to -1 if an error occurred.

do_syscall:     syscall
                testq %rax, %rax
                jns no_error

                neg %eax
                movl %eax, _errno
                movq $-1, %rax

no_error:       ret

# ssize_t read(int fd, void *buf, size_t count);

.global _read

_read:          xorl %eax, %eax
                jmp do_syscall

# ssize_t write(int fd, const void *buf, size_t count);

.global _write

_write:         movl $1, %eax
                jmp do_syscall

# int open(const char *path, int flags);
# int open(const char *path, int flags, mode_t mode);
#
# because of the multiple signtures, open() is declared
# variadic, so we must grab the arguments from the stack.

.global _open

_open:          movq 8(%rsp), %rdi          # path
                movq 16(%rsp), %rsi         # flags
                movq 24(%rsp), %rdx         # mode
                movl $2, %eax               # SYS_OPEN
                jmp do_syscall

# int close(int fd);

.global _close

_close:         movl $3, %eax               # SYS_CLOSE
                jmp do_syscall

# int fstat(int fd, struct stat *statbuf);

.global _fstat

_fstat:         movl $5, %eax               # SYS_FSTAT
                jmp do_syscall

# off_t lseek(int fd, off_t offset, int whence);

.global _lseek

_lseek:         movl $8, %eax
                jmp do_syscall

# void *mmap(void *addr, size_t length, int prot,
#            int flags, int fd, off_t offset);

.global _mmap

_mmap:          movl $9, %eax               # SYS_MMAP
                movq %rcx, %r10
                jmp do_syscall

# void *__brk(void *new);

.global ___brk

___brk:         movl $12, %eax
                jmp do_syscall

# int __sigaction(int sig, const struct sigaction *act,
#                         struct sigaction *oact);
#
# the linux system call is actually rt_sigaction, which takes a fourth
# size_t argument giving sizeof(sigset_t). for now it is fixed at 8. we
# wrap the system call in sigaction.c, which sets sa_restorer properly.

.global ___sigaction

___sigaction:   movl $13, %eax
                movl $8, %r10d
                jmp do_syscall

# void ___sigreturn(void);      /* does not return */

.global ___sigreturn

___sigreturn:   movl $15, %eax
                jmp do_syscall

# int ioctl(int fd, int request, const void *argp);
#
# the linux abi specifies unsigned long for request instead of int.
# we zap the most significant bits to conform to the posix prototype.

.global _ioctl

_ioctl:         movl $16, %eax
                movl %esi, %esi
                jmp do_syscall

# int access(const char *path, int amode);

.global _access

_access:        movl $21, %eax
                jmp do_syscall

# int getpid(void);

.global _getpid

_getpid:        movl $39, %eax
                jmp do_syscall

# pid_t fork(void);

.global _fork

_fork:          movl $57, %eax
                jmp do_syscall

# int execve(const char *pathname, char * const *argv, char * const *envp);

.global _execve

_execve:        movl $59, %eax
                jmp do_syscall

# pid_t waitpid(pid_t pid, int *wstatus, int options);
#
# linux uses a non-standard wait4() system call, which has an
# additional argument. we set that to NULL to get waitpid().

.global _waitpid

_waitpid:       movl $61, %eax
                xorl %r10d, %r10d
                jmp do_syscall

# int kill(pid_t pid, int sig);

.global _kill

_kill:          movl $62, %eax
                jmp do_syscall

# int rename(const char *old, const char *new);

.global _rename

_rename:        movl $82, %eax
                jmp do_syscall

# int creat(const char *pathname, mode_t mode);

.global _creat

_creat:         movl $85, %eax
                jmp do_syscall

# int unlink(const char *path);

.global _unlink

_unlink:        movl $87, %eax
                jmp do_syscall

# time_t time(time_t *timer);

.global _time

_time:          movl $201, %eax
                jmp do_syscall

# vi: set ts=4 expandtab:
