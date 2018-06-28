import processing.pdf.*;
import java.util.*;

float screenWidth;
float screenHeight;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;

float inc = 0.01;
int nd = 1;
float randomiser = random(1000);

void setup(){
  size(1000, 1000);
  screenWidth = width;
  screenHeight = height;
  noiseDetail(100);
  noLoop();
}

void draw(){
  // beginRecord(PDF, "TwoDimPerlinNoise.pdf");
  background(redColor);
  noStroke();
  float yOff = randomiser;
  float redV = whiteColor >> 16 & 0xFF;
  float greenV = whiteColor >> 8 & 0xFF;
  float blueV = whiteColor & 0xFF;
  for (int y = 0; y < height; y++){
    float xOff = randomiser;
    for (int x = 0; x < width; x++){
      int index = x + y*width;
      color fillColor = color(
        redV,
        greenV,
        blueV,
        noise(xOff, yOff)*255
      );
      fill(fillColor);
      rect(x,y,1,1);
      xOff += inc;
    }
    yOff += inc;
  }
  // endRecord();
}

void mouseClicked() {
  randomiser = random(1000);
  redraw();
}
