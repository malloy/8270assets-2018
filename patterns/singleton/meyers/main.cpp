#include <cstdlib>  // for rand()
#include <iostream>

class Random {
public:
  static Random& getInstance();
  int operator()(int a, int b) const { 
    return (rand() % b) + a; 
  }
private:
  Random(const Random&);
  Random& operator=(const Random&);
  Random() { 
    int seed = time(0);
    srand(seed); 
  }
};
Random& Random::getInstance() {
  static Random instance;
  return instance;
}

int main() {
  Random& random = Random::getInstance();
  std::cout << random(1,100) << std::endl;
}
