// How many things are wrong with this class?

#include <cstring>
#include <iostream>
class string {
public:
  string() : buf(new char[1]) { buf[0] = '\0'; }
  string(const char* b) : buf(new char[strlen(b)+1]) { 
    strcpy(buf, b); 
  }
  ~string() { delete [] buf; }
  const char* getBuf() const { return buf; }
private:
  char * buf;
};

void crash(string s) {}

int main() {
  string x("cat"), y = x;
  crash(y);
}
