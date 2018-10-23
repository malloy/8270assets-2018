CXX = clang++

CXXFLAGS= -g -std=c++11 -W -Wall -Weffc++ -Wextra -pedantic -O0

OBJS = \
	main.o \
	vector2f.o \
	shape.o \
	visitor.o
EXEC = run

# $< refers to the first dependency
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# $@ refers to the target
$(EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDFLAGS)

vector2f.o: vector2f.cpp vector2f.h 
shape.o: shape.cpp shape.h visitor.h
visitor.o: visitor.cpp visitor.h shape.h
main.o: main.cpp shape.h visitor.h

clean:
	rm -rf $(OBJS)
	rm -rf $(EXEC)
