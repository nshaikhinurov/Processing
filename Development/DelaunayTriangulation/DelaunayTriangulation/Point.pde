public class Point{
  public float x;
  public float y;

  public Point(float x,float y){
    this.x = x;
    this.y = y;
  }

  @Override
  String toString(){
    return "("+ x +","+ y +")";
  }
}
