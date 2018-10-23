#include <cstdlib>  // for rand()
#include <iostream>

class Random {
public:
  Random() { 
    int seed = time(0);
    srand(seed); 
  }
  int operator()(int a, int b) const { 
    return (rand() % b) + a; 
  }
private:
  Random(const Random&);
  Random& operator=(const Random&);
};

int main() {
  Random random;
  std::cout << random(1,100) << std::endl;
}
