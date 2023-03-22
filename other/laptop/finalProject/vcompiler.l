%{

#include "string.h"
#include "vcompiler.tab.h"
void yyerror (char *s);
int yylex();

%}

SIZE                                        [{][0-9]+[}]
ID                                          [a-zA-Z]([a-zA-Z0-9]+)?
ARR                                         \[[ ]*[0-9]+([ ]*,[ ]*[0-9]+[ ]*)*\] 
NUM                                         (\-)?[0-9]+

%%

"print"                                     { return PRINT; }
"vec"                                       { return VECTOR; }
"scl"                                       { return SCALAR; }
"if"                                        { return IF; }
"loop"                                      { return LOOP; }

[{};,().:]                                  { return yytext[0]; }
[-+*/=]                                     { sscanf(yytext, "%s", yylval.operator); return OP; }

{SIZE}                                      { sscanf(yytext, "%s", yylval.num); return SIZE; }
{ID}                                        { sscanf(yytext, "%s", yylval.id); return ID; }
{ARR}                                       { sscanf(yytext, "%s", yylval.expression); return ARR; }
{NUM}                                       { sscanf(yytext, "%s", yylval.num); return NUM; }

[ \t\n]                                     ;
.                                           { ECHO; yyerror ("unexpected character"); }

%%

int yywrap (void) {return 1;}