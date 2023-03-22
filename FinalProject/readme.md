**How to generate compiler:**
- run *"make"* to generate another.exe (the *"another"* compiler)
- run *"make clean"* to clean generated files and compiler
- the make file is made for Windows, so adjust the make file accordingly

**To compile an *"another"* language file:**
- be *example.another* a file with *"another"* language code
- run *"another < example.another > example.cpp"* 
- generated output file *example.cpp* can be compiled with g++
- *ArrayUtils.hpp* is required to be in the same folder as *example.cpp* since it include the Array Utility library
- run *g++ example.cpp -o example.exe* to generate the executable
- run *.\example.exe* to execute
