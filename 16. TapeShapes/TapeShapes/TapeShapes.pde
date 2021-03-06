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
color[] palette1 = {
  #f9c80e
  ,#f86624
  ,#ea3546
  ,#662e9b
  ,#43bccd
};

color[] palette2 = {
  #f5b201
  ,#87bd2c
  ,#ab679f
};

void setup(){
  size(1200, 800);
  float perimeter = 2 * (width + height);
  numberOfPoints = (int)(perimeter/100);
  numberOfLines = numberOfPoints/5;
  noLoop();
}

void draw(){
  points = generatePoints();
  polygons = getStartingPolygons();
  tapeLines = generateTapeLines();
  splitPolygonsWithTapeLines();

  beginRecord(PDF, "../TapeShapes.pdf");
  background(whiteColor);
  drawPolygons();
  drawTapeLines();
  endRecord();
}

List<PVector> generatePoints(){
  List<PVector> points = new ArrayList<PVector>();
  float padding = 0.05*max(width,height);
  float perimeter = 2 * (width+2*padding + height+2*padding);
  float step = perimeter / numberOfPoints;
  float x = 0;
  float y = 0;
  for(int i = 0; i < numberOfPoints; i++){
    float length = i*step;
    if (length <= width+2*padding){
      x = length - padding;
      y = -padding;
    } else if (length <= width+2*padding + height+2*padding){
      x = width + padding;
      length -= width+2*padding;
      y = length - padding;
    } else if (length <= 2*(width+2*padding) + height+2*padding){
      y = height + padding;
      length -= width+2*padding + height+2*padding;
      x = width + padding - length;
    } else {
      x = -padding;
      length -= 2*(width+2*padding) + height+2*padding;
      y = height + padding - length;
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

  for(PVector vertex : vertices){
    float D = (vertex.x - split.start.x) * (split.end.y - split.start.y) - (vertex.y - split.start.y) * (split.end.x - split.start.x);
    if (D <= 0)
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
  stroke(whiteColor);
  for(Segment tapeline : tapeLines){
    strokeWeight(15);
    if (random(1) < 0.33){
      strokeWeight(40);
    }
    line(tapeline.start.x,tapeline.start.y,tapeline.end.x,tapeline.end.y);
  }
}

void drawPolygons(){
  // colorMode(HSB, 360, 100, 100);
  for(int i = 0; i < polygons.size(); i++){
    Polygon polygon = polygons.get(i);
    noStroke();
    // fill(color(map(i, 0, polygons.size(), 0, 360),100,100));
    fill(getRandomPaletteColor(palette2));
    beginShape();
    for(PVector v : polygon.getSortedVertices()){
      vertex(v.x,v.y);
    }
    endShape(CLOSE);
  }
}

PVector getIntersection(PVector start1, PVector end1, PVector start2, PVector end2){
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

  //подставляем концы отрезков, для выяснения в каких полуплоскостях они
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
