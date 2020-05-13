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



