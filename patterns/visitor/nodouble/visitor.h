class Rectangle;
class Circle;

class Visitor {
public:
  virtual void visit(const Rectangle*, const Rectangle*) = 0;
  virtual void visit(const Circle*, const Circle*) = 0;
  virtual void visit(const Circle*, const Rectangle*) = 0;
};

class AverageAreaVisitor : public Visitor {
public:
  AverageAreaVisitor() : sum(0), count(0) {}
  virtual void visit(const Rectangle*, const Rectangle*) ;
  virtual void visit(const Circle*, const Circle*) ;
  virtual void visit(const Circle*, const Rectangle*) ;
  float getAvg() const { return (count > 0) ? sum/count : 0; }
private:
  float sum;
  unsigned int count;
};
