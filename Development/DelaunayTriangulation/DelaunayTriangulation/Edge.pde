public class Edge implements Comparable<Edge>{
  public Point start;
  public Point end;
  public int status;

  public Edge(Point start, Point end){
    this.start = start;
    this.end = end;
    this.status = 0;
  }

  @Override
  public int compareTo(Edge e){
    int i = this.start.compareTo(e.start);
    if (i == 0)
      return this.end.compareTo(e.end);
    else
      return i;
  }
}
