/*****************************************************************************

   clock.c                                                 jewel/os kernel

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

#include <sys/types.h>
#include <sys/io.h>
#include <sys/clock.h>

/* convert a byte in BCD format to binary. */

#define UNBCD(bcd)  ((((bcd) & 0xF0) >> 4) * 10 + ((bcd) & 0x0F))

/* howard hinnant's method for computing the number
   of days between the epoch (Jan 1 1970) and m/d/y. */

static int
hinnant(int y, int m, int d)
{
    unsigned    yoe, doy, doe;
    int         era;

    y -= (m <= 2);
    era = ((y >= 0) ? y : (y - 399)) / 400;
    yoe = y - era * 400;
    doy = (153 * (m + ((m > 2) ? -3 : 9)) + 2)/5 + d - 1;
    doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;

    return era * 146097 + ((int) doe) - 719468;
}

/* read the CMOS RTC and return the time as UNIX epoch time.
   this should only be called during system initialization,
   since it assumes interrupts are disabled and busy-waits
   for up to a second while waiting for the RTC to update,
   and we don't synchronize CMOS access. assumes RTC is UTC. */

#define SECOND          0           /* indices into state[] */
#define MINUTE          1
#define HOUR            2
#define DAY             3
#define MONTH           4
#define YEAR            5
#define STATUS_A        6
#define STATUS_B        7

#define A_BUSY          0x80        /* update in progress */
#define B_24HR          0x02        /* time is in 24-hour format */
#define B_BIN           0x01        /* values are binary (not BCD) */

#define CMOS_ADDR       0x70        /* CMOS address port */
#define CMOS_DATA       0x71        /* CMOS data window */

#define CMOS_SECOND     0           /* RTC addresses in CMOS */
#define CMOS_MINUTE     2
#define CMOS_HOUR       4
#define CMOS_DAY        7
#define CMOS_MONTH      8
#define CMOS_YEAR       9
#define CMOS_STATUS_A   10
#define CMOS_STATUS_B   11

#define READ_CMOS(addr)         ({                                          \
                                    /* 0x80 is the NMI disable */           \
                                    OUTB(CMOS_ADDR, (addr) | 0x80);         \
                                    INB(CMOS_DATA);                         \
                                })

time_t
readrtc(void)
{
    /* the RTC registers we want are not
       at contiguous addresses, so map 'em */

    static const char map[] = {     CMOS_SECOND,
                                    CMOS_MINUTE,
                                    CMOS_HOUR,
                                    CMOS_DAY,
                                    CMOS_MONTH,
                                    CMOS_YEAR,
                                    CMOS_STATUS_A,
                                    CMOS_STATUS_B    };

    /* if the RTC is in BCD format, these are the
       elements of state[] that are BCD-encoded */

    static const char bcd[] = {     SECOND,
                                    MINUTE,
                                    HOUR,
                                    DAY,
                                    MONTH,
                                    YEAR            };

    char state[sizeof(map)];    /* state (indexed by SECOND, HOUR, etc.) */
    time_t time;                /* epoch time */
    int pm;                     /* AM/PM (set if PM) */

    int i;

    /* we must read the clock when it's not updating. the
       easiest way to avoid races is to wait to observe an
       update, then read the state (within the next second).

       there are faster ways to synchronize, but this way
       back-to-back calls to readrtc() mark out one second,
       which is handy for clkinit(). */

    while (!(READ_CMOS(CMOS_STATUS_A) & A_BUSY)) ;  /* wait for update */
    while (READ_CMOS(CMOS_STATUS_A) & A_BUSY) ;     /* and let it finish */

    for (i = 0; i < sizeof(map); ++i) state[i] = READ_CMOS(map[i]);

    /* if the RTC is in 12-hour format, then bit 7 of HOUR
       is the AM/PM bit (set = PM). strip the bit for now. */

    if (state[STATUS_B] & B_24HR)
        pm = 0;
    else {
        pm = state[HOUR] & 0x80;
        state[HOUR] &= 0x7F;
    }

    /* and if the RTC is in BCD format, normalize as binary */

    if (!(state[STATUS_B] & B_BIN))
        for (i = 0; i < sizeof(bcd); ++i)
            state[bcd[i]] = UNBCD(state[bcd[i]]);

    if (pm) state[HOUR] += 12;      /* normalize to 24-hour clock */

    time = hinnant(2000 + state[YEAR], state[MONTH], state[DAY]);

    time *= 86400;
    time += state[HOUR] * 3600;
    time += state[MINUTE] * 60;
    time += state[SECOND];

    return time;
}

/* vi: set ts=4 expandtab: */
