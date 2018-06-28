import processing.pdf.*;
import java.util.*;

float screenWidth;
float screenHeight;

color redColor = #F44336;
color yellowColor = #FFEB3B;
color indigoColor = #3F51B5;
color blackColor = #212121;
color whiteColor = #eeeeee;

int pointsNumber = 5;

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  testDraw();
  // mainDraw();
}

void mainDraw(){
  beginRecord(PDF, "Triangulation.pdf");
  endRecord();
}

Point[] getRandomSet(){
  Point[] set = new Point[pointsNumber];
  for (int i = 0; i < pointsNumber; i++){
    float x = random(0, width);
    float y = random(0, height);
    set[i] = new Point(x,y);
  }
  return set;
}

List<Triangle> generateTriangulation(Point[] points){
  List<Point> set = new ArrayList<Point>(Arrays.asList(points));
  List<Triangle> triangles = new ArrayList<Triangle>();
  List<Edge> frontier = new ArrayList<Edge>();
  Edge e = hullEdge(set);
  frontier.add(e);
  while(!frontier.isEmpty()){
    e = removeMinimalEdgeFromList(frontier);
    Point mateP = mate(e, set);
    if (mateP != null){
      updateFrontier(frontier, e.start, mateP);
      updateFrontier(frontier, mateP, e.end);
      triangles.add(new Triangle(e.start, mateP, e.end));
    }
  }
  return triangles;
}

Edge hullEdge(List<Point> set){
  int n = set.size();
  int m = 0;
  for (int i = 1; i < n; i++){
    if (set.get(i).compareTo(set.get(m)) < 0)
      m = i;
  }
  Collections.swap(set, 0, m);

  m = 1;
  for(int i = 2; i < n; i++){
    int side = set.get(i).getSide(set.get(0), set.get(m));
    if (side <= 0)
      m = i;
  }
  return new Edge(set.get(0), set.get(m));
}

Edge removeMinimalEdgeFromList(List<Edge> edges){
  Edge minEdge = edges.get(0);
  for (Edge e : edges){
    if (e.compareTo(minEdge) < 0)
      minEdge = e;
  }
  edges.remove(minEdge);
  return minEdge;
}

Point mate(Edge e, List<Point> set){
  Point bestPoint = null;
  float minDelta = Float.MAX_VALUE;
  float midPointX = (e.start.x + e.end.x)/2;
  float midPointY = (e.start.y + e.end.y)/2;
  Point e1RotParams = getRotParams(e);
  for (Point p : set){
    if (p.getSide(e.start, e.end) > 0){
      Edge e2 = new Edge(e.end, p);
      Point e2RotParams = getRotParams(e2);
      float cX = (e2RotParams.y-e1RotParams.y)/(e1RotParams.x-e2RotParams.x);
      float cY = e1RotParams.x * cX + e1RotParams.y;
      float delta = sqrt(sq(cY-midPointY) + sq(cX-midPointX));
      // ellipse(cX, cY, delta, delta);
      if (delta < minDelta){
        minDelta = delta;
        bestPoint = p;
      }
    }
  }
  return bestPoint;
}

Point getRotParams(Edge e){
  float midPointX = (e.start.x + e.end.x)/2;
  float midPointY = (e.start.y + e.end.y)/2;
  Point midPoint = new Point(midPointX, midPointY);
  float k = -1 / ( (e.end.y-e.start.y)/(e.end.x-e.start.x) );
  float b = midPointY - k*midPointX;
  return new Point(k, b);
}

void updateFrontier(List<Edge> frontier, Point p1, Point p2){
  Edge newEdge = new Edge(p1, p2);
  Edge inFrontierEdge = findEdgeInFrontier(newEdge, frontier);
  if(inFrontierEdge != null)
    frontier.remove(inFrontierEdge);
  else {
    // flip?
    frontier.add(newEdge);
  }
}

Edge findEdgeInFrontier(Edge edge, List<Edge> frontier){
  for (Edge e : frontier){
    if(
      edge.start.equals(e.start) && edge.end.equals(e.end)
      ||
      edge.start.equals(e.end) && edge.end.equals(e.start)
    )
    return e;
  }
  return null;
}

void testDraw(){
  background(whiteColor);
  Point[] set = getRandomSet();
  List<Triangle> triangulation = generateTriangulation(set);
  renderTriangulation(triangulation);
  renderPoints(set);
}

void renderTriangulation(List<Triangle> triangulation){
  stroke(blackColor);
  strokeWeight(3);
  for(Triangle t : triangulation){
    triangle(
      t.a.x, t.a.y,
      t.b.x, t.b.y,
       t.c.x,t.c.y
    );
  }
}

void renderPoints(Point[] set){
  stroke(blackColor);
  strokeWeight(15);
  for(Point p : set){
    point(p.x, p.y);
  }
}

void mouseClicked() {
  redraw();
}
