%{

#include "parse.tab.h"

%}

%option yylineno

letter      [a-zA-Z]
digit       [0-9]
ident       {letter}({letter}|{digit})*

%%

"**"      { return EXP; }
"="       { return EQ; }
{digit}+  { yylval.number = atoi(yytext);
            return NUMBER; 
          }
{ident}   {
            yylval.name = new char[yyleng+1];
            strcpy(yylval.name, yytext);
            return NAME; 
          }
"\n"      { return CR; }
<<EOF>>   { yyterminate(); }

%%
int yywrap() { 
  yylex_destroy();
  return 1; 
}
