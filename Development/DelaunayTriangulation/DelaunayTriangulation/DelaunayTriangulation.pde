import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;
color[] palette = {
  // #3d348b
  // ,#7678ed
  #f7b801
  ,#f18701
  ,#ff4f00
};
color[] palette1 = {
  #fee2c6
  ,#ffd09d
  ,#fdb970
  ,#fe952c
  ,#fd861c
};
List<Point> triangulationPoints;
int numberOfPoints = 10;
float sideLength;

void setup(){
  size(1000, 1000);
   sideLength = 1.3*width/(numberOfPoints-1);
  noLoop();
}

void draw(){
  mainDraw();
}

void mainDraw(){
  beginRecord(PDF, "../DelaunayTriangulation.pdf");
  background(whiteColor);
  noFill();
  translate(-0.1*width,-0.1*height);
  List<Triangle> triangulation = generateTriangulation();
  makeDelaunayTriangulation(triangulation);
  renderTriangulation(triangulation);
  // renderPoints(triangulationPoints);
  endRecord();
}

List<Triangle> generateTriangulation(){
  triangulationPoints = new ArrayList<Point>();
  List<Triangle> triangulation = new ArrayList<Triangle>();
  float tHeight = sqrt(3)/2*sideLength;
  for (int i = 0; i < numberOfPoints; i++)
    for( int j = 0; j < numberOfPoints; j++)
      triangulationPoints.add(new Point(j*sideLength, i*tHeight));

  for (int i = 0; i < numberOfPoints-1; i++){
    for (int j = 0; j < numberOfPoints-1; j++){
      if (i % 2 == 0){
        triangulation.add(new Triangle(
            triangulationPoints.get(index(i,j)),
            triangulationPoints.get(index(i,j+1)),
            triangulationPoints.get(index(i+1,j))
        ));
        triangulation.add(new Triangle(
            triangulationPoints.get(index(i+1,j)),
            triangulationPoints.get(index(i,j+1)),
            triangulationPoints.get(index(i+1,j+1))
        ));
      } else {
        triangulation.add(new Triangle(
            triangulationPoints.get(index(i,j)),
            triangulationPoints.get(index(i,j+1)),
            triangulationPoints.get(index(i+1,j+1))
        ));
        triangulation.add(new Triangle(
            triangulationPoints.get(index(i,j)),
            triangulationPoints.get(index(i+1,j)),
            triangulationPoints.get(index(i+1,j+1))
        ));
      }
    }
  }

  for (int i = 1; i < numberOfPoints; i+=2){
    for(int j = 0; j < numberOfPoints; j++){
      Point p = triangulationPoints.get(index(i,j));
      p.x += 0.5*sideLength;
    }
  }

  for (int i = 0; i < numberOfPoints; i++){
    for(int j = 0; j < numberOfPoints; j++){
      Point p = triangulationPoints.get(index(i,j));
      p.x += random(-0.3*sideLength,0.3*sideLength);
      p.y += random(-0.3*sideLength,0.3*sideLength);
    }
  }
  return triangulation;
}

int index(int i, int j){
  return j + i*numberOfPoints;
}

void makeDelaunayTriangulation(List<Triangle> triangulation){
  boolean areAllTrianglesDelaunay;
  boolean outerLoop;
  do{
    areAllTrianglesDelaunay = true;
    outerLoop = true;
    for (int i = 0; i < triangulation.size()-1 && outerLoop; i++){
      Triangle t1 = triangulation.get(i);
      for (int j = i+1; j < triangulation.size(); j++){
        Triangle t2 = triangulation.get(j);
        if (areSided(t1,t2) && !isDelaunayCondition(t1,t2)){
          areAllTrianglesDelaunay = false;
          makeFlip(t1, t2);
          outerLoop = false;
          break;
        }
      }
    }
  } while(!areAllTrianglesDelaunay);
}

boolean areSided(Triangle t1, Triangle t2){
  List<Point> points1 = t1.getPoints();
  List<Point> points2 = t2.getPoints();
  int equalPointsCount = 0;
  for(Point p1 : points1)
    for(Point p2 : points2)
      if (p1 == p2)
        equalPointsCount++;
  return equalPointsCount == 2;
}

boolean isDelaunayCondition(Triangle t1, Triangle t2){
  Point a = t1.a;
  Point b = t1.b;
  Point c = t1.c;
  List<Point> points = t2.getPoints();
  if (isAnyPointInsideCircle(points, a,b,c)){
    return false;
  }
  return true;
}

boolean isAnyPointInsideCircle(List<Point> points, Point p1, Point p2, Point p3){
  float A = p2.x - p1.x;
  float B = p2.y - p1.y;
  float C = p3.x - p1.x;
  float D = p3.y - p1.y;
  float E = A * (p1.x + p2.x) + B * (p1.y + p2.y);
  float F = C * (p1.x + p3.x) + D * (p1.y + p3.y);
  float G = 2 * (A * (p3.y - p2.y) - B * (p3.x - p2.x));
  if (G == 0){
    return false;
  }
  float cX = (D * E - B * F) / G;
  float cY = (A * F - C * E) / G;
  float r = magnitude(p1.x,p1.y,cX,cY);
  for(Point p : points){
    float mag = magnitude(cX,cY,p.x,p.y);
    if (mag < r*0.999)
      return true;
  }
  return false;
}

float magnitude(float x1, float y1, float x2, float y2){
  return sqrt( sq(x1-x2) + sq(y1-y2) );
}

void makeFlip(Triangle t1, Triangle t2){
  List<Point> points1 = t1.getPoints();
  List<Point> points2 = t2.getPoints();
  Point a = null;
  Point b = null;
  Point c = null;
  Point d = null;
  for(Point p1 : points1){
    for(Point p2 : points2){
      if (p1 == p2){
        if (b == null)
          b = p1;
        else
          c = p1;
      }
    }
  }
  for(Point p1 : points1){
    if (p1 != b && p1 != c){
      a = p1;
      break;
    }
  }
  for(Point p2 : points2){
    if (p2 != b && p2 != c){
      d = p2;
      break;
    }
  }
  t1.a = a;
  t1.b = b;
  t1.c = d;
  t2.a = a;
  t2.b = d;
  t2.c = c;
}

void renderTriangulation(List<Triangle> triangulation){
  noStroke();
  for(Triangle t : triangulation){
    fill(getRandomPaletteColor(palette1));
    triangle(
      t.a.x, t.a.y,
      t.b.x, t.b.y,
       t.c.x,t.c.y
    );
  }
}

void renderPoints(List<Point> points){
  stroke(blackColor);
  strokeWeight(15);
  for(Point p : points){
    point(p.x, p.y);
  }
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
