// This file contains global constants and class Square;
// all global constants s/b in an XML file so that they can
// be modified w/out recompiling any modules.

const int WIDTH = 640;
const int HEIGHT =  480;
const float MIN_SPEED = 0.5;
const float MAX_SPEED = 0.9;
const int DELAY = 25;

class Square {
public:
  Square();
  void update();
  void draw();

private:
  int width;
  float x;
  float y;
  float xspeed;
  float yspeed;
};

