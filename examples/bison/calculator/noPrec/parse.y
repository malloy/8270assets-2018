%{
#include <iostream>
extern int yylex();
extern int yylval;
void yyerror(const char * msg);
%}

%token CR NUMBER PLUS MINUS MULT DIV

%%
lines   : lines expr CR
        | lines CR
        | 
        ;

expr    : expr PLUS term
        | expr MINUS term
        | term
        ;

term    : term MULT factor
        | term DIV factor
        | factor
        ;

factor  : NUMBER
        ;
%%
void yyerror(const char * msg) { std::cout << msg << std::endl; }
