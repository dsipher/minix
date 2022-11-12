/*****************************************************************************

   main.c                                                     ux/64 kernel

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

#include <sys/boot.h>
#include <sys/cons.h>
#include <sys/page.h>
#include <sys/log.h>
#include <sys/user.h>
#include <sys/proc.h>
#include <sys/io.h>
#include <sys/apic.h>
#include <sys/clock.h>
#include <sys/utsname.h>
#include <sys/spin.h>
#include <sys/buf.h>
#include <sys/inode.h>
#include <sys/dev.h>
#include "config.h"

struct inode *rootdir;      /* system root directory */
caddr_t kernel_top;         /* top of kernel image */

/* used to keep CPUs in lockstep during boot */

static spinlock_t boot_lock = SPINLOCK_LOCKED;

/* every CPU eventually ends up here during initialization
   (the BSP last). we start the local scheduling timer and
   then release the boot_lock; this release not only allows
   boot to proceed but enables interrupts on the current cpu */

static void
idle(void)
{
    printf(" %d", CURCPU);
    CURPROC->p_flags |= P_FLAG_IDLE;

    tmrinit();
    release(&boot_lock);

    for (;;) __asm("hlt");
}

/* process 1. this will complete system initialization
   with the scheduler running and eventually disappear
   into userland /bin/init. we come alive holding the
   sched_lock: see child() in proc.c for more details. */

#define DEVINIT(n, tab)                                                     \
    do {                                                                    \
        struct tab  *_devsw = (tab);                                        \
        int         _i      = (n);                                          \
                                                                            \
        for (; _i; --_i, ++_devsw) _devsw->d_init();                        \
    } while (0)

static void
init(void)
{
    dev_t rootdev = boot_config.rootdev;

    release(&sched_lock);
    printf(".\n\n");

    DEVINIT(NBLKDEV, bdevsw);
    DEVINIT(NCHRDEV, cdevsw);

    /* mount the root filesystem. grab a reference to
       its root directory for future name lookups. */

    mount(boot_config.rootdev, 0);
    if (u.u_errno) panic("root fs");
    rootdir  = iget(rootdev, FS_ROOT_INO, 0); irelse(rootdir);
    u.u_cdir = iget(rootdev, FS_ROOT_INO, 0); irelse(u.u_cdir);

    for (;;) {
        sleep(&lbolt, P_STATE_COMA, 0);
        printf(".\7"); /* heartbeat */
    }
}

/* the BSP enters here after a brief bounce through
   the locore.s. we're in process 0, interrupts are
   disabled, and the first 2MB are identity-mapped. */

void
main(void)
{
    struct proc *initp;
    caddr_t bss;
    int cpu;

    bss = N_BSSOFF(*KERNEL_EXEC) + KERNEL_ADDR;         /* clear the BSS */
    STOSQ((void *) bss, 0, KERNEL_EXEC->a_bss >> 3);    /* and compute */
    kernel_top += bss + KERNEL_EXEC->a_bss;             /* kernel_top. */
    kernel_top = PAGE_UP(kernel_top);           /* (must be whole pages) */

    boot_config.irqhook = irqhook;

    /* zap the u. area and do minimal setup: we need u_locks because
       we'll access spinlocks. though we're identity-mapped right now,
       pginit() will keep these pages mapped as the u. area for proc[0].
       we don't have a proc[0] struct yet: the proc[] array is allocated
       by pginit(), which will set proc[0].p_ptl3 and u.u_procp, since
       it needs these fields to complete its own setup. boot spaghetti! */

    STOSQ(&u, 0, USER_PAGES * (PAGE_SIZE >> 3));

    /* interrupts are disabled and
       we're holding boot_lock */

    u.u_locks = 1;

    cninit();

    printf("\n%s %s %s [%d text/%d data/%d bss]\n", utsname.sysname,
                                                    utsname.release,
                                                    utsname.version,
                                                    KERNEL_EXEC->a_text,
                                                    KERNEL_EXEC->a_data,
                                                    KERNEL_EXEC->a_bss);

    pginit();
    bufinit();
    inoinit();
    irqinit();
    clkinit();

    /* the BSP APIC ID must be 0. this is a simplifying assumption we
       use everywhere, and it's true every `reasonable' system. (ux/64
       is not 100% symmetric; in particular, the BSP fields all IRQs.) */

    if (CURCPU != 0) panic("bsp");

    /* conventionally, `init' is always process 1, so create first. */

    initp = newproc(init);
    if (initp == 0) panic("initp");

    /* spin up the APs. use the procedure in intel's multiprocessor
       specification 1.4, which still works, though it may be overly
       conservative. in particular, it's unclear if we still need to
       repeat the STARTUP_IPI- is its delivery still unreliable?

       the BSP holds the boot_lock when spinning up each AP, and each
       AP releases it when ready in idle(). reacquiring boot_lock at
       the end of the loop forces us to wait. since the spinlock is
       acquired in one context and released in another, u_locks gets
       skewed, and we must manually correct with unlock(). */

    printf(", %d CPU(s):", NCPU);

    for (cpu = 1; cpu < NCPU; ++cpu) {
        struct proc *idlep;

        idlep = newproc(0);
        if (idlep == 0) panic("idlep");

        boot_config.entry = idle;
        boot_config.entry_ptl3 = idlep->p_ptl3;

        LAPIC_ICR1 = cpu << 24;
        LAPIC_ICR0 = INIT_IPI; udelay(200);
        LAPIC_ICR0 = STARTUP_IPI; udelay(200);
        LAPIC_ICR0 = STARTUP_IPI;
        acquire(&boot_lock);
        unlock();
    }

    /* we've exited the above loop still holding boot_lock;
       we'll release it in idle() just like the APs do. */

    run(initp);
    idle();
}

/* vi: set ts=4 expandtab: */
