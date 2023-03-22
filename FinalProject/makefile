another: lex.yy.c another.tab.c
	g++ lex.yy.c another.tab.c -o another.exe

lex.yy.c: another.l
	flex another.l

another.tab.c: another.y
	bison -d another.y

clean:
	del lex.yy.c another.tab.* another.exe
