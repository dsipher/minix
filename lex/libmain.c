/*****************************************************************************

   libmain.c (main function for libfl)                        tahoe/64 lex

*****************************************************************************/

extern int yylex();

int main( argc, argv )
int argc;
char *argv[];

    {
    return yylex();
    }
