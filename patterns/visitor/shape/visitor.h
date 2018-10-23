class Visitor {
public:
  virtual void visit(const class Rectangle * ) = 0;
  virtual void visit(const class Circle * ) = 0;
};

class AverageAreaVisitor : public Visitor {
public:
  AverageAreaVisitor() : sum(0), count(0) {}
  virtual void visit(const Rectangle * ) ;
  virtual void visit(const Circle * ) ;
  float getAvg() const { return (count > 0) ? sum/count : 0; }
private:
  float sum;
  unsigned int count;
};
