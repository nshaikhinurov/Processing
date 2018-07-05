import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

float padding;
int numberOfPoints;
int numberOfLines;
List<PVector> points;
List<Polygon> polygons;
List<Segment> tapeLines;

void setup(){
  // size(1600, 550);
  size(800, 800);
  float perimeter = 2 * (width + height);
  numberOfPoints = (int)(perimeter/160);
  numberOfLines = 4;
  noLoop();
}

void draw(){
  mainDraw();
  // testDraw();
}

void testDraw(){
  PVector intersection = getIntersection(
      new PVector(0,0),
      new PVector(width, 0),
      new PVector(0,0),
      new PVector(0,10)
  );
  println(intersection);
}

void mainDraw(){
  points = generatePoints();
  polygons = getStartingPolygons();
  tapeLines = generateTapeLines();
  splitPolygonsWithTapeLines();

  // beginRecord(PDF, "../TapeShapes.pdf");
  translate(0.1*width,0.1*height);
  scale(0.8,0.8);
  background(whiteColor);
  drawPolygons();
  drawTapeLines();
  // endRecord();
}

List<PVector> generatePoints(){
  List<PVector> points = new ArrayList<PVector>();
  float perimeter = 2 * (width + height);
  float step = perimeter / numberOfPoints;
  float x = 0;
  float y = 0;
  for(int i = 0; i < numberOfPoints; i++){
    float length = i*step;
    if (length <= width){
      x = length;
      y = 0;
    } else if (length <= width + height){
      x = width;
      length -= width;
      y = length;
    } else if (length <= 2*width + height){
      y = height;
      length -= width + height;
      x = width - length;
    } else {
      x = 0;
      length -= 2*width + height;
      y = height - length;
    }
    PVector p = new PVector(x,y);
    points.add(p);
  }
  return points;
}

List<Polygon> getStartingPolygons(){
  List<Polygon> polygons = new ArrayList<Polygon>();
  List<PVector> vertices = new ArrayList<PVector>();
  vertices.add(new PVector(0,0));
  vertices.add(new PVector(width, 0));
  vertices.add(new PVector(width, height));
  vertices.add(new PVector(0, height));
  polygons.add(new Polygon(vertices));
  return polygons;
}

List<Segment> generateTapeLines(){
  List<Segment> tapeLines = new ArrayList<Segment>();
  for(int i = 0; i < numberOfLines; i++){
    int startIndex;
    int endIndex;
    PVector start;
    PVector end;

    while (true) {
      startIndex = (int) random(points.size());
      endIndex = (int) random(points.size());
      if (startIndex == endIndex)
      continue;
      start = points.get(startIndex);
      end = points.get(endIndex);
      if (start.x == end.x || start.y == end.y)
      continue;
      break;
    }

    Segment newTapeLine = new Segment(start,end);
    tapeLines.add(newTapeLine);
  }
  return tapeLines;
}

void splitPolygonsWithTapeLines(){
  for (Segment tapeline : tapeLines){
    List<Polygon> nextPolygonsGeneration = splitPolygonsWithTapeLine(tapeline);
    polygons = nextPolygonsGeneration;
  }
}

List<Polygon> splitPolygonsWithTapeLine(Segment tapeline){
  List<Polygon> nextPolygonsGeneration = new ArrayList<Polygon>();

  for(Polygon polygon : polygons){
    splitPolygonWithTapeLine(polygon, tapeline, nextPolygonsGeneration);
  }
  return nextPolygonsGeneration;
}

void splitPolygonWithTapeLine(Polygon polygon, Segment tapeline, List<Polygon> nextPolygonsGeneration){
  List<PVector> vertices = polygon.getSortedVertices();
  Segment split = getSplitSegment(vertices, tapeline);
  if (split == null){
    nextPolygonsGeneration.add(polygon);
    return;
  }

  List<PVector> vertices1 = new ArrayList<PVector>();
  List<PVector> vertices2 = new ArrayList<PVector>();
  vertices1.add(split.start);
  vertices1.add(split.end);
  vertices2.add(split.start);
  vertices2.add(split.end);

  PVector centerPoint = new PVector(0, 0);
  for(PVector vertexVector : vertices)
    centerPoint.add(vertexVector);
  centerPoint.add(split.start);
  centerPoint.add(split.end);
  centerPoint.div(vertices.size()+2);

  PVector centerToSplitStart = PVector.sub(split.start,centerPoint);
  PVector centerToSplitEnd = PVector.sub(split.end,centerPoint);
  float angleToSplitStart = centerToSplitStart.heading();
  float angleToSplitEnd = centerToSplitEnd.heading();
  for(PVector vertex : vertices){
    PVector centerToVertex = PVector.sub(vertex,centerPoint);
    if (angleToSplitStart <= centerToVertex.heading() && centerToVertex.heading() <= angleToSplitEnd)
      vertices1.add(vertex);
    else
      vertices2.add(vertex);
  }
  nextPolygonsGeneration.add(new Polygon(vertices1));
  nextPolygonsGeneration.add(new Polygon(vertices2));
}

Segment getSplitSegment(List<PVector> verices, Segment tapeline){
  PVector tapelineStart = tapeline.start;
  PVector tapelineEnd = tapeline.end;
  PVector splitStart = null;
  PVector splitEnd = null;
  for(int i = 0; i < verices.size(); i++){
    PVector edgeStart = verices.get(i);
    PVector edgeEnd = verices.get((i+1) % verices.size());
    PVector intersection = getIntersection(edgeStart, edgeEnd, tapelineStart, tapelineEnd);
    println(intersection);
    if (intersection != null){
      if (splitStart == null){
        splitStart = intersection;
      } else {
        splitEnd = intersection;
        return new Segment(splitStart, splitEnd);
      }
    }
  }
  return null;
}

void drawTapeLines(){
  stroke(blackColor);
  strokeWeight(10);
  for(Segment tapeline : tapeLines){
    line(tapeline.start.x,tapeline.start.y,tapeline.end.x,tapeline.end.y);
  }
}

void drawPolygons(){
  noStroke();
  println(polygons.size());
  for(Polygon polygon : polygons){
    fill(color(random(255),random(255),random(255)));
    beginShape();
    for(PVector v : polygon.getSortedVertices()){
      vertex(v.x,v.y);
    }
    endShape(CLOSE);
  }
}

PVector getIntersection(PVector start1, PVector end1, PVector start2, PVector end2)
{
  PVector intersection = null;
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
  if (seg1_line2_start * seg1_line2_end > 0 || seg2_line1_start * seg2_line1_end > 0)
    return null;

  float u = seg1_line2_start / (seg1_line2_start - seg1_line2_end);
  intersection =  PVector.add(start1,PVector.mult(dir1,u));

  return intersection;
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
