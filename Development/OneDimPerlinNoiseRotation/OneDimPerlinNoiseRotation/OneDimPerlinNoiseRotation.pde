import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

float inc = 0.01;
float start = 0;
int numberOfDots;

float[] xCoordinates;
float[] yCoordinates;

void setup(){
  size(1000, 1000);
  float radius = 0.25*width;
  numberOfDots = (int)(TWO_PI * radius / inc);
  xCoordinates = new float [numberOfDots];
  yCoordinates = new float [numberOfDots];
  for(int i = 0; i < numberOfDots; i++){
    xCoordinates[i] = 0;
    yCoordinates[i] = 0;
  }
  // noLoop();
}

void draw(){
  background(blackColor);
  translate(0.5*width,0.5*height);
  stroke(whiteColor);
  noFill();
  line(-0.5*width,0,0.5*width,0);

  float x = radius * cos(start) + random(5);
  float y = radius * sin(start) + random(5);
  noStroke();
  fill(whiteColor);
  ellipse(x,y,7,7);
  start += inc;

  for(int i = 0; i < numberOfDots-1; i++){
    xCoordinates[i] = xCoordinates[i+1];
    yCoordinates[i] = yCoordinates[i+1];
  }
  xCoordinates[numberOfDots-1] = x;
  yCoordinates[numberOfDots-1] = y;

  noFill();
  stroke(whiteColor);
  strokeWeight(2);
  beginShape();
  for (int i = 0; i < numberOfDots; i++){
    vertex(xCoordinates[i], yCoordinates[i]);
  }
  endShape();
}

void mouseClicked() {
  redraw();
}
