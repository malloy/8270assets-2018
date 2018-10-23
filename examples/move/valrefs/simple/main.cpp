#include <iostream>

int f() { return 7; }

void f(int& x) { std::cout << "l-value ref: " <<x<< std::endl; }
void f(int&& x) { std::cout << "r-value ref: " <<x<< std::endl; }

int main() {
  int x = 0;
  f(x);
  f(std::move(x));
  f(x+1);
  f(f());
}
