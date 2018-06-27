import processing.pdf.*;
import java.util.Collections;

float screenWidth = 1280;
float screenHeight = 720;
float squareSize = 0.8*screenWidth / (53.0 + 52.0*4.0/22.0);
float gap = 4.0/22.0*squareSize;

color[] palette = {
  #eeeeee
  ,#d6e685
  ,#8cc665
  ,#44a340
  ,#1e6823
};

void setup(){
  size(1280,720);
  noLoop();
}

void draw(){
  beginRecord(PDF, "GithubCommits.pdf");
  // generateStrokesOrder();
  background(#eeeeee);
  noStroke();
  renderSquares();
  endRecord();
}

void renderSquares(){
  float yOffset = screenHeight/2.0 - (7*squareSize + 6*gap)/2.0;
  for (int i = 0; i < 365; i++){
    fill(palette[floor(random(palette.length))]);
    if (i == 364)
      fill(palette[3]);
    rect(
      0.1*screenWidth + i/7 * (squareSize + gap),
      yOffset + i%7 * (squareSize + gap),
      squareSize,
      squareSize
    );
  }
}

void mouseClicked() {
  redraw();
}
