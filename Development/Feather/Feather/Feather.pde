import processing.pdf.*;
import java.util.*;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;
color threadColor = #978472;
color[] palette1 = {
  #581845
  ,#900c3f
  ,#c70039
  ,#ff5733
  ,#ffc305
};

color[] fibonacciPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

float PHI = (sqrt(5)+1)/2;
int n = 9;
int iterationsCount = 7;

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  // beginRecord(PDF, "../Dreamcatcher.pdf");
  mainDraw();
  // endRecord();
}

void mainDraw(){
  background(whiteColor);
  translate(0.5*width,0.9*height);
  line(0,0,0,-0.8*width);
  for (int y = 0; y >= -0.8*width; y--){
    float maxLength = map(y, -0.8*width, 0, 0, 0.2*width);
    line(0,y,random(maxLength),y);
  }
}

void mouseClicked() {
  redraw();
}
