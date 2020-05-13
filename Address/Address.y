%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	char* sval;
}

%token<sval> T_DIRECCION

%token T_NEWLINE T_QUIT

%start calculation

%%

calculation: 
	| calculation line
;

line: T_NEWLINE
	| T_DIRECCION T_NEWLINE{ printf("\tDireccion correcta"); }
	| T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;
 
%%
int main()
{
	yyin = stdin;
	do { 
		yyparse();
	}
	while(!feof(yyin));
		return 0;
}

void yyerror(const char* s)
{
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}