%{
#include "assignment1.h"
%}
%option nounput yylineno

INTEGER     [0-9][0-9]*
ID          [a-zA-Z][a-zA-Z0-9]*
ADDR_NAME   ([a-zA-Z]|\-|\.)+([ \t]+([a-zA-Z]|\-|\.)+)*

%%
if|while|for|switch|case|break|continue                 return KEYWORD;
[+-]?{INTEGER}                                          return INTEGER;
[+-]?{INTEGER}\.{INTEGER}(e[+-]?{INTEGER}+)?            return FLOAT;
{ID}                                                    return IDENTIFIER;
((\+[0-9]{1,3}-)|[0-9])[0-9][0-9]?-[0-9]{3}-[0-9]{4}    return TELEPHONE;
[a-zA-Z]+@[a-zA-Z]+\.[a-zA-Z]+(\.[a-zA-Z]+)?            return EMAIL;
[0-9]+[ \t]+{ADDR_NAME},[ \t]+{ADDR_NAME},[ \t]+{ADDR_NAME},[ \t]+{ADDR_NAME}   return ADDRESS;
[[:space:]]                                             ;
.					                                    return ERROR;

%%
//This needs to be added to stop the lexer after one run
int yywrap(void)
{
	return 1;
}
