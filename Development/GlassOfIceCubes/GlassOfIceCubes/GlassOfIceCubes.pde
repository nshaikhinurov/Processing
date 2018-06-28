import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

color[] bestPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

color[] turbulentWaters = {
  #00a6fb
  ,#0582ca
  ,#006494
};

color[] palette = bestPalette;

void setup(){
  size(1000, 1000);
  noLoop();
}

void draw(){
  // beginRecord(PDF, "../GlassOfIceCubes.pdf");
  mainDraw();
  // endRecord();
}

void mainDraw(){
  pushMatrix();
  // translate(0.5*width,0.5*height - 2.0/3.0*0.4*width);
  translate(0.5*width,0.5*height);
  background(whiteColor);
  float glassRadius = 0.4*width;
  float fullness = 0.8;
  float liquidHeight = fullness * (glassRadius + glassRadius*sin(PI/4));
  renderGlass(glassRadius, liquidHeight);
  List<Cube> cubes = generateIceCubes(glassRadius, liquidHeight);
  renderIceCubes(cubes);
  popMatrix();
}

void renderGlass(float glassRadius, float liquidHeight){
  float liquidAlpha = asin((liquidHeight-glassRadius)/glassRadius);
  noStroke();
  fill(color(#cc0000));
  arc(0, 0, 2*glassRadius, 2*glassRadius, -liquidAlpha, PI+liquidAlpha, OPEN);

  stroke(blackColor);
  strokeWeight(10);
  noFill();
  arc(0, 0, 2*glassRadius, 2*glassRadius, -PI/4, 5*PI/4);
}

List<Cube> generateIceCubes(float glassRadius, float liquidHeight){
  List<Cube> cubes = new ArrayList<Cube>();
  int n = 7;
  for(int i = 0; i < n; i++){
    float alpha;
    float side;
    float x;
    float y;
    boolean isOk;
    do {
      isOk = true;
      alpha = random(HALF_PI);
      side = random(0.1*glassRadius, 0.2*glassRadius);
      x = random(-glassRadius, glassRadius);
      y = random(glassRadius-liquidHeight, glassRadius);
      // y = glassRadius-liquidHeight;

      float r = sqrt(2)*side;
      float[] xCoordinates = new float[4];
      float[] yCoordinates = new float[4];
      for(int j = 0; j < 4; j++){
        xCoordinates[j] = x + r*cos(alpha + QUARTER_PI + j*HALF_PI);
        yCoordinates[j] = y + r*sin(alpha + QUARTER_PI + j*HALF_PI);
        isOk &= isInsideGlass(xCoordinates[j], yCoordinates[j], glassRadius);
      }
    } while (!isOk);
    cubes.add(new Cube(x, y, alpha, side));
  }
  return cubes;
}

boolean isInsideGlass(float x, float y, float glassRadius){
  return (new PVector(x,y)).mag() <= glassRadius;
}

void renderIceCubes(List<Cube> cubes){
  rectMode(CENTER);
  noStroke();
  fill(color(#a3d0e8), 0.9*255);
  for(Cube c : cubes){
    pushMatrix();
    translate(c.x, c.y);
    rotate(c.alpha);
    rect(0, 0, c.side, c.side);
    popMatrix();
  }
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
