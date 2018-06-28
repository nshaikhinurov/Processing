import processing.pdf.*;
import java.util.*;

float screenWidth;
float screenHeight;

color blackColor = #212121;
color whiteColor = #eeeeee;

color[] bestPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

color[] palette = bestPalette;

float inc = 0.07;
int n = 9;
float cellSize;

void setup(){
  size(1000, 1000);
  screenWidth = width;
  screenHeight = height;
  noiseDetail(100);
  noLoop();
}

void draw(){
  beginRecord(PDF, "Fireworks.pdf");
  mainDraw();
  endRecord();
}

void mainDraw(){
  background(whiteColor);
}

void launchParticle(float angle){
  for 
}

color getRandomPaletteColor(){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
