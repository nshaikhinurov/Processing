public class Particle{
  public float x;
  public float y;
  public PVector position;
  public PVector velocity;

  public Particle(PVector position, PVector velocity){
    this.position = position;
    this.velocity = velocity;
  }

  public void render(){
    PVector start = PVector.sub(position, PVector.div(velocity,2));
    PVector end = PVector.add(position, PVector.div(velocity,2));
    float x1 = start.x;
    float y1 = start.y;
    float x2 = end.x;
    float y2 = end.y;
    stroke(blackColor);
    strokeWeight(3);
    line(x1,y1,x2,y2);
  }
}
