import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

float padding;
int numberOfPoints;
int numberOfLines;
List<PVector> points;

void setup(){
  size(1600, 550);
  padding = 25;
  numberOfPoints = 100;
  numberOfLines = 10;
  noLoop();
}

void draw(){
  // beginRecord(PDF, "../TapeShapes.pdf");
  points = generatePoints();
  translate(0.1*width,0.1*height);
  scale(0.8,0.8);
  mainDraw();
  // endRecord();
}

List<PVector> generatePoints(){
  List<PVector> points = new ArrayList<PVector>();
  for(int i = 0; i < numberOfPoints; i++){
    PVector p = getRandomPointOnTheEdge(padding);
    points.add(p);
  }
  return points;
}

PVector getRandomPointOnTheEdge(float padding){
  float x;
  float y;

  int side = (int)random(4);
  switch (side){
    case 0:
      x = random(width);
      y = 0;
      break;
    case 1:
      x = width;
      y = random(height);
      break;
    case 2:
      x = random(width);
      y = height;
      break;
    case 3:
      x = 0;
      y = random(height);
    default:
      x = -1;
      y = -1;
  }
  return new PVector(x,y);
}

void mainDraw(){
  background(whiteColor);
  stroke(blackColor);
  strokeWeight(10);
  for(int i = 0; i < numberOfLines; i++){
    int i1;
    int i2;
    PVector p1;
    PVector p2;
    while (true) {
      i1 = (int) random(points.size());
      i2 = (int) random(points.size());
      if (i1 == i2)
        continue;
      p1 = points.get(i1);
      p2 = points.get(i2);
      if (
        p1.x == p2.x
        || p1.y == p2.y
      )
        continue;

      if(PVector.sub(p2,p1).an)
      break;
    }
    line(p1.x,p1.y,p2.x,p2.y);
  }
}

PVector intersection(PVector start1, PVector end1, PVector start2, PVector end2)
{
  PVector out_intersection = null;
  PVector dir1 = PVector.sub(end1,start1);
  PVector dir2 = PVector.sub(end2,start2);

  //считаем уравнения прямых проходящих через отрезки
  float a1 = -dir1.y;
  float b1 = +dir1.x;
  float d1 = -(a1*start1.x + b1*start1.y);

  float a2 = -dir2.y;
  float b2 = +dir2.x;
  float d2 = -(a2*start2.x + b2*start2.y);

  //подставляем концы отрезков, для выяснения в каких полуплоскотях они
  float seg1_line2_start = a2*start1.x + b2*start1.y + d2;
  float seg1_line2_end = a2*end1.x + b2*end1.y + d2;

  float seg2_line1_start = a1*start2.x + b1*start2.y + d1;
  float seg2_line1_end = a1*end2.x + b1*end2.y + d1;

  //если концы одного отрезка имеют один знак, значит он в одной полуплоскости и пересечения нет.
  if (seg1_line2_start * seg1_line2_end >= 0 || seg2_line1_start * seg2_line1_end >= 0)
    return null;

  float u = seg1_line2_start / (seg1_line2_start - seg1_line2_end);
  out_intersection =  PVector.add(start1,PVector.mult(dir1,u));

  return out_intersection;
}

void testDraw(){
  background(whiteColor);
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
