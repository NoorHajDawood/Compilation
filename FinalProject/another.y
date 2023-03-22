%{
#include <iostream>
#include <cstdio>
#include "SyntaxTree.hpp"
using namespace std;

void yyerror (const char *);
extern int yylex();
extern FILE *yyin;
extern int lineno;

void initProgram(list<Node *> *statments);
Node *addDeclarator(bool isInt, list<string> *variables);
int indent;
%}

%code requires {
#include <exception>
#include "SyntaxTree.hpp"
}

%union {
        int num;
        char *id;
        bool isInt;
        Node *node;
        list<string> *variables;
        list<Node *> *statments;
}

%token TOKEN_INT TOKEN_ARR TOKEN_BEGIN TOKEN_END TOKEN_IF TOKEN_THEN TOKEN_WHILE TOKEN_DO TOKEN_PRINT TOKEN_LESSEQUAL TOKEN_GREATEREQUAL TOKEN_NOTEQUAL TOKEN_EQUAL
%token<num> TOKEN_NUMBER
%token<id> TOKEN_ID

%type<isInt> type
%type<variables> variableList
%type<statments> block statmentList expressionList
%type<node> expression number reference variable cond loop conditional statment declarator assignment print

%left '+' '-'
%left '*' '/'
%nonassoc '@' ':'
%left UMINUS

%%

program         : block {initProgram($1);}
                ;

block           : TOKEN_BEGIN statmentList TOKEN_END {$$ = $2;}
                ;

statmentList    : statmentList statment {$$ = $1; $$->push_back($2);}
                | statment {$$ = new list<Node *>(); $$->push_back($1);}
                ;

statment        : declarator ';'
                | assignment ';'
                | print ';'
                | conditional
                | loop
                ;

declarator      : type variableList {$$=addDeclarator($1, $2)}
                ;

type            : TOKEN_INT {$$ = true;}
                | TOKEN_ARR {$$ = false;}
                ;

assignment      : variable '=' expression {$$ = new Expression($1, $3, ExpressionType::ASSIGNMENT);}
                | reference '=' expression {$$ = new Expression($1, $3, ExpressionType::ASSIGNMENT);}
                ;

conditional     : TOKEN_IF '(' cond ')' TOKEN_THEN block {$$ = new Conditional($3, $6);}
                ;

loop            : TOKEN_WHILE '(' cond ')' TOKEN_DO block {$$ = new Loop($3, $6);}
                ;

print           : TOKEN_PRINT expressionList {$$ = new Print($2);}
                ;

variableList    : variableList ',' TOKEN_ID {$$ = $1; $$->push_back($3);}
                |  TOKEN_ID {$$ = new list<string>; $$->push_back($1);}
                ;

expressionList  : expressionList ',' expression {$$ = $1; $$->push_back($3);}
                | expression {$$ = new list<Node *>(); $$->push_back($1);}
                ;

expression      : expression '+' expression {$$ = new Expression($1, $3, ExpressionType::ADDITION);}
                | expression '-' expression {$$ = new Expression($1, $3, ExpressionType::SUBSTRACTION);}
                | expression '*' expression {$$ = new Expression($1, $3, ExpressionType::MULTIPLICATION);}
                | expression '/' expression {$$ = new Expression($1, $3, ExpressionType::DIVISION);}
                | expression '@' expression {$$ = new Expression($1, $3, ExpressionType::DOT_PRODUCT);}
                | '(' expression ')' {$$ = new Expression($2); }
                | variable
                | number
                | reference
                ;

variable        :  TOKEN_ID {$$ = new Name(string($1));}
                ;

cond            : expression '<' expression {$$ = new Expression($1, $3, ExpressionType::LESS);}
                | expression '>' expression {$$ = new Expression($1, $3, ExpressionType::GREATER);}
                | expression TOKEN_LESSEQUAL expression {$$ = new Expression($1, $3, ExpressionType::LESSEQUAL);}
                | expression TOKEN_GREATEREQUAL expression {$$ = new Expression($1, $3, ExpressionType::GREATEREQUAL);}
                | expression TOKEN_EQUAL expression {$$ = new Expression($1, $3, ExpressionType::EQUAL);}
                | expression TOKEN_NOTEQUAL expression {$$ = new Expression($1, $3, ExpressionType::NOTEQUAL);}
                ;

