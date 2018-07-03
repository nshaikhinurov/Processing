public class Triangle{
  public Point a;
  public Point b;
  public Point c;

  public Triangle(Point a, Point b, Point c){
    this.a = a;
    this.b = b;
    this.c = c;
  }

  public List<Point> getPoints(){
    List<Point> points = new ArrayList<Point>();
    points.add(a);
    points.add(b);
    points.add(c);
    return points;
  }

  @Override
  String toString(){
    return "{"+ a.toString() +","+ b.toString() +","+ c.toString() +"}";
  }
}
