#include <cstdlib>
#ifdef __APPLE__
#  include <GLUT/glut.h>
#else
#  include <GL/glut.h>
#endif

#include "utility.h"
#include "square.h"

Square::Square() : 
  width(20),
  x(rand() % (WIDTH-width)),
  y(rand() % (HEIGHT-width)),
  xspeed( getRandFloat(MIN_SPEED, MAX_SPEED) * ( rand()%2?1:-1 ) ),
  yspeed( getRandFloat(MIN_SPEED, MAX_SPEED) * ( rand()%2?1:-1 ) )
{ } 

void Square::update() {
  x+=xspeed;
  y+=yspeed;
  if ( x+width >= WIDTH || x < 0 ) {
    xspeed *= -1;;
  }
  if ( y+width >=  HEIGHT || y < 0 ) {
    yspeed *= -1;;
  }
} 

void Square::draw() {
  glColor3f(1, 0, 1);
  glBegin(GL_POLYGON);
    glVertex2i(x, y);
    glVertex2i(x+width, y);
    glVertex2i(x+width, y+width);
    glVertex2i(x, y+width);
  glEnd();
}
