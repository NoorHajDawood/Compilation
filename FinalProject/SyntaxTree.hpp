#ifndef _AST_HH_
#define _AST_HH_

#include <string>
#include <list>
#include <initializer_list>

using namespace std;

enum class ExpressionType
{
        ADDITION,
        SUBSTRACTION,
        MULTIPLICATION,
        DIVISION,
        ASSIGNMENT,
        LESS,
        GREATER,
        LESSEQUAL,
        GREATEREQUAL,
        EQUAL,
        NOTEQUAL,
        DOT_PRODUCT,
        REFERENCE,
        PARENTHESIS
};

class Node
{
public:
        virtual operator string() const = 0;
};

class Number : public Node
{
private:
        int value;
public:
        Number(int value);
        operator string() const;
};

class Array : public Node
{
private:
        list<Node *> *expressionList;
public:
        Array();
        Array(list<Node *> *expressionList);
        operator string() const;
};

class Name : public Node
{
private:
        string name;
public:
        Name(string name);
        operator string() const;
};

class Declarator : public Node
{
private:
        bool isInt;
        list<string> *nameList;
public:
        Declarator(bool isInt, list<string> *nameList);
        operator string() const;
};

class Print : public Node
{
private:
        list<Node *> *expressionList;
public:
        Print(list<Node *> *expressionList);
        operator string() const;
};

class Conditional : public Node
{
private:
        Node *cond;
        list<Node *> *block;
public:
        Conditional(Node *cond, list<Node *> *block);
        operator string() const;
};

class Loop : public Node
{
private:
        Node *cond;
        list<Node *> *block;
public:
        Loop(Node *cond, list<Node *> *block);
        operator string() const;
};

class Expression : public Node
{
private:
        ExpressionType type;
        Node *left, *right, *expression;
public:
        Expression(Node *expression);
        Expression(Node *left, Node *right, ExpressionType);
        operator string() const;
};

#endif
