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
  Rectangle(const std::string& n, float w, float h) : 
    Shape(n), width(w), height(h) {}
  virtual float area() const { return width*height; } 
private:
  float width;
  float height;
};

void printAreas(const std::vector<Shape*>& shapes) {
  for ( const Shape* s : shapes ) {
    std::cout << s->area() << std::endl;
  }
}

int main() {
  std::vector<Shape*> shapes;
  shapes.push_back( new Circle("circle", 5.0) );
  shapes.push_back( new Rectangle("rectangle", 5.0, 7.2) );
  shapes.push_back( new Circle("circle", 8.0) );
  printAreas(shapes);
}
