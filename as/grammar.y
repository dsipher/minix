%{
#include "as.h"
%}

%union  {
            char *s;
            int i;
            long l;
            struct insn *insns;
            struct nlist *sym;
            struct operand *o;
        }

%token<l>       NUMBER
%token<s>       STRLIT
%token<insns>   MNEMONIC
%token<sym>     SYMBOL

%token          BYTE    SHORT   INT     QUAD

%token          ALIGN   ASCII   BSS     CODE16  CODE32
%token          CODE64  DATA    FILL    GLOBL   LOCAL
%token          ORG     RIP     TEXT

%token          AL      AH      AX      EAX     RAX
%token          BL      BH      BX      EBX     RBX
%token          CL      CH      CX      ECX     RCX
%token          DL      DH      DX      EDX     RDX
%token          SIL             SI      ESI     RSI
%token          DIL             DI      EDI     RDI
%token          BPL             BP      EBP     RBP
%token          SPL             SP      ESP     RSP
%token          R8B             R8W     R8D     R8
%token          R9B             R9W     R9D     R9
%token          R10B            R10W    R10D    R10
%token          R11B            R11W    R11D    R11
%token          R12B            R12W    R12D    R12
%token          R13B            R13W    R13D    R13
%token          R14B            R14W    R14D    R14
%token          R15B            R15W    R15D    R15

%token          XMM0    XMM1    XMM2    XMM3
%token          XMM4    XMM5    XMM6    XMM7
%token          XMM8    XMM9    XMM10   XMM11
%token          XMM12   XMM13   XMM14   XMM15

%token          CR0     CR1     CR2     CR3
%token          CR4     CR5     CR6     CR7
%token          CR8     CR9     CR10    CR11
%token          CR12    CR13    CR14    CR15

%token          CS      DS      SS      ES      FS      GS

%type<i>        data_op data_def
%type<o>        expr static_expr
%type<o>        operand imm indirect
%type<o>        reg reg8 reg16 reg32 reg64 sreg
%type<o>        mem disp base index scale

%left           '+' '-'

%%

goal            :   lines   ;

lines           :   list_line
                |   lines '\n' list_line
                ;

list_line       :   line    { end_of_line(); }  ;

line            :   /* EMPTY */
                |   ASCII STRLIT    { while (*$2) { emit(*$2++); } }
                |   LOCAL SYMBOL    { /* ignored; to be removed */ }
                |   GLOBL SYMBOL    { $2->n_globl = 1; }
                |   TEXT            { segofs = &header.a_text; }
                |   DATA            { segofs = &header.a_data; }
                |   CODE16          { code_size = O_MEM_16; }
                |   CODE32          { code_size = O_MEM_32; }
                |   CODE64          { code_size = O_MEM_64; }
                |   align
                |   bss
                |   data_def
                |   equate
                |   fill
                |   insn
                |   label line
                |   origin
                ;

insn            :   MNEMONIC
                    { encode($1, 0, 0, 0); }
                |   MNEMONIC operand
                    { encode($1, $2, 0, 0); }
                |   MNEMONIC operand ',' operand
                    { encode($1, $4, $2, 0); }
                |   MNEMONIC operand ',' operand ',' operand
                    { encode($1, $6, $4, $2); }
                ;

align           :   ALIGN static_expr
                    {
                        size2($2->value, "alignment");
                        while (*segofs & ($2->value - 1)) emit(0);
                    }
                ;

bss             :   BSS SYMBOL ',' static_expr ',' static_expr
                    {
                        define($2, N_BSS, $4->value, $6->value);
                    }
                ;

data_op         :   BYTE    { $$ = O_IMM_8; }
                |   SHORT   { $$ = O_IMM_16; }
                |   INT     { $$ = O_IMM_32; }
                |   QUAD    { $$ = O_IMM_64; }
                ;

data_def        :   data_op expr        { $2->classes = $1; emit_value($2); $$ = $1; }
                |   data_def ',' expr   { $3->classes = $1; emit_value($3); $$ = $1; }
                ;

equate          :   SYMBOL '=' static_expr
                    {
                        define($1, N_ABS, $3->value, 0);
                    }
                ;

