
CC = g++
LIB =
OBJ = 	main.o
FLAGS = -Wall -Weffc++ -c
EXE = run

$(EXE): $(OBJ)
	$(CC) $(OBJ) $(LIB)  -o $(EXE)

.c.cpp.o: $.h
	$(CC) $(FLAGS) $< 
	
clean:
	 rm -rf *.o $(EXE)

