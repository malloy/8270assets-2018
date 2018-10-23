#include "cmath"
#include "visitor.h"
#include "shape.h"
const float  PI_F=3.14159265358979f;

void AverageAreaVisitor::visit(const Rectangle * rectangle) {
   float area = rectangle->getWidth() * rectangle->getHeight();
   sum += area;
   ++count;
}

void AverageAreaVisitor::visit(const Circle * circle) {
   float area = PI_F * pow(circle->getRadius(), 2);
   sum += area;
   ++count;
}