fill            :   FILL static_expr ',' static_expr ',' static_expr
                    {
                        /* we treat this somewhat different from gas,
                           as we only permit fill bytes (not words).
                           for compatibility (in the short term) we
                           just multiply to compute the count, but
                           eventually we'll reduce this to 2 operands */

                        long count = $2->value * $4->value;
                        while (count-- > 0) emit($6->value);
                    }
                ;

label           :   SYMBOL ':' { define($1, CURSEG(), *segofs, 0); } ;

expr            :   NUMBER
                    {
                        $$ = NEW_OPERAND();
                        $$->value = $1;
                    }
                |   '.'
                    {
                        $$ = NEW_OPERAND();
                        $$->value = *segofs;
                    }
                |   SYMBOL
                    {
                        $$ = NEW_OPERAND();

                        if ($1->n_type == N_ABS)
                            $$->value = $1->n_value;
                        else
                            $$->sym = $1;
                    }
                |   '-' expr
                    {
                        $$ = $2;
                        $$->value = -($$->value);
                        if ($$->sym) error("invalid operand to unary `-'");
                    }
                |   expr '+' expr
                    {
                        /* we can't ever have multiple symbols in
                           an additive expression, since there's no
                           way to express that in a reloc record. */

                        if ($3->sym) SWAP(struct operand *, $1, $3);
                        if ($3->sym) error("invalid operands to binary `+'");
                        $1->value += $3->value;
                        $$ = $1;
                    }
                |   expr '-' expr
                    {
                        /* if both operands have symbols in the same segment,
                           evaluate the difference now and nuke the symbols */

                        if (($1->sym) && (  ($1->sym->n_type == N_TEXT)
                                         || ($1->sym->n_type == N_DATA) )
                          && $3->sym && ($3->sym->n_type == $1->sym->n_type))
                        {
                            $1->value += ($1->sym->n_value -
                                          $3->sym->n_value);
                            $1->sym = 0;
                            $3->sym = 0;
                        }

                        /* the minuend can't be a symbol, but
                           we let it slide on the first pass */

                        if ($3->sym && pass != FIRST_PASS)
                            error("invalid operands to binary `-'");

                        $1->value -= $3->value;
                        $$ = $1;
                    }
                ;

origin          :   ORG static_expr
                    {
                        if ($2->value < *segofs)
                            /* give the benefit of the doubt on
                               the first pass: code may shrink
                               once some symbols are resolved */

                            if (pass != FIRST_PASS)
                                error("origin goes backwards");

                        while (*segofs < $2->value) emit(0);
                    }
                ;

static_expr     :   expr
                    {
                        if ($1->sym) error("static expression required");
                        $$ = $1;
                    }
                ;

operand         :   reg
                |   imm
                |   mem
                |   sreg
                |   indirect { $1->classes &= ~(O_REL | O_ABS); $$ = $1; }
                ;

indirect        :   '*' mem  { $$ = $2; }
                |   '*' reg  { $$ = $2; }
                ;

imm             :   '$' expr
                    {
                        $2->classes = immclass($2->value);
                        if ($2->sym == 0) $2->classes |= O_PURE;
                        $$ = $2;
                    }
                ;

mem             :   expr
                    {
                        int immclasses = immclass($1->value);

                        /* with no registers to indicate the address_size,
                           we assume the current code_size, which is (quite
                           conveniently) already the right kind of O_MEM_*. */

                        $1->classes = O_REL_16 | O_REL_32
                                    | O_ABS_64 | code_size;

                        if (immclasses & O_IMM_8)  $1->classes |= O_ABS_8;
                        if (immclasses & O_IMM_16) $1->classes |= O_ABS_16;
                        if (immclasses & O_IMM_32) $1->classes |= O_ABS_32;

                        /* we cheat here a little bit: O_REL_8 is only for
                           short branches, which are all 2 bytes long, so
                           we can safely resolve() with that assumption */

                        if (resolve($1, 2, 0)) $1->classes |= O_REL_8;

                        $$ = $1;
                    }
                |   disp '(' RIP ')'
                    {
                        $$ = $1 ? $1 : NEW_OPERAND();
                        $$->classes = O_MEM_64;
                        $$->reg = RIP;
                    }
                |   disp '(' base index ')'
                    {
                        int base_class = 0;
                        int index_class = 0;

                        /* combine the three [possible] operands into
                           $$. we reuse the `disp' operand if present */

                        $$ = $1 ? $1 : NEW_OPERAND();

                        if ($3) {   /* base */
                            $$->reg = $3->reg;
                            base_class = $3->classes & O_GPR;
                        }

                        if ($4) {   /* ,index,scale */
                            $$->index = $4->index;
                            $$->scale = $4->scale;
                            index_class = $4->classes & O_GPR;
                        }

                        /* this check ensures that, if both a base and
                           index are specified, they have the same size */

                        if ( ((base_class | index_class) != base_class)
                          && ((base_class | index_class) != index_class))
                            error("mixed register sizes in address");

                        /* and now we assign the address size based
                           on the sizes of the registers given. */

                        switch (base_class | index_class)
                        {
                        case O_GPR_16:  $$->classes = O_MEM_16; break;
                        case O_GPR_32:  $$->classes = O_MEM_32; break;
                        case O_GPR_64:  $$->classes = O_MEM_64; break;

                                        /* catches 8-bit registers,
                                           or no registers at all */

                        default:        error("malformed address");
                        }

                        /* we leave the remaining validation to encoding */
                    }
                ;

