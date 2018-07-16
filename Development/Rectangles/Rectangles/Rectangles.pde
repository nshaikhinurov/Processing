import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

color[] fibonacciPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

int numberOfRectangles;

void setup(){
  // size(1000, 1000, );
  createGraphics(1000, 1000, P2D)
  numberOfRectangles = 7;
  noLoop();
}

void draw(){
  // beginRecord(PDF, "../Rectangles.pdf");
  mainDraw();
  save("rectangles.png");
  // endRecord();
}

void mainDraw(){
  translate(0.5*width,0.5*height);
  background(whiteColor);
  rectMode(CENTER);
  stroke(blackColor);
  strokeWeight(5);
  int i = 0;
  while (i < fibonacciPalette.length){
    float x = random(-0.4*width, 0.4*width);
    // float x = 0;
    float y = random(-0.4*height, 0.4*height);
    float w = random(0.2*width);
    float h = random(0.4*height);
    float s = w*h;
    if (s > 0.02*width*height && s < 0.25*width*height){
      fill(fibonacciPalette[i]);
      rect(x,y,w,h);
      i++;
    }
  }
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
