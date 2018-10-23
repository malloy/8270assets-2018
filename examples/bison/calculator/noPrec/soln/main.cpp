#include <iostream>
extern int yyparse();

int main() {
  if ( yyparse() ) {
    std::cout << "syntactically correct program" << std::endl;
  }
  return 0;
}
