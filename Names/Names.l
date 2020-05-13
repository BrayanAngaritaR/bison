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