disp            :   expr                         |  /* EMPTY */  { $$ = 0; } ;
base            :   reg                          |  /* EMPTY */  { $$ = 0; } ;
scale           :   ',' static_expr { $$ = $2; } |  /* EMPTY */  { $$ = 0; } ;

index           :   ',' reg scale
                    {
                        $$ = $2;
                        $$->index = $$->reg;
                        $$->reg = 0;
                        if ($3) $$->scale = size2($3->value, "scale factor");
                    }
                |   /* EMPTY */ { $$ = 0; }
                ;

reg             :   reg8    |   reg16   |   reg32   |   reg64   ;

reg8            :   AL      {   $$ = REG(O_GPR_8 | O_ACC_8,     AL);    }
                |   AH      {   $$ = REG(O_GPR_8,               AH);    }
                |   BL      {   $$ = REG(O_GPR_8,               BL);    }
                |   BH      {   $$ = REG(O_GPR_8,               BH);    }
                |   CL      {   $$ = REG(O_GPR_8,               CL);    }
                |   CH      {   $$ = REG(O_GPR_8,               CH);    }
                |   DL      {   $$ = REG(O_GPR_8,               DL);    }
                |   DH      {   $$ = REG(O_GPR_8,               DH);    }
                |   SIL     {   $$ = REG(O_GPR_8,               SIL);   }
                |   DIL     {   $$ = REG(O_GPR_8,               DIL);   }
                |   BPL     {   $$ = REG(O_GPR_8,               BPL);   }
                |   SPL     {   $$ = REG(O_GPR_8,               SPL);   }
                |   R8B     {   $$ = REG(O_GPR_8,               R8B);   }
                |   R9B     {   $$ = REG(O_GPR_8,               R9B);   }
                |   R10B    {   $$ = REG(O_GPR_8,               R10B);  }
                |   R11B    {   $$ = REG(O_GPR_8,               R11B);  }
                |   R12B    {   $$ = REG(O_GPR_8,               R12B);  }
                |   R13B    {   $$ = REG(O_GPR_8,               R13B);  }
                |   R14B    {   $$ = REG(O_GPR_8,               R14B);  }
                |   R15B    {   $$ = REG(O_GPR_8,               R15B);  }
                ;

reg16           :   AX      {   $$ = REG(O_GPR_16 | O_ACC_16,   AX);    }
                |   BX      {   $$ = REG(O_GPR_16,              BX);    }
                |   CX      {   $$ = REG(O_GPR_16,              CX);    }
                |   DX      {   $$ = REG(O_GPR_16,              DX);    }
                |   SI      {   $$ = REG(O_GPR_16,              SI);    }
                |   DI      {   $$ = REG(O_GPR_16,              DI);    }
                |   BP      {   $$ = REG(O_GPR_16,              BP);    }
                |   SP      {   $$ = REG(O_GPR_16,              SP);    }
                |   R8W     {   $$ = REG(O_GPR_16,              R8W);   }
                |   R9W     {   $$ = REG(O_GPR_16,              R9W);   }
                |   R10W    {   $$ = REG(O_GPR_16,              R10W);  }
                |   R11W    {   $$ = REG(O_GPR_16,              R11W);  }
                |   R12W    {   $$ = REG(O_GPR_16,              R12W);  }
                |   R13W    {   $$ = REG(O_GPR_16,              R13W);  }
                |   R14W    {   $$ = REG(O_GPR_16,              R14W);  }
                |   R15W    {   $$ = REG(O_GPR_16,              R15W);  }
                ;

