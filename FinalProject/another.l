%{
#include "another.tab.h"
#include <string.h>
#include <stdlib.h>

char *copyId(const char *);
int lineno;
%}

%option noyywrap

%%
 
"int"                           { return TOKEN_INT; }
"arr"                           { return TOKEN_ARR; }
"begin"                         { return TOKEN_BEGIN; }
"end"                           { return TOKEN_END; }
"if"                            { return TOKEN_IF; }
"then"                          { return TOKEN_THEN; }
"while"                         { return TOKEN_WHILE; }
"do"                            { return TOKEN_DO; }
"print"                         { return TOKEN_PRINT; }
"<="                            { return TOKEN_LESSEQUAL; }
">="                            { return TOKEN_GREATEREQUAL; }
"!="                            { return TOKEN_NOTEQUAL; }
"=="                            { return TOKEN_EQUAL; }
[_a-zA-Z][a-zA-Z0-9]*           { yylval.id = copyId(yytext); return TOKEN_ID; }
[0-9]+                          { yylval.num = atoi(yytext); return TOKEN_NUMBER; }
[\(\)\@\+\-\*\/\:\=\;\,\>\<]    { return yytext[0]; }
[ \t\r]                         { }
[\n]                            { ++lineno; }
.                               { return yytext[0]; }

%%

char *copyId (const char *id)
{
  size_t len = strlen(id);
  char *copy = (char *) malloc(len + 1);
  strncpy(copy, id, len);
  copy[len] = '\0';
  return copy;
}