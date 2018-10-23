%{
#include <iostream>
extern int yylex();
extern int yylval;
void yyerror(const char * msg);
%}

%token CR NUMBER PLUS MINUS MULT DIV

%%
lines   : lines expr CR
          { std::cout << "result: " << $2 << std::endl;  }
        | lines CR
        | 
        ;

expr    : expr PLUS term
          { $$ = $1 + $3;  }
        | expr MINUS term
          { $$ = $1 - $3;  }
        | term
          { $$ = $1;       }
        ;

term    : term MULT factor
          { $$ = $1 * $3;  }
        | term DIV factor
          { $$ = $1 / $3;  }
        | factor
          { $$ = $1;  }
        ;

factor  : NUMBER
        ;
%%
void yyerror(const char * msg) { std::cout << msg << std::endl; }
