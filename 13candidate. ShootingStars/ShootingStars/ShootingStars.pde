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

float randomiser = random(1000);
float[] terrainContour;
int starsNumber = 1000;
float maxStarSize = 5;
float maxShootingStarSize = 10;
float maxShootingStarLength = 300;

void setup(){
  size(1280, 720);
  screenWidth = width;
  screenHeight = height;
  noiseDetail(100);
  noLoop();
}

void draw(){
  // testDraw();
  mainDraw();
}

void mainDraw(){
  beginRecord(PDF, "ShootingStars.pdf");
  background(#000000);
  generateLandscape();
  linearGradient(0, 0.4*max(terrainContour), 0, 0.7*max(terrainContour), #000000, #030430, 1);
  linearGradient(0, 0.7*max(terrainContour), 0, max(terrainContour), #030430, #003bc4, 1);
  renderStarField();
  renderShootingStar();
  renderLandscapeLinear(#000000);
  linearGradient(0, (max(terrainContour)+height)/2, 0, 1.3*height, #000000, #003bc4, 1);
  endRecord();
}

void generateLandscape(){
  float xOff = random(1000);
  float xOff2 = random(1000);
  float amplitude = 10;
  terrainContour = new float[width];
  for (int x = 0; x < width; x++){
    float y = map(x, 0, width-1, height/2.618*1.618, height/2.618*1.618);
    xOff2 += 0.01;
    y += noise(xOff2)*0.1*height;
    xOff += 0.2;
    y += map(noise(xOff), 0, 1, -amplitude, amplitude);
    terrainContour[x] = y;
  }
}

void renderLandscapeLinear(color fillColor){
  noStroke();
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

void linearGradient(float x1, float y1, float x2, float y2, color fromColor, color toColor, float thickness){
  strokeWeight(thickness);
  strokeCap(PROJECT);
  float length = sqrt(sq(x2-x1) + sq(y2-y1));
  float k = tan(atan((y2-y1)/(x2-x1)) + PI/2);
  for (float s = 0; s <= length + thickness; s += thickness){
    color strokeColor = lerpColor(fromColor, toColor, map(s, 0, length, 0, 1));
    stroke(strokeColor);
    float x = map(s, 0, length, x1, x2);
    float y = map(s, 0, length, y1, y2);
    if (x1 == x2){
      line(0,y,width,y);
      continue;
    }
    float b = y - k*x;
    float y0 = 0;
    float x0 = (y0-b) / k;
    float yn = height;
    float xn = (yn-b) / k;
    line(x0,y0,xn,yn);
  }
}

void renderStarField(){
  strokeCap(ROUND);
  for (int i = 0; i < starsNumber; i++){
    float size = random(maxStarSize);
    float x = random(width);
    float y = random(height);
    float brightness = random(0.3*255, 255);
    stroke(255,255,255,brightness);
    strokeWeight(size);
    point(x,y);
  }
}

void renderShootingStar(){
  strokeCap(ROUND);
  stroke(#ffffff);
  float length = random(0.8*maxShootingStarLength, maxShootingStarLength);
  float starSize = random(0.8*maxShootingStarSize, maxShootingStarSize);
  float alpha = random(PI);
  float mainX = random(0.1*width, 0.9*width);
  float mainY = random(0.1*height, 0.9*min(terrainContour));
  for (float s = 0; s <= length; s ++){
    float size = map(s, 0, length, starSize, 0);
    strokeWeight(size);
    float x = map(s, 0, length, mainX, mainX - length*cos(alpha));
    float y = map(s, 0, length, mainY, mainY - length*sin(alpha));
    point(x,y);
  }
}

void testDraw(){
  background(whiteColor);
  linearGradient(0, 0, width, height, redColor, forestBlueColor, 10);
}

void mouseClicked() {
  redraw();
}
