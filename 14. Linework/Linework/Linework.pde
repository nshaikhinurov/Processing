import processing.pdf.*;
import java.util.*;

float PHI = (sqrt(5)+1)/2;
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
  beginRecord(PDF, "../Linework.pdf");
  mainDraw();
  endRecord();
}

void mainDraw(){
  pushMatrix();
  translate(0.5*width,0.5*height);
  background(whiteColor);

  renderLine();
  placeDiamondOnLine();
  placeEllipseOnLine();
  placePoligonOnLine(3, 3);
  placePoligonOnLine(4, 1);
  placePoligonOnLine(5, 1);
  popMatrix();
}

void renderLine(){
  stroke(blackColor);
  strokeWeight(0.8*width/56);
  line(-0.4*width,0,0.4*width,0);
}

void placeDiamondOnLine(){
  float dHeight = random(0.3*height, 0.5*height);
  float dWidth = dHeight/PHI;
  float x = random(-0.4*width + 0.5*dWidth, 0.4*width - 0.5*dWidth);
  float y = 0;
  renderDiamond(x, y, dWidth, dHeight);
}

void renderDiamond(float x, float y, float dWidth, float dHeight){
  float strokeThickness = dWidth/56;
  renderLinedDiamond(x,y,dWidth,dHeight,strokeThickness);

  float tg = dHeight/dWidth;
  float lambda = strokeThickness / tg;
  float thicknessOffSet = strokeThickness + sqrt( sq(lambda) + sq(strokeThickness) );
  renderDottedDiamond(x+2*thicknessOffSet,y,dWidth,dHeight,strokeThickness);
}

void renderLinedDiamond(float x, float y, float dWidth, float dHeight, float strokeThickness){
  pushMatrix();
  translate(x,y);
  strokeWeight(strokeThickness);
  stroke(blackColor);
  line(-dWidth/2,0,0,-dHeight/2);
  line(0,-dHeight/2,dWidth/2,0);
  line(dWidth/2,0,0,dHeight/2);
  line(0,dHeight/2,-dWidth/2,0);
  popMatrix();
}

void renderDottedDiamond(float x, float y, float dWidth, float dHeight, float strokeThickness){
  pushMatrix();
  translate(x,y);
  dottedLine(-dWidth/2,0,0,-dHeight/2, strokeThickness);
  dottedLine(0,-dHeight/2,dWidth/2,0, strokeThickness);
  dottedLine(dWidth/2,0,0,dHeight/2, strokeThickness);
  dottedLine(0,dHeight/2,-dWidth/2,0, strokeThickness);
  popMatrix();
}

void placeEllipseOnLine(){
  float diameter = random(0.1*width, 0.3*width);
  float strokeThickness = diameter/56;
  float x = random(-0.4*width + 0.5*diameter, 0.4*width - 0.5*diameter);

  noFill();
  stroke(blackColor);
  strokeWeight(strokeThickness);
  ellipse(x,0,diameter,diameter);

  float radius = random(0.2 * diameter/2,0.8 * diameter/2);
  dottedArc(x - diameter/2,0, radius,0,TWO_PI, 2*radius/56);
}

void placePoligonOnLine(int n, float thicknessMultiplier){
  float diameter = random(0.1*width, 0.3*width);
  float x = random(-0.3*width, 0.3*width);
  float y = 0;
  // float rotation = random(TWO_PI);
  float rotation = 0;
  float thickness = diameter / 56 * thicknessMultiplier;
  if(random(1) > 0.5)
    drawLinedPolygon(x,y,n,diameter,rotation, thickness);
  else
    drawDottedPolygon(x,y,n,diameter,rotation, thickness);
}

void drawLinedPolygon(float xC, float yC, int n, float diameter, float rotation, float thickness){
  float alpha = 0;
  float radius = diameter/2;
  pushMatrix();
  translate(xC, yC);
  rotate(rotation);
  noFill();
  stroke(blackColor);
  strokeWeight(thickness);
  beginShape();
  for (int i = 0; i < n; i++){
    float x = radius * cos(alpha);
    float y = radius * sin(alpha);
    vertex(x,y);
    alpha += TWO_PI / n;
  }
  endShape(CLOSE);
  popMatrix();
}

void drawDottedPolygon(float xC, float yC, int n, float diameter, float rotation, float thickness){
  float alpha = 0;
  float radius = diameter/2;
  pushMatrix();
  translate(xC, yC);
  rotate(rotation);
  for (int i = 0; i < n; i++){
    float x1 = radius * cos(alpha);
    float y1 = radius * sin(alpha);
    float x2 = radius * cos(alpha + TWO_PI / n);
    float y2 = radius * sin(alpha + TWO_PI / n);
    dottedLine(x1,y1,x2,y2,thickness);
    alpha += TWO_PI / n;
  }
  popMatrix();
}

void dottedLine(float x1, float y1, float x2, float y2, float thickness){
  float length = sqrt( sq(x2-x1) + sq(y2-y1) );
  int n = numberOfDots(length, thickness);
  fill(blackColor);
  noStroke();
  for (int i = 0; i < n; i++){
    float x = lerp(x1, x2, (float)i/(n-1));
    float y = lerp(y1, y2, (float)i/(n-1));
    ellipse(x, y, thickness, thickness);
  }
}

void dottedArc(float xC, float yC, float radius, float start, float stop, float thickness){
  float circumference = radius * (stop - start);
  int n = numberOfDots(circumference, thickness);
  pushMatrix();
  translate(xC,yC);
  fill(blackColor);
  noStroke();
  for (int i = 0; i < n; i++){
    float alpha = lerp(start, stop, (float)i/(n-1));
    float x = radius*cos(alpha);
    float y = radius*sin(alpha);
    ellipse(x,y,thickness,thickness);
  }
  popMatrix();
}

int numberOfDots(float length, float thickness){
  float gap = length;
  int n = 0;
  while (gap >= 2*thickness){
    n++;
    gap = length/n;
  }
  return n;
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
