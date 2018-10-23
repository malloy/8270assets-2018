#include <iostream>
#include <string>

extern int yyparse();

int main() {
  try {
    if ( !yyparse() ) {
      std::cout << "Cleaning up ..." << std::endl;
    }
  }
  catch ( const std::string& msg ) {
      std::cout << msg << std::endl;
  }
  catch ( ... ) {
      std::cout << "Uncaught exception!" << std::endl;
  }
  return 0;
}
