Performed by Halel Sarusi - 207055435

- Attached is an input.text file containing the requested sample.
- To run:
    1.flex vcompiler.l     
    2.bison -d vcompiler.y
    3.gcc lex.yy.c vcompiler.tab.c -o vcompiler.exe
    4.vcompiler.exe input.text output.c 
    5.gcc output.c -o output.exe
    6.output.exe