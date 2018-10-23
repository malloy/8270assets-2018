#include <iostream>
#include <string>

class Pokemon {
public:
  Pokemon(const char* s) : name(s) {}
  const std::string& getName() const { return name; }
private:
  std::string name;
};

int main() {
  Pokemon p("Regirock");
  std::cout << p.getName() << std::endl;
}
