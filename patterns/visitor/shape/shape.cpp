#include <iostream>
#include "shape.h"
#include "visitor.h"

const Vector2f& Shape::getCoord() const { return position; }

void Rectangle::draw() const {
  std::cout << "Rectangle: " << width << " by " << height << std::endl;
  std::cout << "Upper left corner at: " << getCoord() << std::endl;
}
void Rectangle::accept(Visitor * const v) { v->visit(this); }
void Circle::accept(Visitor * const v) { v->visit(this); }


void Circle::draw() const {
  std::cout << "Circle of radius: " << radius << std::endl;
  std::cout << "Radius at: " << getCoord() << std::endl;
}
