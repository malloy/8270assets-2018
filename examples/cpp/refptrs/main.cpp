#include <iostream>
class A{};

A f() {}

void fun(A&) {
  std::cout << "l value ref" << std::endl;
}

void fun(A&&) {
  std::cout << "r value ref" << std::endl;
}

int main() {
  int x = 99;
  int* p;
  int& r = x;
  r = 17;
  A&& q = f();
  A a;
  fun(q);
  fun(a);
}
