import processing.pdf.*;
import java.util.*;

// float screenWidth = 728;
// float screenHeight = 1030;
float screenWidth = 1000;
float screenHeight = 1000;
float branchLength = 200;
float minBranchLength = branchLength/30;
float branchThickness = branchLength/10;
float minBranchThickness = branchThickness/30;
float maxAngle = 60;

color[] palette = {
  #ad2139
  ,#c76982
  ,#e7a0ae
  ,#f7d3e4
  ,#e67a92
  ,#b33452
  ,#640c1c
};

void setup(){
  size(1000,1000);
  noLoop();
}

void draw(){
  beginRecord(PDF, "SakuraTree.pdf");
  background(#eeeeee);
  pushMatrix();
  translate(screenWidth/2.0,screenHeight);
  drawBranch(branchLength, branchThickness);
  popMatrix();
  drawFlyingLeaves();
  endRecord();
}

void drawBranch(float branchLength, float branchThickness){
  if (branchThickness <= minBranchThickness){
    float leafR = random(10);
    noStroke();
    fill(palette[floor(random(palette.length))]);
    ellipse(0, 0, leafR, leafR);
    return;
  }
  stroke(0);
  strokeWeight(branchThickness);
  line(0, 0, 0, -branchLength);
  translate(0, -branchLength);

  pushMatrix();
  float lowBranchOffset = random(0.9*branchLength);
  translate(0, lowBranchOffset);
  float lowBranchAngle = -radians(random(maxAngle));
  rotate(lowBranchAngle);
  float newBranchLength = (0.5 + random(0.3)) * branchLength;
  float newBranchThickness = (0.5 + random(0.3)) * branchThickness;
  drawBranch(newBranchLength, newBranchThickness);
  popMatrix();

  pushMatrix();
  float midBranchOffset = random(0.9*lowBranchOffset);
  translate(0, midBranchOffset);
  float midBranchAngle = radians(random(maxAngle));
  rotate(midBranchAngle);
  newBranchLength = (0.5 + random(0.3)) * branchLength;
  newBranchThickness = (0.5 + random(0.3)) * branchThickness;
  drawBranch(newBranchLength, newBranchThickness);
  popMatrix();

  pushMatrix();
  float topBranchOffset = 0;
  translate(0, topBranchOffset);
  float topBranchAngle = -radians(maxAngle) + radians(random(2*maxAngle));
  rotate(topBranchAngle);
  newBranchLength = (0.5 + random(0.3)) * branchLength;
  newBranchThickness = (0.5 + random(0.3)) * branchThickness;
  drawBranch(newBranchLength, newBranchThickness);
  popMatrix();
}

void drawFlyingLeaves(){
  translate (screenWidth/2, screenHeight/2);
  noStroke();
  for (int i = 0; i < 500; i++){
    float x = map(random(screenWidth), 0, screenWidth, -0.8*screenWidth/2.0, 0.8*screenWidth/2.0);
    float y = map(random(screenHeight), 0, screenHeight, -0.8*screenHeight/2.0, 0.8*screenHeight/2.0) + screenHeight/2.0;
    float leafR = random(10);
    fill(palette[floor(random(palette.length))]);
    ellipse(x,y,leafR,leafR);
  }
}

void mouseClicked() {
  redraw();
}
