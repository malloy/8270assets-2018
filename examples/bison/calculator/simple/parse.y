%{
#include <iostream>
extern int yylex();
extern int yylval;
void yyerror(const char * msg);
%}

%token CR NUMBER
%left PLUS MINUS
%left MULT DIV

%%
lines   : lines expr CR
        | lines CR
        | 
        ;

expr    : expr PLUS expr
        | expr MINUS expr
        | expr MULT expr
        | expr DIV expr
        | NUMBER
        ;
%%
void yyerror(const char * msg) { std::cout << msg << std::endl; }
