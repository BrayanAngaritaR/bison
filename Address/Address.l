%option noyywrap
%{<br />#include <stdio.h>
#define YY_DECL int yylex()
#include "Address.h"
%}
%%
((carrera)|(Carrera)|(calle)|(Calle)|(circular)|(Circular)|(transversal)|(Transversal)|(diagonal)|(Diagonal))[ \t]?([1-9])([0-9]?)([0-9]?)[ \t]?([a-f]?)([a-f]?)([A-F]?)([A-F]?)[ \t]?((sur)|(Sur)|(norte)|(Norte))?[ \t]?(#)[ \t]?([1-9])([0-9]?)([0-9]?)[ \t]?([a-f]?)([a-f]?)([A-F]?)([A-F]?)[ \t]?((sur)|(Sur)|(norte)|(Norte))?[ \t]?("-")[ \t]?([1-9])([0-9]?)([0-9]?) { return T_DIRECCION; }
\n				{return T_NEWLINE;}

%%