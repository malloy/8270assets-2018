%{
#include <iostream>
  int lines = 0;
  int words = 0;
  int chars = 0;
%}
word      [a-zA-Z]+

%%
{word}        { ++words; chars += strlen(yytext); }
"\n"          { ++lines; ++chars; }
.             { chars += strlen(yytext); }
%%
int yywrap() { return 1; }

