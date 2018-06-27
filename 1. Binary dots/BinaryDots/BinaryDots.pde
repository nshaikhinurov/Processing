import processing.pdf.*;

Dot[] dots;

void setup(){
  size(750, 750);
  Config.gap = 750.0 / (Config.N + 6);
  Config.maxRadius = 0.98*Config.gap/2.0;
  generateDots();
  noLoop();
}

void draw(){
  beginRecord(PDF, "../BinaryDots.pdf");
  background(#ffffff);
  renderDots();
  endRecord();
}

void generateDots(){
  dots = new Dot[Config.N*Config.N];
  for (int i = 0; i < Config.N*Config.N; i++){
    dots[i] = new Dot(i/Config.N, i%Config.N);
  }
};

void renderDots(){
  noFill();
  for(Dot dot : dots)
      renderDot(dot);
}

void renderDot(Dot dot){
  stroke(16.0, dot.alpha);
  strokeWeight(dot.outerRadius - dot.innerRadius);
  float diameter = dot.outerRadius + dot.innerRadius;
  ellipse((dot.col + 3.5) * Config.gap,
          (dot.row + 3.5) * Config.gap,
          diameter,
          diameter
  );
}
