## Address - Dirección

Archivo Address.l 

```
%option noyywrap
%{<br />#include <stdio.h>
#define YY_DECL int yylex()
#include "Address.h"
%}
%%
((carrera)|(Carrera)|(calle)|(Calle)|(circular)|(Circular)|(transversal)|(Transversal)|(diagonal)|(Diagonal))[ \t]?([1-9])([0-9]?)([0-9]?)[ \t]?([a-f]?)([a-f]?)([A-F]?)([A-F]?)[ \t]?((sur)|(Sur)|(norte)|(Norte))?[ \t]?(#)[ \t]?([1-9])([0-9]?)([0-9]?)[ \t]?([a-f]?)([a-f]?)([A-F]?)([A-F]?)[ \t]?((sur)|(Sur)|(norte)|(Norte))?[ \t]?("-")[ \t]?([1-9])([0-9]?)([0-9]?) { return T_DIRECCION; }
\n				{return T_NEWLINE;}

%%
```

Archivo Address.y

```
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
```

Método de compilación

```
bison -d Address.y
mv Address.tab.h Address.h
mv Address.tab.c Address.y.c
flex Address.l
mv lex.yy.c Address.lex.c
gcc -g -c Address.lex.c -o Address.lex.o
gcc -g -c Address.y.c -o Address.y.o
gcc -g -o Address Address.lex.o Address.y.o -lfl
```

Finalmente se abre con: `./Address`


___________________________

## Code - UNAULA Student Code

Archivo Code.l 

```
%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "Code.h"

%}
COD ^([1][9][789][0-9]|[1][9][6][9]|[2][0][0-9][0-9])[12][0-5][0-9][0-9][0-9]([1-6][0][1]|[3][0][2]|[7][0-9][0-9]|[8][0-9][0-9])$

AI	[1][9][789][0-9]|[1][9][6][9]|[2][0][0-9][0-9]
SEM	[12]
TM	[0-5]
NUMES	[0-9][0-9][0-9]
PROG	[1-6][0][1]|[3][0][2]|[7][0-9][0-9]|[8][0-9][0-9]
%%

[ \t]	; // ignore all whitespace
\n		{return T_NEWLINE;}
{AI}/{SEM}		{yylval.ival = atoi(yytext);return T_AING;}

{SEM}		{yylval.ival = atoi(yytext);return T_SEM;}
{TM}		{yylval.ival = atoi(yytext);return T_TIPM;}

{NUMES}/{PROG}		{yylval.ival = atoi(yytext);return T_NUMES;}
{PROG}		{yylval.ival = atoi(yytext);return T_PROG;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}

%%
```

Archivo Code.y

```
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
```

Método de compilación

```
bison -d Code.y
mv Code.tab.h Code.h
mv Code.tab.c Code.y.c
flex Code.l
mv lex.yy.c Code.lex.c
gcc -g -c Code.lex.c -o Code.lex.o
gcc -g -c Code.y.c -o Code.y.o
gcc -g -o Code Code.lex.o Code.y.o -lfl
```

Finalmente se abre con: `./Code`


___________________________

## Names

Archivo Names.l 

```
%option noyywrap

%{

#include <stdio.h>
#define YY_DECL int yylex()
#include "Names.h"

%}

NOM     [A-Za-z]+[ ]?|[A-Z][a-z]+[ ]?

%%

\n              {return T_NEWLINE;}
{NOM}      {yylval.sval = strdup(yytext);return T_NOM;}
"exit"          {return T_QUIT;}
"quit"          {return T_QUIT;}


%%
```

Archivo Names.y

```
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
```

Método de compilación

```
bison -d Names.y
mv Names.tab.h Names.h
mv Names.tab.c Names.y.c
flex Names.l
mv lex.yy.c Names.lex.c
gcc -g -c Names.lex.c -o Names.lex.o
gcc -g -c Names.y.c -o Names.y.o
gcc -g -o Names Names.lex.o Names.y.o -lfl
```

Finalmente se abre con: `./Names`


___________________________

## Phone Numbers

Archivo Numbers.l 

```
%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "Numbers.h"

%}

PAIS 	[+][5][7]
I 	[1245678]|[3][0][1-5]|[3][1][0-9]|[3][2][123]|[3][5][01]
NUM 	[2-9][0-9][0-9][0-9][0-9][0-9][0-9]

%%

[ \t]	; 
\n		{return T_NEWLINE;}
{PAIS}	    {return T_PAIS;}
{I}/{NUM}	{return T_I;}
{NUM}$	    {return T_NUM;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}

%%
```

Archivo Numbers.y

```
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
```

Método de compilación

```
bison -d Numbers.y
mv Numbers.tab.h Numbers.h
mv Numbers.tab.c Numbers.y.c
flex Numbers.l
mv lex.yy.c Numbers.lex.c
gcc -g -c Numbers.lex.c -o Numbers.lex.o
gcc -g -c Numbers.y.c -o Numbers.y.o
gcc -g -o Numbers Numbers.lex.o Numbers.y.o -lfl
```

Finalmente se abre con: `./Numbers`


___________________________

## Calculator

Archivo Calculator.l 

```
%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "Calculator.h"

%}

%%

[ \t]	; // ignore all whitespace
[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+		{yylval.ival = atoi(yytext); return T_INT;}
\n		{return T_NEWLINE;}
"+"		{return T_PLUS;}
"-"		{return T_MINUS;}
"*"		{return T_MULTIPLY;}
"/"		{return T_DIVIDE;}
"("		{return T_LEFT;}
")"		{return T_RIGHT;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}

%%

```

Archivo Calculator.y

```
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
	float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expression
%type<fval> mixed_expression

%start calculation

%%

calculation:
	   | calculation line
;

line: T_NEWLINE
    | mixed_expression T_NEWLINE { printf("\tResult: %f\n", $1);}
    | expression T_NEWLINE { printf("\tResult: %i\n", $1); }
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

mixed_expression: T_FLOAT                 		 { $$ = $1; }
	  | mixed_expression T_PLUS mixed_expression	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS mixed_expression	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY mixed_expression { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | T_LEFT mixed_expression T_RIGHT		 { $$ = $2; }
	  | expression T_PLUS mixed_expression	 	 { $$ = $1 + $3; }
	  | expression T_MINUS mixed_expression	 	 { $$ = $1 - $3; }
	  | expression T_MULTIPLY mixed_expression 	 { $$ = $1 * $3; }
	  | expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | mixed_expression T_PLUS expression	 	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS expression	 	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY expression 	 { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE expression	 { $$ = $1 / $3; }
	  | expression T_DIVIDE expression		 { $$ = $1 / (float)$3; }
;

expression: T_INT				{ $$ = $1; }
	  | expression T_PLUS expression	{ $$ = $1 + $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
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
```

Este código requiere GMP.

Primero debe ejecutarse: 

`apt-get install  libgmp3-dev`


Método de compilación

```
bison -d Calculator.y
mv Calculator.tab.h Calculator.h
mv Calculator.tab.c Calculator.y.c
flex Calculator.l
mv lex.yy.c Calculator.lex.c
gcc -g -c Calculator.lex.c -o Calculator.lex.o
gcc -g -c Calculator.y.c -o Calculator.y.o
gcc -g -o Calculator Calculator.lex.o Calculator.y.o -lfl
```

Finalmente se abre con: `./Calculator`


___________________________