#include <stdio.h>
#include "assignment1.h"

extern int yylex();
extern int yylineno;
extern char *yytext;

char *names[] = {
    NULL,
    "keyword",
    "integer",
    "float",
    "identifier",
    "telephone",
    "email",
    "address"};

int main(void)
{
    int ntoken = yylex();
    int i = 0;
    while (ntoken)
    {
        if (ntoken == ERROR)
        {
            printf("Unexpected character in line %d: %s\n", yylineno, yytext);
            continue;
            
        }
        printf("<%s, %s>\n", names[ntoken], yytext);
        ntoken = yylex();
    }
    return 0;
}
