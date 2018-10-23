CC = g++
C  = cpp

# Lots of flags for warnings:
CFLAGS		= -g -O0 -Weffc++ -Wall -Wextra -pedantic

ifeq ("$(shell uname)", "Darwin")
  LDFLAGS = -framework Foundation -framework GLUT -framework OpenGL -lm
else
  ifeq ("$(shell uname)", "Linux")
    LDFLAGS = -L /usr/lib64/ -lglut -lGL -lGLU -lm -lexpat
  endif
endif


HFILES = square.h
OFILES = square.o

PROJECT		= main
EXEC		= run

${PROJECT}:	${PROJECT}.o ${OFILES}
	${CC} ${CFLAGS} -o ${EXEC} ${PROJECT}.o ${OFILES} ${LDFLAGS}

${PROJECT}.o:	${PROJECT}.${C} ${HFILES}
	${CC} ${CFLAGS} -c ${PROJECT}.${C}

square.o: square.${C} square.h
	${CC} ${CFLAGS} -c square.${C}

clean:
	rm -rf ${OFILES}
	rm -rf ${PROJECT}.o
	rm -rf ${EXEC}
