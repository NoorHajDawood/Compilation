assignment1.exe: assignment1.c assignment1.h lex.yy.c
	gcc assignment1.c lex.yy.c -o assignment1.exe

lex.yy.c: assignment1.lex
	flex assignment1.lex

clean:
	del assignment1.exe lex.yy.c