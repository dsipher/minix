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

struct insn i_aas[]     =   { { I_NO_CODE64, 1, { 0x3F } }, { 0 } };

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

struct insn i_addss[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x58, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_addsd[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x58, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_andb[] =
{
    { 0,         1, { 0x24       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x20 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x20, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x22, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_andw[] =
{
    { I_DATA_16, 2, { 0x83, 0x20 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x25       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x20 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x21, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x23, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_andl[] =
{
    { I_DATA_32, 2, { 0x83, 0x20 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x25       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x20 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x21, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x23, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_andq[] =
{
    { I_DATA_64, 2, { 0x83, 0x20 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x25       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x20 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x21, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x23, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_bsfw[] =
{
    { I_DATA_16, 3, { 0x0F, 0xBC, 0x00 }, { { O_GPR_16, F_MID           },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_bsfl[] =
{
    { I_DATA_32, 3, { 0x0F, 0xBC, 0x00 }, { { O_GPR_32, F_MID           },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_bsfq[] =
{
    { I_DATA_64, 3, { 0x0F, 0xBC, 0x00 }, { { O_GPR_64, F_MID           },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_bsrw[] =
{
    { I_DATA_16, 3, { 0x0F, 0xBD, 0x00 }, { { O_GPR_16, F_MID           },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_bsrl[] =
{
    { I_DATA_32, 3, { 0x0F, 0xBD, 0x00 }, { { O_GPR_32, F_MID           },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_bsrq[] =
{
    { I_DATA_64, 3, { 0x0F, 0xBD, 0x00 }, { { O_GPR_64, F_MID           },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_call[] =
{
    { I_NO_CODE32 | I_NO_CODE64, 1, { 0xE8 }, { { O_REL_16 } } },
    { I_NO_CODE16,               1, { 0xE8 }, { { O_REL_32 } } },

    { I_DATA_16,     2, { 0xFF, 0x10 }, { { O_GPR_16, F_MODRM } } },

    { I_DATA_32   |
      I_NO_CODE64,   2, { 0xFF, 0x10 }, { { O_GPR_32, F_MODRM } } },

    { I_DATA_16   |
      I_NO_CODE32 |
      I_NO_CODE64,   2, { 0xFF, 0x10 }, { { O_MEM, F_MODRM } } },

    { I_DATA_32   |
      I_NO_CODE16 |
      I_NO_CODE64,   2, { 0xFF, 0x10 }, { { O_MEM, F_MODRM } } },

    { I_DATA_64 |
      I_NO_REX,      2, { 0xFF, 0x10 }, { { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_cbtw[] = { { I_DATA_16, 1, { 0x98 } }, { 0 } };

struct insn i_clc[]     =   { { 0, 1, { 0xF8 } }, { 0 } };
struct insn i_cld[]     =   { { 0, 1, { 0xFC } }, { 0 } };
struct insn i_cli[]     =   { { 0, 1, { 0xFA } }, { 0 } };

struct insn i_cltd[] = { { I_DATA_32, 1, { 0x99 } }, { 0 } };

struct insn i_cmc[]     =   { { 0, 1, { 0xF5 } }, { 0 } };

struct insn i_cmovbw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x42, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovbl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x42, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovbq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x42, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovbew[] =
{
    { I_DATA_16, 3, { 0x0F, 0x46, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovbel[] =
{
    { I_DATA_32, 3, { 0x0F, 0x46, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovbeq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x46, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovlw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x4C, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovll[] =
{
    { I_DATA_32, 3, { 0x0F, 0x4C, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovlq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x4C, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovlew[] =
{
    { I_DATA_16, 3, { 0x0F, 0x4E, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovlel[] =
{
    { I_DATA_32, 3, { 0x0F, 0x4E, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovleq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x4E, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnbw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x43, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnbl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x43, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnbq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x43, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnbew[] =
{
    { I_DATA_16, 3, { 0x0F, 0x47, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnbel[] =
{
    { I_DATA_32, 3, { 0x0F, 0x47, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnbeq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x47, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnlw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x4D, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnll[] =
{
    { I_DATA_32, 3, { 0x0F, 0x4D, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnlq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x4D, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnlew[] =
{
    { I_DATA_16, 3, { 0x0F, 0x4F, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnlel[] =
{
    { I_DATA_32, 3, { 0x0F, 0x4F, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnleq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x4F, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnow[] =
{
    { I_DATA_16, 3, { 0x0F, 0x41, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnol[] =
{
    { I_DATA_32, 3, { 0x0F, 0x41, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnoq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x41, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnpw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x4B, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnpl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x4B, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnpq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x4B, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnsw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x49, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnsl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x49, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnsq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x49, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnzw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x45, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnzl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x45, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovnzq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x45, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovow[] =
{
    { I_DATA_16, 3, { 0x0F, 0x40, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovol[] =
{
    { I_DATA_32, 3, { 0x0F, 0x40, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovoq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x40, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovpw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x4A, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovpl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x4A, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovpq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x4A, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovsw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x48, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovsl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x48, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovsq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x48, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovzw[] =
{
    { I_DATA_16, 3, { 0x0F, 0x44, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovzl[] =
{
    { I_DATA_32, 3, { 0x0F, 0x44, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmovzq[] =
{
    { I_DATA_64, 3, { 0x0F, 0x44, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cmpb[] =
{
    { 0,         1, { 0x3C       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x38 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x38, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x3A, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_cmpw[] =
{
    { I_DATA_16, 2, { 0x83, 0x38 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x3D       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x38 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x39, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x3B, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_cmpl[] =
{
    { I_DATA_32, 2, { 0x83, 0x38 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x3D       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x38 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x39, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x3B, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_cmpq[] =
{
    { I_DATA_64, 2, { 0x83, 0x38 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x3D       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x38 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x39, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x3B, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_cmpsb[] = { { 0,         1, { 0xA6 } }, { 0 } };
struct insn i_cmpsw[] = { { I_DATA_16, 1, { 0xA7 } }, { 0 } };
struct insn i_cmpsl[] = { { I_DATA_32, 1, { 0xA7 } }, { 0 } };
struct insn i_cmpsq[] = { { I_DATA_64, 1, { 0xA7 } }, { 0 } };

struct insn i_cqto[] = { { I_DATA_64, 1, { 0x99 } }, { 0 } };

struct insn i_cvtss2sd[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x5A, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvtsd2ss[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x5A, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvtsi2ssl[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x2A, 0x00 }, { { O_XMM,            F_MID   },
                                          { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvtsi2ssq[] =
{
    { I_PREFIX_F3 |
      I_DATA_64, 3, { 0x0F, 0x2A, 0x00 }, { { O_XMM,            F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvtsi2sdl[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x2A, 0x00 }, { { O_XMM,            F_MID   },
                                          { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvtsi2sdq[] =
{
    { I_PREFIX_F2 |
      I_DATA_64, 3, { 0x0F, 0x2A, 0x00 }, { { O_XMM,            F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvttss2sil[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x2C, 0x00 }, { { O_GPR_32,      F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvttss2siq[] =
{
    { I_PREFIX_F3 |
      I_DATA_64,  3, { 0x0F, 0x2C, 0x00 }, { { O_GPR_64,      F_MID   },
                                             { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvttsd2sil[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x2C, 0x00 }, { { O_GPR_32,      F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cvttsd2siq[] =
{
    { I_PREFIX_F2 |
      I_DATA_64,  3, { 0x0F, 0x2C, 0x00 }, { { O_GPR_64,      F_MID   },
                                             { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_cwtd[] = { { I_DATA_16, 1, { 0x99 } }, { 0 } };

struct insn i_decb[] =
{
    { 0, 2, { 0xFE, 0x08 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_decw[] =
{
    { I_DATA_16 | I_NO_CODE64, 1, { 0x48       }, { { O_GPR_16, F_END } } },

    { I_DATA_16,               2, { 0xFF, 0x08 }, { { O_GPR_16 | O_MEM,
                                                      F_MODRM } } },

    { 0 }
};

struct insn i_decl[] =
{
    { I_DATA_32 | I_NO_CODE64, 1, { 0x48       }, { { O_GPR_32, F_END } } },

    { I_DATA_32,               2, { 0xFF, 0x08 }, { { O_GPR_32 | O_MEM,
                                                      F_MODRM } } },

    { 0 }
};

struct insn i_decq[] =
{
    { I_DATA_64, 2, { 0xFF, 0x08 }, { { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_divb[] =
{
    { 0, 2, { 0xF6, 0x30 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_divw[] =
{
    { I_DATA_16, 2, { 0xF7, 0x30 }, { { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_divl[] =
{
    { I_DATA_32, 2, { 0xF7, 0x30 }, { { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_divq[] =
{
    { I_DATA_64, 2, { 0xF7, 0x30 }, { { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_divss[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x5E, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_divsd[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x5E, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_hlt[]     =   { { 0, 1, { 0xF4 } }, { 0 } };

struct insn i_idivb[] =
{
    { 0, 2, { 0xF6, 0x38 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_idivw[] =
{
    { I_DATA_16, 2, { 0xF7, 0x38 }, { { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_idivl[] =
{
    { I_DATA_32, 2, { 0xF7, 0x38 }, { { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_idivq[] =
{
    { I_DATA_64, 2, { 0xF7, 0x38 }, { { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_imulb[] =
{
    { 0, 2, { 0xF6, 0x28 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_imulw[] =
{
    { I_DATA_16, 2, { 0xF7, 0x28 }, { { O_GPR_16 | O_MEM, F_MODRM } } },

    { I_DATA_16, 3, { 0x0F, 0xAF, 0x00 }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },

    { I_DATA_16, 2, { 0x6B, 0x00       }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM },
                                            { O_IMM_S8                  } } },

    { I_DATA_16, 2, { 0x69, 0x00       }, { { O_GPR_16,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM },
                                            { O_IMM_16                  } } },

    { 0 }
};

struct insn i_imull[] =
{
    { I_DATA_32, 2, { 0xF7, 0x28 }, { { O_GPR_32 | O_MEM, F_MODRM } } },

    { I_DATA_32, 3, { 0x0F, 0xAF, 0x00 }, { { O_GPR_32,         F_MID },
                                            { O_GPR_32 | O_MEM, F_MODRM } } },

    { I_DATA_32, 2, { 0x6B, 0x00       }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM },
                                            { O_IMM_S8                  } } },

    { I_DATA_32, 2, { 0x69, 0x00       }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_32 | O_MEM, F_MODRM },
                                            { O_IMM_32                  } } },

    { 0 }
};

struct insn i_imulq[] =
{
    { I_DATA_64, 2, { 0xF7, 0x28 }, { { O_GPR_64 | O_MEM, F_MODRM } } },

    { I_DATA_64, 3, { 0x0F, 0xAF, 0x00 }, { { O_GPR_64,         F_MID },
                                            { O_GPR_64 | O_MEM, F_MODRM } } },

    { I_DATA_64, 2, { 0x6B, 0x00       }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM },
                                            { O_IMM_S8                  } } },

    { I_DATA_64, 2, { 0x69, 0x00       }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_64 | O_MEM, F_MODRM },
                                            { O_IMM_S32                 } } },

    { 0 }
};

struct insn i_incb[] =
{
    { 0, 2, { 0xFE, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_incw[] =
{
    { I_DATA_16 | I_NO_CODE64, 1, { 0x40       }, { { O_GPR_16, F_END } } },

    { I_DATA_16,               2, { 0xFF, 0x00 }, { { O_GPR_16 | O_MEM,
                                                      F_MODRM } } },

    { 0 }
};

struct insn i_incl[] =
{
    { I_DATA_32 | I_NO_CODE64, 1, { 0x40       }, { { O_GPR_32, F_END } } },

    { I_DATA_32,               2, { 0xFF, 0x00 }, { { O_GPR_32 | O_MEM,
                                                      F_MODRM } } },

    { 0 }
};

struct insn i_incq[] =
{
    { I_DATA_64, 2, { 0xFF, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_iret[]  =
{
    { I_NO_CODE64, 1, { 0xCF } },       /* no REX if not in long mode */
    { I_DATA_64,   1, { 0xCF } },       /* but always a REX in long mode */
    { 0 }
};

struct insn i_jb[] =
{
    { 0,                            1, { 0x72       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x82 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x82 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jbe[] =
{
    { 0,                            1, { 0x76       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x86 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x86 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_je[] =
{
    { 0,                            1, { 0x74       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x84 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x84 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jl[] =
{
    { 0,                            1, { 0x7C       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8C }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8C }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jle[] =
{
    { 0,                            1, { 0x7E       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8E }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8E }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jmp[] =
{
    { 0, 1, { 0xEB }, { { O_REL_8 } } },

    { I_NO_CODE32 | I_NO_CODE64, 1, { 0xE9 }, { { O_REL_16 } } },
    { I_NO_CODE16,               1, { 0xE9 }, { { O_REL_32 } } },

    { I_DATA_16,     2, { 0xFF, 0x20 }, { { O_GPR_16, F_MODRM } } },

    { I_DATA_32   |
      I_NO_CODE64,   2, { 0xFF, 0x20 }, { { O_GPR_32, F_MODRM } } },

    { I_DATA_16   |
      I_NO_CODE32 |
      I_NO_CODE64,   2, { 0xFF, 0x20 }, { { O_MEM, F_MODRM } } },

    { I_DATA_32   |
      I_NO_CODE16 |
      I_NO_CODE64,   2, { 0xFF, 0x20 }, { { O_MEM, F_MODRM } } },

    { I_DATA_64 |
      I_NO_REX,      2, { 0xFF, 0x20 }, { { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_jnb[] =
{
    { 0,                            1, { 0x73       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x83 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x83 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnbe[] =
{
    { 0,                            1, { 0x77       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x87 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x87 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jne[] =
{
    { 0,                            1, { 0x75       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x85 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x85 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnl[] =
{
    { 0,                            1, { 0x7D       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8D }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8D }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnle[] =
{
    { 0,                            1, { 0x7F       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8F }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8F }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jno[] =
{
    { 0,                            1, { 0x71       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x81 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x81 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jnp[] =
{
    { 0,                            1, { 0x7B       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8B }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8B }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jns[] =
{
    { 0,                            1, { 0x79       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x89 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x89 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jo[] =
{
    { 0,                            1, { 0x70       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x80 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x80 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_jp[] =
{
    { 0,                            1, { 0x7A       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x8A }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x8A }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_js[] =
{
    { 0,                            1, { 0x78       }, { { O_REL_8  } } },
    { I_NO_CODE16,                  2, { 0x0F, 0x88 }, { { O_REL_32 } } },
    { I_NO_CODE32 | I_NO_CODE64,    2, { 0x0F, 0x88 }, { { O_REL_16 } } },
    { 0 }
};

struct insn i_leaw[] =
{
    { I_DATA_16,    2, { 0x8D, 0x00 }, { { O_GPR_16, F_MID   },
                                         { O_MEM,    F_MODRM } } },
    { 0 }
};

struct insn i_leal[] =
{
    { I_DATA_32,    2, { 0x8D, 0x00 }, { { O_GPR_32, F_MID   },
                                         { O_MEM,    F_MODRM } } },
    { 0 }
};

struct insn i_leaq[] =
{
    { I_DATA_64,    2, { 0x8D, 0x00 }, { { O_GPR_64, F_MID   },
                                         { O_MEM,    F_MODRM } } },
    { 0 }
};

struct insn i_lock[]    =   { { 0, 1, { 0xF0 } }, { 0 } };

struct insn i_lodsb[] = { { 0,         1, { 0xAC } }, { 0 } };
struct insn i_lodsw[] = { { I_DATA_16, 1, { 0xAD } }, { 0 } };
struct insn i_lodsl[] = { { I_DATA_32, 1, { 0xAD } }, { 0 } };
struct insn i_lodsq[] = { { I_DATA_64, 1, { 0xAD } }, { 0 } };

struct insn i_movsb[] = { { 0,         1, { 0xA4 } }, { 0 } };
struct insn i_movsw[] = { { I_DATA_16, 1, { 0xA5 } }, { 0 } };
struct insn i_movsl[] = { { I_DATA_32, 1, { 0xA5 } }, { 0 } };
struct insn i_movsq[] = { { I_DATA_64, 1, { 0xA5 } }, { 0 } };

struct insn i_movss[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x10, 0x00 }, { { O_XMM,         F_MID },
                                              { O_XMM | O_MEM, F_MODRM } } },

    { I_PREFIX_F3, 3, { 0x0F, 0x11, 0x00 }, { { O_XMM | O_MEM, F_MODRM },
                                              { O_XMM,         F_MID   } } },

    { 0 }
};

struct insn i_movsd[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x10, 0x00 }, { { O_XMM,         F_MID },
                                              { O_XMM | O_MEM, F_MODRM } } },

    { I_PREFIX_F2, 3, { 0x0F, 0x11, 0x00 }, { { O_XMM | O_MEM, F_MODRM },
                                              { O_XMM,         F_MID   } } },

    { 0 }
};

struct insn i_movb[] =
{
    { 0, 2, { 0x88, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_GPR_8,         F_MID   } } },

    { 0, 2, { 0x8A, 0x00 }, { { O_GPR_8,         F_MID   },
                              { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0, 1, { 0xB0       }, { { O_GPR_8,         F_END   },
                              { O_IMM_8                  } } },

    { 0, 2, { 0xC6, 0x00 }, { { O_MEM,           F_MODRM },
                              { O_IMM_8                  } } },

    { 0 }
};

struct insn i_movl[] =
{
    { I_DATA_32, 2, { 0x89, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_GPR_32,         F_MID   } } },

    { I_DATA_32, 2, { 0x8B, 0x00 }, { { O_GPR_32,         F_MID   },
                                      { O_GPR_32 | O_MEM, F_MODRM } } },

    { I_DATA_32, 1, { 0xB8       }, { { O_GPR_32,         F_END   },
                                      { O_IMM_32                  } } },

    { I_DATA_32, 2, { 0xC7, 0x00 }, { { O_MEM,            F_MODRM },
                                      { O_IMM_32                  } } },

    { I_DATA_32, 2, { 0x8C, 0x00 }, { { O_GPR_32 | O_MEM,  F_MODRM },
                                      { O_SEG_2 | O_SEG_3, F_MID   } } },

    { 0 }
};

struct insn i_movq[] =
{
    { I_DATA_64, 2, { 0x89, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64,         F_MID   } } },

    { I_DATA_64, 2, { 0x8B, 0x00 }, { { O_GPR_64,         F_MID   },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { I_DATA_64, 2, { 0xC7, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 1, { 0xB8       }, { { O_GPR_64,         F_END   },
                                      { O_IMM_64                  } } },

    { I_DATA_64, 2, { 0x8C, 0x00 }, { { O_GPR_64 | O_MEM,  F_MODRM },
                                      { O_SEG_2 | O_SEG_3, F_MID   } } },

    { 0 }
};

struct insn i_movsbw[] =
{
    { I_DATA_16, 3, { 0x0F, 0xBE, 0x00 }, { { O_GPR_16,        F_MID   },
                                            { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movsbl[] =
{
    { I_DATA_32, 3, { 0x0F, 0xBE, 0x00 }, { { O_GPR_32,        F_MID   },
                                            { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movsbq[] =
{
    { I_DATA_64, 3, { 0x0F, 0xBE, 0x00 }, { { O_GPR_64,        F_MID   },
                                            { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movslq[] =
{
    { I_DATA_64, 2, { 0x63, 0x00 }, { { O_GPR_64,         F_MID },
                                      { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movswl[] =
{
    { I_DATA_32, 3, { 0x0F, 0xBF, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movswq[] =
{
    { I_DATA_64, 3, { 0x0F, 0xBF, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movw[] =
{
    { I_DATA_16, 2, { 0x89, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_GPR_16,         F_MID   } } },

    { I_DATA_16, 2, { 0x8B, 0x00 }, { { O_GPR_16,         F_MID   },
                                      { O_GPR_16 | O_MEM, F_MODRM } } },

    { I_DATA_16, 1, { 0xB8       }, { { O_GPR_16,         F_END   },
                                      { O_IMM_16                  } } },

    { I_DATA_16, 2, { 0xC7, 0x00 }, { { O_MEM,            F_MODRM },
                                      { O_IMM_16                  } } },

    { I_DATA_16, 2, { 0x8C, 0x00 }, { { O_GPR_16 | O_MEM,  F_MODRM },
                                      { O_SEG_2 | O_SEG_3, F_MID   } } },

    { 0, 2, { 0x8E, 0x00 }, { { O_SEG_2 | O_SEG_3 | O_NOT_CS, F_MID   },
                              { O_GPR_16 | O_MEM,             F_MODRM } } },

    { 0 }
};

struct insn i_movzbw[] =
{
    { I_DATA_16, 3, { 0x0F, 0xB6, 0x00 }, { { O_GPR_16,        F_MID   },
                                            { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movzbl[] =
{
    { I_DATA_32, 3, { 0x0F, 0xB6, 0x00 }, { { O_GPR_32,        F_MID   },
                                            { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movzbq[] =
{
    { I_DATA_64, 3, { 0x0F, 0xB6, 0x00 }, { { O_GPR_64,        F_MID   },
                                            { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movzwl[] =
{
    { I_DATA_32, 3, { 0x0F, 0xB7, 0x00 }, { { O_GPR_32,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_movzwq[] =
{
    { I_DATA_64, 3, { 0x0F, 0xB7, 0x00 }, { { O_GPR_64,         F_MID   },
                                            { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_mulb[] =
{
    { 0, 2, { 0xF6, 0x20 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_mulw[] =
{
    { I_DATA_16, 2, { 0xF7, 0x20 }, { { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_mull[] =
{
    { I_DATA_32, 2, { 0xF7, 0x20 }, { { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_mulq[] =
{
    { I_DATA_64, 2, { 0xF7, 0x20 }, { { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_mulss[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x59, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_mulsd[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x59, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_negb[] =
{
    { 0, 2, { 0xF6, 0x18 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_negw[] =
{
    { I_DATA_16, 2, { 0xF7, 0x18 }, { { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_negl[] =
{
    { I_DATA_32, 2, { 0xF7, 0x18 }, { { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_negq[] =
{
    { I_DATA_64, 2, { 0xF7, 0x18 }, { { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_notb[] =
{
    { 0, 2, { 0xF6, 0x10 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_notw[] =
{
    { I_DATA_16, 2, { 0xF7, 0x10 }, { { O_GPR_16 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_notl[] =
{
    { I_DATA_32, 2, { 0xF7, 0x10 }, { { O_GPR_32 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_notq[] =
{
    { I_DATA_64, 2, { 0xF7, 0x10 }, { { O_GPR_64 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_orb[] =
{
    { 0,         1, { 0x0C       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x08 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x08, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x0A, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_orw[] =
{
    { I_DATA_16, 2, { 0x83, 0x08 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x0D       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x08 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x09, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x0B, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_orl[] =
{
    { I_DATA_32, 2, { 0x83, 0x08 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x0D       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x08 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x09, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x0B, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_orq[] =
{
    { I_DATA_64, 2, { 0x83, 0x08 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x0D       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x08 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x09, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x0B, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_popw[] =
{
    { I_DATA_16,   1, { 0x58       }, { { O_GPR_16, F_END    } } },
    { I_DATA_16,   2, { 0x8F, 0x00 }, { { O_MEM,    F_MODRM  } } },
    { I_DATA_16,   2, { 0x0F, 0x81 }, { { O_SEG_3,  F_MID    } } },

    { I_DATA_16    |
      I_NO_CODE64, 1, { 0x07       }, { { O_SEG_2 | O_NOT_CS,  F_MID    } } },

    { 0 }
};

struct insn i_popl[] =
{
    { I_DATA_32 | I_NO_CODE64, 1, { 0x58       }, { { O_GPR_32, F_END   } } },
    { I_DATA_32 | I_NO_CODE64, 2, { 0x8F, 0x00 }, { { O_MEM,    F_MODRM } } },
    { I_DATA_32 | I_NO_CODE64, 2, { 0x0F, 0x81 }, { { O_SEG_3,  F_MID   } } },

    { I_DATA_32    |
      I_NO_CODE64, 1, { 0x07       }, { { O_SEG_2 | O_NOT_CS,  F_MID    } } },
    { 0 }
};

struct insn i_popq[] =
{
    { I_DATA_64 | I_NO_REX, 1, { 0x58       }, { { O_GPR_64, F_END   } } },
    { I_DATA_64 | I_NO_REX, 2, { 0x8F, 0x00 }, { { O_MEM,    F_MODRM } } },
    { I_DATA_64 | I_NO_REX, 2, { 0x0F, 0x81 }, { { O_SEG_3,  F_MID   } } },
    { 0 }
};

struct insn i_pushw[] =
{
    { I_DATA_16,   1, { 0x6A       }, { { O_IMM_S8 | O_HI16  } } },
    { I_DATA_16,   1, { 0x68       }, { { O_IMM_16           } } },
    { I_DATA_16,   1, { 0x50       }, { { O_GPR_16, F_END    } } },
    { I_DATA_16,   2, { 0xFF, 0x30 }, { { O_MEM,    F_MODRM  } } },
    { I_DATA_16,   2, { 0x0F, 0x80 }, { { O_SEG_3,  F_MID    } } },

    { I_DATA_16    |
      I_NO_CODE64, 1, { 0x06       }, { { O_SEG_2,  F_MID    } } },

    { 0 }
};

struct insn i_pushl[] =
{
    { I_DATA_32 | I_NO_CODE64, 1, { 0x6A       }, { { O_IMM_S8 | O_HI32 } } },
    { I_DATA_32 | I_NO_CODE64, 1, { 0x68       }, { { O_IMM_32          } } },
    { I_DATA_32 | I_NO_CODE64, 1, { 0x50       }, { { O_GPR_32, F_END   } } },
    { I_DATA_32 | I_NO_CODE64, 2, { 0xFF, 0x30 }, { { O_MEM,    F_MODRM } } },
    { I_DATA_32 | I_NO_CODE64, 1, { 0x06       }, { { O_SEG_2,  F_MID   } } },
    { I_DATA_32 | I_NO_CODE64, 2, { 0x0F, 0x80 }, { { O_SEG_3,  F_MID   } } },
    { 0 }
};

struct insn i_pushq[] =
{
    { I_DATA_64 | I_NO_REX, 1, { 0x6A       }, { { O_IMM_S8          } } },
    { I_DATA_64 | I_NO_REX, 1, { 0x68       }, { { O_IMM_S32         } } },
    { I_DATA_64 | I_NO_REX, 1, { 0x50       }, { { O_GPR_64, F_END   } } },
    { I_DATA_64 | I_NO_REX, 2, { 0xFF, 0x30 }, { { O_MEM,    F_MODRM } } },
    { I_DATA_64 | I_NO_REX, 2, { 0x0F, 0x80 }, { { O_SEG_3,  F_MID   } } },
    { 0 }
};

struct insn i_rep[]     =   { { 0, 1, { 0xF3 } }, { 0 } };
struct insn i_ret[]     =   { { 0, 1, { 0xC3 } }, { 0 } };

struct insn i_sarb[] =
{
    { 0, 2, { 0xD0, 0x38 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_IMM_1                  } } },

    { 0, 2, { 0xD2, 0x38 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_REG_CL                 } } },

    { 0, 2, { 0xC0, 0x38 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_IMM_8                  } } },

    { 0 }
};

struct insn i_sarw[] =
{
    { I_DATA_16, 2, { 0xD1, 0x38 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_16, 2, { 0xD3, 0x38 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_16, 2, { 0xC1, 0x38 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_sarl[] =
{
    { I_DATA_32, 2, { 0xD1, 0x38 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_32, 2, { 0xD3, 0x38 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_32, 2, { 0xC1, 0x38 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_sarq[] =
{
    { I_DATA_64, 2, { 0xD1, 0x38 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_64, 2, { 0xD3, 0x38 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_64, 2, { 0xC1, 0x38 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_sbbb[] =
{
    { 0,         1, { 0x1C       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x18 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x18, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x1A, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_sbbw[] =
{
    { I_DATA_16, 2, { 0x83, 0x18 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x1D       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x18 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x19, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x1B, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_sbbl[] =
{
    { I_DATA_32, 2, { 0x83, 0x18 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x1D       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x18 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x19, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x1B, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_sbbq[] =
{
    { I_DATA_64, 2, { 0x83, 0x18 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x1D       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x18 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x19, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x1B, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_scasb[] = { { 0,         1, { 0xAE } }, { 0 } };
struct insn i_scasw[] = { { I_DATA_16, 1, { 0xAF } }, { 0 } };
struct insn i_scasl[] = { { I_DATA_32, 1, { 0xAF } }, { 0 } };
struct insn i_scasq[] = { { I_DATA_64, 1, { 0xAF } }, { 0 } };

struct insn i_seg[] =
{
    { 0, 1, { 0x26 }, { { O_SEG_2, F_MID } } },
    { 0, 1, { 0x60 }, { { O_SEG_3, F_END } } },
    { 0 }
};

struct insn i_setb[] =
{
    { 0, 3, { 0x0F, 0x92, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setbe[] =
{
    { 0, 3, { 0x0F, 0x96, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setl[] =
{
    { 0, 3, { 0x0F, 0x9C, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setle[] =
{
    { 0, 3, { 0x0F, 0x9E, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setnb[] =
{
    { 0, 3, { 0x0F, 0x93, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setnbe[] =
{
    { 0, 3, { 0x0F, 0x97, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setnl[] =
{
    { 0, 3, { 0x0F, 0x9D, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setnle[] =
{
    { 0, 3, { 0x0F, 0x9F, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setno[] =
{
    { 0, 3, { 0x0F, 0x91, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setnp[] =
{
    { 0, 3, { 0x0F, 0x9B, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setns[] =
{
    { 0, 3, { 0x0F, 0x99, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setnz[] =
{
    { 0, 3, { 0x0F, 0x95, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_seto[] =
{
    { 0, 3, { 0x0F, 0x90, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setp[] =
{
    { 0, 3, { 0x0F, 0x9A, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_sets[] =
{
    { 0, 3, { 0x0F, 0x98, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_setz[] =
{
    { 0, 3, { 0x0F, 0x94, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_shlb[] =
{
    { 0, 2, { 0xD0, 0x20 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_IMM_1                  } } },

    { 0, 2, { 0xD2, 0x20 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_REG_CL                 } } },

    { 0, 2, { 0xC0, 0x20 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_IMM_8                  } } },

    { 0 }
};

struct insn i_shlw[] =
{
    { I_DATA_16, 2, { 0xD1, 0x20 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_16, 2, { 0xD3, 0x20 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_16, 2, { 0xC1, 0x20 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_shll[] =
{
    { I_DATA_32, 2, { 0xD1, 0x20 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_32, 2, { 0xD3, 0x20 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_32, 2, { 0xC1, 0x20 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_shlq[] =
{
    { I_DATA_64, 2, { 0xD1, 0x20 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_64, 2, { 0xD3, 0x20 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_64, 2, { 0xC1, 0x20 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_shrb[] =
{
    { 0, 2, { 0xD0, 0x28 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_IMM_1                  } } },

    { 0, 2, { 0xD2, 0x28 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_REG_CL                 } } },

    { 0, 2, { 0xC0, 0x28 }, { { O_GPR_8 | O_MEM, F_MODRM },
                              { O_IMM_8                  } } },

    { 0 }
};

struct insn i_shrw[] =
{
    { I_DATA_16, 2, { 0xD1, 0x28 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_16, 2, { 0xD3, 0x28 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_16, 2, { 0xC1, 0x28 }, { { O_GPR_16 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_shrl[] =
{
    { I_DATA_32, 2, { 0xD1, 0x28 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_32, 2, { 0xD3, 0x28 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_32, 2, { 0xC1, 0x28 }, { { O_GPR_32 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_shrq[] =
{
    { I_DATA_64, 2, { 0xD1, 0x28 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_1                   } } },

    { I_DATA_64, 2, { 0xD3, 0x28 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_REG_CL                  } } },

    { I_DATA_64, 2, { 0xC1, 0x28 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_8                   } } },

    { 0 }
};

struct insn i_stc[]     =   { { 0, 1, { 0xF9 } }, { 0 } };
struct insn i_std[]     =   { { 0, 1, { 0xFD } }, { 0 } };
struct insn i_sti[]     =   { { 0, 1, { 0xFB } }, { 0 } };

struct insn i_stosb[] = { { 0,         1, { 0xAA } }, { 0 } };
struct insn i_stosw[] = { { I_DATA_16, 1, { 0xAB } }, { 0 } };
struct insn i_stosl[] = { { I_DATA_32, 1, { 0xAB } }, { 0 } };
struct insn i_stosq[] = { { I_DATA_64, 1, { 0xAB } }, { 0 } };

struct insn i_subb[] =
{
    { 0,         1, { 0x2C       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x28 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x28, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x2A, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_subw[] =
{
    { I_DATA_16, 2, { 0x83, 0x28 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x2D       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x28 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x29, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x2B, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_subl[] =
{
    { I_DATA_32, 2, { 0x83, 0x28 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x2D       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x28 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x29, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x2B, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_subq[] =
{
    { I_DATA_64, 2, { 0x83, 0x28 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x2D       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x28 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x29, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x2B, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_subss[] =
{
    { I_PREFIX_F3, 3, { 0x0F, 0x5C, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_subsd[] =
{
    { I_PREFIX_F2, 3, { 0x0F, 0x5C, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_testb[] =
{
    { 0,         1, { 0xA8       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0xF6, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x84, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },
    { 0 }
};

struct insn i_testw[] =
{
    { I_DATA_16, 1, { 0xA9       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0xF7, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x85, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },
    { 0 }
};

struct insn i_testl[] =
{
    { I_DATA_32, 1, { 0xA9       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0xF7, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x85, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },
    { 0 }
};

struct insn i_testq[] =
{
    { I_DATA_64, 1, { 0xA9       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0xF7, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x85, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },
    { 0 }
};

struct insn i_ucomiss[] =
{
    { 0, 3, { 0x0F, 0x2E, 0x00 }, { { O_XMM,         F_MID   },
                                    { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_ucomisd[] =
{
    { I_PREFIX_66, 3, { 0x0F, 0x2E, 0x00 }, { { O_XMM,         F_MID   },
                                              { O_XMM | O_MEM, F_MODRM } } },
    { 0 }
};

struct insn i_xlat[]    =   { { 0, 1, { 0xD7 } }, { 0 } };

struct insn i_xorb[] =
{
    { 0,         1, { 0x34       }, { { O_ACC_8                  },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x80, 0x30 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_IMM_8                  } } },

    { 0,         2, { 0x30, 0x00 }, { { O_GPR_8 | O_MEM, F_MODRM },
                                      { O_GPR_8,         F_MID   } } },

    { 0,         2, { 0x32, 0x00 }, { { O_GPR_8, F_MID           },
                                      { O_GPR_8 | O_MEM, F_MODRM } } },

    { 0 }
};

struct insn i_xorw[] =
{
    { I_DATA_16, 2, { 0x83, 0x30 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_HI16 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_16, 1, { 0x35       }, { { O_ACC_16                    },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x81, 0x30 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_IMM_16                    } } },

    { I_DATA_16, 2, { 0x31, 0x00 }, { { O_GPR_16 | O_MEM, F_MODRM   },
                                      { O_GPR_16, F_MID             } } },

    { I_DATA_16, 2, { 0x33, 0x00 }, { { O_GPR_16, F_MID             },
                                      { O_GPR_16 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_xorl[] =
{
    { I_DATA_32, 2, { 0x83, 0x30 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_HI32 | O_IMM_S8 | O_PURE  } } },

    { I_DATA_32, 1, { 0x35       }, { { O_ACC_32                    },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x81, 0x30 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_IMM_32                    } } },

    { I_DATA_32, 2, { 0x31, 0x00 }, { { O_GPR_32 | O_MEM, F_MODRM   },
                                      { O_GPR_32, F_MID             } } },

    { I_DATA_32, 2, { 0x33, 0x00 }, { { O_GPR_32, F_MID             },
                                      { O_GPR_32 | O_MEM, F_MODRM   } } },

    { 0 }
};

struct insn i_xorq[] =
{
    { I_DATA_64, 2, { 0x83, 0x30 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S8 | O_PURE         } } },

    { I_DATA_64, 1, { 0x35       }, { { O_ACC_64                  },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x81, 0x30 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_IMM_S32                 } } },

    { I_DATA_64, 2, { 0x31, 0x00 }, { { O_GPR_64 | O_MEM, F_MODRM },
                                      { O_GPR_64, F_MID           } } },

    { I_DATA_64, 2, { 0x33, 0x00 }, { { O_GPR_64, F_MID           },
                                      { O_GPR_64 | O_MEM, F_MODRM } } },

    { 0 }
};

/* vi: set ts=4 expandtab: */
