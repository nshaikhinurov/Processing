public class Point implements Comparable<Point>{
  public float x;
  public float y;

  public Point(float x,float y){
    this.x = x;
    this.y = y;
  }

  public int getSide(Point start, Point end){
    float lineY = map(this.x, start.x, end.x, start.y, end.y);
    if (this.y < lineY)
      return -1;
    if (this.y > lineY)
      return 1;
    return 0;
  }

  @Override
  public String toString(){
    return "(" + x + ", " + y + ")";
  }

  @Override
  public int compareTo(Point p){
    if (this.x < p.x)
      return -1;
    if (this.x > p.x)
      return 1;
    if (this.y < p.y)
      return -1;
    if (this.y > p.y)
      return 1;
    return 0;
  }
}
