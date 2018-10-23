#include <iostream>

class A{
public:
  A() { std::cout << "default constructor" << std::endl; }
  A(int) { std::cout << "conversion constructor" << std::endl; }

  // Rule of 3:
  A(const A&) { std::cout << "copy constructor" << std::endl; }
  A& operator=(const A&) {
    std::cout << "copy assignment" << std::endl;
    return *this;
  }
  ~A() { std::cout << "destructor" << std::endl; }

  //********************* Rule of 5 adds two more ***********
  A(const A&&) { std::cout << "move constructor" << std::endl; }
  A& operator=(const A&&) {
    std::cout << "move assignment" << std::endl;
    return *this;
  }
};

int main() {
  A a, b;
  a = b;
  b = 99;
}
