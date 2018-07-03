import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

int numberOfDrops = 100;
List<Drop> drops;
float slowMotion = 0.01;
PVector acceleration = new PVector(0, slowMotion);

void setup(){
  size(1000, 1000);
  // frameRate(5);
  // noLoop();
}

void draw(){
  // beginRecord(PDF, "../Rain.pdf");
  translate(0.1*width,0.1*height);
  mainDraw();
  // endRecord();
}

void mainDraw(){
  background(whiteColor);
  if (drops == null)
    initDrops();
  for (Drop drop : drops){
    drop.velocity.add(acceleration);
    drop.position.add(drop.velocity);
    drop.render();
  }
}

void initDrops(){
  drops = new ArrayList<Drop>();
  float speed = 1/slowMotion;
  for (int i = 0; i < numberOfDrops; i++){
    float x = 0.4*width;
    float y = 0;
    float alpha = random(TWO_PI);
    PVector position = new PVector(x,y);
    // PVector velocity = new PVector(random(-speed*slowMotion, speed*slowMotion),random(-speed*slowMotion, speed*slowMotion));
    PVector velocity = new PVector(random(speed*slowMotion)*cos(alpha),random(speed*slowMotion)*sin(alpha));
    Drop drop = new Drop(position, velocity);
    drops.add(drop);
  }
}

void testDraw(){
  background(whiteColor);
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

color getColorWithAlpha(color c, float a){
  float r = c >> 16 & 0xFF;
  float g = c >> 8 & 0xFF;
  float b = c & 0xFF;
  return color(r,g,b,a);
}

void mouseClicked() {
  redraw();
}
