import processing.pdf.*;
import java.util.*;

color blackColor = #212121;
color whiteColor = #eeeeee;

int numberOfParticles = 100;
List<Particle> particles;
float slowMotion = 0.1;
PVector acceleration = new PVector(0, 0.25);

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
  if (particles == null)
    initParticles();
  for (Particle particle : particles){
    particle.velocity.add(PVector.mult(acceleration,slowMotion));
    particle.position.add(PVector.mult(particle.velocity,slowMotion));
    particle.render();
  }
}

void initParticles(){
  particles = new ArrayList<Particle>();
  float maxSpeed = 5;
  for (int i = 0; i < numberOfParticles; i++){
    float x = 0.4*width;
    float y = 0;
    float alpha = -4*PI/3 + random(TWO_PI-PI/3);
    // float alpha = random(-2*PI/3, -PI/3);
    // float alpha = -PI/3;
    PVector position = new PVector(x,y);
    // PVector velocity = new PVector(random(-speed*slowMotion, speed*slowMotion),random(-speed*slowMotion, speed*slowMotion));
    float speed = random(maxSpeed);
    PVector velocity = new PVector(speed*cos(alpha),speed*sin(alpha));
    Particle particle = new Particle(position, velocity);
    particles.add(particle);
  }
}

void testDraw(){
  background(whiteColor);
}

color getRandomPaletteColor(color[] palette){
  return palette[floor(random(palette.length))];
}

void mouseClicked() {
  reset();
}

void reset(){
  particles = null;
}
