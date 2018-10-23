#include <iostream>
#include <cstring>

class string {
public:
  string() : buf(new char[1]) {
    buf[0] = '\0';
  }
  string(const char* s) : buf(new char[strlen(s)+1]) {
    strcpy(buf, s);
  }
  string(const string& s) : buf(new char[strlen(s.buf)+1]) {
    strcpy(buf, s.buf);
  }
  ~string() { delete [] buf; }  // s/ destructors always be virtual

  string(string&& s) : buf(std::move(s.buf)) {
    s.buf = nullptr;
  }

  const char* getBuf() const { return buf; }

  string& operator=(const string& rhs) {
    if ( this == &rhs ) return *this;
    delete [] buf;
    buf = new char[strlen(rhs.buf)+1];
    strcpy(buf, rhs.buf);
    return *this;
  }

  string& operator=(string&& rhs) {
    buf = std::move(rhs.buf);
    rhs.buf = nullptr;
    return *this;
  }
private:
  char* buf;
};
std::ostream& operator<<(std::ostream& out, const string& s) {
  return out << s.getBuf();
}

int main() {
  string dog;
  dog = "dog";
  std::cout << dog << std::endl;
}
