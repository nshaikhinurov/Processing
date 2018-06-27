import processing.pdf.*;
import java.util.*;

float screenWidth = 1000;
float screenHeight = 1000;
int n = 21;
float strokeThickness = 0.7*screenWidth / 2 / (4*n-1) * 3;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;

color[] material = {
  redColor
  ,yellowColor
  ,indigoColor
  ,blackColor
};

color[] crunchyCrackers = {
  #f6511d
  ,#ffb400
  ,#00a6ed
  ,#7fb800
  ,#0d2c54
};

color[] lapisLazuili = {
  #03256c
  ,#2541b2
  ,#1768ac
  ,#06bee1
};

color[] bestPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

color[] palette = bestPalette;

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  beginRecord(PDF, "Arcs.pdf");
  background(#eeeeee);
  translate(0.5*screenWidth, 0.5*screenHeight);
  strokeWeight(strokeThickness);
  strokeCap(SQUARE);
  noFill();
  drawArcs();
  endRecord();
}

void drawArcs(){
  for (int i = 0; i < n; i++){
    // float alpha = TWO_PI/n * floor(random(n));
    float alpha = TWO_PI/n * i;
    // float size = map(i, 0, n-1, 0.1*screenWidth, 0.8*screenWidth);
    float size = map(i, 0, n-1, 0, 0.8*screenWidth);
    stroke(getRandomPaletteColor());
    arc(0.0, 0.0, size, size, alpha, alpha + PI);
  }
}

color getRandomPaletteColor(){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
