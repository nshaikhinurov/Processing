import processing.pdf.*;
import java.util.*;

color[] palette = {
  #333333
};

int numberOfStrokes;
ArrayList<Integer> strokesIds;
float strokeLength;
float gapMultiplier;
float strokeThickness;

void setup(){
  size(720,720);
  noLoop();

  numberOfStrokes = 18;
  strokeLength = 0.8*width / sqrt(2);
  gapMultiplier = 0;
  strokeThickness = strokeLength/numberOfStrokes;
}

void draw(){
  generateStrokesOrder();

  beginRecord(PDF, "../Overlap.pdf");
  background(#eeeeee);
  stroke(#eeeeee);
  strokeWeight(strokeThickness/4);
  translate(width/2.0, height/2.0);
  rotate(PI/4);
  rectMode(CENTER);
  renderStrokes();
  endRecord();
}

void generateStrokesOrder(){
  strokesIds = new ArrayList<Integer>();
  for (int i = 0; i < 2*numberOfStrokes; i++){
    strokesIds.add(i);
  }
  Collections.shuffle(strokesIds);
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
}

void renderVerticalStroke(int i){
  float x = map(i, 0, numberOfStrokes-1, -strokeLength/2, strokeLength/2);
  rect(x, 0, strokeThickness, strokeLength+strokeThickness);
}

void mouseClicked() {
  redraw();
}
