import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;
color redWineColor = #cc0000;
color whiteWineColor = #d4ab39;
color wineColor = redWineColor;

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
  float glassRadius = 0.4*width;
  float fullness = 0.8;
  float liquidHeight = fullness * (glassRadius + glassRadius*sin(PI/4));
  List<Cube> cubes = generateIceCubes(glassRadius, liquidHeight, 7);
  List<Bubble> bubbles = generateBubbles(glassRadius, liquidHeight, 100);

  // translate(0.5*width,0.5*height - 2.0/3.0*0.4*width);
  translate(0.5*width,0.5*height);
  background(whiteColor);
  renderWine(glassRadius, liquidHeight);
  renderIceCubes(cubes);
  renderBubbles(bubbles);
  renderGlass(glassRadius, liquidHeight);
  popMatrix();
}

void renderGlass(float glassRadius, float liquidHeight){
  stroke(blackColor);
  strokeWeight(10);
  noFill();
  arc(0, 0, 2*glassRadius, 2*glassRadius, -PI/4, 5*PI/4);
}

void renderWine(float glassRadius, float liquidHeight){
  float liquidAlpha = asin((liquidHeight-glassRadius)/glassRadius);
  noStroke();
  fill(wineColor);
  arc(0, 0, 2*glassRadius, 2*glassRadius, -liquidAlpha, PI+liquidAlpha, OPEN);
}

List<Cube> generateIceCubes(float glassRadius, float liquidHeight, int n){
  List<Cube> cubes = new ArrayList<Cube>();
  for(int i = 0; i < n; i++){
    float alpha;
    float side;
    float x;
    float y;
    boolean isCubeInsideGlass;
    do {
      isCubeInsideGlass = true;
      alpha = random(HALF_PI);
      side = random(0.1*glassRadius, 0.2*glassRadius);
      x = random(-glassRadius, glassRadius);
      // y = random(glassRadius-liquidHeight, glassRadius);
      float liquidLevel = glassRadius-liquidHeight;
      // y = iceCenter(liquidLevel, alpha, side);
      y = liquidLevel;

      float r = sqrt(2)*side;
      float[] xCoordinates = new float[4];
      float[] yCoordinates = new float[4];
      for(int j = 0; j < 4; j++){
        xCoordinates[j] = x + r*cos(alpha + QUARTER_PI + j*HALF_PI);
        yCoordinates[j] = y + r*sin(alpha + QUARTER_PI + j*HALF_PI);
      isCubeInsideGlass &= isPointInsideGlass(xCoordinates[j], yCoordinates[j], glassRadius);
      }
    } while (!isCubeInsideGlass);
    cubes.add(new Cube(x, y, alpha, side));
  }
  return cubes;
}

// float iceCenter(float liquidLevel, float alpha, float side){
//   float iceDensity = 0.9;
// }

boolean isPointInsideGlass(float x, float y, float glassRadius){
  return (new PVector(x,y)).mag() <= glassRadius;
}

List<Bubble> generateBubbles(float glassRadius, float liquidHeight, int n){
  List<Bubble> bubbles = new ArrayList<Bubble>();
  for(int i = 0; i < n; i++){
    float diameter;
    float x;
    float y;
    boolean isBubbleInsideGlass;
    do {
      diameter = random(0, 0.05*glassRadius);
      x = random(-glassRadius, glassRadius);
      y = random(glassRadius-liquidHeight, glassRadius);
      isBubbleInsideGlass = isEllipseInsideGlass(x,y,diameter,glassRadius);
    } while (!isBubbleInsideGlass);
    bubbles.add(new Bubble(x, y, diameter));
  }
  return bubbles;
}

boolean isEllipseInsideGlass(float x, float y, float diameter, float glassRadius){
  return (new PVector(x,y)).mag() + diameter/2 <= glassRadius;
}

void renderIceCubes(List<Cube> cubes){
  rectMode(CENTER);
  noStroke();
  // fill(color(#a3d0e8), 0.9*255);
  for(Cube c : cubes){
    float alpha = random(0.4*255, 0.8*255);
    fill(color(#ffffff), alpha);
    pushMatrix();
    translate(c.x, c.y);
    rotate(c.alpha);
    rect(0, 0, c.side, c.side);
    popMatrix();
  }
}

void renderBubbles(List<Bubble> bubbles){
  noStroke();
  for(Bubble b : bubbles){
    float alpha = random(0.4*255, 0.8*255);
    fill(color(#ffffff), alpha);
    pushMatrix();
    translate(b.x, b.y);
    ellipse(0, 0, b.diameter, b.diameter);
    popMatrix();
  }
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  redraw();
}
