%{
void yyerror (const char *s);
int yylex();
int yywrap();
extern char* yytext;
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>
#include "another.h"
typedef enum {INT_TYPE, ARR_TYPE} rectype;
typedef struct symrec
{
    char *id;
    Array array;
    struct symrec *next;
} symrec;
typedef struct numbers
{
  int val;
  struct numbers *next;
} numbers;
numbers *numHead = NULL;
numbers *numTail = NULL;
symrec *sym_table = NULL;
symrec *putsym();
symrec *getsym();
void push();
void putArr(const char *id);
void printReqs();
void putNum(int val);
void clearNum();
void createArrayFromNums();
// int symbols[52];
// int symbolVal(char symbol);
// void updateSymbolVal(char symbol, int val);
int tcounter=0, ecounter=0, scope=0, type = 0, numCount = 0;
extern int lineno;
%}
%code requires {
  typedef struct symrec symrec;
}
%union {int num; char *id;}         /* Yacc definitions */
%start program
%token PRINT START END IF THEN WHILE DO GE LE NE EQ INT ARR
%token <num> NUMBER
%token <id> IDENTIFIER
/* %token <type> INT_IDENTIFIER */
%type <num> expressionInt constantNumber

%left GE LE NE EQ '>' '<'
%right '='
%nonassoc '@' ':'
%left '+' '-'
%left '*' '/'
%left UMINUS

%%

program         : {printReqs();} block
                ;

block           : START {printf("%.*s{\n", scope++, "\t");} statmentList END {printf("%.*s}\n", --scope, "\t");}
                ;

statmentList    : statmentList statment
                |
                ;

statment        : declarator 
                | assignment
                | conditional
                | loop
                | print
                ;

declarator      : INT {type=1;printf("%.*sint ", scope, "\t");} variableList ';' {type=0;printf(";\n");}
                | ARR {type=2;printf("%.*sArray ", scope, "\t");} variableList ';' {type=0;printf(";\n");}
                ;

assignment      : {printf("%.*s", scope, "\t")} variable '=' {printf(" = ");} expressionInt ';' {printf(";\n");}
                | {printf("%.*s", scope, "\t")} variable '=' {printf(" = ");} expressionArr ';' {printf(";\n");}
                ;

/* assignment      : {printf("%.*s", scope, "\t")} variable '=' {printf(" = ");} expressionArr ';' {printf(";\n");}
                | {printf("%.*s", scope, "\t")} variable '=' {printf(" = ");} expressionInt ';' {printf(";\n");}
                ; */


conditional     : IF '(' {printf("%.*sif (", scope, "\t");} cond ')' THEN {printf("%.*s)\n", scope, "\t");} block
                ;

loop            : WHILE '(' {printf("%.*swhile (", scope, "\t");} cond ')' DO {printf("%.*s)\n", scope, "\t");} block
                ;

print           : PRINT expressionList ';'
                ;
                
expressionList  : expressionInt
                | expressionArr
                | expressionList ',' expressionInt
                | expressionList ',' expressionArr
                ;

expressionInt   : expressionInt '+' {printf(" + ");} expressionInt 
                | expressionInt '-' {printf(" - ");} expressionInt 
                | expressionInt '*' {printf(" * ");} expressionInt 
                | expressionInt '/' {printf(" / ");} expressionInt 
                | '(' {printf("(");} expressionInt ')' {printf(")");}
                | '-' {printf("-");} expressionInt %prec UMINUS 
                | variable 
                | constantNumber {printf("%d", $1);}
                ;

expressionArr   : constantArray
                | {printf("arr_minus(");} expressionArr '-' {printf(", ");} expressionArr {printf(")");}
                | {printf("arr_multiply(");} expressionArr '*' {printf(", ");} expressionArr {printf(")");}
                | {printf("arr_divide(");} expressionArr '/' {printf(", ");} expressionArr {printf(")");}
                | '(' expressionArr ')'
                | variable
                | {printf("arr_plus(");} expressionArr '+' {printf(", ");} expressionArr {printf(")");}
                ;

arrSpecials     : expressionArr ':' {printf(", ");} expressionInt {printf(")");}
                | expressionArr '@' {printf(", ");} expressionArr {printf(")");}
                ;

/* expression      : expression '+' expression {printf("%.*s%d + %d", scope, "\t", $1, $2);}
                | expression '-' expression
                | expression '*' expression
                | expression '/' expression
                | expression '@' expression
                | '(' expression ')'
                | '-' expression %prec UMINUS
                | variable
                | constantNumber
                | constantArray
                ; */

cond            : expressionInt {printf("%d ", $1);} relOps expressionInt {printf(" %d", $4);}
                ;

relOps          : '>' {printf(">");}
                | '<' {printf("<");}
                | GE {printf(">=");}
                | LE {printf(">=");}
                | NE {printf("!=");}
                | EQ {printf("==");}
                ;

constantNumber  : NUMBER
                ;

constantArray   : '[' ']' {numCount=0;printf("createArray(0);")}
                | '[' numberList ']' {createArrayFromNums();}
                ;

numberList      : constantNumber {++numCount;putNum($1);}
                | numberList ',' constantNumber {++numCount;putNum($3);}
                ;

variableList    : variable
                | variableList ',' {printf(", ");} variable

variable        : IDENTIFIER {printf("%s",$1);}//{printf(type==2?"*":"");printf("%s",$1);if(type==2) putArr($1);}
                ;
%%

int main() {
    yyparse();
}

void yyerror (const char* s) {
    fprintf(stderr, "%s\n", s);
}

void putNum(int val)
{
  if(numHead == NULL)
  {
    numHead = malloc(sizeof(numbers));
    if(numHead == NULL)
    {
      fprintf(stderr, "out of memory\n");
      exit(1);
    }
    numTail = numHead;
    numHead->val = val;
    numHead->next = NULL;
    return;
  }

  numTail->next = malloc(sizeof(numbers));
  if(numTail->next == NULL)
  {
    fprintf(stderr, "out of memory\n");
    exit(1);
  }
  numTail = numTail->next;
  numTail->val = val;
  numTail->next = NULL;
}
void clearNum()
{
  numbers *temp;
  while(numHead)
  {
    temp = numHead;
    numHead = numHead->next;
    free(temp);
  }
  numCount = 0;
}

void createArrayFromNums() 
{
  printf("createArray(%d", numCount);
  fprintf(stderr, "createArray(%d", numCount);
  
  numbers *temp;
  
  while(numHead)
  {
    temp = numHead;
    numHead = numHead->next;
    printf(", %d", temp->val);
    
    fprintf(stderr, ", %d", temp->val);
    free(temp);
  }
  numCount=0;
  printf(")");
  fprintf(stderr, ")");
}

void putArr(const char *id)
{
}

symrec * putsym ( char *sym_name )
{
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof(symrec));
  ptr->id = (char *) malloc (strlen(sym_name)+1);
  strcpy (ptr->id,sym_name);
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}
symrec * getsym ( char *sym_name )
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->id,sym_name) == 0)
      return ptr;
  return 0;
}

void push()
{

}

void printReqs()
{
  printf("#include \"another.h\"\n");
  printf("void main(void)\n");
}