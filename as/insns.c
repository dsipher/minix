/*****************************************************************************

   insns.c                                              tahoe/64 assembler

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

#include "as.h"

struct insn i_clc[]     =   { { 0, 1, { 0xF8 } }, { 0 } };
struct insn i_cld[]     =   { { 0, 1, { 0xFC } }, { 0 } };
struct insn i_cli[]     =   { { 0, 1, { 0xFA } }, { 0 } };
struct insn i_cmc[]     =   { { 0, 1, { 0xF5 } }, { 0 } };
struct insn i_hlt[]     =   { { 0, 1, { 0xF4 } }, { 0 } };
struct insn i_lock[]    =   { { 0, 1, { 0xF0 } }, { 0 } };
struct insn i_rep[]     =   { { 0, 1, { 0xF3 } }, { 0 } };
struct insn i_stc[]     =   { { 0, 1, { 0xF9 } }, { 0 } };
struct insn i_std[]     =   { { 0, 1, { 0xFD } }, { 0 } };
struct insn i_sti[]     =   { { 0, 1, { 0xFB } }, { 0 } };
struct insn i_xlat[]    =   { { 0, 1, { 0xD7 } }, { 0 } };

struct insn i_jo[] =
{
    { 0,                            1,  {       0x70 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x80 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x80 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jno[] =
{
    { 0,                            1,  {       0x71 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x81 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x81 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jb[] =
{
    { 0,                            1,  {       0x72 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x82 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x82 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnb[] =
{
    { 0,                            1,  {       0x73 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x83 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x83 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_je[] =
{
    { 0,                            1,  {       0x74 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x84 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x84 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jne[] =
{
    { 0,                            1,  {       0x75 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x85 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x85 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jbe[] =
{
    { 0,                            1,  {       0x76 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x86 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x86 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnbe[] =
{
    { 0,                            1,  {       0x77 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x87 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x87 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_js[] =
{
    { 0,                            1,  {       0x78 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x88 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x88 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jns[] =
{
    { 0,                            1,  {       0x79 }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x89 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x89 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jp[] =
{
    { 0,                            1,  {       0x7A }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x8A }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x8A }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnp[] =
{
    { 0,                            1,  {       0x7B }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x8B }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x8B }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jl[] =
{
    { 0,                            1,  {       0x7C }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x8C }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x8C }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnl[] =
{
    { 0,                            1,  {       0x7D }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x8D }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x8D }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jle[] =
{
    { 0,                            1,  {       0x7E }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x8E }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x8E }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnle[] =
{
    { 0,                            1,  {       0x7F }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2,  { 0x0F, 0x8F }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2,  { 0x0F, 0x8F }, { { O_REL_16 } } },
    { 0 }
};

/* vi: set ts=4 expandtab: */
