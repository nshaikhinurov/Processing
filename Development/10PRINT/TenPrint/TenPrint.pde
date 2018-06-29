import processing.pdf.*;
import java.util.*;

float screenWidth;
float screenHeight;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;
color blue900 = #0D47A1;

color[] palette = {
  // redColor
  // ,yellowColor
  indigoColor
  // ,blackColor
  // #ff4e00
  // ,#f5bb00
  // ,#ec9f05
  // ,#bf3100
  // ,#8ea604
};

float x;
float y;
float spacing;
float thickness;
int n = 19;

void setup(){
  size(1000, 1000);
  screenWidth = width;
  screenHeight = height;
  spacing = screenWidth / n;
  thickness = 0.2*spacing;
  strokeWeight(thickness);
  noLoop();
}

void draw(){
  beginRecord(PDF, "10PRINT.pdf");
  draw10print();
  endRecord();
}

void draw10print(){
  translate(0.1*screenWidth, 0.1*screenHeight);
  stroke(whiteColor);
  // background(blue900);
  background(blackColor);
  x = 0;
  y = 0;
  while (y < 0.8*screenHeight-spacing){
    if (random(1) > 0.5)
      // line(x,y,x+spacing,y+spacing);
      dottedLine(x,y,x+spacing,y+spacing);
    else
      // line(x,y+spacing,x+spacing,y);
      dottedLine(x,y+spacing,x+spacing,y);
    x += spacing;
    if (x >= 0.8*screenWidth-spacing){
      x = 0;
      y += spacing;
    }
  }
}

void dottedLine(float x1, float y1, float x2, float y2){
  int dotsCount = 7;
  float length = sqrt(sq(x2-x1) + sq(y2 - y1));
  strokeWeight(length / (2*dotsCount-1));
  for (int i = 0; i < dotsCount; i++){
    float x = map(i, 0, dotsCount-1, x1, x2);
    float y = map(i, 0, dotsCount-1, y1, y2);
    point(x,y);
  }
}

color getRandomPaletteColor(){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
