#include "vector2f.h"

class Visitor;

class Shape {
public:
  Shape(float x, float y) : position(x, y) {}
  const Vector2f& getCoord() const;
  virtual void draw() const = 0;
  virtual void accept(Visitor * const) = 0;
private:
  Vector2f position;
};

class Rectangle : public Shape {
public:
  Rectangle(float x, float y, float w, float h) : 
    Shape(x, y), width(w), height(h) {}
  float getWidth() const { return width; }
  float getHeight() const { return height; }
  virtual void draw() const;
  virtual void accept(Visitor * const v);
private:
  float width, height;
};

class Circle : public Shape {
public:
  Circle(float x, float y, float r) : Shape(x, y), radius(r) {}
  float getRadius() const { return radius; }
  virtual void draw() const;
  virtual void accept(Visitor * const v) ;
private:
  float radius;
};
