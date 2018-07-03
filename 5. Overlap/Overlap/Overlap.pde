import processing.pdf.*;
import java.util.*;

color[] palette = {
  #333333
};

int numberOfStrokes = 18;
ArrayList<Integer> strokesIds;
float strokeLength = 0.8*screenWidth/sqrt(2);
// float strokeLength = 0.8*screenWidth;
float gapMultiplier = 0;
float strokeThickness = strokeLength/numberOfStrokes;

void setup(){
  size(720,720);
  // test();
  noLoop();
}

void generateStrokesOrder(){
  strokesIds = new ArrayList<Integer>();
  for (int i = 0; i < 2*numberOfStrokes; i++){
    strokesIds.add(i);
  }
  Collections.shuffle(strokesIds);
}

void test(){
    println(strokesIds);
}

void draw(){
  beginRecord(PDF, "../Overlap.pdf");
  generateStrokesOrder();
  background(#eeeeee);
  stroke(#eeeeee);
  // noStroke();
  strokeWeight(strokeThickness/4);
  translate(screenWidth/2.0, screenHeight/2.0);
  rotate(PI/4.0);
  rectMode(CENTER);
  renderStrokes();
  endRecord();
}

void renderStrokes(){
  for(int i : strokesIds)
    renderStroke(i);
}

void renderStroke(int i){
  fill(palette[floor(random(palette.length))]);
  if (i / numberOfStrokes == 0)
    renderHorizontalStroke(i);
  else
    renderVerticalStroke(i%numberOfStrokes);
}

void renderHorizontalStroke(int i){
  float y = map(i, 0, numberOfStrokes-1, -strokeLength/2, strokeLength/2);
  rect(0, y, strokeLength+strokeThickness, strokeThickness);
  // rect((screenWidth-strokeLength)/2.0, (screenHeight-strokeLength)/2.0 + i*(strokeThickness + gap), strokeLength, strokeThickness);
}

void renderVerticalStroke(int i){
  float x = map(i, 0, numberOfStrokes-1, -strokeLength/2, strokeLength/2);
  rect(x, 0, strokeThickness, strokeLength+strokeThickness);
  // rect((screenHeight-strokeLength)/2.0 + i*(strokeThickness + gap), (screenWidth-strokeLength)/2.0, strokeThickness, strokeLength);
}

void mouseClicked() {
  redraw();
}
