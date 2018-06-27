import processing.pdf.*;
import java.util.*;

float screenWidth;
float screenHeight;

color blackColor = #212121;
color whiteColor = #eeeeee;

color[] bestPalette = {
  #3d348b
  ,#7678ed
  ,#f7b801
  ,#f18701
  ,#ff4f00
};

color[] palette = bestPalette;

float inc = 0.07;
int n = 9;
float cellSize;

void setup(){
  size(1000, 1000);
  screenWidth = width;
  screenHeight = height;
  cellSize = 0.8*width/n;
  noiseDetail(100);
  noLoop();
}

void draw(){
  beginRecord(PDF, "PaperPlanes.pdf");
  translate(0.1*width + 0.5*cellSize, 0.1*height + 0.5*cellSize);
  pushMatrix();
  mainDraw();
  popMatrix();
  endRecord();
}

void mainDraw(){
  background(whiteColor);
  stroke(blackColor);
  noFill();

  float randomiser = random(1000);
  float yOff = randomiser;
  for (int row = 0; row < n; row ++){
    float xOff = randomiser;
    for (int col = 0; col < n; col++){
      float x = col*cellSize;
      float y = row*cellSize;
      float angle = noise(xOff, yOff) * TWO_PI;
      drawShape(x, y, angle);
      xOff += inc;
    }
    yOff += inc;
  }
}

void drawShape(float x, float y, float angle){
  popMatrix();
  pushMatrix();
  float miniCellSize = cellSize/4 * 1.25;
  translate(x, y);
  rotate(angle);
  fill(getRandomPaletteColor());
  noStroke();
  quad(
    0,-miniCellSize,
    miniCellSize, miniCellSize,
    0, 0.5*miniCellSize,
    -miniCellSize, miniCellSize
  );
}

color getRandomPaletteColor(){
  return palette[floor(random(palette.length))];
}

color getAngledPaletteColor(float angle){
  float scale = map(angle, 0, TWO_PI, 0, palette.length);
  return palette[floor(scale)];
}

void mouseClicked() {
  redraw();
}
