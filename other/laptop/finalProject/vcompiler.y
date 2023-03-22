%{

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

void yyerror (char *s);
int yylex();

char buffer[256];
char operatorsBuffer[256];
char vecs[256][24];
char vecSizes[256][24];
int tmpVec[2] = {0,0};

char* loopFunction(char* str);
void null();
void  allocation(char* vector1,char* vector2);
char* tempVec(char* size);
void vecToScl(int* arr, int size, int val);
void addVector(char* vecName, char* size);
char* getVector(char* vector);
int bufferVec(char* name);
char* vecSize(char* name);
void printID(char* pos,char* exp,char* ansBuf,char* type);
void operatorToPrint(char* exprLeft,char* exprRight,char* opr,char* ansBuf,char* type);

extern FILE* yyout;
extern FILE* yyin;
int indexVecs = 0; int tempVecs = 0;

%}        

%start line
%token NUM SIZE ID SCALAR VECTOR OP PRINT LOOP IF ARR
%left <oper> ','
%left OP
%left '.' ':'
%left '(' ')'
%type <expression> expr term ID
%type <vectorType> ARR
%type <operator> OP '(' ')' '.'
%type <num> NUM SIZE

%union {
	char num[24]; 
	char id[124];
	char vectorType[24];
	char expression[124];
	char operator[1];
} 

%%

line				: statement ';'								{ null(); }
					| line statement ';'						{ null(); } 
					| assignment ';'							{ null(); }
					| line assignment ';'						{ null(); }
					| blockStatement block 						{ null(); }
					| line blockStatement block					{ null(); }
					;	
assignment			: term OP expr								{  allocation($1,$3); }
					;
statement			: declare									{ null(); }
					| PRINT expr								{ 	if(bufferVec($2)) 
																		fprintf(yyout, "\tprintVec(%s, %s);\n", $2, vecSize($2)); 
																	else if(tmpVec[0]) {
																		fprintf(yyout, "\tprintVec(tmp=%s, %d);\n", $2, tmpVec[1]); 
																		tmpVec[0]=0; 
																		fprintf(yyout, "\tfree(tmp);\n"); 
																	}
																	else fprintf(yyout, "\tprintf(\"%%d\\n\", %s);\n", $2); 
									 							}
					;
block				: '{' line '}'		                        { fprintf(yyout, "\t}\n"); }
					| '{' '}'			                        { fprintf(yyout, "\t}\n"); }
					;
blockStatement		: LOOP expr 								{ fprintf(yyout, "%s {\n", loopFunction($2)); }
					| IF expr								    { fprintf(yyout, "\tif(%s) {\n", $2); }
					;
declare				: SCALAR ID								    { fprintf(yyout, "\tint %s;\n", $2);}
					| VECTOR ID SIZE							{  	strcpy($3, $3+1); 
																	int len = strlen($3); 
																	$3[len-1]='\0'; 
																	fprintf(yyout, "\tint %s[%s];\n", $2, $3); 
																	addVector($2, $3);
																}		
					;
expr				: term										{ null(); }
					| expr OP expr								{ operatorToPrint($1,$2,$3,$$,"op"); }
					| expr ',' expr								{ if(bufferVec($1)) {
																	fprintf(yyout, "\tprintVec(%s, %s);\n", $1, vecSize($1)); 
																	strcpy($$, $3);}
																  else  
																	fprintf(yyout, "\tprintf(\"%%d\\n\", %s);\n", $1);
																  strcpy($$, $3);
																}
					| '(' expr ')'		                        { 	if(bufferVec($2)) 
																		strcpy($$, $2);
																	else { 
																		strcpy($$, "("); 
																		strcat($$, $2); 
																		strcat($$, ")"); 
																	}
																}
					| expr '.' term								{ operatorToPrint($1,$3,NULL,$$,"dot"); }													  
					;
term				: NUM										{ null(); }
					| ID									    { null(); }
					| ARR										{ strcpy($$, getVector($1)); }
					| ARR ':' expr							    { printID($1,$3,$$,"array"); }
					| ID ':' expr						        { printID($1,$3,$$,"identifier"); }
					;	
	
