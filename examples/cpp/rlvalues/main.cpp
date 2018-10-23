#include <iostream>

class A{};

A fun() { return A(); }
A fun(A&& a) { 
  std::cout << "r-value reference" << std::endl;
  return A(); 
}
A fun(A& a) { 
  std::cout << "l-value reference" << std::endl;
  return A(); 
}

void f() {}

int main() {
  int x = 99;
  int& r = x;
  A a;
  A&& f();
  fun(a);
  fun(f());

  fun();
  std::cout << "x is: " << x << std::endl;
  std::cout << "r is: " << r << std::endl;
}
