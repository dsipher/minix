##############################################################################
#
# __ieee_val.s                                      tahoe/64 standard library
#
#    Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.
#
##############################################################################

.text

.global ___huge_val
.global ___frexp_adj

.align 8

___huge_val:        .quad 0x7ff0000000000000        # infinity (double)
___frexp_adj:       .quad 0x6010000000000000        # 0x1.0p514

# vi: set ts=4 expandtab:
