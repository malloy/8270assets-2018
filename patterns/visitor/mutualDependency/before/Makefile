CCC= g++
CCFLAGS=

run:	main.o a.o b.o
	$(CCC) $(CCFLAGS) -o run main.o a.o b.o

main.o:	main.cpp
	$(CCC) $(CCFLAGS) -c main.cpp

a.o: a.cpp a.h
	$(CCC) $(CCFLAGS) -c a.cpp

b.o: b.cpp b.h
	$(CCC) $(CCFLAGS) -c b.cpp

clean:
	rm -f *.o run core
