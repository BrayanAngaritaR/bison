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