%%                     

char* loopFunction(char* str) {
	buffer[0] = '\0';
	strcat(buffer, "\tfor(iter_idx=0; iter_idx<");
	strcat(buffer, str);
	strcat(buffer, "; iter_idx++)");
	return buffer;
}

void null(){
	buffer[0] = '\0';
	tmpVec[0] = 0;
	tmpVec[1] = 0;
}

void  allocation(char* vector1,char* vector2) {
	if(bufferVec(vector1) && bufferVec(vector2)) { 
		fprintf(yyout, "\tvecToVec(%s, %s, %s);\n", vector1, vecSize(vector1), vector2);
	}
	else if(bufferVec(vector1) && tmpVec[0]) { 
		fprintf(yyout, "\tvecToVec(%s, %s, tmp=%s);\n", vector1, vecSize(vector1), vector2); 
		tmpVec[0]=0; fprintf(yyout, "\tfree(tmp);\n"); 
	}
	else if(bufferVec(vector1) && !bufferVec(vector2) ) 
		fprintf(yyout, "\tvecToScl(%s, %s, %s);\n", vector1, vecSize(vector1), vector2);
	else 
		fprintf(yyout, "\t%s%s%s;\n", vector1, "=", vector2);
}

char* tempVec(char* size) {
	buffer[0] = '\0';
	char charNum[12];
	strcat(buffer, "int* tempVec");
	strcat(buffer, itoa(tempVecs++, charNum, 10));
	strcat(buffer, " = ");
	strcat(buffer, operatorsBuffer);
	fprintf(yyout, "\t%s;\n", buffer);
	char vectorsName[24];
	strcpy(vectorsName, "tempVec");
	strcat(vectorsName, charNum);
	addVector(vectorsName, size);
	strcpy(buffer, vectorsName);
	return buffer;
}

void vecToScl(int* arr, int size, int val) {
	for(int i=0; i<size; i++) {
		fprintf(yyout,"%s",arr[i] = val);
	}
}

void addVector(char* vecName, char* size) {
	strcpy(vecs[indexVecs], vecName);
	strcpy(vecSizes[indexVecs], size);
	indexVecs++;
}

char* getVector(char* vector) {
	int length = strlen(vector);
	char charNum[12];
	int count = 1;
	for( int i=0; i<length; i++) {
		if(vector[i] == '[') vector[i] = '{';
		if(vector[i] == ']') vector[i] = '}';
		if(vector[i] == ',') count++;
	}
	buffer [0] = '\0';
	strcat(buffer, "int tmpVec");
	strcat(buffer, itoa(tempVecs++, charNum, 10));
	strcat(buffer, "[] = ");
	strcat(buffer, vector);
	char vectorsName[24];
	strcpy(vectorsName, "tmpVec");
	strcat(vectorsName, charNum);
	addVector(vectorsName, itoa(count, charNum, 10));
	fprintf(yyout, "\t%s;\n", buffer);
	strcpy(buffer, vectorsName);

	return buffer;
}

int bufferVec(char* name) {
	for(int i = 0; i<indexVecs; i++) {
		if(strcmp(vecs[i], name) == 0) 
			return 1;
	}
	return 0;
}

char* vecSize(char* name) {
	for(int i = 0; i<indexVecs; i++) {
		if(strcmp(vecs[i], name) == 0) 
			return vecSizes[i];
	}
	return "0";
}

void printID(char* pos,char* exp,char* ansBuf,char* type) {
	if(type == "array")
		strcpy(pos, getVector(pos));
	if(bufferVec(exp)) { 
		buffer[0]='\0'; 
		strcpy(buffer, "vectorsIndex("); 
		strcat(buffer, pos); 
		strcat(buffer, ","); 
		strcat(buffer, vecSize(pos)); 
		strcat(buffer, ","); 
		strcat(buffer, exp); 
		strcat(buffer, ")"); 
		strcpy(operatorsBuffer, buffer); 
		strcpy(ansBuf, tempVec(vecSize(exp)));
	} 
	else { 
		buffer[0]='\0'; 
		strcat(buffer, pos); 
		strcat(buffer, "["); 
		strcat(buffer, exp); 
		strcat(buffer,"]"); 
		strcpy(ansBuf, buffer); 
	}
}

