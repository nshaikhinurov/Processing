import processing.pdf.*;
import java.util.*;

float screenWidth = 1000;
float screenHeight = 1000;
int n = 250;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;

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

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  beginRecord(PDF, "SnowDots.pdf");
  background(#eeeeee);
  background(blackColor);
  translate(0.5*screenWidth, 0.5*screenHeight);
  noStroke();
  drawSquares();
  endRecord();
}

void drawSquares(){
  for (int i = 0; i < n; i++){
    // float alpha = TWO_PI/n * floor(random(n));
    // float size = map(i, 0, n-1, 1, 50.0 * 50 / n);
    // float size = 1 + random(50.0 * 75 / n);
    float size = 1 + random(25.0);
    float x = map(random(1),0,1,-0.8*width/2,0.8*width/2);
    float y = map(random(1),0,1,-0.8*width/2,0.8*width/2);
    fill(getRandomPaletteColor(), map(random(1), 0, 1, 128, 255));
    fill(whiteColor, map(random(1), 0, 1, 1, 255));
    rectMode(CENTER);
    // rect(x,y, size, size);
    ellipse(x,y,size,size);
  }
}

color getRandomPaletteColor(){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
