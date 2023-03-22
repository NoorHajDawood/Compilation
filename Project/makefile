another.exe: lex.yy.c another.tab.c
	gcc lex.yy.c another.tab.c -o another.exe

lex.yy.c: another.tab.c another.l
	flex another.l

another.tab.c: another.y
	bison -d another.y

clean: 
	del lex.yy.c another.tab.c another.tab.h another.exe
