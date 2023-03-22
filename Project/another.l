%{
#include <string.h>
#include <stdlib.h>
#include "another.tab.h"
void yyerror (const char *s);
int yylex();
int lineno;
char *copyID(const char* id);
%}

NUM         [0-9]+
ID          [[:alpha:]_][[:alnum:]_]*

%%

"int"                                   {return INT;}
"arr"                                   {return ARR;}
"begin"                                 {return START;}
"end"                                   {return END;}
"if"                                    {return IF;}
"then"                                  {return THEN;}
"while"                                 {return WHILE;}
"do"                                    {return DO;}
"print"                                 {return PRINT;}
">="                                    {return GE;}
"<="                                    {return LE;}
"!="                                    {return NE;}
"=="                                    {return EQ;}
{ID}                                    {yylval.id=yytext;return IDENTIFIER;}
{NUM}                                   {yylval.num=atoi(yytext); return NUMBER;}
[ \t\r]                                 {;}
[ \n]                                   {++lineno;}
[\-\+\*\/\=\;\>\<\(\)\,\:\[\]\@]        {return yytext[0];}
.                                       {return yytext[0];yyerror("unexpected character");} // yyerror("unexpected character");

%%

int yywrap (void) {return 1;}

char *copyID(const char *id)
{
    size_t len = strlen(id);
    char *buffer = malloc(len+1);
    if(buffer != NULL)
    {
        memcpy(buffer, id, len);
        buffer[len] = '\0';
    }
    return buffer;
}