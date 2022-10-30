/*****************************************************************************

   token.h                                                     ux/64 shell

******************************************************************************

   derived from ash, contributed to Berkeley by Kenneth Almquist.
   Copyright (c) 1991 The Regents of the University of California.

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

#define TEOF        0
#define TNL         1
#define TSEMI       2
#define TBACKGND    3
#define TAND        4
#define TOR         5
#define TPIPE       6
#define TLP         7
#define TRP         8
#define TENDCASE    9
#define TENDBQUOTE  10
#define TREDIR      11
#define TWORD       12
#define TIF         13
#define TTHEN       14
#define TELSE       15
#define TELIF       16
#define TFI         17
#define TWHILE      18
#define TUNTIL      19
#define TFOR        20
#define TDO         21
#define TDONE       22
#define TBEGIN      23
#define TEND        24
#define TCASE       25
#define TESAC       26

/* Array indicating which tokens mark the end of a list */

const char tokendlist[] = { 1, 0, 0, 0,
                            0, 0, 0, 0,
                            1, 1, 1, 0,
                            0, 0, 1, 1,
                            1, 1, 0, 0,
                            0, 1, 1, 0,
                            1, 0, 1     } ;

char *const tokname[] =
{
    "end of file",  "newline",      "\";\"",        "\"&\"",
    "\"&&\"",       "\"||\"",       "\"|\"",        "\"(\"",
    "\")\"",        "\";;\"",       "\"`\"",        "redirection",
    "word",         "\"if\"",       "\"then\"",     "\"else\"",
    "\"elif\"",     "\"fi\"",       "\"while\"",    "\"until\"",
    "\"for\"",      "\"do\"",       "\"done\"",     "\"{\"",
    "\"}\"",        "\"case\"",     "\"esac\""
};

#define KWDOFFSET TIF       /* first keyword token */

char *const parsekwd[] = {  "if",       "then",     "else",
                            "elif",     "fi",       "while",
                            "until",    "for",      "do",
                            "done",     "{",        "}",
                            "case",     "esac",     0           };

/* vi: set ts=4 expandtab: */
