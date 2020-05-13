%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
}

%token<ival> T_AING
%token<ival> T_SEM
%token<ival> T_TIPM
%token<ival> T_NUMES
%token<ival> T_PROG
%token T_NEWLINE T_QUIT

%type<ival> expression


%start cod

%%

cod:
	   | cod line
;

line: T_NEWLINE
     |expression T_NEWLINE { printf("\tCODIGO VALIDO \n");}
     | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;


expression: T_AING T_SEM T_TIPM T_NUMES T_PROG	{ $$ = $1; }
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
