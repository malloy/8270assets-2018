// http://sourcemaking.com/design_patterns/visitor/cpp/2#
#include <iostream>
#include <list>
#include "shape.h"
#include "visitor.h"

void print(const std::list<Shape*> & shapes) {
  std::list<Shape*>::const_iterator ptr = shapes.begin();
  (*ptr)->draw();
}

float getArea(const std::list<Shape*> & shapes, 
              AverageAreaVisitor & areaVisitor) {
  for ( Shape* shape : shapes ) {
    // areaVisitor.visit(shape);
    shape->accept(&areaVisitor);
  }
  return areaVisitor.getAvg();
}

int main() {
  std::list<Shape *> shapes;
  shapes.push_back(new Circle(3, 3, 5));
  shapes.push_back(new Rectangle(0, 0, 3, 4));
  shapes.push_back(new Circle(0, 0, 5));
  print(shapes);
  AverageAreaVisitor areaVisitor;
  float area = getArea(shapes, areaVisitor);
  std::cout << "area of all shapes is: " << area << std::endl;
}
