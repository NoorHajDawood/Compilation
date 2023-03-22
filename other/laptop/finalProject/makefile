vcompiler.exe: lex.yy.c vcompiler.tab.c
	gcc lex.yy.c vcompiler.tab.c -o vcompiler.exe

lex.yy.c: vcompiler.tab.c vcompiler.l
	flex vcompiler.l

vcompiler.tab.c: vcompiler.y
	bison -d vcompiler.y --debug

clean: 
	del lex.yy.c vcompiler.tab.c vcompiler.tab.h vcompiler.exe