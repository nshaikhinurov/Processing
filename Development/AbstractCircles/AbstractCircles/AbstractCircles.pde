import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

color[] bestPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

color[] turbulentWaters = {
  #00a6fb
  ,#0582ca
  ,#006494
};

color[] palette = bestPalette;

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  beginRecord(PDF, "../AbstractCircles.pdf");
  generateShapes();
  mainDraw();
  endRecord();
}

void mainDraw(){
  background(whiteColor);
  for (int i = 0; i < 3; i++){
    float x = random(0.3*width, 0.7*width);
    float y = random(0.3*height, 0.7*height);
    renderShape(x, y);
  }
}

void renderShape(float x, float y){
  float d = random(0.3*width);
  fill(blackColor);
  noStroke();
  ellipse(x,y,d,d);
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
