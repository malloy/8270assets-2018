#include <typeinfo>

#include "cmath"
#include "visitor.h"
#include "shape.h"
const float  PI_F=3.14159265358979f;

void AverageAreaVisitor::visit(const Rectangle* rectangle, 
                               const Rectangle*) {
   float area = rectangle->getWidth() * rectangle->getHeight();
   sum += area;
   ++count;
}

void AverageAreaVisitor::visit(const Circle* circle, const Circle*) {
   float area = PI_F * pow(circle->getRadius(), 2);
   sum += area;
   ++count;
}

void AverageAreaVisitor::visit(const Circle* circle, const Rectangle* c) {
   std::cout << "circle: " << typeid(circle).name() << std::endl;
   std::cout << "circle: " << typeid(c).name() << std::endl;
   float area = PI_F * pow(circle->getRadius(), 2);
   sum += area;
   ++count;
}

