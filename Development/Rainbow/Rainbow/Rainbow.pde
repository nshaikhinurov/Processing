import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

float padding;
int numberOfLines;
float strokeWidth;

void setup(){
  size(1000, 1000);
  numberOfLines = 7;
  strokeWidth = 1.0*width/numberOfLines;
  noLoop();
}

void draw(){
  beginRecord(PDF, "../TapeShapes.pdf");
  background(whiteColor);
  translate(strokeWidth/2,0.5*height);
  drawLines();
  endRecord();
}

void drawLines(){
  strokeWeight(strokeWidth);
  colorMode(HSB, 360, 100, 100);
  float startHue = random(360);
  for(int i = 0; i < numberOfLines; i++){
    float x = lerp(0, width, 1.0*i/(numberOfLines));
    float hue = map(i, 0, numberOfLines-1, 0, 0.7*360);
    stroke( modulus(hue + startHue, 360), 100, 100);
    line(x,-2*height,x,2*height); // out of screen intended
  }
}

float modulus(float a, float modulus){
  while(a >= modulus)
    a -= modulus;
  while(a < 0)
    a += modulus;
  return a;
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
