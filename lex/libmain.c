/*****************************************************************************

   libmain.c (main function for libfl)                        jewel/os lex

*****************************************************************************/

extern int yylex();

int main( argc, argv )
int argc;
char *argv[];

    {
    return yylex();
    }
