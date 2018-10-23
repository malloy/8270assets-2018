#include <iostream>
#include <vector>
#include <string>

class Shape {
public:
  Shape(const std::string& n) : name(n) {}
  const std::string& getName() const { return name; }
  virtual float area() const = 0;
private:
  std::string name;
};

class Circle : public Shape {
public:
  Circle(const std::string& n, float r) : Shape(n), radius(r) {}
  virtual float area() const { return 3.14*radius*radius; } 
private:
  float radius;
};

class Rectangle : public Shape {
public:
  Rectangle(const std::string& n, int w, int h) :
    Shape(n), width(w), height(h) {}
  virtual float area() const { return width*height; } 
private:
  int width;
  int height;
};

void printArea(const Shape* s) {
  std::cout << s->getName() << ", " << s->area() << std::endl;
}

int main() {
  Shape* shape = new Circle("circle", 5.0);
  printArea(shape);
}
