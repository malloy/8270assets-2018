CFLAGS  = -g -Wall -Weffc++ -Wextra -pedantic
LDFLAGS = -lm

run:	main.o
	g++ ${CFLAGS} -o run main.o ${LDFLAGS}

main.o:	main.cpp
	g++ ${CFLAGS} -c main.cpp

clean:
	rm -rf *.o
	rm -rf *~
	rm -rf run a.out
