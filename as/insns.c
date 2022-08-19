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

struct insn i_aaa[]     =   { { I_NO_CODE64, 1, { 0x37 } }, { 0 } };
struct insn i_aas[]     =   { { I_NO_CODE64, 1, { 0x3F } }, { 0 } };

struct insn i_aad[] =
{
    { I_NO_CODE64, 1, { 0xD5       }, { { O_IMM_8 } } },
    { I_NO_CODE64, 2, { 0xD5, 0x0A }                  },
    { 0 }
};

struct insn i_aam[] =
{
    { I_NO_CODE64, 1, { 0xD4       }, { { O_IMM_8 } } },
    { I_NO_CODE64, 2, { 0xD4, 0x0A }                  },
    { 0 }
};

struct insn i_clc[]     =   { { 0, 1, { 0xF8 } }, { 0 } };
struct insn i_cld[]     =   { { 0, 1, { 0xFC } }, { 0 } };
struct insn i_cli[]     =   { { 0, 1, { 0xFA } }, { 0 } };
struct insn i_cmc[]     =   { { 0, 1, { 0xF5 } }, { 0 } };
struct insn i_hlt[]     =   { { 0, 1, { 0xF4 } }, { 0 } };
struct insn i_lock[]    =   { { 0, 1, { 0xF0 } }, { 0 } };
struct insn i_rep[]     =   { { 0, 1, { 0xF3 } }, { 0 } };
struct insn i_ret[]     =   { { 0, 1, { 0xC3 } }, { 0 } };
struct insn i_stc[]     =   { { 0, 1, { 0xF9 } }, { 0 } };
struct insn i_std[]     =   { { 0, 1, { 0xFD } }, { 0 } };
struct insn i_sti[]     =   { { 0, 1, { 0xFB } }, { 0 } };
struct insn i_xlat[]    =   { { 0, 1, { 0xD7 } }, { 0 } };

struct insn i_seg[] =
{
    { 0, 1, { 0x26 }, { { O_SEG_2, F_MID } } },
    { 0, 1, { 0x60 }, { { O_SEG_3, F_END } } },
    { 0 }
};

struct insn i_iret[]  = { { 0,         1, { 0xCF } }, { 0 } };
struct insn i_iretq[] = { { I_DATA_64, 1, { 0xCF } }, { 0 } };

struct insn i_jo[] =
{
    { 0,                            1, { 0x70       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x80 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x80 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jno[] =
{
    { 0,                            1, { 0x71       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x81 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x81 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jb[] =
{
    { 0,                            1, { 0x72       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x82 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x82 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnb[] =
{
    { 0,                            1, { 0x73       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x83 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x83 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_je[] =
{
    { 0,                            1, { 0x74       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x84 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x84 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jne[] =
{
    { 0,                            1, { 0x75       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x85 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x85 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jbe[] =
{
    { 0,                            1, { 0x76       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x86 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x86 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnbe[] =
{
    { 0,                            1, { 0x77       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x87 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x87 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_js[] =
{
    { 0,                            1, { 0x78       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x88 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x88 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jns[] =
{
    { 0,                            1, { 0x79       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x89 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x89 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jp[] =
{
    { 0,                            1, { 0x7A       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8A }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8A }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnp[] =
{
    { 0,                            1, { 0x7B       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8B }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8B }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jl[] =
{
    { 0,                            1, { 0x7C       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8C }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8C }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnl[] =
{
    { 0,                            1, { 0x7D       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8D }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8D }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jle[] =
{
    { 0,                            1, { 0x7E       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8E }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8E }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnle[] =
{
    { 0,                            1, { 0x7F       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8F }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8F }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_adcb[] =
{
    { 0,         1, { 0x14       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x10 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x10, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x12, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_adcw[] =
{
    { I_DATA_16, 2, { 0x83, 0x10 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x15       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x10 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x11, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x13, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_adcl[] =
{
    { I_DATA_32, 2, { 0x83, 0x10 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x15       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x10 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x11, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x13, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_adcq[] =
{
    { I_DATA_64, 2, { 0x83, 0x10 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x15       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x10 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x11, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x13, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_addb[] =
{
    { 0,         1, { 0x04       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x00, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x02, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_addw[] =
{
    { I_DATA_16, 2, { 0x83, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x05       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x01, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x03, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_addl[] =
{
    { I_DATA_32, 2, { 0x83, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x05       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x01, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x03, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_addq[] =
{
    { I_DATA_64, 2, { 0x83, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x05       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x01, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x03, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

/* vi: set ts=4 expandtab: */
