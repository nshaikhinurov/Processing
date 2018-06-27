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

color[] turbulentWaters = {
  #00a6fb
  ,#0582ca
  ,#006494
};

color[] palette = bestPalette;

float inc = 0.07;
int seedsCount = 75;
float cellSize;

void setup(){
  size(1000, 1000);
  screenWidth = width;
  screenHeight = height;
  noiseDetail(100);
  noLoop();
}

void draw(){
  beginRecord(PDF, "Dandelion.pdf");
  mainDraw();
  endRecord();
}

void mainDraw(){
  background(whiteColor);
  for (int i = 0; i < 3; i++){
    float x = random(0.3*width, 0.7*width);
    // float y = random(0.35*height, 0.8*height);
    float y = map(i,0,2,0.35*height, 0.8*height);
    float d = map(y, 0.4*height, 0.8*height, 0.3*width, 0.1*width);
    renderFlower(x, y, d, d/6);
  }
}

void renderFlower(float cx, float cy, float diameter, float thickness){
  pushMatrix();
  translate(cx, cy);
  float stemHeight = height-cy;
  renderStem(sign(random(-1,1))*random(0.1*stemHeight, 0.3*stemHeight), height-cy, thickness/7);
  renderCenter(0.1*diameter);
  renderSeeds(0.15*diameter/2, diameter/2);
  renderFur(diameter/2, thickness);
  popMatrix();
}

void renderStem(float x, float y, float thickness){
  noFill();
  stroke(blackColor);
  strokeWeight(thickness);

  PVector stemV = new PVector(x, y);
  PVector normalVector = (new PVector(x, y)).rotate(sign(x)*HALF_PI);
  normalVector.setMag(1.5*stemV.mag());
  normalVector.add(PVector.mult(stemV,0.5));
  float r = normalVector.mag();
  float[] cArr = normalVector.array();
  float cX = cArr[0];
  float cY = cArr[1];
  float angle1 = (new PVector(-cX,-cY)).heading();
  float angle2 = (new PVector(x-cX,y-cY)).heading();
  angle1 = normalizeAngle(angle1);
  angle2 = normalizeAngle(angle2);

  if (sign(x) > 0 && angle2 < angle1){
    angle2 += TWO_PI;
  }
  if (sign(x) < 0 && angle2 < angle1){
    float t = angle1;
    angle1 = angle2;
    angle2 = t;
  }
  arc(cX,cY,2*r,2*r,angle1,angle2);
}

float normalizeAngle(float angle){
  if (angle < 0){
    while (angle < 0)
      angle+=TWO_PI;
  } else if (angle > TWO_PI) {
    while (angle > TWO_PI)
      angle-=TWO_PI;
  }
  return angle;
}

void renderCenter(float d){
  stroke(blackColor);
  strokeWeight(0.1*d);
  fill(whiteColor);
  ellipse(0, 0, d, d);
}

void renderSeeds(float distanceFromFlowerCenter, float seedStemLength){
  for (int i = 0; i < seedsCount; i++){
    float alpha = random(TWO_PI);
    float x = cos(alpha) * distanceFromFlowerCenter;
    float y = sin(alpha) * distanceFromFlowerCenter;
    float seedSize = random(distanceFromFlowerCenter*0.05, distanceFromFlowerCenter*0.3);
    noStroke();
    fill(blackColor);
    ellipse(x, y, seedSize, seedSize);

    float s1 = 0;
    float s2 = 0;
    while (s2 - s1 < 0.3*seedStemLength){
      s1 = random(distanceFromFlowerCenter,seedStemLength);
      s2 = random(distanceFromFlowerCenter,seedStemLength);
    }
    float x1 = cos(alpha) * s1;
    float y1 = sin(alpha) * s1;
    float x2 = cos(alpha) * s2;
    float y2 = sin(alpha) * s2;
    noFill();
    stroke(blackColor);
    strokeWeight(seedStemLength/150);
    line(x1,y1,x2,y2);
  }
}

void renderFur(float radius, float thickness){
  noStroke();
  int n = seedsCount*seedsCount;
  for (int i = 0; i < n; i++){
    float alpha = random(TWO_PI);
    float r = map(i, 0, n-1, radius-thickness, radius+thickness);
    float x = cos(alpha) * r;
    float y = sin(alpha) * r;
    float seedSize = doubleMap(r + random(-0.1*r,0.1*r), radius-thickness, radius+thickness, 0, 0.3*thickness);
    fill(getRandomPaletteColor(turbulentWaters));
    ellipse(x, y, seedSize, seedSize);
  }
}

float doubleMap(float v, float sMin, float sMax, float dMin, float dMax){
  if (v <= 0.5*(sMin + sMax))
    return map(v, sMin, sMax, dMin, dMax);
  else
    return map(v, sMin, sMax, dMax, dMin);
}

int sign(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 0;
}

// float getVectorAngle(float x1, float y1, float x2, float y2){
//   PVector v1 = new PVector(-x1,-y1);
//   PVector v2 = new PVector(x2, y2);
//   PVector v = PVector.add(v1, v2, null);
//   PVector zero = new PVector(1, 0);
//   return PVector.angleBetween(v, zero);
// }

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
