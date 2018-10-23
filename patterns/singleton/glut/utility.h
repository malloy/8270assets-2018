// This file was written by Dr. Donald House

#include <stdlib.h>
#include <stdio.h>

#ifndef PI
#define PI 3.1415926535897
#endif

#define RAD2DEG (180/PI)
#define DEG2RAD (PI/180)

#define DegToRad(x) ((x)*DEG2RAD)
#define RadToDeg(x) ((x)*RAD2DEG)

float getRandFloat(float min, float max) {
    return min + (rand() / (RAND_MAX + 1.0f)) * (max - min);
}

double randf(double max) {
    return (rand() / (double)(RAND_MAX)) * max;
}
