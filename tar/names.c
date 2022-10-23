/*****************************************************************************

   names.c                                             ux/64 tape archiver

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from John Gilmore's public domain tar (USENET, Nov 1987)

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

#include <unistd.h>
#include <string.h>
#include "tar.h"

#ifndef NONAMES
/* Whole module goes away if NONAMES defined.  Otherwise... */
#include <pwd.h>
#include <grp.h>

static int  saveuid = -993;
static char saveuname[TUNMLEN];
static int  my_uid = -993;

static int  savegid = -993;
static char savegname[TGNMLEN];
static int  my_gid = -993;

#define myuid   ( my_uid < 0? (my_uid = getuid()): my_uid )
#define mygid   ( my_gid < 0? (my_gid = getgid()): my_gid )

/*
 * Look up a user or group name from a uid/gid, maintaining a cache.
 * FIXME, for now it's a one-entry cache.
 * FIXME2, the "-993" is to reduce the chance of a hit on the first lookup.
 *
 * This is ifdef'd because on Suns, it drags in about 38K of "yellow
 * pages" code, roughly doubling the program size.  Thanks guys.
 */
void
finduname(uname, uid)
    char    uname[TUNMLEN];
    int uid;
{
    struct passwd   *pw;
    extern struct passwd *getpwuid ();

    if (uid != saveuid) {
        saveuid = uid;
        saveuname[0] = '\0';
        pw = getpwuid(uid);
        if (pw)
            strncpy(saveuname, pw->pw_name, TUNMLEN);
    }
    strncpy(uname, saveuname, TUNMLEN);
}

int
finduid(char *uname)
{
    struct passwd   *pw;
    extern struct passwd *getpwnam();

    if (uname[0] != saveuname[0]    /* Quick test w/o proc call */
        || 0!=strncmp(uname, saveuname, TUNMLEN)) {
        strncpy(saveuname, uname, TUNMLEN);
        pw = getpwnam(uname);
        if (pw) {
            saveuid = pw->pw_uid;
        } else {
            saveuid = myuid;
        }
    }
    return saveuid;
}


void
findgname(gname, gid)
    char    gname[TGNMLEN];
    int gid;
{
    struct group    *gr;
    extern struct group *getgrgid ();

    if (gid != savegid) {
        savegid = gid;
        savegname[0] = '\0';
        setgrent();
        gr = getgrgid(gid);
        if (gr)
            strncpy(savegname, gr->gr_name, TGNMLEN);
    }
    (void) strncpy(gname, savegname, TGNMLEN);
}


int
findgid(char *gname)
{
    struct group    *gr;
    extern struct group *getgrnam();

    if (gname[0] != savegname[0]    /* Quick test w/o proc call */
        || 0!=strncmp(gname, savegname, TUNMLEN)) {
        strncpy(savegname, gname, TUNMLEN);
        gr = getgrnam(gname);
        if (gr) {
            savegid = gr->gr_gid;
        } else {
            savegid = mygid;
        }
    }
    return savegid;
}
#endif

/* vi: set ts=4 expandtab: */
