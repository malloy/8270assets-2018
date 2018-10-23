%{
#include <iostream>
#include <map>
extern int yylex();
std::map<std::string, int> table;

void yyerror(const char * msg);
int power(int, int);
%}

%union {
  char* name;
  int number;
}

%token CR NUMBER EQ
%right EXP
%type<number> lines expr
%token<name> NAME

%%
lines   : lines expr CR
          { std::cout << $2 << std::endl; }
        | lines NAME EQ expr CR
          { table[$2] = $4;               
            delete [] $2;
          }
        | lines CR
        | { ; }
        ;

expr    : expr EXP expr   { $$ = power($1, $3); }
        | NUMBER          { $$ = yylval.number;      }
        | NAME            { $$ = table[$1];
                            delete [] $1;
                          }
        ;
%%
void yyerror(const char * msg) { 
  std::cout << msg << std::endl; 
}

int power(int base, int exp) {
  int result = 1;
  for (int i = 0; i < exp; ++i) {
    result *= base;
  }
  return result;
}