void operatorToPrint(char* exprLeft,char* exprRight,char* operator,char* ansBuf,char* type) {
	if(type == "op"){
		if(bufferVec(exprLeft) && bufferVec(operator)) { 
			operatorsBuffer[0] = '\0'; 
			strcpy(operatorsBuffer, "vecOpVec("); 
			strcat(operatorsBuffer, exprLeft); 
			strcat(operatorsBuffer, ", "); 
			strcat(operatorsBuffer, vecSize(exprLeft)); 
			strcat(operatorsBuffer, ", "); 
			strcat(operatorsBuffer, operator); 
			strcat(operatorsBuffer, ", '"); 
			strcat(operatorsBuffer, exprRight); 
			strcat(operatorsBuffer, "')"); 
			strcpy(ansBuf, tempVec(vecSize(exprLeft))); 
		}
		else if(!bufferVec(exprLeft) && bufferVec(operator)) { 
			operatorsBuffer[0] = '\0'; 
			strcpy(operatorsBuffer, "vecOpScl("); 
			strcat(operatorsBuffer, operator); 
			strcat(operatorsBuffer, ", "); 
			strcat(operatorsBuffer, vecSize(operator)); 
			strcat(operatorsBuffer, ", "); 
			strcat(operatorsBuffer, exprLeft); 
			strcat(operatorsBuffer, ", '"); 
			strcat(operatorsBuffer, exprRight); 
			strcat(operatorsBuffer, "')"); 
			strcpy(ansBuf, tempVec(vecSize(operator)));
		}
		else if(bufferVec(exprLeft) && !bufferVec(operator)) { 
			operatorsBuffer[0] = '\0'; 
			strcpy(operatorsBuffer, "vecOpScl("); 
			strcat(operatorsBuffer, exprLeft); 
			strcat(operatorsBuffer, ", "); 
			strcat(operatorsBuffer, vecSize(exprLeft)); 
			strcat(operatorsBuffer, ", "); 
			strcat(operatorsBuffer, operator); 
			strcat(operatorsBuffer, ", '"); 
			strcat(operatorsBuffer, exprRight); 
			strcat(operatorsBuffer, "')"); 
			strcpy(ansBuf, tempVec(vecSize(exprLeft)));
		}
		else {
			buffer[0]='\0'; 
			strcat(buffer, exprLeft); 
			strcat(buffer, exprRight); 
			strcat(buffer, operator); 
			strcpy(ansBuf, buffer); 
		} 
	}
	else if(type == "dot") {
		strcpy(ansBuf, "\tvecDotVec("); 
		strcat(ansBuf, exprLeft); 
		strcat(ansBuf, ", "); 
		strcat(ansBuf, vecSize(exprLeft)); 
		strcat(ansBuf, ", "); 
		strcat(ansBuf, exprRight); 
		strcat(ansBuf, ")");
	}
}

