/*****************************************************************************

   main.c                                                  jewel/os kernel

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#include <a.out.h>
#include <sys/boot.h>
#include <sys/cons.h>
#include <sys/page.h>
#include <sys/log.h>
#include <sys/user.h>
#include <sys/proc.h>
#include <sys/io.h>

caddr_t kernel_top;

#define KERNEL_AOUT     ((struct exec *) KERNEL_ADDR)

/* the BSP enters here after a brief bounce through
   the locore.s. we're in process 0, interrupts are
   disabled, and the first 2MB are identity-mapped. */

void
main(void)
{
    caddr_t bss;

    bss = N_BSSOFF(*KERNEL_AOUT) + KERNEL_ADDR;         /* clear the BSS */
    STOSQ((void *) bss, 0, KERNEL_AOUT->a_bss >> 3);    /* and compute */
    kernel_top += bss + KERNEL_AOUT->a_bss;             /* kernel_top. */
    kernel_top = PAGE_UP(kernel_top);           /* (must be whole pages) */

    /* zap the u. area and do minimal setup: we need u_locks because
       we'll access spinlocks. though we're identity-mapped right now,
       pginit() will keep these pages mapped as the u. area for proc[0].
       we don't have a proc[0] struct yet: the proc[] array is allocated
       by pginit(), which will set proc[0].p_ptl3 and u.u_procp, since
       it needs these fields to complete its own setup. boot spaghetti! */

    STOSQ(&u, 0, USER_PAGES * (PAGE_SIZE >> 3));
    u.u_locks = 1;  /* interrupts are disabled */

    cninit();
    pginit();

    /* finish manually crafting proc[0] here */

    swtch(&proc[0]);
    printf("survived swtch(&proc[0])\n");

    for (;;) ;
}

/* vi: set ts=4 expandtab: */
