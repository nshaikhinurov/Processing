import processing.pdf.*;
import java.util.*;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;
color threadColor = #978472;
color[] palette1 = {
  #581845
  ,#900c3f
  ,#c70039
  ,#ff5733
  ,#ffc305
};

color[] fibonacciPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

float PHI = (sqrt(5)+1)/2;
int n = 9;
int iterationsCount = 7;

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  beginRecord(PDF, "../Dreamcatcher.pdf");
  mainDraw();
  endRecord();
}

void mainDraw(){
  background(whiteColor);
  float bigDiameter = 0.8*width/2;
  float smallDiameter = bigDiameter/2;
  drawDreamcatcher(0.5*width, 0.1*height + 0.5*bigDiameter, bigDiameter);
  drawDreamcatcher(0.5*width, 0.1*height + bigDiameter + 1.5*smallDiameter/2, smallDiameter);
}

void drawDreamcatcher(float x, float y, float diameter){
  pushMatrix();
  translate(x,y);
  List<Line> threads = makeThreads(diameter);
  pushMatrix();
  drawThreads(threads,diameter/250);
  scale(-1,1);
  drawThreads(threads,diameter/250);
  popMatrix();

  drawCircle(diameter);
  float beadSize = diameter/25;
  drawBeads(threads, beadSize);
  popMatrix();
}

List<Line> makeThreads(float diameter){
  List<Line> lines = new ArrayList<Line>();
  float outerRadius = 0.95*diameter/2;
  float innerRadius = (0.5*diameter)/10;
  float alpha = TWO_PI/n;
  for (int j = 0; j < iterationsCount; j++){
    float middleRadius = lerp(innerRadius,outerRadius,2.0/3.0);
    float angle = -HALF_PI + alpha/2*j;
    if (j == iterationsCount-1){
      middleRadius = outerRadius;
      alpha *= 2;
    }
    for(int i = 0; i < n; i++){
      float x1 = outerRadius*cos(angle);
      float y1 = outerRadius*sin(angle);
      float x2 = middleRadius*cos(angle + alpha/2);
      float y2 = middleRadius*sin(angle + alpha/2);
      lines.add(new Line(x1,y1,x2,y2));
      angle += alpha;
    }
    outerRadius = middleRadius;
  }
  return lines;
}

void drawThreads(List<Line> threads, float thickness){
  stroke(blackColor);
  strokeWeight(thickness);
  for (Line l : threads){
    line(l.x1,l.y1,l.x2,l.y2);
  }
}

void drawBeads(List<Line> threads, float beadSize){
  for(int i = 0; i < n*(iterationsCount-3); i++){
    Line thread = threads.get(i);
    if ( random(1) < 0.1 ){
      float x = thread.x2;
      float y = thread.y2;
      float magnitude = (new PVector(x,y)).mag();
      // float beadSize = map(magnitude, 0, 400, 0, 30);
      noStroke();
      fill(getRandomPaletteColor(fibonacciPalette));
      ellipse(x,y,beadSize,beadSize);
    }
    if ( random(1) < 0.1 ){
      float scale = random(0.3,0.7);
      float x = lerp(thread.x1, thread.x2, scale);
      float y = lerp(thread.y1, thread.y2, scale);
      float magnitude = (new PVector(x,y)).mag();
      // float beadSize = map(magnitude, 0, 400, 0, 30);
      noStroke();
      fill(getRandomPaletteColor(fibonacciPalette));
      ellipse(x,y,beadSize,beadSize);
    }
  }
}

void drawCircle(float diameter){
  float outerRadius = diameter / 2;
  float innerRadius = 0.95*outerRadius;
  float circumference = TWO_PI*outerRadius;
  int n = (int)(circumference/16);
  float alpha = TWO_PI / n;

  noFill();
  stroke(getRandomPaletteColor(fibonacciPalette));
  strokeWeight(outerRadius - innerRadius);
  arc(0,0, 2*lerp(innerRadius, outerRadius, 0.5),2*lerp(innerRadius, outerRadius, 0.5),0,TWO_PI);

  strokeWeight(diameter/250);
  stroke(blackColor);
  float angle = -HALF_PI;
  for (int i = 0; i < n; i++){
    float outerX = outerRadius * cos(angle);
    float innerX = innerRadius * cos(angle-alpha);
    float outerY = outerRadius * sin(angle);
    float innerY = innerRadius * sin(angle-alpha);
    line(outerX,outerY,innerX,innerY);
    angle += alpha;
  }
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
