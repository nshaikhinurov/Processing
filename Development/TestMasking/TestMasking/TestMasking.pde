import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

int numberOfPoints;
int iteration;
List<PVector> shapePoints;
float offSet;
float inc;
float xSpeed;
float colorSpeed;

void setup(){
  size(1000, 1000);
  numberOfPoints = 360;
  iteration = 0;
  xSpeed = 0.5;
  colorSpeed = 0.1;
  offSet = 0;
  inc = 0.01;
  noiseDetail(100);
  // noLoop();
  background(whiteColor);
  // frameRate(2);
}

void draw(){
  iteration++;
  changeShape();

  // background(whiteColor);
  // beginRecord(PDF, "../Test.pdf");
  translate(0, 0.5*height);
  pushMatrix();
  translate(iteration*xSpeed,0);
  // translate(0.5*width, 0);
  rotate(iteration*TWO_PI/360);
  drawShape();
  popMatrix();
  // endRecord();
}

void changeShape(){
  shapePoints = new ArrayList<PVector>(numberOfPoints);
  // float angle = random(TWO_PI);
  float angle = 0;
  float alpha = TWO_PI/numberOfPoints;
  float amplitude = 100;
  for (int i = 0; i < numberOfPoints; i++){
    float r = 0.2*height;
    float x = cos(angle);
    float y = sin(angle);
    float noise = (noise(x + offSet,y + offSet)-0.5)*amplitude;
    r += noise;
    x = r*cos(angle);
    y = r*sin(angle);
    shapePoints.add(new PVector(x,y));
    angle += alpha;
  }
  offSet += inc;
}

void drawShape(){
  noFill();
  colorMode(HSB,360,100,100);
  stroke((iteration*colorSpeed)%360,100,100);
  strokeWeight(1);
  beginShape();
  curveVertex(shapePoints.get(0).x,shapePoints.get(0).y);
  for(PVector p: shapePoints){
    curveVertex(p.x,p.y);
  }
  curveVertex(shapePoints.get(shapePoints.size()-1).x,shapePoints.get(shapePoints.size()-1).y);
  endShape(CLOSE);
}

void mouseClicked() {
  redraw();
}