reg32           :   EAX     {   $$ = REG(O_GPR_32 | O_ACC_32,   EAX);   }
                |   EBX     {   $$ = REG(O_GPR_32,              EBX);   }
                |   ECX     {   $$ = REG(O_GPR_32,              ECX);   }
                |   EDX     {   $$ = REG(O_GPR_32,              EDX);   }
                |   ESI     {   $$ = REG(O_GPR_32,              ESI);   }
                |   EDI     {   $$ = REG(O_GPR_32,              EDI);   }
                |   EBP     {   $$ = REG(O_GPR_32,              EBP);   }
                |   ESP     {   $$ = REG(O_GPR_32,              ESP);   }
                |   R8D     {   $$ = REG(O_GPR_32,              R8D);   }
                |   R9D     {   $$ = REG(O_GPR_32,              R9D);   }
                |   R10D    {   $$ = REG(O_GPR_32,              R10D);  }
                |   R11D    {   $$ = REG(O_GPR_32,              R11D);  }
                |   R12D    {   $$ = REG(O_GPR_32,              R12D);  }
                |   R13D    {   $$ = REG(O_GPR_32,              R13D);  }
                |   R14D    {   $$ = REG(O_GPR_32,              R14D);  }
                |   R15D    {   $$ = REG(O_GPR_32,              R15D);  }
                ;

reg64           :   RAX     {   $$ = REG(O_GPR_64 | O_ACC_64,   RAX);   }
                |   RBX     {   $$ = REG(O_GPR_64,              RBX);   }
                |   RCX     {   $$ = REG(O_GPR_64,              RCX);   }
                |   RDX     {   $$ = REG(O_GPR_64,              RDX);   }
                |   RSI     {   $$ = REG(O_GPR_64,              RSI);   }
                |   RDI     {   $$ = REG(O_GPR_64,              RDI);   }
                |   RBP     {   $$ = REG(O_GPR_64,              RBP);   }
                |   RSP     {   $$ = REG(O_GPR_64,              RSP);   }
                |   R8      {   $$ = REG(O_GPR_64,              R8);    }
                |   R9      {   $$ = REG(O_GPR_64,              R9);    }
                |   R10     {   $$ = REG(O_GPR_64,              R10);   }
                |   R11     {   $$ = REG(O_GPR_64,              R11);   }
                |   R12     {   $$ = REG(O_GPR_64,              R12);   }
                |   R13     {   $$ = REG(O_GPR_64,              R13);   }
                |   R14     {   $$ = REG(O_GPR_64,              R14);   }
                |   R15     {   $$ = REG(O_GPR_64,              R15);   }
                ;

sreg            :   CS      {   $$ = REG(O_SEG_2,               CS);    }
                |   DS      {   $$ = REG(O_SEG_2,               DS);    }
                |   SS      {   $$ = REG(O_SEG_2,               SS);    }
                |   ES      {   $$ = REG(O_SEG_2,               ES);    }
                |   FS      {   $$ = REG(O_SEG_3,               FS);    }
                |   GS      {   $$ = REG(O_SEG_3,               GS);    }
                ;

%%

#define NEW_OPERAND()           ({                                          \
                                    struct operand *_o;                     \
                                    _o = ALLOC(sizeof(struct operand));     \
                                    _o->classes = 0;                        \
                                    _o->reg = 0;                            \
                                    _o->index = 0;                          \
                                    _o->scale = 0;                          \
                                    _o->value = 0;                          \
                                    _o->sym = 0;                            \
                                    (_o);                                   \
                                })

#define REG(_c, _r)             ({                                          \
                                    struct operand *_o;                     \
                                    _o = NEW_OPERAND();                     \
                                    _o->classes = (_c);                     \
                                    _o->reg = (_r);                         \
                                    (_o);                                   \
                                })

/* vi: set ts=4 expandtab: */
