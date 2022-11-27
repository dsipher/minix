/*****************************************************************************

   libmain.c (main function for libfl)                           minix lex

*****************************************************************************/

extern int yylex();

int main( argc, argv )
int argc;
char *argv[];

    {
    return yylex();
    }
