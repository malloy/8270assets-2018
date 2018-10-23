#include <cstdlib>  // for rand()
#include <iostream>

class Random {
public:
  static Random* getInstance();
  int operator()(int a, int b) const { 
    return (rand() % b) + a; 
  }
private:
  static Random* instance;
  Random(const Random&);
  Random& operator=(const Random&);
  Random() { 
    int seed = time(0);
    srand(seed); 
  }
};
Random* Random::getInstance() {
  if ( !instance ) instance = new Random;
  return instance;
}
Random* Random::instance = NULL;

int main() {
  Random* random = Random::getInstance();
  std::cout << (*random)(1,100) << std::endl;
  delete random;
}
