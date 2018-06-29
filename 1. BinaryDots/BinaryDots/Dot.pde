public class Dot{
  private float outerRadius;
  private float innerRadius;
  private float alpha;
  public int row;
  public int col;

  public Dot(int row, int col){
    // this.outerRadius = random(Config.maxRadius) * floor(random(6))/5.0;
    this.outerRadius = random(Config.maxRadius);
    // this.innerRadius = floor(random(5))/5.0 * outerRadius;
    this.innerRadius = random(1) * outerRadius;
    // this.alpha = 256 * (1+floor(random(3)))/3.0;
    this.alpha = generateAlpha();
    this.row = row;
    this.col = col;
  }

  private float generateAlpha(){
    if (isTooSmall() || isTooThin())
      return 0;

    if (random(1) > 0.75)
      return 0;

    if (isThick())
      return 256;
    return 256 * ceil(random(3))/3.0;
  }

  private boolean isThick(){
    return innerRadius < 0.8 * outerRadius;
  }

  private boolean isTooThin(){
    return innerRadius > 0.95 * outerRadius;
  }

  private boolean isTooSmall(){
    return outerRadius + innerRadius < 0.2 * Config.gap; //Config.maxRadius = 0.98*Config.gap/2.0;
  }

  public boolean isVisible(){
    return alpha > 0;
  }
}
