import processing.pdf.*;
import java.util.*;

float screenWidth;
float screenHeight;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color forestBlueColor = #000157;
color blackColor = #212121;
color whiteColor = #eeeeee;

int nd = 1;
float randomiser = random(1000);
float[] terrainContour;

void setup(){
  size(750, 1000);
  screenWidth = width;
  screenHeight = height;
  noiseDetail(100);
  noLoop();
}

void draw(){
  // testFog();
  mainDraw();
}

void mainDraw(){
  beginRecord(PDF, "FoggyLandscape.pdf");
  background(whiteColor);
  // background(blackColor);
  generateLandscape();
  noStroke();
  renderLinear(forestBlueColor);
  renderFog();
  endRecord();
}

void generateLandscape(){
  float xOff = random(1000);
  float xOff2 = random(1000);
  float amplitude = 10;
  terrainContour = new float[width];
  for (int x = 0; x < width; x++){
    float y = map(x, 0, width-1, height/2.618*1.618 + 0.1*height, height/2.618*1.618 - 0.1*height);
    xOff2 += 0.01;
    y += noise(xOff2)*0.1*height;
    xOff += 0.2;
    y += map(noise(xOff), 0, 1, -amplitude, amplitude);
    terrainContour[x] = y;
  }
}

void renderLinear(color fillColor){
  fill(fillColor);
  beginShape();
  vertex(0, screenHeight);
  vertex(0, screenHeight);
  vertex(0, terrainContour[0]);
  for (int x = 0; x < width; x++){
    float y = terrainContour[x];
    vertex(x, y);
  }
  vertex(screenWidth, terrainContour[width-1]);
  vertex(screenWidth, screenHeight);
  vertex(screenWidth, screenHeight);
  endShape();
}

void renderFog(){
  int minY = (int) min(terrainContour);
  int maxY = (int) max(terrainContour);
  fogGradient(0, minY, width-1, (int)(maxY + 0.1*height));
  fogGradient((int)(0.1*width), 0, 0, height);

  fill(whiteColor);
  rect(0, maxY + 0.1*height, width, height);
}

void fogGradient(int x1, int y1, int x2, int y2){
  float redV = whiteColor >> 16 & 0xFF;
  float greenV = whiteColor >> 8 & 0xFF;
  float blueV = whiteColor & 0xFF;
  float randomiser = random(1000);
  float inc = 0.01;

  float yOff = randomiser;
  for (int y = y1; y <= y2; y++){
    float xOff = randomiser;
    for (int x = x1; x <= x2; x++){
      float alpha = map(y, y1, y2, 0, 255);
      color fillColor = color(
        redV,
        greenV,
        blueV,
        map(noise(xOff, yOff), 0, 1, alpha, 300)
      );
      fill(fillColor);
      rect(x,y,1,1);
      xOff += inc;
    }
    yOff += inc;
  }
}

void testFog(){
  background(blackColor);
  fogGradient((int)(0.9*width), 0, width, height);
}

void mouseClicked() {
  redraw();
}
