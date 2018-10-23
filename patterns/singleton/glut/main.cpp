//   Sample OpenGL/GLUT Program to animate a Square 
//   Brian A. Malloy
//   This is a good example of the singleton pattern to enable
//   callbacks for OpenGL. We use the singleton to obviate the
//   inclusion of the "this" pointer to the static callback function
//   and enable us to use GLUT w/out global variables, sans constants

#include <iostream>
#include <cstdlib>
#ifdef __APPLE__
#  include <GLUT/glut.h>
#else
#  include <GL/glut.h>
#endif
#include "square.h"

class Manager {
public:
  static Manager* getInstance() {
    if ( !instance ) {
      instance = new Manager;
    }
    return instance;
  }
  void display() {
    glClear(GL_COLOR_BUFFER_BIT); 
    square.draw();
    glutSwapBuffers();
  }
  void update() { square.update(); }

  void updateAnimation(int) {
    int delay;
    update();
    glutPostRedisplay();
    time = glutGet(GLUT_ELAPSED_TIME);
    delay = DELAY - (time - oldtime);
    oldtime = time;
    if (delay < 0) delay = 0;
    glutTimerFunc(delay, Manager::wrapperForAnimation, 0);
  } 
  static void wrapperForDisplay() {
    Manager::getInstance()->display();
  }
  static void wrapperForAnimation(int extra) {
    Manager::getInstance()->updateAnimation(extra);
  }
private:
  Manager() : square(), time(0), oldtime(0) {}
  Manager(const Manager&);
  Manager* operator=(const Manager&);
  static Manager* instance;
  Square square;
  int time;
  int oldtime;
};

void handleKey(unsigned char key, int, int) {
  switch(key){
    case 'q': case 'Q': case 27: exit(0);
    default: return; // not a valid key -- ignore it
  }
}

void initGlut(int argc, char* argv[]) {
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
  glutInitWindowPosition(200,0);
  glutInitWindowSize(WIDTH, HEIGHT);
  glutCreateWindow("A Bouncing Square");
  gluOrtho2D(0, WIDTH, 0, HEIGHT);
  glClearColor(255, 255, 255, 0);
  glutDisplayFunc( Manager::wrapperForDisplay );	
  glutKeyboardFunc(handleKey);	
  glutTimerFunc(0, Manager::wrapperForAnimation, 0);
}

Manager* Manager::instance = NULL;

int main(int argc, char* argv[]) {
  initGlut(argc, argv);
  glutMainLoop();
  return 0;
}