void buildFile() {
	char buildFunctions[2048];
	buildFunctions[0] = '\0';

	strcat(buildFunctions, "#include <stdio.h>\n");
	strcat(buildFunctions, "#include <stdlib.h>\n\n");

	strcat(buildFunctions, "void vecToScl(int* arr, int size, int val) {\n");
	strcat(buildFunctions, "\tfor(int i=0; i<size; i++) {\n");
	strcat(buildFunctions, "\t\tarr[i] = val;\n");
	strcat(buildFunctions, "\t}\n");
	strcat(buildFunctions, "}\n\n");

	strcat(buildFunctions, "void vecToVec(int* arr, int size, int* arr2) {\n");
	strcat(buildFunctions, "\tfor(int i=0; i<size; i++) {\n");
	strcat(buildFunctions, "\t\tarr[i] = arr2[i];\n");
	strcat(buildFunctions, "\t}\n");
	strcat(buildFunctions, "}\n\n");

	strcat(buildFunctions, "int* vectorsIndex(int* arr, int size, int* arr2) {\n");
	strcat(buildFunctions, "\tint* tmp = malloc(sizeof(int)*size);\n");
	strcat(buildFunctions, "\tfor(int i=0; i<size; i++) {\n");
	strcat(buildFunctions, "\t\ttmp[i] = arr[arr2[i]];\n");
	strcat(buildFunctions, "\t}\n");
	strcat(buildFunctions, "\treturn tmp;\n");
	strcat(buildFunctions, "}\n\n");

	strcat(buildFunctions, "int* vecOpScl(int* arr, int size, int scl, char op) {\n");
	strcat(buildFunctions, "\tint* tmp = malloc(sizeof(int)*size);\n");
	strcat(buildFunctions, "\tswitch(op) {\n");
	strcat(buildFunctions, "\t\tcase '+':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] + scl;\n\t\t\tbreak;\n");
	strcat(buildFunctions, "\t\tcase '-':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] - scl;\n\t\t\tbreak;\n");
	strcat(buildFunctions, "\t\tcase '*':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] * scl;\n\t\t\tbreak;\n");
	strcat(buildFunctions, "\t\tcase '/':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] / scl;\n\t\t\tbreak;\n\t\t}\n");
	strcat(buildFunctions, "\treturn tmp;\n");
	strcat(buildFunctions, "}\n\n");

	strcat(buildFunctions, "int* vecOpVec(int* arr, int size, int* arr2, char op) {\n");
	strcat(buildFunctions, "\tint* tmp = malloc(sizeof(int)*size);\n");
	strcat(buildFunctions, "\tswitch(op) {\n");
	strcat(buildFunctions, "\t\tcase '+':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] + arr2[i];\n\t\t\tbreak;\n");
	strcat(buildFunctions, "\t\tcase '-':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] - arr2[i];\n\t\t\tbreak;\n");
	strcat(buildFunctions, "\t\tcase '*':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] * arr2[i];\n\t\t\tbreak;\n");
	strcat(buildFunctions, "\t\tcase '/':\n\t\t\tfor(int i=0; i<size; i++) tmp[i] = arr[i] / arr2[i];\n\t\t\tbreak;\n\t\t}\n");
	strcat(buildFunctions, "\treturn tmp;\n");
	strcat(buildFunctions, "}\n\n");

	strcat(buildFunctions, "int vecDotVec(int* arr, int size, int* arr2) {\n");
	strcat(buildFunctions, "\tint sum = 0;\n");
	strcat(buildFunctions, "\tfor(int i=0; i<size; i++) { sum += arr[i] * arr2[i]; }\n");
	strcat(buildFunctions, "\treturn sum;\n");
	strcat(buildFunctions, "}\n\n");

	strcat(buildFunctions, "void printVec(int* arr, int size) {\n");
	strcat(buildFunctions, "\tprintf(\"[\");\n");
	strcat(buildFunctions, "\tfor(int i=0; i<size-1; i++) {\n");
	strcat(buildFunctions, "\t\tprintf(\"%d, \", arr[i]);\n");
	strcat(buildFunctions, "\t}\n");
	strcat(buildFunctions, "\tprintf(\"%d\", arr[size-1]);\n");
	strcat(buildFunctions, "\tprintf(\"]\\n\");\n");
	strcat(buildFunctions, "}\n\n");

	strcat(buildFunctions, "int main(void) {\n\n");
	strcat(buildFunctions, "\tint iter_idx=0;\n\n");

	fprintf(yyout, "%s", buildFunctions);
}

int main (int argc, char** argv) {
	yyin = fopen(argv[1], "r");
	yyout = fopen(argv[2], "w");

	if(yyin == NULL) {
		printf("problem! The input file did not open '%s'\n", argv[1]);
		return 1;
	}
	if(yyout == NULL) {
		printf("problem! The output file did not open '%s'\n", argv[2]);
		return 1;
	}
	buildFile();
	yyparse ();	
	fprintf(yyout, "\treturn 0;\n}");
	return 0;
}

void yyerror (char *s) { fprintf (stderr, "%s\n", s); } 