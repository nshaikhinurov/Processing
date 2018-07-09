import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

float inc = 0.01;
float start = 0;

void setup(){
  size(1000, 1000);
  // noLoop();
}

void draw(){
  background(blackColor);
  stroke(whiteColor);
  line(0,0.5*height,width,0.5*height);
  noFill();
  beginShape();
  float xOff = start;

  for (float x = 0; x < width; x++){
    float y = noise(xOff) * height;
    vertex(x,y);
    xOff += inc;
  }
  endShape();
  start += inc;
}

void mouseClicked() {
  redraw();
}