number          : TOKEN_NUMBER {$$ = new Number($1);}
                | '-' TOKEN_NUMBER %prec UMINUS {$$ = new Number(-$2);}
                | '[' ']' {$$ = new Array();}
                | '[' expressionList ']' {$$ = new Array($2);}
                ;

reference       : variable ':' expression {$$ = new Expression($1, $3, ExpressionType::REFERENCE);}
                ;

%%

void initProgram(list<Node *> *statments)
{
        cout << "#include \"ArrayUtils.hpp\"" << endl
             << "using namespace std;" << endl
             << "int main()" << endl << "{" << endl;
             
        for (Node *node : *statments) {
                cout << string(*node) << ";" << endl;
        }

        cout << "}" << endl;
}

Node *addDeclarator(bool isInt, list<string> *variables)
{
        return new Declarator(isInt, variables);
}

void yyerror (const char *s)
{
        cerr << "line " << lineno << ", " << s << endl;
}

int main (int argc, char **argv)
{
        lineno = indent = 1;
        if (argc > 2) {
                yyin = fopen(argv[1], "rb");
        }
        yyparse();
}

Number::Number(int value) : value(value) {}
Number::operator string() const { return to_string(value); }

Array::Array() : expressionList(nullptr) {}
Array::Array(list<Node *> *expressionList) : expressionList(expressionList) {}
Array::operator string() const
{
        string code = "Array{";
        if (expressionList)
        {
                code += string(*(expressionList->front()));
                expressionList->pop_front();
                for (Node *node : *expressionList)
                {
                        code += ", " + string(*node);
                }
        }
        code += "}";
        return code;
}

Name::Name(string name) : name(name) {}
Name::operator string() const { return name; }

Declarator::Declarator(bool isInt, list<string> *nameList) : isInt(isInt), nameList(nameList) {}
Declarator::operator string() const
{
        string code(indent, '\t');
        code += isInt ? "int " : "Array ";
        code += nameList->front();
        nameList->pop_front();
        for (string id : *nameList)
        {
                code += ", " + id;
        }
        return code;
}

Print::Print(list<Node *> *expressionList) : expressionList(expressionList) {}
Print::operator string() const
{
        string code(indent, '\t');
        code += "cout << ";
        code += string(*(expressionList->front()));
        expressionList->pop_front();
        for (Node *node : *expressionList)
        {
                code += " << \", \" << " + string(*node);
        }
        code += " << endl";
        return code;
}

Conditional::Conditional(Node *cond, list<Node *> *block) : cond(cond), block(block) {}
Conditional::operator string() const
{
        string code(indent, '\t');
        code += "if(" + string(*cond) + ")\n";
        code += string(indent, '\t') + "{\n";
        ++indent;
        for (Node *node : *block)
        {
                code += string(*node) + ";\n";
        }
        --indent;
        code += string(indent, '\t') + "}";
        return code;
}

Loop::Loop(Node *cond, list<Node *> *block) : cond(cond), block(block) {}
Loop::operator string() const
{
        string code(indent, '\t');
        code += "while(" + string(*cond) + ")\n";
        code += string(indent, '\t') + "{\n";
        ++indent;
        for (Node *node : *block)
        {
                code += string(*node) + ";\n";
        }
        --indent;
        code += string(indent, '\t') + "}";
        return code;
}

string ops[] = {" + ", " - ", " * ", " / ", " = ", " < ", " > ", " <= ", " >= ", " == ", " != "};
Expression::Expression(Node *expression) : expression(expression), type(ExpressionType::PARENTHESIS) {}
Expression::Expression(Node *left, Node *right, ExpressionType type) : left(left), right(right), type(type) {}
Expression::operator string() const
{
        if (type == ExpressionType::PARENTHESIS)
        {
                return "(" + string(*expression) + ")";
        }

        string leftCode = string(*left);
        string rightCode = string(*right);

        if (type ==  ExpressionType::REFERENCE)
        {
                return leftCode + "[" + rightCode + "]";;
        }
        if (type  == ExpressionType::DOT_PRODUCT)
        {
                return  "Array::dotProduct(" + leftCode + ", " + rightCode + ")";
        }

        return  (type == ExpressionType::ASSIGNMENT ? string(indent, '\t') : "") + leftCode + ops[int(type)]  +  rightCode;
}
