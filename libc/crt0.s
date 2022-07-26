##############################################################################
#
# crt0.s                                            tahoe/64 standard library
#
#    Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE file for details.
#
##############################################################################

.text

.global cstart
.global _exit

cstart:         popq %rdi                   # argc
                movq %rsp, %rsi             # argv
                leaq 8(%rsi,%rdi,8), %rdx   # envp

                movq %rdx, _environ(%rip)
                cld
                call _main

                movl %eax, %edi             # pass along main's
                call _exit                  # return value to exit()

.comm _environ, 8, 8

# vi: set ts=4 expandtab:
