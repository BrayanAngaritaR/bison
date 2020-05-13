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


%token<sval> T_PAIS T_I T_NUM
%token T_NEWLINE T_QUIT


%type<sval> expression


%start fyc

%%

fyc:
	   | fyc line
;

line: T_NEWLINE
    | expression T_NEWLINE { printf("\tVALIDO\n");}
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;


expression: T_PAIS T_I T_NUM				{ $$ = $1; }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
