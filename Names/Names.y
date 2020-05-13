%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
        char *sval;
}

%token<sval> T_NOM
%token T_NEWLINE T_QUIT

%start nom

%%

nom:
           | nom line
;
line: T_NEWLINE
     |expression T_NEWLINE { printf("\tNOMBRE VALIDO \n");}
     | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

expression: add | add1 | add2
;

add: T_NOM T_NOM  {printf("\tNOMBRE INGRESADO: %s%s\n",$1,$2);};
add1: T_NOM T_NOM T_NOM  {printf("\tNOMBRE INGRESADO: %s%s%s\n",$1,$2,$3);};
add2: T_NOM T_NOM T_NOM T_NOM  {printf("\tNOMBRE INGRESADO: %s%s%s%s\n",$1,$2,$3,$4);};

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
