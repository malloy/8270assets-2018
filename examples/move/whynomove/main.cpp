#include <iostream>
#include <cstring>

class string {
public:
  string() : buf(new char[1]) {
    std::cout << "default" << std::endl;
    buf[0] = '\0';
  }
  string(const char* s) : buf(new char[strlen(s)+1]) {
    std::cout << "convert: " << this << std::endl;
    strcpy(buf, s);
  }
  string(const string& s) : buf(new char[strlen(s.buf)+1]) {
    std::cout << "copy" << std::endl;
    strcpy(buf, s.buf);
  }
  ~string() { 
    std::cout << "destruct: " << this << std::endl;
    delete [] buf; 
  }  // s/ destructors always be virtual

  string(string&& s) : buf(std::move(s.buf)) {
    std::cout << "move constructor" << std::endl;
    s.buf = nullptr;
  }

  const char* getBuf() const { return buf; }

  string& operator=(const string& rhs) {
    std::cout << "copy assignment" << std::endl;
    if ( this == &rhs ) return *this;
    delete [] buf;
    buf = new char[strlen(rhs.buf)+1];
    strcpy(buf, rhs.buf);
    return *this;
  }

  string& operator=(string&& rhs) {
    std::cout << "move assignment" << std::endl;
    std::swap(buf, rhs.buf);
    return *this;
  }
private:
  char* buf;
};
std::ostream& operator<<(std::ostream& out, const string& s) {
  std::cout << "output operator" << std::endl;
  return out << s.getBuf();
}

void print(string&& s) {
  std::cout << "print fun: " << &s << std::endl;
  std::cout << s << std::endl;
}

void fun(const string&) {
  std::cout << "l-value ref" << std::endl;
}
void fun(string&&) {
  std::cout << "r-value ref" << std::endl;
}

int main() {
  print( "cat" );
  //fun( "cat" );
}
