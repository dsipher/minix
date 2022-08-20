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

struct insn i_clc[]     =   { { 0, 1, { 0xF8 } }, { 0 } };
struct insn i_cld[]     =   { { 0, 1, { 0xFC } }, { 0 } };
struct insn i_cli[]     =   { { 0, 1, { 0xFA } }, { 0 } };
struct insn i_cmc[]     =   { { 0, 1, { 0xF5 } }, { 0 } };

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

struct insn i_hlt[]     =   { { 0, 1, { 0xF4 } }, { 0 } };

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

struct insn i_lock[]    =   { { 0, 1, { 0xF0 } }, { 0 } };

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

struct insn i_rep[]     =   { { 0, 1, { 0xF3 } }, { 0 } };
struct insn i_ret[]     =   { { 0, 1, { 0xC3 } }, { 0 } };

struct insn i_seg[] =
{
    { 0, 1, { 0x26 }, { { O_SEG_2, F_MID } } },
    { 0, 1, { 0x60 }, { { O_SEG_3, F_END } } },
    { 0 }
};

struct insn i_stc[]     =   { { 0, 1, { 0xF9 } }, { 0 } };
struct insn i_std[]     =   { { 0, 1, { 0xFD } }, { 0 } };
struct insn i_sti[]     =   { { 0, 1, { 0xFB } }, { 0 } };

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
